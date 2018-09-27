/*
 * VirusFWParser.cpp
 *
 *  Created on: 26/09/2018
 *      Author: AdrianDesk
 */

#include "VirusFWParser.h"
#include <iostream>
#include <fstream>

using namespace std;

VirusFWParser::VirusFWParser(const char* filename) : filename(filename)
{


   // TODO Auto-generated constructor stub

}


void VirusFWParser::Split(uint8_t flags)
{

   header_t hdr;

   fstream infile;
   fstream outfile;


   infile.open(filename, ios::in | ios::binary);
   if( !infile ) {
      cout << "Failed to open " << filename << "\n";
      return;
   }

   char outfileName[10];
   int actualSize = 0;

   while ( !infile.eof())
   {
      infile.read( (char*)&hdr, sizeof(hdr) );
      if( infile.eof() )
      {
         break;
      }


      actualSize = __builtin_bswap32 (hdr.size);

      char * buffer = new char [actualSize];
      infile.read( buffer, actualSize );

      int chunkCount = actualSize / (sizeof(chunk_t)+kDefaultChunkSize);
      /*char* ptr = buffer;
      for( int i = 0 ; i < actualSize; i=i+sizeof(chunk_t)+kDefaultChunkSize )
      {
         chunk_t chunk = {0};

         memcpy( &chunk, ptr+i, sizeof(chunk_t));
         chunkCount++;
      }*/

      memcpy(outfileName, hdr.blockName, 4);
      outfileName[5] = 0;
      cout << "Writing " << outfileName << " Size: " << actualSize << " \tChunk Count : " << chunkCount << "\n";

      outfile.open(outfileName, ios::out | ios::binary | ios::trunc);

      if( flags & REPACK )
      {
         actualSize = StripHeaders(buffer, actualSize);
      }

      if( flags & ENDIAN_CHANGE )
      {
         actualSize = ReverseEndian(buffer, actualSize, 3);
      }

      if( flags == 0)
      {
         outfile.write( (char*)&hdr, sizeof(hdr));
      }

      outfile.write(buffer, actualSize);
      outfile.close();

      delete[] buffer;
   }


   infile.close();
}

uint32_t VirusFWParser::ReverseEndian(char* buffer, uint32_t length, uint8_t byteLen)
{
   char* ptr = buffer;

   uint8_t buf[4];
   uint8_t revbuf[4];

   for( int i = 0 ; i < length; i=i+byteLen )
   {
      memcpy(buf, ptr + i, byteLen);
      for( int j = 0 ; j < byteLen; ++j )
      {
         revbuf[j] = buf[byteLen-j-1];
      }

      memmove(buffer, revbuf, byteLen);
      buffer += byteLen;
   }


   return 0;
}

uint32_t VirusFWParser::StripHeaders(char* buffer, uint32_t length)
{

   char* ptr = buffer;

   uint32_t outputLen = 0;

   for( int i = sizeof(chunk_t) ; i < length; i=i+sizeof(chunk_t)+kDefaultChunkSize )
   {
      chunk_t chunk = {0};
      memmove(buffer, ptr+i, kDefaultChunkSize);

      buffer += kDefaultChunkSize;
      outputLen += kDefaultChunkSize;
   }

   return outputLen;

}

















