```cpp
namespace twoDimension
{
    // convex hull
    auto lowerConvexHull(polygon p)
    {
        sort(p.begin(), p.end());
        polygon st;
        for (auto q : p)
        {
            while (st.size() >= 2 && orient(st.back(), st[st.size() - 2], q) >= 0)
                st.pop_back();
            st.push_back(q);
        }
        return st;
    }
    auto upperConvexHull(polygon p)
    {
        sort(p.begin(), p.end());
        polygon st;
        for (auto q : p)
        {
            while (st.size() >= 2 && orient(st.back(), st[st.size() - 2], q) <= 0)
                st.pop_back();
            st.push_back(q);
        }
        return st;
    }
    auto convexHull(polygon p) // 逆时针给出点
    {
        rotate(p.begin(), min_element(p.begin(), p.end()), p.end());
        auto compare = [&](auto x, auto y)
        {
            int d = sgn(orient(p.front(), x, y));
            if (d == 0)
                return norm(x) < norm(y);
            else
                return d > 0;
        };
        sort(p.begin() + 1, p.end(), compare);
        polygon st;
        for (auto q : p)
        {
            while (st.size() >= 2 && orient(st.back(), st[st.size() - 2], q) >= 0)
                st.pop_back();
            st.push_back(q);
        }
        return st;
    }
    auto minkowskiSum(polygon a, polygon b) // 逆时针凸包的闵可夫斯基和
    {
        if (a.empty() || b.empty())
            return polygon();
        polygon c(a.size() + b.size() - 1);
        c.front() = a.front() + b.front();
        adjacent_difference(a.begin(), a.end(), a.begin());
        adjacent_difference(b.begin(), b.end(), b.begin());
        merge(a.begin() + 1, a.end(), b.begin() + 1, b.end(), c.begin() + 1, [](auto x, auto y)
              { return cross(x, y) > 0; });
        partial_sum(c.begin(), c.end(), c.begin());
        return c;
    }
}
```