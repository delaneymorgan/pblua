local luaunit = require( "luaunit")

local m_u = require( "utils")


function testBytesToFloat32()
    luaunit.assertAlmostEquals( m_u.bytesToFloat32( {0x00, 0x00, 0x00, 0x00}), 0.0)
    luaunit.assertAlmostEquals( m_u.bytesToFloat32( {0x20, 0xb2, 0x96, 0x49}), 1234500.0)
    luaunit.assertAlmostEquals( m_u.bytesToFloat32( {0x2c, 0x52, 0x9a, 0x44}), 1234.56789, 0.001)
    luaunit.assertAlmostEquals( m_u.bytesToFloat32( {0x2c, 0x52, 0x9a, 0xc4}), -1234.56789, 0.001)
end

os.exit( luaunit.LuaUnit.run() )
