namespace twoDimension
{
    // circle
    p2 circumcenter(p2 a, p2 b, p2 c)
    {
        b = b - a, c = c - a;
        return a + perp(b * norm(c) - c * norm(b)) / cross(b, c) / 2.0;
    }
    p2 incenter(p2 a, p2 b, p2 c)
    {
        double A = abs(b - c), B = abs(a - c), C = abs(a - b);
        return (A * a + B * b + C * c) / (A + B + C);
    }
    auto circleLine(p2 o, double r, line l) -> vector<p2>
    {
        double h2 = r * r - l.sqDist(o);
        if (sgn(h2) == 0)
        {
            p2 p = l.proj(o);
            return {p};
        }
        else if (sgn(h2) > 0)
        {
            p2 p = l.proj(o);
            p2 h = l.v * sqrt(h2) / abs(l.v);
            return {p - h, p + h};
        }
        else
            return {};
    }
    auto circleCircle(p2 o1, double r1, p2 o2, double r2) -> vector<p2>
    {
        p2 d = o2 - o1;
        double d2 = norm(d);
        if (sgn(d2) == 0)
            return {};
        double pd = (d2 + r1 * r1 - r2 * r2) / 2; // |O1P|*d
        double h2 = r1 * r1 - pd * pd / d2;
        if (sgn(h2) == 0)
        {
            p2 p = o1 + d * pd / d2;
            return {p};
        }
        else if (sgn(h2) == 1)
        {
            p2 p = o1 + d * pd / d2, h = perp(d) * sqrt(h2 / d2);
            return{p - h, p + h};
        }
        else
            return {};
    }
    auto tangents(p2 o1, double r1, p2 o2, double r2, bool inner) -> vector<pair<p2, p2>>
    {
        if (inner)
            r2 = -r2;
        p2 d = o2 - o1;
        double dr = r1 - r2, d2 = norm(d), h2 = d2 - dr * dr;
        if (sgn(d2) == 0)
            return {};
        if (sgn(h2) == 0)
        {
            p2 v = d * dr / h2;
            return {{o1 + v * r1, o2 + v * r2}};
        }
        else if (sgn(h2) == 1)
        {
            p2 v = (d * dr + perp(d) * sqrt(h2)) / d2, w = (d * dr - perp(d) * sqrt(h2)) / d2;
            return {{o1 + v * r1, o2 + v * r2}, {o1 + w * r1, o2 + w * r2}};
        }
        else
            return {};
    }
};
