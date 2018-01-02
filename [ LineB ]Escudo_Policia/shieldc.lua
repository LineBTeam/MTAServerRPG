-- cria o escudo / troca o modelo 
function clientshieldstarter( theResource )
	if ( theResource == getThisResource() ) then
		local txd_shield = engineLoadTXD("riot_shield.txd")
		engineImportTXD(txd_shield,1631)
		local col_shield = engineLoadCOL("riot_shield.col")
		local dff_shield = engineLoadDFF("riot_shield.dff", 1631 )
		engineReplaceCOL(col_shield,1631)
		engineReplaceModel(dff_shield,1631)
	end
end
addEventHandler("onClientResourceStart", root, clientshieldstarter)

function shieldingyet ()
if (getTeamName(getPlayerTeam( localPlayer )) == "Police") then
	local currenttask = getPedSimplestTask (localPlayer)
	if shieldon ~= 1 then
		if currenttask == "TASK_SIMPLE_PLAYER_ON_FOOT" and getControlState("jump") == true and getControlState("aim_weapon") == true then
			currentweapon = getPedWeapon (localPlayer)
			shieldon = 1
			triggerServerEvent ("shieldup", localPlayer, localPlayer )
		end
	elseif shieldon == 1 then
		if currenttask ~= "TASK_SIMPLE_PLAYER_ON_FOOT" or getControlState("jump") == false or getControlState("aim_weapon") == false then
			shieldon = 0
			triggerServerEvent ("shielddown", localPlayer, currentweapon )
		end
	end
end
end

function shieldLeggDamageControl ( attacker, weapon, bodypart )
	if ( bodypart == 7 or  bodypart == 8 ) and ( shieldon == 1 ) then
		cancelEvent()
	end
end
addEventHandler ( "onClientPlayerDamage", localPlayer, shieldLeggDamageControl )

function shieldtimer( key, keyState )
	if (getTeamName(getPlayerTeam( localPlayer )) == "Police") then
		local theWeapon = getPedWeapon (localPlayer)
		if ( theWeapon == 3 ) then
			if keyState == "down" then
				blockcheck = setTimer ( shieldingyet, 300, 0, localPlayer )
			else
				if blockcheck then
					killTimer(blockcheck)
					blockcheck = nil
					if shieldon == 1 then
						shieldon = 0
						triggerServerEvent ("shielddown", localPlayer, currentweapon )
					end
				end
			end
		end
	end
end
bindKey ( "jump", "both", shieldtimer )
