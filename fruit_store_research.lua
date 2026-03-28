-- ════════════════════════════════════════════════════
--  Fruit Store Research v4
--  Tanpa goto, semua pcall, CoreGui
-- ════════════════════════════════════════════════════
print("[FSR4] start")

-- Services
local lp
pcall(function() lp = game:GetService("Players").LocalPlayer end)
if not lp then print("[FSR4] ERROR: no localplayer"); return end

local VIM
pcall(function() VIM = game:GetService("VirtualInputManager") end)
print("[FSR4] lp="..lp.Name.." VIM="..(VIM and "ok" or "nil"))

-- GUI parent
local guiPar
pcall(function() guiPar = game:GetService("CoreGui") end)
if not guiPar then pcall(function() guiPar = lp.PlayerGui end) end
if not guiPar then print("[FSR4] ERROR: no gui parent"); return end

-- Cleanup
pcall(function()
    for _, v in ipairs(guiPar:GetChildren()) do
        if v.Name == "FSR4" then v:Destroy() end
    end
end)

-- ScreenGui
local sg = Instance.new("ScreenGui")
sg.Name = "FSR4"
sg.ResetOnSpawn = false
sg.DisplayOrder = 9999
pcall(function() sg.Parent = guiPar end)
print("[FSR4] sg.Parent="..(sg.Parent and sg.Parent.Name or "nil"))

-- Main frame — hanya setengah layar bagian atas
-- sisa bawah bebas untuk Delta menu
local fr = Instance.new("Frame")
fr.Size     = UDim2.new(0.96, 0, 0.52, 0)   -- 52% tinggi layar
fr.Position = UDim2.new(0.02, 0, 0.01, 0)   -- mulai dari atas
fr.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
fr.BorderSizePixel  = 0
fr.ZIndex   = 5
fr.Parent   = sg
Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 5)

-- Header bar (tinggi lebih besar agar mudah di-tap)
local hb = Instance.new("Frame")
hb.Size             = UDim2.new(1, 0, 0, 44)
hb.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
hb.BorderSizePixel  = 0
hb.ZIndex           = 6
hb.Parent           = fr

local htl = Instance.new("TextLabel")
htl.Size            = UDim2.new(0.60, 0, 1, 0)
htl.Position        = UDim2.new(0, 6, 0, 0)
htl.BackgroundTransparency = 1
htl.Text            = "FRUIT RESEARCH v4"
htl.TextColor3      = Color3.fromRGB(0, 210, 255)
htl.TextSize        = 13
htl.Font            = Enum.Font.GothamBold
htl.TextXAlignment  = Enum.TextXAlignment.Left
htl.ZIndex          = 7
htl.Parent          = hb

-- Tombol MIN — sembunyikan/tampilkan scroll (toggle)
local minBtn = Instance.new("TextButton")
minBtn.Size             = UDim2.new(0, 60, 0, 36)
minBtn.Position         = UDim2.new(1, -130, 0, 4)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 60, 100)
minBtn.BorderSizePixel  = 0
minBtn.Text             = "MIN"
minBtn.TextColor3       = Color3.fromRGB(200, 220, 255)
minBtn.TextSize         = 13
minBtn.Font             = Enum.Font.GothamBold
minBtn.ZIndex           = 7
minBtn.Parent           = hb

-- Tombol CLOSE — besar, mudah di-tap di mobile
local xb = Instance.new("TextButton")
xb.Size             = UDim2.new(0, 60, 0, 36)
xb.Position         = UDim2.new(1, -64, 0, 4)
xb.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
xb.BorderSizePixel  = 0
xb.Text             = "CLOSE"
xb.TextColor3       = Color3.fromRGB(255, 255, 255)
xb.TextSize         = 13
xb.Font             = Enum.Font.GothamBold
xb.ZIndex           = 7
xb.Parent           = hb
xb.MouseButton1Click:Connect(function() sg:Destroy() end)

-- Toggle scroll visibility saat MIN ditekan
local scrollVisible = true
minBtn.MouseButton1Click:Connect(function()
    scrollVisible = not scrollVisible
    sc.Visible    = scrollVisible
    if scrollVisible then
        fr.Size   = UDim2.new(0.96, 0, 0.52, 0)
        minBtn.Text = "MIN"
    else
        fr.Size   = UDim2.new(0.96, 0, 0, 46)
        minBtn.Text = "MAX"
    end
end)

