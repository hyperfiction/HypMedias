package fr.hyperfiction.hypmedias;

import fr.hyperfiction.hypmedias.HypVideoView.PlayPauseListener;

import android.util.Log;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.media.MediaPlayer.OnSeekCompleteListener;
import android.media.MediaPlayer.OnInfoListener;
import android.media.MediaPlayer.OnErrorListener;
import android.media.MediaPlayer;

import mme.mobile.tag.EAndroidTagCtrl;
import mme.mobile.tag.EStmPositionCallback;
import mme.mobile.tag.EStmTagData;
import mme.mobile.tag.EVideoState;

import fr.hyperfiction.hypmedias.HypVideoActivity;

/**
 * ...
 * @author shoe[box]
 */
public class EStatHypVideoActivity extends HypVideoActivity implements PlayPauseListener , OnErrorListener{

	private MediaPosition mediaPosition;
	private MediaPlayer _mpInstance;

	private boolean _estat_state;
	private static EStmTagData stmTagData;

	// -------o constructor


	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public void initEstat( String params , boolean bDebug ){
			trace("initEstat ::: "+params+" - "+bDebug);

			//Log Enabled ?
				EAndroidTagCtrl.setLogEnabled( bDebug);

			//Split the params
				String[] aParams = params.split("&");

			//Initializing
				stmTagData = new EStmTagData(aParams[0]);
				stmTagData.setApplicationName("::APP_PACKAGE::");
				stmTagData.setApplicationVersion("::APP_VERSION::");
				stmTagData.setUILevel1(aParams[1]);
				stmTagData.setUILevel2(aParams[2]);
				stmTagData.setUILevel3(aParams[3]);
				stmTagData.setUILevel4(aParams[4]);
				stmTagData.setUILevel5(aParams[5]);
				stmTagData.setVideoGender(aParams[6]);
				stmTagData.setVideoName(aParams[7]);
				stmTagData.setVideoProvider(aParams[8]);
		}


		/**
		* On prepared listener
		*
		* @see android.media.MediaPlayer.OnPreparedListene
		* @public
		* @return	void
		*/
		public void onPrepared( MediaPlayer mp ){
			trace("onPrepared");

			//MediaPosition
				mediaPosition = new MediaPosition( mp );

			//
				super.onPrepared( mp );
				_mpInstance = mp;
				trace("onPrepared");

			//Video duration
				stmTagData.setVideoDuration( mp.getDuration( ) / 1000 );

			//On seek complete
				mp.setOnSeekCompleteListener(new OnSeekCompleteListener(){
					@Override
					public void onSeekComplete(MediaPlayer mp){
						if( _estat_state ) {
							notifyEvent(EVideoState.PLAYING,mp);
						}else{
							notifyEvent(EVideoState.PAUSED,mp);
						}
					}
				});

		}

		//Play / Pause listener -------------------------------------------------------------------------------

		/**
		*
		*
		* @public
		* @return	void
		*/
		@Override
		public void onPlayback_seek( int msec ){
			trace("onPlayback_seek");
			super.onPlayback_seek( msec );
			notifyEvent( EVideoState.PAUSED , _mpInstance );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		@Override
		public void onPlayback_play( ){
			trace("onPlayback_play");
			super.onPlayback_play( );
			_estat_state = true;
			notifyEvent( EVideoState.PLAYING , _mpInstance );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		@Override
		public void onPlayback_Pause( ){
			super.onPlayback_Pause( );
			_estat_state = false;
			trace("onPlayback_Pause");
			notifyEvent( EVideoState.PAUSED , _mpInstance );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		@Override
		public void onPlayback_stop( ){
			super.onPlayback_stop( );
			_estat_state = false;
			trace("onPlayback_stop");
			notifyEvent( EVideoState.STOPPED , _mpInstance );
		}

		/**
		* On video playback completion
		*
		* @public
		* @return	void
		*/
		@Override
		public void onCompletion( MediaPlayer mp ){
			super.onCompletion( mp );
			trace("onCompletion");
			notifyEvent( EVideoState.STOPPED , mp );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		@Override
		public boolean onError (MediaPlayer mp, int what, int extra){
			notifyEvent( EVideoState.STOPPED , mp );
			return super.onError( mp , what , extra );
		}

	// -------o protected

		/**
		* Notify an event to eStat
		*
		* @private
		* @return	void
		*/
		private void notifyEvent( EVideoState event, MediaPlayer mp ) {
			trace("notifyEvent ::: "+event+" -" +mp);
			try{

				if( stmTagData != null ){
					stmTagData.setVideoCurrentPosition( mp.getCurrentPosition()/1000 );
					EAndroidTagCtrl.notifyEvent(stmTagData,event, mediaPosition, this );
				}

			}catch( Exception e ){
				e.printStackTrace( );
			}
		}

	// -------o misc

		private final class MediaPosition implements EStmPositionCallback {

			MediaPlayer mediaPlayer;

			public MediaPosition(MediaPlayer mediaPlayer) {
				this.mediaPlayer = mediaPlayer;
			}

			public int getPosition() {
				int res = 0;
				try{
					res = mediaPlayer.getCurrentPosition()/1000;
				} catch ( Exception e ) {
					e.printStackTrace( );
				}
				return res;
			}
		}
}