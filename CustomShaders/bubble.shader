const float normalScaling = 1.5;
const float timeScale = 3.0;

_geometry.position += vec4(_geometry.normal, 0.0) * sin(u_time * timeScale) * normalScaling;