require "lib.moonloader"
require "vkeys"
local sf = require "lib.sampfuncs"
local events = require("samp.events")
local config = require 'inicfg'
local cfg = config.load(nil, 'florenso_tools/config.ini')
local prizivi = "config/florenso_tools/config.ini"
local settings = {}
local text1 = '"Los-Santos"'
local dlstatus = require("moonloader").download_status
local script_vers = 2
local script_path = thisScript().path
local script_url = "https://raw.githubusercontent.com/Vladik1234/obnovlenie/master/florenso_tools.lua"
local update_path = getWorkingDirectory() .. "/update.ini"
local update_url = "https://raw.githubusercontent.com/Vladik1234/florenso/main/update.ini"

function main()
  while not isSampAvailable() do wait(100) end
  if cfg == nil then
    local settings = {
      global = {
        prizivi = false,
        Tag = "[Ãåí.Øòàá]"
      }
    }
    config.save(settings, 'florenso_tools/config.ini')
  else
    prizivi = cfg.global.prizivi
    Tag = cfg.global.Tag
    igrokId = cfg.global.igrokId
    hour = cfg.global.hour
    minute = cfg.global.minute
    rejim1 = cfg.global.rejim1
    rejim2 = cfg.global.rejim2
    rejim3 = cfg.global.rejim3
    rejim4 = cfg.global.rejim4
    doljnost = cfg.global.doljnost
    settings = cfg
  end

  downloadUrlToFile(update_url, update_path, function(id, status)
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
        updateIni = config.load(nil, update_path)
        if tonumber(updateIni.info.vers) > script_vers then
            sampAddChatMessage("[florenso_tools]: Åñòü îáíîâëåíèå. Âåðñèÿ: " .. updateIni.info.vers_text, 0x33AAFFFF)
            update_state = true
        else
            sampAddChatMessage("[florenso_tools]: Îáíîâëåíèé íå îáíàðóæåíî. Çàãðóæàåì ñòàðóþ âåðñèþ.", 0x33AAFFFF)
        end
    end
  end)

  sampRegisterChatCommand("florenso_tools", function() 
    local _, pID = sampGetPlayerIdByCharHandle(PLAYER_PED)
    name = sampGetPlayerNickname(pID)
    if settings.global.prizivi == true then
      settings.global.prizivi = false 
      sampAddChatMessage("[florenso tools]: Ñêðèïò îòêëþ÷¸í.", 0x33AAFFFF) 
    else
      sampAddChatMessage("[florenso tools]: Ñêðèïò çàïóùåí.", 0x33AAFFFF) 
      settings.global.prizivi = true
    end
  end)

  lua_thread.create(function()
    while true do wait(0)
      if testCheat("OOO") then
        sampShowDialog(9999, "Óñòàíîâèòü òýã:", "{b6b6b6}Ââåäè ñâîé òýã:", "ÎÊ", "Çàêðûòü", 1)
        while sampIsDialogActive() do wait(0) end
        local result, button, item, input = sampHasDialogRespond(9999)
        if result and button == 1 then
          settings.global.Tag = input
        end
      end
    end
  end)

  sampRegisterChatCommand("florenso_invite", getNearestPlayerId)

  lua_thread.create(function()
    while true do wait(0)
      if testCheat("Y") and prizovnik == true then
        sampSendChat("/invite "..settings.global.igrokId.."")
        prizovnik = false
      end
    end
  end)

  lua_thread.create(function()
    while true do wait(0)
      if wasKeyPressed(VK_Y) and povishka == true then
        if zvanie == "Åôðåéòîðà" or zvanie == "Ìë.Ñåðæàíòà" or zvanie == "Ñåðæàíòà" or zvanie == "Ñò.Ñåðæàíòà" or zvanie == "Ñòàðøèíû" or zvanie == "Ïðàïîðùèêà" then
          sampSendChat("/me äîñòàë(à) ëû÷êè "..zvanie.." çàòåì ïåðåäàë ÷åëîâåêó íà ïðîòèâ")
          povishka = false
        else
          sampSendChat("/me äîñòàë(à) ïîãîíû "..zvanie.." çàòåì ïåðåäàë ÷åëîâåêó íà ïðîòèâ")
        end
      end
    end
  end)

  lua_thread.create(function()
    while true do wait(0)
      if wasKeyPressed(VK_Y) and uvolnenie then
        sampSendChat("/r "..settings.global.Tag.." "..nickuvolennogo.." óâîëåí èç àðìèè Las-Venturas`a. Ïðè÷èíà: "..prichina.."")
        wait(1000)
        sampSendChat("/me äîñòàë(à) ÊÏÊ, ïîñëå ÷åãî îòìåòèë(à) ëè÷íîå äåëî "..nickuvolennogo.." êàê «Óâîëåí»")
        uvolnenie = false
      end
    end
  end)

  lua_thread.create(function()
    while true do wait(0)
      local _, pID = sampGetPlayerIdByCharHandle(PLAYER_PED)
      name = sampGetPlayerNickname(pID)
      if testCheat("UJD") then
        submenus_show(LVDialog, "{00FA9A}florenso tools{FFFFFF}")
      end
    end
  end)

  while true do wait(100)
    if update_state then
      downloadUrlToFile(script_url, script_path, function(id, status)
          if status == dlstatus.STATUS_ENDDOWNLOADDATA then
              sampAddChatMessage("[florenso_tools]: Ñêðèïò óñïåøíî îáíîâë¸í.", 0x33AAFFFF)
              thisScript():reload()
          end
      end)
    end
  end

  lua_thread.create(function()
    while true do wait(0)
      local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
      local name = sampGetPlayerNickname(id):gsub("_", " ")
      if settings.global.prizivi == true then
        local timestamp = os.time() 
        local dt1 = os.date( "!*t", timestamp )
        local dt2 = os.date( "*t" , timestamp ) 
        local shift_h  = dt2.hour - dt1.hour +  (dt1.isdst and 1 or 0)
        local shift_m = 100 * (dt2.min  - dt1.min) / 60
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 04 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 05 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF) -- ïåðâûé ïðèçûâ
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, cåãîäíÿ â 14:15 ñîñòîèòñÿ ïðèçûâ â Àðìèþ Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òðåáîâàíèÿ: ìèíèìóì 2 ãîäà ïðîæèâàíèÿ â øòàòå è îòñóòñòâèå ïðîáëåì ñ çàêîíîì.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïðèçûâíîé ïóíêò ïî GPS 4 - 2. Âòîðîé ýòàæ Áîëüíèöû "..text1..".")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 14 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 15 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, ïðèçûâ â Àðìèþ Las-Venturas íà÷àëñÿ.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òðåáîâàíèÿ: ìèíèìóì 2 ãîäà ïðîæèâàíèÿ â øòàòå è îòñóòñòâèå ïðîáëåì ñ çàêîíîì.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïðèçûâíîé ïóíêò ïî GPS 4 - 2. Âòîðîé ýòàæ Áîëüíèöû "..text1..".")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 24 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 25 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, ïðèçûâ â Àðìèþ Las-Venturas ïðîäîëæàåòñÿ.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òðåáîâàíèÿ: ìèíèìóì 2 ãîäà ïðîæèâàíèÿ â øòàòå è îòñóòñòâèå ïðîáëåì ñ çàêîíîì.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïðèçûâíîé ïóíêò ïî GPS 4 - 2. Âòîðîé ýòàæ Áîëüíèöû "..text1..".")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 34 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 35 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, ïðèçûâ â Àðìèþ Las-Venturas ïðîäîëæàåòñÿ.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òðåáîâàíèÿ: ìèíèìóì 2 ãîäà ïðîæèâàíèÿ â øòàòå è îòñóòñòâèå ïðîáëåì ñ çàêîíîì.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïðèçûâíîé ïóíêò ïî GPS 4 - 2. Âòîðîé ýòàæ Áîëüíèöû "..text1..".")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 44 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 45 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, ïðèçûâ â Àðìèþ Las-Venturas îêîí÷åí. Ñëåäóþùèé ïðèçûâ â 18:45.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òàêæå íàïîìèíàþ, ÷òî îòêðûòû çàÿâëåíèÿ íà êîíòðàêòíóþ ñëóæáó â Àðìèþ Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïîäðîáíàÿ èíôîðìàöèÿ íà îôèöèàëüíîì ïîðòàëå àðìèè.")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
          settings.global.prizivi = false
          sampAddChatMessage("[florenso tools]: Ñêðèïò îòêëþ÷¸í. Åñëè âû áóäåòå ïðîâîäèòü ñëåäóþùèé ïðèçûâ - âêëþ÷èòå ñêðèïò åù¸ ðàç.", 0x33AAFFFF) 
        end
        if tonumber(os.date("%H")) == 18 and tonumber(os.date("%M")) == 34 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 18 and tonumber(os.date("%M")) == 35 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF) -- âòîðîé ïðèçûâ
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, cåãîäíÿ â 18:45 ñîñòîèòñÿ ïðèçûâ â Àðìèþ Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òðåáîâàíèÿ: ìèíèìóì 2 ãîäà ïðîæèâàíèÿ â øòàòå è îòñóòñòâèå ïðîáëåì ñ çàêîíîì.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïðèçûâíîé ïóíêò ïî GPS 4 - 2. Âòîðîé ýòàæ Áîëüíèöû "..text1..".")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
        end
        if tonumber(os.date("%H")) == 18 and tonumber(os.date("%M")) == 44 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 18 and tonumber(os.date("%M")) == 45 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, ïðèçûâ â Àðìèþ Las-Venturas íà÷àëñÿ.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òðåáîâàíèÿ: ìèíèìóì 2 ãîäà ïðîæèâàíèÿ â øòàòå è îòñóòñòâèå ïðîáëåì ñ çàêîíîì.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïðèçûâíîé ïóíêò ïî GPS 4 - 2. Âòîðîé ýòàæ Áîëüíèöû "..text1..".")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
        end
        if tonumber(os.date("%H")) == 18 and tonumber(os.date("%M")) == 54 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 18 and tonumber(os.date("%M")) == 55 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, ïðèçûâ â Àðìèþ Las-Venturas ïðîäîëæàåòñÿ.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òðåáîâàíèÿ: ìèíèìóì 2 ãîäà ïðîæèâàíèÿ â øòàòå è îòñóòñòâèå ïðîáëåì ñ çàêîíîì.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïðèçûâíîé ïóíêò ïî GPS 4 - 2. Âòîðîé ýòàæ Áîëüíèöû "..text1..".")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
        end
        if tonumber(os.date("%H")) == 19 and tonumber(os.date("%M")) == 04 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 19 and tonumber(os.date("%M")) == 05 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, ïðèçûâ â Àðìèþ Las-Venturas ïðîäîëæàåòñÿ.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òðåáîâàíèÿ: ìèíèìóì 2 ãîäà ïðîæèâàíèÿ â øòàòå è îòñóòñòâèå ïðîáëåì ñ çàêîíîì.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïðèçûâíîé ïóíêò ïî GPS 4 - 2. Âòîðîé ýòàæ Áîëüíèöû "..text1..".")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
        end
        if tonumber(os.date("%H")) == 19 and tonumber(os.date("%M")) == 14 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 19 and tonumber(os.date("%M")) == 15 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, ïðèçûâ â Àðìèþ Las-Venturas îêîí÷åí. Ñëåäóþùèé ïðèçûâ â 21:20.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òàêæå íàïîìèíàþ, ÷òî îòêðûòû çàÿâëåíèÿ íà êîíòðàêòíóþ ñëóæáó â Àðìèþ Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïîäðîáíàÿ èíôîðìàöèÿ íà îôèöèàëüíîì ïîðòàëå àðìèè.")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
          settings.global.prizivi = false
          sampAddChatMessage("[florenso tools]: Ñêðèïò îòêëþ÷¸í. Åñëè âû áóäåòå ïðîâîäèòü ñëåäóþùèé ïðèçûâ - âêëþ÷èòå ñêðèïò åù¸ ðàç.", 0x33AAFFFF) 
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 09 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 10 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF) -- òðåòèé ïðèçûâ
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, cåãîäíÿ â 21:20 ñîñòîèòñÿ ïðèçûâ â Àðìèþ Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òðåáîâàíèÿ: ìèíèìóì 2 ãîäà ïðîæèâàíèÿ â øòàòå è îòñóòñòâèå ïðîáëåì ñ çàêîíîì.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïðèçûâíîé ïóíêò ïî GPS 4 - 2. Âòîðîé ýòàæ Áîëüíèöû "..text1..".")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 19 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 20 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, ïðèçûâ â Àðìèþ Las-Venturas íà÷àëñÿ.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òðåáîâàíèÿ: ìèíèìóì 2 ãîäà ïðîæèâàíèÿ â øòàòå è îòñóòñòâèå ïðîáëåì ñ çàêîíîì.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïðèçûâíîé ïóíêò ïî GPS 4 - 2. Âòîðîé ýòàæ Áîëüíèöû "..text1..".")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 29 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 30 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, ïðèçûâ â Àðìèþ Las-Venturas ïðîäîëæàåòñÿ.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òðåáîâàíèÿ: ìèíèìóì 2 ãîäà ïðîæèâàíèÿ â øòàòå è îòñóòñòâèå ïðîáëåì ñ çàêîíîì.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïðèçûâíîé ïóíêò ïî GPS 4 - 2. Âòîðîé ýòàæ Áîëüíèöû "..text1..".")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 39 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 40 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, ïðèçûâ â Àðìèþ Las-Venturas ïðîäîëæàåòñÿ.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òðåáîâàíèÿ: ìèíèìóì 2 ãîäà ïðîæèâàíèÿ â øòàòå è îòñóòñòâèå ïðîáëåì ñ çàêîíîì.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïðèçûâíîé ïóíêò ïî GPS 4 - 2. Âòîðîé ýòàæ Áîëüíèöû "..text1..".")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 49 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 50 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, ïðèçûâ â Àðìèþ Las-Venturas îêîí÷åí. Ñëåäóþùèé ïðèçûâ â 23:40.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òàêæå íàïîìèíàþ, ÷òî îòêðûòû çàÿâëåíèÿ íà êîíòðàêòíóþ ñëóæáó â Àðìèþ Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïîäðîáíàÿ èíôîðìàöèÿ íà îôèöèàëüíîì ïîðòàëå àðìèè.")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
          settings.global.prizivi = false
          sampAddChatMessage("[florenso tools]: Ñêðèïò îòêëþ÷¸í. Åñëè âû áóäåòå ïðîâîäèòü ñëåäóþùèé ïðèçûâ - âêëþ÷èòå ñêðèïò åù¸ ðàç.", 0x33AAFFFF) 
        end
        if tonumber(os.date("%H")) == 23 and tonumber(os.date("%M")) == 29 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 23 and tonumber(os.date("%M")) == 30 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF) -- ÷åòâ¸ðòûé ïðèçûâ
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, cåãîäíÿ â 23:40 ñîñòîèòñÿ ïðèçûâ â Àðìèþ Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òðåáîâàíèÿ: ìèíèìóì 2 ãîäà ïðîæèâàíèÿ â øòàòå è îòñóòñòâèå ïðîáëåì ñ çàêîíîì.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïðèçûâíîé ïóíêò ïî GPS 4 - 2. Âòîðîé ýòàæ Áîëüíèöû "..text1..".")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
        end
        if tonumber(os.date("%H")) == 23 and tonumber(os.date("%M")) == 39 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 23 and tonumber(os.date("%M")) == 40 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, ïðèçûâ â Àðìèþ Las-Venturas íà÷àëñÿ.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òðåáîâàíèÿ: ìèíèìóì 2 ãîäà ïðîæèâàíèÿ â øòàòå è îòñóòñòâèå ïðîáëåì ñ çàêîíîì.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïðèçûâíîé ïóíêò ïî GPS 4 - 2. Âòîðîé ýòàæ Áîëüíèöû "..text1..".")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
        end
        if tonumber(os.date("%H")) == 23 and tonumber(os.date("%M")) == 49 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 23 and tonumber(os.date("%M")) == 50 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, ïðèçûâ â Àðìèþ Las-Venturas ïðîäîëæàåòñÿ.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òðåáîâàíèÿ: ìèíèìóì 2 ãîäà ïðîæèâàíèÿ â øòàòå è îòñóòñòâèå ïðîáëåì ñ çàêîíîì.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïðèçûâíîé ïóíêò ïî GPS 4 - 2. Âòîðîé ýòàæ Áîëüíèöû "..text1..".")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
        end
        if tonumber(os.date("%H")) == 23 and tonumber(os.date("%M")) == 59 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 00 and tonumber(os.date("%M")) == 00 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, ïðèçûâ â Àðìèþ Las-Venturas ïðîäîëæàåòñÿ.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òðåáîâàíèÿ: ìèíèìóì 2 ãîäà ïðîæèâàíèÿ â øòàòå è îòñóòñòâèå ïðîáëåì ñ çàêîíîì.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïðèçûâíîé ïóíêò ïî GPS 4 - 2. Âòîðîé ýòàæ Áîëüíèöû "..text1..".")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
        end
        if tonumber(os.date("%H")) == 00 and tonumber(os.date("%M")) == 09 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ×åðåç ìèíóòó âåùàåì, íå óõîäè â àôê."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 00 and tonumber(os.date("%M")) == 10 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà, ïðèçûâ â Àðìèþ Las-Venturas îêîí÷åí. Ñëåäóþùèé ïðèçûâ â 14:15.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Òàêæå íàïîìèíàþ, ÷òî îòêðûòû çàÿâëåíèÿ íà êîíòðàêòíóþ ñëóæáó â Àðìèþ Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ïîäðîáíàÿ èíôîðìàöèÿ íà îôèöèàëüíîì ïîðòàëå àðìèè.")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
          settings.global.prizivi = false
          sampAddChatMessage("[florenso tools]: Ñêðèïò îòêëþ÷¸í. Åñëè âû áóäåòå ïðîâîäèòü ñëåäóþùèé ïðèçûâ - âêëþ÷èòå ñêðèïò åù¸ ðàç.", 0x33AAFFFF) 
        end
      end
      if settings.global.rejim1 then
        if tonumber(os.date("%H")) == settings.global.hour and tonumber(os.date("%M")) == settings.global.minute and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF) 
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV] Óâàæàåìûå æèòåëè øòàòà, íà ïîðòàëå àðìèè îòêðûòû çàÿâëåíèÿ íà êîíòðàêòíóþ ñëóæáó.")
          wait(5500)
          sampSendChat("/gov [Army LV] Òðåáîâàíèÿ: îò 7 ëåò â øòàòå, íå ñîñòîÿòü â ×Ñ LVA")
          wait(5500)
          sampSendChat("/gov [Army LV] Çà çàâåðøåíèå êîíòðàêòà äåíåæíûå âûïëàòû äî 500.000$, ïîäðîáíàÿ èíôîðìàöèÿ íà îô.ïîðòàëå àðìèè")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
          settings.global.rejim1 = false
        end
      end
      if settings.global.rejim2 then
        if tonumber(os.date("%H")) == settings.global.hour and tonumber(os.date("%M")) == settings.global.minute and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF) 
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV] Óâàæàåìûå æèòåëè øòàòà, ïðîñëóøàéòå âàæíóþ èíôîðìàöèþ.")
          wait(5500)
          sampSendChat("/gov [Army LV] Îáúÿâëÿåòñÿ âñåîáùàÿ àìíèñòèÿ äëÿ ãðàæäàí, ïîïàâøèõ â ×Ñ LVA.")
          wait(5500)
          sampSendChat("/gov [Army LV] Èñêëþ÷åíèå: ïðîäàâöû ãîñ.èìóùåñòâà è çëîñòíûå íàðóøèòåëè áåç ïðàâà íà âûõîä.")
          wait(5500)
          sampSendChat("/gov [Army LV] Áëèæàéøèé ïðèçûâ â áîëüíèöå "..text1.." â 14:45 . Ñ óâàæåíèåì "..settings.global.doljnost.." "..name.."")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
          settings.global.rejim2 = false
        end
      end
      if settings.global.rejim3 then
        if tonumber(os.date("%H")) == settings.global.hour and tonumber(os.date("%M")) == settings.global.minute and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF) 
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV] Óâàæàåìûå æèòåëè øòàòà, íà ïîðòàëå àðìèè îòêðûòû çàÿâëåíèÿ íà îôèöåðñêèé êîíòðàêò.")
          wait(5500)
          sampSendChat("/gov [Army LV] Òðåáîâàíèÿ: îò 2 ëåò â øòàòå, íå ñîñòîÿòü â ×Ñ Las-Venturas Army.")
          wait(5500)
          sampSendChat("/gov [Army LV] Çà çàâåðøåíèå êîíòðàêòà äåíåæíûå âûïëàòû â 2.000.000$, ïîäðîáíàÿ èíôîðìàöèÿ íà îô.ïîðòàëå àðìèè")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
          settings.global.rejim3 = false
        end
      end
      if settings.global.rejim4 then
        if tonumber(os.date("%H")) == settings.global.hour and tonumber(os.date("%M")) == settings.global.minute and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Íà÷èíàþ âåùàíèå. Íå ïîëüçóéñÿ ÷àòîì."), 0x33AAFFFF) 
          wait(500)
          sampSendChat("/d OG, çàíèìàþ âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Óâàæàåìûå æèòåëè øòàòà,ïðîñëóøàéòå îáúÿâëåíèå.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Â Íàñòîÿùåå âðåìÿ Army LV íóæäàåòñÿ â ïðèçûâíèêàõ.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Âðåìÿ ïðèçûâîâ Äíåâíîé â 14:15. Âå÷åðíèé â 18:45.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Íî÷íîé â 21:20. Êðàéíèé â 23:40. Ñ óâàæåíèåì "..settings.global.doljnost.." "..name.."")
          wait(2500)
          sampSendChat("/d OG, îñâîáîäèë âîëíó ãîñóäàðñòâåííûõ íîâîñòåé.")
          wait(1000)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 20")
          justPressThisShitPlease(VK_RETURN)
          wait(500)
          sampSendChat("/time 1")
          wait(500)
          justPressThisShitPlease(VK_F8)
          wait(500)
          justPressThisShitPlease(VK_F6)
          sampSetChatInputText("/pagesize 11")
          justPressThisShitPlease(VK_RETURN)
          settings.global.rejim4 = false
        end
      end
    end
  end)

  refreshDialog()

