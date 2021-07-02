// Thanks to @conrad and @akenaton
// The video also can auto-loop by using mp.setLooping(true); below the line  mp.prepare();
// The video can be fast forwarded/backwarded with the slider.
// When used on APDE you have to run it in "App mode"

import android.media.MediaMetadataRetriever;
import android.os.Looper;
import android.app.Activity;
import android.view.ViewGroup;
import android.view.View;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.media.MediaMetadataRetriever;
import android.media.MediaPlayer;
import android.content.res.Resources;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.content.Context;
import java.util.concurrent.TimeUnit;

PGraphics c,canvas;
PShader mean, canny, gaussian, variance;
int  video_x, video_y, video_width, video_height, video_w, video_h;
String video_title;
float  slider_length, slider_x, slider_y;

color bg;

AssetFileDescriptor afd;
Context context;
Activity act;
SurfaceView mySurface;
SurfaceHolder mSurfaceHolder;
MediaMetadataRetriever metaRetriever;
MediaPlayer mp;
Slider slider;
AndroidVideo av;
BMS b;
sliderBox sl1;
Button b1, b2, b3;
Menu m1;
tab t1;
Dropdown d1;

void setup() {
  orientation(PORTRAIT);

  // Colors
  bg = color(255, 165, 0);  // background

  b = new BMS(this, true);

  t1 = new tab(0, 80, 120, 550, "Mean", b);
  //t1.toggle = true;
  t1.draggable = true;
  String []s1 = {"Range", "Mult"};
  sl1 = new sliderBox (20, 20, 60, 60, 20, s1, b);
  sl1.setPieSquare();
  //sl1.setClassicBar();
  t1.add( sl1);
  b.add(t1);
  b.dock.add(t1);
  // Video values
  video_title = "data.mp4"; // video in data folder
  video_width = 3*width/4; // Set here desired width because video is resized/fit into these values.
  video_height = height/3; // Desired height
  video_x = (displayWidth-video_width)/2;
  video_y = (displayHeight-video_height)/4;

  av = new AndroidVideo(this, video_x, video_y, video_width, video_height);
  av.load(video_title);
  // Slider values
  slider_length = video_width; // Normally video width
  slider_x = (width - slider_length)/2;
  slider_y = video_y+video_height+height/20;

  slider = new Slider(slider_x, slider_y, video_width, 10, "vidPos", b);
  slider.setClassicBar();
  slider.valuex = 0;
  slider.value = 0;
  b.add(slider);

  b1 = new Button(slider.x, slider.y+slider.h+20, 90, 40, "Play", b);
  b.add(b1);

  b2 = new Button(b1.x+b1.w+20, slider.y+slider.h+20, 90, 40, "Restart", b);
  b.add(b2);
  String[] d1Labels = {"Mean", "Canny", "Sobel"};
  d1 = new Dropdown(width-120, 90, 90, 40, 0, "Shader", d1Labels, b);
  mp.start();
  c = createGraphics(video_width, video_height, P2D);
  canvas = createGraphics(video_width, video_height, P2D);
  mean = loadShader("mean.glsl");
  canny = loadShader("canny.glsl");
  gaussian = loadShader("gaussian.glsl");
  variance = loadShader("variance.glsl");
};

void draw() {
  background(bg);
  
  //c.beginDraw();
  //av.display(c);
  
  ////mean.set("texture",
  //c.shader(mean);
  //image(c, video_x, video_y);
  //c.endDraw();
  
  b.run();
  if (t1.toggle) {
    t1.setPieInt(0, 0, 0, 10);
    t1.setPie(0, 1, -1, 1);
  }
  b.theme.run();
};

void settings() {
  fullScreen (P2D);
};

void onStop() {
  if (mp!=null) {
    mp.release();
    mp = null;
    println ("Stopped");
  }
  super.onStop() ;
};
