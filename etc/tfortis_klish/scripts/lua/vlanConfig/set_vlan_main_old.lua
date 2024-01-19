#!/usr/bin/lua


print("*************** set_vlan_main_old.lua ver - 1.0 ***************")
local uci = require("luci.model.uci").cursor()
bit = require "bit"

vlanRange_in     = arg[1]
cmd_in           = arg[2]
taggedType_in    = arg[3]
portList_in      = arg[4]
device_in        = "switch"

-- function getUciBridgeVlanList()
--     uci:foreach("network", "bridge-vlan",
--     function(v)
--         local vlan = {}
--         if v.ports ~= nil then
--             local portNumber = 0
--             for portNum , port in pairs(v.ports) do
--                 local portList = {}
--                 port = tostring(port)
--                 local isTaggedBool = 7
--                 --print("===============================")
--                 if string.find(port, ":t") then
--                     --print("true")
--                     local str, num, isTagget = port:match("(%w+)(%d+):(%a+)")
--                     portNumber = tonumber(num)
--                     --portList.state = 1
--                     isTaggedBool = 1
--                     --portList.state = tostring(isTaggedBool)
--                     --portList.id = v.vlan
--                 else
--                     --print("false")
--                     local str, num = port:match("(%a+)(%d+)")
--                     portNumber = tonumber(num)
--                     --portList.state = 0
--                     isTaggedBool = 0
--                     --portList.state = tostring(isTaggedBool)
--                     --portList.id = v.vlan
--                     --portInfo[portNumber] = portList
--                 end
--                  portList.id = v.vlan
--                  portList.str = port
--                  portList.state = isTaggedBool
--                 -- print("portList.id  = ", portList.id)
--                 -- print("portList.state  = ", portList.state)
--                 -- print("portList.state  = ", portList.str)
--                 -- print("portNumber  = ", portNumber)
--                 portInfo[portNumber] = portList
--             end
--             vlan.ports =  portInfo
--             vlan.id     = v[".name"]
--             vlan.num    = v.vlan
--             vlan.device = v.device
--             vlan.index  = v[".index"]
--             brVlanList[v.vlan] = vlan
--         end
--         --print("++++++++++++++++++++++++++++++++++++++")
--         --print("v.vlan = ", v.vlan)
--         --print("v.name = ", v[".name"])
--     end)
-- end

function fillBusyPortList()
    for i = 1, 10 do
        portBusyList[i] = 0
    end

    for key, vlan in pairs(brVlanList) do
        if (vlan.ports == nil) then
            print("For this Vlan: " .. vlan.num .. " ports is not configured")
        else
            for i, port in pairs(vlan.ports) do
                local str, portNumber = port:match("(%a+)(%d+)")
                portNumber = tonumber(portNumber)
                portBusyList[portNumber] = key
            end
        end
    end
end

function fillPortList()
    print("Fill  Ports")
    key_in = tostring(key_in)
    for i = portRange[1], portRange[2] do
        print(" i = ", i, "portBusyList[i] = ", portBusyList[i])
        if portBusyList[i] == 0 or portBusyList[i] == key_in then
            print("add vlanNum 1 = ", i)
            table.insert(lanPorts, "lan" .. i)
        else
            print("Port lan" .. i .. " is used on VlanId: " .. portBusyList[i])
        end
    end
end

--function savePorts(vlan)
--    print("Save Ports")
--    for i, port in pairs(vlan.ports) do
--        local str, portNumber = port:match("(%a+)(%d+)")
--        portNumber = tonumber(portNumber)
--        local portRangeMin = tonumber(portRange[1])
--        local portRangeMax = tonumber(portRange[2])
--        print("portNumber = ", portNumber)
--        if portNumber < portRangeMin or portNumber > portRangeMax then
--            print("add vlanNum_2 = ", portNumber)
--            table.insert(lanPorts, "lan" .. portNumber)
--        end
--    end
--end

function saveUnTaggetPorts(vlan)
    print("Save Ports")
    for i, port in pairs(vlan.ports) do
        print("i = ", i)
        if port == nil then
            print("ports not configured")
        else
            print("Ports: ")
                print(" State   = " ,port.state)
                print(" id      = " ,port.id)
                print(" str     = " ,port.str)
        end
        --local str, portNumber = port:match("(%a+)(%d+)")
        --portNumber = tonumber(portNumber)
        --local portRangeMin = tonumber(portRange[1])
        --local portRangeMax = tonumber(portRange[2])
        --print("portNumber = ", portNumber)
        --print("add vlanNum_2 = ", portNumber)
        --table.insert(lanPorts, "lan" .. portNumber)
    end
end

-- //////////////////////////////////////////////////////////////////


-- function vlan_add_untagged()
--
--     print("************ add_untagged *****************")
--
--     local bridgeVlan = {}
--     local bridge_vlanID = 0
--     portRange = checkPortRange(portList_in)
--
--     if portRange == nil then
--         print("Error, the port range is specified incorrectly")
--     else
--         bridgeVlan = findVlan()
--         print("bridge_vlan KEY = ", bridgeVlan.num)
--         print("bridge_vlan id = ", bridgeVlan.id)
--
--         if bridgeVlan.num == nil then
--             print("-------------------- ADD new Vlan ------------------")
--             print("Vlan with id = " .. key_in .. " not in Use. Was added new Bridge Vlan device")
--             bridge_vlanID = uci:add("network", "bridge-vlan")
--             uci:set("network", bridge_vlanID, "device", "switch")
--             uci:set("network", bridge_vlanID, "vlan", key_in)
--         else
--
--
--
--
--
--
--         end
--
--         local NumPorts = (portRange[2] - portRange[1]) + 1
--         local PortsCount = 0
--
--         fillBusyPortList()
--         fillPortList()
--
--         PortsCount = #lanPorts
--         print("portsCount", PortsCount)
--
--         for i,p in pairs(lanPorts) do
--             print("i = ", i, "p = ", p)
--         end
--
--         if PortsCount > 0 then
--             local res = uci:set_list("network", bridge_vlanID, "ports", lanPorts)
--             if res == false then
--                 print("CMD -> uci:set_list(network, thisVlan.id, ports) " .. bridge_vlanID .. " is failed")
--             elseif res == true then
--                 print("CMD -> uci:set_list(network, thisVlan.id, ports) " .. bridge_vlanID .. " Done " )
--             end
--         else
--             print("------------- NO PORT to add in this Vlan -------------")
--         end
--         res = uci:changes()
--         print("uci:changes:")
--         for i, str in pairs(res) do
--             print("i = ", i)
--             print(str)
--         end
--         uci:commit("network")
--     end
-- end





-- //////////////////////////////////////////////////////

-- function main()
   --getUciBridgeVlanList()
   --
   --if debug_print == 1 then
   --    printParam()
   --    printBrVlanInfo()
   --end


    --
    --
-- end

-- main()

-- =================================================================================



