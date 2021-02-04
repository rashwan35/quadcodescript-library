instrument {
    name = "Klinger Oscillator",
    short_name = "KO"
}

input_group {
    "front.ind.dpo.generalline",
    fast = input (34, "front.platform.fast period", input.integer, 1, 250),
    slow = input (55, "front.platform.slow period", input.integer, 1, 250),
    source = input (inputs.hlc3, "front.ind.source", input.string_selection, inputs.titles),

    osc_color = input { default = "#56CEFF", type = input.color },
    osc_width = input { default = 1, type = input.line_width },
    osc_visible = input { default = true, type = input.plot_visibility }
}

input_group {
    "front.platform.signal-line",
    "Reference signal series period",
    signal_period = input (13, "front.period", input.integer, 1, 250),

    signal_color = input { default = "#25E154", type = input.color },
    signal_width = input { default = 1, type = input.line_width },
    signal_visible = input { default = true, type = input.plot_visibility }
}

input_group {
    "front.platform.baseline",
    zero_line_visible = input { default = true, type = input.plot_visibility },
    zero_line_color   = input { default = rgba(255,255,255,0.15), type = input.color },
    zero_line_width   = input { default = 1, type = input.line_width }
}

sv = iff (change (inputs [source]) >= 0, volume, -volume)

kvo = ema (sv, fast) - ema (sv, slow)

signal = sma(kvo, signal_period)

if zero_line_visible then
    hline (0, "Zero", zero_line_color, zero_line_width)
end

if osc_visible then
    plot(kvo, "KO", osc_color, osc_width)
end

if signal_visible then
    plot(signal, "front.platform.signal-line", signal_color, signal_width)
end
