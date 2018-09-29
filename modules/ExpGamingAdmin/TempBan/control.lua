--- Adds a temp ban function to the admin set, requires ExpGamingCore.Role to work.
-- @module ExpGamingAdmin.KicTempBan@4.0.0
-- @author Cooldude2606
-- @license https://github.com/explosivegaming/scenario/blob/master/LICENSE
-- @alais ThisModule 

-- Module Require
local Admin = require('ExpGamingAdmin.AdminLib@^4.0.0')
local Server = require('ExpGamingCore.Server@^4.0.0')
local Role = require('ExpGamingCore.Role@^4.0.0')
local Game = require('FactorioStdLib.Game@^0.8.0')
local Color = require('FactorioStdLib.Color@^0.8.0')
local Sync -- ExpGamingCore.Sync@^4.0.0

-- Module Define
local module_verbose = false
local ThisModule = {
    on_init=function()
        if loaded_modules['ExpGamingCore.Sync@^4.0.0'] then Sync = require('ExpGamingCore.Sync@^4.0.0') end
    end
}

-- Function Define
function Admin.temp_ban(player,by_player,reason)
    local player = Game.get_player(player)
    local by_player_name = Game.get_player(by_player) and Game.get_player(by_player).name or '<server>'
    if not player or Admin.is_banned(player) then return end
    Admin.set_banned(player,'temp')
    if Sync then Sync.emit_embeded{
        title='Player Temp-Ban',
        color=Color.to_hex(defines.textcolor.high),
        description='A player was jailed.',
        ['Player:']='<<inline>>'..player.name,
        ['By:']='<<inline>>'..by_player_name,
        ['Reason:']=Admin.create_reason(reason,by_player_name)
    } end
    game.print({'ExpGamingAdmin.temp-ban',player.name,by_player_name,reason},defines.textcolor.info)
    if Admin.move_inventory then Admin.move_inventory(player) end
    Role.meta.last_jail = player.name
    Server.interface(Role.unassign,true,player,Role.get(player),by_player_name)
    Server.interface(Role.assign,true,player,'Jail',by_player_name)
end

Admin.add_action('Temp Ban',Admin.temp_ban)

-- Module Return
return ThisModule 