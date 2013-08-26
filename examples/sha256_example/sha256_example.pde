#include <string.h>
#include <stdio.h>
#include "sha2.h"

/*
Output should be:
ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad
248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1
cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0
*/

void print_hash(unsigned char hash[]) {
  int idx;
  for (idx=0; idx < 32; idx++)
    SerialUSB.print(hash[idx], HEX);
   SerialUSB.println(" ");
}

  unsigned char
    text1[]={"abc"},
    text2[]={"abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"},
    text3[]={"aaaaaaaaaa"},
    hash[32];

void setup() {
  delay(2000);
  SerialUSB.println("sha2 example");
}

void loop() {
  unsigned long t0;
// Hash one
  SerialUSB.print("\nHash #1 (in microseconds): ");
  t0=micros();
  sha2(text1, 3, hash, 0);
  t0=micros()-t0;
  SerialUSB.println(t0);
  print_hash(hash);

  // Hash two
  SerialUSB.print("\nHash #2 (in microseconds): ");
  t0=micros();
  sha2(text2, 56, hash, 0);
  t0=micros()-t0;
  SerialUSB.println(t0);
  print_hash(hash);

   // Hash three
  SerialUSB.print("\nHash #3 (in microseconds): ");
  t0=micros();
  sha2_context ctx;
  sha2_starts(&ctx, 0);
  int idx;
  for (idx=0; idx < 100000; ++idx)
    sha2_update(&ctx, text3, 10);
  sha2_finish(&ctx, hash);
  t0=micros()-t0;
  SerialUSB.println(t0);
  print_hash(hash);
  memset(&ctx, 0, sizeof(sha2_context));
  SerialUSB.println("==========================");

  delay(5000);
}