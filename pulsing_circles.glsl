void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    
    // shift origin from bottome left corner to center
    uv -= .5;
    // fix for screens where x > y
    uv.x *= iResolution.x/iResolution.y;
    
    vec2 center = vec2(0.0, 0.0);
    float d = length(uv);
    
    // Animate center radius
    float speed = 3.0; // pulses per second
    float baseRadius = 0.5 + 0.1 * sin(iTime * speed); // varies 0.2 to 0.4
    
    float halfThick = 0.02;
    
    float inner = smoothstep(baseRadius - halfThick, baseRadius, d);
    float outer = smoothstep(baseRadius, baseRadius + halfThick, d);
    
    float ring = inner - outer;
    
    
    float speed2 = 1.0;
    float baseRadius2 = 0.5 + 0.1 * sin(iTime * speed2); // varies 0.2 to 0.4
    
    float halfThick2 = 0.02;
    
    float inner2 = smoothstep(baseRadius2 - halfThick2, baseRadius2, d);
    float outer2 = smoothstep(baseRadius2, baseRadius2 + halfThick2, d);
    
    float ring2 = inner2 - outer2;
    
    vec3 col1 = vec3(1.0, 0.3, 0.2) * ring; // orange-ish
    vec3 col2 = vec3(0.2, 0.6, 1.0) * ring2; // light blue
    
    vec3 bg = vec3(0.05);
    
    vec3 final = bg + col1 + col2;

     fragColor = vec4(final, 1.0);
}