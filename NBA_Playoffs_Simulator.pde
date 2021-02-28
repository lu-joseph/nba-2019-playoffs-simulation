import g4p_controls.*;
import java.awt.Font;

int gamesPerSeries = 7;
int minsPerQuarter = 12;
int delay = 20;
int match = 0;

boolean gameRunning = false;
boolean paused = false;
boolean showGame = true;
boolean quickSim = false;
boolean choosingTeams = true;
boolean settingOptions = false;
boolean showStats = false;
boolean showTeam1 = true;

Table players;

ArrayList<Game> playoffs = new ArrayList<Game>();
ArrayList<Team> teams = new ArrayList<Team>();
ArrayList<Team> west = new ArrayList<Team>();
ArrayList<Team> east = new ArrayList<Team>();
ArrayList<Team> history = new ArrayList<Team>();

Team champion;

PFont myFont;

void setup() {
  size(600, 600);
  background(255);
  createGUI();
  
  //sets these buttons to invisible
  GAbstractControl[] g = {pauseButton,skipButton,speedSlider,speedLabel,confirmButton,showStatsButton,startButton,undoButton,switchButton};
  setVisControl(g,false);
  
  optionsWindow.setVisible(false);
  
  //sets up font settings
  textAlign(CENTER,CENTER);
  myFont = createFont("Arial",20);
  textFont(myFont);
  
  //loads in the players from the table
  players = loadTable("s1.csv","header");

  for(int i=0;i<players.getRowCount();i+=5){
    TableRow row0 = players.getRow(i);
    TableRow row1 = players.getRow(i+1);
    TableRow row2 = players.getRow(i+2);
    TableRow row3 = players.getRow(i+3);
    TableRow row4 = players.getRow(i+4);
    
    Player[] temp = {new Player(row0.getString("Name"),row0.getFloat("3pt"),row0.getFloat("2pt"),row0.getFloat("Steal"),row0.getFloat("Block"),row0.getFloat("Tipoff")),
                     new Player(row1.getString("Name"),row1.getFloat("3pt"),row1.getFloat("2pt"),row1.getFloat("Steal"),row1.getFloat("Block"),row1.getFloat("Tipoff")),
                     new Player(row2.getString("Name"),row2.getFloat("3pt"),row2.getFloat("2pt"),row2.getFloat("Steal"),row2.getFloat("Block"),row2.getFloat("Tipoff")),
                     new Player(row3.getString("Name"),row3.getFloat("3pt"),row3.getFloat("2pt"),row3.getFloat("Steal"),row3.getFloat("Block"),row3.getFloat("Tipoff")),
                     new Player(row4.getString("Name"),row4.getFloat("3pt"),row4.getFloat("2pt"),row4.getFloat("Steal"),row4.getFloat("Block"),row4.getFloat("Tipoff"))};
    
    //takes 5 players and creates a team, adding it to the teams ArrayList
    teams.add(new Team(temp,players.getRow(i).getString("Team"),players.getRow(i).getString("Conference")));   
  }  
}

