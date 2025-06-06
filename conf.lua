-- conf.lua

function love.conf(t)
    t.identity = "trial_by_card"           -- save directory name
    t.version = "11.5"                     -- Love2D version (update if needed)
    t.console = false                      -- Set to true if you want a debug console (Windows)

    t.window.title = "Trial by Card"       -- Title of the game window
    t.window.width = 1280                  -- Window width
    t.window.height = 720                  -- Window height
    t.window.resizable = false             -- Whether the window is resizable
    t.window.vsync = 1                     -- Vertical sync on (1) or off (0)
    t.window.msaa = 0                      -- Anti-aliasing (0 = off)
    t.window.fullscreen = true            -- Start in fullscreen?
    t.window.fullscreentype = "desktop"    -- Standard or desktop fullscreen

    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = false
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = false
    t.modules.sound = true
    t.modules.system = true
    t.modules.timer = true
    t.modules.window = true
end