// C code generated by Lisaac compiler (www.isaacOS.com) //
int arg_count;
char **arg_vector;

//==========================//
// EXTERNAL                 //
//==========================//

// SYSTEM_IO

#include <stdio.h>
#include <stdlib.h>
#include <sys/syscall.h>  
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


void *table_type[0];

//==========================//
// GLOBAL                   //
//==========================//


//==========================//
// FUNCTION HEADER          //
//==========================//

// Source code

//==========================//
// SOURCE CODE              //
//==========================//

int main(int argc,char **argv)
{
  arg_count  = argc;
  arg_vector = argv;
#ifdef _PTHREAD_H
  pthread_key_create(&current_thread, NULL);
  pthread_attr_init(&thread_attr);
  /*pthread_attr_setdetachstate(&thread_attr,PTHREAD_CREATE_DETACHED);*/
#endif
  ;
  syscall(__NR_write, 1,("hello world\n"),( 12));
  return(0);
}
