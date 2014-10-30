#ifdef GL_ES
#else
#define highp
#define mediump
#define lowp
#endif
uniform   mat4 u_mvp;

attribute vec4 a_pos;
attribute vec2 a_uv0;
attribute vec2 a_uv1;
attribute vec4 a_color;

varying   vec2 v_texcoord0;
varying   vec2 v_texcoord1;
varying   vec4 v_color;

void main()
{
	gl_Position = u_mvp * a_pos;
	v_texcoord0 = a_uv0;
	v_texcoord1 = a_uv1;
	v_color = a_color;
}
