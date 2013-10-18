package fr.hyperfiction.hypmedias;

import nme.events.Event;
import nme.events.EventDispatcher;

/**
 * ...
 * @author shoe[box]
 */
 @:build( ShortCuts.mirrors( ) )
class HypVideo extends EventDispatcher{

	private static var _bInitialized : Bool;

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		private function new() {
			trace("constructor");
			super( );
			_initialize( );
		}

	// -------o public

		/**
		* Play a remote video
		*
		* @public
		* @param	sVideo_url : Remote video URL ( String )
		* @return	Void
		*/
		public function playRemote( sVideo_url : String ) : Void {
			_playRemote( sVideo_url );
		}

	// -------o protected

		/**
		* Initializing
		*
		* @private
		* @return	void
		*/
		private function _initialize( ) : Void{
			trace("initialize");

			//Already initialized ?
				if( _bInitialized )
					return;
				_bInitialized = true;

			//Event callback
				HypVideo_set_event_callback( _onEvent_from_java );

		}

		/**
		* Event Listener
		*
		* @private
		* @return	void
		*/
		private function _onEvent_from_java( sEvent : String , sArg : String ) : Void{
			trace("_onEvent_from_java ::: "+sEvent+" - "+sArg);
			_emit( sEvent , sArg );
		}

		/**
		* Emit function ( to be override for signals... )
		*
		* @private
		* @param	sEvent_type : Event name 		( String )
		* @param	sParam 		: Optional param 	( String )
		* @return	Void
		*/
		private function _emit( sEvent_type : String , sArg : String = null ) : Void{
			dispatchEvent( new HypVideoEvent( sEvent_type , sArg ) );
		}

	// -------o mirrors

		/**
		* Set the event listener
		*
		* @private
		* @return	void
		*/
		#if cpp
		@CPP("hypmedias")
		#end
		private function HypVideo_set_event_callback( f : String->String->Void ) : Void {

		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		#if android
		@JNI("fr.hyperfiction.hypmedias.HypVideo","playRemote")
		#end
		#if ios
		@CPP("hypmedias","HypVideo_playRemote")
		#end
		static private function _playRemote( s : String ) : Void{
		}

	// -------o misc

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function getInstance( ) : HypVideo {

			if( __instance == null )
				__instance = new HypVideo( );

			return __instance;
		}
		private static var __instance : HypVideo = null;

}

/**
 * ...
 * @author shoe[box]
 */

class HypVideoEvent extends Event{

	public var arg : String;

	public static inline var PLAYBACK_COMPLETE	= "HypVideoEvent_PLAYBACK_COMPLETE";
	public static inline var PLAYBACK_ERROR		= "HypVideoEvent_PLAYBACK_ERROR";
	public static inline var PLAYBACK_INFO		= "HypVideoEvent_PLAYBACK_INFO";
	public static inline var PLAYBACK_PAUSE		= "HypVideoEvent_PLAYBACK_PAUSE";
	public static inline var PLAYBACK_PLAY		= "HypVideoEvent_PLAYBACK_PLAY";
	public static inline var PLAYBACK_SEEK		= "HypVideoEvent_PLAYBACK_SEEK";
	public static inline var PLAYBACK_STOP		= "HypVideoEvent_PLAYBACK_STOP";

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new( sType : String , sArg : String ) {
			super( sType );
			this.arg = sArg;
		}

	// -------o public



	// -------o protected



	// -------o misc

}