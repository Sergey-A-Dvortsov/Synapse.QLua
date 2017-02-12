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
	
	optionInfo.BaseCode = GetUnderlingCodeByOptCode(optCode) -- ��� ����������� ������
	optionInfo.Strike = GetStrikeFromOptCode(optCode) -- ������ 
	optionInfo.OptExpMonth = GetOptExpiryMonthByCode(GetExpCodeFromOptCode(optCode), "") 
	optionInfo.FutExpMonth = GetFutExpiryByOptMonth(optionInfo.OptExpMonth)
	optionInfo.Year = 2010 + GetYearFromOptCode(optCode)
	
	return optionInfo

end


-- ���������� ����� ���������� ������� � ���� ����� �� ���� ������
-- monthCode - ��� ������, optionType - ��� �������
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

-- �������a�� ������� ����� ������� ��� �������� Call
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

-- �������a�� ������� ����� ������� ��� �������� Put
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

-- �������a�� ������� ��������� ������� ��� ���������
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

-- ���������� ����� ���������� �������� �������� �� ������ ���������� �������
-- optMonth - ����� ���������� �������
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

-- ���������� ��� ������ ���������� �������, �������� ��� �� ���� �������
function GetExpCodeFromOptCode(optCode)

	local expCode = nil
	
	if type(string.sub(optCode, -1)) == "number" then
		expCode = string.sub(optCode, -2)
	else type(string.sub(optCode, -2)) == "number" then
		expCode = string.sub(optCode, -3)
	end

	return expCode

end

-- ���������� ������ �������, �������� ��� �� ���� �������  
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


-- ���������� ��� ����������� ������, �������� ��� �� ���� �������  
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


-- ���������� ��� ��������� datetime, � �������a��
--  0, ���� time1 = time2;
--  1, ���� time1 > time2;
-- -1, ���� time1 < time2.
--function DateTimeCompare(time1, time2)

--    local sec1 = GetSecondsWithFractions(time1)
--	local sec2 = GetSecondsWithFractions(time2)
--	return Compare(sec1, sec2)
	
--end	

-- ��������� ��� ��������� datetime.
-- ������������ �������� - ����� ��������� datetime 
--function DateTimeAdd(time1, time2)

--	local sec = GetSecondsWithFractions(time1) + GetSecondsWithFractions(time2)
--	return GetDatetime(sec)
	
--end

-- ������� �������� ���� �������� datetime (time1 - time2).
-- ������������ �������� - ����� ��������� datetime 
--function DateTimeSubstract(time1, time2)

--	local sec = GetSecondsWithFractions(time1) - GetSecondsWithFractions(time2)
--	if sec < 0 then return nil end	
--	return GetDatetime(sec)
	
--end

-- ��������� ��������� datetime � �������� ������ ���� days.
-- ��� ��������� ����������� ������������� �������� days 
--function AddDay(time, days)
--    return AddHour(time, days * 24) 
--end

-- ��������� ��������� datetime � �������� ������ ����� hours.
-- ��� ��������� ����������� ������������� �������� hours
--function AddHour(time, hours)
--	return AddMinute(time, hours * 60)
--end

-- ��������� ��������� datetime � �������� ������ ����� minutes.
-- ��� ��������� ����������� ������������� �������� minutes
--function AddMinute(time, minutes)
--	return AddSecond(time, minutes * 60)
--end

-- ��������� ��������� datetime � �������� ������ ������ seconds.
-- ��� ��������� ����������� ������������� �������� seconds 
-- ����������� ������������� ������� �������� ������, ��������, 
-- ���� seconds = 0.01, �� ����� ��������� 10 ms
--function AddSecond(time, seconds)
--	local sec = GetSecondsWithFractions(time) + seconds 
--	if sec < 0 then return nil end	
--	return GetDatetime(sec)
--end

-- ����������� ��������� datetime � ����� ������, ��������� � �������� 1 ������ 1970 ����,
-- ��� ������� ����� ����������� ����� ����������� (�����������)
--function GetSecondsWithFractions(time)

