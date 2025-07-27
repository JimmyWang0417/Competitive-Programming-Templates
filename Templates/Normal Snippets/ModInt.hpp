namespace MODINT
{
    template <const int _mod>
    struct modint
    {
        int x;
        constexpr modint(int _x = 0) : x(_x) {}
        constexpr inline modint operator+() const
        {
            return *this;
        }
        constexpr inline modint operator-() const
        {
            return !x ? 0 : _mod - x;
        }
        constexpr inline modint &operator++()
        {
            ++x;
            if (x >= _mod)
                x -= _mod;
            return *this;
        }
        constexpr inline modint &operator--()
        {
            --x;
            if (x < 0)
                x += _mod;
            return *this;
        }
        constexpr inline modint operator++(int)
        {
            int res = x;
            if (x >= _mod)
                x -= _mod;
            return res;
        }
        constexpr inline modint operator--(int)
        {
            int res = x;
            if (x < 0)
                x += _mod;
            return res;
        }
        constexpr inline modint operator+(const modint &rhs) const
        {
            int res = x;
            res += rhs.x;
            if (res >= _mod)
                res -= _mod;
            return res;
        }
        constexpr inline modint operator-(const modint &rhs) const
        {
            int res = x;
            res -= rhs.x;
            if (res < 0)
                res += _mod;
            return res;
        }
        constexpr inline modint operator*(const modint &rhs) const
        {
            return (int)((ll)x * rhs.x % _mod);
        }
        constexpr inline modint &operator+=(const modint &rhs)
        {
            x += rhs.x;
            if (x >= _mod)
                x -= _mod;
            return *this;
        }
        constexpr inline modint &operator-=(const modint &rhs)
        {
            x -= rhs.x;
            if (x < 0)
                x += _mod;
            return *this;
        }
        constexpr inline modint &operator*=(const modint &rhs)
        {
            x = (int)((ll)x * rhs.x % _mod);
            return *this;
        }
        template <typename _G>
        constexpr inline modint operator^(_G rhs) const
        {
            modint a = x, res = 1;
            while (rhs)
            {
                if (rhs & 1)
                    res *= a;
                a *= a;
                rhs >>= 1;
            }
            return res;
        }
        constexpr inline modint inv() const
        {
            return *this ^ (_mod - 2);
        }
        constexpr inline modint operator/(const modint &rhs) const
        {
            return (*this) * rhs.inv();
        }
        constexpr inline modint &operator/=(const modint &rhs)
        {
            return (*this) *= rhs.inv();
        }
        constexpr inline bool operator==(const modint &rhs) const
        {
            return x == rhs.x;
        }
        constexpr inline bool operator!=(const modint &rhs) const
        {
            return x != rhs.x;
        }
        constexpr inline int &data()
        {
            return x;
        }
    };
}