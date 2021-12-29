script_name('Admin Tools ')
script_version_number(2)
script_moonloader(025)
script_author('Leon_Markelov')
script_version('2.0')
-- Библиотеки
require 'lib.moonloader'
require 'lib.sampfuncs'
local dlstatus = require('moonloader').download_status
local SE = require 'lib.samp.events'
local memory = require 'memory'
local imgui = require 'imgui'
local bitex = require 'bitex'
local vkeys = require 'vkeys'
local GK = require 'game.keys'
local weapons = require 'game.weapons'
local inicfg = require 'inicfg'
local winmsg = require 'windows.message'
local encoding = require 'encoding'
encoding.default = 'cp1251'
(function()
	patches={['SAMP_PATCH_SCOREBOARDTOGGLEON']={old_value=nil,offset=0x6AA10,value=0xC3,size=1},['SAMP_PATCH_SCOREBOARDTOGGLEONKEYLOCK']={old_value=nil,offset=0x6AD30,value=0xC3,size=1}}setmetatable(patches,{__call=function(a,b,c)if type(b)~='string'then return end;local d=a[b]if d~=nil then if type(c)~='boolean'then c=false end;local e=false;if c==false and d.old_value==nil then d.old_value=memory.getint8(sampGetBase()+d.offset,true)memory.write(sampGetBase()+d.offset,d.value,d.size,true)e=true elseif d.old_value~=nil then memory.write(sampGetBase()+d.offset,d.old_value,d.size,true)d.old_value=nil end;return e end end})
end)()
u8 = encoding.UTF8

local main_color_text = '{ffffff}'

-- Search: Global
local tCarsName = {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection", "Hunter",
"Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo",
"RCBandit", "Romero","Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed",
"Yankee", "Caddy", "Solair", "Berkley'sRCVan", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage",
"Dozer", "Maverick", "NewsChopper", "Rancher", "FBIRancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "BlistaCompact", "PoliceMaverick",
"Boxvillde", "Benson", "Mesa", "RCGoblin", "HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT", "Elegant", "Journey", "Bike",
"MountainBike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "hydra", "FCR-900", "NRG-500", "HPV1000",
"CementTruck", "TowTruck", "Fortune", "Cadrona", "FBITruck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight",
"Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada",
"Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito",
"FreightFlat", "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "NewsVan",
"Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "FreightBox", "Trailer", "Andromada", "Dodo", "RCCam", "Launch", "PoliceCar", "PoliceCar",
"PoliceCar", "PoliceRanger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "GlendaleShit", "SadlerShit", "Luggage A", "Luggage B", "Stairs", "Boxville", "Tiller",
"UtilityTrailer"}
local tCarsTypeName = {"Автомобиль", "Мотоицикл", "Вертолёт", "Самолёт", "Прицеп", "Лодка", "Другое", "Поезд", "Велосипед"}
local tCarsSpeed = {43, 40, 51, 30, 36, 45, 30, 41, 27, 43, 36, 61, 46, 30, 29, 53, 42, 30, 32, 41, 40, 42, 38, 27, 37,
54, 48, 45, 43, 55, 51, 36, 26, 30, 46, 0, 41, 43, 39, 46, 37, 21, 38, 35, 30, 45, 60, 35, 30, 52, 0, 53, 43, 16, 33, 43,
29, 26, 43, 37, 48, 43, 30, 29, 14, 13, 40, 39, 40, 34, 43, 30, 34, 29, 41, 48, 69, 51, 32, 38, 51, 20, 43, 34, 18, 27,
17, 47, 40, 38, 43, 41, 39, 49, 59, 49, 45, 48, 29, 34, 39, 8, 58, 59, 48, 38, 49, 46, 29, 21, 27, 40, 36, 45, 33, 39, 43,
43, 45, 75, 75, 43, 48, 41, 36, 44, 43, 41, 48, 41, 16, 19, 30, 46, 46, 43, 47, -1, -1, 27, 41, 56, 45, 41, 41, 40, 41,
39, 37, 42, 40, 43, 33, 64, 39, 43, 30, 30, 43, 49, 46, 42, 49, 39, 24, 45, 44, 49, 40, -1, -1, 25, 22, 30, 30, 43, 43, 75,
36, 43, 42, 42, 37, 23, 0, 42, 38, 45, 29, 45, 0, 0, 75, 52, 17, 32, 48, 48, 48, 44, 41, 30, 47, 47, 40, 41, 0, 0, 0, 29, 0, 0
}
local tCarsType = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1,
3, 1, 1, 1, 1, 6, 1, 1, 1, 1, 5, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 6, 3, 2, 8, 5, 1, 6, 6, 6, 1,
1, 1, 1, 1, 4, 2, 2, 2, 7, 7, 1, 1, 2, 3, 1, 7, 6, 6, 1, 1, 4, 1, 1, 1, 1, 9, 1, 1, 6, 1,
1, 3, 3, 1, 1, 1, 1, 6, 1, 1, 1, 3, 1, 1, 1, 7, 1, 1, 1, 1, 1, 1, 1, 9, 9, 4, 4, 4, 1, 1, 1,
1, 1, 4, 4, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 1, 1,
1, 3, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 4,
1, 1, 1, 2, 1, 1, 5, 1, 2, 1, 1, 1, 7, 5, 4, 4, 7, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 5, 1, 5, 5
}

script_version('0')

function update()
    local raw = 'https://raw.githubusercontent.com/GovnocodedByChapo/autoupdtest/main/file.json'
    local dlstatus = require('moonloader').download_status
    local requests = require('requests')
    local f = {}
    function f:getLastVersion()
        local response = requests.get(raw)
        if response.status_code == 200 then
            return decodeJson(response.text)['last']
        else
            return 'UNKNOWN'
        end
    end
    function f:download()
        local response = requests.get(raw)
        if response.status_code == 200 then
            downloadUrlToFile(decodeJson(response.text)['url'], thisScript().path, function (id, status, p1, p2)
                print('Скачиваю '..decodeJson(response.text)['url']..' в '..thisScript().path)
                if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                    sampAddChatMessage('Скрипт обновлен, перезагрузка...', -1)
                    thisScript():reload()
                end
            end)
        else
            sampAddChatMessage('Ошибка, невозможно установить обновление, код: '..response.status_code, -1)
        end
    end
    return f
end
-- TODO: 537, 538, 569, 570
local pInfo = inicfg.load({
 	info = {
 		reportId = -1,
 		reconId = -1,
 		acId = -1,
 		pmId = -1,
 		day = "",
		reportCount = 0,
		bCount = 0,
 		lastAuth = "",
 		lastOnline = 0,
 		aPassword = "",
		adminLevel = 7,
 		dayOnline = 0,
		lastCreateCar = 0,
		lastCreateCarColor1 = 0,
		lastCreateCarColor2 = 0
 	},
 	set = {
 		savePass = false,
		autoDuty = false,
		autoConoff = false,
		autoFon = false,
		autoSmson = false,
		autoVon = false,
		dutySkin = 294,
		iStyle = 0,
		wallhack = false,
		traicers = false,
		reColorMod = false,
		fullFastMap = false,
		pubMod = false,
		colorAChat = 4278241535,
		colorPm = 872388915,
		colorReport = 2905604013
 	},
	keys = {
		reconReport = "164 49",
		reconAC = "164 50",
		pm = "164 51",
		adminChat = "164 52",
		time = "164 54",
		reoff = "113",
		adminMenu = "112",
		fastMap = "77"
	}
}, "Admin_Tools")
local reportData = {}
for i = 0, 300 do
	reportData[i] = {fromId = -1, fromNick = "", onId = -1, onNick = "", text = ""}
end
local BulletSync = {lastId = 0, maxLines = 15}
for i = 1, BulletSync.maxLines do
	BulletSync[i] = {enable = false, o = {x, y, z}, t = {x, y, z}, time = 0, tType = 0}
end
local sInfo = {
	authorized = true,
	sessionStart = 0,
	authTime = ""
}
local popupInfo = {
	enable = false,
	active = false,
	close = false,
	open = "",
	msg = ""
}
local KeyboardFocus = false
local rInfo = {
	state = false,
	Cursor = false,
	refresh = false,
	cPosX = -1,
	cPosY = -1,
	itemMenu = 1,
	sMenuOpen = 0,
	sItemMenu = 1,
	id = -1,
	lastCar = -1,
	lastCmdRe = -1,
	last = {
		id = -1,
		name = -1,
		score = -1,
		ping = -1,
		health = 0,
		armor = 0
	}
}
local russian_characters = {
    [168] = 'Ё', [184] = 'ё', [192] = 'А', [193] = 'Б', [194] = 'В', [195] = 'Г', [196] = 'Д', [197] = 'Е', [198] = 'Ж', [199] = 'З', [200] = 'И', [201] = 'Й', [202] = 'К', [203] = 'Л', [204] = 'М', [205] = 'Н', [206] = 'О', [207] = 'П', [208] = 'Р', [209] = 'С', [210] = 'Т', [211] = 'У', [212] = 'Ф', [213] = 'Х', [214] = 'Ц', [215] = 'Ч', [216] = 'Ш', [217] = 'Щ', [218] = 'Ъ', [219] = 'Ы', [220] = 'Ь', [221] = 'Э', [222] = 'Ю', [223] = 'Я', [224] = 'а', [225] = 'б', [226] = 'в', [227] = 'г', [228] = 'д', [229] = 'е', [230] = 'ж', [231] = 'з', [232] = 'и', [233] = 'й', [234] = 'к', [235] = 'л', [236] = 'м', [237] = 'н', [238] = 'о', [239] = 'п', [240] = 'р', [241] = 'с', [242] = 'т', [243] = 'у', [244] = 'ф', [245] = 'х', [246] = 'ц', [247] = 'ч', [248] = 'ш', [249] = 'щ', [250] = 'ъ', [251] = 'ы', [252] = 'ь', [253] = 'э', [254] = 'ю', [255] = 'я',
}
local quitReason = {
	"Вылет / краш",
	"Вышел из игры",
	"Кик / бан"
}

-- Search: Variables
local colorAChat = imgui.ImColor(pInfo.set.colorAChat)
local colorPm = imgui.ImColor(pInfo.set.colorPm)
local colorReport = imgui.ImColor(pInfo.set.colorReport)
local aPanel = imgui.ImBool(false)
local aMenu = imgui.ImBool(false)
local ckAutoDuty = imgui.ImBool(pInfo.set.autoDuty)
local ckAutoConoff = imgui.ImBool(pInfo.set.autoConoff)
local ckAutoFon = imgui.ImBool(pInfo.set.autoFon)
local ckAutoSmson = imgui.ImBool(pInfo.set.autoSmson)
local ckAutoVon = imgui.ImBool(pInfo.set.autoVon)
local ckWallhack = imgui.ImBool(pInfo.set.wallhack)
local ckTraicers = imgui.ImBool(pInfo.set.traicers)
local ckReColorMod = imgui.ImBool(pInfo.set.reColorMod)
local ckPubMod = imgui.ImBool(pInfo.set.pubMod)
local ckFullFastMap = imgui.ImBool(pInfo.set.fullFastMap)
local editSkinDuty = imgui.ImBuffer(tostring(pInfo.set.dutySkin), 256)
local comboStyle = imgui.ImInt(pInfo.set.iStyle)
local hkReconReport = imgui.ImBuffer(tostring(pInfo.keys.reconReport), 256)
local hkReconAC = imgui.ImBuffer(tostring(pInfo.keys.reconAC), 256)
local hkPm = imgui.ImBuffer(tostring(pInfo.keys.pm), 256)
local hkAdminChat = imgui.ImBuffer(tostring(pInfo.keys.adminChat), 256)
local hkTime = imgui.ImBuffer(tostring(pInfo.keys.time), 256)
local hkReoff = imgui.ImBuffer(tostring(pInfo.keys.reoff), 256)
local hkAdminMenu = imgui.ImBuffer(tostring(pInfo.keys.adminMenu), 256)
local hkFastMap = imgui.ImBuffer(tostring(pInfo.keys.fastMap), 256)
local password = imgui.ImBuffer(pInfo.set.savePass and tostring(pInfo.info.aPassword) or "", 256)
local isSavePass = imgui.ImBool(pInfo.set.savePass)
local comboCar = imgui.ImInt(pInfo.info.lastCreateCar)
local carColor1 = imgui.ImInt(pInfo.info.lastCreateCarColor1)
local carColor2 = imgui.ImInt(pInfo.info.lastCreateCarColor2)
local captInfo = imgui.ImBool(true)
local comboFastPm = imgui.ImInt(0)
local logInputBuf = imgui.ImBuffer(128)
local logFilter = imgui.ImBuffer(128)
local popupItem1 = imgui.ImInt(0)
local popupItem2 = imgui.ImInt(0)
local popupInput = imgui.ImBuffer(128)
local popupCk = imgui.ImBool(false)
local popupCk2 = imgui.ImBool(false)
local scoreBoard = imgui.ImBool(false)
local isInStream = imgui.ImBool(false)
local searchBuf = imgui.ImBuffer(64)
local logConFilter = imgui.ImBuffer(128)
local logText = {}
local logConnect = {}
local ScrollToButton = false
local CopyToolActive = false
local cInfo = {
	enable = false,
	time = "",
	aztec = -1,
	ballas = -1,
	grove = -1,
	vagos = -1
}


