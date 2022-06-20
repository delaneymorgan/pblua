#include <iostream>
#include <fstream>
#include <string>
#include "manykitchensinks.pb.h"
using namespace std;


#define NELEM(array)    (sizeof(array)/sizeof(*array))


static void makeKitchenSink(tutorial::KitchenSink *kitchenSink)
{
    kitchenSink->set_int32_minus_big( -123456789);
    kitchenSink->set_int32_minus_one( -1);
    kitchenSink->set_int32_zero( 0);
    kitchenSink->set_int32_plus_one( 1);
    kitchenSink->set_int32_plus_big( 123456789);

    kitchenSink->set_int64_minus_big( -123456789);
    kitchenSink->set_int64_minus_one( -1);
    kitchenSink->set_int64_zero( 0);
    kitchenSink->set_int64_plus_one( 1);
    kitchenSink->set_int64_plus_big( 123456789);

    kitchenSink->set_uint32_zero( 0);
    kitchenSink->set_uint32_plus_one( 1);
    kitchenSink->set_uint32_plus_big( 123456789);

    kitchenSink->set_uint64_zero( 0);
    kitchenSink->set_uint64_plus_one( 1);
    kitchenSink->set_uint64_plus_big( 123456789);
    
    kitchenSink->set_sint32_minus_big( -123456789);
    kitchenSink->set_sint32_minus_one( -1);
    kitchenSink->set_sint32_zero( 0);
    kitchenSink->set_sint32_plus_one( 1);
    kitchenSink->set_sint32_plus_big( 123456789);

    kitchenSink->set_sint64_minus_big( -123456789);
    kitchenSink->set_sint64_minus_one( -1);
    kitchenSink->set_sint64_zero( 0);
    kitchenSink->set_sint64_plus_one( 1);
    kitchenSink->set_sint64_plus_big( 123456789);

    kitchenSink->set_fixed32_minus_big( -123456789);
    kitchenSink->set_fixed32_minus_one( -1);
    kitchenSink->set_fixed32_zero( 0);
    kitchenSink->set_fixed32_plus_one( 1);
    kitchenSink->set_fixed32_plus_big( 123456789);

    kitchenSink->set_sfixed32_minus_big( -123456789);
    kitchenSink->set_sfixed32_minus_one( -1);
    kitchenSink->set_sfixed32_zero( 0);
    kitchenSink->set_sfixed32_plus_one( 1);
    kitchenSink->set_sfixed32_plus_big( 123456789);

    kitchenSink->set_float_minus_big( -1.2345e+6);
    kitchenSink->set_float_minus_one( -1.0);
    kitchenSink->set_float_zero( 0.0);
    kitchenSink->set_float_plus_one( 1.0);
    kitchenSink->set_float_plus_big( 1.2345e+6);

    kitchenSink->set_double_minus_big( -1.2345e+6);
    kitchenSink->set_double_minus_one( -1.0);
    kitchenSink->set_double_zero( 0.0);
    kitchenSink->set_double_plus_one( 1.0);
    kitchenSink->set_double_plus_big( 1.2345e+6);

    kitchenSink->set_my_enum( tutorial::KitchenSink::MY_ENUM_2);
    kitchenSink->set_my_string( "Here is a string");
    unsigned char bytes[] = {0x00, 0x01, 0x02, 0x03, 0x04};
    kitchenSink->set_my_bytes( bytes, NELEM( bytes));
}


int main(int argc, char *argv[])
{
    // Verify that the version of the library that we linked against is
    // compatible with the version of the headers we compiled against.
    GOOGLE_PROTOBUF_VERIFY_VERSION;

    if (argc != 2)
    {
        cerr << "Usage:  " << argv[0] << " MANY_KITCHEN_SINKS_FILE" << endl;
        return -1;
    }

    tutorial::KitchenSink kitchenSink;

    for (int ksNo = 0; ksNo < 10; ksNo++)
    {
        makeKitchenSink(&kitchenSink);
    }

    {
        fstream output(argv[1], ios::out | ios::trunc | ios::binary);
        if (!kitchenSink.SerializeToOstream(&output))
        {
            cerr << "Failed to write Many Kitchen Sinks." << endl;
            return -1;
        }
    }

    // Optional:  Delete all global objects allocated by libprotobuf.
    google::protobuf::ShutdownProtobufLibrary();

    return 0;
}