end

function refreshDialog()
  LVDialog = {

    {
      title = "{808080}Êîíòðàêòíàÿ ñëóæáà{FFFFFF}",
      submenu = {
        title = "{808080}Íàñòðîéêè{FFFFFF}",
        {
          title = "{808080}Óñòàíîâèòü âðåìÿ âåùàíèÿ{FFFFFF}",
          onclick = function()
            sampShowDialog(1234, "{CD5C5C}florenso tools{FFFFFF}", "{b6b6b6}Óñòàíîâèòå âðåìÿ íà÷àëà âåùàíèÿ.\n\nÎáðàçåö: {FFFFFF}12:00", "ÎÊ", "Çàêðûòü", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(1234)
            if result and button == 1 then
              local args = split(input, ":")
                settings.global.hour = args[1]
                settings.global.minute = args[2]
                sampAddChatMessage("[florenso tools]: Âû íàçíà÷èëè âåùàíèå íà "..settings.global.hour..":"..settings.global.minute..". ×òîáû ïðîâåùàòü â ýòî âðåìÿ ïðåäâàðèòåëüíî âêëþ÷èòå ðåæèì âåùàíèÿ.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: Ðåêîìåíäóåòñÿ âêëþ÷àòü ðåæèì âåùàíèÿ â ìîìåíò, êîãäà äî íåãî áîëåå 2-õ ìèíóò.", 0x33AAFFFF)
            end
          end
        },
        {
          title = "{808080}Ðåæèì âåùàíèÿ",
          onclick = function()
            if settings.global.rejim1 == true then 
              settings.global.rejim1 = false 
              sampAddChatMessage("[florenso tools]: Ðåæèì âåùàíèÿ âûêëþ÷åí.", 0x33AAFFFF)
            else
              if settings.global.doljnost ~= nil then
                settings.global.rejim1 = true 
                settings.global.rejim3 = false 
                settings.global.rejim2 = false 
                settings.global.rejim4 = false 
                sampAddChatMessage("[florenso tools]: Ðåæèì âåùàíèÿ âêëþ÷åí.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: Âåùàíèå íà÷í¸òñÿ â "..settings.global.hour..":"..settings.global.minute..".", 0x33AAFFFF)
                wait(500)
                thisScript():reload()
              else
                sampAddChatMessage("[florenso tools]: Âû íå óñòàíîâèëè çâàíèå.", 0x33AAFFFF)
              end
            end
          end
        },
      }
    },
    {
      title = "{808080}Àìíèñòèÿ (Âåùàòü äî 14:45){FFFFFF}",
      submenu = {
        title = "{808080}Íàñòðîéêè{FFFFFF}",
        {
          title = "{808080}Óñòàíîâèòü âðåìÿ âåùàíèÿ{FFFFFF}",
          onclick = function()
            sampShowDialog(2245, "{CD5C5C}florenso tools{FFFFFF}", "{b6b6b6}Óñòàíîâèòå âðåìÿ íà÷àëà âåùàíèÿ.\n\nÎáðàçåö: {FFFFFF}12:00", "ÎÊ", "Çàêðûòü", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(2245)
            if result and button == 1 then
              local args = split(input, ":")
                settings.global.hour = args[1]
                settings.global.minute = args[2]
                sampAddChatMessage("[florenso tools]: Âû íàçíà÷èëè âåùàíèå íà "..settings.global.hour..":"..settings.global.minute..". ×òîáû ïðîâåùàòü â ýòî âðåìÿ ïðåäâàðèòåëüíî âêëþ÷èòå ðåæèì âåùàíèÿ.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: Ðåêîìåíäóåòñÿ âêëþ÷àòü ðåæèì âåùàíèÿ â ìîìåíò, êîãäà äî íåãî áîëåå 2-õ ìèíóò.", 0x33AAFFFF)
            end
          end
        },
        {
          title = "{808080}Ðåæèì âåùàíèÿ",
          onclick = function()
            if settings.global.rejim2 == true then 
              settings.global.rejim2 = false 
              sampAddChatMessage("[florenso tools]: Ðåæèì âåùàíèÿ âûêëþ÷åí.", 0x33AAFFFF)
            else 
              if settings.global.doljnost ~= nil then
                settings.global.rejim2 = true 
                settings.global.rejim3 = false 
                settings.global.rejim4 = false 
                settings.global.rejim1 = false 
                onScriptTerminate()
                sampAddChatMessage("[florenso tools]: Ðåæèì âåùàíèÿ âêëþ÷åí.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: Âåùàíèå íà÷í¸òñÿ â "..settings.global.hour..":"..settings.global.minute..".", 0x33AAFFFF)
                wait(500)
                thisScript():reload()
              else
                sampAddChatMessage("[florenso tools]: Âû íå óñòàíîâèëè çâàíèå.", 0x33AAFFFF)
              end
            end
          end
        },
      }
    },
    {
      title = "{808080}Îôèöåðñêèé êîíòðàêò{FFFFFF}",
      submenu = {
        title = "{808080}Íàñòðîéêè{FFFFFF}",
        {
          title = "{808080}Óñòàíîâèòü âðåìÿ âåùàíèÿ{FFFFFF}",
          onclick = function()
            sampShowDialog(3358, "{CD5C5C}florenso tools{FFFFFF}", "{b6b6b6}Óñòàíîâèòå âðåìÿ íà÷àëà âåùàíèÿ.\n\nÎáðàçåö: {FFFFFF}12:00", "ÎÊ", "Çàêðûòü", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(3358)
            if result and button == 1 then
              local args = split(input, ":")
                settings.global.hour = args[1]
                settings.global.minute = args[2]
                sampAddChatMessage("[florenso tools]: Âû íàçíà÷èëè âåùàíèå íà "..settings.global.hour..":"..settings.global.minute..". ×òîáû ïðîâåùàòü â ýòî âðåìÿ ïðåäâàðèòåëüíî âêëþ÷èòå ðåæèì âåùàíèÿ.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: Ðåêîìåíäóåòñÿ âêëþ÷àòü ðåæèì âåùàíèÿ â ìîìåíò, êîãäà äî íåãî áîëåå 2-õ ìèíóò.", 0x33AAFFFF)
            end
          end
        },
        {
          title = "{808080}Ðåæèì âåùàíèÿ",
          onclick = function()
            if settings.global.rejim3 == true then 
              settings.global.rejim3 = false 
              sampAddChatMessage("[florenso tools]: Ðåæèì âåùàíèÿ âûêëþ÷åí.", 0x33AAFFFF)
            else 
              if settings.global.doljnost ~= nil then
                settings.global.rejim3 = true 
                settings.global.rejim4 = false 
                settings.global.rejim2 = false 
                settings.global.rejim1 = false 
                onScriptTerminate()
                sampAddChatMessage("[florenso tools]: Ðåæèì âåùàíèÿ âêëþ÷åí.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: Âåùàíèå íà÷í¸òñÿ â "..settings.global.hour..":"..settings.global.minute..".", 0x33AAFFFF)
                wait(500)
                thisScript():reload()
              else
                sampAddChatMessage("[florenso tools]: Âû íå óñòàíîâèëè çâàíèå.", 0x33AAFFFF)
              end
            end
          end
        },
      }
    },
    {
      title = "{808080}Ïðèçûâíèêè{FFFFFF}",
      submenu = {
        title = "{808080}Íàñòðîéêè{FFFFFF}",
        {
          title = "{808080}Óñòàíîâèòü âðåìÿ âåùàíèÿ{FFFFFF}",
          onclick = function()
            sampShowDialog(1275, "{CD5C5C}florenso tools{FFFFFF}", "{b6b6b6}Óñòàíîâèòå âðåìÿ íà÷àëà âåùàíèÿ.\n\nÎáðàçåö: {FFFFFF}12:00", "ÎÊ", "Çàêðûòü", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(1275)
            if result and button == 1 then
              local args = split(input, ":")
                settings.global.hour = args[1]
                settings.global.minute = args[2]
                sampAddChatMessage("[florenso tools]: Âû íàçíà÷èëè âåùàíèå íà "..settings.global.hour..":"..settings.global.minute..". ×òîáû ïðîâåùàòü â ýòî âðåìÿ ïðåäâàðèòåëüíî âêëþ÷èòå ðåæèì âåùàíèÿ.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: Ðåêîìåíäóåòñÿ âêëþ÷àòü ðåæèì âåùàíèÿ â ìîìåíò, êîãäà äî íåãî áîëåå 2-õ ìèíóò.", 0x33AAFFFF)
            end
          end
        },
        {
          title = "{808080}Ðåæèì âåùàíèÿ",
          onclick = function()
            if settings.global.rejim4 == true then 
              settings.global.rejim4 = false 
              sampAddChatMessage("[florenso tools]: Ðåæèì âåùàíèÿ âûêëþ÷åí.", 0x33AAFFFF)
            else 
              if settings.global.doljnost ~= nil then
                settings.global.rejim4 = true 
                settings.global.rejim3 = false 
                settings.global.rejim2 = false 
                settings.global.rejim1 = false 
                onScriptTerminate()
                sampAddChatMessage("[florenso tools]: Ðåæèì âåùàíèÿ âêëþ÷åí.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: Âåùàíèå íà÷í¸òñÿ â "..settings.global.hour..":"..settings.global.minute..".", 0x33AAFFFF)
                wait(500)
                thisScript():reload()
              else
                sampAddChatMessage("[florenso tools]: Âû íå óñòàíîâèëè çâàíèå.", 0x33AAFFFF)
              end
            end
          end
        },
      }
    },
    {
      title = "{808080}Óñòàíîâèòü çâàíèå (ÎÁßÇÀÒÅËÜÍÎ){FFFFFF}",
      onclick = function()
        sampShowDialog(1234, "{CD5C5C}florenso tools{FFFFFF}", "{b6b6b6}Óñòàíîâèòå ñâî¸ çâàíèå\nñ áîëüøîé áóêâû.\n\nÎáðàçåö: {FFFFFF}Ãåíåðàë", "ÎÊ", "Çàêðûòü", 1)
        while sampIsDialogActive() do wait(0) end
        local result, button, item, input = sampHasDialogRespond(1234)
        if result and button == 1 then
          settings.global.doljnost = input
        end
      end
    },
  }
end

function split(inputstr, sep) 
  if sep == nil then 
    sep = "%s" 
  end 
  local t = {} ; i = 1 
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do 
    t[i] = str i = i + 1 
  end 
  return t 
end

function justPressThisShitPlease(key) 
  lua_thread.create(function(key) 
    setVirtualKeyDown(key, true) 
    wait(10) 
    setVirtualKeyDown(key, false) end, key) 
end

function events.onServerMessage(color, text)
  if (text:find("Äîáðî ïîæàëîâàòü íà Evolve Role Play")) then
    if settings.global.prizivi == true then
      settings.global.prizivi = false
      sampAddChatMessage("[florenso tools]: Ñêðèïò ïðèçûâà îòêëþ÷¸í. Åñëè âû áóäåòå ïðîâîäèòü ñëåäóþùèé ïðèçûâ - âêëþ÷èòå ñêðèïò åù¸ ðàç.", 0x33AAFFFF)
      sampAddChatMessage("[florenso tools]: Âàø òýã: "..settings.global.Tag.."", 0x33AAFFFF)
    end 
    if settings.global.rejim1 or settings.global.rejim2 or settings.global.rejim3 or settings.global.rejim4 then
      sampAddChatMessage("[florenso tools]: Ðåæèì âåùàíèÿ îòêëþ÷¸í.", 0x33AAFFFF)
      settings.global.rejim4 = false
      settings.global.rejim3 = false 
      settings.global.rejim2 = false 
      settings.global.rejim1 = false 
    end
  end
  if (text:find("Âû ïðåäëîæèëè (%w+_%w+) âñòóïèòü â (.*)")) then
    writeInFile("moonloader/invite.txt", text)
  end
  if (text:find("Âû âûãíàëè (%w+_%w+) èç îðãàíèçàöèè. Ïðè÷èíà: (.*)")) then
    writeInFile("moonloader/uninvite.txt", text)
    uvolnenie = true
    lua_thread.create(function()
      if uvolnenie then 
        sampAddChatMessage("[florenso tools]: Íàæìèòå 'Y' ÷òîáû îòûãðàòü óâîëüíåíèå è îáüÿâèòü â ðàöèþ", 0x33AAFFFF)
        nickuvolennogo = string.match(text, "(%w+_%w+) .*"):gsub("_", " ")
        prichina = string.match(text, "%w+_%w+ èç îðãàíèçàöèè. Ïðè÷èíà: (.*)")
        wait(6000)
        if uvolnenie then uvolnenie = false end
      end
    end)
  end
  if (text:find("Âû íàçíà÷èëè (%w+_%w+).*%[(%d+)%]")) then
    writeInFile("moonloader/giverank.txt", text)
    povishka = true
    lua_thread.create(function()
      if povishka then
        sampAddChatMessage("[florenso tools]: Íàæìèòå 'Y' ÷òîáû îòûãðàòü âûäà÷ó ëû÷åê/ïîãîí", 0x33AAFFFF)
        zvanie = string.match(text, "%w+_%w+ (.+)%[%d+%]"):gsub("Åôðåéòîð", "Åôðåéòîðà"):gsub("Ñåðæàíò", "Ñåðæàíòà"):gsub("Ñòàðøèíà", "Ñòàðøèíû"):gsub("Ïðàïîðùèê", "Ïðàïîðùèêà"):gsub("Ëåéòåíàíò", "Ëåéòåíàíòà"):gsub("Êàïèòàí", "Êàïèòàíà"):gsub("Ìàéîð", "Ìàéîðà"):gsub("Ïîäïîëêîâíèê", "Ïîäïîëêîâíèêà"):gsub("Ïîëêîâíèê", "Ïîëêîâíèêà")
        wait(6000)
        if povishka then povishka = false end
      end
    end)
  end
  if (text:find("Ôðàêöèÿ: Íåèçâåñòíî")) and (text:find("Äîëæíîñòü: Íåò")) and prizovniki == true and color == -169954390 then
    sampAddChatMessage("Íàæìèòå 'Y' ÷òîáû ïðèíÿòü "..igrok.." â ËÂÀ", 0x33AAFFFF)
    lua_thread.create(function()
      prizovnik = true
      wait(30000)
      if prizovnik then prizovnik = false end
    end)
  end
end

function submenus_show(menu, caption, select_button, close_button, back_button)
  select_button, close_button, back_button = select_button or 'Âûáðàòü', close_button or 'Âûéòè', back_button or 'Íàçàä'
  prev_menus = {}
  function display(menu, id, caption)
    local string_list = {}
    for i, v in ipairs(menu) do
      table.insert(string_list, type(v.submenu) == 'table' and v.title or v.title)
    end
    sampShowDialog(id, caption, table.concat(string_list, '\n'), select_button, (#prev_menus > 0) and back_button or close_button, sf.DIALOG_STYLE_LIST)
    repeat
      wait(0)
      local result, button, list = sampHasDialogRespond(id)
      if result then
        if button == 1 and list ~= -1 then
          local item = menu[list + 1]
          if type(item.submenu) == 'table' then -- submenu
            table.insert(prev_menus, {menu = menu, caption = caption})
            if type(item.onclick) == 'function' then
              item.onclick(menu, list + 1, item.submenu)
            end
            return display(item.submenu, id + 1, item.submenu.title and item.submenu.title or item.title)
          elseif type(item.onclick) == 'function' then
            local result = item.onclick(menu, list + 1)
            if not result then return result end
            return display(menu, id, caption)
          end
        else -- if button == 0
          if #prev_menus > 0 then
            local prev_menu = prev_menus[#prev_menus]
            prev_menus[#prev_menus] = nil
            return display(prev_menu.menu, id - 1, prev_menu.caption)
          end
          return false
        end
      end
    until result
  end
  return display(menu, 31337, caption or menu.title)
end

function getNearestPlayerId()
  if settings.global.prizivi == true then
    lua_thread.create(function()
      local min = 9999
      local minPed = nil
      local x, y, z = getCharCoordinates(PLAYER_PED)
        for _, ped in pairs(getAllChars()) do
            if (doesCharExist(ped)) and (PLAYER_PED ~= ped) then
                local px, py, pz = getCharCoordinates(ped)
                local dist = getDistanceBetweenCoords3d(x, y, z, px, py, pz)
                if (dist < min) then
                    min = dist
                    minPed = ped
                end
            end
        end 
        if (minPed ~= nil) then
          if (doesCharExist(minPed)) then
            local result, playerid = sampGetPlayerIdByCharHandle(minPed)
            if result and not isCharInAnyCar(minPed) and sampGetPlayerColor(playerid) == 4294942134 then
              local _, pID = sampGetPlayerIdByCharHandle(PLAYER_PED)
              sampSendChat("Çäðàâèÿ æåëàþ. Áóäüòå äîáðû, ïîêàæèòå Âàøè äîêóìåíòû.")
              wait(1000)
              sampSendChat("/b /showpass "..pID.."")
              prizovniki = true
              settings.global.igrokId = playerid
              name = sampGetPlayerNickname(playerid)
              igrok = name
              wait(40000)
              if prizovniki then prizovniki = false end
            end
          end
        end
    end)
  end
end

function writeInFile(path, message)
  local file = io.open(path, 'a')
  if (file == nil) then
    file = io.open(path, 'w')
  end
  file:write(message.."\n")
  file:close()
end

function onScriptTerminate(script)
  if (script == thisScript()) then
    config.save(settings, "florenso_tools/config.ini")
  end
end
