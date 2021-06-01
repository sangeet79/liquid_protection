minetest.register_privilege( "liquids", "Can spill flowing liquids at any depth.")

local LIQUID_PLACE_LEVEL = 0

function override_on_place(item_name)
	local def = minetest.registered_items[item_name]
	local old_on_place = def.on_place

	def.on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack -- No placement
		end
		if pointed_thing.above.y <= LIQUID_PLACE_LEVEL
				or minetest.check_player_privs(placer, "liquids") then
			-- OK
			return old_on_place(itemstack, placer, pointed_thing)
		end
		-- Prevent placement
		local player_name = placer:get_player_name()
		minetest.chat_send_player(player_name,
			"You are not allowed to place flowing liquids above " .. LIQUID_PLACE_LEVEL .. "!")
		minetest.log("action", player_name .. " tried to place some flowing liquid above " .. LIQUID_PLACE_LEVEL)
		return itemstack
	end
end

override_on_place("bucket:bucket_lava")
override_on_place("default:lava_source")
override_on_place("bucket:bucket_water")
override_on_place("default:water_source")
