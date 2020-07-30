#version 330

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif


uniform vec2 resolution;
uniform float time;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;

//Mandelbulb distance estimation function;
//Check http://blog.hvidtfeldts.net/index.php/2011/06/distance-estimated-3d-fractals-part-i/ for a nice introduction to 3D fractals; 

float DE(vec3 pos) {
	vec3 z = pos;
	float dr = 1.0;
	float r = 0.0;
	for (int i = 0; i < 100 ; i++) {
		r = length(z);
		if (r>1.5) break;
		float Power = mod(0.1 * time, 8.0) + 1.1;
		// convert to polar coordinates
		float theta = acos(z.z/r);
		float phi = atan(z.y,z.x);
		dr =  pow( r, Power-1.0)*Power*dr + 1.0;
		
		// scale and rotate the point
		float zr = pow( r,Power);
		theta = theta*Power;
		phi = phi*Power;
		
		// convert back to cartesian coordinates
		z = zr*vec3(sin(theta)*cos(phi), sin(phi)*sin(theta), cos(theta));
		z+=pos;
	}
	return 0.5*log(r)*r/dr;
}

//Helper function, useful with more objects

float map_the_world(vec3 p)
{   
    float fracta =  DE(p);
    return fracta;
}

//Simple raymarcher;

vec3 trace(vec3 from, vec3 direction) {
	float totalDistance = 0.0;
	const int max_steps = 128;
    int stps;
    vec3 p;
	float col;
	for (int steps= 0; steps < max_steps; steps++) {
		 p = from + totalDistance * direction;
		float dist = DE(p);
		totalDistance += dist;
		if (dist < 0.0002) {
		break;
		}
		stps = steps;
	}
	
	return vec3(1.0 - float(stps)/float(max_steps)) * vec3(1.0, 1.0, 0.8);
	//return vec3(col);
}

void main() {
  
  //Center coordinates and take into account the resolution;
  
  vec2 pos = gl_FragCoord.xy/resolution;
  float scl = resolution.x/resolution.y;
  pos.x *= scl;
  pos = (pos - vec2(0.5 * scl, 0.5))/0.5; 
  
    
	// Set up ray origin and destination;
	
    vec3 camera_pos = vec3(0.2, 0.2, -2.0 + 0.016 * time);
    vec3 ro = camera_pos;
    vec3 rd = normalize(vec3(pos.x, pos.y, 1.5));
 

    vec3 color = trace(ro, rd) * vec3(0.9, 0.9, 1.0);

	gl_FragColor = vec4(color, 1.0);
}