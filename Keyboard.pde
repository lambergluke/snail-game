
class Keyboard {
  
  Boolean holdingUp,holdingRight,holdingLeft,holdingSpace;
  
  Keyboard() {
    holdingUp=holdingRight=holdingLeft=holdingSpace=false;
  }
  
  

  void pressKey(char key) {
    if(key == 'r') { 
      if(gameWon()) { 
        resetGame(); 
      }
    }
   
    if (key == 'w') {
      holdingUp = true;
    }
    if (key == 'a') {
      holdingLeft = true;
    }
    if (key == 'd') {
      holdingRight = true;
    }
    if (key == ' ') {
      holdingSpace = true;
    }
  }
  void releaseKey(int key) {
    if (key == 'w') {
      holdingUp = false;
    }
    if (key == 'a') {
      holdingLeft = false;
    }
    if (key == 'd') {
      holdingRight = false;
    }
    if (keyCode == ' ') {
      holdingSpace = false;
    }
  }
}