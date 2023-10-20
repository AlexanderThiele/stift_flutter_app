// Copyright 2023 Alexander Thiele. All rights reserved.
// Use of this source code is governed by a BSD-style license

#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform float speed;

out vec4 fragColor;


vec3 palette(float t){
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263, 0.416, 0.557);

    return a+b*cos(6.28318*(c*t+d));
}

void main(){
    vec2 currentCoords = FlutterFragCoord();
    vec2 mouseCoords = mouse.xy;
    vec2 screenResolution = resolution;
    float time = time;

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (currentCoords / screenResolution.xy - 0.5)*2.0;
    vec2 m  = (mouseCoords / screenResolution - 0.5)*2.0;

    // set the center to mouse cords
    uv.xy -= m.xy;

    // this will respect the screen sizes
    uv.x *= screenResolution.x/screenResolution.y;

    float d = length(uv) - 0.13;

    vec3 color = palette(d+time);
    float alpha = 1.0;
    if (d > 0.0){
        alpha = d-0.1;
        d = sin(d*12.0 + time * speed)/12.0;
    } else {
        alpha = 0.0;
    }

    d = abs(d);
    d=0.04/d;

    color *= d;

    // Output to screen
    fragColor = vec4(color, alpha);
}