require "lib.moonloader"
require "vkeys"
local dlstatus = require("moonloader").download_status
local sf = require "lib.sampfuncs"
local config = require 'inicfg'
local inicfg = require 'inicfg'
local encoding = require "encoding"
local SE = require 'samp.events'
local e = require "lib.samp.events"
local ffi = require "ffi"
local memory = require 'memory'
local textId = nil
local t_se_au_to_clist, k_r_u_t_o, a_u_t_o_tag, a_u_t_o_screen, m_s_t_a_t, s_kin_i_n_lva, priziv, lwait, sdelaitak, pozivnoy = "config/SOBR tools/config.ini"
local sdopolnitelnoe = true
local autoON = true
local marker = nil
local checkpoint = nil
local key = 99 
local shrift = "Segoe UI"
local size = 10 
local flag = 13 
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
local tData = {}
local nData = {}
local bronya = false
Target = {}

encoding.default = "CP1251"
local u8 = encoding.UTF8

local imgui = require "imgui"
local main_window_state = imgui.ImBool(false)
local text_buffer = imgui.ImBuffer(256)

local pInfo = {
  Tag = "�� ������.",
  cvetclist = "�� ������.",
  lwait = "�� �������.",
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

function onScriptTerminate(script)
  if (script == thisScript()) then
    for k, val in pairs(tData) do 
      val:deattachText() 
    end
    config.save(settings, "SOBR tools/config.ini")
  end
  deleteCheckpoint(marker) removeBlip(checkpoint)
end

function main()
  while not isSampAvailable() do wait(100) end
  if cfg == nil then
    local settings = {
      global = {
        Tag = "�� ������.",
        cvetclist = "�� ������.",
        lwait = "�� �������.",
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
    sdelaitak = cfg.global.sdelaitak
    pozivnoy = cfg.global.pozivnoy
    pInfo.cvetclist = cfg.global.cvetclist
    settings = cfg
    CreateFileAndSettings()
  end

  imgui.Process = false

    for _, ped in pairs(getAllChars()) do
      if (doesCharExist(ped) and PLAYER_PED ~= ped) then
        local _, id = sampGetPlayerIdByCharHandle(ped)
        if sampIsPlayerConnected(id) then
          local name = sampGetPlayerNickname(id)
          if (tData[name] ~= nil) and settings.global.pozivnoy == true then
            tData[name].id = id
            tData[name]:attachText()
          end
        end
      end
    end

    sampRegisterChatCommand("fustav", cmd_imgui)

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

    sampRegisterChatCommand("smembers", smembers)

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
        if sampGetPlayerColor(id) == 4283536973 and settings.global.cvetclist ~= nil and settings.global.t_se_au_to_clist == true then 
          if getCharModel(PLAYER_PED) == 287 or getCharModel(PLAYER_PED) == 191 or getCharModel(PLAYER_PED) == 179 or getCharModel(PLAYER_PED) == 61 or getCharModel(PLAYER_PED) == 255 or getCharModel(PLAYER_PED) == 73 then 
            sampSendChat("/clist "..pInfo.cvetclist.."")
          end
        end
      end
    end)

    refreshDialog()

    local r, id = sampGetPlayerIdByCharHandle(PLAYER_PED)

    while true do
      wait(0)
      if isKeyJustPressed(VK_SPACE) and sampIsChatInputActive() and settings.global.a_u_t_o_tag == true and sampGetChatInputText() == "/r " then sampSetChatInputText("/r "..pInfo.Tag.." ") end
      if isKeyJustPressed(VK_SPACE) and sampIsChatInputActive() and settings.global.a_u_t_o_tag == true and sampGetChatInputText() == "/R " then sampSetChatInputText("/R "..pInfo.Tag.." ") end
      if testCheat("PP") then submenus_show(SSSDialog, "{808080}SOBR tools by Tarasov{FFFFFF}") end
      if isKeyJustPressed(VK_L) and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() and settings.global.k_r_u_t_o == true then sampSendChat("/lock") end
      if priziv == true and testCheat("Z") then submenus_show(LVDialog, "{00FA9A}������{FFFFFF}") end
      if main_window_state.v == false then imgui.Process = false end
      if sampIsChatInputActive() and sampGetChatInputText() == "/cfaq" then sampSetChatInputText("") sampShowDialog(1285, "{808080}[SOBR tools] �������{FFFFFF}", "{808080}/aclist - ���������/�������� ���������\n/lp - ���������/�������� ���������� ���� �� ������� `L`\n/atag - ���������/�������� ����-���\n/ascreen - ���������/�������� ����-����� ����� ������\n/sw, /st - ������� ������� �����/������\n/cc - �������� ���\n/kv - ��������� ����� �� �������\n/getm - �������� ���� ����������, /rgetm - � �����\n/przv - ��������/��������� ����� �������\n/abp - ���������/�������� ����-�� �� `alt`\n/hphud - ��������/��������� �� ���\n/abp - �������� ��������� ����-��\n/splayer - ��������/��������� ����������� � ���� ����� ������� ������� ��������� � ���� ������\n/fustav - ���������� �� � �����\n/smembers - ���������� ������ ������{FFFFFF}", "�����", "���������", 0) end
      if testCheat("JJJJJ") then getNearestPlayerId() end
      if isKeyJustPressed(VK_C) and isKeyJustPressed(VK_MULTIPLY) then getNearestPlayerId1() end
      if wasKeyPressed(VK_MENU) then abp() end
      nyamnyam()
    end
  end

function refreshDialog()
  SSSDialog = {
  
    {
      title = "{808080}��������� ���������{FFFFFF}",
      onclick = function()
        sampSendChat("/r "..pInfo.Tag.." ���������� ��������� � ������� "..kvadrat())
      end
    },
    {
      title = "{808080}������ �����{FFFFFF}",
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
      title = "{808080}���������{FFFFFF}",
      submenu = 
      {
        title = "{808080}���������{FFFFFF}",
        {
          title = "{808080}��������������{FFFFFF}",
          submenu = 
          {
            title = "{808080}�������� ���������{FFFFFF}",
            {
              title = "{808080}�������������� ���������� � ������� ����������{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "�� �������." and settings.global.lwait ~= "�� �������" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me ������ ����� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ��� ��������� ����������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ���������� � ������� ����������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ����������� ����� �� ������� ����������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� � ��������� ��������� ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ������� �� ���������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���� ����� ������ � ����")
                    wait(settings.global.lwait)
                    sampSendChat("/me � ������� ������� ������ �������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ������������ ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� �������� � ���������� �������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ��������� � �������� ���������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���� � ���� �������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ����������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���������� ���������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���� ������������� ����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ���������� � ����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ��� ����������� � ����� ������")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me ������� ����� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���������� ��� ��������� ����������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ���������� � ������� ����������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ����������� ����� �� ������� ����������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���������� � ��������� ��������� ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ������� �� ���������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����� ����� ������ � ����")
                    wait(settings.global.lwait)
                    sampSendChat("/me � ������� ������� ������� �������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ������������ ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� �������� � ���������� �������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ��������� � �������� ���������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����� � ���� �������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ����������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����������� ���������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����� ������������� ����")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� ���������� � ����")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� ��� ����������� � ����� ������")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}�������������� �������������{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "�� �������." and settings.global.lwait ~= "�� �������" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do �� ����� ����� ������ ������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ������ �� �����, ����� ������ ����� ��� ��������������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� �������� �����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� �� ������ ������������� �������� ���� `PS-201`")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� ������ � ������ �����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ������ ��������� ���� ������ � �����, ����� ���� ������� �� ������ �����")
                    wait(settings.global.lwait)
                    sampSendChat("/do �� ����� ����� ������� � ����� ������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� ������ �����, ����� ���� ��������� ������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������ ��������� � ����� ������ �� �������� � �������������.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do �� ����� ����� ������ ������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ������ �� �����, ����� ������ ����� ��� ��������������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ��������� �����")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� �� ������ ������������� �������� ���� `PS-201`")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ������ � ������ �����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ������ ��������� ����� ������ � �����, ����� ���� ������� �� ������ �����")
                    wait(settings.global.lwait)
                    sampSendChat("/do �� ����� ����� ������� � ����� ������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ������ �����, ����� ���� ��������� ������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������ ��������� � ����� ������ �� �������� � �������������.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}�������������� ��������� ���������� � ������������� �����������{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "�� �������." and settings.global.lwait ~= "�� �������" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me ������ �������� �����, ������� ���")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� �������� ����������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ��������� ��� ��������� ���������� `����� � ������������� �����������`.")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������ ��� ������ �� ����� � ����������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ �������� �� ��������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/do �������� � ����.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� �������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ������ ����� � ������ �������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������ ������� �������� ���������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���������� ���� ���������� �� ������� � ����������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ��� �������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ������ ������. ��������� �������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ����� �����������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ����������� ������� � �������� �����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ������������� ���� � ��������� ������ ���� �����")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me ������ �������� �����, �������� ���")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� �������� ����������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ���������� ��� ��������� ���������� `����� � ������������� �����������`.")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������� ��� ������ �� ����� � ����������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� �������� �� ��������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/do �������� � ����.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ��������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���������� ������ ����� � ������� �������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������� ������� �������� ���������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����������� ���� ���������� �� ������� � ����������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ��� �������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���������� ������ ������. ��������� �������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ����� �����������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ����������� ������� � �������� �����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ������������� ���� � ��������� ������ ���� �����")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}�������������� ��������� ���������� � ������-����������{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "�� �������." and settings.global.lwait ~= "�� �������" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me �������� �������� ����������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ��� ����� ���������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����������� ������ �����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���� ������� � �������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ��������� ������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���� �����-�������� � �������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� �����-�������� � �������� �������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���� �������� � �������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������������ ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���� ������� ")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���� �����-��������")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� �����-�������� � ������ �������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���� �������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ����� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���������� ���������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ����� �����������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ��� ������� � �������� �����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ������������� ����")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� ����� � ������������� ����")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me ��������� �������� ����������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ��� ����� ���������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����������� ������ �����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����� ������� � �������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ��������� ������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����� �����-�������� � �������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� �����-�������� � �������� �������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����� �������� � �������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������������� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����� ������� ")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����� �����-��������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� �����-�������� � ������ �������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����� �������")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� ����� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����������� ���������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ����� �����������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� ��� ������� � �������� �����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ������������� ����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ����� � ������������� ����")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  end
                end
              end
            },
          }
        },
        {
          title = "{808080}������ ����������� ������[���]{FFFFFF}",
          submenu = 
          {
            title = "{808080}�������� ���������{FFFFFF}",
            {
              title = "{808080}��� ��� ��������{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "�� �������." and settings.global.lwait ~= "�� �������" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do ����������� ����� �� �����.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���� ����������� ����� � �����, ����� ������ �")
                    wait(settings.global.lwait)
                    sampSendChat("/do � ����� �����: ���������� ������, ������ � ������������, ����, �����.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ���������� ����� � �������, ��������� ��������� ������ � ������������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ���������� ������ � �����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ����� �������������, ����� ���� ��� ���������� ����� ����� � ����, ������ �������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ �� ����� ����, ����� �������� ����������� � �� ����������� ����������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ������� ���� �� ����������� ����������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ���� ����������� �������� �� ����������� ����������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���� �� ����� ���������� �����, ����� ����� ������ �������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ������� �� ����������� �����")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� ����������� ���������� � �������� ���������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ����������� ���������� ��������������.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do ����������� ����� �� �����.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����� ����������� ����� � �����, ����� ������ �")
                    wait(settings.global.lwait)
                    sampSendChat("/do � ����� �����: ���������� ������, ������ � ������������, ����, �����.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ���������� ����� � �������, ��������� ��������� ������ � ������������")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� ���������� ������ � �����")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� ����� �������������, ����� ���� ��� ���������� ����� ����� � ����, ������ �������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� �� ����� ����, ����� �������� ����������� � �� ����������� ����������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� �������� ���� �� ����������� ����������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ���� ����������� �������� �� ����������� ����������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����� �� ����� ���������� �����, ����� ����� ������ �������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ������� �� ����������� �����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ����������� ���������� � �������� ���������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ����������� ���������� ��������������.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}��� ��� ������� �����������{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "�� �������." and settings.global.lwait ~= "�� �������" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me �������� ���������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ���������, ������� �������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ������� ������� �� ����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ����� �� ������� � ������� ����� ����� �� ����� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ���� ����� ����� �� ����� � �������� � �� ����� �������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ������� � ������ ��, ����� ������ ���� � ����")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� ������� �� ������� ������ ������� ���� ������ ����")
                    wait(settings.global.lwait)
                    sampSendChat("/do ���� ������� ���� ���� �������.")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������������ ���������� ��������.")
                    wait(settings.global.lwait)
                    sampSendChat("/do ���� �������, ������������ �����������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ �� ������� �������� ������� � ������� � ��� ��������")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me ��������� ���������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ����������, ������� �������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� ������� ������� �� ����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ����� �� ������� � �������� ����� ����� �� ����� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������ ����� �� ����� � ��������� � �� ����� �������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ������� � ������� ��, ����� ������� ���� � ����")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ������� �� ������� ������ ������� ���� ������ ����")
                    wait(settings.global.lwait)
                    sampSendChat("/do �������� ���� ���� �������.")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������������ ���������� ��������.")
                    wait(settings.global.lwait)
                    sampSendChat("/do ���� �������, ������������ �����������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� �� ������� �������� ������� � �������� � ��� ��������")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}��� ��� ������� � ����� � �����{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "�� �������." and settings.global.lwait ~= "�� �������" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me �������� ���������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����� �������� ������� ����������� ���������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ������� � ������ ��")
                    wait(settings.global.lwait)
                    sampSendChat("/do ���� ������ �� ������� ���������� ���� � �������� ��� ��������� ���.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ���� ���� ���������������� ��������� � ����� ������� �����")
                    wait(settings.global.lwait)
                    sampSendChat("/do ���� ������ ������������ ����� � ������ �� �������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ����� � ����, ������������ ������������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ �� ������� ����, ����� ����� ���������� ����")
                    wait(settings.global.lwait)
                    sampSendChat("/do ����� ���������� �������� ����.")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������� ������ �������� � ��������� ����.")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������������ ���������� ��������.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me ��������� ���������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� �������� ������� ����������� ���������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ������� � ������ ��")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������� �� ������� ���������� ���� � �������� ��� ��������� ���.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���������� ���� ���� ���������������� ��������� � ����� ������� �����")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������� ������������ ����� � ������� �� �������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ����� � ����, ������������ ������������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� �� ������� ����, ����� ������ ���������� ����")
                    wait(settings.global.lwait)
                    sampSendChat("/do ����� ���������� �������� ����.")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������� ������ �������� � ��������� ����.")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������������ ���������� ��������.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}��� ��� ������ ������{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "�� �������." and settings.global.lwait ~= "�� �������" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do �� ������ ����� ����� �������� ���. �����.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ �� ����� ���������, �������� ��� ��� ��� �������������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���� � ����� �������� ��� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ���� ��� ������������ ����������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ �������� ����, ����� ������ ������������� ������� �����")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������ ���������� ��������� � ��������� ����� �������������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������� ���� ���� �� ����� �� ����� ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ �������� ������ ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����������� ������ ������������� ������� � �������� ������ ������")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do �� ������ ����� ����� �������� ���. �����.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ �� ����� ���������, ��������� ��� ��� ��� �������������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����� � ����� �������� ��� ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����� ��� ������������ ����������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ �������� ����, ������ ������ ������������� ������� �����")
                    wait(settings.global.lwait)
                    sampSendChat("/do ������ ���������� ��������� � ��������� ����� �������������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� ���� ���� �� ����� �� ����� ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ �������� ������ ������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����������� ������ ������������� ������� � �������� ������ ������")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  end
                end
              end
            },
          }
        },
        {
          title = "{808080}������{FFFFFF}",
          submenu = 
          {
            title = "{808080}�������� ���������{FFFFFF}",
            {
              title = "{808080}���������� ���������� � ������� � ��{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "�� �������." and settings.global.lwait ~= "�� �������" then
                  sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                  wait(200)
                  sampSendChat("/do �������� � ��������� ��������� � ���������� ��� ��������������� ������.")
                  wait(settings.global.lwait)
                  sampSendChat("/do ���������� ��������� ����������, �������� ����� �����������, ���� �����������.")
                  wait(settings.global.lwait)
                  sampSendChat("/do ������ ���������� ������������, �������� �������� � ���������� �� ����������.")
                  wait(200)
                  sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                end
              end
            },
            {
              title = "{808080}������ ����������{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "�� �������." and settings.global.lwait ~= "�� �������" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do �� ����� ����� ���� ����� �������� � ������������ ��-21.")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� �������, ������ ���������� � ������ ��������� ����� ���")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do �� ����� ����� ���� ����� �������� � ������������ ��-21.")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� �������, ������� ���������� � ������ ��������� ������ ���")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}������ ���������� ����{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "�� �������." and settings.global.lwait ~= "�� �������" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do ����������� ���� � ������� ����� �� ������� ����� ������ �����.")
                    wait(settings.global.lwait)
                    sampSendChat("/do �� ����������� ��� �������, ����������������� ����� �����������.")
                    wait(settings.global.lwait)
                    sampSendChat("/do ���� ������ ����������, �������� �� ����������.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do ����������� ����� � ������� ����� �� ������� ����� ������ �����.")
                    wait(settings.global.lwait)
                    sampSendChat("/do �� ����������� ��� �������, ����������������� ����� �����������.")
                    wait(settings.global.lwait)
                    sampSendChat("/do ���� ������ ����������, �������� �� ����������.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}������ ���������� ���� � ����������{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "�� �������." and settings.global.lwait ~= "�� �������" then
                  sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                  wait(200)
                  sampSendChat("/do ����������� ����� � ������� ����� �� ������� �����-������ �����.")
                  wait(settings.global.lwait)
                  sampSendChat("/do ����������������� ����� �� ����� �����������.")
                  wait(settings.global.lwait)
                  sampSendChat("/do ���� ������ �����������, �������� �� ����������.")
                  wait(200)
                  sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                end
              end
            },
            {
              title = "{808080}�������� ����������{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "�� �������." and settings.global.lwait ~= "�� �������" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do �� ����� ����� ������ ��������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ����� ��������� ���� ����������, �������� ������ ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� ������ ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/do � ������ �������� ����� ������� ��-2 � ������������ ����� ���-1. ")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� ������ � ������ ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/do �� ������ � ������� �������� ����� 5 ��������� ��� �4, 6 ��������� ��� Deagle, 5 ����� ��� Rifle.")
                    wait(settings.global.lwait)
                    sampSendChat("/me �������� ��������� ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/do � ��������� �������� ����� 2 ��������� ������� ��� �����������, �����, ��������, ���������.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: ����� ���������. ��� ������ ������� CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do �� ����� ����� ������ ��������.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ������ ��������� ���� ����������, �������� ������ ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ������ ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/do � ������ �������� ����� ������� ��-2 � ������������ ����� ���-1. ")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ������ � ������ ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/do �� ������ � ������� �������� ����� 5 ��������� ��� �4, 6 ��������� ��� Deagle, 5 ����� ��� Rifle.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ��������� ��������� ��������")
                    wait(settings.global.lwait)
                    sampSendChat("/do � ��������� �������� ����� 2 ��������� ������� ��� �����������, �����, ��������, ���������.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: ����� ���������.", 0x33AAFFFF)
                  end
                end
              end
            },
          }
        },
        {
          title = "{808080}�������� ����� �������� � ����������:{FFFFFF} "..pInfo.lwait,
          onclick = function()
            sampShowDialog(9999, "���������� ��������:", "{b6b6b6}����� ��������:", "��", "�������", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              settings.global.lwait = input
              pInfo.lwait = input
              refreshDialog()
            end
          end
        },
      }
    },
    {
      title = "{808080}����������{FFFFFF}",
      submenu =
      {
        title = "{808080}����������{FFFFFF}",
        {
          title = "{808080}����� ������{FFFFFF}",
          onclick = function()
            sampShowDialog(2344, "{808080}[SOBR tools] ����� ����{FFFFFF}", "{808080}�����������\n1.1 ������ ���� ������ ������ ����� � ��������� ������� ������������� �������.\n1.2 �� ������������ ������ ������ ���� ����� �������� ��������� ������ �� ���������� �� ������.\n1.3 �������� ������ ����� ����� �������� ����� � ����� �����.\n�����������Ȼ\n2.1 ������������� ������������ ���������� ���������� ����� ���-���������;\n2.2 ���������� ������������ �� `SOS` �� ������� ������, ������� �������� �����������;\n2.3 �������� `��������� ������` � `����`;\n2.4 �������������� ����� �������� ���������, � ��� ����� ������� �������;\n2.5 ������������� �������������� �������� ������ �������� �����, ��������� ��������� � ����� ������� ������ ���������� ������, � ��� �� ������� ����������� ���������� ������ � ��� ������������;\n2.6 ����� ������� ����� ����� ( ��-������ );\n2.7 ������������� ������������� ������ ��������� � ����� ����������� ��������� �����;\n2.8 ������������� ������������ � ������� �� �������� � ����� ���-���������;\n2.9 ������� � ����. ��������� ������ � ����������� ����������� ������������,� ��� �� Federal Bureau of Investigation;\n2.10 ������ � ����� ���-������� ��� ������������ ���������.\n2.11 ������ ������ �������.\n�������ۻ\n3.1 ��������� ������ � ����� �����;\n3.2 ������������ �������� ������������ �������, ����������� �����;\n3.3 ������������ �� ����� ������� (����.: ������ 3 ������);\n3.4 ���� � ����������� � ����� � ����� ������������ ������������ (����.: � ���� ��������);\n3.5 ������� � �����������/�� �� ��������� � �����-���� �������, ����� ��������� �������� � �������� ���������� �����;\n3.6 �������� ���� ����� ����, ��� ������ � ��� (� ������, ���� ���� ��������, �������� ���.����������, ���� ���� �� ����, ������������ � �����);\n3.7 ����� ��������� � ������� �����;\n3.8 ���������� � ������� ������ ��� ����.��������;\n3.9 ������������ ��������� ������� ��� ���������� ���.������� ������ �/��� � ������� ����� ���� �������;\n3.10 �������� �� ���������� ������ � ������, ���� �� ����� ����� ����������� ��� ���������� ���-���� �� ������� ��� ��������.\n(����.: ����������� ����������� ��������� � ����������� ��������� ��� ���������� ������� ��������)\n���������λ\n4.1 �������� ���������� ����� ��� �������� ���������� � ���������� ���. ���������� � ��������. (�� ��������� ����)\n4.2 �������� � ���������� ���� ����� ������ ����� � ��� � ����� ����� ����� � ������������ �� ��.\n4.3 ������ ��������� ������� �� ����� ������ �� �����.\n4.4 ��������, ����� � ����� �������������� �����.\n4.5 ��������� ���� ������ ��������� ������ �� �����.\n4.6 ����� ����� �� ��������� �� ������ �����, ������� ��������� � ����� � �����.{FFFFFF}", "�����", "�� �����", 0)
          end
        },
        {
          title = "{808080}���-����{FFFFFF} ",
          onclick = function()
            sampShowDialog(4353, "{808080}[SOBR tools] ���-����{FFFFFF}", "{808080}10-4 � ��������� �������, �������!\n10-6 � � �����, �� ������� - [������� �������]\n10-8 � ����� � ������ [������� ��������]\n10-10 � ���������, � ������� - [������� ������]\n10-16 � ����������� �������������� � ������� - [������� ������]\n10-20 � �������������� � ������� - [������� ������]\n10-26 � ��������� ���������� ����������.\n10-34 � ��������� ������������ � ������� - [������� ������]\n10-37 � ��������� ��������� � ������ - [������� ������]\n10-38 � ��������� ������ ������ ������ � ������ - [������� ������]\n10-30 - ������� � ������������� - [������� �������� ����������]\n10-31 - ������������ � �����\n10-40 - ������� ����� - [������� �������� ����������]\n10-43 - �������� � ���� �� - [������� �������� ����������]\n10-44 - ��������� � ���� ��\n10-51 - ������� �� �������� AMMO LS - [������� �������� ����������]\n10-52 - ������� �� �������� AMMO SF - [������� �������� ����������]\n10-53 - ������� �� �������� AMMO LV - [������� �������� ����������]\n10-61 - ������� �� �������� MO LS - [������� �������� ����������]\n10-62 - ������� �� �������� MO SF - [������� �������� ����������]\n10-63 - ������� �� �������� MO LV - [������� �������� ����������]\n10-99 � ������� ���������, ��� � �������.\n10-100 � ����� ������.\n10-200 � ��������� ����� ������� � ������ - [������� ������]\n10-250 � ����� ����.������� PD � ��������� ����� - [������� ������ / �����].\n(������������ ��� ������, �������, �������� � ����� �����������)\n10-300 � ����� ����.������� PD � Army � ��������� ����� - [������� ������ / �����].\n(������������ ��� ������, �������, �������� � ����� �����������){FFFFFF}", "�����", "�� �����", 0)
          end
        },
        {
          title = "{808080}�������� ����������{FFFFFF}",
          onclick = function()
            sampShowDialog(1298, "{808080}[SOBR tools] ��������{FFFFFF}", "{808080}Leo Florenso - ����\nSergu Sibov - ����������\nHoward Harper - ������\nMisha Samyrai - ���\nValentin Molo - ����\nBrain Spencor - ����\nKevin Spencor - ����\nAleksey Tarasov - �����\nRodrigo German - ����\nMichael Fersize - �����\nBarbie Bell - �����\nJimmy Saints - �������\nBoulevard Bledov - �����\nSaibor Ackerman - ������\nKenneth Sapporo - ������\nNikita Prizrack - �������\nHieden Bell - �������\nChristian Hazard - �����{FFFFFF}", "��", "�� ��", 0)
          end
        },
        {
          title = "{808080}����� ����� � ����������� �������������{FFFFFF}",
          onclick = function()
            cmd_imgui()
          end
        },
      }
    },
    {
      title = "{808080}������� �������{FFFFFF}",
      onclick = function()
        sampShowDialog(1285, "{808080}[SOBR tools] �������{FFFFFF}", "{808080}/aclist - ���������/�������� ���������\n/lp - ���������/�������� ���������� ���� �� ������� `L`\n/atag - ���������/�������� ����-���\n/ascreen - ���������/�������� ����-����� ����� ������\n/sw, /st - ������� ������� �����/������\n/cc - �������� ���\n/kv - ��������� ����� �� �������\n/getm - �������� ���� ����������, /rgetm - � �����\n/przv - ��������/��������� ����� �������\n/abp - ���������/�������� ����-�� �� `alt`\n/hphud - ��������/��������� �� ���\n/abp - �������� ��������� ����-��\n/splayer - ��������/��������� ����������� � ���� ����� ������� ������� ��������� � ���� ������\n/fustav - ���������� �� � �����{FFFFFF}", "�����", "���������", 0)
      end
    },
    {
      title = "{808080}���������{FFFFFF}",
      submenu =
      {
        title = "{808080}���������{FFFFFF}",
        {
          title = "{808080}���:{FFFFFF} "..pInfo.Tag,
          onclick = function()
            sampShowDialog(9999, "���������� ���:", "{b6b6b6}����� ���� ���:", "��", "�������", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              settings.global.Tag = input
              pInfo.Tag = input
              refreshDialog()
              onScriptTerminate()
            end
          end
        },
        {
          title = "{808080}����� ����� ����������:{FFFFFF} "..pInfo.cvetclist,
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
          title = "{808080}���������/�������� ���������� ���������� �� ������� `L`{FFFFFF}",
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
          title = "{808080}���������/�������� ����-���{FFFFFF}",
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
          title = "{808080}���������/�������� ��������� ����� ������{FFFFFF}",
          onclick = function()
            if settings.global.a_u_t_o_screen == true then
              sampAddChatMessage("[SOBR tools]: ��������� ����� ������ ��� ��������.", 0xFFB22222)
              settings.global.a_u_t_o_screen = false
            else
              sampAddChatMessage("[SOBR tools]: ��������� ����� ������ ��� �������.", 0x33AAFFFF)
              settings.global.a_u_t_o_screen = true
            end
          end
        },
        {
          title = "{808080}���������/�������� ����� �������� �� `Alt + ������ �� ������`{FFFFFF}",
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
        {
          title = "{808080}���������/�������� ����������� ��������{FFFFFF}",
          onclick = function()
            if settings.global.pozivnoy == true then
              sampAddChatMessage("[SOBR tools]: ����������� �������� ���� ���������.", 0xFFB22222)
              settings.global.pozivnoy = false
              for k, val in pairs(tData) do val:deattachText() end
            else
              sampAddChatMessage("[SOBR tools]: ����������� �������� ���� ��������.", 0x33AAFFFF)
              settings.global.pozivnoy = true
              for k, val in pairs(tData) do val:attachText() end
            end
          end
        },
      }
    },
  }

  LVDialog = {

    {
      title = "{808080}������/���.������{FFFFFF}",
      submenu = {
        title = "{808080}���.������{FFFFFF}",
        {
          title = "{808080}����������� � ������� �������� ���������{FFFFFF}",
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
          title = "{808080}/me ���� �������� � ����� ������� �{FFFFFF}",
          onclick = function()
             sampSendChat("/me ���� �������� � ����� ������� �")
          end
        },
        {
          title = "{808080}/todo ������� ��� ������ ���?*������������ ��������{FFFFFF}",
          onclick = function()
             sampSendChat("/todo ������� ��� ������ ���?*������������ ��������")
          end
        },
        {
          title = "{808080}/todo ���, ���������� ��� � ����*������ ��������{FFFFFF}",
          onclick = function()
             sampSendChat("/todo ���, ���������� ��� � ����*������ ��������")
          end
        },
        {
          title = "{808080}�������. ��� � ���� ��� �������?{FFFFFF}",
          onclick = function()
             sampSendChat("�������. ��� � ���� ��� �������?")
          end
        },
        {
          title = "{808080}�������, �� ����� ��� ������ � �����{FFFFFF}",
          onclick = function()
             sampSendChat("�������, �� ����� ��� ������ � �����.")
          end
        },
        {
          title = "{808080}������� ������� �16 � ��������� � �������� �������{FFFFFF}",
          onclick = function()
             sampSendChat("������� ������� �16 � ��������� � �������� �������.")
          end
        },
        {
          title = "{808080}/r [��� ���]: ��������� � ��������� ID ����� ��� ������ � ����� ����� ������� �������{FFFFFF}",
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

function e.onPlayerQuit(id)
  local name = sampGetPlayerNickname(id)
  if (tData[name] ~= nil) then 
    tData[name]:deattachText()
  end
end

function Target:New(text)
  local obj = {}
  obj.text = text
  obj.name = name
  obj.id = nil
  obj.text3d = nil

  function obj:deattachText()
    if (self.text3d ~= nil) then 
      sampDestroy3dText(self.text3d)
      self.text3d = nil
    end
  end

  function obj:attachText()
    self:deattachText()
    self.text3d = sampCreate3dText(self.text, 0x00000000, 0, 0, 0.7, 50, false, self.id, -1)
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end

tData["Leo_Florenso"] = Target:New("{000000}����{FFFFFF}")
tData["Howard_Harper"] = Target:New("{000000}������{FFFFFF}")
tData["Aleksey_Tarasov"] = Target:New("{000000}�����{FFFFFF}")
tData["Valentin_Molo"] = Target:New("{000000}����{FFFFFF}")
tData["Brain_Spencor"] = Target:New("{000000}����{FFFFFF}")
tData["Kevin_Spencor"] = Target:New("{000000}����{FFFFFF}")
tData["Evan_Corleone"] = Target:New("{000000}��������{FFFFFF}")
tData["Misha_Samyrai"] = Target:New("{000000}���{FFFFFF}")
tData["Sergu_Sibov"] = Target:New("{000000}����������{FFFFFF}")
tData["Kenneth_Sapporo"] = Target:New("{000000}������{FFFFFF}")
tData["Rodrigo_German"] = Target:New("{000000}����{FFFFFF}")
tData["Michael_Fersize"] = Target:New("{000000}�����{FFFFFF}")
tData["Jimmy_Saints"] = Target:New("{000000}�������{FFFFFF}")
tData["Barbie_Bell"] = Target:New("{000000}�����{FFFFFF}")
tData["Saibor_Ackerman"] = Target:New("{000000}������{FFFFFF}")
tData["Boulevard_Bledov"] = Target:New("{000000}�����{FFFFFF}")
tData["Nikita_Prizrack"] = Target:New("{000000}�������{FFFFFF}")
tData["Christian_Hazard"] = Target:New("{000000}�����{FFFFFF}")
tData["Hieden_Bell"] = Target:New("{000000}�������{FFFFFF}")


nData = {"Leo_Florenso", "Howard_Harper", "Aleksey_Tarasov", "Valentin_Molo", "Evan_Corleone", "Kevin_Spencor", "Brain_Spencor", "Rodrigo_German", "Sergu_Sibov", "Jimmy_Saints", "Saibor_Ackerman", "Michael_Fersize", "Barbie_Bell", "Boulevard_Bledov", "Kenneth_Sapporo", "Nikita_Prizrack", "Hieden_Bell", "Christian_Hazard"}

function e.onPlayerStreamIn(id, _, model)
  if cfg.global.sdelaitak ~= nil then
    if cfg.global.sdelaitak == true then
      local name = sampGetPlayerNickname(id)
      if model == 287 or model == 191 or model == 179 or model == 61 or model == 255 or model == 73 then
        sampAddChatMessage("[SOBR tools]: ���� "..name.." �������� � ���� ����������.", 0x33AAFFFF)
      end
    end
  end
  if (sampIsPlayerConnected(id) and tData[sampGetPlayerNickname(id)] ~= nil) then
    local target = tData[sampGetPlayerNickname(id)]
    if ((target.id == nil) or (target.id ~= id)) then
      target.id = id
      target:attachText()
    end
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

function e.onShowDialog(dialogId, style, title, button1, button2, text)
  if title:find('�������������') and bronya == true then       
    sampSendDialogResponse(32700, 1, 2, nil)
  end
end

function e.onServerMessage(color, text)
  if (text:find("������ ����� SA")) and settings.global.a_u_t_o_screen == true then
      sampSendChat("/time")
      lua_thread.create(function()
          wait(1234)
          justPressThisShitPlease(VK_F8)
      end)
  end
  if (text:find("����� ���������� �� Evolve Role Play")) then
    goupdate()
  end
	if color == 479068104 then
		local id = text:match("%d+")
		sampAddChatMessage(text, sampGetPlayerColor(id))
		return false
  end
end

function justPressThisShitPlease(key) lua_thread.create(function(key) setVirtualKeyDown(key, true) wait(10) setVirtualKeyDown(key, false) end, key) end

function goupdate()
  sampAddChatMessage("[SOBR tools]: ��������� ���������� ������� ���������.", 0xFFB22222)
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
	for k, val in pairs(temp) do monikQuant[k] = val end
	if monikQuant[6] ~= nil then
		for i = 1, table.getn(monikQuant) do
			number1, number2, monikQuantNum[i] = string.match(monikQuant[i],"(%d+)[^%d]+(%d+)[^%d]+(%d+)")
			monikQuantNum[i] = monikQuantNum[i]/1000
		end
    sampSendChat("/r "..pInfo.Tag..": ����������: LSPD - "..monikQuantNum[1].."|SFPD: "..monikQuantNum[2].."|LVPD: "..monikQuantNum[3].."|SFa: "..monikQuantNum[4].."|FBI: "..monikQuantNum[6].."")
    thisScript():reload()
  else
    sampAddChatMessage("[SOBR tools]: ������. �� ���������� ������� ������ �� �������.", 0xFFB22222)
  end
end

function getm() 
  local x,y,z = getCharCoordinates(PLAYER_PED) 
  local result, text = Search3Dtext(x,y,z, 1000, "FBI") 
  local temp = split(text, "\n") 
  for k, val in pairs(temp) do 
    sampAddChatMessage(val, 0xFFFFFF) 
  end
end

function getNearestPlayerId()
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
      if result and not isCharInAnyCar(minPed) then
        sampSendChat("/showpass "..playerid.."")
      end
    end
  end
end

function getNearestPlayerId1()
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
      if result then
        sampSendChat("/report "..playerid.." +�")
      end
    end
  end
end

function abp()	
  if sampIsDialogActive() and sampGetCurrentDialogId() == 20053 then
    bronya = true
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
    bronya = false
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

function smembers()
  for i = 0, 999 do
    if (sampIsPlayerConnected(i)) then
      local name = sampGetPlayerNickname(i)
      if (table.concat(nData, " "):find(name)) then
        sampAddChatMessage(name, 0x33AAFFFF)
      end
    end
  end
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
		
	textHelp = "������� ���������� ���������� "..nameGun..", ������� ��������� �����.\n�������� ������ ������ ���� �� 0 �� 2."
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

function cmd_imgui(arg)
  main_window_state.v = not main_window_state.v
  imgui.Process = main_window_state.v
end

function imgui.OnDrawFrame()
  imgui.Begin(u8"����� � ��", main_window_state)
  imgui.Text(u8"                                                                                              �����")
  imgui.Text(u8"\n����� I. ����� ���������.\n1.1 ����� ���������� ����� ����� � ����������� �������������� Las-Venturas Army � �� ���������������,\n����������� �������� ����������� ���,�������������, ������� ����������� ������� � �������� ����� � �� ��������������;\n1.2 ������ ����� ������� ����� � ��������� ��� �������������� �����;\n1.3 �������� ������ �� ����������� ��� �� ���������������;\n1.4 ����� ����� ���� ������� ��������� � ����� �����;\n1.5 ������� ���� � ����� ���������� � 8:00 �� 22:00, � �������� ��� � � ������� � 9:00 �� 21:00;\n1.6 ���� ���������� � 13:00 �� 14:00. � ������ ����� ������ ����������� ���������� ������ ������, ������� ����� � �������\n[������� � ���������� ����������� �������� ���, ������� ��������� �� ������������� ��������, �� ��������];\n1.7 ��������� � ����� ��� ����� ����� ����� ������� ������. � ��� ����� �� �� ������ �������� ������ � ������,\n����� �������� ����� � ��;\n1.8 ������, ����, ������������ � �.�. �������� �� ����� ���� ����������� ����������� ��� ������������\n[����������: ���� ������������ ������������ �������������];\n1.9 ������� ������ ������ ������ �������������� ������ �����;")
  imgui.Text(u8"����� II. �������� ����������� ��������������.\n2.1 �������������� ������ ��������� ����� �����, �����������, ������ �����, ����������� �������������;\n2.2 �������������� ������ �������������� ��������� ������� ������� �� ������ � ��������� � ������ �� ���������� � �������� �� � ���;\n2.3 �������������� ������ ���� ����������, ������ ������� ������� � ��������������� �����;\n2.4 �������������� ������ ����� � ���� � ������� ������� ���������� ������;\n2.5 �������������� ������ �������� ��������� � �������� ����� Las-Venturas;\n2.6 �������������� ������ ���������� �� ������ � ������� ����� �������� ���;\n2.7 �������������� ������ ��� ����������� � ���� �������� ������� �7, �� ����� ��������������� ������� ��� ��� ����������;\n2.8 �������������� ������ ����������� ��������� ��������� �� ��� / ���� �� �������� �� ������ [����������: ������� �������];\n2.9 ������ ��������������, ����������� �� ��� / ����, ������ ��������� ��������� � ������� ������������,\n���������� �� ���������� �����[����������: ������� �������];\n2.10 �������������� �� ��� / ���� ����� ��� ��� ��������� ��������� � ������������, �������������� ������ �������������\n[������: �������������, � ������� ������. ���������� ���������� ���� ���������.�].\n2.11 �������������� ������ ������ ���� � �������� ���� [100 hp � 100 armor].")
  imgui.Text(u8"����� III. �������� ������� ��������������.\n3.1 ��������������� ��������� ���������, ������ ������� �����\n[����������: ����������� �� ������ � ������� ������, ���, ���� � ��� ����.���������].\n3.2 ��������������� ��������� ���������� ���������� ���.\n3.3 ��������������� ��������� ����������� ������, ���������.\n3.4 ��������������� ��������� ���������� �������� ���������� �����\n[����������: ����� ������ 5.1].\n3.5 ��������������� ��������� ���������� � ������� ������\n[����������: ���, ���� � �����, ����������� �� ���������].\n3.6 ��������������� ��������� ��������� ����� �� ����� �����������\n[����������: �������� ��������� ��������� �� ����������].\n3.7 ��������������� ��������� ���������� �����������.\n3.8 ��������������� ��������� ����������� �� �������� �� ������ ��� ���������.\n3.9 ��������������� ��������� ������������ ����������� �����, ����������, ������� ����-����\n[� OOC � SMS ������������!].\n3.10 ��������������� ��������� ������������� ����� ���������� ������������.\n3.11 ��������������� ��������� �������������� ������ ���������� ������������.\n3.12 ��������������� ��������� ��������� ���� ��������� ����������.\n3.13 ��������������� ��������� ���������� ������ �������������.\n3.14 ��������������� ��������� ���������� ������ �����\n[����������: ������� �������, ���].\n3.15 ��������������� ��������� ���������� ������� �����, ��������� ������, �������� �����\n[����������: ������� �������; ���, ���� ��� ����. ��������, �� � �����; ���� ��� �� ����� ������� � ���� LS;\n��� - ����� ������. � ����� ������ �������������� ������ ������� ����� ��� ����������� �� ��������� � ������].\n[����������: ����� �� ������ ����� �� ������� �������� �� ���� � ����� ��������� �������:")
  imgui.Text(u8"/r [tag] �������� ������ �������������� ��������. ����� ����� - ���� ��(������� �������)]\n3.16 ��������������� ��������� ����������� ������������� ������������� ����� [���, ���� ��� ������� ��������].\n3.17 ��������������� ��������� ����� [AFK] � ������������ ����� ����� 120 ������ [2 ������].\n3.18 ��������������� ��������� ��������� � ��������� ������ �� ���������� �����������\n[����������: �����������, ����������� ����� ���-��].\n3.19 ��������������� ��������� �������� ������ �������� �������\n[����������: ���������� �� ������� ��������, ���������� ���, ���� � 22:00 �� 8:00].\n3.20 ��������������� ��������� ��������� ����������� ���, �������� �� ���������� �����.\n3.21 ��������������� ��������� ������������ ����� ������������, �� �� ����������.\n3.22 ��������������� ��������� ���������� � �������������� ������ � ������� �����:\n������, �����������, ������, ���, ����, �����������\n[����������: ��� ��� ���������� ����������� ������������, ����������� �� ������������� � �������������].\n3.23 ��������������� ��������� ����������� ������������, ������������� ��������,\n� ����� ���������� � ����������� ���������.\n3.24 ��������������� ��������� ������� � ����� ����� ������.\n3.25 ��������������� ��������� ������ ����������\n[����������: ������ �� �����������, ������� ���� ����� ����������].\n3.26 ��������������� ��������� ���������� �������� ����������� ���, ��� ��� ����������.\n3.27 ��������������� ��������� �������� ������� ����������� ������� ��������.\n[������������ ��� ������, ��������� � ��� �����].\n3.28 ��������������� ��������� �������� ����������� �������������.\n3.29 ��������������� ��������� ������������ ������/����� ��\n[����������: ������� ������� - ����� ������������ ����� ���������;")
  imgui.Text(u8"�������� �������, ���, ����, ��� - ���������� Sultan, FBI Rancher, Huntley, Patriot, ��������� NRG-500, FCR-900 - ������� �����.\n���� - ���������� Sultan, FBI Rancher, Huntley, ��������� NRG-500, FCR-900 - ������ �����, �������� ������� - �������� NRG-500].\n3.30 ��������������� ��������� ������������ �/c Bobcat, Walton � �������� ��� ��������� �������.\n3.31 ��������������� ��������� ������ �� �������������� �����.\n3.32 ��������������� ��������� ����� ���� �����������.\n3.33 ��������������� ��������� ��������� �� ������ ������, ������������� �� ���������� �����.\n3.34 ��������������� ���������, �������� �� ������, ����� ������, �������� ��� �� ��������� ������ �����\n[����������: ��������� M4, MP5, Desert Eagle, �������, ShotGun, Rifle, ����������, ������ ������� �������].\n3.35 ��������������� ���������, � ������� ����� ��������� ���������� ������\n[����������: ���������].\n3.36 ��������������� ���������, ��������� � ����� � ������ ���������� [������, �������].\n3.37 ��������������� ��������� �������� ������� ����� [����� IV].\n3.38 ��������������� ��������� ������ ��������� ������� �� ��� / ����\n[����������: ������ �� �����].\n3.39 ����������� ������������ �������� �� ������ � ���������.\n3.40 ����������� ������������� � �� ��������� ���� ��������� �����������.\n3.41 ����������� �������� � ������� �����/������������� � ��������\n[����������: ���, ������� �������].\n3.42 ��������������� ���������, ������������ ������������� ������ �� �� ����������.\n3.43 ��������������� ���������, ��������� �� ������ [����������: �� �����].\n3.44 ��������������� ��������� �������� ������������� ��������� �����-��� [����� XIII].\n3.45 ��������������� ��������� ������� ���������� � ����� ����������� ��������� � ������������.\n3.46 ��������������� ��������� �������� ������� ��������.")
  imgui.Text(u8"3.47 ��������������� ��������� �������� ����� �� �������� ��� ���������� � ���������� (���, ������� �������)\n[����������: ���, ���� ��, ������������� �������].\n3.48 ���������������, ����������� ������ �� ���������, ��������� ���������� �� ����� ��� �������� `CS`.")
  imgui.Text(u8"����� IV. ������� �����.\n4.1 �������� �� ����� ���������� �������������� ����� ������: ������� �������, ���;\n4.2 � ����� ������� ���������� �� ��������������, ��� ������ ���� ������� ��� ����������;\n4.3 � ����� ���������:\n4.3.1 ��� ���������� ��������� �������������, ���������, ������������ ����� �������� �������� ����������\n[����� ����: /sms, /call, /b, /r, /rb, /dep, /w � �������];\n4.3.2 ������� ���������������, ������ ���������\n[��������������� ���������: /me, /do, /try, /animlist � ������];\n4.3.3 ������������ ������� [����������: ���� ��������� ���������� �������� ����� ��� ���];\n4.3.4 ��������� ������ ��� ������� [����������: �������� � �����, �������� � �����, ������];\n4.3.5 ��������� ����� ��� �������\n[����������: ��������� �������� �� ������� �����, ������� ������� ��������, � ����� ��� ������ �����];\n4.3.6 ����� [������� � AFK ����� ��� �� 30 ������];\n4.3.7 ���������� �������� �����;\n4.3.8 ��������� �������� �����������;\n4.3.9 ������������� � ����� [����������: ����������� �����].\n4.3.10 ������������ ���� [����������: ������������].\n4.4 ����� ��� ��� ������ � �����, �������������� ������ ��������� ����������� [100 hp � 100 armor].\n4.5 ��������������, ������������ �� ����������,\n����� ����� ������ � ����� �� ������� �� ��� ��������� ����������.\n���� �� �������� �� ���������� ��, �� ����� ��������� ��������� �������� �� ���������� ������ � �����.\n�� ������� ������ �������������� � ����� ����� ��� ����� � �� ����� ����� ���������.")
  imgui.Text(u8"����� V. ������� ������.\n5.1 ������� ������� ����� ����� ���������� �������� �����.\n������� ������� ����� ����� ����� ��������� ������ �� ���������� ����� ��� �������������.\n5.2 �������������� ������ �������� ����, ������� ��� ��������;\n5.3 ����� ��������� ������ � ������� ����� � ������� [����������: ����� VI ������ �����];\n5.4 ������ �� �������, �������������� ������ ������ ����� ������ ������ ��� ������������� � ������������ � ��������� ����:\n������� �������/������� ����� - ������� �21\n��� - ����� �32\n���� - ����� �30, �11.\n���� - ����� �29, 22\n��� - ����� �5, 3\n��� - ����� �19, 20\n��������� ������� � ������� - ����� �12\n������������ ������� � �������- ����� �8\n������� ������� - ����� �10\n����������: ��� ����� ���� ������ ���������� �� ���������.\n5.5 ����������� ���� ��� �� �������, ���� ������ � ������� 10-�� ����� ������� �� ���������� �����.\n������ 10 ����� ����������� ��������� ������������� �� ������,\n������� ����� ���������, ��������� �������� � �.�.;\n5.6 ���� �� ������ ��� ��������� ������ ��� ��� �����������,\n������������ ���� ������� ���������� �������� ����� ������ ������������ � �����;\n5.7 �������� ������ � ����� ��������� ������: �������, ���, ���, � ����� ���. ������� �������\n[��� ���������� ����� ������������];")
  imgui.Text(u8"����� VI. ������� ���.\n6.1 ����� ���� Army Las Venturas ����� ����� ����� � ������� ����� � �������;\n6.2 ����� ��� ����� ����� ����� � �������, �� ����� ������� �����;\n6.3 ����� ������� ���, ���� ����� ����� ����� � ������ ����� �������������� �����;\n6.4 ������� ������� ����� ����� ����� � ����� �����;\n6.5 ����� ��� ����� ����� ����� �� �����, �� �� ����� ��� 2 ������ [120 ������].")
  imgui.Text(u8"����� VII. �������������� �����.\n7.1 �������������� ����� � ������ ��� ���������� � 22:00 � ������������� � 8:00,\n� ������� � �������� ��� ���������� � 21:00 � ������������� � 9:00;\n7.2 �����, ������� ������ ��.������� � ����, ����� ����� ����� ����� � ����������� � �������������� �����.\n������� � ��������� ��� �� ���������� ����� ������ � �����;\n7.3 ���� ������ ��������������� ����������� ����� ���������� ����� 100.000 ������,\n�� �������������� ����� ��� ���������� �� ���� �������, ���� ������ �� ����� ���������;\n7.4 ���.������ �������, ������� ������� � ����� �����, ����� ���� ������� � ����� � ��������������� �������;\n7.5 �������� �������������� ����� ����� ����� ������ ������� �������.")
  imgui.Text(u8"����� VIII. ������������/������� ������������� �����.\n8.1 �������������� ������� ��������� ������������ � ������� ����� �����;\n8.2 ��� �������� ���� ������ ��������: `��� �����, ������� ��������, ������!`,\n��� ����������: `����� ���, ������� ��������, ������!`,\n���� ���� ������� ������: `����, ������� ��������, ������!`;\n8.3 ���������� � ������������, ���� ������ �������: `������� �����`\n[`�����`, `�������` � �.� ���������];\n8.4 �������������� ������ ��������: ` �, ������� `������` ` ����� ��� �������� ������� �� ������;\n8.5 ���� ��������������� �������, �� �� �������� �� ������ ��������\n[������: `������� ������, ������� ������ �� ������ ���������� ������`];\n8.6 ��������� ���-����, �������������� ������ �������: ` ������� `������`, ��������� ����������` `;\n8.7 ��� ��������� ��������������� �� ������ ��������: `����� ����� Las Venturas!`;\n8.8 �������������� ������ ������� �������� � ����� ������� �����;\n8.9 �������������� ������ ���������� �� `��` � ����� �����������\n[����������: ���� ��������� � ������ ����, �� ����������� ���������� �� `��`].\n8.10 ��� ������� � ����� ������ ����������� ��� ����������������� �������;\n8.11 ��� ������� �� ����� ���������:\n8.11.1 ����� ��������� �� ��������� � �������� ������ [���������, �������, �����������];\n8.11.2 ����������� ����������� ��������� [� OOC � IC ���];\n8.11.3 �������� ��� ����������� ������ ������ [������: /r [��� �����]:].\n8.12 �������������� ������ ���������� � ������� ������ �� ������\n[������: `������� ������� ������, ��������� ����������?`];\n8.13 �� ����� �������������� [�� �����] ��������� ���� ������������ ����� �� ������ ��\n[����������: ������ ����� ������������ ������� �������, ���].\n")
  imgui.Text(u8"����� IX. ���������� �����.\n9.1 �� ���������� ����� Las-Venturas Army ��������� ����������:\n���������;\n- ���� � ��� ������������\n[����������: � ������ 9.1 - ����������� ���� ��� ������ �� ���������� ���������� ������� ������������ ��������� ���������]:\n�������� �������������� ��������.\n������������� �������������� ���������� �������.\n��������� ��� � ��� ������������;\n������� SAPD � �� ������������;\n- �������� San-Fierro Army.\n��������� ��������������� �������� �� ���������� ����� ��������� ����������\n����� �������������� �� ����� ������������ � ��������� ��������� ��\n������� ��������, ���� �������� � �����, �� ������ ������;\n9.2 ����� �� ����� ������� ����������� � ����� � �������� ���� ��� � ����������� ������ �� ��� � ����;\n9.3 ����� �� ����� ����� ����� ��������� �������� � ���� ���������� � ���������� ��������������,\n����������� � ����������� ���\n[����������: �������� �����, ������� �������, ������� ��� � ������������];\n9.4 ��������� ��������� � ���������� ����� ������, ������� �� ����� ���������� �� ����� �� ������� ��������\n[����������: ����� 9.5 ������ �����];\n9.5 ��� ���������� �������� ����� �������������,\n����� ����, ���, ����, ���, ��� ����� ����� �������� ����� ��� ���������� ������� ��������;\n9.6 ����� �� ���������� ������� ����� �� ����������� ������������ �������� ������ ��������\n[����������: �������� �����, �������� ���������� �� ���������� �����,\n�������� ����� XII ������ �����];\n9.6.1 �����, ��������� � ������ 9.1 ������ �����, ����������� ����� �� ���������� ������� �����\n�� ��������� ���������� ������������� � ��������� �����;\n9.7 ��� �������������� ������� ���������� ������� �� ��� � ���� �� �������� � ����� � ����������� �����\n[����������: ������� �������];")
  imgui.Text(u8"9.8 ��������� ������������ Las-Venturas Army �������� ��������\n[����������: �������� ��������� SFa ��� �������� �����������, � ����� ����, ��������� � ������ 9.1 ������ �����].\n9.9 �������� ����� ��������� ���� ����������� ������ � ���������� ���������� (���, ������� ��������)\n[����������: ���, ���� ��, ������������� �������].")
  imgui.Text(u8"����� X. ������� ���������.\n10.1 �������, ������� � ���, ��������� ����� ������: ���, ����, ����, ���, ���,\n� ����� ��� ������������� ��� � �������������� �����;\n10.2 ���������� ����� � ��� ��������� ����� ������: ���, ����, ���,\n���.������� ������� � ������� [��������, �����������, �������];\n10.3 ���������� ���� � ������� ��������� �����: ���, ��� ���������� ������;\n10.4 �������, ������� � �������, ��������� ����� ������: ���, ����;\n10.5 �������, ������� � ����� ���� ��������� ����� ������: ���, ����;\n10.6 ��������� �� �������� ��������� ����� ������: ���� �� 3-� �������; \n � ������������; ���� �� 3-� �������, � ����� � ���������� ������� ��������;\n10.7 ��������� ��������� ��������� ����� ������: ���, ���, ����, ���\n[����������: �������� � ���� ��� ������ ��� � ���������� �������� �����];\n10.8 �������� ��������� ����� �� ������� ������� �������� ��� ���������� ����������� ������ �����, ��������;\n10.9 ������ Shamal ����� ����� �����: ������� �������, ����� ����� ���� � ���������� ������� ��������;\n10.10 ������� ������� ����� ����� ����� ����� ������� �����;")
  imgui.Text(u8"����� XI. ���������� �������/����������.\n11.1 ����� ��� ����������� ���� ����������� �������, � ������: ���, ����. ������� � ������� ��������;\n11.2 ������ ����, ��� � ��� ��������� �� ����� ������ ��������;\n11.3 ����� ������������ ���������� ���� �����������: ���. �����, ���;\n11.4 ��� �����������: ���. �����.\n��������� ��� ����������� �� ����������\n���.���������� ��� ���������� �� �������������\n�� ������ � �� ��.������������ ����������� �� ������.\n11.5 ����� ���� ����� Las Venturas, ������������� � ��� ��� �������� ���������,\n����� �������������� ���������� � ������� ����� ��� ���� ����������;\n11.6 �������������� ������ �������������� ���������,\n�� ����� ���������, ������� ����������������� �������� ��������� � �������������� ���������;")
  imgui.Text(u8"����� XII. ������� ��������.\n12.1 �� ��������� ������ ��������, ���� ����� �������� ������� � ���� ������, �� ��������� ��������� �������;\n12.2 ������� � ���������� ������ ��������� ����� ��� � ����� � ����������� � ��� ����������;\n12.3 �����, ������� ������ ��.������� � ���� ������� ����������� �� ����� �������� ��� �����;\n12.4 �����, ��������� � ����.������ ���� ����� ����� ��������� ��� ������ �����,\n��������� � ������ 3.29 ��� ����, �� �������� ������ �� �����;\n12.5 �����, ��������� � ����.������ ���, ����� ����� ��������� ��� ������� �����,\n��������� � ������ 3.29 ��� ���, � �������;\n12.6 �����, ������� ������ �� ��.��������� �� ������� ����� ����� ����������� �� ������� �2;\n12.7 ������� ����� ����� ����� ����������� ������ � �������;\n12.8 ����� ������� ���� ������ ������� ������� ��������� ���\n�� ����� �������� ��� ����� ��� ����� � ���. ��� ����������� �� ������\n[����������: ��� ����� ������������ ������� �� ������� �� ������ �� ����� ��������].\n12.9 �����, ��������� � ���, ����� ����� ��������� ��� ������ �����,\n��������� � ������ 3.29, �� �������� ����� �� �������, � ���������.;")
  imgui.Text(u8"����� XIII. �����-���.\n13.1 �������������� ������ ������ ����� ������������� ���� ���������:\n13.1.1 ������� ����� �287 - ��������� ������ ���� �������������� �����.\n13.1.2 ������ ������ �255 - ��������� ������ ������������ �������.\n13.1.3 ����� ������ �61 - ��������� ������ ������������� ������� ��������.\n13.1.4 ����������� ����� �179 - ��������� ������ �������� ������� � �������������� ���������� �������� �����.\n13.1.5 ����� � ������������ ������� �73 - ��������� ������ ������ ���� � ���, ���;\n13.1.6 ����� �191 - ������������� ��� �������� ����, ���������� �� ��������� � ������.\n13.2 ������������ � ������� �����, �������������� ������ ����� ����������� ��� ����������.\n������ ����������� ����� ���������� �� ������.\n13.3 ����������, �� ��������� � ������ 13.2 ������ ����� �������� ������������ ��� ���� ��������������.")
  imgui.Text(u8"����� XIV. ������� ���������.\n14.1 �������� ��� ������� ������.\n14.1.1 �������� ������� �� ������� � ���������� � ��� ���������.\n14.1.2 ���� ���� �������� ������� � ����������\n�� ������ ���������� ��� ����������.\n14.1.3 ���� � ����� ��� 1 �������� ������� � �� ������� ��� ���� - ����\n���������� �� ���� ������� �� 2 �������� ��������.\n14.1.4 ���� � ����� ���� 2 �������� �������� � �� ������� ��� ���� - ����\n����������� �� ����� �� 3 �������� ��������.\n14.2 �������� ��� ������� ��������\n14.2.1 ������� �������� ������� � ����� ������ ������ ���.���.����� � �������.\n����������: �������������, FBI.\n14.2.2 �������� � ������� �������� �� ����� ������, ������� �����\n����� ������ ������� ����� �� ������ ������ �������� ������� �� ������.\n14.2.3 �� �������������� ��������� �������� ������� �������� ������ ��������������.\n14.2.4 ���� ������� ������ �������� 2 ������ �������������� ��� ������������� �������� �������.\n14.2.5 ���� � �������� ������� ���������� 2 �������� �������� �� �������� ���� ���� � ���������� �� ��������.\n14.2.6 ���������/���� ������� �������� �������, � ����� ����� �������/������,\n�� ���� �������� ���������� �� ��������� ����� ��������/�������.\n")
  imgui.Text(u8"                                                                                              ����������� �������������")
  imgui.Text(u8"\n������������� �����.\n0.1. ����������� ������������� � ��� ����������-�������� ���, ������� ��� ������� ������\n������ ����� � ������ ��������������� �����������.\n����������� ������������� � ��� ����������-�������� ���,\n������� �������� ������ ����������� ����� ������� �\n������������ ����� � ����������� �� ���������� ������ ����������� ������������� � �����.\n0.2. ����������� ������������� ������� ����������� ���� ������������� ��� ����������� � �����.\n0.3. ����������� ������������� ����� ���� �������� ���������� ���\n[ ��� ������� ��������� �������������� ]\n� ����� ����� ��� � ����, ��� ���������� � ���� ���������� ����� 48 ����� ����� ����������.\n0.4. ����������� ������������� ������� ����������� ����� ������������ �������������� �����������.\n0.5. �������� ������������ ������������� �� ����������� ����������� �� ���������������.")
  imgui.Text(u8"����� �1.\n������������ ������ ��������������.\n1.1. ����������� ������������������� ���������� �������������� ������ ������ ������\n������������ ���� / ���������� ��������������� ����������� � ��������� / ����������.\n����������: �� ����������������� ���������� ��������������� ������������� ��� �����������,\n������������ �������� ���������� �������. ������ ���������� �� ���������������� �� ������� ����.\n1.2. ����������� ����� �������� ����� � ����������� ������� ����������\n�� ��� ����������� ��� ��������� ������� � ����������.\n1.3. ����������� ���������� ������� � ��������� ��� �������,\n��� � ����������� ��� ������ ��� � ��������� / ����������.\n����� �2.\n������������� � ��������� ����������� ������������ ���� ������������� � �����.\n2.1. ����������� ��������� �� ���������� FBI ��� ��������� ������������ ��������\n�� ������ �� ������� ��� ���� ��.������ � ������� / ���������.\n����������: �����������, ��������� �����, ������� ���������� �� ���������.\n2.2. ����������� �������� ���� �� ������ ���������������� ���������� � ��������� / ����������.\n����������: ������ ��� �� ����� ������� ������������ �������� ��� ����������.\n2.3. ����������� ����� ����������� ����������\n[ ������� / ��������� / ���� ������ ��� ������������ ��� ]\n��� ������� ��� � ����������.\n2.4. ����������� ������������ ������ ��� � ������ ��� �������� ���������� � ��������� / ����������.\n����������: ������ ��� �� ����� ������� ������������ �������� ��� ����������.\n2.5. ����������� �������� / ������������� ������ ��� � ����������.\n2.6. ����������� ���������� ��������� / ����������, �������� ������� ��� / ������������ ���-����,\n����� ��� � ����������� ������� ����� � ��������� / ����������.\n2.7. ����������� ���������� �������� ������ ���, ���� ��� ��������� ��� ���������� � ����������.\n����������: ���� ����� ��� ��������� �� ��������� ����� ������� /spy, � �� ����� ����������,\n�� ������ ����� �� �������� ��������� �� ��� ���������.\n�� ����� � ����� ���� ����� �������� ����������, ������� ������� � ��������� ������.\n2.8. ����������� ������� ������ � ������ �������������� �������� �� ������ ������� ������,\n���������� ������ ���� �������� � ��������������� ���������� � ������� / ���������.\n����������: ��������� ������������ ����������� ������ ���������, ����-�� IC, ����-�� OOC. [ /r, /rb, /ticket ]\n2.9. ����������� �������� �������� �� ��� � ��������� / ����������.\n����������: ����� ����� ����� ��� ������� � ���� � �������� ��������.\n��� ������ ��������� ��������������� ��������� �������� ������.\n2.10. ��������� ��������� ������� �� ��������� � ������� ��� ��� ����������\n[ ������, ���������� � ������ ],\n� ����� ������� ������ � ������ ����������� ������������ ���� � ������� / ���������.\n����������: ����� � ���������� �� �������� ������� ��� ����������.")
  imgui.Text(u8"����� �3.\n������������� � ��������� ����������� ������������� � �����.\n3.1. ����������� ����� ���������� ������������� ��������� � ������� / ��������� / ����������.\n����������: ��� ������������ ���������� ��������������� ������ ���. �������� �� �����������,\n���������� ������������ ���� �� ������ � ���� ��������� ������� �����,\n������� �������� � ������������ ��������� ���������� ������� ������������ �������������\n3.2. ����������� �������� ������� ����� � �������.\n����������: ����� ��� ���� ��������������� ������������ � ������������ ������������� ������� /time,\n�������� � ������ ������������.\n3.3. ����������� ������� ������ ���������������� ���������\n[ ����� �� �����/�����/���� � ������������ ] � ���������� + �� �������.\n3.4. ����������� ������ �������� ������ ���������� ���������������� ���������� � ������� / ��������� / ����������.\n����������: ��� ����� ������ ��������� ��������������� ����� ����������/�������� ����������,\n������� ����������� ��������������� ���������.\n3.5. ����������� ������������� ��������� ���������,\n� ��� �� ��������� ����� ����������� ��� � ������� / ���������.\n3.6. ����������� ��������������� ����������� ������� � ������� � ������/������� � ����������.\n����������: ����. �������� [ ������������ �������� �������� ������� ].\n3.7. ����������� ��� ���������� / �������� [ ���������� ] �������� ����� / ����\n����� � ������� / ��������� / ����������.\n����������: ���������� � ����������� ���� �� �������� ���������� ������� ������ ������������ �������������.\n3.8. ����������� ������ ����� �� ��������������� ���������� ��������� / ������ � ������� / ���������.\n����������: ������������ ����� � ������ ��������������� ������������� �����������.\n3.9. ����������� � ������� ����� ������ �� ���� ���������� ���������� � ������� / ���������.\n����������: ��� ����������� ������������ ��������������� ���� ���������� �������� �� ���� ���. ���������.\n��������� ������� ����, ����, ������ ������� �� ����. ��� �� ��������� ����������,\n��������������� ������������� ���. ��������� [ ������, ���������� ����� ].\n3.10. ��������� ��������� ������� � ���� ������ ������� ��� ����������� ��� � ������� / ��������� / ����������.\n����������: ���� �� �������� � ������ �������� ���� ������������, �� ������ �������� �� ���� � �����������.")
  imgui.Text(u8"����� �4.\n������������ ��������������� ����������� ������ ���� ������, � ������ �������� ����������.\n4.1. ����������� �������� ������ �(���) ���������� ����� ��� ������� �� �� �������, �� �������.\n����� ������� - �� ���� ����� ��������� ����� � ������� / ��������� / ����������.\n4.2. ����������� ������������� ����-����, �� �����, ������ ���� ���������� � ������� / ��������� / ����������.\n4.3. ����������� ������������ ����������� �����, � ����� ����������� � ������� / ��������� / ����������.\n����������: �� ������� ������ ������������ �������� ������/���������, � ������,\n���� ��������� ��������� ��� ���������� �/��� ����� ��������� �\n���������������� ������������.\n��������� ����� ������ ��������� ���������������� ��� �� IC ��� � �� OOC ���� [ ���, /fb, /f. ].\n4.4. ����������� � ������� ����� ���������� ������ ������ � ������� �����,\n������������� ������� ��������������� �����������\n[ ���� � ������, ������� � ���������, base jump, �����, � ������ ����������� � ��������������� ������.\n� ��� ����� ��������� ��������� ����������� � ����������\n�������. ] � ������� / ��������� / ����������.\n����������: ����������� �� ������������� [ �� ������� ��������� ],\n���������� ��������� ������������ [ ������ ���������, �������� �������������� ����\n������� ����.������� ����� � ��. �������� ], ���� � 13:00 �� 14:00 [ ����� ���������� ����� ],\n���������� �����������, ��. �������.\n����������: ����������� ������������ ��� ����� �� ����� ����� �������� ���������� �� ���������\n[ � ����� ���� ]\n� ������ � ���������� ������� � �� ����� ����� � ������� ����� �������� [ � ����� ���� ] �� ��������������.\n4.5. ����������� �������� � ������������ ������������� �������, � ����� �������� �������� ����������.")
  imgui.Text(u8"��� ��� ������ �������� �������� ����������������� ���������� � �����. � ����������.\n����������: ���������� PD, ���������� ��� � ����� ����. �������� [ � ������������ ��������� �������� ������� ].\n4.6. ����������� ���������� � ������� ������ ��� ����. �������� � ������� / ��������� / ����������.\n����������: ����������� �������,����������� ������ [ ������������ �������� �� ������� ����������� ����������� ].\n4.7. ����������� ��������� � ������ �� �� ���������� ������� � ������� / ���������.\n4.8. ����������� ������������ �������� �� ������ � ������ ������ � ������� / ���������.\n����������: ������� �� ������ - � ������ ����� �����������.\n4.9. ����������� ����������� �������� � ������� ����� � ���������.\n4.10. ����������� ����� / ������ ������ � ����������.\n����������: ����������� ��������� Bad Cops.\n��� ������ ���� � ��������������� ������� ���� ������� � ���������� ����� � ���������\n[ screen & /time ].\n� ������ ���� ��� ������ ��������� � ����� ����� - ������������� �� ��������� ������ ������������ �������������.\n4.11. ����������� �������� ������� ����� ������������ � ������� / ���������.\n����������: ����������� ���.������������ ������� ��������� ��������� ����������\n�� ������ � ��������� �� �� ����� ������������, ������ �����\n���������������� ���� �� ���, ��� ��� ���� ��� ����� �� ��.\n���������� ������ ������ �� �������� ��������� ���������� ����������: �OG, �� ���������, ������\n��� ���������, � ����� ��������� ��� ��� � ������������ ��������� ���������� ����������,\n������ ����, ���������� ���������.\n4.12. ����������� ����������� ���������� ��������������� ����������� � ������� / ���������.\n����������: � ������, ���� ������������ ����� ��� ����������/�����������,")
  imgui.Text(u8"������� ���� �� ������� �� ����������� �������� � ������ ������� �� ����� ��������� � ���������������.\n4.13. ����������� ������ �������� ��� ������� �� �� ������ � ����������� ��������� �������� �� ����\n����������� ������� � ���������� ���. ������� � ������� / ���������.\n����������: ���� �� �������, ��� ��������������� ��������� ������� ������� ��������� ��������\n��� � ����������� ����� �� [ ��� ����������������� ������� �������� ],\n� � ��� ���� ��������������, �� ������ ������ ����� ������� ��������.\n4.14. ����������� �������� ������������ ��� ������� �� �������� �� ������ � ������� / ���������.\n4.15. ����������� �������� � ���������� ��� �������� ������������� � ��������� / ����������.\n����������: ��������� ������������ ������������ � �����������, ���� ��� �������� � ������ ����\n� � ��� ���� ��������������.\n4.16. ����������� �������� ������ �����, � ������: ��������� ������ � ���������������� �������,\n�����������, ������ �� / ����� � ������ ������� ������������� ������-����\n��������� ������ � ������� / ��������� / ����������.\n����������: ���� � ��� ���� ��������������, �������������� ���� ������ ���� ���������\n������������ �� ������: ����������� ���� � �������; ������ ������� ���������;\n��� ���������� ���������� �����, �� �������� �� ��� ���������� ��������� ������������ [ �� � ����� ];\n������ �������� �� ������ � ������ ������.\n4.17. ����������� ������������ ������������ ������� ��� � ��������� / ����������.\n4.18. ����������� ������������ ����������� � ������ ������ ����� Evolve � ��������� / ����������.\n4.19. ����������� �������� ������� ����������� � ����������.\n4.20. ����������� �������� ������� ����������� ��� � ��������� / ����������.")
  imgui.Text(u8"4.21. ��������� �������� ����� �� �������� �� ����.��������/�� ������ ��� ������/���������/������ �����.\n��������� ������ ����� �� ������� ������ ��� � �������� �������������. � ������� / ���������.\n����������: ������ ����� � ������� [ � ������ ] ����� ���������.\n��� ��������������� ������ ������� ������� ��������� �� ���������� ����������� ����������.\n4.22. ����������� ������������ ������ ������������ �������� � ��������� ����� � ���������,\n�� ��������������� ����������� ������� ���.�����������. � �������.\n����������: ������ ����� ��������� � ������ ������� � ������.\n������������ ������ ��������� ����� ����. ������������� � ������� ���������� ������ �����,\n����� � ���� ���.\n4.23. ����������� ��������� ���� ����������� ���������� � ��������� / ����������.\n4.24. ����������� ��������� � ������ ��������������/����������� ���� �� ��� ������ ����� � ������� / ���������.\n����������: �������������� ������� ��������� [ ����������� �������� ��� ����������� ],\n� ����� ������ ������ �������� ���������� �� ����, � ����� �� ��� ���.\n����������� ����� ������ ������� � ������ ����������������� �������� � ������������� ��� ����� �� ������\n[ �.�. ����������� ���������� ����, ������� ������������� � /time ����������� ].\n4.25. ����������� �������� ����� ������� ������� � ������� / ��������� / ����������.\n4.26. ��������� ����������� / ������������ ������������ �� �������� ������ �����,\n����������� � ������� ��������, �� �������������� ��������� ������ ���������. � ������� / ��������� / ����������.\n4.27. ����������� ����������� ����� ���������� AF, � ����� ���� ������� ��������������� ��������\n� �� ������������ � ������� � �������� ����� ��� ��������� FBI � ������� / ���������.")
  imgui.Text(u8"����������: � ������, ���� �� ������� � ����������� ����� �� ���� ����� � ������� 5 �����,\n�� ����������� ����� � ��� ��������� FBI, �� � ������������ ��������� �������.\n4.28. ����������� �������� ������� ��������� �����,\n� ����� ����������������� �������� ������������ ��������� � ����-������������,\n������������ �� ����������, ��������� � ������ �� ������ ����� � ������� / ���������.\n4.29. ����������� ������������ ������� � ������ �����,\n� ������ � ��������� ����������� � ��������,\n����� � ������ ����, �� ����������� � ������� �������� � ������� / ���������.\n����������: [ ������� � ���, ���, ��� ����?� & ������� ����������?� ] � ��� ������ ������!")
  imgui.Text(u8"����� �5.\n5.1. ��������� ��� ����� ����� ������� ��������� �� �������������� ��������� � ���� ��������������\n���� ���� ��������� �� ��������������� ��������\n���������� ���� ��� ���������� ���������������.\n���������� ��������������� �������� ��������� ���. ��������� � ��������� ���������,\n���� �������������� ������������ ����� ��������\n� ������������� ������������� ����� ����������.\n5.2. ��������� ����� ��� �� ������ ������� ������ � ����� ���� � ����������� ����� �� �������� ��.\n5.3. ����� ��������� �������������� ������� ���, ������ �� ��� �������� ������ � �����.\n������ �������������� �� ������, ������� ��� ��� ����� �������� ��������� ��������������� ������������ - ���������.\n5.4. ��������� ����� ����� �������� ������ ���� ��������������,\n��� ����������� ���������� ������� ����� ������ ���������.\n5.5. ������, ����������������� ����� ���� ���������,\n������������� ���������� ������ �� ��� �� ���������� ��������� ���������,\n� ����������� �� ������� ��������� � ������� �������� ��������������,\n���� ��������� � �������.\n5.6. ������������ ��������. � ������ ���������� ��������������� ����������� ������,\n������� ����� ������ �� ��������� ��������� ��� ��� ���� ������ ������ ��\n����������-�������� �����, ����������� ������ ��� ����� ����� ���������\n����� �� ����������� ������� ��������������� ���, �������� ��� ���� �� ��.")
  imgui.Text(u8"����� �6.\n���������� ������� ���.\n6.1. �������� FBI � ���� ����� ����� ������ ������ ������ ����� �� ������ ������� � �������� ������� �� ������\n������� ������������ ��� �� [ �������/��������� ].\n6.2. ����� DEA/CID ����� ����� ������ ������ ������ ����� �� ������\n��������� � �������� ������� �� ������ ��.��������� ������������.\n6.3. ����� DEA/CID ����� ����� ������ ������ ������ ����� �� ������\n����� � �������� ������� �� ������ ����� ������������.\n6.4. ��������� FBI ����� ����� ������ ������ ������ ����� �� ������ \n������������ � �������� ������� �� ������ ������������ ������������.\n6.5. ���. ��������� FBI ����� ����� ������ ������ ������ ����� �� ������\n��������� � �������� ������� �� ������ ��������� ������������.\n����������: � �������, ����� ��������� ��� ��� �� ������� ����� [ �� � ����/�������� ],\n����������� ��������� ��� ����� ����� ������ ������ ������ ���������� ������� ��������.\n6.6. �������� FBI ����� ����� ������ ������ ������ ����� �� ������\n������� � �������� ������� �� ������ ����� ������������.")
  imgui.Text(u8"����� �7.\n���� ������� ��� ��������������� ��������.\n7.1. �������, ������������� ���� � ������ ����� �������� �������.\n����� ������ �������, �������� �� �� ������ �������� �� ���������� ����������� �����.\n7.2. ��������� ��/����� ����� �������� ������� � ���� ��������������\n�� ��������� ������������ ������������� / ����������� ������ �����������.\n7.3. ��������� ��/����� ����� �������� ������� � ���� ������ �� ���������\n������������ ������������� / ����������� ������ �����������.\n7.4. ��������� ��/����� ����� �������� ������� � ���� �������� �������� �� 7 ���� �� ���������\n������������ ������������� / ����������� ������ �����������.\n7.5. ��������� ��/����� ����� �������� ������� � ���� �������� �������� �� 14 ���� �\n��������� ��������� �� ��������� ������������ ������������� / ����������� ������ �����������.\n7.6. ��������� ��/����� ����� �������� ������� � ���� ��������� �� ���������\n������������ ������������� / ����������� ������ �����������.\n7.7. ��������� ��/����� ����� �������� ������� � ���� ���������� �� ���������\n������������ ������������� / ����������� ������ �����������.")
  imgui.End()
end

function nyamnyam()
  local result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
  if result then
    local animid = sampGetPlayerAnimationId(id)
    if animid == 536 then
      sampSendChat("��� ���.")
      wait(6000)
    end
  end
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