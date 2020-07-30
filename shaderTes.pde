
PShader shader;
float time = 0.0;
boolean save = false;

void setup(){
  
  size(1920, 1080, P3D);
  background(0);
 
  shader = loadShader("frag.glsl");
}

void draw(){
  background(0);
  shader.set("resolution", width, height);
  shader.set("time", time);
  shader(shader);
  rect(0, 0, width, height);
  time += 0.08;
  
  if (save){
    saveFrame("frames/fract-######.png");
  }
}

void keyPressed(){
  save = false;
}
