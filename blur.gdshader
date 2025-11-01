shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D SCREEN_TEXTURE2: hint_screen_texture;
uniform float lod = 0.5;

vec4 v4lerp(vec4 a, vec4 b, float t)
{
    return a + t * (b - a);
}

void fragment(){
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, lod);
	vec4 color2 = texture(SCREEN_TEXTURE2, SCREEN_UV);

	COLOR = v4lerp(v4lerp(color * 2.0, color2 * 3.0, 0.7), vec4(0, 0, 0, 1), 0.62);
}