void draw(){
  background(255);
  fill(100);
  rect(0,0,width,50);
  
  if(choosingTeams){
    fill(0);
    
    //print headers
    textFont(createFont("Arial",40));
    textAlign(CENTER,CENTER);
    text("West",150,100);
    text("East",450,100);
    
    //print team names
    textAlign(LEFT,CENTER);
    textFont(createFont("Arial",20));
    int y1 = 200;
    for(int i=0;i<west.size();i++){
      text(i+1+". "+west.get(i).name,50,y1);
      y1+=50;
    }
    
    int y2 = 200;
    for(int i=0;i<east.size();i++){
      text(i+1+". "+east.get(i).name,350,y2);
      y2+=50;
    }
    
    //print instructions text
    textAlign(CENTER,CENTER);
    if(west.size()==0&&east.size()==0){
      text("In the other window, pick the 8 teams from",width/2,height/2-15);
      text("each conference participating in the playoffs.",width/2,height/2+15);
      
    } else{
      line(width/2,150,width/2,height);
      line(0,150,width,150);
    }
    
    //undo button is invisible if the user has no selections made
    undoButton.setVisible(west.size()>0||east.size()>0);
    
    //if the user is done selecting teams, then the confirm button appears
    if(west.size()==8&&east.size()==8){
      confirmButton.setVisible(true);
    }
    
  }else if (settingOptions){
    //print instructions text
    fill(0);
    text("Choose the playoff settings in the other window.",width/2,height/2-15);   
    
  }else if (gameRunning) { //game section
    Game current = playoffs.get(match);
    
    if(!paused){
      
      if(current.startGame){ //starts the game
        current.tipOff();
        
      } else if(current.endGame){ //what happens at the end of the game
        current.endScreen();
        
      } else{ //main part of the game
        if(showGame&&!quickSim){ //watchable game
          if(frameCount%delay==0){ //each update to the game happens here
            current.play();
            current.printScore();
            current.switchPossession();
            current.updateTime();
            
          } else{ //happens between updates to the game
            //the same score and time, as well as the most recent event are repeatedly drawn to screen
            current.printScore();
            current.printTime();
            current.printEvent();
          }
        } else{//this happens if the game is being skipped
          showStatsButton.setVisible(false);
          current.play();
          current.switchPossession();
          current.updateTime();
          text("Simulating...",width/2,height/2);
        } 
      }
    } else{ //when the game is paused
      //simulation just prints the current score and time, nothing is updated
      current.printScore();
      current.printTime();
      current.printEvent();
    }
    
    if(showStats){
      current.printStats();
    }
    
  } else if(west.size()==0||east.size()==0){ //the last team has been eliminated
    fill(0);
    if(west.size()==0) //if the western team was eliminated, then the eastern team is the champion, and vice versa
      champion = east.get(0);
    else
      champion = west.get(0);
    
    showStatsButton.setVisible(false);
    text("The NBA Champions are the "+champion.name+"!",width/2,height/2);
  
  }else{ //between games
    if(match<playoffs.size()-1){
      while(playoffs.get(match).series.over){ //if one team has already won enough games in the series, then the rest of the planned games will be skipped
        match++;
      }
    }
    
    Game next = playoffs.get(match);
    
    //prints the next matchup to the screen
    fill(0);
    text("Next matchup: "+next.team1.name+" vs. "+next.team2.name,width/2,height/2);
    text("Series: "+next.team1.wins+" - "+next.team2.wins,width/2,80);
  }
}

void generateRound(){
  match = 0; //reset match number to 0
  
  //reset all the teams wins to 0 for the next round
  for(int i=0;i<west.size();i++){
    west.get(i).wins = 0;
  }
  for(int i=0;i<west.size();i++){
    east.get(i).wins = 0;
  }
  
  //checks how many teams are left in west (east would be the same at this point), and then uses the number of remaining players to determine which round of the playoffs it currently is
  int r; //round number
  switch(west.size()){
    case 8:
      r = 1;
      break;
    case 4:
      r = 2;
      break;
    default: //this would be 2 teams left
      r = 3;
      break;
  }
  
  //create all the series in the current round
  ArrayList<Series> currentRound = new ArrayList<Series>();
  for(int i=0;i<west.size()/2;i++){
    Series temp = new Series(west.get(i),west.get(west.size()-1-i),gamesPerSeries,r);
    currentRound.add(temp);
  }

  for(int i=0;i<east.size()/2;i++){
    Series temp = new Series(east.get(i),east.get(east.size()-1-i),gamesPerSeries,r);
    currentRound.add(temp);
  }
  
  //add all these games into the playoffs arraylist of games
  for(int i=0;i<currentRound.size();i++){
    for(int j=0;j<currentRound.get(i).games.size();j++){
      playoffs.add(currentRound.get(i).games.get(j));
    }
  }
}

//separate function for generating the finals series because it's between an eastern and a western team
void generateFinals(){
  //reset the two finalists wins to 0
  west.get(0).wins = 0;
  east.get(0).wins = 0;
  
  //adds the finals series games to the playoffs arraylist of games
  Series finals = new Series(west.get(0),east.get(0),gamesPerSeries,4);
  
  for(int i=0;i<finals.games.size();i++){
    playoffs.add(finals.games.get(i));
  }
}

//helper function to set multiple controls visiblity settings at once
void setVisControl(GAbstractControl[] g,boolean b){
  for(int i=0;i<g.length;i++){
    g[i].setVisible(b);
  }
}
