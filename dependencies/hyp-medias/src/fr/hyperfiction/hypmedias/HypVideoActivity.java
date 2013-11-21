package fr.hyperfiction.hypmedias;

import fr.hyperfiction.hypmedias.HypVideo;
import fr.hyperfiction.hypmedias.HypVideoView.PlayPauseListener;
import fr.hyperfiction.hypmedias.HypVideoView;
import fr.hyperfiction.hypmedias.R;

import android.app.Activity;
import android.media.MediaPlayer.OnBufferingUpdateListener;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnErrorListener;
import android.media.MediaPlayer.OnInfoListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.media.MediaPlayer.OnSeekCompleteListener;
import android.media.MediaPlayer;
import android.net.Uri;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.MediaController;
import android.widget.ProgressBar;
import android.widget.VideoView;

import java.io.IOException;
import java.lang.Runnable;

/**
 * ...
 * @author shoe[box]
 */
public class HypVideoActivity extends Activity implements OnPreparedListener , OnCompletionListener , PlayPauseListener , OnErrorListener , OnBufferingUpdateListener{

	public static final String PLAYBACK_COMPLETE = "HypVideoEvent_PLAYBACK_COMPLETE";
	public static final String PLAYBACK_ERROR 	 = "HypVideoEvent_PLAYBACK_ERROR";
	public static final String PLAYBACK_INFO 	 = "HypVideoEvent_PLAYBACK_INFO";
	public static final String PLAYBACK_PAUSE 	 = "HypVideoEvent_PLAYBACK_PAUSE";
	public static final String PLAYBACK_PLAY 	 = "HypVideoEvent_PLAYBACK_PLAY";
	public static final String PLAYBACK_SEEK 	 = "HypVideoEvent_PLAYBACK_SEEK";
	public static final String PLAYBACK_STOP 	 = "HypVideoEvent_PLAYBACK_STOP";

	HypVideoView oVideo_player;
	ProgressBar oLoader;
	String sVideo_url;

	private static String TAG = "trace"; //HypVideo

	// -------o constructor

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		@Override
		public void onPause( ){
			super.onPause( );
			trace("onPause");
			if( oVideo_player != null )
				oVideo_player.pause( );
		}

		/**
		* Called when the Activity is created
		*
		* @public
		* @return	void
		*/
		@Override
		public void onCreate( Bundle savedInstance_state ){
			trace("onCreate");

			//Callback the superclass
				super.onCreate( savedInstance_state );

			//Full screen
				/* Fullscreen option
				if( android.os.Build.VERSION.SDK_INT >= 19 ) {
	                getWindow().getDecorView().setSystemUiVisibility(
						View.SYSTEM_UI_FLAG_FULLSCREEN |
						View.SYSTEM_UI_FLAG_HIDE_NAVIGATION |
						View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY |
						View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION |
						View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN |
						View.SYSTEM_UI_FLAG_LAYOUT_STABLE
	                );
	            }else if( android.os.Build.VERSION.SDK_INT >= 16 ) {
            		getWindow().getDecorView().setSystemUiVisibility(
						View.SYSTEM_UI_FLAG_FULLSCREEN |
						View.SYSTEM_UI_FLAG_HIDE_NAVIGATION |
						View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION |
						View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN |
						View.SYSTEM_UI_FLAG_LAYOUT_STABLE
					);
	            }
	            */

			//Content of the view
				setContentView( R.layout.fr_hyperfiction_hypmedias_hypvideo );

			//The extras arguments bundle
				Bundle extras = getIntent( ).getExtras( );

			//The video URL
				sVideo_url = extras.getString("sVideo_url");
				trace("sVideo_url ::: "+sVideo_url);

			//Player initialization
				oVideo_player = (HypVideoView)findViewById(R.id.HypVideoPlayer);
				oVideo_player.setMediaController(new MediaController(this));

			//the spinning loader
				oLoader = (ProgressBar)findViewById(R.id.HypVideoProgressBar);

		    //Custom listener
		        oVideo_player.setOnPlayPauseListener( this );

		    //Completion listenezr
		        oVideo_player.setOnCompletionListener( this );

		    //Prepare listener
		        oVideo_player.setOnPreparedListener( this );

		    //Error listener
		        oVideo_player.setOnErrorListener( this );


		    //Start
		        oVideo_player.setKeepScreenOn(true);
		        oVideo_player.setVideoURI(Uri.parse( sVideo_url ));
		        oVideo_player.requestFocus();
		        oVideo_player.start();

		}

		/**
		* On prepared listener
		*
		* @public
		* @see android.media.MediaPlayer.OnPreparedListener
		* @return	void
		*/
		public void onPrepared( MediaPlayer mp ){

			//Hiding the loader
				oLoader.setVisibility( View.INVISIBLE );

			//Listening for Buffering updates
				mp.setOnBufferingUpdateListener( this );

		}

		/**
		* Show / Hide the loader if the video is buffering or not
		*
		* @public
		* @return	void
		*/
		public void onBufferingUpdate(MediaPlayer mp, int percent){
			oLoader.setVisibility( percent == 100 ? View.INVISIBLE : View.INVISIBLE );
		}

		/**
		* On video playback completion
		*
		* @public
		* @return	void
		*/
		public void onCompletion( MediaPlayer mp ){
			trace("onCompletion");

			//Send status
				_sendStatus( PLAYBACK_COMPLETE , "" );

			//Finishing activity
				finish( );
		}

		/**
		* On error listener
		*
		* @public
		* @see 		android.media.MediaPlayer.OnErrorListener
		* @return	void
		*/
		@Override
		public boolean onError (MediaPlayer mp, int what, int extra){
			trace("onError");

			//Sending back the status
				_sendStatus( PLAYBACK_ERROR , what+"|"+extra);

			//Finishing the activity
				//finish( );

			return false;
		}

		//Play / Pause listener -------------------------------------------------------------------------------

		/**
		* Sending the seek event to Haxe
		*
		* @public
		* @return	void
		*/
		public void onPlayback_seek( int msec ){
			_sendStatus( PLAYBACK_SEEK , msec+"" );
		}

		/**
		* When the video is played, sending the event to Haxe
		*
		* @public
		* @return	void
		*/
		public void onPlayback_play( ){
			_sendStatus( PLAYBACK_PLAY , "" );
		}

		/**
		* When the video is paused, sending the event to Haxe
		*
		* @public
		* @return	void
		*/
		public void onPlayback_Pause( ){
			_sendStatus( PLAYBACK_PAUSE , "" );
		}

		/**
		* Whe nthe PLayback STOP
		*
		* @public
		* @return	void
		*/
		public void onPlayback_stop( ){
			_sendStatus( PLAYBACK_STOP , "" );
		}

		/**
		* When the button BACK is press while playback
		*
		* @private
		* @return	void
		*/
		@Override
		public void onBackPressed( ){
			trace("onBackPressed");

			//Sending the playback complete event
				_sendStatus( PLAYBACK_COMPLETE , "" );

			//Calling super method
				super.onBackPressed( );
		}

	// -------o protected

		/**
		* Queue an event on the GLSurfaceView
		*
		* @private
		* @return	void
		*/
		private void _sendStatus( final String sStatus , final String sArg ){
			HypVideo.callbackHandler.post(
				new Runnable() {
					@Override
					public void run() {
						try{
							HypVideo.onVideoStatus( sStatus , sArg );
						} catch( Exception e) {
							trace("Exception while sending status");
							e.printStackTrace();
						}
					}
				}
			);
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