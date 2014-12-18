// Modifed twist shader from
// http://www.objc.io/issue-18/scenekit.html

// a function that creates a rotation transform matrix around X
mat4 rotationAroundX(float angle)
{
return mat4(1.0,    0.0,         0.0,        0.0,
            0.0,    cos(angle), -sin(angle), 0.0,
            0.0,    sin(angle),  cos(angle), 0.0,
            0.0,    0.0,         0.0,        1.0);
}

#pragma body

const float twistFactor = 1.0;
const float twistIntensity = 2.0;



float rotationAngle = _geometry.position.x * sin(u_time);
mat4 rotationMatrix = rotationAroundX(rotationAngle);

// position is a vec4
_geometry.position *= rotationMatrix;

// normal is a vec3
vec4 twistedNormal = vec4(_geometry.normal, 1.0) * rotationMatrix;
_geometry.normal   = twistedNormal.xyz;