// Name: Harry Kim //

//Global Variables Section.
import g4p_controls.*;

PImage image;
PImage backGround;

int n = 15; //This will be changed later so the user can change in GUI. The number of originalStack.

int padding = 20;
int indicesFactor; 
int randomVariable = 0;
int t;
int magicNumber;
int doneOnce = 0; 
int doneOnce1 = 0;
int negativeFix = 0;
int frame = 10;
int indexToBeAnimated;
int onCard;

float destination;
float destinationXValue;
float originalXValue;
float destinationYValue;
float originalYValue;
float ratio = 691.0/1056.0; //original size. 
float xValue;
float yValue;
float frameAddition = 3;

//Change to Gui later. 
String choice = "insertionSort"; //This can be insertionSort, bubbleSort, selectionSort. 
String choiceSwap = "circularSwap";
float speed = 1;

boolean finishedAnimating;
boolean animating;
boolean finishing;
boolean forceFinish;
boolean adding;
boolean mouseIsClicked;
boolean moving;

int[] suitType = new int[n]; 
int[] cardValue = new int[n];


float[] tempXx = new float[n];
float[] tempYy = new float[n];
float[] deltaXFix = new float[n];
float[] temporaryList = new float[n];

boolean[] toBeDrawn = new boolean[n];

Card[] originalStack = new Card[n];
Card[] animatedStack = new Card[n];


ArrayList<Integer> indicesToBeSwapped = new ArrayList<Integer>();
ArrayList<Float> destinationX = new ArrayList<Float>();
ArrayList<Integer> arrayOfMins = new ArrayList<Integer>();
ArrayList<Float> heldValues = new ArrayList<Float>();
ArrayList<Float> cardXMiddle = new ArrayList<Float>();
ArrayList<Float> cardYMiddle = new ArrayList<Float>();

//Global Variables Section End. 

void setup() {

  size(1500, 844); //Creates the Screen
  createGUI(); //Creates the GUI 

  xValue = ((width-padding*(n+1))/float(n));  //Sets the size of the card depending on the amount of cards. 
  yValue = (xValue * pow(ratio, -1)); //Sets the yValue using a ratio and the xValue. 
  boolean original; //A boolean used to later to set original values for each card. 
  indicesFactor = 0;

  for (int i = 0; i < n; i++) { //Sets random card values.
    original = false;


    while (original == false) { //Clever little scan to ensure that there are no repeated cards. 
      suitType[i] = round(random(1, 4)); 
      cardValue[i] = round(random(2, 14));    

      for (int j = 0; j <= i; j++) {
        if ( i != j) {
          if (suitType[i] == suitType[j] && cardValue[i] == cardValue[j]) {
            original = false;   
            break;
          } else {
            original = true;
          }
        }
        original = true;
      }
    }


//Section that sets the fields for the set of cards that are used. 
    int trueValue = 4*(cardValue[i]-2) + suitType[i]; //Calculates the value of this card. Simple formula to determine its unique value. 
    image = loadImage(str(cardValue[i]) + "-" + str(suitType[i]) + ".png");

    float tempX = (padding*(i+1))+ xValue*i;
    float tempY = ((height-yValue)/2.0);

    cardXMiddle.add((tempX + xValue)/2.0);
    cardYMiddle.add((tempY + yValue)/2.0);

    tempXx[i] = tempX;
    tempYy[i] = tempY;
    deltaXFix[i] = tempX;
    //printArray(deltaXFix);
    //println(xValue);

    originalStack[i] = new Card(suitType[i], cardValue[i], image, trueValue, tempX, tempY);
    animatedStack[i] = originalStack[i];
  } 
  //noLoop();

//Defaulted to insertion sort. 
  if (choice.equals("bubbleSort"))
    originalStack = bubbleSort(originalStack);
  else if (choice.equals("insertionSort"))
    originalStack = insertionSort(originalStack);
  else if (choice.equals("selectionSort"))
    originalStack = selectionSort(originalStack);
  else if (choice.equals( "manualSort"))
    println("manual sort!");


//These are booleans that help the Reset button in the GUI. 
  animating = true;
  finishing = false;
}


void draw() {
  
  //If the code is not finished before the user hits Reset on the GUI, this section quickly uses a while loop to finish sorting and clear the arrays of unwanted stuff before moving on to the next
  //set of cards.
  
  if (finishing == false) {
    drawing();
  } else {
    while (finishing == false)
      drawing();
    //println("hello");
  }
}



