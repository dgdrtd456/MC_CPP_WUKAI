const int N=300; //这个数要大于等于nparticle*2;
const int n_step=1e6;
float position[N][3];//全局数组，存储position的三位坐标
float angle_t[N][3];//定义新的全局数组，angle_t=zeros(n_particle,3); % initial angle
float npoint_coord[N][9];//npoint_coord=zeros(n_particle,9);%each particle has 3 points to discribe it
float conformational_state[N][1];//conformational_state=zeros(n_particle,1);% 0 refer to coil state;1 refer to beta state
float trans[n_step][N/2];
#include "Close_Packed_pbclen.cpp"
#include "Close_Packed_position.cpp"
#include<iostream>
#include<random>
#include <typeinfo>
using namespace std;



int M;             

int main()
{
    // default_random_engine e;
    // uniform_int_distribution<unsigned> u(0,100);
    // for(int i=0;i<100;i++)
    //     cout<<u(e)<<endl;
    int nPart=130,length_width=4,width=2,ball_r=0,total_length=8;//对应于n_particle
    float density=0.01;
    Close_Packed_position(nPart,density, length_width,width,ball_r);
    cout<<Close_Packed_pbclen(nPart,density, length_width,width,ball_r)<<endl;
    
    int interaction_aa=8,interaction_bb=9,interaction_cc=30,energy_penal=20,energy_i=0;
    float coord[9]={-4.0,0.0,0.0,4.0,0.0,0.0,0.0,0.0,1.0};
    
    float maxDr=0.05,pbc_length=26.0; //%to check whether collision or not, set pbc_length=1


    for(int i=0;i<nPart;i++)//总共nPart行，从0到nPart-1行。9列，0-8.
        for(int j=0;j<9;j++)
        {
            npoint_coord[i][j]=coord[j]+position[i][j%3];
        }

    //MC random walk of two particles。
    float angle_dis[3];//angle_dis=5*(rand(3,1)-0.5)';%max displacement is 10 degree
    for(int i=0;i<n_step;i++)
        for(int j=0;j<nPart;j++)
        {

            default_random_engine e; 
            uniform_real_distribution<float> u(-2.5, 2.5); //生成0，1之间的一个随机数
            for(int k=0;i<3;i++) //注意这个循环里面的i已经被用掉了
                angle_dis[i]=u(e);

        }

    cout<<"finished"<<endl;
    // for(int i=0;i<60;i++)
    // {    for(int j=0;j<3;j++)
    //         cout<<npoint_coord[i][j]<<" ";
    //     cout<<endl;}
    // return 0;
    cout<<typeid(npoint_coord[3][4]).name() ;

    // default_random_engine e; 
    // uniform_real_distribution<float> u(0, 1); //生成0，1之间的一个随机数
    // for(int i=0;i<5;i++)
    //     cout<<u(e)<<endl;

}


