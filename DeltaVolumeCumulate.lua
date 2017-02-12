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
Settings.Name = "Delta Volume Cumulate" 

function Init()
	--dofile(getScriptPath() .. "\\Lib.lua")
	SourceInfo = {}
	DeltaValues = {}
	isInit = true
	NumberOf = 0
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
		NumberOf = getNumberOf("all_trades")
		local indexes = SearchItems("all_trades", 0, NumberOf - 1, TradesFilter, "sec_code, class_code")
		DeltaValues = GetHistoryDeltaValues(indexes) 
		isInit = false
	end	
	
	--if (index >= #DeltaValues)
	--	local start = NumberOf 
	--	NumberOf = getNumberOf("all_trades")
	--	local indexes = SearchItems("all_trades", start, NumberOf - 1, TradesFilter, "sec_code, class_code")
	--	SetDeltaValues(indexes, index)
	--end
	
	if (index <= #DeltaValues) then
		return DeltaValues[index].Value
	else
		return nil
	end
	
	
end


function GetHistoryDeltaValues(indexes)

	local values = {}
	local range = nil
	local index = 0
	local side = ""
	
	for i = 1, #indexes do
	
		local trade = getItem("all_trades", indexes[i])
		
		if trade ~= nil then
		
			if i == 1 or (range ~= nil and not IntoDateTimeRange(trade.datetime, range)) then
			
				range = GetDateTimeRange(trade.datetime, SourceInfo.interval)
				
				index = index + 1
				
				values[index] = {}
				
				values[index].Range = range

				if (index > 1) then
					values[index].Value = values[index - 1].Value
				else
					values[index].Value = 0
				end
			
			end		
		
			if CheckBit(trade.flags, 0) then -- �������
				values[index].Value = values[index].Value - trade.qty 
				side = "sell"
			elseif CheckBit(trade.flags, 1) then -- �������
				values[index].Value = values[index].Value + trade.qty 
				side = "buy"
			end
			
			--if i < 1000 then
				--PrintDbgStr("index: " .. index .. " qty: " .. trade.qty .. " side: " .. side .. " delta: " .. values[index].Value)
			--end		
			
		end
	end
	
	return values

end

function SetDeltaValues(indexes, index)

--	for i = 0, #indexes - 1 do
	
--		local trade = getItem("all_trades", i)
		
--		if IntoDateTimeRange(trade.datetime, DeltaValues[index].Range) then

--			if CheckBit(trade.flags, 0) -- �������
--				DeltaValues[index].Value = DeltaValues[index].Value - trade.qty 
--			elseif CheckBit(trade.flags, 1) -- �������
--				DeltaValues[index].Value = DeltaValues[index].Value + trade.qty 
--			end

--		else
		
--			local range = GetDateTimeRange(trade.datetime, SourceInfo.interval)
--			local index2 = index + 1
--			DeltaValues[index2].Range = range
			
--			if CheckBit(trade.flags, 0) -- �������
--				DeltaValues[index2].Value = DeltaValues[index].Value - trade.qty 
--			elseif CheckBit(trade.flags, 1) -- �������
--				DeltaValues[index2].Value = DeltaValues[index].Value + trade.qty 
--			end
			
--		end		
--	end
end

function GetDateTimeRange(time, timeframe)
    local range = {}
	
	local secframe = timeframe * 60
	local sec = os.time(time)
	local min = secframe * math.floor(sec / secframe)  
	range.Min = min
	range.Max = range.Min + secframe - 1
	return range
end 

function IntoDateTimeRange(time, range)
	local sec = os.time(time)
 	return range.Min >= sec and sec <= range.Max
end 

-- ������� ��������� ���������� ���, ��� ��� (���������� true, ��� false)
function CheckBit(flags, _bit)

   -- ���������, ��� ���������� ��������� �������� �������
   if type(flags) ~= "number" then error("������!!! Checkbit: 1-� �������� �� �����!") end
   if type(_bit) ~= "number" then error("������!!! Checkbit: 2-� �������� �� �����!") end
   
   if _bit == 0 then _bit = 0x1
   elseif _bit == 1 then _bit = 0x2
   elseif _bit == 2 then _bit = 0x4
   elseif _bit == 3 then _bit  = 0x8
   elseif _bit == 4 then _bit = 0x10
   elseif _bit == 5 then _bit = 0x20
   elseif _bit == 6 then _bit = 0x40
   elseif _bit == 7 then _bit  = 0x80
   elseif _bit == 8 then _bit = 0x100
   elseif _bit == 9 then _bit = 0x200
   elseif _bit == 10 then _bit = 0x400
   elseif _bit == 11 then _bit = 0x800
   elseif _bit == 12 then _bit  = 0x1000
   elseif _bit == 13 then _bit = 0x2000
   elseif _bit == 14 then _bit  = 0x4000
   elseif _bit == 15 then _bit  = 0x8000
   elseif _bit == 16 then _bit = 0x10000
   elseif _bit == 17 then _bit = 0x20000
   elseif _bit == 18 then _bit = 0x40000
   elseif _bit == 19 then _bit = 0x80000
   elseif _bit == 20 then _bit = 0x100000
   end
 
   if bit.band(flags, _bit) == _bit then 
		return true
	else 
		return false 
   end
end

function SecurityFilter(code, class_code)

  if SourceInfo.class_code == class_code and SourceInfo.sec_code == code then 
      return true
  else
      return false
  end
  
end

function TradesFilter(sec_code, class_code)

  if SourceInfo.class_code == class_code and SourceInfo.sec_code == sec_code then 
      return true
  else
      return false
  end
  
end




--sec  NUMBER  �������   
--min  NUMBER  ������  
--hour  NUMBER  ����  
--day  NUMBER  ����  
--week_day  NUMBER  ����� ��� ������  
--month  NUMBER  �����  
--year  NUMBER  ���  

--min  NUMBER  ������  
--hour  NUMBER  ����  
--day  NUMBER  ����  
--week_day  NUMBER  ����� ��� ������  
--month  NUMBER  �����  
--year  NUMBER  ���  








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
