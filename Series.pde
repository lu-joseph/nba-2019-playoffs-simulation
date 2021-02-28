class Series{
  Team team1,team2;
  int numGames;
  ArrayList<Game> games;
  Team winner;
  boolean over;
  String round;
  
  Series(Team t1,Team t2,int n,int r){
    this.team1 = t1;
    this.team2 = t2;
    this.numGames = n;
    this.games = new ArrayList<Game>();
    this.generateGames();
    this.over = false;
    
    switch(r){
      case 1:
        this.round = "Round 1";
        break;
      case 2:
        this.round = "Conference Semifinals";
        break;
      case 3:
        this.round = "Conference Finals";
        break;
      default:
        this.round = "NBA Finals";
        break;
    } 
  }
  
  //adds the appropriate number of games to the games ArrayList
  void generateGames(){
    for(int i=0;i<numGames;i++){
      games.add(new Game(this.team1,this.team2,this));
    }
  }


}
