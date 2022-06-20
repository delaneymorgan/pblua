-- pblua - lua protocol buffer decoder test bed
-- Author: Craig McFarlane


local m_p = require( "print")
local m_pbl = require( "pblow")


local PROTOBUF_DATA = "ks.data"


--print( m_p.sprint( "hello"))
local tab = { a=1, b=2, c=3, d={4, 5, 6}, e={z=123, x=321, y="FRED"}}
tab[1] = 1.2345
tab[2] = { 956, 123}
--print( m_p.sprint( "tab: %s", tab))
local inFile = io.open(PROTOBUF_DATA, "rb")
local buffer = inFile:read("*a")
inFile.close()
local bytes = m_p.strToBuf( buffer)
--print( m_p.sprint( "buffer: %s", m_p.pbuf( bytes)))
local msg = m_pbl.decodeBuffer( bytes)
for idx,field in ipairs( msg) do
    if field.converted then
        print( m_p.sprint( "field No: %d, Type: %d, chunk: %s, converted: %s", idx, field.fieldType, m_p.pbuf( field.chunk), field.converted))
    else
        print( m_p.sprint( "field No: %d, Type: %d, chunk: %s", idx, field.fieldType, m_p.pbuf( field.chunk)))
    end
end