-- Scroll
local sc = Instance.new("ScrollingFrame")
sc.Size = UDim2.new(1, 0, 1, -46)
sc.Position = UDim2.new(0, 0, 0, 46)
sc.BackgroundTransparency = 1
sc.ScrollBarThickness = 7
sc.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 110)
sc.CanvasSize = UDim2.new(0, 0, 0, 500)
sc.ZIndex = 6
sc.Parent = fr

local ll = Instance.new("UIListLayout")
ll.SortOrder = Enum.SortOrder.LayoutOrder
ll.Parent = sc
Instance.new("UIPadding", sc).PaddingLeft = UDim.new(0, 3)

local n = 0
local LINE_H = 18

local function L(t, c)
    n = n + 1
    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(1, -6, 0, LINE_H)
    lb.BackgroundColor3 = Color3.fromRGB(30, 30, 44)
    lb.BackgroundTransparency = (n%2==0) and 0.82 or 1
    lb.Text = tostring(t)
    lb.TextColor3 = c or Color3.fromRGB(192, 192, 208)
    lb.TextSize = 12
    lb.Font = Enum.Font.RobotoMono
    lb.TextXAlignment = Enum.TextXAlignment.Left
    lb.TextWrapped = true
    lb.ClipsDescendants = false
    lb.LayoutOrder = n
    lb.ZIndex = 7
    lb.Parent = sc
    -- Update canvas manual setiap baris (tidak pakai signal)
    local h = n * LINE_H + 40
    sc.CanvasSize = UDim2.new(0, 0, 0, h)
    pcall(function() sc.CanvasPosition = Vector2.new(0, h) end)
    print("[FSR4] "..tostring(t))
end

local K = {
    H = Color3.fromRGB(0,210,255),
    G = Color3.fromRGB(55,210,90),
    W = Color3.fromRGB(255,200,0),
    R = Color3.fromRGB(255,70,70),
    P = Color3.fromRGB(180,105,255),
    D = Color3.fromRGB(105,105,125),
}

local function SH(t) L("") ; L("=== "..t, K.H) end
local function OK(t) L(" [OK] "..t, K.G) end
local function WN(t) L(" [!] "..t, K.W) end
local function ER(t) L(" [X] "..t, K.R) end
local function IN(t) L("  "..t) end
local function DT(t) L("    "..t, K.D) end
local function HI(t) L(" >>> "..t, K.P) end

L("GUI OK — geser isi ke bawah untuk lihat hasil", K.G)
L("Tombol MIN = perkecil panel | CLOSE = tutup", K.D)

-- Remote spy
local captured = {}
local spying = false
local hookOk = false

pcall(function()
    if not hookmetamethod then return end
    if not getnamecallmethod then return end
    local old = hookmetamethod(game, "__namecall", function(self, ...)
        if spying then
            local m = getnamecallmethod()
            if m == "FireServer" or m == "InvokeServer" then
                local ok2, cls = pcall(function() return self.ClassName end)
                if ok2 and (cls=="RemoteEvent" or cls=="RemoteFunction") then
                    local args = {...}
                    local astr = ""
                    pcall(function()
                        for i,a in ipairs(args) do
                            astr = astr..tostring(a)
                            if i<#args then astr=astr.."," end
                        end
                    end)
                    local pth = ""
                    pcall(function()
                        local parts,cur = {},self
                        while cur and cur~=game do
                            table.insert(parts,1,cur.Name); cur=cur.Parent
                        end
                        pth = table.concat(parts,".")
                    end)
                    table.insert(captured, {cls=cls, name=self.Name, path=pth, args=astr})
                end
            end
        end
        return old(self, ...)
    end)
    hookOk = true
end)

