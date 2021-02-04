instrument { name = "Linear Regression Slope", overlay = false }

period  = input (14, "front.period", input.integer, 2)

source = input (inputs.close, "front.ind.source", input.string_selection, inputs.titles)


input_group {
    "front.ind.dpo.generalline",
    color = input { default = "#B42EFF", type = input.color },
    width = input { default = 1, type = input.line_width}
}

input_group {
    "front.platform.baseline",
    zero_color  = input { default = rgba(255,255,255,0.15), type = input.color },
    zero_width  = input { default = 1, type = input.line_width}
}

local sourceSeries = inputs [source]

a = linreg (sourceSeries, period, 0)
b = linreg (sourceSeries, period, 1)
lrs = a - b

hline { value = 0, color = zero_color, width = zero_width }
plot (lrs, "Slope", color, width)
