-module(client).
-author(rgaini).
-import(string,[len/1]).
-import(crypto,[hash/2]).
-import(string,[equal/2]).
-import(string,[concat/2,sub_string/3]).
-export([ss/3,start/3,start1/1]).

start1(N) ->
    
    Workers=erlang:system_info(logical_processors_available),
    ss(Workers,0,N).

ss(Workers,WorkerCounter,N) ->
        if
            Workers >= WorkerCounter ->
                
                spawn(client, start,[N,0,0]),
                %io:fwrite("THe process ~p~n",[Pid]),
    
                ss(Workers,WorkerCounter+1,N);  
                
            true ->
                io:fwrite("Processes Invoked!!!")
        end.


start(N,StrCount,CoinCount)->
    UfID="5004099927363334",

    %Generate a random string
    String=base64:encode_to_string(crypto:strong_rand_bytes(24)),

    %Append Random String with UFID
    RandomString=string:concat(UfID,String),
    %Hash the Random string using SHA256
    HashString=io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256,RandomString))]),
    %Create a substring from first character to N character
    HashedSubString= sub_string(HashString,1,N),
    % Create a string with N zeros
    %Str=string:concat(string:concat('~',(integer_to_list(N)),"..0B"),
    %ZeroString = lists:flatten(io_lib:fwrite(Str, [0])),
    ZeroString = string:copies("0",N),

    Status=string:equal(HashedSubString,ZeroString),

        if
            StrCount =< 1000 ->
            if
                Status == true ->
                %io:format("Bitcoin is found and sending message to server\n"),
                io:format("The bitcoin string is ~p and hash is ~p ~n",[RandomString, HashString]),
                %io:format("Bitcoin Code Endsssssssssssssssss\n"),
                start(N,StrCount+1,CoinCount+1);
        %term();
        % ! {ping,RandomString,HashString},
        %start();
                true ->
                    start(N,StrCount+1,CoinCount)
                
            %io:fwrite("Not Found")
            end;
            true ->
                io:format("All the strings are Done!~n"),
                io:fwrite("The coins mined by ~p are ~p~n",[self(),CoinCount])
                % term(TotalCoins,CoinCount)
        end.
