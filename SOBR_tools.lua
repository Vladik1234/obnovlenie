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
  Tag = "Не указан.",
  cvetclist = "Не указан.",
  lwait = "Не указана.",
}

local monikQuant = {}

local monikQuantNum = {}

local settings = {}

script_author("Tarasov")
script_name("SOBR tools")
script_version_number(1)
script_description("Скрипт для СОБР")

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
        Tag = "Не указан.",
        cvetclist = "Не указан.",
        lwait = "Не указана.",
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
 
    sampRegisterChatCommand("przv",function() if settings.global.priziv == true then sampAddChatMessage("[SOBR tools]: Режим призыва отключён.", 0xFFB22222) settings.global.priziv = false else sampAddChatMessage("[SOBR tools]: Режим призыва включён.", 0x33AAFFFF) settings.global.priziv = true end end)

    sampRegisterChatCommand("splayer",function() if settings.global.sdelaitak == true then sampAddChatMessage("[SOBR tools]: Отображение в чате ников военных которые появились в зоне стрима отключено.", 0xFFB22222) settings.global.sdelaitak = false else sampAddChatMessage("[SOBR tools]: Отображение в чате ников военных которые появились в зоне стрима включено.", 0x33AAFFFF) settings.global.sdelaitak = true end end)

    sampRegisterChatCommand("pst",function() if settings.global.m_s_t_a_t == true then sampAddChatMessage("[SOBR tools]: Теперь у вас в скрипте женские отыгровки.", 0xFFB22222) settings.global.m_s_t_a_t = false else  sampAddChatMessage("[SOBR tools]: Теперь у вас в скрипте мужские отыгровки.", 0x33AAFFFF) settings.global.m_s_t_a_t = true end end)

    sampRegisterChatCommand("ascreen",function() if settings.global.a_u_t_o_screen == true then sampAddChatMessage("[SOBR tools]: Автоскрин после пэйдея был выключен.", 0xFFB22222) settings.global.a_u_t_o_screen = false else sampAddChatMessage("[SOBR tools]: Автоскрин после пэйдея был включён.", 0x33AAFFFF) settings.global.a_u_t_o_screen = true end end)

    sampRegisterChatCommand("atag",function() if settings.global.a_u_t_o_tag == true then sampAddChatMessage("[SOBR tools]: Автотег в чат был выключен.", 0xFFB22222) settings.global.a_u_t_o_tag = false else sampAddChatMessage("[SOBR tools]: Автотег в чат был включен.", 0x33AAFFFF) settings.global.a_u_t_o_tag = true end end)

    sampRegisterChatCommand("lp",function() if settings.global.k_r_u_t_o == true then sampAddChatMessage("[SOBR tools]: Открывание авто на клавишу `L` было выключено.", 0xFFB22222) settings.global.k_r_u_t_o = false else sampAddChatMessage("[SOBR tools]: Открывание авто на клавишу `L` было включено.", 0x33AAFFFF) settings.global.k_r_u_t_o = true end end)

    sampRegisterChatCommand("aclist",function() if settings.global.t_se_au_to_clist == true then sampAddChatMessage("[SOBR tools]: Автоклист выключен.", 0xFFB22222) settings.global.t_se_au_to_clist = false else sampAddChatMessage("[SOBR tools]: Автоклист включен.", 0x33AAFFFF) settings.global.t_se_au_to_clist = true end end)

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
      if priziv == true and testCheat("Z") then submenus_show(LVDialog, "{00FA9A}ПРИЗЫВ{FFFFFF}") end
      if main_window_state.v == false then imgui.Process = false end
      if sampIsChatInputActive() and sampGetChatInputText() == "/cfaq" then sampSetChatInputText("") sampShowDialog(1285, "{808080}[SOBR tools] Команды{FFFFFF}", "{808080}/aclist - выключить/включить автоклист\n/lp - выключить/включить открывание авто на клавишу `L`\n/atag - выключить/включить авто-тег\n/ascreen - выключить/включить авто-скрин после пэйдея\n/sw, /st - сменить игровое время/погоду\n/cc - очистить чат\n/kv - поставить метку на квадрат\n/getm - показать себе мониторинг, /rgetm - в рацию\n/przv - включить/выключить режим призыва\n/abp - выключить/включить авто-БП на `alt`\n/hphud - включить/отключить хп худ\n/abp - включить настройки авто-БП\n/splayer - включить/выключить отображение в чате ников военных которые появились в зоне стрима\n/fustav - посмотреть ФП и устав\n/smembers - посмотреть онлайн отряда{FFFFFF}", "Ладно", "Прохладно", 0) end
      if testCheat("JJJJJ") then getNearestPlayerId() end
      if isKeyJustPressed(VK_C) and isKeyJustPressed(VK_MULTIPLY) then getNearestPlayerId1() end
      if wasKeyPressed(VK_MENU) then abp() end
      nyamnyam()
    end
  end

