

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


 /* File created by MIDL compiler version 7.00.0500 */
/* at Mon Apr 04 18:31:03 2011
 */
/* Compiler settings for BoxedAppSDK_Interfaces.idl:
    Oicf, W1, Zp8, env=Win32 (32b run)
    protocol : dce , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
//@@MIDL_FILE_HEADING(  )

#pragma warning( disable: 4049 )  /* more than 64k source lines */


/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 475
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif // __RPCNDR_H_VERSION__


#ifndef __BoxedAppSDK_Interfaces_h__
#define __BoxedAppSDK_Interfaces_h__

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

/* Forward Declarations */ 

#ifndef __IBoxedAppVirtualFile_FWD_DEFINED__
#define __IBoxedAppVirtualFile_FWD_DEFINED__
typedef interface IBoxedAppVirtualFile IBoxedAppVirtualFile;
#endif 	/* __IBoxedAppVirtualFile_FWD_DEFINED__ */


#ifndef __IBoxedAppVirtualFileStream_FWD_DEFINED__
#define __IBoxedAppVirtualFileStream_FWD_DEFINED__
typedef interface IBoxedAppVirtualFileStream IBoxedAppVirtualFileStream;
#endif 	/* __IBoxedAppVirtualFileStream_FWD_DEFINED__ */


#ifndef __IBoxedAppEnumVirtualFile_FWD_DEFINED__
#define __IBoxedAppEnumVirtualFile_FWD_DEFINED__
typedef interface IBoxedAppEnumVirtualFile IBoxedAppEnumVirtualFile;
#endif 	/* __IBoxedAppEnumVirtualFile_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"

