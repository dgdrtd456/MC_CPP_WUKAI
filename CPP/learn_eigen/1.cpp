#include"D:/WUKAI/CPP/eigen-3.3.9/Eigen/Core"
#include<iostream>
int main()
{
  int size = 50;
  // VectorXf is a vector of floats, with dynamic size.
  Eigen::VectorXf u(size), v(size), w(size);
  u = v + w;
  std::cout<<u<<std::endl;
}