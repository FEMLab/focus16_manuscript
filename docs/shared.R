# shared functions

mytheme <- ggplot2::theme_minimal() + 
  ggplot2::theme(
    rect = element_rect(fill = "transparent"),
    #plot.background = element_rect(fill = "#FAFAFA", color=NA),
    plot.background = element_rect(fill = "transparent", color=NA),
    axis.text = element_text(size=8),
    strip.background = element_rect(fill = "grey95", color=NA),
    strip.text = element_text(face="bold"),
    axis.title  = element_text(size=10),
    panel.grid.minor.x = element_blank(),
    title = element_text(size=14),
    plot.caption=element_text(hjust = 0),
    legend.text =  element_text(size=12), 
    plot.subtitle = element_text(size=12, colour = "grey60"),
    #legend.position = "bottom"
  )

plot_mock <- function(df){
  #  used to generate plots of which runs yielded fruitful results
  #  See the plot_success section of the supplementary data script
  df <- df  %>%  arrange(pmessage) %>%
    group_by(strain) %>%
    mutate(thisid = row_number()) %>%
    transform(thisid = ifelse(is.na(messag), 0, thisid)) 
  df$strain <- factor(df$strain, levels=rev(levels(factor(df$strain))))
  
  # for coloring x/y axis
  alpha_info <-  rev(ifelse(df[!duplicated(df$strain), "globalmessage"]=="Success", "gray90", "gray60"))
  alpha_data <- df %>%
    group_by(strain) %>% 
    mutate(alpha = ifelse(globalmessage=="Success", "gray10", "gray70")) %>% 
    select(strain, alpha) %>% distinct() %>% as.data.frame()
  
  alpha_v <- alpha_data[order(alpha_data$strain, alpha_data$alpha), "alpha"]
  # put in original number of orrganisms, for plotting purposes()
  (p <- ggplot(df, aes(x=strain, y=thisid, shape=pmessage,
                       color=pmessage, fill=pmessage)) + 
      scale_shape_manual(guide = "legend", values = c(21, 22, 23,24, 25)) + 
      geom_point(size=5)  + coord_flip() + mytheme +
      scale_colour_brewer(palette = "Set2") +
      scale_fill_brewer(palette = "Set2") +
      # unfortuantely facet wrapping throws off our beautiful alpha'd out names
      # due to those repeated
      facet_wrap(~mock) +
      labs("SRAs Proccessed by focusDB",
           y="Number of whole-genome sequencing SRAs", x="", color="Per SRA", fill="Per SRA", shape="Per SRA")  +
      theme(axis.text=element_text(size=10),
            axis.title.x =element_text(size=14),
            axis.text.y = element_text(colour = alpha_v))
  )
  return(p)
}
plot_genera <- function(df){
  #  used to generate plots of which runs yielded fruitful results
  #  See the plot_success section of the supplementary data script
  df <- df  %>%  arrange(pmessage) %>%
    group_by(strain) %>%
    mutate(thisid = row_number()) %>%
    transform(thisid = ifelse(is.na(messag), 0, thisid)) 
  df$strain <- factor(df$strain, levels=rev(levels(factor(df$strain))))
  
  # for coloring x/y axis
  alpha_info <-  rev(ifelse(df[!duplicated(df$strain), "globalmessage"]=="Success", "gray90", "gray60"))
  alpha_data <- df %>%
    group_by(strain) %>% 
    mutate(alpha = ifelse(globalmessage=="Success", "gray10", "gray70")) %>% 
    select(strain, alpha) %>% distinct() %>% as.data.frame()
  
  alpha_v <- alpha_data[order(alpha_data$strain, alpha_data$alpha), "alpha"]
  # put in original number of orrganisms, for plotting purposes()
  (p <- ggplot(df, aes(x=strain, y=thisid, shape=pmessage,
                       color=pmessage, fill=pmessage)) + 
      scale_shape_manual(guide = "legend", values = c(21, 22, 23,24, 25)) + 
      geom_point(size=3)  + 
      coord_flip() +
      scale_y_continuous(expand = c(0.0,0), limits = c(0, 51)) + 
      #expand_limits(y = c(0, 50)) + 
      mytheme +
      scale_colour_brewer(palette = "Set2") +
      scale_fill_brewer(palette = "Set2") +
      # unfortuantely facet wrapping throws off our beautiful alpha'd out names
      # due to those repeated
      #facet_wrap(~mock) +
      labs(title="SRAs Proccessed by focusDB",
           caption="QC failure includes insufficient coverage, invalid read length",
           y="Number of whole-genome sequencing SRAs", x="", color="Per SRA", fill="Per SRA", shape="Per SRA")  +
      theme(axis.text=element_text(size=10),
            axis.title.x =element_text(size=14),
            axis.text.y = element_text(colour = alpha_v))
  )
  return(p)
}


