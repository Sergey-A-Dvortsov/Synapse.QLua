--dofile(getScriptPath() .. "\\Lib.lua")

Settings= 
{ 
	Name = "Open Interest Direct"
	--line =
	--{
	--	{
	--		Name = "r",
	--		Color = RGB(109,109,245),
	--		Type = TYPE_LINE,
	--		Width = 2
	--	}
	--}
} 

function Init()
	--dofile(getScriptPath() .. "\\Lib.lua")
	--SourceInfo = getDataSourceInfo()
	--lastIndex = 0
	--map = {}
	return 1
end

function OnCalculate(index)
	
	--if index > Settings.Period then Reindex() end	
	
	--tradesCount = getNumberOf("all_trades")
	--OpenTime = T(index)
	--CloseTime = AddMinute(OpenTime, SourceInfo.interval) 
	
    --trades = SearchItems("all_trades", lastIndex, tradesCount - 1, TradesFilter, "sec_code, class_code, time")
	
	--oiDelta =  trades[#trades].open_interest - trades[1].open_interest
	--candleDelta = C(index) - O(index)
	
	--mapValue = 0
	
	--if (oiDelta > 0 and candleDelta > 0) or (oiDelta < 0 and candleDelta < 0)
	--	mapValue = 1
	--end	
	
	--value = nil
	
	--if index > Settings.Period then
	
	--	map[Settings.Period] = mapValue
	--	for i = 1, Settings.Period do 
	--		value = value + map[i]  
	--	end	
	--	value = 100 * value / Settings.Period  
		
	--else
	--	map[index] = mapValue
	--	return nil
	--end	
	
	--lastIndex = tradesCount
	
	--return value
	
	return 1
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
