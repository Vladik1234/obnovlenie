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
local t_se_au_to_clist, k_r_u_t_o, a_u_t_o_tag, a_u_t_o_screen, m_s_t_a_t, s_kin_i_n_lva, priziv, lwait, sdelaitak, pozivnoy, styazhki = "config/SOBR tools/config.ini"
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
  Tag = "Íå óêàçàí.",
  cvetclist = "Íå óêàçàí.",
  lwait = "Íå óêàçàíà.",
}

local monikQuant = {}

local monikQuantNum = {}

local settings = {}

script_author("Tarasov")
script_name("SOBR tools")
script_version_number(1)
script_description("Ñêðèïò äëÿ ÑÎÁÐ")

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
        Tag = "Íå óêàçàí.",
        cvetclist = "Íå óêàçàí.",
        lwait = "Íå óêàçàíà.",
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
    styazhki = cfg.global.styazhki
    settings = cfg
    CreateFileAndSettings()
    local _, pID = sampGetPlayerIdByCharHandle(PLAYER_PED)
    name = sampGetPlayerNickname(pID)
    if name == "Weaver_Tail" or name == "Charles_Montenegro" or name == "Tim_Vedenkin" or name == "Leo_Florenso" or name == "Misha_Samyrai" or name == "Angel_Galante" or name == "Aleksey_Tarasov" or name == "Valentin_Molo" or name == "Evan_Corleone" or name == "Kevin_Spencor" or name == "Brain_Spencor" or name == "Sergu_Sibov" or name == "Jimmy_Saints" or name == "Saibor_Ackerman" or name == "Christopher_Shaffer" or name == "Barbie_Bell" or name == "Boulevard_Bledov" or name == "Hieden_Bell" or name == "Bogdan_Mishenko" or name == "Ashton_Edwards" or name == "Santiago_Belucci" or name == "Chris_Ludvig" or name == "Jack_Lingard" or name == "Thomas_Rinner" or name == "Aiden_Florestino" or name == "Steven_Green" or name == "Hidan_Bell" then
      sampAddChatMessage("[SOBR tools]: "..name..", äîñòóï îòêðûò.", 0x33AAFFFF)
    else
      sampAddChatMessage("[SOBR tools]: "..name..", â äîñòóïå îòêàçàíî.", 0xFFB22222)
      thisScript():unload()
    end
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
 
    sampRegisterChatCommand("przv",function() if settings.global.priziv == true then sampAddChatMessage("[SOBR tools]: Ðåæèì ïðèçûâà îòêëþ÷¸í.", 0xFFB22222) settings.global.priziv = false else sampAddChatMessage("[SOBR tools]: Ðåæèì ïðèçûâà âêëþ÷¸í.", 0x33AAFFFF) settings.global.priziv = true end end)

    sampRegisterChatCommand("splayer",function() if settings.global.sdelaitak == true then sampAddChatMessage("[SOBR tools]: Îòîáðàæåíèå â ÷àòå íèêîâ âîåííûõ êîòîðûå ïîÿâèëèñü â çîíå ñòðèìà îòêëþ÷åíî.", 0xFFB22222) settings.global.sdelaitak = false else sampAddChatMessage("[SOBR tools]: Îòîáðàæåíèå â ÷àòå íèêîâ âîåííûõ êîòîðûå ïîÿâèëèñü â çîíå ñòðèìà âêëþ÷åíî.", 0x33AAFFFF) settings.global.sdelaitak = true end end)

    sampRegisterChatCommand("pst",function() if settings.global.m_s_t_a_t == true then sampAddChatMessage("[SOBR tools]: Òåïåðü ó âàñ â ñêðèïòå æåíñêèå îòûãðîâêè.", 0xFFB22222) settings.global.m_s_t_a_t = false else  sampAddChatMessage("[SOBR tools]: Òåïåðü ó âàñ â ñêðèïòå ìóæñêèå îòûãðîâêè.", 0x33AAFFFF) settings.global.m_s_t_a_t = true end end)

    sampRegisterChatCommand("ascreen",function() if settings.global.a_u_t_o_screen == true then sampAddChatMessage("[SOBR tools]: Àâòîñêðèí ïîñëå ïýéäåÿ áûë âûêëþ÷åí.", 0xFFB22222) settings.global.a_u_t_o_screen = false else sampAddChatMessage("[SOBR tools]: Àâòîñêðèí ïîñëå ïýéäåÿ áûë âêëþ÷¸í.", 0x33AAFFFF) settings.global.a_u_t_o_screen = true end end)

    sampRegisterChatCommand("atag",function() if settings.global.a_u_t_o_tag == true then sampAddChatMessage("[SOBR tools]: Àâòîòåã â ÷àò áûë âûêëþ÷åí.", 0xFFB22222) settings.global.a_u_t_o_tag = false else sampAddChatMessage("[SOBR tools]: Àâòîòåã â ÷àò áûë âêëþ÷åí.", 0x33AAFFFF) settings.global.a_u_t_o_tag = true end end)

    sampRegisterChatCommand("lp",function() if settings.global.k_r_u_t_o == true then sampAddChatMessage("[SOBR tools]: Îòêðûâàíèå àâòî íà êëàâèøó `L` áûëî âûêëþ÷åíî.", 0xFFB22222) settings.global.k_r_u_t_o = false else sampAddChatMessage("[SOBR tools]: Îòêðûâàíèå àâòî íà êëàâèøó `L` áûëî âêëþ÷åíî.", 0x33AAFFFF) settings.global.k_r_u_t_o = true end end)

    sampRegisterChatCommand("aclist",function() if settings.global.t_se_au_to_clist == true then sampAddChatMessage("[SOBR tools]: Àâòîêëèñò âûêëþ÷åí.", 0xFFB22222) settings.global.t_se_au_to_clist = false else sampAddChatMessage("[SOBR tools]: Àâòîêëèñò âêëþ÷åí.", 0x33AAFFFF) settings.global.t_se_au_to_clist = true end end)

    sampRegisterChatCommand("abp", Settingsabp)

    sampRegisterChatCommand("smembers", smembers)

    sampRegisterChatCommand("ñòÿæêè", function() if settings.global.styazhki == true then sampAddChatMessage("[SOBR tools]: Ñòÿæêè âûêëþ÷åíû.", 0xFFB22222) settings.global.styazhki = false else sampAddChatMessage("[SOBR tools]: Ñòÿæêè âêëþ÷åíû.", 0x33AAFFFF) settings.global.styazhki = true end end)

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
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)  
        if valid and doesCharExist(ped) and isKeyJustPressed(VK_B) then  
          local result, id = sampGetPlayerIdByCharHandle(ped)  
          local name = sampGetPlayerNickname(id):gsub("_", " ")
          if result and settings.global.styazhki == true then 
            sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
            wait(200)
            sampSendChat("/do Íà ïîÿñå âèñèò ïàðà ñâÿçîê.") 
            wait(settings.global.lwait)
            sampSendChat("/me ðåçêèì äâèæåíèåì ðóêè íàêèíóë ñòÿæêó íà ÷åëîâåêà")
            wait(settings.global.lwait)
            sampSendChat("/tie "..id.."")
            wait(settings.global.lwait)
            sampSendChat("/do "..name.." îáåçäâèæåí.")
            wait(settings.global.lwait)
            sampSendChat("/me ïðèêðåïèë çàäåðæàííîãî ñòÿæêîé ê ñâîåìó ïîÿñó")
            wait(settings.global.lwait)
            sampSendChat("/follow "..id.."")
            wait(200)
            sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
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
      if sampIsChatInputActive() and sampGetChatInputText() == "/äîêëàäû" then sampSetChatInputText("") submenus_show(RaciaDialog, "{808080}Äîêëàäû{FFFFFF}") end
      if isKeyJustPressed(VK_L) and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() and settings.global.k_r_u_t_o == true then sampSendChat("/lock") end
      if priziv == true and testCheat("Z") then submenus_show(LVDialog, "{00FA9A}ÏÐÈÇÛÂ{FFFFFF}") end
      if main_window_state.v == false then imgui.Process = false end
      if sampIsChatInputActive() and sampGetChatInputText() == "/cfaq" then sampSetChatInputText("") sampShowDialog(1285, "{808080}[SOBR tools] Êîìàíäû{FFFFFF}", "{808080}/aclist - âûêëþ÷èòü/âêëþ÷èòü àâòîêëèñò\n/lp - âûêëþ÷èòü/âêëþ÷èòü îòêðûâàíèå àâòî íà êëàâèøó `L`\n/atag - âûêëþ÷èòü/âêëþ÷èòü àâòî-òåã\n/ascreen - âûêëþ÷èòü/âêëþ÷èòü àâòî-ñêðèí ïîñëå ïýéäåÿ\n/sw, /st - ñìåíèòü èãðîâîå âðåìÿ/ïîãîäó\n/cc - î÷èñòèòü ÷àò\n/kv - ïîñòàâèòü ìåòêó íà êâàäðàò\n/getm - ïîêàçàòü ñåáå ìîíèòîðèíã, /rgetm - â ðàöèþ\n/przv - âêëþ÷èòü/âûêëþ÷èòü ðåæèì ïðèçûâà\n/abp - âûêëþ÷èòü/âêëþ÷èòü àâòî-ÁÏ íà `alt`\n/hphud - âêëþ÷èòü/îòêëþ÷èòü õï õóä\n/abp - âêëþ÷èòü íàñòðîéêè àâòî-ÁÏ\n/splayer - âêëþ÷èòü/âûêëþ÷èòü îòîáðàæåíèå â ÷àòå íèêîâ âîåííûõ êîòîðûå ïîÿâèëèñü â çîíå ñòðèìà\n/fustav - ïîñìîòðåòü ÔÏ è óñòàâ\n/smembers - ïîñìîòðåòü îíëàéí îòðÿäà{FFFFFF}", "Ëàäíî", "Ïðîõëàäíî", 0) end
      if testCheat("JJJJJ") then getNearestPlayerId() end
      if isKeyJustPressed(VK_C) and isKeyJustPressed(VK_MULTIPLY) then getNearestPlayerId1() end
      if wasKeyPressed(VK_MENU) then abp() end
      nyamnyam()
      if rabbota == true then
        if testCheat("Y") then 
          sampSendChat("/r "..pInfo.Tag.." Çäðàâèÿ æåëàþ àðìèÿ.")
          rabbota = false
        end
      end
      if monitor == true then
        if testCheat("Y") then 
          rgetm()
          monitor = false
        end
      end
    end
end

