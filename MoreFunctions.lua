format = {
    obfuscated = '\194\167k',
    bold = '\194\167l',
    strikethrough = '\194\167m',
    underline = '\194\167n',
    italic = '\194\167o',
    reset = '\194\167r'
}

color = {
    dark_red = '\194\1674',
    red = '\194\167c',
    gold = '\194\1676',
    yellow = '\194\167e',
    dark_green = '\194\1672',
    green = '\194\167a',
    aqua = '\194\167b',
    dark_aqua = '\194\1673',
    dark_blue = '\194\1671',
    blue = '\194\1679',
    light_purple = '\194\167d',
    dark_purple = '\194\1675',
    white = '\194\167f',
    gray = '\194\1677',
    dark_gray = '\194\1678',
    black = '\194\1670'
}

Math = {
    round = function(num, dec)
        local shift = 10^(dec or 2)
        num = math.floor(num * shift + 0.5) / shift
        if num == math.floor(num) then num = tostring(num.."."..("0"):rep(dec)) end
        return num
    end
}

thePlayer = {
    mouseOverBlock = function()
        local n, v, x, y, z, sx, sy, sz = player.over_mouse()
        if n == 2 then
            return v, x, y, z, sx, sy, sz
        end
        return nil
    end,

    findHotbarSlot = function(item)
        for i = 1, 9 do
            local name = player.inventory.item_information(35 + i)

            if name ~= nil and string.match(name, item) then
                return i
            end
        end

        return -1
    end
}

moduleHelper = {
    setModuleState = function(mod, boolean)
        if module_manager.is_module_on(mod) ~= boolean then
            player.message("." .. mod)
        end
    end
}

theWorld = {
    isTeamMate = function(entityID)
        if entityID == nil then
            return nil
        end
        display_name = world.display_name(player.id())
        if display_name ~= nil then
            if string.find(display_name, "\194\167") ~= nil then
                substring = string.sub(display_name, string.find(display_name, "\194\167"), string.find(display_name, "\194\167") +2)
                if string.find(world.display_name(entityID), substring) ~= nil then
                    return true
                end
                return false
            end
        end
    end,

    getBPS = function(entityID, decimals)
        local posX, posY, posZ = world.position(entityID)
        local prevPosX, prevPosY, prevPosZ = world.prev_position(entityID)
        local x = posX - prevPosX;
        local z = posZ - prevPosZ;
        local sp = math.sqrt((x * x) + (z * z)) * 20;
        return Math.round(sp, decimals);
    end,

    isEntityNaked = function(entityID)
        local inventory = world.inventory(entityID)
        if inventory.leggings == nil and inventory.chestplate == nil and inventory.helmet == nil and inventory.boots == nil then
            return true
        else
            return false
        end
    end
}