-- ════════════════════════════════════════════════════
task.spawn(function()
    task.wait(0.3)

    -- ── Scan popup + klik Collect
    local function doPopupScan(eatGui)
        SH("SCAN EatFruitBecky")
        OK("Popup ditemukan!")
        pcall(function() IN("Enabled="..tostring(eatGui.Enabled)) end)

        local allBtns = {}
        for _, obj in ipairs(eatGui:GetDescendants()) do
            local depth,cur = 0,obj
            while cur and cur~=eatGui do depth=depth+1; cur=cur.Parent end
            local ind = string.rep("  ", depth)
            local d = obj.ClassName
            pcall(function()
                if obj:IsA("GuiObject") then
                    d = d.." V="..tostring(obj.Visible)
                end
            end)
            pcall(function()
                if obj:IsA("TextButton") or obj:IsA("TextLabel") then
                    d = d..' T="'..tostring(obj.Text):sub(1,35)..'"'
                end
            end)
            local isBtn = obj:IsA("TextButton") or obj:IsA("ImageButton")
            L(ind..obj.Name.." ["..d.."]", isBtn and K.W or K.D)
            if isBtn then
                table.insert(allBtns, obj)
                local txt = ""
                pcall(function() if obj:IsA("TextButton") then txt=obj.Text end end)
                if txt=="Collect" or obj.Name=="Collect" then HI("TOMBOL COLLECT DITEMUKAN!") end
                pcall(function()
                    local ap=obj.AbsolutePosition; local as=obj.AbsoluteSize
                    DT(("Pos=(%d,%d) Sz=%dx%d"):format(ap.X,ap.Y,as.X,as.Y))
                end)
                pcall(function()
                    local cc=getconnections(obj.MouseButton1Click)
                    if cc then DT("conn="..#cc) end
                end)
            end
        end

        IN("Total tombol: "..#allBtns)

        -- Cari Collect
        local cb = nil
        for _, btn in ipairs(allBtns) do
            local txt=""
            pcall(function() if btn:IsA("TextButton") then txt=btn.Text end end)
            if txt=="Collect" or btn.Name=="Collect" then cb=btn; break end
        end

        if not cb then
            ER("Tombol Collect TIDAK ada di antara "..#allBtns.." tombol")
            IN("Nama-nama tombol yang ada:")
            for _,btn in ipairs(allBtns) do
                local t2,n2="",""
                pcall(function() if btn:IsA("TextButton") then t2=btn.Text end end)
                pcall(function() n2=btn.Name end)
                DT("name='"..n2.."' txt='"..t2.."'")
            end
            return
        end

        OK("Collect button: "..cb.Name)
        captured = {}
        spying = true
        local anySuccess = false

        -- A: firesignal
        IN("--- Metode A: firesignal ---")
        captured = {}
        local okA = false
        pcall(function()
            if firesignal then
                firesignal(cb.MouseButton1Click)
                okA = true
                OK("  firesignal dipanggil")
            end
        end)
        if not okA then WN("  firesignal tidak ada") end
        task.wait(1.8)
        if #captured>0 then
            anySuccess = true
            OK("A BERHASIL — "..#captured.." remote(s):")
            for _,c in ipairs(captured) do
                HI(c.cls.." '"..c.name.."' args=("..c.args..")")
                DT(c.path)
            end
        else
            WN("A: 0 remote")
        end

        -- B: Fire()
        if not anySuccess then
            IN("--- Metode B: MouseButton1Click:Fire() ---")
            captured = {}
            pcall(function()
                cb.MouseButton1Click:Fire()
                OK("  Fire() dipanggil")
            end)
            task.wait(1.8)
            if #captured>0 then
                anySuccess = true
                OK("B BERHASIL — "..#captured.." remote(s):")
                for _,c in ipairs(captured) do
                    HI(c.cls.." '"..c.name.."' ("..c.args..")")
                    DT(c.path)
                end
            else WN("B: 0 remote") end
        end

        -- C: VIM mouse
        if not anySuccess then
            IN("--- Metode C: VIM mouse klik ---")
            captured = {}
            pcall(function()
                if not VIM then error("VIM nil") end
                local ap=cb.AbsolutePosition; local as=cb.AbsoluteSize
                local bx=ap.X+as.X/2; local by=ap.Y+as.Y/2
                IN("  klik ("..math.floor(bx)..","..math.floor(by)..")")
                VIM:SendMouseButtonEvent(bx,by,0,true,game,1)
                task.wait(0.06)
                VIM:SendMouseButtonEvent(bx,by,0,false,game,1)
                OK("  VIM mouse sent")
            end)
            task.wait(1.8)
            if #captured>0 then
                anySuccess = true
                OK("C BERHASIL — "..#captured.." remote(s):")
                for _,c in ipairs(captured) do HI(c.cls.." '"..c.name.."' ("..c.args..")"); DT(c.path) end
            else WN("C: 0 remote") end
        end

        -- D: VIM touch
        if not anySuccess then
            IN("--- Metode D: VIM touch ---")
            captured = {}
            pcall(function()
                if not VIM then error("VIM nil") end
                local ap=cb.AbsolutePosition; local as=cb.AbsoluteSize
                local bx=ap.X+as.X/2; local by=ap.Y+as.Y/2
                VIM:SendTouchEvent("1",0,bx,by,game)
                task.wait(0.08)
                VIM:SendTouchEvent("1",1,bx,by,game)
                task.wait(0.08)
                VIM:SendTouchEvent("1",2,bx,by,game)
                OK("  VIM touch sent")
            end)
            task.wait(1.8)
            if #captured>0 then
                anySuccess = true
                OK("D BERHASIL — "..#captured.." remote(s):")
                for _,c in ipairs(captured) do HI(c.cls.." '"..c.name.."' ("..c.args..")"); DT(c.path) end
            else WN("D: 0 remote") end
        end

        -- E: getconnections
        if not anySuccess then
            IN("--- Metode E: getconnections:Fire() ---")
            captured = {}
            pcall(function()
                local cc = getconnections(cb.MouseButton1Click)
                if not cc then error("getconnections nil") end
                IN("  "..#cc.." connection(s)")
                for i,c2 in ipairs(cc) do
                    pcall(function() c2:Fire(); OK("  conn#"..i.." fired") end)
                end
            end)
            task.wait(1.8)
            if #captured>0 then
                anySuccess = true
                OK("E BERHASIL — "..#captured.." remote(s):")
                for _,c in ipairs(captured) do HI(c.cls.." '"..c.name.."' ("..c.args..")"); DT(c.path) end
            else WN("E: 0 remote") end
        end

        spying = false
        if not anySuccess then
            ER("SEMUA METODE GAGAL tangkap remote")
            IN("Mungkin: Collect bukan RemoteEvent, atau hook tidak berfungsi")
        end
    end

    -- ── Cari popup
    local function findEatGui()
        return lp.PlayerGui:FindFirstChild("EatFruitBecky")
    end

    -- ── Phase 1
    SH("PHASE 1: CEK BUAH DI BACKPACK")
    if hookOk then OK("Hook spy aktif") else WN("Hook spy tidak tersedia") end

    local bp = lp:FindFirstChild("Backpack")
    local char = lp.Character
    local fruits = {}

    local function scanTools(cont, loc)
        if not cont then return end
        for _,t in ipairs(cont:GetChildren()) do
            if t:IsA("Tool") then
                local isFruit = t.Name:find("Fruit") ~= nil
                DT(loc..": "..t.Name..(isFruit and " [BUAH]" or ""))
                if isFruit then table.insert(fruits,t) end
            end
        end
    end
    scanTools(bp,   "Backpack")
    scanTools(char, "Character")

    if #fruits == 0 then
        L("") 
        L("============================", K.R)
        L("  TIDAK ADA BUAH DI BACKPACK", K.R)
        L("============================", K.R)
        L("  1. Keluar dulu dari menu ini (tap CLOSE)", K.W)
        L("  2. Ambil buah dari ground/chest dulu", K.W)
        L("  3. Execute script ini lagi", K.W)
        L("") 
        L("  ATAU: buka popup buah manual dulu", K.W)
        L("  (klik slot buah → klik layar)", K.W)
        L("  lalu langsung execute script ini", K.W)
        L("============================", K.R)
        htl.Text = "SELESAI — tidak ada buah!"
        return
    end
    local tgt = fruits[1]
    OK("Target buah: "..tgt.Name)

    -- ── Phase 2: cek apakah popup sudah terbuka
    SH("PHASE 2: CEK POPUP SEBELUM EQUIP")
    local eatGui = findEatGui()
    if eatGui then
        OK("EatFruitBecky SUDAH TERBUKA! Langsung scan.")
        doPopupScan(eatGui)
    else
        IN("Popup belum ada, akan equip + trigger")

        -- ── Phase 3: equip
        SH("PHASE 3: EQUIP BUAH")
        local hum
        pcall(function()
            local c = lp.Character
            hum = c and c:FindFirstChildOfClass("Humanoid")
        end)
        if hum then
            pcall(function() hum:EquipTool(tgt) end)
            OK("EquipTool("..tgt.Name..")")
        else
            ER("Tidak ada Humanoid")
        end
        task.wait(0.8)

        -- ── Phase 4: trigger popup 5 cara
        SH("PHASE 4: TRIGGER POPUP (5 cara)")

        local vp = workspace.CurrentCamera.ViewportSize
        local cx,cy = vp.X/2, vp.Y/2
        IN("Screen center=("..math.floor(cx)..","..math.floor(cy)..")")

        local function checkPopup()
            eatGui = findEatGui()
            return eatGui ~= nil
        end

        local popupFound = false

        -- Cara 1: VIM mouse
        if not popupFound then
            IN("Cara 1: VIM mouse klik tengah layar")
            pcall(function()
                if not VIM then error("VIM=nil") end
                VIM:SendMouseButtonEvent(cx,cy,0,true,game,1)
                task.wait(0.06)
                VIM:SendMouseButtonEvent(cx,cy,0,false,game,1)
                OK("  sent")
            end)
            task.wait(1.5)
            if checkPopup() then OK("Cara 1 BERHASIL!"); popupFound=true
            else WN("Cara 1 gagal") end
        end

        -- Cara 2: VIM touch
        if not popupFound then
            IN("Cara 2: VIM touch tengah layar")
            pcall(function()
                if not VIM then error("VIM=nil") end
                VIM:SendTouchEvent("1",0,cx,cy,game)
                task.wait(0.08)
                VIM:SendTouchEvent("1",1,cx,cy,game)
                task.wait(0.08)
                VIM:SendTouchEvent("1",2,cx,cy,game)
                OK("  sent")
            end)
            task.wait(1.5)
            if checkPopup() then OK("Cara 2 BERHASIL!"); popupFound=true
            else WN("Cara 2 gagal") end
        end

        -- Cara 3: Activated:Fire
        if not popupFound then
            IN("Cara 3: Tool.Activated:Fire()")
            pcall(function()
                tgt.Activated:Fire()
                OK("  fired")
            end)
            task.wait(1.5)
            if checkPopup() then OK("Cara 3 BERHASIL!"); popupFound=true
            else WN("Cara 3 gagal") end
        end

        -- Cara 4: klik Handle
        if not popupFound then
            IN("Cara 4: klik Handle tool")
            pcall(function()
                if not VIM then error("VIM=nil") end
                local h = tgt:FindFirstChild("Handle")
                if not h then error("no Handle") end
                local sp,onSc = workspace.CurrentCamera:WorldToScreenPoint(h.Position)
                IN("  Handle onScreen="..tostring(onSc))
                if onSc then
                    VIM:SendMouseButtonEvent(sp.X,sp.Y,0,true,game,1)
                    task.wait(0.06)
                    VIM:SendMouseButtonEvent(sp.X,sp.Y,0,false,game,1)
                    OK("  klik sent")
                end
            end)
            task.wait(1.5)
            if checkPopup() then OK("Cara 4 BERHASIL!"); popupFound=true
            else WN("Cara 4 gagal") end
        end

        -- Cara 5: getconnections Activated
        if not popupFound then
            IN("Cara 5: getconnections(Activated)")
            pcall(function()
                local cc = getconnections(tgt.Activated)
                if not cc then error("getconnections nil") end
                IN("  "..#cc.." connection(s) di Activated")
                for i,c2 in ipairs(cc) do
                    pcall(function() c2:Fire(); OK("  conn#"..i.." fired") end)
                end
            end)
            task.wait(1.5)
            if checkPopup() then OK("Cara 5 BERHASIL!"); popupFound=true
            else WN("Cara 5 gagal") end
        end

        if popupFound then
            doPopupScan(eatGui)
        else
            ER("POPUP TIDAK MUNCUL setelah semua cara!")
            IN("Coba: buka popup manual (klik slot buah, klik layar)")
            IN("Lalu LANGSUNG execute ulang script ini")
            IN("")
            IN("Daftar ScreenGui di PlayerGui:")
            pcall(function()
                for _,sg2 in ipairs(lp.PlayerGui:GetChildren()) do
                    if sg2:IsA("ScreenGui") then
                        local en=true
                        pcall(function() en=sg2.Enabled end)
                        DT(sg2.Name.." En="..tostring(en).." ch="..#sg2:GetChildren())
                    end
                end
            end)
        end
    end

    -- ── Pengecekan akhir
    SH("PENGECEKAN AKHIR")
    local stillHas = false
    pcall(function()
        if bp then for _,t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and t.Name==tgt.Name then stillHas=true end
        end end
        if char then for _,t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and t.Name==tgt.Name then stillHas=true end
        end end
    end)

    if stillHas then WN("Buah '"..tgt.Name.."' masih di backpack")
    else             OK("Buah '"..tgt.Name.."' hilang — tersimpan!") end

    IN("Total remote captured: "..#captured)
    for _,c in ipairs(captured) do
        HI(c.cls.." '"..c.name.."' ("..c.args..")")
        DT(c.path)
    end

    SH("SELESAI — screenshot & kirim hasilnya!")
    htl.Text = "SELESAI — screenshot panel ini"
    OK("Bisa di-scroll ke atas/bawah")
end)
