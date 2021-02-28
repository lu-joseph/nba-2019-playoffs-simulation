class Game {
  Team team1, team2;

  //keeps track of possession
  Team hasBall, defence;

  //to be determined at the end of the game
  Team winner, loser;

  boolean startGame, endGame;
  boolean overtime;

  int timeLeft; //always in seconds
  int quarter;

  Series series;

  ArrayList<String> events;

  Game(Team t1, Team t2, Series s) {
    this.team1 = t1;
    this.team2 = t2;
    this.timeLeft = minsPerQuarter*60;
    this.quarter = 1;
    this.startGame = true;
    this.endGame = false;
    this.overtime = false;
    this.series = s;
    this.events = new ArrayList<String>();
  }

  void updateTime() {
    int pTime = round(random(5, 24)); //amount of time the possession took

    this.timeLeft -= pTime;

    if (this.timeLeft<0) {
      this.timeLeft = 0;
    }

    if (showGame&&!quickSim) {
      this.printTime();
    }

    if (this.timeLeft==0&&this.quarter<4) { //if at the end of a quarter (not 4th)     
      this.timeLeft += minsPerQuarter*60;
      this.quarter++;
    } else if (this.timeLeft==0&&this.quarter>=4) { //at the end of a quarter(4th or overtime)
      if (this.team1.score==this.team2.score) { //allows overtime if the score is tied
        this.overtime();
      } else {
        this.finish();
        this.endGame = true;
      }
    }
  }

  //swaps possession
  void switchPossession() {
    Team copy = this.defence;
    this.defence = this.hasBall;
    this.hasBall = copy;
  }

  void tipOff() {
    if (showGame) {
      GAbstractControl[] g = {speedSlider, speedLabel, showStatsButton};
      setVisControl(g, true); //sets buttons to visible
    }

    //resets the teams' scores
    this.team1.score = 0;
    this.team2.score = 0;

    //resets the players stats
    for (int i=0; i<team1.players.length; i++) {
      Player p = team1.players[i];
      p.points = 0;
      p.threes = 0;
      p.threesTotal = 0;
      p.twos = 0;
      p.twosTotal = 0;
      p.numSteals = 0;
      p.numBlocks = 0;
    }

    for (int i=0; i<team2.players.length; i++) {
      Player p = team2.players[i];
      p.points = 0;
      p.threes = 0;
      p.threesTotal = 0;
      p.twos = 0;
      p.twosTotal = 0;
      p.numSteals = 0;
      p.numBlocks = 0;
    }

    //determine which team's center wins the tipoff
    ArrayList<Boolean> prob = new ArrayList<Boolean>();

    for (float i=0; i<this.team1.players[4].tipOff; i+=0.01) {
      prob.add(true);
    }

    for (float i=0; i<this.team2.players[4].tipOff; i+=0.01) {
      prob.add(false);
    }

    //determines which team gets possession
    if (prob.get(round(random(prob.size()-1)))) {
      this.hasBall = team1;
      this.defence = team2;
    } else {
      this.hasBall = team2;
      this.defence = team1;
    }

    this.startGame = false;
  }

  void play() {
    ArrayList<String> prob = new ArrayList<String>();
    ArrayList<Player> players = new ArrayList<Player>();

    //for the offence
    for (int i=0; i<this.hasBall.players.length; i++) {
      for (float j=0; j<this.hasBall.players[i].twoPoint; j+=0.01) {
        prob.add("2");
        players.add(this.hasBall.players[i]);
      }

      for (float j=0; j<this.hasBall.players[i].threePoint; j+=0.01) {
        prob.add("3");
        players.add(this.hasBall.players[i]);
      }
    }

    //for the defence
    for (int i=0; i<this.defence.players.length; i++) {
      for (float j=0; j<this.defence.players[i].steal; j+=0.01) {
        prob.add("s");
        players.add(this.defence.players[i]);
      }

      for (float j=0; j<this.defence.players[i].block; j+=0.01) {
        prob.add("b");
        players.add(this.defence.players[i]);
      }
    }

    //index randomly chosen
    int choice = round(random(prob.size()-1));

    String event;
    fill(0);
    if (prob.get(choice).equals("3")) {
      if (random(1)<players.get(choice).threePoint) {//determines if the shot was scored or not
        event = players.get(choice).name+" scored a three pointer!";

        players.get(choice).points += 3;
        players.get(choice).threes++;
        this.hasBall.score += 3;
        this.hasBall.threes++;
      } else {
        event = players.get(choice).name+" attempted a three pointer and missed!";
      }

      players.get(choice).threesTotal++;
    } else if (prob.get(choice).equals("2")) {
      if (random(1)<players.get(choice).twoPoint) {
        event = players.get(choice).name+" scored a two pointer!";

        players.get(choice).points += 2;
        players.get(choice).twos++;
        this.hasBall.score += 2;
        this.hasBall.twos++;
      } else {
        event = players.get(choice).name+" attempted a two pointer and missed!";
      }

      players.get(choice).twosTotal++;
    } else if (prob.get(choice).equals("s")) {
      event = players.get(choice).name+" stole the ball!";

      players.get(choice).numSteals++;
    } else {
      event = players.get(choice).name+" blocked the ball!";

      players.get(choice).numBlocks++;
    }

    this.events.add(event);

    if (showGame&&!quickSim)
      this.printEvent();
  }

  String minTime(int s) { //helper method that converts a time in seconds to a time in minutes
    int m = s/60; //integer division
    int leftover = s - m*60;

    String mPart = "";
    if (m<10)
      mPart = "0"+str(m);
    else
      mPart = str(m);

    String sPart = "";
    if (leftover<10)
      sPart = "0"+str(leftover);
    else
      sPart = str(leftover);

    return mPart+":"+sPart;
  }

  void finish() {  
    speedSlider.setVisible(false);
    speedLabel.setVisible(false);
    showStatsButton.setVisible(true);

    //determines the winner and loser
    if (this.team1.score>this.team2.score) {
      this.winner = this.team1;
      this.loser = this.team2;
    } else {
      this.winner = this.team2;
      this.loser = this.team1;
    }

    this.winner.wins++;

    //checks if the series has been won
    if (winner.wins==gamesPerSeries/2+1) {
      series.winner = this.winner;
      series.over = true;

      if (loser.conf.equals("West"))
        west.remove(west.indexOf(loser));

      else
        east.remove(east.indexOf(loser));
    }

    pauseButton.setVisible(false);
    skipButton.setVisible(false);
    startButton.setText("Continue");
    startButton.setVisible(true);
  }

  //allows the game to go into overtime
  void overtime() {
    this.quarter++;
    this.overtime = true;
    this.timeLeft = round(60*(minsPerQuarter/2.0));
  }

  void endScreen() {
    fill(0);

    //displays the final time
    if (this.overtime) {
      if (this.quarter==5)
        text("OT - 00:00", width/2, 70);

      else
        text("OT"+(this.quarter-4)+" - 00:00", width/2, 70);
    } else {
      text("Q4 - 00:00", width/2, 70);
    }

    this.printScore();

    //difference is calculated and displayed
    int diff = this.winner.score-this.loser.score;
    String winText = "The "+this.winner.name+" won by "+diff;

    if (diff==1) {
      winText += " point!";
    } else {
      winText += " points!";
    }

    int y;

    if (showStats) //allows for space for the stats if they're being shown
      y = height/4+45;
    else
      y = height/2+65;

    text(winText, width/2, y);

    if (showStats) {
      startButton.setVisible(false);
    }
  }

  //prints the score, the series record, and the current round
  void printScore() {
    fill(0);
    text("Series: "+this.team1.wins+" - "+this.team2.wins, width/2, 110);

    textAlign(LEFT, CENTER);
    text(this.series.round, 30, 80);
    textAlign(CENTER, CENTER);

    int y1, y2;
    if (showStats) {
      y1 = height/4-15;
      y2 = height/4+15;
    } else {
      y1 = height/2-15;
      y2 = height/2+15;
    }
    text(this.team1.name, width/4, y1);
    text(this.team1.score, width/4, y2);
    text(this.team2.name, 3*width/4, y1);
    text(this.team2.score, 3*width/4, y2);
  }

  //displays the time
  void printTime() {
    if (this.overtime) {
      if (this.quarter==5) {
        text("OT"+" - "+this.minTime(this.timeLeft), width/2, 80);
      } else {
        int ot = this.quarter-4;
        text("OT"+ot+" - "+this.minTime(this.timeLeft), width/2, 80);
      }
    } else {
      text("Q"+this.quarter+" - "+this.minTime(this.timeLeft), width/2, 80);
    }
  }

  //displays the most recent event
  void printEvent() {
    if (this.events.size()!=0) {
      int y;
      if (showStats) //allows space for the stats if they're being displayed
        y = height/4+45;
      else
        y = height/2+50;

      text(this.events.get(this.events.size()-1), width/2, y);
    }
  }

  //shows the stats, based on which team is being shown
  void printStats() {
    textAlign(LEFT, CENTER);
    textFont(createFont("Arial", 15));
    int s = 100;
    int x1 = 245;
    int x2 = x1+s;
    int x3 = x2+s;
    int x4 = x3+s;
    Team t;
    if (showTeam1) {
      t = team1;
    } else {
      t= team2;
    }
    for (int i=0; i<t.players.length; i++) {
      Player p = t.players[i];
      int y = 280+i*50;
      text(p.name, 20, y);
      textAlign(CENTER, CENTER);
      text(p.points, x1, y);
      text(p.numSteals, x2, y);
      text(p.numBlocks, x3, y);
      text(p.threes+"/"+p.threesTotal, x4, y);
      textAlign(LEFT, CENTER);
    }
    textFont(createFont("Arial", 17));
    textAlign(LEFT, BOTTOM);
    text(t.name, 20, 243);
    textAlign(CENTER, CENTER);
    textFont(createFont("Arial", 20));
    text("Points", x1, 230);
    text("Steals", x2, 230);
    text("Blocks", x3, 230);  
    text("3 Pointers", x4, 230);
  }
}
