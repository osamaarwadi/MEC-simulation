function Basestations = shiftMEC(Basestations, mec_count)
    mecs = zeros(mec_count);
    for i = 1:length(mecs)
        for j = 1:length(Basestations)
            if Basestations(j).is_MEC == true
                if j == length(Basestations)
                    mecs(i) = 1;
                    Basestations(j).is_MEC = false;
                    break;
                else
                    mecs(i) = j+1;    
                    Basestations(j).is_MEC = false; 
                    break;
                end
            end
        end
    end
    for i = 1:length(Basestations)
        for j = 1:length(mecs)
            if mecs(j)==i
                Basestations(i).is_MEC = true;
            end
        end
    end
end