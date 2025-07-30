```cpp
namespace threeDimension
{
    // polygon
    typedef vector<p3> polygon;
    auto vectorArea2(const polygon &p)
    {
        p3 res = p3();
        for (int i = 0; i < (int)p.size(); ++i)
            res = res + cross(p[i], p[(i + 1) % p.size()]);
        return res;
    }
    auto area(const polygon &p)
    {
        return abs(vectorArea2(p)) / 2;
    }

    // polyhedron
    typedef vector<polygon> polyhedron;
    auto reorient(polyhedron &p)
    {
        int n = (int)p.size();
        vector<vector<pair<int, bool>>> g(n);
        map<pair<p3, p3>, int> mp;
        for (int u = 0; u < n; ++u)
        {
            for (int i = 0; i < (int)p[u].size(); ++i)
            {
                auto a = p[u][i], b = p[u][(i + 1) % p[u].size()];
                if (mp[{a, b}])
                {
                    int v = mp[{a, b}];
                    g[u].emplace_back(v, true);
                    g[v].emplace_back(u, true);
                }
                else if (mp[{b, a}])
                {
                    int v = mp[{b, a}];
                    g[u].emplace_back(v, false);
                    g[v].emplace_back(u, false);
                }
                else
                    mp[{a, b}] = i;
            }
        }
        vector<bool> flip(n), vis(n);
        queue<int> q;
        q.push(0);
        while (!q.empty())
        {
            int u = q.front();
            q.pop();
            for (auto [v, f] : g[u])
            {
                if (vis[v])
                    continue;
                flip[v] = flip[u] ^ f;
                vis[v] = true;
                q.push(v);
            }
            if (flip[u])
                reverse(p[u].begin(), p[u].end());
        }
    }
    auto volume(const polyhedron &p)
    {
        double res = 0;
        for (auto q : p)
            res += dot(q.front(), vectorArea2(q));
        return res / 6;
    }
}
```