Object = require 'libraries/classic/classic'
Input  = require 'libraries/boipushy/Input'
Timer  = require 'libraries/enhanced_timer/EnhancedTimer'
Camera = require 'libraries/hump/camera'

function love.load()
    -- Game resolution setup
    resize(3)
    love.graphics.setDefaultFilter('nearest')
    love.graphics.setLineStyle('rough')

    -- Load objects
    local object_files = {}
    recursiveEnumerate('objects', object_files)
    requireFiles(object_files)

    -- Global timer setup
    timer = Timer()

    -- Rooms setup
    current_room = nil

    -- Camera setup
    camera = Camera()

    -- Input setup and bindings
    input = Input()

    -- Miscellaneous
    input:bind('f1', function() gotoRoom('Stage') end)
    input:bind('f3', function() camera:shake(4, 60, 1) end)
end

function love.update()
    -- Global timer update
    timer:update(dt)

    -- Rooms update
    if current_room then current_room:update(dt) end

    -- Camera update
    camera:update(dt)
end

function love.draw()
    -- Draw room
    if current_room then current_room:draw() end

    -- Miscellaneous
    love.graphics.circle('line', gw/2, gh/2, 50)
end

-------------------------------------------------------------------------------

-- Helper for loading objects
function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)

    for _, item in ipairs(items) do
        local file = folder .. '/' .. item

        if love.filesystem.isFile(file) then
            table.insert(file_list, file)
        elseif love.filesystem.isDirectory(file) then
            recursiveEnumerate(file, file_list)
        end
    end
end

-- Helper for loading objects
function requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1, -5)
        require(file)
    end
end

-- Helper for room changing
function gotoRoom(room_type, ...)
    current_room = _G[room_type](...)
end

-- Game resolution helper
function resize(s)
    love.window.setMode(s*gw, s*gh) 
    sx, sy = s, s
end