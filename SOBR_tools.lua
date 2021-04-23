require "lib.moonloader"
require "vkeys"
local dlstatus = require("moonloader").download_status
local sf = require "lib.sampfuncs"
local config = require 'inicfg'
local inicfg = require 'inicfg'
local encoding = require "lib.encoding"
local SE = require 'samp.events'
local e = require "lib.samp.events"
local ffi = require "ffi"
local memory = require 'memory'
local t_se_au_to_clist, k_r_u_t_o, a_u_t_o_tag, a_u_t_o_screen, m_s_t_a_t, s_kin_i_n_lva, priziv, lwait, svscreen, rusispr, ofeka, pokazatel, sdelaitak = "config/SOBR tools/config.ini"
local sdopolnitelnoe = true
local autoON = true
local marker = nil
local checkpoint = nil
local key = 99 
local shrift = "Segoe UI"
local size = 10 
local flag = 13 
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)

encoding.default = "CP1251"
local UTF8 = encoding.UTF8

local pInfo = {
  Tag = "Tag:",
  cvetclist = "31",
}

local monikQuant = {}

local monikQuantNum = {}

local settings = {}

script_author("Tarasov")
script_name("SOBR tools")
script_version_number(1)
script_description("������ ��� ����")

local cfg = config.load(nil, 'SOBR tools/config.ini')
local SSSDialog = {}
local LVDialog = {}

function onScriptTerminate(script, jopa)
  if (script == thisScript()) then
    config.save(settings, "SOBR tools/config.ini")
  end
end

