// ----------------------------------------------------------------------------
// Author: Inigo Quilez (The Book of Shaders)
// A quick hash – maps 2D → pseudo-random float [0,1]
// ----------------------------------------------------------------------------
float hash21(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

// A smooth 2D noise
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    // four corners
    float a = hash21(i + vec2(0.0,0.0));
    float b = hash21(i + vec2(1.0,0.0));
    float c = hash21(i + vec2(0.0,1.0));
    float d = hash21(i + vec2(1.0,1.0));
    // smoothstep for interpolation weights
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) 
         + (c - a)* u.y * (1.0 - u.x)
         + (d - b)* u.x * u.y;
}


void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // normalize coords
    vec2 uv = fragCoord.xy / iResolution.xy;
    float aspect = iResolution.x / iResolution.y;

    // center (click‐stick)
    vec2 center = (iMouse.z>0.0) 
        ? iMouse.xy / iResolution.xy 
        : vec2(0.5);

    // corrected distance
    vec2 pos = uv - center;
    pos.x *= aspect;
    float dist= length(pos);

    // grain overlay: sample noise at high freq
    float grain = noise(uv *  iResolution.xy * 0.5) * 0.05;

    float halfThick = 0.01;

    // —— Ring 1 w/ noise-distorted radius —— 
    float noise1 = noise(uv * 3.0 + iTime * 0.5) * 0.02;
    float radius1 = 0.25 + noise1 + 0.05 * sin(iTime * 1.0);
    float inner1  = smoothstep(radius1 - halfThick, radius1, dist);
    float outer1 = smoothstep(radius1, radius1 + halfThick, dist);
    float ring1 = inner1 - outer1;
    vec3 color1   = vec3(1.0, 0.4, 0.1) * ring1;

    // —— Ring 2 w/ noise —— 
    float noise2 = noise(uv * 4.0 - iTime * 0.7) * 0.015;
    float radius2 = 0.40 + noise2 + 0.05 * sin(iTime * 1.5 + 1.0);
    float inner2  = smoothstep(radius2 - halfThick, radius2, dist);
    float outer2 = smoothstep(radius2, radius2 + halfThick, dist);
    float ring2 = inner2 - outer2;
    vec3 color2   = vec3(0.2, 0.6, 1.0) * ring2;

    // —— Ring 3 w/ noise —— 
    float noise3 = noise(uv * 5.0 + iTime * 1.3) * 0.01;
    float radius3 = 0.55 + noise3 + 0.05 * sin(iTime * 2.0 + 2.5);
    float inner3  = smoothstep(radius3 - halfThick, radius3, dist);
    float outer3 = smoothstep(radius3, radius3 + halfThick, dist);
    float ring3 = inner3 - outer3;
    vec3 color3   = vec3(1.0, 0.2, 0.7) * ring3;

    // composite + background + grain
    vec3 bg    = vec3(0.05);
    vec3 color = bg + color1 + color2 + color3 + grain;

    fragColor = vec4(color, 1.0);
}
