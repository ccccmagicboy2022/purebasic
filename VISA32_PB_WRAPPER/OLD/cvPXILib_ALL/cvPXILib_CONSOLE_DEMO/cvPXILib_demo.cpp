#include	<string>
#include	"cvPXILib.h"
#include	"cvPXILib_PB.h"

#pragma comment(lib,"cvPXILib.lib")
#pragma comment(lib,"cvPXILib_PB.lib")

int	main()
{
	unsigned	int	result;
	char	test[1024];
	
	_asm INT 3;
	
	result	=	select_card_pb();
	HelloWorldDLL();

	GetBuffer1(test);
	_asm INT 3;
	
	printf("select card is 0x%x", result);

	




	getchar();


	return 0;
}