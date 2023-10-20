// https://www.shadertoy.com/view/mtyGWy

#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 resolution;
uniform float time;

out vec4 fragColor;

//https://iquilezles.org/articles/palettes/
vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263, 0.416, 0.557);

    return a + b*cos(6.28318*(c*t+d));
}

void main() {

    vec2 currentCoords = FlutterFragCoord();
    vec2 screenResolution = resolution;
    float time = time;

    vec2 uv = (currentCoords * 2.0 - screenResolution.xy) / screenResolution.y;
    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.0);

    for (float i = 0.0; i < 4.0; i++) {
        uv = fract(uv * 1.5) - 0.5;

        float d = length(uv) * exp(-length(uv0));

        vec3 col = palette(length(uv0) + i*.4 + time*.4);

        d = sin(d*8. + time)/8.;
        d = abs(d);

        d = pow(0.01 / d, 1.2);

        finalColor += col * d;
    }

    fragColor = vec4(finalColor, 1.0);
}