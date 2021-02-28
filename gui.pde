/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void startClicked(GButton source, GEvent event) { //_CODE_:startButton:265887:
  if(startButton.getText().equals("Continue")){ //finishing the current game
    gameRunning = false;
    startButton.setText("Next");
    quickSim = false;
    showStatsButton.setVisible(false);
    
    if(match!=playoffs.size()-1)//moves on the next game, if not at the end of the playoffs ArrayList
      match++;
      
    else{ //geneerates new rounds if at the end of the ArrayList
      if(west.size()==1&&east.size()==1){
        generateFinals();
      }else if(west.size()==0){
        champion = east.get(0);
        startButton.setVisible(false);
      }else if(east.size()==0){
        champion = west.get(0);
        startButton.setVisible(false);
      }else{
        generateRound();
      }
    }
  } else{ //starting a game
    gameRunning = true;
    
    if(showGame&&!quickSim){
      pauseButton.setVisible(true);
      skipButton.setVisible(true);
    }
      
    optionsWindow.setVisible(false);
    startButton.setVisible(false);

  }
  
} //_CODE_:startButton:265887:

public void skipClicked(GButton source, GEvent event) { //_CODE_:skipButton:752415:
  quickSim = true;
  showStats = false;
  paused = false;
  showStatsButton.setText("Show Stats");

  GAbstractControl[] g = {skipButton,pauseButton,speedSlider,speedLabel,showStatsButton,switchButton};
  setVisControl(g,false);
} //_CODE_:skipButton:752415:

public void quitButtonClicked(GButton source, GEvent event) { //_CODE_:quitButton:402600:
  exit();
} //_CODE_:quitButton:402600:

public void pauseButtonClicked(GButton source, GEvent event) { //_CODE_:pauseButton:379508:
  //changes the button's text appropriately
  if(!paused){
    pauseButton.setText("Resume");
  }
  else{
    pauseButton.setText("Pause");
  }
  paused = !paused;
} //_CODE_:pauseButton:379508:

public void speedChanged(GSlider source, GEvent event) { //_CODE_:speedSlider:749766:
  delay = 61-speedSlider.getValueI();
} //_CODE_:speedSlider:749766:

public void confirmButtonClicked(GButton source, GEvent event) { //_CODE_:confirmButton:299688:
  optionsWindow.setVisible(true);
  teamWindow.setVisible(false);
  choosingTeams = false;
  settingOptions = true;
  confirmButton.setVisible(false);
} //_CODE_:confirmButton:299688:

public void showStatsButtonClicked(GButton source, GEvent event) { //_CODE_:showStatsButton:656078:
  if(!showStats){
    showStats = true;
    showStatsButton.setText("Hide Stats");
    switchButton.setVisible(true);
    
  } else{
    showStats = false;
    showStatsButton.setText("Show Stats");
    switchButton.setVisible(false);
    
    if(playoffs.get(match).endGame){ //checks if at the end of the current game
      startButton.setVisible(true);
    }
  }
  
} //_CODE_:showStatsButton:656078:

public void switchButtonClicked(GButton source, GEvent event) { //_CODE_:switchButton:752407:
  showTeam1 = !showTeam1;
} //_CODE_:switchButton:752407:

synchronized public void optionsWindowDraw(PApplet appc, GWinData data) { //_CODE_:optionsWindow:952192:
  appc.background(255);

} //_CODE_:optionsWindow:952192:

public void doneClicked(GButton source, GEvent event) { //_CODE_:doneButton:971220:
  optionsWindow.setVisible(false);
  startButton.setVisible(true);
  generateRound();
  settingOptions = false;
  
} //_CODE_:doneButton:971220:

public void skipSimClicked(GOption source, GEvent event) { //_CODE_:skipSim:439698:
  showGame = false;
} //_CODE_:skipSim:439698:

public void watchSimClicked(GOption source, GEvent event) { //_CODE_:watchSim:844049:
  showGame = true;
} //_CODE_:watchSim:844049:

public void numGamesClicked(GDropList source, GEvent event) { //_CODE_:numGames:533332:
  gamesPerSeries = int(numGames.getSelectedText());
} //_CODE_:numGames:533332:

