package fr.hyperfiction.hypmedias;

import android.content.Intent;
import android.util.Log;

import fr.hyperfiction.hypmedias.HypVideoActivity;

import org.haxe.extension.Extension;

/**
 * ...
 * @author shoe[box]
 */

public class HypVideo extends Extension{

	static public native void onVideoStatus( String sStatus , String sArg );
	static{
		System.loadLibrary( "hypmedias" );
	}

	private static String TAG = "trace"; //HypVideo

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public void HypVideo(){

		}

	// -------o public

		/**
		* Play a remote video by it's URL
		*
		* @public
		* @return	void
		*/
		static public void playRemote( String sVideo_url ){
			_playRemote( sVideo_url , HypVideoActivity.class );
		}

	// -------o protected

		/**
		*
		*
		* @private
		* @return	void
		*/
		static private void _playRemote( String sVideo_url , Class<?> c ){
			//The arguments
				Intent 	i = new Intent( mainContext , c );
						i.putExtra("sVideo_url", sVideo_url);

			//Starting the Activity
				mainActivity.startActivity( i );
		}

	// -------o misc

		/**
		* "trace" method
		*
		* @public
		* @return	void
		*/
		public static void trace( String s ){
			Log.i( TAG, s );
		}
}