.featureDataRequiredColumns <- function(featureData, columns) {
    msg     <- NULL
    absent  <- columns[!(columns %in% rownames(varMetadata(featureData)))]
    if (length(absent) != 0) {
        msg <- paste(msg, paste("missing columns' ", absent ,"' in featureData" , sep = "", collapse = "\n\t"), sep="\n")
    }
    if (is.null(msg)) TRUE else msg
}

.makeEmptyFeatureData <- function(object) {
    dims        <- Biobase:::assayDataDims(object)
    n           <- dims[1,1]
    features    <-         
    if (is(object, "environment")) ls(object)
    else names(object)
    nms         <- rownames(object[[features[[1]]]])
    data        <- data.frame(Chromosome=numeric(n), Start=numeric(n), End=numeric(n), row.names=nms)
    dimLabels   <- c("featureNames", "featureColumns")
    metadata    <- data.frame(labelDescription=c("Chromosomal position", "Basepair position start", "Basepair position end"), row.names=c("Chromosome", "Start", "End"))
    new("AnnotatedDataFrame", data=data, dimLabels=dimLabels, varMetadata=metadata)                  
}

.makeEmptyFeatureDataForRegions <- function(object) {
    dims        <- Biobase:::assayDataDims(object)
    n           <- dims[1,1]
    features    <-         
    if (is(object, "environment")) ls(object)
    else names(object)
    nms         <- rownames(object[[features[[1]]]])
    data        <- data.frame(Chromosome=numeric(n), Start=numeric(n), End=numeric(n), Nclone=numeric(n), AveDist=numeric(n), row.names=nms)
    dimLabels   <- c("featureNames", "featureColumns")
    metadata    <- data.frame(  labelDescription=c("Chromosomal position", 
                                                    "Basepair position start", 
                                                    "Basepair position end", 
                                                    "Number of clones in region", 
                                                    "Average distance"), 
                                row.names=c("Chromosome", 
                                            "Start", 
                                            "End",
                                            "Nclone",
                                            "AveDist")
                                )
    new("AnnotatedDataFrame", data=data, dimLabels=dimLabels, varMetadata=metadata)                  
}

.makeSegments <- function(data,chrdata) {
    previous    <- 2000
    chrpr       <- -100
    values      <- c()
    start       <- c()
    end         <- c()
    el          <- length(data)
    data <- c(data,-10000) #add value to allow data[i+1]
    for (i in 1:el) {
        if ((data[i] != previous & previous != data[i+1]) | chrdata[i] != chrpr) { #bug repaired 12/06/09
            start   <- c(start, i)
            last    <- i - 1
            if (last > 0) end <- c(end, last)
            values  <- c(values, data[i])
        }
        previous    <- data[i]
        chrpr <- chrdata[i]
    }
    end     <- c(end, el)
    result  <- cbind(values, start, end)
    result
}

