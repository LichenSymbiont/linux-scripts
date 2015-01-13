#include "CAPI.h"
#include <math.h>

float wave[1000];
#define cmusic(i) ((i*(i>>8|i>>9)&46&i>>8))^(i&i>>13|i>>6)
#define cwave(i) (wave[(i)%1000])

int main(int argc, char** args)
{
	for(int i=0; i<1000; i++)wave[i]= (float)cos( ((float)i)/1000.0f );
	
	cBuffer buff;
	buffer_init(&buff, 1000000);
	
	for(int i=0;i<1000000;i++){
		buff.data[i]= -128 + cwave(i*1 + i%12) * 256;
	}
	
	buffer_writeto("cmusic.txt", &buff);
	printf("Music generated!\nUse aplay ./cmusic.txt; to play it\nExit with Ctrl+C\n");
	
	//buffer_readfile("cmusic.txt", &buff);
	//for(int i=0;i<10000;i++)printf("%i,", (int)buff.data[i]);
	
	//system("aplay ./cmusic.txt");
	return 1;
}

