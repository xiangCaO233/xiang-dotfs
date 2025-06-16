-- A slightly altered version of catppucchin mocha
-- stylua: ignore
local mocha = {
   rosewater = '#f5e0dc',
   flamingo  = '#f2cdcd',
   pink      = '#f5c2e7',
   mauve     = '#cba6f7',
   red       = '#f38ba8',
   maroon    = '#eba0ac',
   peach     = '#fab387',
   yellow    = '#f9e2af',
   green     = '#a6e3a1',
   teal      = '#94e2d5',
   sky       = '#89dceb',
   sapphire  = '#74c7ec',
   blue      = '#89b4fa',
   lavender  = '#b4befe',
   text      = '#cdd6f4',
   subtext1  = '#bac2de',
   subtext0  = '#a6adc8',
   overlay2  = '#9399b2',
   overlay1  = '#7f849c',
   overlay0  = '#6c7086',
   surface2  = '#585b70',
   surface1  = '#45475a',
   surface0  = '#313244',
   base      = '#171720',
   mantle    = '#181825',
   crust     = '#11111b',
}
-- 高对比度粉色护眼主题
-- stylua: ignore
local pink_theme = {
  -- 柔和的粉色系配色
  rosewater = '#FFD6E0', -- 更柔和的玫瑰水色
  flamingo  = '#FFB8D1', -- 柔和的火烈鸟粉
  pink      = '#FFA3D1', -- 中等饱和度粉色
  mauve     = '#D8B4FE', -- 柔和的薰衣草紫
  red       = '#FF6B8B', -- 柔和的珊瑚红
  maroon    = '#FF8FA3', -- 柔和的玫瑰红
  peach     = '#FFB88C', -- 柔和的桃色
  yellow    = '#FFE08C', -- 柔和的黄色
  green     = '#8CFF8F', -- 柔和的绿色
  teal      = '#7AFFE0', -- 柔和的青色
  sky       = '#8CD4FF', -- 柔和的天蓝色
  sapphire  = '#8CB4FF', -- 柔和的蓝宝石色
  blue      = '#A3B4FF', -- 柔和的蓝色
  lavender  = '#C8C8FF', -- 柔和的薰衣草色

  -- 文本和背景色保持高对比度
  text      = '#F0F0F0', -- 接近纯白的文本
  subtext1  = '#D0D0D0', -- 高对比度副文本
  subtext0  = '#B0B0B0', -- 次副文本
  overlay2  = '#909090', -- 覆盖层文本
  overlay1  = '#707070', -- 次覆盖层
  overlay0  = '#505050', -- 弱覆盖层

  -- 背景色保持深色
  surface2  = '#353535',
  surface1  = '#282828',
  surface0  = '#1E1E1E',
  base      = '#080808',
  mantle    = '#0F0F0F',
  crust     = '#0A0A0A',
}

local colorscheme = {
	 foreground = mocha.text,
   background = mocha.base,
   cursor_bg = mocha.rosewater,
   cursor_border = mocha.rosewater,
   cursor_fg = mocha.crust,
   selection_bg = mocha.surface2,
   selection_fg = mocha.text,
   ansi = {
      '#0C0C0C', -- black
      '#C50F1F', -- red
      '#13A10E', -- green
      '#C19C00', -- yellow
      '#0037DA', -- blue
      '#881798', -- magenta/purple
      '#3A96DD', -- cyan
      '#CCCCCC', -- white
   },
   brights = {
      '#767676', -- black
      '#E74856', -- red
      '#16C60C', -- green
      '#F9F1A5', -- yellow
      '#3B78FF', -- blue
      '#B4009E', -- magenta/purple
      '#61D6D6', -- cyan
      '#F2F2F2', -- white
   },
   tab_bar = {
      background = 'rgba(0, 0, 0, 0.4)',
      active_tab = {
         bg_color = mocha.surface2,
         fg_color = mocha.text,
      },
      inactive_tab = {
         bg_color = mocha.surface0,
         fg_color = mocha.subtext1,
      },
      inactive_tab_hover = {
         bg_color = mocha.surface0,
         fg_color = mocha.text,
      },
      new_tab = {
         bg_color = mocha.base,
         fg_color = mocha.text,
      },
      new_tab_hover = {
         bg_color = mocha.mantle,
         fg_color = mocha.text,
         italic = true,
      },
   },
   visual_bell = mocha.red,
   indexed = {
      [16] = mocha.peach,
      [17] = mocha.rosewater,
   },
   scrollbar_thumb = mocha.surface2,
   split = mocha.overlay0,
   compose_cursor = mocha.flamingo,
}

local pcolorscheme = {
  foreground = pink_theme.text,
  background = pink_theme.base,

  -- 光标使用柔和的粉色
  cursor_bg = pink_theme.flamingo,
  cursor_border = pink_theme.flamingo,
  cursor_fg = pink_theme.crust,

  -- 选择区域
  selection_bg = pink_theme.surface2,
  selection_fg = pink_theme.text,

  -- ANSI 颜色 (减少品红色使用)
  ansi = {
    pink_theme.crust,      -- 黑色
    pink_theme.red,        -- 红色 (使用珊瑚红替代品红)
    pink_theme.green,      -- 绿色
    pink_theme.yellow,     -- 黄色
    pink_theme.blue,       -- 蓝色
    pink_theme.mauve,      -- 紫色 (使用薰衣草紫替代品红)
    pink_theme.teal,       -- 青色
    pink_theme.subtext1,   -- 白色
  },

  -- 亮色 (避免使用突兀的品红色)
  brights = {
    pink_theme.overlay0,   -- 黑色
    pink_theme.maroon,     -- 红色 (使用玫瑰红)
    '#7AFF7D',             -- 柔和的亮绿色
    pink_theme.peach,      -- 黄色 (使用桃色)
    '#8CB4FF',             -- 柔和的亮蓝色
    pink_theme.pink,       -- 粉色 (替代品红)
    pink_theme.sky,        -- 青色 (使用天蓝色)
    pink_theme.text,       -- 白色
  },

  -- 标签栏设置 (使用粉色系)
  tab_bar = {
    background = 'rgba(10, 10, 10, 0.7)',
    active_tab = {
      bg_color = pink_theme.surface1,
      fg_color = pink_theme.flamingo,
    },
    inactive_tab = {
      bg_color = pink_theme.surface0,
      fg_color = pink_theme.overlay2,
    },
    inactive_tab_hover = {
      bg_color = pink_theme.surface0,
      fg_color = pink_theme.subtext1,
    },
    new_tab = {
      bg_color = pink_theme.base,
      fg_color = pink_theme.text,
    },
    new_tab_hover = {
      bg_color = pink_theme.mantle,
      fg_color = pink_theme.flamingo,
      italic = true,
    },
  },

  -- 其他元素
  visual_bell = pink_theme.red,
  indexed = {
    [16] = pink_theme.peach,
    [17] = pink_theme.rosewater,
  },
  scrollbar_thumb = pink_theme.surface2,
  split = pink_theme.overlay0,
  compose_cursor = pink_theme.flamingo,
}

return pcolorscheme
