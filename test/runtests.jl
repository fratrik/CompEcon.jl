module CompEconTests

using CompEcon

if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

tests = [
    "types.jl"
    ]

if length(ARGS) > 0
    tests = ARGS
end

end_jl(s) = endswith(s, ".jl") ? s : s * ".jl"

for t in tests
    print_with_color(:green, "* $t\n")
    include(end_jl(t))
end


# correctness is checked in BasisMatrices. Here we just check that all
# functions run without error
b1 = fundef((:spli, linspace(0, 1, 10), 0, 3))
b2 = fundef((:lin, linspace(0, 1, 10), 0))
b3 = fundef((:cheb, 10, 0.0, 3.0))
b4 = fundefn(:spli, [10, 10], [-2.0, -1.0], [1.0, 2.0], 3)
b5 = fundefn(:lin, [10, 10], [-2.0, -1.0], [1.0, 2.0])
b6 = fundefn(:cheb, [10, 10], [-2.0, -1.0], [1.0, 2.0])
f1(X) = exp.(X)
f2(X) = sin.(X[:, 1] + X[:, 2])

i = 0
for b in (b1, b2, b3, b4, b5, b6)
    @show i += 1
    X, x = funnode(b)
    funbase(b)
    funbasex(b)

    f = b[:d] == 1 ? f1 : f2
    funfitf(b, f)
    y = f(X)
    c, B = funfitxy(b, X, y)
    funeval(c, b, x)
    funeval(c, b, X)
    funeval(c, b, B)
    funbconv(B, B[:order], :expanded)
end

end  # module
