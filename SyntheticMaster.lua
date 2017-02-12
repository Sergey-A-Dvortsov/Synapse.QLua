-- ��������� �������������� �����������
-- ��������� ������� ������� ������������� ������������, � ��� ����� ������� �������

Settings = {
    Name = "Synthetic Master",
	Mode = 0, -- ��. ����
	BaseCoeff = 1, -- ���������� ��� �������� �����������
	Tags = "", -- ������ ��������������� ��������, ����������� � ������� �������� �������������� �����������
	TagCoeffs = 1, -- ������ ������������� ��� ������������, ���������� � ����������������� ��������
    line = { { Name = "Spread", Color = RGB(0, 0, 255), Type = TYPE_LINE, Width = 1, } }
}

-- ���� Mode = 0, �� ������������ �������:
-- synthetic = (Base * BaseCoeff) + (tag1 * tagCoeff1) + (tag2 * tagCoeff2) ... + (tagN * tagCoeffN)   
-- � �������� ������ ������������ �������:
-- synthetic = ((tag1 * tagCoeff1) + (tag2 * tagCoeff2) ... + (tagN * tagCoeffN)) / (Base * BaseCoeff)  


function Init()
	dofile(getScriptPath() .. "\\Lib.lua") -- "������������" ����� ����� ������� �����. 
	SourceInfo = {}
	Candles = nil
	Interval = nil
	isInit = true -- ���� - ���������� ��������� �� ����������� �������� (�������� ��� ��������� ������ �����)
	LastIndex = 0
	cndCount = 0
	return 1
end

--ChartIdMXH7

function OnCalculate(index)

	local value = nil

	-- ����� ����������� ����������� �������� 
	if isInit then
		isInit = false
		PrintDbgStr("�������������� ���������")
		SourceInfo = getDataSourceInfo() -- �������� ���������� �� ��������� ������ �������
		
		Tags = "", -- ������ ��������������� ��������, ����������� � ������� �������� �������������� �����������
		TagCoeffs = 1, -- ������ ������������� ��� ������������, ���������� � ����������������� ��������
		
		cnt = getNumCandles(Settings.Id)
		PrintDbgStr("cndCount: " .. cndCount)
		Candles,cndCount,l = getCandlesByIndex(Settings.Id, 0, 0, cnt) 
		
		PrintDbgStr(Settings.SecCode .. "/" .. Settings.ClassCode)
		
		if Candles == nil then
			PrintDbgStr("t is nil")
		else
			PrintDbgStr("t not nil, cnt: " .. cndCount)
		end
		
		--if Candles == nil then
		--	PrintDbgStr(err)
		--	error(err)
		--else
		--	PrintDbgStr("Candles not nil")
		--end
		
	end
	
	if LastIndex == index then -- �������������� ������������� ������
		local cnt = getNumCandles(Settings.Id)
		Candles,cndCount,l = getCandlesByIndex(Id, 0, 0, cnt) 
	end
	
	if Candles ~= nil and cndCount > 0 then
		local candle = GetCandleByTime(T(index))
		if candle ~= nil then
			if Settings.Ratio == 0 then
				value = candle.close / C(index)
			else
				value = candle.close - (C(index) * Settings.Ratio)
			end
		end
	end
	
	LastIndex = index
	return value
	
end


function getTagInfo()
	local tags = ""
	Coeffs
end

function GetCandleByTime(time)
	if cndCount == 0 then
		return nil
	end
	for i = 0, cndCount - 1 do
		if os.time(time) == os.time(Candles[i].datetime) then  
			return Candles[i]
		end
	end
	return nil
end


function GetBarByTime(time)
    if #RelatedBars == 0 then
		return nil
	end
	
	for i = 1, #RelatedBars do
		local bar = RelatedBars[i] 
		if IntoDateTimeRange(time, bar.Range) then
			return bar
		end
	end
	
	return nil

end

-- ������ �������a�� ������� ����� ������������� �����������
function TradesFilter(sec_code, class_code)

  if Settings.ClassCode == class_code and Settings.SecCode == sec_code then 
      return true
  else
      return false
  end
  
end

-- ���������� ������� "������������" �����. ���� �������������� �� ������
-- ������� "������������ ������"
function GetRelatedBars(indexes)
	
	local bars = {}
	local range = nil -- �������� ������� ����: range.Min = ����� ��������, range.Max = ����� ��������
	local index = 0
	
	for i = 1, #indexes do
	
		local trade = getItem("all_trades", indexes[i])
		
		if trade ~= nil then
		
			-- � ���� ����� ��������� ����� ���, ����:
			-- 1. ������ ������ ������ (i == 1)
			-- 2. ����� ������� ������ ����� �� ������� ��������� �������� ����
			if i == 1 or not IntoDateTimeRange(trade.datetime, bars[index].Range) then
			
			    if index > 0 then
					PrintDbgStr("Time: " .. TimeToString(trade.datetime) .. "Open: " .. bars[index].Open .. " High: " .. bars[index].High .. " Low: " .. bars[index].Low .. " Close: " .. bars[index].Close)
				end	
			
				index = index + 1
				bars[index] = {}
				
				bars[index].Range = GetDateTimeRange(trade.datetime, SourceInfo.interval)
				bars[index].Open = trade.price
				bars[index].High = trade.price
				bars[index].Low = trade.price
				bars[index].Close = trade.price
				bars[index].Volume = 0
			
			end		
			
			-- ����� ����������� �������� �������� ����
			if trade.price > bars[index].High then
				bars[index].High = trade.price
			end		
			
			if trade.price < bars[index].Low then
				bars[index].Low = trade.price
			end		
			
			bars[index].Close = trade.price
			bars[index].Volume = bars[index].Volume + trade.qty 
			
			--if i < 1000 then
				--PrintDbgStr("index: " .. index .. " qty: " .. trade.qty .. " side: " .. side .. " delta: " .. values[index].Value)
			--end		
			
		end
	end
	
	return bars

end

function TimeToString(time)
--sec  NUMBER  �������   
--min  NUMBER  ������  
--hour  NUMBER  ����  
	return (string.format("%i:%i:%i", time.hour, time.min, time.sec))
end

-- ��������� ������� "������������" �����. ���� �������������� �� ������
-- ������� "������������ ������"
function UpdateRelatedBars(indexes)

	local index = #RelatedBars
	
	for i = 1, #indexes do
	
		local trade = getItem("all_trades", indexes[i])
		
		if trade ~= nil then
		
			if not IntoDateTimeRange(trade.datetime, RelatedBars[index].Range) then
				
				index = index + 1
				RelatedBars[index] = {}
				RelatedBars[index].Range = GetDateTimeRange(trade.datetime, SourceInfo.interval)
				RelatedBars[index].Open = trade.price
				RelatedBars[index].High = trade.price
				RelatedBars[index].Low = trade.price
				RelatedBars[index].Volume = 0
			
			end
			
			if trade.price > RelatedBars[index].High then
				RelatedBars[index].High = trade.price
			end		
			
			if trade.price < RelatedBars[index].Low then
				RelatedBars[index].Low = trade.price
			end		
			
			RelatedBars[index].Close = trade.price
			RelatedBars[index].Volume = RelatedBars[index].Volume + trade.qty
			
		end
	end

end

-- ������������ ��������� ����� (��������) ��� �������� ������� � ����������. 
-- time - ��������� ������� QLua, timeframe - ��������� � �������.   
function GetDateTimeRange(time, timeframe)
    local range = {}
	
	local secframe = timeframe * 60
	local sec = os.time(time)
	local min = secframe * math.floor(sec / secframe)  
	range.Min = min
	range.Max = range.Min + secframe - 1
	return range
end 

-- ���������� true, ���� ����� time ����� ������ ��������� range
function IntoDateTimeRange(time, range)
	local sec = os.time(time)
 	return sec >= range.Min and sec <= range.Max
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


function GetInterval(interval)

	PrintDbgStr("Interval: " .. interval)

	if interval == -3 then
		return INTERVAL_MN1
	elseif interval == -2 then
		return INTERVAL_W1
	elseif interval == -1 then
		return INTERVAL_D1
	elseif interval == 0 then
		return INTERVAL_TICK
	elseif interval == 1 then
		return INTERVAL_M1
	elseif interval == 2 then
		return INTERVAL_M2
	elseif interval == 3 then
		return INTERVAL_M3
	elseif interval == 4 then
		return INTERVAL_M4
	elseif interval == 5 then
	
		return INTERVAL_M5
	elseif interval == 6 then
		return INTERVAL_M6
	elseif interval == 10 then
		return INTERVAL_M10
	elseif interval == 15 then
		return INTERVAL_M15	
	elseif interval == 20 then
		return INTERVAL_M20	
	elseif interval == 30 then
		return INTERVAL_M30	
	elseif interval == 60 then
		return INTERVAL_H1	
	elseif interval == 120 then
		return INTERVAL_H2
	elseif interval == 240 then
		return INTERVAL_H4
	else
		return nil
	end

end

 


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
--open_interest NUMBER �������� ������� 
--exchange_code STRING  ��� ����� � �������� ������� 






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
