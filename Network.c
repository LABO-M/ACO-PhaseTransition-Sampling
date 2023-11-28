#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "random.h"

   /* How to use = ./a.out N r w  */ 
void main(int argc, char *argv[]);
void Network(int N, int r, double w, int *ki, int *ko, int *li);

void main(int argc, char *argv[])
{
  int i;
  int N; 
  int r;
  double w;
  int Ki[10001],Ko[10001],Li[10001][3];
  int seed;
  char filename[100];
  FILE *fp;

     /*   Initialization  */
     N=atoi(argv[1]);
     r=atoi(argv[2]);
     w=atof(argv[3]);
     
     printf("N=%d r=%d w=%lf \n",N,r,w);
     seed=1;
     srand(seed);
     Network(N,r,w,&Ki[0],&Ko[0],&Li[0][0]);
     for(i=0;i<=N;i++){
     printf("Node %d k_in:%d k_out:%d link1:%d link2:%d link3:%d\n",i,Ki[i],Ko[i],Li[i][0],Li[i][1],Li[i][2]);
     } 
     /*     
     sprintf(filename,"Net_N%d_r%1d_w%4.2lf.csv",N,r,w);
     fp=fopen(filename,"w");
     fprintf(fp,"i,K_in,k_out,Link1,Link2,Link3\n");
     for(i=0;i<=N;i++){
     fprintf(fp,"%d,%d,%d,%d,%d,%d\n",i,Ki[i],Ko[i],Li[i][0],Li[i][1],Li[i][2]);
     } 
     fclose(fp);
     */
    return;
}



void Network(int N, int r, double w, int *ki, int *ko, int *li)
{
  int k,n,m,l,Nc[10001];
  int Ki[10001],Ko[10001],Li[10001][3],linkable[10001];
  double pop[10001];
  double Z,x;
  
      /* Initial Condition */
  for(n=0;n<N;n++){
    Ki[n]=0;
    Ko[n]=0;
    for(k=0;k<r;k++){
      Li[n][k]=-1;
    }
  }
  for(n=0;n<=r;n++){
    Ki[n]=n;
    Ko[n]=(r-n);
    if(Ki[n]>0){
      for(k=0;k<Ki[n];k++){
        Li[n][k]=k;
      }
    }
    Nc[n]=Ki[n];
  }

  /* Evolution  */
  
  if(w>-1.0){  
  for(n=(r+1);n<=N;n++){
    Nc[n]=0;
    Z=0.0;
    for(m=0;m<n;m++){
      pop[m]= Ki[m]*1.0+w*Ko[m];
      if(pop[m]>0.0){
	linkable[Nc[n]]=m;
        Nc[n]++;
	Z+=pop[m];
      }
    }
    
    if(Nc[n]<=r){
      Ki[n]=Nc[n];
      for(m=0;m<Nc[n];m++){
	Li[n][m]=linkable[m];
	Ko[linkable[m]]++;
      }
    }   
    else{
      Ki[n]=r;
      for(m=0;m<r;m++){
      x=Uniform()*Z;
      l=0;
      while(x>0){
      x-=pop[linkable[l]];
      l++;
      }
      l=l-1;
      Li[n][m]=linkable[l];
      Ko[linkable[l]]++;
      Z-=pop[linkable[l]];
      pop[linkable[l]]=0.0;
      }
    }
  }	 
  }  /* if w>-1.0 */
  else{
  for(n=(r+1);n<=N;n++){
    Ki[n]=r;
    Ko[n]=0;
      for(k=0;k<r;k++){
        Li[n][k]=n-r+k;
        Ko[n-r+k]++;
      }
  }
  }  /* else loop  */  


  
   /* Result */
   for(n=0;n<=N;n++){
      *(ki+n)=Ki[n];
      *(ko+n)=Ko[n];
      for(k=0;k<r;k++){
      *(li+n*3+k)=Li[n][k];
      }
   }
  return;
}
 