function refreshDialog()
  SSSDialog = {
  
    {
      title = "{808080}Запросить эвакуацию{FFFFFF}",
      onclick = function()
        sampSendChat("/r "..pInfo.Tag.." Запрашиваю эвакуацию в квадрат "..kvadrat())
      end
    },
    {
      title = "{808080}Надеть маску{FFFFFF}",
      onclick = function()
        if m_s_t_a_t == true then
            sampSendChat("/me достал маску из кармана и надел на лицо")
            wait(1200)
            sampSendChat("/mask")
            wait(1200)
            sampSendChat("/clist 0")
            wait(1200)
            sampSendChat("/do На лице маска. Лица не видно. Форма без нашивок и погон.")
        else
            sampSendChat("/me достала маску из кармана и надела на лицо")
            wait(1200)
            sampSendChat("/mask")
            wait(1200)
            sampSendChat("/clist 0")
            wait(1200)
            sampSendChat("/do На лице маска. Лица не видно. Форма без нашивок и погон.")
        end
      end
    },
    {
      title = "{808080}Отыгровки{FFFFFF}",
      submenu = 
      {
        title = "{808080}Отыгровки{FFFFFF}",
        {
          title = "{808080}Разминирование{FFFFFF}",
          submenu = 
          {
            title = "{808080}Выберите отыгровку{FFFFFF}",
            {
              title = "{808080}Разминирование взрывчатки с часовым механизмом{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Не указана." and settings.global.lwait ~= "Не указана" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me достал набор сапера")
                    wait(settings.global.lwait)
                    sampSendChat("/me определил тип взрывного устройства")
                    wait(settings.global.lwait)
                    sampSendChat("/do Взрывчатка с часовым механизмом.")
                    wait(settings.global.lwait)
                    sampSendChat("/me достал отвертку")
                    wait(settings.global.lwait)
                    sampSendChat("/me аккуратно откручивает болты на корпусе устройства")
                    wait(settings.global.lwait)
                    sampSendChat("/me обнаружил в механизме несколько проводов")
                    wait(settings.global.lwait)
                    sampSendChat("/me достал кусачки из саперского набора")
                    wait(settings.global.lwait)
                    sampSendChat("/me взял синий провод в руки")
                    wait(settings.global.lwait)
                    sampSendChat("/me с помощью кусачек оголил провода")
                    wait(settings.global.lwait)
                    sampSendChat("/me достал индикаторную отвертку")
                    wait(settings.global.lwait)
                    sampSendChat("/me приложил отвертку к оголенному проводу")
                    wait(settings.global.lwait)
                    sampSendChat("/do Светодиод в отвертке загорелся.")
                    wait(settings.global.lwait)
                    sampSendChat("/me взял в руки кусачки")
                    wait(settings.global.lwait)
                    sampSendChat("/me перерезал провод")
                    wait(settings.global.lwait)
                    sampSendChat("/me Таймер остановлен.")
                    wait(settings.global.lwait)
                    sampSendChat("/me отсоеденил детанатор")
                    wait(settings.global.lwait)
                    sampSendChat("/me взял бронированный кейс")
                    wait(settings.global.lwait)
                    sampSendChat("/me положил взрывчатку в кейс")
                    wait(settings.global.lwait)
                    sampSendChat("/me положил все инструменты в набор сапера")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me достала набор сапера")
                    wait(settings.global.lwait)
                    sampSendChat("/me определила тип взрывного устройства")
                    wait(settings.global.lwait)
                    sampSendChat("/do Взрывчатка с часовым механизмом.")
                    wait(settings.global.lwait)
                    sampSendChat("/me достала отвертку")
                    wait(settings.global.lwait)
                    sampSendChat("/me аккуратно откручивает болты на корпусе устройства")
                    wait(settings.global.lwait)
                    sampSendChat("/me обнаружила в механизме несколько проводов")
                    wait(settings.global.lwait)
                    sampSendChat("/me достала кусачки из саперского набора")
                    wait(settings.global.lwait)
                    sampSendChat("/me взяла синий провод в руки")
                    wait(settings.global.lwait)
                    sampSendChat("/me с помощью кусачек оголила провода")
                    wait(settings.global.lwait)
                    sampSendChat("/me достала индикаторную отвертку")
                    wait(settings.global.lwait)
                    sampSendChat("/me приложила отвертку к оголенному проводу")
                    wait(settings.global.lwait)
                    sampSendChat("/do Светодиод в отвертке загорелся.")
                    wait(settings.global.lwait)
                    sampSendChat("/me взяла в руки кусачки")
                    wait(settings.global.lwait)
                    sampSendChat("/me перерезала провод")
                    wait(settings.global.lwait)
                    sampSendChat("/me Таймер остановлен.")
                    wait(settings.global.lwait)
                    sampSendChat("/me отсоеденила детанатор")
                    wait(settings.global.lwait)
                    sampSendChat("/me взяла бронированный кейс")
                    wait(settings.global.lwait)
                    sampSendChat("/me положила взрывчатку в кейс")
                    wait(settings.global.lwait)
                    sampSendChat("/me положила все инструменты в набор сапера")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}Разминирование универсальное{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Не указана." and settings.global.lwait ~= "Не указана" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do На спине висит боевой рюкзак.")
                    wait(settings.global.lwait)
                    sampSendChat("/me стянул рюкзак со спины, затем достал набор для разминирования")
                    wait(settings.global.lwait)
                    sampSendChat("/me аккуратно осмотрел бомбу")
                    wait(settings.global.lwait)
                    sampSendChat("/me вытащил из набора электрическую отвертку типа `PS-201`")
                    wait(settings.global.lwait)
                    sampSendChat("/me открутил шурупы с панели бомбы")
                    wait(settings.global.lwait)
                    sampSendChat("/me обеими руками аккуратно снял крышку с бомбы, после чего вытащил из набора щипцы")
                    wait(settings.global.lwait)
                    sampSendChat("/do На бомбе виден красный и синий провод.")
                    wait(settings.global.lwait)
                    sampSendChat("/me надрезал провод бомбы, после чего перекусил красный провод")
                    wait(settings.global.lwait)
                    sampSendChat("/do Таймер заморожен и бомба больше не пригодна к использованию.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do На спине висит боевой рюкзак.")
                    wait(settings.global.lwait)
                    sampSendChat("/me стянула рюкзак со спины, затем достал набор для разминирования")
                    wait(settings.global.lwait)
                    sampSendChat("/me аккуратно осмотрела бомбу")
                    wait(settings.global.lwait)
                    sampSendChat("/me вытащила из набора электрическую отвертку типа `PS-201`")
                    wait(settings.global.lwait)
                    sampSendChat("/me открутила шурупы с панели бомбы")
                    wait(settings.global.lwait)
                    sampSendChat("/me обеими руками аккуратно сняла крышку с бомбы, после чего вытащил из набора щипцы")
                    wait(settings.global.lwait)
                    sampSendChat("/do На бомбе виден красный и синий провод.")
                    wait(settings.global.lwait)
                    sampSendChat("/me надрезала провод бомбы, после чего перекусил красный провод")
                    wait(settings.global.lwait)
                    sampSendChat("/do Таймер заморожен и бомба больше не пригодна к использованию.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}Разминирование взрывного устройства с дистанционным управлением{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Не указана." and settings.global.lwait ~= "Не указана" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me достав саперный набор, раскрыл его")
                    wait(settings.global.lwait)
                    sampSendChat("/me осмотрел взрывное устройство")
                    wait(settings.global.lwait)
                    sampSendChat("/do Определил тип взрывного устройства `Бомба с дистанционным управлением`.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Увидел два шурупа на блоке с механизмом.")
                    wait(settings.global.lwait)
                    sampSendChat("/me достал отвертку из саперного набора")
                    wait(settings.global.lwait)
                    sampSendChat("/do Отвертка в руке.")
                    wait(settings.global.lwait)
                    sampSendChat("/me аккуратно выкрутил шурупы")
                    wait(settings.global.lwait)
                    sampSendChat("/me отодвинул крышку блока и увидел антенну")
                    wait(settings.global.lwait)
                    sampSendChat("/do Увидел красный мигающий индикатор.")
                    wait(settings.global.lwait)
                    sampSendChat("/me просмотрел путь микросхемы от антенны к детонатору")
                    wait(settings.global.lwait)
                    sampSendChat("/me увидел два провода")
                    wait(settings.global.lwait)
                    sampSendChat("/me перерезал первый провод. Индикатор перестал мигать")
                    wait(settings.global.lwait)
                    sampSendChat("/do Бомба обезврежена.")
                    wait(settings.global.lwait)
                    sampSendChat("/me сложил инструменты обратно в саперный набор")
                    wait(settings.global.lwait)
                    sampSendChat("/me достал бронированный кейс и аккуратно сложил туда бомбу")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me достав саперный набор, раскрыла его")
                    wait(settings.global.lwait)
                    sampSendChat("/me осмотрела взрывное устройство")
                    wait(settings.global.lwait)
                    sampSendChat("/do Определила тип взрывного устройства `Бомба с дистанционным управлением`.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Увидела два шурупа на блоке с механизмом.")
                    wait(settings.global.lwait)
                    sampSendChat("/me достала отвертку из саперного набора")
                    wait(settings.global.lwait)
                    sampSendChat("/do Отвертка в руке.")
                    wait(settings.global.lwait)
                    sampSendChat("/me аккуратно выкрутила шурупы")
                    wait(settings.global.lwait)
                    sampSendChat("/me отодвинула крышку блока и увидела антенну")
                    wait(settings.global.lwait)
                    sampSendChat("/do Увидела красный мигающий индикатор.")
                    wait(settings.global.lwait)
                    sampSendChat("/me просмотрела путь микросхемы от антенны к детонатору")
                    wait(settings.global.lwait)
                    sampSendChat("/me увидела два провода")
                    wait(settings.global.lwait)
                    sampSendChat("/me перерезала первый провод. Индикатор перестал мигать")
                    wait(settings.global.lwait)
                    sampSendChat("/do Бомба обезврежена.")
                    wait(settings.global.lwait)
                    sampSendChat("/me сложила инструменты обратно в саперный набор")
                    wait(settings.global.lwait)
                    sampSendChat("/me достал бронированный кейс и аккуратно сложил туда бомбу")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}Разминирование взрывного устройства с жучком-детектором{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Не указана." and settings.global.lwait ~= "Не указана" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me осмотрел взрывное устройство")
                    wait(settings.global.lwait)
                    sampSendChat("/do Вид бомбы определен.")
                    wait(settings.global.lwait)
                    sampSendChat("/me достал отвертку")
                    wait(settings.global.lwait)
                    sampSendChat("/me откручивает корпус бомбы")
                    wait(settings.global.lwait)
                    sampSendChat("/me взял кусачки в саперном наборе")
                    wait(settings.global.lwait)
                    sampSendChat("/me оголил кусачками красный провод")
                    wait(settings.global.lwait)
                    sampSendChat("/me взял жучок-детектор в саперном наборе")
                    wait(settings.global.lwait)
                    sampSendChat("/me прицепил жучок-детектор к красному проводу")
                    wait(settings.global.lwait)
                    sampSendChat("/me взял изоленту в саперном наборе")
                    wait(settings.global.lwait)
                    sampSendChat("/me заизолировал провод")
                    wait(settings.global.lwait)
                    sampSendChat("/me взял кусачки ")
                    wait(settings.global.lwait)
                    sampSendChat("/me взял жучок-детектор")
                    wait(settings.global.lwait)
                    sampSendChat("/me прицепил жучок-детектор к синему проводу")
                    wait(settings.global.lwait)
                    sampSendChat("/me взял кусачки")
                    wait(settings.global.lwait)
                    sampSendChat("/me отрезал синий провод")
                    wait(settings.global.lwait)
                    sampSendChat("/me отсоединил детонатор")
                    wait(settings.global.lwait)
                    sampSendChat("/do Бомба обезврежена.")
                    wait(settings.global.lwait)
                    sampSendChat("/me положил все обратно в саперный набор")
                    wait(settings.global.lwait)
                    sampSendChat("/me достал бронированный кейс")
                    wait(settings.global.lwait)
                    sampSendChat("/me поместил бомбу в бронированный кейс")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me осмотрела взрывное устройство")
                    wait(settings.global.lwait)
                    sampSendChat("/do Вид бомбы определен.")
                    wait(settings.global.lwait)
                    sampSendChat("/me достала отвертку")
                    wait(settings.global.lwait)
                    sampSendChat("/me откручивает корпус бомбы")
                    wait(settings.global.lwait)
                    sampSendChat("/me взяла кусачки в саперном наборе")
                    wait(settings.global.lwait)
                    sampSendChat("/me оголила кусачками красный провод")
                    wait(settings.global.lwait)
                    sampSendChat("/me взяла жучок-детектор в саперном наборе")
                    wait(settings.global.lwait)
                    sampSendChat("/me прицепила жучок-детектор к красному проводу")
                    wait(settings.global.lwait)
                    sampSendChat("/me взяла изоленту в саперном наборе")
                    wait(settings.global.lwait)
                    sampSendChat("/me заизолировала провод")
                    wait(settings.global.lwait)
                    sampSendChat("/me взяла кусачки ")
                    wait(settings.global.lwait)
                    sampSendChat("/me взяла жучок-детектор")
                    wait(settings.global.lwait)
                    sampSendChat("/me прицепила жучок-детектор к синему проводу")
                    wait(settings.global.lwait)
                    sampSendChat("/me взяла кусачки")
                    wait(settings.global.lwait)
                    sampSendChat("/me отрезала синий провод")
                    wait(settings.global.lwait)
                    sampSendChat("/me отсоединила детонатор")
                    wait(settings.global.lwait)
                    sampSendChat("/do Бомба обезврежена.")
                    wait(settings.global.lwait)
                    sampSendChat("/me положила все обратно в саперный набор")
                    wait(settings.global.lwait)
                    sampSendChat("/me достала бронированный кейс")
                    wait(settings.global.lwait)
                    sampSendChat("/me поместила бомбу в бронированный кейс")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  end
                end
              end
            },
          }
        },
        {
          title = "{808080}Первая медицинская помощь[ПМП]{FFFFFF}",
          submenu = 
          {
            title = "{808080}Выберите отыгровку{FFFFFF}",
            {
              title = "{808080}ПМП при переломе{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Не указана." and settings.global.lwait ~= "Не указана" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do Медицинская сумка на плече.")
                    wait(settings.global.lwait)
                    sampSendChat("/me снял медицинскую сумку с плеча, затем открыл её")
                    wait(settings.global.lwait)
                    sampSendChat("/do В сумке лежат: стерильные шприцы, ампула с анальгетиком, шина, бинты.")
                    wait(settings.global.lwait)
                    sampSendChat("/me достал стерильный шприц с ампулой, аккуратно приоткрыв ампулу с анальгетиком")
                    wait(settings.global.lwait)
                    sampSendChat("/me перелил содержимое ампулы в шприц")
                    wait(settings.global.lwait)
                    sampSendChat("/me закатал рукав пострадавшего, после чего ввёл анальгетик через шприц в вену, вдавив поршень")
                    wait(settings.global.lwait)
                    sampSendChat("/me достал из сумки шину, затем принялся накладывать её на повреждённую конечность")
                    wait(settings.global.lwait)
                    sampSendChat("/me аккуратно наложил шину на повреждённую конечность")
                    wait(settings.global.lwait)
                    sampSendChat("/do Шина качественно наложена на повреждённую конечность.")
                    wait(settings.global.lwait)
                    sampSendChat("/me взял из сумки стерильные бинты, затем начал делать косынку")
                    wait(settings.global.lwait)
                    sampSendChat("/me сделал косынку из стерильного бинта")
                    wait(settings.global.lwait)
                    sampSendChat("/me подвесил повреждённую конечность в согнутом положении")
                    wait(settings.global.lwait)
                    sampSendChat("/do Повреждённая конечность иммобилизована.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do Медицинская сумка на плече.")
                    wait(settings.global.lwait)
                    sampSendChat("/me сняла медицинскую сумку с плеча, затем открыл её")
                    wait(settings.global.lwait)
                    sampSendChat("/do В сумке лежат: стерильные шприцы, ампула с анальгетиком, шина, бинты.")
                    wait(settings.global.lwait)
                    sampSendChat("/me достала стерильный шприц с ампулой, аккуратно приоткрыв ампулу с анальгетиком")
                    wait(settings.global.lwait)
                    sampSendChat("/me перелила содержимое ампулы в шприц")
                    wait(settings.global.lwait)
                    sampSendChat("/me закатала рукав пострадавшего, после чего ввёл анальгетик через шприц в вену, вдавив поршень")
                    wait(settings.global.lwait)
                    sampSendChat("/me достала из сумки шину, затем принялся накладывать её на повреждённую конечность")
                    wait(settings.global.lwait)
                    sampSendChat("/me аккуратно наложила шину на повреждённую конечность")
                    wait(settings.global.lwait)
                    sampSendChat("/do Шина качественно наложена на повреждённую конечность.")
                    wait(settings.global.lwait)
                    sampSendChat("/me взяла из сумки стерильные бинты, затем начал делать косынку")
                    wait(settings.global.lwait)
                    sampSendChat("/me сделала косынку из стерильного бинта")
                    wait(settings.global.lwait)
                    sampSendChat("/me подвесила повреждённую конечность в согнутом положении")
                    wait(settings.global.lwait)
                    sampSendChat("/do Повреждённая конечность иммобилизована.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}ПМП при ранении конечностей{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Не указана." and settings.global.lwait ~= "Не указана" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me осмотрел раненного")
                    wait(settings.global.lwait)
                    sampSendChat("/do Определил, пробита артерия.")
                    wait(settings.global.lwait)
                    sampSendChat("/me наложил давящую повязку на рану")
                    wait(settings.global.lwait)
                    sampSendChat("/me достал флягу со спиртом и оторвал кусок ткани со своей одежды")
                    wait(settings.global.lwait)
                    sampSendChat("/do Боец налил спирт на ткань и приложил её на место ранения.")
                    wait(settings.global.lwait)
                    sampSendChat("/me достал аптечку и открыл ее, затем достал жгут и бинт")
                    wait(settings.global.lwait)
                    sampSendChat("/me закрепил повязку на ранении бинтом обмотав бинт вокруг раны")
                    wait(settings.global.lwait)
                    sampSendChat("/do Боец наложил жгут ниже ранения.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Кровотечение постепенно проходит.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Жгут наложен, кровотечение остановлено.")
                    wait(settings.global.lwait)
                    sampSendChat("/me достал из аптечки таблетки Аспирин и положил в рот раненому")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me осмотрела раненного")
                    wait(settings.global.lwait)
                    sampSendChat("/do Определила, пробита артерия.")
                    wait(settings.global.lwait)
                    sampSendChat("/me наложила давящую повязку на рану")
                    wait(settings.global.lwait)
                    sampSendChat("/me достала флягу со спиртом и оторвала кусок ткани со своей одежды")
                    wait(settings.global.lwait)
                    sampSendChat("/do Налила спирт на ткань и приложила её на место ранения.")
                    wait(settings.global.lwait)
                    sampSendChat("/me достала аптечку и открыла ее, затем достала жгут и бинт")
                    wait(settings.global.lwait)
                    sampSendChat("/me закрепила повязку на ранении бинтом обмотав бинт вокруг раны")
                    wait(settings.global.lwait)
                    sampSendChat("/do Наложила жгут ниже ранения.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Кровотечение постепенно проходит.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Жгут наложен, кровотечение остановлено.")
                    wait(settings.global.lwait)
                    sampSendChat("/me достала из аптечки таблетки Аспирин и положила в рот раненому")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}ПМП при ранении в грудь и живот{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Не указана." and settings.global.lwait ~= "Не указана" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me осмотрел раненного")
                    wait(settings.global.lwait)
                    sampSendChat("/me помог человеку принять полусидячее положение")
                    wait(settings.global.lwait)
                    sampSendChat("/me достал аптечку и открыл ее")
                    wait(settings.global.lwait)
                    sampSendChat("/do Боец достал из аптечки стерильный бинт и средства для обработки ран.")
                    wait(settings.global.lwait)
                    sampSendChat("/me обработал края раны обеззараживающим средством и убрал излишки крови")
                    wait(settings.global.lwait)
                    sampSendChat("/do Боец достал асептическую марлю и смочил ее спиртом.")
                    wait(settings.global.lwait)
                    sampSendChat("/me прижал марлю к ране, приостановив кровотечение")
                    wait(settings.global.lwait)
                    sampSendChat("/me достал из аптечки бинт, затем начал обматывать рану")
                    wait(settings.global.lwait)
                    sampSendChat("/do Бинты постепенно скрывают рану.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Повязка крепко наложена и стягивает рану.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Кровотечение постепенно проходит.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/me осмотрела раненного")
                    wait(settings.global.lwait)
                    sampSendChat("/me помогла человеку принять полусидячее положение")
                    wait(settings.global.lwait)
                    sampSendChat("/me достала аптечку и открыл ее")
                    wait(settings.global.lwait)
                    sampSendChat("/do Достала из аптечки стерильный бинт и средства для обработки ран.")
                    wait(settings.global.lwait)
                    sampSendChat("/me обработала края раны обеззараживающим средством и убрал излишки крови")
                    wait(settings.global.lwait)
                    sampSendChat("/do Достала асептическую марлю и смочила ее спиртом.")
                    wait(settings.global.lwait)
                    sampSendChat("/me прижала марлю к ране, приостановив кровотечение")
                    wait(settings.global.lwait)
                    sampSendChat("/me достала из аптечки бинт, затем начала обматывать рану")
                    wait(settings.global.lwait)
                    sampSendChat("/do Бинты постепенно скрывают рану.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Повязка крепко наложена и стягивает рану.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Кровотечение постепенно проходит.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}ПМП при потере пульса{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Не указана." and settings.global.lwait ~= "Не указана" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do На правом плече висит открытая мед. сумка.")
                    wait(settings.global.lwait)
                    sampSendChat("/me достав из сумки полотенце, подложил его под шею пострадавшего")
                    wait(settings.global.lwait)
                    sampSendChat("/me снял с груди человека всю одежду")
                    wait(settings.global.lwait)
                    sampSendChat("/me снял все сдавливающие аксессуары")
                    wait(settings.global.lwait)
                    sampSendChat("/me сделав глубокий вдох, начал делать искусственное дыхание лёгких")
                    wait(settings.global.lwait)
                    sampSendChat("/do Воздух постепенно наполняет и заполняет лёгкие пострадавшего.")
                    wait(settings.global.lwait)
                    sampSendChat("/me положил руки друг на друга на грудь человека")
                    wait(settings.global.lwait)
                    sampSendChat("/me делает непрямой массаж сердца")
                    wait(settings.global.lwait)
                    sampSendChat("/me попеременно делает искусственное дыхание и непрямой массаж сердца")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do На правом плече висит открытая мед. сумка.")
                    wait(settings.global.lwait)
                    sampSendChat("/me достав из сумки полотенце, подложила его под шею пострадавшего")
                    wait(settings.global.lwait)
                    sampSendChat("/me сняла с груди человека всю одежду")
                    wait(settings.global.lwait)
                    sampSendChat("/me сняла все сдавливающие аксессуары")
                    wait(settings.global.lwait)
                    sampSendChat("/me сделав глубокий вдох, начала делать искусственное дыхание лёгких")
                    wait(settings.global.lwait)
                    sampSendChat("/do Воздух постепенно наполняет и заполняет лёгкие пострадавшего.")
                    wait(settings.global.lwait)
                    sampSendChat("/me положила руки друг на друга на грудь человека")
                    wait(settings.global.lwait)
                    sampSendChat("/me делает непрямой массаж сердца")
                    wait(settings.global.lwait)
                    sampSendChat("/me попеременно делает искусственное дыхание и непрямой массаж сердца")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  end
                end
              end
            },
          }
        },
        {
          title = "{808080}Другое{FFFFFF}",
          submenu = 
          {
            title = "{808080}Выберите отыгровку{FFFFFF}",
            {
              title = "{808080}Маскировка автомобиля и сидячих в нём{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Не указана." and settings.global.lwait ~= "Не указана" then
                  sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                  wait(200)
                  sampSendChat("/do Водитель и пассажиры находятся в автомобиле без опозновательных знаков.")
                  wait(settings.global.lwait)
                  sampSendChat("/do Автомобиль полностью бронирован, номерные знаки отсутствуют, шины пулестойкие.")
                  wait(settings.global.lwait)
                  sampSendChat("/do Стекла автомобиля затонированы, личность водителя и пассажиров не распознать.")
                  wait(200)
                  sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                end
              end
            },
            {
              title = "{808080}Надеть противогаз{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Не указана." and settings.global.lwait ~= "Не указана" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do На бедре левой ноги висит подсумок с противогазом ГП-21.")
                    wait(settings.global.lwait)
                    sampSendChat("/me задержав дыхание, достал противогаз и ловким движением надел его")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do На бедре левой ноги висит подсумок с противогазом ГП-21.")
                    wait(settings.global.lwait)
                    sampSendChat("/me задержав дыхание, достала противогаз и ловким движением надела его")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}Полная маскировка себя{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Не указана." and settings.global.lwait ~= "Не указана" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do Неизвестный одет в военную форму из номекса темно серого цвета.")
                    wait(settings.global.lwait)
                    sampSendChat("/do На бронежилете нет нашивок, распознавательные знаки отсутствуют.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Лицо скрыто балаклавой, личность не распознать.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do Неизвестная одета в военную форму из номекса темно серого цвета.")
                    wait(settings.global.lwait)
                    sampSendChat("/do На бронежилете нет нашивок, распознавательные знаки отсутствуют.")
                    wait(settings.global.lwait)
                    sampSendChat("/do Лицо скрыто балаклавой, личность не распознать.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  end
                end
              end
            },
            {
              title = "{808080}Полная маскировка себя и окружающих{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Не указана." and settings.global.lwait ~= "Не указана" then
                  sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                  wait(200)
                  sampSendChat("/do Неизвестные одеты в военную форму из номекса темно-серого цвета.")
                  wait(settings.global.lwait)
                  sampSendChat("/do Распознавательные знаки на форме отсутствуют.")
                  wait(settings.global.lwait)
                  sampSendChat("/do Лица скрыты балаклавами, личности не распознать.")
                  wait(200)
                  sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                end
              end
            },
            {
              title = "{808080}Проверка снаряжения{FFFFFF}",
              onclick = function()
                if settings.global.lwait ~= "Не указана." and settings.global.lwait ~= "Не указана" then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do На груди висит четыре подсумка.")
                    wait(settings.global.lwait)
                    sampSendChat("/me начал проверять свое снаряжение, проверяя каждый подсумок")
                    wait(settings.global.lwait)
                    sampSendChat("/me проверил первый подсумок")
                    wait(settings.global.lwait)
                    sampSendChat("/do В первом подсумке лежит аптечка АИ-2 и перевязочный пакет ИПП-1. ")
                    wait(settings.global.lwait)
                    sampSendChat("/me проверил второй и третий подсумок")
                    wait(settings.global.lwait)
                    sampSendChat("/do Во втором и третьем подсумке лежит 5 магазинов для М4, 6 магазинов для Deagle, 5 обойм для Rifle.")
                    wait(settings.global.lwait)
                    sampSendChat("/me проверил четвертый подсумок")
                    wait(settings.global.lwait)
                    sampSendChat("/do В четвертом подсумке лежат 2 небольших фильтра для противогаза, ключи, сигареты, наручники.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  else
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("/do На груди висит четыре подсумка.")
                    wait(settings.global.lwait)
                    sampSendChat("/me начала проверять свое снаряжение, проверяя каждый подсумок")
                    wait(settings.global.lwait)
                    sampSendChat("/me проверила первый подсумок")
                    wait(settings.global.lwait)
                    sampSendChat("/do В первом подсумке лежит аптечка АИ-2 и перевязочный пакет ИПП-1. ")
                    wait(settings.global.lwait)
                    sampSendChat("/me проверила второй и третий подсумок")
                    wait(settings.global.lwait)
                    sampSendChat("/do Во втором и третьем подсумке лежит 5 магазинов для М4, 6 магазинов для Deagle, 5 обойм для Rifle.")
                    wait(settings.global.lwait)
                    sampSendChat("/me проверила четвертый подсумок")
                    wait(settings.global.lwait)
                    sampSendChat("/do В четвертом подсумке лежат 2 небольших фильтра для противогаза, ключи, сигареты, наручники.")
                    wait(200)
                    sampAddChatMessage("[SOBR tools]: Конец отыгровки.", 0x33AAFFFF)
                  end
                end
              end
            },
          }
        },
        {
          title = "{808080}Задержка между строками в отыгровках:{FFFFFF} "..pInfo.lwait,
          onclick = function()
            sampShowDialog(9999, "Установить задержку:", "{b6b6b6}Введи задержку:", "ОК", "Закрыть", 1)
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
      title = "{808080}Информация{FFFFFF}",
      submenu =
      {
        title = "{808080}Информация{FFFFFF}",
        {
          title = "{808080}Устав отряда{FFFFFF}",
          onclick = function()
            sampShowDialog(2344, "{808080}[SOBR tools] Устав СОБР{FFFFFF}", "{808080}«ПРЕАМБУЛА»\n1.1 Каждый боец отряда обязан знать и соблюдать правила установленные уставом.\n1.2 За несоблюдение устава отряда боец может получить наказание вплоть до исключения из отряда.\n1.3 Командир отряда имеет право изменять устав в любое время.\n«ОБЯЗАННОСТИ»\n2.1 Осуществление безопасности охраняемой территории армии Лас-Вентураса;\n2.2 Мгновенное реагирование на `SOS` со стороны бойцов, ведущих поставки боеприпасов;\n2.3 Проверка `Магазинов одежды` и `АММО`;\n2.4 Предотвращение кражи военного имущества, в том числе военной техники;\n2.5 Осуществление круглосуточных патрулей вокруг воинской части, маршрутов снабжения в целях находки засады байкерских клубов, а так же патруль близлежащих территорий города и его окрестностей;\n2.6 Пеший патруль самой части ( ГС-Ангары );\n2.7 Осуществление сопровождений колонн снабжения в целях сохранности имущества армии;\n2.8 Осуществление безопасности и порядка на призывах в армию Лас-Вентураса;\n2.9 Участие в спец. операциях вместе с Управлением Собственной Безопасности,а так же Federal Bureau of Investigation;\n2.10 Помощь в порту Лос-Сантоса при чрезвычайных ситуациях.\n2.11 Помощь другим взводам.\n«ЗАПРЕТЫ»\n3.1 Нарушение устава в любой форме;\n3.2 Неисполнение приказов командующего состава, руководства армии;\n3.3 Возвращаться на место ранения (искл.: прошло 3 минуты);\n3.4 Идти в перестрелку с тремя и более вооруженными противниками (искл.: с вами напарник);\n3.5 Участие в тренировках/мп от Сенаторов с каким-либо взводом, когда нападения байкеров и бандитов происходят часто;\n3.6 Взрывать фуру после того, как отбили у ОПГ (в случае, если фура поломана, починить рем.комплектом, если фура на ходу, эвакуировать в часть);\n3.7 Любые конфликты с бойцами армии;\n3.8 Находиться в опасном районе вне спец.операций;\n3.9 Осуществлять воздушный патруль без разрешения ком.состава отряда и/или в составе менее трех человек;\n3.10 Несмотря на офицерское звания в отряде, СОБР не имеет право командовать или руководить кем-либо из взводов или офицеров.\n(искл.: допускается руководство солдатами в критических ситуациях при отсутствии старших офицеров)\n«РАЗРЕШЕНО»\n4.1 Покидать территорию части для заправки транспорта и пополнения рем. комплектов с докладом. (от должности Боец)\n4.2 Выезжать с территории базы через проход рядом с КПП и через горку рядом с контейнерами на ГС.\n4.3 Ломать кнопочную станции во время погони за фурой.\n4.4 Отдыхать, спать в штабе неограниченное время.\n4.5 Парковать свой личный транспорт справа от штаба.\n4.6 Вести огонь на поражение по любому бойцу, который находится в маске в части.{FFFFFF}", "Понял", "Не понял", 0)
          end
        },
        {
          title = "{808080}Тен-коды{FFFFFF} ",
          onclick = function()
            sampShowDialog(4353, "{808080}[SOBR tools] Тен-коды{FFFFFF}", "{808080}10-4 — Сообщение принято, выезжаю!\n10-6 — Я занят, по причине - [Указать причину]\n10-8 — Готов к работе [Указать позывной]\n10-10 — Похищение, в секторе - [Указать сектор]\n10-16 — Перехватите подозреваемого в секторе - [Указать сектор]\n10-20 — Местоположение в секторе - [Указать сектор]\n10-26 — Последняя информация отменяется.\n10-34 — Требуется подкрепление в секторе - [Указать сектор]\n10-37 — Требуется эвакуация в сектор - [Указать сектор]\n10-38 — Требуется машина скорой помощи в сектор - [Указать сектор]\n10-30 - Выехали в сопровождение - [Указать позывные напарников]\n10-31 - Возвращаемся в часть\n10-40 - Патруль части - [Указать позывные напарников]\n10-43 - Вылетели в порт ЛС - [Указать позывные напарников]\n10-44 - Прилетели в порт ЛС\n10-51 - Выехали на проверку AMMO LS - [Указать позывные напарников]\n10-52 - Выехали на проверку AMMO SF - [Указать позывные напарников]\n10-53 - Выехали на проверку AMMO LV - [Указать позывные напарников]\n10-61 - Выехали на проверку MO LS - [Указать позывные напарников]\n10-62 - Выехали на проверку MO SF - [Указать позывные напарников]\n10-63 - Выехали на проверку MO LV - [Указать позывные напарников]\n10-99 — Задание выполнено, все в порядке.\n10-100 — Нужно отойти.\n10-200 — Требуется наряд полиции в сектор - [Указать сектор]\n10-250 — Вызов спец.отрядов PD в указанное место - [Указать сектор / место].\n(Используется при рейдах, облавах, терактах и общих тренировках)\n10-300 — Вызов спец.отрядов PD и Army в указанное место - [Указать сектор / место].\n(Используется при рейдах, облавах, терактах и общих тренировках){FFFFFF}", "Понял", "Не понял", 0)
          end
        },
        {
          title = "{808080}Позывные напарников{FFFFFF}",
          onclick = function()
            sampShowDialog(1298, "{808080}[SOBR tools] Позывные{FFFFFF}", "{808080}Leo Florenso - Пена\nSergu Sibov - Аристократ\nHoward Harper - Деанон\nMisha Samyrai - Жит\nValentin Molo - Крот\nBrain Spencor - Волк\nKevin Spencor - Гром\nAleksey Tarasov - Зверь\nRodrigo German - Фура\nMichael Fersize - Изгой\nBarbie Bell - Ангел\nJimmy Saints - Маккуин\nBoulevard Bledov - Бизон\nSaibor Ackerman - Молния\nKenneth Sapporo - Феникс\nNikita Prizrack - Призрак\nHieden Bell - Андрюха\nChristian Hazard - Крест{FFFFFF}", "Ок", "Не ок", 0)
          end
        },
        {
          title = "{808080}Устав армии и Федеральное Постановление{FFFFFF}",
          onclick = function()
            cmd_imgui()
          end
        },
      }
    },
    {
      title = "{808080}Команды скрипта{FFFFFF}",
      onclick = function()
        sampShowDialog(1285, "{808080}[SOBR tools] Команды{FFFFFF}", "{808080}/aclist - выключить/включить автоклист\n/lp - выключить/включить открывание авто на клавишу `L`\n/atag - выключить/включить авто-тег\n/ascreen - выключить/включить авто-скрин после пэйдея\n/sw, /st - сменить игровое время/погоду\n/cc - очистить чат\n/kv - поставить метку на квадрат\n/getm - показать себе мониторинг, /rgetm - в рацию\n/przv - включить/выключить режим призыва\n/abp - выключить/включить авто-БП на `alt`\n/hphud - включить/отключить хп худ\n/abp - включить настройки авто-БП\n/splayer - включить/выключить отображение в чате ников военных которые появились в зоне стрима\n/fustav - посмотреть ФП и устав{FFFFFF}", "Ладно", "Прохладно", 0)
      end
    },
    {
      title = "{808080}Настройки{FFFFFF}",
      submenu =
      {
        title = "{808080}Настройки{FFFFFF}",
        {
          title = "{808080}Тэг:{FFFFFF} "..pInfo.Tag,
          onclick = function()
            sampShowDialog(9999, "Установить тэг:", "{b6b6b6}Введи свой тэг:", "ОК", "Закрыть", 1)
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
          title = "{808080}Номер цвета автоклиста:{FFFFFF} "..pInfo.cvetclist,
          onclick = function()
            sampShowDialog(9999, "Автоклист:", "{b6b6b6}Введи номер цвета:", "ОК", "Закрыть", 1)
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
          title = "{808080}Выключить/включить открывание транспорта на клавишу `L`{FFFFFF}",
          onclick = function()
            if settings.global.k_r_u_t_o == true then
              sampAddChatMessage("[SOBR tools]: Открывание авто на клавишу `L` было выключено.", 0xFFB22222)
              settings.global.k_r_u_t_o = false
            else
              sampAddChatMessage("[SOBR tools]: Открывание авто на клавишу `L` было включено.", 0x33AAFFFF)
              settings.global.k_r_u_t_o = true
            end
          end
        },
        {
          title = "{808080}Выключить/включить авто-тег{FFFFFF}",
          onclick = function()
            if settings.global.a_u_t_o_tag == true then
              sampAddChatMessage("[SOBR tools]: Автотег в чат был выключен.", 0xFFB22222)
              settings.global.a_u_t_o_tag = false
            else
              sampAddChatMessage("[SOBR tools]: Автотег в чат был включен.", 0x33AAFFFF)
              settings.global.a_u_t_o_tag = true
            end
          end
        },
        {
          title = "{808080}Выключить/включить автоскрин после пэйдея{FFFFFF}",
          onclick = function()
            if settings.global.a_u_t_o_screen == true then
              sampAddChatMessage("[SOBR tools]: Автоскрин после пэйдея был выключен.", 0xFFB22222)
              settings.global.a_u_t_o_screen = false
            else
              sampAddChatMessage("[SOBR tools]: Автоскрин после пэйдея был включен.", 0x33AAFFFF)
              settings.global.a_u_t_o_screen = true
            end
          end
        },
        {
          title = "{808080}Выключить/включить показ паспорта на `Alt + прицел на игрока`{FFFFFF}",
          onclick = function()
            if settings.global.pokazatpassport == true then
              sampAddChatMessage("[SOBR tools]: Функция показа паспорта была отключена.", 0xFFB22222)
              settings.global.pokazatpassport = false
            else
              sampAddChatMessage("[SOBR tools]: Функция показа паспорта была включена.", 0x33AAFFFF)
              settings.global.pokazatpassport = true
            end
          end
        },
        {
          title = "{808080}Выключить/включить отображение позывных{FFFFFF}",
          onclick = function()
            if settings.global.pozivnoy == true then
              sampAddChatMessage("[SOBR tools]: Отображение позывных было выключено.", 0xFFB22222)
              settings.global.pozivnoy = false
              for k, val in pairs(tData) do val:deattachText() end
            else
              sampAddChatMessage("[SOBR tools]: Отображение позывных было включено.", 0x33AAFFFF)
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
      title = "{808080}Призыв/мед.осмотр{FFFFFF}",
      submenu = {
        title = "{808080}Мед.осмотр{FFFFFF}",
        {
          title = "{808080}Приветствие и просьба показать документы{FFFFFF}",
          onclick = function()
            local _, pID = sampGetPlayerIdByCharHandle(PLAYER_PED)
            if settings.global.m_s_t_a_t == true then
                sampSendChat("Приветствую, я сотрудник призывной комиссии.")
                wait(1600)
                sampSendChat("Покажите ваши документы и медицинскую карту.")
                wait(1600)
                sampSendChat("/b /showpass "..pID.." / /me показал мед.карту")
            else
                sampSendChat("Приветствую, я сотрудница призывной комиссии.")
                wait(1600)
                sampSendChat("Покажите ваши документы и медицинскую карту.")
                wait(1600)
                sampSendChat("/b /showpass "..pID.." / /me показал мед.карту")
            end
          end
        },
        {
          title = "{808080}/me взял медкарту и начал изучать её{FFFFFF}",
          onclick = function()
             sampSendChat("/me взял медкарту и начал изучать её")
          end
        },
        {
          title = "{808080}/todo Сколько вам полных лет?*перелистывая медкарту{FFFFFF}",
          onclick = function()
             sampSendChat("/todo Сколько вам полных лет?*перелистывая медкарту")
          end
        },
        {
          title = "{808080}/todo Так, расскажите мне о себе*закрыв медкарту{FFFFFF}",
          onclick = function()
             sampSendChat("/todo Так, расскажите мне о себе*закрыв медкарту")
          end
        },
        {
          title = "{808080}Отлично. Что у меня над головой?{FFFFFF}",
          onclick = function()
             sampSendChat("Отлично. Что у меня над головой?")
          end
        },
        {
          title = "{808080}Отлично, вы годны для службы в армии{FFFFFF}",
          onclick = function()
             sampSendChat("Отлично, вы годны для службы в армии.")
          end
        },
        {
          title = "{808080}Держите повязку №16 и проходите в соседний кабинет{FFFFFF}",
          onclick = function()
             sampSendChat("Держите повязку №16 и проходите в соседний кабинет.")
          end
        },
        {
          title = "{808080}/r [Ваш тэг]: Гражданин с пейджером ID годен для службы в армии Выдал розовую повязку{FFFFFF}",
          onclick = function()
            sampShowDialog(9999, "{CD5C5C}SOBR tools {FFFFFF} :", "{b6b6b6}Введите ид.\nОбразец: {FFFFFF}3", "ОК", "Закрыть", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              local args = split(input, ",")
                args[1] = args[1]:gsub(" ", "")
                sampSendChat("/r "..pInfo.Tag.." Гражданин с пейджером "..args[1].." годен для службы в армии, получил розовую повязку.")
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

tData["Leo_Florenso"] = Target:New("{000000}Пена{FFFFFF}")
tData["Howard_Harper"] = Target:New("{000000}Деанон{FFFFFF}")
tData["Aleksey_Tarasov"] = Target:New("{000000}Зверь{FFFFFF}")
tData["Valentin_Molo"] = Target:New("{000000}Крот{FFFFFF}")
tData["Brain_Spencor"] = Target:New("{000000}Волк{FFFFFF}")
tData["Kevin_Spencor"] = Target:New("{000000}Гром{FFFFFF}")
tData["Evan_Corleone"] = Target:New("{000000}Левиафан{FFFFFF}")
tData["Misha_Samyrai"] = Target:New("{000000}Жит{FFFFFF}")
tData["Sergu_Sibov"] = Target:New("{000000}Аристократ{FFFFFF}")
tData["Kenneth_Sapporo"] = Target:New("{000000}Феникс{FFFFFF}")
tData["Rodrigo_German"] = Target:New("{000000}Фура{FFFFFF}")
tData["Michael_Fersize"] = Target:New("{000000}Изгой{FFFFFF}")
tData["Jimmy_Saints"] = Target:New("{000000}Маккуин{FFFFFF}")
tData["Barbie_Bell"] = Target:New("{000000}Ангел{FFFFFF}")
tData["Saibor_Ackerman"] = Target:New("{000000}Молния{FFFFFF}")
tData["Boulevard_Bledov"] = Target:New("{000000}Бизон{FFFFFF}")
tData["Nikita_Prizrack"] = Target:New("{000000}Призрак{FFFFFF}")
tData["Christian_Hazard"] = Target:New("{000000}Крест{FFFFFF}")
tData["Hieden_Bell"] = Target:New("{000000}Андрюха{FFFFFF}")


nData = {"Leo_Florenso", "Howard_Harper", "Aleksey_Tarasov", "Valentin_Molo", "Evan_Corleone", "Kevin_Spencor", "Brain_Spencor", "Rodrigo_German", "Sergu_Sibov", "Jimmy_Saints", "Saibor_Ackerman", "Michael_Fersize", "Barbie_Bell", "Boulevard_Bledov", "Kenneth_Sapporo", "Nikita_Prizrack", "Hieden_Bell", "Christian_Hazard"}

function e.onPlayerStreamIn(id, _, model)
  if cfg.global.sdelaitak ~= nil then
    if cfg.global.sdelaitak == true then
      local name = sampGetPlayerNickname(id)
      if model == 287 or model == 191 or model == 179 or model == 61 or model == 255 or model == 73 then
        sampAddChatMessage("[SOBR tools]: Боец "..name.." появился в зоне прорисовки.", 0x33AAFFFF)
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

function sw(param) local weather = tonumber(param) if weather ~= nil and weather >= 0 and weather <= 45 then forceWeatherNow(weather) sampAddChatMessage("Вы сменили погоду на: "..weather, 0x33AAFFFF) else sampAddChatMessage("Диапазон значения погоды: от 0 до 45.", 0x33AAFFFF) end end

function st(param)
    local hour = tonumber(param)
    if hour ~= nil and hour >= 0 and hour <= 23 then
        time = hour
        patch_samp_time_set(true)
        if time then
            setTimeOfDay(time, 0)
            sampAddChatMessage("Вы изменили время на: "..time, 0x33AAFFFF)
        end
    else
        sampAddChatMessage("Значение времени должно быть в диапазоне от 0 до 23.", 0x33AAFFFF)
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
    local letters = {"А", "Б", "В", "Г", "Д", "Ж", "З", "И", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Я"}
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
  if title:find('Дополнительно') and bronya == true then       
    sampSendDialogResponse(32700, 1, 2, nil)
  end
end

function e.onServerMessage(color, text)
  if (text:find("КЛИЕНТ БАНКА SA")) and settings.global.a_u_t_o_screen == true then
      sampSendChat("/time")
      lua_thread.create(function()
          wait(1234)
          justPressThisShitPlease(VK_F8)
      end)
  end
  if (text:find("Добро пожаловать на Evolve Role Play")) then
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
  sampAddChatMessage("[SOBR tools]: Последнее обновление успешно загружено.", 0xFFB22222)
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
	local result, text = Search3Dtext(x,y,z, 700, "Склад")
	local temp = split(text, "\n")
	for k, val in pairs(temp) do monikQuant[k] = val end
	if monikQuant[6] ~= nil then
		for i = 1, table.getn(monikQuant) do
			number1, number2, monikQuantNum[i] = string.match(monikQuant[i],"(%d+)[^%d]+(%d+)[^%d]+(%d+)")
			monikQuantNum[i] = monikQuantNum[i]/1000
		end
    sampSendChat("/r "..pInfo.Tag..": Мониторинг: LSPD - "..monikQuantNum[1].."|SFPD: "..monikQuantNum[2].."|LVPD: "..monikQuantNum[3].."|SFa: "..monikQuantNum[4].."|FBI: "..monikQuantNum[6].."")
    thisScript():reload()
  else
    sampAddChatMessage("[SOBR tools]: Ошибка. Вы находитесь слишком далеко от бункера.", 0xFFB22222)
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
        sampSendChat("/report "..playerid.." +С")
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
    sampAddChatMessage("[SOBR tools] Желаемый комплект боеприпасов был взят.", 0xFFB22222)
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
	line[6] = "Броня			"..((ini.Settings["Slot6"] == "0" or ini.Settings["Slot6"] == 0) and "{ff0000}[OFF]" or "{59fc30}[ON]")
	line[7] = "Спец. оружие	              "..((ini.Settings["Slot7"] == "0" or ini.Settings["Slot7"] == 0) and "{ff0000}[OFF]" or "{59fc30}[ON]")

	local textSettings = ""

	for k,v in pairs(line) do textSettings = textSettings..v.."\n" end

	sampShowDialog(1995, "Настройки авто-БП", textSettings, "Выбрать", "Отмена", 2)
	
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
		
	textHelp = "Введите количество комплектов "..nameGun..", которое требуется взять.\nВведеные данные должны быть от 0 до 2."
	sampShowDialog(1995, "Комплекты "..nameGun, textHelp, "Выбрать", "Отмена", 1)
	
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
  imgui.Begin(u8"Устав и ФП", main_window_state)
  imgui.Text(u8"                                                                                              УСТАВ")
  imgui.Text(u8"\nГлава I. Общие положения.\n1.1 Устав определяет общие права и обязанности военнослужащих Las-Venturas Army и их взаимоотношения,\nобязанности основных должностных лиц,подразделений, правила внутреннего порядка в воинской части и ее подразделениях;\n1.2 Данный устав обязаны знать и соблюдать все военнослужащие армии;\n1.3 Незнание устава не освобождает вас от ответственности;\n1.4 Устав может быть изменен генералом в любое время;\n1.5 Рабочий день в будни начинается с 8:00 до 22:00, в выходные дни и в пятницу с 9:00 до 21:00;\n1.6 Обед начинается с 13:00 до 14:00. В данное время бойцам разрешается заниматься своими делами, оставив форму в казарме\n[рядовым и ефрейторам разрешается посещать тир, который находится на тренировочной площадке, за казармой];\n1.7 Отпустить в город без формы может любой старший офицер. В это время вы не можете посещать казино и гаражи,\nтакже нарушать устав и ФП;\n1.8 Приказ, указ, распоряжение и т.п. генерала не могут быть подвергнуты оспариванию или невыполнению\n[исключение: указ противоречит федеральному постановлению];\n1.9 Генерал вправе выдать приказ противоречащий уставу армии;")
  imgui.Text(u8"Глава II. Основные обязанности военнослужащих.\n2.1 Военнослужащий обязан соблюдать устав армии, конституцию, законы штата, федеральное постановление;\n2.2 Военнослужащий обязан беспрекословно выполнять приказы старших по званию и должности в рамках их полномочий и защищать их в бою;\n2.3 Военнослужащий обязан быть бдительным, строго хранить военную и государственную тайну;\n2.4 Военнослужащий обязан знать в лицо и поимённо старший офицерский состав;\n2.5 Военнослужащий обязан защищать имущество и ценности армии Las-Venturas;\n2.6 Военнослужащий обязан находиться на службе в течение всего рабочего дня;\n2.7 Военнослужащий обязан при приближении к базе надевать повязку №7, во время увольнительного времени все без исключения;\n2.8 Военнослужащий обязан предъявлять документы дежурному на КПП / СКПП по прибытию на службу [исключение: старшие офицеры];\n2.9 Каждый военнослужащий, находящийся на КПП / СКПП, обязан запросить документы у каждого гражданского,\nприбывшего на пропускной пункт[исключение: старшие офицеры];\n2.10 Военнослужащий на КПП / СКПП перед тем как запросить документы у гражданского, военнослужащий обязан представиться\n[Пример: “Здравствуйте, я рядовой Иванов. Предъявите пожалуйста ваши документы.”].\n2.11 Военнослужащий обязан всегда быть в опрятном виде [100 hp и 100 armor].")
  imgui.Text(u8"Глава III. Основные запреты военнослужащих.\n3.1 Военнослужащему запрещено продавать, терять военную форму\n[исключение: мероприятие от сената в опасном районе, УСБ, СОБР к при спец.операциях].\n3.2 Военнослужащему запрещено доставлять боеприпасы ОПГ.\n3.3 Военнослужащему запрещено выпрашивать звание, должность.\n3.4 Военнослужащему запрещено самовольно покидать территорию части\n[исключение: пункт устава 5.1].\n3.5 Военнослужащему запрещено находиться в опасном районе\n[исключение: УСБ, СОБР в рейде, мероприятия от сенаторов].\n3.6 Военнослужащему запрещено открывать огонь по своим сослуживцам\n[исключение: стрельба холостыми патронами на тренировке].\n3.7 Военнослужащему запрещено обманывать сослуживцев.\n3.8 Военнослужащему запрещено пререкаться со старшими по званию или должности.\n3.9 Военнослужащему запрещено использовать нецензурную брань, оскорблять, унижать кого-либо\n[В OOC и SMS включительно!].\n3.10 Военнослужащему запрещено содействовать любым преступным группировкам.\n3.11 Военнослужащему запрещено злоупотреблять своими служебными полномочиями.\n3.12 Военнослужащему запрещено превышать свои служебные полномочия.\n3.13 Военнослужащему запрещено самовольно менять подразделение.\n3.14 Военнослужащему запрещено самовольно менять каску\n[исключение: старшие офицеры, УСБ].\n3.15 Военнослужащему запрещено самовольно снимать каску, отключать маячок, надевать маску\n[исключение: старшие офицеры; УСБ, СОБР при спец. операции, ЧС в порту; СВСС при ЧС перед въездом в порт LS;\nВСБ - режим “стелс”. В части каждый военнослужащий обязан снимать маску вне зависимости от должности и звания].\n[Примечание: когда вы надели маску вы обязаны сообщить об этом в рацию следующим образом:")
  imgui.Text(u8"/r [tag] Отключаю маячок дистанционного слежения. Надел маску - порт ЧС(указать причину)]\n3.16 Военнослужащему запрещено подделывать удостоверение подразделений армии [УСБ, СОБР или старших офицеров].\n3.17 Военнослужащему запрещено спать [AFK] в неположенном месте более 120 секунд [2 минуты].\n3.18 Военнослужащему запрещено доставать и применять оружие за охраняемой территорией\n[исключение: самооборона, обязательно иметь док-ва].\n3.19 Военнослужащему запрещено улучшать навыки владения оружием\n[исключение: разрешение от старших офицеров, сотрудника УСБ, либо с 22:00 до 8:00].\n3.20 Военнослужащему запрещено проводить гражданских лиц, бандитов на территорию части.\n3.21 Военнослужащему запрещено использовать волну департамента, не по назначению.\n3.22 Военнослужащему запрещено находиться в увеселительных местах в рабочее время:\nказино, автоярмарка, гаражи, бар, клуб, мероприятия\n[исключение: УСБ для выполнения должностных обязанностей, мероприятия от администрации с телепортацией].\n3.23 Военнослужащему запрещено употреблять психотропные, наркотические вещества,\nа также находиться в алкогольном опьянении.\n3.24 Военнослужащему запрещено прыгать с вышек через заборы.\n3.25 Военнослужащему запрещено бегать вприпрыжку\n[исключение: погоня за нарушителем, который тоже бежит вприпрыжку].\n3.26 Военнослужащему запрещено раскрывать личность сотрудников ФБР, УСБ под прикрытием.\n3.27 Военнослужащему запрещено нарушать правила пользования военной техникой.\n[Разбрасывать где попало, подрезать и так далее].\n3.28 Военнослужащему запрещено нарушать федеральное постановление.\n3.29 Военнослужащему запрещено использовать личное/чужое ТС\n[исключение: старшие офицеры - могут использовать любой транспорт;")
  imgui.Text(u8"Кураторы взводов, УСБ, СОБР, УСБ - автомобиль Sultan, FBI Rancher, Huntley, Patriot, мотоциклы NRG-500, FCR-900 - чёрного цвета.\nСОБР - автомобиль Sultan, FBI Rancher, Huntley, мотоциклы NRG-500, FCR-900 - серого цвета, кураторы взводов - мотоцикл NRG-500].\n3.30 Военнослужащему запрещено использовать т/c Bobcat, Walton и подобное для перевозки состава.\n3.31 Военнослужащему запрещено бегать по вентиляционной трубе.\n3.32 Военнослужащему запрещено вести себя неадекватно.\n3.33 Военнослужащему запрещено находится на крышах зданий, расположенных на территории части.\n3.34 Военнослужащему запрещено, находясь на службе, иметь оружие, которого нет на оружейном складе Армии\n[исключение: разрешено M4, MP5, Desert Eagle, Парашют, ShotGun, Rifle, Тепловизор, Прибор ночного видения].\n3.35 Военнослужащему запрещено, в рабочее время проходить ежедневные квесты\n[исключение: Армейские].\n3.36 Военнослужащему запрещено, приезжать в часть в одежде бездомного [рваной, грязной].\n3.37 Военнослужащему запрещено нарушать правила строя [глава IV].\n3.38 Военнослужащему запрещено ломать кнопочную станцию на КПП / СКПП\n[исключение: погоня за фурой].\n3.39 Запрещается неподчинение старшему по званию и должности.\n3.40 Запрещается бездельничать и не выполнять свои служебные обязанности.\n3.41 Запрещается выезжать в патруль части/сопровождение в одиночку\n[исключение: УСБ, старшие офицеры].\n3.42 Военнослужащему запрещено, использовать огнестрельное оружие не по назначению.\n3.43 Военнослужащему запрещено, находится на вышках [исключение: ЧС армии].\n3.44 Военнослужащему запрещено нарушать установленный правилами дресс-код [глава XIII].\n3.45 Военнослужащему запрещено халатно относиться к своей руководящей должности и обязанностям.\n3.46 Военнослужащему запрещено нарушать приказы генерала.")
  imgui.Text(u8"3.47 Военнослужащему запрещено покидать часть на вертолёте без разрешения у диспетчера (УСБ, старшие офицеры)\n[исключение: УСБ, порт ЧС, игнорирование запроса].\n3.48 Военнослужащему, проходящему службу по контракту, запрещено обращаться по рации без префикса `CS`.")
  imgui.Text(u8"Глава IV. Правила строя.\n4.1 Созывать на общее построение военнослужащих могут только: старшие офицеры, АСВ;\n4.2 В строю обязаны находиться те военнослужащие, чьи взвода были указаны при построении;\n4.3 В строю запрещено:\n4.3.1 Без разрешения командира разговаривать, шептаться, использовать любые средства передачи информации\n[любые чаты: /sms, /call, /b, /r, /rb, /dep, /w и обычный];\n4.3.2 Активно жестикулировать, мешать товарищам\n[злоупотребление командами: /me, /do, /try, /animlist и другие];\n4.3.3 Использовать телефон [исключение: если сообщение направлено офицерам штаба или УСБ];\n4.3.4 Доставать оружие без приказа [исключение: равнение в строю, повороты в строю, приказ];\n4.3.5 Открывать огонь без приказа\n[исключение: разрешено стрелять по военным фурам, которые угоняют оборотни, а также при угрозе жизни];\n4.3.6 Спать [уходить в AFK более чем на 30 секунд];\n4.3.7 Самовольно покидать строй;\n4.3.8 Выполнять воинское приветствие;\n4.3.9 Разговаривать в строю [исключение: руководство армии].\n4.3.10 Использовать часы [исключение: фотофиксация].\n4.4 Перед тем как встать в строй, военнослужащий обязан пополнить боекомплект [100 hp и 100 armor].\n4.5 Военнослужащие, опаздывающие на построение,\nимеют право встать в строй не получая на это отдельное разрешение.\nЕсли вы опоздали на построение то, не нужно отвлекать строящего запросом на разрешения встать в строй.\nВы обязаны встать самостоятельно в конец строя без суеты и не мешая своим товарищам.")
  imgui.Text(u8"Глава V. Несение службы.\n5.1 Старшие офицеры имеют право самовольно покидать часть.\nСтаршие офицеры также имеют право отпускать бойцов за территорию части при необходимости.\n5.2 Военнослужащий обязан охранять пост, который ему доверили;\n5.3 Спать разрешено только в казарме рядом с койками [исключение: глава VI устава армии];\n5.4 Выходя из казармы, военнослужащий обязан надеть каску своего взвода или подразделения в соответствии с правилами ниже:\nСтаршие офицеры/офицеры штаба - Фуражка №21\nУСБ - Берет №32\nСОБР - Берет №30, №11.\nСВСС - Каска №29, 22\nВСБ - Каска №5, 3\nАСВ - Каска №19, 20\nКомандиры отрядов и взводов - Берет №12\nЗаместителей отрядов и взводов- Берет №8\nТренеры взводов - Берет №10\nПримечание: УСБ носят свои береты независимо от должности.\n5.5 Проснувшись дома или на вокзале, боец обязан в течении 10-ти минут явиться на территорию части.\nДанные 10 минут разрешается потратить исключительно на дорогу,\nникаких работ таксистом, водителем автобуса и т.д.;\n5.6 Если на службе нет командира взвода или его заместителя,\nкомандование этим взводом передается старшему бойцу взвода находящемуся в части;\n5.7 Вывозить бойцов в город разрешено только: старшим, УСБ, ВСБ, а также ком. составу взводов\n[для выполнения своих обязанностей];")
  imgui.Text(u8"Глава VI. Правила сна.\n6.1 Любой боец Army Las Venturas имеет право спать в казарме рядом с койками;\n6.2 Бойцы ВСБ имеют право спать в ангарах, не мешая проезду фурам;\n6.3 Бойцы отрядов УСБ, СОБР имеют право спать в внутри штаба неограниченное время;\n6.4 Старшие офицеры имеют право спать в любом месте;\n6.5 Бойцы УСБ имеют право спать на плацу, но не более чем 2 минуты [120 секунд].")
  imgui.Text(u8"Глава VII. Увольнительное время.\n7.1 Увольнительное время в будние дни начинается в 22:00 и заканчивается в 8:00,\nв пятницу и выходные дни начинается в 21:00 и заканчивается в 9:00;\n7.2 Бойцы, имеющие звание Мл.Сержант и выше, имеют право снять форму и отправиться в увольнительное время.\nРядовые и Ефрейторы так же продолжают нести службу в части;\n7.3 Если склады государственных организаций штата составляют менее 100.000 единиц,\nто увольнительное время ВСБ отменяется до того момента, пока склады не будут заполнены;\n7.4 Ком.состав взводов, старшие офицеры и бойцы армии, могут быть вызваны в часть с увольнительного времени;\n7.5 Отложить увольнительное время имеют право только старшие офицеры.")
  imgui.Text(u8"Глава VIII. Субординация/правила использование рации.\n8.1 Военнослужащие обязаны соблюдать субординацию в общении между собой;\n8.2 При согласии боец обязан отвечать: `Так точно, товарищ «Фамилия, Звание»!`,\nпри несогласии: `Никак нет, Товарищ «Фамилия, Звание»!`,\nесли боец получил приказ: `Есть, Товарищ «Фамилия, Звание»!`;\n8.3 Здороваясь с сослуживцами, боец обязан сказать: `Здравия желаю`\n[`салам`, `здорова` и т.п запрещены];\n8.4 Военнослужащий обязан ответить: ` я, товарищ `звание` ` когда его называет старший по званию;\n8.5 Если военнослужащего вызвали, то по прибытию он обязан доложить\n[Пример: `Генерал Касети, рядовой Иванов по вашему приказанию прибыл`];\n8.6 Спрашивая что-либо, военнослужащий должен сказать: ` Товарищ `звание`, разрешите обратиться` `;\n8.7 При поощрении военнослужащего он должен ответить: `Служу Армии Las Venturas!`;\n8.8 Военнослужащий обязан вежливо общаться с любым жителем штата;\n8.9 Военнослужащий обязан обращаться на `Вы` к своим сослуживцам\n[исключение: если должность и звание выше, то разрешается обращаться на `Ты`].\n8.10 При общении в рацию должны соблюдаться все вышеперечисленные правила;\n8.11 При общении по рации запрещено:\n8.11.1 Вести разговоры не связанные с несением службы [Оффтопить, флудить, метагейминг];\n8.11.2 Употреблять нецензурные выражения [в OOC и IC чат];\n8.11.3 Говорить без обозначения вашего взвода [пример: /r [ВАШ ВЗВОД]:].\n8.12 Военнослужащий обязан обращаться к старшим строго по званию\n[Пример: `Товарищ Генерал Касети, разрешите обратиться?`];\n8.13 Во время “радиомолчание” [ЧС рации] запрещено всем использовать рацию до снятие ЧС\n[исключение: рацией могут пользоваться старшие офицеры, УСБ].\n")
  imgui.Text(u8"Глава IX. Пропускной режим.\n9.1 На территорию части Las-Venturas Army разрешено пропускать:\nСенаторов;\n- Мэра и его заместителей\n[исключение: к пункту 9.1 - заместители Мэра при въезде на охраняемую территорию обязаны предоставить следующие документы]:\nДокумент подтверждающий личность.\nУдостоверение подтверждающее курирующую отрасль.\nДиректора ФБР и его заместителей;\nШерифов SAPD и их заместителей;\n- Генерала San-Fierro Army.\nОстальным государственным служащим на территории армии разрешено находиться\nпосле предупреждения по волне департамента и получения одобрения от\nстарших офицеров, либо старшего в части, на данный момент;\n9.2 Бойцы на посту обязаны докладывать в рацию о прибытии всех лиц в гражданской одежде на КПП и СКПП;\n9.3 Бойцы на посту имеют право проверять паспорта у всех въезжающих и выезжающих военнослужащих,\nдолжностных и гражданских лиц\n[исключение: сенаторы штата, старшие офицеры, колонна фур с боеприпасами];\n9.4 Запрещено выпускать с территории части солдат, которые не имеют разрешения на выезд от старших офицеров\n[исключение: пункт 9.5 устава армии];\n9.5 Для исполнения основных задач подразделения,\nбойцы СОБР, УСБ, СВСС, ВСБ, АСВ имеют право покинуть часть без разрешения старших офицеров;\n9.6 Въезд на территорию военной части на гражданском транспортном средстве строго запрещен\n[исключение: сенаторы штата, парковка автомобиля на территории части,\nсогласно главе XII устава армии];\n9.6.1 Лицам, указанным в пункте 9.1 устава армии, допускается въезд на территорию военной части\nна служебном транспорте исключительно в служебных целях;\n9.7 Все военнослужащие обязаны показывать паспорт на КПП и СКПП по прибытии в часть в гражданской форме\n[исключение: старшие офицеры];")
  imgui.Text(u8"9.8 Воздушное пространство Las-Venturas Army является закрытым\n[исключение: грузовые вертолеты SFa при поставке боеприпасов, а также лица, указанные в пункте 9.1 устава армии].\n9.9 Покинуть части воздушным путём разрешается только с разрешения диспетчера (УСБ, старших офицеров)\n[исключение: УСБ, порт ЧС, игнорирование запроса].")
  imgui.Text(u8"Глава X. Военный транспорт.\n10.1 Хаммеры, стоящие в ГВТ, разрешено брать бойцам: УСБ, СОБР, СВСС, ВСБ, АСВ,\nа также для сопровождения фур и патрулирования части;\n10.2 Офицерские джипы в ГВТ разрешено брать бойцам: УСБ, СОБР, АСВ,\nКом.составу взводов и отрядов [Командир, заместители, тренера];\n10.3 Офицерский джип у казармы разрешено брать: АСВ, для проведения лекций;\n10.4 Хаммера, стоящие у казармы, разрешено брать бойцам: УСБ, СОБР;\n10.5 Хаммера, стоящие в Штабе СОБР разрешено брать бойцам: УСБ, СОБР;\n10.6 Вертолеты за казармой разрешено брать бойцам: СОБР от 3-х человек; \n с оперативника; СВСС от 3-х человек, а также с разрешения старших офицеров;\n10.7 Грузовики снабжения разрешено брать бойцам: АСВ, УСБ, СОБР, ВСБ\n[исключение: ефрейтор и выше для помощи ВСБ с разрешения офицеров штаба];\n10.8 Автобусы разрешено брать по приказу старших офицеров для проведения мероприятий внутри армии, призывов;\n10.9 Самолёт Shamal имеют право брать: старшие офицеры, также любой боец с разрешения старших офицеров;\n10.10 Старшие офицеры имеют право брать любую технику армии;")
  imgui.Text(u8"Глава XI. Полномочия взводов/должностей.\n11.1 Взвод ВВО подчиняется всем вышестоящим взводам, а именно: АСВ, спец. отрядам и старшим офицерам;\n11.2 Взвода СВСС, ВВО и ВСБ находятся на одном уровне иерархии;\n11.3 Отряд специального назначения СОБР подчиняется: ген. штабу, УСБ;\n11.4 УСБ подчиняется: ген. штабу.\nНачальник УСБ подчиняется от полковника\nЗам.Начальника УСБ починяется от подполковника\nот Стажёра и до Ст.Оперативника подчиняются от майора.\n11.5 Любой боец Армии Las Venturas, договорившись с АСВ или старшими офицерами,\nмогут организовывать тренировки и строить армию для этих тренировок;\n11.6 Уполномоченные выдать дисциплинарное взыскание,\nво время наказания, обязаны руководствоваться таблицей наказаний и дисциплинарных взысканий;")
  imgui.Text(u8"Глава XII. Правила парковки.\n12.1 За нарушение правил парковки, боец может получить санкции в виде наряда, за повторные нарушения выговор;\n12.2 Рядовым и ефрейторам строго запрещено иметь ЛТС в части и прилегающей к ней территории;\n12.3 Бойцы, имеющие звание Мл.Сержант и выше обязаны парковаться на общей парковке вне части;\n12.4 Бойцы, состоящие в спец.отряде СОБР имеют право парковать ЛТС серого цвета,\nуказанные в пункте 3.29 для СОБР, на парковке справа от штаба;\n12.5 Бойцы, состоящие в спец.отряде УСБ, имеют право парковать ЛТС чёрного цвета,\nуказанные в пункте 3.29 для УСБ, в бункере;\n12.6 Бойцы, имеющие звание от Мл.Лейтенант до Капитан имеют право парковаться за Ангаром №2;\n12.7 Офицеры штаба имеют право парковаться только в бункере;\n12.8 Бойцы имеющие свой личный вертолёт обязаны парковать его\nна общей парковке вне части или рядом с ней. Вне зависимости от звания\n[исключение: УСБ можно припарковать вертолёт на холмике не далеко от своей парковки].\n12.9 Бойцы, состоящие в АСВ, имеют право парковать ЛТС белого цвета,\nуказанные в пункте 3.29, на парковке слева от казармы, у банкомата.;")
  imgui.Text(u8"Глава XIII. Дресс-код.\n13.1 Военнослужащий обязан носить форму установленной ниже правилами:\n13.1.1 Полевую форму №287 - разрешено носить всем военнослужащим армии.\n13.1.2 Черный костюм №255 - разрешено носить заместителям взводов.\n13.1.3 Синий костюм №61 - разрешено носить исключительно старшим офицерам.\n13.1.4 Специальная форма №179 - разрешено носить тренерам взводов и военнослужащим получившие краповый берет.\n13.1.5 Форма с камуфляжными штанами №73 - разрешено носить бойцам СВСС и ВСБ, АСВ;\n13.1.6 Форма №191 - предназначена для женского пола, независимо от должности и звания.\n13.2 Переодевшись в военную форму, военнослужащий обязан снять запрещенные ему аксессуары.\nСписок аксессуаров можно посмотреть на форуме.\n13.3 Аксессуары, не указанные в пункте 13.2 устава армии являются запрещенными для всех военнослужащих.")
  imgui.Text(u8"Глава XIV. Система выговоров.\n14.1 Выговоры для обычных бойцов.\n14.1.1 Выговоры делятся на выговор с отработкой и без отработки.\n14.1.2 Если боец получает выговор с отработкой\nон обязан попытаться его отработать.\n14.1.3 Если у бойца был 1 активный выговор и он получил еще один - боец\nпонижается на одну ступень за 2 активных выговора.\n14.1.4 Если у бойца были 2 активных выговора и он получил еще один - боец\nувольняется из армии за 3 активных выговора.\n14.2 Выговоры для старших офицеров\n14.2.1 Выговор старшему офицеру в праве выдать только Нач.Ген.Штаба и Генерал.\nИсключение: администрация, FBI.\n14.2.2 Выговоры у старших офицеров не имеют сроков, выговор может\nснять только Генерал армии по итогам работы старшего офицера за неделю.\n14.2.3 За незначительные нарушения старшему офицеру выдается устное предупреждение.\n14.2.4 Если старший офицер получает 2 устных предупреждения ему автоматически выдается выговор.\n14.2.5 Если у старшего офицера набирается 2 активных выговора он покидает свой пост и понижается до Капитана.\n14.2.6 Сотрудник/боец имеющий активный выговор, в праве взять неактив/отпуск,\nно срок выговора сдвигается до окончания срока неактива/отпуска.\n")
  imgui.Text(u8"                                                                                              Федеральное постановление")
  imgui.Text(u8"\nВступительная часть.\n0.1. Федеральное Постановление — это нормативно-правовой акт, который был призван внести\nчёткие рамки в работу государственных организаций.\nФедеральное постановление — это нормативно-правовой акт,\nкоторый обладает высшей юридической силой наравне с\nКонституцией штата и превосходит по значимости уставы полицейских департаментов и армий.\n0.2. Федеральное Постановление издаётся Федеральным Бюро Расследований для Полицейских и Армий.\n0.3. Федеральное Постановление может быть изменено Директором ФБР\n[ при участии следящего администратора ]\nв любое время дня и ночи, его вступление в силу происходит через 48 часов после публикации.\n0.4. Федеральное Постановление обязано выполняться всеми сотрудниками вышеупомянутых организаций.\n0.5. Незнание Федерального Постановления не освобождает обвиняемого от ответственности.")
  imgui.Text(u8"Глава №1.\nПреступления против общественности.\n1.1. Запрещается несанкционированное применение огнестрельного оружия против любого\nгражданского лица / сотрудника государственных организаций — понижение / увольнение.\nПримечание: за санкционированное применение подразумевается использование при самообороне,\nневыполнении законных требований полиции. Данное примечание не распространяется на зеленые зоны.\n1.2. Запрещается любое унижение чести и достоинства граждан независимо\nот его социального или правового статуса — увольнение.\n1.3. Запрещается применение насилия в отношении как граждан,\nтак и заключенных под стражу лиц — понижение / увольнение.\nГлава №2.\nПостановление в отношении сотрудников Федерального Бюро Расследований и Мэрии.\n2.1. Запрещается проникать на территорию FBI без получения официального пропуска\nот любого из агентов ФБР выше Мл.Агента — выговор / понижение.\nПримечание: Губернатору, Генералам армий, Шерифам разрешение не требуется.\n2.2. Запрещается выдавать себя за любого государственного сотрудника — понижение / увольнение.\nИсключение: агенты ФБР во время ведения следственных действий под прикрытием.\n2.3. Запрещается брать руководство операциями\n[ теракты / похищения / иная работа под руководством ФБР ]\nбез приказа ФБР — увольнение.\n2.4. Запрещается неподчинение агенту ФБР в рамках его законных требований — понижение / увольнение.\nИсключение: агенты ФБР во время ведения следственных действий под прикрытием.\n2.5. Запрещается угрожать / шантажировать агента ФБР — увольнение.\n2.6. Запрещается оспаривать понижение / увольнение, выданное агентом ФБР / Губернатором где-либо,\nкроме как в специальном разделе жалоб — понижение / увольнение.\n2.7. Запрещается раскрывать личность агента ФБР, если тот находится под прикрытием — увольнение.\nПримечание: если агент ФБР находится во внедрении через команду /spy, а не через маскировку,\nто данный пункт не отменяет наказания за его нарушение.\nНе важно в каком чате будет написана информация, которая привела к раскрытию агента.\n2.8. Запрещается вносить помехи в работу аттестационной комиссии от высших органов власти,\nпроводящих любого рода проверки в государственных структурах — выговор / понижение.\nПримечание: запрещено подсказывать сотрудникам любыми способами, будь-то IC, будь-то OOC. [ /r, /rb, /ticket ]\n2.9. Запрещается избегать проверки от ФБР — понижение / увольнение.\nПримечание: агент имеет право вас вызвать в бюро и провести проверку.\nПри отказе последует соответствующее наказание согласно пункту.\n2.10. Запрещено применять санкции по отношению к агентам ФБР при исполнении\n[ штрафы, объявление в розыск ],\nа также вносить помеху в работу сотрудникам федерального бюро — выговор / понижение.\nПримечание: агент в маскировке не является агентом при исполнении.")
  imgui.Text(u8"Глава №3.\nПостановление в отношении Полицейских Департаментов и Армий.\n3.1. Запрещаются любые проявления неадекватного поведения — выговор / понижение / увольнение.\nПримечание: под неадекватным поведением подразумевается прыжки гос. служащим по автомобилям,\nнамеренное выталкивание авто на дорогу и иные нарушения законов штата,\nкоторые приводят в совокупность нарушений нескольких пунктов Федерального Постановления\n3.2. Запрещается нарушать правила строя — выговор.\nПримечание: также под этим подразумевается беспричинное и беспочвенное использование команды /time,\nанимации и прочие телодвижения.\n3.3. Запрещается продажа любого государственного имущества\n[ ключи от камер/форма/фуры с боеприпасами ] — увольнение + ЧС фракции.\n3.4. Запрещается давать заведомо ложную информацию государственному сотруднику — выговор / понижение / увольнение.\nПримечание: под дачей ложных показаний подразумевается любая выдуманная/сокрытая информация,\nкоторую запрашивает государственный сотрудник.\n3.5. Запрещается необоснованно требовать документы,\nа так же проводить обыск гражданских лиц — выговор / понижение.\n3.6. Запрещается государственным сотрудникам входить в сговоры с мафией/бандами — увольнение.\nИсключение: спец. операции [ обязательный контроль старшего офицера ].\n3.7. Запрещается без разрешения / пропуска [ самовольно ] покидать часть / свой\nгород — выговор / понижение / увольнение.\nПримечание: нахождение в нейтральной зоне не является нарушением данного пункта федерального постановления.\n3.8. Запрещается носить форму не соответствующую занимаемой должности / званию — выговор / понижение.\nПримечание: соответствие формы и званий устанавливается руководителем организации.\n3.9. Запрещается в рабочее время носить на себе вызывающие аксессуары — выговор / понижение.\nПримечание: под вызывающими аксессуарами подразумевается ярко выраженные предметы на теле гос. служащего.\nРазрешены строгие очки, часы, чёрные повязки на лицо. Так же разрешены аксессуары,\nсоответствующие подразделению гос. служащего [ береты, ковбойские шляпы ].\n3.10. Запрещено умышленно удалять с базы данных розыска без уведомления ФБР — выговор / понижение / увольнение.\nДополнение: Если вы ошиблись и можете доказать свою невиновность, вы должны сообщить об этом в департамент.")
  imgui.Text(u8"Глава №4.\nПреступления государственных сотрудников против норм Устава, и других правовых документов.\n4.1. Запрещается выдавать розыск и(или) выписывать штраф без весомой на то причины, по просьбе.\nИными словами - не видя факта нарушения лично — выговор / понижение / увольнение.\n4.2. Запрещается провоцировать кого-либо, не важно, какого рода провокации — выговор / понижение / увольнение.\n4.3. Запрещается использовать нецензурную брань, а также оскорбления — выговор / понижение / увольнение.\nПримечание: по данному пункту рассмотрению подлежат жалобы/обращения, в случае,\nесли сотрудник находился при исполнении и/или текст относился к\nпрофессиональной деятельности.\nНарушение этого пункта одинаково распространяется как на IC так и на OOC чаты [ смс, /fb, /f. ].\n4.4. Запрещается в рабочее время заниматься своими делами в рабочее время,\nустановленное уставом соответствующей организации\n[ игра в казино, участие в пейнтболе, base jump, дерби, и другие мероприятия в развлекательном центре.\nВ том числе запрещены посещения автоярмарки и аукционных\nгаражей. ] — выговор / понижение / увольнение.\nИсключение: мероприятия от администрации [ со скрином телепорта ],\nисполнение служебных обязанностей [ охрана авторынка, проверка вышеупомянутых мест\nбойцами спец.отрядов армий и ст. офицеров ], обед с 13:00 до 14:00 [ форму необходимо снять ],\nразрешение руководства, ст. офицеры.\nПримечание: руководство департамента или армии не имеет права выдавать разрешение на посещение\n[ с целью игры ]\nв казино и аукционных гаражей и не имеет право в рабочее время посещать [ с целью игры ] их самостоятельно.\n4.5. Запрещается хранение и употребление наркотических веществ, а также хранение краденых материалов.")
  imgui.Text(u8"Под эту статью попадает хранение вышеперечисленных материалов в сейфе. — увольнение.\nИсключение: Сотрудники PD, сотрудники ФБР в целях спец. операций [ с обязательным контролем старшего офицера ].\n4.6. Запрещается находиться в опасном районе вне спец. операций — выговор / понижение / увольнение.\nИсключение: федеральный патруль,специальные отделы [ обязательный контроль со стороны руководства организации ].\n4.7. Запрещается объявлять в розыск не по уголовному кодексу — выговор / понижение.\n4.8. Запрещается неподчинение старшему по званию в рамках закона — выговор / понижение.\nИсключение: Старшие по званию - в рамках одной организации.\n4.9. Запрещается употреблять алкоголь в рабочее время — понижение.\n4.10. Запрещается брать / давать взятки — увольнение.\nПримечание: разрешается отыгровка Bad Cops.\nОна должна быть с предварительным снятием всех нашивок и надеванием маски с фиксацией\n[ screen & /time ].\nВ случае если вас успели задержать и снять маску - привлекаетесь по указанной статье Федерального постановления.\n4.11. Запрещается нарушать правила волны департамента — выговор / понижение.\nПримечание: руководство гос.организацией обязано оповещать прибывших работников\nна работу о положении ЧС по волне департамента, данный пункт\nраспространяется даже на тех, кто «не знал» что волна на ЧС.\nНарушением данной статьи ФП являются сообщения следующего содержания: «OG, не реагируем», «учтем\nпри понижении», а также сообщения про еду в неформальном контексте «накормите печеньками»,\n«дайте еды», «накормите пончиками».\n4.12. Запрещается беспричинно обыскивать государственных сотрудников — выговор / понижение.\nПримечание: в случае, если обыскивается агент под прикрытием/маскировкой,")
  imgui.Text(u8"который себя не раскрыл по собственным причинам — офицер полиции не будет привлечён к ответственности.\n4.13. Запрещается лишать лицензии без весомых на то причин — компенсация стоимости лицензий за счёт\nотобравшего офицера с вынесением доп. санкции — выговор / понижение.\nПримечание: если Вы увидели, что государственный сотрудник нарушил правила дорожного движения\nили в гражданской форме УК [ где предусматривается изъятие лицензии ],\nи у Вас есть доказательства, Вы имеете полное право забрать лицензию.\n4.14. Запрещается нарушать субординацию при общении со старшими по званию — выговор / понижение.\n4.15. Запрещается убийство в наручниках или эффектом электрошокера — понижение / увольнение.\nПримечание: разрешено использовать электрошокер в перестрелке, если она началась в Зелёной Зоне\nи у вас есть доказательства.\n4.16. Запрещается нарушать законы штата, а именно: уголовный кодекс и административный кодексы,\nконституция, уставы ПД / Армий и другие правила установленные какими-либо\nправовыми актами — выговор / понижение / увольнение.\nИсключение: если у Вас есть доказательства, подтверждающие вашу полную либо частичную\nневиновность по фактам: самообороны себя и близких; защиты личного имущества;\nпри выполнении служебного долга, но находясь не при исполнении служебных обязанностей [ не в форме ];\nприказ старшего по званию в рамках закона.\n4.17. Запрещается неподчинение руководящему составу ФБР — понижение / увольнение.\n4.18. Запрещается неподчинение Губернатору в рамках закона Штата Evolve — понижение / увольнение.\n4.19. Запрещается отдавать приказы Губернатору — увольнение.\n4.20. Запрещается отдавать приказы сотрудникам ФБР — понижение / увольнение.")
  imgui.Text(u8"4.21. Запрещено надевать маску не находясь на спец.операции/на облаве или заезде/отбивании/защите порта.\nРазрешено надеть маску по приказу агента ФБР с наличием доказательств. — выговор / понижение.\nПримечание: носить маску в участке [ в гараже ] также запрещено.\nПри злоупотреблении данным пунктом следует наказание за превышение должностных полномочий.\n4.22. Запрещается использовать личное транспортное средство в служебных целях и ситуациях,\nне предусмотренных действующим уставом гос.организации. — выговор.\nПримечание: данный пункт относится в первую очередь к армиям.\nИспользовать личный транспорт могут спец. подразделения и Старший Офицерский состав армий,\nГлавы и выше ФБР.\n4.23. Запрещается превышать свои должностные полномочия — понижение / увольнение.\n4.24. Запрещается объявлять в розыск подозреваемого/преступника если на нем надета маска — выговор / понижение.\nИсключение: Подозреваемого удалось задержать [ обездвижить тайзером или наручниками ],\nв таком случае розыск выдается независимо от того, в маске он или нет.\nДопускается также выдача розыска в случае непосредственного контакта с подозреваемым без маски до погони\n[ т.е. возможность разглядеть лицо, наличие доказательств с /time обязательно ].\n4.25. Запрещается нарушать общие правила полиции — выговор / понижение / увольнение.\n4.26. Запрещено бездействие / неисполнение обязанностей по оказанию помощи лицам,\nнаходящимся в опасной ситуации, по предотвращению нанесения ущерба имуществу. — выговор / понижение / увольнение.\n4.27. Запрещается производить арест сотрудника AF, а также всех лидеров государственных структур\nи их заместителей в рабочее и выходное время без одобрения FBI — выговор / понижение.")
  imgui.Text(u8"Примечание: В случае, если по запросу в департамент никто не дает ответ в течение 5 минут,\nто разрешается арест и без одобрения FBI, НО с обязательной фиксацией запроса.\n4.28. Запрещается нарушать правила посещения Мэрии,\nа также воспрепятствовать законной деятельности министров и вице-губернаторов,\nигнорировать их требования, указанные в законе «О работе мэрии» — выговор / понижение.\n4.29. Запрещается использовать мегафон в личных целях,\nа именно в различных переговоров с друзьями,\nшутки и всякий бред, не относящийся к рабочим моментам — выговор / понижение.\nПримечание: [ Примеры — «Эй, бро, как дела?» & «Пойдем покатаемся?» ] — так делать нельзя!")
  imgui.Text(u8"Глава №5.\n5.1. Сотрудник ФБР имеет право сменить наказание на дисциплинарное взыскание в виде предупреждения\nлибо иное наказание не предусмотренное пунктами\nнастоящего бюро при смягчающих обстоятельствах.\nСмягчающим обстоятельством является раскаяние гос. служащего в содеянном нарушении,\nлибо конструктивная аргументация своих действий\nс подкреплением доказательств своим аргументам.\n5.2. Сотрудник Армии или ПД обязан сделать выводы о своей вине и постараться более не нарушать ФП.\n5.3. Смена наказания осуществляется агентом ФБР, исходя из его здравого смысла и опыта.\nВыдача предупреждений за пункты, которые так или иначе способны пошатнуть государственную безопасность - запрещены.\n5.4. Сотрудник имеет право получить только одно предупреждение,\nпри последующих нарушениях следуют более тяжкие наказания.\n5.5. Пункты, предусматривающие выбор вида наказания,\nподразумевают применение одного из них по усмотрению выдающего наказание,\nв зависимости от тяжести нарушения и наличия активных предупреждений,\nлибо нарушений в прошлом.\n5.6. Неординарные ситуации. В случае совершения государственным сотрудником деяния,\nкоторое можно счесть за косвенное нарушение той или иной статьи одного из\nнормативно-правовых актов, руководящий состав ФБР имеет право применить\nлюбой из действующих пунктов законодательных баз, ссылаясь при этом на ФП.")
  imgui.Text(u8"Глава №6.\nПолномочия агентов ФБР.\n6.1. Дежурный FBI и выше имеет право отдать приказ бойцам армии до звания Капитан и офицерам полиции до звания\nКапитан включительно при ЧС [ теракте/похищение ].\n6.2. Агент DEA/CID имеет право отдать приказ бойцам армии до звания\nПрапорщик и офицерам полиции до звания Ст.Прапорщик включительно.\n6.3. Глава DEA/CID имеет право отдать приказ бойцам армии до звания\nМайор и офицерам полиции до звания Майор включительно.\n6.4. Инспектор FBI имеет право отдать приказ бойцам армии до звания \nПодполковник и офицерам полиции до звания Подполковник включительно.\n6.5. Зам. Директора FBI имеет право отдать приказ бойцам армии до звания\nПолковник и офицерам полиции до звания Полковник включительно.\nПримечание: В случаях, когда Директора ФБР нет на рабочем месте [ не в игре/выходной ],\nЗаместитель Директора ФБР имеет право отдать приказ любому сотруднику силовых структур.\n6.6. Директор FBI имеет право отдать приказ бойцам армии до звания\nГенерал и офицерам полиции до звания Шериф включительно.")
  imgui.Text(u8"Глава №7.\nВиды санкций для государственных структур.\n7.1. Санкции, перечисленные ниже в данной главе являются едиными.\nЛюбая другая санкция, выданная не по данным правилам не наделяется юридической силой.\n7.2. Сотрудник ПД/Армии может получить санкцию в виде предупреждения\nза нарушение Федерального постановления / внутреннего устава организации.\n7.3. Сотрудник ПД/Армии может получить санкцию в виде наряда за нарушение\nФедерального постановления / внутреннего устава организации.\n7.4. Сотрудник ПД/Армии может получить санкцию в виде обычного выговора на 7 дней за нарушение\nФедерального постановления / внутреннего устава организации.\n7.5. Сотрудник ПД/Армии может получить санкцию в виде строгого выговора на 14 дней с\nпропуском повышения за нарушение Федерального постановления / внутреннего устава организации.\n7.6. Сотрудник ПД/Армии может получить санкцию в виде понижения за нарушение\nФедерального постановления / внутреннего устава организации.\n7.7. Сотрудник ПД/Армии может получить санкцию в виде увольнения за нарушение\nФедерального постановления / внутреннего устава организации.")
  imgui.End()
end

function nyamnyam()
  local result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
  if result then
    local animid = sampGetPlayerAnimationId(id)
    if animid == 536 then
      sampSendChat("Ням ням.")
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

function kvadrat() local KV = { [1] = "А", [2] = "Б", [3] = "В", [4] = "Г", [5] = "Д", [6] = "Ж", [7] = "З", [8] = "И", [9] = "К", [10] = "Л", [11] = "М", [12] = "Н", [13] = "О", [14] = "П", [15] = "Р", [16] = "С", [17] = "Т", [18] = "У", [19] = "Ф", [20] = "Х", [21] = "Ц", [22] = "Ч", [23] = "Ш", [24] = "Я", } local X, Y, Z = getCharCoordinates(playerPed) X = math.ceil((X + 3000) / 250) Y = math.ceil((Y * - 1 + 3000) / 250) Y = KV[Y] local KVX = (Y.."-"..X) return KVX end 