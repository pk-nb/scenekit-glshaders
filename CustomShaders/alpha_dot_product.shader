#pragma transparent

_output.color.a = mix(_output.color.a, (0.8 - dot(_surface.view, _surface.normal)) * _output.color.a, 1.0);
