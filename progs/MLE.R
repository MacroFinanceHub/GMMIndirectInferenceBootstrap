# Numerische ML-Sch�tzung der Parameter einer Normalverteilung

library(MASS)

# Definition der Loglikelihood-Funktion
logliknormal <- function(param,daten)
  {
  mu <- param[1]
  sigma2 <- param[2]
  return(sum(log(dnorm(daten,mean=mu,sd=sqrt(sigma2)))))
  }

# Parameter festlegen
n <- 100
mu <- 5
sigma2 <- 9

# Ziehung einer Stichprobe
x <- rnorm(n,mean=mu,sd=sqrt(sigma2))

# Optimierung der Loglikelihood
opt1 <- optim(c(0,1),logliknormal,control=list(fnscale=-1),hessian=TRUE,daten=x)

print(paste("Sch�tzwerte: ",opt1$par)) # Vektor der Sch�tzwerte
print("Hesse-Matrix:")
print(opt1$hessian) # Hesse-Matrix

estcov <- -solve(opt1$hessian) 
print("Gesch�tzte Kovarianzmatrix:")
print(estcov) # Gesch�tzte Kovarianzmatrix der Sch�tzwerte

print(paste("Standardfehler von muhat = ",sqrt(estcov[1,1])))
print(paste("Standardfehler von sigma2hat = ",sqrt(estcov[2,2])))


# Wie ist der ML-Sch�tzer muhat verteilt?

v <- rep(NA,10000)
for(i in 1:10000)
  {
  x <- rnorm(n,mean=mu,sd=sqrt(sigma2))
  opt1 <- optim(c(0,1),logliknormal,control=list(fnscale=-1),hessian=TRUE,daten=x)
  v[i] <- opt1$par[1]
  }
truehist(v)
g <- seq(min(v),max(v),length=300)
lines(g,dnorm(g,mean=mean(v),sd=sd(v)),col="red",lwd=3)