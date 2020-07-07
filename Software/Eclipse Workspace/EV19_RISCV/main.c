#include "./Drivers/Keyboard.h"

#include "fixmath.h"
#include "stdbool.h"
//#define __CUSTOM_FILE_IO__ 1

#include "stdio.h"

#include "MyFixPoint.h"

#define KB PS21

//static volatile uint8_t dummy[1] = {8};

#define WIDTH 640
#define HEIGHT 480
#define NITER 12

#define RED_MASK 0b1111100000000000
#define GREEN_MASK 0b0000011111100000
#define BLUE_MASK 0b0000000000011111
#define RGB16(r, g, b)                                                         \
  (uint16_t)((((r) << 11) & RED_MASK) + (((g) << 5) & GREEN_MASK) +                \
             (((b) << 0) & BLUE_MASK))


volatile uint16_t (*screen)[WIDTH] = (uint16_t(*)[WIDTH])PIXEL_BUFFER_BASE;

void keyboardTest();
void runningLed();
void fiboLeds();
void dualCoreTest();
void mandelbrot(int32_t x0,int32_t x1,int32_t y0,int32_t y1);
void interactiveMandelbrot();

int main()
{
	for (int i = 0; i < HEIGHT; i++)
			for (int j = 0; j < WIDTH; j++)
				screen[i][j] = 0;

	//fiboLeds();
	runningLed();
	//fillScreenTest();
	//keyboardTest();
	//mandelbrot1();
	//keyboardTest();
	//interactiveMandelbrot();
  return 0;
}

void fillScreenTest()
{
	uint8_t r=0;
	uint8_t g=0;
	uint8_t b=0;

	while(1)
	{
		uint8_t * leds= (uint8_t *)LEDS_BASE;
		for (int i = 0; i < HEIGHT; i++)
			for (int j = 0; j < WIDTH; j++)
			{
				(*leds) = (1<<((((i+1)*WIDTH+j+1)*8)/(HEIGHT*WIDTH)))-1;
				screen[i][j] = RGB16(r,g,b);
			}
		r+=3;
		g-=3;
	}
}

void keyboardTest()
{
	uint8_t * leds= (uint8_t *)LEDS_BASE;
	uint8_t * button= (uint8_t *)BUTTON_BASE;
	// Clear screen
	for (int i = 0; i < HEIGHT; i++)
		for (int j = 0; j < WIDTH; j++)
			screen[i][j] = 0x00;


	for (int i = 0; i < 180; i++)
				for (int j = 000; j < 550; j++)
					screen[i][j] = 0xDEAD;

	for (int i = 100; i < 150; i++)
				for (int j = 200; j < 250; j++)
					screen[i][j] = 0xF0F0;


	volatile uint8_t * charBuffer = (uint8_t *)CHAR_BUFFER_BASE;

	PS2_Device_t dev;
	int status = PS2_Init(PS21,&dev);

	//if(status==0)
	{
		//if(dev == PS2_KEYBOARD)
		{
			int i=0;
			while(1)
			{
				while((*button)==0);

				KB_CODE_TYPE decodeMode;
				uint8_t b;
				char c;
				if(Keyboard_Decode(KB,&decodeMode, &b, &c) == 0)
				{
					if(c!=' ')
					{
						charBuffer[i] = c;
						(*leds) = c;
						i++;
					}
				}
				int n=10000;
				while(n--);
				//(*leds)=8;

			}

		}
		//else (*leds)=0xFF;
	}
	//else (*leds)=0xF0;

}
void runningLed()
{
	uint8_t * leds= (uint8_t *)LEDS_BASE;
	uint32_t * button = (uint32_t*) BUTTON_BASE;
	uint32_t * dip = (uint32_t*) DIP_BASE;

	while(1)
	{
		for(int i=0; i<8; i++)
		{
			(*leds)=1<<i;//SDRAM[i];
			for(int n=0; n<100000; n++)
				while((*button)==0);
		}
		for(int i=6; i>0; i--)
		{
			(*leds)=1<<i;//SDRAM[i];
			for(int n=0; n<100000; n++)
				while((*button)==0);
		}
	}
}
void fiboLeds()
{
	uint8_t * leds= (uint8_t *)LEDS_BASE;
	uint8_t * SDRAM = (uint8_t *)SDRAM_BASE;

	SDRAM[0]=0;
	SDRAM[1]=1;

	for(int i=2; i<12; i++)
		SDRAM[i]=SDRAM[i-1]+SDRAM[i-2];

	while(1)
	{
		for(int i=0; i<12; i++)
		{
			(*leds) = SDRAM[i];
			for(int n=0; n<1000000; n++);
		}
	}
}
void dualCoreTest()
{
	volatile uint32_t * id = (uint32_t *)ID_BASE;
	uint8_t * leds= (uint8_t *)LEDS_BASE;
	uint32_t * key = (uint32_t*)BUTTON_BASE;
	volatile uint8_t * sharedVar = (uint8_t *)(RAM_BASE+0xf);


	if((*id)==0x00000001)
	{
		(*sharedVar) = 0xFF;
		while(1);
	}

	if((*id)==0x00000001)
	{(*sharedVar) = 3;
		uint32_t n = 1000000;while(n--);
		while(1)
		{
			while( (*sharedVar)==1)
			{
				for(int i=0; i<8; i++)
				{
					(*leds)= 1<<i;
					uint32_t n = 1000000;while(n--);
				}
				for(int i=6; i>0; i--)
				{
					(*leds)= 1<<i;
					uint32_t n = 1000000;while(n--);
				}
			}
		}
	}

	if((*id)==0x00000000)
	{
		uint32_t status=1;
		(*sharedVar) = 3;
		while(1)
		{
			uint32_t currStatus = (*key);
			sharedVar[2]=currStatus;
			if(currStatus != status)
			{
				status = currStatus;
				if(status == 1)
				{
					(*sharedVar)^=1;
				}
			}
		}
	}
}

