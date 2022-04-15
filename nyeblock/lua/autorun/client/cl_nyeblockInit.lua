//Client vars
NYEBLOCK.PROFILE = {}

//Files to include
include("donations/cl_donationManager.lua")
include("profile/cl_profile.lua")
include("profile/cl_viewProfile.lua")
include("exploit_reporting/cl_exploitReporting.lua")
include("f1/cl_f1.lua")
include("levels/cl_levels.lua")
include("motd/cl_motd.lua")
include("popups/cl_hints.lua")
include("popups/cl_roundPopup.lua")
include("rtd/cl_rtd.lua")
include("tag_system/cl_tagSystem.lua")
include("user/cl_profile.lua")
include("user/cl_userSearch.lua")

-- for k,v in pairs(clientFiles) do
-- 	include(v)
-- end