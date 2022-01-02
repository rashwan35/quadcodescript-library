EMA1 = ta.ema(haC, EMAlength)
EMA2 = ta.ema(EMA1, EMAlength)
EMA3 = ta.ema(EMA2, EMAlength)
TMA1 = 3 * EMA1 - 3 * EMA2 + EMA3
EMA4 = ta.ema(TMA1, EMAlength)
EMA5 = ta.ema(EMA4, EMAlength)
EMA6 = ta.ema(EMA5, EMAlength)
TMA2 = 3 * EMA4 - 3 * EMA5 + EMA6
IPEK = TMA1 - TMA2
YASIN = TMA1 + IPEK
EMA7 = ta.ema(hlc3, EMAlength)
EMA8 = ta.ema(EMA7, EMAlength)
EMA9 = ta.ema(EMA8, EMAlength)
TMA3 = 3 * EMA7 - 3 * EMA8 + EMA9
EMA10 = ta.ema(TMA3, EMAlength)
EMA11 = ta.ema(EMA10, EMAlength)
EMA12 = ta.ema(EMA11, EMAlength)
TMA4 = 3 * EMA10 - 3 * EMA11 + EMA12
IPEK1 = TMA3 - TMA4
YASIN1 = TMA3 + IPEK1

mavi = YASIN1
kirmizi = YASIN


longCond = mavi > kirmizi and mavi[1] <= kirmizi[1]
shortCond = mavi < kirmizi and mavi[1] >= kirmizi[1]

trendState = kirmizi < mavi ? true : kirmizi > mavi ? false : na
closePlot = plot(kirmizi, title='Close Line', color=color.new(color.green, 90), linewidth=10, style=plot.style_line)
openPlot = plot(mavi, title='Open Line', color=color.new(color.red, 90), linewidth=10, style=plot.style_line)
closePlotU = plot(trendState ? kirmizi : na, editable=false, transp=100)
openPlotU = plot(trendState ? mavi : na, editable=false, transp=100)
closePlotD = plot(trendState ? na : kirmizi, editable=false, transp=100)
openPlotD = plot(trendState ? na : mavi, editable=false, transp=100)
fill(openPlotU, closePlotU, title='Up Trend Fill', color=color.new(color.green, 1))
fill(openPlotD, closePlotD, title='Down Trend Fill', color=color.new(color.red, 1))


last_signal = 0
long_final = longCond and (nz(last_signal[1]) == 0 or nz(last_signal[1]) == -1)
short_final = shortCond and (nz(last_signal[1]) == 0 or nz(last_signal[1]) == 1)

alertcondition(long_final, title='call alarm', message='buy signal!!!')
alertcondition(short_final, title='put alarm', message='sell signal!!!')
last_signal := long_final ? 1 : short_final ? -1 : last_signal[1]

plotshape(long_final, style=shape.labelup, location=location.belowbar, color=color.new(color.blue, 0), size=size.tiny, title='buy label', text='Call', textcolor=color.new(color.white, 0))
plotshape(short_final, style=shape.labeldown, location=location.abovebar, color=color.new(color.red, 0), size=size.tiny, title='sell label', text='Put', textcolor=color.new(color.white, 0))


src2 = input(defval=close, title='Source')
len = input.int(defval=100, title='Length', minval=10)
devlen = input.float(defval=2., title='Deviation', minval=0.1, step=0.1)
extendit = input(defval=true, title='Extend Lines')
showfibo = input(defval=false, title='Show Fibonacci Levels')
showbroken = input.bool(defval=true, title='Show Broken Channel', inline='brk')
brokencol = input.color(defval=color.blue, title='', inline='brk')
upcol = input.color(defval=color.lime, title='Up/Down Trend Colors', inline='trcols')
dncol = input.color(defval=color.red, title='', inline='trcols')
widt = input(defval=2, title='Line Width')

var fibo_ratios = array.new_float(0)
var colors = array.new_color(2)
if barstate.isfirst
    array.unshift(colors, upcol)
    array.unshift(colors, dncol)
    array.push(fibo_ratios, 0.236)
    array.push(fibo_ratios, 0.382)
    array.push(fibo_ratios, 0.618)
    array.push(fibo_ratios, 0.786)


get_channel(src2, len) =>
    mid = math.sum(src2, len) / len
    slope = ta.linreg(src2, len, 0) - ta.linreg(src2, len, 1)
    intercept = mid - slope * math.floor(len / 2) + (1 - len % 2) / 2 * slope
    endy = intercept + slope * (len - 1)
    dev = 0.0
    for x = 0 to len - 1 by 1
        dev += math.pow(src2[x] - (slope * (len - x) + intercept), 2)
        dev
    dev := math.sqrt(dev / len)
    [intercept, endy, dev, slope]

[y1_, y2_, dev, slope] = get_channel(src2, len)

outofchannel = slope > 0 and close < y2_ - dev * devlen ? 0 : slope < 0 and close > y2_ + dev * devlen ? 2 : -1

var reglines = array.new_line(3)
var fibolines = array.new_line(4)
for x = 0 to 2 by 1
    if not showbroken or outofchannel != x or nz(outofchannel[1], -1) != -1
        line.delete(array.get(reglines, x))
    else
        line.set_color(array.get(reglines, x), color=brokencol)
        line.set_width(array.get(reglines, x), width=3)
        line.set_style(array.get(reglines, x), style=line.style_solid)
        line.set_extend(array.get(reglines, x), extend=extend.none)

    array.set(reglines, x, line.new(x1=bar_index - (len - 1), y1=y1_ + dev * devlen * (x - 1), x2=bar_index, y2=y2_ + dev * devlen * (x - 1), color=array.get(colors, math.round(math.max(math.sign(slope), 0))), style=x % 2 == 1 ? line.style_solid : line.style_solid, width=widt, extend=extendit ? extend.right : extend.none))
if showfibo
    for x = 0 to 3 by 1
        line.delete(array.get(fibolines, x))
        array.set(fibolines, x, line.new(x1=bar_index - (len - 1), y1=y1_ - dev * devlen + dev * devlen * 2 * array.get(fibo_ratios, x), x2=bar_index, y2=y2_ - dev * devlen + dev * devlen * 2 * array.get(fibo_ratios, x), color=array.get(colors, math.round(math.max(math.sign(slope), 0))), style=line.style_solid, width=widt, extend=extendit ? extend.right : extend.none))

var label sidelab = label.new(x=bar_index - (len - 1), y=y1_, text='S', size=size.large)
txt = slope > 0 ? slope > slope[1] ? '⇑' : '⇗' : slope < 0 ? slope < slope[1] ? '⇓' : '⇘' : '⇒'
stl = slope > 0 ? slope > slope[1] ? label.style_label_up : label.style_label_upper_right : slope < 0 ? slope < slope[1] ? label.style_label_down : label.style_label_lower_right : label.style_label_right
label.set_style(sidelab, stl)
label.set_text(sidelab, txt)
label.set_x(sidelab, bar_index - (len - 1))
label.set_y(sidelab, slope > 0 ? y1_ - dev * devlen : slope < 0 ? y1_ + dev * devlen : y1_)
label.set_color(sidelab, slope > 0 ? upcol : slope < 0 ? dncol : color.blue)

alertcondition(outofchannel, title='Channel Broken', message='Channel Broken')

// direction
trendisup = math.sign(slope) != math.sign(slope[1]) and slope > 0
trendisdown = math.sign(slope) != math.sign(slope[1]) and slope < 0
alertcondition(trendisup, title='Up trend has started', message='Up trend has started')
alertcondition(trendisdown, title='Down trend has started', message='Down trend has started')


           