local ToScreen = convertGameScreenCoordsToWindowScreenCoords

local aPassTD = {}
local editKeys = 0
local nextLockKey = -1
local nextLockKeyUp = -1
local captTime = 0


local menu = {
	{
		name = "Обновить",
		onClick = function () rInfo.refresh = false end
	},
	{
		name = "Посадить в тюрьму >",
		onClick = {
			{
				name = "DM",
				onClick = function () sampSendChat(string.format("/jail %d 15 DeathMatch", rInfo.id)) end
			},
			{
				name = "DB",
				onClick = function () sampSendChat(string.format("/jail %d 15 DriveBy", rInfo.id)) end
			},
			{
				name = "SK",
				onClick = function () sampSendChat(string.format("/jail %d 20 SpawnKill", rInfo.id)) end
			},
			{
				name = "TK",
				onClick = function () sampSendChat(string.format("/jail %d 20 TeamKill", rInfo.id)) end
			},
			{
				name = "FF",
				onClick = function () sampSendChat(string.format("/jail %d 20 FrendlyFire", rInfo.id)) end
			},
			{
				name = "PG",
				onClick = function () sampSendChat(string.format("/jail %d 15 PowerGaming", rInfo.id)) end
			},
			{
				name = "RVK",
				onClick = function () sampSendChat(string.format("/jail %d 15 RevangeKill", rInfo.id)) end
			},
			{
				name = "DM in ZZ",
				onClick = function () sampSendChat(string.format("/jail %d 60 DM in ZZ", rInfo.id)) end
			},
			{
				name = "NRP",
				onClick = function () sampSendChat(string.format("/jail %d 15 NonRolePlay", rInfo.id)) end
			},
			{
				name = "Уход от RP",
				onClick = function () sampSendChat(string.format("/jail %d 20 Уход от RP", rInfo.id)) end
			},
			{
				name = "drive",
				onClick = function () sampSendChat(string.format("/jail %d 15 NonRolePlay drive", rInfo.id)) end
			},
			{
				name = "Погоня",
				onClick = function () sampSendChat(string.format("/jail %d 30 Провокация на погоню", rInfo.id)) end
			},
			{
				name = "ЕПП (дально)",
				onClick = function () sampSendChat(string.format("/jail %d 120 ЕПП (дальнобойщик)", rInfo.id)) end
			},
			{
				name = "ЕПП (дально)",
				onClick = function () sampSendChat(string.format("/jail %d 120 ЕПП (дальнобойщик)", rInfo.id)) end
			},
			{
				name = "Другая причина »",
				onClick = function () popupInfo.enable = true; popupInfo.open = u8"Посадить в тюрьму"; end
			},
			postEvent = function () rInfo.sMenuOpen = 0 end
		}
	},
	{
		name = "Информация »",
		onClick = {
			{
				name = "Статистика",
				onClick = function () sampSendChat(string.format("/stats %d", rInfo.id)) end
			},
		}
	},
	{
		name = "Кикнуть игрока >",
		onClick = {
			{
				name = "AFK на дороге",
				onClick = function () sampSendChat(string.format("/kick %d AFK на дороге", rInfo.id)) end
			},
			{
				name = "Помеха",
				onClick = function () sampSendChat(string.format("/kick %d Помеха", rInfo.id)) end
			},
			{
				name = "NRP сон",
				onClick = function () sampSendChat(string.format("/kick %d NRP сон", rInfo.id)) end
			},
			{
				name = "AFK no ESC",
				onClick = function () sampSendChat(string.format("/kick %d AFK no ESC", rInfo.id)) end
			},
			{
				name = "Spawn Kill",
				onClick = function () sampSendChat(string.format("/kick %d Spawn Kill", rInfo.id)) end
			},
			{
				name = "Никнейм",
				onClick = function () sampSendChat(string.format("/kick %d Смените имя (/mn)", rInfo.id)) end
			},
			{
				name = "Другая причина >",
				onClick = function () popupInfo.enable = true; popupInfo.open = u8"Кикнуть игрока"; end
			},
			postEvent = function () rInfo.sMenuOpen = 0 end
		}
	},
	{
		name = "Помочь игроку >",
		onClick = {
			{
				name = "Выдать спавн",
				oonClick = function () sampSendChat(string.format("/spawn %d ", rInfo.id)) end
			},
			{
				name = "Выдать слап",
				oonClick = function () sampSendChat(string.format("/slap %d ", rInfo.id)) end
			},
			{
				name = "Помог",
				oonClick = function () sampSendChat("/n Помог, приятной игры на Brilliant RP | Phantom ") end
			},
			{
				name = "Выдать спавн >",
				oonClick = function () sampSendChat(string.format("/spawn %d ", rInfo.id)) end
			},
			{
				name = "Выдать спавн >",
				oonClick = function () sampSendChat(string.format("/spawn %d ", rInfo.id)) end
			},
			
			postEvent = function () rInfo.sMenuOpen = 0 end
		}
	},
	{
		name = "Выдать мут >",
		onClick = {
			{
				name = "CapsLock",
				onClick = function () sampSendChat(string.format("/mute %d 15 CapsLock", rInfo.id)) end
			},
			{
				name = "Flood",
				onClick = function () sampSendChat(string.format("/mute %d 15 Flood", rInfo.id)) end
			},
			{
				name = "Язык",
				onClick = function () sampSendChat(string.format("/mute %d 10 Нарушение правила 5.5", rInfo.id)) end
			},
			{
				name = "Транслит",
				onClick = function () sampSendChat(string.format("/mute %d 15 Транслит", rInfo.id)) end
			},
			{
				name = "Злоупотреб знаками",
				onClick = function () sampSendChat(string.format("/mute %d 15 Злоупотреб знаками", rInfo.id)) end
			},
			{
				name = "Своя причина >",
				onClick = function () popupInfo.enable = true; popupInfo.open = u8"Бан чата"; end
			},
			
			postEvent = function () rInfo.sMenuOpen = 0 end
		}
	},
	{
		name = "Выйти из наблюдения",
		onClick = function () sampSendChat("/reoff") end
	}
}

-- Search: Main()
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then
		return
	end
	while not isSampAvailable() do wait(100) end
	sampAddChatMessage('{00AAFF}[Admin Tools]: ' .. main_color_text .. 'Скрипт начал свою работу на сервере {00AAFF}Phantom', 0xffffff)
	sampAddChatMessage('{00AAFF}[Admin Tools]:' .. main_color_text .. ' Основное меню скрипта: {00AAFF}F1', 0xffffff)
	sampAddChatMessage('{00AAFF}[Admin Tools]:' .. main_color_text .. ' Проверьте обновление на скрипт используя команду: {00AAFF}/update', 0xffffff)
	-- dateFont = renderCreateFont("Comic Sans MS", 10, FCR_BORDER + FCR_BOLD)
	

	if sInfo.authorized then
		patches('SAMP_PATCH_SCOREBOARDTOGGLEON')
		patches('SAMP_PATCH_SCOREBOARDTOGGLEONKEYLOCK')
	end

	memory.fill(sampGetBase()+0x713F2, 0x90, 5, true)
	memory.fill(sampGetBase()+0x2D3C45, 0, 2, true)
	memory.write(sampGetBase()+0x797E, 0, 1, true)
	sampRegisterChatCommand("cc", function () ClearChat() end)

	local day = os.date("%d.%m.%y")

	if pInfo.info.day ~= day then
		pInfo.info.day = os.date("%d.%m.%y")
		pInfo.info.dayOnline = 0
	end
	sInfo.sessionStart = os.time()
 	sInfo.authTime = os.date("%d.%m.%y %H:%M:%S")

	imgui.ShowCursor = false
	imgui.SetMouseCursor(imgui.MouseCursor.None)
	imgui.Process = false
	local menuPtr = 0x00BA6748

	-- lua_thread.create(drawBulletLine)

	-- maxSpeed = 0
	-- rInfo.state = true
	-- rInfo.id = 0
sampRegisterChatCommand('osk_rod', function(arg)
local ran = math.random(10, 20)
sampSendChat('/ban ' ..arg.. ' ' ..ran.. ' Оскорбление родных')
end)
sampRegisterChatCommand('dm', function(arg)
    sampSendChat('/jail '..arg..' 15 dm')
end)
	sampRegisterChatCommand('tk', function(arg)
    sampSendChat('/jail '..arg..' 20 TeamKill')
end)
	sampRegisterChatCommand('sk', function(arg)
    sampSendChat('/jail '..arg..' 20 SpawnKill')
end)
	sampRegisterChatCommand('flood', function(arg)
    sampSendChat('/mute '..arg..' 15 Flood')
end)
	sampRegisterChatCommand('mg', function(arg)
    sampSendChat('/mute '..arg..' 15 MetaGaming')
end)
	while true do
		wait(0)
		-- if isCharInAnyCar(playerPed) then
		-- 	local carHundle = storeCarCharIsInNoSave(playerPed)
		-- 	if maxSpeed < math.floor(getCarSpeed(carHundle)) then
		-- 		maxSpeed = math.floor(getCarSpeed(carHundle))
		-- 	end
		-- 	renderFontDrawText(dateFont, getNameOfVehicleModel(getCarModel(carHundle)) .. ": " .. maxSpeed, 1280*0.085, 720*0.97, 0xFFFFFFFF)
		-- end
		if aPanel.v then
			displayHud(false)
			displayRadar(false)
			sampSetChatDisplayMode(0)
			imgui.Process = true
			imgui.ShowCursor = true
			imgui.LockPlayer = true
		elseif aMenu.v then
			displayHud(false)
			displayRadar(false)
			sampSetChatDisplayMode(0)
			imgui.Process = true
			imgui.ShowCursor = true
			imgui.LockPlayer = false
		--
		-- elseif rInfo.state and rInfo.id ~= -1 then
	elseif scoreBoard.v then
		displayHud(false)
		displayRadar(false)
		sampSetChatDisplayMode(0)
		imgui.Process = true
		imgui.ShowCursor = true
		imgui.LockPlayer = false
		elseif rInfo.state and rInfo.id ~= -1 and sampIsPlayerConnected(rInfo.id) then
			imgui.Process = true
			imgui.LockPlayer = false
			imgui.ShowCursor = popupInfo.enable and true or rInfo.Cursor
			if not imgui.ShowCursor then
				imgui.SetMouseCursor(imgui.MouseCursor.None)
			end
		elseif captInfo.v then
			imgui.Process = true
			imgui.ShowCursor = false
			imgui.SetMouseCursor(imgui.MouseCursor.None)
			imgui.LockPlayer = false
		else
			imgui.Process = false
			imgui.ShowCursor = false
			imgui.SetMouseCursor(imgui.MouseCursor.None)
			imgui.LockPlayer = false
		end

		if rInfo.state and rInfo.id ~= -1 and sampIsPlayerConnected(rInfo.id) then
			local isPed, pPed = sampGetCharHandleBySampPlayerId(rInfo.id)
			if rInfo.refresh then
				setGameKeyState(GK.player.FIREWEAPON, -1)
			else
				if isPed and doesCharExist(pPed) then
					if isCharInAnyCar(pPed) then
						if rInfo.lastCar == -1 then
							setGameKeyState(GK.player.FIREWEAPON, -1)
						end
					else
						if rInfo.lastCar > -1 then
							setGameKeyState(GK.player.FIREWEAPON, -1)
						end
					end
				else
					setGameKeyState(GK.player.FIREWEAPON, -1)
				end
			end
		end

		if not sampIsChatInputActive() and sInfo.authorized and not sampIsDialogActive() and not isSampfuncsConsoleActive() and isPlayerPlaying(playerHandle) and editKeys == 0 then
			if isKeysDown(pInfo.keys.adminMenu) and not popupInfo.enable then
				aMenu.v = not aMenu.v
				if not aMenu.v then
					displayRadar(true)
					sampSetChatDisplayMode(2)
				else
					ScrollToButton = true
				end
			end
			if isKeysDown(pInfo.keys.fastMap, true) then
				writeMemory(menuPtr + 0x33, 1, 1, false)
				wait(0)
				if nextLockKey == pInfo.keys.fastMap then
					nextLockKey = pInfo.keys.fastMap
				end
				writeMemory(menuPtr + 0x15C, 1, 1, false) -- textures loaded
				writeMemory(menuPtr + 0x15D, 1, 5, false) -- current menu
				if pInfo.set.fullFastMap then
				  writeMemory(menuPtr + 0x64, 4, representFloatAsInt(300.0), false)
				end
				while isKeysDown(pInfo.keys.fastMap, true) do
				  wait(80)
				end
				writeMemory(menuPtr + 0x32, 1, 1, false) -- close menu
			end
			if isKeysDown(pInfo.keys.reconReport) then
				sampSendChat("/re " .. pInfo.info.reportId)

			end
			if isKeysDown(pInfo.keys.reconAC) then
				sampSendChat("/re " .. pInfo.info.acId)
			end
			if isKeysDown(pInfo.keys.pm) then
				sampSetChatInputText("/pm " .. (pInfo.info.pmId == -1 and "" or pInfo.info.pmId .. " "))
				sampSetChatInputEnabled(true)
			end
			if isKeysDown(pInfo.keys.adminChat) then
				sampSetChatInputText("/a ")
				sampSetChatInputEnabled(true)
			end
			if isKeysDown(pInfo.keys.time) then
				sampSendChat("/time")
			end
			if isKeysDown(pInfo.keys.reoff) then
				sampSendChat("/reoff")
			end
		end
		local oTime = os.time()
		if pInfo.set.traicers and not isPauseMenuActive() then
			for i = 1, BulletSync.maxLines do
				if BulletSync[i].enable == true and BulletSync[i].time >= oTime then
					local sx, sy, sz = calcScreenCoors(BulletSync[i].o.x, BulletSync[i].o.y, BulletSync[i].o.z)
					local fx, fy, fz = calcScreenCoors(BulletSync[i].t.x, BulletSync[i].t.y, BulletSync[i].t.z)

					if sz > 1 and fz > 1 then
						renderDrawLine(sx, sy, fx, fy, 1, BulletSync[i].tType == 0 and 0xFFFFFFFF or 0xFFFFC700)
						renderDrawPolygon(fx, fy-1, 3, 3, 4.0, 10, BulletSync[i].tType == 0 and 0xFFFFFFFF or 0xFFFFC700)
					end
				end
			end
		end
	end
