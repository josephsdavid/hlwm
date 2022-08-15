struct Keybind{L, R}
    lhs::L
    rhs::R
end

(k::Keybind)() = cmd(_hc(k.lhs, k.rhs))

function Keybind(p::Pair)
    return Keybind(p...)
end

function Keybind(t::Tag{L, R}) where {L, R}
    return Keybind.([
        MOD(t.key) => use_index(t.name)
        MOD("Shift", t.key) => move_index(t.name)
    ])
end

bind(k::Keybind) = run(k(); wait = false)
