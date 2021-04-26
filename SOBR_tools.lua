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
local t_se_au_to_clist, k_r_u_t_o, a_u_t_o_tag, a_u_t_o_screen, m_s_t_a_t, s_kin_i_n_lva, priziv, lwait, svscreen, ofeka, pokazatel, sdelaitak = "config/SOBR tools/config.ini"
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
        Tag = "Не указан.",
        cvetclist = "Не указан.",
        lwait = "Не указана",
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
    ofeka = cfg.global.ofeka
    pokazatel = cfg.global.pokazatel
    sdelaitak = cfg.global.sdelaitak
    pInfo.cvetclist = cfg.global.cvetclist
    settings = cfg
    CreateFileAndSettings()
  end

    sampRegisterChatCommand("supd", goupdate)

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
          sampSendChat("/r "..pInfo.Tag.." 10-100, определённое время.")
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
      if testCheat("PP") then submenus_show(SSSDialog, "{808080}SOBR tools by Tarasov{FFFFFF}") end
      if isKeyJustPressed(VK_L) and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() and settings.global.k_r_u_t_o == true then sampSendChat("/lock") end
      if priziv == true and testCheat("Z") then submenus_show(LVDialog, "{00FA9A}ПРИЗЫВ{FFFFFF}") end
      if sampIsChatInputActive() and sampGetChatInputText() == "/cfaq" then sampSetChatInputText("") sampShowDialog(1285, "{808080}[SOBR tools] Команды{FFFFFF}", "{808080}/aclist - выключить/включить автоклист\n/lp - выключить/включить открывание авто на клавишу `L`\n/atag - выключить/включить авто-тег\n/ascreen - выключить/включить авто-скрин после пэйдея\n/sw, /st - сменить игровое время/погоду\n/cc - очистить чат\n/kv - поставить метку на квадрат\n/getm - показать себе мониторинг, /rgetm - в рацию\n/przv - включить/выключить режим призыва\n/abp - выключить/включить авто-БП на `alt`\n/hphud - включить/отключить хп худ\n/abp - включить настройки авто-БП\n/splayer - включить/выключить отображение в чате ников военных которые появились в зоне стрима{FFFFFF}", "Ладно", "Прохладно", 0) end
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
      title = "{808080}Завербовать в отряд{FFFFFF}",
      onclick = function()
        sampShowDialog(9999, "Завербовать кого-то", "{b6b6b6}Введите ID игрока которого хотите завербовать", "ОК", "Закрыть", 1)
        while sampIsDialogActive() do wait(0) end
        local result, button, item, input = sampHasDialogRespond(9999)
        if result and button == 1 then
          local args = split(input, ",")
          if sampIsPlayerConnected(args[1]) then
            sampSendChat("/r "..pInfo.Tag.." "..sampGetPlayerNickname(args[1]):gsub("_", " ").." завербован в спец.отряд СОБР.")
          else sampShowDialog(9999, "{CD5C5C}SOBR tools |{FFFFFF} Ошибка", "{b6b6b6}Игрока с ID {B22222}"..args[1].."{b6b6b6} не существует.", "Блин", "Ок", 0) end
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
                if settings.global.lwait ~= nil then
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
                if settings.global.lwait ~= nil then
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
                if settings.global.lwait ~= nil then
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
                if settings.global.lwait ~= nil then
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
                if settings.global.lwait ~= nil then
                  if settings.global.m_s_t_a_t == true then
                    sampAddChatMessage("[SOBR tools]: Старт отыгровки. Для отмены нажмите CTRL+R.", 0x33AAFFFF)
                    wait(200)
                    sampSendChat("do Медицинская сумка на плече.")
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
                    sampSendChat("do Медицинская сумка на плече.")
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
                if settings.global.lwait ~= nil then
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
                if settings.global.lwait ~= nil then
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
                if settings.global.lwait ~= nil then
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
                if settings.global.lwait ~= nil then
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
                if settings.global.lwait ~= nil then
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
                if settings.global.lwait ~= nil then
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
                if settings.global.lwait ~= nil then
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
                if settings.global.lwait ~= nil then
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
      title = "{808080}Позывные напарников{FFFFFF}",
      onclick = function()
        sampShowDialog(1298, "{808080}[SOBR tools] Позывные{FFFFFF}", "{808080}Molly Asad - Атланта\nAnton Amurov - Мура\nLeo Florenso - Пена\nVolodya Lipton - Свен\nTim Vedenkin - Морти\nAdam Walter - Вольт\nSativa Johnson - Боба\nMaksim Azzantroph - Лоли\nJack Lingard - Барон\nAnatoly Morozov - Беркут\nHoward Harper - Деанон\nIgor Chabanov - Филин\nValentin Molo - Крот\nBrain Spencor - Волк\nKevin Spencor - Гром\nBogdan Nurminski - Сталкер\nAleksey Tarasov - Зверь\nMaksim Dinosower - Сняряд{FFFFFF}", "Ок", "Не ок", 0)
      end
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
        }
      }
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
              thisScript():reload()
            else
              sampAddChatMessage("[SOBR tools]: Автоскрин после пэйдея был включен.", 0x33AAFFFF)
              settings.global.a_u_t_o_screen = true
              thisScript():reload()
            end
          end
        },
        {
          title = "{808080}Выключить/включить функцию `Рация на зарядке`{FFFFFF}",
          onclick = function()
            if settings.global.ofeka == true then
              sampAddChatMessage("[SOBR tools]: Функция `Рация на зарядке` была отключена.", 0xFFB22222)
              settings.global.ofeka = false
            else
              sampAddChatMessage("[SOBR tools]: Функция `Рация на зарядке` была включена", 0x33AAFFFF)
              settings.global.ofeka = true
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

function e.onPlayerStreamIn(id, _, model)
  if settings.global.sdelaitak == true then
    local name = sampGetPlayerNickname(id)
    if model == 287 or model == 191 or model == 179 or model == 61 or model == 255 or model == 73 then
      sampAddChatMessage("[SOBR tools]: Боец "..name.." появился в зоне прорисовки.", 0x33AAFFFF)
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

function e.onServerMessage(color, text)
  if (text:find("КЛИЕНТ БАНКА SA")) and settings.global.a_u_t_o_screen == true then
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
  sampAddChatMessage("Обновление успешно загружено.", 0xFFB22222)
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
    thisScript():reload()
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
		sampAddChatMessage("[SOBR tools] Желаемый комплект боеприпасов был взят.", 0xFFB22222)
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