public void minsClicked(GDropList source, GEvent event) { //_CODE_:mins:863832:
  minsPerQuarter = int(mins.getSelectedText());
  
  for(int i=0;i<playoffs.size();i++){ //changes all the games' minsPerQuarter appropriately 
    playoffs.get(i).timeLeft = minsPerQuarter*60;
  }
} //_CODE_:mins:863832:

synchronized public void teamWindowDraw(PApplet appc, GWinData data) { //_CODE_:teamWindow:396557:
  appc.background(255);
  appc.fill(0);
  appc.textFont(createFont("Arial",40));
  appc.textAlign(CENTER,CENTER);
  appc.text("West",150,35);
  appc.text("East",450,35);
  appc.textFont(createFont("Arial",15));
  appc.text("In order of seeding, select the teams in each conference to participate in the playoffs",300,70);
  appc.line(300,95,300,550);
  appc.line(0,95,600,95);
} //_CODE_:teamWindow:396557:

public void s76ersClicked(GImageButton source, GEvent event) { //_CODE_:s76ers:740650:
  for(int i=0;i<teams.size();i++){ //searches for the appropriate team and adds it to the appropriate arrayLists
    if(teams.get(i).name.equals("Philadelphia 76ers")&&east.size()<8){
      teams.get(i).button = s76ers; //assigns this button to the team
      east.add(teams.get(i));
      history.add(teams.get(i));
      s76ers.setVisible(false);
    }
  }
  
} //_CODE_:s76ers:740650:

public void blazersClicked(GImageButton source, GEvent event) { //_CODE_:blazers:382300:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Portland Trail Blazers")&&west.size()<8){
      teams.get(i).button = blazers;
      west.add(teams.get(i));
      
      history.add(teams.get(i));
      blazers.setVisible(false);
    }
  }
  
} //_CODE_:blazers:382300:

public void bucksClicked(GImageButton source, GEvent event) { //_CODE_:bucks:775991:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Milwaukee Bucks")&&east.size()<8){
      teams.get(i).button = bucks;
      east.add(teams.get(i));
      
      history.add(teams.get(i));
      bucks.setVisible(false);
    }
  }
  
} //_CODE_:bucks:775991:

public void bullsClicked(GImageButton source, GEvent event) { //_CODE_:bulls:888522:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Chicago Bulls")&&east.size()<8){
      teams.get(i).button = bulls;
      east.add(teams.get(i));
      
      history.add(teams.get(i));
      bulls.setVisible(false);
    }
  }
  
} //_CODE_:bulls:888522:

public void cavsClicked(GImageButton source, GEvent event) { //_CODE_:cavs:860597:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Cleveland Cavaliers")&&east.size()<8){
      teams.get(i).button = cavs;
      east.add(teams.get(i));
      
      history.add(teams.get(i));
      cavs.setVisible(false);
    }
  }
  
} //_CODE_:cavs:860597:

public void celticsClicked(GImageButton source, GEvent event) { //_CODE_:celtics:893172:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Boston Celtics")&&east.size()<8){
      teams.get(i).button = celtics;
      east.add(teams.get(i));
      
      history.add(teams.get(i));
      celtics.setVisible(false);
    }
  }
  
} //_CODE_:celtics:893172:

public void clippersClicked(GImageButton source, GEvent event) { //_CODE_:clippers:663303:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Los Angeles Clippers")&&west.size()<8){
      teams.get(i).button = clippers;
      west.add(teams.get(i));
      
      history.add(teams.get(i));
      clippers.setVisible(false);
    }
  }
  
} //_CODE_:clippers:663303:

public void grizzliesClicked(GImageButton source, GEvent event) { //_CODE_:grizzlies:632283:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Memphis Grizzlies")&&west.size()<8){
      teams.get(i).button = grizzlies;
      west.add(teams.get(i));
      
      history.add(teams.get(i));
      grizzlies.setVisible(false);
    }
  }
  
} //_CODE_:grizzlies:632283:

public void hawksClicked(GImageButton source, GEvent event) { //_CODE_:hawks:724072:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Atlanta Hawks")&&east.size()<8){
      teams.get(i).button = hawks;
      east.add(teams.get(i));
      
      history.add(teams.get(i));
      hawks.setVisible(false);
    }
  }
  
} //_CODE_:hawks:724072:

public void heatClicked(GImageButton source, GEvent event) { //_CODE_:heat:917640:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Miami Heat")&&east.size()<8){
      teams.get(i).button = heat;
      east.add(teams.get(i));
      
      history.add(teams.get(i));
      heat.setVisible(false);
    }
  }
  
} //_CODE_:heat:917640:

public void hornetsClicked(GImageButton source, GEvent event) { //_CODE_:hornets:620355:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Charlotte Hornets")&&east.size()<8){
      teams.get(i).button = hornets;
      east.add(teams.get(i));
      
      history.add(teams.get(i));
      hornets.setVisible(false);
    }
  }
  
} //_CODE_:hornets:620355:

public void jazzClicked(GImageButton source, GEvent event) { //_CODE_:jazz:869765:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Utah Jazz")&&west.size()<8){
      teams.get(i).button = jazz;
      west.add(teams.get(i));
      
      history.add(teams.get(i));
      jazz.setVisible(false);
    }
  }
  
} //_CODE_:jazz:869765:

public void kingsClicked(GImageButton source, GEvent event) { //_CODE_:kings:860377:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Sacramento Kings")&&west.size()<8){
      teams.get(i).button = kings;
      west.add(teams.get(i));
      
      history.add(teams.get(i));
      kings.setVisible(false);
    }
  }
  
} //_CODE_:kings:860377:

public void knicksClicked(GImageButton source, GEvent event) { //_CODE_:knicks:244461:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("New York Knicks")&&east.size()<8){
      teams.get(i).button = knicks;
      east.add(teams.get(i));
      
      history.add(teams.get(i));
      knicks.setVisible(false);
    }
  }
  
} //_CODE_:knicks:244461:

public void lakersClicked(GImageButton source, GEvent event) { //_CODE_:lakers:342871:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Los Angeles Lakers")&&west.size()<8){
      teams.get(i).button = lakers;
      west.add(teams.get(i));
      
      history.add(teams.get(i));
      lakers.setVisible(false);
    }
  }
  
} //_CODE_:lakers:342871:

public void magicClicked(GImageButton source, GEvent event) { //_CODE_:magic:885944:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Orlando Magic")&&east.size()<8){
      teams.get(i).button = magic;
      east.add(teams.get(i));
      
      history.add(teams.get(i));
      magic.setVisible(false);
    }
  }
  
} //_CODE_:magic:885944:

public void mavsClicked(GImageButton source, GEvent event) { //_CODE_:mavs:901150:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Dallas Mavericks")&&west.size()<8){
      teams.get(i).button = mavs;
      west.add(teams.get(i));
      
      history.add(teams.get(i));
      mavs.setVisible(false);
    }
  }
  
} //_CODE_:mavs:901150:

public void netsClicked(GImageButton source, GEvent event) { //_CODE_:nets:995268:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Brooklyn Nets")&&east.size()<8){
      teams.get(i).button = nets;
      east.add(teams.get(i));
      
      history.add(teams.get(i));
      nets.setVisible(false);
    }
  }
  
} //_CODE_:nets:995268:

public void nuggetsClicked(GImageButton source, GEvent event) { //_CODE_:nuggets:327481:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Denver Nuggets")&&west.size()<8){
      teams.get(i).button = nuggets;
      west.add(teams.get(i));
      
      history.add(teams.get(i));
      nuggets.setVisible(false);
    }
  }
  
} //_CODE_:nuggets:327481:

public void pacersClicked(GImageButton source, GEvent event) { //_CODE_:pacers:584538:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Indiana Pacers")&&east.size()<8){
      teams.get(i).button = pacers;
      east.add(teams.get(i));
      
      history.add(teams.get(i));
      pacers.setVisible(false);
    }
  }
  
} //_CODE_:pacers:584538:

public void pelicansClicked(GImageButton source, GEvent event) { //_CODE_:pelicans:488330:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("New Orleans Pelicans")&&west.size()<8){
      teams.get(i).button = pelicans;
      west.add(teams.get(i));
      
      history.add(teams.get(i));
      pelicans.setVisible(false);
    }
  }
  
} //_CODE_:pelicans:488330:

public void pistonsClicked(GImageButton source, GEvent event) { //_CODE_:pistons:807209:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Detroit Pistons")&&east.size()<8){
      teams.get(i).button = pistons;
      east.add(teams.get(i));
      
      history.add(teams.get(i));
      pistons.setVisible(false);
    }
  }
  
} //_CODE_:pistons:807209:

public void raptorsClicked(GImageButton source, GEvent event) { //_CODE_:raptors:433545:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Toronto Raptors")&&east.size()<8){
      teams.get(i).button = raptors;
      east.add(teams.get(i));
      
      history.add(teams.get(i));
      raptors.setVisible(false);
    }
  }
  
} //_CODE_:raptors:433545:

public void rocketsClicked(GImageButton source, GEvent event) { //_CODE_:rockets:821087:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Houston Rockets")&&west.size()<8){
      teams.get(i).button = rockets;
      west.add(teams.get(i));
      
      history.add(teams.get(i));
      rockets.setVisible(false);
    }
  }
  
} //_CODE_:rockets:821087:

public void spursClicked(GImageButton source, GEvent event) { //_CODE_:spurs:959564:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("San Antonio Spurs")&&west.size()<8){
      teams.get(i).button = spurs;
      west.add(teams.get(i));
      
      history.add(teams.get(i));
      spurs.setVisible(false);
    }
  }
  
} //_CODE_:spurs:959564:

public void sunsClicked(GImageButton source, GEvent event) { //_CODE_:suns:506486:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Phoenix Suns")&&west.size()<8){
      teams.get(i).button = suns;
      west.add(teams.get(i));
      
      history.add(teams.get(i));
      suns.setVisible(false);
    }
  }
  
} //_CODE_:suns:506486:

public void thunderClicked(GImageButton source, GEvent event) { //_CODE_:thunder:836051:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Oklahoma City Thunder")&&west.size()<8){
      teams.get(i).button = thunder;
      west.add(teams.get(i));
      
      history.add(teams.get(i));
      thunder.setVisible(false);
    }
  }
  
} //_CODE_:thunder:836051:

public void wolvesClicked(GImageButton source, GEvent event) { //_CODE_:wolves:534167:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Minnesota Timberwolves")&&west.size()<8){
      teams.get(i).button = wolves;
      west.add(teams.get(i));
      
      history.add(teams.get(i));
      wolves.setVisible(false);
    }
  }
  
} //_CODE_:wolves:534167:

public void warriorsClicked(GImageButton source, GEvent event) { //_CODE_:warriors:673483:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Golden State Warriors")&&west.size()<8){
      teams.get(i).button = warriors;
      west.add(teams.get(i));
      
      history.add(teams.get(i));
      warriors.setVisible(false);
    }
  }
  
} //_CODE_:warriors:673483:

public void wizardsClicked(GImageButton source, GEvent event) { //_CODE_:wizards:897457:
  for(int i=0;i<teams.size();i++){
    if(teams.get(i).name.equals("Washington Wizards")&&east.size()<8){
      teams.get(i).button = wizards;
      east.add(teams.get(i));
      
      history.add(teams.get(i));
      wizards.setVisible(false);
    }
  }
  
} //_CODE_:wizards:897457:

public void undoButtonClicked(GButton source, GEvent event) { //_CODE_:undoButton:631146:
  if(history.get(history.size()-1).conf.equals("West")){ //checks if the most recent selection was east or west
    west.remove(west.size()-1); //removes it from that conference's array
  } else{
    east.remove(east.size()-1);
  }
  history.get(history.size()-1).button.setVisible(true); //sets the button visible again
  history.remove(history.size()-1); //removes it from the history
  
} //_CODE_:undoButton:631146:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  startButton = new GButton(this, 250, 400, 100, 50);
  startButton.setText("Start simulation");
  startButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  startButton.addEventHandler(this, "startClicked");
  skipButton = new GButton(this, 200, 10, 80, 30);
  skipButton.setText("Skip to end");
  skipButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  skipButton.addEventHandler(this, "skipClicked");
  quitButton = new GButton(this, 440, 10, 80, 30);
  quitButton.setText("Quit");
  quitButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  quitButton.addEventHandler(this, "quitButtonClicked");
  pauseButton = new GButton(this, 80, 10, 80, 30);
  pauseButton.setText("Pause");
  pauseButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  pauseButton.addEventHandler(this, "pauseButtonClicked");
  speedSlider = new GSlider(this, 250, 550, 100, 40, 10.0);
  speedSlider.setLimits(30, 10, 50);
  speedSlider.setNumberFormat(G4P.INTEGER, 0);
  speedSlider.setLocalColorScheme(GCScheme.RED_SCHEME);
  speedSlider.setOpaque(false);
  speedSlider.addEventHandler(this, "speedChanged");
  confirmButton = new GButton(this, 260, 90, 80, 30);
  confirmButton.setText("Confirm Teams");
  confirmButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  confirmButton.addEventHandler(this, "confirmButtonClicked");
  showStatsButton = new GButton(this, 320, 10, 80, 30);
  showStatsButton.setText("Show Stats");
  showStatsButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  showStatsButton.addEventHandler(this, "showStatsButtonClicked");
  speedLabel = new GLabel(this, 250, 530, 100, 20);
  speedLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  speedLabel.setText("Simulation Speed");
  speedLabel.setLocalColorScheme(GCScheme.RED_SCHEME);
  speedLabel.setOpaque(false);
  switchButton = new GButton(this, 510, 560, 80, 30);
  switchButton.setText("Switch Team");
  switchButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  switchButton.addEventHandler(this, "switchButtonClicked");
  optionsWindow = GWindow.getWindow(this, "Options ", 200, 0, 400, 250, JAVA2D);
  optionsWindow.noLoop();
  optionsWindow.setActionOnClose(G4P.CLOSE_WINDOW);
  optionsWindow.addDrawHandler(this, "optionsWindowDraw");
  doneButton = new GButton(optionsWindow, 160, 185, 80, 30);
  doneButton.setText("Done");
  doneButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  doneButton.addEventHandler(this, "doneClicked");
  togGroup1 = new GToggleGroup();
  skipSim = new GOption(optionsWindow, 275, 130, 120, 25);
  skipSim.setText("Skip Simulations");
  skipSim.setLocalColorScheme(GCScheme.RED_SCHEME);
  skipSim.setOpaque(false);
  skipSim.addEventHandler(this, "skipSimClicked");
  watchSim = new GOption(optionsWindow, 275, 80, 120, 25);
  watchSim.setText("Watch Simulations");
  watchSim.setLocalColorScheme(GCScheme.RED_SCHEME);
  watchSim.setOpaque(false);
  watchSim.addEventHandler(this, "watchSimClicked");
  togGroup1.addControl(skipSim);
  togGroup1.addControl(watchSim);
  watchSim.setSelected(true);
  numGames = new GDropList(optionsWindow, 20, 110, 100, 100, 4, 20);
  numGames.setItems(loadStrings("list_533332"), 0);
  numGames.setLocalColorScheme(GCScheme.RED_SCHEME);
  numGames.addEventHandler(this, "numGamesClicked");
  mins = new GDropList(optionsWindow, 145, 110, 100, 100, 4, 20);
  mins.setItems(loadStrings("list_863832"), 0);
  mins.setLocalColorScheme(GCScheme.RED_SCHEME);
  mins.addEventHandler(this, "minsClicked");
  label1 = new GLabel(optionsWindow, 20, 60, 100, 30);
  label1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label1.setText("Games Per Series");
  label1.setOpaque(false);
  label2 = new GLabel(optionsWindow, 145, 60, 100, 30);
  label2.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label2.setText("Minutes Per Quarter");
  label2.setOpaque(false);
  label3 = new GLabel(optionsWindow, 275, 35, 120, 41);
  label3.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label3.setText("Watch or quickly simulate games?");
  label3.setOpaque(false);
  teamWindow = GWindow.getWindow(this, "Select Teams", 1200, 0, 600, 550, JAVA2D);
  teamWindow.noLoop();
  teamWindow.setActionOnClose(G4P.CLOSE_WINDOW);
  teamWindow.addDrawHandler(this, "teamWindowDraw");
  s76ers = new GImageButton(teamWindow, 420, 460, 80, 80, new String[] { "76ers.png", "76ers.png", "76ers.png" } );
  s76ers.addEventHandler(this, "s76ersClicked");
  blazers = new GImageButton(teamWindow, 10, 100, 80, 80, new String[] { "Blazers.png", "Blazers.png", "Blazers.png" } );
  blazers.addEventHandler(this, "blazersClicked");
  bucks = new GImageButton(teamWindow, 330, 100, 80, 80, new String[] { "Bucks.png", "Bucks.png", "Bucks.png" } );
  bucks.addEventHandler(this, "bucksClicked");
  bulls = new GImageButton(teamWindow, 425, 290, 70, 70, new String[] { "Bulls.png", "Bulls.png", "Bulls.png" } );
  bulls.addEventHandler(this, "bullsClicked");
  cavs = new GImageButton(teamWindow, 420, 115, 80, 50, new String[] { "Cavaliers.png", "Cavaliers.png", "Cavaliers.png" } );
  cavs.addEventHandler(this, "cavsClicked");
  celtics = new GImageButton(teamWindow, 510, 100, 80, 80, new String[] { "Celtics.png", "Celtics.png", "Celtics.png" } );
  celtics.addEventHandler(this, "celticsClicked");
  clippers = new GImageButton(teamWindow, 10, 200, 80, 60, new String[] { "Clippers.png", "Clippers.png", "Clippers.png" } );
  clippers.addEventHandler(this, "clippersClicked");
  grizzlies = new GImageButton(teamWindow, 100, 200, 80, 80, new String[] { "Grizzlies.png", "Grizzlies.png", "Grizzlies.png" } );
  grizzlies.addEventHandler(this, "grizzliesClicked");
  hawks = new GImageButton(teamWindow, 330, 190, 80, 80, new String[] { "Hawks.png", "Hawks.png", "Hawks.png" } );
  hawks.addEventHandler(this, "hawksClicked");
  heat = new GImageButton(teamWindow, 380, 170, 160, 120, new String[] { "Heat.png", "Heat.png", "Heat.png" } );
  heat.addEventHandler(this, "heatClicked");
  hornets = new GImageButton(teamWindow, 505, 185, 90, 90, new String[] { "Hornets.png", "Hornets.png", "Hornets.png" } );
  hornets.addEventHandler(this, "hornetsClicked");
  jazz = new GImageButton(teamWindow, 100, 110, 80, 60, new String[] { "Jazz.png", "Jazz.png", "Jazz.png" } );
  jazz.addEventHandler(this, "jazzClicked");
  kings = new GImageButton(teamWindow, 10, 280, 80, 80, new String[] { "Kings.png", "Kings.png", "Kings.png" } );
  kings.addEventHandler(this, "kingsClicked");
  knicks = new GImageButton(teamWindow, 500, 360, 100, 100, new String[] { "Knicks.png", "Knicks.png", "Knicks.png" } );
  knicks.addEventHandler(this, "knicksClicked");
  lakers = new GImageButton(teamWindow, 190, 205, 80, 50, new String[] { "Lakers.png", "Lakers.png", "Lakers.png" } );
  lakers.addEventHandler(this, "lakersClicked");
  magic = new GImageButton(teamWindow, 330, 290, 80, 60, new String[] { "Magic.png", "Magic.png", "Magic.png" } );
  magic.addEventHandler(this, "magicClicked");
  mavs = new GImageButton(teamWindow, 100, 370, 80, 80, new String[] { "Mavericks.png", "Mavericks.png", "Mavericks.png" } );
  mavs.addEventHandler(this, "mavsClicked");
  nets = new GImageButton(teamWindow, 510, 280, 80, 80, new String[] { "Nets.png", "Nets.png", "Nets.png" } );
  nets.addEventHandler(this, "netsClicked");
  nuggets = new GImageButton(teamWindow, 10, 380, 80, 60, new String[] { "Nuggets.png", "Nuggets.png", "Nuggets.png" } );
  nuggets.addEventHandler(this, "nuggetsClicked");
  pacers = new GImageButton(teamWindow, 330, 460, 80, 80, new String[] { "Pacers.png", "Pacers.png", "Pacers.png" } );
  pacers.addEventHandler(this, "pacersClicked");
  pelicans = new GImageButton(teamWindow, 190, 380, 80, 60, new String[] { "Pelicans.png", "Pelicans.png", "Pelicans.png" } );
  pelicans.addEventHandler(this, "pelicansClicked");
  pistons = new GImageButton(teamWindow, 330, 380, 80, 60, new String[] { "Pistons.png", "Pistons.png", "Pistons.png" } );
  pistons.addEventHandler(this, "pistonsClicked");
  raptors = new GImageButton(teamWindow, 420, 370, 80, 80, new String[] { "Raptors.png", "Raptors.png", "Raptors.png" } );
  raptors.addEventHandler(this, "raptorsClicked");
  rockets = new GImageButton(teamWindow, 100, 290, 80, 60, new String[] { "Rockets.png", "Rockets.png", "Rockets.png" } );
  rockets.addEventHandler(this, "rocketsClicked");
  spurs = new GImageButton(teamWindow, 10, 470, 80, 60, new String[] { "Spurs.png", "Spurs.png", "Spurs.png" } );
  spurs.addEventHandler(this, "spursClicked");
  suns = new GImageButton(teamWindow, 105, 465, 70, 70, new String[] { "Suns.png", "Suns.png", "Suns.png" } );
  suns.addEventHandler(this, "sunsClicked");
  thunder = new GImageButton(teamWindow, 190, 460, 80, 80, new String[] { "Thunder.png", "Thunder.png", "Thunder.png" } );
  thunder.addEventHandler(this, "thunderClicked");
  wolves = new GImageButton(teamWindow, 190, 105, 80, 70, new String[] { "Timberwolves.png", "Timberwolves.png", "Timberwolves.png" } );
  wolves.addEventHandler(this, "wolvesClicked");
  warriors = new GImageButton(teamWindow, 195, 280, 70, 80, new String[] { "Warriors.png", "Warriors.png", "Warriors.png" } );
  warriors.addEventHandler(this, "warriorsClicked");
  wizards = new GImageButton(teamWindow, 510, 460, 80, 80, new String[] { "Wizards.png", "Wizards.png", "Wizards.png" } );
  wizards.addEventHandler(this, "wizardsClicked");
  undoButton = new GButton(teamWindow, 260, 25, 80, 30);
  undoButton.setText("Undo Selection");
  undoButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  undoButton.addEventHandler(this, "undoButtonClicked");
  optionsWindow.loop();
  teamWindow.loop();
}