renderHelper = {
    renderBlockSideOutline = function(minX, minY, minZ, maxX, maxY, maxZ, sc, r, g, b, a, thickness)
        red = r
        green = g
        blue = b
        alpha = a
        px, py, pz = player.camera_position()
        dMinX = minX-px
        dMinY = minY-py
        dMinZ = minZ-pz
        dMaxX = maxX-px
        dMaxY = maxY-py
        dMaxZ = maxZ-pz
        
        x1, y1, z1 = render.world_to_screen(dMaxX,dMinY,dMinZ)
        x2, y2, z2 = render.world_to_screen(dMaxX,dMaxY,dMinZ)
        x3, y3, z3 = render.world_to_screen(dMinX,dMinY,dMaxZ)
        x4, y4, z4 = render.world_to_screen(dMinX,dMaxY,dMaxZ)
        x5, y5, z5 = render.world_to_screen(dMinX,dMinY,dMinZ)
        x6, y6, z6 = render.world_to_screen(dMinX,dMaxY,dMinZ)
        x7, y7, z7 = render.world_to_screen(dMaxX,dMinY,dMaxZ)
        x8, y8, z8 = render.world_to_screen(dMaxX,dMaxY,dMaxZ)
        
        render.scale(1/sc.scale_factor)
        
        lineWidth = thickness
        if z1<1 and z2<1 and z3<1 and z4<1 and z5<1 and z6<1 and z7<1 and z8<1 then
            v, x, y, z = thePlayer.mouseOverBlock()
            if v == 1 then
                render.line(x1,y1,x5,y5,lineWidth,red,green,blue,alpha)
                render.line(x3,y3,x7,y7,lineWidth,red,green,blue,alpha)
                render.line(x5,y5,x3,y3,lineWidth,red,green,blue,alpha)
                render.line(x7,y7,x1,y1,lineWidth,red,green,blue,alpha)
            end
            if v == 2 then
                render.line(x2,y2,x6,y6,lineWidth,red,green,blue,alpha)
                render.line(x4,y4,x8,y8,lineWidth,red,green,blue,alpha)
                render.line(x6,y6,x4,y4,lineWidth,red,green,blue,alpha)
                render.line(x8,y8,x2,y2,lineWidth,red,green,blue,alpha)
            end
            if v == 3 then
                render.line(x3,y3,x4,y4,lineWidth,red,green,blue,alpha)
                render.line(x7,y7,x8,y8,lineWidth,red,green,blue,alpha)
                render.line(x3,y3,x7,y7,lineWidth,red,green,blue,alpha)
                render.line(x4,y4,x8,y8,lineWidth,red,green,blue,alpha)
            end
            if v == 4 then
                render.line(x1,y1,x2,y2,lineWidth,red,green,blue,alpha)
                render.line(x5,y5,x6,y6,lineWidth,red,green,blue,alpha)
                render.line(x1,y1,x5,y5,lineWidth,red,green,blue,alpha)
                render.line(x2,y2,x6,y6,lineWidth,red,green,blue,alpha)
            end
            if v == 5 then
                render.line(x1,y1,x2,y2,lineWidth,red,green,blue,alpha)
                render.line(x7,y7,x8,y8,lineWidth,red,green,blue,alpha)
                render.line(x7,y7,x1,y1,lineWidth,red,green,blue,alpha)
                render.line(x8,y8,x2,y2,lineWidth,red,green,blue,alpha)
            end
            if v == 6 then
                render.line(x3,y3,x4,y4,lineWidth,red,green,blue,alpha)
                render.line(x5,y5,x6,y6,lineWidth,red,green,blue,alpha)
                render.line(x5,y5,x3,y3,lineWidth,red,green,blue,alpha)
                render.line(x6,y6,x4,y4,lineWidth,red,green,blue,alpha)
            end
        end
        
        render.scale(sc.scale_factor)
    end,

    renderOutline = function(minX, minY, minZ, maxX, maxY, maxZ, sc, red, green, blue, alpha, lineWidth)
        px, py, pz = player.camera_position()
        dMinX = minX-px
        dMinY = minY-py
        dMinZ = minZ-pz
        dMaxX = maxX-px
        dMaxY = maxY-py
        dMaxZ = maxZ-pz
        
        x1, y1, z1 = render.world_to_screen(dMaxX,dMinY,dMinZ)
        x2, y2, z2 = render.world_to_screen(dMaxX,dMaxY,dMinZ)
        x3, y3, z3 = render.world_to_screen(dMinX,dMinY,dMaxZ)
        x4, y4, z4 = render.world_to_screen(dMinX,dMaxY,dMaxZ)
        x5, y5, z5 = render.world_to_screen(dMinX,dMinY,dMinZ)
        x6, y6, z6 = render.world_to_screen(dMinX,dMaxY,dMinZ)
        x7, y7, z7 = render.world_to_screen(dMaxX,dMinY,dMaxZ)
        x8, y8, z8 = render.world_to_screen(dMaxX,dMaxY,dMaxZ)
        
        render.scale(1/sc.scale_factor)
        
        if z1<1 and z2<1 and z3<1 and z4<1 and z5<1 and z6<1 and z7<1 and z8<1 then
            render.line(x1,y1,x2,y2,lineWidth,red,green,blue,alpha)
            render.line(x3,y3,x4,y4,lineWidth,red,green,blue,alpha)
            render.line(x5,y5,x6,y6,lineWidth,red,green,blue,alpha)
            render.line(x7,y7,x8,y8,lineWidth,red,green,blue,alpha)
            render.line(x1,y1,x5,y5,lineWidth,red,green,blue,alpha)
            render.line(x2,y2,x6,y6,lineWidth,red,green,blue,alpha)
            render.line(x3,y3,x7,y7,lineWidth,red,green,blue,alpha)
            render.line(x4,y4,x8,y8,lineWidth,red,green,blue,alpha)
            render.line(x5,y5,x3,y3,lineWidth,red,green,blue,alpha)
            render.line(x6,y6,x4,y4,lineWidth,red,green,blue,alpha)
            render.line(x7,y7,x1,y1,lineWidth,red,green,blue,alpha)
            render.line(x8,y8,x2,y2,lineWidth,red,green,blue,alpha)
        end
        
        render.scale(sc.scale_factor)
    end,

    getBlockBoundingBox = function(posX, posY, posZ)
        maxY = posY + 1
        minY = posY
        maxX = posX
        maxZ = posZ
        minX = posX + 1
        minZ = posZ + 1
        return minX, minY, minZ, maxX, maxY, maxZ
    end
}

local recivedPacket = false
local recivedPacket2 = false
local stopped = false

module_manager.register("NewAirVelo", {
    on_receive_packet = function(e)
        if e.packet_id == 0x02 then
            message = string.gsub(e.message, '(\194\167%w)', '')
            if string.find(message, ",hi") then
                recivedPacket = true
            elseif string.find(message, ",lol") then
                recivedPacket2 = true
            elseif string.find(message, ",hii") then
                stopped = true
            end
        end
    end,

    on_send_packet = function(t)
        if recivedPacket2 then
            player.send_packet(0x09, 5)
            recivedPacket2 = false
        end
        if recivedPacket and not stopped then
    		if t.packet_id == 0x02 then
                if t.action == 2 then
    			    t.cancel = true
                end
    	    end
        end
        return t
    end,

    on_player_join = function()
        recivedPacket = false
        stopped = false
    end
})
