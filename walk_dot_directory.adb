-- ----------------------------------------------------------------------------
-- NAME: Janneth Guarcas Garcia (using walk_directory.adb as start point)
-- ASGT: Activity 3
-- ORGN: CSUB - CMPS 3500
-- FILE: walk_dot_directory.adb
-- DATE: 03/10/2021
-- ----------------------------------------------------------------------------

with Ada.Directories;       use Ada.Directories;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Fixed;     use Ada.Strings.Fixed;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;

procedure walk_dot_directory is

    -- start of declaration section
    -- given declarations from original walk_directory.adb
    Directory : String := ".";
    Pattern   : String := "";    -- empty pattern = all file/subdirectory names
    Search    : Search_Type;
    Dir_Ent   : Directory_Entry_Type;
    smatch    : String := "in";

    -- start of my additional declarations
    file_count: INTEGER := 1;    -- to store filename in names_array per index
    highest_max: INTEGER;        -- for final highest max value
    highest_index: INTEGER := 1; -- for final highest max index (for mapping)
    
    -- an array of strings to store the file names as they are encountered
    -- string size set to match size of provided filenames, 10 total files
    names_array : array(1..10) of String(1..6);
    file_name : String(1..6);   -- temp for filenames in directory
    
    -- first, second, and results arrays for multiple dot product calculations
    first_array : array (1..10) of INTEGER; -- 10 numbers per file lines
    second_array : array (1..10) of INTEGER;
    result_array : array (1..10) of INTEGER;
    
    -- each files' max dot-product, mappable to names_array via indeces
    maxes_array : array (1..10) of INTEGER;
    
    -- file handler for input and output, respectively
    infile :FILE_TYPE;

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    -- nested procedure to find the final maximum (a.k.a. largest max of maxes)

    procedure findFinalMax is

        -- nested procedure declarations
        temp_value: INTEGER;

        begin
            highest_max := maxes_array(1);
            for i in 2..10 loop
                temp_value := maxes_array(i);
                if temp_value > highest_max then
                    highest_max := temp_value;
                    highest_index := i;
                end if;
            end loop;

    end findFinalMax;

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
    -- nested procedure to find dot products, max in results, and store max

    procedure multiplyAndMax(position: in INTEGER) is

        -- nested procedure declarations
        local_max_index: INTEGER := 1;
        local_max : INTEGER;
        local_temp: INTEGER;

        begin
            -- get dot product, store it, display it
            for i in 1..10 loop
                result_array(i) := first_array(i) * second_array(i);
                local_temp := result_array(i);
                Put(local_temp, 8); -- prints to scream
            end loop;

            -- find max in result_array
            local_max := result_array(1);
            for i in 2..10 loop
                local_temp := result_array(i);
                if local_temp > local_max then
                    local_max := local_temp;
                    local_max_index := i;
                    --highest_index := i; dont need it here
                end if;
            end loop;

            -- store the max into our maxes_array, then display current max
            maxes_array(position):= result_array(local_max_index);
            Put(maxes_array(position), 9);

    end multiplyAndMax;

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    -- nested procedure to open corresponding files and fill arrays
    
    procedure getArrayValues(the_file:in String) is
        
        begin
            Open(infile, In_File, the_file);
            -- to fill first array
            for i in 1..10 loop
                exit when End_Of_Line(infile);
                Get(infile, first_array(i));
            end loop;

            -- to fill second array
            Skip_Line(infile);
            for i in 1..10 loop
                Get(infile, second_array(i));
            end loop;
            Close(infile);

    end getArrayValues;

    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    -- begin outermost prodecure

    begin
        -- from walk_directory.adb, walks through directory, modified to also
        -- store the matching filenames into our string array

        Start_Search (Search, Directory, Pattern);

        --searchs each file in current folder
        while More_Entries (Search) loop
            Get_Next_Entry (Search, Dir_Ent);
            
            if Tail (Simple_Name (Dir_Ent), smatch'Length) = smatch then
                -- set up to store the filenames to the string array
                file_name := Simple_Name (Dir_Ent);
                names_array(file_count) := file_name;
                file_count := file_count + 1;
            end if;
        end loop;

        End_Search (Search);    
        
        -- set up for table of dot product values, format per instructions
        Put_Line("Vector   Dot Product                       "
            & "                                              "
            & "Maximum");
        
        Put_Line("******   "
            & "***************************************"
            & "***************************************"
            & "  *******");

        -- use names_array to call getArrayValues, multiplyAndMax iteratively
        for i in 1..10 loop
            Put(names_array(i) & " ");
            getArrayValues(names_array(i));
            multiplyAndMax(i);
            New_Line;
        end loop;

        -- calling findFinalMax to find the highest maximum value and index
        findFinalMax;


        -- display name of vector with highest max using highest index to map
            New_Line;
            Put("The vector with the highest maximum is: " 
            & names_array(highest_index));

end walk_dot_directory;
