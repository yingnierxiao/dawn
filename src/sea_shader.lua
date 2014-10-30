local shader = require "ejoy2d.shader"

local M = {}

local vs = [[
attribute vec4 position;
attribute vec2 texcoord;
attribute vec4 color;

varying vec2 v_texcoord;
varying vec4 v_color;

void main() {
	gl_Position = position + vec4(-1,1,0,0);
	v_texcoord = texcoord;
	v_color = color;
}
]]


local sea_fs = [[
precision highp float;

uniform sampler2D Texture0;
uniform float t;
uniform float t1;
uniform float sx;
uniform vec4 far;
uniform vec4 near;
uniform vec4 spec;
uniform vec4 refl;

varying vec2 v_texcoord;
varying vec4 v_color;

const vec2 tex_scale = vec2(0.5, 15.0);
const vec2 noise_speed = vec2(-0.08, -0.08);

void main(void)
{
	vec2 tc = vec2(v_texcoord.x, pow(v_texcoord.y, 0.1));
	vec2 nc = fract(tc*tex_scale + t*noise_speed);

	vec4 noise = texture2D(Texture0, nc);
	float n = mix(noise.x, noise.y, t1);

	float w = (sin(tc.y*10.0 + n - t) + 1.0) * 0.5;
	w = abs(w - n*0.1);

	float x = n - pow(abs(tc.x-sx), 2.0) * 60.0;
	x = clamp(x, 0.0, 1.0);

	vec4 base = near * (1.0 + n*0.1);
	//base.xyz += spec.xyz * (1.0 - pow(w, 0.15));
	//base.xyz += refl.xyz * (1.0 - pow(w, x));
	gl_FragColor = mix(far, base, pow(tc.y, 3.0));
}
]]

function M.init()
	shader.load("sea", sea_fs, vs,
		{
			t="1f", t1="1f",
			sx="1f",
			far="4f", near="4f", spec="4f" --, refl="4f"
		})
end

return M