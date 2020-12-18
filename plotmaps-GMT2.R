#----------------------------------------------------------------
# FUNCTION using GMT (modified Anders Nielsen's function 'plotmap'
# allowing overplotting on the map, showing the coastline and grid)
#----------------------------------------------------------------
plotmap1<-function (x1, x2, y1, y2, resolution = 3, grid = FALSE, add = FALSE,
    save = FALSE, landcolor = rgb(0.7,0.7,0.7,0), seacolor = rgb(1,1,1,0),
    #save = FALSE, landcolor = rgb(0.85,0.82,0.66), seacolor = rgb(1,1,1,0),
    #save = FALSE, landcolor = rgb(0.85,0.82,0.66), seacolor = "white",
    zoom = FALSE, coastline=TRUE, coastcolor=1)
    #zoom = FALSE, coastline=TRUE, coastcolor=rgb(0.37,0.35,0.3))
{
    #comment: GMT coastline doesn't work properly for WW negative coordinates
    if ((x1<0) & (x2<0)) {x1<-x1+360; x2<-x2+360}

    gmt <- function(x1, x2, y1, y2, resolution = 3) {
        read.ps.line <- function(txt) {
            txt.split <- strsplit(txt, split = " ")[[1]]
            ret <- c(NA, NA)
            if (length(txt.split) == 3) {
                if (txt.split[3] %in% c("M", "moveto", "D")) {
                  ret <- as.numeric(txt.split[1:2])
                }
            }
            return(ret)
        }
        if (resolution < 1 || resolution > 5)
            stop("resolution from 1 (full) to 5(crude)")
        res <- c("f", "h", "i", "l", "c")[resolution]
        filen <- tempfile("gmtmap")
        on.exit(unlink(c(filen, ".gmtcommands4")))
        #cmd <- paste("pscoast -R",x1,"/",x2,"/",y1,"/",y2, " -Jx1id -P -G -D", res, " -X0 -Y0 >", filen,sep = "")
        cmd <- paste("pscoast -R",x1,"/",x2,"/",y1,"/",y2, " -Jx2id -P -G -D", res, " -X0 -Y0 >", filen,sep = "")
        #cmd <- paste("pscoast -R",x1,"/",x2,"/",y1,"/",y2, " -Jx2id -P -G -D", res, " -X0 -Y0 >", filen,sep = "")
        system(cmd)
        
        txt <- readLines(filen); 
        mat <- matrix(unlist(lapply(txt, read.ps.line)), ncol = 2,
            byrow = TRUE)
        for (i in 2:nrow(mat)) {
            if (!is.na(mat[i, 1]) & !is.na(mat[i - 1, 1]))
                mat[i, ] <- mat[i, ] + mat[i - 1, ]
        }
        maxx <- max(mat[, 1], na.rm = TRUE)
        maxy <- max(mat[, 2], na.rm = TRUE)
        mat[, 1] <- mat[, 1]/600 + x1
        mat[, 2] <- mat[, 2]/600 + y1
        return(mat)
    }
    junk <- gmt(x1, x2, y1, y2, resolution = resolution)
    if (!add) {
        plot(c(x1, x2), c(y1, y2), type = "n", ylab = "", xlab = "",
            xaxs = "i", yaxs = "i",asp=1,axes=FALSE)
            #xaxs = "i", yaxs = "i",xaxt="n",yaxt="n")
            #,xaxt="n",yaxt="n",axes=FALSE)
        rect(x1, y1, x2, y2, col = seacolor,xaxs = "i", yaxs = "i",asp=1)
        if (grid) {
            axis(1, tck = 1, labels=FALSE,lwd=0.3) # no ugly labels
            axis(2, tck = 1, labels=FALSE,lwd=0.3)
        }
    }
    polygon(junk, border = landcolor, col = landcolor)
    if (zoom) {
        ret <- locator(2)
        if (length(ret$x) < 2) {
            zoom <- FALSE
        }
        else {
            x1 <- min(ret$x)
            x2 <- max(ret$x)
            y1 <- min(ret$y)
            y2 <- max(ret$y)
        }
        plotmap1(x1, x2, y1, y2, resolution, grid, add, save,landcolor, seacolor, zoom)
    }
    if (save) {
        dimnames(junk)[[2]] <- c("longitude", "latitude")
        return(junk)
    }
   # add coastline
   if (coastline){
    filen <- tempfile("gmtmap") ;  on.exit(unlink(c(filen, ".gmtcommands4")))
    res <- c("f", "h", "i", "l", "c")[resolution]
    #cmd <- paste("pscoast -R",x1,"/",x2,"/",y1,"/",y2," -Jx1id -W -M  -D",res," >",filen,sep="")
    cmd <- paste("pscoast -R",x1,"/",x2,"/",y1,"/",y2," -Jx2id -W -M  -D",res," >",filen,sep="")
    system(cmd)
    dat <- readLines(filen);
    ff<-function(str)if(regexpr("#",str)>0){
      c(NA, NA)
    }else{
      as.numeric(strsplit(str, split="\t")[[1]])
    }
    lines(t(sapply(dat, ff)),col=coastcolor)
   }
}

