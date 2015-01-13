#include <stdlib.h>
#include <stdio.h>
#include <string.h>

//simple buffer handling struct and functions:
struct cBuffer{
	unsigned char* data;
	unsigned int pos, size;
	FILE* file;
};

inline void buffer_init(cBuffer* buff, int size){
	buff->pos=0;
	buff->size=size;
	buff->data= (unsigned char*)malloc(size);
}

inline void buffer_resize(cBuffer* buff, int size){
	if(buff->size < size){
		buff->data= (unsigned char*)realloc(buff->data, size+1);
		buff->size= size;
	}
}

inline void buffer_add(cBuffer* buff, char* str){
	int i=0;
	for(; str[i]!='\0'; i++)
		buff->data[i]= str[i];
	buff->data[i]= '\0';
}

inline bool buffer_set_file(cBuffer* buff, FILE* fp){
	buffer_resize(buff, BUFSIZ);
	buff->file=fp;
	setbuf(fp, (char*)buff->data);
}
inline void buffer_flush(cBuffer* buff){
	fflush(buff->file);
}

inline bool buffer_writeto(const char* fn, cBuffer* buff){
	FILE* f= fopen(fn,"w+b");
	if(!f)return 0;
	fwrite(buff->data, 1, buff->size, f);
	fclose(f);
	return 1;
}

inline bool buffer_readfile(const char* fn, cBuffer* buff){
	FILE* f= fopen(fn,"r+b");
	if(!f)return 0;
	fseek(f,0,SEEK_END);
	int size=ftell(f);
	fseek(f,0,SEEK_SET);
	buffer_resize(buff, size);
	printf("file size= %i\n", size);
	fread(buff->data, 1, buff->size, f);
	fclose(f);
	return 1;
}
