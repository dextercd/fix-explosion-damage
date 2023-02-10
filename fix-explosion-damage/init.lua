-- Welcome, seeker of knowledge!

local ffi = require("ffi")

ffi.cdef([[

bool VirtualProtect(void* adress, size_t size, int new_protect, int* old_protect);
int memcmp(const void *buffer1, const void *buffer2, size_t count);

]])

local locations = {
    0x009f67c6,
    0x00a0107a,
}

local expect = ffi.new("uint8_t[4]", {0xc8, 0x2d, 0xe6, 0x00})
local gui_hp_multiplier_location = ffi.new("uint8_t[4]", {0xfc, 0xac, 0xf3, 0x00})

function patch_location(location, expect, patch_bytes)
    if ffi.C.memcmp(location, patch_bytes, ffi.sizeof(patch_bytes)) == 0 then
        -- Patch already applied! :-)
        return true
    end

    if ffi.C.memcmp(location, expect, ffi.sizeof(expect)) ~= 0 then
        print("Error: Unexpected instructions at location.")
        return false
    end

    local restore_protection = ffi.new("int[1]")
    local prot_success = ffi.C.VirtualProtect(
        location, ffi.sizeof(patch_bytes), 0x40, restore_protection)

    if not prot_success then
        print("Error: Couldn't change memory protection.")
        return false
    end

    ffi.copy(location, patch_bytes, ffi.sizeof(patch_bytes))

    -- Restore protection
    ffi.C.VirtualProtect(
        location,
        ffi.sizeof(patch_bytes),
        restore_protection[0],
        restore_protection)

    return true
end


for _, location in ipairs(locations) do
    local loc = ffi.cast("void*", location)
    patch_location(loc, expect, gui_hp_multiplier_location)
end
