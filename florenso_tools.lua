require "lib.moonloader"
require "vkeys"
local sf = require "lib.sampfuncs"
local events = require("samp.events")
local config = require 'inicfg'
local cfg = config.load(nil, 'florenso_tools/config.ini')
local prizivi = "config/florenso_tools/config.ini"
local settings = {}
local text1 = '"Los-Santos"'

function main()
  while not isSampAvailable() do wait(100) end
  if cfg == nil then
    local settings = {
      global = {
        prizivi = false,
        Tag = "[Ген.Штаб]"
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

  sampRegisterChatCommand("florenso_tools", function() 
    local _, pID = sampGetPlayerIdByCharHandle(PLAYER_PED)
    name = sampGetPlayerNickname(pID)
    if settings.global.prizivi == true then
      settings.global.prizivi = false 
      sampAddChatMessage("[florenso tools]: Скрипт отключён.", 0x33AAFFFF) 
    else
      sampAddChatMessage("[florenso tools]: Скрипт запущен.", 0x33AAFFFF) 
      settings.global.prizivi = true
    end
  end)

  lua_thread.create(function()
    while true do wait(0)
      if testCheat("OOO") then
        sampShowDialog(9999, "Установить тэг:", "{b6b6b6}Введи свой тэг:", "ОК", "Закрыть", 1)
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
        if zvanie == "Ефрейтора" or zvanie == "Мл.Сержанта" or zvanie == "Сержанта" or zvanie == "Ст.Сержанта" or zvanie == "Старшины" or zvanie == "Прапорщика" then
          sampSendChat("/me достал(а) лычки "..zvanie.." затем передал человеку на против")
          povishka = false
        else
          sampSendChat("/me достал(а) погоны "..zvanie.." затем передал человеку на против")
        end
      end
    end
  end)

  lua_thread.create(function()
    while true do wait(0)
      if wasKeyPressed(VK_Y) and uvolnenie then
        sampSendChat("/r "..settings.global.Tag.." "..nickuvolennogo.." уволен из армии Las-Venturas`a. Причина: "..prichina.."")
        wait(1000)
        sampSendChat("/me достал(а) КПК, после чего отметил(а) личное дело "..nickuvolennogo.." как «Уволен»")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 05 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF) -- первый призыв
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, cегодня в 14:15 состоится призыв в Армию Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Требования: минимум 2 года проживания в штате и отсутствие проблем с законом.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Призывной пункт по GPS 4 - 2. Второй этаж Больницы "..text1..".")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 15 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, призыв в Армию Las-Venturas начался.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Требования: минимум 2 года проживания в штате и отсутствие проблем с законом.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Призывной пункт по GPS 4 - 2. Второй этаж Больницы "..text1..".")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 25 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, призыв в Армию Las-Venturas продолжается.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Требования: минимум 2 года проживания в штате и отсутствие проблем с законом.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Призывной пункт по GPS 4 - 2. Второй этаж Больницы "..text1..".")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 35 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, призыв в Армию Las-Venturas продолжается.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Требования: минимум 2 года проживания в штате и отсутствие проблем с законом.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Призывной пункт по GPS 4 - 2. Второй этаж Больницы "..text1..".")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 45 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, призыв в Армию Las-Venturas окончен. Следующий призыв в 18:45.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Также напоминаю, что открыты заявления на контрактную службу в Армию Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Подробная информация на официальном портале армии.")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage("[florenso tools]: Скрипт отключён. Если вы будете проводить следующий призыв - включите скрипт ещё раз.", 0x33AAFFFF) 
        end
        if tonumber(os.date("%H")) == 18 and tonumber(os.date("%M")) == 34 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 18 and tonumber(os.date("%M")) == 35 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF) -- второй призыв
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, cегодня в 18:45 состоится призыв в Армию Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Требования: минимум 2 года проживания в штате и отсутствие проблем с законом.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Призывной пункт по GPS 4 - 2. Второй этаж Больницы "..text1..".")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 18 and tonumber(os.date("%M")) == 45 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, призыв в Армию Las-Venturas начался.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Требования: минимум 2 года проживания в штате и отсутствие проблем с законом.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Призывной пункт по GPS 4 - 2. Второй этаж Больницы "..text1..".")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 18 and tonumber(os.date("%M")) == 55 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, призыв в Армию Las-Venturas продолжается.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Требования: минимум 2 года проживания в штате и отсутствие проблем с законом.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Призывной пункт по GPS 4 - 2. Второй этаж Больницы "..text1..".")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 19 and tonumber(os.date("%M")) == 05 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, призыв в Армию Las-Venturas продолжается.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Требования: минимум 2 года проживания в штате и отсутствие проблем с законом.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Призывной пункт по GPS 4 - 2. Второй этаж Больницы "..text1..".")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 19 and tonumber(os.date("%M")) == 15 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, призыв в Армию Las-Venturas окончен. Следующий призыв в 21:20.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Также напоминаю, что открыты заявления на контрактную службу в Армию Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Подробная информация на официальном портале армии.")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage("[florenso tools]: Скрипт отключён. Если вы будете проводить следующий призыв - включите скрипт ещё раз.", 0x33AAFFFF) 
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 09 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 10 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF) -- третий призыв
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, cегодня в 21:20 состоится призыв в Армию Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Требования: минимум 2 года проживания в штате и отсутствие проблем с законом.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Призывной пункт по GPS 4 - 2. Второй этаж Больницы "..text1..".")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 20 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, призыв в Армию Las-Venturas начался.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Требования: минимум 2 года проживания в штате и отсутствие проблем с законом.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Призывной пункт по GPS 4 - 2. Второй этаж Больницы "..text1..".")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 30 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, призыв в Армию Las-Venturas продолжается.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Требования: минимум 2 года проживания в штате и отсутствие проблем с законом.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Призывной пункт по GPS 4 - 2. Второй этаж Больницы "..text1..".")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 40 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, призыв в Армию Las-Venturas продолжается.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Требования: минимум 2 года проживания в штате и отсутствие проблем с законом.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Призывной пункт по GPS 4 - 2. Второй этаж Больницы "..text1..".")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 50 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, призыв в Армию Las-Venturas окончен. Следующий призыв в 23:40.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Также напоминаю, что открыты заявления на контрактную службу в Армию Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Подробная информация на официальном портале армии.")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage("[florenso tools]: Скрипт отключён. Если вы будете проводить следующий призыв - включите скрипт ещё раз.", 0x33AAFFFF) 
        end
        if tonumber(os.date("%H")) == 23 and tonumber(os.date("%M")) == 29 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 23 and tonumber(os.date("%M")) == 30 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF) -- четвёртый призыв
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, cегодня в 23:40 состоится призыв в Армию Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Требования: минимум 2 года проживания в штате и отсутствие проблем с законом.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Призывной пункт по GPS 4 - 2. Второй этаж Больницы "..text1..".")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 23 and tonumber(os.date("%M")) == 40 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, призыв в Армию Las-Venturas начался.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Требования: минимум 2 года проживания в штате и отсутствие проблем с законом.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Призывной пункт по GPS 4 - 2. Второй этаж Больницы "..text1..".")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 23 and tonumber(os.date("%M")) == 50 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, призыв в Армию Las-Venturas продолжается.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Требования: минимум 2 года проживания в штате и отсутствие проблем с законом.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Призывной пункт по GPS 4 - 2. Второй этаж Больницы "..text1..".")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 00 and tonumber(os.date("%M")) == 00 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, призыв в Армию Las-Venturas продолжается.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Требования: минимум 2 года проживания в штате и отсутствие проблем с законом.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Призывной пункт по GPS 4 - 2. Второй этаж Больницы "..text1..".")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Через минуту вещаем, не уходи в афк."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 00 and tonumber(os.date("%M")) == 10 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата, призыв в Армию Las-Venturas окончен. Следующий призыв в 14:15.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Также напоминаю, что открыты заявления на контрактную службу в Армию Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Подробная информация на официальном портале армии.")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage("[florenso tools]: Скрипт отключён. Если вы будете проводить следующий призыв - включите скрипт ещё раз.", 0x33AAFFFF) 
        end
      end
      if settings.global.rejim1 then
        if tonumber(os.date("%H")) == settings.global.hour and tonumber(os.date("%M")) == settings.global.minute and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF) 
          wait(500)
          sampSendChat(" /d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat(" /gov [Army LV] Уважаемые жители штата, на портале армии открыты заявления на контрактную службу.")
          wait(5500)
          sampSendChat(" /gov [Army LV] Требования: от 7 лет в штате, не состоять в ЧС LVA")
          wait(5500)
          sampSendChat(" /gov [Army LV] За завершение контракта денежные выплаты до 500.000$, подробная информация на оф.портале армии")
          wait(2500)
          sampSendChat(" /d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF) 
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV] Уважаемые жители штата, прослушайте важную информацию.")
          wait(5500)
          sampSendChat("/gov [Army LV] Объявляется всеобщая амнистия для граждан, попавших в ЧС LVA.")
          wait(5500)
          sampSendChat("/gov [Army LV] Исключение: продавцы гос.имущества и злостные нарушители без права на выход.")
          wait(5500)
          sampSendChat("/gov [Army LV] Ближайший призыв в больнице "..text1.." в 14:45 . С уважением "..settings.global.doljnost.." "..name.."")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF) 
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV] Уважаемые жители штата, на портале армии открыты заявления на офицерский контракт.")
          wait(5500)
          sampSendChat("/gov [Army LV] Требования: от 2 лет в штате, не состоять в ЧС Las-Venturas Army.")
          wait(5500)
          sampSendChat("/gov [Army LV] За завершение контракта денежные выплаты в 2.000.000$, подробная информация на оф.портале армии")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
          sampAddChatMessage(os.date("[florenso tools]: Начинаю вещание. Не пользуйся чатом."), 0x33AAFFFF) 
          wait(500)
          sampSendChat("/d OG, занимаю волну государственных новостей.")
          wait(2500)
          sampSendChat("/gov [Army LV]: Уважаемые жители штата,прослушайте объявление.")
          wait(5500)
          sampSendChat("/gov [Army LV]: В Настоящее время Army LV нуждается в призывниках.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Время призывов Дневной в 14:15. Вечерний в 18:45.")
          wait(5500)
          sampSendChat("/gov [Army LV]: Ночной в 21:20. Крайний в 23:40. С уважением "..settings.global.doljnost.." "..name.."")
          wait(2500)
          sampSendChat("/d OG, освободил волну государственных новостей.")
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
      title = "{808080}Контрактная служба{FFFFFF}",
      submenu = {
        title = "{808080}Настройки{FFFFFF}",
        {
          title = "{808080}Установить время вещания{FFFFFF}",
          onclick = function()
            sampShowDialog(1234, "{CD5C5C}florenso tools{FFFFFF}", "{b6b6b6}Установите время начала вещания.\n\nОбразец: {FFFFFF}12:00", "ОК", "Закрыть", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(1234)
            if result and button == 1 then
              local args = split(input, ":")
                settings.global.hour = args[1]
                settings.global.minute = args[2]
                sampAddChatMessage("[florenso tools]: Вы назначили вещание на "..settings.global.hour..":"..settings.global.minute..". Чтобы провещать в это время предварительно включите режим вещания.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: Рекомендуется включать режим вещания в момент, когда до него более 2-х минут.", 0x33AAFFFF)
            end
          end
        },
        {
          title = "{808080}Режим вещания",
          onclick = function()
            if settings.global.rejim1 == true then 
              settings.global.rejim1 = false 
              sampAddChatMessage("[florenso tools]: Режим вещания выключен.", 0x33AAFFFF)
            else
              if settings.global.doljnost ~= nil then
                settings.global.rejim1 = true 
                settings.global.rejim3 = false 
                settings.global.rejim2 = false 
                settings.global.rejim4 = false 
                sampAddChatMessage("[florenso tools]: Режим вещания включен.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: Вещание начнётся в "..settings.global.hour..":"..settings.global.minute..".", 0x33AAFFFF)
                wait(500)
                thisScript():reload()
              else
                sampAddChatMessage("[florenso tools]: Вы не установили звание.", 0x33AAFFFF)
              end
            end
          end
        },
      }
    },
    {
      title = "{808080}Амнистия (Вещать до 14:45){FFFFFF}",
      submenu = {
        title = "{808080}Настройки{FFFFFF}",
        {
          title = "{808080}Установить время вещания{FFFFFF}",
          onclick = function()
            sampShowDialog(2245, "{CD5C5C}florenso tools{FFFFFF}", "{b6b6b6}Установите время начала вещания.\n\nОбразец: {FFFFFF}12:00", "ОК", "Закрыть", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(2245)
            if result and button == 1 then
              local args = split(input, ":")
                settings.global.hour = args[1]
                settings.global.minute = args[2]
                sampAddChatMessage("[florenso tools]: Вы назначили вещание на "..settings.global.hour..":"..settings.global.minute..". Чтобы провещать в это время предварительно включите режим вещания.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: Рекомендуется включать режим вещания в момент, когда до него более 2-х минут.", 0x33AAFFFF)
            end
          end
        },
        {
          title = "{808080}Режим вещания",
          onclick = function()
            if settings.global.rejim2 == true then 
              settings.global.rejim2 = false 
              sampAddChatMessage("[florenso tools]: Режим вещания выключен.", 0x33AAFFFF)
            else 
              if settings.global.doljnost ~= nil then
                settings.global.rejim2 = true 
                settings.global.rejim3 = false 
                settings.global.rejim4 = false 
                settings.global.rejim1 = false 
                onScriptTerminate()
                sampAddChatMessage("[florenso tools]: Режим вещания включен.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: Вещание начнётся в "..settings.global.hour..":"..settings.global.minute..".", 0x33AAFFFF)
                wait(500)
                thisScript():reload()
              else
                sampAddChatMessage("[florenso tools]: Вы не установили звание.", 0x33AAFFFF)
              end
            end
          end
        },
      }
    },
    {
      title = "{808080}Офицерский контракт{FFFFFF}",
      submenu = {
        title = "{808080}Настройки{FFFFFF}",
        {
          title = "{808080}Установить время вещания{FFFFFF}",
          onclick = function()
            sampShowDialog(3358, "{CD5C5C}florenso tools{FFFFFF}", "{b6b6b6}Установите время начала вещания.\n\nОбразец: {FFFFFF}12:00", "ОК", "Закрыть", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(3358)
            if result and button == 1 then
              local args = split(input, ":")
                settings.global.hour = args[1]
                settings.global.minute = args[2]
                sampAddChatMessage("[florenso tools]: Вы назначили вещание на "..settings.global.hour..":"..settings.global.minute..". Чтобы провещать в это время предварительно включите режим вещания.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: Рекомендуется включать режим вещания в момент, когда до него более 2-х минут.", 0x33AAFFFF)
            end
          end
        },
        {
          title = "{808080}Режим вещания",
          onclick = function()
            if settings.global.rejim3 == true then 
              settings.global.rejim3 = false 
              sampAddChatMessage("[florenso tools]: Режим вещания выключен.", 0x33AAFFFF)
            else 
              if settings.global.doljnost ~= nil then
                settings.global.rejim3 = true 
                settings.global.rejim4 = false 
                settings.global.rejim2 = false 
                settings.global.rejim1 = false 
                onScriptTerminate()
                sampAddChatMessage("[florenso tools]: Режим вещания включен.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: Вещание начнётся в "..settings.global.hour..":"..settings.global.minute..".", 0x33AAFFFF)
                wait(500)
                thisScript():reload()
              else
                sampAddChatMessage("[florenso tools]: Вы не установили звание.", 0x33AAFFFF)
              end
            end
          end
        },
      }
    },
    {
      title = "{808080}Призывники{FFFFFF}",
      submenu = {
        title = "{808080}Настройки{FFFFFF}",
        {
          title = "{808080}Установить время вещания{FFFFFF}",
          onclick = function()
            sampShowDialog(1275, "{CD5C5C}florenso tools{FFFFFF}", "{b6b6b6}Установите время начала вещания.\n\nОбразец: {FFFFFF}12:00", "ОК", "Закрыть", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(1275)
            if result and button == 1 then
              local args = split(input, ":")
                settings.global.hour = args[1]
                settings.global.minute = args[2]
                sampAddChatMessage("[florenso tools]: Вы назначили вещание на "..settings.global.hour..":"..settings.global.minute..". Чтобы провещать в это время предварительно включите режим вещания.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: Рекомендуется включать режим вещания в момент, когда до него более 2-х минут.", 0x33AAFFFF)
            end
          end
        },
        {
          title = "{808080}Режим вещания",
          onclick = function()
            if settings.global.rejim4 == true then 
              settings.global.rejim4 = false 
              sampAddChatMessage("[florenso tools]: Режим вещания выключен.", 0x33AAFFFF)
            else 
              if settings.global.doljnost ~= nil then
                settings.global.rejim4 = true 
                settings.global.rejim3 = false 
                settings.global.rejim2 = false 
                settings.global.rejim1 = false 
                onScriptTerminate()
                sampAddChatMessage("[florenso tools]: Режим вещания включен.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: Вещание начнётся в "..settings.global.hour..":"..settings.global.minute..".", 0x33AAFFFF)
                wait(500)
                thisScript():reload()
              else
                sampAddChatMessage("[florenso tools]: Вы не установили звание.", 0x33AAFFFF)
              end
            end
          end
        },
      }
    },
    {
      title = "{808080}Установить звание (ОБЯЗАТЕЛЬНО){FFFFFF}",
      onclick = function()
        sampShowDialog(1234, "{CD5C5C}florenso tools{FFFFFF}", "{b6b6b6}Установите своё звание\nс большой буквы.\n\nОбразец: {FFFFFF}Генерал", "ОК", "Закрыть", 1)
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
  if (text:find("Добро пожаловать на Evolve Role Play")) then
    if settings.global.prizivi == true then
      settings.global.prizivi = false
      sampAddChatMessage("[florenso tools]: Скрипт призыва отключён. Если вы будете проводить следующий призыв - включите скрипт ещё раз.", 0x33AAFFFF)
      sampAddChatMessage("[florenso tools]: Ваш тэг: "..settings.global.Tag.."", 0x33AAFFFF)
    end 
    if settings.global.rejim1 or settings.global.rejim2 or settings.global.rejim3 or settings.global.rejim4 then
      sampAddChatMessage("[florenso tools]: Режим вещания отключён.", 0x33AAFFFF)
      settings.global.rejim4 = false
      settings.global.rejim3 = false 
      settings.global.rejim2 = false 
      settings.global.rejim1 = false 
    end
  end
  if (text:find("Вы предложили (%w+_%w+) вступить в (.*)")) then
    writeInFile("moonloader/invite.txt", text)
  end
  if (text:find("Вы выгнали (%w+_%w+) из организации. Причина: (.*)")) then
    writeInFile("moonloader/uninvite.txt", text)
    uvolnenie = true
    lua_thread.create(function()
      if uvolnenie then 
        sampAddChatMessage("[florenso tools]: Нажмите 'Y' чтобы отыграть увольнение и обьявить в рацию", 0x33AAFFFF)
        nickuvolennogo = string.match(text, "(%w+_%w+) .*"):gsub("_", " ")
        prichina = string.match(text, "%w+_%w+ из организации. Причина: (.*)")
        wait(6000)
        if uvolnenie then uvolnenie = false end
      end
    end)
  end
  if (text:find("Вы назначили (%w+_%w+).*%[(%d+)%]")) then
    writeInFile("moonloader/giverank.txt", text)
    povishka = true
    lua_thread.create(function()
      if povishka then
        sampAddChatMessage("[florenso tools]: Нажмите 'Y' чтобы отыграть выдачу лычек/погон", 0x33AAFFFF)
        zvanie = string.match(text, "%w+_%w+ (.+)%[%d+%]"):gsub("Ефрейтор", "Ефрейтора"):gsub("Сержант", "Сержанта"):gsub("Старшина", "Старшины"):gsub("Прапорщик", "Прапорщика"):gsub("Лейтенант", "Лейтенанта"):gsub("Капитан", "Капитана"):gsub("Майор", "Майора"):gsub("Подполковник", "Подполковника"):gsub("Полковник", "Полковника")
        wait(6000)
        if povishka then povishka = false end
      end
    end)
  end
  if (text:find("Фракция: Неизвестно")) and (text:find("Должность: Нет")) and prizovniki == true and color == -169954390 then
    sampAddChatMessage("Нажмите 'Y' чтобы принять "..igrok.." в ЛВА", 0x33AAFFFF)
    lua_thread.create(function()
      prizovnik = true
      wait(30000)
      if prizovnik then prizovnik = false end
    end)
  end
end

function submenus_show(menu, caption, select_button, close_button, back_button)
  select_button, close_button, back_button = select_button or 'Выбрать', close_button or 'Выйти', back_button or 'Назад'
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
              sampSendChat("Здравия желаю. Будьте добры, покажите Ваши документы.")
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