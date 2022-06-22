-- pblua - lua protocol buffer decoder test bed
-- Author: Craig McFarlane


local m_p = require( "print")
local m_pbl = require( "pblow")
local m_u = require( "utils")


local PROTOBUF_DATA = "./proto/ks.data"


local inFile = io.open(PROTOBUF_DATA, "rb")
local buffer = inFile:read("*a")
inFile.close()
local bytes = m_u.strToBuf( buffer)
local msg = m_pbl.decodeBuffer( bytes)
for idx,field in ipairs( msg) do
    if field.converted then
        m_p.print( "field No: %d, Type: %d, chunk: %s, converted: %s", idx, field.fieldType, m_p.pbuf( field.chunk), field.converted)
    else
        m_p.print( "field No: %d, Type: %d, chunk: %s", idx, field.fieldType, m_p.pbuf( field.chunk))
    end
end
