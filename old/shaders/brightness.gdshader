shader_type canvas_item;
render_mode blend_mix,unshaded;

uniform sampler2D warm_color;
uniform sampler2D cool_color;
uniform float temperature = 0;

uniform float brightness : hint_range(-1, 1) = 0;
uniform float contrast : hint_range(0, 3) = 1.0;
uniform float saturation : hint_range(0, 3) = 1.0;

uniform float redVal : hint_range(0, 1) = 1.0;
uniform float greenVal : hint_range(0, 1) = 1.0;
uniform float blueVal : hint_range(0, 1) = 1.0;

uniform vec4 tint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float tint_effect_factor : hint_range(0, 1) = 0.0;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

//---------------------------------------------
//CONTRAST
//---------------------------------------------
mat4 contrastMatrix( float _contrast ){
	float t = ( 1.0 - _contrast ) / 2.0;
    return mat4(
		vec4(_contrast, 0, 0, 0),
		vec4(0, _contrast, 0, 0),
		vec4(0, 0, _contrast, 0),
		vec4(t, t, t, 1));
}
//---------------------------------------------
//BRIGHTNESS
//---------------------------------------------
mat4 brightnessMatrix( float _brightness ){
    return mat4( vec4(1, 0, 0, 0),
                 vec4(0, 1, 0, 0),
                 vec4(0, 0, 1, 0),
                 vec4(_brightness, _brightness, _brightness, 1));
}
//---------------------------------------------
//SATURATION
//---------------------------------------------
mat4 saturationMatrix( float _saturation ){
    vec3 luminance = vec3( 0.3086, 0.6094, 0.0820 );
    float oneMinusSat = 1.0 - _saturation;

    vec3 red = vec3( luminance.x * oneMinusSat );
    red+= vec3(_saturation, 0, 0)*redVal;
    vec3 green = vec3( luminance.y * oneMinusSat );
    green += vec3( 0,_saturation, 0 )*greenVal;
    vec3 blue = vec3( luminance.z * oneMinusSat );
    blue += vec3( 0, 0,_saturation )*blueVal;

    return mat4(vec4(red, 0),vec4(green,0),vec4(blue,0),vec4(0, 0, 0, 1));
}


vec3 warmShader(vec4 input_color){

	float grayscale_value = dot(input_color.rgb, vec3(0.299, 0.587, 0.114));
	vec3 sampled_color;
	if (temperature > 0.0){
		sampled_color = texture(warm_color, vec2(grayscale_value, 0.0)).rgb;
		return mix(input_color.rgb, sampled_color, temperature);
	}

	sampled_color = texture(cool_color, vec2(grayscale_value, 0.0)).rgb;
	return mix(input_color.rgb, sampled_color, temperature * -1.0);

}

//---------------------------------------------
// fragment
//---------------------------------------------
void fragment() {

	vec4 screen = texture(screen_texture, SCREEN_UV);
	vec3 warm = warmShader(screen);
	vec4 warm_screen = vec4(warm.r, warm.g, warm.b,0);

	vec4 screen_delta = screen * tint_color;
	COLOR = brightnessMatrix( brightness ) * contrastMatrix( contrast ) * saturationMatrix( saturation ) * mix(warm_screen, screen_delta, tint_effect_factor);
	COLOR.a = screen.a;
}