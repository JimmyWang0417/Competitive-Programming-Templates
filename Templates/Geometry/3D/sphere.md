```cpp
namespace threeDimension
{
    // sphere
    auto sphereLine(p3 o, double r, line l) -> vector<p3>
    {
        double h2 = r * r - l.sqDist(o);
        if (sgn(h2) == -1)
            return {};
        else if (sgn(h2) == 0)
        {
            p3 p = l.proj(o);
            return {p};
        }
        else
        {
            p3 p = l.proj(o);
            p3 h = l.d * sqrt(h2) / abs(l.d);
            return {p - h, p + h};
        }
    }
    auto greatCircleDist(p3 o, double r, p3 a, p3 b)
    {
        return r * angle(a - o, b - o);
    }
    auto onSphSegment(p3 a, p3 b, p3 p)
    {
        p3 n = cross(a, b);
        if (sgn(norm(n)))
            return sgn(norm(cross(a, p))) == 0 && dot(a, p) > 0;
        return sgn(dot(n, p)) == 0 && mixed(n, a, p) >= 0 && mixed(n, p, b) >= 0;
    }
    auto properInter(p3 a, p3 b, p3 c, p3 d) -> pair<bool, p3>
    {
        p3 ab = cross(a, b), cd = cross(c, d);
        int oa = sgn(dot(cd, a));
        int ob = sgn(dot(cd, b));
        int oc = sgn(dot(ab, c));
        int od = sgn(dot(ab, d));
        return {oa != ob && oc != od && oa != oc, cross(ab, cd) * od};
    }
    auto intersSph(p3 a, p3 b, p3 c, p3 d) -> vector<p3>
    {
        auto [f, out] = properInter(a, b, c, d);
        if (f)
            return {out};

        set<p3> se;
        if (onSphSegment(c, d, a))
            se.insert(a);
        if (onSphSegment(c, d, b))
            se.insert(b);
        if (onSphSegment(a, b, c))
            se.insert(c);
        if (onSphSegment(a, b, d))
            se.insert(d);
        vector<p3> vec;
        for (auto p : se)
            vec.emplace_back(p);
        return vec;
    }
    auto angleSph(p3 a, p3 b, p3 c) // ∠BAC
    {
        return angle(cross(a, b), cross(a, c));
    }
    auto orientAngleSph(p3 a, p3 b, p3 c)
    {
        if (dot(a, cross(b, c)) >= 0)
            return angleSph(a, b, c);
        else
            return 2 * M_PI - angleSph(a, b, c);
    }
    auto areaOnSphere(const polygon &p, double r) // 逆时针给出点的多边形
    {
        double sum = -M_PI * ((int)p.size() - 2);
        for (int i = 0; i < (int)p.size(); ++i)
            sum += orientAngleSph(p[(i + 1) % p.size()], p[(i + 2) % p.size()], p[i]);
        return r * r * sum;
    }
}
```