function [AC,MIhat] = Evaluate(label,gnd)
    label = bestMap(gnd,label);%using hungarian algorithm to map the label
    AC = length(find(gnd == label))/length(gnd);
    MIhat = MutualInfo(gnd,label);
end