#include <bits/stdc++.h>
using namespace std;

ofstream fout;
ifstream fin;
string toBinary(int n)
{
    string r;
    while (n != 0)
    {
        r += (n % 2 == 0 ? "0" : "1");
        n /= 2;
    }
    return r;
}

int main()
{
    int n;
    while (fin >> n)
    {
        cout << "out1: " << n << endl;
    }
    return 0;
}