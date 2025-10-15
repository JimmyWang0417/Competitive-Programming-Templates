namespace std
{
    template <typename T>
    bool operator<(const complex<T> &lhs, const complex<T> &rhs)
    {
        return tie(lhs.real(), lhs.imag()) < tie(rhs.real(), rhs.imag());
    }
}
namespace twoDimension
{
    constexpr double eps = 1e-9;
    auto sgn = [](double x)
    {
        return x < -eps ? -1 : (x > eps ? 1 : 0);
    };

    // point
    typedef complex<double> p2;
    auto dot(p2 lhs, p2 rhs)
    {
        return (conj(lhs) * rhs).real();
    }
    auto cross(p2 lhs, p2 rhs)
    {
        return (conj(lhs) * rhs).imag();
    }

    auto perp(p2 p)
    {
        return p2(-p.imag(), p.real());
    }
    auto rot(p2 p, double theta)
    {
        return p * polar(1.0, theta);
    }

    auto translate(p2 lhs, p2 rhs)
    {
        return lhs + rhs;
    }
    auto scale(p2 c, double factor, p2 p)
    {
        return c + (p - c) * factor;
    }

    auto isPerp(p2 p, p2 q)
    {
        return sgn(dot(p, q)) == 0;
    }
    auto angle(p2 a, p2 b)
    {
        return abs(arg(conj(a) * b));
    }
    auto orientAngle(p2 a, p2 b)
    {
        return arg(conj(a) * b);
    }

    auto orient(p2 a, p2 b, p2 c)
    {
        return cross(b - a, c - a);
    }
    auto inAngle(p2 a, p2 b, p2 c, p2 p)
    {
        if (orient(a, b, c) < 0)
            swap(b, c);
        return orient(a, b, p) >= 0 && orient(a, p, c) >= 0;
    }
};