//Draw section. Pretty straightforward. 
void drawing() {

  //If the code is animating... 
  if (animating == true) {

    
    
   ////////////////////////////////////////////////////////////////////////////////// BUBBLE SORT ///////////////////////////////////////////////////////////////////////////////
    if (choice.equals("bubbleSort" )) { //If the user chooses bubble sort... 
    //Draws the cards. 
      for (int i = 0; i<n; i++) {
        animatedStack[i].plainDraw(i);
      } 

      if ((frame % speed == 0) && (randomVariable < indicesToBeSwapped.size()) && choiceSwap.equals("linearSwap")) { //If the user chooses linear swap... 
        Card justARandomVariable = animatedStack[indicesToBeSwapped.get(randomVariable)];  //Placeholder variable for use later. 

        destination = animatedStack[indicesToBeSwapped.get(randomVariable) + 1].xCoor + xValue; //This is the destination. 
        destination -= (destination- animatedStack[indicesToBeSwapped.get(randomVariable)].xCoor) % frameAddition; //Reduces "overshooting". 

        if (finishedAnimating == false) { //If the swap is not finished... 
          animatedStack[indicesToBeSwapped.get(randomVariable)].linearSwap(animatedStack[indicesToBeSwapped.get(randomVariable) +1]); //Swaps the cards. 
        } else {

          animatedStack[indicesToBeSwapped.get(randomVariable)].xCoor += deltaX;  //Fixes "overshooting" 
          animatedStack[indicesToBeSwapped.get(randomVariable)+1].xCoor -= deltaX;


          animatedStack[indicesToBeSwapped.get(randomVariable)] = animatedStack[indicesToBeSwapped.get(randomVariable) + 1];
          animatedStack[indicesToBeSwapped.get(randomVariable) + 1] = justARandomVariable;         //Actually swaps them in the array.



          randomVariable ++;
          finishedAnimating = false;
          //Moving on to the next animation. 
        }
      } else if (randomVariable == indicesToBeSwapped.size()) {
        finishing = true;
        forceFinish = false;
      } 
      
      
      
      else if ((frame % speed == 0) && (randomVariable < indicesToBeSwapped.size()) && choiceSwap.equals("circularSwap")) { //If the user chooses cirular swap.. 
        Card justARandomVariable = animatedStack[indicesToBeSwapped.get(randomVariable)]; 

        destination = animatedStack[indicesToBeSwapped.get(randomVariable) + 1].xCoor + xValue;
        destination -= (destination- animatedStack[indicesToBeSwapped.get(randomVariable)].xCoor) % frameAddition; //Reduces overshooting. 
        
        
        if (finishedAnimating == false) { //If the animation is not finished... 
          if (doneOnce == 0) { //To not overwrite things we don't want overwritten. 
            destinationXValue = animatedStack[indicesToBeSwapped.get(randomVariable)].xCoor;
            originalXValue = animatedStack[indicesToBeSwapped.get(randomVariable)+1].xCoor;
            doneOnce ++; 
          } 

          animatedStack[indicesToBeSwapped.get(randomVariable)].circularSwap(animatedStack[indicesToBeSwapped.get(randomVariable) +1]); //Calls circular swap. 
        } 
        
        
        else {     //If the animation is finished...     
          animatedStack[indicesToBeSwapped.get(randomVariable)] = animatedStack[indicesToBeSwapped.get(randomVariable) + 1];
          animatedStack[indicesToBeSwapped.get(randomVariable) + 1] = justARandomVariable;

          animatedStack[indicesToBeSwapped.get(randomVariable)].xCoor -= deltaX;  //Fixes overshooting. 
          animatedStack[indicesToBeSwapped.get(randomVariable)+1].xCoor += deltaX;

          animatedStack[indicesToBeSwapped.get(randomVariable)].yCoor += deltaY ;
          animatedStack[indicesToBeSwapped.get(randomVariable)+1].yCoor -= deltaY;

          randomVariable ++;
          finishedAnimating = false; //We are done the animation. 
        }
      } else if (randomVariable == indicesToBeSwapped.size()) {
        finishing = true;
        forceFinish = false;
      }
    } 
    ////////////////////////////////////////// BUBBLE SORT ////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    ////////////////////////////////////////////////////// MANUAL SORT ///////////////////////////////////////////////////////////////
    else if (choice.equals("manualSort")) {
//this is a secret comment that only appears 1 in 610204 comments. Say hello! 
      
          //If the mouse is clicked! 
      if (mouseIsClicked == true && moving == false) {
        for (int i = 0; i<n; i++) {
          if ((mouseX >= originalStack[i].xCoor) && (mouseX <= originalStack[i].xCoor + xValue) && (mouseY >= originalStack[i].yCoor) && (mouseY <= originalStack[i].yCoor + yValue)) {
            onCard = i;
            println(i);
            break;
          }
        }
      }
        //if the mouse stars moving!
      if (mouseIsClicked == true && moving == true) {
        if ((mouseX >= originalStack[onCard].xCoor) && (mouseX <= originalStack[onCard].xCoor + xValue) && (mouseY >= originalStack[onCard].yCoor) && (mouseY <= originalStack[onCard].yCoor + yValue)){ 
          //The line above can be commmented out with a "}" to allow the card to continue moving even when the mouse is no longer on the card. Causes mild
          //Issues with the card that is selected, so I decided to keep it in to keep things smooth.
  
          originalStack[onCard].xCoor = mouseX - xValue/2.0;
          originalStack[onCard].yCoor = mouseY - yValue/2.0;
          moving = false;
        }
      }
    } 
    
    
    
    ////////////////////////////////////////////////// MANUAL SORT /////////////////////////////////////////////////////////////
    
    
    
    ///////////////////////////////////////////////// INSERTION SORT /////////////////////////////////////////////////////
    else if (choice.equals("insertionSort")) {    //Insertion Sort! 
      for (int i = 0; i<n; i++) {
        animatedStack[i].plainDraw(i);
      }
      //Draws the cards. 
      
      if ( (frame % speed == 0) && (randomVariable < indicesToBeSwapped.size()) && choiceSwap.equals("linearSwap")) {   //If the user chooses linear swap... 
        int c = indicesToBeSwapped.get(randomVariable);

        if (c > 0 && animatedStack[c].trueValue <= animatedStack[c-1].trueValue) {
          Card justARandomVariable = animatedStack[c]; //Placeholder variable. 
          if (doneOnce == 0) { //To prevent overwriting things that we don't want overwritten. 
            for (int a = 0; a < n; a++) {
              heldValues.add(animatedStack[a].xCoor);
            }
            doneOnce ++;
          }

          destination = heldValues.get(c);

          if (finishedAnimating == false) { //As long as the animation is not finished swapping...
            if (doneOnce == 0) {
              destinationXValue = animatedStack[c].xCoor;
              originalXValue = animatedStack[c-1].xCoor;
              doneOnce ++;
            }


            animatedStack[c-1].linearSwap(animatedStack[c]);
          }
          
          else { //Once the animation is finished...

            animatedStack[c].xCoor += deltaX;
            animatedStack[c-1].xCoor -= deltaX;         //Fixes overshooting. 

            animatedStack[c]= animatedStack[c-1];
            animatedStack[c-1] = justARandomVariable;
            c--;
            randomVariable ++;
            finishedAnimating = false;
          }
        }
      } else if (randomVariable == indicesToBeSwapped.size()) { //Resets animation. 
        finishing = true;
        forceFinish = false;
      }
 
      
      if ( (frame % speed == 0) && (randomVariable < indicesToBeSwapped.size()) && choiceSwap.equals("circularSwap")) {    //Same logic as above. 
        int c = indicesToBeSwapped.get(randomVariable);

        if (c > 0 && animatedStack[c].trueValue <= animatedStack[c-1].trueValue) {
          Card justARandomVariable = animatedStack[c]; //Placeholder variable! 
          if (doneOnce == 0) {
            for (int a = 0; a < n; a++) {
              heldValues.add(animatedStack[a].xCoor);
              destinationXValue = animatedStack[c].xCoor;
              originalXValue = animatedStack[c-1].xCoor;
            }
            doneOnce ++;
          }

          destination = heldValues.get(c); //Sets destination. 


          if (doneOnce == 0) {
            destinationXValue = animatedStack[c].xCoor;
            originalXValue = animatedStack[c-1].xCoor;
            doneOnce ++;
          }
          if (finishedAnimating == false) { //As long as it's still animating the sawp. 
            animatedStack[c-1].circularSwap(animatedStack[c]);
          } else { //When it finishes animating swap. 

            animatedStack[c].xCoor += deltaX; //Fixes overshooting. 
            animatedStack[c-1].xCoor -= deltaX;   

            animatedStack[c].yCoor += deltaY ;
            animatedStack[c-1].yCoor -= deltaY;

            animatedStack[c]= animatedStack[c-1];
            animatedStack[c-1] = justARandomVariable;
            c--;
            randomVariable ++;
            finishedAnimating = false;
          }
        }
      } 
      
      else if (randomVariable == indicesToBeSwapped.size()) { //Resets. 
        finishing = true;
        forceFinish = false;
      }
    } 
    
    ////////////////////////////////////////////// INSERTION SORT ///////////////////////////////////////////////////////////////
    
    //else if (choice.equals("selectionSort")) { //This is actually extremely sad. 
    //  for (int i = 0; i<n; i++) {
    //    animatedStack[i].plainDraw(i);
    //  } 
    //  if ((frame % speed == 0) && (randomVariable < indicesToBeSwapped.size()) && choiceSwap.equals("linearSwap")) {
    //    Card justARandomVariable = animatedStack[indicesToBeSwapped.get(randomVariable)];

    //    //      if (doneOnce == 0) {
    //    //        for (int a = 0; a < n; a++) {
    //    //          heldValues.add(animatedStack[a].xCoor);
    //    //        }
    //    //        doneOnce ++;
    //    //      }

    //    //destination = heldValues.get(indicesToBeSwapped.get(randomVariable));
    //    //destination = animatedStack[(indicesToBeSwapped.get(randomVariable))].xCoor + ((animatedStack[randomVariable].xCoor + animatedStack[indicesToBeSwapped.get(randomVariable)].xCoor)/2.0);
    //    destination = animatedStack[(indicesToBeSwapped.get(randomVariable))].xCoor;

    //    if (finishedAnimating == false) {
    //      animatedStack[randomVariable].linearSwap(animatedStack[indicesToBeSwapped.get(randomVariable)]);
    //    } else {
    //      animatedStack[randomVariable] = animatedStack[indicesToBeSwapped.get(randomVariable)];
    //      animatedStack[indicesToBeSwapped.get(randomVariable)] = justARandomVariable;
    //      randomVariable ++;
    //      finishedAnimating = false;
    //    }
    //  } else if (randomVariable == indicesToBeSwapped.size()) {
    //    finishing = true;
    //    forceFinish = false;
    //  }
    //  else if ((frame % speed == 0) && (randomVariable < indicesToBeSwapped.size()) && choiceSwap.equals("circularSwap")){
     
    //    Card justARandomVariable = animatedStack[indicesToBeSwapped.get(randomVariable)];

    //    //      if (doneOnce == 0) {
    //    //        for (int a = 0; a < n; a++) {
    //    //          heldValues.add(animatedStack[a].xCoor);
    //    //        }
    //    //        doneOnce ++;
    //    //      }

    //    //destination = heldValues.get(indicesToBeSwapped.get(randomVariable));
    //    //destination = animatedStack[(indicesToBeSwapped.get(randomVariable))].xCoor + ((animatedStack[randomVariable].xCoor + animatedStack[indicesToBeSwapped.get(randomVariable)].xCoor)/2.0);
    //    destination = animatedStack[(indicesToBeSwapped.get(randomVariable))].xCoor;

    //    if (finishedAnimating == false) {
    //      animatedStack[randomVariable].circularSwap(animatedStack[indicesToBeSwapped.get(randomVariable)]);
    //    } else {
    //      animatedStack[randomVariable] = animatedStack[indicesToBeSwapped.get(randomVariable)];
    //      animatedStack[indicesToBeSwapped.get(randomVariable)] = justARandomVariable;
    //      randomVariable ++;
    //      finishedAnimating = false;
    //    }
    //  } else if (randomVariable == indicesToBeSwapped.size()) {
    //    finishing = true;
    //    forceFinish = false;
    //  }      
      
      
    //  }
      
      else if (choice.equals( "selectionSort")){
    if ((frame % speed == 0) && (randomVariable < indicesToBeSwapped.size())) {
      Card justARandomVariable = animatedStack[randomVariable];
      
      animatedStack[randomVariable] = animatedStack[indicesToBeSwapped.get(randomVariable)];
      animatedStack[indicesToBeSwapped.get(randomVariable)] = justARandomVariable;  
      randomVariable ++;
      finishing = false;
      forceFinish = false;
      finishedAnimating = false;
      
      println("will you shut up man");
    }
  
  }
   
    clear(); //Clears the screen of any junk. 
      //backGround = loadImage("backGround.jpg");
      //background(backGround);
      
    for (int i = 0; i<n; i++) {
      animatedStack[i].plainDraw(i);
    } 
    //Draw. 
 
    frame += frameAddition; //Next frame! 

  }
}


