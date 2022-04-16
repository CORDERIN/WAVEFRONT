import java.util.LinkedList;
 
final int N = 50;
final int ESPACO_VAZIO = -1;
final int ROBO = -2;
final int DESTINO = -3;
final int OBSTACULO = 0;
final int QUANTIDADE_DE_OBSTACULOS = 500;
final int PESO_INICIAL = 1;
final int PERCORRIDO = -4;
  
float contador = 1;
boolean CAMINHO_INVALIDO = false;
int pos = 0;
int[] ESPACO_DESTINO;
int[] ESPACO_ROBO;
int[][] matriz = new int [N][N];
LinkedList<int[]> menorcaminho = new LinkedList<int[]>();

PImage obstaculo;
PImage robo;
PImage destino;
PImage sem_caminho;

void setup(){
 
  size(800, 800);
  thread("Executa");
  obstaculo = loadImage("obstaculo.png");
  robo = loadImage("robo.png");
  destino = loadImage("destino.png");
  sem_caminho = loadImage("sem_caminho.png");
}

void Executa(){
 
  CriaMapa();
  Wavefront();
  Simulacao();
  
 }

void draw(){
   
  float l = width/N;
  float h = height/N;
  
  background(210);  
  
  for(int i = 0; i < N; i++){
   for(int j = 0; j < N; j ++){
     
     float y = h * i;
     float x = l * j;
    
    if(matriz[i][j] == OBSTACULO){
    
    fill(255);
    image(obstaculo, x, y, l, h);
      
    }else if (matriz[i][j] == ESPACO_VAZIO){
    
    fill(256);
    rect(x, y, l, h);
  
   }else if (matriz[i][j] == ROBO) {
    
   fill(#03FF1D);
   image(robo, x, y, l, h);
    
   }else if(matriz[i][j] == PERCORRIDO){
     
   fill (#53FAEB);
   rect(x, y, l, h); 
   
   }else if(matriz[i][j] == DESTINO) {
     
    fill (#525ED6);
    image(destino, x, y, l, h);
     
   } else{
    
    fill(1 - matriz[i][j]*8);
    rect(x, y, l, h);
    textAlign(CENTER, CENTER);
    fill(0);
    text(String.format("%d", matriz[i][j]), x + l/2, y + h/2); 
    
   }
   
   if(pos == 10){
     
   fill(#03FF1D);
   image(sem_caminho, l, h);
   
   }
     
   }
    
  }
  
}

void CriaMapa(){
 
 for(int i = 0; i < N; i++){
  
   for(int j = 0; j < N; j++){
    
     matriz[i][j] = ESPACO_VAZIO;
     
   }
   
 }
 
 for (int a = 0; a < QUANTIDADE_DE_OBSTACULOS; a++){  
   
 int linha = (int)random(N);
 int coluna = (int)random(N);
 if(matriz[linha][coluna] == OBSTACULO) a--;
 else matriz[linha][coluna] = OBSTACULO;
  
 }
 
 boolean continua = false;
 
 do{
   
 int linha = (int)random(N);
 int coluna = (int)random(N);
 
 if(matriz[linha][coluna] == OBSTACULO) continua = true;
 
 else{  
 matriz[linha][coluna] = ROBO;
 ESPACO_ROBO = new int[]{linha, coluna};
 continua = false;
 
 }
 
 }while (continua == true);
 
 
 do{
   
 int linha = (int)random(N);
 int coluna = (int)random(N);
 
 if(matriz[linha][coluna] != ESPACO_VAZIO) continua = true;
 
 else{
  matriz[linha][coluna] = DESTINO;
  ESPACO_DESTINO = new int[]{linha, coluna};
  continua = false;

 }
 
 }while (continua == true);

}

void inserir_coordenadas_adjacentes(LinkedList<int[]>fila, int[] atual, int peso){
   
   delay((int)(1000/contador));
   fila.add(new int [] {atual[0] + 1, atual[1], peso});
   fila.add(new int [] {atual[0] - 1, atual[1], peso});
   fila.add(new int [] {atual[0], atual[1] + 1, peso});
   fila.add(new int [] {atual[0], atual[1] - 1, peso});

}

void Busca_em_largura (){
  
  LinkedList<int[]> fila_adjacentes = new LinkedList<int[]>();
  int posicao_destino[] = ESPACO_DESTINO;
  
  delay(20);
  fila_adjacentes.add(new int [] {posicao_destino[0] + 1, posicao_destino[1], PESO_INICIAL});
  fila_adjacentes.add(new int [] {posicao_destino[0] - 1, posicao_destino[1], PESO_INICIAL});
  fila_adjacentes.add(new int [] {posicao_destino[0], posicao_destino[1] + 1, PESO_INICIAL});
  fila_adjacentes.add(new int [] {posicao_destino[0], posicao_destino[1] - 1, PESO_INICIAL});
  
  boolean continua = true;
  
  while (fila_adjacentes.size() != 0 && continua){
    
  contador = contador + 0.04;
    
  int atual[] = fila_adjacentes.removeFirst();
  
  if(atual[0] < N && atual[0] >= 0 && atual[1] < N && atual[1] >= 0 ){
  
    if(matriz[atual[0]][atual[1]] == ROBO) continua = false; 
  
    else if(matriz[atual[0]][atual[1]] == ESPACO_VAZIO) {
          
    matriz[atual[0]][atual[1]] = atual[2];

    inserir_coordenadas_adjacentes(fila_adjacentes, atual, atual[2] + 1);
    
    }
  
   }
  
  }
  
}

 void Wavefront(){
   
  Busca_em_largura();
    
  LinkedList<int[]> lista_adjacentes = new LinkedList<int[]>();
  boolean continua = true;
  
  int[]origem = ESPACO_ROBO;
  int menor = 1000000000;
  int[] m_caminho = null;
  
  menorcaminho.add(origem);
  
  lista_adjacentes.add(new int [] {origem[0] + 1, origem[1]});
  lista_adjacentes.add(new int [] {origem[0] - 1, origem[1]});
  lista_adjacentes.add(new int [] {origem[0], origem[1] + 1});
  lista_adjacentes.add(new int [] {origem[0], origem[1] - 1});

  int index = matriz[origem[0]][origem[1]];
  
  while(index != DESTINO){
    
    while(lista_adjacentes.size() != 0 && continua){
      
     int atual[] = lista_adjacentes.removeFirst();
     
     if(atual[0] < N && atual[0] >= 0 && atual[1] < N && atual[1] >= 0 && matriz[atual[0]][atual[1]] != OBSTACULO && matriz[atual[0]][atual[1]] != ESPACO_VAZIO && matriz[atual[0]][atual[1]] != ROBO){
       
       if(matriz[atual[0]][atual[1]] == DESTINO){
         
         index = DESTINO;
         m_caminho = atual;
         continua = false;
         
       }else if(matriz[atual[0]][atual[1]] < menor){
        
         menor = matriz[atual[0]][atual[1]];
         m_caminho = atual;
         index = menor;
         
       }
     }
   }
   
  if(m_caminho != null){
    
   lista_adjacentes.add(new int [] {m_caminho[0] + 1, m_caminho[1]});
   lista_adjacentes.add(new int [] {m_caminho[0] - 1, m_caminho[1]});
   lista_adjacentes.add(new int [] {m_caminho[0], m_caminho[1] + 1});
   lista_adjacentes.add(new int [] {m_caminho[0], m_caminho[1] - 1});
   
   menorcaminho.add(m_caminho);
   
  }else {
       
   CAMINHO_INVALIDO = true;
   return;   
   
  }
    
  }
  
   return;
   
 }
 
 void completa_com_caminho(){
 
    if(CAMINHO_INVALIDO){
     
      delay(1000);
      pos = 10;
      println("IXII!! Não achou caminho"); 

    }else{
    
    int[] antigo = ESPACO_ROBO;
    
    while(menorcaminho.size()!= 0){
      
     int[]atual = menorcaminho.removeFirst();
     
      delay(250);
      matriz[antigo[0]][antigo[1]] = PERCORRIDO;
      matriz[atual[0]][atual[1]] = ROBO;
      antigo = atual;
   }
   
  }
 }
 
 void Simulacao(){
  
   delay(200);
   completa_com_caminho();
   
 
 }
 