// Variable declarations 
// autogenerated do not edit
GButton startButton; 
GButton skipButton; 
GButton quitButton; 
GButton pauseButton; 
GSlider speedSlider; 
GButton confirmButton; 
GButton showStatsButton; 
GLabel speedLabel; 
GButton switchButton; 
GWindow optionsWindow;
GButton doneButton; 
GToggleGroup togGroup1; 
GOption skipSim; 
GOption watchSim; 
GDropList numGames; 
GDropList mins; 
GLabel label1; 
GLabel label2; 
GLabel label3; 
GWindow teamWindow;
GImageButton s76ers; 
GImageButton blazers; 
GImageButton bucks; 
GImageButton bulls; 
GImageButton cavs; 
GImageButton celtics; 
GImageButton clippers; 
GImageButton grizzlies; 
GImageButton hawks; 
GImageButton heat; 
GImageButton hornets; 
GImageButton jazz; 
GImageButton kings; 
GImageButton knicks; 
GImageButton lakers; 
GImageButton magic; 
GImageButton mavs; 
GImageButton nets; 
GImageButton nuggets; 
GImageButton pacers; 
GImageButton pelicans; 
GImageButton pistons; 
GImageButton raptors; 
GImageButton rockets; 
GImageButton spurs; 
GImageButton suns; 
GImageButton thunder; 
GImageButton wolves; 
GImageButton warriors; 
GImageButton wizards; 
GButton undoButton; 
