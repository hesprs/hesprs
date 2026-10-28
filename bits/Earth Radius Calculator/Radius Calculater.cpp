#include <iostream>
#include <cmath>
using namespace std;
const double pi = 3.14159265359; // approximation of π
double lat1, lat2, lon1, lon2, d;

int main() {
    // inputting data
    cout << "Give the latitude of the first spot: ";
    cin >> d; lat1 = d / 180 * pi;
    cout << "Give the longitude of the first spot: ";
    cin >> d; lon1 = d / 180 * pi;
    cout << "Give the latitude of the second spot: ";
    cin >> d; lat2 = d / 180 * pi;
    cout << "Give the longitude of the second spot: ";
    cin >> d; lon2 = d / 180 * pi;
    cout << "Give the kilometre distance between two spots: ";
    cin >> d;

    double R = d / acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon1 - lon2)); // transformation of the formula
    cout << "Radius of the earth: " << R << " kilometers.";

    // remaining window
    cout<<" \n\nEnter any key to continue\n";
    cin >> d;
    return 0;
}