void interactiveMandelbrot()
{
	uint8_t * leds= (uint8_t *)LEDS_BASE;

	uint32_t moveStep = Q16_FRAC(1,4);
	int32_t x0 	   = Q16_FRAC(-2,1);
	int32_t x1 	   = Q16_FRAC(1,1);
	int32_t y0 	   = Q16_FRAC(-3,2);
	int32_t y1 	   = Q16_FRAC(3,2);

	mandelbrot(x0,x1,y0,y1);

	PS2_Device_t dev;
	int status = PS2_Init(PS21,&dev);

	int i=0;
	uint8_t zoomLevel=0;
	uint32_t refresh=0;
	while(1)
	{
		KB_CODE_TYPE decodeMode;
		uint8_t makeCode;
		char c;
		(*leds)=0;
		if(Keyboard_Decode(KB,&decodeMode, &makeCode, &c) == 0)
		{
			PS2_ClearFifo(KB);
			(*leds)=c;

			if(c=='Z') // zoom
			{
				if(zoomLevel<20)
				{
					zoomLevel++;
					x0+=2*moveStep/zoomLevel;
					x1-=2*moveStep/zoomLevel;
					y0+=2*moveStep/zoomLevel;
					y1-=2*moveStep/zoomLevel;
					refresh=1;
				}
			}
			else if(c=='X') // unzoom
			{
				if(zoomLevel>0)
				{
					zoomLevel--;
					x0-=2*moveStep/zoomLevel;
					x1+=2*moveStep/zoomLevel;
					y0-=2*moveStep/zoomLevel;
					y1+=2*moveStep/zoomLevel;
					refresh=1;
				}
			}

			else if(makeCode==0x6B) // left
			{
				if(x0>Q16_FRAC(-2,1))
				{
					x0-=2*moveStep/zoomLevel;
					x1-=2*moveStep/zoomLevel;
					refresh=1;
				}
			}
			else if(makeCode==0x75) // up
			{
				if(y1<Q16_FRAC(3,2))
				{
					y1+=2*moveStep/zoomLevel;
					y0+=2*moveStep/zoomLevel;
					refresh=1;
				}
			}
			else if(makeCode==0x72) // down
			{
				if(y0>Q16_FRAC(-3,2))
				{
					y1-=2*moveStep/zoomLevel;
					y0-=2*moveStep/zoomLevel;
					refresh=1;
				}
			}
			else if(makeCode==0x74)//right
			{
				if(x1<Q16_FRAC(1,1))
				{
					x1+=2*moveStep/zoomLevel;
					x0+=2*moveStep/zoomLevel;
					refresh=1;
				}
			}

			if(refresh==1)
			{
				mandelbrot(x0,x1,y0,y1);
				refresh=0;
				c=0;
			}

		}
		int n=100000;
		while(n--);
	}
}

void mandelbrot(int32_t x0,int32_t x1,int32_t y0,int32_t y1)
{
	PS2_Device_t dev;
	int status = PS2_Init(PS21,&dev);

	uint8_t * leds= (uint8_t *)LEDS_BASE;

	int32_t imagStep = (y1-y0)/HEIGHT;
	int32_t realStep = (x1-x0)/WIDTH;

	(*leds) = 0;
	for (int i = 0; i < HEIGHT; i++)
	{
		fix16_t imagC = y1-imagStep*i;
		for (int j = 0; j < WIDTH; j++)
		{
			(*leds) = (1<<((((i+1)*WIDTH+j+1)*8)/(HEIGHT*WIDTH)))-1;
			fix16_t realC = x0+realStep*j;
			fix16_t realZ = 0;
			fix16_t imagZ = 0;
			uint32_t nIter;
			for (nIter = 0; nIter < NITER; nIter++)
			{
				// z = z^2 + c
				realZ = Q16_MUL(realZ, realZ) - Q16_MUL(imagZ,imagZ) + realC;
				imagZ = 2*Q16_MUL(realZ,imagZ) + imagC;

				 if ((Q16_MUL(realZ, realZ)+ Q16_MUL(imagZ, imagZ)) > Q16(4))
				   break;
			}
			screen[i][j] = RGB16((nIter*32)/NITER-1,64-(nIter*64)/NITER-1,64-(nIter*64)/NITER-1);
		}
	}
}



