HypMedias
=========

Haxe NME / OpenFL extension for Media Playback

Vidéo playback only for now, and soon recording, display image...

HypVideo:
-----------------------------

Allow to play Videos on Android & iOS

__Usage:__

The usage is quite simple:
```java
var v = HypVideo.getInstance( );
	v.addEventListener( HypVideoEvent.PLAYBACK_COMPLETE , _onHypVideo_event );
	v.addEventListener( HypVideoEvent.PLAYBACK_ERROR , _onHypVideo_event );
	v.addEventListener( HypVideoEvent.PLAYBACK_INFO , _onHypVideo_event );
	v.addEventListener( HypVideoEvent.PLAYBACK_PAUSE , _onHypVideo_event );
	v.addEventListener( HypVideoEvent.PLAYBACK_PLAY , _onHypVideo_event );
	v.addEventListener( HypVideoEvent.PLAYBACK_SEEK , _onHypVideo_event );
	v.addEventListener( HypVideoEvent.PLAYBACK_STOP , _onHypVideo_event );
	v.playRemote("VIDEOURL");
```

__iOS setup:__

Nothing to do.

__Android setup:__

For android you need to add the following activity to your AndroidManifest:
```xml
<!-- HypMedias -->
<activity
	android:name="fr.hyperfiction.hypmedias.HypVideoActivity"
	android:theme="@android:style/Theme.NoTitleBar.Fullscreen"
	android:label="HypMedias"
	android:screenOrientation="landscape"
/>
```

Made at [Hyperfiction](http://hyperfiction.fr)
--------------------
Developed by [Johann Martinache](https://github.com/shoebox) [@shoe_box](https://twitter.com/shoe_box)

License
-------
This work is under BSD simplified License.
