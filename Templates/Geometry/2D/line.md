```cpp
namespace twoDimension
{
    // line
    struct line
    {
        p2 v;
        double c;
        line(p2 _v = p2(), double _c = 0) : v(_v), c(_c) {}
        line(p2 p, p2 q) : v(q - p), c(cross(v, p)) {}
        line(double p, double q, double r) : v({q, -p}), c(r) {}

        auto side(p2 p) const
        {
            return cross(v, p) - c;
        }
        // >0 说明是向量左边，<0说明是向量右边
        auto dist(p2 p) const
        {
            return abs(side(p)) / abs(p);
        }
        auto sqDist(p2 p) const
        {
            return side(p) * side(p) / norm(p);
        }
        auto perpThrough(p2 p) const
        {
            return line(p, p + perp(v));
        }
        auto cmpProj(p2 p, p2 q) const
        {
            return dot(v, p) < dot(v, q);
        }
        auto translate(p2 p) const
        {
            return line(v, c + cross(v, p));
        }
        auto shiftLeft(double dist) const
        {
            return line(v, c + dist * abs(v));
        }
        auto inter(line l1, line l2) -> pair<bool, p2> const
        {
            double d = cross(l1.v, l2.v);
            if (sgn(d))
                return {false, 0};
            else
                return {true, (l2.v * l1.c - l1.v * l2.c) / d};
        }
        auto proj(p2 p) const
        {
            return p - perp(v) * side(p) / norm(v);
        }
        auto refl(p2 p) const
        {
            return p - 2.0 * perp(v) * side(p) / norm(v);
        }
        friend auto bisector(line l1, line l2, bool interior)
        // if interior = true 则是内角平分线
        // 否则则是外角平分线
        {
            double sign = interior ? 1 : -1;
            return line(l2.v / abs(l2.v) + l1.v / abs(l1.v) * sign, l2.c / abs(l2.v) + l1.c / abs(l1.v) * sign);
        }
    };
}
```