void mandelbrot1()
{
	uint8_t * leds= (uint8_t *)LEDS_BASE;

	const int32_t x0 	   = Q16_FRAC(-2,1);
	const int32_t x1 	   = Q16_FRAC(1,1);
	const int32_t y0 	   = Q16_FRAC(-3,2);
	const int32_t y1 	   = Q16_FRAC(3,2);
	const int32_t imagStep = (y1-y0)/HEIGHT;
	const int32_t realStep = (x1-x0)/WIDTH;

	for (int i = 0; i < HEIGHT; i++)
	{
		for (int j = 0; j < WIDTH; j++)
		{
			(*leds) = (1<<((((i+1)*WIDTH+j+1)*8)/(HEIGHT*WIDTH)))-1;
			screen[i][j] = 0x00;
		}
	}

	while(1)
	{
	(*leds) = 0;
	for (int i = 0; i < HEIGHT; i++)
	{
		fix16_t imagC = y1-imagStep*i;
		for (int j = 0; j < WIDTH; j++)
		{
			(*leds) = (1<<((((i+1)*WIDTH+j+1)*8)/(HEIGHT*WIDTH)))-1;
			fix16_t realC = x0+realStep*j;
			fix16_t realZ = 0;
			fix16_t imagZ = 0;
			uint32_t nIter;
			for (nIter = 0; nIter < NITER; nIter++)
			{
				// z = z^2 + c
				realZ = Q16_MUL(realZ, realZ) - Q16_MUL(imagZ,imagZ) + realC;
				imagZ = 2*Q16_MUL(realZ,imagZ) + imagC;

				 if ((Q16_MUL(realZ, realZ)+ Q16_MUL(imagZ, imagZ)) > Q16(4))
				   break;
			}
			screen[i][j] = RGB16((nIter*32)/NITER-1,64-(nIter*64)/NITER-1,64-(nIter*64)/NITER-1);
		}
	}
	}
}
void mandelbrot2()
{
	uint8_t * leds= (uint8_t *)LEDS_BASE;

    const fix16_t x0 	   = fix16_from_int(-2);
    const fix16_t x1 	   = fix16_from_int(1);
    const fix16_t y0 	   = -1*fract32_invert(fract32_create(2,3));
    const fix16_t y1 	   = fract32_invert(fract32_create(2,3));
    const fix16_t height   = fix16_from_int(HEIGHT);
    const fix16_t width    = fix16_from_int(WIDTH);
    const fix16_t imagStep = fix16_div(fix16_sub(y1,y0),height);
    const fix16_t realStep = fix16_div(fix16_sub(x1,x0),width);

    for (int i = 0; i < HEIGHT; i++)
	{
		for (int j = 0; j < WIDTH; j++)
		{
			(*leds) = (1<<((((i+1)*WIDTH+j+1)*8)/(HEIGHT*WIDTH)))-1;
			screen[i][j] = 0x00;
		}
	}

    while(1)
    {
		for (int i = 0; i < HEIGHT; i++)
		{
			fix16_t imagC = fix16_sub(y1,fix16_mul(imagStep,i));
			for (int j = 0; j < WIDTH; j++)
			{
				(*leds) = (1<<((((i+1)*WIDTH+j+1)*8)/(HEIGHT*WIDTH)))-1;
				fix16_t realC = fix16_add(x0,fix16_mul(realStep,j));
				fix16_t realZ = 0;
				fix16_t imagZ = 0;
				uint32_t nIter;
				for (nIter = 0; nIter < NITER; nIter++)
				{
					// z = z^2 + c
					realZ = fix16_add(fix16_sub(fix16_mul(realZ, realZ), fix16_mul(imagZ,imagZ)), realC);
					imagZ = fix16_add(fix16_mul(2*fix16_one,fix16_mul(realZ,imagZ)), imagC);

					 if (fix16_add(fix16_mul(realZ, realZ), fix16_mul(imagZ, imagZ)) > fix16_from_int(4))
					   break;
				}
				screen[i][j] = RGB16((nIter*32)/NITER-1,64-(nIter*64)/NITER-1,64-(nIter*64)/NITER-1);
			}
		}
	}
}
