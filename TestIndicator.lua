Settings={}
Settings.Name = "MyTest"
Trades=nil{}
lastIndex = 0
SourceInfo=nil{}
LastCandleTime=nil{}

function Init()
	SourceInfo = getDataSourceInfo()
	--Trades = SearchItems("all_trades", 0, tradesCount-1, tradesFilter, "sec_code, class_code"))
	return 1
end

function OnCalculate(index)
    start = tradesCount
	tradesCount = getNumberOf("all_trades")
	LastCandleTime = T(index)
    Trades = SearchItems("all_trades", lastIndex - 1, TradesCount-1, TradesFilter, "sec_code, class_code, time"))
	lastIndex = tradesCount - 1
	return 1
end

function TradesFilter(sec_code, class_code, time)
  if SourceInfo.class_code == class_code and SourceInfo.sec_code == sec_code then 
      return true
  else
      return false
  end
end

-- Возвращает 0, если time1 = time2
-- Возвращает 1, если time1 > time2
-- Возвращает -1, если time1 < time2
function DateTimeCompare(time1, time2)

	local rezult = Compare(time1.year == time2.year)
	if (rezult == 0)
		rezult = Compare(time1.month, time2.month)
		if (rezult == 0)
			rezult = Compare(time1.day, time2.day)	
			if (rezult == 0)
				rezult = Compare(time1.hour, time2.hour)
				if (rezult == 0)
					rezult = Compare(time1.min, time2.min)
					if (rezult == 0)
						rezult = Compare(time1.sec, time2.sec)			
						if (rezult == 0)
							rezult = Compare(time1.ms, time2.ms)
							if (rezult == 0)
								rezult = Compare(time1.mcs, time2.mcs)			
							end						
						end
					end
				end
			end
		end
	end
	
	return rezult
	
end	

function Compare(arg1, arg2)
	if arg1 > arg2 then
		return 1
	end
	if arg1 < arg2 then
		return -1
	end
	return 0
end

-- Суммирует дату/время time с периодом времени ts
function DateTimeAdd(time, ts)
	
	local result={}
	
	result.year = time.year + ts.year 
	result.month = time.month + ts.month
	CorrectMonth(result)
	
	result.day = time.day + ts.day
	CorrectDay(result)
	
	result.hour = time.hour + ts.hour
	CorrectHour(result)
	
	result.min = time.min + ts.min
	CorrectMin(result)
	
	result.sec = time.sec + ts.sec
	CorrectSec(result)
		
	result.ms = time.ms + ts.ms
	CorrectMs(result)
	
	result.mcs = time.mcs + ts.mcs
	CorrectMcs(result)

	return result
end

-- Возвращает результат вычитания период времени ts из даты/время time 
function DateTimeSubstract(time, ts)
	
	local result={}
	
	result.year = time.year - ts.year 
	
	result.month = time.month - ts.month
	
	CorrectMonth(result)
	
	result.day = time.day - ts.day
	CorrectDay(result)
	
	result.hour = time.hour - ts.hour
	CorrectHour(result)
	
	result.min = time.min - ts.min
	CorrectMin(result)
	
	result.sec = time.sec - ts.sec
	CorrectSec(result)
		
	result.ms = time.ms - ts.ms
	CorrectMs(result)
	
	result.mcs = time.mcs - ts.mcs
	CorrectMcs(result)

	return result
end

function CorrectMonth(time)
	if time.month > 12
		time.year = time.year + 1
		time.month = time.month - 12
	elseif time.month < 0 then
		time.year = time.year - 1
		time.month = time.month + 12
	end
end

function CorrectDay(time)
	days = GetDaysInMonth(time.month, time.year)
	if (time.day > days)
		time.month = time.month + 1
		CorrectMonth(time)
		time.day = time.day - days
	elseif time.day < 0 then
		time.month = time.month - 1
		CorrectMonth(time)
		time.day = time.day + days
	end
end

function CorrectHour(time)
	if time.hour > 24
		time.day = time.day + 1		
		CorrectDay(time)
		time.hour = time.hour - 25
	elseif time.hour < 0 then
		time.day = time.day - 1		
		CorrectDay(time)
		time.hour = time.hour + 24
	end
end

function CorrectMin(time)
	if (time.min > 59)
		time.hour = time.hour + 1		
		CorrectHour(time)
		time.min = time.min - 60
	elseif time.min < 0 then
		time.hour = time.hour - 1		
		CorrectHour(time)
		time.min = time.min + 60
	end
end

function CorrectSec(time)
	if (time.sec > 59)
		time.min = time.min + 1		
		CorrectMin(time)
		time.sec = time.sec - 60
	elseif time.sec < 0 then
		time.min = time.min - 1		
		CorrectMin(time)
		time.sec = time.sec + 60
	end
end

function CorrectMs(time)
	if (time.ms > 999)
		time.sec = time.sec + 1		
		CorrectSec(time)
		time.ms = time.ms - 1000
	elseif time.ms < 0 then
		time.sec = time.sec - 1		
		CorrectSec(time)
		time.ms = time.ms + 1000
	end
end

function CorrectMcs(time)
	if (time.mcs > 999)
		time.ms = time.ms + 1
		CorrectMs(time)
		time.mcs = time.mcs - 1000
	elseif time.mcs < 0 then
		time.ms = time.ms - 1
		CorrectMs(time)
		time.mcs = time.mcs + 1000	
	end
end

function GetDaysInMonth(month, year)
	
	if month == 1 then 
		return 31
	elseif month == 2 then
	 if year % 4 == 0 or (year % 100 == 0 and year % 400 == 0)
		return 29
	 else
		return 28
	 end
	elseif month == 3 then
		return 31
	elseif month == 4 then
		return 30
	elseif month == 5 then
		return 31
	elseif month == 6 then
		return 30
	elseif month == 7 then
		return 31
	elseif month == 8 then
		return 31
	elseif month == 9 then
		return 30
	elseif month == 10 then
		return 31
	elseif month == 11 then
		return 30
	elseif month == 12 then
		return 31
	end

end




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
