```cpp
namespace threeDimension
{
    // convex hull
    auto convexHull(polygon p)
    {
        int n = (int)p.size();
        mt19937 rnd(chrono::system_clock::now().time_since_epoch().count());
        auto range = uniform_real_distribution<>(-eps, eps);
        for (auto &[x, y, z] : p)
        {
            x += range(rnd);
            y += range(rnd);
            z += range(rnd);
        }
        vector<array<int, 3>> f{{0, 1, 2}, {2, 1, 0}}, g;
        auto see = [&](auto a, auto b)
        {
            auto x = p[a[0]],
                 y = p[a[1]],
                 z = p[a[2]];
            return dot(b - x, cross(y - z, z - x)) > 0;
        };
        vector<vector<bool>> vis(n, vector<bool>(n));
        for (int i = 3, v; i < (int)p.size(); ++i)
        {
            for (auto h : f)
            {
                if (!(v = see(h, p[i])))
                    g.push_back(h);
                for (int j = 0; j < 3; ++j)
                    vis[h[j]][h[(j + 1) % 3]] = v;
            }
            for (auto h : f)
                for (int j = 0; j < 3; ++j)
                {
                    int x = h[j], y = h[(j + 1) % 3];
                    if (vis[x][y] && !vis[y][x])
                        g.push_back({x, y, i});
                }
            swap(f, g);
            g.clear();
        }
        polyhedron q(f.size(), polygon(3));
        for (int i = 0; i < (int)f.size(); ++i)
        {
            for (int j = 0; j < 3; ++j)
                q[i][j] = p[f[i][j]];
        }
        return q;
    }
}
```