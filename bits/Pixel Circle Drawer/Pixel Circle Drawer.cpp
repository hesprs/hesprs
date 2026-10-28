#include <bits/stdc++.h>
using namespace std;
vector<int> l;
int main() {
    while (true) {
        cout << "Please type in the diameter as a positive integer: ";
        string temp;
        getline(cin, temp);
        const int d = stoi(temp);
        if (to_string(d) != temp || d <= 0) {
            cout << "Invalid input!" << endl << "----------------------------" << endl;
            continue;
        }
        const double w = d / 2.0;
        const double z = fmod(w, 1) + 0.5;
        const int y = d % 2;
        const int x = floor(w);
        l.push_back(d);
        while ((double)size(l) - z + 0.5 < l[size(l) - 1] / 2) {
            l.push_back(l[size(l) - 1]);
            while ((w + size(l) - z) * (w - size(l) + z) < pow((l[size(l) - 1] / 2 - 0.5), 2)) l[size(l) - 1] -= 2;
        }
        int c = size(l);
        for (int a = 0; a < x + y - c; a++) {
            l.push_back(y);
            for (int b = 0; b < c - y; b++) {
                if (l[b + y] - 2 * c + y - 2 * a >= 2) l[size(l) - 1] += 2;
            }
        }
        int S = 0;
        for (const auto& a : l) S += 2 * a;
        S -= y * d;
        cout << "Area of the pixel circle: " << S << '.' << endl;
        reverse(l.begin(), l.end());
        const int g = size(l);
        for (int a = 0; a < g - y; a++) l.push_back(l[size(l) - 1 - 2 * a - y]);
        cout << "The chord lengths of the pixel circle: ";
        for (int a = 0; a < size(l); a++) {
            if (a + 1 != size(l)) cout << l[a] << ", ";
            else cout << l[a] << '.' << endl;
        }
        for (const auto& a : l) {
            for (int b = 0; b < (d - a) / 2; b++) cout << "  ";
            for (int b = 0; b < a; b++) cout << "■ ";
            cout << endl;
        }
        cout << "----------------------------" << endl;
        l.clear();
    }
    return 0;
}