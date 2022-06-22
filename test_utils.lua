local luaunit = require( "luaunit")

local m_u = require( "utils")


function test_bytesToFloat32()
    luaunit.assertAlmostEquals( m_u.bytesToFloat32( {0x00, 0x00, 0x00, 0x00}), 0.0)
    luaunit.assertAlmostEquals( m_u.bytesToFloat32( {0x20, 0xb2, 0x96, 0x49}), 1234500.0)
    luaunit.assertAlmostEquals( m_u.bytesToFloat32( {0x2c, 0x52, 0x9a, 0x44}), 1234.56789, 0.001)
    luaunit.assertAlmostEquals( m_u.bytesToFloat32( {0x2c, 0x52, 0x9a, 0xc4}), -1234.56789, 0.001)
end

function test_strToBuf()
    local buffer = "DEAD BEEF"
    local bytes = m_u.strToBuf( buffer)
    luaunit.assertEquals( m_u.strToBuf( buffer), {0x44, 0x45, 0x41, 0x44, 0x20, 0x42, 0x45, 0x45, 0x46})
end

os.exit( luaunit.LuaUnit.run() )
