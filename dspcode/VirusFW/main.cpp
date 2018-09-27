/*
 * main.cpp
 *
 *  Created on: 26/09/2018
 *      Author: AdrianDesk
 */


#include "VirusFWParser.h"
#include <iostream>
#include <cstring>
using namespace std;


typedef struct
{
   const char* str;
   int flags;
} options_t;

enum
{
   REPACK,
   TO_BIGENDIAN,
};

options_t options[] = {
      {"--repack", VirusFWParser::REPACK},
      {"--endian", VirusFWParser::ENDIAN_CHANGE},
};

int main(int argc, char *argv[])
{

   if( argc < 2 )
   {
      cout << "Usage: Parser <options> <filename.bin>\n";
      cout << "Parser takes a combined firmware section and \n\t splits it up into their respective sections\n";
      cout << "Options: \n";
      cout << "--repack :\tRemoves header information leaving only raw binary\n";
      cout << "--endian :\tSwaps the Endian using 3 bytes\n";
      return 0;
   }

   uint8_t procFlags = 0;

   for(int i = 0; i < sizeof(options)/sizeof(options[0]) ; ++i)
   {
      for(int j = 0; j < argc ; ++j)
      {
         if( (strcmp(argv[j], options[i].str) == 0 ) )
         {
            cout << options[i].str << " enabled!\n";
            procFlags |= options[i].flags;
         }
      }
   }

   cout << "Parsing " << argv[argc-1] << "\n";

   VirusFWParser* parse = new VirusFWParser(argv[argc-1]);
   parse->Split( procFlags );



   return 0;
}
