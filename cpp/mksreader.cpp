#include <iostream>
#include <fstream>
#include <string>
#include "manykitchensinks.pb.h"
using namespace std;


static void PrintKitchenSink( const tutorial::KitchenSink& kitchenSink)
{
    cout << "int32_minus_big: " << kitchenSink.int32_minus_big() << endl;
    cout << "int32_minus_one: " << kitchenSink.int32_minus_one() << endl;
    cout << "int32_zero: " << kitchenSink.int32_zero() << endl;
    cout << "int32_plus_one: " << kitchenSink.int32_plus_one() << endl;
    cout << "int32_plus_big: " << kitchenSink.int32_plus_big() << endl;

    cout << "int64_minus_big: " << kitchenSink.int64_minus_big() << endl;
    cout << "int64_minus_one: " << kitchenSink.int64_minus_one() << endl;
    cout << "int64_zero: " << kitchenSink.int64_zero() << endl;
    cout << "int64_plus_one: " << kitchenSink.int64_plus_one() << endl;
    cout << "int64_plus_big: " << kitchenSink.int64_plus_big() << endl;

    cout << "uint32_zero: " << kitchenSink.uint32_zero() << endl;
    cout << "uint32_plus_one: " << kitchenSink.uint32_plus_one() << endl;
    cout << "uint32_plus_big: " << kitchenSink.uint32_plus_big() << endl;

    cout << "uint64_zero: " << kitchenSink.uint64_zero() << endl;
    cout << "uint64_plus_one: " << kitchenSink.uint64_plus_one() << endl;
    cout << "uint64_plus_big: " << kitchenSink.uint64_plus_big() << endl;

    cout << "sint32_minus_big: " << kitchenSink.sint32_minus_big() << endl;
    cout << "sint32_minus_one: " << kitchenSink.sint32_minus_one() << endl;
    cout << "sint32_zero: " << kitchenSink.sint32_zero() << endl;
    cout << "sint32_plus_one: " << kitchenSink.sint32_plus_one() << endl;
    cout << "sint32_plus_big: " << kitchenSink.sint32_plus_big() << endl;

    cout << "sint64_minus_big: " << kitchenSink.sint64_minus_big() << endl;
    cout << "sint64_minus_one: " << kitchenSink.sint64_minus_one() << endl;
    cout << "sint64_zero: " << kitchenSink.sint64_zero() << endl;
    cout << "sint64_plus_one: " << kitchenSink.sint64_plus_one() << endl;
    cout << "sint64_plus_big: " << kitchenSink.sint64_plus_big() << endl;

    cout << "fixed32_minus_big: " << kitchenSink.fixed32_minus_big() << endl;
    cout << "fixed32_minus_one: " << kitchenSink.fixed32_minus_one() << endl;
    cout << "fixed32_zero: " << kitchenSink.fixed32_zero() << endl;
    cout << "fixed32_plus_one: " << kitchenSink.fixed32_plus_one() << endl;
    cout << "fixed32_plus_big: " << kitchenSink.fixed32_plus_big() << endl;

    cout << "sfixed32_minus_big: " << kitchenSink.sfixed32_minus_big() << endl;
    cout << "sfixed32_minus_one: " << kitchenSink.sfixed32_minus_one() << endl;
    cout << "sfixed32_zero: " << kitchenSink.sfixed32_zero() << endl;
    cout << "sfixed32_plus_one: " << kitchenSink.sfixed32_plus_one() << endl;
    cout << "sfixed32_plus_big: " << kitchenSink.sfixed32_plus_big() << endl;

    cout << "float_minus_big: " << kitchenSink.float_minus_big() << endl;
    cout << "float_minus_one: " << kitchenSink.float_minus_one() << endl;
    cout << "float_zero: " << kitchenSink.float_zero() << endl;
    cout << "float_plus_one: " << kitchenSink.float_plus_one() << endl;
    cout << "float_plus_big: " << kitchenSink.float_plus_big() << endl;

    cout << "double_minus_big: " << kitchenSink.double_minus_big() << endl;
    cout << "double_minus_one: " << kitchenSink.double_minus_one() << endl;
    cout << "double_zero: " << kitchenSink.double_zero() << endl;
    cout << "double_plus_one: " << kitchenSink.double_plus_one() << endl;
    cout << "double_plus_big: " << kitchenSink.double_plus_big() << endl;

    switch (kitchenSink.my_enum()) {
      case tutorial::KitchenSink::MY_ENUM_0:
        cout << "  MY_ENUM_0";
        break;
      case tutorial::KitchenSink::MY_ENUM_1:
        cout << "  MY_ENUM_1";
        break;
      case tutorial::KitchenSink::MY_ENUM_2:
        cout << "  MY_ENUM_2";
        break;
      case tutorial::KitchenSink::MY_ENUM_3:
        cout << "  MY_ENUM_3";
        break;
      case tutorial::KitchenSink::MY_ENUM_4:
        cout << "  MY_ENUM_4";
        break;
    }
    cout << endl;

    cout << "string: " << kitchenSink.my_string() << endl;
    cout << "bytes: " << kitchenSink.my_bytes() << endl;
}


static void ListKitchenSinks(const tutorial::ManyKitchenSinks &manyKitchenSinks)
{
  for (int i = 0; i < manyKitchenSinks.kitchen_sink_size(); i++)
  {
    const tutorial::KitchenSink &kitchenSink = manyKitchenSinks.kitchen_sink(i);
    PrintKitchenSink( kitchenSink);
  }
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

  tutorial::ManyKitchenSinks manyKitchenSinks;

  {
    fstream input(argv[1], ios::in | ios::binary);
    if (!manyKitchenSinks.ParseFromIstream(&input))
    {
      cerr << "Failed to parse Many Kitchen Sinks." << endl;
      return -1;
    }
  }

  ListKitchenSinks(manyKitchenSinks);

  google::protobuf::ShutdownProtobufLibrary();

  return 0;
}
