
#include <iostream>
using namespace std;

void BuyCar(int* pnr, int* pbuy) {
    wcout << L"Enter nr:";
    wcin >> *pnr;
    wcout << L"Enter price:";
    wcin >> *pbuy;
}
void SellCar(int* pnr, int* psell) {
    wcout << L"Enter nr:";
    wcin >> *pnr;
    wcout << L"Enter price:";
    wcin >> *psell;
}
void FindProfit(int* pbuy, int* psell, int n) {
    int sum = 0;
    for (int i = 0; i < n; i++) {
        sum += (*(psell + i) - *(pbuy + i));
    }
    wcout << sum;
}
void ListCars(int* pnr, int* pbuy, int* psell, int n) {
    for (int i = 0; i < n; i++) {
        wcout << L"Carnr: " << *(pnr + i) << L" Price: " << *(pbuy + i) << L" SellPrice: " << *(psell + i) << endl;
    }
}
int FindIndex(int* pnr, int b, int length) {
    for (int i = 0; i < length; i++) {
        if (*(pnr + i) == b) {
            return i;
        }
    }
    return -1;
}

int main()
{
    int carnr[1000];
    int buyprice[1000];
    int sellprice[1000];
    int choice = 0;
    int idx = 0;

    do {
        wcout << endl << L"List of choises" << endl;
        wcout << L"1 Buy a car" << endl;
        wcout << L"2 Sell a car" << endl;
        wcout << L"3 Find the profit" << endl;
        wcout << L"4 List all the cars" << endl;
        wcout << L"5 Cleanup list (remove sold cars)" << endl;
        wcout << L"0 Quit" << endl;
        wcin >> choice;

        switch (choice) 
        {
            int nr, buy, sell;
            case 1: BuyCar(&nr, &buy);
                carnr[idx] = nr;
                buyprice[idx] = buy;
                sellprice[idx] = 0;
                idx++;
                break;
            case 2: SellCar(&nr, &sell);
                if (FindIndex(carnr, nr, idx) != -1) {
                    sellprice[FindIndex(carnr, nr, idx)] = sell;
                }
                else {
                    wcout << L"This car does not exist";
                }
                break;
            case 3: FindProfit(buyprice, sellprice, idx);
                break;
            case 4: ListCars(carnr, buyprice, sellprice, idx);
                break;
            case 5:
                main();

        }
    } while (choice!= 0);







}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file