// TODO invert so it does outline? Might have to use a geometry shader for this

const float PIover2 = (3.14159265358979 / 2.0);
const float lineTolerance = 1.0;

float dotProduct = dot(_surface.view, _surface.normal);

if ( (PIover2 + lineTolerance) > dotProduct && dotProduct > (PIover2 - lineTolerance) ) {
  _output.color.rgba = vec4(0.0, 0.0, 0.0, 1.0);
}

