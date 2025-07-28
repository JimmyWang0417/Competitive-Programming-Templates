```cpp
namespace twoDimension
{
    // polygon
    typedef vector<p2> polygon;
    double areaPolygon(const polygon &p)
    {
        double area = 0;
        for (int i = 0; i < (int)p.size(); ++i)
            area += cross(p[i], p[(i + 1) % p.size()]);
        return abs(area) / 2.0;
    }
    bool inPolygon(const polygon &p, p2 q, bool strict = false)
    {
        bool flag = false;
        for (int i = 0; i < (int)p.size(); ++i)
        {
            if (onSegment(p[i], p[(i + 1) % p.size()], q))
                return !strict;
            auto crossRay = [](p2 a, p2 b, p2 c)
            {
                auto above = [](p2 _a, p2 _b)
                {
                    return _a.imag() <= _b.imag();
                };
                return (above(a, c) - above(a, b)) * orient(a, b, c) > 0;
            };
            if (crossRay(q, p[i], p[(i + 1) % p.size()]))
                flag ^= 1;
        }
        return flag;
    }
}
```