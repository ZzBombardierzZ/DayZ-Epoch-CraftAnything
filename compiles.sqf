if (isServer) then {
    // Blah blah blah
};

if (!isDedicated) then {

    //........... Other compiled scripts up here....

    //// !! COPY/ADD THIS FUNCTION TO YOUR CLIENT COMPILED SCRIPTS !! ////

    // This function is used to combine duplicate entries in an array of arrays. It is used by the bomb's craftAnything script and some others which may be released in the future.
    // Example: [["mag1",1],["mag2",1],["mag1",1]] becomes: [["mag1",2],["mag2",1]]
    // or [["weapon1"], ["weapon2"], ["weapon1"]] becomes: [["weapon1",2], ["weapon2",1]]
    // or [["thing1",1], ["thing2",1], ["thing1"]] becomes: [["thing1",2], ["thing2",1]]
    bomb_combineArrayOfDuplicates = {
        local _combineThese = _this;
        _combined = [];
        //check for duplicates that aren't written in the correct format ["example",count]
        {
            if (count _combined == 0) then {
                if (typeName _x == "ARRAY") then {
                    _combined set [count _combined,_x];
                } else {
                    _combined set [count _combined,[_x,1]];
                };
            } else {
                local _thisCombine = _x;
                if (typeName _thisCombine == "STRING") then {
                    _thisCombine = [_thisCombine,1];
                };
                local _found = false;
                {
                    if ((_thisCombine select 0) in _x) then {
                        _combined set [_forEachIndex,[_x select 0, (_x select 1) + (_thisCombine select 1)]];
                        _found = true;
                        breakOut "";
                    };
                } forEach _combined;
                if (!_found) then {
                    _combined set [count _combined,_thisCombine];
                };
            };
        } forEach _combineThese;
        //return _combined
        _combined
    };
    // !!! End of section to copy !!!

};

// Global compiled scripts.... blah blah blah