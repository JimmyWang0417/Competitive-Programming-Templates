```cpp
namespace threeDimension
{
    constexpr double eps = 1e-9;
    auto sgn = [](double x)
    {
        return x < -eps ? -1 : (x > eps ? 1 : 0);
    };

    // point
    struct p3
    {
        double x, y, z;
        p3(double _x = 0, double _y = 0, double _z = 0) : x(_x), y(_y), z(_z) {}
        auto operator<(const p3 &rhs) const
        {
            return tie(x, y, z) < tie(rhs.x, rhs.y, rhs.z);
        }
        auto operator+(p3 p) const
        {
            return p3(x + p.x, y + p.y, z + p.z);
        }
        auto operator-(p3 p) const
        {
            return p3(x - p.x, y - p.y, z - p.z);
        }
        auto operator*(double p) const
        {
            return p3(x * p, y * p, z * p);
        }
        auto operator/(double p) const
        {
            return p3(x / p, y / p, z / p);
        }

        auto friend dot(p3 a, p3 b)
        {
            return a.x * b.x + a.y * b.y + a.z * b.z;
        }
        auto friend cross(p3 a, p3 b)
        {
            return p3(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x);
        }
        auto friend mixed(p3 a, p3 b, p3 c)
        {
            return dot(cross(a, b), c);
        }
        auto friend norm(p3 a)
        {
            return dot(a, a);
        }
        auto friend abs(p3 a)
        {
            return sqrt(norm(a));
        }
        auto friend angle(p3 a, p3 b)
        {
            return acos(clamp(dot(a, b) / abs(a) / abs(b), -1.0, 1.0));
        }
        auto friend orient(p3 p, p3 q, p3 r, p3 n)
        {
            return mixed(q - p, r - p, n);
        }
    };
}
```