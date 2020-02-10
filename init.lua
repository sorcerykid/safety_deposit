--------------------------------------------------------
-- Minetest :: Safety Deposit Mod (safety_deposit)
--
-- See README.txt for licensing and other information.
-- Copyright (c) 2020, Leslie E. Krause
--
-- ./games/minetest_game/mods/safety_deposit/init.lua
--------------------------------------------------------

local username = minetest.setting_get( "name" )	-- used as public key for encryption

-----------------------

safety_deposit = { }

safety_deposit.encrypt_metadata = function ( itemstack, data )
	local raw_data = cipher.encrypt_to_base64( minetest.serialize( data ), username )
	itemstack:set_metadata( raw_data )
end

safety_deposit.decrypt_metadata = function ( itemstack )
	local raw_data = itemstack:get_metadata( )
	if cipher.is_encrypted( raw_data ) then
		return minetest.deserialize( cipher.decrypt_from_base64( raw_data, username ) )
	else
		return minetest.deserialize( raw_data )
	end
end

-----------------------

local disabled_safes = { }

local function open_safe_viewer( pos, player_name, access_code, safe_inv )

	local function get_formspec( )
		local formspec =
			"size[8,7]" ..
			default.gui_bg ..
			default.gui_bg_img ..
			default.gui_slots ..
			string.format( "list[detached:%s_safe;main;0,0;8,2;]", player_name ) ..
			"button[0.0,2.3;2,0.3;get;Get Items]" ..
			"button[6.0.,2.3;2,0.3;unlock;Unlock]" ..
			"list[current_player;main;0,3;8,1;]" ..
			"list[current_player;main;0,4.2;8,3;8]" ..
			"listring[nodemeta:%s;books]"..
			"listring[current_player;main]" ..
			"hidden[context;true]" ..
			default.get_hotbar_bg(0,3)

		return formspec
	end

	local function on_close( fs, player, fields )
		if fields.quit then
			local meta = minetest.get_meta( pos )
			local data = { }

			for _, itemstack in ipairs( safe_inv:get_list( "main" ) ) do
				table.insert( data, itemstack:to_string( ) )
			end

			local raw_data = cipher.encrypt_to_base64( minetest.serialize( data ), access_code )

			meta:set_string( "storage", raw_data )
			safe_inv:set_list( "main", { } )	-- reset player's detached inventory

			minetest.sound_play( "safe_close", { pos = pos, gain = 1.0, max_hear_distance = 5, loop = false } )

		elseif fields.get then
	                local player_inv = player:get_inventory( )
			default.get_contents( safe_inv, player_inv )

		elseif fields.unlock then
			local meta = minetest.get_meta( pos )

			if not safe_inv:is_empty( "main" ) then
				minetest.sound_play( "safe_close", { pos = pos, gain = 1.0, max_hear_distance = 5, loop = false } )
				minetest.chat_send_player( player_name, "This safe cannot be unlocked until it is empty." )
				minetest.destroy_form( player_name, minetest.FORMSPEC_SIGSTOP )

				return
			end

			meta:set_string( "storage", "" )
			meta:set_string( "infotext", "Unlocked Safe" )

			minetest.sound_play( "safe_unlock", { pos = pos, gain = 1.0, max_hear_distance = 5, loop = false } )
			minetest.log_status( "%s unlocks digital safe at %s", player_name, minetest.pos_to_string( pos ) )
			minetest.chat_send_player( player_name, "This safe is unlocked. Right-click to set an access code." )
			minetest.destroy_form( player_name, minetest.FORMSPEC_SIGSTOP )
		end
	end

	minetest.sound_play( "safe_open", { pos = pos, gain = 1.0, max_hear_distance = 5, loop = false } )
	minetest.create_form( nil, player_name, get_formspec( ), on_close )
end

