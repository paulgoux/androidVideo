

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER;

uniform sampler2D texture;
uniform float type;
uniform int Mode;
uniform float thresh2;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform vec2 resolution;

float abs(float a,float b){
	float c = 0.0;
	if(a <b)c = b-a;
	else c = a - b;
	return c;
}

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

void main(void) {

  float resX = 1.0 / resolution.x;
  float resY = 1.0 / resolution.y;
	
	float ypos = vertTexCoord.y;
	float xpos = vertTexCoord.x;
	
  vec4 mCol = texture2D( texture, vec2( xpos, ypos ) );
	
  float ucount = 1.0-mCol.r;
	float dcount = 1.0-mCol.g;
  float lcount = 1.0-mCol.b;
	float rcount = 1.0-mCol.a;
	
	//if(ucount<1.0||dcount<1.0||lcount<1.0||rcount<1.0){
	if(ucount>0.0||dcount>0.0||lcount>0.0||rcount>0.0){
		float hmax = 0.0;
		if(ucount>dcount)hmax = ucount;
		else hmax = dcount;
		
		float vmax = 0.0;
		if(lcount>rcount)vmax = lcount;
		else vmax = rcount;
		
		float avmax = (ucount + dcount)/2.0;
		float ahmax = (rcount + lcount)/2.0;
		
		bool k = false;
		bool k1 = false;
		bool k2 = false;
		bool k3 = false;
		bool k4 = false;
		bool k5 = false;
		
				for (float i=xpos-resX; i<=xpos+resX; i++) {
					for (float j=ypos-resY; j<=ypos+resY; j++) {
						
						if (j>=0&&j<resolution.y&&i>=0&&i<resolution.x) {
						
							vec4 nCol = texture2D( texture, vec2( xpos+resX*i, ypos+resY*j) );
							
							if (i!=xpos&&j!=ypos) {
							
							float ucount1 = 1.0-nCol.r;
							float dcount1 = 1.0-nCol.g;
							float lcount1 = 1.0-nCol.b;
							float rcount1 = 1.0-nCol.a;
							
							float hmax1 = 0.0;
							if(ucount1>dcount1)hmax1 = ucount1;
							else hmax1 = dcount1;
							
							float vmax1 = 0.0;
							if(lcount1>rcount1)vmax1 = lcount1;
							else vmax1 = rcount1;
							
							float avmax1 = (ucount1+dcount1)/2;
							float ahmax1 = (lcount1+rcount1)/2;
							
								if(Mode ==0){
									if(ypos==j){
										if(ahmax1==ahmax)k = true;
										}
									if(xpos==i){
										if(avmax1==avmax)k1 = true;
									}
								}
								if(Mode==1){
									if(ypos==j){
										 if(hmax1==hmax)k1 = true;
										}
									if(xpos==i){
										if(vmax1==vmax)k1 = true;
									}
								}
								
								if(Mode ==2){
									if(ypos==j){
										if(lcount1<lcount)k2 = true;
										if(rcount1>mCol.a)k3 = true;
										}
									if(xpos==i){
										if(ucount1<ucount)k4 = true;
										if(dcount1<dcount)k5 = true;
									}
								}
								if(Mode ==3){
									if(ypos==j){
										if(lcount1<lcount)k2 = true;
										if(rcount1>rcount)k3 = true;
										}
									if(xpos==i){
										if(ucount1>ucount)k4 = true;
										if(dcount1<dcount)k5 = true;
									}
								}
								if(Mode ==4){
									if(ypos==j){
										if(lcount1<lcount)k2 = true;
										if(rcount1<rcount)k3 = true;
										}
									if(xpos==i){
										if(ucount1<ucount)k4 = true;
										if(dcount1<dcount)k5 = true;
									}
								}
								
								if(Mode==5){
									if(ypos==j){
										 if(lcount1<rcount)k1 = true;
										 if(hmax1!=hmax)k2 = true;
										}
									if(xpos==i){
										if(dcount1<ucount)k3 = true;
										if(vmax1!=vmax)k4 = true;
									}
								}
								
								if(Mode==6){
									if(ypos==j){
										 if(lcount1<rcount)k1 = true;
										 if(ahmax1==ahmax)k2 = true;
										}
									if(xpos==i){
										if(dcount1<ucount)k3 = true;
										if(avmax1==avmax)k4 = true;
									}
								}
							}
						} 
					}
				}
				
				if(Mode==0&&(!k||!k1)){
					gl_FragColor = vec4(0.0,0.0,0.0,1.0);
				}
				if(Mode==1&&((k1))){
					gl_FragColor = vec4(0.0,0.0,0.0,1.0);
					
				}
				if(Mode==2&&((!k2||!k3)||(!k4||!k5))){
					gl_FragColor = vec4(0.0,0.0,0.0,1.0);
					
				}
				if(Mode==3&&((!k2||!k3)||(!k4||!k5))){
					gl_FragColor = vec4(0.0,0.0,0.0,1.0);
					
				}
				if(Mode==4&&((!k2||!k3)||(!k4||!k5))){
					gl_FragColor = vec4(0.0,0.0,0.0,1.0);
					
				}
				if(Mode==5&&((!k1||!k2)||((!k3||!k4)))){
					gl_FragColor = vec4(0.0,0.0,0.0,1.0);
					
				}
				if(Mode==6&&((!k1&&k2)||(!k3&&k4))){
					gl_FragColor = vec4(0.0,0.0,0.0,1.0);
					
				}
		
	}
	else{
		gl_FragColor = vec4(1.0,1.0,1.0,1.0);
	}
};