#ifdef __cplusplus
extern "C"{
#endif 



#ifndef __BoxedAppSDK_Interfaces_LIBRARY_DEFINED__
#define __BoxedAppSDK_Interfaces_LIBRARY_DEFINED__

/* library BoxedAppSDK_Interfaces */
/* [helpstring][version][uuid] */ 




typedef struct _SBoxedAppVirtualFileData
    {
    DWORD m_dwSizeOfStruct;
    LPOLESTR m_szName;
    LARGE_INTEGER m_nSize;
    DWORD m_dwAttributes;
    FILETIME m_CreationTime;
    FILETIME m_LastWriteTime;
    FILETIME m_LastAccessTime;
    FILETIME m_ChangeTime;
    } 	SBoxedAppVirtualFileData;


EXTERN_C const IID LIBID_BoxedAppSDK_Interfaces;

#ifndef __IBoxedAppVirtualFile_INTERFACE_DEFINED__
#define __IBoxedAppVirtualFile_INTERFACE_DEFINED__

/* interface IBoxedAppVirtualFile */
/* [object][uuid] */ 


EXTERN_C const IID IID_IBoxedAppVirtualFile;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("D6BECAD0-5D56-4b51-8278-D690474D69FF")
    IBoxedAppVirtualFile : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE get_Attributes( 
            /* [retval][out] */ DWORD *pdwAttributes) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE set_Attributes( 
            /* [in] */ DWORD dwAttributes) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE get_CreationTime( 
            /* [retval][out] */ LARGE_INTEGER *ptime) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE set_CreationTime( 
            /* [in] */ LARGE_INTEGER *ptime) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE get_LastWriteTime( 
            /* [retval][out] */ LARGE_INTEGER *ptime) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE set_LastWriteTime( 
            /* [in] */ LARGE_INTEGER *ptime) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE get_LastAccessTime( 
            /* [retval][out] */ LARGE_INTEGER *ptime) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE set_LastAccessTime( 
            /* [in] */ LARGE_INTEGER *ptime) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE get_ChangeTime( 
            /* [retval][out] */ LARGE_INTEGER *ptime) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE set_ChangeTime( 
            /* [in] */ LARGE_INTEGER *ptime) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE createFileStream( 
            /* [in] */ LPCWSTR szName,
            /* [in] */ DWORD dwDesiredAccess,
            /* [in] */ DWORD dwAttributes,
            /* [in] */ DWORD dwShareAccess,
            /* [in] */ DWORD dwCreateOptions,
            /* [retval][out] */ IBoxedAppVirtualFileStream **ppVirtualFileStream) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE openFileStream( 
            /* [in] */ LPCWSTR szName,
            /* [in] */ DWORD dwDesiredAccess,
            /* [in] */ DWORD dwShareAccess,
            /* [in] */ DWORD dwOpenOptions,
            /* [retval][out] */ IBoxedAppVirtualFileStream **ppVirtualFileStream) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE renameFileStream( 
            /* [in] */ LPCWSTR szOldName,
            /* [in] */ LPCWSTR szNewName) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE deleteFileStream( 
            /* [in] */ LPCWSTR szName) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE enumFileStreams( 
            /* [retval][out] */ IBoxedAppEnumVirtualFile **ppEnumVirtualStream) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE createFile( 
            /* [in] */ LPCWSTR szName,
            /* [in] */ DWORD dwDesiredAccess,
            /* [in] */ DWORD dwAttributes,
            /* [in] */ DWORD dwShareAccess,
            /* [in] */ DWORD dwCreateOptions,
            /* [retval][out] */ IBoxedAppVirtualFile **ppVirtualFile) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE openFile( 
            /* [in] */ LPCWSTR szName,
            /* [in] */ DWORD dwDesiredAccess,
            /* [in] */ DWORD dwShareAccess,
            /* [in] */ DWORD dwOpenOptions,
            /* [retval][out] */ IBoxedAppVirtualFile **ppVirtualFile) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE renameFile( 
            /* [in] */ LPCWSTR szOldName,
            /* [in] */ LPCWSTR szNewName) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE deleteFile( 
            /* [in] */ LPCWSTR szName) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE enumFiles( 
            /* [retval][out] */ IBoxedAppEnumVirtualFile **ppEnumVirtualStream) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IBoxedAppVirtualFileVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IBoxedAppVirtualFile * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ 
            __RPC__deref_out  void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IBoxedAppVirtualFile * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IBoxedAppVirtualFile * This);
        
        HRESULT ( STDMETHODCALLTYPE *get_Attributes )( 
            IBoxedAppVirtualFile * This,
            /* [retval][out] */ DWORD *pdwAttributes);
        
        HRESULT ( STDMETHODCALLTYPE *set_Attributes )( 
            IBoxedAppVirtualFile * This,
            /* [in] */ DWORD dwAttributes);
        
        HRESULT ( STDMETHODCALLTYPE *get_CreationTime )( 
            IBoxedAppVirtualFile * This,
            /* [retval][out] */ LARGE_INTEGER *ptime);
        
        HRESULT ( STDMETHODCALLTYPE *set_CreationTime )( 
            IBoxedAppVirtualFile * This,
            /* [in] */ LARGE_INTEGER *ptime);
        
        HRESULT ( STDMETHODCALLTYPE *get_LastWriteTime )( 
            IBoxedAppVirtualFile * This,
            /* [retval][out] */ LARGE_INTEGER *ptime);
        
        HRESULT ( STDMETHODCALLTYPE *set_LastWriteTime )( 
            IBoxedAppVirtualFile * This,
            /* [in] */ LARGE_INTEGER *ptime);
        
        HRESULT ( STDMETHODCALLTYPE *get_LastAccessTime )( 
            IBoxedAppVirtualFile * This,
            /* [retval][out] */ LARGE_INTEGER *ptime);
        
        HRESULT ( STDMETHODCALLTYPE *set_LastAccessTime )( 
            IBoxedAppVirtualFile * This,
            /* [in] */ LARGE_INTEGER *ptime);
        
        HRESULT ( STDMETHODCALLTYPE *get_ChangeTime )( 
            IBoxedAppVirtualFile * This,
            /* [retval][out] */ LARGE_INTEGER *ptime);
        
        HRESULT ( STDMETHODCALLTYPE *set_ChangeTime )( 
            IBoxedAppVirtualFile * This,
            /* [in] */ LARGE_INTEGER *ptime);
        
        HRESULT ( STDMETHODCALLTYPE *createFileStream )( 
            IBoxedAppVirtualFile * This,
            /* [in] */ LPCWSTR szName,
            /* [in] */ DWORD dwDesiredAccess,
            /* [in] */ DWORD dwAttributes,
            /* [in] */ DWORD dwShareAccess,
            /* [in] */ DWORD dwCreateOptions,
            /* [retval][out] */ IBoxedAppVirtualFileStream **ppVirtualFileStream);
        
        HRESULT ( STDMETHODCALLTYPE *openFileStream )( 
            IBoxedAppVirtualFile * This,
            /* [in] */ LPCWSTR szName,
            /* [in] */ DWORD dwDesiredAccess,
            /* [in] */ DWORD dwShareAccess,
            /* [in] */ DWORD dwOpenOptions,
            /* [retval][out] */ IBoxedAppVirtualFileStream **ppVirtualFileStream);
        
        HRESULT ( STDMETHODCALLTYPE *renameFileStream )( 
            IBoxedAppVirtualFile * This,
            /* [in] */ LPCWSTR szOldName,
            /* [in] */ LPCWSTR szNewName);
        
        HRESULT ( STDMETHODCALLTYPE *deleteFileStream )( 
            IBoxedAppVirtualFile * This,
            /* [in] */ LPCWSTR szName);
        
        HRESULT ( STDMETHODCALLTYPE *enumFileStreams )( 
            IBoxedAppVirtualFile * This,
            /* [retval][out] */ IBoxedAppEnumVirtualFile **ppEnumVirtualStream);
        
        HRESULT ( STDMETHODCALLTYPE *createFile )( 
            IBoxedAppVirtualFile * This,
            /* [in] */ LPCWSTR szName,
            /* [in] */ DWORD dwDesiredAccess,
            /* [in] */ DWORD dwAttributes,
            /* [in] */ DWORD dwShareAccess,
            /* [in] */ DWORD dwCreateOptions,
            /* [retval][out] */ IBoxedAppVirtualFile **ppVirtualFile);
        
        HRESULT ( STDMETHODCALLTYPE *openFile )( 
            IBoxedAppVirtualFile * This,
            /* [in] */ LPCWSTR szName,
            /* [in] */ DWORD dwDesiredAccess,
            /* [in] */ DWORD dwShareAccess,
            /* [in] */ DWORD dwOpenOptions,
            /* [retval][out] */ IBoxedAppVirtualFile **ppVirtualFile);
        
        HRESULT ( STDMETHODCALLTYPE *renameFile )( 
            IBoxedAppVirtualFile * This,
            /* [in] */ LPCWSTR szOldName,
            /* [in] */ LPCWSTR szNewName);
        
        HRESULT ( STDMETHODCALLTYPE *deleteFile )( 
            IBoxedAppVirtualFile * This,
            /* [in] */ LPCWSTR szName);
        
        HRESULT ( STDMETHODCALLTYPE *enumFiles )( 
            IBoxedAppVirtualFile * This,
            /* [retval][out] */ IBoxedAppEnumVirtualFile **ppEnumVirtualStream);
        
        END_INTERFACE
    } IBoxedAppVirtualFileVtbl;

    interface IBoxedAppVirtualFile
    {
        CONST_VTBL struct IBoxedAppVirtualFileVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IBoxedAppVirtualFile_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IBoxedAppVirtualFile_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define IBoxedAppVirtualFile_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define IBoxedAppVirtualFile_get_Attributes(This,pdwAttributes)	\
    ( (This)->lpVtbl -> get_Attributes(This,pdwAttributes) ) 

#define IBoxedAppVirtualFile_set_Attributes(This,dwAttributes)	\
    ( (This)->lpVtbl -> set_Attributes(This,dwAttributes) ) 

#define IBoxedAppVirtualFile_get_CreationTime(This,ptime)	\
    ( (This)->lpVtbl -> get_CreationTime(This,ptime) ) 

#define IBoxedAppVirtualFile_set_CreationTime(This,ptime)	\
    ( (This)->lpVtbl -> set_CreationTime(This,ptime) ) 

#define IBoxedAppVirtualFile_get_LastWriteTime(This,ptime)	\
    ( (This)->lpVtbl -> get_LastWriteTime(This,ptime) ) 

#define IBoxedAppVirtualFile_set_LastWriteTime(This,ptime)	\
    ( (This)->lpVtbl -> set_LastWriteTime(This,ptime) ) 

#define IBoxedAppVirtualFile_get_LastAccessTime(This,ptime)	\
    ( (This)->lpVtbl -> get_LastAccessTime(This,ptime) ) 

#define IBoxedAppVirtualFile_set_LastAccessTime(This,ptime)	\
    ( (This)->lpVtbl -> set_LastAccessTime(This,ptime) ) 

#define IBoxedAppVirtualFile_get_ChangeTime(This,ptime)	\
    ( (This)->lpVtbl -> get_ChangeTime(This,ptime) ) 

#define IBoxedAppVirtualFile_set_ChangeTime(This,ptime)	\
    ( (This)->lpVtbl -> set_ChangeTime(This,ptime) ) 

#define IBoxedAppVirtualFile_createFileStream(This,szName,dwDesiredAccess,dwAttributes,dwShareAccess,dwCreateOptions,ppVirtualFileStream)	\
    ( (This)->lpVtbl -> createFileStream(This,szName,dwDesiredAccess,dwAttributes,dwShareAccess,dwCreateOptions,ppVirtualFileStream) ) 

#define IBoxedAppVirtualFile_openFileStream(This,szName,dwDesiredAccess,dwShareAccess,dwOpenOptions,ppVirtualFileStream)	\
    ( (This)->lpVtbl -> openFileStream(This,szName,dwDesiredAccess,dwShareAccess,dwOpenOptions,ppVirtualFileStream) ) 

#define IBoxedAppVirtualFile_renameFileStream(This,szOldName,szNewName)	\
    ( (This)->lpVtbl -> renameFileStream(This,szOldName,szNewName) ) 

#define IBoxedAppVirtualFile_deleteFileStream(This,szName)	\
    ( (This)->lpVtbl -> deleteFileStream(This,szName) ) 

#define IBoxedAppVirtualFile_enumFileStreams(This,ppEnumVirtualStream)	\
    ( (This)->lpVtbl -> enumFileStreams(This,ppEnumVirtualStream) ) 

#define IBoxedAppVirtualFile_createFile(This,szName,dwDesiredAccess,dwAttributes,dwShareAccess,dwCreateOptions,ppVirtualFile)	\
    ( (This)->lpVtbl -> createFile(This,szName,dwDesiredAccess,dwAttributes,dwShareAccess,dwCreateOptions,ppVirtualFile) ) 

#define IBoxedAppVirtualFile_openFile(This,szName,dwDesiredAccess,dwShareAccess,dwOpenOptions,ppVirtualFile)	\
    ( (This)->lpVtbl -> openFile(This,szName,dwDesiredAccess,dwShareAccess,dwOpenOptions,ppVirtualFile) ) 

#define IBoxedAppVirtualFile_renameFile(This,szOldName,szNewName)	\
    ( (This)->lpVtbl -> renameFile(This,szOldName,szNewName) ) 

#define IBoxedAppVirtualFile_deleteFile(This,szName)	\
    ( (This)->lpVtbl -> deleteFile(This,szName) ) 

#define IBoxedAppVirtualFile_enumFiles(This,ppEnumVirtualStream)	\
    ( (This)->lpVtbl -> enumFiles(This,ppEnumVirtualStream) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __IBoxedAppVirtualFile_INTERFACE_DEFINED__ */


#ifndef __IBoxedAppVirtualFileStream_INTERFACE_DEFINED__
#define __IBoxedAppVirtualFileStream_INTERFACE_DEFINED__

/* interface IBoxedAppVirtualFileStream */
/* [object][uuid] */ 


EXTERN_C const IID IID_IBoxedAppVirtualFileStream;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("120536BB-23D3-4eb4-B070-B6844B1B6DD1")
    IBoxedAppVirtualFileStream : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE get_Attributes( 
            /* [retval][out] */ DWORD *pdwAttributes) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE set_Attributes( 
            /* [in] */ DWORD dwAttributes) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE get_CreationTime( 
            /* [retval][out] */ LARGE_INTEGER *ptime) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE set_CreationTime( 
            /* [in] */ LARGE_INTEGER *ptime) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE get_LastWriteTime( 
            /* [retval][out] */ LARGE_INTEGER *ptime) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE set_LastWriteTime( 
            /* [in] */ LARGE_INTEGER *ptime) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE get_LastAccessTime( 
            /* [retval][out] */ LARGE_INTEGER *ptime) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE set_LastAccessTime( 
            /* [in] */ LARGE_INTEGER *ptime) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE get_ChangeTime( 
            /* [retval][out] */ LARGE_INTEGER *ptime) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE set_ChangeTime( 
            /* [in] */ LARGE_INTEGER *ptime) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE get_NewStream( 
            /* [retval][out] */ LPSTREAM *ppStream) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IBoxedAppVirtualFileStreamVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IBoxedAppVirtualFileStream * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ 
            __RPC__deref_out  void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IBoxedAppVirtualFileStream * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IBoxedAppVirtualFileStream * This);
        
        HRESULT ( STDMETHODCALLTYPE *get_Attributes )( 
            IBoxedAppVirtualFileStream * This,
            /* [retval][out] */ DWORD *pdwAttributes);
        
        HRESULT ( STDMETHODCALLTYPE *set_Attributes )( 
            IBoxedAppVirtualFileStream * This,
            /* [in] */ DWORD dwAttributes);
        
        HRESULT ( STDMETHODCALLTYPE *get_CreationTime )( 
            IBoxedAppVirtualFileStream * This,
            /* [retval][out] */ LARGE_INTEGER *ptime);
        
        HRESULT ( STDMETHODCALLTYPE *set_CreationTime )( 
            IBoxedAppVirtualFileStream * This,
            /* [in] */ LARGE_INTEGER *ptime);
        
        HRESULT ( STDMETHODCALLTYPE *get_LastWriteTime )( 
            IBoxedAppVirtualFileStream * This,
            /* [retval][out] */ LARGE_INTEGER *ptime);
        
        HRESULT ( STDMETHODCALLTYPE *set_LastWriteTime )( 
            IBoxedAppVirtualFileStream * This,
            /* [in] */ LARGE_INTEGER *ptime);
        
        HRESULT ( STDMETHODCALLTYPE *get_LastAccessTime )( 
            IBoxedAppVirtualFileStream * This,
            /* [retval][out] */ LARGE_INTEGER *ptime);
        
        HRESULT ( STDMETHODCALLTYPE *set_LastAccessTime )( 
            IBoxedAppVirtualFileStream * This,
            /* [in] */ LARGE_INTEGER *ptime);
        
        HRESULT ( STDMETHODCALLTYPE *get_ChangeTime )( 
            IBoxedAppVirtualFileStream * This,
            /* [retval][out] */ LARGE_INTEGER *ptime);
        
        HRESULT ( STDMETHODCALLTYPE *set_ChangeTime )( 
            IBoxedAppVirtualFileStream * This,
            /* [in] */ LARGE_INTEGER *ptime);
        
        HRESULT ( STDMETHODCALLTYPE *get_NewStream )( 
            IBoxedAppVirtualFileStream * This,
            /* [retval][out] */ LPSTREAM *ppStream);
        
        END_INTERFACE
    } IBoxedAppVirtualFileStreamVtbl;

    interface IBoxedAppVirtualFileStream
    {
        CONST_VTBL struct IBoxedAppVirtualFileStreamVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IBoxedAppVirtualFileStream_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IBoxedAppVirtualFileStream_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define IBoxedAppVirtualFileStream_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define IBoxedAppVirtualFileStream_get_Attributes(This,pdwAttributes)	\
    ( (This)->lpVtbl -> get_Attributes(This,pdwAttributes) ) 

#define IBoxedAppVirtualFileStream_set_Attributes(This,dwAttributes)	\
    ( (This)->lpVtbl -> set_Attributes(This,dwAttributes) ) 

#define IBoxedAppVirtualFileStream_get_CreationTime(This,ptime)	\
    ( (This)->lpVtbl -> get_CreationTime(This,ptime) ) 

#define IBoxedAppVirtualFileStream_set_CreationTime(This,ptime)	\
    ( (This)->lpVtbl -> set_CreationTime(This,ptime) ) 

#define IBoxedAppVirtualFileStream_get_LastWriteTime(This,ptime)	\
    ( (This)->lpVtbl -> get_LastWriteTime(This,ptime) ) 

#define IBoxedAppVirtualFileStream_set_LastWriteTime(This,ptime)	\
    ( (This)->lpVtbl -> set_LastWriteTime(This,ptime) ) 

#define IBoxedAppVirtualFileStream_get_LastAccessTime(This,ptime)	\
    ( (This)->lpVtbl -> get_LastAccessTime(This,ptime) ) 

#define IBoxedAppVirtualFileStream_set_LastAccessTime(This,ptime)	\
    ( (This)->lpVtbl -> set_LastAccessTime(This,ptime) ) 

#define IBoxedAppVirtualFileStream_get_ChangeTime(This,ptime)	\
    ( (This)->lpVtbl -> get_ChangeTime(This,ptime) ) 

#define IBoxedAppVirtualFileStream_set_ChangeTime(This,ptime)	\
    ( (This)->lpVtbl -> set_ChangeTime(This,ptime) ) 

#define IBoxedAppVirtualFileStream_get_NewStream(This,ppStream)	\
    ( (This)->lpVtbl -> get_NewStream(This,ppStream) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __IBoxedAppVirtualFileStream_INTERFACE_DEFINED__ */


#ifndef __IBoxedAppEnumVirtualFile_INTERFACE_DEFINED__
#define __IBoxedAppEnumVirtualFile_INTERFACE_DEFINED__

/* interface IBoxedAppEnumVirtualFile */
/* [object][uuid] */ 


EXTERN_C const IID IID_IBoxedAppEnumVirtualFile;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("DA17DB74-3406-44bb-B760-2EECF9711E9C")
    IBoxedAppEnumVirtualFile : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE Next( 
            /* [in] */ ULONG celt,
            /* [out][in] */ SBoxedAppVirtualFileData *pData,
            /* [out] */ ULONG *pceltFetched) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE Skip( 
            /* [in] */ ULONG celt) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE Reset( void) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE Clone( 
            /* [retval][out] */ IBoxedAppEnumVirtualFile **ppEnum) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IBoxedAppEnumVirtualFileVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IBoxedAppEnumVirtualFile * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ 
            __RPC__deref_out  void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IBoxedAppEnumVirtualFile * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IBoxedAppEnumVirtualFile * This);
        
        HRESULT ( STDMETHODCALLTYPE *Next )( 
            IBoxedAppEnumVirtualFile * This,
            /* [in] */ ULONG celt,
            /* [out][in] */ SBoxedAppVirtualFileData *pData,
            /* [out] */ ULONG *pceltFetched);
        
        HRESULT ( STDMETHODCALLTYPE *Skip )( 
            IBoxedAppEnumVirtualFile * This,
            /* [in] */ ULONG celt);
        
        HRESULT ( STDMETHODCALLTYPE *Reset )( 
            IBoxedAppEnumVirtualFile * This);
        
        HRESULT ( STDMETHODCALLTYPE *Clone )( 
            IBoxedAppEnumVirtualFile * This,
            /* [retval][out] */ IBoxedAppEnumVirtualFile **ppEnum);
        
        END_INTERFACE
    } IBoxedAppEnumVirtualFileVtbl;

    interface IBoxedAppEnumVirtualFile
    {
        CONST_VTBL struct IBoxedAppEnumVirtualFileVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IBoxedAppEnumVirtualFile_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IBoxedAppEnumVirtualFile_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define IBoxedAppEnumVirtualFile_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define IBoxedAppEnumVirtualFile_Next(This,celt,pData,pceltFetched)	\
    ( (This)->lpVtbl -> Next(This,celt,pData,pceltFetched) ) 

#define IBoxedAppEnumVirtualFile_Skip(This,celt)	\
    ( (This)->lpVtbl -> Skip(This,celt) ) 

#define IBoxedAppEnumVirtualFile_Reset(This)	\
    ( (This)->lpVtbl -> Reset(This) ) 

#define IBoxedAppEnumVirtualFile_Clone(This,ppEnum)	\
    ( (This)->lpVtbl -> Clone(This,ppEnum) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __IBoxedAppEnumVirtualFile_INTERFACE_DEFINED__ */

#endif /* __BoxedAppSDK_Interfaces_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif


