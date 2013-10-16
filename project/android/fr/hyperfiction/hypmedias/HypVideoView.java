package fr.hyperfiction.hypmedias;

import android.content.Context;
import android.content.res.Configuration;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.VideoView;

public class HypVideoView extends VideoView {

	private static String TAG = "HypVideo";
	private PlayPauseListener mListener;

	public HypVideoView(Context context){
		super(context);
	}

	public HypVideoView(Context context, AttributeSet attrs){
		super(context,attrs);
	}

	public HypVideoView(Context context, AttributeSet attrs,int defStyle){
		super(context, attrs, defStyle);
	}

	/*
	*
	* @public
	* @return	void
	*/
	public static void trace( String s ){
		Log.i( TAG, s );
	}

	public void setOnPlayPauseListener( PlayPauseListener listener ){
		mListener = listener;
	}

	@Override
	public void seekTo(int msec){
		if (mListener != null) {
	        mListener.onPlayback_seek(msec);
	    }
	    super.seekTo(msec);
	}

	@Override
	public void pause() {
		super.pause();
		if( mListener != null ) {
			mListener.onPlayback_Pause();
		}
	}

	@Override
	public void resume() {
		super.resume();
		if( mListener != null ) {
			mListener.onPlayback_play();
		}
	}

	@Override
	public void start() {
		super.start();
		if( mListener != null ) {
			mListener.onPlayback_play();
		}
	}

	@Override
	public void stopPlayback() {
		super.stopPlayback();
		if( mListener != null ) {
			mListener.onPlayback_stop();
		}
	}

	interface PlayPauseListener {
		void onPlayback_Pause();
		void onPlayback_play();
		void onPlayback_stop();
		void onPlayback_seek(int msec);
	}

}