

class Player {
  PVector position,velocity; 

  Boolean isOnGround; 
  Boolean facingRight; 
  int delay; 
  int currentFrame; 
  int KelpsCollected; 
  
  static final float JUMP_POWER = 11.0; 
  static final float RUN_SPEED = 1.0; 
  static final float AIR_SPEED = 2.0; 
  static final float SLOWDOWN_PERC = 0.6; 
  static final float AIRSPEED = 0.85; 
  static final int RUN_ANIMATION_DELAY = 3; 
  static final float RUN_DIRECTION = 1.0; 
  
  Player() { 
    isOnGround = false;
    facingRight = true;
    position = new PVector();
    velocity = new PVector();
    reset();
  }
  
  void reset() {
    KelpsCollected = 0;
    delay = 0;
    currentFrame = 0;
    velocity.x = 0;
    velocity.y = 0;
  }
  
  void inputCheck() {
   
    
    float speedHere = (isOnGround ? RUN_SPEED : AIR_SPEED);
    float frictionHere = (isOnGround ? SLOWDOWN_PERC : AIRSPEED);
    
    if(theKeyboard.holdingLeft) {
      velocity.x -= speedHere;
    } else if(theKeyboard.holdingRight) {
      velocity.x += speedHere;
    } 
    velocity.x *= frictionHere; 
    
    if(isOnGround) { 
      if(theKeyboard.holdingSpace || theKeyboard.holdingUp) { 
        sndJump.trigger(); 
        velocity.y = -JUMP_POWER; 
        isOnGround = false; 
      }
    }
  }
  
  void checkForWallBumping() {
    int snailWidth = snail2.width; 
    int snailHeight = snail2.height;
    int wallProbeDistance = int(snailWidth*0.3);
    int ceilingProbeDistance = int(snailHeight*0.95);
    
   
    
    
    PVector topLeft,topRight,bottomLeft,bottomRight,topSide;
    topLeft = new PVector();
    topRight = new PVector();
    bottomLeft = new PVector();
    bottomRight = new PVector();
    topSide = new PVector();

    
    topLeft.x = bottomLeft.x = position.x - wallProbeDistance; 
    topRight.x = bottomRight.x = position.x + wallProbeDistance; 
    bottomLeft.y = bottomRight.y = position.y-0.2*snailHeight; 
    topLeft.y = topRight.y = position.y-0.8*snailHeight; 

    topSide.x = position.x; 
    topSide.y = position.y-ceilingProbeDistance; 

    
    if( theWorld.block(topSide)==World.CRABBY ||
         theWorld.block(topLeft)==World.CRABBY ||
         theWorld.block(bottomLeft)==World.CRABBY ||
         theWorld.block(topRight)==World.CRABBY ||
         theWorld.block(bottomRight)==World.CRABBY ||
         theWorld.block(position)==World.CRABBY) {
      resetGame();
      return; 
    }
    
   
    
    if( theWorld.block(topSide)==World.GROUND) {
      if(theWorld.block(position)==World.GROUND) {
        position.sub(velocity);
        velocity.x=0.0;
        velocity.y=0.0;
      } else {
        position.y = theWorld.bottomOfSquare(topSide)+ceilingProbeDistance;
        if(velocity.y < 0) {
          velocity.y = 0.0;
        }
      }
    }
    
    if( theWorld.block(bottomLeft)==World.GROUND) {
      position.x = theWorld.rightOfSquare(bottomLeft)+wallProbeDistance;
      if(velocity.x < 0) {
        velocity.x = 0.0;
      }
    }
   
    if( theWorld.block(topLeft)==World.GROUND) {
      position.x = theWorld.rightOfSquare(topLeft)+wallProbeDistance;
      if(velocity.x < 0) {
        velocity.x = 0.0;
      }
    }
   
    if( theWorld.block(bottomRight)==World.GROUND) {
      position.x = theWorld.leftOfSquare(bottomRight)-wallProbeDistance;
      if(velocity.x > 0) {
        velocity.x = 0.0;
      }
    }
   
    if( theWorld.block(topRight)==World.GROUND) {
      position.x = theWorld.leftOfSquare(topRight)-wallProbeDistance;
      if(velocity.x > 0) {
        velocity.x = 0.0;
      }
    }
  }

  void checkForKelpGetting() {
    PVector centerOfPlayer;
   
    centerOfPlayer = new PVector(position.x,position.y-snail2.height/2);

    if(theWorld.block(centerOfPlayer)==World.KELP) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.SKY);
      sndKelp.trigger();
      KelpsCollected++;
    }
  }

  void checkForFalling() {
    
    if(theWorld.block(position)==World.SKY ||
       theWorld.block(position)==World.KELP) {
       isOnGround=false;
    }
    
    if(isOnGround==false) { 
      if(theWorld.block(position)==World.GROUND) { 
        isOnGround = true;
        position.y = theWorld.topOfSquare(position);
        velocity.y = 0.0;
      } else { // fall
        velocity.y += GRAVITY_POWER;
      }
    }
  }

  void move() {
    position.add(velocity);
    
    checkForWallBumping();
    
    checkForKelpGetting();
    
    checkForFalling();
  }
  
  void draw() {
    int snailWidth = snail2.width;
    int snailHeight = snail2.height;
    
    if(velocity.x<-RUN_DIRECTION) {
      facingRight = false;
    } else if(velocity.x>RUN_DIRECTION) {
      facingRight = true;
    }
    
    pushMatrix(); 
    translate(position.x,position.y);
    if(facingRight==false) {
      scale(-1,1); 
    }
    translate(-snailWidth/2,-snailHeight); 

    if(isOnGround==false) { 
      image(snailjump, 0,0); 
    } else if(abs(velocity.x)<RUN_DIRECTION) { 
      image(snail2, 0,0);
    } else { // running. Animate.
      if(delay--<0) {
        delay=RUN_ANIMATION_DELAY;
        if(currentFrame==0) {
          currentFrame=1;
        } else {
          currentFrame=0;
        }
      }
      
      if(currentFrame==0) {
        image(snail1, 0,0);
      } else {
        image(snail2, 0,0);
      }
    }
    
    popMatrix(); 
  }
}