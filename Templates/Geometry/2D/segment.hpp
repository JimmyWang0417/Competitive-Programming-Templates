namespace twoDimension
{
    // segment
    auto onSegment(p2 a, p2 b, p2 p)
    {
        return sgn(orient(a, b, p)) == 0 && dot(a - p, b - p) <= 0;
    }
    auto properInter(p2 a, p2 b, p2 c, p2 d) -> pair<bool, p2>
    {
        double oa = orient(c, d, a);
        double ob = orient(c, d, b);
        double oc = orient(a, b, c);
        double od = orient(a, b, d);
        if (oa * ob < 0 && oc * od < 0)
            return make_pair(true, (a * ob - b * oa) / (ob - oa));
        else
            return make_pair(false, 0);
    }
    auto inters(p2 a, p2 b, p2 c, p2 d)
    {
        auto [x, y] = properInter(a, b, c, d);
        if (x)
            return vector<p2>(1, y);
        set<p2> se;
        if (onSegment(c, d, a))
            se.insert(a);
        if (onSegment(c, d, b))
            se.insert(b);
        if (onSegment(a, b, c))
            se.insert(c);
        if (onSegment(a, b, d))
            se.insert(d);
        vector<p2> vec;
        for (auto p : se)
            vec.emplace_back(p);
        return vec;
    }
    auto segPoint(p2 a, p2 b, p2 p)
    {
        if (a != b)
        {
            line l(a, b);
            if (l.cmpProj(a, p) && l.cmpProj(p, b))
                return l.dist(p);
        }
        return min(abs(p - a), abs(p - b));
    }
    auto segSeg(p2 a, p2 b, p2 c, p2 d) -> double
    {
        if (properInter(a, b, c, d).first)
            return 0;
        return min({segPoint(a, b, c), segPoint(a, b, d), segPoint(c, d, a), segPoint(c, d, b)});
    }
}