void emptyArray() { //Empties all arrays that need to be emptied. 
  if (finishing == false) {
    indicesToBeSwapped.clear();
    destinationX.clear();
    arrayOfMins.clear();
    //heldValues.clear();   
    originalStack = (Card[])expand(originalStack, n);
    animatedStack = (Card[])expand(animatedStack, n+1);
    randomVariable = 0;
    doneOnce = 0;
  }
}



void resetParameters() { //Resets parameters. Very similar to setup() but with a few differences. 
  emptyArray();


  xValue = ((width-padding*(n+1))/float(n));
  yValue = (xValue * pow(ratio, -1));
  boolean original;
  indicesFactor = 0;

  for (int i = 0; i < n; i++) { //Sets random card values.
    original = false;
    while (original == false) { //Clever little scan to ensure that there are no repeated cards. 
      suitType[i] = round(random(1, 4)); 
      cardValue[i] = round(random(2, 14));    

      for (int j = 0; j <= i; j++) {
        if ( i != j) {
          if (suitType[i] == suitType[j] && cardValue[i] == cardValue[j]) {
            original = false; 
            break;
          } else {
            original = true;
          }
        }
        original = true;
      }
    }

    int trueValue = 4*(cardValue[i]-2) + suitType[i]; //Calculates the value of this card. Simple formula to determine its unique value. 
    image = loadImage(str(cardValue[i]) + "-" + str(suitType[i]) + ".png");



    float tempX = (padding*(i+1))+ xValue*i;
    float tempY = ((height-yValue)/2.0);

    tempXx[i] = tempX;
    tempYy[i] = tempY;

    originalStack[i] = new Card(suitType[i], cardValue[i], image, trueValue, tempX, tempY);
    animatedStack[i] = originalStack[i];
    println(n);
  } 

  if (choice.equals("bubbleSort"))
    originalStack = bubbleSort(originalStack);
  else if (choice.equals("insertionSort"))
    originalStack = insertionSort(originalStack);
  else if (choice.equals("selectionSort"))
    originalStack = selectionSort(originalStack);
  else if (choice.equals( "manualSort"))
    println("manual sort!");

  animating = true;
  finishing = false;
}



