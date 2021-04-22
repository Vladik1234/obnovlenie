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
local t_se_au_to_clist, k_r_u_t_o, a_u_t_o_tag, a_u_t_o_screen, m_s_t_a_t, s_kin_i_n_lva, priziv, lwait, svscreen, hepehud, rusispr, ofeka, pokazatel, sdelaitak = "config/SOBR tools/config.ini"
local sdopolnitelnoe = true
local autoON = true
local marker = nil
local checkpoint = nil
local key = 99 
local shrift = "Segoe UI"
local size = 10 
local flag = 13 
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
if autoON then run = true end
weapons = {}
weapons[30] = 130
weapons[31] = 70
weapons[24] = 35
weapons[23] = 100
weapons[25] = 35
weapons[27] = 30
weapons[26] = 25
weapons[28] = 25
weapons[29] = 60
weapons[33] = 100
weapons[34] = 220
weapons[22] = 25

encoding.default = "CP1251"
local UTF8 = encoding.UTF8

local pInfo = {
  Tag = "Tag:",
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
local FADialog = {}
local STREAMSDialog = {}

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
    hepehud = cfg.global.hepehud
    rusispr = cfg.global.rusispr
    ofeka = cfg.global.ofeka
    pokazatel = cfg.global.pokazatel
    sdelaitak = cfg.global.sdelaitak
    settings = cfg
    CreateFileAndSettings()
    sampAddChatMessage("[SOBR tools]: Скрипт успешно загружен.", 0xFFB22222)
  end

    sampRegisterChatCommand("sicmd",function() if settings.global.rusispr == true then sampAddChatMessage("[SOBR tools]: Автоисправление ошибочных команд отключено.", 0xFFB22222) settings.global.rusispr = false else sampAddChatMessage("[SOBR tools]: Автоисправление ошибочных команд включено.", 0x33AAFFFF) settings.global.rusispr = true end end)

    sampRegisterChatCommand("hphud",function() if settings.global.hepehud == true then sampAddChatMessage("[SOBR tools]: ХП худ отключён.", 0xFFB22222) thisScript():reload() settings.global.hepehud = false else sampAddChatMessage("[SOBR tools]: ХП худ включён.", 0x33AAFFFF) settings.global.hepehud = true end end)

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
      wait(0)
        if settings.global.hepehud == true then 
          hphud()
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
        if sampGetPlayerColor(id) == 4283536973 and settings.global.t_se_au_to_clist == true and getCharModel(PLAYER_PED) == 287 or getCharModel(PLAYER_PED) == 191 or getCharModel(PLAYER_PED) == 179 or getCharModel(PLAYER_PED) == 61 or getCharModel(PLAYER_PED) == 255 or getCharModel(PLAYER_PED) == 73 then 
          wait(1000)
          sampSendChat("/clist 31")
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
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/ыьы" then sampSetChatInputText("/sms") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/к" then sampSetChatInputText("/r") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/а" then sampSetChatInputText("/f") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/ки" then sampSetChatInputText("/rb") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/аи" then sampSetChatInputText("/fb") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/в" then sampSetChatInputText("/d") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/пщм" then sampSetChatInputText("/gov") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/штмшеу" then sampSetChatInputText("/invite") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/гтштмшеу" then sampSetChatInputText("/uninvite") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/ьуьиукы" then sampSetChatInputText("/members") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/щааьуьиукы" then sampSetChatInputText("/offmembers") end 
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/пшмукфтл" then sampSetChatInputText("/giverank") end 
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/щаапшмукфтл" then sampSetChatInputText("/offgiverank") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/аьгеу" then sampSetChatInputText("/fmute") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/аашчсфк" then sampSetChatInputText("/ffixcar") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/ь" then sampSetChatInputText("/m") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/цфкурщгыу" then sampSetChatInputText("/warehouse") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/сфкь" then sampSetChatInputText("/carm") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/сфьукф" then sampSetChatInputText("/camera") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/сфьукфщаа" then sampSetChatInputText("/cameraoff") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/кфь" then sampSetChatInputText("/ram") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/ид" then sampSetChatInputText("/bl") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/fи" then sampSetChatInputText("/fb") end
      if sampIsChatInputActive() and settings.global.rusispr and sampGetChatInputText() == "/rи" then sampSetChatInputText("/rb") end
      if priziv == true and testCheat("Z") then submenus_show(LVDialog, "{00FA9A}ПРИЗЫВ{FFFFFF}") end
      if sampIsChatInputActive() == true and sampGetChatInputText() == "forum" then sampSetChatInputText("") submenus_show(FORDialog, "{00FA9A}Evolve Role Play - Сообщество{FFFFFF}") end
      if sampIsChatInputActive() and sampGetChatInputText() == "/streamsettings" then sampSetChatInputText("") submenus_show(STREAMSDialog, "{00FA9A}Настройка функции `Игрок в стриме`{FFFFFF}") end
      if sampIsChatInputActive() and sampGetChatInputText() == "/cfaq" then sampSetChatInputText("") sampShowDialog(1285, "{808080}[SOBR tools] Команды{FFFFFF}", "{808080}/aclist - выключить/включить автоклист\n/agclist - выключить/включить авто-седьмой клист на гражданке\n/lp - выключить/включить открывание авто на клавишу `L`\n/atag - выключить/включить авто-тег\n/ascreen - выключить/включить авто-скрин после пэйдея\n/sw, /st - сменить игровое время/погоду\n/cc - очистить чат\n/kv - поставить метку на квадрат\n/getm - показать себе мониторинг, /rgetm - в рацию\n/przv - включить/выключить режим призыва\n/abp - выключить/включить авто-БП на `alt`\n/sicmd - включить/выключить автоисправление русских команд\n/hphud - включить/отключить хп худ\n/abp - включить настройки авто-БП\n/splayer - включить/выключить отображение в чате ников военных которые появились в зоне стрима{FFFFFF}", "Ладно", "Прохладно", 0) end
    end
  end

function refreshDialog()
  SSSDialog = {
  
    {
      title = "{20B2AA}Рация и доклады{FFFFFF}",
      submenu = {
        title = "{20B2AA}Рация и доклады{FFFFFF}",
        {
          title = "{00FA9A}Подьезжаем к СКПП, открывайте{FFFFFF}",
          onclick = function()
            sampSendChat("/r "..pInfo.Tag.." Подьезжаем к СКПП, открывайте.")
          end
        },
        {
          title = "{00FA9A}Взятие фуры{FFFFFF}",
          onclick = function()
            if m_s_t_a_t == true then
                sampSendChat("/r "..pInfo.Tag.." Взял грузовик снабжения.")
            else
                sampSendChat("/r "..pInfo.Tag.." Взяла грузовик снабжения.")
            end
          end
        },
        {
          title = "{20B2AA}Заканчиваю поставки{FFFFFF}",
          onclick = function()
            sampShowDialog(9999, "{CD5C5C}SOBR tools {FFFFFF} Конец поставок:", "{b6b6b6}Введите литраж.\nОбразец: {FFFFFF}20", "ОК", "Закрыть", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              local args = split(input, ",")
                args[1] = args[1]:gsub(" ", "")
                sampSendChat("/r "..pInfo.Tag.." Заканчиваю поставки, литраж: "..args[1]..".")
            end
          end
        },
        {
          title = "{00FA9A}Разгрузились на складе{FFFFFF}",
          onclick = function()
            sampShowDialog(9999, "{CD5C5C}SOBR tools {FFFFFF} Разгрузка:", "{b6b6b6}Введите фракцию, затем тонны.\nОбразец: {FFFFFF}SFA, 133", "ОК", "Закрыть", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              local args = split(input, ",")
                args[1] = args[1]:gsub(" ", "", 1)
                args[2] = args[2]:gsub(" ", "")
                sampSendChat("/r "..pInfo.Tag.." Разгрузились на складе "..args[1]..", "..args[2].."т.")
            end
          end
        },
        {
          title = "{20B2AA}Выехали с базы{FFFFFF}",
          onclick = function()
            sampShowDialog(9999, "{CD5C5C}SOBR tools {FFFFFF} Выехали с базы:", "{b6b6b6}Введите состав.\nОбразец: {FFFFFF}3", "ОК", "Закрыть", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              local args = split(input, ",")
                args[1] = args[1]:gsub(" ", "")
                sampSendChat("/r "..pInfo.Tag.." Выехали с базы. Состав фур: "..args[1]..".")
            end
          end
        },
        {
          title = "{20B2AA}Обьявить о сдачи экзамена и переведении в основной состав{FFFFFF}",
          onclick = function()
            sampShowDialog(9999, "Обьявить", "{b6b6b6}Введите ID игрока который прошёл экзамен", "ОК", "Закрыть", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              local args = split(input, ",")
              if sampIsPlayerConnected(args[1]) then
                sampSendChat("/r "..pInfo.Tag.." "..sampGetPlayerNickname(args[1]):gsub("_", " ").." сдал все экзамены и был переведен в основной состав.")
              else sampShowDialog(9999, "{CD5C5C}SOBR tools |{FFFFFF} Ошибка", "{b6b6b6}Игрока с ID {B22222}"..args[1].."{b6b6b6} не существует.", "Блин", "Ок", 0) end
            end
          end
        },
        {
          title = "{00FA9A}Выдать наказание в виде наряда{FFFFFF}",
          onclick = function()
            sampShowDialog(9999, "{CD5C5C}SOBR tools |{FFFFFF} Выдать наряд кому то", "{b6b6b6}Ввеите id игрока, затем кол-во кругов и причину\n\nОбразец: {FFFFFF}500, 10, прыжки по части", "ОК", "Закрыть", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              local args = split(input, ",")
              if sampIsPlayerConnected(args[1]) and tonumber(args[2]) then
                args[2] = args[2]:gsub(" ", "")
                args[3] = args[3]:gsub(" ", "", 1)
                sampSendChat("/r "..pInfo.Tag.." "..sampGetPlayerNickname(args[1]):gsub("_", " ")..", получает наряд "..args[2].." кругов вокруг части за "..args[3]..".")
              else sampShowDialog(9999, "{CD5C5C}SOBR tools |{FFFFFF} Ошибка", "{b6b6b6}Игрока с ID {B22222}"..args[1].."{b6b6b6} не существует.", "Печально", "Круто", 0) end
            end
          end
        },
        {
          title = "{20B2AA}Узнать занятость конкретного игрока{FFFFFF}",
          onclick = function()
            sampShowDialog(9999, "{CD5C5C}SOBR tools |{FFFFFF} Узнать занятость", "{b6b6b6}Введите ID игрока\nОбразец: {FFFFFF}641", "ОК", "Закрыть", 1)
            while sampIsDialogActive() do wait(0) end
            local _, pID = sampGetPlayerIdByCharHandle(PLAYER_PED)
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              local args = split(input, ",")
              if sampIsPlayerConnected(args[1]) then
                sampSendChat("/r "..pInfo.Tag.." "..sampGetPlayerNickname(args[1]):gsub("_", " ")..", сообщите вашу занятость на п."..pID..".")
              else sampShowDialog(9999, "{CD5C5C}SOBR tools |{FFFFFF} Ошибка", "{b6b6b6}Игрока с ID {B22222}"..args[1].."{b6b6b6} не существует.", "Печально", "Круто", 0) end
            end
          end
        },
        {
          title = "{00FA9A}Выезд на SOS{FFFFFF}",
          onclick = function()
            if m_s_t_a_t == true then
               sampSendChat("/r "..pInfo.Tag.." SOS в секторе принял. Выезжаю!")
            else
               sampSendChat("/r "..pInfo.Tag.." SOS в секторе приняла. Выезжаю!")
            end
          end
        },
        {
          title = "{00FA9A}Сделать построение у штаба{FFFFFF}",
          onclick = function()
            sampSendChat("/r "..pInfo.Tag.." СОБР строй у штаба. РВП - 5 минут!")
          end
        },
        {
          title = "{20B2AA}Патруль зоны 51{FFFFFF}",
          onclick = function()
            local result, amount = getPassengers() -- получаем таблицу пассажиров и их число
            if (result ~= false) then -- проверяем, есть ли что проверять :)
                if (amount > 0) then -- если пассажиров больше 0, делаем вывод, что они есть
                    names = "" -- создаем путую строковую переменную, чтобы в дальнейшем пихать сюда ники всех
                    for k, val in pairs(result) do -- перебираем элементы таблицы 
                        n = val.playername:gsub("_", " ")    -- получаем имя конкретного элемента
                        print(n)
                        if names == "" then      -- сделаем проверку, если в переменной names (выше) меньше двух символов текста
                                               -- тогда просто добавим следующее имя
                            names = names.. n   -- добавляем имя
                        else -- если символов больше двух, делаем вывод, что там уже есть ники, значит нужны запятые
                            names = names .. ", ".. n -- добавляем ники с запятыми
                        end
                    end
                    sampSendChat("/r "..pInfo.Tag.." Патруль части. Работаю c ".. names .. ".") -- выводим
                  elseif m_s_t_a_t == true then
                    sampSendChat("/r "..pInfo.Tag.." Патруль части. Работаю один.")
                  elseif m_s_t_a_t == false then
                    sampSendChat("/r "..pInfo.Tag.." Патруль части. Работаю одна.")
                end
            end
        end
        },
        {
          title = "{00FA9A}Сопровождение обьекта{FFFFFF}",
          onclick = function()
            local result, amount = getPassengers() 
            if (result ~= false) then 
                if (amount > 0) then 
                    names = "" 
                    for k, val in pairs(result) do 
                        n = val.playername:gsub("_", " ") 
                        print(n)
                        if names == "" then    
                                               -- тогда просто добавим следующее имя
                            names = names.. n  
                        else 
                            names = names .. ", ".. n -- добавляем ники с запятыми
                        end
                    end
                    sampSendChat("/r "..pInfo.Tag.." Выехали в сопровождение. Работаю с ".. names .. ".") -- выводим
                  elseif m_s_t_a_t == true then
                    sampSendChat("/r "..pInfo.Tag.." Выехал в сопровождение. Работаю один.")
                  elseif m_s_t_a_t == false then
                    sampSendChat("/r "..pInfo.Tag.." Выехала в сопровождение. Работаю одна.")
                end
            end
        end
        },
        {
          title = "{20B2AA}Выезд на проверку МО/АММО{FFFFFF}",
          onclick = function()
            local result, amount = getPassengers() -- получаем таблицу пассажиров и их число
            if (result ~= false) then -- проверяем, есть ли что проверять :)
                if (amount > 0) then -- если пассажиров больше 0, делаем вывод, что они есть
                    names = "" -- создаем путую строковую переменную, чтобы в дальнейшем пихать сюда ники всех
                    for k, val in pairs(result) do -- перебираем элементы таблицы 
                        n = val.playername:gsub("_", " ")    -- получаем имя конкретного элемента
                        print(n)
                        if names == "" then      -- сделаем проверку, если в переменной names (выше) меньше двух символов текста
                                               -- тогда просто добавим следующее имя
                            names = names.. n   -- добавляем имя
                        else -- если символов больше двух, делаем вывод, что там уже есть ники, значит нужны запятые
                            names = names .. ", ".. n -- добавляем ники с запятыми
                        end
                    end
                    sampSendChat("/r "..pInfo.Tag.." Выехали на проверку MO/AMMO работаю с ".. names .. ".") -- выводим
                  elseif m_s_t_a_t == true then
                    sampSendChat("/r "..pInfo.Tag.." Выехал на проверку MO/AMMO. Работаю один.")
                  elseif m_s_t_a_t == false then
                    sampSendChat("/r "..pInfo.Tag.." Выехала на проверку MO/AMMO. Работаю одна.")
                end
            end
        end
        },
        {
          title = "{00FA9A}Обеспечение безопасности на призыве{FFFFFF}",
          onclick = function()
            sampShowDialog(9999, "{CD5C5C}SOBR tools |{FFFFFF} 10-42", "{b6b6b6}Введите ID игрока, который является вашим напарником\nУказывать только одного из напарников!\n(без точки)\nОбразец: {FFFFFF}500", "ОК", "Закрыть", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              local args = split(input, ",")
              if sampIsPlayerConnected(args[1]) then
                sampSendChat("/r "..pInfo.Tag.." Охрана призыва. Работаю с "..sampGetPlayerNickname(args[1]):gsub("_", " ")..".")
              else sampShowDialog(9999, "{CD5C5C}SOBR tools |{FFFFFF} Ошибка", "{b6b6b6}Игрока с ID {B22222}"..args[1].."{b6b6b6} не существует.", "Печально", "Круто", 0) end
            end
          end
        },
        {
          title = "{20B2AA}Обеспечение безопасности на призыве(если один){FFFFFF}",
          onclick = function()
            if m_s_t_a_t == true then
                sampSendChat("/r "..pInfo.Tag.." Охрана призыва. Работаю один.")
            else
                sampSendChat("/r "..pInfo.Tag.." Охрана призыва. Работаю одна.")
            end
          end
        },
        {
          title = "{20B2AA}Выезд в порт{FFFFFF}",
          onclick = function()
            local result, amount = getPassengers() 
            if (result ~= false) then 
                if (amount > 0) then 
                    names = "" 
                    for k, val in pairs(result) do 
                        n = val.playername:gsub("_", " ")    
                        print(n)
                        if names == "" then      
                                               -- vavada
                            names = names.. n   
                        else 
                            names = names .. ", ".. n -- vavada
                        end
                    end
                    sampSendChat("/r "..pInfo.Tag.." Выехали в порт. Работаю с ".. names .. ".") 
                  elseif m_s_t_a_t == true then
                    sampSendChat("/r "..pInfo.Tag.." Выехал в порт. Работаю один.")
                  elseif m_s_t_a_t == false then
                    sampSendChat("/r "..pInfo.Tag.." Выехала в порт. Работаю одна.")
                end
            end
        end
        },
        {
          title = "{00FA9A}Сопровождение: попросить держать расстояние от колонны{FFFFFF}",
          onclick = function()
            sampSendChat("/m Держитесь на расстоянии от колонны! В случае приближения по вам откроется огонь на поражение!")
          end
        },
        {
          title = "{20B2AA}Позвать к штабу кого-то(в рацию){FFFFFF}",
          onclick = function()
            sampShowDialog(9999, "{CD5C5C}SOBR tools |{FFFFFF} Позвать к штабу кого-то", "{b6b6b6}Введите ID игрока которого хотите позвать к штабу.", "ОК", "Закрыть", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              local args = split(input, ",")
              if sampIsPlayerConnected(args[1]) then
                sampSendChat("/r "..pInfo.Tag.." "..sampGetPlayerNickname(args[1]):gsub("_", " ").." подойдите к штабу. У вас 30 секунд.")
              else sampShowDialog(9999, "{CD5C5C}SOBR tools |{FFFFFF} Ошибка", "{b6b6b6}Игрока с ID {B22222}"..args[1].."{b6b6b6} не существует.", "Печально", "Круто", 0) end
            end
          end
        },
        {
          title = "{00FA9A}Сделать перекличку{FFFFFF}",
          onclick = function()
            local _, pID = sampGetPlayerIdByCharHandle(PLAYER_PED)
            sampSendChat("/r "..pInfo.Tag.." СОБР - перекличка на п."..pID..".")
          end
        },
        {
          title = "{20B2AA}Узнать занятость отряда{FFFFFF}",
          onclick = function()
            local _, pID = sampGetPlayerIdByCharHandle(PLAYER_PED)
            sampSendChat("/r "..pInfo.Tag.." СОБР - кто чем занимается, сообщите на п."..pID..".")
          end
        },
      }
    },
    {
      title = "{FF8C00}Прочитать лекцию{FFFFFF}",
      submenu = {
        title = "{FFA500}Выберите лекцию{FFFFFF}",
        {
          title = "{FF8C00}Разминирование{FFFFFF}",
          onclick = function()
            sampSendChat("Всех приветствую, сегодня я покажу и расскажу")
            wait(settings.global.lwait)
            sampSendChat("порядок действий при разминировании бомбы.")
            wait(settings.global.lwait)
            sampSendChat("Начнём с того что при теракте за группой закреплена сумка сапёра.")
            wait(settings.global.lwait)
            sampSendChat("/do На плече у солдата весит спортивная сумка.")
            wait(settings.global.lwait)
            sampSendChat("/todo Что входит в этот набор рассмотрим сейчас*снял сумку с плеча, затем поставил на пол и растягнул")
            wait(settings.global.lwait)
            sampSendChat("стандартный набор: отвёртки разных видов, щипцы, изолетна, обжим и мультимитр.")
            wait(settings.global.lwait)
            sampSendChat("Прежде всего нужно отбросить все заднии мысли, сосредоточится на выполнении задачи.")
            wait(settings.global.lwait)
            sampSendChat("/me наклонился, затем потянул руку в сумку и достал муляж бомбы")
            wait(settings.global.lwait)
            sampSendChat("Стандартный муляж класса Б, сейчас я вам продемонстрирую всю процидуру.")
            wait(settings.global.lwait)
            sampSendChat("/me присел, затем положил муляж на асфальт")
            wait(settings.global.lwait)
            sampSendChat("/me соединил два провода, затем нажал на кнопку таймера")
            wait(settings.global.lwait)
            sampSendChat("/do Муляж начал пикать, на видимом дисплее начался обратный отчёт в пять минут.")
            wait(settings.global.lwait)
            sampSendChat("Для начало нужно осматреть бомбу, определить как закреплена крышка.")
            wait(settings.global.lwait)
            sampSendChat("/me достал из сумки отвёртку, затем начал скручивать болты на корпусе")
            wait(settings.global.lwait)
            sampSendChat("/me аккуратно открыл корпус, затем в сторону убрал в сторону")
            wait(settings.global.lwait)
            sampSendChat("К устройству должно быть проведено минимум три провода, разных цветов.")
            wait(settings.global.lwait)
            sampSendChat("Не стоит забывать о том факте, что перерезав ненужный провод, таймер может ускорить свой темп.")
            wait(settings.global.lwait)
            sampSendChat("Вам придётся принимать решение от которого могут зависит людские жизни.")
            wait(settings.global.lwait)
            sampSendChat("Краткий курс эеро-динамики вы сможете прочитать после, сейчас рассматрваем конкретный пример.")
            wait(settings.global.lwait)
            sampSendChat("/me достал из сумки щипцы")
            wait(settings.global.lwait)
            sampSendChat("/me аккуратно поднёс щипцы к красному проводу, затем перерезал его")
            wait(settings.global.lwait)
            sampSendChat("/try Бомба обезврежена")
            wait(settings.global.lwait)
            sampSendChat("Если в этот момент удача была не на вашей стороне, вам придётся в быстром темпе принимать следующее решение.")
            wait(settings.global.lwait)
            sampSendChat("/do Муляж запикал ещё в большем темпе.")
            wait(settings.global.lwait)
            sampSendChat("/me поднёс ципцы к зелёному проводу, затем сделал надрез")
            wait(settings.global.lwait)
            sampSendChat("/try Бомба обезврежена")
            wait(settings.global.lwait)
            sampSendChat("Как только вы сумели обезвредить бомбу, вам нужно слушать распоряжений старшего за группой.")
            wait(settings.global.lwait)
            sampSendChat("И помните, боец СОБР должен быть готов к разным поворотам ситуаций.")
          end
        },
        {
          title = "{FFA500}Первая помощь при потере сознания{FFFFFF}",
          onclick = function()
            sampSendChat("Первые действия на месте происшествия должны быть направлены на определение состояния пострадавшего и")
            wait(settings.global.lwait)
            sampSendChat("степени опасности, которой он подвергается со стороны угрожающих факторов")
            wait(settings.global.lwait)
            sampSendChat("Прежде всего, необходимо устранить угрожающие факторы, чтобы прекратить их воздействие на пострадавшего и")
            wait(settings.global.lwait)
            sampSendChat("вызвать «скорую помощь». Затем определить состояние пострадавшего: наличие сознания, а также признаки жизни.")
            wait(settings.global.lwait)
            sampSendChat("Если пострадавший находится в бессознательном состоянии а сердцебиение и дыхание присутствуют, необходимо")
            wait(settings.global.lwait)
            sampSendChat("выполнить действия, направленные на возвращение человеку сознания:")
            wait(settings.global.lwait)
            sampSendChat("1. Положите пострадавшего на бок, осмотрите.")
            wait(settings.global.lwait)
            sampSendChat("2. Расстегните у пострадавшего воротник рубашки, освободите грудь и живот от стягивающей их одежды,")
            wait(settings.global.lwait)
            sampSendChat("обеспечьте приток свежего воздуха.")
            wait(settings.global.lwait)
            sampSendChat("3. Придайте приподнятое положение ногам для притока крови к голове.")
            wait(settings.global.lwait)
            sampSendChat("4. Протрите лицо и шею прохладной водой. Похлопайте по щекам и, если возможно, дайте пострадавшему понюхать")
            wait(settings.global.lwait)
            sampSendChat("ватку, смоченную нашатырным спиртом.")
          end
        },
        {
          title = "{FF8C00}Первая помощь при отсутствии признаков жизни{FFFFFF}",
          onclick = function()
            sampSendChat("Необходимо приступить к определению наличия признаков жизни, если пострадавший находится в бессознательном")
            wait(settings.global.lwait)
            sampSendChat("состоянии, при этом определяют наличие сердцебиения, дыхания, зрачкового рефлекса, реакция зрачка на свет:")
            wait(settings.global.lwait)
            sampSendChat("а) определить наличие пульса на сонной артерии")
            wait(settings.global.lwait)
            sampSendChat("б) установить наличие или отсутствие дыхания по движению грудной клетки")
            wait(settings.global.lwait)
            sampSendChat("в) определить реакцию зрачков на свет, приподнимая верхнее веко обоих глаз")
            wait(settings.global.lwait)
            sampSendChat("При обнаружении признаков жизни пострадавшему оказывается первая помощь в зависимости от вида")
            wait(settings.global.lwait)
            sampSendChat("повреждений, которые он получил.")
            wait(settings.global.lwait)
            sampSendChat("При отсутствии признаков жизни необходимо срочно приступать к проведению сердечно-лёгочной реанимации.")
            wait(settings.global.lwait)
            sampSendChat("Требуется перевернуть пострадавшего на спину, скрестить руки на груди и сделать закрытый массаж сердца с")
            wait(settings.global.lwait)
            sampSendChat("интервалом в три секунды.")
          end
        },
        {
          title = "{FFA500}Особенности ранений{FFFFFF}",
          onclick = function()
            sampSendChat("Наиболее опасными для человека являются ранения грудной и брюшной полостей,")
            wait(settings.global.lwait)
            sampSendChat("так как в них располагаются жизненно важные органы, нарушение деятельности которых приводит к смерти.")
            wait(settings.global.lwait)
            sampSendChat("При оказании помощи необходимо наложить давящую повязку на большую площадь, чем имеющаяся рана.")
            wait(settings.global.lwait)
            sampSendChat("Оказание первой помощи при ранении головы:")
            wait(settings.global.lwait)
            sampSendChat("Останови кровотечение. Плотно прижми к ране стерильную салфетку. Удерживай ее пальцами до остановки")
            wait(settings.global.lwait)
            sampSendChat("кровотечения. Приложи холод к голове")
            wait(settings.global.lwait)
            sampSendChat("Первая помощь при проникающем ранении грудной клетки")
            wait(settings.global.lwait)
            sampSendChat("Большую опасность представляют проникающие ранения грудной клетки. В результате таких ранений может")
            wait(settings.global.lwait)
            sampSendChat("возникнуть такое явление, как пневмоторакс, когда поступает воздух в грудную полость, при котором функция лёгких резко")
            wait(settings.global.lwait)
            sampSendChat("снижается и человек может погибнуть в результате удушья. В данном случае необходимо оказывать помощь следующим")
            wait(settings.global.lwait)
            sampSendChat("образом:")
            wait(settings.global.lwait)
            sampSendChat("При отсутствии в ране инородного предмета прижми ладонь к ране и закрой в нее доступ воздуха. Если рана сквозная,")
            wait(settings.global.lwait)
            sampSendChat("Закрой рану воздухонепроницаемым материалом, герметизируя ее. Зафиксируй этот материал повязкой или пластырем или")
            wait(settings.global.lwait)
            sampSendChat("придай пострадавшему положение `полусидя`. Приложи холод к ране, подложив тканевую прокладку")
            wait(settings.global.lwait)
            sampSendChat("При наличии в ране инородного предмета зафиксируй его валиками из бинта, пластырем или повязкой. Извлекать из")
            wait(settings.global.lwait)
            sampSendChat("раны инородные предметы на месте происшествия запрещается!")
          end
        },
      }
    },
    {
      title = "{FF7F50}Запросить эвакуацию{FFFFFF}",
      onclick = function()
        sampSendChat("/r "..pInfo.Tag.." Запрашиваю эвакуацию в квадрат "..kvadrat())
      end
    },
    {
      title = "{DCDCDC}Надеть маску{FFFFFF}",
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
      title = "{B8860B}Завербовать в отряд{FFFFFF}",
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
      title = "{708090}Разминирование{FFFFFF}",
      submenu = 
      {
        title = "{2F4F4F}Выберите что хотите разминировать{FFFFFF}",
        {
          title = "{708090}Разминирование взрывчатки с часовым механизмом{FFFFFF}",
          onclick = function()
            sampSendChat("/me достал(а) набор сапера")
            wait(1200)
            sampSendChat("/me определил(а) тип взрывного устройства")
            wait(1200)
            sampSendChat("/do Взрывчатка с часовым механизмом.")
            wait(1200)
            sampSendChat("/me достал(а) отвертку")
            wait(1200)
            sampSendChat("/me аккуратно откручивает болты на корпусе устройства")
            wait(1200)
            sampSendChat("/me обнаружил(а) в механизме несколько проводов")
            wait(1200)
            sampSendChat("/me достал(а) кусачки из саперского набора")
            wait(1200)
            sampSendChat("/me взял(а) синий провод в руки")
            wait(1200)
            sampSendChat("/me с помощью кусачек оголил(а) провода")
            wait(1200)
            sampSendChat("/me достал(а) индикаторную отвертку")
            wait(1200)
            sampSendChat("/me приложил(а) отвертку к оголенному проводу")
            wait(1200)
            sampSendChat("/do Светодиод в отвертке загорелся.")
            wait(1200)
            sampSendChat("/me взял(а) в руки кусачки")
            wait(1200)
            sampSendChat("/me перерезал(а) провод")
            wait(1200)
            sampSendChat("/me Таймер остановлен.")
            wait(1200)
            sampSendChat("/me отсоеденил(а) детанатор")
            wait(1200)
            sampSendChat("/me взял(а) бронированный кейс")
            wait(1200)
            sampSendChat("/me положил(а) взрывчатку в кейс")
            wait(1200)
            sampSendChat("/me положил(а) все инструменты в набор сапера")
            wait(1200)
          end
        },
      }
    },
    {
      title = "{006400}Настройки{FFFFFF}",
      submenu =
      {
        title = "{9ACD32}Настройки{FFFFFF}",
        {
          title = "{006400}Поставить задержку между строками в лекциях(ОБЯЗАТЕЛЬНО){FFFFFF}",
          onclick = function()
            sampShowDialog(9999, "Установить задержку в лекциях:", "{b6b6b6}Введи задержку:", "ОК", "Закрыть", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              settings.global.lwait = input
              pInfo.lwait = input
              refreshDialog()
            end
          end
        },
        {
          title = "{006400}Тэг:{FFFFFF} "..pInfo.Tag,
          onclick = function()
            sampShowDialog(9999, "Установить тэг:", "{b6b6b6}Введи свой тэг:", "ОК", "Закрыть", 1)
            while sampIsDialogActive() do wait(0) end
            local result, button, item, input = sampHasDialogRespond(9999)
            if result and button == 1 then
              settings.global.Tag = input
              pInfo.Tag = input
              refreshDialog()
            end
          end
        },
        {
          title = "{9ACD32}Выключить/включить автоклист{FFFFFF}",
          onclick = function()
            if settings.global.t_se_au_to_clist == true then
              sampAddChatMessage("[SOBR tools]: Автоклист выключен.", 0xFFB22222)
              settings.global.t_se_au_to_clist = false
            else
              sampAddChatMessage("[SOBR tools]: Автоклист включен.", 0x33AAFFFF)
              settings.global.t_se_au_to_clist = true
            end
          end
        },
        {
          title = "{9ACD32}Выключить/включить открывание транспорта на клавишу `L`{FFFFFF}",
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
          title = "{006400}Выключить/включить авто-тег{FFFFFF}",
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
          title = "{9ACD32}Выключить/включить автоскрин после пэйдея{FFFFFF}",
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
          title = "{9ACD32}Выключить/включить функцию `Рация на зарядке`{FFFFFF}",
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
          title = "{9ACD32}Выключить/включить показ паспорта на `Alt + прицел на игрока`{FFFFFF}",
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
    {
      title = "{20B2AA}Позывные напарников{FFFFFF}",
      onclick = function()
        sampShowDialog(1298, "{808080}[SOBR tools] Позывные{FFFFFF}", "{808080}Molly Asad - Атланта\nAnton Amurov - Мура\nLeo Florenso - Пена\nVolodya Lipton - Свен\nTim Vedenkin - Морти\nAdam Walter - Вольт\nSativa Johnson - Боба\nMaksim Azzantroph - Лоли\nJony Soprano - Санёчек\nJack Lingard - Барон\nAnatoly Morozov - Беркут\nHoward Harper - Деанон\nIgor Chabanov - Филин\nValentin Molo - Крот\nBrain Spencor - Волк\nKevin Spencor - Гром\nBogdan Nurminski - Сталкер\nAleksey Tarasov - Зверь{FFFFFF}", "Ок", "Не ок", 0)
      end
    },
  }

  LVDialog = {

    {
      title = "{FF8C00}Призыв/мед.осмотр{FFFFFF}",
      submenu = {
        title = "{FFA500}Мед.осмотр{FFFFFF}",
        {
          title = "{FFA500}Приветствие и просьба показать документы{FFFFFF}",
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
          title = "{FF8C00}/me взял медкарту и начал изучать её{FFFFFF}",
          onclick = function()
             sampSendChat("/me взял медкарту и начал изучать её")
          end
        },
        {
          title = "{FFA500}/todo Сколько вам полных лет?*перелистывая медкарту{FFFFFF}",
          onclick = function()
             sampSendChat("/todo Сколько вам полных лет?*перелистывая медкарту")
          end
        },
        {
          title = "{FF8C00}/todo Так, расскажите мне о себе*закрыв медкарту{FFFFFF}",
          onclick = function()
             sampSendChat("/todo Так, расскажите мне о себе*закрыв медкарту")
          end
        },
        {
          title = "{FFA500}Отлично. Что у меня над головой?{FFFFFF}",
          onclick = function()
             sampSendChat("Отлично. Что у меня над головой?")
          end
        },
        {
          title = "{FF8C00}Отлично, вы годны для службы в армии{FFFFFF}",
          onclick = function()
             sampSendChat("Отлично, вы годны для службы в армии.")
          end
        },
        {
          title = "{FFA500}Держите повязку №16 и проходите в соседний кабинет{FFFFFF}",
          onclick = function()
             sampSendChat("Держите повязку №16 и проходите в соседний кабинет.")
          end
        },
        {
          title = "{20B2AA}/r [Ваш тэг]: Гражданин с пейджером ID годен для службы в армии Выдал розовую повязку{FFFFFF}",
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
  select_button, close_button, back_button = select_button or 'Ок', close_button or 'Не ок', back_button or 'Назад'
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
    if (status == dlstatus.STATUS_ENDDOWNLOADDATA) then
      sampAddChatMessage("Обновление успешно загружено.", 0xFFB22222)
    else
      sampAddChatMessage("Обновление не загружено.", 0xFFB22222)
    end    
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
	sampAddChatMessage("============= Мониторинг ============", 0xFFFFFF)
	for k, val in pairs(temp) do monikQuant[k] = val end
	if monikQuant[6] ~= nil then
		for i = 1, table.getn(monikQuant) do
			number1, number2, monikQuantNum[i] = string.match(monikQuant[i],"(%d+)[^%d]+(%d+)[^%d]+(%d+)")
			monikQuantNum[i] = monikQuantNum[i]/1000
		end
    sampSendChat("/r "..pInfo.Tag..": Мониторинг: [LSPD - "..monikQuantNum[1].." | SFPD - "..monikQuantNum[2].." | LVPD - "..monikQuantNum[3].." | SFa - "..monikQuantNum[4].." | FBI - "..monikQuantNum[6].."]")
	end
end

function getm() local x,y,z = getCharCoordinates(PLAYER_PED) local result, text = Search3Dtext(x,y,z, 1000, "FBI") local temp = split(text, "\n") sampAddChatMessage("=============[Мониторинг]============", 0xFFFFFF) for k, val in pairs(temp) do sampAddChatMessage(val, 0xFFFFFF) end end

function getDistance(x1, y1, z1, x2, y2, z2) local distance = math.sqrt( ((x1-x2)^2) + ((y1-y2)^2) + ((z1-z2)^2)) return distance end

function getBodyPartCoordinates(id, handle) local pedptr = getCharPointer(handle) local vec = ffi.new("float[3]") getBonePosition(ffi.cast("void*", pedptr), vec, id, true) return vec[0], vec[1], vec[2] end

function getActiveCamMode() local activeCaУСБ = memory.getint8(0x00B6F028 + 0x59) return getCamMode(activeCaУСБ) end


function getCamMode(id) local cams = 0x00B6F028 + 0x174 local cam = cams + id * 0x238 return memory.getint16(cam + 0x0C) end

function hphud()
  lua_thread.create(function()
    while true do wait(0)
      while not isPlayerPlaying(PLAYER_HANDLE) do wait(0) end
      useRenderCommands(true) -- use lua render
      setTextCentre(true) -- set text centered
      setTextScale(0.2, 0.5) -- x y size
      setTextColour(255--[[r]], 255--[[g]], 255--[[b]], 255--[[a]])
      setTextEdge(1--[[outline size]], 0--[[r]], 0--[[g]], 0--[[b]], 255--[[a]])
      displayTextWithNumber(578.0, 68.5, 'NUMBER', getCharHealth(PLAYER_PED))
      if getCharArmour(PLAYER_PED) > 0 then
         setTextCentre(true) -- set text centered
         setTextScale(0.2, 0.5) -- x y size
         setTextColour(255--[[r]], 255--[[g]], 255--[[b]], 255--[[a]])
         setTextEdge(1--[[outline size]], 0--[[r]], 0--[[g]], 0--[[b]], 255--[[a]])
         displayTextWithNumber(578.0, 47.0, 'NUMBER', getCharArmour(PLAYER_PED))
      end
    end
  end)
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
		
	textHelp = "Введите количество комплектов "..nameGun..", которое трубется взять.\nВведеные данные должны быть от 0 до 2."
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