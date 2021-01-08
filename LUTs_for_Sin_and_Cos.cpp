#include <stdio.h>
#include <math.h>
#include <iostream>
#include <bitset>
using namespace std;
#define PI 3.14159265


void decimalToBinary(double num, int k_prec, string& binary)
{
    binary = "";

    // Fetch the integral part of decimal number 
    int Integral = num;

    // Fetch the fractional part decimal number 
    double fractional = num - Integral;

    // Conversion of integral part to 
    // binary equivalent 
    while (Integral)
    {
        int rem = Integral % 2;

        // Append 0 in binary 
        binary.push_back(rem + '0');

        Integral /= 2;
    }

    // Reverse string to get original binary 
    // equivalent 
    reverse(binary.begin(), binary.end());

    // Pad with zeros to create 16 bit whole part
    while (binary.size() < (k_prec / 2)) {
        binary.insert(0, "0");
    }

    // Append point before conversion of 
    // fractional part 
    binary.push_back('_');

    // Conversion of fractional part to 
    // binary equivalent 
    int rem = k_prec / 2;
    while (rem--)
    {
        // Find next bit in fraction 
        fractional *= 2;
        int fract_bit = fractional;

        if (fract_bit == 1)
        {
            fractional -= fract_bit;
            binary.push_back(1 + '0');
        }
        else
            binary.push_back(0 + '0');
    }
}

void negate(string in, string& sNew) {
    sNew = "";
    bool invert = false;
    char s;
    for (int i = in.size() - 1; i >= 0; i--) {
        s = in[i];
        if (s == '_')
            sNew.push_back(s);
        else {
            if (!invert) {
                sNew.push_back(s);
                if (s == '1')
                    invert = true;
            }
            else {
                if (s == '0')
                    sNew.push_back('1');
                else if (s == '1')
                    sNew.push_back('0');
            }
        }
    }
    reverse(sNew.begin(), sNew.end());
}

// Driver code 
int main()
{
    string arr[90];
    string temp;
    string convert;

    for (int i = 0; i <= 180; i++)
    {
        double n = cos(i * PI / 180);
        int k = 32;

        if (i <= 90) {
            decimalToBinary(n, k, temp);
            if (i != 90) {
                negate(temp, convert);
                arr[89 - i] = convert;
            }
        }
        else
            temp = arr[i - 91];
        cout << "cos[" << i << "] = 32'b" << temp << ";" << endl;
    }

    cout << endl << endl << endl;

    for (int i = 0; i <= 180; i++)
    {
        double n = sin(i * PI / 180);
        int k = 32;

        if (i <= 90) {
            decimalToBinary(n, k, temp);
            if (i != 90) {
                arr[89 - i] = temp;
            }
        }
        else
            temp = arr[i - 91];
        cout << "sin[" << i << "] = 32'b" << temp << ";" << endl;
    }
}