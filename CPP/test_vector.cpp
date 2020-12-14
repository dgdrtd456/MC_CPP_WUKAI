#include<iostream>
#include<algorithm>
#include<vector>
using namespace std;
int main()
{

    vector<vector<double> > close_pac;
    vector<double> temp;
    temp.push_back(1.1);
    temp.push_back(2.1);
    temp.push_back(3.3);
    close_pac.push_back(temp);
    temp.clear();
    temp.push_back(4.23);
    temp.push_back(5.2324);
    temp.push_back(6.33);
    close_pac.push_back(temp);
    for(int i = 0; i < close_pac.size();i++)   
        for(int j=0;j<close_pac[0].size();j++)
            cout<<close_pac[i][j]<<endl;

    struct
}