shader_type spatial;

uniform sampler2D depth_texture : hint_depth_texture;

void fragment()
{
	ALBEDO = texture(depth_texture, UV.xy).xyz;
	ALPHA = texture(depth_texture, UV.xy).w;
}