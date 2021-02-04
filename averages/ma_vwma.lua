instrument { name = "Volume Weighted Moving Average", short_name = "VWMA", overlay = true, icon="indicators:MA" }

period = input (20, "front.period", input.integer, 1)
source = input (1, "front.ind.source", input.string_selection, inputs.titles_overlay)

input_group {
    "front.ind.dpo.generalline",
    color = input { default = "#FF6C58", type = input.color },
    width = input { default = 1, type = input.line_width}
}

local sourceSeries = inputs [source]

plot (vwma (sourceSeries, period), "VWMA", color, width)
