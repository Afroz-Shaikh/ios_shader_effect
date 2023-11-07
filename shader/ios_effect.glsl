#version 320 es

precision highp float;
uniform float iTime;
uniform vec2 iResolution;
uniform sampler2D iChannel0;

const float PI = 6.28318530718;
const float DYNAMIC_OFFSET_Y = 0.46;
const float MOD_TIME_LIMIT = 3.0;
const float EXPLOSION_LIGHT_INTENSITY = 0.19;
const float EXPLOSION_LIGHT_2_INTENSITY = 0.14;
const float EXPLOSION_LIGHT_SHIFT = 8.0;
const float EXPLOSION_LIGHT_2_SHIFT = 8.0;
const float EXPLOSION_LIGHT_Y_OFFSET = 0.4;
const float EXPLOSION_LIGHT_2_Y_OFFSET = 0.4;
// was 90
const float NUM_DIRS = 20.0;
//12
const float QUALITY = 9.0;
const float BLUR_RAD_MULTIPLIER = 0.4;
const float BLUR_RAD_LIGHT_MULTIPLIER = 0.04;
const float GLOW_1_INTENSITY = 0.25;
const float GLOW_2_INTENSITY = 0.5;

out vec4 fragColor;




vec4 mainImage(in vec2 fragCoord) {
    float limitedTime = mod(iTime, MOD_TIME_LIMIT);
    float timeSq = limitedTime * limitedTime;
    float timeCu = limitedTime * timeSq;

    vec2 normalizedUv = fragCoord / iResolution.xy;
    vec2 distortedUv = vec2(
        normalizedUv.x + (normalizedUv.x - 0.5) * pow(normalizedUv.y, 6.0) * timeCu * 0.1,
        (normalizedUv.y * (normalizedUv.y * pow((1.0 - timeSq * 0.01), 8.0)) + (1.0 - normalizedUv.y) * normalizedUv.y
        )
    );
    distortedUv = mix(normalizedUv, distortedUv, smoothstep(1.1, 1.0, limitedTime));

    vec4 color = texture(iChannel0, distortedUv);
    vec2 explosionShift = vec2(0.0);
    float explosionLight = 0.0;

    if (limitedTime >= 1.0) {
        float adjustedTime = limitedTime - 1.0;
        normalizedUv -= 0.5;
        normalizedUv.x *= iResolution.x / iResolution.y;
        normalizedUv.x -= 0.1;

        vec2 uvExplode = vec2(normalizedUv.x + 0.1, normalizedUv.y + DYNAMIC_OFFSET_Y);
        explosionLight = (adjustedTime * EXPLOSION_LIGHT_INTENSITY) / length(uvExplode);
        explosionLight = smoothstep(0.09, 0.05, explosionLight) *
        smoothstep(0.04, 0.07, explosionLight) *
        (normalizedUv.y + 0.05);
        explosionShift = vec2(-EXPLOSION_LIGHT_SHIFT * explosionLight * normalizedUv.x,
                              -4.0 * explosionLight * (normalizedUv.y - EXPLOSION_LIGHT_Y_OFFSET)) * 0.1;

        float explosionLight2 = ((adjustedTime - 0.085) * EXPLOSION_LIGHT_2_INTENSITY) / length(uvExplode);
        explosionLight2 = smoothstep(0.09, 0.05, explosionLight2) *
        smoothstep(0.04, 0.07, explosionLight2) *
        (normalizedUv.y + 0.05);
        explosionShift += vec2(-EXPLOSION_LIGHT_2_SHIFT * explosionLight2 * normalizedUv.x,
                               -4.0 * explosionLight2 * (normalizedUv.y - EXPLOSION_LIGHT_2_Y_OFFSET)) * -0.02;
    }

    vec2 finalUv = distortedUv + explosionShift;
    color = texture(iChannel0, finalUv);
    color += explosionLight * 500.0 * smoothstep(1.05, 1.1, limitedTime);

    float blurRad = timeSq * 0.1 * pow(normalizedUv.y, 6.0) * BLUR_RAD_MULTIPLIER;
    blurRad *= smoothstep(1.3, 0.9, limitedTime);
    blurRad += explosionLight * BLUR_RAD_LIGHT_MULTIPLIER;

    for (float angle = 0.0; angle < PI; angle += PI / NUM_DIRS) {
        for (float i = 1.0 / QUALITY; i <= 1.0; i += 1.0 / QUALITY) {
            vec2 blurPosition = finalUv + vec2(cos(angle), sin(angle)) * blurRad * i;
            color += texture(iChannel0, blurPosition);
        }
    }
    color /= QUALITY * NUM_DIRS;

    fragColor = color;

    return fragColor;
}
void main() {
    vec2 pos = gl_FragCoord.xy;
    vec4 color = mainImage(pos); // Call mainImage to get the color
    fragColor = color; // Set the built-in gl_FragColor
}