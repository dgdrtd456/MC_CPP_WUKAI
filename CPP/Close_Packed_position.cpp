#include<math.h>
#include<vector>
#include<iostream>
#include<cstdlib>
#include<ctime>
#include<random>
using namespace std;
void Close_Packed_position(int nPart,float density,int length_width,int width, int ball_r)
{
    //std::vector<std::vector<float>> position_1; //origin position
    float pbc_length_3=(float(nPart)*3.1415926*(11.0/12*pow(float(width),3)+2.0/3*pow(float(ball_r),3))/density);
    int Lx=(length_width+0)*width;
    int Ly=(length_width+0)*width;
    int Lz=(length_width+0)*width;
    if (float(Lx*Ly*Lz)>=pbc_length_3)
    {
        std::cout<<"The density is too high, you need to adjust the size of the cell,return -1.0";
        // return position_1;
    }
    // calculate the center of cells
    // particle_index_1=randi(nn,2*nPart,3); 
    // 生成1到nn之间的  2*npart行 3列的矩阵   
    float pbc_length=pow(pbc_length_3, 1.0/3);
    int nn=int(pbc_length/Lx);
    //下面一行是启动随机数
    //srand((int)time(0));
    // 生成1到nn之间的  2*npart行 3列的矩阵  
    if(nn<=0)
    {
        std::cout<<"error,nn<=0;";
    }
    
    int position_index1[N][3];//对应于matlab程序中的particle_index_1
    default_random_engine e;
    uniform_int_distribution<unsigned> u(0,nn);
    
    for(int i=0;i<2*nPart;i++) //从行开始遍历
        for(int j=0;j<3;j++)    // col 0,1,2
            position_index1[i][j]=u(e);

    for(int i=0;i<nPart;i++) //从行开始遍历,对应于这个程序语句 position=(particle_index_2-1)*Lx+0.5*Lx;
        for(int j=0;j<3;j++)    // col 0,1,2
            position[i][j]=float(position_index1[i][j]-0.5)*float(Lx);



}



