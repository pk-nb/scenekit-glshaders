vec3 lDir = normalize(vec3(0.1,1.0,1.0));
float dotProduct = dot(_surface.normal, _light.direction);

if (dotProduct >= 0.0) {
  _lightingContribution.diffuse += (dotProduct * dotProduct * _light.intensity.rgb);
  _lightingContribution.diffuse = floor(_lightingContribution.diffuse * 4.0) / 3.0;
}
