--dofile(getScriptPath() .. "\\Lib.lua")

--Settings= 
--{ 
--	Name = "Price Levity"
--	line =
--	{
	--	{
	--		Name = "r",
	--		Color = RGB(109,109,245),
	--		Type = TYPE_LINE,
	--		Width = 2
	--	}
--	}
--} 

Settings={} 
Settings.Name = "Option Open Interest" 

function Init()
	--dofile(getScriptPath() .. "\\Lib.lua")
	SourceInfo = {}
	isInit = true
	--if SourceInfo == nil then
	-- PrintDbgStr("SourceInfo == nil")
	--else
	--	PrintDbgStr("SourceInfo ~= nil")
	--	PrintDbgStr("SourceInfo.class_code = " .. SourceInfo.class_code)
	--	PrintDbgStr("SourceInfo.sec_code = " .. SourceInfo.sec_code)
	--end
	--if Security == nil then
	--   PrintDbgStr("Security == nil")
	--else
	--	PrintDbgStr("Security ~= nil")
	--	PrintDbgStr("min_price_step: " .. Security.min_price_step)
	--end
	return 1
end

function OnCalculate(index)

	if isInit then
		SourceInfo = getDataSourceInfo()
		indexes = SearchItems("all_trades", 0, getNumberOf("all_trades") - 1, SecurityFilter, "code, class_code")
		
		--Security = getItem("securities", indexes[1])
		
		isInit = false
	end	
	
	body = math.abs(C(index) - O(index))
	
	if body == 0 then
		return nil
	end	
	
	ticks = body / Security.min_price_step
	value = V(index) / ticks
	
	return value
	
end



--function OnDestroy() 
	--Log("OnDestroy()") 
	--if file~=nil then file:close() end 
--end

--function Reindex()

   --temp = {}	
   --for i = 2, Settings.Period do temp[i-1] = map[i] end
   --map = temp
   
--end

--function TradesFilter(sec_code, class_code, time)

  --local ot = DateTimeCompare(time, OpenTime)
  --local ct = DateTimeCompare(time, CloseTime)
  
  --if SourceInfo.class_code == class_code and SourceInfo.sec_code == sec_code and ot >= 0 and ct < 0 then 
  --    return true
  --else
  --    return false
  --end
  
--end

function SecurityFilter(code, class_code)

  if SourceInfo.class_code == class_code and SourceInfo.sec_code == code then 
      return true
  else
      return false
  end
  
end

--RI105000BO7

--string.sub(s, startidx [, stopidx])

function GetOptionInfo(optCode)

	local optionInfo = {}
	
	optionInfo.BaseCode = GetUnderlingCodeByOptCode(optCode) -- код подлещащего актива
	optionInfo.Strike = GetStrikeFromOptCode(optCode) -- страйк 
	optionInfo.OptExpMonth = GetOptExpiryMonthByCode(GetExpCodeFromOptCode(optCode), "") 
	optionInfo.FutExpMonth = GetFutExpiryByOptMonth(optionInfo.OptExpMonth)
	optionInfo.Year = 2010 + GetYearFromOptCode(optCode)
	
	return optionInfo

end


-- Возвращает месяц экспирации опциона в виде числа по коду месяца
-- monthCode - код месяца, optionType - тип опциона
function GetOptExpiryMonthByCode(monthCode, optionType)

	local codes = {}
	local month = nil
	local stop = 1
	
	if string.upper(optionType) == "PUT" then
		codes = GetPutMonthCodes()
	elseif string.upper(optionType) == "CALL" then
		codes = GetCallMonthCodes()
	else
		codes = GetPutMonthCodes()
		stop = 2
	end
	
	for k = 1, stop do
		for i = 1, 12 do 
			if codes[i] == string.upper(monthCode) then
				month = i
				break
			end	
		end
		codes = GetCallMonthCodes()
	end	
	
	return month
	
end

-- возвращaет таблицу кодов месяцев для опционов Call
function GetCallMonthCodes()
	local codes = {}
	codes[1] = "A"
	codes[2] = "B"
	codes[3] = "C"
	codes[4] = "D"
	codes[5] = "E"
	codes[6] = "F"
	codes[7] = "G"
	codes[8] = "H"
	codes[9] = "I"
	codes[10] = "J"
	codes[11] = "K"
	codes[12] = "L"
	return codes
end

-- возвращaет таблицу кодов месяцев для опционов Put
function GetPutMonthCodes()
	local codes = {}
	codes[1] = "M"
	codes[2] = "N"
	codes[3] = "O"
	codes[4] = "P"
	codes[5] = "Q"
	codes[6] = "R"
	codes[7] = "S"
	codes[8] = "T"
	codes[9] = "U"
	codes[10] = "V"
	codes[11] = "W"
	codes[12] = "X"
	return codes
end

