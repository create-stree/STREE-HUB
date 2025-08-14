local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- =========================
-- Konfigurasi lokasi / event
-- =========================
-- Ganti nama folder/objek ini sesuai di game
local PlantsFolder = workspace:FindFirstChild("Plants")
local GearFolder = workspace:FindFirstChild("GearSpawns")
local PetFolder = workspace:FindFirstChild("PetSpawns")

-- Waktu kemunculan terakhir
local lastPlantTime = nil
local lastGearTime = nil
local lastPetTime = nil

-- Perkiraan cooldown (detik) - nanti bisa disesuaikan
local plantCooldown = 300 -- contoh: 5 menit
local gearCooldown = 600  -- contoh: 10 menit
local petCooldown = 900   -- contoh: 15 menit

-- Fungsi untuk format waktu ke menit:detik
local function formatTime(seconds)
    local m = math.floor(seconds / 60)
    local s = math.floor(seconds % 60)
    return string.format("%02d:%02d", m, s)
end

-- Deteksi tanaman
if PlantsFolder then
    PlantsFolder.ChildAdded:Connect(function(child)
        lastPlantTime = tick()
        print("🌱 Tanaman muncul pada:", os.date("%X", lastPlantTime))
    end)
end

-- Deteksi gear
if GearFolder then
    GearFolder.ChildAdded:Connect(function(child)
        lastGearTime = tick()
        print("⚙️ Gear muncul pada:", os.date("%X", lastGearTime))
    end)
end

-- Deteksi pet
if PetFolder then
    PetFolder.ChildAdded:Connect(function(child)
        lastPetTime = tick()
        print("🐾 Pet muncul pada:", os.date("%X", lastPetTime))
    end)
end

-- Loop prediksi
RunService.Heartbeat:Connect(function()
    if lastPlantTime then
        local remaining = (lastPlantTime + plantCooldown) - tick()
        if remaining > 0 then
            print("⏳ Tanaman berikutnya dalam", formatTime(remaining))
        end
    end

    if lastGearTime then
        local remaining = (lastGearTime + gearCooldown) - tick()
        if remaining > 0 then
            print("⏳ Gear berikutnya dalam", formatTime(remaining))
        end
    end

    if lastPetTime then
        local remaining = (lastPetTime + petCooldown) - tick()
        if remaining > 0 then
            print("⏳ Pet berikutnya dalam", formatTime(remaining))
        end
    end
end)
