namespace threeDimension
{
    // plane
    struct plane
    {
        p3 n;
        double d;
        plane(p3 _n = p3(), double _d = 0) : n(_n), d(_d) {}
        plane(p3 _n, p3 _p) : n(_n), d(dot(_n, _p)) {}
        plane(p3 p, p3 q, p3 r) : plane(cross(q - p, r - p), p) {}

        auto side(p3 p) const
        {
            return dot(n, p) - d;
        }
        auto dist(p3 p) const
        {
            return dot(n, p) / abs(n);
        }

        auto translate(p3 t) const
        {
            return plane(n, d + dot(n, t));
        }
        auto shiftUp(double dist) const
        {
            return plane(n, d + abs(n) * dist);
        }
        auto proj(p3 p) const
        {
            return p - n * side(p) / norm(n);
        }
        auto refl(p3 p) const
        {
            return p - n * side(p) * 2 / norm(n);
        }

        auto friend angle(plane a, plane b)
        {
            return angle(a.n, b.n);
        }
    };
}