-- возвращaет таблицу кодировки месяцев для фьючерсов
function GetFutMonthCodes()

	local codes = {}
	codes[1] = "F"
	codes[2] = "G"
	codes[3] = "H"
	codes[4] = "J"
	codes[5] = "K"
	codes[6] = "M"
	codes[7] = "N"
	codes[8] = "Q"
	codes[9] = "U"
	codes[10] = "V"
	codes[11] = "X"
	codes[12] = "Z"
	return codes
end

-- Возвращает месяц экспирации базового фьючерса по месяцу экспирации опциона
-- optMonth - месяц экспирации опциона
function GetFutExpiryByOptMonth(optMonth)

	if optMonth >= 1 and optMonth <= 3 then  
		return 3
	elseif optMonth >= 4 and optMonth <= 6 then 
		return 6
	elseif optMonth >= 7 and optMonth <= 9 then 
		return 9
	elseif optMonth >= 10 and optMonth <= 12 then 
		return 12
	end
	
	return nil
	
end

function GetYearFromOptCode(optCode)

	local year = nil
	
	if type(string.sub(optCode, -1)) == "number" then
		year = string.sub(optCode, -1)
	else type(string.sub(optCode, -2)) == "number" then
		year = string.sub(optCode, -2)
	end

	return year

end

-- Возвращает код месяца экспирации опциона, вычисляя его из кода опциона
function GetExpCodeFromOptCode(optCode)

	local expCode = nil
	
	if type(string.sub(optCode, -1)) == "number" then
		expCode = string.sub(optCode, -2)
	else type(string.sub(optCode, -2)) == "number" then
		expCode = string.sub(optCode, -3)
	end

	return expCode

end

-- Возвращает страйк опциона, вычисляя его из кода опциона  
function GetStrikeFromOptCode(optCode)

	local strike = -1
	
	for i = 3, #optCode do 
		if type(string.sub(optCode, i, i)) ~= "number" then
			strike = string.sub(optCode, 3, i - 1)
			break
		end
	end

	return strike

end


-- Возвращает код подлещащего актива, вычисляя его из кода опциона  
function GetUnderlingCodeByOptCode(optCode)

	local underling = nil

    local baseCode =  string.sub(optCode, 1, 2)
	
	local year = GetYearFromOptCode(optCode)
	
	if year ~= nil then
		local expCode = GetExpCodeFromOptCode(optCode)
		if expCode ~= nil then
			optMonth = GetOptExpiryMonthByCode(expCode)
			if optMonth ~= nil then
				futMonth = GetFutExpiryByOptMonth(optMonth)
				if futMonth ~= nil then
					futCodes = GetFutMonthCodes()
					futCode = futCodes[futMonth] 
					underling = string.format("%s%s%i", baseCode, futCode, year); 
				end
			end
		end
	end
	
	return underling
	
end


-- Сравнивает две структуры datetime, и возвращaет
--  0, если time1 = time2;
--  1, если time1 > time2;
-- -1, если time1 < time2.
--function DateTimeCompare(time1, time2)

--    local sec1 = GetSecondsWithFractions(time1)
--	local sec2 = GetSecondsWithFractions(time2)
--	return Compare(sec1, sec2)
	
--end	

-- Суммирует две структуры datetime.
-- Возвращаемое значение - новая структура datetime 
--function DateTimeAdd(time1, time2)

--	local sec = GetSecondsWithFractions(time1) + GetSecondsWithFractions(time2)
--	return GetDatetime(sec)
	
--end

-- Находит разность двух структур datetime (time1 - time2).
-- Возвращаемое значение - новая структура datetime 
--function DateTimeSubstract(time1, time2)

--	local sec = GetSecondsWithFractions(time1) - GetSecondsWithFractions(time2)
--	if sec < 0 then return nil end	
--	return GetDatetime(sec)
	
--end

-- Суммирует структуру datetime с заданным числом дней days.
-- Для вычитания используйте отрицательное значение days 
--function AddDay(time, days)
--    return AddHour(time, days * 24) 
--end

-- Суммирует структуру datetime с заданным числом часов hours.
-- Для вычитания используйте отрицательное значение hours
--function AddHour(time, hours)
--	return AddMinute(time, hours * 60)
--end

-- Суммирует структуру datetime с заданным числом минут minutes.
-- Для вычитания используйте отрицательное значение minutes
--function AddMinute(time, minutes)
--	return AddSecond(time, minutes * 60)
--end

-- Суммирует структуру datetime с заданным числом секунд seconds.
-- Для вычитания используйте отрицательное значение seconds 
-- Допускается использование дробных значений секунд, например, 
-- если seconds = 0.01, то будет добавлено 10 ms
--function AddSecond(time, seconds)
--	local sec = GetSecondsWithFractions(time) + seconds 
--	if sec < 0 then return nil end	
--	return GetDatetime(sec)
--end

