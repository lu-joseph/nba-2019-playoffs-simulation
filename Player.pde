class Player{
  String name;
  boolean isCenter;
  
  //abilities
  float threePoint;
  float twoPoint;
  float steal;
  float block;
  float tipOff;
  
  //game stats
  int points;
  int threes;
  int threesTotal;
  int twos;
  int twosTotal;
  int numSteals;
  int numBlocks;
    
  Player(String n,float thP,float twP,float s,float b,float tO){
    this.name = n;
    this.isCenter = true;
    this.threePoint = thP;
    this.twoPoint = twP;
    this.steal = s;
    this.block = b;
    this.tipOff = tO;
    
    this.points = 0;
    this.threes = 0;
    this.twos = 0;
    this.threesTotal = 0;
    this.twosTotal = 0;
    this.numSteals = 0;
    this.numBlocks = 0;
  }
  
}