end
-- Search: Imgui Draw

function apply_custom_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	style.WindowRounding = 1.5
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ChildWindowRounding = 1.5
	style.FrameRounding = 1.0
	style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 0
	style.GrabMinSize = 8.0
	style.GrabRounding = 1.0
	-- style.Alpha =
	style.WindowPadding = imgui.ImVec2(4.0, 3.0)
	-- style.WindowMinSize =
	style.FramePadding = imgui.ImVec2(2.5, 3.5)
	-- style.ItemInnerSpacing =
	-- style.TouchExtraPadding =
	-- style.IndentSpacing =
	-- style.ColumnsMinSpacing = ?
	style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
	-- style.DisplayWindowPadding =
	-- style.DisplaySafeAreaPadding =
	-- style.AntiAliasedLines =
	-- style.AntiAliasedShapes =
	-- style.CurveTessellationTol =
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.04, 0.04, 0.04, 0.9)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.05, 0.05, 0.05, 0.79)
	colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CheckMark]              = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.28, 0.28, 0.28, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.35, 0.35, 0.35, 1.00)
	colors[clr.Header]                 = ImVec4(0.12, 0.12, 0.12, 0.94)
	colors[clr.HeaderHovered]          = ImVec4(0.25, 0.25, 0.25, 0.2)
	colors[clr.HeaderActive]           = ImVec4(0.16, 0.16, 0.16, 0.90)
	colors[clr.Separator]              = colors[clr.Border]
	colors[clr.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
	colors[clr.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.59, 0.98, 0.95)
	colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.10, 0.10, 0.10, 0.35)
end
apply_custom_style()
function setInterfaceStyle(id)
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	if id == 0 then
		colors[clr.CheckMark]              = ImVec4(1.00, 1.00, 1.00, 1.00)
		colors[clr.Text]                   = ImVec4(0.9, 0.9, 0.9, 1.00)
		colors[clr.WindowBg]               = imgui.ImColor(2, 0, 0, 230):GetVec4() -- 04
		colors[clr.FrameBg]     	          = imgui.ImColor(150, 10, 10, 100):GetVec4() -- 01
		colors[clr.FrameBgHovered]         = imgui.ImColor(150, 10, 10, 180):GetVec4()
		colors[clr.FrameBgActive]          = imgui.ImColor(150, 10, 10, 70):GetVec4()
		colors[clr.TitleBg]                = imgui.ImColor(150, 20, 20, 235):GetVec4() -- 01
		colors[clr.TitleBgActive]          = imgui.ImColor(150, 20, 20, 235):GetVec4() -- 01
		colors[clr.Button]                 = imgui.ImColor(150, 10, 10, 235):GetVec4() -- 01
		colors[clr.ButtonHovered]          = imgui.ImColor(150, 10, 10, 180):GetVec4() -- 01
		colors[clr.ButtonActive]           = imgui.ImColor(120, 10, 10, 180):GetVec4() -- 01
	elseif id == 1 then
		colors[clr.CheckMark]              = ImVec4(1.00, 1.00, 1.00, 1.00)
		colors[clr.Text]                   = ImVec4(0.9, 0.9, 0.9, 1.00)
		colors[clr.WindowBg]               = imgui.ImColor(2, 1, 3, 230):GetVec4() -- 04
		colors[clr.FrameBg]    	 		  = imgui.ImColor(70, 21, 135, 100):GetVec4() -- 02
		colors[clr.FrameBgHovered]         = imgui.ImColor(70, 18, 115, 180):GetVec4()
		colors[clr.FrameBgActive]          = imgui.ImColor(70, 21, 135, 70):GetVec4()
		colors[clr.TitleBg]                = imgui.ImColor(70, 21, 135, 235):GetVec4() -- 02
		colors[clr.TitleBgActive]          = imgui.ImColor(70, 21, 135, 235):GetVec4() -- 02
		colors[clr.Button]                 = imgui.ImColor(70, 21, 135, 235):GetVec4() -- 02
		colors[clr.ButtonHovered]          = imgui.ImColor(70, 21, 135, 170):GetVec4() -- 02
		colors[clr.ButtonActive]           = imgui.ImColor(55, 18, 115, 170):GetVec4() -- 02
	elseif id == 2 then
		colors[clr.CheckMark]              = ImVec4(1.00, 1.00, 1.00, 1.00)
		colors[clr.Text]                   = ImVec4(0.9, 0.9, 0.9, 1.00)
		colors[clr.WindowBg]               = imgui.ImColor(0, 2, 0, 230):GetVec4() -- 03
		colors[clr.FrameBg] 				   = ImVec4(0.2, 0.79, 0.14, 0.24) -- 03
		colors[clr.FrameBgHovered]         = ImVec4(0.2, 0.79, 0.14, 0.4)
		colors[clr.FrameBgActive]          = ImVec4(0.15, 0.59, 0.14, 0.39)
		colors[clr.TitleBg]                = ImVec4(0.05, 0.35, 0.05, 0.95) -- 03
		colors[clr.TitleBgActive]          = ImVec4(0.05, 0.35, 0.05, 0.95) -- 03
		colors[clr.Button]                 = ImVec4(0.2, 0.79, 0.14, 0.59) -- 03
		colors[clr.ButtonHovered]          = ImVec4(0.2, 0.79, 0.14, 0.4) -- 03
		colors[clr.ButtonActive]           = ImVec4(0.15, 0.59, 0.14, 0.39) -- 03
	elseif id == 3 then
		colors[clr.CheckMark]              = ImVec4(1.00, 1.00, 1.00, 1.00)
		colors[clr.Text]                   = ImVec4(0.9, 0.9, 0.9, 1.00)
		colors[clr.WindowBg]               = imgui.ImColor(0, 1, 2, 230):GetVec4() -- 04
		colors[clr.FrameBg]    	 		  = imgui.ImColor(2, 182, 193, 100):GetVec4() -- 04
		colors[clr.FrameBgHovered]         = imgui.ImColor(0, 182, 193, 140):GetVec4()
		colors[clr.FrameBgActive]          = imgui.ImColor(0, 182, 193, 70):GetVec4()
		colors[clr.TitleBg]                = imgui.ImColor(0, 123, 135, 232):GetVec4() -- 04
		colors[clr.TitleBgActive]          = imgui.ImColor(0, 123, 138, 232):GetVec4() -- 04
		colors[clr.Button]                 = imgui.ImColor(0, 172, 183, 163):GetVec4() -- 04
		colors[clr.ButtonHovered]          = imgui.ImColor(0, 182, 193, 100):GetVec4() -- 04
		colors[clr.ButtonActive]           = imgui.ImColor(0, 122, 133, 100):GetVec4() -- 04
	elseif id == 4 then
		colors[clr.CheckMark]              = ImVec4(1.00, 1.00, 1.00, 1.00)
		colors[clr.Text]                   = ImVec4(0.9, 0.9, 0.9, 1.00)
		colors[clr.WindowBg]               = imgui.ImColor(0, 0, 0, 230):GetVec4()
		colors[clr.FrameBg]    	 		  = imgui.ImColor(40, 40, 40, 100):GetVec4()
		colors[clr.FrameBgHovered]         = imgui.ImColor(95, 95, 95, 140):GetVec4()
		colors[clr.FrameBgActive]          = imgui.ImColor(95, 95, 95, 70):GetVec4()
		colors[clr.TitleBg]                = imgui.ImColor(7, 7, 7, 232):GetVec4()
		colors[clr.TitleBgActive]          = imgui.ImColor(7, 7, 7, 232):GetVec4()
		colors[clr.Button]                 = imgui.ImColor(30, 30, 30, 163):GetVec4()
		colors[clr.ButtonHovered]          = imgui.ImColor(95, 95, 95, 100):GetVec4()
		colors[clr.ButtonActive]           = imgui.ImColor(50, 50, 50, 100):GetVec4()
	elseif id == 5 then
		colors[clr.CheckMark]              = ImVec4(1.00, 1.00, 1.00, 1.00)
		colors[clr.Text]                   = ImVec4(0.9, 0.9, 0.9, 1.00)
		colors[clr.WindowBg]               = imgui.ImColor(3, 3, 0, 230):GetVec4()
		colors[clr.FrameBg]    	 		  = imgui.ImColor(210, 210, 0, 100):GetVec4()
		colors[clr.FrameBgHovered]         = imgui.ImColor(210, 210, 0, 140):GetVec4()
		colors[clr.FrameBgActive]          = imgui.ImColor(210, 210, 0, 70):GetVec4()
		colors[clr.TitleBg]                = imgui.ImColor(120, 120, 0, 232):GetVec4()
		colors[clr.TitleBgActive]          = imgui.ImColor(120, 120, 0, 232):GetVec4()
		colors[clr.Button]                 = imgui.ImColor(180, 180, 0, 163):GetVec4()
		colors[clr.ButtonHovered]          = imgui.ImColor(180, 180, 0, 100):GetVec4()
		colors[clr.ButtonActive]           = imgui.ImColor(100, 100, 0, 100):GetVec4()
	end
end
setInterfaceStyle(pInfo.set.iStyle)
local glyph_ranges = nil
function imgui.BeforeDrawFrame()
    if not fontChanged then
        fontChanged = true
        glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
        imgui.GetIO().Fonts:Clear()
        imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\arialbd.ttf', 14, nil, glyph_ranges)
    end
