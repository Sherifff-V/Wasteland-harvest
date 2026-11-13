shader_type canvas_item;

uniform vec4 dirt_color_a : source_color = vec4(0.6, 0.5, 0.2, 1.0);
uniform vec4 dirt_color_b : source_color = vec4(0.45, 0.38, 0.15, 1.0);
uniform float tolerance : hint_range(0.0, 0.3) = 0.05;

void fragment() {
    vec4 c = texture(TEXTURE, UV);
    if (distance(c.rgb, dirt_color_a.rgb) < tolerance
     || distance(c.rgb, dirt_color_b.rgb) < tolerance) {
        c.a = 0.0;
    }
    COLOR = c;
}