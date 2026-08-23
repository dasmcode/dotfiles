local MiniStatusline = require("mini.statusline")

MiniStatusline.setup({
  use_icons = true,
  content = {
    active = function()
      local mode = MiniStatusline.section_mode({ trunc_width = 120 })
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
      local location = MiniStatusline.section_location({ trunc_width = 75 })

      return mode .. filename .. "%=" .. fileinfo .. location
    end,
  },
})
