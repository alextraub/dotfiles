// Cursor that grows out from its vertical center to full height, then shrinks
// back to the center, on a smooth cosine (ease-in-out) loop. The pulse restarts
// at full height whenever the cursor moves, so it is easy to find while typing.

const float PERIOD = 1.0;     // seconds for one shrink + grow cycle
const float MIN_SCALE = 0.0;  // height at the smallest point (0 = vanishes)

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 term = texture(iChannel0, uv);
    fragColor = term;

    if (iCursorVisible.x < 0.5) return;

    // iCurrentCursor.xy is the top-left corner (y grows upward), .zw the size.
    vec2 size = iCurrentCursor.zw;
    vec2 center = iCurrentCursor.xy + vec2(0.5, -0.5) * size;

    float t = iTime - iTimeCursorChange;
    float wave = 0.5 + 0.5 * cos(6.28318530718 * t / PERIOD); // 1 -> 0 -> 1
    float scale = mix(MIN_SCALE, 1.0, wave);

    vec2 d = abs(fragCoord - center);
    vec2 halfSize = vec2(0.5 * size.x, 0.5 * size.y * scale);
    // 1px anti-aliased edge on top and bottom so the motion stays smooth.
    float inside = step(d.x, halfSize.x) * clamp(halfSize.y - d.y + 0.5, 0.0, 1.0);
    if (inside <= 0.0) return;

    // Keep the glyph under the cursor readable: pixels that differ from the
    // background are text and get drawn in the background color, like a
    // normal block cursor.
    float textness = smoothstep(0.08, 0.35, distance(term.rgb, iBackgroundColor * term.a));
    vec3 cursor = mix(iCurrentCursorColor.rgb, iBackgroundColor, textness);
    fragColor = vec4(mix(term.rgb, cursor, inside), max(term.a, inside));
}