Card[] selectionSort(Card[] a) { //Selection Sort.

  for (int i = 0; i < n; i++) {
    int indexOfMin = i; 
    for (int j = i+1; j < a.length; j++) {
      if (a[j].trueValue < a[indexOfMin].trueValue)
        indexOfMin = j;
    }

    Card placeHolder = a[i] ;

    a[i] = a[indexOfMin];
    a[indexOfMin] = placeHolder;

    indicesToBeSwapped.add(indexOfMin);
    destinationX.add(a[indexOfMin].xCoor);
  }
  return a;
}


Card[] bubbleSort(Card[] a) { //Bubble Sort
  for (int p = 1; p <= n-1; p++) {
    for (int i = 0; i <= (n-p-1); i++) {
      if ( a[i].trueValue > a[i+1].trueValue) {
        Card justARandomVariable = a[i];
        indicesToBeSwapped.add(i);
        if (p == 1)
          magicNumber += 1;
        destinationX.add(a[i+1].xCoor);

        a[i] = a[i+1];
        a[i+1] = justARandomVariable;
      }
    }
  }
  return a;
}


Card[] insertionSort(Card[] a) { //Insertion Sort
  for (int i = 1; i <= n-1; i++) {
    int c = i; 
    while (c > 0 && a[c].trueValue < a[c-1].trueValue) {

      Card justARandomVariable = a[c];
      indicesToBeSwapped.add(c);
      destinationX.add(a[c].xCoor);
      a[c]= a[c-1];
      a[c-1] = justARandomVariable; 
      c--;
    }
  }
  return a;
}



//These three are mini functions that are tied with the booleans used in manual swap. 
void mousePressed() { 
  mouseIsClicked = true;
  println("hello");
}

void mouseReleased() {
  mouseIsClicked = false;
  moving = false;
  println("goodbye!");
}
void mouseDragged(){
  moving = true; 
}


// And that's all, folks! 
