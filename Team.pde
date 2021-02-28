class Team{
  String name;
  Player[] players;
  
  int wins;
  
  //game stats
  int score;
  int threes;
  int twos;
  int numSteals;
  int numBlocks;
  
  String conf;
  GImageButton button;
  
  Team(Player[] p,String n,String c){
    this.name = n;
    this.players = p;
    
    this.wins = 0;
    
    this.score = 0;
    this.threes = 0;
    this.twos = 0;
    this.numSteals = 0;
    this.numBlocks = 0;
    
    this.conf = c;
  }
}
