/*
Luke Lamberg final project
crab1 from https://pixabay.com/en/crab1-crustacean-shell-sea-seafood-42880/
Eating sound from https://www.freesound.org/people/Ondruska/sounds/360686/
*/


import ddf.minim.*;
Minim minim;

PImage sand;
PImage crab1;
PImage snail1, snail2, snailjump;
PImage kelp, kelp1;

// music
AudioPlayer music; 
AudioSample sndJump, sndKelp; 

// track camera
float cameraOffsetX;

Player thePlayer = new Player();
World theWorld = new World();
Keyboard theKeyboard = new Keyboard();

PFont font;


int gameStartTimeSec,gameCurrentTimeSec;


final float GRAVITY_POWER = 0.5; 

void setup() { 
  size(1200,720); 
  sand = loadImage("Sand.jpg");
  crab1 = loadImage("crab1.png");
  font = loadFont("SansSerif-20.vlw");
  snailjump = loadImage("snailjump.png");
  snail1 = loadImage("snail1.png");
  snail2 = loadImage("snail2.png");
  kelp = loadImage("kelp.png");
  kelp1 = loadImage("kelp1.png");
  cameraOffsetX = 0.0;
  
  minim = new Minim(this);
  music = minim.loadFile("sound file.mp3", 1024);
  music.loop();
  int buffersize = 256;
  sndJump = minim.loadSample("jumpNoise.mp3", buffersize);
  sndKelp = minim.loadSample("nomnom.mp3", buffersize);
  
  frameRate(24); 
  
  resetGame(); 
}

void resetGame() {
  
  
  thePlayer.reset(); 
  
  theWorld.reload(); 

  
  gameCurrentTimeSec = gameStartTimeSec = millis()/1000; 
}

Boolean gameWon() { 
  return (thePlayer.KelpsCollected == theWorld.kelpInStage);
}

void outlinedText(String sayThis, float atX, float atY) {
  textFont(font); 
  fill(0); 
  text(sayThis, atX-1,atY);
  text(sayThis, atX+1,atY);
  text(sayThis, atX,atY-1);
  text(sayThis, atX,atY+1);
  fill(255); 
  text(sayThis, atX,atY);
}

void updateCameraPosition() {
  int rightEdge = World.LEVEL_WIDTH*World.LEVEL_SIZE-width;
  
  
  cameraOffsetX = thePlayer.position.x-width/2;
  if(cameraOffsetX < 0) {
    cameraOffsetX = 0;
  }
  
  if(cameraOffsetX > rightEdge) {
    cameraOffsetX = rightEdge;
  }
}

void draw() { 
  pushMatrix(); 
  translate(-cameraOffsetX,0.0); 
  updateCameraPosition();

  theWorld.render();
    
  thePlayer.inputCheck();
  thePlayer.move();
  thePlayer.draw();
  
  popMatrix(); 
  
  if(focused == false) { 
    textAlign(CENTER);
    outlinedText("Click to resume.\n\nUse WASD to move.\nSpacebar to jump.",width/2, height-90);
  } else {
    textAlign(LEFT); 
    outlinedText("Kelp:"+thePlayer.KelpsCollected +"/"+theWorld.kelpInStage,8, height-10);
    
    textAlign(RIGHT);
    if(gameWon() == false) { 
      gameCurrentTimeSec = millis()/1000; 
    }
    int minutes = (gameCurrentTimeSec-gameStartTimeSec)/60;
    int seconds = (gameCurrentTimeSec-gameStartTimeSec)%60;
    if(seconds < 10) {
      outlinedText(minutes +":0"+seconds,width-8, height-10);
    } else {
      outlinedText(minutes +":"+seconds,width-8, height-10);
    }
    
    textAlign(CENTER); 
    
    if(gameWon()) {
      outlinedText("You win!\nPress R to Reset.",width/2, height/2-12);
    }
  }
}

void keyPressed() {
  theKeyboard.pressKey(key);
}

void keyReleased() {
  theKeyboard.releaseKey(key);
}

void stop() { 
  music.close();
  sndJump.close();
  sndKelp.close();
 
  minim.stop();

  super.stop(); 
}