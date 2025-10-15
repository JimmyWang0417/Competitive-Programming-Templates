namespace twoDimension
{
    // half convex hull
    auto halfConvexHull(polygon p) // 下凸包，逆时针给出
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
    auto halfMinkowskiSum(polygon a, polygon b) // 逆时针凸包的闵可夫斯基和
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
