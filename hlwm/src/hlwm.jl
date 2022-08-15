module hlwm
using FilePathsBase
export plan_binds, bind, pushbind!, Keybind

include("cmd.jl")

function delim_str(init="", delim=" ")
    return (s...) -> reduce((x, y) -> "$(x)$(delim)$(y)", [s...]; init)
end

const _hc = delim_str("herbstclient")
const MOD = delim_str("mod4", "-")
const use_index = delim_str("use_index")
const move_index = delim_str("move_index")
const spawn = delim_str(:spawn)
const chain = delim_str(:chain, " . ")

include("tag.jl")
include("keybind.jl")

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
        :XF86AudioLowerVolume => spawn("/home/david/scripts/utilities/dunst_vol", :down),
        :XF86AudioMute => spawn("/home/david/scripts/utilities/dunst_vol", :mute),
        :XF86MonBrightnessUp => spawn("/home/david/scripts/utilities/dunst_bright", :up),
        :XF86MonBrightnessDown => spawn("/home/david/scripts/utilities/dunst_bright", :down),
        MOD(:Alt, :Down) => chain(spawn(:playerctl, "play-pause")),
        MOD(:Alt, :Left) => chain(spawn(:playerctl, "previous")),
        MOD(:Alt, :Right) => chain(spawn(:playerctl, "next")),
        :XF86AudioPlay => chain(spawn(:playerctl, "play-pause")),
        :XF86AudioPrev => chain(spawn(:playerctl, "previous")),
        :XF86AudioNext => chain(spawn(:playerctl, "next")),
        MOD(:Shift, :p) => spawn("/home/david/scripts/utilities/screenshot"),
        MOD(:Shift, :f) => spawn("/home/david/scripts/utilities/recorder"),
        MOD(:Alt, :f) => chain(spawn(:pkill, :ffmpeg), spawn("notify-send", "Recording stopped!")),
    ]

    pushbind!(binds, Keybind.(Tag.(1:9)))
    pushbind!(binds, Keybind.(keybinds))
    return binds

end


bind.(plan_binds())


end # module
