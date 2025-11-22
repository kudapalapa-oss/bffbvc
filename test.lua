--[[
    Script untuk Deobfuscate File lua.lua
    =====================================
    
    Script ini khusus untuk mendekripsi file lua.lua yang ada di folder.
    
    CATATAN:
    - Script ini menggunakan teknik runtime hooks untuk menangkap kode
    - Jalankan script ini SEBELUM menjalankan script obfuscated
    - Hooks akan menangkap dan menampilkan kode yang dieksekusi
]]

print("\n" .. string.rep("=", 70))
print("MOONSEC V3 / SANSMOBA DEOBFUSCATOR")
print("Untuk file: lua.lua")
print(string.rep("=", 70) .. "\n")

-- ============================================
-- RUNTIME HOOKS - AKTIFKAN SEBELUM SCRIPT DIJALANKAN
-- ============================================

local hooksInstalled = false

local function installHooks()
    if hooksInstalled then
        print("[WARNING] Hooks sudah diinstall sebelumnya\n")
        return
    end
    
    print("[INFO] Installing runtime hooks...")
    
    -- Hook ke loadstring/load
    local originalLoadstring = loadstring or load
    if originalLoadstring then
        local hooked = function(script, chunkname)
            print("\n" .. string.rep("=", 70))
            print("[HOOK] loadstring/load DETECTED!")
            print(string.rep("=", 70))
            print("Timestamp:", os.time() or "N/A")
            if type(script) == "string" then
                print(string.format("Script Length: %d characters", #script))
                print("\n--- FIRST 1500 CHARACTERS ---")
                print(script:sub(1, 1500))
                print("\n--- ... ---\n")
                print("--- LAST 1000 CHARACTERS ---")
                print(script:sub(-1000))
                print(string.rep("=", 70))
                
                -- Try to save to clipboard
                if setclipboard then
                    setclipboard(script)
                    print("\n[SUCCESS] Script copied to clipboard!")
                    print("Paste ke editor untuk melihat kode lengkap.\n")
                else
                    print("\n[INFO] setclipboard tidak tersedia, gunakan copy manual")
                end
                
                -- Save first 5000 characters untuk analisis
                local preview = script:sub(1, 5000)
                print("\n[PREVIEW] First 5000 characters:")
                print(preview)
                print("\n")
            end
            return originalLoadstring(script, chunkname)
        end
        
        loadstring = hooked
        load = hooked
        print("✓ Hook loadstring/load installed")
    end
    
    -- Hook ke getfenv
    local originalGetfenv = getfenv
    if originalGetfenv then
        getfenv = function(level)
            print(string.format("[HOOK] getfenv called (level: %s)", tostring(level)))
            return originalGetfenv(level)
        end
        print("✓ Hook getfenv installed")
    end
    
    -- Hook ke setfenv
    local originalSetfenv = setfenv
    if originalSetfenv then
        setfenv = function(func, env)
            print("[HOOK] setfenv called")
            return originalSetfenv(func, env)
        end
        print("✓ Hook setfenv installed")
    end
    
    -- Hook ke getrawmetatable (sering digunakan MoonSec V3)
    if getrawmetatable then
        local originalGetrawmetatable = getrawmetatable
        getrawmetatable = function(obj)
            print(string.format("[HOOK] getrawmetatable called (obj: %s)", type(obj)))
            return originalGetrawmetatable(obj)
        end
        print("✓ Hook getrawmetatable installed")
    end
    
    -- Hook ke setrawmetatable
    if setrawmetatable then
        local originalSetrawmetatable = setrawmetatable
        setrawmetatable = function(obj, metatable)
            print(string.format("[HOOK] setrawmetatable called (obj: %s)", type(obj)))
            return originalSetrawmetatable(obj, metatable)
        end
        print("✓ Hook setrawmetatable installed")
    end
    
    -- Hook ke checkcaller (anti-tamper MoonSec V3)
    if checkcaller then
        local originalCheckcaller = checkcaller
        checkcaller = function()
            print("[HOOK] checkcaller called (bypassing)")
            return true  -- Bypass anti-tamper
        end
        print("✓ Hook checkcaller installed (bypass enabled)")
    end
    
    hooksInstalled = true
    print("\n" .. string.rep("=", 70))
    print("[SUCCESS] All hooks installed successfully!")
    print(string.rep("=", 70))
    print("\n[INFO] Runtime hooks aktif dan siap menangkap kode!")
    print("[INFO] Sekarang jalankan script obfuscated Anda.")
    print("[INFO] Kode yang dieksekusi akan ditampilkan di console.\n")
end

-- Auto-install hooks
installHooks()

-- ============================================
-- STRING ANALYSIS FUNCTIONS
-- ============================================

local function analyzeObfuscatedScript(script)
    print("\n" .. string.rep("=", 70))
    print("SCRIPT ANALYSIS")
    print(string.rep("=", 70))
    
    if type(script) ~= "string" then
        print("⚠️  Script bukan string!")
        return
    end
    
    print(string.format("Script Length: %d characters", #script))
    print(string.format("Script Size: %.2f KB", #script / 1024))
    
    -- Check obfuscator patterns
    local patterns = {
        MoonSec = script:find("MoonSec") or script:find("moon"),
        SansMoba = script:find("SansMoba"),
        WeAreDevs = script:find("wearedevs") or script:find("WeAreDevs"),
    }
    
    print("\nObfuscator Detection:")
    for name, found in pairs(patterns) do
        print(string.format("  %s: %s", name, found and "✓" or "✗"))
    end
    
    -- Count escape sequences
    local escapeCount = 0
    for _ in script:gmatch('\\(%d+)') do
        escapeCount = escapeCount + 1
    end
    
    print(string.format("\nEncoded Strings: %d escape sequences found", escapeCount))
    
    -- Check for VM patterns
    local vmPatterns = {
        getfenv = script:find("getfenv"),
        loadstring = script:find("loadstring"),
        getrawmetatable = script:find("getrawmetatable"),
        checkcaller = script:find("checkcaller"),
    }
    
    print("\nVM/Protection Patterns:")
    for name, found in pairs(vmPatterns) do
        print(string.format("  %s: %s", name, found and "✓" or "✗"))
    end
    
    print(string.rep("=", 70) .. "\n")
end

-- Export functions untuk penggunaan manual
if getgenv then
    getgenv().DeobfuscatorHooks = {
        install = installHooks,
        analyze = analyzeObfuscatedScript,
    }
end

-- Display instructions
print("\n" .. string.rep("=", 70))
print("INSTRUCTIONS")
print(string.rep("=", 70))
print([[
1. Hooks sudah diinstall dan aktif
2. Jalankan script obfuscated Anda (lua.lua)
3. Kode yang dieksekusi akan ditampilkan di console
4. Script akan di-copy ke clipboard secara otomatis
5. Paste ke editor untuk melihat kode lengkap

CARA MENGGUNAKAN:
-----------------
-- Jika script Anda adalah:
local script = loadstring(game:HttpGet("..."))()

-- Jalankan script ini TERLEBIH DAHULU (hooks sudah aktif)
-- Kemudian jalankan script obfuscated Anda

ATAU:

-- Jika Anda punya script langsung:
local obfuscatedScript = [PASTE SCRIPT DI SINI]
local clean = DeobfuscatorHooks.analyze(obfuscatedScript)

LANGKAH SELANJUTNYA:
-------------------
Setelah hooks aktif, jalankan script obfuscated Anda.
Hooks akan menangkap dan menampilkan kode yang dieksekusi.
]])
print(string.rep("=", 70) .. "\n")

-- Ready!
print("🚀 Deobfuscator ready! Hooks aktif dan siap menangkap kode!\n")

