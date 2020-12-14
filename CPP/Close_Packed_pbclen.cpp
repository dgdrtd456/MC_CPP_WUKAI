#include<math.h>

float Close_Packed_pbclen(int nPart,float density, int length_width, int width, int ball_r)
{
    float pbc_length_3=(float(nPart)*3.1415926*(11.0/12*pow(float(width),3)+2.0/3*pow(float(ball_r),3))/density);
    if(pbc_length_3<0)
        return -pow(pbc_length_3, 1.0/3);
    else
        return pow(pbc_length_3, 1.0/3);
}