--    local sec = os.time(time)
--	local ms = 0 local mcs = 0
--	if (time1.ms ~= nil) then ms = time1.ms * 0.001 end
--	if (time1.mcs ~= nil) then mcs = time1.mcs * 0.000001 end
--	return sec + ms + mcs 
--end

-- ����������� ����� ������, ��������� � �������� 1 ������ 1970 ����, � ��������� datetime
-- ��� ������� ����� ����������� ����� ����������� (�����������)
--function GetDatetime(sec)

--    local datetime = os.date("*t",  math.floor(sec));
--	local frac = sec - math.floor(sec)
--	datetime.ms = math.floor(frac * 1000)
--	datetime.mcs = 1000 *(frac - (datetime.ms /1000))
--	return datetime
	
--end

-- ���������� ��� �����, � �������a��
--  0 - ���� arg1 = arg2
--  1 - ���� arg1 > arg2
-- -1 - ���� arg1 < arg2
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



--   0 �������  
--   1 1 ������  
--   2 2 ������  
--   3 3 ������  
--   4 4 ������
--   5 5 �����
--   6 6 �����
--  10 10 �����
--  15 15 �����
--  20 20 �����
--  30 30 �����
--  60 1 ���
-- 120 2 ����
-- 240 4 ����
--  -1 1 ����
--  -2 1 ������
--  -3 1 �����



--- ���������� ����������		   
--seconds = os.time(datetime); -- � seconds ����� �������� 1427052491
-- ����������� ����� � �������� � ���� ������� datetime
--datetime = os.date("*t",seconds);
 
-- �������������� ������ ����/������� � ������� datetime
--dt = {};
--dt.day,dt.month,dt.year,dt.hour,dt.min,dt.sec = string.match("22/03/2015 22:28:11","(%d*)/(%d*)/(%d*) (%d*):(%d*):(%d*)");
--for key,value in dt do dt[key] = tonumber(value) end
 
-- � ��� ����� �������� ������� ����/����� ������� � ���� ������� datetime
--dt = {};
--dt.day,dt.month,dt.year,dt.hour,dt.min,dt.sec = string.match(getInfoParam('TRADEDATE')..' '..getInfoParam('SERVERTIME'),"(%d*).(%d*).(%d*) (%d*):(%d*):(%d*)")
--for key,value in pairs(dt) do dt[key] = tonumber(value) end

--   0 �������  
--   1 1 ������  
--   2 2 ������  
--   3 3 ������  
--   4 4 ������
--   5 5 �����
--   6 6 �����
--  10 10 �����
--  15 15 �����
--  20 20 �����
--  30 30 �����
--  60 1 ���
-- 120 2 ����
-- 240 4 ����
--  -1 1 ����
--  -2 1 ������
--  -3 1 �����
 


--trade_num NUMBER ����� ������ � �������� ������� 
--flags  NUMBER  ����� ������� ������  
--price  NUMBER  ����  
--qty  NUMBER  ���������� ����� � ��������� ������ � �����  
--value  NUMBER  ����� � �������� ���������  
--accruedint  NUMBER  ����������� �������� �����  
--yield  NUMBER  ����������  
--settlecode  STRING  ��� ��������  
--reporate  NUMBER  ������ ���� (%)  
--repovalue  NUMBER  ����� ����  
--repo2value  NUMBER  ����� ������ ����  
--repoterm  NUMBER  ���� ���� � ����  
--sec_code  STRING  ��� ������ ������  
--class_code  STRING  ��� ������  
--datetime  TABLE  ���� � �����  
--period  NUMBER  ������ �������� ������. ��������� ��������: 
--�0� � ��������; 
--�1� � ����������; 
--�2� � �������� 
--open_interest  NUMBER  �������� �������  

--mcs  NUMBER  ������������  
--ms  NUMBER  ������������  
--sec  NUMBER  �������   
--min  NUMBER  ������  
--hour  NUMBER  ����  
--day  NUMBER  ����  
--week_day  NUMBER  ����� ��� ������  
--month  NUMBER  �����  
--year  NUMBER  ���  
