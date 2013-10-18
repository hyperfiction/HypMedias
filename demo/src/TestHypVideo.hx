package;

import nme.events.Event;
import fr.hyperfiction.hypmedias.HypVideo;
import fr.hyperfiction.hypmedias.HypVideoEstat;
import fr.hyperfiction.hypmedias.HypVideo.HypVideoEvent;

import nme.display.Sprite;

/**
 * ...
 * @author shoe[box]
 */
class TestHypVideo extends Sprite{

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new() {
			super( );
			trace("constructor");

			var btn = new Sprite( );
				btn.graphics.beginFill( 0xFF6600 );
				btn.graphics.drawRect( 0 , 0 , 200 , 200 );
				btn.graphics.endFill( );
				btn.addEventListener( nme.events.MouseEvent.MOUSE_UP , function( _ ){
					_run( );
					});
			addChild( btn );

		}

	// -------o public



	// -------o protected

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _run( ) : Void{
			trace("run");
			var v = HypVideo.getInstance( );
				v.addEventListener( HypVideoEvent.PLAYBACK_COMPLETE , _onHypVideo_event );
				v.addEventListener( HypVideoEvent.PLAYBACK_ERROR , _onHypVideo_event );
				v.addEventListener( HypVideoEvent.PLAYBACK_INFO , _onHypVideo_event );
				v.addEventListener( HypVideoEvent.PLAYBACK_PAUSE , _onHypVideo_event );
				v.addEventListener( HypVideoEvent.PLAYBACK_PLAY , _onHypVideo_event );
				v.addEventListener( HypVideoEvent.PLAYBACK_SEEK , _onHypVideo_event );
				v.addEventListener( HypVideoEvent.PLAYBACK_STOP , _onHypVideo_event );
				v.playRemote("http://cdn.dmcloud.net/route/http/4f1ffb14f325e171730015e0/52036a1094a6f6203000002b/mp4_h264_aac.mp4?auth=1382529503-0-yms0b1eu-4ddbfc351894899f8d0f6e0433eeddac");
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _onHypVideo_event( e : HypVideoEvent ) : Void{
			trace("_onHypVideo_event ::: "+e.type+" | "+e.arg);
		}

	// -------o misc

}