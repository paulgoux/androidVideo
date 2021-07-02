class AndroidVideo {
  PApplet p;
  Activity act;
  int x, y, w, h;
  double mp_current_position;
  boolean on_start = true;
  String str;
  color bc, ds, glow;
  float duration;

  AndroidVideo() {
  };

  AndroidVideo(PApplet app) {
    p = app;
    initColors();
  };

  AndroidVideo(PApplet app, int xx, int yy, int ww, int hh) {
    p = app;
    x = xx;
    y = yy;
    h = hh;
    w = ww;
    initColors();
  };

  void initColors() {
    ds = color(50, 50, 0);    // dark stroke
    glow = color(0, 220, 220);// slider button
    bc = color(255, 100, 0);  // button
  };

  void load(String s) {
    initVideo(s);
  };

  void loadDataFile(String s) {
    initVideo(s);
  };

  void initVideo(String s) {
    act = p.getActivity();
    context = act.getApplicationContext();
    Looper.prepare();
    mp = new MediaPlayer();
    try {
      afd = context.getAssets().openFd(s);
      MediaMetadataRetriever metaRetriever = new MediaMetadataRetriever();
      metaRetriever.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
      String h = metaRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT);
      String w = metaRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH);
      video_w = int(w);
      video_h = int(h);
      println("Original video height = "+h+"  width = "+w);

      mp.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
      mp.prepare();
      duration = mp.getDuration();
      println("length = "+afd.getLength());
      println("duration = "+mp.getDuration());
      println("startOffset = "+afd.getStartOffset() );
    }
    catch (IOException e) {
      e.printStackTrace();
    }
    mySurface = new SurfaceView(act);
    mSurfaceHolder = mySurface.getHolder();
    mSurfaceHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
    mSurfaceHolder.addCallback(new SurfaceHolder.Callback() {
      @Override
        public void surfaceCreated(SurfaceHolder surfaceHolder) {
        mp.setDisplay(surfaceHolder);
        println("Surface  created");
      }
      @Override
        public void surfaceChanged(SurfaceHolder surfaceHolder, int i, int i2, int i3) {
        mp.setDisplay(surfaceHolder);
        println("Surface changed");
      }
      @Override
        public void surfaceDestroyed(SurfaceHolder surfaceHolder) {
        println("Surface destroid");
      }
    }
    );
    act.runOnUiThread(new Runnable() {
      public void run() {
        mSurfaceHolder = mySurface.getHolder();
        mSurfaceHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
        act.addContentView(mySurface, new ViewGroup.LayoutParams(video_width, video_height));
        mySurface.setZOrderOnTop(true);
        mySurface.setX(video_x);
        mySurface.setY(video_y);
      }
    }
    );
  }

  void display() {
    logic();
    if (on_start) { // Necessary to set first frame
      mp_current_position = mp.getCurrentPosition();
      if (mp_current_position > 2) {
        on_start = false;
        mp.pause();
      }
    }
    if (mousePressed) {
      mp_current_position = mp.getCurrentPosition();
      if (mouseX >= slider_x && mouseX <= slider_x+slider_length) {
        if (mouseY >= slider_y-height/30 && mouseY <= slider_y+height/30) {
          //slider.update();
        }
      }
    }
    if (mp.isPlaying()) {
      mp_current_position = mp.getCurrentPosition();
      displayTime();
      //slider.setPosition(mp_current_position); // Will be mapped there
    }
  };

  void display(PGraphics c) {
    logic();
    if (on_start) { // Necessary to set first frame
      mp_current_position = mp.getCurrentPosition();
      if (mp_current_position > 2) {
        on_start = false;
        //mp.pause();
      }
    }
    if (mousePressed) {
      //mp_current_position = mp.getCurrentPosition();
      //if (mouseX >= slider_x && mouseX <= slider_x+slider_length) {
      //  if (mouseY >= slider_y-height/30 && mouseY <= slider_y+height/30) {
      //    slider.update();
      //  }
      //}
    }

    if (mp.isPlaying()) {
      mp_current_position = mp.getCurrentPosition();
      displayTime(c);
      if (mousePressed)println("av disp playing");
      //slider.setPosition(mp_current_position); // Will be mapped there
    }
  };

  void displayTime() {  // The current video positioning time
  //logic();
    textSize(28*displayDensity*1200/height);
    stroke(ds);
    strokeWeight(3);
    textSize(24*displayDensity*1200/height);
    str = String.format("%d min, %d sec", 
      TimeUnit.MILLISECONDS.toMinutes((long) mp_current_position), 
      TimeUnit.MILLISECONDS.toSeconds((long) mp_current_position) -
      TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes((long)
      mp_current_position)));
    fill(bg);
    noStroke();
    float th = textAscent()+textDescent();
    rect(slider_x-15, video_y+video_height+20, textWidth(str)+30, th);
    fill(ds);
    text(str, slider_x, video_y+video_height+height/30);
  };

  void displayTime(PGraphics c) {  // The current video positioning time
    c.textSize(24*displayDensity*1200/height);
    String str = String.format("%d min, %d sec", 
      TimeUnit.MILLISECONDS.toMinutes((long) mp_current_position), 
      TimeUnit.MILLISECONDS.toSeconds((long) mp_current_position) -
      TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes((long)
      mp_current_position)));
    c.fill(bg);
    c.noStroke();
    float th = textAscent()+textDescent();
    c.rect(slider_x-15, video_y+video_height+20, textWidth(str)+30, th);
    c.fill(ds);
    c.text(str, slider_x, video_y+video_height+height/30);
  };

  void logic() {
    if (b1.toggle()) {
      if (mp.isPlaying() == false) {
        mp.start();
        b1.label = "Play";
        println("av play");
      }
      else if (mp.isPlaying() == true) {
        mp.pause();
        b1.label = "Pause";
        println(" av pause");
      }
    }
    if (b2.toggle()) {
      //mp.pause();
      slider.valuex = 0;
      slider.value = 0;
      mp.seekTo(0);
    }
    slider.set(0, duration);
    if (slider.mdown)mp.seekTo(int(slider.value));
  };

  
};
