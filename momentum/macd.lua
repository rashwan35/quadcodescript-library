instrument {
    name = "MACD",
    short_name = "MACD",
    icon = "indicators:MACD"
}

input_group {
    "MACD",
    "front.newind.macd.slowfast-hint",
    fast = input (12, "front.platform.fast period", input.integer, 1, 250),
    slow = input (26, "front.platform.fast period", input.integer, 1, 250),

    macd_color = input { default = "#2384C2", type = input.color },
    macd_width = input { default = 1, type = input.line_width },
    macd_visible = input { default = true, type = input.plot_visibility }
}

input_group {
    "front.platform.signal-line",
    "front.newind.macd.signal-hint",
    signal_period = input (9, "front.period", input.integer, 1, 250),

    signal_color = input { default = "#FF7700", type = input.color },
    signal_width = input { default = 1, type = input.line_width },
    signal_visible = input { default = true, type = input.plot_visibility }
}

input_group {
    "front.platform.baseline",
    zero_line_visible = input { default = true, type = input.plot_visibility },
    zero_line_color   = input { default = rgba(255,255,255,0.15), type = input.color },
    zero_line_width   = input { default = 1, type = input.line_width }
}

input_group {
    "front.newind.barcolors",
    histogram_visible = input { default = true, type = input.plot_visibility },
    histogram_up_color   = input { default = "#2CAC40", type = input.color },
    histogram_down_color   = input { default = "#DB4931", type = input.color }
}

fastMA = ema(close, fast)
slowMA = ema(close, slow)

macd = fastMA - slowMA

signal = ema(macd, signal_period)

hist = macd - signal

if macd_visible then
    plot(macd, "MACD", macd_color, macd_width)
end

if signal_visible then
    plot(signal, "front.platform.signal-line", signal_color, signal_width)
end

if histogram_visible then
    rect {
        first = 0,
        second = hist,
        color = hist >= hist [1] and histogram_up_color or histogram_down_color,
        width = 0.4
    }
end

if zero_line_visible then
    hline (0, "Zero", zero_line_color, zero_line_width)
end
