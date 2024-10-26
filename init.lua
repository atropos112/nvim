local cfg = require("atro.config")

cfg.init_default()
cfg.init_user(os.getenv("HOME") .. "/.config/nvim-custom/init.lua")

require("atro.lazy")
