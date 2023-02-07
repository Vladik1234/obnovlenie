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
        Tag = "[���.����]"
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
      sampAddChatMessage("[florenso tools]: ������ ��������.", 0x33AAFFFF) 
    else
      sampAddChatMessage("[florenso tools]: ������ �������.", 0x33AAFFFF) 
      settings.global.prizivi = true
    end
  end)

  lua_thread.create(function()
    while true do wait(0)
      if testCheat("OOO") then
        sampShowDialog(9999, "���������� ���:", "{b6b6b6}����� ���� ���:", "��", "�������", 1)
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
        if zvanie == "���������" or zvanie == "��.��������" or zvanie == "��������" or zvanie == "��.��������" or zvanie == "��������" or zvanie == "����������" then
          sampSendChat("/me ������(�) ����� "..zvanie.." ����� ������� �������� �� ������")
          povishka = false
        else
          sampSendChat("/me ������(�) ������ "..zvanie.." ����� ������� �������� �� ������")
        end
      end
    end
  end)

  lua_thread.create(function()
    while true do wait(0)
      if wasKeyPressed(VK_Y) and uvolnenie then
        sampSendChat("/r "..settings.global.Tag.." "..nickuvolennogo.." ������ �� ����� Las-Venturas`a. �������: "..prichina.."")
        wait(1000)
        sampSendChat("/me ������(�) ���, ����� ���� �������(�) ������ ���� "..nickuvolennogo.." ��� �������")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 05 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF) -- ������ ������
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, c������ � 14:15 ��������� ������ � ����� Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����������: ������� 2 ���� ���������� � ����� � ���������� ������� � �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ����� �� GPS 4 - 2. ������ ���� �������� "..text1..".")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 15 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, ������ � ����� Las-Venturas �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����������: ������� 2 ���� ���������� � ����� � ���������� ������� � �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ����� �� GPS 4 - 2. ������ ���� �������� "..text1..".")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 25 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, ������ � ����� Las-Venturas ������������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����������: ������� 2 ���� ���������� � ����� � ���������� ������� � �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ����� �� GPS 4 - 2. ������ ���� �������� "..text1..".")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 35 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, ������ � ����� Las-Venturas ������������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����������: ������� 2 ���� ���������� � ����� � ���������� ������� � �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ����� �� GPS 4 - 2. ������ ���� �������� "..text1..".")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 14 and tonumber(os.date("%M")) == 45 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, ������ � ����� Las-Venturas �������. ��������� ������ � 18:45.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����� ���������, ��� ������� ��������� �� ����������� ������ � ����� Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ���������� �� ����������� ������� �����.")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage("[florenso tools]: ������ ��������. ���� �� ������ ��������� ��������� ������ - �������� ������ ��� ���.", 0x33AAFFFF) 
        end
        if tonumber(os.date("%H")) == 18 and tonumber(os.date("%M")) == 34 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 18 and tonumber(os.date("%M")) == 35 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF) -- ������ ������
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, c������ � 18:45 ��������� ������ � ����� Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����������: ������� 2 ���� ���������� � ����� � ���������� ������� � �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ����� �� GPS 4 - 2. ������ ���� �������� "..text1..".")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 18 and tonumber(os.date("%M")) == 45 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, ������ � ����� Las-Venturas �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����������: ������� 2 ���� ���������� � ����� � ���������� ������� � �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ����� �� GPS 4 - 2. ������ ���� �������� "..text1..".")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 18 and tonumber(os.date("%M")) == 55 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, ������ � ����� Las-Venturas ������������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����������: ������� 2 ���� ���������� � ����� � ���������� ������� � �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ����� �� GPS 4 - 2. ������ ���� �������� "..text1..".")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 19 and tonumber(os.date("%M")) == 05 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, ������ � ����� Las-Venturas ������������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����������: ������� 2 ���� ���������� � ����� � ���������� ������� � �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ����� �� GPS 4 - 2. ������ ���� �������� "..text1..".")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 19 and tonumber(os.date("%M")) == 15 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, ������ � ����� Las-Venturas �������. ��������� ������ � 21:20.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����� ���������, ��� ������� ��������� �� ����������� ������ � ����� Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ���������� �� ����������� ������� �����.")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage("[florenso tools]: ������ ��������. ���� �� ������ ��������� ��������� ������ - �������� ������ ��� ���.", 0x33AAFFFF) 
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 09 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 10 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF) -- ������ ������
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, c������ � 21:20 ��������� ������ � ����� Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����������: ������� 2 ���� ���������� � ����� � ���������� ������� � �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ����� �� GPS 4 - 2. ������ ���� �������� "..text1..".")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 20 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, ������ � ����� Las-Venturas �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����������: ������� 2 ���� ���������� � ����� � ���������� ������� � �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ����� �� GPS 4 - 2. ������ ���� �������� "..text1..".")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 30 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, ������ � ����� Las-Venturas ������������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����������: ������� 2 ���� ���������� � ����� � ���������� ������� � �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ����� �� GPS 4 - 2. ������ ���� �������� "..text1..".")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 40 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, ������ � ����� Las-Venturas ������������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����������: ������� 2 ���� ���������� � ����� � ���������� ������� � �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ����� �� GPS 4 - 2. ������ ���� �������� "..text1..".")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 21 and tonumber(os.date("%M")) == 50 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, ������ � ����� Las-Venturas �������. ��������� ������ � 23:40.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����� ���������, ��� ������� ��������� �� ����������� ������ � ����� Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ���������� �� ����������� ������� �����.")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage("[florenso tools]: ������ ��������. ���� �� ������ ��������� ��������� ������ - �������� ������ ��� ���.", 0x33AAFFFF) 
        end
        if tonumber(os.date("%H")) == 23 and tonumber(os.date("%M")) == 29 and tonumber(os.date("%S")) == 00 then
          wait(500)
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 23 and tonumber(os.date("%M")) == 30 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF) -- �������� ������
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, c������ � 23:40 ��������� ������ � ����� Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����������: ������� 2 ���� ���������� � ����� � ���������� ������� � �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ����� �� GPS 4 - 2. ������ ���� �������� "..text1..".")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 23 and tonumber(os.date("%M")) == 40 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, ������ � ����� Las-Venturas �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����������: ������� 2 ���� ���������� � ����� � ���������� ������� � �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ����� �� GPS 4 - 2. ������ ���� �������� "..text1..".")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 23 and tonumber(os.date("%M")) == 50 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, ������ � ����� Las-Venturas ������������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����������: ������� 2 ���� ���������� � ����� � ���������� ������� � �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ����� �� GPS 4 - 2. ������ ���� �������� "..text1..".")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 00 and tonumber(os.date("%M")) == 00 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, ������ � ����� Las-Venturas ������������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����������: ������� 2 ���� ���������� � ����� � ���������� ������� � �������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ����� �� GPS 4 - 2. ������ ���� �������� "..text1..".")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ����� ������ ������, �� ����� � ���."), 0x33AAFFFF)
        end
        if tonumber(os.date("%H")) == 00 and tonumber(os.date("%M")) == 10 and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF)
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����, ������ � ����� Las-Venturas �������. ��������� ������ � 14:15.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����� ���������, ��� ������� ��������� �� ����������� ������ � ����� Las-Venturas.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ��������� ���������� �� ����������� ������� �����.")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage("[florenso tools]: ������ ��������. ���� �� ������ ��������� ��������� ������ - �������� ������ ��� ���.", 0x33AAFFFF) 
        end
      end
      if settings.global.rejim1 then
        if tonumber(os.date("%H")) == settings.global.hour and tonumber(os.date("%M")) == settings.global.minute and tonumber(os.date("%S")) == 00 then
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF) 
          wait(500)
          sampSendChat(" /d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat(" /gov [Army LV] ��������� ������ �����, �� ������� ����� ������� ��������� �� ����������� ������.")
          wait(5500)
          sampSendChat(" /gov [Army LV] ����������: �� 7 ��� � �����, �� �������� � �� LVA")
          wait(5500)
          sampSendChat(" /gov [Army LV] �� ���������� ��������� �������� ������� �� 500.000$, ��������� ���������� �� ��.������� �����")
          wait(2500)
          sampSendChat(" /d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF) 
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV] ��������� ������ �����, ����������� ������ ����������.")
          wait(5500)
          sampSendChat("/gov [Army LV] ����������� �������� �������� ��� �������, �������� � �� LVA.")
          wait(5500)
          sampSendChat("/gov [Army LV] ����������: �������� ���.��������� � �������� ���������� ��� ����� �� �����.")
          wait(5500)
          sampSendChat("/gov [Army LV] ��������� ������ � �������� "..text1.." � 14:45 . � ��������� "..settings.global.doljnost.." "..name.."")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF) 
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV] ��������� ������ �����, �� ������� ����� ������� ��������� �� ���������� ��������.")
          wait(5500)
          sampSendChat("/gov [Army LV] ����������: �� 2 ��� � �����, �� �������� � �� Las-Venturas Army.")
          wait(5500)
          sampSendChat("/gov [Army LV] �� ���������� ��������� �������� ������� � 2.000.000$, ��������� ���������� �� ��.������� �����")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
          sampAddChatMessage(os.date("[florenso tools]: ������� �������. �� ��������� �����."), 0x33AAFFFF) 
          wait(500)
          sampSendChat("/d OG, ������� ����� ��������������� ��������.")
          wait(2500)
          sampSendChat("/gov [Army LV]: ��������� ������ �����,����������� ����������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: � ��������� ����� Army LV ��������� � �����������.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ����� �������� ������� � 14:15. �������� � 18:45.")
          wait(5500)
          sampSendChat("/gov [Army LV]: ������ � 21:20. ������� � 23:40. � ��������� "..settings.global.doljnost.." "..name.."")
          wait(2500)
          sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
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
      title = "{808080}����������� ������{FFFFFF}",
      submenu = {
        title = "{808080}���������{FFFFFF}",
        {
          title = "{808080}���������� ����� �������{FFFFFF}",
          onclick = function()
            sampShowDialog(1234, "{CD5C5C}florenso tools{FFFFFF}", "{b6b6b6}���������� ����� ������ �������.\n\n�������: {FFFFFF}12:00", "��", "�������", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(1234)
            if result and button == 1 then
              local args = split(input, ":")
                settings.global.hour = args[1]
                settings.global.minute = args[2]
                sampAddChatMessage("[florenso tools]: �� ��������� ������� �� "..settings.global.hour..":"..settings.global.minute..". ����� ��������� � ��� ����� �������������� �������� ����� �������.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: ������������� �������� ����� ������� � ������, ����� �� ���� ����� 2-� �����.", 0x33AAFFFF)
            end
          end
        },
        {
          title = "{808080}����� �������",
          onclick = function()
            if settings.global.rejim1 == true then 
              settings.global.rejim1 = false 
              sampAddChatMessage("[florenso tools]: ����� ������� ��������.", 0x33AAFFFF)
            else
              if settings.global.doljnost ~= nil then
                settings.global.rejim1 = true 
                settings.global.rejim3 = false 
                settings.global.rejim2 = false 
                settings.global.rejim4 = false 
                sampAddChatMessage("[florenso tools]: ����� ������� �������.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: ������� ������� � "..settings.global.hour..":"..settings.global.minute..".", 0x33AAFFFF)
                wait(500)
                thisScript():reload()
              else
                sampAddChatMessage("[florenso tools]: �� �� ���������� ������.", 0x33AAFFFF)
              end
            end
          end
        },
      }
    },
    {
      title = "{808080}�������� (������ �� 14:45){FFFFFF}",
      submenu = {
        title = "{808080}���������{FFFFFF}",
        {
          title = "{808080}���������� ����� �������{FFFFFF}",
          onclick = function()
            sampShowDialog(2245, "{CD5C5C}florenso tools{FFFFFF}", "{b6b6b6}���������� ����� ������ �������.\n\n�������: {FFFFFF}12:00", "��", "�������", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(2245)
            if result and button == 1 then
              local args = split(input, ":")
                settings.global.hour = args[1]
                settings.global.minute = args[2]
                sampAddChatMessage("[florenso tools]: �� ��������� ������� �� "..settings.global.hour..":"..settings.global.minute..". ����� ��������� � ��� ����� �������������� �������� ����� �������.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: ������������� �������� ����� ������� � ������, ����� �� ���� ����� 2-� �����.", 0x33AAFFFF)
            end
          end
        },
        {
          title = "{808080}����� �������",
          onclick = function()
            if settings.global.rejim2 == true then 
              settings.global.rejim2 = false 
              sampAddChatMessage("[florenso tools]: ����� ������� ��������.", 0x33AAFFFF)
            else 
              if settings.global.doljnost ~= nil then
                settings.global.rejim2 = true 
                settings.global.rejim3 = false 
                settings.global.rejim4 = false 
                settings.global.rejim1 = false 
                onScriptTerminate()
                sampAddChatMessage("[florenso tools]: ����� ������� �������.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: ������� ������� � "..settings.global.hour..":"..settings.global.minute..".", 0x33AAFFFF)
                wait(500)
                thisScript():reload()
              else
                sampAddChatMessage("[florenso tools]: �� �� ���������� ������.", 0x33AAFFFF)
              end
            end
          end
        },
      }
    },
    {
      title = "{808080}���������� ��������{FFFFFF}",
      submenu = {
        title = "{808080}���������{FFFFFF}",
        {
          title = "{808080}���������� ����� �������{FFFFFF}",
          onclick = function()
            sampShowDialog(3358, "{CD5C5C}florenso tools{FFFFFF}", "{b6b6b6}���������� ����� ������ �������.\n\n�������: {FFFFFF}12:00", "��", "�������", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(3358)
            if result and button == 1 then
              local args = split(input, ":")
                settings.global.hour = args[1]
                settings.global.minute = args[2]
                sampAddChatMessage("[florenso tools]: �� ��������� ������� �� "..settings.global.hour..":"..settings.global.minute..". ����� ��������� � ��� ����� �������������� �������� ����� �������.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: ������������� �������� ����� ������� � ������, ����� �� ���� ����� 2-� �����.", 0x33AAFFFF)
            end
          end
        },
        {
          title = "{808080}����� �������",
          onclick = function()
            if settings.global.rejim3 == true then 
              settings.global.rejim3 = false 
              sampAddChatMessage("[florenso tools]: ����� ������� ��������.", 0x33AAFFFF)
            else 
              if settings.global.doljnost ~= nil then
                settings.global.rejim3 = true 
                settings.global.rejim4 = false 
                settings.global.rejim2 = false 
                settings.global.rejim1 = false 
                onScriptTerminate()
                sampAddChatMessage("[florenso tools]: ����� ������� �������.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: ������� ������� � "..settings.global.hour..":"..settings.global.minute..".", 0x33AAFFFF)
                wait(500)
                thisScript():reload()
              else
                sampAddChatMessage("[florenso tools]: �� �� ���������� ������.", 0x33AAFFFF)
              end
            end
          end
        },
      }
    },
    {
      title = "{808080}����������{FFFFFF}",
      submenu = {
        title = "{808080}���������{FFFFFF}",
        {
          title = "{808080}���������� ����� �������{FFFFFF}",
          onclick = function()
            sampShowDialog(1275, "{CD5C5C}florenso tools{FFFFFF}", "{b6b6b6}���������� ����� ������ �������.\n\n�������: {FFFFFF}12:00", "��", "�������", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(1275)
            if result and button == 1 then
              local args = split(input, ":")
                settings.global.hour = args[1]
                settings.global.minute = args[2]
                sampAddChatMessage("[florenso tools]: �� ��������� ������� �� "..settings.global.hour..":"..settings.global.minute..". ����� ��������� � ��� ����� �������������� �������� ����� �������.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: ������������� �������� ����� ������� � ������, ����� �� ���� ����� 2-� �����.", 0x33AAFFFF)
            end
          end
        },
        {
          title = "{808080}����� �������",
          onclick = function()
            if settings.global.rejim4 == true then 
              settings.global.rejim4 = false 
              sampAddChatMessage("[florenso tools]: ����� ������� ��������.", 0x33AAFFFF)
            else 
              if settings.global.doljnost ~= nil then
                settings.global.rejim4 = true 
                settings.global.rejim3 = false 
                settings.global.rejim2 = false 
                settings.global.rejim1 = false 
                onScriptTerminate()
                sampAddChatMessage("[florenso tools]: ����� ������� �������.", 0x33AAFFFF)
                wait(1000)
                sampAddChatMessage("[florenso tools]: ������� ������� � "..settings.global.hour..":"..settings.global.minute..".", 0x33AAFFFF)
                wait(500)
                thisScript():reload()
              else
                sampAddChatMessage("[florenso tools]: �� �� ���������� ������.", 0x33AAFFFF)
              end
            end
          end
        },
      }
    },
    {
      title = "{808080}���������� ������ (�����������){FFFFFF}",
      onclick = function()
        sampShowDialog(1234, "{CD5C5C}florenso tools{FFFFFF}", "{b6b6b6}���������� ��� ������\n� ������� �����.\n\n�������: {FFFFFF}�������", "��", "�������", 1)
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
  if (text:find("����� ���������� �� Evolve Role Play")) then
    if settings.global.prizivi == true then
      settings.global.prizivi = false
      sampAddChatMessage("[florenso tools]: ������ ������� ��������. ���� �� ������ ��������� ��������� ������ - �������� ������ ��� ���.", 0x33AAFFFF)
      sampAddChatMessage("[florenso tools]: ��� ���: "..settings.global.Tag.."", 0x33AAFFFF)
    end 
    if settings.global.rejim1 or settings.global.rejim2 or settings.global.rejim3 or settings.global.rejim4 then
      sampAddChatMessage("[florenso tools]: ����� ������� ��������.", 0x33AAFFFF)
      settings.global.rejim4 = false
      settings.global.rejim3 = false 
      settings.global.rejim2 = false 
      settings.global.rejim1 = false 
    end
  end
  if (text:find("�� ���������� (%w+_%w+) �������� � (.*)")) then
    writeInFile("moonloader/invite.txt", text)
  end
  if (text:find("�� ������� (%w+_%w+) �� �����������. �������: (.*)")) then
    writeInFile("moonloader/uninvite.txt", text)
    uvolnenie = true
    lua_thread.create(function()
      if uvolnenie then 
        sampAddChatMessage("[florenso tools]: ������� 'Y' ����� �������� ���������� � �������� � �����", 0x33AAFFFF)
        nickuvolennogo = string.match(text, "(%w+_%w+) .*"):gsub("_", " ")
        prichina = string.match(text, "%w+_%w+ �� �����������. �������: (.*)")
        wait(6000)
        if uvolnenie then uvolnenie = false end
      end
    end)
  end
  if (text:find("�� ��������� (%w+_%w+).*%[(%d+)%]")) then
    writeInFile("moonloader/giverank.txt", text)
    povishka = true
    lua_thread.create(function()
      if povishka then
        sampAddChatMessage("[florenso tools]: ������� 'Y' ����� �������� ������ �����/�����", 0x33AAFFFF)
        zvanie = string.match(text, "%w+_%w+ (.+)%[%d+%]"):gsub("��������", "���������"):gsub("�������", "��������"):gsub("��������", "��������"):gsub("���������", "����������"):gsub("���������", "����������"):gsub("�������", "��������"):gsub("�����", "������"):gsub("������������", "�������������"):gsub("���������", "����������")
        wait(6000)
        if povishka then povishka = false end
      end
    end)
  end
  if (text:find("�������: ����������")) and (text:find("���������: ���")) and prizovniki == true and color == -169954390 then
    sampAddChatMessage("������� 'Y' ����� ������� "..igrok.." � ���", 0x33AAFFFF)
    lua_thread.create(function()
      prizovnik = true
      wait(30000)
      if prizovnik then prizovnik = false end
    end)
  end
end

function submenus_show(menu, caption, select_button, close_button, back_button)
  select_button, close_button, back_button = select_button or '�������', close_button or '�����', back_button or '�����'
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
              sampSendChat("������� �����. ������ �����, �������� ���� ���������.")
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