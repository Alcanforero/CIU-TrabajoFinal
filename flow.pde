import java.io.*;

int state = 0;  // inicio = 0; jugando = 1; end = 2; saving = 3;
int puntuacion; // se sustituye por la puntuación del usuario
String name = "";

// Añadir puntos conseguidos al lado del mensaje de muerte

void setup() {
  size(800, 500);
  background(0);
  fill(255);
  textSize(20);
  
  try { new File(sketchPath("") + "/data/db_puntuacion.txt").createNewFile(); } catch (IOException ioe) { System.out.println(ioe); }  
  resetGame();
}

void resetGame() { 
  state = 0;
  name = "";  
}

void draw() {  
  switch (state) {
    case 0:  inicio(); break;
    case 1:  run();    break;
    default: end();
  }
}

void run() {
  // Sustituir este código con el desarrollado a parte......
  fill(100);
  background(255);
  text("Jugando", 350, 50);
  puntuacion = (int)random(100);
  
  /*
   *
   *
   *
   *
   *
   *
   */  
}

// Pegar aquí la imagen designada como fondo para el inicio
void inicio() {
  background(0);
}

// Imprime los mensajes del estado de muerte
void end() {
  background(0);
  
  fill(255);
  text("Has muerto.", 340, 90);  
  fill(100);
  text("Pulse ENTER para volver a jugar.", 250, 120);
  
  fill(100);
  stroke(255);
  rect(width/2-75, height/2+150, 150, 40);  
  fill(255);
  noStroke();
  text("GUARDAR", width/2-48, height/2+178);  
  
  if (state == 3) saving();
  else printTable();
}

// Imprime el cuadro de dialogo de guardado de partida
void saving() {
  text("Escribe tu nombre:", 310, height/2-40);  
  stroke(255);
  fill(100);
  rect(width/2-150,height/2-20,300,40);
  fill(255);
  text(name, width/2-140,height/2+8);
}

// Almacena la puntuación del cuadro de texto en el fichero de datos
void savelog() {
  if (name != "") {
    try {
      FileWriter fw = new FileWriter(new File(sketchPath("") + "/data/db_puntuacion.txt"), true);
      fw.write(name + "," + puntuacion + ";");
      fw.close();
    } catch (IOException ioe) {
      System.out.print(ioe);
    }
  }
  resetGame();
}

// Imprime la tabla de puntuaciones en el centro de la pantalla
void printTable() {
  try {
    String str;    
    BufferedReader br = new BufferedReader(new FileReader(new File(sketchPath("") + "/data/db_puntuacion.txt")));    
    if ((str = br.readLine()) != null) {
      String[][] auxArray = pickBests(str.split(";"));
      
      for (int i=0; i<auxArray.length; i++) {
        System.out.println(auxArray[i][0] + " - " + auxArray[i][1]);
      }
    }
    br.close();
  } catch (IOException ioe) {
    System.out.println(ioe);    
  }
}

// Toma un vector de strings con el formato "String + ',' + int"
// y devuelve un vector de cinco elementos con las cadenas que mayor
// componente int tengan.
String[][] pickBests(String[] str) {
  String[] strRanking = new String[str.length];
  int[] intRanking = new int[str.length];  
  for (int i = 0; i < str.length; i++) {
    strRanking[i] = str[i].split(",")[0];
    intRanking[i] = Integer.parseInt(str[i].split(",")[1]);
  }
  
  int intTemp;
  String strTemp;  
  for (int i = 1; i < str.length; i++) {
    for (int j = i; j > 0; j--) {
     if (intRanking[j] > intRanking[j-1]) {
      intTemp = intRanking[j];
      strTemp = strRanking[j];
      intRanking[j] = intRanking[j-1];
      strRanking[j] = strRanking[j-1];
      intRanking[j-1] = intTemp;
      strRanking[j-1] = strTemp;
     }
    }
  }
  
  String[][] ranking = new String[5][2];
  for (int i = 0; i < str.length && i<5; i++) {
    ranking[i][0] = strRanking[i];
    ranking[i][1] = Integer.toString(intRanking[i]);
  }
  
  return ranking;
}

void mouseClicked() {  
  if (state == 0) state = 1;
  
  if (state == 3) {
    if (mouseX >= width/2-75 && mouseX <= width/2+75) 
      if (mouseY >= height/2+150 && mouseY <= height/2+190)
        savelog();
  }
  if (state == 2) {
    if (mouseX >= width/2-75 && mouseX <= width/2+75) 
      if (mouseY >= height/2+150 && mouseY <= height/2+190)
        state = 3;
  }
}

void keyPressed() {
  if (state == 3) {
    if ((key >= 65 && key <= 90) || (key >= 97 && key <= 122))
      if (name.length() < 10) name += key;
  }
  switch (keyCode) {
    case DELETE: state = 2; break; // Borrar al añadir el resto del código.
    case ENTER: if(state > 1) savelog(); break;
    case 8: if(state == 3 && name.length() >= 1) name = name.substring(0,name.length()-1);
  }
}
