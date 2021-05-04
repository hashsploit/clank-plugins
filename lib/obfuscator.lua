--
-- Lua source file obfuscator #!/sbin/hashsploit
--

local function print_usage()
	print("Usage: obfuscator.lua <source.lua>")
	os.exit(1)
end

local function print_404(path)
	print("File not found: " .. path)
	os.exit(1)
end

local function file_exists(file)
	local f = io.open(file, "r")
	if f then f:close() end
	return f ~= nil
end

local function lines_from(file)
	lines = {}
	for line in io.lines(file) do 
		lines[#lines + 1] = line
	end
	return table.concat(lines, "\n")
end

-- Modified version of LuaSeel 1.2.0
local function obfuscate(b)
local c="function IllIlllIllIlllIlllIlllIll(IllIlllIllIllIll) if (IllIlllIllIllIll==(((((919 + 636)-636)*3147)/3147)+919)) then return not true end if (IllIlllIllIllIll==(((((968 + 670)-670)*3315)/3315)+968)) then return not false end end; "local d=c;local e=""local f={"IllIllIllIllI","IIlllIIlllIIlllIIlllII","IIllllIIllll"}local g=[[local IlIlIlIlIlIlIlIlII = {]]local h=[[local IllIIllIIllIII = load]]local i=[[local IlllIIllIIIIllI = table.concat]]local j=[[local IIIIIIIIllllllllIIIIIIII = "''"]]local k="local "..f[math.random(1,#f)].." = (7*3-9/9+3*2/0+3*3);"local l="local "..f[math.random(1,#f)].." = (3*4-7/7+6*4/3+9*9);"local m=""for n=1,string.len(b)do e=e.."'\\"..string.byte(b,n).."',"end;local o="function IllIIlIllIIIIIl("..f[math.random(1,#f)]..")"local p="function "..f[math.random(1,#f)].."("..f[math.random(1,#f)]..")"local q="local "..f[math.random(1,#f)].." = (5*3-2/8+9*2/9+8*3)"local r="end"local s="IllIIlIllIIIIIl(900283)"local t="function IllIlllIllIlllIlllIlllIllIlllIIIlll("..f[math.random(1,#f)]..")"local q="function "..f[math.random(1,#f)].."("..f[math.random(1,#f)]..")"local u="local "..f[math.random(1,#f)].." = (9*0-7/5+3*1/3+8*2)"local v="end"local w="IllIlllIllIlllIlllIlllIllIlllIIIlll(9083)"local x=m..d..k..l..i..";"..o.." "..p.." "..q.." "..r.." "..r.." "..r..";"..s..";"..t.." "..q.." "..u.." "..v.." "..v..";"..w..";"..h..";"..g..e.."}".."IllIIllIIllIII(IlllIIllIIIIllI(IlIlIlIlIlIlIlIlII,IIIIIIIIllllllllIIIIIIII))()"print(x)
end

if arg == nil or type(arg) ~= "table" then
	print_usage()
	return
end

if #arg ~= 1 then
	print_usage()
	return
end

local path = arg[1]

if not file_exists(path) then
	print_404(path)
	return
end

local source = lines_from(path)

do obfuscate(source) end

