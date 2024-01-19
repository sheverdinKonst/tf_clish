#!/usr/bin/lua

print("*************** show_autorestart ver.-.0.0 ***************")
local uci = require("luci.model.uci").cursor()
bit = require "bit"

function main()
    print("this is main function")
    os.execute("tf_poe_restart_ctrl status")

    local res = io.popen("tf_poe_restart_ctrl status"):read("*a")
    print("status = ")
    print(res)

    print("=================================")
    for line in res do
        print(line)
    end
end

main()