local function open_safe_signin( pos, player_name )
	local digits = { }

        local function get_formspec( )
                local formspec =
                        string.format( "size[4.0,6.3]" ) ..
                        default.gui_bg ..
                        default.gui_bg_img ..

			"box[0.0,1.1;3.8,4.5;#222222]" ..

			"button[0.5,3.4;1.0,1.0;num7;7]" ..
			"button[1.5,3.4;1.0,1.0;num8;8]" ..
			"button[2.5,3.4;1.0,1.0;num9;9]" ..
			"button[0.5,2.4;1.0,1.0;num4;4]" ..
			"button[1.5,2.4;1.0,1.0;num5;5]" ..
			"button[2.5,2.4;1.0,1.0;num6;6]" ..
			"button[0.5,1.4;1.0,1.0;num1;1]" ..
			"button[1.5,1.4;1.0,1.0;num2;2]" ..
			"button[2.5,1.4;1.0,1.0;num3;3]" ..
			"button[0.5,4.4;2.0,1.0;num0;0]" ..
			"button[2.5,4.4;1.0,1.0;clear;C]" ..
			"button[1.0,5.7;2.0,1.0;enter;Enter]" ..

			string.format( "image[0.0,0.0;1.0,1.0;counter_%s.png]", digits[ 1 ] or "nil" ) ..
			string.format( "image[1.0,0.0;1.0,1.0;counter_%s.png]", digits[ 2 ] or "nil" ) ..
			string.format( "image[2.0,0.0;1.0,1.0;counter_%s.png]", digits[ 3 ] or "nil" ) ..
			string.format( "image[3.0,0.0;1.0,1.0;counter_%s.png]", digits[ 4 ] or "nil" )
		return formspec
	end

	local function on_close( form, player, fields )
		if fields.quit then return end

		if fields.enter then
			local meta = minetest.get_meta( pos )
			local access_code = table.concat( digits )

			if #access_code < 4 then
				minetest.sound_play( "safe_abort", { pos = pos, gain = 0.5, max_hear_distance = 5, loop = false } )
				return
			end

			if meta:get_string( "storage" ) == "" then
				-- this safe is unlocked, so set access code and create inventory
				local data = { "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" }
				local raw_data = cipher.encrypt_to_base64( minetest.serialize( data ), access_code )

				meta:set_string( "storage", raw_data )
				meta:set_string( "infotext", "Locked Safe" )

				minetest.sound_play( "safe_lock", { pos = pos, gain = 1.0, max_hear_distance = 5, loop = false } )
				minetest.log_status( "%s locks digital safe at %s", player_name, minetest.pos_to_string( pos ) )
				minetest.chat_send_player( player_name, "This safe is ready for use. Your access code is " .. access_code .. ". Do not forget this number!" )
				minetest.destroy_form( player_name )
				
			else
				-- this safe is locked, so validate the access code
				local raw_data = meta:get_string( "storage" )

				if not cipher.is_encrypted( raw_data ) then
					minetest.chat_send_player( player_name, "This safe cannot be opened." )
					minetest.destroy_form( player_name )

					return
				end

				local data = minetest.deserialize( cipher.decrypt_from_base64( raw_data, access_code ) )
				if not data then
					local safe_id = minetest.hash_node_position( pos )

					disabled_safes[ safe_id ] = player_name
					minetest.after( 5.0, function ( )
						disabled_safes[ safe_id ] = nil
					end )

					minetest.sound_play( "safe_error", { pos = pos, gain = 0.5, max_hear_distance = 5, loop = false } )
					minetest.log_status( "%s is denied access to digital safe at %s", player_name, minetest.pos_to_string( pos ) )
					minetest.chat_send_player( player_name, "Incorrect access code." )
					minetest.destroy_form( player_name )

					return
				end

				local safe_inv = minetest.get_inventory( { type = "detached", name = player_name .. "_safe" } )
				safe_inv:set_list( "main", data )

				open_safe_viewer( pos, player_name, access_code, safe_inv )
			end

		elseif fields.clear then
			digits = { }
			minetest.sound_play( "safe_entry", { pos = pos, gain = 0.5, max_hear_distance = 5, loop = false } )
			minetest.update_form( player_name, get_formspec( ) )

		else
			local field_name = next( fields, nil )	-- next, since we only care about the name of the first button
			local key = string.match( field_name, "^num([0-9])$" )

			if key and #digits < 4 then
				table.insert( digits, key )
				minetest.sound_play( "safe_entry", { pos = pos, gain = 0.5, max_hear_distance = 5, loop = false } )
				minetest.update_form( player_name, get_formspec( ) )
			else
				minetest.sound_play( "safe_abort", { pos = pos, gain = 0.5, max_hear_distance = 5, loop = false } )
			end
		end
	end

	minetest.create_form( nil, player_name, get_formspec( ), on_close )
end

minetest.register_on_joinplayer( function( player )
	local player_name = player:get_player_name( )
	local safe_inv = minetest.create_detached_inventory( player_name .. "_safe", { }, player_name )

	safe_inv:set_size( "main", 16 )
end )

minetest.register_node( "safety_deposit:digital_safe", {
	-- https://gitlab.com/VanessaE/currency/
	description = ( "Digital Safe" ),
	inventory_image = "safe_front.png",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {
		"safe_side.png",
		"safe_side.png",
		"safe_side.png",
		"safe_side.png",
		"safe_side.png",
		"safe_front.png",
	},
	is_ground_content = false,
	groups = { cracky = 1, level = 3 },

        can_dig = function ( pos, player )
		local meta = minetest.get_meta( pos )
		return meta:get_string( "storage" ) == ""	-- allow dig only if safe is empty (and thus unlocked)
        end,
	on_construct = function ( pos )
		local meta = minetest.get_meta( pos )
		meta:get_inventory( ):set_size( "main", 8 * 2 )
		meta:set_string( "infotext", "Unlocked Safe" )
		meta:set_string( "oldtime", os.time( ) )
        end,
	after_place_node = function ( pos, player )
		local player_name = player:get_player_name( )
		minetest.chat_send_player( player_name, "This safe is unlocked. Right-click to set an access code." )
	end,
	on_rightclick = function ( pos, node, clicker )
		local player_name = clicker:get_player_name( )
		local safe_id = minetest.hash_node_position( pos )

		if disabled_safes[ safe_id ] == player_name then
			minetest.chat_send_player( player_name, "This safe has been disabled. Please try again later." )
		else
			open_safe_signin( pos, player_name )
		end
	end,
} )
