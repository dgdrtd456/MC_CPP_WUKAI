#include <math.h>
#include<iostream>
#include<stdio.h>
#include<random>
using namespace std;

float Close_Packed_position(int nPart,float density, int length_width, int width, int ball_r)
{
    float pbc_length_3=(float(nPart)*3.1415926*(11.0/12*pow(float(width),3)+2.0/3*pow(float(ball_r),3))/density);
    if(pbc_length_3<0)
        return -pow(pbc_length_3, 1.0/3);
    else
        return pow(pbc_length_3, 1.0/3);
}

const int N=1000;
float st[N][3];
int M;
void init(float sst[][3])
{
    for(int i=0;i<M;i++)
        for(int j=0;j<3;j++)
        {
            sst[i][j]=float(i*j);
        }
}
int main()
{
    M=100;
    init(st);
    // random_device rd; // 真随机数生成器（但有些编译器没有实现），用于生成伪随机数生成器的种子
    // mt19937 eng(rd()); // 使用梅森旋转法作为伪随机数生成器，随机程度较好
    // uniform_int_distribution<int> dis(10, 20); // 10到20之间的整数均匀分布

    default_random_engine e;
    uniform_int_distribution<unsigned> u(0,100);
    for(int i=0;i<100;i++)
        cout<<u(e)<<endl;

    // for(int i=0;i<10;i++)
    //     cout<<dis(eng)<<endl;


}