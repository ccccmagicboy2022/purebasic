//以下来自cvirte
/**	Code 	Description
*	1	 	Low-level support driver was loaded at startup.
*	0 		Low-level support driver was not loaded at startup.
*/
extern	"C"	__declspec(dllimport)	int	__stdcall	CVILowLevelSupportDriverLoaded(void);
/**
*	Parameters
	Input
	Name 		Type	 	Description
	portNumber 	integer 	Port from which to read the byte.
	
	Return Value
	Name 		Type 	Description
	byteRead 	char 	Byte read from the port.
*
*/
extern	"C"	__declspec(dllimport)	char	__stdcall	CVI_inp(int	address);
/* 	Parameters
	Input
	Name	 	Type 		Description
	portNumber 	integer 	Port from which to read the word.
	Return Value
	Name 		Type 	Description
	wordRead 	short 	Word read from the port. 
*/
extern	"C"	__declspec(dllimport)	short	__stdcall	CVI_inpw(int	address);
/* 	Parameters
	Input
	Name 		Type 	Description
	portNumber 	short 	The port from which to read the double word.
	Return Value
	Name 			Type 	Description
	wordReceived 	long 	The double word (long int) read from the port. 
*/
extern	"C"	__declspec(dllimport)	long	__stdcall	CVI_inpd(short	address);
/* 	Parameters
	Input
	Name 			Type 		Description
	portNumber 		integer 	Port to which the byte is written.
	byteToWrite 	char 		Byte to write.
	Return Value
	Name 			Type 	Description
	byteWritten 	char 	Byte written to the port. */
extern	"C"	__declspec(dllimport)	char	__stdcall	CVI_outp(int	address, char	data);
/* 	Parameters
	Input
	Name 			Type 	Description
	portNumber 		short 	Port to which the word is written.
	wordToWrite 	short 	Word to write.
	Return Value
	Name 			Type 	Description
	wordWritten 	short 	Word written to the port. */
extern	"C"	__declspec(dllimport)	short	__stdcall	CVI_outpw(short	address, short	data);
/* 	Parameters
	Input
	Name 		Type 	Description
	portNumber 	short 	The port to which the double word is written.
	doubleWord 	long 	The double word (long int) written to the port.
	Return Value
	Name 			Type 	Description
	wordWritten 	long 	The double word written to the port. */
extern	"C"	__declspec(dllimport)	long	__stdcall	CVI_outpd(short	address, long	data);
/* 	Parameters
	Input
	Name 				Type			 	Description
	physicalAddress 	unsigned integer 	Physical address to read from.
	destinationBuffer 	void pointer 		Buffer into which to copy the physical memory.
	numberOfBytes 		unsigned integer 	Number of bytes to copy from physical memory.
	Return Value
	Name 	Type 		Description
	status 	integer 	Indicates whether the function succeeded.

	Code 	Description
	1 	Success.
	0 	Operating system reported failure, or low-level support driver not loaded. */
extern	"C"	__declspec(dllimport)	int	__stdcall	ReadFromPhysicalMemory (unsigned int physicalAddress, void *destinationBuffer, unsigned int numberOfBytes);
/*	Parameters
	Input
	Name 				Type 				Description
	physicalAddress 	unsigned integer 	Physical address to read from.
	destinationBuffer 	void pointer 		Buffer into which to copy the physical memory.
	numberOfBytes 		unsigned integer 	Number of bytes to copy from physical memory.
		!numberOfBytes must be a multiple of bytesAtATime.
	bytesAtATime 		integer			 	Unit size in which to copy the data.
		!bytesAtATime can be 1, 2, or 4 bytes.
	Return Value
	Name 	Type 		Description
	status 	integer 	Indicates whether the function succeeded.
		Code 	Description
		1 	Success.
		0 	Operating system reported failure, low-level support driver not loaded, numberOfBytes is not a multiple of bytesAtATime, or invalid value for bytesAtATime. */
extern	"C"	__declspec(dllimport)	int __stdcall	ReadFromPhysicalMemoryEx (unsigned int physicalAddress, void *destinationBuffer, unsigned int numberOfBytes, int bytesAtATime);
/* 	Parameters
	Input
	Name 				Type 				Description
	physicalAddress 	unsigned integer 	Physical address to write to.
	sourceBuffer 		const void * 		Buffer from which to copy the physical memory.
	numberOfBytes 		unsigned integer 	Number of bytes to copy to physical memory.
	Return Value
	Name 	Type 		Description
	status 	integer 	Indicates whether the function succeeded.

	Code 	Description
	1 	Success.
	0 	Operating system reported failure, or low-level support driver not loaded. */
extern	"C"	__declspec(dllimport)	int __stdcall	WriteToPhysicalMemory (unsigned int physicalAddress, const void *sourceBuffer, unsigned int numberOfBytes);
/* 	Parameters
	Input
	Name 				Type 				Description
	physicalAddress 	unsigned integer 	Physical address to write to.
	sourceBuffer 		const void * 		Buffer from which to copy the physical memory.
	numberOfBytes 		unsigned integer 	Number of bytes to copy to physical memory.
		!numberOfBytes must be a multiple of bytesAtATime.
	bytesAtATime 		integer 			Unit size in which to copy the data.
		!bytesAtATime can be 1, 2, or 4 bytes.
	Return Value
	Name 	Type 		Description
	status 	integer 	Indicates whether the function succeeded.

	Code 	Description
	1 	Success.
	0 	Operating system reported failure, low-level support driver not loaded, numberOfBytes is not a multiple of bytesAtATime, or invalid value for bytesAtATime. */
extern	"C"	__declspec(dllimport)	int __stdcall	WriteToPhysicalMemoryEx (unsigned int physicalAddress, const void *sourceBuffer, unsigned int numberOfBytes, int bytesAtATime);
/* 	Parameters
	Input
	Name 			Type			 	Description
	physAddress 	unsigned integer 	Physical address to map into user memory.
	numBytes 		unsigned integer 	Number of bytes of physical memory to map.
	Output
	Name 				Type 					Description
	ptrToMappedAddr 	any type of pointer 	The mapped physical address.
		!Pass a pointer by reference as this parameter.
	mapHandle 			integer 				The handle that you pass to the UnMapPhysicalMemory function to unmap the physical memory.
	Return Value
	Name 	Type 		Description
	status 	integer 	Indicates whether the function succeeded.

	Code 	Description
	1 	Success.
	0 	numBytes is 0, memory allocation failed, the operating system reported an error, or the low-level support driver is not loaded. */
extern	"C"	__declspec(dllimport)	int	__stdcall	MapPhysicalMemory(unsigned int	p_address, unsigned int	size, void*	v_address, int*	map_handle);
/* 	Parameters
	Input
	Name 		Type 		Description
	mapHandle 	integer 	Handle that MapPhysicalMemory returns.
	Return Value
	Name 	Type 		Description
	status 	integer 	Indicates whether the function succeeded.

	Code 	Description
	1 	Success.
	0 	mapHandle is not valid, the operating system reported an error, or the low-level support driver is not loaded.
 */
extern	"C"	__declspec(dllimport)	int	__stdcall	UnMapPhysicalMemory(int	map_handle);
//以下来自plxapi，已包含在其它h文件里

// PlxPci_DeviceOpen;
// PlxPci_CommonBufferProperties;
// PlxPci_DeviceClose;	

//以下来自windriver

//
//
//
extern	"C"	__declspec(dllimport)	void	__stdcall	SkinH_Attach(void);
extern	"C"	__declspec(dllimport)	void	__stdcall	SkinH_Detach(void);




