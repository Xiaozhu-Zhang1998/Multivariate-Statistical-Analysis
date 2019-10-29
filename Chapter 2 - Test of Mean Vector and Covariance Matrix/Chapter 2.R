## ��������
X=read.table("clipboard",header=T)
## ----------------------------------------
library(mvnormtest)

## ����ÿһ�������Ƿ������̬�ֲ�
par(mfrow=c(4,2))
for(i in 4:11){
  k1=mshapiro.test(t(X[,i]))
  qqnorm(X[,i])
    if(k1$p.value>0.05){
    print(list(i-3,k1$p.value))
  }
}

## ���ڷ�����̬�ֲ��ĵ��������������������Ƿ������̬�ֲ�
mshapiro.test(t(X[,c(4,5,6,10)]))
## 4���������ɵ�������������̬�ֲ�

## ����3���������ɵ������Ƿ������̬�ֲ�
for(i in c(4,5,6,10)){
  for(j in c(5,6,10)){
    for(k in c(6,10)){
      if(i<j && j<k){
        te=mshapiro.test(t(X[,c(i,j,k)]))
        if(te$p.value>0.05){
          print(list(c(i-3,j-3,k-3),te$p.value))
        }
      }
    }
  }
}

## �õ�������������������̬�ֲ�

## ----------------------------------------
## ���з������Լ���(�Ա����)

## attach(X)
r=3
G1 <- subset(X,"��ҵ"=="������ú����ˮ�������͹�Ӧҵ")
G2 <- subset(X,"��ҵ"=="������ҵ")
G3 <- subset(X,"��ҵ"=="��Ϣ����ҵ")
n1=nrow(G1)
n2=nrow(G2)
n3=nrow(G3)
n=n1+n2+n3

cov.test <- function(p,nr){ #����c(�����������,����������(����))
  nr=nr+3
  L1=(n1-1)*cov(G1[,nr])
  L2=(n2-1)*cov(G2[,nr])
  L3=(n3-1)*cov(G3[,nr])
  L=L1+L2+L3
  
  ## ����Mͳ����
  A=(n-r)*log(exp(1),det(L/(n-r)))
  B1=(n1-1)*log(exp(1),det(L1/(n1-1)))
  B2=(n2-1)*log(exp(1),det(L2/(n2-1)))
  B3=(n3-1)*log(exp(1),det(L3/(n3-1)))
  M=A-B1-B2-B3
  ## Ѱ�ҷֲ�
  if(n1==n2 && n2==n3){
    d1=(2*p^2+3*p-1)*(r-1)/(6*(p+1)*r*(n-1)) 
    d2=(p-1)*(p+2)*(r^2+r+1)/(6*r^2*(n-1)^2)
  }
  
  if(n1!=n2 || n1!=n3 || n2!=n3){
    d1=(2*p^2+3*p-1)/(6*(p+1)*(r-1))*(1/(n1-1)+1/(n2-1)+1/(n3-1)-1/(n-r)) 
    d2=(p-1)*(p+2)/(6*(r-1))*(1/(n1-1)^2+1/(n2-1)^2+1/(n3-1)^2-1/(n-r)^2)
  }
  
  f1=p*(p+1)*(r-1)/2
  f2=(f1+2)/(d2-d1^2)
  b=f1/(1-d1-f1/f2)
  FS=M/b
  pvalue=pf(FS,f1,f2,ncp=0,lower.tail=FALSE,log.p=FALSE)
  list("M"=M,"b"=b,"p-value"=pvalue)
}

cov.test(3,c(1,2,3))
cov.test(3,c(1,3,7))

## ----------------------------------------
## �������
## ��Ԫ�������
attach(X)
aggregate(cbind(���ʲ�������,���ʲ�������,�ʲ���ծ��,����������),by=list(��ҵ),FUN=mean)

y.1 <- as.data.frame(cbind(��ҵ,���ʲ�������,���ʲ�������,�ʲ���ծ��))
type1 <- as.factor(y.1$��ҵ)
fit1 <- manova(cbind(���ʲ�������,���ʲ�������,�ʲ���ծ��)~type1,data=y.1)
summary(fit1,test=c("Wilks"))

y.2 <- as.data.frame(cbind(��ҵ,���ʲ�������,�ʲ���ծ��,����������))
type2 <- as.factor(y.2$��ҵ)
fit2 <- manova(cbind(���ʲ�������,�ʲ���ծ��,����������)~type2,data=y.2)
summary(fit2,test=c("Wilks"))

## �����ط������
y.3 <- as.data.frame(cbind(��ҵ,���ʲ�������,���ʲ�������,�ʲ���ծ��,����������))
type3 <- as.factor(y.3$��ҵ)
fit3 <- manova(cbind(���ʲ�������,���ʲ�������,�ʲ���ծ��,����������)~type3)
summary.aov(fit3)

## �º�Ƚ�
library(agricolae)
back.test <- function(i){
  attach(X)
  fit <- aov(i~��ҵ,data=X)
  #bonferroni����
  out.LSD <- LSD.test(fit,"��ҵ",p.adj="bonferroni")
  #SNK����
  out.SNK <- SNK.test(fit,"��ҵ")
  #TukeyHSD����
  out.TUK=TukeyHSD(fit)
  #Scheffe����
  out.SHF <- scheffe.test(fit,"��ҵ")
  
  par(mfrow=c(2,2))
  plot(out.LSD)
  plot(out.SNK)
  plot(out.TUK)
  plot(out.SHF)
  list(LSD=out.LSD$group,SNK=out.SNK$group,TUK=out.TUK$��ҵ,SHF=out.SHF$group)
}

back.test(���ʲ�������)
back.test(���ʲ�������)