-- Преобразует структуру datetime в число секунд, прошедших с полуночи 1 января 1970 года,
-- где дробная часть сооветсвует числу миллисекунд (микросекунд)
--function GetSecondsWithFractions(time)

--    local sec = os.time(time)
--	local ms = 0 local mcs = 0
--	if (time1.ms ~= nil) then ms = time1.ms * 0.001 end
--	if (time1.mcs ~= nil) then mcs = time1.mcs * 0.000001 end
--	return sec + ms + mcs 
--end

-- Преобразует число секунд, прошедших с полуночи 1 января 1970 года, в структуру datetime
-- где дробная часть сооветсвует числу миллисекунд (микросекунд)
--function GetDatetime(sec)

--    local datetime = os.date("*t",  math.floor(sec));
--	local frac = sec - math.floor(sec)
--	datetime.ms = math.floor(frac * 1000)
--	datetime.mcs = 1000 *(frac - (datetime.ms /1000))
--	return datetime
	
--end

-- Сравнивает два числа, и возвращaет
--  0 - если arg1 = arg2
--  1 - если arg1 > arg2
-- -1 - если arg1 < arg2
--function Compare(arg1, arg2)

--	if arg1 > arg2 then
--		return 1
--	elseif arg1 < arg2 then
--		return -1
--	else
--		return 0
--	end
--end

--function IntervalToMinute(interval)
-- 	if interval == 0 then
--		return nil
--	elseif interval > 0 then
	
--	elseif interval < 0 then
--	elseif interval == 3 then
--	elseif interval == 4 then
--	elseif interval == 5 then
--	elseif interval == 6 then
--	elseif interval == 10 then
--	elseif interval == 15 then
--	elseif interval == 0 then
--	end
	
-- end



--   0 Тиковый  
--   1 1 минута  
--   2 2 минуты  
--   3 3 минуты  
--   4 4 минуты
--   5 5 минут
--   6 6 минут
--  10 10 минут
--  15 15 минут
--  20 20 минут
--  30 30 минут
--  60 1 час
-- 120 2 часа
-- 240 4 часа
--  -1 1 день
--  -2 1 неделя
--  -3 1 месяц



--- Справочная информация		   
--seconds = os.time(datetime); -- в seconds будет значение 1427052491
-- Представить время в секундах в виде таблицы datetime
--datetime = os.date("*t",seconds);
 
-- Преобразование строки даты/времени в таблицу datetime
--dt = {};
--dt.day,dt.month,dt.year,dt.hour,dt.min,dt.sec = string.match("22/03/2015 22:28:11","(%d*)/(%d*)/(%d*) (%d*):(%d*):(%d*)");
--for key,value in dt do dt[key] = tonumber(value) end
 
-- А так можно получить текущие дату/время сервера в виде таблицы datetime
--dt = {};
--dt.day,dt.month,dt.year,dt.hour,dt.min,dt.sec = string.match(getInfoParam('TRADEDATE')..' '..getInfoParam('SERVERTIME'),"(%d*).(%d*).(%d*) (%d*):(%d*):(%d*)")
--for key,value in pairs(dt) do dt[key] = tonumber(value) end

--   0 Тиковый  
--   1 1 минута  
--   2 2 минуты  
--   3 3 минуты  
--   4 4 минуты
--   5 5 минут
--   6 6 минут
--  10 10 минут
--  15 15 минут
--  20 20 минут
--  30 30 минут
--  60 1 час
-- 120 2 часа
-- 240 4 часа
--  -1 1 день
--  -2 1 неделя
--  -3 1 месяц
 


--trade_num NUMBER Номер сделки в торговой системе 
--flags  NUMBER  Набор битовых флагов  
--price  NUMBER  Цена  
--qty  NUMBER  Количество бумаг в последней сделке в лотах  
--value  NUMBER  Объем в денежных средствах  
--accruedint  NUMBER  Накопленный купонный доход  
--yield  NUMBER  Доходность  
--settlecode  STRING  Код расчетов  
--reporate  NUMBER  Ставка РЕПО (%)  
--repovalue  NUMBER  Сумма РЕПО  
--repo2value  NUMBER  Объем выкупа РЕПО  
--repoterm  NUMBER  Срок РЕПО в днях  
--sec_code  STRING  Код бумаги заявки  
--class_code  STRING  Код класса  
--datetime  TABLE  Дата и время  
--period  NUMBER  Период торговой сессии. Возможные значения: 
--«0» – Открытие; 
--«1» – Нормальный; 
--«2» – Закрытие 
--open_interest  NUMBER  Открытый интерес  

--mcs  NUMBER  Микросекунды  
--ms  NUMBER  Миллисекунды  
--sec  NUMBER  Секунды   
--min  NUMBER  Минуты  
--hour  NUMBER  Часы  
--day  NUMBER  День  
--week_day  NUMBER  Номер дня недели  
--month  NUMBER  Месяц  
--year  NUMBER  Год  