function main()
  while not isSampAvailable() do wait(100) end
  if cfg == nil then
    local settings = {
      global = {
        Tag = "Tag:",
        cvetclist = "31",
      }
    }
    config.save(settings, 'SOBR tools/config.ini')
  else
    pInfo.Tag = cfg.global.Tag
    k_r_u_t_o = cfg.global.k_r_u_t_o
    t_se_au_to_clist = cfg.global.t_se_au_to_clist
    a_u_t_o_tag = cfg.global.a_u_t_o_tag
    a_u_t_o_screen = cfg.global.a_u_t_o_screen
    m_s_t_a_t = cfg.global.m_s_t_a_t
    s_kin_i_n_lva = cfg.global.s_kin_i_n_lva
    priziv = cfg.global.priziv
    lwait = cfg.global.lwait
    pInfo.lwait = cfg.global.lwait
    rusispr = cfg.global.rusispr
    ofeka = cfg.global.ofeka
    pokazatel = cfg.global.pokazatel
    sdelaitak = cfg.global.sdelaitak
    pInfo.cvetclist = cfg.global.cvetclist
    settings = cfg
    CreateFileAndSettings()
    sampAddChatMessage("[SOBR tools]: ������ ������� ��������.", 0xFFB22222)
  end

    sampRegisterChatCommand("sicmd",function() if settings.global.rusispr == true then sampAddChatMessage("[SOBR tools]: ��������������� ��������� ������ ���������.", 0xFFB22222) settings.global.rusispr = false else sampAddChatMessage("[SOBR tools]: ��������������� ��������� ������ ��������.", 0x33AAFFFF) settings.global.rusispr = true end end)

    sampRegisterChatCommand("supd", goupdate)

    sampRegisterChatCommand("rgetm", rgetm)

	  sampRegisterChatCommand("getm", getm)

    sampRegisterChatCommand("sw", sw)

    sampRegisterChatCommand("st", st)

    sampRegisterChatCommand('cc', cc)

    sampRegisterChatCommand("kv", function(param) if (#param > 1) then letter = param:sub(1,1) number = param:match("%d+") kvadrat1(letter, number) else deleteCheckpoint(marker) removeBlip(checkpoint) end end)
 
    sampRegisterChatCommand("przv",function() if settings.global.priziv == true then sampAddChatMessage("[SOBR tools]: ����� ������� ��������.", 0xFFB22222) settings.global.priziv = false else sampAddChatMessage("[SOBR tools]: ����� ������� �������.", 0x33AAFFFF) settings.global.priziv = true end end)

    sampRegisterChatCommand("splayer",function() if settings.global.sdelaitak == true then sampAddChatMessage("[SOBR tools]: ����������� � ���� ����� ������� ������� ��������� � ���� ������ ���������.", 0xFFB22222) settings.global.sdelaitak = false else sampAddChatMessage("[SOBR tools]: ����������� � ���� ����� ������� ������� ��������� � ���� ������ ��������.", 0x33AAFFFF) settings.global.sdelaitak = true end end)

    sampRegisterChatCommand("pst",function() if settings.global.m_s_t_a_t == true then sampAddChatMessage("[SOBR tools]: ������ � ��� � ������� ������� ���������.", 0xFFB22222) settings.global.m_s_t_a_t = false else  sampAddChatMessage("[SOBR tools]: ������ � ��� � ������� ������� ���������.", 0x33AAFFFF) settings.global.m_s_t_a_t = true end end)

    sampRegisterChatCommand("ascreen",function() if settings.global.a_u_t_o_screen == true then sampAddChatMessage("[SOBR tools]: ��������� ����� ������ ��� ��������.", 0xFFB22222) settings.global.a_u_t_o_screen = false else sampAddChatMessage("[SOBR tools]: ��������� ����� ������ ��� �������.", 0x33AAFFFF) settings.global.a_u_t_o_screen = true end end)

    sampRegisterChatCommand("atag",function() if settings.global.a_u_t_o_tag == true then sampAddChatMessage("[SOBR tools]: ������� � ��� ��� ��������.", 0xFFB22222) settings.global.a_u_t_o_tag = false else sampAddChatMessage("[SOBR tools]: ������� � ��� ��� �������.", 0x33AAFFFF) settings.global.a_u_t_o_tag = true end end)

    sampRegisterChatCommand("lp",function() if settings.global.k_r_u_t_o == true then sampAddChatMessage("[SOBR tools]: ���������� ���� �� ������� `L` ���� ���������.", 0xFFB22222) settings.global.k_r_u_t_o = false else sampAddChatMessage("[SOBR tools]: ���������� ���� �� ������� `L` ���� ��������.", 0x33AAFFFF) settings.global.k_r_u_t_o = true end end)

    sampRegisterChatCommand("aclist",function() if settings.global.t_se_au_to_clist == true then sampAddChatMessage("[SOBR tools]: ��������� ��������.", 0xFFB22222) settings.global.t_se_au_to_clist = false else sampAddChatMessage("[SOBR tools]: ��������� �������.", 0x33AAFFFF) settings.global.t_se_au_to_clist = true end end)

    sampRegisterChatCommand("abp", Settingsabp)

    lua_thread.create(function()
      while true do
        wait(0)
        if wasKeyPressed(VK_MENU) then
          abp()
        end
      end
    end)

    lua_thread.create(function()  
      while true do
        wait(0)
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)  
        if valid and doesCharExist(ped) and isKeyJustPressed(VK_MENU) then  
          local result, id = sampGetPlayerIdByCharHandle(ped)  
          if result and settings.global.pokazatpassport then 
            sampSendChat("/showpass "..id.."") 
          end 
        end 
      end
    end)

    lua_thread.create(function()
      while true do
        wait(0)
        if testCheat("1") and wasKeyPressed(VK_CONTROL) and settings.global.ofeka == true then
          sampSendChat("/r "..pInfo.Tag.." 10-100, ����������� �����.")
          wait(200)
          justPressThisShitPlease(VK_ESCAPE)
        end
      end
    end)

    lua_thread.create(function()
      while true do
        wait(1000)
        local r, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if pizdec == true then
        color = sampGetPlayerColor(id)
        sampAddChatMessage(""..color.."", 0x33AAFFFF)
        end
      end
    end)

    lua_thread.create(function()
      while true do
        wait(1000)
        local r, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if sampGetPlayerColor(id) == 4283536973 and settings.global.cvetclist ~= nil and settings.global.t_se_au_to_clist == true and getCharModel(PLAYER_PED) == 287 or getCharModel(PLAYER_PED) == 191 or getCharModel(PLAYER_PED) == 179 or getCharModel(PLAYER_PED) == 61 or getCharModel(PLAYER_PED) == 255 or getCharModel(PLAYER_PED) == 73 then 
          wait(1000)
          sampSendChat("/clist "..pInfo.cvetclist.."")
        end
      end
    end)

    refreshDialog()

    while getCharHealth(PLAYER_PED) == 200 do wait(0) end

    local r, id = sampGetPlayerIdByCharHandle(PLAYER_PED)

    while true do
      wait(0)
      if isKeyJustPressed(VK_SPACE) and sampIsChatInputActive() and settings.global.a_u_t_o_tag == true and sampGetChatInputText() =="/r " then sampSetChatInputText("/r "..pInfo.Tag.." ") end
      if isKeyJustPressed(VK_SPACE) and sampIsChatInputActive() and settings.global.a_u_t_o_tag == true and sampGetChatInputText() =="/R " then sampSetChatInputText("/R "..pInfo.Tag.." ") end
      if testCheat("PP") then submenus_show(SSSDialog, "{00FA9A}SOBR tools by Tarasov{FFFFFF}") end
      if isKeyJustPressed(VK_L) and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() and k_r_u_t_o then sampSendChat("/lock") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/���" then sampSetChatInputText("/sms") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/�" then sampSetChatInputText("/r") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/�" then sampSetChatInputText("/f") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/��" then sampSetChatInputText("/rb") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/��" then sampSetChatInputText("/fb") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/�" then sampSetChatInputText("/d") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/���" then sampSetChatInputText("/gov") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/������" then sampSetChatInputText("/invite") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/��������" then sampSetChatInputText("/uninvite") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/�������" then sampSetChatInputText("/members") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/����������" then sampSetChatInputText("/offmembers") end 
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/��������" then sampSetChatInputText("/giverank") end 
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/�����������" then sampSetChatInputText("/offgiverank") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/�����" then sampSetChatInputText("/fmute") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/�������" then sampSetChatInputText("/ffixcar") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/�" then sampSetChatInputText("/m") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/���������" then sampSetChatInputText("/warehouse") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/����" then sampSetChatInputText("/carm") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/������" then sampSetChatInputText("/camera") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/���������" then sampSetChatInputText("/cameraoff") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/���" then sampSetChatInputText("/ram") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/��" then sampSetChatInputText("/bl") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/f�" then sampSetChatInputText("/fb") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/r�" then sampSetChatInputText("/rb") end
      if priziv == true and testCheat("Z") then submenus_show(LVDialog, "{00FA9A}������{FFFFFF}") end
      if sampIsChatInputActive() and sampGetChatInputText() == "/cfaq" then sampSetChatInputText("") sampShowDialog(1285, "{808080}[SOBR tools] �������{FFFFFF}", "{808080}/aclist - ���������/�������� ���������\n/lp - ���������/�������� ���������� ���� �� ������� `L`\n/atag - ���������/�������� ����-���\n/ascreen - ���������/�������� ����-����� ����� ������\n/sw, /st - ������� ������� �����/������\n/cc - �������� ���\n/kv - ��������� ����� �� �������\n/getm - �������� ���� ����������, /rgetm - � �����\n/przv - ��������/��������� ����� �������\n/abp - ���������/�������� ����-�� �� `alt`\n/sicmd - ��������/��������� ��������������� ������� ������\n/hphud - ��������/��������� �� ���\n/abp - �������� ��������� ����-��\n/splayer - ��������/��������� ����������� � ���� ����� ������� ������� ��������� � ���� ������{FFFFFF}", "�����", "���������", 0) end
    end
  end

function refreshDialog()
  SSSDialog = {
  
    {
      title = "{FF7F50}��������� ���������{FFFFFF}",
      onclick = function()
        sampSendChat("/r "..pInfo.Tag.." ���������� ��������� � ������� "..kvadrat())
      end
    },
    {
      title = "{DCDCDC}������ �����{FFFFFF}",
      onclick = function()
        if m_s_t_a_t == true then
            sampSendChat("/me ������ ����� �� ������� � ����� �� ����")
            wait(1200)
            sampSendChat("/mask")
            wait(1200)
            sampSendChat("/clist 0")
            wait(1200)
            sampSendChat("/do �� ���� �����. ���� �� �����. ����� ��� ������� � �����.")
        else
            sampSendChat("/me ������� ����� �� ������� � ������ �� ����")
            wait(1200)
            sampSendChat("/mask")
            wait(1200)
            sampSendChat("/clist 0")
            wait(1200)
            sampSendChat("/do �� ���� �����. ���� �� �����. ����� ��� ������� � �����.")
        end
      end
    },
    {
      title = "{B8860B}����������� � �����{FFFFFF}",
      onclick = function()
        sampShowDialog(9999, "����������� ����-��", "{b6b6b6}������� ID ������ �������� ������ �����������", "��", "�������", 1)
        while sampIsDialogActive() do wait(0) end
        local result, button, item, input = sampHasDialogRespond(9999)
        if result and button == 1 then
          local args = split(input, ",")
          if sampIsPlayerConnected(args[1]) then
            sampSendChat("/r "..pInfo.Tag.." "..sampGetPlayerNickname(args[1]):gsub("_", " ").." ���������� � ����.����� ����.")
          else sampShowDialog(9999, "{CD5C5C}SOBR tools |{FFFFFF} ������", "{b6b6b6}������ � ID {B22222}"..args[1].."{b6b6b6} �� ����������.", "����", "��", 0) end
        end      
      end
    },
    {
      title = "{708090}��������������{FFFFFF}",
      submenu = 
      {
        title = "{2F4F4F}�������� ��� ������ �������������{FFFFFF}",
        {
          title = "{708090}�������������� ���������� � ������� ����������{FFFFFF}",
          onclick = function()
            sampSendChat("/me ������(�) ����� ������")
            wait(1200)
            sampSendChat("/me ���������(�) ��� ��������� ����������")
            wait(1200)
            sampSendChat("/do ���������� � ������� ����������.")
            wait(1200)
            sampSendChat("/me ������(�) ��������")
            wait(1200)
            sampSendChat("/me ��������� ����������� ����� �� ������� ����������")
            wait(1200)
            sampSendChat("/me ���������(�) � ��������� ��������� ��������")
            wait(1200)
            sampSendChat("/me ������(�) ������� �� ���������� ������")
            wait(1200)
            sampSendChat("/me ����(�) ����� ������ � ����")
            wait(1200)
            sampSendChat("/me � ������� ������� ������(�) �������")
            wait(1200)
            sampSendChat("/me ������(�) ������������ ��������")
            wait(1200)
            sampSendChat("/me ��������(�) �������� � ���������� �������")
            wait(1200)
            sampSendChat("/do ��������� � �������� ���������.")
            wait(1200)
            sampSendChat("/me ����(�) � ���� �������")
            wait(1200)
            sampSendChat("/me ���������(�) ������")
            wait(1200)
            sampSendChat("/me ������ ����������.")
            wait(1200)
            sampSendChat("/me ����������(�) ���������")
            wait(1200)
            sampSendChat("/me ����(�) ������������� ����")
            wait(1200)
            sampSendChat("/me �������(�) ���������� � ����")
            wait(1200)
            sampSendChat("/me �������(�) ��� ����������� � ����� ������")
            wait(1200)
          end
        },
      }
    },
    {
      title = "{006400}���������{FFFFFF}",
      submenu =
      {
        title = "{9ACD32}���������{FFFFFF}",
        {
          title = "{006400}���:{FFFFFF} "..pInfo.Tag,
          onclick = function()
            sampShowDialog(9999, "���������� ���:", "{b6b6b6}����� ���� ���:", "��", "�������", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              sett9jgs.global.Tag = input
              pInfo.Tag = input
              refreshDialog()
            end
          end
        },
        {
          title = "{006400}���� ����������{FFFFFF} ",
          onclick = function()
            sampShowDialog(9999, "���������:", "{b6b6b6}����� ����� �����:", "��", "�������", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              settings.global.cvetclist = input
              pInfo.cvetclist = input
              refreshDialog()
              onScriptTerminate()
            end
          end
        },
        {
          title = "{9ACD32}���������/�������� ���������� ���������� �� ������� `L`{FFFFFF}",
          onclick = function()
            if settings.global.k_r_u_t_o == true then
              sampAddChatMessage("[SOBR tools]: ���������� ���� �� ������� `L` ���� ���������.", 0xFFB22222)
              settings.global.k_r_u_t_o = false
            else
              sampAddChatMessage("[SOBR tools]: ���������� ���� �� ������� `L` ���� ��������.", 0x33AAFFFF)
              settings.global.k_r_u_t_o = true
            end
          end
        },
        {
          title = "{006400}���������/�������� ����-���{FFFFFF}",
          onclick = function()
            if settings.global.a_u_t_o_tag == true then
              sampAddChatMessage("[SOBR tools]: ������� � ��� ��� ��������.", 0xFFB22222)
              settings.global.a_u_t_o_tag = false
            else
              sampAddChatMessage("[SOBR tools]: ������� � ��� ��� �������.", 0x33AAFFFF)
              settings.global.a_u_t_o_tag = true
            end
          end
        },
        {
          title = "{9ACD32}���������/�������� ��������� ����� ������{FFFFFF}",
          onclick = function()
            if settings.global.a_u_t_o_screen == true then
              sampAddChatMessage("[SOBR tools]: ��������� ����� ������ ��� ��������.", 0xFFB22222)
              settings.global.a_u_t_o_screen = false
              thisScript():reload()
            else
              sampAddChatMessage("[SOBR tools]: ��������� ����� ������ ��� �������.", 0x33AAFFFF)
              settings.global.a_u_t_o_screen = true
              thisScript():reload()
            end
          end
        },
        {
          title = "{9ACD32}���������/�������� ������� `����� �� �������`{FFFFFF}",
          onclick = function()
            if settings.global.ofeka == true then
              sampAddChatMessage("[SOBR tools]: ������� `����� �� �������` ���� ���������.", 0xFFB22222)
              settings.global.ofeka = false
            else
              sampAddChatMessage("[SOBR tools]: ������� `����� �� �������` ���� ��������", 0x33AAFFFF)
              settings.global.ofeka = true
            end
          end
        },
        {
          title = "{9ACD32}���������/�������� ����� �������� �� `Alt + ������ �� ������`{FFFFFF}",
          onclick = function()
            if settings.global.pokazatpassport == true then
              sampAddChatMessage("[SOBR tools]: ������� ������ �������� ���� ���������.", 0xFFB22222)
              settings.global.pokazatpassport = false
            else
              sampAddChatMessage("[SOBR tools]: ������� ������ �������� ���� ��������.", 0x33AAFFFF)
              settings.global.pokazatpassport = true
            end
          end
        },
      }
    },
    {
      title = "{20B2AA}�������� ����������{FFFFFF}",
      onclick = function()
        sampShowDialog(1298, "{808080}[SOBR tools] ��������{FFFFFF}", "{808080}Molly Asad - �������\nAnton Amurov - ����\nLeo Florenso - ����\nVolodya Lipton - ����\nTim Vedenkin - �����\nAdam Walter - �����\nSativa Johnson - ����\nMaksim Azzantroph - ����\nJack Lingard - �����\nAnatoly Morozov - ������\nHoward Harper - ������\nIgor Chabanov - �����\nValentin Molo - ����\nBrain Spencor - ����\nKevin Spencor - ����\nBogdan Nurminski - �������\nAleksey Tarasov - �����\nMaksim Dinosower - ������{FFFFFF}", "��", "�� ��", 0)
      end
    },
  }

  LVDialog = {

    {
      title = "{FF8C00}������/���.������{FFFFFF}",
      submenu = {
        title = "{FFA500}���.������{FFFFFF}",
        {
          title = "{FFA500}����������� � ������� �������� ���������{FFFFFF}",
          onclick = function()
            local _, pID = sampGetPlayerIdByCharHandle(PLAYER_PED)
            if settings.global.m_s_t_a_t == true then
                sampSendChat("�����������, � ��������� ��������� ��������.")
                wait(1600)
                sampSendChat("�������� ���� ��������� � ����������� �����.")
                wait(1600)
                sampSendChat("/b /showpass "..pID.." / /me ������� ���.�����")
            else
                sampSendChat("�����������, � ���������� ��������� ��������.")
                wait(1600)
                sampSendChat("�������� ���� ��������� � ����������� �����.")
                wait(1600)
                sampSendChat("/b /showpass "..pID.." / /me ������� ���.�����")
            end
          end
        },
        {
          title = "{FF8C00}/me ���� �������� � ����� ������� �{FFFFFF}",
          onclick = function()
             sampSendChat("/me ���� �������� � ����� ������� �")
          end
        },
        {
          title = "{FFA500}/todo ������� ��� ������ ���?*������������ ��������{FFFFFF}",
          onclick = function()
             sampSendChat("/todo ������� ��� ������ ���?*������������ ��������")
          end
        },
        {
          title = "{FF8C00}/todo ���, ���������� ��� � ����*������ ��������{FFFFFF}",
          onclick = function()
             sampSendChat("/todo ���, ���������� ��� � ����*������ ��������")
          end
        },
        {
          title = "{FFA500}�������. ��� � ���� ��� �������?{FFFFFF}",
          onclick = function()
             sampSendChat("�������. ��� � ���� ��� �������?")
          end
        },
        {
          title = "{FF8C00}�������, �� ����� ��� ������ � �����{FFFFFF}",
          onclick = function()
             sampSendChat("�������, �� ����� ��� ������ � �����.")
          end
        },
        {
          title = "{FFA500}������� ������� �16 � ��������� � �������� �������{FFFFFF}",
          onclick = function()
             sampSendChat("������� ������� �16 � ��������� � �������� �������.")
          end
        },
        {
          title = "{20B2AA}/r [��� ���]: ��������� � ��������� ID ����� ��� ������ � ����� ����� ������� �������{FFFFFF}",
          onclick = function()
            sampShowDialog(9999, "{CD5C5C}SOBR tools {FFFFFF} :", "{b6b6b6}������� ��.\n�������: {FFFFFF}3", "��", "�������", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              local args = split(input, ",")
                args[1] = args[1]:gsub(" ", "")
                sampSendChat("/r "..pInfo.Tag.." ��������� � ��������� "..args[1].." ����� ��� ������ � �����, ������� ������� �������.")
            end
          end
        },
      }
    },
  }
end

function split(inputstr, sep) if sep == nil then sep = "%s" end local t = {} ; i = 1 for str in string.gmatch(inputstr, "([^"..sep.."]+)") do t[i] = str i = i + 1 end return t end

function e.onPlayerStreamIn(id, _, model)
  if settings.global.sdelaitak == true then
    local name = sampGetPlayerNickname(id)
    if model == 287 or model == 191 or model == 179 or model == 61 or model == 255 or model == 73 then
      sampAddChatMessage("[SOBR tools]: ���� "..name.." �������� � ���� ����������.", 0x33AAFFFF)
    end
  end
end

function submenus_show(menu, caption, select_button, close_button, back_button)
  select_button, close_button, back_button = select_button or '��', close_button or '�� ��', back_button or '�����'
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

function getPassengers()
    local result = {}
    local amount = 0
    if (isCharInAnyCar(PLAYER_PED) == true) then
        local car = storeCarCharIsInNoSave(PLAYER_PED)
        if (getCarModel(car) ~= 431) then
            for i, ped in pairs(getAllChars()) do
                if doesCharExist(ped) then
                    if (PLAYER_PED ~= ped) then
                        local h, id = sampGetPlayerIdByCharHandle(ped)
                        if (sampIsPlayerNpc(id) == false) then
                            if (isCharInAnyCar(ped) == true) then
                                if (storeCarCharIsInNoSave(ped) == car) then
                                    local name = sampGetPlayerNickname(id)
                                    local skin = getCharModel(ped)
                                    table.insert(result, {playername = name, playerid = id, playerskin = skin})
                                    amount = amount + 1
                                end
                            end
                        end
                    end
                end
            end
            return result, amount
        end
    end
    return false
end

function sw(param) local weather = tonumber(param) if weather ~= nil and weather >= 0 and weather <= 45 then forceWeatherNow(weather) sampAddChatMessage("�� ������� ������ ��: "..weather, 0x33AAFFFF) else sampAddChatMessage("�������� �������� ������: �� 0 �� 45.", 0x33AAFFFF) end end

function st(param)
    local hour = tonumber(param)
    if hour ~= nil and hour >= 0 and hour <= 23 then
        time = hour
        patch_samp_time_set(true)
        if time then
            setTimeOfDay(time, 0)
            sampAddChatMessage("�� �������� ����� ��: "..time, 0x33AAFFFF)
        end
    else
        sampAddChatMessage("�������� ������� ������ ���� � ��������� �� 0 �� 23.", 0x33AAFFFF)
        patch_samp_time_set(false)
        time = nil
    end
end

function cc() local memory = require "memory" memory.fill(sampGetChatInfoPtr() + 306, 0x0, 25200) memory.write(sampGetChatInfoPtr() + 306, 25562, 4, 0x0) memory.write(sampGetChatInfoPtr() + 0x63DA, 1, 1) end

function kvadrat1(letter, number)
    deleteCheckpoint(marker)
    removeBlip(checkpoint)
    print(letter)
    local function setMarker(type, x, y, z, radius, color)
        deleteCheckpoint(marker)
        removeBlip(checkpoint)
        checkpoint = addBlipForCoord(x, y, z)
        marker = createCheckpoint(type, x, y, z, 1, 1, 1, radius)
        changeBlipColour(checkpoint, color)
        lua_thread.create(function()
            repeat
                wait(0)
                local x1, y1, z1 = getCharCoordinates(PLAYER_PED)
            until getDistanceBetweenCoords2d(x, y, x1, y1) < radius or not doesBlipExist(checkpoint)
            deleteCheckpoint(marker)
            removeBlip(checkpoint)
            addOneOffSound(0, 0, 0, 1149)
        end)
    end

    number = tonumber(number)
    local letters = {"�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�"}
    local X,Y = 0,0
    for k, val in pairs(letters) do
        if (val == letter) then
            Y = k
        end
    end
    if (Y == 0) then print("Yes") end
    X = math.ceil(number*250-3000)-125
    Y = math.ceil(3000-250*Y)+125 -- s
    setMarker(1, X, Y, 60, 5, 0x00FF00FF)
end

function e.onServerMessage(color, text)
  if (text:find("������ ����� SA")) and settings.global.a_u_t_o_screen == true then
      sampSendChat("/time")
      lua_thread.create(function()
          wait(1234)
          justPressThisShitPlease(VK_F8)
      end)
  end
	if color == 479068104  then
		local id = text:match("%d+")
		sampAddChatMessage(text, sampGetPlayerColor(id))
		return false
  end
end

function justPressThisShitPlease(key) lua_thread.create(function(key) setVirtualKeyDown(key, true) wait(10) setVirtualKeyDown(key, false) end, key) end

function goupdate()
  sampAddChatMessage("���������� ������� ���������.", 0xFFB22222)
  downloadUrlToFile("https://raw.githubusercontent.com/Vladik1234/obnovlenie/master/SOBR_tools.lua", thisScript().path, function(id, status)
    print(status)  
  end)
end

function Search3Dtext(x, y, z, radius, patern)
  local text = ""
  local color = 0
  local posX = 0.0
  local posY = 0.0
  local posZ = 0.0
  local distance = 0.0
  local ignoreWalls = false
  local player = -1
  local vehicle = -1
  local result = false

  for id = 0, 2048 do
      if sampIs3dTextDefined(id) then
          local text2, color2, posX2, posY2, posZ2, distance2, ignoreWalls2, player2, vehicle2 = sampGet3dTextInfoById(id)
          if getDistanceBetweenCoords3d(x, y, z, posX2, posY2, posZ2) < radius then
              if string.len(patern) ~= 0 then
                  if string.match(text2, patern, 0) ~= nil then result = true end
              else
                  result = true
              end
              if result then
                  text = text2
                  color = color2
                  posX = posX2
                  posY = posY2
                  posZ = posZ2
                  distance = distance2
                  ignoreWalls = ignoreWalls2
                  player = player2
                  vehicle = vehicle2
                  radius = getDistanceBetweenCoords3d(x, y, z, posX, posY, posZ)
              end
          end
      end
  end

      return result, text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle
end

function patch_samp_time_set(enable) if enable and default == nil then default = readMemory(sampGetBase() + 0x9C0A0, 4, true) writeMemory(sampGetBase() + 0x9C0A0, 4, 0x000008C2, true) elseif enable == false and default ~= nil then writeMemory(sampGetBase() + 0x9C0A0, 4, default, true) default = nil end end

function rgetm()
	local x,y,z = getCharCoordinates(PLAYER_PED)
	local result, text = Search3Dtext(x,y,z, 700, "�����")
	local temp = split(text, "\n")
	sampAddChatMessage("============= ���������� ============", 0xFFFFFF)
	for k, val in pairs(temp) do monikQuant[k] = val end
	if monikQuant[6] ~= nil then
		for i = 1, table.getn(monikQuant) do
			number1, number2, monikQuantNum[i] = string.match(monikQuant[i],"(%d+)[^%d]+(%d+)[^%d]+(%d+)")
			monikQuantNum[i] = monikQuantNum[i]/1000
		end
    sampSendChat("/r "..pInfo.Tag..": ����������: [LSPD - "..monikQuantNum[1].." | SFPD - "..monikQuantNum[2].." | LVPD - "..monikQuantNum[3].." | SFa - "..monikQuantNum[4].." | FBI - "..monikQuantNum[6].."]")
	end
end

function getm() local x,y,z = getCharCoordinates(PLAYER_PED) local result, text = Search3Dtext(x,y,z, 1000, "FBI") local temp = split(text, "\n") sampAddChatMessage("=============[����������]============", 0xFFFFFF) for k, val in pairs(temp) do sampAddChatMessage(val, 0xFFFFFF) end end

function abp()	
	if sampIsDialogActive() and sampGetCurrentDialogId() == 20053 then
		local idGun = 0
		local countCurrentGun = 0
    local nameKey = ""
    local ini = inicfg.load(nil, "ScriptsArmy/abp.ini")
		while true do
			wait(0)
			
			if tonumber(countCurrentGun) == 0 then
				idGun = idGun + 1
				nameKey = "Slot"..idGun
				countCurrentGun = ini.Settings[nameKey]
			elseif tonumber(countCurrentGun) > 0 then
				sampSendDialogResponse(20053, 1, idGun-1, "")
				countCurrentGun = countCurrentGun - 1
			elseif tonumber(countCurrentGun) == nil then
				countCurrentGun = 0
			end		

			if idGun > 7 then
				break;
			end
		end
		
		wait(500)
		sampCloseCurrentDialogWithButton(0)
		wait(250)
		sampAddChatMessage("[SOBR tools] �������� �������� ����������� ��� ����.", 0xFFB22222)
	end
end

function CloseWindow()
	local notDialog = 0
	
	while true do
		wait(50)
		if sampIsDialogActive() and sampGetCurrentDialogId() == 20054 then
			sampCloseCurrentDialogWithButton(0)
			return
		else
			notDialog = notDialog + 1
			
			if notDialog >= 20 then
				return
			end
    end
	end
end

function Settingsabp()
	stopThread = true
  
  local ini = inicfg.load(nil, "ScriptsArmy/abp.ini")
	local line = {}
	line[1] = "Deagle			"..((ini.Settings["Slot1"] == "0" or ini.Settings["Slot1"] == 0) and "{ff0000}[OFF" or "{59fc30}["..ini.Settings["Slot1"]).."]"			--.."{59fc30}["..ini.Settings["Slot1"].."]"
	line[2] = "Shotgun		"..((ini.Settings["Slot2"] == "0" or ini.Settings["Slot2"] == 0) and "{ff0000}[OFF" or "{59fc30}["..ini.Settings["Slot2"]).."]"
	line[3] = "SMG			"..((ini.Settings["Slot3"] == "0" or ini.Settings["Slot3"] == 0) and "{ff0000}[OFF" or "{59fc30}["..ini.Settings["Slot3"]).."]"
	line[4] = "M4A1			"..((ini.Settings["Slot4"] == "0" or ini.Settings["Slot4"] == 0) and "{ff0000}[OFF" or "{59fc30}["..ini.Settings["Slot4"]).."]"
	line[5] = "Rifle			"..((ini.Settings["Slot5"] == "0" or ini.Settings["Slot5"] == 0) and "{ff0000}[OFF" or "{59fc30}["..ini.Settings["Slot5"]).."]"
	line[6] = "�����			"..((ini.Settings["Slot6"] == "0" or ini.Settings["Slot6"] == 0) and "{ff0000}[OFF]" or "{59fc30}[ON]")
	line[7] = "����. ������	              "..((ini.Settings["Slot7"] == "0" or ini.Settings["Slot7"] == 0) and "{ff0000}[OFF]" or "{59fc30}[ON]")

	local textSettings = ""

	for k,v in pairs(line) do textSettings = textSettings..v.."\n" end

	sampShowDialog(1995, "��������� ����-��", textSettings, "�������", "������", 2)
	
	lua_thread.create(function()
		wait(100)
		stopThread = false
		
		repeat
			wait(0)
			local result, button, list, input = sampHasDialogRespond(1995)
				if result then
					if button == 1 then
						if list < 5 then
							SettingsGun(list)
						elseif list == 5 then
							SettingsBodyArmor(true)
						elseif list == 6 then
							SettingsBodyArmor(false)
						end
					end
				end
		until not sampIsDialogActive() or stopThread
	end)
end	

function SettingsGun(list)
	stopThread = true
	
	local nameGun = ""
  local key = ""
  local ini = inicfg.load(nil, "ScriptsArmy/abp.ini")
	
	if list == 0 then
		nameGun = "Deagle"
	elseif list == 1 then
		nameGun = "Shotgun"
	elseif list == 2 then
		nameGun = "SMG"
	elseif list == 3 then
		nameGun = "M4A1"
	elseif list == 4 then
		nameGun = "Rifle"
	end
	
	key = "Slot"..(list+1)
		
	textHelp = "������� ���������� ���������� "..nameGun..", ������� �������� �����.\n�������� ������ ������ ���� �� 0 �� 2."
	sampShowDialog(1995, "��������� "..nameGun, textHelp, "�������", "������", 1)
	
	lua_thread.create(function()
		wait(100)
		stopThread = false
		
		repeat
			wait(0)
			local result, button, list, input = sampHasDialogRespond(1995)
				if result then
					if button == 1 then
					
						if input == "0" or input == "1" or input == "2" then
							ini.Settings[key] = input
						else 
							input = ini.Settings[key]
						end
						
						ini.Settings[key] = input
						inicfg.save(ini, "ScriptsArmy\\abp.ini")
						Settingsabp()
					end
				end
		until not sampIsDialogActive() or stopThread
	end)
end

function CreateFileAndSettings()
	if not doesDirectoryExist("moonloader\\Config\\ScriptsArmy") then createDirectory("moonloader\\Config\\ScriptsArmy") end
	if not doesFileExist("moonloader\\Config\\ScriptsArmy\\abp.ini") then
	local text = string.format("[Settings]\nSlot1=2\nSlot2=1\nSlot3=1\nSlot4=2\nSlot5=1\nSlot6=1\nSlot7=0\n");
		file = io.open("moonloader\\Config\\ScriptsArmy\\abp.ini", "a")	
		file:write(text)
		file:flush()
		io.close(file)
	end

	local ini = inicfg.load(nil, "ScriptsArmy/abp.ini")
	
	if ini.Settings["Slot1"] == nil then ini.Settings["Slot1"] = "2" end
	if ini.Settings["Slot2"] == nil then ini.Settings["Slot2"] = "1" end
	if ini.Settings["Slot3"] == nil then ini.Settings["Slot3"] = "1" end
	if ini.Settings["Slot4"] == nil then ini.Settings["Slot4"] = "2" end
	if ini.Settings["Slot5"] == nil then ini.Settings["Slot5"] = "1" end
	if ini.Settings["Slot6"] == nil then ini.Settings["Slot6"] = "1" end
	if ini.Settings["Slot7"] == nil then ini.Settings["Slot7"] = "0" end
	
	inicfg.save(ini, "ScriptsArmy/abp.ini")
end

function SettingsBodyArmor(flag)
	stopThread = true
	
  local key = ""
  local ini = inicfg.load(nil, "ScriptsArmy/abp.ini")
	
	if flag then
		key = "Slot6"
	else
		key = "Slot7"
	end
		
	if ini.Settings[key] == "0" or ini.Settings[key] == 0 then
		ini.Settings[key] = "1"
	else
		ini.Settings[key] = "0"
	end
		
	inicfg.save(ini, "ScriptsArmy\\abp.ini")
	Settingsabp()
end

function kvadrat() local KV = { [1] = "�", [2] = "�", [3] = "�", [4] = "�", [5] = "�", [6] = "�", [7] = "�", [8] = "�", [9] = "�", [10] = "�", [11] = "�", [12] = "�", [13] = "�", [14] = "�", [15] = "�", [16] = "�", [17] = "�", [18] = "�", [19] = "�", [20] = "�", [21] = "�", [22] = "�", [23] = "�", [24] = "�", } local X, Y, Z = getCharCoordinates(playerPed) X = math.ceil((X + 3000) / 250) Y = math.ceil((Y * - 1 + 3000) / 250) Y = KV[Y] local KVX = (Y.."-"..X) return KVX end 