namespace threeDimension
{
    // line
    struct line
    {
        p3 d, o;
        line(p3 p = p3(), p3 q = p3()) : d(q - p), o(p) {}
        line(plane p, plane q)
        {
            d = cross(p.n, q.n);
            o = cross((cross(q.n, p.d) - cross(p.n, q.d)), d) / norm(d);
        }
        auto sqDist(p3 p) const
        {
            return norm(cross(d, p - o)) / norm(d);
        }
        auto dist(p3 p) const
        {
            return sqrt(sqDist(p));
        }
        auto cmpProj(p3 p, p3 q) const
        {
            return dot(d, p) < dot(d, q);
        }
        auto proj(p3 p) const
        {
            return o + d * dot(d, p - o) / norm(d);
        }
        auto refl(p3 p) const
        {
            return proj(p) * 2 - p;
        }
        auto friend inter(plane p, line l)
        {
            return l.o - l.d * p.side(l.o) / dot(p.n, l.d);
        }
        auto friend dist(line l1, line l2)
        {
            p3 n = cross(l1.d, l2.d);
            if (sgn(norm(n)) == 0)
                return l1.dist(l2.o);
            return abs(dot(l2.o - l1.o, n)) / abs(n);
        }
        auto friend closestOnL1(line l1, line l2)
        {
            auto n2 = cross(l2.d, cross(l1.d, l2.d));
            return l1.o + l1.d * dot(l2.o - l1.o, n2) / dot(l1.d, n2);
        }
        auto friend angle(line a, line b)
        {
            return angle(a.d, b.d);
        }
        auto friend perpThrough(plane p, p3 o)
        {
            return line(o, o + p.n);
        }
        auto friend perpThrough(line l, p3 o)
        {
            return plane(l.d, o);
        }
    };
}
