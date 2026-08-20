-- Colores pywal en formato RGBA hexadecimal
-- Formato: rgba(33ccffee) donde cada color es de 2 dígitos hex
-- Generado automáticamente

local function to_rgba_hex(hex, alpha)
	-- Eliminar el # si existe
	hex = hex:gsub("#", "")
	alpha = alpha or "ff"
	-- Formato: rgba(rrggbbaa) sin # y sin comas
	return string.format("rgba(%s%s)", hex, alpha)
end

local colors = {
	wallpaper = "{wallpaper}",
	alpha = "{alpha}",
	checksum = "{checksum}",

	-- Colores con opacidad completa (ff = 255)
	background = to_rgba_hex("{background}", "ff"),
	foreground = to_rgba_hex("{foreground}", "ff"),
	cursor = to_rgba_hex("{cursor}", "ff"),

	color0 = to_rgba_hex("{color0}", "ff"),
	color1 = to_rgba_hex("{color1}", "ff"),
	color2 = to_rgba_hex("{color2}", "ff"),
	color3 = to_rgba_hex("{color3}", "ff"),
	color4 = to_rgba_hex("{color4}", "ff"),
	color5 = to_rgba_hex("{color5}", "ff"),
	color6 = to_rgba_hex("{color6}", "ff"),
	color7 = to_rgba_hex("{color7}", "ff"),
	color8 = to_rgba_hex("{color8}", "ff"),
	color9 = to_rgba_hex("{color9}", "ff"),
	color10 = to_rgba_hex("{color10}", "ff"),
	color11 = to_rgba_hex("{color11}", "ff"),
	color12 = to_rgba_hex("{color12}", "ff"),
	color13 = to_rgba_hex("{color13}", "ff"),
	color14 = to_rgba_hex("{color14}", "ff"),
	color15 = to_rgba_hex("{color15}", "ff"),

	-- Versiones con transparencia (opcional)
	background_50 = to_rgba_hex("{background}", "80"), -- 50% transparente
	foreground_50 = to_rgba_hex("{foreground}", "80"),
}

return colors