addcoast<-function(resolution=3, coastcolor=rgb(0.37,0.35,0.3),...) {
  # ----------------------------------------------------------------------------
  # "THE BEER-WARE LICENSE":
  # <anders.nielsen@hawaii.edu> wrote this file. As long as you retain this notice you
  # can do whatever you want with this stuff. If we meet some day, and you think
  # this stuff is worth it, you can buy me a beer in return. Anders Nielsen
  # ----------------------------------------------------------------------------

    usr<-par("usr"); x1<-usr[1]; x2<-usr[2]; y1<-usr[3]; y2<-usr[4];
    filen <- tempfile("gmtmap") ;  on.exit(unlink(c(filen, ".gmtcommands4")))
    res <- c("f", "h", "i", "l", "c")[resolution]
    #cmd <- paste("pscoast -R",x1,"/",x2,"/",y1,"/",y2," -Jx1id -W -M  -D",res," >",filen,sep="")
    cmd <- paste("pscoast -R",x1,"/",x2,"/",y1,"/",y2," -Jx2id -W -M  -D",res," >",filen,sep="")
    system(cmd)
    dat <- readLines(filen);
    ff<-function(str)if(regexpr("#",str)>0){
      c(NA, NA)
    }else{
      as.numeric(strsplit(str, split="\t")[[1]])
    }
    lines(t(sapply(dat, ff)),col=coastcolor)
}


Wpos<-function(x){
  #return(x-180*(x/abs(x)-1))# div by 0!
  return(ifelse(x<0,x+360,x))
}

Wneg<-function(x){
  #return(x-180*(abs(x-180)/(x-180)+1)) # div by 0!
  return(ifelse(x>180,x,x))
  #return(ifelse(x>180,x-360,x))
}

nice.map<-function(X,Y,resolution=5,grid=TRUE,col=rgb(0.4,0.4,0.4,1)){
#nice.map<-function(X,Y,resolution=5,grid=TRUE,col=rgb(0.85,0.82,0.66)){
  #----------------------------------------------
  # MAP LABELS
  #----------------------------------------------
  xlabels<-pretty(X); ylabels<-pretty(Y)
  #xlabnames<-ifelse(Wneg(xlabels)>=0,parse(text=paste(xlabels,"^o * E",sep="")),parse(text=paste((-Wneg(xlabels)),"^o * W",sep="")))
  xlabnames<-parse(text=paste(xlabels,"^o * E",sep=""))
  ylabnames<-ifelse(ylabels<0,parse(text=paste(abs(ylabels),"^o * S",sep="")),parse(text=paste(ylabels,"^o * N",sep=""))); ylabnames<-ifelse(ylabels==0,parse(text=paste(abs(ylabels),"^o",sep="")),ylabnames)


  par(cex.axis=1.0,tck=-0.01)
  #par(cex.axis=1.0,tck=-0.01,mgp=c(0.2,0.5,0.2))
  #par(mar=c(2,4,4,4),cex.axis=1.0,tck=-0.01,mgp=c(0.2,0.5,0))
  plotmap1(X[1],X[length(X)],Y[1],Y[length(Y)],res=resolution,grid,landcolor=col)
  box(lwd=2.0)
  #comment: GMT coastline doesn't work properly for WW negative coordinates (see plotmap1 function above)
  #if (all(X<0)) {axis(1,at=Wpos(xlabels),lab=xlabnames); axis(3,at=Wpos(xlabels),lab=xlabnames)}
  #else {axis(1,lab='');axis(3,lab='')}
  #axis(2,lab='',las=1);axis(4,lab='',las=1)
  #else {axis(1,at=xlabels,lab=xlabnames);axis(3,at=xlabels,lab=xlabnames)}
  #axis(2,at=ylabels,lab=ylabnames,las=1);axis(4,at=ylabels,lab=ylabnames,las=1)
}

#----------------------------------------------
# REGION of the map
#----------------------------------------------
 #X<--90:-40;Y=25:45; 
 #jpeg("map.jpg",width=1200,height=600)
 #pdf("map.pdf",width=11,height=6)
 #nice.map(X,Y,5)
 #dev.off()


