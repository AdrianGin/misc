/*
 * VirusFWParser.h
 *
 *  Created on: 26/09/2018
 *      Author: AdrianDesk
 */

#ifndef VIRUSFWPARSER_H_
#define VIRUSFWPARSER_H_

#include <cstdint>

class VirusFWParser
{
public:

   enum eProcessFlags
   {
      REPACK = 0x01,
      ENDIAN_CHANGE = 0x02,
   };

   typedef struct{
      char blockName[4];
      uint32_t size;
   } __attribute__((packed)) header_t;


   typedef struct
   {
      char data[3];

   } __attribute__((packed)) chunk_t;

   const int kDefaultChunkSize = 0x20;

   VirusFWParser(const char* filename);

   void Split(uint8_t flags);

   //Returns actual size
   uint32_t StripHeaders(char* buffer, uint32_t length);
   uint32_t ReverseEndian(char* buffer, uint32_t length, uint8_t byteLen);


private:
   const char* filename;

};

#endif /* VIRUSFWPARSER_H_ */
