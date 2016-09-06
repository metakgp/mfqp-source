require 'json'

def get_branch
    `git branch`.split("\n").each do |each_branch|
        if each_branch.include? "* "
            return each_branch.gsub("* ","")
        end
    end
end

def show_changes master_hash , test_hash

    if test_hash == master_hash
        puts "No change in subjects.json file."
    else
        master_keys , test_keys = master_hash.keys , test_hash.keys
        master_values , test_values = master_hash.values , test_hash.values

        test_hash.each do |k,v|
            if master_keys.include? k 
                if master_values[master_keys.find_index(k)] == test_hash[k]
                     # Means - no change to individual record
                else
                    puts "Subject #{k} : Modified." 
                end
            else
                puts "Subject #{k} : Added."
            end
        end

        master_hash.each do |k,v|
            unless test_keys.include? k 
                puts "Subject #{k} : Deleted."
            end
        end

    end
end

puts "\n"
test_branch , master_branch = get_branch() , "master"
`git checkout #{test_branch}`
test_obj = JSON.parse(File.read("./include/subjects.json"))
`git checkout #{master_branch}`
master_obj = JSON.parse(File.read("./include/subjects.json"))
`git checkout #{test_branch}`
puts "\n"
show_changes(master_obj,test_obj)
puts "\n"