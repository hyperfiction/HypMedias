#ifndef IPHONE
#define IMPLEMENT_API
#endif

#include <hx/CFFI.h>
#include <stdio.h>
#include "HypVideo.h"

#ifdef ANDROID
	#include <hx/CFFI.h>
	#include <jni.h>
	#define LOG_TAG "HypMedia"
	#define ALOG(...) __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#endif


using namespace hypvideo;

AutoGCRoot *eval_HypVideo_onEvent = 0;

extern "C"{

	int HypVideo_register_prims(){
		printf("HypVideo: register_prims()\n");
		return 0;
	}

	void HypVideo_dispatch_event( const char *sEvent , const char *sArg ){
		val_call2(
					eval_HypVideo_onEvent->get( ) ,
					alloc_string( sEvent ) ,
					alloc_string( sArg )
				);

	}
}

#ifdef IPHONE

	static value HypVideo_play_remote( value sUrl, value orientation ){
		printf("HypVideo_play_remote");
		play_remote( val_string( sUrl ), val_int( orientation ) );
		return alloc_null( );
	}
	DEFINE_PRIM( HypVideo_play_remote , 2 );

	static value HypVideo_dispose( ){
		printf("HypVideo_dispose");
		dispose( );
		return alloc_null( );
	}
	DEFINE_PRIM( HypVideo_dispose , 0 );

#endif

// Callbacks ------------------------------------------------------------------------------------------------------

	static value HypVideo_set_event_callback( value onCall ){
		printf("HypVideo_set_event_callback");
		eval_HypVideo_onEvent = new AutoGCRoot( onCall );
		return alloc_bool( true );
	}
	DEFINE_PRIM( HypVideo_set_event_callback , 1 );

// Android ------------------------------------------------------------------------------------------------------
	#ifdef ANDROID
		extern "C"{
			JNIEXPORT void JNICALL Java_fr_hyperfiction_hypmedias_HypVideo_onVideoStatus(
				                   													JNIEnv * env ,
				                   													jobject obj ,
				                   													jstring jsStatus,
				                   													jstring jsArg
				                   													){
				ALOG("onVideoStatus");

				if( eval_HypVideo_onEvent->get( ) != NULL ){
					const char *sStatus	= env->GetStringUTFChars( jsStatus , 0 );
					const char *sArg   	= env->GetStringUTFChars( jsArg , 0 );
					val_call2( eval_HypVideo_onEvent->get( ), alloc_string( sStatus ) , alloc_string( sArg ) );
					env->ReleaseStringUTFChars( jsStatus , sStatus );
					env->ReleaseStringUTFChars( jsArg , sArg );
				}
			}
		}
	#endif
