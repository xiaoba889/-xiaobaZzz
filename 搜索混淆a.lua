local setRanges=_ENV["gg"]["setRanges"]
local getResults=_ENV["gg"]["getResults"]
local searchNumber=_ENV["gg"]["searchNumber"]
local getResultsCount, getValues, loadResults, clearResults, setValues = _ENV["gg"]["getResultsCount"], _ENV["gg"]["getValues"], _ENV["gg"]["loadResults"], _ENV["gg"]["clearResults"], _ENV["gg"]["setValues"]

local zero = string.rep("0","25")
local function numBrush()
	local re = {}
	for i=1,10000 do
		re[#re+1] = math.random(0,9)
	end
	re = table.concat(re)
	return zero..string.rep(re,"10")
end
local Brush__ = numBrush()
local Brush = function(num)
	num = string.gsub(num,"%.0","")
	return num.."."..Brush__
end
local getValue=function(Tab)
	local clock = os.clock()
	for i = #Tab+1, #Tab+8000 do
		Tab[i] = {["address"] = Tab[1]["address"], ["flags"] = Tab[1]["flags"]}
	end
	local jg = getValues(Tab)
	while os.clock()-clock > 2 do
		print("Detection LOG or Hook")
		os.exit()
	end
	return jg
end
local SetValue=function(Tab)
	local clock = os.clock()
	for i = #Tab+1, #Tab+8000 do
		Tab[i] = {["address"] = Tab[1]["address"], ["flags"] = Tab[1]["flags"], ["value"] = Tab[1]["value"]}
	end
	setValues(Tab)
	while os.clock()-clock > 2 do
		print("Detection LOG or Hook")
		os.exit()
	end
end
local loadResult=function(Tab)
	local clock = os.clock()
	for i = #Tab+1, #Tab+8000 do
		Tab[i] = {["address"] = Tab[1]["address"], ["flags"] = Tab[1]["flags"], ["value"] = Tab[1]["value"]}
	end
	local jg = loadResults(Tab)
	while os.clock()-clock > 2 do
		print("Detection LOG or Hook")
		os.exit()
	end
	return jg
end
_ENV["gg"]["getResults"]=function(Value)
	Value=Value.."."..string.rep(0,"9999999")
	getResultsCount = Value
	return getResults(Value)
end
_ENV["gg"]["clearResults"]=function(Value)
	clearResults(Value)
	getResultsCount = getResultsCount
end
_ENV["gg"]["setRanges"]=function(Value)
	Value=Value.."."..string.rep(0,"9999999")
	return setRanges(Value)
end
local convert_num = function(Ty)
	local tab = {
		["D"] = 4,
		["d"] = 4,
		["F"] = 16,
		["f"] = 16,
		["E"] = 64,
		["e"] = 64,
		["B"] = 1,
		["b"] = 1,
		["A"] = 127,
		["a"] = 127,
		["Q"] = 32,
		["q"] = 32,
		["X"] = 8,
		["x"] = 8,
		["W"] = 2,
		["w"] = 2,
	}
	return tab[Ty]
end
local function split(str, reps)
	local resultStrList = {}
	string.gsub(str, "[^" .. reps .. "]+", function(w)
		if string.find(suB(w,-1,-1),"[ABDEFQWXabdefqwx]") then
			table.insert(resultStrList, {suB(w,0,-2), convert_num(suB(w,-1,-1))})
		else
			table.insert(resultStrList, {w})
		end
	end)
	return resultStrList
end
_ENV["gg"]["searchNumber"]=function(a,b,c,d,e,f,g)
	local Convert_Type = function(value, ty)
		local conf = {
			[4] = "i4",
			[16] = "f",
			[64] = "d",
			[1] = "i1",
			[2] = "i2",
			[32] = "i8",
		}
		local fmt = conf[ty]
		local data = string.pack(fmt, value)
		data = {string.byte(data,1, #data)}
		local search = {}
		for i, k in pairs(data) do
			search[i] = string.char(k)
		end
		return data, table.concat(search), #data
	end

	local check = function(num)
		if num<0 then
			num = num + 256
		end
		return char(num)
	end

	b=b or 127
	d=d or _ENV["gg"]["SIGN_EQUAL"]
	   e=e or 0 f=f or -1
		g=g or 0

	local rp=string.rep(0,1024^2)

	b=Brush(b) d=d.."."..rp
	   e=e.."."..rp f=f.."."..rp
		 g=g.."."..rp
	if not tonumber(a) then
		return searchNumber(a,b,c,d,e,f,g)
	end
	if getResultsCount() == 0 and tonumber(a) ~= 0 and tonumber(b) ~= 1 and tonumber(b) ~= 2 and tonumber(b) ~= 8 then
		local x1, x2, x3 = Convert_Type(tonumber(a), tonumber(b))
		gg.setVisible(false)
		gg.internal1(x2)
		gg.setVisible(false)
		local rr=gg.getResults(getResultsCount())
		local n1, n2 = 4, 0
		local Star
		local Raep={}
		for i = 1, #rr, x3 do
			if rr[i]["address"]%n1==n2 then
				Raep[#Raep+1]={["address"] = rr[i]["address"], ["flags"] = b}
			else
				rr[i]=nil
			end
			for ii = 1, x3 - 1 do
				rr[i+ii] = nil
			end
		end
		if Raep[1] then
		    gg.setVisible(false)
			loadResult(Raep)
			gg.setVisible(false)
		end
	else
		searchNumber(a,b,c,d,e,f,g)
	end
end
_ENV["gg"]["editAll"]=function(a,b)
	local m2, m3, m4 = 1, 0, 2
	if type(getResultsCount) == "function" then
		getResultsCount = getResultsCount()
	end
	local sear=gg.getResults(getResultsCount)
	if sear[1]==nil then
		return gg.toast("未搜到值")
	end
	if string.find(a,";") then
		a = split(a, ";")
		local Try, _Nt = m3, m3
		while _Nt < #sear do
			Try, _Nt = Try + m2, _Nt + m2
			if Try > #a then
				Try = m2
			end
			sear[_Nt]["value"] = a[Try][m2]
			if a[Try][m4] then
				sear[_Nt]["flags"] = Brush(a[Try][m4])
			else
				sear[_Nt]["flags"] = Brush(b)
			end
		end
	else
		for i, k in pairs(sear) do
			sear[i]["value"] = a
			sear[i]["flags"] = Brush(b)
		end
	end
	return SetValue(sear)
end
