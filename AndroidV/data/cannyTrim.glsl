

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER;

uniform sampler2D texture;
uniform float type;
uniform float thresh;
uniform float thresh2;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform vec2 resolution;

float abs(float a,float b){
	float c = 0.0;
	if(a<b)c = b-a;
	else   c = a-b;
	return c;
}

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

void main(void) {

  float x = 1.0 / resolution.x;
  float y = 1.0 / resolution.y;
	//float type = 1.0;
  float q = 1.0;
  float r = 1.0;
  vec4 p1 = vec4( 0.0 );
  vec4 p2 = vec4( 0.0 );
  float m = 2.0;
	float n = 1.0;
  vec4 mCol = texture2D( texture, vec2( vertTexCoord.x, vertTexCoord.y ) );
	float x1 = mCol.r;
	float y1 = mCol.g;
  float myCol = mCol.b;
	
	
	float stepSize = 0.0;
	if(resolution.x>resolution.y)stepSize = x;
	else stepSize = y;
	float uCount = 0.0+stepSize;
	float dCount = 0.0+stepSize;
	float lCount = 0.0+stepSize;
	float rCount = 0.0+stepSize;
	
	if(mCol.r<thresh){
		 if(type==1.0){
			
			//up
			for(float i=0;i<vertTexCoord.y;i++){
				p1 = texture2D( texture, vec2( vertTexCoord.x, vertTexCoord.y - y * i));
				if(vertTexCoord.y - y * i<0||abs(mCol.r,p1.r)>thresh2){
					break;
				}else uCount += stepSize;
			}
			// down
			for(float i=0.0;i<resolution.y - vertTexCoord.y;i++){
				p1 = texture2D( texture, vec2( vertTexCoord.x, vertTexCoord.y + y * i));
				if(vertTexCoord.y + y * i>resolution.y||abs(mCol.r,p1.r)>thresh2){
					break;
				}else dCount += stepSize;
			}
			//left
			for(float i=0.0;i<vertTexCoord.x;i++){
				p1 = texture2D( texture, vec2( vertTexCoord.x - x * i, vertTexCoord.y));
				if(vertTexCoord.x - x * i<0||abs(mCol.r,p1.r)>thresh2){
					break;
				}else lCount += stepSize;
			}
			//right
			for(float i=0.0;i<resolution.x - vertTexCoord.y;i++){
				p1 = texture2D( texture, vec2( vertTexCoord.x + x * i, vertTexCoord.y));
				if(vertTexCoord.x + x * i>resolution.x||abs(mCol.r,p1.r)>thresh2){
					break;
				}else rCount += stepSize;
			}
			
			
			
			gl_FragColor = vec4(1.0-uCount,1.0-dCount,1.0-lCount,1.0-rCount);
			//gl_FragColor = vec4(uCount,0.0,0.0,0.0);
			
		}
	
	}else{
			gl_FragColor = vec4(1.0,1.0,1.0,1.0);
		}
	
	
	
};
