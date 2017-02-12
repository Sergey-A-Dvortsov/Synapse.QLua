-- Сравнивает две структуры datetime, и возвращaет
--  0, если time1 = time2;
--  1, если time1 > time2;
-- -1, если time1 < time2.
function DateTimeCompare(time1, time2)

    local sec1 = GetSecondsWithFractions(time1)
	local sec2 = GetSecondsWithFractions(time2)
	return Compare(sec1, sec2)
	
end	

-- Суммирует две структуры datetime.
-- Возвращаемое значение - новая структура datetime 
function DateTimeAdd(time1, time2)

	local sec = GetSecondsWithFractions(time1) + GetSecondsWithFractions(time2)
	return GetDatetime(sec)
	
end

-- Находит разность двух структур datetime (time1 - time2).
-- Возвращаемое значение - новая структура datetime 
function DateTimeSubstract(time1, time2)

	local sec = GetSecondsWithFractions(time1) - GetSecondsWithFractions(time2)
	if sec < 0 then return nil end	
	return GetDatetime(sec)
	
end

-- Суммирует структуру datetime с заданным числом дней days.
-- Для вычитания используйте отрицательное значение days 
function AddDay(time, days)
    return AddHour(time, days * 24) 
end

-- Суммирует структуру datetime с заданным числом часов hours.
-- Для вычитания используйте отрицательное значение hours
function AddHour(time, hours)
	return AddMinute(time, hours * 60)
end

-- Суммирует структуру datetime с заданным числом минут minutes.
-- Для вычитания используйте отрицательное значение minutes
function AddMinute(time, minutes)
	return AddSecond(time, minutes * 60)
end

-- Суммирует структуру datetime с заданным числом секунд seconds.
-- Для вычитания используйте отрицательное значение seconds 
-- Допускается использование дробных значений секунд, например, 
-- если seconds = 0.01, то будет добавлено 10 ms
function AddSecond(time, seconds)
	local sec = GetSecondsWithFractions(time) + seconds 
	if sec < 0 then return nil end	
	return GetDatetime(sec)
end

-- Преобразует структуру datetime в число секунд, прошедших с полуночи 1 января 1970 года,
-- где дробная часть сооветсвует числу миллисекунд (микросекунд)
function GetSecondsWithFractions(time)

    local sec = os.time(time)
	local ms = 0 local mcs = 0
	if (time1.ms ~= nil) then ms = time1.ms * 0.001 end
	if (time1.mcs ~= nil) then mcs = time1.mcs * 0.000001 end
	return sec + ms + mcs 
	
end

-- Преобразует число секунд, прошедших с полуночи 1 января 1970 года, в структуру datetime
-- где дробная часть сооветсвует числу миллисекунд (микросекунд)
function GetDatetime(sec)

    local datetime = os.date("*t",  math.floor(sec));
	local frac = sec - math.floor(sec)
	datetime.ms = math.floor(frac * 1000)
	datetime.mcs = 1000 *(frac - (datetime.ms /1000))
	return datetime
	
end

-- Сравнивает два числа, и возвращaет
--  0 - если arg1 = arg2
--  1 - если arg1 > arg2
-- -1 - если arg1 < arg2
function Compare(arg1, arg2)

	if arg1 > arg2 then
		return 1
	elseif arg1 < arg2 then
		return -1
	else
		return 0
	end
	
end



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
