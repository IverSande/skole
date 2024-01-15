#include <iostream>

int Myfunction(wchar_t* p){
    int i = 0;
    for (; *p; p++) {
        i++;
    }
    return i;
}

int CountDoubleChars(wchar_t* pch) {
    int counter = 0;
    for (int i = 0; i < wcslen(pch); i++) {
        if (pch[i] == pch[i + 1]) {
            counter++;
            i++;
        }
    }
    return counter;
}

int main()
{
    wchar_t buffer[25];
    std::wcout << "Hello World!\n";
    std::wcin >> buffer;

    int thisThing = Myfunction(buffer);
    int thisThing2 = CountDoubleChars(buffer);

    std::wcout << L"The length of what you typed is " << thisThing << "\n";
    std::wcout << L"amount of double chars " << thisThing2;

}


