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