.getCentromere <- function(build) {
    build <- as.integer(gsub('[^0-9]', '', build))
    centromere <- matrix(NA, 23, 2);
    if (build == 34 || build == 16) {
        centromere[1,] <- c(120093537, 122333537)
        centromere[2,] <- c(91810927, 94810927)
        centromere[3,] <- c(90425755, 93325755)
        centromere[4,] <- c(49575659, 52575659)
        centromere[5,] <- c(46451142, 49451142)
        centromere[6,] <- c(58877002, 61877002)
        centromere[7,] <- c(57832528, 60832528)
        centromere[8,] <- c(43856263, 46856263)
        centromere[9,] <- c(44443361, 47443361)
        centromere[10,] <- c(39208941, 41588941)
        centromere[11,] <- c(51602318, 54602318)
        centromere[12,] <- c(34747961, 36142961)
        centromere[13,] <- c(14900000, 16768000)
        centromere[14,] <- c(15070000, 18070000)
        centromere[15,] <- c(15260000, 18260000)
        centromere[16,] <- c(36366889, 38166889)
        centromere[17,] <- c(22408570, 25408570)
        centromere[18,] <- c(15398887, 16762885)
        centromere[19,] <- c(26923622, 29923622)
        centromere[20,] <- c(26314569, 29314569)
        centromere[21,] <- c(10260000, 13260000)
        centromere[22,] <- c(11330000, 14330000)
        centromere[23,] <- c(57548803, 60548803)
        # centromere[24,] <- c(9757849, 12757849)
    } else if (build == 35 || build == 17) {
        centromere[1,] <- c(121147476, 123387476)
        centromere[2,] <- c(91748045, 94748045)
        centromere[3,] <- c(90587544, 93487544)
        centromere[4,] <- c(49501045, 52501045)
        centromere[5,] <- c(46441398, 49441398)
        centromere[6,] <- c(58938125, 61938125)
        centromere[7,] <- c(57864988, 60864988)
        centromere[8,] <- c(43958052, 46958052)
        centromere[9,] <- c(46035928, 49035928)
        centromere[10,] <- c(39244941, 41624941)
        centromere[11,] <- c(51450781, 54450781)
        centromere[12,] <- c(34747961, 36142961)
        centromere[13,] <- c(16000000, 17868000)
        centromere[14,] <- c(15070000, 18070000)
        centromere[15,] <- c(15260000, 18260000)
        centromere[16,] <- c(35143302, 36943302)
        centromere[17,] <- c(22187133, 22287133)
        centromere[18,] <- c(15400898, 16764896)
        centromere[19,] <- c(26923622, 29923622)
        centromere[20,] <- c(26267569, 28033230)
        centromere[21,] <- c(10260000, 13260000)
        centromere[22,] <- c(11330000, 14330000)
        centromere[23,] <- c(58465033, 61465033)
        # centromere[24,] <- c(11237315, 12237315)
    } else if (build == 36 || build == 18) {
        centromere[1,] <- c(121236957, 123476957)
        centromere[2,] <- c(91689898, 94689898)
        centromere[3,] <- c(90587544, 93487544)
        centromere[4,] <- c(49354874, 52354874)
        centromere[5,] <- c(46441398, 49441398)
        centromere[6,] <- c(58938125, 61938125)
        centromere[7,] <- c(58058273, 61058273)
        centromere[8,] <- c(43958052, 46958052)
        centromere[9,] <- c(47107499, 50107499)
        centromere[10,] <- c(39244941, 41624941)
        centromere[11,] <- c(51450781, 54450781)
        centromere[12,] <- c(34747961, 36142961)
        centromere[13,] <- c(16000000, 17868000)
        centromere[14,] <- c(15070000, 18070000)
        centromere[15,] <- c(15260000, 18260000)
        centromere[16,] <- c(35143302, 36943302)
        centromere[17,] <- c(22187133, 22287133)
        centromere[18,] <- c(15400898, 16764896)
        centromere[19,] <- c(26923622, 29923622)
        centromere[20,] <- c(26267569, 28033230)
        centromere[21,] <- c(10260000, 13260000)
        centromere[22,] <- c(11330000, 14330000)
        centromere[23,] <- c(58598737, 61598737)
    } else if (build == 37 || build == 19) { # 37 / 19
        centromere[1,] <- c(121535434, 124535434)
        centromere[2,] <- c(92326171, 95326171)
        centromere[3,] <- c(90504854, 93504854)
        centromere[4,] <- c(49660117, 52660117)
        centromere[5,] <- c(46405641, 49405641)
        centromere[6,] <- c(58830166, 61830166)
        centromere[7,] <- c(58054331, 61054331)
        centromere[8,] <- c(43838887, 46838887)
        centromere[9,] <- c(47367679, 50367679)
        centromere[10,] <- c(39254935, 42254935)
        centromere[11,] <- c(51644205, 54644205)
        centromere[12,] <- c(34856694, 37856694)
        centromere[13,] <- c(16000000, 19000000)
        centromere[14,] <- c(16000000, 19000000)
        centromere[15,] <- c(17000000, 20000000)
        centromere[16,] <- c(35335801, 38335801)
        centromere[17,] <- c(22263006, 25263006)
        centromere[18,] <- c(15460898, 18460898)
        centromere[19,] <- c(24681782, 27681782)
        centromere[20,] <- c(26369569, 29369569)
        centromere[21,] <- c(11288129, 14288129)
        centromere[22,] <- c(13000000, 16000000)
        centromere[23,] <- c(58632012, 61632012)
        # centromere[24,] <- c(10104553, 13104553)
    } else { # hg38 from http://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/
        centromere[1,] <- c(122026459, 124932724)
        centromere[2,] <- c(92188145, 94090557)
        centromere[3,] <- c(90772458, 93655574)
        centromere[4,] <- c(49712061, 51743951)
        centromere[5,] <- c(46485900, 50059807)
        centromere[6,] <- c(58553888, 59829934)
        centromere[7,] <- c(58169653, 61528020)
        centromere[8,] <- c(44033744, 45877265)
        centromere[9,] <- c(43389635, 45518558)
        centromere[10,] <- c(39686682, 41593521)
        centromere[11,] <- c(51078348, 54425074)
        centromere[12,] <- c(34769407, 37185252)
        centromere[13,] <- c(16000000, 18051248)
        centromere[14,] <- c(16000000, 18173523)
        centromere[15,] <- c(17083673, 19725254)
        centromere[16,] <- c(36311158, 38265669)
        centromere[17,] <- c(22813679, 26616164)
        centromere[18,] <- c(15460899, 20861206)
        centromere[19,] <- c(24498980, 27190874)
        centromere[20,] <- c(26436232, 30038348)
        centromere[21,] <- c(10864560, 12915808)
        centromere[22,] <- c(12954788, 15054318)
        centromere[23,] <- c(58605579, 62412542)
        # centromere[24,] <- c(10316944, 10544039)
    }
    centromere <- apply(centromere, 1, mean);
    return(centromere);
}


