buffer = 5
forecast = 3
initialBankroll = 1.
bet<-1. # ,25 seems to work
rake = .00
#
buy0 <- function(index, prices) {
    return(T)
}
run <- function(symbol, prices, buy) {
    bankroll <- initialBankroll
    boughtAt <- 0. # swithc for buy and hold - change the name
    totalRake<-0.
    buys<-0
    wins<-0
    one <- function(i, boughtAt) {
        sell<-function(amountBet) {
            current<-prices[i]
            change<-current-boughtAt
            if(change>0) wins<-wins+1
            profit<-(current-boughtAt)/boughtAt # per share
            # hProfit().add(profit)
            delta<-amountBet*(1+profit)
            previous<-bankroll
            if(TRUE) bankroll<-bankroll+delta
            else bankroll<-bankroll+amountBet # pretend no gain or loss.
            # this is just to keep the bankroll constant.
            print(sprintf("in sell, previous bankroll: %7.3f, change: %7.3f,  delta: %7.3f",previous,change,delta))
            print(sprintf("end of sell, profit(b4): %6.3f, br %7.3f, bought at %6.3f, current %6.3f, $ %6.3f\n",profit,
                                              bankroll,boughtAt,current,current-boughtAt))
        } # end of sell
        if (boughtAt == 0.) {
            # new buy?
            if (buy(i, prices)) {
                boughtAt <- prices[i - 1]
                betAmount <- bankroll * bet
                bankroll <- bankroll - betAmount
                rakeAmount <- betAmount * rake
                totalRake <- totalRake + rakeAmount
                betAmount <- betAmount - rakeAmount
                buys <- buys + 1
                print(sprintf("bet amount: %7.3f",betAmount))
                print(sprintf("before sell, bankroll: %7.3f",bankroll))
                sell( betAmount)
                print(sprintf("after sell, bankroll: %7.3f",bankroll))
                boughtAt = 0.
            } else {
                print("no buy")
            }
        } else {
            # we are holding some
            print("holding!")
        }
        return(boughtAt)
        
    }
    r <- (buffer+1):(length(prices) - forecast)
    for (i in r) {
        print(sprintf("index: %d, bankroll: %7.3f",i,bankroll))
        if (bankroll <= 0.) {
            print("broke!")
            return(NULL)
        }
        print(prices[i])
        boughtAt <- one(i,boughtAt)
        print(sprintf("at end of loop, bankroll: %7.3f",bankroll))
        print("------------------------------")
    }
}
prices = c(1, 2, 3, 4, 5, 6, 7, 8, 9,10)
symbol <- "GOOG"
run(symbol, prices,buy0)

    public String toCSVLine() {
        String s=String.format("%-15s, %5.2f, %5.2f, %5.2f, %7.3f, %5.2f, %7.3f, %4d", //
                                   name(),bankroll(),eProfit(),sdProfit(), //
                                   pptd(),winRate(),buyRate(),days());
        if(false) s+=String.format(", \"%s\"",hProfit());
        return s;
    }
    #public static String header() { return "name,bankroll,eProfit,sdProfit,pptd,winRate,buyRate,days,hProfit"; }
    public static String toLine(String[] names,Object[] objects) {
        StringBuffer s=new StringBuffer();
        for(int i=0;i<names.length;++i) {
            if(i>0) s.append(", ");
            s.append(names[i]).append(": ").append(objects[i]);
        }
        return s.toString();
    }
    public static String toLine(Object... arguments) {
        StringBuffer s=new StringBuffer();
        for(int i=0;i<arguments.length;i+=2) {
            if(i>0) s.append(", ");
            s.append(arguments[i]);
            if(i+1<arguments.length) s.append(": ").append(arguments[i+1]);
        }
        return s.toString();
    }
    public static StringWriter toCSV(SortedMap<Comparable<?>,Play> map) throws IOException {
        // maybe use values()?
            StringWriter w=new StringWriter();
            w.write(Play.header()+'\n');
            for(Object d:map.keySet()) {
                Play play=map.get(d);
                w.write(play.toCSVLine());
                w.write('\n');
            }
            w.write(Play.header()+'\n');
            w.close();
            return w;
    }
    public static void toConsole(SortedMap<Comparable<?>,Play> map) {
        System.out.println(Play.header());
        for(Object d:map.keySet()) System.out.println(map.get(d));
    }
    public static void filenames(String filename) throws IOException {
        StringWriter w=new StringWriter();
        for(Object d:map.keySet()) {
            Play play=map.get(d);
            w.write(play.filename);
            w.write('\n');
        }
        File file=new File(filename);
        FileWriter fw=new FileWriter(file);
        fw.write(w.toString());
        fw.close();
    }
    public static List<String> getFilenames(String filename) throws IOException {
        File file=new File(filename);
        BufferedReader br=new BufferedReader(new FileReader(file));
        ArrayList<String> list=new ArrayList<>();
        for(String name=br.readLine();name!=null;name=br.readLine()) list.add(name);
        return list;
    }
    public void update() {
        hBankroll.add(bankroll());
        hExpectation.add(hProfit().mean());
        hWinRate.add(winRate());
        hBuyRate.add(buyRate());
        // hack key so it's uniqie
        long dt=System.nanoTime()-t0;
        double d=bankroll();
        double factor=dt/100000000.;
        //System.out.println("dt2: "+dt+", factor: "+factor);
        double key=-(bankroll()+factor);
        map.put(key,this);
        //map.put(filename,this);
    }
    public void prologue() {
        System.out.format("start at: %4d, min:  %4d, nax: %4d\n" //
                +"br: %7.2f, bet: %5.2f, rake: %.2f, max files: %5d"+", buy: "+"\n", //
                startAt,minSize,maxsize, //
                bankroll,bet,rake,maxFiles //
        );
        //static int maxFiles=Integer.MAX_VALUE;
        //static int buffer=5,forecast=3;
        //static double initialBankroll=1;
    }
    public static void summary(SortedMap<Comparable<?>,Play> map) throws IOException {
        System.out.println("e: "+Play.hExpectation);
        System.out.println("E(profit): "+toString(hExpectation));
        System.out.println("bankroll: "+Play.hBankroll);
        System.out.println("bankroll: "+toString(hBankroll));
        System.out.println("win ratel: "+Play.hWinRate);
        System.out.println("buy ratel: "+Play.hBuyRate);
        //Play.toConsole(Play.map);
        StringWriter w=Play.toCSV(map);
        File file=new File("out.csv");
        FileWriter fw=new FileWriter(file);
        fw.write(w.toString());
        fw.close();
    }
    public static void one(String filename) {
        double[] prices=getPrices(filename);
        Play play=new Play(filename,prices);
        // initialize
        // then run with a buy?
        // reset and run with another buy?
        // or make a new instance
        play.run(buy0);
        if(play.verbosity>0) play.summary();
        if(play.verbosity>1) System.out.println("profit: "+play.hProfit());
        System.out.println(play);
    }
    public static void some(List<String> filenames) throws IOException {
        for(int index=0;index<filenames.size();++index) {
            if(index>Play.maxFiles) break;
            String filename=filenames.get(index);
            // make this use getPrices in MyDaaset.
            // maybe make a get size? 
            double[] l=getPrices(filename);
            if(l.length<minSize) { ++skippedFiles; continue; }
            int length=260; // same as min size for now.
            if(l.length<length) { System.out.println("too  small: "+filename); continue; }
            int start=l.length-length;
            int stop=l.length;
            l=getPrices(filename,start,stop);
            Play play=new Play(filename,l);
            //play.verbosity=2;
            if(index==0) play.prologue(); // before
            play.run(buy0);
            if(play.verbosity>0) play.summary();
            if(play.verbosity>1) System.out.println("profit: "+play.hProfit());
            //System.out.println("dt: "+(System.nanoTime()-play.t0));
            play.update();
            //update(hBankroll,hExpectation,map,play);
            if(play!=null&&index==filenames.size()-1) play.prologue();
            if(index>0&&index%1000==0) System.out.println("index: "+index+", bankroll: "+Play.hBankroll);
        }
        summary(Play.map);
    }
    public static void main(String[] args) throws IOException {
        @SuppressWarnings("unused") List<String> forceInitialization=MyDataset.datasetFilenames;
        //Play.maxFiles=999;
        //Play.maxFiles=10;
        boolean useDatasetFilenames=true;
        List<String> l;
        if(useDatasetFilenames) l=datasetFilenames; // use most
        else l=getFilenames("filenames.txt");
        System.out.println("start of processing filenames.");
        some(l);
        System.out.println("map sze: "+map.size());
        System.out.println("end of processing filenames.");
        System.out.println(skippedFiles+" skipped files.");
        filenames("newfilenames.txt"); // save filenames in order
        //System.out.println(getFilenames("filenames.txt"));
        System.out.println(System.currentTimeMillis()-t0ms);
    }
    public static final BiPredicate<Integer,double[]> buy0=(index,prices)-> { return true; };
    public static final BiPredicate<Integer,double[]> buy1=(index,prices)-> {
        double p1=prices[index-2];
        double p2=prices[index-1];
        return p1<=p2;
    };
    public static final BiPredicate<Integer,double[]> buy2=(index,prices)-> {
        double p1=prices[index-3];
        double p2=prices[index-2];
        double p3=prices[index-1];
        // add a check for some mimimum increase? 
        return p1<=p2&&p2<=p3;
    };
    public static final BiPredicate<Integer,double[]> buy3=(index,prices)-> {
        double p1=prices[index-4];
        double p2=prices[index-3];
        double p3=prices[index-2];
        double p4=prices[index-1];
        return p1<=p2&&p2<=p3&&p3<=p4;
    };
    public static final BiPredicate<Integer,double[]> buy4=(index,prices)-> {
        double p1=prices[index-4];
        double p2=prices[index-3];
        double p3=prices[index-2];
        double p4=prices[index-1];
        double dy2=p2-p1;
        double dy3=p3-p2;
        double dy4=p4-p3;
        double d2y3=dy3-dy2;
        double d2y4=dy4-dy3;
        double d3y4=d2y4-d2y3;
        return dy4>0&&d2y4>0;
    };
    public static String toString(Histogram histogram) {
        return String.format("min: %5.2f, mean: %5.2f, max: %5.2f" //
                +", sd: %6.3f",histogram.min() //
                ,histogram.mean() //
                ,histogram.max() //
                ,Math.sqrt(histogram.variance()) //
        );
    }
    