codes_from_ncbi <- read.csv(text="Prefix	Database	Type
BA,DF,DG,LD	DDBJ	CON division
AN	EMBL	CON division
CH,CM,DS,EM, EN,EP,EQ,FA, GG,GL,JH,KB, KD,KE,KI,KK, KL,KN,KQ,KV, KZ,ML	NCBI	CON division
C,AT,AU,AV,BB, BJ,BP,BW,BY,CI, CJ,DA,DB,DC, DK,FS,FY,HX, HY,LU	DDBJ	EST
F	EMBL	EST
H,N,T,R,W,AA,AI, AW,BE,BF,BG, BI,BM,BQ,BU, CA,CB,CD,CF, CK,CN,CO,CV, CX,DN,DR,DT, DV,DW,DY,EB, EC,EE,EG,EH, EL,ES,EV,EW, EX,EY,FC,FD, FE,FF,FG,FK, FL,GD,GE,GH, GO,GR,GT,GW, HO,HS,JG,JK, JZ	GenBank	EST
D,AB,LC	DDBJ	Direct submissions
V,X,Y,Z,AJ,AM, FM,FN,HE,HF, HG,FO,LK,LL, LM,LN,LO,LR, LS,LT,OA,OB, OC,OD,OE	EMBL	Direct submissions
U,AF,AY,DQ,EF, EU,FJ,GQ,GU, HM,HQ,JF,JN, JQ,JX,KC,KF, KJ,KM,KP,KR, KT,KU,KX,KY, MF,MG,MH,MK, MN	GenBank	Direct submissions
AP	DDBJ	Genome project data
BS	DDBJ	Chimpanzee genome data
AL,BX,CR,CT, CU,FP,FQ,FR	EMBL	Genome project data
AE,CP,CY	GenBank	Genome project data
AG,DE,DH,FT, GA,LB	DDBJ	GSS
B,AQ,AZ,BH,BZ, CC,CE,CG,CL, CW,CZ,DU,DX, ED,EI,EJ,EK, ER,ET,FH,FI, GS,HN,HR,JJ, JM,JS,JY,KG, KO,KS,MJ	GenBank	GSS
AK	DDBJ	cDNA projects
AC,DP	GenBank	HTGS
E,BD,DD,DI,DJ, DL,DM,FU,FV, FW,FZ,GB,HV, HW,HZ,LF,LG, LV,LX,LY,LZ, MA,MB,MC	DDBJ	Patents
A,AX,CQ,CS,FB, GM,GN,HA,HB, HC,HD,HH,HI, JA,JB,JC,JD, JE,LP,LQ,MP, MQ,MR,MS	EMBL	Patents (nucleotide only)
I,AR,DZ,EA,GC, GP,GV,GX,GY, GZ,HJ,HK,HL, KH,MI,MM,MO	GenBank	Patents (nucleotide)
G,BV,GF	GenBank	STS
BR	DDBJ	TPA
BN	EMBL	TPA
BK	GenBank	TPA
HT,HU	DDBJ	TPA CON division
BL,GJ,GK	GenBank	TPA CON division
EZ,HP,JI,JL, JO,JP,JR,JT, JU,JV,JW,KA	GenBank	TSA
FX,LA,LE,LH, LI,LJ	DDBJ	TSA
S	GenBank	From journal scanning
AD	GenBank	From GSDB
AH	GenBank	Segmented set header
AS	GenBank	Other - not currently being used
BC	GenBank	MGC project
BT	GenBank	FLI-cDNA projects
J,K,L,M	GenBank	from GSDB direct submissions
N	GenBank and DDBJ	N0-N2 were used intially by both groups but have been removed from circulation, N2-N9 are ESTs
AAAA-AZZZ, JAAA-JZZZ, LAAA-LZZZ, MAAA-MZZZ, NAAA-NZZZ, PAAA-PZZZ, QAAA-QZZZ, RAAA-RZZZ, SAAA-SZZZ, VAAA-VZZZ	GenBank	WGS
AAAAAA-AZZZZZ	GenBank	WGS
BAAA-BZZZ	DDBJ	WGS
BAAAAA-BZZZZZ	DDBJ	WGS
CAAA-CZZZ, FAAA-FZZZ, OAAA-OZZZ, UAAA-UZZZ	EMBL	WGS
CAAAAA-CZZZZZ	EMBL	WGS
DAAA-DZZZ	GenBank	WGS TPA
DAAAAA-DZZZZZ	GenBank	WGS TPA
EAAA-EZZZ	DDBJ	WGS TPA
GAAA-GZZZ	GenBank	TSA
HAAA-HZZZ	EMBL	TSA
IAAA-IZZZ	DDBJ	TSA
TAAA-TZZZ	DDBJ	Targeted Gene Projects
KAAA-KZZZ	GenBank	Targeted Gene Projects
AAAAA-AZZZZ	DDBJ	MGA", sep="\t", stringsAsFactors=F)

write_msa <- function(db, assembly="GCA_000699725.1", destdir){
  # get matching assembly from sraFind to get the complete genome/seqeunce accession
  this_silva <- unique(db[grepl(assembly, db$Assembly.Accession), "raw" ])
  if (length(this_silva) == 0) {
    warning(paste("No matches ", assembly, ";  could be long reads?"))
    return (list(NA, NA, NA, NA, NA, NA))
  }
  # paste tofgether to make a query string with or's; this is because for assemblies, 
  # # different contigs will have different sequence names, but a single assembly accession
  this_silva_query <- gsub("(.*)\\|$", "\\1", paste0(unique(gsub("(.*?)\\..*", "\\1", this_silva)), collapse = "", sep="|"))
  # get matching SRAs for assembly, so we can use them to search the focusdb results
  this_focus <- unique(unlist(strsplit(db[grepl(assembly,  db$Assembly.Accession), "run_SRAs" ],",")))
  # build focusdb query string;  get rid of the *_\\d suffix we add to SRAs to keep themunique
  this_focus_query <- gsub("(.*)\\|$", "\\1", paste0(gsub("_\\d+", "",this_focus), collapse = "", sep="|"))
  
  # identify all seqeunces associated with this assembly accesssion
  silva_subset_seqs <- silva[grepl(this_silva_query,  names(silva))]
  # idenify the seqeunces from focusDB
  focus_subset_seqs <- all_focus[grepl(this_focus_query, names(all_focus))]
  unique_focus_subset_seqs <- unique(focus_subset_seqs)
  if (length(unique_focus_subset_seqs) == 0) {
    warning(paste("No matches for ",this_focus_query,"(", assembly, ")  in focusDB results"))
    return (list(NA, NA, NA, NA, NA, NA))
  } else{
    Biostrings::writeXStringSet(
      x=append(DNAStringSet(silva_subset_seqs), unique_focus_subset_seqs),
      filepath = file.path(destdir, paste0(assembly, ".msa")),
      append = F, 
      format = "fasta")
  }
}
