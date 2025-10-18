namespace twoDimension
{
    // full convex hull
    auto adjust(polygon &p) { rotate(p.begin(), min_element(p.begin(), p.end()), p.end()); }
    auto convexHull(polygon p) // 逆时针给出点
    {
        adjust(p);
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
    auto sqdiameter(polygon p) -> double
    {
        int n = (int)p.size();
        if (n <= 1)
            return 0;
        if (n == 2)
            return norm(p.front() - p.back());
        double res = 0;
        for (int i = 0, j = 3; i < n; ++i)
        {
            while (i != (j + 1) % n &&
                abs(orient(p[i], p[(i + 1) % n], p[j])) <= abs(orient(p[i], p[(i + 1) % n], p[(j + 1) % n])))
                j = (j + 1) % n;
            res = max({res, norm(p[j] - p[i]), norm(p[j] - p[(i + 1) % n])});
        }
        return res;
    }
    auto diameter(polygon p) { return sqrt(sqdiameter(p)); }
    auto minkowskiSum(polygon a, polygon b) // 逆时针凸包的闵可夫斯基和
    {                                       // 必须经过adjust的凸包才能正确处理
        if (a.empty() || b.empty())
            return polygon();
        a.push_back(a.front()), b.push_back(b.front());
        polygon c(a.size() + b.size() - 1);
        c.front() = a.front() + b.front();
        adjacent_difference(a.begin(), a.end(), a.begin());
        adjacent_difference(b.begin(), b.end(), b.begin());
        merge(a.begin() + 1, a.end(), b.begin() + 1, b.end(), c.begin() + 1, [](auto x, auto y)
        { return cross(x, y) > 0; });
        partial_sum(c.begin(), c.end(), c.begin());
        c.pop_back();
        return c;
    }
    auto minkowskiDifference(polygon a, polygon b)
    {
        for (int i = 0; i < (int)a.size(); ++i)
            a[i] = -a[i];
        adjust(a);
        return minkowskiSum(move(a), move(b));
    }
    auto convexConvex(const polygon &a, const polygon &b) // 凸包之间的距离
    {
        return polygonPoint(minkowskiDifference(a, b), p2(0, 0));
    }
}
