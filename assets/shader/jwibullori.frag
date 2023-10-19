// Fork of "Jwibullori" by catking562. https://shadertoy.com/view/cs3fzl
// 2023-10-19 13:50:10

#version 460 core
#include <flutter/runtime_effect.glsl>

#define PI  3.14159265359

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

out vec4 fragColor;

vec4 lerp(vec4 a, vec4 b, float t) {
    return (a * vec4(t)) + (b * vec4(1.0-t));
}
vec4 lerp(vec4 a, vec4 b, vec4 t) {
    return (a * t) + (b * (vec4(1.0) * t));
}

vec4 hue2rgb(float hue) {
    hue = fract(hue);//only use fractional part of hue, making it loop
    float r = abs(hue * 6.0 - 3.0) - 1.0;//red
    float g = 2.0 - abs(hue * 6.0 - 2.0);//green
    float b = 2.0 - abs(hue * 6.0 - 4.0);//blue
    vec4 rgb = vec4(r, g, b, 1.0);//combine components
    rgb = clamp(rgb, 0.0, 1.0);//clamp between 0 and 1
    return rgb;
}
vec4 hsv2rgb(vec3 hsv) {
    vec4 rgb = hue2rgb(hsv.x);//apply hue
    rgb = lerp(vec4(1.0), rgb, 1.0 - hsv.y);//apply saturation
    rgb = rgb * hsv.z;//apply value
    return rgb;
}


void main(){
    vec2 fragCoord = FlutterFragCoord();
    vec2 iResolution = resolution;
    float iTime = time;
    vec2 iMouse = mouse.xy;

    //float size = 0.02;
    float sx = iResolution.x;
    float sy = iResolution.y;
    float s = sqrt(sx*sx+sy*sy);
    vec2 uv = fragCoord/iResolution.xy - vec2(0.5, 0.5);
    float j = 0.0;
    //while(size>=0.001) {
    for (float size=0.02;size>=0.001;size-=0.0001) {
        float x = (cos(iTime*5.0+size*150.0)*s/10.0)/sx;
        float y = (sin(iTime*5.0+size*150.0)*s/10.0)/sy;
        float dx = uv.x-x;
        float dy = uv.y-y;
        float k = sqrt(dx*dx+dy*dy);
        j += (size/k)/100.0;
        //size-=0.0001;
    }

    float red = cos(PI*(j-1.0/3.0)*3.0/2.0);

    if (iMouse.xy == vec2(0.)) {
        float green = cos(PI*(j-2.0/3.0)*3.0/2.0);
        float blue = cos(PI*(j-1.0)*3.0/2.0);
        fragColor = vec4(red, green, blue, 1);
    } else {
        vec2 mouseUV = iMouse.xy / iResolution.xy;
        vec4 mouseColor = hsv2rgb(vec3(mouseUV.x, mouseUV.y, 1.0));

        //#define SINGLECOLOR
        #ifdef SINGLECOLOR
        float green=red, blue=red;
        #else
        float green = cos(PI*(j-(2.0*mouseUV.y)/3.0)*3.0/2.0);
        float blue = cos(PI*(j-(1.0*mouseUV.x))*3.0/2.0);
        #endif
        fragColor = vec4(red, green, blue, 1.) * mouseColor;
    }
}