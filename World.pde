

class World {
  int kelpInStage; 
   

  static final int SKY = 0;
  static final int GROUND = 1;
  static final int KELP = 2;
  static final int CRABBY = 3;
  static final int START = 4;
  int meme = 0;
  int someTimerThing = 0;
  static final int LEVEL_SIZE = 60; 
 

  
  static final int LEVEL_WIDTH = 28;
  static final int LEVEL_HEIGHT = 12;

  int[][] worldGrid = new int[LEVEL_HEIGHT][LEVEL_WIDTH]; 
  
  
  int[][] start_Grid = { {1, 2, 3, 0, 0, 0, 0, 0, 0, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
                         {1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1},
                         {1, 1, 1, 0, 2, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {2, 2, 0, 0, 0, 2, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 3, 0, 3, 1, 3, 0, 0, 0, 0, 0, 0, 0},
                         {2, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                         {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0},
                         {0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0},
                         {0, 0, 2, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0},
                         {3, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 2, 0, 0, 0, 0, 1, 2, 0, 1},
                         {0, 0, 0, 1, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1},
                         {4, 0, 0, 0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 1, 0, 0, 1, 3, 1, 1},
                         {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1} };
                         
                         
 

  World() { 
     
  }
  
  
  int block(PVector currentPos) {
    float gridSpotX = currentPos.x/LEVEL_SIZE;
    float gridSpotY = currentPos.y/LEVEL_SIZE;
  
    
    if(gridSpotX<0) {
      return GROUND; 
    }
    if(gridSpotX>=LEVEL_WIDTH) {
      return GROUND; 
    }
    if(gridSpotY<0) {
      return GROUND; 
    }
    if(gridSpotY>=LEVEL_HEIGHT) {
      return GROUND;
    }
    
    return worldGrid[int(gridSpotY)][int(gridSpotX)];
  }
  
  
  void setSquareAtToThis(PVector currentPos, int newTile) {
    int gridSpotX = int(currentPos.x/LEVEL_SIZE);
    int gridSpotY = int(currentPos.y/LEVEL_SIZE);
  
    if(gridSpotX<0 || gridSpotX>=LEVEL_WIDTH || 
       gridSpotY<0 || gridSpotY>=LEVEL_HEIGHT) {
      return; 
    }
    
    worldGrid[gridSpotY][gridSpotX] = newTile;
  }
  
  
  float topOfSquare(PVector currentPos) {
    int thisY = int(currentPos.y);
    thisY /= LEVEL_SIZE;
    return float(thisY*LEVEL_SIZE);
  }
  float bottomOfSquare(PVector currentPos) {
    if(currentPos.y<0) {
      return 0;
    }
    return topOfSquare(currentPos)+LEVEL_SIZE;
  }
  float leftOfSquare(PVector currentPos) {
    int thisX = int(currentPos.x);
    thisX /= LEVEL_SIZE;
    return float(thisX*LEVEL_SIZE);
  }
  float rightOfSquare(PVector currentPos) {
    if(currentPos.x<0) {
      return 0;
    }
    return leftOfSquare(currentPos)+LEVEL_SIZE;
  }
  
  void reload() {
    kelpInStage = 0; 
    
    for(int i=0;i<LEVEL_WIDTH;i++) {
      for(int j=0;j<LEVEL_HEIGHT;j++) {
        if(start_Grid[j][i] == START) { 
          worldGrid[j][i] = SKY; 
  
          // then update the player spot to the center of that tile
          thePlayer.position.x = i*LEVEL_SIZE+(LEVEL_SIZE/2);
          thePlayer.position.y = j*LEVEL_SIZE+(LEVEL_SIZE/2);
        } else {
          if(start_Grid[j][i]==KELP) {
            kelpInStage++;
          }
          worldGrid[j][i] = start_Grid[j][i];
        }
      }
    }
  }
  
  void render() { 
     
    
    
    
    
    
    int x = 0;
    for(int i=0;i<LEVEL_WIDTH;i++) { 
      for(int j=0;j<LEVEL_HEIGHT;j++) { 
        switch(worldGrid[j][i]) { 
          case GROUND:
            stroke(76,70,50, 0); 
            fill(76,70,50, 0); 
            break;
          case CRABBY:
            stroke(30,144,2550);
            fill(20,144,2550); 
            break;
          default:
            stroke(30,144,255);
            fill(30,144,255); 
            break;
        }
          if(worldGrid[j][i] == GROUND){
             rect(i*LEVEL_SIZE,j*LEVEL_SIZE, 
             LEVEL_SIZE-1,LEVEL_SIZE-1);
             
             image(sand,i*LEVEL_SIZE,j*LEVEL_SIZE);
        } else if(worldGrid[j][i] == CRABBY){
          rect(i*LEVEL_SIZE,j*LEVEL_SIZE, 
             LEVEL_SIZE-1,LEVEL_SIZE-1);
             image(crab1,i*LEVEL_SIZE,j*LEVEL_SIZE);
        } else{
          rect(i*LEVEL_SIZE,j*LEVEL_SIZE, 
             LEVEL_SIZE-1,LEVEL_SIZE-1);
        }
        if(worldGrid[j][i]==KELP) { 
          someTimerThing = millis()/500;
          println(someTimerThing);
          if(someTimerThing%2 == 0){
            
            image(kelp,i*LEVEL_SIZE,j*LEVEL_SIZE);
          } else{
            image(kelp1,i*LEVEL_SIZE,j*LEVEL_SIZE);
          }
        }
      }
    }
  }
}