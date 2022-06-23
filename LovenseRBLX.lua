--[[
  Modified version by stellar#4242 (Original Source Linked Below)                                     
,--.                                                
|  |    ,---.,--.  ,--.,---. ,--,--,  ,---.  ,---.  
|  |   | .-. |\  `'  /| .-. :|      \(  .-' | .-. : 
|  '--.' '-' ' \    / \   --.|  ||  |.-'  `)\   --. 
`-----' `---'   `--'   `----'`--''--'`----'  `----' 
                                                    
    Control your Lovense toy with Roblox
   Made with love by Lunatic#7777 (@170q)

   https://github.com/LovenseFunny/LovenseRBLX
]]

if not Promise then
    loadstring(game:HttpGet('https://raw.githubusercontent.com/stellar-4242/Source/main/Promise.lua'))(); getgenv().Promise = require("{AB02623B-DEB2-4994-8732-BF44E3FDCFBC}")
end

local StarterGui = game:GetService("StarterGui")
local Lovense = {}

--Options
Lovense.debugmode = false;
Lovense.AutoObtainHost = true;
Lovense.Host = "";

function Lovense.GetHost()
	local Req = game:HttpGet("https://api.lovense.com/api/lan/getToys")
    local Response = HttpService:JSONDecode(Req);

	local domain = Response.domain;
	local port = Response.httpsPort;

	if Lovense.debugmode == true then
        print("[Lovense] Response: " .. Response.Body)
		print("[Lovense] Device ID: " .. Response.deviceId);
		print("[Lovense] Platform: " .. Response.platform);
		print("[Lovense] Domain: " .. Response.domain);
		print("[Lovense] Port: " .. Response.httpsPort);
	end

    if domain == nil then
        return "Error"
    else
        if getgenv().ErrorInvoked then
            getgenv().ErrorInvoked = nil
        end
        return domain..":".. port
    end
end

function RouteHost()
    if getgenv().Exempt then
        return true
    end
    local Attempt, Bindable = Promise.promisify(Lovense.GetHost), Instance.new('BindableFunction')
    return Attempt():catch(function(err)
	    if err then
	        getgenv().ErrorInvoked = true
	        
	        Bindable.OnInvoke = function(Response)
	            if Response == "Retry" then
	                RouteHost()
	            end
	        end
	        
            StarterGui:SetCore("SendNotification", {
            	Title = "Lovense",
            	Text = "Failed to find your toy!",
            	Icon = "http://www.roblox.com/asset/?id=7907761855",
            	Duration = 50,
            	Callback = Bindable,
            	Button1 = "Retry",
            	Button2 = "Cancel"
            })
	    end
	end):expect()
end


if Lovense.AutoObtainHost == true then
	Lovense.Host = RouteHost()
else
    return "Error"
end

function Lovense.GetToyInfo()
	local Req = game:HttpGet(Lovense.Host .. "/GetToys")
	local Response = HttpService:JSONDecode(Req);
	if Lovense.debugmode == true then
		print(Response.data)
	else
		--
	end
	return Response.data
end

function Lovense.Domain()
	print(Lovense.Host);
end
function Lovense.GetBattery()
	local Req = game:HttpGet(Lovense.Host .. "/Battery");
	local Response = HttpService:JSONDecode(Req);
	print("Battery Output: " .. Response.battery);
	return Response.battery
end

--Functions for handling vibration & rotation requests
function Lovense.Vibrate(speed, length)

	if speed > 20 then -- Max intensity is 20
		print'[Lovense] Intensity is too high! Please use a number between 0 - 20.';
		return
	else
		-- <3
	end
	
	local Req = game:HttpGet(Lovense.Host .. "/AVibrate?v=" .. speed .. "&sec=" .. length);
	local Response = HttpService:JSONDecode(Req);

	print("[Lovense] Started vibrating at speed " .. speed .. " for " .. length .. " seconds.");

	if Lovense.debugmode == true then
		print(Response.data);
	else
		-- <3
	end
end

function Lovense.Rotate(speed, length)

	if speed > 20 then
		print'[Lovense] Intensity is too high! Please use a number between 0 - 20.';
		return
	else
		-- <3
	end

	local Req = game:HttpGet(Lovense.Host .. "/ARotate?v=" .. speed .. "&sec=" .. length);
	local Response = HttpService:JSONDecode(Req);

	print("[Lovense] Started rotating at speed " .. speed .. " for " .. length .. " seconds.");

	if Lovense.debugmode == true then
		print(Response.data)
	else
		--
	end
end

return Lovense