.getChromosomeLengths <- function(build) {
    build <- as.integer(gsub('[^0-9]', '', build))
    if (build == 34 || build == 16) {
       chromosome.lengths <- c(246127941, 243615958, 199344050, 191731959, 181034922, 170914576, 158545518, 146308819, 136372045, 135037215, 134482954, 132078379, 113042980, 105311216, 100256656, 90041932, 81860266, 76115139, 63811651, 63741868, 46976097, 49396972, 153692391, 50286555)
    } else if (build == 35 || build == 17) {
       chromosome.lengths <- c(245522847, 243018229, 199505740, 191411218, 180857866, 170975699, 158628139, 146274826, 138429268, 135413628, 134452384, 132449811, 114142980, 106368585, 100338915, 88827254, 78774742, 76117153, 63811651, 62435964, 46944323, 49554710, 154824264, 57701691)
    } else if (build == 36 || build == 18) {
       chromosome.lengths <- c(247249719, 242951149, 199501827, 191273063, 180857866, 170899992, 158821424, 146274826, 140273252, 135374737, 134452384, 132349534, 114142980, 106368585, 100338915, 88827254, 78774742, 76117153, 63811651, 62435964, 46944323, 49691432, 154913754, 57772954)
    } else if (build == 37 || build == 19){
       chromosome.lengths <- c(249250621, 243199373, 198022430, 191154276, 180915260, 171115067, 159138663, 146364022, 141213431, 135534747, 135006516, 133851895, 115169878, 107349540, 102531392, 90354753, 81195210, 78077248, 59128983, 63025520, 48129895, 51304566, 155270560, 59373566)
    } else {
       chromosome.lengths <- c(248956422, 242193529, 198295559, 190214555, 181538259, 170805979, 159345973, 145138636, 138394717, 133797422, 135086622, 133275309, 114364328, 107043718, 101991189, 90338345, 83257441, 80373285, 58617616, 64444167, 46709983, 50818468, 156040895, 57227415)
    }
    names(chromosome.lengths) <- 1:24
    chromosome.lengths
}

.convertChromosomeToArm <- function(dataframe, build) { #changed 22/06/2009; 
    cat("Dividing chromosomes into arms using centromere positions from", build, "\n\n");
    centromere  <- .getCentromere(build);
    chr <- dataframe[,2]
    bp <- dataframe[,3]
    chrlev <- unique(chr)
    a<-1
    chrarms <- c()
    for(i in chrlev){
    print(i)
    chri <- which(chr==i)
    bpi <- bp[chri]
    wbpi <- length(which(bpi<=centromere[i]))
    wbpil <- length(which(bpi>centromere[i]))
    if(wbpi>0) {chrarms <- c(chrarms,rep(a,wbpi));a<-a+1}
    if(wbpil>0) {chrarms <- c(chrarms,rep(a,wbpil));a<-a+1}  
    }  
    dataframe[,2] <- chrarms
    return(dataframe)
}
