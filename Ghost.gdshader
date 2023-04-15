shader_type canvas_item;

uniform float flash : hint_range(0.0, 1.0, 0.1);
uniform vec4 flashColor : source_color ;


void fragment() {
	vec4 spriteColor = texture(TEXTURE, UV);
	COLOR = mix(spriteColor, flashColor, flash);
	COLOR.a *= spriteColor.a * flash;
}
