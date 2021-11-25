local medius = require("medius")

------------------------------------------
-- Packet Base
------------------------------------------
Packet = {payload = ""}

function Packet:new(o, payload)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	self.payload = payload or ""
	return o
end

function Packet:setPayload(payload)
	self.payload = payload
end

function Packet:tostring()
	local hex = ""
	for i=1, #self.payload do
		hex = hex .. string.format("%.2X ", self.payload:sub(i, i))
	end
	return string.format("{Packet: {payload_string: \"%s\", payload_hex: \"%s\"}}", self.payload, hex:sub(1, #hex-1))
end

function Packet:toprettystring()
	local hex = ""
	for i=1, #self.payload do
		hex = hex .. string.format("%.2X ", self.payload:sub(i, i))
	end
	return string.format("{\nPacket:\n\t{\n\t\tpayload_string: \"%s\",\n\t\tpayload_hex: \"%s\"\n\t\t}\n}", self.payload, hex:sub(1, #hex-1))
end



------------------------------------------
-- RT Packet
------------------------------------------
RTPacket = Packet:new()

function RTPacket:new(o, rtid, payload)
	o = o or Packet:new()
	setmetatable(o, self)
	self.__index = self
	
	if type(rtid) ~= "number" then
		error("RTPacket:new(rtid, payload): rtid must be a valid medius.rtids value.")
	end
	
	self.rtid = rtid or medius.rtids.RT_MSG_CLIENT_CONNECT_TCP
	self.payload = payload or ""
	
	return o
end






