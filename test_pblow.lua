local luaunit = require( "luaunit")

local m_pbl = require( "pblow")


local TPBL = {}


function TPBL.test_zigZagToSInt()
    luaunit.assertNil( m_pbl.zigZagToSInt( -1))
    luaunit.assertEquals( m_pbl.zigZagToSInt( 0), 0)
    luaunit.assertEquals( m_pbl.zigZagToSInt( 1), -1)
    luaunit.assertEquals( m_pbl.zigZagToSInt( 2), 1)
    luaunit.assertEquals( m_pbl.zigZagToSInt( 3), -2)
    luaunit.assertEquals( m_pbl.zigZagToSInt( 4), 2)
    luaunit.assertEquals( m_pbl.zigZagToSInt( 5), -3)
    luaunit.assertEquals( m_pbl.zigZagToSInt( 6), 3)
    luaunit.assertEquals( m_pbl.zigZagToSInt( 7), -4)
    luaunit.assertEquals( m_pbl.zigZagToSInt( 8), 4)
    luaunit.assertEquals( m_pbl.zigZagToSInt( 9), -5)
    luaunit.assertEquals( m_pbl.zigZagToSInt( 10), 5)
    luaunit.assertEquals( m_pbl.zigZagToSInt( 4294967294), 2147483647)
    luaunit.assertEquals( m_pbl.zigZagToSInt( 4294967295), -2147483648)
end

function TPBL.test_decodeBuffer()
end


return TPBL
