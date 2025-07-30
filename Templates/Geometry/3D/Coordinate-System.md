```cpp
namespace threeDimension
{
    // Coordinate System
    struct coords
    {
        p3 o, dx, dy, dz;
        coords(p3 p, p3 q, p3 r) : o(p)
        {
            dx = (q - p) / abs(q - p);
            dz = cross(dx, (r - p) / abs(r - p));
            dy = cross(dz, dx);
        }

        auto pos2d(p3 p) const
        {
            p = p - o;
            return twoDimension::p2(dot(p, dx), dot(p, dy));
        }
        auto pos3d(p3 p) const
        {
            p = p - o;
            return p3(dot(p, dx), dot(p, dy), dot(p, dz));
        }
    };
}
```