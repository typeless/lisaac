// C code generated by Lisaac compiler (www.isaacOS.com) //
int arg_count;
char **arg_vector;

//==========================//
// EXTERNAL                 //
//==========================//

// SYSTEM_IO

#include <stdio.h>
#include <stdlib.h>
  
// Hardware 'print_char'
void print_char(char car)
{
  fputc(car,stdout);
}

// Hardware 'exit'
int die_with_code(int code)
{
  exit(code);
}


// SYSTEM
#include <time.h>

//==========================//
// TYPE                     //
//==========================//

// Generic Object
struct ___OBJ {
  unsigned long __id;
};

// NULL
#ifndef NULL
#define NULL ((void *)0)
#endif

// CHARACTER
typedef char __CHARACTER;

// STRING_CONSTANT
#define __STRING_CONSTANT__ 0
typedef struct STRING_CONSTANT_struct __STRING_CONSTANT;
struct STRING_CONSTANT_struct {
  __CHARACTER *storage__1;
};
// INTEGER
typedef int __INTEGER;


void *table_type[1];

//==========================//
// GLOBAL                   //
//==========================//

__STRING_CONSTANT STRING_CONSTANT_;
#define STRING_CONSTANT__ (&STRING_CONSTANT_)


//==========================//
// STRING CONSTANT          //
//==========================//

__STRING_CONSTANT __string_1={"Hello\n"};

//==========================//
// FUNCTION HEADER          //
//==========================//

// Source code

//==========================//
// SOURCE CODE              //
//==========================//

int main(int argc,char **argv)
{
  __INTEGER Self__XE;
  arg_count  = argc;
  arg_vector = argv;
  Self__XE= 1;
  while ((Self__XE <=  6)) {
    fputc((int)((&__string_1)->storage__1[(__INTEGER)(Self__XE -  1)]),stdout);
    Self__XE=(__INTEGER)(Self__XE +  1);
  };
  return(0);
}
