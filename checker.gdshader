shader_type canvas_item;

uniform vec4 col1: hint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 col2: hint_color = vec4(0.5, 0.5, 0.5, 1.0);

varying vec2 full_uv;
void vertex () {
  full_uv = VERTEX.xy;
}

void fragment() {
  ivec2 xy = ivec2(full_uv);
  if (xy.y % 2 == 1 && xy.x % 2 == 0) {
    COLOR.rgba = col1;
   } else {
    COLOR.rgba = col2;
   }
  COLOR.a = texture(TEXTURE, UV).a;
}