function refreshDialog()
  SSSDialog = {
  
    {
      title = "{808080}Çàïðîñèòü ýâàêóàöèþ{FFFFFF}",
      onclick = function()
        sampSendChat("/r "..pInfo.Tag.." Çàïðàøèâàþ ýâàêóàöèþ â êâàäðàò "..kvadrat())
      end
    },
    {
      title = "{808080}Íàäåòü ìàñêó{FFFFFF}",
      onclick = function()
        if m_s_t_a_t == true then
            sampSendChat("/me äîñòàë ìàñêó èç êàðìàíà è íàäåë íà ëèöî")
            wait(1200)
            sampSendChat("/mask")
            wait(1200)
            sampSendChat("/clist 0")
            wait(1200)
            sampSendChat("/do Íà ëèöå ìàñêà. Ëèöà íå âèäíî. Ôîðìà áåç íàøèâîê è ïîãîí.")
        else
            sampSendChat("/me äîñòàëà ìàñêó èç êàðìàíà è íàäåëà íà ëèöî")
            wait(1200)
            sampSendChat("/mask")
            wait(1200)
            sampSendChat("/clist 0")
            wait(1200)
            sampSendChat("/do Íà ëèöå ìàñêà. Ëèöà íå âèäíî. Ôîðìà áåç íàøèâîê è ïîãîí.")
        end
      end
    },
    {
      title = "{808080}Îòûãðîâêè{FFFFFF}",
      submenu = 
      {
        title = "{808080}Îòûãðîâêè{FFFFFF}",
        {
          title = "{808080}Ðàçìèíèðîâàíèå{FFFFFF}",
          submenu = 
          {
            title = "{808080}Âûáåðèòå îòûãðîâêó{FFFFFF}",
            {
              title = "{808080}Ðàçìèíèðîâàíèå âçðûâ÷àòêè ñ ÷àñîâûì ìåõàíèçìîì{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Íå óêàçàíà." and settings.global.lwait ~= "Íå óêàçàíà" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me äîñòàë íàáîð ñàïåðà")
                    wait(settings.global.lwait)
                    sampSendChat("/me îïðåäåëèë òèï âçðûâíîãî óñòðîéñòâà")
                    wait(settings.global.lwait)
                    sampSendChat("/do Âçðûâ÷àòêà ñ ÷àñîâûì ìåõàíèçìîì.")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàë îòâåðòêó")
                    wait(settings.global.lwait)
                    sampSendChat("/me àêêóðàòíî îòêðó÷èâàåò áîëòû íà êîðïóñå óñòðîéñòâà")
                    wait(settings.global.lwait)
                    sampSendChat("/me îáíàðóæèë â ìåõàíèçìå íåñêîëüêî ïðîâîäîâ")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàë êóñà÷êè èç ñàïåðñêîãî íàáîðà")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿë ñèíèé ïðîâîä â ðóêè")
                    wait(settings.global.lwait)
                    sampSendChat("/me ñ ïîìîùüþ êóñà÷åê îãîëèë ïðîâîäà")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàë èíäèêàòîðíóþ îòâåðòêó")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïðèëîæèë îòâåðòêó ê îãîëåííîìó ïðîâîäó")
                    wait(settings.global.lwait)
                    sampSendChat("/do Ñâåòîäèîä â îòâåðòêå çàãîðåëñÿ.")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿë â ðóêè êóñà÷êè")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïåðåðåçàë ïðîâîä")
                    wait(settings.global.lwait)
                    sampSendChat("/me Òàéìåð îñòàíîâëåí.")
                    wait(settings.global.lwait)
                    sampSendChat("/me îòñîåäåíèë äåòàíàòîð")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿë áðîíèðîâàííûé êåéñ")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïîëîæèë âçðûâ÷àòêó â êåéñ")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïîëîæèë âñå èíñòðóìåíòû â íàáîð ñàïåðà")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me äîñòàëà íàáîð ñàïåðà")
                    wait(settings.global.lwait)
                    sampSendChat("/me îïðåäåëèëà òèï âçðûâíîãî óñòðîéñòâà")
                    wait(settings.global.lwait)
                    sampSendChat("/do Âçðûâ÷àòêà ñ ÷àñîâûì ìåõàíèçìîì.")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàëà îòâåðòêó")
                    wait(settings.global.lwait)
                    sampSendChat("/me àêêóðàòíî îòêðó÷èâàåò áîëòû íà êîðïóñå óñòðîéñòâà")
                    wait(settings.global.lwait)
                    sampSendChat("/me îáíàðóæèëà â ìåõàíèçìå íåñêîëüêî ïðîâîäîâ")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàëà êóñà÷êè èç ñàïåðñêîãî íàáîðà")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿëà ñèíèé ïðîâîä â ðóêè")
                    wait(settings.global.lwait)
                    sampSendChat("/me ñ ïîìîùüþ êóñà÷åê îãîëèëà ïðîâîäà")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàëà èíäèêàòîðíóþ îòâåðòêó")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïðèëîæèëà îòâåðòêó ê îãîëåííîìó ïðîâîäó")
                    wait(settings.global.lwait)
                    sampSendChat("/do Ñâåòîäèîä â îòâåðòêå çàãîðåëñÿ.")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿëà â ðóêè êóñà÷êè")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïåðåðåçàëà ïðîâîä")
                    wait(settings.global.lwait)
                    sampSendChat("/me Òàéìåð îñòàíîâëåí.")
                    wait(settings.global.lwait)
                    sampSendChat("/me îòñîåäåíèëà äåòàíàòîð")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿëà áðîíèðîâàííûé êåéñ")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïîëîæèëà âçðûâ÷àòêó â êåéñ")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïîëîæèëà âñå èíñòðóìåíòû â íàáîð ñàïåðà")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}Ðàçìèíèðîâàíèå óíèâåðñàëüíîå{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Íå óêàçàíà." and settings.global.lwait ~= "Íå óêàçàíà" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do Íà ñïèíå âèñèò áîåâîé ðþêçàê.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ñòÿíóë ðþêçàê ñî ñïèíû, çàòåì äîñòàë íàáîð äëÿ ðàçìèíèðîâàíèÿ")
                    wait(settings.global.lwait)
                    sampSendChat("/me àêêóðàòíî îñìîòðåë áîìáó")
                    wait(settings.global.lwait)
                    sampSendChat("/me âûòàùèë èç íàáîðà ýëåêòðè÷åñêóþ îòâåðòêó òèïà `PS-201`")
                    wait(settings.global.lwait)
                    sampSendChat("/me îòêðóòèë øóðóïû ñ ïàíåëè áîìáû")
                    wait(settings.global.lwait)
                    sampSendChat("/me îáåèìè ðóêàìè àêêóðàòíî ñíÿë êðûøêó ñ áîìáû, ïîñëå ÷åãî âûòàùèë èç íàáîðà ùèïöû")
                    wait(settings.global.lwait)
                    sampSendChat("/do Íà áîìáå âèäåí êðàñíûé è ñèíèé ïðîâîä.")
                    wait(settings.global.lwait)
                    sampSendChat("/me íàäðåçàë ïðîâîä áîìáû, ïîñëå ÷åãî ïåðåêóñèë êðàñíûé ïðîâîä")
                    wait(settings.global.lwait)
                    sampSendChat("/do Òàéìåð çàìîðîæåí è áîìáà áîëüøå íå ïðèãîäíà ê èñïîëüçîâàíèþ.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do Íà ñïèíå âèñèò áîåâîé ðþêçàê.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ñòÿíóëà ðþêçàê ñî ñïèíû, çàòåì äîñòàë íàáîð äëÿ ðàçìèíèðîâàíèÿ")
                    wait(settings.global.lwait)
                    sampSendChat("/me àêêóðàòíî îñìîòðåëà áîìáó")
                    wait(settings.global.lwait)
                    sampSendChat("/me âûòàùèëà èç íàáîðà ýëåêòðè÷åñêóþ îòâåðòêó òèïà `PS-201`")
                    wait(settings.global.lwait)
                    sampSendChat("/me îòêðóòèëà øóðóïû ñ ïàíåëè áîìáû")
                    wait(settings.global.lwait)
                    sampSendChat("/me îáåèìè ðóêàìè àêêóðàòíî ñíÿëà êðûøêó ñ áîìáû, ïîñëå ÷åãî âûòàùèë èç íàáîðà ùèïöû")
                    wait(settings.global.lwait)
                    sampSendChat("/do Íà áîìáå âèäåí êðàñíûé è ñèíèé ïðîâîä.")
                    wait(settings.global.lwait)
                    sampSendChat("/me íàäðåçàëà ïðîâîä áîìáû, ïîñëå ÷åãî ïåðåêóñèë êðàñíûé ïðîâîä")
                    wait(settings.global.lwait)
                    sampSendChat("/do Òàéìåð çàìîðîæåí è áîìáà áîëüøå íå ïðèãîäíà ê èñïîëüçîâàíèþ.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}Ðàçìèíèðîâàíèå âçðûâíîãî óñòðîéñòâà ñ äèñòàíöèîííûì óïðàâëåíèåì{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Íå óêàçàíà." and settings.global.lwait ~= "Íå óêàçàíà" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me äîñòàâ ñàïåðíûé íàáîð, ðàñêðûë åãî")
                    wait(settings.global.lwait)
                    sampSendChat("/me îñìîòðåë âçðûâíîå óñòðîéñòâî")
                    wait(settings.global.lwait)
                    sampSendChat("/do Îïðåäåëèë òèï âçðûâíîãî óñòðîéñòâà `Áîìáà ñ äèñòàíöèîííûì óïðàâëåíèåì`.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Óâèäåë äâà øóðóïà íà áëîêå ñ ìåõàíèçìîì.")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàë îòâåðòêó èç ñàïåðíîãî íàáîðà")
                    wait(settings.global.lwait)
                    sampSendChat("/do Îòâåðòêà â ðóêå.")
                    wait(settings.global.lwait)
                    sampSendChat("/me àêêóðàòíî âûêðóòèë øóðóïû")
                    wait(settings.global.lwait)
                    sampSendChat("/me îòîäâèíóë êðûøêó áëîêà è óâèäåë àíòåííó")
                    wait(settings.global.lwait)
                    sampSendChat("/do Óâèäåë êðàñíûé ìèãàþùèé èíäèêàòîð.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïðîñìîòðåë ïóòü ìèêðîñõåìû îò àíòåííû ê äåòîíàòîðó")
                    wait(settings.global.lwait)
                    sampSendChat("/me óâèäåë äâà ïðîâîäà")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïåðåðåçàë ïåðâûé ïðîâîä. Èíäèêàòîð ïåðåñòàë ìèãàòü")
                    wait(settings.global.lwait)
                    sampSendChat("/do Áîìáà îáåçâðåæåíà.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ñëîæèë èíñòðóìåíòû îáðàòíî â ñàïåðíûé íàáîð")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàë áðîíèðîâàííûé êåéñ è àêêóðàòíî ñëîæèë òóäà áîìáó")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me äîñòàâ ñàïåðíûé íàáîð, ðàñêðûëà åãî")
                    wait(settings.global.lwait)
                    sampSendChat("/me îñìîòðåëà âçðûâíîå óñòðîéñòâî")
                    wait(settings.global.lwait)
                    sampSendChat("/do Îïðåäåëèëà òèï âçðûâíîãî óñòðîéñòâà `Áîìáà ñ äèñòàíöèîííûì óïðàâëåíèåì`.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Óâèäåëà äâà øóðóïà íà áëîêå ñ ìåõàíèçìîì.")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàëà îòâåðòêó èç ñàïåðíîãî íàáîðà")
                    wait(settings.global.lwait)
                    sampSendChat("/do Îòâåðòêà â ðóêå.")
                    wait(settings.global.lwait)
                    sampSendChat("/me àêêóðàòíî âûêðóòèëà øóðóïû")
                    wait(settings.global.lwait)
                    sampSendChat("/me îòîäâèíóëà êðûøêó áëîêà è óâèäåëà àíòåííó")
                    wait(settings.global.lwait)
                    sampSendChat("/do Óâèäåëà êðàñíûé ìèãàþùèé èíäèêàòîð.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïðîñìîòðåëà ïóòü ìèêðîñõåìû îò àíòåííû ê äåòîíàòîðó")
                    wait(settings.global.lwait)
                    sampSendChat("/me óâèäåëà äâà ïðîâîäà")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïåðåðåçàëà ïåðâûé ïðîâîä. Èíäèêàòîð ïåðåñòàë ìèãàòü")
                    wait(settings.global.lwait)
                    sampSendChat("/do Áîìáà îáåçâðåæåíà.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ñëîæèëà èíñòðóìåíòû îáðàòíî â ñàïåðíûé íàáîð")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàë áðîíèðîâàííûé êåéñ è àêêóðàòíî ñëîæèë òóäà áîìáó")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}Ðàçìèíèðîâàíèå âçðûâíîãî óñòðîéñòâà ñ æó÷êîì-äåòåêòîðîì{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Íå óêàçàíà." and settings.global.lwait ~= "Íå óêàçàíà" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me îñìîòðåë âçðûâíîå óñòðîéñòâî")
                    wait(settings.global.lwait)
                    sampSendChat("/do Âèä áîìáû îïðåäåëåí.")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàë îòâåðòêó")
                    wait(settings.global.lwait)
                    sampSendChat("/me îòêðó÷èâàåò êîðïóñ áîìáû")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿë êóñà÷êè â ñàïåðíîì íàáîðå")
                    wait(settings.global.lwait)
                    sampSendChat("/me îãîëèë êóñà÷êàìè êðàñíûé ïðîâîä")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿë æó÷îê-äåòåêòîð â ñàïåðíîì íàáîðå")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïðèöåïèë æó÷îê-äåòåêòîð ê êðàñíîìó ïðîâîäó")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿë èçîëåíòó â ñàïåðíîì íàáîðå")
                    wait(settings.global.lwait)
                    sampSendChat("/me çàèçîëèðîâàë ïðîâîä")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿë êóñà÷êè ")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿë æó÷îê-äåòåêòîð")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïðèöåïèë æó÷îê-äåòåêòîð ê ñèíåìó ïðîâîäó")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿë êóñà÷êè")
                    wait(settings.global.lwait)
                    sampSendChat("/me îòðåçàë ñèíèé ïðîâîä")
                    wait(settings.global.lwait)
                    sampSendChat("/me îòñîåäèíèë äåòîíàòîð")
                    wait(settings.global.lwait)
                    sampSendChat("/do Áîìáà îáåçâðåæåíà.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïîëîæèë âñå îáðàòíî â ñàïåðíûé íàáîð")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàë áðîíèðîâàííûé êåéñ")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïîìåñòèë áîìáó â áðîíèðîâàííûé êåéñ")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me îñìîòðåëà âçðûâíîå óñòðîéñòâî")
                    wait(settings.global.lwait)
                    sampSendChat("/do Âèä áîìáû îïðåäåëåí.")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàëà îòâåðòêó")
                    wait(settings.global.lwait)
                    sampSendChat("/me îòêðó÷èâàåò êîðïóñ áîìáû")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿëà êóñà÷êè â ñàïåðíîì íàáîðå")
                    wait(settings.global.lwait)
                    sampSendChat("/me îãîëèëà êóñà÷êàìè êðàñíûé ïðîâîä")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿëà æó÷îê-äåòåêòîð â ñàïåðíîì íàáîðå")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïðèöåïèëà æó÷îê-äåòåêòîð ê êðàñíîìó ïðîâîäó")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿëà èçîëåíòó â ñàïåðíîì íàáîðå")
                    wait(settings.global.lwait)
                    sampSendChat("/me çàèçîëèðîâàëà ïðîâîä")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿëà êóñà÷êè ")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿëà æó÷îê-äåòåêòîð")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïðèöåïèëà æó÷îê-äåòåêòîð ê ñèíåìó ïðîâîäó")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿëà êóñà÷êè")
                    wait(settings.global.lwait)
                    sampSendChat("/me îòðåçàëà ñèíèé ïðîâîä")
                    wait(settings.global.lwait)
                    sampSendChat("/me îòñîåäèíèëà äåòîíàòîð")
                    wait(settings.global.lwait)
                    sampSendChat("/do Áîìáà îáåçâðåæåíà.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïîëîæèëà âñå îáðàòíî â ñàïåðíûé íàáîð")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàëà áðîíèðîâàííûé êåéñ")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïîìåñòèëà áîìáó â áðîíèðîâàííûé êåéñ")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  end
                end
              end
            },
          }
        },
        {
          title = "{808080}Ïåðâàÿ ìåäèöèíñêàÿ ïîìîùü[ÏÌÏ]{FFFFFF}",
          submenu = 
          {
            title = "{808080}Âûáåðèòå îòûãðîâêó{FFFFFF}",
            {
              title = "{808080}ÏÌÏ ïðè ïåðåëîìå{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Íå óêàçàíà." and settings.global.lwait ~= "Íå óêàçàíà" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do Ìåäèöèíñêàÿ ñóìêà íà ïëå÷å.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ñíÿë ìåäèöèíñêóþ ñóìêó ñ ïëå÷à, çàòåì îòêðûë å¸")
                    wait(settings.global.lwait)
                    sampSendChat("/do Â ñóìêå ëåæàò: ñòåðèëüíûå øïðèöû, àìïóëà ñ àíàëüãåòèêîì, øèíà, áèíòû.")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàë ñòåðèëüíûé øïðèö ñ àìïóëîé, àêêóðàòíî ïðèîòêðûâ àìïóëó ñ àíàëüãåòèêîì")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïåðåëèë ñîäåðæèìîå àìïóëû â øïðèö")
                    wait(settings.global.lwait)
                    sampSendChat("/me çàêàòàë ðóêàâ ïîñòðàäàâøåãî, ïîñëå ÷åãî ââ¸ë àíàëüãåòèê ÷åðåç øïðèö â âåíó, âäàâèâ ïîðøåíü")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàë èç ñóìêè øèíó, çàòåì ïðèíÿëñÿ íàêëàäûâàòü å¸ íà ïîâðåæä¸ííóþ êîíå÷íîñòü")
                    wait(settings.global.lwait)
                    sampSendChat("/me àêêóðàòíî íàëîæèë øèíó íà ïîâðåæä¸ííóþ êîíå÷íîñòü")
                    wait(settings.global.lwait)
                    sampSendChat("/do Øèíà êà÷åñòâåííî íàëîæåíà íà ïîâðåæä¸ííóþ êîíå÷íîñòü.")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿë èç ñóìêè ñòåðèëüíûå áèíòû, çàòåì íà÷àë äåëàòü êîñûíêó")
                    wait(settings.global.lwait)
                    sampSendChat("/me ñäåëàë êîñûíêó èç ñòåðèëüíîãî áèíòà")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïîäâåñèë ïîâðåæä¸ííóþ êîíå÷íîñòü â ñîãíóòîì ïîëîæåíèè")
                    wait(settings.global.lwait)
                    sampSendChat("/do Ïîâðåæä¸ííàÿ êîíå÷íîñòü èììîáèëèçîâàíà.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do Ìåäèöèíñêàÿ ñóìêà íà ïëå÷å.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ñíÿëà ìåäèöèíñêóþ ñóìêó ñ ïëå÷à, çàòåì îòêðûë å¸")
                    wait(settings.global.lwait)
                    sampSendChat("/do Â ñóìêå ëåæàò: ñòåðèëüíûå øïðèöû, àìïóëà ñ àíàëüãåòèêîì, øèíà, áèíòû.")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàëà ñòåðèëüíûé øïðèö ñ àìïóëîé, àêêóðàòíî ïðèîòêðûâ àìïóëó ñ àíàëüãåòèêîì")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïåðåëèëà ñîäåðæèìîå àìïóëû â øïðèö")
                    wait(settings.global.lwait)
                    sampSendChat("/me çàêàòàëà ðóêàâ ïîñòðàäàâøåãî, ïîñëå ÷åãî ââ¸ë àíàëüãåòèê ÷åðåç øïðèö â âåíó, âäàâèâ ïîðøåíü")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàëà èç ñóìêè øèíó, çàòåì ïðèíÿëñÿ íàêëàäûâàòü å¸ íà ïîâðåæä¸ííóþ êîíå÷íîñòü")
                    wait(settings.global.lwait)
                    sampSendChat("/me àêêóðàòíî íàëîæèëà øèíó íà ïîâðåæä¸ííóþ êîíå÷íîñòü")
                    wait(settings.global.lwait)
                    sampSendChat("/do Øèíà êà÷åñòâåííî íàëîæåíà íà ïîâðåæä¸ííóþ êîíå÷íîñòü.")
                    wait(settings.global.lwait)
                    sampSendChat("/me âçÿëà èç ñóìêè ñòåðèëüíûå áèíòû, çàòåì íà÷àë äåëàòü êîñûíêó")
                    wait(settings.global.lwait)
                    sampSendChat("/me ñäåëàëà êîñûíêó èç ñòåðèëüíîãî áèíòà")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïîäâåñèëà ïîâðåæä¸ííóþ êîíå÷íîñòü â ñîãíóòîì ïîëîæåíèè")
                    wait(settings.global.lwait)
                    sampSendChat("/do Ïîâðåæä¸ííàÿ êîíå÷íîñòü èììîáèëèçîâàíà.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}ÏÌÏ ïðè ðàíåíèè êîíå÷íîñòåé{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Íå óêàçàíà." and settings.global.lwait ~= "Íå óêàçàíà" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me îñìîòðåë ðàíåííîãî")
                    wait(settings.global.lwait)
                    sampSendChat("/do Îïðåäåëèë, ïðîáèòà àðòåðèÿ.")
                    wait(settings.global.lwait)
                    sampSendChat("/me íàëîæèë äàâÿùóþ ïîâÿçêó íà ðàíó")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàë ôëÿãó ñî ñïèðòîì è îòîðâàë êóñîê òêàíè ñî ñâîåé îäåæäû")
                    wait(settings.global.lwait)
                    sampSendChat("/do Áîåö íàëèë ñïèðò íà òêàíü è ïðèëîæèë å¸ íà ìåñòî ðàíåíèÿ.")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàë àïòå÷êó è îòêðûë åå, çàòåì äîñòàë æãóò è áèíò")
                    wait(settings.global.lwait)
                    sampSendChat("/me çàêðåïèë ïîâÿçêó íà ðàíåíèè áèíòîì îáìîòàâ áèíò âîêðóã ðàíû")
                    wait(settings.global.lwait)
                    sampSendChat("/do Áîåö íàëîæèë æãóò íèæå ðàíåíèÿ.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Êðîâîòå÷åíèå ïîñòåïåííî ïðîõîäèò.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Æãóò íàëîæåí, êðîâîòå÷åíèå îñòàíîâëåíî.")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàë èç àïòå÷êè òàáëåòêè Àñïèðèí è ïîëîæèë â ðîò ðàíåíîìó")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me îñìîòðåëà ðàíåííîãî")
                    wait(settings.global.lwait)
                    sampSendChat("/do Îïðåäåëèëà, ïðîáèòà àðòåðèÿ.")
                    wait(settings.global.lwait)
                    sampSendChat("/me íàëîæèëà äàâÿùóþ ïîâÿçêó íà ðàíó")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàëà ôëÿãó ñî ñïèðòîì è îòîðâàëà êóñîê òêàíè ñî ñâîåé îäåæäû")
                    wait(settings.global.lwait)
                    sampSendChat("/do Íàëèëà ñïèðò íà òêàíü è ïðèëîæèëà å¸ íà ìåñòî ðàíåíèÿ.")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàëà àïòå÷êó è îòêðûëà åå, çàòåì äîñòàëà æãóò è áèíò")
                    wait(settings.global.lwait)
                    sampSendChat("/me çàêðåïèëà ïîâÿçêó íà ðàíåíèè áèíòîì îáìîòàâ áèíò âîêðóã ðàíû")
                    wait(settings.global.lwait)
                    sampSendChat("/do Íàëîæèëà æãóò íèæå ðàíåíèÿ.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Êðîâîòå÷åíèå ïîñòåïåííî ïðîõîäèò.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Æãóò íàëîæåí, êðîâîòå÷åíèå îñòàíîâëåíî.")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàëà èç àïòå÷êè òàáëåòêè Àñïèðèí è ïîëîæèëà â ðîò ðàíåíîìó")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}ÏÌÏ ïðè ðàíåíèè â ãðóäü è æèâîò{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Íå óêàçàíà." and settings.global.lwait ~= "Íå óêàçàíà" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me îñìîòðåë ðàíåííîãî")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïîìîã ÷åëîâåêó ïðèíÿòü ïîëóñèäÿ÷åå ïîëîæåíèå")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàë àïòå÷êó è îòêðûë åå")
                    wait(settings.global.lwait)
                    sampSendChat("/do Áîåö äîñòàë èç àïòå÷êè ñòåðèëüíûé áèíò è ñðåäñòâà äëÿ îáðàáîòêè ðàí.")
                    wait(settings.global.lwait)
                    sampSendChat("/me îáðàáîòàë êðàÿ ðàíû îáåççàðàæèâàþùèì ñðåäñòâîì è óáðàë èçëèøêè êðîâè")
                    wait(settings.global.lwait)
                    sampSendChat("/do Áîåö äîñòàë àñåïòè÷åñêóþ ìàðëþ è ñìî÷èë åå ñïèðòîì.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïðèæàë ìàðëþ ê ðàíå, ïðèîñòàíîâèâ êðîâîòå÷åíèå")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàë èç àïòå÷êè áèíò, çàòåì íà÷àë îáìàòûâàòü ðàíó")
                    wait(settings.global.lwait)
                    sampSendChat("/do Áèíòû ïîñòåïåííî ñêðûâàþò ðàíó.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Ïîâÿçêà êðåïêî íàëîæåíà è ñòÿãèâàåò ðàíó.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Êðîâîòå÷åíèå ïîñòåïåííî ïðîõîäèò.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me îñìîòðåëà ðàíåííîãî")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïîìîãëà ÷åëîâåêó ïðèíÿòü ïîëóñèäÿ÷åå ïîëîæåíèå")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàëà àïòå÷êó è îòêðûë åå")
                    wait(settings.global.lwait)
                    sampSendChat("/do Äîñòàëà èç àïòå÷êè ñòåðèëüíûé áèíò è ñðåäñòâà äëÿ îáðàáîòêè ðàí.")
                    wait(settings.global.lwait)
                    sampSendChat("/me îáðàáîòàëà êðàÿ ðàíû îáåççàðàæèâàþùèì ñðåäñòâîì è óáðàë èçëèøêè êðîâè")
                    wait(settings.global.lwait)
                    sampSendChat("/do Äîñòàëà àñåïòè÷åñêóþ ìàðëþ è ñìî÷èëà åå ñïèðòîì.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïðèæàëà ìàðëþ ê ðàíå, ïðèîñòàíîâèâ êðîâîòå÷åíèå")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàëà èç àïòå÷êè áèíò, çàòåì íà÷àëà îáìàòûâàòü ðàíó")
                    wait(settings.global.lwait)
                    sampSendChat("/do Áèíòû ïîñòåïåííî ñêðûâàþò ðàíó.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Ïîâÿçêà êðåïêî íàëîæåíà è ñòÿãèâàåò ðàíó.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Êðîâîòå÷åíèå ïîñòåïåííî ïðîõîäèò.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}ÏÌÏ ïðè ïîòåðå ïóëüñà{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Íå óêàçàíà." and settings.global.lwait ~= "Íå óêàçàíà" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do Íà ïðàâîì ïëå÷å âèñèò îòêðûòàÿ ìåä. ñóìêà.")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàâ èç ñóìêè ïîëîòåíöå, ïîäëîæèë åãî ïîä øåþ ïîñòðàäàâøåãî")
                    wait(settings.global.lwait)
                    sampSendChat("/me ñíÿë ñ ãðóäè ÷åëîâåêà âñþ îäåæäó")
                    wait(settings.global.lwait)
                    sampSendChat("/me ñíÿë âñå ñäàâëèâàþùèå àêñåññóàðû")
                    wait(settings.global.lwait)
                    sampSendChat("/me ñäåëàâ ãëóáîêèé âäîõ, íà÷àë äåëàòü èñêóññòâåííîå äûõàíèå ë¸ãêèõ")
                    wait(settings.global.lwait)
                    sampSendChat("/do Âîçäóõ ïîñòåïåííî íàïîëíÿåò è çàïîëíÿåò ë¸ãêèå ïîñòðàäàâøåãî.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïîëîæèë ðóêè äðóã íà äðóãà íà ãðóäü ÷åëîâåêà")
                    wait(settings.global.lwait)
                    sampSendChat("/me äåëàåò íåïðÿìîé ìàññàæ ñåðäöà")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïîïåðåìåííî äåëàåò èñêóññòâåííîå äûõàíèå è íåïðÿìîé ìàññàæ ñåðäöà")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do Íà ïðàâîì ïëå÷å âèñèò îòêðûòàÿ ìåä. ñóìêà.")
                    wait(settings.global.lwait)
                    sampSendChat("/me äîñòàâ èç ñóìêè ïîëîòåíöå, ïîäëîæèëà åãî ïîä øåþ ïîñòðàäàâøåãî")
                    wait(settings.global.lwait)
                    sampSendChat("/me ñíÿëà ñ ãðóäè ÷åëîâåêà âñþ îäåæäó")
                    wait(settings.global.lwait)
                    sampSendChat("/me ñíÿëà âñå ñäàâëèâàþùèå àêñåññóàðû")
                    wait(settings.global.lwait)
                    sampSendChat("/me ñäåëàâ ãëóáîêèé âäîõ, íà÷àëà äåëàòü èñêóññòâåííîå äûõàíèå ë¸ãêèõ")
                    wait(settings.global.lwait)
                    sampSendChat("/do Âîçäóõ ïîñòåïåííî íàïîëíÿåò è çàïîëíÿåò ë¸ãêèå ïîñòðàäàâøåãî.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïîëîæèëà ðóêè äðóã íà äðóãà íà ãðóäü ÷åëîâåêà")
                    wait(settings.global.lwait)
                    sampSendChat("/me äåëàåò íåïðÿìîé ìàññàæ ñåðäöà")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïîïåðåìåííî äåëàåò èñêóññòâåííîå äûõàíèå è íåïðÿìîé ìàññàæ ñåðäöà")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  end
                end
              end
            },
          }
        },
        {
          title = "{808080}Äðóãîå{FFFFFF}",
          submenu = 
          {
            title = "{808080}Âûáåðèòå îòûãðîâêó{FFFFFF}",
            {
              title = "{808080}Ìàñêèðîâêà àâòîìîáèëÿ è ñèäÿ÷èõ â í¸ì{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Íå óêàçàíà." and settings.global.lwait ~= "Íå óêàçàíà" then
                  sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                  wait(200)
                  sampSendChat("/do Âîäèòåëü è ïàññàæèðû íàõîäÿòñÿ â àâòîìîáèëå áåç îïîçíîâàòåëüíûõ çíàêîâ.")
                  wait(settings.global.lwait)
                  sampSendChat("/do Àâòîìîáèëü ïîëíîñòüþ áðîíèðîâàí, íîìåðíûå çíàêè îòñóòñòâóþò, øèíû ïóëåñòîéêèå.")
                  wait(settings.global.lwait)
                  sampSendChat("/do Ñòåêëà àâòîìîáèëÿ çàòîíèðîâàíû, ëè÷íîñòü âîäèòåëÿ è ïàññàæèðîâ íå ðàñïîçíàòü.")
                  wait(200)
                  sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                end
              end
            },
            {
              title = "{808080}Íàäåòü ïðîòèâîãàç{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Íå óêàçàíà." and settings.global.lwait ~= "Íå óêàçàíà" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do Íà áåäðå ëåâîé íîãè âèñèò ïîäñóìîê ñ ïðîòèâîãàçîì ÃÏ-21.")
                    wait(settings.global.lwait)
                    sampSendChat("/me çàäåðæàâ äûõàíèå, äîñòàë ïðîòèâîãàç è ëîâêèì äâèæåíèåì íàäåë åãî")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do Íà áåäðå ëåâîé íîãè âèñèò ïîäñóìîê ñ ïðîòèâîãàçîì ÃÏ-21.")
                    wait(settings.global.lwait)
                    sampSendChat("/me çàäåðæàâ äûõàíèå, äîñòàëà ïðîòèâîãàç è ëîâêèì äâèæåíèåì íàäåëà åãî")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}Ïîëíàÿ ìàñêèðîâêà ñåáÿ{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Íå óêàçàíà." and settings.global.lwait ~= "Íå óêàçàíà" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do Íåèçâåñòíûé îäåò â âîåííóþ ôîðìó èç íîìåêñà òåìíî ñåðîãî öâåòà.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Íà áðîíåæèëåòå íåò íàøèâîê, ðàñïîçíàâàòåëüíûå çíàêè îòñóòñòâóþò.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Ëèöî ñêðûòî áàëàêëàâîé, ëè÷íîñòü íå ðàñïîçíàòü.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do Íåèçâåñòíàÿ îäåòà â âîåííóþ ôîðìó èç íîìåêñà òåìíî ñåðîãî öâåòà.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Íà áðîíåæèëåòå íåò íàøèâîê, ðàñïîçíàâàòåëüíûå çíàêè îòñóòñòâóþò.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Ëèöî ñêðûòî áàëàêëàâîé, ëè÷íîñòü íå ðàñïîçíàòü.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}Ïîëíàÿ ìàñêèðîâêà ñåáÿ è îêðóæàþùèõ{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Íå óêàçàíà." and settings.global.lwait ~= "Íå óêàçàíà" then
                  sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                  wait(200)
                  sampSendChat("/do Íåèçâåñòíûå îäåòû â âîåííóþ ôîðìó èç íîìåêñà òåìíî-ñåðîãî öâåòà.")
                  wait(settings.global.lwait)
                  sampSendChat("/do Ðàñïîçíàâàòåëüíûå çíàêè íà ôîðìå îòñóòñòâóþò.")
                  wait(settings.global.lwait)
                  sampSendChat("/do Ëèöà ñêðûòû áàëàêëàâàìè, ëè÷íîñòè íå ðàñïîçíàòü.")
                  wait(200)
                  sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                end
              end
            },
            {
              title = "{808080}Ïðîâåðêà ñíàðÿæåíèÿ{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Íå óêàçàíà." and settings.global.lwait ~= "Íå óêàçàíà" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do Íà ãðóäè âèñèò ÷åòûðå ïîäñóìêà.")
                    wait(settings.global.lwait)
                    sampSendChat("/me íà÷àë ïðîâåðÿòü ñâîå ñíàðÿæåíèå, ïðîâåðÿÿ êàæäûé ïîäñóìîê")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïðîâåðèë ïåðâûé ïîäñóìîê")
                    wait(settings.global.lwait)
                    sampSendChat("/do Â ïåðâîì ïîäñóìêå ëåæèò àïòå÷êà ÀÈ-2 è ïåðåâÿçî÷íûé ïàêåò ÈÏÏ-1. ")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïðîâåðèë âòîðîé è òðåòèé ïîäñóìîê")
                    wait(settings.global.lwait)
                    sampSendChat("/do Âî âòîðîì è òðåòüåì ïîäñóìêå ëåæèò 5 ìàãàçèíîâ äëÿ Ì4, 6 ìàãàçèíîâ äëÿ Deagle, 5 îáîéì äëÿ Rifle.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïðîâåðèë ÷åòâåðòûé ïîäñóìîê")
                    wait(settings.global.lwait)
                    sampSendChat("/do Â ÷åòâåðòîì ïîäñóìêå ëåæàò 2 íåáîëüøèõ ôèëüòðà äëÿ ïðîòèâîãàçà, êëþ÷è, ñèãàðåòû, íàðó÷íèêè.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Ñòàðò îòûãðîâêè. Äëÿ îòìåíû íàæìèòå CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do Íà ãðóäè âèñèò ÷åòûðå ïîäñóìêà.")
                    wait(settings.global.lwait)
                    sampSendChat("/me íà÷àëà ïðîâåðÿòü ñâîå ñíàðÿæåíèå, ïðîâåðÿÿ êàæäûé ïîäñóìîê")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïðîâåðèëà ïåðâûé ïîäñóìîê")
                    wait(settings.global.lwait)
                    sampSendChat("/do Â ïåðâîì ïîäñóìêå ëåæèò àïòå÷êà ÀÈ-2 è ïåðåâÿçî÷íûé ïàêåò ÈÏÏ-1. ")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïðîâåðèëà âòîðîé è òðåòèé ïîäñóìîê")
                    wait(settings.global.lwait)
                    sampSendChat("/do Âî âòîðîì è òðåòüåì ïîäñóìêå ëåæèò 5 ìàãàçèíîâ äëÿ Ì4, 6 ìàãàçèíîâ äëÿ Deagle, 5 îáîéì äëÿ Rifle.")
                    wait(settings.global.lwait)
                    sampSendChat("/me ïðîâåðèëà ÷åòâåðòûé ïîäñóìîê")
                    wait(settings.global.lwait)
                    sampSendChat("/do Â ÷åòâåðòîì ïîäñóìêå ëåæàò 2 íåáîëüøèõ ôèëüòðà äëÿ ïðîòèâîãàçà, êëþ÷è, ñèãàðåòû, íàðó÷íèêè.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Êîíåö îòûãðîâêè.", 0x33AAFFFF)
                  end
                end
              end
            },
          }
        },
        {
          title = "{808080}Çàäåðæêà ìåæäó ñòðîêàìè â îòûãðîâêàõ:{FFFFFF} "..pInfo.lwait,
          onclick = function()
            sampShowDialog(9999, "Óñòàíîâèòü çàäåðæêó:", "{b6b6b6}Ââåäè çàäåðæêó:", "ÎÊ", "Çàêðûòü", 1)
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
      title = "{808080}Èíôîðìàöèÿ{FFFFFF}",
      submenu =
      {
        title = "{808080}Èíôîðìàöèÿ{FFFFFF}",
        {
          title = "{808080}Óñòàâ îòðÿäà{FFFFFF}",
          onclick = function()
            sampShowDialog(2344, "{808080}[SOBR tools] Óñòàâ ÑÎÁÐ{FFFFFF}", "{808080}«ÏÐÅÀÌÁÓËÀ»\n1.1 Êàæäûé áîåö îòðÿäà îáÿçàí çíàòü è ñîáëþäàòü ïðàâèëà óñòàíîâëåííûå óñòàâîì.\n1.2 Çà íåñîáëþäåíèå óñòàâà îòðÿäà áîåö ìîæåò ïîëó÷èòü íàêàçàíèå âïëîòü äî èñêëþ÷åíèÿ èç îòðÿäà.\n1.3 Êîìàíäèð îòðÿäà èìååò ïðàâî èçìåíÿòü óñòàâ â ëþáîå âðåìÿ.\n«ÎÁßÇÀÍÍÎÑÒÈ»\n2.1 Îñóùåñòâëåíèå áåçîïàñíîñòè îõðàíÿåìîé òåððèòîðèè àðìèè Ëàñ-Âåíòóðàñà;\n2.2 Ìãíîâåííîå ðåàãèðîâàíèå íà `SOS` ñî ñòîðîíû áîéöîâ, âåäóùèõ ïîñòàâêè áîåïðèïàñîâ;\n2.3 Ïðîâåðêà `Ìàãàçèíîâ îäåæäû` è `ÀÌÌÎ`;\n2.4 Ïðåäîòâðàùåíèå êðàæè âîåííîãî èìóùåñòâà, â òîì ÷èñëå âîåííîé òåõíèêè;\n2.5 Îñóùåñòâëåíèå êðóãëîñóòî÷íûõ ïàòðóëåé âîêðóã âîèíñêîé ÷àñòè, ìàðøðóòîâ ñíàáæåíèÿ â öåëÿõ íàõîäêè çàñàäû áàéêåðñêèõ êëóáîâ, à òàê æå ïàòðóëü áëèçëåæàùèõ òåððèòîðèé ãîðîäà è åãî îêðåñòíîñòåé;\n2.6 Ïåøèé ïàòðóëü ñàìîé ÷àñòè ( ÃÑ-Àíãàðû );\n2.7 Îñóùåñòâëåíèå ñîïðîâîæäåíèé êîëîíí ñíàáæåíèÿ â öåëÿõ ñîõðàííîñòè èìóùåñòâà àðìèè;\n2.8 Îñóùåñòâëåíèå áåçîïàñíîñòè è ïîðÿäêà íà ïðèçûâàõ â àðìèþ Ëàñ-Âåíòóðàñà;\n2.9 Ó÷àñòèå â ñïåö. îïåðàöèÿõ âìåñòå ñ Óïðàâëåíèåì Ñîáñòâåííîé Áåçîïàñíîñòè,à òàê æå Federal Bureau of Investigation;\n2.10 Ïîìîùü â ïîðòó Ëîñ-Ñàíòîñà ïðè ÷ðåçâû÷àéíûõ ñèòóàöèÿõ.\n2.11 Ïîìîùü äðóãèì âçâîäàì.\n«ÇÀÏÐÅÒÛ»\n3.1 Íàðóøåíèå óñòàâà â ëþáîé ôîðìå;\n3.2 Íåèñïîëíåíèå ïðèêàçîâ êîìàíäóþùåãî ñîñòàâà, ðóêîâîäñòâà àðìèè;\n3.3 Íåÿâêà íà âûçîâû FBI ïî çàïðîñàì. (èñêë.: ÑÎ èëè ðàçëè÷íîãî ðîäà ìåðîïðèÿòèÿ îò ðóê-âà îòðÿäà);\n3.4 Èäòè â ïåðåñòðåëêó ñ òðåìÿ è áîëåå âîîðóæåííûìè ïðîòèâíèêàìè (èñêë.: ñ âàìè íàïàðíèê);\n3.5 Ó÷àñòèå â òðåíèðîâêàõ/ìï îò Ñåíàòîðîâ ñ êàêèì-ëèáî âçâîäîì, êîãäà íàïàäåíèÿ áàéêåðîâ è áàíäèòîâ ïðîèñõîäÿò ÷àñòî;\n3.6 Âçðûâàòü ôóðó ïîñëå òîãî, êàê îòáèëè ó ÎÏÃ (â ñëó÷àå, åñëè ôóðà ïîëîìàíà, ïî÷èíèòü ðåì.êîìïëåêòîì, åñëè ôóðà íà õîäó, ýâàêóèðîâàòü â ÷àñòü);\n3.7 Ëþáûå êîíôëèêòû ñ áîéöàìè àðìèè;\n3.8 Íàõîäèòüñÿ â îïàñíîì ðàéîíå âíå ñïåö.îïåðàöèé;\n3.9 Îñóùåñòâëÿòü âîçäóøíûé ïàòðóëü áåç ðàçðåøåíèÿ êîì.ñîñòàâà îòðÿäà è/èëè â ñîñòàâå ìåíåå òðåõ ÷åëîâåê;\n3.10 Íåñìîòðÿ íà îôèöåðñêîå çâàíèÿ â îòðÿäå, ÑÎÁÐ íå èìååò ïðàâî êîìàíäîâàòü èëè ðóêîâîäèòü êåì-ëèáî èç âçâîäîâ èëè îôèöåðîâ.\n(èñêë.: äîïóñêàåòñÿ ðóêîâîäñòâî ñîëäàòàìè â êðèòè÷åñêèõ ñèòóàöèÿõ ïðè îòñóòñòâèè ñòàðøèõ îôèöåðîâ)\n«ÐÀÇÐÅØÅÍÎ»\n4.1 Ïîêèäàòü òåððèòîðèþ ÷àñòè äëÿ çàïðàâêè òðàíñïîðòà è ïîïîëíåíèÿ ðåì. êîìïëåêòîâ ñ äîêëàäîì. (îò äîëæíîñòè Áîåö)\n4.2 Âûåçæàòü ñ òåððèòîðèè áàçû ÷åðåç ïðîõîä ðÿäîì ñ ÊÏÏ è ÷åðåç ãîðêó ðÿäîì ñ êîíòåéíåðàìè íà ÃÑ.\n4.3 Ëîìàòü êíîïî÷íóþ ñòàíöèè âî âðåìÿ ïîãîíè çà ôóðîé.\n4.4 Îòäûõàòü, ñïàòü â øòàáå íåîãðàíè÷åííîå âðåìÿ.\n4.5 Ïàðêîâàòü ñâîé ëè÷íûé òðàíñïîðò ñïðàâà îò øòàáà.\n4.6 Âåñòè îãîíü íà ïîðàæåíèå ïî ëþáîìó áîéöó, êîòîðûé íàõîäèòñÿ â ìàñêå â ÷àñòè.{FFFFFF}", "Ïîíÿë", "Íå ïîíÿë", 0)
          end
        },
        {
          title = "{808080}Òåí-êîäû{FFFFFF} ",
          onclick = function()
            sampShowDialog(4353, "{808080}[SOBR tools] Òåí-êîäû{FFFFFF}", "{808080}10-4  Ñîîáùåíèå ïðèíÿòî, âûåçæàþ!\n10-6  ß çàíÿò, ïî ïðè÷èíå - [Óêàçàòü ïðè÷èíó]\n10-8  Ãîòîâ ê ðàáîòå [Óêàçàòü ïîçûâíîé]\n10-10  Ïîõèùåíèå, â ñåêòîðå - [Óêàçàòü ñåêòîð]\n10-16  Ïåðåõâàòèòå ïîäîçðåâàåìîãî â ñåêòîðå - [Óêàçàòü ñåêòîð]\n10-20  Ìåñòîïîëîæåíèå â ñåêòîðå - [Óêàçàòü ñåêòîð]\n10-26  Ïîñëåäíÿÿ èíôîðìàöèÿ îòìåíÿåòñÿ.\n10-34  Òðåáóåòñÿ ïîäêðåïëåíèå â ñåêòîðå - [Óêàçàòü ñåêòîð]\n10-37  Òðåáóåòñÿ ýâàêóàöèÿ â ñåêòîð - [Óêàçàòü ñåêòîð]\n10-38  Òðåáóåòñÿ ìàøèíà ñêîðîé ïîìîùè â ñåêòîð - [Óêàçàòü ñåêòîð]\n10-30 - Âûåõàëè â ñîïðîâîæäåíèå - [Óêàçàòü ïîçûâíûå íàïàðíèêîâ]\n10-31 - Âîçâðàùàåìñÿ â ÷àñòü\n10-40 - Ïàòðóëü ÷àñòè - [Óêàçàòü ïîçûâíûå íàïàðíèêîâ]\n10-43 - Âûëåòåëè â ïîðò ËÑ - [Óêàçàòü ïîçûâíûå íàïàðíèêîâ]\n10-44 - Ïðèëåòåëè â ïîðò ËÑ\n10-51 - Âûåõàëè íà ïðîâåðêó AMMO LS - [Óêàçàòü ïîçûâíûå íàïàðíèêîâ]\n10-52 - Âûåõàëè íà ïðîâåðêó AMMO SF - [Óêàçàòü ïîçûâíûå íàïàðíèêîâ]\n10-53 - Âûåõàëè íà ïðîâåðêó AMMO LV - [Óêàçàòü ïîçûâíûå íàïàðíèêîâ]\n10-61 - Âûåõàëè íà ïðîâåðêó MO LS - [Óêàçàòü ïîçûâíûå íàïàðíèêîâ]\n10-62 - Âûåõàëè íà ïðîâåðêó MO SF - [Óêàçàòü ïîçûâíûå íàïàðíèêîâ]\n10-63 - Âûåõàëè íà ïðîâåðêó MO LV - [Óêàçàòü ïîçûâíûå íàïàðíèêîâ]\n10-99  Çàäàíèå âûïîëíåíî, âñå â ïîðÿäêå.\n10-100  Íóæíî îòîéòè.\n10-200  Òðåáóåòñÿ íàðÿä ïîëèöèè â ñåêòîð - [Óêàçàòü ñåêòîð]\n10-250  Âûçîâ ñïåö.îòðÿäîâ PD â óêàçàííîå ìåñòî - [Óêàçàòü ñåêòîð / ìåñòî].\n(Èñïîëüçóåòñÿ ïðè ðåéäàõ, îáëàâàõ, òåðàêòàõ è îáùèõ òðåíèðîâêàõ)\n10-300  Âûçîâ ñïåö.îòðÿäîâ PD è Army â óêàçàííîå ìåñòî - [Óêàçàòü ñåêòîð / ìåñòî].\n(Èñïîëüçóåòñÿ ïðè ðåéäàõ, îáëàâàõ, òåðàêòàõ è îáùèõ òðåíèðîâêàõ){FFFFFF}", "Ïîíÿë", "Íå ïîíÿë", 0)
          end
        },
        {
          title = "{808080}Óñòàâ àðìèè è Ôåäåðàëüíîå Ïîñòàíîâëåíèå{FFFFFF}",
          onclick = function()
            cmd_imgui()
          end
        },
      }
    },
    {
      title = "{808080}Êîìàíäû ñêðèïòà{FFFFFF}",
      onclick = function()
        sampShowDialog(1285, "{808080}[SOBR tools] Êîìàíäû{FFFFFF}", "{808080}/aclist - âûêëþ÷èòü/âêëþ÷èòü àâòîêëèñò\n/lp - âûêëþ÷èòü/âêëþ÷èòü îòêðûâàíèå àâòî íà êëàâèøó `L`\n/atag - âûêëþ÷èòü/âêëþ÷èòü àâòî-òåã\n/ascreen - âûêëþ÷èòü/âêëþ÷èòü àâòî-ñêðèí ïîñëå ïýéäåÿ\n/sw, /st - ñìåíèòü èãðîâîå âðåìÿ/ïîãîäó\n/cc - î÷èñòèòü ÷àò\n/kv - ïîñòàâèòü ìåòêó íà êâàäðàò\n/getm - ïîêàçàòü ñåáå ìîíèòîðèíã, /rgetm - â ðàöèþ\n/przv - âêëþ÷èòü/âûêëþ÷èòü ðåæèì ïðèçûâà\n/abp - âûêëþ÷èòü/âêëþ÷èòü àâòî-ÁÏ íà `alt`\n/abp - âêëþ÷èòü íàñòðîéêè àâòî-ÁÏ\n/splayer - âêëþ÷èòü/âûêëþ÷èòü îòîáðàæåíèå â ÷àòå íèêîâ âîåííûõ êîòîðûå ïîÿâèëèñü â çîíå ñòðèìà\n/fustav - ïîñìîòðåòü ÔÏ è óñòàâ\n/ñòÿæêè - âêëþ÷èòü/îòêëþ÷èòü îòûãðîâêó ñòÿæåê\n/äîêëàäû - îòêðûòü ìåíþ äîêëàäîâ{FFFFFF}", "Ëàäíî", "Ïðîõëàäíî", 0)
      end
    },
    {
      title = "{808080}Íàñòðîéêè{FFFFFF}",
      submenu =
      {
        title = "{808080}Íàñòðîéêè{FFFFFF}",
        {
          title = "{808080}Òýã:{FFFFFF} "..pInfo.Tag,
          onclick = function()
            sampShowDialog(9999, "Óñòàíîâèòü òýã:", "{b6b6b6}Ââåäè ñâîé òýã:", "ÎÊ", "Çàêðûòü", 1)
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
          title = "{808080}Íîìåð öâåòà àâòîêëèñòà:{FFFFFF} "..pInfo.cvetclist,
          onclick = function()
            sampShowDialog(9999, "Àâòîêëèñò:", "{b6b6b6}Ââåäè íîìåð öâåòà:", "ÎÊ", "Çàêðûòü", 1)
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
          title = "{808080}Âûêëþ÷èòü/âêëþ÷èòü îòêðûâàíèå òðàíñïîðòà íà êëàâèøó `L`{FFFFFF}",
          onclick = function()
            if settings.global.k_r_u_t_o == true then
              sampAddChatMessage("[SOBR tools]: Îòêðûâàíèå àâòî íà êëàâèøó `L` áûëî âûêëþ÷åíî.", 0xFFB22222)
              settings.global.k_r_u_t_o = false
            else
              sampAddChatMessage("[SOBR tools]: Îòêðûâàíèå àâòî íà êëàâèøó `L` áûëî âêëþ÷åíî.", 0x33AAFFFF)
              settings.global.k_r_u_t_o = true
            end
          end
        },
        {
          title = "{808080}Âûêëþ÷èòü/âêëþ÷èòü àâòî-òåã{FFFFFF}",
          onclick = function()
            if settings.global.a_u_t_o_tag == true then
              sampAddChatMessage("[SOBR tools]: Àâòîòåã â ÷àò áûë âûêëþ÷åí.", 0xFFB22222)
              settings.global.a_u_t_o_tag = false
            else
              sampAddChatMessage("[SOBR tools]: Àâòîòåã â ÷àò áûë âêëþ÷åí.", 0x33AAFFFF)
              settings.global.a_u_t_o_tag = true
            end
          end
        },
        {
          title = "{808080}Âûêëþ÷èòü/âêëþ÷èòü àâòîñêðèí ïîñëå ïýéäåÿ{FFFFFF}",
          onclick = function()
            if settings.global.a_u_t_o_screen == true then
              sampAddChatMessage("[SOBR tools]: Àâòîñêðèí ïîñëå ïýéäåÿ áûë âûêëþ÷åí.", 0xFFB22222)
              settings.global.a_u_t_o_screen = false
            else
              sampAddChatMessage("[SOBR tools]: Àâòîñêðèí ïîñëå ïýéäåÿ áûë âêëþ÷åí.", 0x33AAFFFF)
              settings.global.a_u_t_o_screen = true
            end
          end
        },
        {
          title = "{808080}Âûêëþ÷èòü/âêëþ÷èòü ïîêàç ïàñïîðòà íà `Alt + ïðèöåë íà èãðîêà`{FFFFFF}",
          onclick = function()
            if settings.global.pokazatpassport == true then
              sampAddChatMessage("[SOBR tools]: Ôóíêöèÿ ïîêàçà ïàñïîðòà áûëà îòêëþ÷åíà.", 0xFFB22222)
              settings.global.pokazatpassport = false
            else
              sampAddChatMessage("[SOBR tools]: Ôóíêöèÿ ïîêàçà ïàñïîðòà áûëà âêëþ÷åíà.", 0x33AAFFFF)
              settings.global.pokazatpassport = true
            end
          end
        },
        {
          title = "{808080}Âûêëþ÷èòü/âêëþ÷èòü îòîáðàæåíèå ïîçûâíûõ{FFFFFF}",
          onclick = function()
            if settings.global.pozivnoy == true then
              sampAddChatMessage("[SOBR tools]: Îòîáðàæåíèå ïîçûâíûõ áûëî âûêëþ÷åíî.", 0xFFB22222)
              settings.global.pozivnoy = false
              for k, val in pairs(tData) do val:deattachText() end
            else
              sampAddChatMessage("[SOBR tools]: Îòîáðàæåíèå ïîçûâíûõ áûëî âêëþ÷åíî.", 0x33AAFFFF)
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
      title = "{808080}Ïðèçûâ/ìåä.îñìîòð{FFFFFF}",
      submenu = {
        title = "{808080}Ìåä.îñìîòð{FFFFFF}",
        {
          title = "{808080}Ïðèâåòñòâèå è ïðîñüáà ïîêàçàòü äîêóìåíòû{FFFFFF}",
          onclick = function()
            local _, pID = sampGetPlayerIdByCharHandle(PLAYER_PED)
            if settings.global.m_s_t_a_t == true then
                sampSendChat("Ïðèâåòñòâóþ, ÿ ñîòðóäíèê ïðèçûâíîé êîìèññèè.")
                wait(1600)
                sampSendChat("Ïîêàæèòå âàøè äîêóìåíòû è ìåäèöèíñêóþ êàðòó.")
                wait(1600)
                sampSendChat("/b /showpass "..pID.." / /me ïîêàçàë ìåä.êàðòó")
            else
                sampSendChat("Ïðèâåòñòâóþ, ÿ ñîòðóäíèöà ïðèçûâíîé êîìèññèè.")
                wait(1600)
                sampSendChat("Ïîêàæèòå âàøè äîêóìåíòû è ìåäèöèíñêóþ êàðòó.")
                wait(1600)
                sampSendChat("/b /showpass "..pID.." / /me ïîêàçàë ìåä.êàðòó")
            end
          end
        },
        {
          title = "{808080}/me âçÿë ìåäêàðòó è íà÷àë èçó÷àòü å¸{FFFFFF}",
          onclick = function()
             sampSendChat("/me âçÿë ìåäêàðòó è íà÷àë èçó÷àòü å¸")
          end
        },
        {
          title = "{808080}/todo Ñêîëüêî âàì ïîëíûõ ëåò?*ïåðåëèñòûâàÿ ìåäêàðòó{FFFFFF}",
          onclick = function()
             sampSendChat("/todo Ñêîëüêî âàì ïîëíûõ ëåò?*ïåðåëèñòûâàÿ ìåäêàðòó")
          end
        },
        {
          title = "{808080}/todo Òàê, ðàññêàæèòå ìíå î ñåáå*çàêðûâ ìåäêàðòó{FFFFFF}",
          onclick = function()
             sampSendChat("/todo Òàê, ðàññêàæèòå ìíå î ñåáå*çàêðûâ ìåäêàðòó")
          end
        },
        {
          title = "{808080}Îòëè÷íî. ×òî ó ìåíÿ íàä ãîëîâîé?{FFFFFF}",
          onclick = function()
             sampSendChat("Îòëè÷íî. ×òî ó ìåíÿ íàä ãîëîâîé?")
          end
        },
        {
          title = "{808080}Îòëè÷íî, âû ãîäíû äëÿ ñëóæáû â àðìèè{FFFFFF}",
          onclick = function()
             sampSendChat("Îòëè÷íî, âû ãîäíû äëÿ ñëóæáû â àðìèè.")
          end
        },
        {
          title = "{808080}Äåðæèòå ïîâÿçêó ¹16 è ïðîõîäèòå â ñîñåäíèé êàáèíåò{FFFFFF}",
          onclick = function()
             sampSendChat("Äåðæèòå ïîâÿçêó ¹16 è ïðîõîäèòå â ñîñåäíèé êàáèíåò.")
          end
        },
        {
          title = "{808080}/r [Âàø òýã]: Ãðàæäàíèí ñ ïåéäæåðîì ID ãîäåí äëÿ ñëóæáû â àðìèè Âûäàë ðîçîâóþ ïîâÿçêó{FFFFFF}",
          onclick = function()
            sampShowDialog(9999, "{CD5C5C}SOBR tools {FFFFFF} :", "{b6b6b6}Ââåäèòå èä.\nÎáðàçåö: {FFFFFF}3", "ÎÊ", "Çàêðûòü", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              local args = split(input, ",")
                args[1] = args[1]:gsub(" ", "")
                sampSendChat("/r "..pInfo.Tag.." Ãðàæäàíèí ñ ïåéäæåðîì "..args[1].." ãîäåí äëÿ ñëóæáû â àðìèè, ïîëó÷èë ðîçîâóþ ïîâÿçêó.")
            end
          end
        },
      }
    },
  }
  RaciaDialog = {

    {
      title = "{808080}10-30{FFFFFF}",
      onclick = function()
        local result, amount = getPassengers()
        if (result ~= false) then
            if (amount > 0) then
                names = ""
                for k, val in pairs(result) do
                    n = val.playername:gsub("_", " "):gsub("Leo Florenso", "Øûíãûñ"):gsub("Angel Galante", "Âàìïèð"):gsub("Valentin Molo", "Êðîò"):gsub("Aleksey Tarasov", "Çâåðü"):gsub("Sergu Sibov", "Àðèñòîêðàò"):gsub("Misha Samyrai", "Æèò"):gsub("Jimmy Saints", "Ìàêêóèí"):gsub("Saibor Ackerman", "Ìîëíèÿ"):gsub("Evan Corleone", "Ëåâèàôàí"):gsub("Bogdan Mishenko", "Ñîêîë"):gsub("Brain Spencor", "Âîëê"):gsub("Boulevard Bledov", "Áèçîí"):gsub("Ashton Edwards", "Àøîò"):gsub("Barbie Bell", "Àíãåë"):gsub("Chris Ludvig", "ßíêè"):gsub("Santiago Belucci", "ßñòðåá"):gsub("Jack Lingard", "Áàðîí"):gsub("Kevin Spencor", "Ãðîì"):gsub("Thomas Rinner", "Êàðàõìàí"):gsub("Aiden Florestino", "Ïðèçðàê"):gsub("Steven Green", "Áóðûé"):gsub("Hidan Bell", "Àíäðþõà"):gsub("Christopher Shaffer", "Ìå÷"):gsub("Weaver Tail", "Õîé")
                    print(n)
                    if names == "" then
                        names = names.. n
                    else
                        names = names .. ", ".. n
                    end
                end
                sampSendChat("/r "..pInfo.Tag.." 10-30. ".. names .. ".")
              else
                sampSendChat("/r "..pInfo.Tag.." 10-30.")
            end
        end
      end
    },
    {
      title = "{808080}10-31{FFFFFF}",
      onclick = function()
        local result, amount = getPassengers()
        if (result ~= false) then
            if (amount > 0) then
                names = ""
                for k, val in pairs(result) do
                    n = val.playername:gsub("_", " "):gsub("Leo Florenso", "Øûíãûñ"):gsub("Angel Galante", "Âàìïèð"):gsub("Valentin Molo", "Êðîò"):gsub("Aleksey Tarasov", "Çâåðü"):gsub("Sergu Sibov", "Àðèñòîêðàò"):gsub("Misha Samyrai", "Æèò"):gsub("Jimmy Saints", "Ìàêêóèí"):gsub("Saibor Ackerman", "Ìîëíèÿ"):gsub("Evan Corleone", "Ëåâèàôàí"):gsub("Bogdan Mishenko", "Ñîêîë"):gsub("Brain Spencor", "Âîëê"):gsub("Boulevard Bledov", "Áèçîí"):gsub("Ashton Edwards", "Àøîò"):gsub("Barbie Bell", "Àíãåë"):gsub("Chris Ludvig", "ßíêè"):gsub("Santiago Belucci", "ßñòðåá"):gsub("Jack Lingard", "Áàðîí"):gsub("Kevin Spencor", "Ãðîì"):gsub("Thomas Rinner", "Êàðàõìàí"):gsub("Aiden Florestino", "Ïðèçðàê"):gsub("Steven Green", "Áóðûé"):gsub("Hidan Bell", "Àíäðþõà"):gsub("Christopher Shaffer", "Ìå÷"):gsub("Weaver Tail", "Õîé")
                    print(n)
                    if names == "" then
                        names = names.. n
                    else
                        names = names .. ", ".. n
                    end
                end
                sampSendChat("/r "..pInfo.Tag.." 10-31. ".. names .. ".")
              else
                sampSendChat("/r "..pInfo.Tag.." 10-31.")
            end
        end
      end
    },
    {
      title = "{808080}10-40{FFFFFF}",
      onclick = function()
        local result, amount = getPassengers()
        if (result ~= false) then
            if (amount > 0) then
                names = ""
                for k, val in pairs(result) do
                    n = val.playername:gsub("_", " "):gsub("Leo Florenso", "Øûíãûñ"):gsub("Angel Galante", "Âàìïèð"):gsub("Valentin Molo", "Êðîò"):gsub("Aleksey Tarasov", "Çâåðü"):gsub("Sergu Sibov", "Àðèñòîêðàò"):gsub("Misha Samyrai", "Æèò"):gsub("Jimmy Saints", "Ìàêêóèí"):gsub("Saibor Ackerman", "Ìîëíèÿ"):gsub("Evan Corleone", "Ëåâèàôàí"):gsub("Bogdan Mishenko", "Ñîêîë"):gsub("Brain Spencor", "Âîëê"):gsub("Boulevard Bledov", "Áèçîí"):gsub("Ashton Edwards", "Àøîò"):gsub("Barbie Bell", "Àíãåë"):gsub("Chris Ludvig", "ßíêè"):gsub("Santiago Belucci", "ßñòðåá"):gsub("Jack Lingard", "Áàðîí"):gsub("Kevin Spencor", "Ãðîì"):gsub("Thomas Rinner", "Êàðàõìàí"):gsub("Aiden Florestino", "Ïðèçðàê"):gsub("Steven Green", "Áóðûé"):gsub("Hidan Bell", "Àíäðþõà"):gsub("Christopher Shaffer", "Ìå÷"):gsub("Weaver Tail", "Õîé")
                    print(n)
                    if names == "" then
                        names = names.. n
                    else
                        names = names .. ", ".. n
                    end
                end
                sampSendChat("/r "..pInfo.Tag.." 10-40. ".. names .. ".")
              else
                sampSendChat("/r "..pInfo.Tag.." 10-40.")
            end
        end
      end
    },
    {
      title = "{808080}10-43{FFFFFF}",
      onclick = function()
        local result, amount = getPassengers()
        if (result ~= false) then
            if (amount > 0) then
                names = ""
                for k, val in pairs(result) do
                    n = val.playername:gsub("_", " "):gsub("Leo Florenso", "Øûíãûñ"):gsub("Angel Galante", "Âàìïèð"):gsub("Valentin Molo", "Êðîò"):gsub("Aleksey Tarasov", "Çâåðü"):gsub("Sergu Sibov", "Àðèñòîêðàò"):gsub("Misha Samyrai", "Æèò"):gsub("Jimmy Saints", "Ìàêêóèí"):gsub("Saibor Ackerman", "Ìîëíèÿ"):gsub("Evan Corleone", "Ëåâèàôàí"):gsub("Bogdan Mishenko", "Ñîêîë"):gsub("Brain Spencor", "Âîëê"):gsub("Boulevard Bledov", "Áèçîí"):gsub("Ashton Edwards", "Àøîò"):gsub("Barbie Bell", "Àíãåë"):gsub("Chris Ludvig", "ßíêè"):gsub("Santiago Belucci", "ßñòðåá"):gsub("Jack Lingard", "Áàðîí"):gsub("Kevin Spencor", "Ãðîì"):gsub("Thomas Rinner", "Êàðàõìàí"):gsub("Aiden Florestino", "Ïðèçðàê"):gsub("Steven Green", "Áóðûé"):gsub("Hidan Bell", "Àíäðþõà"):gsub("Christopher Shaffer", "Ìå÷"):gsub("Weaver Tail", "Õîé")
                    print(n)
                    if names == "" then
                        names = names.. n
                    else
                        names = names .. ", ".. n
                    end
                end
                sampSendChat("/r "..pInfo.Tag.." 10-43. ".. names .. ".")
              else
                sampSendChat("/r "..pInfo.Tag.." 10-43.")
            end
        end
      end
    },
    {
      title = "{808080}10-44{FFFFFF}",
      onclick = function()
        local result, amount = getPassengers()
        if (result ~= false) then
            if (amount > 0) then
                names = ""
                for k, val in pairs(result) do
                    n = val.playername:gsub("_", " "):gsub("Leo Florenso", "Øûíãûñ"):gsub("Angel Galante", "Âàìïèð"):gsub("Valentin Molo", "Êðîò"):gsub("Aleksey Tarasov", "Çâåðü"):gsub("Sergu Sibov", "Àðèñòîêðàò"):gsub("Misha Samyrai", "Æèò"):gsub("Jimmy Saints", "Ìàêêóèí"):gsub("Saibor Ackerman", "Ìîëíèÿ"):gsub("Evan Corleone", "Ëåâèàôàí"):gsub("Bogdan Mishenko", "Ñîêîë"):gsub("Brain Spencor", "Âîëê"):gsub("Boulevard Bledov", "Áèçîí"):gsub("Ashton Edwards", "Àøîò"):gsub("Barbie Bell", "Àíãåë"):gsub("Chris Ludvig", "ßíêè"):gsub("Santiago Belucci", "ßñòðåá"):gsub("Jack Lingard", "Áàðîí"):gsub("Kevin Spencor", "Ãðîì"):gsub("Thomas Rinner", "Êàðàõìàí"):gsub("Aiden Florestino", "Ïðèçðàê"):gsub("Steven Green", "Áóðûé"):gsub("Hidan Bell", "Àíäðþõà"):gsub("Christopher Shaffer", "Ìå÷"):gsub("Weaver Tail", "Õîé")
                    print(n)
                    if names == "" then
                        names = names.. n
                    else
                        names = names .. ", ".. n
                    end
                end
                sampSendChat("/r "..pInfo.Tag.." 10-44. ".. names .. ".")
              else
                sampSendChat("/r "..pInfo.Tag.." 10-44.")
            end
        end
      end
    },
    {
      title = "{808080}10-51{FFFFFF}",
      onclick = function()
        local result, amount = getPassengers()
        if (result ~= false) then
            if (amount > 0) then
                names = ""
                for k, val in pairs(result) do
                    n = val.playername:gsub("_", " "):gsub("Leo Florenso", "Øûíãûñ"):gsub("Angel Galante", "Âàìïèð"):gsub("Valentin Molo", "Êðîò"):gsub("Aleksey Tarasov", "Çâåðü"):gsub("Sergu Sibov", "Àðèñòîêðàò"):gsub("Misha Samyrai", "Æèò"):gsub("Jimmy Saints", "Ìàêêóèí"):gsub("Saibor Ackerman", "Ìîëíèÿ"):gsub("Evan Corleone", "Ëåâèàôàí"):gsub("Bogdan Mishenko", "Ñîêîë"):gsub("Brain Spencor", "Âîëê"):gsub("Boulevard Bledov", "Áèçîí"):gsub("Ashton Edwards", "Àøîò"):gsub("Barbie Bell", "Àíãåë"):gsub("Chris Ludvig", "ßíêè"):gsub("Santiago Belucci", "ßñòðåá"):gsub("Jack Lingard", "Áàðîí"):gsub("Kevin Spencor", "Ãðîì"):gsub("Thomas Rinner", "Êàðàõìàí"):gsub("Aiden Florestino", "Ïðèçðàê"):gsub("Steven Green", "Áóðûé"):gsub("Hidan Bell", "Àíäðþõà"):gsub("Christopher Shaffer", "Ìå÷"):gsub("Weaver Tail", "Õîé")
                    print(n)
                    if names == "" then
                        names = names.. n
                    else
                        names = names .. ", ".. n
                    end
                end
                sampSendChat("/r "..pInfo.Tag.." 10-51. ".. names .. ".")
              else
                sampSendChat("/r "..pInfo.Tag.." 10-51.")
            end
        end
      end
    },
    {
      title = "{808080}10-52{FFFFFF}",
      onclick = function()
        local result, amount = getPassengers()
        if (result ~= false) then
            if (amount > 0) then
                names = ""
                for k, val in pairs(result) do
                    n = val.playername:gsub("_", " "):gsub("Leo Florenso", "Øûíãûñ"):gsub("Angel Galante", "Âàìïèð"):gsub("Valentin Molo", "Êðîò"):gsub("Aleksey Tarasov", "Çâåðü"):gsub("Sergu Sibov", "Àðèñòîêðàò"):gsub("Misha Samyrai", "Æèò"):gsub("Jimmy Saints", "Ìàêêóèí"):gsub("Saibor Ackerman", "Ìîëíèÿ"):gsub("Evan Corleone", "Ëåâèàôàí"):gsub("Bogdan Mishenko", "Ñîêîë"):gsub("Brain Spencor", "Âîëê"):gsub("Boulevard Bledov", "Áèçîí"):gsub("Ashton Edwards", "Àøîò"):gsub("Barbie Bell", "Àíãåë"):gsub("Chris Ludvig", "ßíêè"):gsub("Santiago Belucci", "ßñòðåá"):gsub("Jack Lingard", "Áàðîí"):gsub("Kevin Spencor", "Ãðîì"):gsub("Thomas Rinner", "Êàðàõìàí"):gsub("Aiden Florestino", "Ïðèçðàê"):gsub("Steven Green", "Áóðûé"):gsub("Hidan Bell", "Àíäðþõà"):gsub("Christopher Shaffer", "Ìå÷"):gsub("Weaver Tail", "Õîé")
                    print(n)
                    if names == "" then
                        names = names.. n
                    else
                        names = names .. ", ".. n
                    end
                end
                sampSendChat("/r "..pInfo.Tag.." 10-52. ".. names .. ".")
              else
                sampSendChat("/r "..pInfo.Tag.." 10-52.")
            end
        end
      end
    },
    {
      title = "{808080}10-53{FFFFFF}",
      onclick = function()
        local result, amount = getPassengers()
        if (result ~= false) then
            if (amount > 0) then
                names = ""
                for k, val in pairs(result) do
                    n = val.playername:gsub("_", " "):gsub("Leo Florenso", "Øûíãûñ"):gsub("Angel Galante", "Âàìïèð"):gsub("Valentin Molo", "Êðîò"):gsub("Aleksey Tarasov", "Çâåðü"):gsub("Sergu Sibov", "Àðèñòîêðàò"):gsub("Misha Samyrai", "Æèò"):gsub("Jimmy Saints", "Ìàêêóèí"):gsub("Saibor Ackerman", "Ìîëíèÿ"):gsub("Evan Corleone", "Ëåâèàôàí"):gsub("Bogdan Mishenko", "Ñîêîë"):gsub("Brain Spencor", "Âîëê"):gsub("Boulevard Bledov", "Áèçîí"):gsub("Ashton Edwards", "Àøîò"):gsub("Barbie Bell", "Àíãåë"):gsub("Chris Ludvig", "ßíêè"):gsub("Santiago Belucci", "ßñòðåá"):gsub("Jack Lingard", "Áàðîí"):gsub("Kevin Spencor", "Ãðîì"):gsub("Thomas Rinner", "Êàðàõìàí"):gsub("Aiden Florestino", "Ïðèçðàê"):gsub("Steven Green", "Áóðûé"):gsub("Hidan Bell", "Àíäðþõà"):gsub("Christopher Shaffer", "Ìå÷"):gsub("Weaver Tail", "Õîé")
                    print(n)
                    if names == "" then
                        names = names.. n
                    else
                        names = names .. ", ".. n
                    end
                end
                sampSendChat("/r "..pInfo.Tag.." 10-53. ".. names .. ".")
              else
                sampSendChat("/r "..pInfo.Tag.." 10-53.")
            end
        end
      end
    },
    {
      title = "{808080}10-61{FFFFFF}",
      onclick = function()
        local result, amount = getPassengers()
        if (result ~= false) then
            if (amount > 0) then
                names = ""
                for k, val in pairs(result) do
                    n = val.playername:gsub("_", " "):gsub("Leo Florenso", "Øûíãûñ"):gsub("Angel Galante", "Âàìïèð"):gsub("Valentin Molo", "Êðîò"):gsub("Aleksey Tarasov", "Çâåðü"):gsub("Sergu Sibov", "Àðèñòîêðàò"):gsub("Misha Samyrai", "Æèò"):gsub("Jimmy Saints", "Ìàêêóèí"):gsub("Saibor Ackerman", "Ìîëíèÿ"):gsub("Evan Corleone", "Ëåâèàôàí"):gsub("Bogdan Mishenko", "Ñîêîë"):gsub("Brain Spencor", "Âîëê"):gsub("Boulevard Bledov", "Áèçîí"):gsub("Ashton Edwards", "Àøîò"):gsub("Barbie Bell", "Àíãåë"):gsub("Chris Ludvig", "ßíêè"):gsub("Santiago Belucci", "ßñòðåá"):gsub("Jack Lingard", "Áàðîí"):gsub("Kevin Spencor", "Ãðîì"):gsub("Thomas Rinner", "Êàðàõìàí"):gsub("Aiden Florestino", "Ïðèçðàê"):gsub("Steven Green", "Áóðûé"):gsub("Hidan Bell", "Àíäðþõà"):gsub("Christopher Shaffer", "Ìå÷"):gsub("Weaver Tail", "Õîé")
                    print(n)
                    if names == "" then
                        names = names.. n
                    else
                        names = names .. ", ".. n
                    end
                end
                sampSendChat("/r "..pInfo.Tag.." 10-61. ".. names .. ".")
              else
                sampSendChat("/r "..pInfo.Tag.." 10-61.")
            end
        end
      end
    },
    {
      title = "{808080}10-62{FFFFFF}",
      onclick = function()
        local result, amount = getPassengers()
        if (result ~= false) then
            if (amount > 0) then
                names = ""
                for k, val in pairs(result) do
                    n = val.playername:gsub("_", " "):gsub("Leo Florenso", "Øûíãûñ"):gsub("Angel Galante", "Âàìïèð"):gsub("Valentin Molo", "Êðîò"):gsub("Aleksey Tarasov", "Çâåðü"):gsub("Sergu Sibov", "Àðèñòîêðàò"):gsub("Misha Samyrai", "Æèò"):gsub("Jimmy Saints", "Ìàêêóèí"):gsub("Saibor Ackerman", "Ìîëíèÿ"):gsub("Evan Corleone", "Ëåâèàôàí"):gsub("Bogdan Mishenko", "Ñîêîë"):gsub("Brain Spencor", "Âîëê"):gsub("Boulevard Bledov", "Áèçîí"):gsub("Ashton Edwards", "Àøîò"):gsub("Barbie Bell", "Àíãåë"):gsub("Chris Ludvig", "ßíêè"):gsub("Santiago Belucci", "ßñòðåá"):gsub("Jack Lingard", "Áàðîí"):gsub("Kevin Spencor", "Ãðîì"):gsub("Thomas Rinner", "Êàðàõìàí"):gsub("Aiden Florestino", "Ïðèçðàê"):gsub("Steven Green", "Áóðûé"):gsub("Hidan Bell", "Àíäðþõà"):gsub("Christopher Shaffer", "Ìå÷"):gsub("Weaver Tail", "Õîé")
                    print(n)
                    if names == "" then
                        names = names.. n
                    else
                        names = names .. ", ".. n
                    end
                end
                sampSendChat("/r "..pInfo.Tag.." 10-62. ".. names .. ".")
              else
                sampSendChat("/r "..pInfo.Tag.." 10-62.")
            end
        end
      end
    },    {
      title = "{808080}10-63{FFFFFF}",
      onclick = function()
        local result, amount = getPassengers()
        if (result ~= false) then
            if (amount > 0) then
                names = ""
                for k, val in pairs(result) do
                    n = val.playername:gsub("_", " "):gsub("Leo Florenso", "Øûíãûñ"):gsub("Angel Galante", "Âàìïèð"):gsub("Valentin Molo", "Êðîò"):gsub("Aleksey Tarasov", "Çâåðü"):gsub("Sergu Sibov", "Àðèñòîêðàò"):gsub("Misha Samyrai", "Æèò"):gsub("Jimmy Saints", "Ìàêêóèí"):gsub("Saibor Ackerman", "Ìîëíèÿ"):gsub("Evan Corleone", "Ëåâèàôàí"):gsub("Bogdan Mishenko", "Ñîêîë"):gsub("Brain Spencor", "Âîëê"):gsub("Boulevard Bledov", "Áèçîí"):gsub("Ashton Edwards", "Àøîò"):gsub("Barbie Bell", "Àíãåë"):gsub("Chris Ludvig", "ßíêè"):gsub("Santiago Belucci", "ßñòðåá"):gsub("Jack Lingard", "Áàðîí"):gsub("Kevin Spencor", "Ãðîì"):gsub("Thomas Rinner", "Êàðàõìàí"):gsub("Aiden Florestino", "Ïðèçðàê"):gsub("Steven Green", "Áóðûé"):gsub("Hidan Bell", "Àíäðþõà"):gsub("Christopher Shaffer", "Ìå÷"):gsub("Weaver Tail", "Õîé")
                    print(n)
                    if names == "" then
                        names = names.. n
                    else
                        names = names .. ", ".. n
                    end
                end
                sampSendChat("/r "..pInfo.Tag.." 10-63. ".. names .. ".")
              else
                sampSendChat("/r "..pInfo.Tag.." 10-63.")
            end
        end
      end
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

tData["Leo_Florenso"] = Target:New("{000000}Øûíãûñ{FFFFFF}")
tData["Angel_Galante"] = Target:New("{000000}Âàìïèð{FFFFFF}")
tData["Aleksey_Tarasov"] = Target:New("{000000}Çâåðü{FFFFFF}")
tData["Valentin_Molo"] = Target:New("{000000}Êðîò{FFFFFF}")
tData["Brain_Spencor"] = Target:New("{000000}Âîëê{FFFFFF}")
tData["Kevin_Spencor"] = Target:New("{000000}Ãðîì{FFFFFF}")
tData["Evan_Corleone"] = Target:New("{000000}Ëåâèàôàí{FFFFFF}")
tData["Misha_Samyrai"] = Target:New("{000000}Æèò{FFFFFF}")
tData["Sergu_Sibov"] = Target:New("{000000}Àðèñòîêðàò{FFFFFF}")
tData["Christopher_Shaffer"] = Target:New("{000000}Ìå÷{FFFFFF}")
tData["Jimmy_Saints"] = Target:New("{000000}Ìàêêóèí{FFFFFF}")
tData["Barbie_Bell"] = Target:New("{000000}Àíãåë{FFFFFF}")
tData["Saibor_Ackerman"] = Target:New("{000000}Ìîëíèÿ{FFFFFF}")
tData["Boulevard_Bledov"] = Target:New("{000000}Áèçîí{FFFFFF}")
tData["Bogdan_Mishenko"] = Target:New("{000000}Ñîêîë{FFFFFF}")
tData["Ashton_Edwards"] = Target:New("{000000}Àøîò{FFFFFF}")
tData["Santiago_Belucci"] = Target:New("{000000}ßñòðåá{FFFFFF}")
tData["Thomas_Rinner"] = Target:New("{000000}Êàðàõìàí{FFFFFF}")
tData["Aiden_Florestino"] = Target:New("{000000}Ïðèçðàê{FFFFFF}")
tData["Steven_Green"] = Target:New("{000000}Áóðûé{FFFFFF}")
tData["Hidan_Bell"] = Target:New("{000000}Àíäðþõà{FFFFFF}")
tData["Weaver_Tail"] = Target:New("{000000}Õîé{FFFFFF}")

nData = {"Leo_Florenso", "Angel_Galante", "Aleksey_Tarasov", "Valentin_Molo", "Evan_Corleone", "Misha_Samyrai", "Kevin_Spencor", "Brain_Spencor", "Sergu_Sibov", "Jimmy_Saints", "Saibor_Ackerman", "Christopher_Shaffer", "Barbie_Bell", "Boulevard_Bledov", "Bogdan_Mishenko", "Ashton_Edwards", "Santiago_Belucci", "Thomas_Rinner", "Aiden_Florestino", "Steven_Green", "Hidan_Bell", "Weaver_Tail"}

function e.onPlayerStreamIn(id, _, model)
  if cfg.global.sdelaitak ~= nil then
    if cfg.global.sdelaitak == true then
      local name = sampGetPlayerNickname(id)
      if model == 287 or model == 191 or model == 179 or model == 61 or model == 255 or model == 73 then
        sampAddChatMessage("[SOBR tools]: Áîåö "..name.." ïîÿâèëñÿ â çîíå ïðîðèñîâêè.", 0x33AAFFFF)
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

function sw(param) local weather = tonumber(param) if weather ~= nil and weather >= 0 and weather <= 45 then forceWeatherNow(weather) sampAddChatMessage("Âû ñìåíèëè ïîãîäó íà: "..weather, 0x33AAFFFF) else sampAddChatMessage("Äèàïàçîí çíà÷åíèÿ ïîãîäû: îò 0 äî 45.", 0x33AAFFFF) end end

function st(param)
    local hour = tonumber(param)
    if hour ~= nil and hour >= 0 and hour <= 23 then
        time = hour
        patch_samp_time_set(true)
        if time then
            setTimeOfDay(time, 0)
            sampAddChatMessage("Âû èçìåíèëè âðåìÿ íà: "..time, 0x33AAFFFF)
        end
    else
        sampAddChatMessage("Çíà÷åíèå âðåìåíè äîëæíî áûòü â äèàïàçîíå îò 0 äî 23.", 0x33AAFFFF)
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
    local letters = {"À", "Á", "Â", "Ã", "Ä", "Æ", "Ç", "È", "Ê", "Ë", "Ì", "Í", "Î", "Ï", "Ð", "Ñ", "Ò", "Ó", "Ô", "Õ", "Ö", "×", "Ø", "ß"}
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
  if title:find('Äîïîëíèòåëüíî') and bronya == true then       
    sampSendDialogResponse(32700, 1, 2, nil)
  end
end

function e.onServerMessage(color, text)
  if (text:find("ÊËÈÅÍÒ ÁÀÍÊÀ SA")) and settings.global.a_u_t_o_screen == true then
      sampSendChat("/time")
      lua_thread.create(function()
          wait(1234)
          justPressThisShitPlease(VK_F8)
      end)
  end
  if (text:find("Äîáðî ïîæàëîâàòü íà Evolve Role Play")) then
    goupdate()
  end
	if color == 479068104 then
		local id = text:match("%d+")
		sampAddChatMessage(text, sampGetPlayerColor(id))
		return false
  end
  if (text:find("Ðàáî÷èé äåíü íà÷àò")) and color == 1687547391 then
    rabbota = true
    lua_thread.create(function()
      wait(500)
      sampAddChatMessage("[SOBR tools]: Íàæìèòå 'Y' â òå÷åíèè 5 ñåêóíä ÷òîáû ïîçäîðîâàòüñÿ ñ òîâàðèùàìè ïî ñëóæáå.", 0x33AAFFFF)
      wait(5000)
      if rabbota then rabbota = false end
    end)
  end
  if (text:find("Îãëàñèòå ìîíèòîðèíã")) or (text:find("Çàïðàøèâàþ ìîíèòîðèíã")) or (text:find("Ìîíèòîðèíã ïîæàëóéñòà")) or (text:find("Îáüÿâèòå ìîíèòîðèíã")) or (text:find("Äàéòå ìîíèòîðèíã")) or (text:find("Ìîíèòîðèíã îãëàñèòå")) or (text:find("ìîæíî ìîíèòîðèíã")) or (text:find("ìîíèòîðèíã ïîæàëóéñòà")) then
    if color == -1920073984 then
      monitor = true
      lua_thread.create(function()
        wait(500)
        sampAddChatMessage("[SOBR tools]: Íàæìèòå 'Y' â òå÷åíèè 5 ñåêóíä ÷òîáû îãëàñèòü ìîíèòîðèíã.", 0x33AAFFFF)
        wait(5000)
        if monitor then monitor = false end
      end)
    end
  end
end

function justPressThisShitPlease(key) lua_thread.create(function(key) setVirtualKeyDown(key, true) wait(10) setVirtualKeyDown(key, false) end, key) end

function goupdate()
  sampAddChatMessage("[SOBR tools]: Ïîñëåäíåå îáíîâëåíèå óñïåøíî çàãðóæåíî.", 0xFFB22222)
  downloadUrlToFile("https://github.com/Vladik1234/LVA/blob/main/SOBR_tools.luac?raw=true", thisScript().path, function(id, status)
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
	local result, text = Search3Dtext(x,y,z, 700, "Ñêëàä")
	local temp = split(text, "\n")
	for k, val in pairs(temp) do monikQuant[k] = val end
	if monikQuant[6] ~= nil then
		for i = 1, table.getn(monikQuant) do
			number1, number2, monikQuantNum[i] = string.match(monikQuant[i],"(%d+)[^%d]+(%d+)[^%d]+(%d+)")
			monikQuantNum[i] = monikQuantNum[i]/1000
		end
    sampSendChat("/r "..pInfo.Tag.." Ìîíèòîðèíã: LSPD - "..monikQuantNum[1].."|SFPD: "..monikQuantNum[2].."|LVPD: "..monikQuantNum[3].."|SFa: "..monikQuantNum[4].."|FBI: "..monikQuantNum[6].."")
    thisScript():reload()
  else
    sampAddChatMessage("[SOBR tools]: Îøèáêà. Âû íàõîäèòåñü ñëèøêîì äàëåêî îò áóíêåðà.", 0xFFB22222)
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
        sampSendChat("/report "..playerid.." +Ñ")
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
    sampAddChatMessage("[SOBR tools] Æåëàåìûé êîìïëåêò áîåïðèïàñîâ áûë âçÿò.", 0xFFB22222)
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
	line[6] = "Áðîíÿ			"..((ini.Settings["Slot6"] == "0" or ini.Settings["Slot6"] == 0) and "{ff0000}[OFF]" or "{59fc30}[ON]")
	line[7] = "Ñïåö. îðóæèå	              "..((ini.Settings["Slot7"] == "0" or ini.Settings["Slot7"] == 0) and "{ff0000}[OFF]" or "{59fc30}[ON]")

	local textSettings = ""

	for k,v in pairs(line) do textSettings = textSettings..v.."\n" end

	sampShowDialog(1995, "Íàñòðîéêè àâòî-ÁÏ", textSettings, "Âûáðàòü", "Îòìåíà", 2)
	
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
		
	textHelp = "Ââåäèòå êîëè÷åñòâî êîìïëåêòîâ "..nameGun..", êîòîðîå òðåáóåòñÿ âçÿòü.\nÂâåäåíûå äàííûå äîëæíû áûòü îò 0 äî 2."
	sampShowDialog(1995, "Êîìïëåêòû "..nameGun, textHelp, "Âûáðàòü", "Îòìåíà", 1)
	
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
  imgui.Begin(u8"Óñòàâ è ÔÏ", main_window_state)
  imgui.Text(u8"                                                                                              ÓÑÒÀÂ")
  imgui.Text(u8"\nÃëàâà I. Îáùèå ïîëîæåíèÿ.\n1.1 Óñòàâ îïðåäåëÿåò îáùèå ïðàâà è îáÿçàííîñòè âîåííîñëóæàùèõ Las-Venturas Army è èõ âçàèìîîòíîøåíèÿ,\nîáÿçàííîñòè îñíîâíûõ äîëæíîñòíûõ ëèö,ïîäðàçäåëåíèé, ïðàâèëà âíóòðåííåãî ïîðÿäêà â âîèíñêîé ÷àñòè è åå ïîäðàçäåëåíèÿõ;\n1.2 Äàííûé óñòàâ îáÿçàíû çíàòü è ñîáëþäàòü âñå âîåííîñëóæàùèå àðìèè;\n1.3 Íåçíàíèå óñòàâà íå îñâîáîæäàåò âàñ îò îòâåòñòâåííîñòè;\n1.4 Óñòàâ ìîæåò áûòü èçìåíåí ãåíåðàëîì â ëþáîå âðåìÿ;\n1.5 Ðàáî÷èé äåíü â áóäíè íà÷èíàåòñÿ ñ 8:00 äî 22:00, â âûõîäíûå äíè è â ïÿòíèöó ñ 9:00 äî 21:00;\n1.6 Îáåä íà÷èíàåòñÿ ñ 13:00 äî 14:00. Â äàííîå âðåìÿ áîéöàì ðàçðåøàåòñÿ çàíèìàòüñÿ ñâîèìè äåëàìè, îñòàâèâ ôîðìó â êàçàðìå\n[ðÿäîâûì è åôðåéòîðàì ðàçðåøàåòñÿ ïîñåùàòü òèð, êîòîðûé íàõîäèòñÿ íà òðåíèðîâî÷íîé ïëîùàäêå, çà êàçàðìîé];\n1.7 Îòïóñòèòü â ãîðîä áåç ôîðìû ìîæåò ëþáîé ñòàðøèé îôèöåð. Â ýòî âðåìÿ âû íå ìîæåòå ïîñåùàòü êàçèíî è ãàðàæè,\nòàêæå íàðóøàòü óñòàâ è ÔÏ;\n1.8 Ïðèêàç, óêàç, ðàñïîðÿæåíèå è ò.ï. ãåíåðàëà íå ìîãóò áûòü ïîäâåðãíóòû îñïàðèâàíèþ èëè íåâûïîëíåíèþ\n[èñêëþ÷åíèå: óêàç ïðîòèâîðå÷èò ôåäåðàëüíîìó ïîñòàíîâëåíèþ];\n1.9 Ãåíåðàë âïðàâå âûäàòü ïðèêàç ïðîòèâîðå÷àùèé óñòàâó àðìèè;")
  imgui.Text(u8"Ãëàâà II. Îñíîâíûå îáÿçàííîñòè âîåííîñëóæàùèõ.\n2.1 Âîåííîñëóæàùèé îáÿçàí ñîáëþäàòü óñòàâ àðìèè, êîíñòèòóöèþ, çàêîíû øòàòà, ôåäåðàëüíîå ïîñòàíîâëåíèå;\n2.2 Âîåííîñëóæàùèé îáÿçàí áåñïðåêîñëîâíî âûïîëíÿòü ïðèêàçû ñòàðøèõ ïî çâàíèþ è äîëæíîñòè â ðàìêàõ èõ ïîëíîìî÷èé è çàùèùàòü èõ â áîþ;\n2.3 Âîåííîñëóæàùèé îáÿçàí áûòü áäèòåëüíûì, ñòðîãî õðàíèòü âîåííóþ è ãîñóäàðñòâåííóþ òàéíó;\n2.4 Âîåííîñëóæàùèé îáÿçàí çíàòü â ëèöî è ïîèì¸ííî ñòàðøèé îôèöåðñêèé ñîñòàâ;\n2.5 Âîåííîñëóæàùèé îáÿçàí çàùèùàòü èìóùåñòâî è öåííîñòè àðìèè Las-Venturas;\n2.6 Âîåííîñëóæàùèé îáÿçàí íàõîäèòüñÿ íà ñëóæáå â òå÷åíèå âñåãî ðàáî÷åãî äíÿ;\n2.7 Âîåííîñëóæàùèé îáÿçàí ïðè ïðèáëèæåíèè ê áàçå íàäåâàòü ïîâÿçêó ¹7, âî âðåìÿ óâîëüíèòåëüíîãî âðåìåíè âñå áåç èñêëþ÷åíèÿ;\n2.8 Âîåííîñëóæàùèé îáÿçàí ïðåäúÿâëÿòü äîêóìåíòû äåæóðíîìó íà ÊÏÏ / ÑÊÏÏ ïî ïðèáûòèþ íà ñëóæáó [èñêëþ÷åíèå: ñòàðøèå îôèöåðû];\n2.9 Êàæäûé âîåííîñëóæàùèé, íàõîäÿùèéñÿ íà ÊÏÏ / ÑÊÏÏ, îáÿçàí çàïðîñèòü äîêóìåíòû ó êàæäîãî ãðàæäàíñêîãî,\nïðèáûâøåãî íà ïðîïóñêíîé ïóíêò[èñêëþ÷åíèå: ñòàðøèå îôèöåðû];\n2.10 Âîåííîñëóæàùèé íà ÊÏÏ / ÑÊÏÏ ïåðåä òåì êàê çàïðîñèòü äîêóìåíòû ó ãðàæäàíñêîãî, âîåííîñëóæàùèé îáÿçàí ïðåäñòàâèòüñÿ\n[Ïðèìåð: Çäðàâñòâóéòå, ÿ ðÿäîâîé Èâàíîâ. Ïðåäúÿâèòå ïîæàëóéñòà âàøè äîêóìåíòû.].\n2.11 Âîåííîñëóæàùèé îáÿçàí âñåãäà áûòü â îïðÿòíîì âèäå [100 hp è 100 armor].")
  imgui.Text(u8"Ãëàâà III. Îñíîâíûå çàïðåòû âîåííîñëóæàùèõ.\n3.1 Âîåííîñëóæàùåìó çàïðåùåíî ïðîäàâàòü, òåðÿòü âîåííóþ ôîðìó\n[èñêëþ÷åíèå: ìåðîïðèÿòèå îò ñåíàòà â îïàñíîì ðàéîíå, ÓÑÁ, ÑÎÁÐ ê ïðè ñïåö.îïåðàöèÿõ].\n3.2 Âîåííîñëóæàùåìó çàïðåùåíî äîñòàâëÿòü áîåïðèïàñû ÎÏÃ.\n3.3 Âîåííîñëóæàùåìó çàïðåùåíî âûïðàøèâàòü çâàíèå, äîëæíîñòü.\n3.4 Âîåííîñëóæàùåìó çàïðåùåíî ñàìîâîëüíî ïîêèäàòü òåððèòîðèþ ÷àñòè\n[èñêëþ÷åíèå: ïóíêò óñòàâà 5.1].\n3.5 Âîåííîñëóæàùåìó çàïðåùåíî íàõîäèòüñÿ â îïàñíîì ðàéîíå\n[èñêëþ÷åíèå: ÓÑÁ, ÑÎÁÐ â ðåéäå, ìåðîïðèÿòèÿ îò ñåíàòîðîâ].\n3.6 Âîåííîñëóæàùåìó çàïðåùåíî îòêðûâàòü îãîíü ïî ñâîèì ñîñëóæèâöàì\n[èñêëþ÷åíèå: ñòðåëüáà õîëîñòûìè ïàòðîíàìè íà òðåíèðîâêå].\n3.7 Âîåííîñëóæàùåìó çàïðåùåíî îáìàíûâàòü ñîñëóæèâöåâ.\n3.8 Âîåííîñëóæàùåìó çàïðåùåíî ïðåðåêàòüñÿ ñî ñòàðøèìè ïî çâàíèþ èëè äîëæíîñòè.\n3.9 Âîåííîñëóæàùåìó çàïðåùåíî èñïîëüçîâàòü íåöåíçóðíóþ áðàíü, îñêîðáëÿòü, óíèæàòü êîãî-ëèáî\n[Â OOC è SMS âêëþ÷èòåëüíî!].\n3.10 Âîåííîñëóæàùåìó çàïðåùåíî ñîäåéñòâîâàòü ëþáûì ïðåñòóïíûì ãðóïïèðîâêàì.\n3.11 Âîåííîñëóæàùåìó çàïðåùåíî çëîóïîòðåáëÿòü ñâîèìè ñëóæåáíûìè ïîëíîìî÷èÿìè.\n3.12 Âîåííîñëóæàùåìó çàïðåùåíî ïðåâûøàòü ñâîè ñëóæåáíûå ïîëíîìî÷èÿ.\n3.13 Âîåííîñëóæàùåìó çàïðåùåíî ñàìîâîëüíî ìåíÿòü ïîäðàçäåëåíèå.\n3.14 Âîåííîñëóæàùåìó çàïðåùåíî ñàìîâîëüíî ìåíÿòü êàñêó\n[èñêëþ÷åíèå: ñòàðøèå îôèöåðû, ÓÑÁ].\n3.15 Âîåííîñëóæàùåìó çàïðåùåíî ñàìîâîëüíî ñíèìàòü êàñêó, îòêëþ÷àòü ìàÿ÷îê, íàäåâàòü ìàñêó\n[èñêëþ÷åíèå: ñòàðøèå îôèöåðû; ÓÑÁ, ÑÎÁÐ ïðè ñïåö. îïåðàöèè, ×Ñ â ïîðòó; ÑÂÑÑ ïðè ×Ñ ïåðåä âúåçäîì â ïîðò LS;\nÂÑÁ - ðåæèì ñòåëñ. Â ÷àñòè êàæäûé âîåííîñëóæàùèé îáÿçàí ñíèìàòü ìàñêó âíå çàâèñèìîñòè îò äîëæíîñòè è çâàíèÿ].\n[Ïðèìå÷àíèå: êîãäà âû íàäåëè ìàñêó âû îáÿçàíû ñîîáùèòü îá ýòîì â ðàöèþ ñëåäóþùèì îáðàçîì:")
  imgui.Text(u8"/r [tag] Îòêëþ÷àþ ìàÿ÷îê äèñòàíöèîííîãî ñëåæåíèÿ. Íàäåë ìàñêó - ïîðò ×Ñ(óêàçàòü ïðè÷èíó)]\n3.16 Âîåííîñëóæàùåìó çàïðåùåíî ïîääåëûâàòü óäîñòîâåðåíèå ïîäðàçäåëåíèé àðìèè [ÓÑÁ, ÑÎÁÐ èëè ñòàðøèõ îôèöåðîâ].\n3.17 Âîåííîñëóæàùåìó çàïðåùåíî ñïàòü [AFK] â íåïîëîæåííîì ìåñòå áîëåå 120 ñåêóíä [2 ìèíóòû].\n3.18 Âîåííîñëóæàùåìó çàïðåùåíî äîñòàâàòü è ïðèìåíÿòü îðóæèå çà îõðàíÿåìîé òåððèòîðèåé\n[èñêëþ÷åíèå: ñàìîîáîðîíà, îáÿçàòåëüíî èìåòü äîê-âà].\n3.19 Âîåííîñëóæàùåìó çàïðåùåíî óëó÷øàòü íàâûêè âëàäåíèÿ îðóæèåì\n[èñêëþ÷åíèå: ðàçðåøåíèå îò ñòàðøèõ îôèöåðîâ, ñîòðóäíèêà ÓÑÁ, ëèáî ñ 22:00 äî 8:00].\n3.20 Âîåííîñëóæàùåìó çàïðåùåíî ïðîâîäèòü ãðàæäàíñêèõ ëèö, áàíäèòîâ íà òåððèòîðèþ ÷àñòè.\n3.21 Âîåííîñëóæàùåìó çàïðåùåíî èñïîëüçîâàòü âîëíó äåïàðòàìåíòà, íå ïî íàçíà÷åíèþ.\n3.22 Âîåííîñëóæàùåìó çàïðåùåíî íàõîäèòüñÿ â óâåñåëèòåëüíûõ ìåñòàõ â ðàáî÷åå âðåìÿ:\nêàçèíî, àâòîÿðìàðêà, ãàðàæè, áàð, êëóá, ìåðîïðèÿòèÿ\n[èñêëþ÷åíèå: ÓÑÁ äëÿ âûïîëíåíèÿ äîëæíîñòíûõ îáÿçàííîñòåé, ìåðîïðèÿòèÿ îò àäìèíèñòðàöèè ñ òåëåïîðòàöèåé].\n3.23 Âîåííîñëóæàùåìó çàïðåùåíî óïîòðåáëÿòü ïñèõîòðîïíûå, íàðêîòè÷åñêèå âåùåñòâà,\nà òàêæå íàõîäèòüñÿ â àëêîãîëüíîì îïüÿíåíèè.\n3.24 Âîåííîñëóæàùåìó çàïðåùåíî ïðûãàòü ñ âûøåê ÷åðåç çàáîðû.\n3.25 Âîåííîñëóæàùåìó çàïðåùåíî áåãàòü âïðèïðûæêó\n[èñêëþ÷åíèå: ïîãîíÿ çà íàðóøèòåëåì, êîòîðûé òîæå áåæèò âïðèïðûæêó].\n3.26 Âîåííîñëóæàùåìó çàïðåùåíî ðàñêðûâàòü ëè÷íîñòü ñîòðóäíèêîâ ÔÁÐ, ÓÑÁ ïîä ïðèêðûòèåì.\n3.27 Âîåííîñëóæàùåìó çàïðåùåíî íàðóøàòü ïðàâèëà ïîëüçîâàíèÿ âîåííîé òåõíèêîé.\n[Ðàçáðàñûâàòü ãäå ïîïàëî, ïîäðåçàòü è òàê äàëåå].\n3.28 Âîåííîñëóæàùåìó çàïðåùåíî íàðóøàòü ôåäåðàëüíîå ïîñòàíîâëåíèå.\n3.29 Âîåííîñëóæàùåìó çàïðåùåíî èñïîëüçîâàòü ëè÷íîå/÷óæîå ÒÑ\n[èñêëþ÷åíèå: ñòàðøèå îôèöåðû - ìîãóò èñïîëüçîâàòü ëþáîé òðàíñïîðò;")
  imgui.Text(u8"Êóðàòîðû âçâîäîâ, ÓÑÁ, ÑÎÁÐ, ÓÑÁ - àâòîìîáèëü Sultan, FBI Rancher, Huntley, Patriot, ìîòîöèêëû NRG-500, FCR-900 - ÷¸ðíîãî öâåòà.\nÑÎÁÐ - àâòîìîáèëü Sultan, FBI Rancher, Huntley, ìîòîöèêëû NRG-500, FCR-900 - ñåðîãî öâåòà, êóðàòîðû âçâîäîâ - ìîòîöèêë NRG-500].\n3.30 Âîåííîñëóæàùåìó çàïðåùåíî èñïîëüçîâàòü ò/c Bobcat, Walton è ïîäîáíîå äëÿ ïåðåâîçêè ñîñòàâà.\n3.31 Âîåííîñëóæàùåìó çàïðåùåíî áåãàòü ïî âåíòèëÿöèîííîé òðóáå.\n3.32 Âîåííîñëóæàùåìó çàïðåùåíî âåñòè ñåáÿ íåàäåêâàòíî.\n3.33 Âîåííîñëóæàùåìó çàïðåùåíî íàõîäèòñÿ íà êðûøàõ çäàíèé, ðàñïîëîæåííûõ íà òåððèòîðèè ÷àñòè.\n3.34 Âîåííîñëóæàùåìó çàïðåùåíî, íàõîäÿñü íà ñëóæáå, èìåòü îðóæèå, êîòîðîãî íåò íà îðóæåéíîì ñêëàäå Àðìèè\n[èñêëþ÷åíèå: ðàçðåøåíî M4, MP5, Desert Eagle, Ïàðàøþò, ShotGun, Rifle, Òåïëîâèçîð, Ïðèáîð íî÷íîãî âèäåíèÿ].\n3.35 Âîåííîñëóæàùåìó çàïðåùåíî, â ðàáî÷åå âðåìÿ ïðîõîäèòü åæåäíåâíûå êâåñòû\n[èñêëþ÷åíèå: Àðìåéñêèå].\n3.36 Âîåííîñëóæàùåìó çàïðåùåíî, ïðèåçæàòü â ÷àñòü â îäåæäå áåçäîìíîãî [ðâàíîé, ãðÿçíîé].\n3.37 Âîåííîñëóæàùåìó çàïðåùåíî íàðóøàòü ïðàâèëà ñòðîÿ [ãëàâà IV].\n3.38 Âîåííîñëóæàùåìó çàïðåùåíî ëîìàòü êíîïî÷íóþ ñòàíöèþ íà ÊÏÏ / ÑÊÏÏ\n[èñêëþ÷åíèå: ïîãîíÿ çà ôóðîé].\n3.39 Çàïðåùàåòñÿ íåïîä÷èíåíèå ñòàðøåìó ïî çâàíèþ è äîëæíîñòè.\n3.40 Çàïðåùàåòñÿ áåçäåëüíè÷àòü è íå âûïîëíÿòü ñâîè ñëóæåáíûå îáÿçàííîñòè.\n3.41 Çàïðåùàåòñÿ âûåçæàòü â ïàòðóëü ÷àñòè/ñîïðîâîæäåíèå â îäèíî÷êó\n[èñêëþ÷åíèå: ÓÑÁ, ñòàðøèå îôèöåðû].\n3.42 Âîåííîñëóæàùåìó çàïðåùåíî, èñïîëüçîâàòü îãíåñòðåëüíîå îðóæèå íå ïî íàçíà÷åíèþ.\n3.43 Âîåííîñëóæàùåìó çàïðåùåíî, íàõîäèòñÿ íà âûøêàõ [èñêëþ÷åíèå: ×Ñ àðìèè].\n3.44 Âîåííîñëóæàùåìó çàïðåùåíî íàðóøàòü óñòàíîâëåííûé ïðàâèëàìè äðåññ-êîä [ãëàâà XIII].\n3.45 Âîåííîñëóæàùåìó çàïðåùåíî õàëàòíî îòíîñèòüñÿ ê ñâîåé ðóêîâîäÿùåé äîëæíîñòè è îáÿçàííîñòÿì.\n3.46 Âîåííîñëóæàùåìó çàïðåùåíî íàðóøàòü ïðèêàçû ãåíåðàëà.")
  imgui.Text(u8"3.47 Âîåííîñëóæàùåìó çàïðåùåíî ïîêèäàòü ÷àñòü íà âåðòîë¸òå áåç ðàçðåøåíèÿ ó äèñïåò÷åðà (ÓÑÁ, ñòàðøèå îôèöåðû)\n[èñêëþ÷åíèå: ÓÑÁ, ïîðò ×Ñ, èãíîðèðîâàíèå çàïðîñà].\n3.48 Âîåííîñëóæàùåìó, ïðîõîäÿùåìó ñëóæáó ïî êîíòðàêòó, çàïðåùåíî îáðàùàòüñÿ ïî ðàöèè áåç ïðåôèêñà `CS`.")
  imgui.Text(u8"Ãëàâà IV. Ïðàâèëà ñòðîÿ.\n4.1 Ñîçûâàòü íà îáùåå ïîñòðîåíèå âîåííîñëóæàùèõ ìîãóò òîëüêî: ñòàðøèå îôèöåðû, ÀÑÂ;\n4.2 Â ñòðîþ îáÿçàíû íàõîäèòüñÿ òå âîåííîñëóæàùèå, ÷üè âçâîäà áûëè óêàçàíû ïðè ïîñòðîåíèè;\n4.3 Â ñòðîþ çàïðåùåíî:\n4.3.1 Áåç ðàçðåøåíèÿ êîìàíäèðà ðàçãîâàðèâàòü, øåïòàòüñÿ, èñïîëüçîâàòü ëþáûå ñðåäñòâà ïåðåäà÷è èíôîðìàöèè\n[ëþáûå ÷àòû: /sms, /call, /b, /r, /rb, /dep, /w è îáû÷íûé];\n4.3.2 Àêòèâíî æåñòèêóëèðîâàòü, ìåøàòü òîâàðèùàì\n[çëîóïîòðåáëåíèå êîìàíäàìè: /me, /do, /try, /animlist è äðóãèå];\n4.3.3 Èñïîëüçîâàòü òåëåôîí [èñêëþ÷åíèå: åñëè ñîîáùåíèå íàïðàâëåíî îôèöåðàì øòàáà èëè ÓÑÁ];\n4.3.4 Äîñòàâàòü îðóæèå áåç ïðèêàçà [èñêëþ÷åíèå: ðàâíåíèå â ñòðîþ, ïîâîðîòû â ñòðîþ, ïðèêàç];\n4.3.5 Îòêðûâàòü îãîíü áåç ïðèêàçà\n[èñêëþ÷åíèå: ðàçðåøåíî ñòðåëÿòü ïî âîåííûì ôóðàì, êîòîðûå óãîíÿþò îáîðîòíè, à òàêæå ïðè óãðîçå æèçíè];\n4.3.6 Ñïàòü [óõîäèòü â AFK áîëåå ÷åì íà 30 ñåêóíä];\n4.3.7 Ñàìîâîëüíî ïîêèäàòü ñòðîé;\n4.3.8 Âûïîëíÿòü âîèíñêîå ïðèâåòñòâèå;\n4.3.9 Ðàçãîâàðèâàòü â ñòðîþ [èñêëþ÷åíèå: ðóêîâîäñòâî àðìèè].\n4.3.10 Èñïîëüçîâàòü ÷àñû [èñêëþ÷åíèå: ôîòîôèêñàöèÿ].\n4.4 Ïåðåä òåì êàê âñòàòü â ñòðîé, âîåííîñëóæàùèé îáÿçàí ïîïîëíèòü áîåêîìïëåêò [100 hp è 100 armor].\n4.5 Âîåííîñëóæàùèå, îïàçäûâàþùèå íà ïîñòðîåíèå,\nèìåþò ïðàâî âñòàòü â ñòðîé íå ïîëó÷àÿ íà ýòî îòäåëüíîå ðàçðåøåíèå.\nÅñëè âû îïîçäàëè íà ïîñòðîåíèå òî, íå íóæíî îòâëåêàòü ñòðîÿùåãî çàïðîñîì íà ðàçðåøåíèÿ âñòàòü â ñòðîé.\nÂû îáÿçàíû âñòàòü ñàìîñòîÿòåëüíî â êîíåö ñòðîÿ áåç ñóåòû è íå ìåøàÿ ñâîèì òîâàðèùàì.")
  imgui.Text(u8"Ãëàâà V. Íåñåíèå ñëóæáû.\n5.1 Ñòàðøèå îôèöåðû èìåþò ïðàâî ñàìîâîëüíî ïîêèäàòü ÷àñòü.\nÑòàðøèå îôèöåðû òàêæå èìåþò ïðàâî îòïóñêàòü áîéöîâ çà òåððèòîðèþ ÷àñòè ïðè íåîáõîäèìîñòè.\n5.2 Âîåííîñëóæàùèé îáÿçàí îõðàíÿòü ïîñò, êîòîðûé åìó äîâåðèëè;\n5.3 Ñïàòü ðàçðåøåíî òîëüêî â êàçàðìå ðÿäîì ñ êîéêàìè [èñêëþ÷åíèå: ãëàâà VI óñòàâà àðìèè];\n5.4 Âûõîäÿ èç êàçàðìû, âîåííîñëóæàùèé îáÿçàí íàäåòü êàñêó ñâîåãî âçâîäà èëè ïîäðàçäåëåíèÿ â ñîîòâåòñòâèè ñ ïðàâèëàìè íèæå:\nÑòàðøèå îôèöåðû/îôèöåðû øòàáà - Ôóðàæêà ¹21\nÓÑÁ - Áåðåò ¹32\nÑÎÁÐ - Áåðåò ¹30, ¹11.\nÑÂÑÑ - Êàñêà ¹29, 22\nÂÑÁ - Êàñêà ¹5, 3\nÀÑÂ - Êàñêà ¹19, 20\nÊîìàíäèðû îòðÿäîâ è âçâîäîâ - Áåðåò ¹12\nÇàìåñòèòåëåé îòðÿäîâ è âçâîäîâ- Áåðåò ¹8\nÒðåíåðû âçâîäîâ - Áåðåò ¹10\nÏðèìå÷àíèå: ÓÑÁ íîñÿò ñâîè áåðåòû íåçàâèñèìî îò äîëæíîñòè.\n5.5 Ïðîñíóâøèñü äîìà èëè íà âîêçàëå, áîåö îáÿçàí â òå÷åíèè 10-òè ìèíóò ÿâèòüñÿ íà òåððèòîðèþ ÷àñòè.\nÄàííûå 10 ìèíóò ðàçðåøàåòñÿ ïîòðàòèòü èñêëþ÷èòåëüíî íà äîðîãó,\níèêàêèõ ðàáîò òàêñèñòîì, âîäèòåëåì àâòîáóñà è ò.ä.;\n5.6 Åñëè íà ñëóæáå íåò êîìàíäèðà âçâîäà èëè åãî çàìåñòèòåëÿ,\nêîìàíäîâàíèå ýòèì âçâîäîì ïåðåäàåòñÿ ñòàðøåìó áîéöó âçâîäà íàõîäÿùåìóñÿ â ÷àñòè;\n5.7 Âûâîçèòü áîéöîâ â ãîðîä ðàçðåøåíî òîëüêî: ñòàðøèì, ÓÑÁ, ÂÑÁ, à òàêæå êîì. ñîñòàâó âçâîäîâ\n[äëÿ âûïîëíåíèÿ ñâîèõ îáÿçàííîñòåé];")
  imgui.Text(u8"Ãëàâà VI. Ïðàâèëà ñíà.\n6.1 Ëþáîé áîåö Army Las Venturas èìååò ïðàâî ñïàòü â êàçàðìå ðÿäîì ñ êîéêàìè;\n6.2 Áîéöû ÂÑÁ èìåþò ïðàâî ñïàòü â àíãàðàõ, íå ìåøàÿ ïðîåçäó ôóðàì;\n6.3 Áîéöû îòðÿäîâ ÓÑÁ, ÑÎÁÐ èìåþò ïðàâî ñïàòü â âíóòðè øòàáà íåîãðàíè÷åííîå âðåìÿ;\n6.4 Ñòàðøèå îôèöåðû èìåþò ïðàâî ñïàòü â ëþáîì ìåñòå;\n6.5 Áîéöû ÓÑÁ èìåþò ïðàâî ñïàòü íà ïëàöó, íî íå áîëåå ÷åì 2 ìèíóòû [120 ñåêóíä].")
  imgui.Text(u8"Ãëàâà VII. Óâîëüíèòåëüíîå âðåìÿ.\n7.1 Óâîëüíèòåëüíîå âðåìÿ â áóäíèå äíè íà÷èíàåòñÿ â 22:00 è çàêàí÷èâàåòñÿ â 8:00,\nâ ïÿòíèöó è âûõîäíûå äíè íà÷èíàåòñÿ â 21:00 è çàêàí÷èâàåòñÿ â 9:00;\n7.2 Áîéöû, èìåþùèå çâàíèå Ìë.Ñåðæàíò è âûøå, èìåþò ïðàâî ñíÿòü ôîðìó è îòïðàâèòüñÿ â óâîëüíèòåëüíîå âðåìÿ.\nÐÿäîâûå è Åôðåéòîðû òàê æå ïðîäîëæàþò íåñòè ñëóæáó â ÷àñòè;\n7.3 Åñëè ñêëàäû ãîñóäàðñòâåííûõ îðãàíèçàöèé øòàòà ñîñòàâëÿþò ìåíåå 100.000 åäèíèö,\nòî óâîëüíèòåëüíîå âðåìÿ ÂÑÁ îòìåíÿåòñÿ äî òîãî ìîìåíòà, ïîêà ñêëàäû íå áóäóò çàïîëíåíû;\n7.4 Êîì.ñîñòàâ âçâîäîâ, ñòàðøèå îôèöåðû è áîéöû àðìèè, ìîãóò áûòü âûçâàíû â ÷àñòü ñ óâîëüíèòåëüíîãî âðåìåíè;\n7.5 Îòëîæèòü óâîëüíèòåëüíîå âðåìÿ èìåþò ïðàâî òîëüêî ñòàðøèå îôèöåðû.")
  imgui.Text(u8"Ãëàâà VIII. Ñóáîðäèíàöèÿ/ïðàâèëà èñïîëüçîâàíèå ðàöèè.\n8.1 Âîåííîñëóæàùèå îáÿçàíû ñîáëþäàòü ñóáîðäèíàöèþ â îáùåíèè ìåæäó ñîáîé;\n8.2 Ïðè ñîãëàñèè áîåö îáÿçàí îòâå÷àòü: `Òàê òî÷íî, òîâàðèù «Ôàìèëèÿ, Çâàíèå»!`,\nïðè íåñîãëàñèè: `Íèêàê íåò, Òîâàðèù «Ôàìèëèÿ, Çâàíèå»!`,\nåñëè áîåö ïîëó÷èë ïðèêàç: `Åñòü, Òîâàðèù «Ôàìèëèÿ, Çâàíèå»!`;\n8.3 Çäîðîâàÿñü ñ ñîñëóæèâöàìè, áîåö îáÿçàí ñêàçàòü: `Çäðàâèÿ æåëàþ`\n[`ñàëàì`, `çäîðîâà` è ò.ï çàïðåùåíû];\n8.4 Âîåííîñëóæàùèé îáÿçàí îòâåòèòü: ` ÿ, òîâàðèù `çâàíèå` ` êîãäà åãî íàçûâàåò ñòàðøèé ïî çâàíèþ;\n8.5 Åñëè âîåííîñëóæàùåãî âûçâàëè, òî ïî ïðèáûòèþ îí îáÿçàí äîëîæèòü\n[Ïðèìåð: `Ãåíåðàë Êàñåòè, ðÿäîâîé Èâàíîâ ïî âàøåìó ïðèêàçàíèþ ïðèáûë`];\n8.6 Ñïðàøèâàÿ ÷òî-ëèáî, âîåííîñëóæàùèé äîëæåí ñêàçàòü: ` Òîâàðèù `çâàíèå`, ðàçðåøèòå îáðàòèòüñÿ` `;\n8.7 Ïðè ïîîùðåíèè âîåííîñëóæàùåãî îí äîëæåí îòâåòèòü: `Ñëóæó Àðìèè Las Venturas!`;\n8.8 Âîåííîñëóæàùèé îáÿçàí âåæëèâî îáùàòüñÿ ñ ëþáûì æèòåëåì øòàòà;\n8.9 Âîåííîñëóæàùèé îáÿçàí îáðàùàòüñÿ íà `Âû` ê ñâîèì ñîñëóæèâöàì\n[èñêëþ÷åíèå: åñëè äîëæíîñòü è çâàíèå âûøå, òî ðàçðåøàåòñÿ îáðàùàòüñÿ íà `Òû`].\n8.10 Ïðè îáùåíèè â ðàöèþ äîëæíû ñîáëþäàòüñÿ âñå âûøåïåðå÷èñëåííûå ïðàâèëà;\n8.11 Ïðè îáùåíèè ïî ðàöèè çàïðåùåíî:\n8.11.1 Âåñòè ðàçãîâîðû íå ñâÿçàííûå ñ íåñåíèåì ñëóæáû [Îôôòîïèòü, ôëóäèòü, ìåòàãåéìèíã];\n8.11.2 Óïîòðåáëÿòü íåöåíçóðíûå âûðàæåíèÿ [â OOC è IC ÷àò];\n8.11.3 Ãîâîðèòü áåç îáîçíà÷åíèÿ âàøåãî âçâîäà [ïðèìåð: /r [ÂÀØ ÂÇÂÎÄ]:].\n8.12 Âîåííîñëóæàùèé îáÿçàí îáðàùàòüñÿ ê ñòàðøèì ñòðîãî ïî çâàíèþ\n[Ïðèìåð: `Òîâàðèù Ãåíåðàë Êàñåòè, ðàçðåøèòå îáðàòèòüñÿ?`];\n8.13 Âî âðåìÿ ðàäèîìîë÷àíèå [×Ñ ðàöèè] çàïðåùåíî âñåì èñïîëüçîâàòü ðàöèþ äî ñíÿòèå ×Ñ\n[èñêëþ÷åíèå: ðàöèåé ìîãóò ïîëüçîâàòüñÿ ñòàðøèå îôèöåðû, ÓÑÁ].\n")
  imgui.Text(u8"Ãëàâà IX. Ïðîïóñêíîé ðåæèì.\n9.1 Íà òåððèòîðèþ ÷àñòè Las-Venturas Army ðàçðåøåíî ïðîïóñêàòü:\nÑåíàòîðîâ;\n- Ìýðà è åãî çàìåñòèòåëåé\n[èñêëþ÷åíèå: ê ïóíêòó 9.1 - çàìåñòèòåëè Ìýðà ïðè âúåçäå íà îõðàíÿåìóþ òåððèòîðèþ îáÿçàíû ïðåäîñòàâèòü ñëåäóþùèå äîêóìåíòû]:\nÄîêóìåíò ïîäòâåðæäàþùèé ëè÷íîñòü.\nÓäîñòîâåðåíèå ïîäòâåðæäàþùåå êóðèðóþùóþ îòðàñëü.\nÄèðåêòîðà ÔÁÐ è åãî çàìåñòèòåëåé;\nØåðèôîâ SAPD è èõ çàìåñòèòåëåé;\n- Ãåíåðàëà San-Fierro Army.\nÎñòàëüíûì ãîñóäàðñòâåííûì ñëóæàùèì íà òåððèòîðèè àðìèè ðàçðåøåíî íàõîäèòüñÿ\nïîñëå ïðåäóïðåæäåíèÿ ïî âîëíå äåïàðòàìåíòà è ïîëó÷åíèÿ îäîáðåíèÿ îò\nñòàðøèõ îôèöåðîâ, ëèáî ñòàðøåãî â ÷àñòè, íà äàííûé ìîìåíò;\n9.2 Áîéöû íà ïîñòó îáÿçàíû äîêëàäûâàòü â ðàöèþ î ïðèáûòèè âñåõ ëèö â ãðàæäàíñêîé îäåæäå íà ÊÏÏ è ÑÊÏÏ;\n9.3 Áîéöû íà ïîñòó èìåþò ïðàâî ïðîâåðÿòü ïàñïîðòà ó âñåõ âúåçæàþùèõ è âûåçæàþùèõ âîåííîñëóæàùèõ,\näîëæíîñòíûõ è ãðàæäàíñêèõ ëèö\n[èñêëþ÷åíèå: ñåíàòîðû øòàòà, ñòàðøèå îôèöåðû, êîëîííà ôóð ñ áîåïðèïàñàìè];\n9.4 Çàïðåùåíî âûïóñêàòü ñ òåððèòîðèè ÷àñòè ñîëäàò, êîòîðûå íå èìåþò ðàçðåøåíèÿ íà âûåçä îò ñòàðøèõ îôèöåðîâ\n[èñêëþ÷åíèå: ïóíêò 9.5 óñòàâà àðìèè];\n9.5 Äëÿ èñïîëíåíèÿ îñíîâíûõ çàäà÷ ïîäðàçäåëåíèÿ,\náîéöû ÑÎÁÐ, ÓÑÁ, ÑÂÑÑ, ÂÑÁ, ÀÑÂ èìåþò ïðàâî ïîêèíóòü ÷àñòü áåç ðàçðåøåíèÿ ñòàðøèõ îôèöåðîâ;\n9.6 Âúåçä íà òåððèòîðèþ âîåííîé ÷àñòè íà ãðàæäàíñêîì òðàíñïîðòíîì ñðåäñòâå ñòðîãî çàïðåùåí\n[èñêëþ÷åíèå: ñåíàòîðû øòàòà, ïàðêîâêà àâòîìîáèëÿ íà òåððèòîðèè ÷àñòè,\nñîãëàñíî ãëàâå XII óñòàâà àðìèè];\n9.6.1 Ëèöàì, óêàçàííûì â ïóíêòå 9.1 óñòàâà àðìèè, äîïóñêàåòñÿ âúåçä íà òåððèòîðèþ âîåííîé ÷àñòè\níà ñëóæåáíîì òðàíñïîðòå èñêëþ÷èòåëüíî â ñëóæåáíûõ öåëÿõ;\n9.7 Âñå âîåííîñëóæàùèå îáÿçàíû ïîêàçûâàòü ïàñïîðò íà ÊÏÏ è ÑÊÏÏ ïî ïðèáûòèè â ÷àñòü â ãðàæäàíñêîé ôîðìå\n[èñêëþ÷åíèå: ñòàðøèå îôèöåðû];")
  imgui.Text(u8"9.8 Âîçäóøíîå ïðîñòðàíñòâî Las-Venturas Army ÿâëÿåòñÿ çàêðûòûì\n[èñêëþ÷åíèå: ãðóçîâûå âåðòîëåòû SFa ïðè ïîñòàâêå áîåïðèïàñîâ, à òàêæå ëèöà, óêàçàííûå â ïóíêòå 9.1 óñòàâà àðìèè].\n9.9 Ïîêèíóòü ÷àñòè âîçäóøíûì ïóò¸ì ðàçðåøàåòñÿ òîëüêî ñ ðàçðåøåíèÿ äèñïåò÷åðà (ÓÑÁ, ñòàðøèõ îôèöåðîâ)\n[èñêëþ÷åíèå: ÓÑÁ, ïîðò ×Ñ, èãíîðèðîâàíèå çàïðîñà].")
  imgui.Text(u8"Ãëàâà X. Âîåííûé òðàíñïîðò.\n10.1 Õàììåðû, ñòîÿùèå â ÃÂÒ, ðàçðåøåíî áðàòü áîéöàì: ÓÑÁ, ÑÎÁÐ, ÑÂÑÑ, ÂÑÁ, ÀÑÂ,\nà òàêæå äëÿ ñîïðîâîæäåíèÿ ôóð è ïàòðóëèðîâàíèÿ ÷àñòè;\n10.2 Îôèöåðñêèå äæèïû â ÃÂÒ ðàçðåøåíî áðàòü áîéöàì: ÓÑÁ, ÑÎÁÐ, ÀÑÂ,\nÊîì.ñîñòàâó âçâîäîâ è îòðÿäîâ [Êîìàíäèð, çàìåñòèòåëè, òðåíåðà];\n10.3 Îôèöåðñêèé äæèï ó êàçàðìû ðàçðåøåíî áðàòü: ÀÑÂ, äëÿ ïðîâåäåíèÿ ëåêöèé;\n10.4 Õàììåðà, ñòîÿùèå ó êàçàðìû, ðàçðåøåíî áðàòü áîéöàì: ÓÑÁ, ÑÎÁÐ;\n10.5 Õàììåðà, ñòîÿùèå â Øòàáå ÑÎÁÐ ðàçðåøåíî áðàòü áîéöàì: ÓÑÁ, ÑÎÁÐ;\n10.6 Âåðòîëåòû çà êàçàðìîé ðàçðåøåíî áðàòü áîéöàì: ÑÎÁÐ îò 3-õ ÷åëîâåê; \n ñ îïåðàòèâíèêà; ÑÂÑÑ îò 3-õ ÷åëîâåê, à òàêæå ñ ðàçðåøåíèÿ ñòàðøèõ îôèöåðîâ;\n10.7 Ãðóçîâèêè ñíàáæåíèÿ ðàçðåøåíî áðàòü áîéöàì: ÀÑÂ, ÓÑÁ, ÑÎÁÐ, ÂÑÁ\n[èñêëþ÷åíèå: åôðåéòîð è âûøå äëÿ ïîìîùè ÂÑÁ ñ ðàçðåøåíèÿ îôèöåðîâ øòàáà];\n10.8 Àâòîáóñû ðàçðåøåíî áðàòü ïî ïðèêàçó ñòàðøèõ îôèöåðîâ äëÿ ïðîâåäåíèÿ ìåðîïðèÿòèé âíóòðè àðìèè, ïðèçûâîâ;\n10.9 Ñàìîë¸ò Shamal èìåþò ïðàâî áðàòü: ñòàðøèå îôèöåðû, òàêæå ëþáîé áîåö ñ ðàçðåøåíèÿ ñòàðøèõ îôèöåðîâ;\n10.10 Ñòàðøèå îôèöåðû èìåþò ïðàâî áðàòü ëþáóþ òåõíèêó àðìèè;")
  imgui.Text(u8"Ãëàâà XI. Ïîëíîìî÷èÿ âçâîäîâ/äîëæíîñòåé.\n11.1 Âçâîä ÂÂÎ ïîä÷èíÿåòñÿ âñåì âûøåñòîÿùèì âçâîäàì, à èìåííî: ÀÑÂ, ñïåö. îòðÿäàì è ñòàðøèì îôèöåðàì;\n11.2 Âçâîäà ÑÂÑÑ, ÂÂÎ è ÂÑÁ íàõîäÿòñÿ íà îäíîì óðîâíå èåðàðõèè;\n11.3 Îòðÿä ñïåöèàëüíîãî íàçíà÷åíèÿ ÑÎÁÐ ïîä÷èíÿåòñÿ: ãåí. øòàáó, ÓÑÁ;\n11.4 ÓÑÁ ïîä÷èíÿåòñÿ: ãåí. øòàáó.\nÍà÷àëüíèê ÓÑÁ ïîä÷èíÿåòñÿ îò ïîëêîâíèêà\nÇàì.Íà÷àëüíèêà ÓÑÁ ïî÷èíÿåòñÿ îò ïîäïîëêîâíèêà\nîò Ñòàæ¸ðà è äî Ñò.Îïåðàòèâíèêà ïîä÷èíÿþòñÿ îò ìàéîðà.\n11.5 Ëþáîé áîåö Àðìèè Las Venturas, äîãîâîðèâøèñü ñ ÀÑÂ èëè ñòàðøèìè îôèöåðàìè,\nìîãóò îðãàíèçîâûâàòü òðåíèðîâêè è ñòðîèòü àðìèþ äëÿ ýòèõ òðåíèðîâîê;\n11.6 Óïîëíîìî÷åííûå âûäàòü äèñöèïëèíàðíîå âçûñêàíèå,\nâî âðåìÿ íàêàçàíèÿ, îáÿçàíû ðóêîâîäñòâîâàòüñÿ òàáëèöåé íàêàçàíèé è äèñöèïëèíàðíûõ âçûñêàíèé;")
  imgui.Text(u8"Ãëàâà XII. Ïðàâèëà ïàðêîâêè.\n12.1 Çà íàðóøåíèå ïðàâèë ïàðêîâêè, áîåö ìîæåò ïîëó÷èòü ñàíêöèè â âèäå íàðÿäà, çà ïîâòîðíûå íàðóøåíèÿ âûãîâîð;\n12.2 Ðÿäîâûì è åôðåéòîðàì ñòðîãî çàïðåùåíî èìåòü ËÒÑ â ÷àñòè è ïðèëåãàþùåé ê íåé òåððèòîðèè;\n12.3 Áîéöû, èìåþùèå çâàíèå Ìë.Ñåðæàíò è âûøå îáÿçàíû ïàðêîâàòüñÿ íà îáùåé ïàðêîâêå âíå ÷àñòè;\n12.4 Áîéöû, ñîñòîÿùèå â ñïåö.îòðÿäå ÑÎÁÐ èìåþò ïðàâî ïàðêîâàòü ËÒÑ ñåðîãî öâåòà,\nóêàçàííûå â ïóíêòå 3.29 äëÿ ÑÎÁÐ, íà ïàðêîâêå ñïðàâà îò øòàáà;\n12.5 Áîéöû, ñîñòîÿùèå â ñïåö.îòðÿäå ÓÑÁ, èìåþò ïðàâî ïàðêîâàòü ËÒÑ ÷¸ðíîãî öâåòà,\nóêàçàííûå â ïóíêòå 3.29 äëÿ ÓÑÁ, â áóíêåðå;\n12.6 Áîéöû, èìåþùèå çâàíèå îò Ìë.Ëåéòåíàíò äî Êàïèòàí èìåþò ïðàâî ïàðêîâàòüñÿ çà Àíãàðîì ¹2;\n12.7 Îôèöåðû øòàáà èìåþò ïðàâî ïàðêîâàòüñÿ òîëüêî â áóíêåðå;\n12.8 Áîéöû èìåþùèå ñâîé ëè÷íûé âåðòîë¸ò îáÿçàíû ïàðêîâàòü åãî\níà îáùåé ïàðêîâêå âíå ÷àñòè èëè ðÿäîì ñ íåé. Âíå çàâèñèìîñòè îò çâàíèÿ\n[èñêëþ÷åíèå: ÓÑÁ ìîæíî ïðèïàðêîâàòü âåðòîë¸ò íà õîëìèêå íå äàëåêî îò ñâîåé ïàðêîâêè].\n12.9 Áîéöû, ñîñòîÿùèå â ÀÑÂ, èìåþò ïðàâî ïàðêîâàòü ËÒÑ áåëîãî öâåòà,\nóêàçàííûå â ïóíêòå 3.29, íà ïàðêîâêå ñëåâà îò êàçàðìû, ó áàíêîìàòà.;")
  imgui.Text(u8"Ãëàâà XIII. Äðåññ-êîä.\n13.1 Âîåííîñëóæàùèé îáÿçàí íîñèòü ôîðìó óñòàíîâëåííîé íèæå ïðàâèëàìè:\n13.1.1 Ïîëåâóþ ôîðìó ¹287 - ðàçðåøåíî íîñèòü âñåì âîåííîñëóæàùèì àðìèè.\n13.1.2 ×åðíûé êîñòþì ¹255 - ðàçðåøåíî íîñèòü çàìåñòèòåëÿì âçâîäîâ.\n13.1.3 Ñèíèé êîñòþì ¹61 - ðàçðåøåíî íîñèòü èñêëþ÷èòåëüíî ñòàðøèì îôèöåðàì.\n13.1.4 Ñïåöèàëüíàÿ ôîðìà ¹179 - ðàçðåøåíî íîñèòü òðåíåðàì âçâîäîâ è âîåííîñëóæàùèì ïîëó÷èâøèå êðàïîâûé áåðåò.\n13.1.5 Ôîðìà ñ êàìóôëÿæíûìè øòàíàìè ¹73 - ðàçðåøåíî íîñèòü áîéöàì ÑÂÑÑ è ÂÑÁ, ÀÑÂ;\n13.1.6 Ôîðìà ¹191 - ïðåäíàçíà÷åíà äëÿ æåíñêîãî ïîëà, íåçàâèñèìî îò äîëæíîñòè è çâàíèÿ.\n13.2 Ïåðåîäåâøèñü â âîåííóþ ôîðìó, âîåííîñëóæàùèé îáÿçàí ñíÿòü çàïðåùåííûå åìó àêñåññóàðû.\nÑïèñîê àêñåññóàðîâ ìîæíî ïîñìîòðåòü íà ôîðóìå.\n13.3 Àêñåññóàðû, íå óêàçàííûå â ïóíêòå 13.2 óñòàâà àðìèè ÿâëÿþòñÿ çàïðåùåííûìè äëÿ âñåõ âîåííîñëóæàùèõ.")
  imgui.Text(u8"Ãëàâà XIV. Ñèñòåìà âûãîâîðîâ.\n14.1 Âûãîâîðû äëÿ îáû÷íûõ áîéöîâ.\n14.1.1 Âûãîâîðû äåëÿòñÿ íà âûãîâîð ñ îòðàáîòêîé è áåç îòðàáîòêè.\n14.1.2 Åñëè áîåö ïîëó÷àåò âûãîâîð ñ îòðàáîòêîé\nîí îáÿçàí ïîïûòàòüñÿ åãî îòðàáîòàòü.\n14.1.3 Åñëè ó áîéöà áûë 1 àêòèâíûé âûãîâîð è îí ïîëó÷èë åùå îäèí - áîåö\nïîíèæàåòñÿ íà îäíó ñòóïåíü çà 2 àêòèâíûõ âûãîâîðà.\n14.1.4 Åñëè ó áîéöà áûëè 2 àêòèâíûõ âûãîâîðà è îí ïîëó÷èë åùå îäèí - áîåö\nóâîëüíÿåòñÿ èç àðìèè çà 3 àêòèâíûõ âûãîâîðà.\n14.2 Âûãîâîðû äëÿ ñòàðøèõ îôèöåðîâ\n14.2.1 Âûãîâîð ñòàðøåìó îôèöåðó â ïðàâå âûäàòü òîëüêî Íà÷.Ãåí.Øòàáà è Ãåíåðàë.\nÈñêëþ÷åíèå: àäìèíèñòðàöèÿ, FBI.\n14.2.2 Âûãîâîðû ó ñòàðøèõ îôèöåðîâ íå èìåþò ñðîêîâ, âûãîâîð ìîæåò\nñíÿòü òîëüêî Ãåíåðàë àðìèè ïî èòîãàì ðàáîòû ñòàðøåãî îôèöåðà çà íåäåëþ.\n14.2.3 Çà íåçíà÷èòåëüíûå íàðóøåíèÿ ñòàðøåìó îôèöåðó âûäàåòñÿ óñòíîå ïðåäóïðåæäåíèå.\n14.2.4 Åñëè ñòàðøèé îôèöåð ïîëó÷àåò 2 óñòíûõ ïðåäóïðåæäåíèÿ åìó àâòîìàòè÷åñêè âûäàåòñÿ âûãîâîð.\n14.2.5 Åñëè ó ñòàðøåãî îôèöåðà íàáèðàåòñÿ 2 àêòèâíûõ âûãîâîðà îí ïîêèäàåò ñâîé ïîñò è ïîíèæàåòñÿ äî Êàïèòàíà.\n14.2.6 Ñîòðóäíèê/áîåö èìåþùèé àêòèâíûé âûãîâîð, â ïðàâå âçÿòü íåàêòèâ/îòïóñê,\níî ñðîê âûãîâîðà ñäâèãàåòñÿ äî îêîí÷àíèÿ ñðîêà íåàêòèâà/îòïóñêà.\n")
  imgui.Text(u8"                                                                                              Ôåäåðàëüíîå ïîñòàíîâëåíèå")
  imgui.Text(u8"\nÂñòóïèòåëüíàÿ ÷àñòü.\n0.1. Ôåäåðàëüíîå Ïîñòàíîâëåíèå  ýòî íîðìàòèâíî-ïðàâîâîé àêò, êîòîðûé áûë ïðèçâàí âíåñòè\n÷¸òêèå ðàìêè â ðàáîòó ãîñóäàðñòâåííûõ îðãàíèçàöèé.\nÔåäåðàëüíîå ïîñòàíîâëåíèå  ýòî íîðìàòèâíî-ïðàâîâîé àêò,\nêîòîðûé îáëàäàåò âûñøåé þðèäè÷åñêîé ñèëîé íàðàâíå ñ\nÊîíñòèòóöèåé øòàòà è ïðåâîñõîäèò ïî çíà÷èìîñòè óñòàâû ïîëèöåéñêèõ äåïàðòàìåíòîâ è àðìèé.\n0.2. Ôåäåðàëüíîå Ïîñòàíîâëåíèå èçäà¸òñÿ Ôåäåðàëüíûì Áþðî Ðàññëåäîâàíèé äëÿ Ïîëèöåéñêèõ è Àðìèé.\n0.3. Ôåäåðàëüíîå Ïîñòàíîâëåíèå ìîæåò áûòü èçìåíåíî Äèðåêòîðîì ÔÁÐ\n[ ïðè ó÷àñòèè ñëåäÿùåãî àäìèíèñòðàòîðà ]\nâ ëþáîå âðåìÿ äíÿ è íî÷è, åãî âñòóïëåíèå â ñèëó ïðîèñõîäèò ÷åðåç 48 ÷àñîâ ïîñëå ïóáëèêàöèè.\n0.4. Ôåäåðàëüíîå Ïîñòàíîâëåíèå îáÿçàíî âûïîëíÿòüñÿ âñåìè ñîòðóäíèêàìè âûøåóïîìÿíóòûõ îðãàíèçàöèé.\n0.5. Íåçíàíèå Ôåäåðàëüíîãî Ïîñòàíîâëåíèÿ íå îñâîáîæäàåò îáâèíÿåìîãî îò îòâåòñòâåííîñòè.")
  imgui.Text(u8"Ãëàâà ¹1.\nÏðåñòóïëåíèÿ ïðîòèâ îáùåñòâåííîñòè.\n1.1. Çàïðåùàåòñÿ íåñàíêöèîíèðîâàííîå ïðèìåíåíèå îãíåñòðåëüíîãî îðóæèÿ ïðîòèâ ëþáîãî\nãðàæäàíñêîãî ëèöà / ñîòðóäíèêà ãîñóäàðñòâåííûõ îðãàíèçàöèé  ïîíèæåíèå / óâîëüíåíèå.\nÏðèìå÷àíèå: çà ñàíêöèîíèðîâàííîå ïðèìåíåíèå ïîäðàçóìåâàåòñÿ èñïîëüçîâàíèå ïðè ñàìîîáîðîíå,\níåâûïîëíåíèè çàêîííûõ òðåáîâàíèé ïîëèöèè. Äàííîå ïðèìå÷àíèå íå ðàñïðîñòðàíÿåòñÿ íà çåëåíûå çîíû.\n1.2. Çàïðåùàåòñÿ ëþáîå óíèæåíèå ÷åñòè è äîñòîèíñòâà ãðàæäàí íåçàâèñèìî\nîò åãî ñîöèàëüíîãî èëè ïðàâîâîãî ñòàòóñà  óâîëüíåíèå.\n1.3. Çàïðåùàåòñÿ ïðèìåíåíèå íàñèëèÿ â îòíîøåíèè êàê ãðàæäàí,\nòàê è çàêëþ÷åííûõ ïîä ñòðàæó ëèö  ïîíèæåíèå / óâîëüíåíèå.\nÃëàâà ¹2.\nÏîñòàíîâëåíèå â îòíîøåíèè ñîòðóäíèêîâ Ôåäåðàëüíîãî Áþðî Ðàññëåäîâàíèé è Ìýðèè.\n2.1. Çàïðåùàåòñÿ ïðîíèêàòü íà òåððèòîðèþ FBI áåç ïîëó÷åíèÿ îôèöèàëüíîãî ïðîïóñêà\nîò ëþáîãî èç àãåíòîâ ÔÁÐ âûøå Ìë.Àãåíòà  âûãîâîð / ïîíèæåíèå.\nÏðèìå÷àíèå: Ãóáåðíàòîðó, Ãåíåðàëàì àðìèé, Øåðèôàì ðàçðåøåíèå íå òðåáóåòñÿ.\n2.2. Çàïðåùàåòñÿ âûäàâàòü ñåáÿ çà ëþáîãî ãîñóäàðñòâåííîãî ñîòðóäíèêà  ïîíèæåíèå / óâîëüíåíèå.\nÈñêëþ÷åíèå: àãåíòû ÔÁÐ âî âðåìÿ âåäåíèÿ ñëåäñòâåííûõ äåéñòâèé ïîä ïðèêðûòèåì.\n2.3. Çàïðåùàåòñÿ áðàòü ðóêîâîäñòâî îïåðàöèÿìè\n[ òåðàêòû / ïîõèùåíèÿ / èíàÿ ðàáîòà ïîä ðóêîâîäñòâîì ÔÁÐ ]\náåç ïðèêàçà ÔÁÐ  óâîëüíåíèå.\n2.4. Çàïðåùàåòñÿ íåïîä÷èíåíèå àãåíòó ÔÁÐ â ðàìêàõ åãî çàêîííûõ òðåáîâàíèé  ïîíèæåíèå / óâîëüíåíèå.\nÈñêëþ÷åíèå: àãåíòû ÔÁÐ âî âðåìÿ âåäåíèÿ ñëåäñòâåííûõ äåéñòâèé ïîä ïðèêðûòèåì.\n2.5. Çàïðåùàåòñÿ óãðîæàòü / øàíòàæèðîâàòü àãåíòà ÔÁÐ  óâîëüíåíèå.\n2.6. Çàïðåùàåòñÿ îñïàðèâàòü ïîíèæåíèå / óâîëüíåíèå, âûäàííîå àãåíòîì ÔÁÐ / Ãóáåðíàòîðîì ãäå-ëèáî,\nêðîìå êàê â ñïåöèàëüíîì ðàçäåëå æàëîá  ïîíèæåíèå / óâîëüíåíèå.\n2.7. Çàïðåùàåòñÿ ðàñêðûâàòü ëè÷íîñòü àãåíòà ÔÁÐ, åñëè òîò íàõîäèòñÿ ïîä ïðèêðûòèåì  óâîëüíåíèå.\nÏðèìå÷àíèå: åñëè àãåíò ÔÁÐ íàõîäèòñÿ âî âíåäðåíèè ÷åðåç êîìàíäó /spy, à íå ÷åðåç ìàñêèðîâêó,\nòî äàííûé ïóíêò íå îòìåíÿåò íàêàçàíèÿ çà åãî íàðóøåíèå.\nÍå âàæíî â êàêîì ÷àòå áóäåò íàïèñàíà èíôîðìàöèÿ, êîòîðàÿ ïðèâåëà ê ðàñêðûòèþ àãåíòà.\n2.8. Çàïðåùàåòñÿ âíîñèòü ïîìåõè â ðàáîòó àòòåñòàöèîííîé êîìèññèè îò âûñøèõ îðãàíîâ âëàñòè,\nïðîâîäÿùèõ ëþáîãî ðîäà ïðîâåðêè â ãîñóäàðñòâåííûõ ñòðóêòóðàõ  âûãîâîð / ïîíèæåíèå.\nÏðèìå÷àíèå: çàïðåùåíî ïîäñêàçûâàòü ñîòðóäíèêàì ëþáûìè ñïîñîáàìè, áóäü-òî IC, áóäü-òî OOC. [ /r, /rb, /ticket ]\n2.9. Çàïðåùàåòñÿ èçáåãàòü ïðîâåðêè îò ÔÁÐ  ïîíèæåíèå / óâîëüíåíèå.\nÏðèìå÷àíèå: àãåíò èìååò ïðàâî âàñ âûçâàòü â áþðî è ïðîâåñòè ïðîâåðêó.\nÏðè îòêàçå ïîñëåäóåò ñîîòâåòñòâóþùåå íàêàçàíèå ñîãëàñíî ïóíêòó.\n2.10. Çàïðåùåíî ïðèìåíÿòü ñàíêöèè ïî îòíîøåíèþ ê àãåíòàì ÔÁÐ ïðè èñïîëíåíèè\n[ øòðàôû, îáúÿâëåíèå â ðîçûñê ],\nà òàêæå âíîñèòü ïîìåõó â ðàáîòó ñîòðóäíèêàì ôåäåðàëüíîãî áþðî  âûãîâîð / ïîíèæåíèå.\nÏðèìå÷àíèå: àãåíò â ìàñêèðîâêå íå ÿâëÿåòñÿ àãåíòîì ïðè èñïîëíåíèè.")
  imgui.Text(u8"Ãëàâà ¹3.\nÏîñòàíîâëåíèå â îòíîøåíèè Ïîëèöåéñêèõ Äåïàðòàìåíòîâ è Àðìèé.\n3.1. Çàïðåùàþòñÿ ëþáûå ïðîÿâëåíèÿ íåàäåêâàòíîãî ïîâåäåíèÿ  âûãîâîð / ïîíèæåíèå / óâîëüíåíèå.\nÏðèìå÷àíèå: ïîä íåàäåêâàòíûì ïîâåäåíèåì ïîäðàçóìåâàåòñÿ ïðûæêè ãîñ. ñëóæàùèì ïî àâòîìîáèëÿì,\níàìåðåííîå âûòàëêèâàíèå àâòî íà äîðîãó è èíûå íàðóøåíèÿ çàêîíîâ øòàòà,\nêîòîðûå ïðèâîäÿò â ñîâîêóïíîñòü íàðóøåíèé íåñêîëüêèõ ïóíêòîâ Ôåäåðàëüíîãî Ïîñòàíîâëåíèÿ\n3.2. Çàïðåùàåòñÿ íàðóøàòü ïðàâèëà ñòðîÿ  âûãîâîð.\nÏðèìå÷àíèå: òàêæå ïîä ýòèì ïîäðàçóìåâàåòñÿ áåñïðè÷èííîå è áåñïî÷âåííîå èñïîëüçîâàíèå êîìàíäû /time,\nàíèìàöèè è ïðî÷èå òåëîäâèæåíèÿ.\n3.3. Çàïðåùàåòñÿ ïðîäàæà ëþáîãî ãîñóäàðñòâåííîãî èìóùåñòâà\n[ êëþ÷è îò êàìåð/ôîðìà/ôóðû ñ áîåïðèïàñàìè ]  óâîëüíåíèå + ×Ñ ôðàêöèè.\n3.4. Çàïðåùàåòñÿ äàâàòü çàâåäîìî ëîæíóþ èíôîðìàöèþ ãîñóäàðñòâåííîìó ñîòðóäíèêó  âûãîâîð / ïîíèæåíèå / óâîëüíåíèå.\nÏðèìå÷àíèå: ïîä äà÷åé ëîæíûõ ïîêàçàíèé ïîäðàçóìåâàåòñÿ ëþáàÿ âûäóìàííàÿ/ñîêðûòàÿ èíôîðìàöèÿ,\nêîòîðóþ çàïðàøèâàåò ãîñóäàðñòâåííûé ñîòðóäíèê.\n3.5. Çàïðåùàåòñÿ íåîáîñíîâàííî òðåáîâàòü äîêóìåíòû,\nà òàê æå ïðîâîäèòü îáûñê ãðàæäàíñêèõ ëèö  âûãîâîð / ïîíèæåíèå.\n3.6. Çàïðåùàåòñÿ ãîñóäàðñòâåííûì ñîòðóäíèêàì âõîäèòü â ñãîâîðû ñ ìàôèåé/áàíäàìè  óâîëüíåíèå.\nÈñêëþ÷åíèå: ñïåö. îïåðàöèè [ îáÿçàòåëüíûé êîíòðîëü ñòàðøåãî îôèöåðà ].\n3.7. Çàïðåùàåòñÿ áåç ðàçðåøåíèÿ / ïðîïóñêà [ ñàìîâîëüíî ] ïîêèäàòü ÷àñòü / ñâîé\nãîðîä  âûãîâîð / ïîíèæåíèå / óâîëüíåíèå.\nÏðèìå÷àíèå: íàõîæäåíèå â íåéòðàëüíîé çîíå íå ÿâëÿåòñÿ íàðóøåíèåì äàííîãî ïóíêòà ôåäåðàëüíîãî ïîñòàíîâëåíèÿ.\n3.8. Çàïðåùàåòñÿ íîñèòü ôîðìó íå ñîîòâåòñòâóþùóþ çàíèìàåìîé äîëæíîñòè / çâàíèþ  âûãîâîð / ïîíèæåíèå.\nÏðèìå÷àíèå: ñîîòâåòñòâèå ôîðìû è çâàíèé óñòàíàâëèâàåòñÿ ðóêîâîäèòåëåì îðãàíèçàöèè.\n3.9. Çàïðåùàåòñÿ â ðàáî÷åå âðåìÿ íîñèòü íà ñåáå âûçûâàþùèå àêñåññóàðû  âûãîâîð / ïîíèæåíèå.\nÏðèìå÷àíèå: ïîä âûçûâàþùèìè àêñåññóàðàìè ïîäðàçóìåâàåòñÿ ÿðêî âûðàæåííûå ïðåäìåòû íà òåëå ãîñ. ñëóæàùåãî.\nÐàçðåøåíû ñòðîãèå î÷êè, ÷àñû, ÷¸ðíûå ïîâÿçêè íà ëèöî. Òàê æå ðàçðåøåíû àêñåññóàðû,\nñîîòâåòñòâóþùèå ïîäðàçäåëåíèþ ãîñ. ñëóæàùåãî [ áåðåòû, êîâáîéñêèå øëÿïû ].\n3.10. Çàïðåùåíî óìûøëåííî óäàëÿòü ñ áàçû äàííûõ ðîçûñêà áåç óâåäîìëåíèÿ ÔÁÐ  âûãîâîð / ïîíèæåíèå / óâîëüíåíèå.\nÄîïîëíåíèå: Åñëè âû îøèáëèñü è ìîæåòå äîêàçàòü ñâîþ íåâèíîâíîñòü, âû äîëæíû ñîîáùèòü îá ýòîì â äåïàðòàìåíò.")
  imgui.Text(u8"Ãëàâà ¹4.\nÏðåñòóïëåíèÿ ãîñóäàðñòâåííûõ ñîòðóäíèêîâ ïðîòèâ íîðì Óñòàâà, è äðóãèõ ïðàâîâûõ äîêóìåíòîâ.\n4.1. Çàïðåùàåòñÿ âûäàâàòü ðîçûñê è(èëè) âûïèñûâàòü øòðàô áåç âåñîìîé íà òî ïðè÷èíû, ïî ïðîñüáå.\nÈíûìè ñëîâàìè - íå âèäÿ ôàêòà íàðóøåíèÿ ëè÷íî  âûãîâîð / ïîíèæåíèå / óâîëüíåíèå.\n4.2. Çàïðåùàåòñÿ ïðîâîöèðîâàòü êîãî-ëèáî, íå âàæíî, êàêîãî ðîäà ïðîâîêàöèè  âûãîâîð / ïîíèæåíèå / óâîëüíåíèå.\n4.3. Çàïðåùàåòñÿ èñïîëüçîâàòü íåöåíçóðíóþ áðàíü, à òàêæå îñêîðáëåíèÿ  âûãîâîð / ïîíèæåíèå / óâîëüíåíèå.\nÏðèìå÷àíèå: ïî äàííîìó ïóíêòó ðàññìîòðåíèþ ïîäëåæàò æàëîáû/îáðàùåíèÿ, â ñëó÷àå,\nåñëè ñîòðóäíèê íàõîäèëñÿ ïðè èñïîëíåíèè è/èëè òåêñò îòíîñèëñÿ ê\nïðîôåññèîíàëüíîé äåÿòåëüíîñòè.\nÍàðóøåíèå ýòîãî ïóíêòà îäèíàêîâî ðàñïðîñòðàíÿåòñÿ êàê íà IC òàê è íà OOC ÷àòû [ ñìñ, /fb, /f. ].\n4.4. Çàïðåùàåòñÿ â ðàáî÷åå âðåìÿ çàíèìàòüñÿ ñâîèìè äåëàìè â ðàáî÷åå âðåìÿ,\nóñòàíîâëåííîå óñòàâîì ñîîòâåòñòâóþùåé îðãàíèçàöèè\n[ èãðà â êàçèíî, ó÷àñòèå â ïåéíòáîëå, base jump, äåðáè, è äðóãèå ìåðîïðèÿòèÿ â ðàçâëåêàòåëüíîì öåíòðå.\nÂ òîì ÷èñëå çàïðåùåíû ïîñåùåíèÿ àâòîÿðìàðêè è àóêöèîííûõ\nãàðàæåé. ]  âûãîâîð / ïîíèæåíèå / óâîëüíåíèå.\nÈñêëþ÷åíèå: ìåðîïðèÿòèÿ îò àäìèíèñòðàöèè [ ñî ñêðèíîì òåëåïîðòà ],\nèñïîëíåíèå ñëóæåáíûõ îáÿçàííîñòåé [ îõðàíà àâòîðûíêà, ïðîâåðêà âûøåóïîìÿíóòûõ ìåñò\náîéöàìè ñïåö.îòðÿäîâ àðìèé è ñò. îôèöåðîâ ], îáåä ñ 13:00 äî 14:00 [ ôîðìó íåîáõîäèìî ñíÿòü ],\nðàçðåøåíèå ðóêîâîäñòâà, ñò. îôèöåðû.\nÏðèìå÷àíèå: ðóêîâîäñòâî äåïàðòàìåíòà èëè àðìèè íå èìååò ïðàâà âûäàâàòü ðàçðåøåíèå íà ïîñåùåíèå\n[ ñ öåëüþ èãðû ]\nâ êàçèíî è àóêöèîííûõ ãàðàæåé è íå èìååò ïðàâî â ðàáî÷åå âðåìÿ ïîñåùàòü [ ñ öåëüþ èãðû ] èõ ñàìîñòîÿòåëüíî.\n4.5. Çàïðåùàåòñÿ õðàíåíèå è óïîòðåáëåíèå íàðêîòè÷åñêèõ âåùåñòâ, à òàêæå õðàíåíèå êðàäåíûõ ìàòåðèàëîâ.")
  imgui.Text(u8"Ïîä ýòó ñòàòüþ ïîïàäàåò õðàíåíèå âûøåïåðå÷èñëåííûõ ìàòåðèàëîâ â ñåéôå.  óâîëüíåíèå.\nÈñêëþ÷åíèå: Ñîòðóäíèêè PD, ñîòðóäíèêè ÔÁÐ â öåëÿõ ñïåö. îïåðàöèé [ ñ îáÿçàòåëüíûì êîíòðîëåì ñòàðøåãî îôèöåðà ].\n4.6. Çàïðåùàåòñÿ íàõîäèòüñÿ â îïàñíîì ðàéîíå âíå ñïåö. îïåðàöèé  âûãîâîð / ïîíèæåíèå / óâîëüíåíèå.\nÈñêëþ÷åíèå: ôåäåðàëüíûé ïàòðóëü,ñïåöèàëüíûå îòäåëû [ îáÿçàòåëüíûé êîíòðîëü ñî ñòîðîíû ðóêîâîäñòâà îðãàíèçàöèè ].\n4.7. Çàïðåùàåòñÿ îáúÿâëÿòü â ðîçûñê íå ïî óãîëîâíîìó êîäåêñó  âûãîâîð / ïîíèæåíèå.\n4.8. Çàïðåùàåòñÿ íåïîä÷èíåíèå ñòàðøåìó ïî çâàíèþ â ðàìêàõ çàêîíà  âûãîâîð / ïîíèæåíèå.\nÈñêëþ÷åíèå: Ñòàðøèå ïî çâàíèþ - â ðàìêàõ îäíîé îðãàíèçàöèè.\n4.9. Çàïðåùàåòñÿ óïîòðåáëÿòü àëêîãîëü â ðàáî÷åå âðåìÿ  ïîíèæåíèå.\n4.10. Çàïðåùàåòñÿ áðàòü / äàâàòü âçÿòêè  óâîëüíåíèå.\nÏðèìå÷àíèå: ðàçðåøàåòñÿ îòûãðîâêà Bad Cops.\nÎíà äîëæíà áûòü ñ ïðåäâàðèòåëüíûì ñíÿòèåì âñåõ íàøèâîê è íàäåâàíèåì ìàñêè ñ ôèêñàöèåé\n[ screen & /time ].\nÂ ñëó÷àå åñëè âàñ óñïåëè çàäåðæàòü è ñíÿòü ìàñêó - ïðèâëåêàåòåñü ïî óêàçàííîé ñòàòüå Ôåäåðàëüíîãî ïîñòàíîâëåíèÿ.\n4.11. Çàïðåùàåòñÿ íàðóøàòü ïðàâèëà âîëíû äåïàðòàìåíòà  âûãîâîð / ïîíèæåíèå.\nÏðèìå÷àíèå: ðóêîâîäñòâî ãîñ.îðãàíèçàöèåé îáÿçàíî îïîâåùàòü ïðèáûâøèõ ðàáîòíèêîâ\níà ðàáîòó î ïîëîæåíèè ×Ñ ïî âîëíå äåïàðòàìåíòà, äàííûé ïóíêò\nðàñïðîñòðàíÿåòñÿ äàæå íà òåõ, êòî «íå çíàë» ÷òî âîëíà íà ×Ñ.\nÍàðóøåíèåì äàííîé ñòàòüè ÔÏ ÿâëÿþòñÿ ñîîáùåíèÿ ñëåäóþùåãî ñîäåðæàíèÿ: «OG, íå ðåàãèðóåì», «ó÷òåì\nïðè ïîíèæåíèè», à òàêæå ñîîáùåíèÿ ïðî åäó â íåôîðìàëüíîì êîíòåêñòå «íàêîðìèòå ïå÷åíüêàìè»,\n«äàéòå åäû», «íàêîðìèòå ïîí÷èêàìè».\n4.12. Çàïðåùàåòñÿ áåñïðè÷èííî îáûñêèâàòü ãîñóäàðñòâåííûõ ñîòðóäíèêîâ  âûãîâîð / ïîíèæåíèå.\nÏðèìå÷àíèå: â ñëó÷àå, åñëè îáûñêèâàåòñÿ àãåíò ïîä ïðèêðûòèåì/ìàñêèðîâêîé,")
  imgui.Text(u8"êîòîðûé ñåáÿ íå ðàñêðûë ïî ñîáñòâåííûì ïðè÷èíàì  îôèöåð ïîëèöèè íå áóäåò ïðèâëå÷¸í ê îòâåòñòâåííîñòè.\n4.13. Çàïðåùàåòñÿ ëèøàòü ëèöåíçèè áåç âåñîìûõ íà òî ïðè÷èí  êîìïåíñàöèÿ ñòîèìîñòè ëèöåíçèé çà ñ÷¸ò\nîòîáðàâøåãî îôèöåðà ñ âûíåñåíèåì äîï. ñàíêöèè  âûãîâîð / ïîíèæåíèå.\nÏðèìå÷àíèå: åñëè Âû óâèäåëè, ÷òî ãîñóäàðñòâåííûé ñîòðóäíèê íàðóøèë ïðàâèëà äîðîæíîãî äâèæåíèÿ\nèëè â ãðàæäàíñêîé ôîðìå ÓÊ [ ãäå ïðåäóñìàòðèâàåòñÿ èçúÿòèå ëèöåíçèè ],\nè ó Âàñ åñòü äîêàçàòåëüñòâà, Âû èìååòå ïîëíîå ïðàâî çàáðàòü ëèöåíçèþ.\n4.14. Çàïðåùàåòñÿ íàðóøàòü ñóáîðäèíàöèþ ïðè îáùåíèè ñî ñòàðøèìè ïî çâàíèþ  âûãîâîð / ïîíèæåíèå.\n4.15. Çàïðåùàåòñÿ óáèéñòâî â íàðó÷íèêàõ èëè ýôôåêòîì ýëåêòðîøîêåðà  ïîíèæåíèå / óâîëüíåíèå.\nÏðèìå÷àíèå: ðàçðåøåíî èñïîëüçîâàòü ýëåêòðîøîêåð â ïåðåñòðåëêå, åñëè îíà íà÷àëàñü â Çåë¸íîé Çîíå\nè ó âàñ åñòü äîêàçàòåëüñòâà.\n4.16. Çàïðåùàåòñÿ íàðóøàòü çàêîíû øòàòà, à èìåííî: óãîëîâíûé êîäåêñ è àäìèíèñòðàòèâíûé êîäåêñû,\nêîíñòèòóöèÿ, óñòàâû ÏÄ / Àðìèé è äðóãèå ïðàâèëà óñòàíîâëåííûå êàêèìè-ëèáî\nïðàâîâûìè àêòàìè  âûãîâîð / ïîíèæåíèå / óâîëüíåíèå.\nÈñêëþ÷åíèå: åñëè ó Âàñ åñòü äîêàçàòåëüñòâà, ïîäòâåðæäàþùèå âàøó ïîëíóþ ëèáî ÷àñòè÷íóþ\níåâèíîâíîñòü ïî ôàêòàì: ñàìîîáîðîíû ñåáÿ è áëèçêèõ; çàùèòû ëè÷íîãî èìóùåñòâà;\nïðè âûïîëíåíèè ñëóæåáíîãî äîëãà, íî íàõîäÿñü íå ïðè èñïîëíåíèè ñëóæåáíûõ îáÿçàííîñòåé [ íå â ôîðìå ];\nïðèêàç ñòàðøåãî ïî çâàíèþ â ðàìêàõ çàêîíà.\n4.17. Çàïðåùàåòñÿ íåïîä÷èíåíèå ðóêîâîäÿùåìó ñîñòàâó ÔÁÐ  ïîíèæåíèå / óâîëüíåíèå.\n4.18. Çàïðåùàåòñÿ íåïîä÷èíåíèå Ãóáåðíàòîðó â ðàìêàõ çàêîíà Øòàòà Evolve  ïîíèæåíèå / óâîëüíåíèå.\n4.19. Çàïðåùàåòñÿ îòäàâàòü ïðèêàçû Ãóáåðíàòîðó  óâîëüíåíèå.\n4.20. Çàïðåùàåòñÿ îòäàâàòü ïðèêàçû ñîòðóäíèêàì ÔÁÐ  ïîíèæåíèå / óâîëüíåíèå.")
  imgui.Text(u8"4.21. Çàïðåùåíî íàäåâàòü ìàñêó íå íàõîäÿñü íà ñïåö.îïåðàöèè/íà îáëàâå èëè çàåçäå/îòáèâàíèè/çàùèòå ïîðòà.\nÐàçðåøåíî íàäåòü ìàñêó ïî ïðèêàçó àãåíòà ÔÁÐ ñ íàëè÷èåì äîêàçàòåëüñòâ.  âûãîâîð / ïîíèæåíèå.\nÏðèìå÷àíèå: íîñèòü ìàñêó â ó÷àñòêå [ â ãàðàæå ] òàêæå çàïðåùåíî.\nÏðè çëîóïîòðåáëåíèè äàííûì ïóíêòîì ñëåäóåò íàêàçàíèå çà ïðåâûøåíèå äîëæíîñòíûõ ïîëíîìî÷èé.\n4.22. Çàïðåùàåòñÿ èñïîëüçîâàòü ëè÷íîå òðàíñïîðòíîå ñðåäñòâî â ñëóæåáíûõ öåëÿõ è ñèòóàöèÿõ,\níå ïðåäóñìîòðåííûõ äåéñòâóþùèì óñòàâîì ãîñ.îðãàíèçàöèè.  âûãîâîð.\nÏðèìå÷àíèå: äàííûé ïóíêò îòíîñèòñÿ â ïåðâóþ î÷åðåäü ê àðìèÿì.\nÈñïîëüçîâàòü ëè÷íûé òðàíñïîðò ìîãóò ñïåö. ïîäðàçäåëåíèÿ è Ñòàðøèé Îôèöåðñêèé ñîñòàâ àðìèé,\nÃëàâû è âûøå ÔÁÐ.\n4.23. Çàïðåùàåòñÿ ïðåâûøàòü ñâîè äîëæíîñòíûå ïîëíîìî÷èÿ  ïîíèæåíèå / óâîëüíåíèå.\n4.24. Çàïðåùàåòñÿ îáúÿâëÿòü â ðîçûñê ïîäîçðåâàåìîãî/ïðåñòóïíèêà åñëè íà íåì íàäåòà ìàñêà  âûãîâîð / ïîíèæåíèå.\nÈñêëþ÷åíèå: Ïîäîçðåâàåìîãî óäàëîñü çàäåðæàòü [ îáåçäâèæèòü òàéçåðîì èëè íàðó÷íèêàìè ],\nâ òàêîì ñëó÷àå ðîçûñê âûäàåòñÿ íåçàâèñèìî îò òîãî, â ìàñêå îí èëè íåò.\nÄîïóñêàåòñÿ òàêæå âûäà÷à ðîçûñêà â ñëó÷àå íåïîñðåäñòâåííîãî êîíòàêòà ñ ïîäîçðåâàåìûì áåç ìàñêè äî ïîãîíè\n[ ò.å. âîçìîæíîñòü ðàçãëÿäåòü ëèöî, íàëè÷èå äîêàçàòåëüñòâ ñ /time îáÿçàòåëüíî ].\n4.25. Çàïðåùàåòñÿ íàðóøàòü îáùèå ïðàâèëà ïîëèöèè  âûãîâîð / ïîíèæåíèå / óâîëüíåíèå.\n4.26. Çàïðåùåíî áåçäåéñòâèå / íåèñïîëíåíèå îáÿçàííîñòåé ïî îêàçàíèþ ïîìîùè ëèöàì,\níàõîäÿùèìñÿ â îïàñíîé ñèòóàöèè, ïî ïðåäîòâðàùåíèþ íàíåñåíèÿ óùåðáà èìóùåñòâó.  âûãîâîð / ïîíèæåíèå / óâîëüíåíèå.\n4.27. Çàïðåùàåòñÿ ïðîèçâîäèòü àðåñò ñîòðóäíèêà AF, à òàêæå âñåõ ëèäåðîâ ãîñóäàðñòâåííûõ ñòðóêòóð\nè èõ çàìåñòèòåëåé â ðàáî÷åå è âûõîäíîå âðåìÿ áåç îäîáðåíèÿ FBI  âûãîâîð / ïîíèæåíèå.")
  imgui.Text(u8"Ïðèìå÷àíèå: Â ñëó÷àå, åñëè ïî çàïðîñó â äåïàðòàìåíò íèêòî íå äàåò îòâåò â òå÷åíèå 5 ìèíóò,\nòî ðàçðåøàåòñÿ àðåñò è áåç îäîáðåíèÿ FBI, ÍÎ ñ îáÿçàòåëüíîé ôèêñàöèåé çàïðîñà.\n4.28. Çàïðåùàåòñÿ íàðóøàòü ïðàâèëà ïîñåùåíèÿ Ìýðèè,\nà òàêæå âîñïðåïÿòñòâîâàòü çàêîííîé äåÿòåëüíîñòè ìèíèñòðîâ è âèöå-ãóáåðíàòîðîâ,\nèãíîðèðîâàòü èõ òðåáîâàíèÿ, óêàçàííûå â çàêîíå «Î ðàáîòå ìýðèè»  âûãîâîð / ïîíèæåíèå.\n4.29. Çàïðåùàåòñÿ èñïîëüçîâàòü ìåãàôîí â ëè÷íûõ öåëÿõ,\nà èìåííî â ðàçëè÷íûõ ïåðåãîâîðîâ ñ äðóçüÿìè,\nøóòêè è âñÿêèé áðåä, íå îòíîñÿùèéñÿ ê ðàáî÷èì ìîìåíòàì  âûãîâîð / ïîíèæåíèå.\nÏðèìå÷àíèå: [ Ïðèìåðû  «Ýé, áðî, êàê äåëà?» & «Ïîéäåì ïîêàòàåìñÿ?» ]  òàê äåëàòü íåëüçÿ!")
  imgui.Text(u8"Ãëàâà ¹5.\n5.1. Ñîòðóäíèê ÔÁÐ èìååò ïðàâî ñìåíèòü íàêàçàíèå íà äèñöèïëèíàðíîå âçûñêàíèå â âèäå ïðåäóïðåæäåíèÿ\nëèáî èíîå íàêàçàíèå íå ïðåäóñìîòðåííîå ïóíêòàìè\níàñòîÿùåãî áþðî ïðè ñìÿã÷àþùèõ îáñòîÿòåëüñòâàõ.\nÑìÿã÷àþùèì îáñòîÿòåëüñòâîì ÿâëÿåòñÿ ðàñêàÿíèå ãîñ. ñëóæàùåãî â ñîäåÿííîì íàðóøåíèè,\nëèáî êîíñòðóêòèâíàÿ àðãóìåíòàöèÿ ñâîèõ äåéñòâèé\nñ ïîäêðåïëåíèåì äîêàçàòåëüñòâ ñâîèì àðãóìåíòàì.\n5.2. Ñîòðóäíèê Àðìèè èëè ÏÄ îáÿçàí ñäåëàòü âûâîäû î ñâîåé âèíå è ïîñòàðàòüñÿ áîëåå íå íàðóøàòü ÔÏ.\n5.3. Ñìåíà íàêàçàíèÿ îñóùåñòâëÿåòñÿ àãåíòîì ÔÁÐ, èñõîäÿ èç åãî çäðàâîãî ñìûñëà è îïûòà.\nÂûäà÷à ïðåäóïðåæäåíèé çà ïóíêòû, êîòîðûå òàê èëè èíà÷å ñïîñîáíû ïîøàòíóòü ãîñóäàðñòâåííóþ áåçîïàñíîñòü - çàïðåùåíû.\n5.4. Ñîòðóäíèê èìååò ïðàâî ïîëó÷èòü òîëüêî îäíî ïðåäóïðåæäåíèå,\nïðè ïîñëåäóþùèõ íàðóøåíèÿõ ñëåäóþò áîëåå òÿæêèå íàêàçàíèÿ.\n5.5. Ïóíêòû, ïðåäóñìàòðèâàþùèå âûáîð âèäà íàêàçàíèÿ,\nïîäðàçóìåâàþò ïðèìåíåíèå îäíîãî èç íèõ ïî óñìîòðåíèþ âûäàþùåãî íàêàçàíèå,\nâ çàâèñèìîñòè îò òÿæåñòè íàðóøåíèÿ è íàëè÷èÿ àêòèâíûõ ïðåäóïðåæäåíèé,\nëèáî íàðóøåíèé â ïðîøëîì.\n5.6. Íåîðäèíàðíûå ñèòóàöèè. Â ñëó÷àå ñîâåðøåíèÿ ãîñóäàðñòâåííûì ñîòðóäíèêîì äåÿíèÿ,\nêîòîðîå ìîæíî ñ÷åñòü çà êîñâåííîå íàðóøåíèå òîé èëè èíîé ñòàòüè îäíîãî èç\níîðìàòèâíî-ïðàâîâûõ àêòîâ, ðóêîâîäÿùèé ñîñòàâ ÔÁÐ èìååò ïðàâî ïðèìåíèòü\nëþáîé èç äåéñòâóþùèõ ïóíêòîâ çàêîíîäàòåëüíûõ áàç, ññûëàÿñü ïðè ýòîì íà ÔÏ.")
  imgui.Text(u8"Ãëàâà ¹6.\nÏîëíîìî÷èÿ àãåíòîâ ÔÁÐ.\n6.1. Äåæóðíûé FBI è âûøå èìååò ïðàâî îòäàòü ïðèêàç áîéöàì àðìèè äî çâàíèÿ Êàïèòàí è îôèöåðàì ïîëèöèè äî çâàíèÿ\nÊàïèòàí âêëþ÷èòåëüíî ïðè ×Ñ [ òåðàêòå/ïîõèùåíèå ].\n6.2. Àãåíò DEA/CID èìååò ïðàâî îòäàòü ïðèêàç áîéöàì àðìèè äî çâàíèÿ\nÏðàïîðùèê è îôèöåðàì ïîëèöèè äî çâàíèÿ Ñò.Ïðàïîðùèê âêëþ÷èòåëüíî.\n6.3. Ãëàâà DEA/CID èìååò ïðàâî îòäàòü ïðèêàç áîéöàì àðìèè äî çâàíèÿ\nÌàéîð è îôèöåðàì ïîëèöèè äî çâàíèÿ Ìàéîð âêëþ÷èòåëüíî.\n6.4. Èíñïåêòîð FBI èìååò ïðàâî îòäàòü ïðèêàç áîéöàì àðìèè äî çâàíèÿ \nÏîäïîëêîâíèê è îôèöåðàì ïîëèöèè äî çâàíèÿ Ïîäïîëêîâíèê âêëþ÷èòåëüíî.\n6.5. Çàì. Äèðåêòîðà FBI èìååò ïðàâî îòäàòü ïðèêàç áîéöàì àðìèè äî çâàíèÿ\nÏîëêîâíèê è îôèöåðàì ïîëèöèè äî çâàíèÿ Ïîëêîâíèê âêëþ÷èòåëüíî.\nÏðèìå÷àíèå: Â ñëó÷àÿõ, êîãäà Äèðåêòîðà ÔÁÐ íåò íà ðàáî÷åì ìåñòå [ íå â èãðå/âûõîäíîé ],\nÇàìåñòèòåëü Äèðåêòîðà ÔÁÐ èìååò ïðàâî îòäàòü ïðèêàç ëþáîìó ñîòðóäíèêó ñèëîâûõ ñòðóêòóð.\n6.6. Äèðåêòîð FBI èìååò ïðàâî îòäàòü ïðèêàç áîéöàì àðìèè äî çâàíèÿ\nÃåíåðàë è îôèöåðàì ïîëèöèè äî çâàíèÿ Øåðèô âêëþ÷èòåëüíî.")
  imgui.Text(u8"Ãëàâà ¹7.\nÂèäû ñàíêöèé äëÿ ãîñóäàðñòâåííûõ ñòðóêòóð.\n7.1. Ñàíêöèè, ïåðå÷èñëåííûå íèæå â äàííîé ãëàâå ÿâëÿþòñÿ åäèíûìè.\nËþáàÿ äðóãàÿ ñàíêöèÿ, âûäàííàÿ íå ïî äàííûì ïðàâèëàì íå íàäåëÿåòñÿ þðèäè÷åñêîé ñèëîé.\n7.2. Ñîòðóäíèê ÏÄ/Àðìèè ìîæåò ïîëó÷èòü ñàíêöèþ â âèäå ïðåäóïðåæäåíèÿ\nçà íàðóøåíèå Ôåäåðàëüíîãî ïîñòàíîâëåíèÿ / âíóòðåííåãî óñòàâà îðãàíèçàöèè.\n7.3. Ñîòðóäíèê ÏÄ/Àðìèè ìîæåò ïîëó÷èòü ñàíêöèþ â âèäå íàðÿäà çà íàðóøåíèå\nÔåäåðàëüíîãî ïîñòàíîâëåíèÿ / âíóòðåííåãî óñòàâà îðãàíèçàöèè.\n7.4. Ñîòðóäíèê ÏÄ/Àðìèè ìîæåò ïîëó÷èòü ñàíêöèþ â âèäå îáû÷íîãî âûãîâîðà íà 7 äíåé çà íàðóøåíèå\nÔåäåðàëüíîãî ïîñòàíîâëåíèÿ / âíóòðåííåãî óñòàâà îðãàíèçàöèè.\n7.5. Ñîòðóäíèê ÏÄ/Àðìèè ìîæåò ïîëó÷èòü ñàíêöèþ â âèäå ñòðîãîãî âûãîâîðà íà 14 äíåé ñ\nïðîïóñêîì ïîâûøåíèÿ çà íàðóøåíèå Ôåäåðàëüíîãî ïîñòàíîâëåíèÿ / âíóòðåííåãî óñòàâà îðãàíèçàöèè.\n7.6. Ñîòðóäíèê ÏÄ/Àðìèè ìîæåò ïîëó÷èòü ñàíêöèþ â âèäå ïîíèæåíèÿ çà íàðóøåíèå\nÔåäåðàëüíîãî ïîñòàíîâëåíèÿ / âíóòðåííåãî óñòàâà îðãàíèçàöèè.\n7.7. Ñîòðóäíèê ÏÄ/Àðìèè ìîæåò ïîëó÷èòü ñàíêöèþ â âèäå óâîëüíåíèÿ çà íàðóøåíèå\nÔåäåðàëüíîãî ïîñòàíîâëåíèÿ / âíóòðåííåãî óñòàâà îðãàíèçàöèè.")
  imgui.End()
end

function nyamnyam()
  local result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
  if result then
    local animid = sampGetPlayerAnimationId(id)
    if animid == 536 then
      sampSendChat("Íÿì íÿì.")
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

function kvadrat() local KV = { [1] = "À", [2] = "Á", [3] = "Â", [4] = "Ã", [5] = "Ä", [6] = "Æ", [7] = "Ç", [8] = "È", [9] = "Ê", [10] = "Ë", [11] = "Ì", [12] = "Í", [13] = "Î", [14] = "Ï", [15] = "Ð", [16] = "Ñ", [17] = "Ò", [18] = "Ó", [19] = "Ô", [20] = "Õ", [21] = "Ö", [22] = "×", [23] = "Ø", [24] = "ß", } local X, Y, Z = getCharCoordinates(playerPed) X = math.ceil((X + 3000) / 250) Y = math.ceil((Y * - 1 + 3000) / 250) Y = KV[Y] local KVX = (Y.."-"..X) return KVX end 
