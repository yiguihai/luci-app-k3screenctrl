-- Copyright (C) 2018 XiaoShan mivm.cn

local m, s ,o

m = Map("k3screenctrl", translate("Screen"), translate("Customize your device screen"))

s = m:section(TypedSection, "general", translate("General Setting") )
s.anonymous = true

o = s:option(ListValue, "screen_time", translate("Screen time :"), translate("This time no action, the screen will close."))
o:value("60",translate("1 Minute"))
o:value("120",translate("2 Minutes"))
o:value("180",translate("3 Minutes"))
o:value("300",translate("5 Minutes"))
o.rmempty = false

o = s:option(ListValue, "refresh_time", translate("Refresh interval :"), translate("Screen data refresh interval."))
o:value("1",translate("1 Second"))
o:value("2",translate("2 Seconds"))
o:value("5",translate("5 Seconds"))
o:value("10",translate("10 Seconds"))
o.rmempty = false

o = s:option(ListValue, "check_stable", translate("Check update interval :"), translate("Stable openwrt version check interval"))
o:value("1",translate("1 Day"))
o:value("2",translate("2 Days"))
o:value("3",translate("3 Days"))
o:value("5",translate("5 Days"))
o:value("10",translate("10 Days"))
o:value("20",translate("20 Days"))
o:value("30",translate("30 Days"))
o.rmempty = false

o = s:option(Value, "weather_key", translate("Private Key :"))
o.placeholder = "S50NSz27cfrFGx00R"

o = s:option(Value, "weather_city", translate("City :"), translate("Example: Beijing"))

o = s:option(ListValue, "weather_delay", translate("Weather update interval :"))
o:value("10",translate("10 Minutes"))
o:value("30",translate("30 Minutes"))
o:value("60",translate("1 Hour"))
o:value("120",translate("2 Hours"))
o:value("180",translate("3 Hours"))
o:value("300",translate("5 Hours"))
o:value("360",translate("6 Hours"))
o.rmempty = false

o = s:option(Flag, "psk_hide", translate("Hide Wireless password"))
o.default = 0

o = s:option(Button,"test_print",translate("Test"),translate("Execute k3screenctrl -t and return the result"))
o.inputtitle = translate("Print info")
o.write = function()
	luci.sys.call("k3screenctrl -t > /tmp/k3screenctrl.log")
	luci.http.redirect(luci.dispatcher.build_url("admin","services","k3screenctrl"))
end

s = m:section(TypedSection, "device_custom", translate("Device customization") ,translate("Customize the fifth page of device information"))
s.template = "cbi/tblsection"
s.addremove = true
s.anonymous = true

o = s:option(Value,"mac",translate("Device"))
o.datatype = "macaddr"
o.rmempty = false
luci.sys.net.mac_hints(function(t,a)
	o:value(t,"%s (%s)"%{a,t})
end)

o = s:option(Value,"name",translate("Hostname"))

o = s:option(ListValue,"icon",translate("Icon"))
o:value("0",translate("Auto"))
o:value("1",translate("OnePlus"))
o:value("2","360")
o:value("3",translate("Asus"))
o:value("4",translate("Coolpad"))
o:value("5",translate("Dell"))
o:value("6",translate("Haier"))
o:value("7",translate("Hasee"))
o:value("8",translate("Honor"))
o:value("9",translate("HP"))
o:value("10","HTC")
o:value("11",translate("Huawei"))
o:value("12",translate("Apple"))
o:value("13",translate("Lenovo"))
o:value("14",translate("LeEco"))
o:value("15","LG")
o:value("16",translate("Meitu"))
o:value("17",translate("Meizu"))
o:value("18","OPPO")
o:value("19",translate("Phicomm"))
o:value("20",translate("Samsung"))
o:value("21",translate("Smartisan"))
o:value("22",translate("Sony"))
o:value("23","TCL")
o:value("24","ThinkPad")
o:value("25",translate("TongfangPC"))
o:value("26","VIVO")
o:value("27",translate("Microsoft"))
o:value("28",translate("XiaoMi"))
o:value("29",translate("ZTE"))

if nixio.fs.access("/tmp/k3screenctrl.log") then
	s = m:section(TypedSection, "general", translate("Output results"))
	s.anonymous = true
	o = s:option(TextValue,"test_output_results")
	o.readonly = true
	o.rows = 30
	o.cfgvalue = function()
		return luci.sys.exec("cat /tmp/k3screenctrl.log && rm -f /tmp/k3screenctrl.log")
	end
end

return m
