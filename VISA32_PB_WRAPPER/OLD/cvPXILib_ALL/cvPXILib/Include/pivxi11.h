/*******************************************************************************
 *  Dll for VXI-11 discovery 
 *
 *  Copyright (C) 1988 - 2008, Pickering Interfaces ltd.
 *   
 *  Support: support@pickeringtest.com
 *  Version: 1.0.0
 *
 *  Notes  
 *      this library is based upon ONC RPC for windows
 *
 *******************************************************************************/

#include <windows.h>
#include <windef.h>

/// \cond

#ifdef __cplusplus
extern "C" {
#endif

#ifdef PIVXI11_EXPORTS
#define PIVXI11_W32_API __declspec(dllexport) __cdecl
#else
#define PIVXI11_W32_API __declspec(dllimport) __cdecl
#endif

/// \endcond

///VXI-11 error codes.
enum VxiErrorCodes {
	VXI_OK           = 0,   ///< No error.
	VXI_SYNERR       = 1,   ///< Syntax error.
	VXI_NOACCESS     = 3,   ///< Device not accessible.
	VXI_INVLINK      = 4,   ///< Invalid link identifier.
	VXI_PARAMERR     = 5,   ///< Parameter error.
	VXI_NOCHAN       = 6,   ///< Channel not established.
	VXI_NOTSUPP      = 8,   ///< Operation not supported.
	VXI_NORES        = 9,   ///< Out of resources.
	VXI_DEVLOCK      = 11,  ///< Device locked by another link.
	VXI_NOLOCK       = 12,  ///< No lock held by this link.
	VXI_IOTIMEOUT    = 15,  ///< I/O timeout.
	VXI_IOERR        = 17,  ///< I/O error.
	VXI_INVADDR      = 21,  ///< Invalid address.
	VXI_ABORT        = 23,  ///< Abort.
	VXI_CHANEXIST    = 29,  ///< Channel already established.
	PIVXI_RPC_ERROR	 = 100  ///< RPC command failed, see details in message.
};

///Input parameters for VXI-11 operations.
struct DiscoveryParams {
	BOOL LockDevice;			///<Signal whether to lock device or not when operating it.
	long LockTimeout;			///<Interval that RPC commands will wait for lock to be released.
	long RetryTimeout;			///<Interval after that the network instrument command will be repeated.
	long CommunicationTimeout;	///<Interval that netowrk discovery command will take. Any device that doesn't respond in this interval won't be found.
};

///Structure describing response from device(s).
struct DiscoveryResponse {
	char Hostname[255];		///<Hostname (IP address) of device on network.
	char InstrumentId[10];		///<Instrument id of device within instrument (e.g. inst0, inst1, etc.).
	char Description[1024];		///<Description returned by querying IDN command on hotsname/instrument.
};

/**
 * <summary>
 *   Send a direct inquiry to a device for getting information. If device is available, there will be vxi11 response
 *   from it in "response" parameter. RetryTimeout and CommunicationTimeout fields of params parameter are ignored
 *   in this function. Note: "response" parameter is allocated by user of this function and has to be freed by user as well.
 * </summary>
 * <param name="hostname">IP address or name of remote LXI.</param>
 * <param name="params">Input parameters for discovery command including timeouts etc.</param>
 * <param name="response">User allocated array of responses to fill in.</param>
 * <param name="responseArrayLength">Size of "response" array. E.g. maximum of possible responses.</param>
 * <param name="responseArrayFilled">Pointer to a variable to receive number of devices written to response array.</param>
 * <returns>Zero for success, or non-zero error code.</returns>
 */
long PIVXI11_W32_API pivxi11_DiscoveryInstrument(char* hostname, struct DiscoveryParams params, struct DiscoveryResponse *response, long responseArrayLength, long *responseArrayFilled);

/**
 * <summary>
 *   Send a broadcast message to all LXI in current subnet. For getting information about available LXIs you must
 *   use functions pivxi11_DiscoveryGetCount and pivxi11_DiscoveryGetData. Whole discovery process will take
 *   CommunicationTimeout miliseconds. If RetryTimeout is set lower than CommunicationTimeout, request to devices
 *   on local network will be sent multiple times. CommunicationTimeout and RetryTimeout are fields of params parameter.
 * </summary>
 * <param name="broadcastAddr">Explicit broadcast address. For NULL is used implicit 255.255.255.255 broadcast address.</param>
 * <param name="params">Input parameters for discovery command including timeouts etc.</param>
 * <param name="foundInstruments">Pointer to a variable to receive a count of found instruments.</param>
 * <returns>Zero for success, or non-zero error code.</returns>
 */
long PIVXI11_W32_API pivxi11_DiscoveryNetwork(char* broadcastAddr, struct DiscoveryParams params, long *foundInstruments);

/**
 * <summary>
 *   Receive information about device by index. Before using this function pivxi11_DiscoveryNetwork must be called.
 *   Note: "response" parameter is allocated by user of this function and has to be freed by user as well.
 * </summary>
 * <param name="index">Index of LXI info.</param> 
 * <param name="response">User allocated array of responses to fill in.</param>
 * <param name="responseArrayLength">Size of "response" array. E.g. maximum of possible responses.</param>
 * <param name="responseArrayFilled">Pointer to a variable to receive number of instruments written to response array.</param>
 * <returns>Zero for success, or non-zero error code.</returns>
 */
long PIVXI11_W32_API pivxi11_DiscoveryGetData(long index, struct DiscoveryResponse *response, long responseArrayLength, long *responseArrayFilled);

/**
 * <summary>
 *   Receive last error code and message.
 * </summary>
 * <param name="code">Pointer to variable to receive an error code.</param>
 * <param name="message">String buffer allocated by user to receive error message.</param>
 * <param name="messageBufLength">Length of "message" buffer.</param>
 */
void PIVXI11_W32_API pivxi11_GetLastError(long *code, char* message, long messageBufLength);

#ifdef __cplusplus
}
#endif
