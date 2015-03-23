
yourfilename = "yourfilename"    --这里写你自己需要更新的远端服务器上的名字 
file.open(yourfilename, "r")
	local temp = file.readline()
    updateflag = string.sub(temp,0,string.find(temp,"\r\n"))
    temp = nil
file.close()

	Server = "yourserver.name"
 	socket=net.createConnection(net.TCP, 0)
     socket:dns(Server, function(conn,ip) if ip == nil then print("DNS Fail.") node.restart() end end)
     --开始连接服务器
     socket:connect(80, Server)
     socket:on("connection", function(sck) 
      print("connect to:"..Server)
      toget()
	end)

	function toget()
     --HTTP请求头定义

     local rupdateflag = ""
     socket:send("GET /"..yourfilename.." HTTP/1.1\r\n" ..    
            "Host: "..Server.."\r\n" ..
            "Accept: */*" ..
            "User-Agent: Nodemcu CHIPID:"..node.chipid().."\r\n\r\n")
     end

     socket:on("receive", function(sck, response)
     	local rupdateflag=string.sub(response,0,string.find(response,"\r\n"))
     	if updateflag ~= rupdateflag then 
     		file.remove("temp.lua")
     		file.open("temp.lua", "a+")
     		file.writeline(response)
     		file.close()
			file.remove(yourfilename)
			file.rename("temp.lua",yourfilename)
			file.remove("init.lua")
			file.open("init.lua", "a+")
			file.writeline("node.compile(yourfilename)")
			file.writeline("dofile("..string.sub(yourfilename,0,string.find(".lua")-1..".lc)")
			file.close()
	
			node.restart()
		else 
			
		end
     end)

 --    在自己程序里开始部分写入
 --    file.remove("init.lua")
	-- file.open("init.lua", "a+")
	-- file.writeline("dofile(update.lua)")
	-- file.close()
	-- node.restart()
