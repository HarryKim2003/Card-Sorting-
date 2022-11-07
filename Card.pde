float deltaX = 0;
float deltaX2 = 0;
float deltaY = 0;
float deltaY2 = 0;

class Card {
  //Fields
  int cardValue;
  int suitType;
  int trueValue;
  float xCoor;
  float yCoor;

  PImage image;

  //Constructor s
  Card(int cV, int sT, PImage img, int tV, float xC, float yC) {
    this.cardValue = cV;
    this.suitType = sT;
    this.image = img;
    this.trueValue = tV;
    this.xCoor = xC;
    this.yCoor = yC;
  }

  void plainDraw(int a) {    
    this.image.resize(int(xValue), int(yValue));
    
    if(choiceSwap.equals("selectionSort")) 
      this.xCoor = (padding *(a+1))+ xValue * a;

    image(this.image, this.xCoor, this.yCoor);
  }


  void linearSwap(Card b) {


    if (round(this.xCoor) <= round(destination)) { //Takes the two and swaps them slowly but surely. 
      this.xCoor += frameAddition;
      b.xCoor -= frameAddition;
      deltaX = destination - this.xCoor; 


      for (int i = 0; i < n; i++) {
        image(animatedStack[i].image, animatedStack[i].xCoor, animatedStack[i].yCoor);
      }
    } else { //if it's done swapping ..
      finishedAnimating = true;
      for (int j = 0; j<n; j++) {
        temporaryList[j] = abs(deltaXFix[j] - this.xCoor); //This is to fix overshooting.
      }
      deltaX = min(temporaryList);
    }
  }



  void circularSwap(Card b) { //Circular Swap! 
    println("destination coord is", destination);

    for (int i = 0; i < n; i++) {
      clear();
      animatedStack[i].plainDraw(i);
    }      

    if ( round(this.xCoor) <= round(destination) ) { //X component is the same. 
      this.xCoor += frameAddition;
      b.xCoor -= frameAddition;

      if (choice.equals("bubbleSort")) { //This has a little bit of math involved. It takes the period (two times the distance between the two cards being swapped) and uses a sin wave to animate a "circular" motion. 
        this.yCoor = 75*sin(2*PI/(2*(destinationXValue-originalXValue-0.5*deltaX)) * (this.xCoor)) + (height-yValue)/2.0 ;
        b.yCoor = -75*sin(2*PI/(2*(destinationXValue-originalXValue-0.5*deltaX)) * (this.xCoor)) + (height-yValue)/2.0 ;
        
        
      } else if (choice.equals("insertionSort")) {
        this.yCoor = 75*sin(2*PI/(2*(destinationXValue-originalXValue+0.5*deltaX)) * (this.xCoor+deltaX)) + (height-yValue)/2.0;
        b.yCoor = -75*sin(2*PI/(2*(destinationXValue-originalXValue+0.5*deltaX)) * (this.xCoor+deltaX) ) + (height-yValue)/2.0;
      }
      else {

        this.yCoor = 75*sin(2*PI/(2*(destinationXValue-originalXValue-0.5*deltaX)) * this.xCoor) + (height-yValue)/2.0;
        b.yCoor = -75*sin(2*PI/(2*(destinationXValue-originalXValue-0.5*deltaX)) * this.xCoor ) + (height-yValue)/2.0;
      }



      for (int i = 0; i < n; i++) {
        image(animatedStack[i].image, animatedStack[i].xCoor, animatedStack[i].yCoor);
      }
    } else {
      finishedAnimating = true;
      deltaY = this.yCoor - (height-yValue)/2.0; //Fixes overshooting. 


      for (int j = 0; j<n; j++) {
        temporaryList[j] = abs(deltaXFix[j] - this.xCoor);
      }
      deltaX = min(temporaryList);
    }
  }


  //Helper function I initialy used to test out my algorithms. No longer works due to various additions ;(. 
  void plainSwap(Card b) {
   float temporarry = b.xCoor;
    b.xCoor = this.xCoor;
    this.xCoor = temporarry;

  }
}
