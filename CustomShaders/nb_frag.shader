#pragma transparent

const float fragIntensity = 1.0;
const float circlePixSize = 5.0;
const float speed = 2.0;


// Circle variable
float circleSize = ( (1 + sin(u_time * speed))

float videoShadow = 1.0;
float y = gl_FragCoord.y + u_time * 100.0;

if (fract(y * 0.06) > 0.5) {
videoShadow = 0.0;//0.3 + 0.2 * sin(u_time * 0.0);
}


_output.color.rgba = mix(_output.color.rgba, videoShadow * _output.color.rgba, fragIntensity);