end
function imgui.OnDrawFrame()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local color = colors[clr.ButtonHovered]
	local colorLog = colors[clr.WindowBg]
	if aPanel.v then
		local w, h = ToScreen(640, 448)
		imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0, 0, 0, 0.1))
		imgui.SetNextWindowPos(imgui.ImVec2(0, 0), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowSize(imgui.ImVec2(w, h), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"##bg", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
		imgui.End()
		imgui.PopStyleColor()
		local x, y = ToScreen(50, 0)
		local w, h = ToScreen(160, 448)
		local p1, p2 = ToScreen(51, 130)
		imgui.SetNextWindowPos(imgui.ImVec2(x, y), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowSize(imgui.ImVec2(w-x, h), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"##auth", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
		imgui.SetCursorPos(imgui.ImVec2(0, p2))
		imgui.Separator()
		imgui.SetCursorPos(imgui.ImVec2(3.5, p2+5))
		imgui.PushStyleVar(imgui.StyleVar.FramePadding, imgui.ImVec2(3.5, 5.5))
		imgui.Text(u8"Введите пароль:")
		imgui.PushItemWidth(w-x-8)
		local inp = imgui.InputText("##pass", password, imgui.InputTextFlags.Password + imgui.InputTextFlags.EnterReturnsTrue + imgui.InputTextFlags.CharsNoBlank)
		imgui.PopItemWidth()
		imgui.PopStyleVar()
		imgui.Checkbox(u8"Запомнить пароль?", isSavePass)
		imgui.PushStyleVar(imgui.StyleVar.FramePadding, imgui.ImVec2(3.5, 5.5))
		if imgui.Button(u8"Авторизация", imgui.ImVec2(w-x-8, 0)) or inp then
			local pass = tostring(password.v)
			if pass:len() == 6 then
				for s in string.gmatch(pass, ".") do
					sampSendClickTextdraw(aPassTD[s])
				end
				aPanel.v = false
				displayRadar(true)
				sampSetChatDisplayMode(2)
				if isSavePass.v then
					pInfo.set.savePass = true
					pInfo.info.aPassword = pass
				else
					pInfo.set.savePass = false
					pInfo.info.aPassword = ""
				end
			end
		end
		imgui.PopStyleVar()
		imgui.SetCursorPos(imgui.ImVec2(4.5, p2+108))
		imgui.Separator()
		imgui.End()
		local x, y = ToScreen(440, 0)
		local w, h = ToScreen(640, 448)
		imgui.SetNextWindowPos(imgui.ImVec2(x, y), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowSize(imgui.ImVec2(w-x, h), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"##infoBar", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
		imgui.SetWindowFontScale(1.15)
		imgui.Text(u8"Последние новости:")
		imgui.SetWindowFontScale(1.0)
		imgui.Separator()
		local _, hb = ToScreen(_, 311)
		imgui.BeginChild("##news", imgui.ImVec2(w-x-2, hb))
		local upd = [[02.03.2018 | Версия: 4 | Alexandr_Together:
Глобальное обновление скрипта:
- Полностью переписана админ-панель (F1)
- Сделан уникальный вход в админку
- Изменены цвета жалоб и ответов на жалобы
- Изменена система слежки за игроком
- Теперь меню слежки можно управлять клавишами:
 W / S - Вверх / Вниз
 A / D - Вперед / Назад
 F - Назад
 Права кнопка мыши - Переключение режима. Кнопки / мышь
- Добавлен лог важных событий в админ-панели
 * Клик по строке в логе копирует её (ЛКМ / ПКМ)
- Исправлено большенство багов
- Изменена таблица счета
- Добавлен журнал подключений

24.02.2018 | Версия: 3 | Alexandr_Together:
- Система автоматического обновления
- Исправление багов
- Изменение цвета репорта
- Небольшие добратки рекона

05.02.2018 | Версия: 2 | Alexandr_Together:
- Исправление багов
- В меню слежки добавлен пункт "Взаимодействие"
- Изменение цвета репорт и ответов на репорт
- Добавлено меню при выходе игрока
- Другие мелкие изменения

20.01.2018 | Версия: 1 | Alexandr_Together:
- День создания скрипта. Первые тесты]]
		imgui.TextWrapped(u8(upd))
		imgui.EndChild()
		imgui.Separator()
		imgui.SetWindowFontScale(1.15)
		imgui.Text(u8"Информация:")
		imgui.SetWindowFontScale(1.0)
		imgui.Separator()
		local ip, port = sampGetCurrentServerAddress()
		imgui.Text(u8("Сервер: " .. sampGetCurrentServerName() .. "\nIP: " .. ip .. ":" .. port .."\nСейчас на сервере: " .. sampGetPlayerCount() .. "\n"))
		imgui.Separator()
		imgui.SetWindowFontScale(1.13)
		imgui.Text(u8"Статистика:")
		imgui.SetWindowFontScale(1.0)
		imgui.Separator()
		imgui.Text(u8("Последний вход: " .. pInfo.info.lastAuth .. "\nВремя игры: " .. secToTime(pInfo.info.lastOnline) .. "\n\nОнлайн за день: " .. secToTime(pInfo.info.dayOnline) .. "\nВыдно наказаний: " .. pInfo.info.bCount .. "\nОтветов в репорт: " .. pInfo.info.reportCount))
		imgui.End()
	elseif aMenu.v and sInfo.authorized then
		local w, h = ToScreen(640, 448)
		imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0, 0.05, 0, 0.1))
		imgui.SetNextWindowPos(imgui.ImVec2(0, 0), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowSize(imgui.ImVec2(w, h), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"##bg", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
		imgui.End()
		imgui.PopStyleColor()

		local x, y = ToScreen(2, 2) -- 109
		local w, h = ToScreen(140, 111)
		imgui.SetNextWindowPos(imgui.ImVec2(x, y), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowSize(imgui.ImVec2(w-x, h-y), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"##globalSet", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
		imgui.SetWindowFontScale(1.1)
		imgui.Text(u8"Общие настройки:")
		imgui.SetWindowFontScale(1.0)
		imgui.Separator()
		imgui.AlignTextToFramePadding()
		imgui.Text(u8"Стиль интерфейса:")
		imgui.SameLine()
		imgui.PushItemWidth(130)
		local styles = {u8"Красный", u8"Фиолетовый", u8"Зеленый", u8"Голубой", u8"Черный", u8"Желтый"}
		if imgui.Combo(u8"##styleedit", comboStyle, styles) then
			pInfo.set.iStyle = comboStyle.v
			setInterfaceStyle(pInfo.set.iStyle)
		end
		if imgui.Checkbox(u8"Wall Hack", ckWallhack) then
			pInfo.set.wallhack = ckWallhack.v
			if ckWallhack.v then
				nameTagOn()
			else
				nameTagOff()
			end
		end
		if imgui.Checkbox(u8"Трейсеры пуль при слежке", ckTraicers) then
			pInfo.set.traicers = ckTraicers.v
		end
		if imgui.Checkbox(u8"Заменять цвета чата", ckReColorMod) then
			pInfo.set.reColorMod = ckReColorMod.v
		end
		if imgui.Checkbox(u8"Болшой масштаб карты", ckFullFastMap) then
			pInfo.set.fullFastMap = ckFullFastMap.v
		end
		imgui.SameLine()
		imgui.TextDisabled(u8"(?)")
		if imgui.IsItemHovered() then
			imgui.BeginTooltip();
			imgui.TextUnformatted(u8"Изменяет параметр масштаба при\nбыстром просмотре карты");
			imgui.EndTooltip();
		end
		if imgui.Button(u8"Настройки замены цветов чата") then
			imgui.OpenPopup(u8"Настройка цветов чата")
			popupInfo.enable = true
		end
		if imgui.BeginPopupModal(u8"Настройка цветов чата", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
			imgui.AlignTextToFramePadding()
			imgui.Text(u8"Цвет админ-чата:")
			imgui.SameLine(140)
			if imgui.ColorEdit3("##aChatColor", colorAChat.v, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
				local col32 = colorAChat:GetU32()
				pInfo.set.colorAChat = col32
			end
			imgui.AlignTextToFramePadding()
			imgui.Text(u8"Цвет жалоб:")
			imgui.SameLine(140)
			if imgui.ColorEdit3("##reportColor", colorReport.v, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
				local col32 = colorReport:GetU32()
				pInfo.set.colorReport = col32
			end
			imgui.AlignTextToFramePadding()
			imgui.Text(u8"Цвет ответов:")
			imgui.SameLine(140)
			if imgui.ColorEdit3("##pmColor", colorPm.v, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
				local col32 = colorPm:GetU32()
				pInfo.set.colorPm = col32
			end
			if imgui.Button(u8"Заркыть", imgui.ImVec2(200, 0)) or popupInfo.close then
				popupInfo.enable = false
				popupInfo.close = false
				imgui.CloseCurrentPopup()
			end
			imgui.EndPopup()
		end
		-- if imgui.Checkbox(u8"Публичный режим", ckPubMod) then
		-- 	pInfo.set.pubMod = ckPubMod.v
		-- end
		-- imgui.SameLine()
		-- imgui.TextDisabled(u8"(?)")
		-- if imgui.IsItemHovered() then
		-- 	imgui.BeginTooltip();
		-- 	imgui.TextUnformatted(u8"Скрывает такую информацию как:\n- Админ-чат\n- IP адреса\n- AIM панель\n- Админ-команды 5+ уровней");
		-- 	imgui.EndTooltip();
		-- end
		-- imgui.PopItemWidth()
		imgui.End()

		

		local x, y = ToScreen(2, 114) -- 78
		local w, h = ToScreen(280, 192)
		imgui.SetNextWindowPos(imgui.ImVec2(x, y), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowSize(imgui.ImVec2(w-x, h-y), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"##binds", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
		imgui.SetWindowFontScale(1.1)
		imgui.Text(u8"Настройки управления:")
		imgui.SetWindowFontScale(1.0)
		imgui.Separator()
		imgui.Columns(2, _, false)
		imgui.SetColumnWidth(-1, (w-x) / 2)

		if imgui.Hotkey(u8"Панель администратора", hkAdminMenu, 80) then
			if hkAdminMenu.v == '' then
				hkAdminMenu.v = pInfo.keys.adminMenu
				nextLockKey = hkAdminMenu.v
			elseif isKeysBinded(hkAdminMenu.v) then
				nextLockKey = hkAdminMenu.v
				hkAdminMenu.v = pInfo.keys.adminMenu
			else
				nextLockKey = hkAdminMenu.v
				pInfo.keys.adminMenu = hkAdminMenu.v
			end
		end
		if imgui.Hotkey(u8"Следить за жалобой", hkReconReport, 80) then
			if isKeysBinded(hkReconReport.v) then
				nextLockKey = hkReconReport.v
				hkReconReport.v = pInfo.keys.reconReport
			else
				nextLockKey = hkReconReport.v
				pInfo.keys.reconReport = hkReconReport.v
			end
		end
		if imgui.Hotkey(u8"Следить за читером", hkReconAC, 80) then
			if isKeysBinded(hkReconAC.v) then
				nextLockKey = hkReconAC.v
				hkReconAC.v = pInfo.keys.reconAC
			else
				nextLockKey = hkReconAC.v
				pInfo.keys.reconAC = hkReconAC.v
			end
		end
		if imgui.Hotkey(u8"Ответ на репорт", hkPm, 80) then
			if isKeysBinded(hkPm.v) then
				nextLockKey = hkPm.v
				hkPm.v = pInfo.keys.pm
			else
				nextLockKey = hkPm.v
				pInfo.keys.pm = hkPm.v
			end
		end

		imgui.NextColumn()

		if imgui.Hotkey(u8"Написать в админ-чат", hkAdminChat, 80) then
			if isKeysBinded(hkAdminChat.v) then
				nextLockKey = hkAdminChat.v
				hkAdminChat.v = pInfo.keys.adminChat
			else
				nextLockKey = hkAdminChat.v
				pInfo.keys.adminChat = hkAdminChat.v
			end
		end
		if imgui.Hotkey(u8"Выйти из наблюдения", hkReoff, 80) then
			if isKeysBinded(hkReoff.v) then
				nextLockKey = hkReoff.v
				hkReoff.v = pInfo.keys.reoff
			else
				nextLockKey = hkReoff.v
				pInfo.keys.reoff = hkReoff.v
			end
		end
		if imgui.Hotkey(u8"Посмотреть карту", hkFastMap, 80) then
			if isKeysBinded(hkFastMap.v) then
				nextLockKey = hkFastMap.v
				hkFastMap.v = pInfo.keys.fastMap
			else
				nextLockKey = hkFastMap.v
				pInfo.keys.fastMap = hkFastMap.v
			end
		end
		if imgui.Hotkey(u8"Посмотреть время", hkTime, 80) then
			if isKeysBinded(hkTime.v) then
				nextLockKey = hkTime.v
				hkTime.v = pInfo.keys.time
			else
				nextLockKey = hkTime.v
				pInfo.keys.time = hkTime.v
			end
		end

		imgui.Columns(1)
		imgui.End()


		local x, y = ToScreen(2, 258) -- 189
		local w, h = ToScreen(280, 446)
		imgui.SetNextWindowPos(imgui.ImVec2(x, y), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowSize(imgui.ImVec2(w-x, h-y), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"##log", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
		imgui.AlignTextToFramePadding()
		imgui.SetWindowFontScale(1.1)
		imgui.Text(u8"Журнал:")
		imgui.SetWindowFontScale(1.0)
		imgui.SameLine(w-x-357)
		if imgui.Button(u8"Очистить") and #logText > 0 then
			logText = {}
			addLog("Журнал очищен ...")
		end
		imgui.SameLine()
		if imgui.Button(u8"Копировать журнал") and #logText > 0 then
			local t = ""
			for k, v in ipairs(logText) do
				t = t .. (tostring(t):len() > 0 and "\n" or "") .. v
			end
			setClipboardText(t)
			addLog("Содержимое журнала скопировано в буфер. Используйте CTRL + V")
		end
		imgui.SameLine()
		imgui.PushItemWidth(150)
		imgui.InputText("##logFilter", logFilter)
		if not imgui.IsItemActive() and logFilter.v:len() == 0 then
			imgui.SameLine(w-x-151)
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(195, 195, 195, 255):GetVec4())
			imgui.Text(u8"Поиск по журналу")
			imgui.PopStyleColor()
		end
		imgui.PopItemWidth()
		imgui.Separator()
		imgui.BeginChild("##logText", imgui.ImVec2(w-x-8, h-y-65))
		imgui.PushStyleVar(imgui.StyleVar.ItemSpacing, imgui.ImVec2(1, 2))
		if #logText > 0 then
			local fCount = 0
			for k, v in ipairs(logText) do
				if logFilter.v:len() > 0 then
					if string.find(string.rlower(v), string.rlower(u8:decode(logFilter.v)), 1, true) then
						imgui.TextWrapped(u8(v))
						fCount = fCount + 1
					end
				else
					imgui.TextWrapped(u8(v))
				end
				if (imgui.IsItemClicked(0) or imgui.IsItemClicked(1)) and (logFilter.v:len() == 0 or fCount > 0) then
					setClipboardText(v)
				end
			end
			if logFilter.v:len() > 0 and fCount == 0 then
				imgui.Text(u8"Совпадения не найдены ...")
			end
		else
			imgui.Text(u8"Журнал пуст ...")
		end
		if ScrollToButton then
			imgui.SetScrollHere()
			ScrollToButton = false
		end
		imgui.PopStyleVar()
		imgui.EndChild()
		imgui.Separator()
		imgui.PushItemWidth(w-x-85)
		if imgui.InputText("##logi", logInputBuf, imgui.InputTextFlags.EnterReturnsTrue) or imgui.SameLine() or imgui.Button(u8"Отправить")then
			if logInputBuf.v:len() > 0  then
				addLog(u8:decode("* " .. logInputBuf.v))
				logInputBuf.v = ''
				ScrollToButton = true
			end
			imgui.SetKeyboardFocusHere(-1)
		end
		imgui.PopItemWidth()
		imgui.End()

		local x, y = ToScreen(440, 0)
		local w, h = ToScreen(640, 448)
		imgui.SetNextWindowPos(imgui.ImVec2(x, y), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowSize(imgui.ImVec2(w-x, h), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"##pensBar", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
		imgui.SetWindowFontScale(1.1)
		imgui.Text(u8"Таблица наказаний:")
		imgui.SetWindowFontScale(1.0)
		imgui.Separator()
		local _, hb = ToScreen(_, 416)
		imgui.BeginChild("##pens", imgui.ImVec2(w-x-2, hb))
		local pens = [[Блокировка чата:
		
FLOOD - 15 Минут
CapsLock - 15 Минут
Оффтоп в репорт - 15 Минут
Мат в репорт - 15 Минут
Оскорбление игроков - 20 минут
MetaGaming - 15 минут
Нарушение пункта 5.5 (языки) - 10 минут
Злоупотреб знаками - 15 минут
Транслит - 15 минут
Отыгровка в войс - 15 минут
MetaGaming в войс - 15 минут
Использование доп. по для 
изменения голоса - 30 - 180 минут
Музыка в войс - 90 минут
Оск администрации - 180 минут

Кик игрока:
AFK no ESC
AFK на дороге
NRP sleep
NRP Nick

Выдача ДеМоргана:

DeathMatch - 15 минут
DriveBy - 15 минут
SpawnKill - 20 минут
TeamKill - 20 минут	
FrendlyFire - 20 минут
PowerGaming - 15 минут
Revange Kill (RVK) - 15 минут
DM in ZZ - 60 минут
NonRolePlay - 15 минут
Уход от RP - 20 минут
NonRolePlay drive - 15 минут
Езда по полям (лег) - 30 минут
Провокация на погоню - 30 минут
ЕПП (груз) - 120 минут

Выдача предупреждения (WARN)

Систематические нарушения 
Провокация на погоню
Уход от ареста
Mass DM (от 3-х)
Mass TK (от 2-х)
Mass SK (от 2-х)
Mass DB (от 3-х)
Отыгровки в свою сторону
Бандитизм от сотрудников гос структур

]]
		local times = [[

]]
		imgui.Columns(2, _, false)
		imgui.SetColumnWidth(-1, 255)
		imgui.Text(u8(pens))
		imgui.NextColumn()
		imgui.Text(u8(times))
		imgui.Columns(1)
		imgui.EndChild()
		imgui.Separator()
		imgui.Text(u8"Последнее обновление таблицы: 29.12.2021")
		imgui.End()
	--
	elseif scoreBoard.v and not sampIsChatInputActive() and not sampIsDialogActive() then
		drawScoreBoard()
	elseif captInfo.v and sInfo.authorized and (sampTextdrawIsExists(89) or sampTextdrawIsExists(96)) then
		local x, y = ToScreen(523, sampTextdrawIsExists(96) and 385 or 397)
		local w, h = ToScreen(638, 446)
		imgui.SetNextWindowPos(imgui.ImVec2(x, y), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowSize(imgui.ImVec2(w-x, h-y), imgui.Cond.FirstUseEver)
		imgui.Begin(u8((tonumber(captTime) > 0 and "Начало через " .. captTime .. " ..." or "Информация о капте") .. "##capt"), _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoSavedSettings)

		if sampTextdrawIsExists(96) then
			local x, y = ToScreen(520, 385)
			imgui.SetWindowPos(imgui.ImVec2(x, y))
			imgui.SetWindowSize(imgui.ImVec2(w-x, h-y))
			for i = 96, 100 do
				sampTextdrawSetPos(i, 9999, 9999)
				if i ~= 96 then
					local band, proc = string.match(sampTextdrawGetString(i), "(.*) (%d+%%)")
					imgui.TextColored(bandColor[band], band)
					imgui.SameLine((w-x) * 0.65)
					imgui.Text(proc)
				end
			end
		elseif sampTextdrawIsExists(91) then
			local x, y = ToScreen(520, 397)
			imgui.SetWindowPos(imgui.ImVec2(x, y))
			imgui.SetWindowSize(imgui.ImVec2(w-x, h-y))
			for i = 89, 95 do
				sampTextdrawSetPos(i, 9999, 9999)
			end
			imgui.Text(u8("Напали: "))
			imgui.SameLine((w-x) * 0.29)
			imgui.TextColored(bandColor[sampTextdrawGetString(92)], sampTextdrawGetString(92))
			imgui.SameLine((w-x) * 0.87)
			imgui.Text(u8(sampTextdrawGetString(95)))
			imgui.Text(u8("Оборона: "))
			imgui.SameLine((w-x) * 0.29)
			imgui.TextColored(bandColor[sampTextdrawGetString(93)], sampTextdrawGetString(93))
			imgui.SameLine((w-x) * 0.87)
			imgui.Text(u8(sampTextdrawGetString(94)))
			imgui.Text(u8("До конца войны:"))
			imgui.SameLine((w-x) * 0.87)
			imgui.Text(string.gsub(sampTextdrawGetString(91), " *(.*)", "%1"))
		end
		imgui.End()
	end
	--
	if rInfo.state and not scoreBoard.v and not aPanel.v and not aMenu.v and sInfo.authorized and rInfo.id ~= -1 and sampIsPlayerConnected(rInfo.id) then
		local x, y = ToScreen(552, 230)
		local w, h = ToScreen(638, 330)
		imgui.SetNextWindowPos(imgui.ImVec2(x, y), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowSize(imgui.ImVec2(w-x, 160), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"Информация##reconInfo", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoSavedSettings)

		local isPed, pPed = sampGetCharHandleBySampPlayerId(rInfo.id)
		local speed, health, armor, interior, model, carSpeed, carHealth, carHundle, carModel
		local score, ping = sampGetPlayerScore(rInfo.id), sampGetPlayerPing(rInfo.id)
		local spacing, height = 90.0, 162.0
		local btnSize = imgui.ImVec2(-0.001, 0)
		-- pPed = playerPed
		-- isPed = true
		rInfo.last.id = rInfo.id
		rInfo.last.name = getCurrentNickname(rInfo.id)
		rInfo.last.score = score
		rInfo.last.ping = ping
		if isPed and doesCharExist(pPed) then
			speed = getCharSpeed(pPed)
			health = sampGetPlayerHealth(rInfo.id)
			armor = sampGetPlayerArmor(rInfo.id)
			model = getCharModel(pPed)
			interior = getCharActiveInterior(playerPed)
			rInfo.last.speed = speed
			rInfo.last.interior = interior
			rInfo.last.health = health
			rInfo.last.armor = armor
			rInfo.last.model = model
			if isCharInAnyCar(pPed) then
				carHundle = storeCarCharIsInNoSave(pPed)
				carSpeed = getCarSpeed(carHundle)
				carModel = getCarModel(carHundle)
				carHealth = getCarHealth(carHundle)
				rInfo.last.isCar = true
				rInfo.last.carName = tCarsName[carModel-399]
				rInfo.last.carHealth = carHealth
				rInfo.last.carModel = carModel
				rInfo.last.speed = carSpeed
			else
				rInfo.last.isCar = false
			end
		end
		local spacing = 90.0

		imgui.PushStyleVar(imgui.StyleVar.ItemSpacing, imgui.ImVec2(1.0, 8.0))
		imgui.Text(u8(getCurrentNickname(rInfo.id) .. "[" .. rInfo.id .. "]"))
		imgui.PopStyleVar()

		imgui.PushStyleVar(imgui.StyleVar.ItemSpacing, imgui.ImVec2(1.0, 2.5))
		imgui.Text(u8"Жизни:"); imgui.SameLine(spacing); imgui.Text(isPed and health or u8"Нет")
		imgui.Text(u8"Броня:"); imgui.SameLine(spacing); imgui.Text(isPed and armor or u8"Нет")
		imgui.Text(u8"Счёт:"); imgui.SameLine(spacing); imgui.Text(score)
		imgui.Text(u8"Пинг:"); imgui.SameLine(spacing); imgui.Text(ping)
		imgui.Text(u8"Скин:"); imgui.SameLine(spacing); imgui.Text(isPed and model or u8"Нет")
		imgui.Text(u8"Скорость:"); imgui.SameLine(spacing); imgui.Text(isPed and (isCharInAnyCar(pPed) and math.floor(carSpeed) .. " / " .. tCarsSpeed[carModel - 399] or math.floor(speed)) or u8"Нет")
		imgui.Text(u8"Интерьер:"); imgui.SameLine(spacing); imgui.Text(isPed and interior or u8"Нет")
		imgui.PopStyleVar()
		imgui.End()
		y = y + 163
		-- local x, y = ToScreen(552, 332)
		-- local w, h = ToScreen(638, 365)
		if isPed and doesCharExist(pPed) and isCharInAnyCar(pPed) then
			imgui.SetNextWindowPos(imgui.ImVec2(x, y), imgui.Cond.FirstUseEver, imgui.ImVec2(0.0, 0.0))
			imgui.SetNextWindowSize(imgui.ImVec2(w-x, 53), imgui.Cond.FirstUseEver)
			imgui.Begin(u8"##reconCarInfo", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoSavedSettings)

			imgui.PushStyleVar(imgui.StyleVar.ItemSpacing, imgui.ImVec2(1.0, 2.5))
			imgui.Text(u8"Транспорт:"); imgui.SameLine(spacing); imgui.Text(isPed and tCarsName[carModel-399] or u8"Нет")
			imgui.Text(u8"Жизни:"); imgui.SameLine(spacing); imgui.Text(isPed and carHealth or u8"Нет")
			imgui.Text(u8"Модель:"); imgui.SameLine(spacing); imgui.Text(isPed and carModel or u8"Нет")
			imgui.PopStyleVar()

			imgui.End()
		end

		local x, y = ToScreen(2, 230)
		local w, h = ToScreen(83, 330)
		local bSize = imgui.ImVec2(w-x-8, 24)
		local endPush = false
		local clickedItem = false
		if rInfo.sMenuOpen > 0 and menu[rInfo.sMenuOpen].onClick ~= nil then
			if (imgui.IsKeyPressed(70) or imgui.IsKeyPressed(65)) and not imgui.ShowCursor and not sampIsChatInputActive() and not sampIsDialogActive() then
				rInfo.sMenuOpen = 0
			else
				local maxItems = #menu[rInfo.sMenuOpen].onClick
				imgui.SetNextWindowPos(imgui.ImVec2(x+(w-x)+3, y+(rInfo.sMenuOpen * 24) + (rInfo.sMenuOpen * 3) - 27), imgui.Cond.FirstUseEver, imgui.ImVec2(0.0, 0.0))
				imgui.SetNextWindowSize(imgui.ImVec2(w-x-10, (maxItems * 24) + (maxItems * 3) + 3), imgui.Cond.FirstUseEver)
				imgui.Begin(u8"##reconSubMenu" .. rInfo.sMenuOpen, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoSavedSettings)

				if not sampIsChatInputActive() and not sampIsDialogActive() then
					if imgui.IsKeyPressed(83) and not imgui.ShowCursor then
						rInfo.sItemMenu = rInfo.sItemMenu + 1
					end
					if imgui.IsKeyPressed(87) and not imgui.ShowCursor then
						rInfo.sItemMenu = rInfo.sItemMenu - 1
					end
				end
				if rInfo.sItemMenu > maxItems then
					rInfo.sItemMenu = 1
				end
				if rInfo.sItemMenu < 1 then
					rInfo.sItemMenu = maxItems
				end
				imgui.PushStyleVar(imgui.StyleVar.ItemSpacing, imgui.ImVec2(1.0, 3.5))
				for k, v in ipairs(menu[rInfo.sMenuOpen].onClick) do
					if not imgui.ShowCursor then
						if tonumber(rInfo.sItemMenu) == tonumber(k) then
							imgui.PushStyleColor(imgui.Col.Button, color)
							endPush = true
						end
					end
					if imgui.Button(u8(v.name), imgui.ImVec2(w-x-18, 24)) or ((imgui.IsKeyPressed(68, false)) and rInfo.sItemMenu == k and not imgui.ShowCursor and not sampIsChatInputActive() and not sampIsDialogActive()) then
					v=on:click()
						if menu[rInfo.sMenuOpen].onClick.postEvent ~= nil then
							menu[rInfo.sMenuOpen].onClick.postEvent()
						end
						clickedItem = true
						
					end
					if endPush then
						imgui.PopStyleColor()
						endPush = false
					end
				end
				imgui.PopStyleVar()
				imgui.End()
			end
		end
		imgui.SetNextWindowPos(imgui.ImVec2(x, y), imgui.Cond.FirstUseEver, imgui.ImVec2(0.0, 0.0))
		imgui.SetNextWindowSize(imgui.ImVec2(w-x, 192.0), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"##reconMenu", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoSavedSettings)

		if popupInfo.enable and tostring(popupInfo.open):len() > 0 then
			imgui.OpenPopup(popupInfo.open)
			KeyboardFocus = true
			popupInfo.open = ""
		end

		if imgui.BeginPopupModal(u8"Кикнуть игрока", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
			local bSize = imgui.ImVec2(100, 0)
			imgui.Text(u8"Введите причину:")
			imgui.PushItemWidth(190)
			imgui.InputText(u8"##kickReson", popupInput)
			imgui.PopItemWidth()
			if KeyboardFocus then
				KeyboardFocus = false
				imgui.SetKeyboardFocusHere(-1)
			end
			imgui.Checkbox(u8"Тикий кик", popupCk)
			if imgui.Button(u8"Продолжить##okkick", bSize) or popupInfo.active then
				if popupInput.v:len() > 0 then
					sampSendChat((popupCk.v and "/skick" or "/kick") .. " " .. rInfo.id .. " " .. u8:decode(popupInput.v))
					ighnoreId = rInfo.id
				else
					sampAddChatMessage("Вы не ввели причину кика", 0xAAAAAAAA)
				end
				popupInfo.enable = false
				popupInfo.active = false
				popupInput.v = ''
				popupCk.v = false
				submenu = 0
				imgui.CloseCurrentPopup()
			end
			imgui.SameLine()
			if imgui.Button(u8"Закрыть##nokick",bSize) or popupInfo.close then
				popupInfo.enable = false
				popupInfo.close = false
				popupInput.v = ''
				popupCk.v = false
				submenu = 0
				imgui.CloseCurrentPopup()
			end
			imgui.EndPopup()
		
		elseif imgui.BeginPopupModal(u8"Бан чата", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
			local bSize = imgui.ImVec2(100, 0)
			local items = {u8"5 минут", u8"10 минут", u8"15 минут", u8"20 минут", u8"30 минут", u8"40 минут", u8"60 минут", u8"120 минут", u8"180 минут"}
			imgui.Text(u8"Выберите время:")
			imgui.PushItemWidth(160)
			imgui.Combo("##min", popupItem1, items)
			imgui.PopItemWidth()
			imgui.Text(u8"Введите причину:")
			imgui.PushItemWidth(190)
			imgui.InputText(u8"##muteReson", popupInput)
			imgui.PopItemWidth()
			if imgui.Button(u8"Продолжить##okmute", bSize) or popupInfo.active then
				local mTime = 0
				if popupItem1.v == 0 then
					mTime = 5
				elseif popupItem1.v == 1 then
					mTime = 10
				elseif popupItem1.v == 2 then
					mTime = 15
				elseif popupItem1.v == 3 then
					mTime = 20
				elseif popupItem1.v == 4 then
					mTime = 30
				elseif popupItem1.v == 5 then
					mTime = 40
				elseif popupItem1.v == 6 then
					mTime = 60
				elseif popupItem1.v == 7 then
					mTime = 120
				elseif popupItem1.v == 8 then
					mTime = 180
				else
					mTime = 0
				end
				if popupInput.v:len() > 0 then
					sampSendChat("/mute " .. rInfo.id .. " " .. mTime .. " " .. u8:decode(popupInput.v))
				else
					sampAddChatMessage("Вы не ввели причину бана чата", 0xAAAAAAAA)
				end
				popupItem1.v = 0
				popupCk.v = false
				popupInfo.enable = false
				popupInfo.active = false
				popupInput.v = ''
				imgui.CloseCurrentPopup()
			end
			imgui.SameLine()
			if imgui.Button(u8"Закрыть##nomute",bSize) or popupInfo.close then
				popupItem1.v = 0
				popupCk.v = false
				popupInfo.enable = false
				popupInfo.close = false
				popupInput.v = ''
				imgui.CloseCurrentPopup()
			end
			imgui.EndPopup()
		elseif imgui.BeginPopupModal(u8"Посадить в тюрьму", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
			local bSize = imgui.ImVec2(100, 0)
			local items = {u8"10 минут", u8"15 минут", u8"60 минут", u8"100 минут", u8"120 минут", u8"180 минут"}
			imgui.Text(u8"Выберите время:")
			imgui.PushItemWidth(160)
			imgui.Combo("##min", popupItem1, items)
			imgui.PopItemWidth()
			imgui.Text(u8"Введите причину:")
			imgui.PushItemWidth(190)
			imgui.InputText(u8"##jailReson", popupInput)
			imgui.PopItemWidth()
			if imgui.Button(u8"Продолжить##kkjail", bSize) or popupInfo.active then
				local jTime = 0
				if popupItem1.v == 0 then
					jTime = 10
				elseif popupItem1.v == 1 then
					jTime = 15
				elseif popupItem1.v == 2 then
					jTime = 60
				elseif popupItem1.v == 3 then
					jTime = 100
				elseif popupItem1.v == 4 then
					jTime = 120
				elseif popupItem1.v == 5 then
					jTime = 180
				else
					jTime = 0
				end
				if popupInput.v:len() > 0 then
					sampSendChat("/jail " .. rInfo.id .. " " .. jTime .. " " .. u8:decode(popupInput.v))
				else
					sampAddChatMessage("Вы не ввели причину джайла", 0xAAAAAAAA)
				end
				popupItem1.v = 0
				popupCk.v = false
				popupInfo.enable = false
				popupInfo.active = false
				popupInput.v = ''
				imgui.CloseCurrentPopup()
			end
			imgui.SameLine()
			if imgui.Button(u8"Закрыть##njail",bSize) or popupInfo.close then
				popupItem1.v = 0
				popupCk.v = false
				popupInfo.enable = false
				popupInfo.active = false
				popupInput.v = ''
				imgui.CloseCurrentPopup()
			end
			imgui.EndPopup()
		end

		imgui.PushStyleVar(imgui.StyleVar.ItemSpacing, imgui.ImVec2(1.0, 3.5))
		if rInfo.sMenuOpen == 0 and not sampIsChatInputActive() and not sampIsDialogActive() then
			if imgui.IsKeyPressed(83) and not imgui.ShowCursor then
				rInfo.itemMenu = rInfo.itemMenu + 1
				if rInfo.itemMenu > #menu then
					rInfo.itemMenu = 1
				end
			end
			if imgui.IsKeyPressed(87) and not imgui.ShowCursor then
				rInfo.itemMenu = rInfo.itemMenu - 1
				if rInfo.itemMenu < 1 then
					rInfo.itemMenu = #menu
				end
			end
		end
		for k, v in ipairs(menu) do
			if not imgui.ShowCursor or rInfo.sMenuOpen == k then
				if tonumber(rInfo.itemMenu) == tonumber(k) or rInfo.sMenuOpen == k then
					imgui.PushStyleColor(imgui.Col.Button, color)
					endPush = true
				end
			end
			if (imgui.Button(u8(v.name), bSize) or ((imgui.IsKeyPressed(68, false)) and rInfo.itemMenu == k) and not imgui.ShowCursor) and not clickedItem and not sampIsChatInputActive() and not sampIsDialogActive() then
				if type(v.onClick) == "table" then
					if imgui.ShowCursor and rInfo.sMenuOpen == k then
						rInfo.sMenuOpen = 0
					else
						rInfo.sMenuOpen = k
						rInfo.itemMenu = k
						rInfo.sItemMenu = 1
					end
				else
					v.onClick()
				end
			end
			if endPush then
				imgui.PopStyleColor()
				endPush = false
			end
		end
		imgui.PopStyleVar()

		imgui.End()

		if reportData[tonumber(rInfo.id)].onId ~= nil and tostring(reportData[rInfo.id].onNick) == tostring(rInfo.last.name) then
			y = y + 195
			imgui.SetNextWindowPos(imgui.ImVec2(x, y), imgui.Cond.FirstUseEver)
			imgui.SetNextWindowSize(imgui.ImVec2(w-x, 58), imgui.Cond.FirstUseEver)
			imgui.Begin(u8"##reportInfo", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoSavedSettings + imgui.WindowFlags.NoTitleBar)
			imgui.Text(u8("Жалоба:"))
			imgui.Separator()
			imgui.TextWrapped(u8(string.format("%s[%d]\nТекст: %s", reportData[rInfo.id].fromNick, reportData[rInfo.id].fromId, string.lsub(reportData[rInfo.id].text:gsub(" ?(.*)", "%1"), 15))))
			imgui.End()
		end

		if imgui.IsMouseClicked(1) then
			rInfo.Cursor = not rInfo.Cursor
		end
	end
end

-- Search: Events
function SE.onPlayerJoin(id, color, isNpc, nickname)
	if sInfo.authorized then
		addConLog(string.format("%s[%d] подключился", nickname, id))
	end
end
function SE.onPlayerQuit(id, reason)
	if sInfo.authorized then
		addConLog(string.format("%s[%d] отключился. Причина: %s", getCurrentNickname(id), id, quitReason[reason+1]))
	end
end
function SE.onDisplayGameText(style, time, text)
	if text == "~n~~n~~n~~n~~n~~n~~n~~n~~w~RECON ~r~ OFF~n~ ~r~PLAYER DISCONNECT" and rInfo.last.id >= 0 then

	elseif text:find("%~y%~WAIT %d%.%.%.") then
		captTime = text:match("%~y%~WAIT (%d)%.%.%.")
		if tonumber(captTime) == 1 then
			lua_thread.create(function () wait(1100); captTime = 0; end)
		end
		return false
	end
end
function SE.onShowDialog(id, style, caption, b1, b2, text)
	if id == 7 and rInfo.state then
		return false
	end
	if id == 84 then
		sampSendDialogResponse(84, 1, 1, "")
		return false
	end
end
function SE.onSelectTextDraw(color)
	if rInfo.state and rInfo.id ~= -1 and sampIsPlayerConnected(rInfo.id) then
		return false
	end
end
function SE.onSpectatePlayer(playerid, camtype)
	if rInfo.id ~= playerid then
		rInfo.sMenuOpen = 0
		rInfo.sItemMenu = 1
		refreshMenu = true
	end
	rInfo.lastId = playerid
	rInfo.id = playerid
	rInfo.lastCar = -1
end
function SE.onSpectateVehicle(carid, camtype)
	if rInfo.id ~= rInfo.lastCmdRe and rInfo.lastCmdRe >= 0 then
		rInfo.id = rInfo.lastCmdRe
		if rInfo.lastCar ~= carid then
			rInfo.sMenuOpen = 0
			rInfo.sItemMenu = 1
			refreshMenu = true
		end
	end
	rInfo.lastCar = carid
end
function SE.onTogglePlayerSpectating(state)
	rInfo.state = state
	if not state then
		if rInfo.sMenuOpen > 0 then
			rInfo.sMenuOpen = 0
			rInfo.sItemMenu = 1
		end
		rInfo.lastCar = -1
		rInfo.id = -1
		refreshMenu = true
	elseif state and rInfo.refresh then
		rInfo.refresh = false
	end
end
function SE.onBulletSync(playerid, data)
	if rInfo.state and tonumber(playerid) == rInfo.id and pInfo.set.traicers then
		if data.target.x == -1 or data.target.y == -1 or data.target.z == -1 then
			return true
		end
		BulletSync.lastId = BulletSync.lastId + 1
		if BulletSync.lastId < 1 or BulletSync.lastId > BulletSync.maxLines then
			BulletSync.lastId = 1
		end
		local id = BulletSync.lastId
		BulletSync[id].enable = true
		BulletSync[id].tType = data.targetType
		BulletSync[id].time = os.time() + 15
		BulletSync[id].o.x, BulletSync[id].o.y, BulletSync[id].o.z = data.origin.x, data.origin.y, data.origin.z
		BulletSync[id].t.x, BulletSync[id].t.y, BulletSync[id].t.z = data.target.x, data.target.y, data.target.z
	end
end
function SE.onSendCommand(cmd)
	local reId = string.match(cmd, "^%/re (%d+)")
	if reId then
		rInfo.lastCmdRe = tonumber(reId)
	end
	-- sampAddChatMessage(cmd, 0xAAAAAAAA)
	-- return false
end
function SE.onShowTextDraw(id, data)
	if data.text == " " then
		return false
	end
	if id > 112 and id <= 206 then
		if tostring(data.text):len() == 1 then
			aPassTD[data.text] = id
		end
		return false
	end
	if id >= 89 and id <= 100 then
		data.position.x = 9999
		data.position.y = 9999
		return {id, data}
	end
end
function SE.onServerMessage(color, text)
	if text == "{42AAFF}Введите свой пароль от админ-панели" then
		aPanel.v = true
		displayRadar(false)
		sampSetChatDisplayMode(0)
		return
	elseif text == "{9EC73D}Для зачисления онлайна в статистику /ia необходимо заступить на дежурство (/duty)" then

		patches('SAMP_PATCH_SCOREBOARDTOGGLEON')
		patches('SAMP_PATCH_SCOREBOARDTOGGLEONKEYLOCK')

		sInfo.authorized = true
		lua_thread.create(function ()
			wait(0)
			if pInfo.set.autoDuty then
				sampSendChat("/duty " .. (pInfo.set.dutySkin ~= nil and pInfo.set.dutySkin or "294"))
			end
			if pInfo.set.autoConoff then
				sampSendChat("/conoff")
			end
			if pInfo.set.autoFon then
				sampSendChat("/fon")
			end
			if pInfo.set.autoVon then
				sampSendChat("/von")
			end
			if pInfo.set.autoSmson then
				sampSendChat("/smson")
			end
			if pInfo.set.wallhack then
				nameTagOn()
			end
		end)
		-- sampAddChatMessage(text, color)
		return
	end
	local _, localID = sampGetPlayerIdByCharHandle(playerPed)
	local rName, rId, rText = string.match(text, "%*.* Сообщение от (.*)%[(%d+)%]%: (.*)")
	local getALevel = string.match(text, "%{FFA500%}.* %[ID%:" .. localID .. "%] авторизовался как администратор (%d+) уровня")
	local pmAName, pmAId, pmName, pmId, pmText = string.match(text, "%{488331%}%* (.*) %[ID%:(%d+)%] отвечает (.*) %[ID%:(%d+)%]%: %{ffffff%}(.*)")
	local acNick, acId, acCheat, acIp = string.match(text, "%{FF0000%}%[AntiCheat%] %{FFFFFF%}(.*) %[ID%:(%d+)%] возможно использует (.*) %{FF0000%}%(IP%: (.*)%)")
	local toLog = string.match(text, "^%{FF6347%}(.*)")
	local stCapt = string.match(text, "%{A9401A%}(.* %[ID%:%d+%] инициировал захват территории)")
	local adminChat = string.match(text, "^%{00CD66%}(.*)")
	if adminChat then
		if pInfo.set.pubMod then
			local aLvl, aNick, aId = string.match(adminChat, "%[A%:(%d+)%] (.*) %[ID%:(%d+)%]%:.*")
			if aLvl and aNick and aId then
				addLog(adminChat)
				adminChat = string.format("[A:%d] %s [ID:%d]: <Сообщение скрыто>", aLvl, aNick, aId)
			end
		end
		r, g, b, a = imgui.ImColor(pInfo.set.colorAChat):GetRGBA()
		local nColor = join_argb(r, g, b, 255)
		return {pInfo.set.reColorMod and nColor or 0x00CD66FF, adminChat}
	elseif stCapt then
		captTime = 0
		addLog(stCapt)
	elseif toLog then
		if string.find(toLog, "Администратор " .. getCurrentNickname()) then
			local getBName = string.match(toLog, "Администратор " .. getCurrentNickname() .. " (.*)")
			local triggerList = {"забанил игрока", "выдал бан чата", "посадил в тюрьму"}
			local ok = false
			for _, v in ipairs(triggerList) do
				if string.find(getBName, "^" .. v) then
					ok = true
					break
				end
			end
			if ok then
				pInfo.info.bCount = pInfo.info.bCount + 1
			end
		end
		addLog(toLog)
	elseif getALevel then
		pInfo.info.adminLevel = tonumber(getALevel)
	elseif rName and rId and rText then
		local name, prefix = getCurrentNickname(tonumber(rId))
		local newRep = string.format("%sЖалоба от %s[%d]: %s", prefix ~= nil and prefix .. " | " or "", rName, rId, rText)
		pInfo.info.pmId = rId
		local lastRID, reasonRep = string.match(rText, "^[^%d]*(%d*)(.*)")
		if lastRID ~= nil and #lastRID > 0 and sampIsPlayerConnected(lastRID) then
			lastRID = tonumber(lastRID)
			reportData[lastRID].fromId = rId
			reportData[lastRID].fromNick = rName
			reportData[lastRID].onId = lastRID
			reportData[lastRID].onNick = getCurrentNickname(lastRID)
			reportData[lastRID].text = reasonRep
			newRep = string.format("%sЖалоба от %s[%d] на %s[%d]%s", prefix ~= nil and prefix .. " | " or "", rName, rId, (tostring(reasonRep):len() > 0 and "" or "игрока ") .. getCurrentNickname(lastRID), lastRID, tostring(reasonRep):len() > 0 and ": " .. reasonRep:gsub(" ?(.*)", "%1") or "")
			pInfo.info.reportId = lastRID
		end
		--  pInfo.set.reColorMod and 0xADFF2FFF or color
		r, g, b, a = imgui.ImColor(pInfo.set.colorReport):GetRGBA()
		local nColor = join_argb(r, g, b, 255)
		return {pInfo.set.reColorMod and nColor or 0xFF4366FF, newRep}
	elseif pmAName and pmAId and pmName and pmId and pmText then
		local newPm = string.format("<- Ответ %s[%d] к %s[%d]: {FFFFFF}%s", pmAName, pmAId, pmName, pmId, pmText)
		if tonumber(pmAId) == localID then
			pInfo.info.reportCount = pInfo.info.reportCount + 1
		end
		r, g, b, a = imgui.ImColor(pInfo.set.colorPm):GetRGBA()
		local nColor = join_argb(r, g, b, 255)
		return {pInfo.set.reColorMod and nColor or 0x488331FF, newPm}
	elseif acNick and acId and acCheat and acIp then
		local newAC = string.format("<Warning> %s[%d] возможно использует %s [IP: %s]", acNick, acId, acCheat, acIp)
		pInfo.info.acId = acId
		--[[B22222]]
		return {0xFF0000FF, newAC}
	end
end
function onScriptTerminate(script, quitGame)
	if script == thisScript() then
		if not doesDirectoryExist("moonloader\\config") then
			createDirectory("moonloader\\config")
		end
		pInfo.info.lastAuth = sInfo.authTime
		pInfo.info.lastOnline = os.time() - sInfo.sessionStart
		pInfo.info.dayOnline = pInfo.info.dayOnline + pInfo.info.lastOnline
		inicfg.save(pInfo, "Admin_Tools")
		patches('SAMP_PATCH_SCOREBOARDTOGGLEON', true)
		patches('SAMP_PATCH_SCOREBOARDTOGGLEONKEYLOCK', true)
	end
end
function onWindowMessage(msg, wparam, lparam)
	if(msg == 0x100 or msg == 0x101) and not popupInfo.enable then
		if msg == 0x100 and wparam == VK_ESCAPE and aMenu.v and not sampIsChatInputActive() and not sampIsDialogActive() then
			consumeWindowMessage(true, false)
		elseif msg == 0x101 and wparam == VK_ESCAPE and aMenu.v and not sampIsChatInputActive() and not sampIsDialogActive() then
			consumeWindowMessage(true, false)
			aMenu.v = false
			displayRadar(true)
			sampSetChatDisplayMode(2)
		elseif(wparam == VK_ESCAPE and scoreBoard.v and not sampIsChatInputActive() and not sampIsDialogActive()) and not isPauseMenuActive() then
			consumeWindowMessage(true, false)
			if(msg == 0x101)then
				toggleScoreboard(false)
				displayRadar(true)
				sampSetChatDisplayMode(2)
			end
		elseif wparam == VK_TAB and not isKeyDown(VK_TAB) and not isPauseMenuActive() then
			if not scoreBoard.v then
				if not sampIsChatInputActive() and sInfo.authorized then
					toggleScoreboard(true)
				end
			else
				toggleScoreboard(false)
				displayRadar(true)
				sampSetChatDisplayMode(2)
			end
			consumeWindowMessage(true, false)
		end
		if (wparam == VK_ESCAPE or wparam == VK_RETURN or wparam == VK_TAB or wparam == VK_F6 or wparam == VK_F7 or wparam == VK_F8 or wparam == VK_T or wparam == VK_OEM_3) and msg == 0x100 and editKeys > 0 then
			consumeWindowMessage(true, true)
			editKeys = 0
			editHotkey = nil
			nextLockKeyUp = wparam
		elseif nextLockKeyUp > -1 and nextLockKeyUp == wparam and msg == 0x101 then
			consumeWindowMessage(true, false)
			nextLockKeyUp = -1
		end
	end

	if msg == 0x100 and (wparam == VK_ESCAPE or wparam == VK_RETURN) and popupInfo.enable then
		consumeWindowMessage(true, true)
	elseif msg == 0x101 and popupInfo.enable and wparam == VK_ESCAPE then
		consumeWindowMessage(true, true)
		popupInfo.close = true
		popupInfo.enable = false
	elseif msg == 0x101 and popupInfo.enable and wparam == VK_RETURN then
		consumeWindowMessage(true, true)
		popupInfo.active = true
		popupInfo.enable = false
	end
end

-- Search: Functions
function explode_argb(argb)
  local a = bit.band(bit.rshift(argb, 24), 0xFF)
  local r = bit.band(bit.rshift(argb, 16), 0xFF)
  local g = bit.band(bit.rshift(argb, 8), 0xFF)
  local b = bit.band(argb, 0xFF)
  return a, r, g, b
end
function join_argb(a, r, g, b)
  local argb = b  -- b
  argb = bit.bor(argb, bit.lshift(g, 8))  -- g
  argb = bit.bor(argb, bit.lshift(r, 16)) -- r
  argb = bit.bor(argb, bit.lshift(a, 24)) -- a
  return argb
end
function drawScoreBoard()
	local x, y = ToScreen(0, 0)
	local w, h = ToScreen(168, 448)
	imgui.SetNextWindowPos(imgui.ImVec2(x, y), imgui.Cond.FirstUseEver)
	imgui.SetNextWindowSize(imgui.ImVec2(w-x, h), imgui.Cond.FirstUseEver)
	imgui.Begin(u8"##connectLogBar", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
	imgui.SetWindowFontScale(1.1)
	imgui.AlignTextToFramePadding()
	imgui.Text(u8"Журнал подключений:")
	imgui.SameLine(w-x-153)
	imgui.PushItemWidth(150)
	imgui.InputText("##logConFilter", logConFilter)
	if not imgui.IsItemActive() and logConFilter.v:len() == 0 then
		imgui.SameLine(w-x-151)
		imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(195, 195, 195, 255):GetVec4())
		imgui.Text(u8"Поиск по журналу")
		imgui.PopStyleColor()
	end
	imgui.PopItemWidth()
	imgui.SetWindowFontScale(1.0)
	imgui.Separator()
	local _, hb = ToScreen(_, 428)
	imgui.BeginChild("##connectLog", imgui.ImVec2(w-x-4, hb))
	imgui.PushStyleVar(imgui.StyleVar.ItemSpacing, imgui.ImVec2(1, 2))
	if #logConnect > 0 then
		local fCount = 0
		for k, v in ipairs(logConnect) do
			if logConFilter.v:len() > 0 then
				if string.find(string.rlower(v), string.rlower(u8:decode(logConFilter.v)), 1, true) then
					imgui.TextWrapped(u8(v))
					fCount = fCount + 1
				end
			else
				imgui.TextWrapped(u8(v))
			end
			if (imgui.IsItemClicked(0) or imgui.IsItemClicked(1)) and (logConFilter.v:len() == 0 or fCount > 0) then
				setClipboardText(v)
			end
		end
		if logConFilter.v:len() > 0 and fCount == 0 then
			imgui.Text(u8"Совпадения не найдены ...")
		end
	else
		imgui.Text(u8"Журнал пуст ...")
	end
	if ScrollToButton then
		imgui.SetScrollHere()
		ScrollToButton = false
	end
	imgui.PopStyleVar()
	imgui.EndChild()
	imgui.End()
	playerCount = 0
	local x, y = ToScreen(190, 20)
	local w, h = ToScreen(620, 425)
	imgui.SetNextWindowPos(imgui.ImVec2(x, y), imgui.Cond.FirstUseEver, imgui.ImVec2(0.0, 0.0))
	imgui.SetNextWindowSize(imgui.ImVec2(w-x , h-y), imgui.Cond.FirstUseEver)
	imgui.Begin(encoding.UTF8(sampGetCurrentServerName()), show_main_window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus)

	imgui.AlignTextToFramePadding()
	imgui.Text(u8'Всего онлайн: ' .. sampGetPlayerCount(false))
	imgui.SameLine(w-x-275)
	imgui.Checkbox(u8"В зоне стрима", isInStream)
	imgui.AlignTextToFramePadding()
	imgui.SameLine()
	imgui.PushItemWidth(150)
	imgui.PushAllowKeyboardFocus(false)
	imgui.InputText("##search", searchBuf, imgui.InputTextFlags.EnterReturnsTrue + imgui.InputTextFlags.CharsNoBlank)
	if not imgui.IsItemActive() and searchBuf.v:len() == 0 then
		imgui.SameLine(w-x-151)
		imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(195, 195, 195, 255):GetVec4())
		imgui.Text(u8"Поиск по нику / id")
		imgui.PopStyleColor()
	end
	imgui.PopAllowKeyboardFocus()
	imgui.PopItemWidth()
	if(isInStream.v)then
		imgui.Columns(5)
	else
		imgui.Columns(4)
	end
	imgui.Separator()
	imgui.SetColumnWidth(-1, 30); imgui.Text('ID'); imgui.NextColumn()
	imgui.SetColumnWidth(-1, isInStream.v and w-x-300 or w-x-200); imgui.Text(u8'Никнейм'); imgui.NextColumn()
	if(isInStream.v)then
		imgui.SetColumnWidth(-1, 102); imgui.Text(u8'Дистанция'); imgui.NextColumn()
	end
	imgui.SetColumnWidth(-1, 90); imgui.Text(u8'Счет'); imgui.NextColumn()
	imgui.SetColumnWidth(-1, 50); imgui.Text(u8'Пинг'); imgui.NextColumn()
	imgui.Columns(1)
	imgui.Separator()
	imgui.BeginChild("##scroll", imgui.ImVec2(0, 0), false)
	if(isInStream.v)then
		imgui.Columns(5)
	else
		imgui.Columns(4)
	end
	imgui.SetColumnWidth(-1, 30);imgui.NextColumn()
	imgui.SetColumnWidth(-1,isInStream.v and w-x-300 or w-x-200); imgui.NextColumn()
	if(isInStream.v)then
		imgui.SetColumnWidth(-1, 102); imgui.NextColumn()
	end
	imgui.SetColumnWidth(-1, 90);imgui.NextColumn()
	imgui.SetColumnWidth(-1, 50); imgui.NextColumn()
	local local_player_id = getLocalPlayerId()
	if(#searchBuf.v < 1) then
		drawScoreboardPlayer(local_player_id)
	else
		if(string.find(sampGetPlayerNickname(local_player_id):lower(), searchBuf.v:lower(), 1, true) or local_player_id == tonumber(searchBuf.v))then
			drawScoreboardPlayer(local_player_id)
		end
	end
	for i = 0, sampGetMaxPlayerId(isInStream.v) do
		if local_player_id ~= i and sampIsPlayerConnected(i) then
			if(#searchBuf.v > 0) then
				if(string.find(sampGetPlayerNickname(i):lower(), searchBuf.v:lower(), 1, true) or i == tonumber(searchBuf.v))then
					drawScoreboardPlayer(i)
				end
			else
				drawScoreboardPlayer(i)
			end
		end
	end

	imgui.Columns(1)
	if(playerCount == 0)then
		imgui.SameLine(5.0); imgui.Text(u8"Список пуст ...")
	end
	imgui.Separator()
	imgui.EndChild()

	imgui.End()
end
function getDistanceToPlayer(playerId)
	if sampIsPlayerConnected(playerId) then
		local result, ped = sampGetCharHandleBySampPlayerId(playerId)
		if result and doesCharExist(ped) then
			local myX, myY, myZ = getCharCoordinates(playerPed)
			local playerX, playerY, playerZ = getCharCoordinates(ped)
			return getDistanceBetweenCoords3d(myX, myY, myZ, playerX, playerY, playerZ)
		end
	end
	return -1
end
function drawScoreboardPlayer(id)
	-- send scores&ping update?
	local distance
	local isPlayerInStream = sampGetCharHandleBySampPlayerId(id)
	if(isInStream.v and not isPlayerInStream)then
		return
	elseif(isInStream.v and isPlayerInStream)then
		distance = getDistanceToPlayer(id)
	end
	local nickname = encoding.UTF8(sampGetPlayerNickname(id))
	local score = sampGetPlayerScore(id)
	local ping = sampGetPlayerPing(id)
	local color = sampGetPlayerColor(id)
	local r, g, b = bitex.bextract(color, 16, 8), bitex.bextract(color, 8, 8), bitex.bextract(color, 0, 8)
	local imgui_RGBA = imgui.ImVec4(r / 255.0, g / 255.0, b / 255.0, 1)

	playerCount = playerCount + 1

	if imgui.Selectable(id, false, imgui.SelectableFlags.SpanAllColumns + imgui.SelectableFlags.AllowDoubleClick) then
		if imgui.IsMouseDoubleClicked(0) then
			sampSendClickPlayer(id, 0)
			lua_thread.create(function ()
				wait(150)
				toggleScoreboard(false)
			end)
		end
	end

	if imgui.BeginPopupContextItem() then
		imgui.TextColored(imgui_RGBA, nickname .. "[" .. id .. "]")
		local btnSize = imgui.ImVec2(0.0, 0.0)
		imgui.Separator()
		if(id ~= getLocalPlayerId())then
			if imgui.Button(u8'Следить за игроком', btnSize) then
				imgui.CloseCurrentPopup()
				toggleScoreboard(false)
				sampSendChat("/re " .. id)
			end
		end
		if(id ~= getLocalPlayerId())then
			if imgui.Button(u8'Написать сообщение', btnSize) then
				imgui.CloseCurrentPopup()
				toggleScoreboard(false)
				sampSetChatInputText("/sms " .. id .. " ")
				sampSetChatInputEnabled(true)
			end
		end
		if imgui.Button(u8'Копировать никнейм', btnSize) then
			setClipboardText(nickname)
			imgui.CloseCurrentPopup()
		end

		imgui.EndPopup()
	end

	imgui.NextColumn()

	imgui.TextColored(imgui_RGBA, nickname); imgui.NextColumn()
	if(isInStream.v)then
		imgui.Text(string.format("%0.2f", distance));  imgui.NextColumn()
	end
	imgui.Text(score); imgui.NextColumn()
	imgui.Text(ping); imgui.NextColumn()
end
function toggleScoreboard(flag)
	if type(flag) == 'boolean' then
		scoreBoard.v = flag
	else
		scoreBoard.v = not scoreBoard.v
	end
	if scoreBoard.v then
		ScrollToButton = true
	else
		ScrollToButton = false
		displayRadar(true)
		sampSetChatDisplayMode(2)
	end
end
function addLog(string)
	logText[#logText+1] = string.format("[%s] %s", os.date("%H:%M:%S"), string)
end
function addConLog(string)
	logConnect[#logConnect+1] = string.format("[%s] %s", os.date("%H:%M:%S"), string)
end
function string.lsub(text, len)
	local text = tostring(text)
	text = string.trim(text, " ")
	if text:len() > len then
		text = text:sub(1, len) .. "..."
	end
	return text
end
function string.trim(text, sub)
	local text = tostring(text)
	text = string.gsub(text, "^%" .. sub .. "*(.*)%" .. sub .. "*$", "%1")
	return text
end
function calcScreenCoors(fX,fY,fZ)
	local dwM = 0xB6FA2C

	local m_11 = memory.getfloat(dwM + 0*4)
	local m_12 = memory.getfloat(dwM + 1*4)
	local m_13 = memory.getfloat(dwM + 2*4)
	local m_21 = memory.getfloat(dwM + 4*4)
	local m_22 = memory.getfloat(dwM + 5*4)
	local m_23 = memory.getfloat(dwM + 6*4)
	local m_31 = memory.getfloat(dwM + 8*4)
	local m_32 = memory.getfloat(dwM + 9*4)
	local m_33 = memory.getfloat(dwM + 10*4)
	local m_41 = memory.getfloat(dwM + 12*4)
	local m_42 = memory.getfloat(dwM + 13*4)
	local m_43 = memory.getfloat(dwM + 14*4)

	local dwLenX = memory.read(0xC17044, 4)
	local dwLenY = memory.read(0xC17048, 4)

	frX = fZ * m_31 + fY * m_21 + fX * m_11 + m_41
	frY = fZ * m_32 + fY * m_22 + fX * m_12 + m_42
	frZ = fZ * m_33 + fY * m_23 + fX * m_13 + m_43

	fRecip = 1.0/frZ
	frX = frX * (fRecip * dwLenX)
	frY = frY * (fRecip * dwLenY)

    if(frX<=dwLenX and frY<=dwLenY and frZ>1)then
        return frX, frY, frZ
	else
		return -1, -1, -1
	end
end
function imgui.Hotkey(name, keyBuf, width)
	local name = tostring(name)
	local keys, endkey = getDownKeys()
	local keysName = ""
	local ImVec2 = imgui.ImVec2
	local bool = false
	if editHotkey == name then
		if keys == VK_BACK then
			keyBuf.v = ''
			editHotkey = nil
			nextLockKey = keys
			editKeys = 0
			bool = true
		else
			local tNames = string.split(keys, " ")
			local keylist = ""
			for _, v in ipairs(tNames) do
				local key = tostring(vkeys.id_to_name(tonumber(v)))
				if tostring(keylist):len() == 0 then
					keylist = key
				else
					keylist = keylist .. " + " .. key
				end
			end
			keysName = keylist
			if endkey then
				bool = true
				keyBuf.v = keys
				editHotkey = nil
				nextLockKey = keys
				editKeys = 0
			end
		end
	else
		local tNames = string.split(keyBuf.v, " ")
		for _, v in ipairs(tNames) do
			local key = tostring(vkeys.id_to_name(tonumber(v)))
			if tostring(keysName):len() == 0 then
				keysName = key
			else
				keysName = keysName .. " + " .. key
			end
		end
	end
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	imgui.PushStyleColor(imgui.Col.Button, colors[clr.FrameBg])
	imgui.PushStyleColor(imgui.Col.ButtonActive, colors[clr.FrameBg])
	imgui.PushStyleColor(imgui.Col.ButtonHovered, colors[clr.FrameBg])
	imgui.PushStyleVar(imgui.StyleVar.ButtonTextAlign, ImVec2(0.04, 0.5))
	imgui.AlignTextToFramePadding()
	imgui.Button(u8((tostring(keysName):len() > 0 or editHotkey == name) and keysName or "Нет"), ImVec2(width, 20))
	imgui.PopStyleVar()
	imgui.PopStyleColor(3)
	if imgui.IsItemHovered() and imgui.IsItemClicked() and editHotkey == nil then
		editHotkey = name
		editKeys = 100
	end
	if name:len() > 0 then
		imgui.SameLine()
		imgui.Text(name)
	end
	return bool
end

function string.split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function isKeysDown(keylist, pressed)
	local tKeys = string.split(keylist, " ")
	if pressed == nil then
		pressed = false
	end
	if tKeys[1] == nil then
		return false
	end
	local bool = false
	local key = #tKeys < 2 and tonumber(tKeys[1]) or tonumber(tKeys[2])
	local modified = tonumber(tKeys[1])
	if #tKeys < 2 then
		if not isKeyDown(VK_RMENU) and not isKeyDown(VK_LMENU) and not isKeyDown(VK_LSHIFT) and not isKeyDown(VK_RSHIFT) and not isKeyDown(VK_LCONTROL) and not isKeyDown(VK_RCONTROL) then
			if wasKeyPressed(key) and not pressed then
				bool = true
			elseif isKeyDown(key) and pressed then
				bool = true
			end
		end
	else
		if isKeyDown(modified) and not wasKeyReleased(modified) then
			if wasKeyPressed(key) and not pressed then
				bool = true
			elseif isKeyDown(key) and pressed then
				bool = true
			end
		end
	end
	if tostring(nextLockKey) == tostring(keylist) then
		if pressed and not wasKeyReleased(key) then
			bool = false
--			nextLockKey = ""
		else
			bool = false
			nextLockKey = ""
		end
	end
	return bool
end

function getDownKeys()
	local curkeys = ""
	local bool = false
	for k, v in pairs(vkeys) do
		if isKeyDown(v) and (v == VK_MENU or v == VK_CONTROL or v == VK_SHIFT or v == VK_LMENU or v == VK_RMENU or v == VK_RCONTROL or v == VK_LCONTROL or v == VK_LSHIFT or v == VK_RSHIFT) then
			if v ~= VK_MENU and v ~= VK_CONTROL and v ~= VK_SHIFT then
				curkeys = v
			end
		end
	end
	for k, v in pairs(vkeys) do
		if isKeyDown(v) and (v ~= VK_MENU and v ~= VK_CONTROL and v ~= VK_SHIFT and v ~= VK_LMENU and v ~= VK_RMENU and v ~= VK_RCONTROL and v ~= VK_LCONTROL and v ~= VK_LSHIFT and v ~= VK_RSHIFT) then
			if tostring(curkeys):len() == 0 then
				curkeys = v
			else
				curkeys = curkeys .. " " .. v
			end
			bool = true
		end
	end
	return curkeys, bool
end
function secToTime(sec)
	local hour, minute, second = sec / 3600, math.floor(sec / 60), sec % 60
	return string.format("%02d:%02d:%02d", math.floor(hour) ,  minute - (math.floor(hour) * 60), second)
end
function isKeysBinded(str)
	local bool = false
	for k, v in pairs(pInfo.keys) do
		if tostring(str) == tostring(v) and tostring(v):len() > 0 then
			bool = true
			break
		end
	end
	return bool
end
function string.rlower(s)
    s = s:lower()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:lower()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 192 and ch <= 223 then -- upper russian characters
            output = output .. russian_characters[ch + 32]
        elseif ch == 168 then -- Ё
            output = output .. russian_characters[184]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function string.rupper(s)
    s = s:upper()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:upper()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 224 and ch <= 255 then -- lower russian characters
            output = output .. russian_characters[ch - 32]
        elseif ch == 184 then -- ё
            output = output .. russian_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function getLocalPlayerId()
	local _, id = sampGetPlayerIdByCharHandle(playerPed)
	return id
end
function getCurrentNickname(id)
	local _, myId = sampGetPlayerIdByCharHandle(playerPed)
	if id == nil then
		id = myId
	end
	if sampIsPlayerConnected(id) or id == myId then
		local name = sampGetPlayerNickname(id)
		local prefix = nil
		if string.find(name, "^%[GW%]") or string.find(name, "^%[DM%]") or string.find(name, "^%[TR%]") or string.find(name, "^%[LC%]") then
			prefix = string.match(name, "^%[([A-Z]+)%].*")
			name = string.gsub(name, "^%[[A-Z]+%]", "")
		end
		return name, prefix
	end
	return ""
end
function getCarName(carid)
	if type(carid) ~= "number" then
		return "No valid car id"
	end
	if carid < 400 or carid > 611 then
		return "No valid car id"
	end
	return tCarsName[carid-399]
end
function nameTagOn()
	local pStSet = sampGetServerSettingsPtr()
	activeWH = true
	memory.setfloat(pStSet + 39, 1488.0)
	memory.setint8(pStSet + 47, 0)
	memory.setint8(pStSet + 56, 1)
end
function ClearChat()
    memory.fill(sampGetChatInfoPtr() + 306, 0x0, 25200, false)
    setStructElement(sampGetChatInfoPtr() + 306, 25562, 4, true, false)
    memory.write(sampGetChatInfoPtr() + 0x63DA, 1, 1, false)
end
function nameTagOff()
	local pStSet = sampGetServerSettingsPtr()
	activeWH = false
	memory.setfloat(pStSet + 39, 50.0)
	memory.setint8(pStSet + 47, 0)
	memory.setint8(pStSet + 56, 1)
end
