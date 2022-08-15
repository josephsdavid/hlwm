module hlwm
using FilePathsBase
export plan_binds, bind, pushbind!, Keybind

include("cmd.jl")

function delim_str(init = "", delim = " ")
    return (s...) -> reduce((x, y) -> "$(x)$(delim)$(y)", [s...]; init)
end

const _hc = delim_str("herbstclient")
const MOD = delim_str("mod4", "-")
const use_index = delim_str("use_index")
const move_index = delim_str("move_index")
const spawn = delim_str(:spawn)
const chain = delim_str(:chain, " . ")
const focus = delim_str(:focus)
const split = delim_str(:split)
const resize = delim_str(:resize)

include("tag.jl")
include("keybind.jl")

move_across_monitors(direction) = chain(
    :lock,
    :shift_to_monitor,
    "-$(direction)",
    :focus_monitor,
    "-$(direction)",
    "emit_hook layout_changed",
    :unlock,
)

pushbind!(binds::Vector{Keybind}, k::Keybind) = push!(binds, k)
function pushbind!(binds::Vector{Keybind}, k::Vector)
    for kk in k
        pushbind!(binds, kk)
    end
end

function plan_binds()
    binds = Keybind[]

    keybinds = [
        MOD(:slash) => spawn("/home/david/scripts/menus/system-menu.sh"),
        MOD(:Shift, :q) => spawn("/home/david/scripts/menus/locker.sh"),
        MOD(:Shift, :r) => :reload,
        MOD(:x) => :close,
        MOD(:w) => :remove,
        MOD(:Shift, :x) => :close_or_remove,
        MOD(:d) => chain("emit_hook dmenu", spawn("rofi -show drun -columns 3")),
        MOD(:Shift, :Return) => spawn(:alacritty),
        MOD(:Shift, :v) => spawn(:firefox),
        :XF86AudioRaiseVolume => spawn("/home/david/scripts/utilities/dunst_vol", :up),
        :XF86AudioLowerVolume =>
            spawn("/home/david/scripts/utilities/dunst_vol", :down),
        :XF86AudioMute => spawn("/home/david/scripts/utilities/dunst_vol", :mute),
        :XF86MonBrightnessUp =>
            spawn("/home/david/scripts/utilities/dunst_bright", :up),
        :XF86MonBrightnessDown =>
            spawn("/home/david/scripts/utilities/dunst_bright", :down),
        MOD(:Alt, :Down) => chain(spawn(:playerctl, "play-pause")),
        MOD(:Alt, :Left) => chain(spawn(:playerctl, "previous")),
        MOD(:Alt, :Right) => chain(spawn(:playerctl, "next")),
        :XF86AudioPlay => chain(spawn(:playerctl, "play-pause")),
        :XF86AudioPrev => chain(spawn(:playerctl, "previous")),
        :XF86AudioNext => chain(spawn(:playerctl, "next")),
        MOD(:Shift, :p) => spawn("/home/david/scripts/utilities/screenshot"),
        MOD(:Shift, :f) => spawn("/home/david/scripts/utilities/recorder"),
        MOD(:Alt, :f) =>
            chain(spawn(:pkill, :ffmpeg), spawn("notify-send", "Recording stopped!")),
        MOD(:Left) => focus(:left),
        MOD(:h) => focus(:left),
        MOD(:Right) => focus(:right),
        MOD(:l) => focus(:right),
        MOD(:Up) => focus(:up),
        MOD(:k) => focus(:up),
        MOD(:Down) => focus(:down),
        MOD(:j) => focus(:down),
        MOD(:Shift, :h) => move_across_monitors("l"),
        MOD(:Shift, :Left) => move_across_monitors("l"),
        MOD(:Shift, :j) => move_across_monitors("d"),
        MOD(:Shift, :Down) => move_across_monitors("d"),
        MOD(:Shift, :k) => move_across_monitors("u"),
        MOD(:Shift, :Up) => move_across_monitors("u"),
        MOD(:Shift, :l) => move_across_monitors("r"),
        MOD(:Shift, :Right) => move_across_monitors("r"),
        MOD(:u) => split(:bottom, 0.5),
        MOD(:o) => split(:right, 0.5),
        MOD(:Control, :space) => split(:explode),
        MOD(:Control, :h) => resize(:left, "+0.05"),
        MOD(:Control, :j) => resize(:down, "+0.05"),
        MOD(:Control, :k) => resize(:up, "+0.05"),
        MOD(:Control, :l) => resize(:right, "+0.05"),
        MOD(:t) => "floating toggle",
        MOD(:f) => "fullscreen toggle",
        MOD(:p) => "pseudotile toggle",
        MOD(:Shift, :t) => spawn("/home/david/.config/herbstluftwm/bin/floatsingle"),

    ]
    pushbind!(binds, Keybind.(Tag.(1:9)))
    pushbind!(binds, Keybind.(keybinds))
    return binds

end


bind.(plan_binds())


end # module
