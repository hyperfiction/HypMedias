package fr.hyperfiction.hypmedias;

import fr.hyperfiction.hypmedias.HypVideo;

/**
 * ...
 * @author shoe[box]
 */
@:build( ShortCuts.mirrors( ) )
class HypVideoEstat extends HypVideo{

	#if estat

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new() {
			super( );
		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function init( aParams : Array<String> , bDebug : Bool = false ) : Void {
			trace("init ::: "+aParams+" - "+bDebug );
			_initEstat( aParams.join( "&" ) , bDebug );
		}

		/**
		* Play a remote video
		*
		* @public
		* @param	sVideo_url : Remote video URL ( String )
		* @return	Void
		*/
		override public function playRemote( sVideo_url : String ) : Void {
			trace("playRemote ::: "+sVideo_url);
			playRemote_estat( sVideo_url );
		}

	// -------o protected

	// -------o mirrors

		/**
		* Initializing estat
		*
		* @private
		* @return	void
		*/
		#if android
		@JNI("fr.hyperfiction.hypmedias.EStatHypVideoActivity","initEstat")
		#end
		private static function _initEstat( sParams : String , bDebug : Bool ) : Void{
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		#if android
		@JNI("fr.hyperfiction.hypmedias.HypVideo","playRemoteEstat")
		#end
		static private function playRemote_estat( s : String ) : Void{
		}

	// -------o misc

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function getEstatInstance( ) : HypVideoEstat {

			if( __instanceEstat == null )
				__instanceEstat = new HypVideoEstat( );

			return __instanceEstat;
		}
		private static var __instanceEstat : HypVideoEstat = null;

	#end
}