-module(master).
%-author("nuthalapati\_satyamythili\:nikhitha\_mikkilineni")
-import(string,[len/1]).
-import(crypto,[hash/2]).
-import(string,[equal/2]).
-import(string,[concat/2,sub_string/3]).
-export([start/3, ss/3,start1/0]).
%-export([start/0, ss/,pong/0,start_pong/0]).

%term(TotalCoins,CoinCount) ->


start1() ->
    {ok, N} = io:read("Enter the number: "),
    Workers=erlang:system_info(logical_processors_available),
    ss(Workers,0,N),
    rpc:call('div@192.168.0.131',client,start1,[N]).
    

ss(Workers,WorkerCounter,N) ->
    if
        Workers >= WorkerCounter ->
            
            spawn(master, start,[N,0,0]),
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
  HashedSubString=sub_string(HashString,1,N),
  % Create a string with N zeros
  %Str=string:concat(string:concat('~',(integer_to_list(N)),"..0B"),
  %ZeroString = lists:flatten(io_lib:fwrite(Str, [0])),
  ZeroString = string:copies("0",N),
  
  Status=string:equal(HashedSubString,ZeroString),

    if
        StrCount =< 10000000 ->
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


% pong() ->
%     receive
%         {ping,String,Hashedstring} ->
%             io:format("the string is ~p \n", [String]),
%             io:format("the hashed string is ~p \n", [Hashedstring]),
%             pong()
%     end.

% start_pong() ->
%     register(masterpid, spawn(master, pong, [])).













% Bitcoin with 6 - adloorihjLYyG9k8HeGc0Q==0
% The bitcoin string is "adloorihl8ZggOXAFyutvH37PWxrzUt0o6YXwifi" and hash is "000000002a11d29efd0f6f777bfca3621bad352be90cef6bba3fee72ef9c7fd7"
% 5> The bitcoin string is "adloorihKq3UdWbWCG8hsu0FKYD70xw+EyaL5Ig9" and hash is "00000003483c76967164169f642596dc166451ed1cd5c3f36174ba4ea1f08ed4"
% 5> The bitcoin string is "adloorih+ZLkhJ0xLqmeYXpDJ8OV9P+pqrGQcW/W" and hash is "0000000be8dbcb0ad8c0b085ff93954c68f4168998b8d5a713c3d2038c82687f"
% 5> The bitcoin string is "adloorihsayCo3KKlEtEAAVO3EZyf161oMW/v0cP" and hash is "0000000bdaeb715afa2be2ece1eb5ce55226bb5c26dc3ad73d1a9299ae91be3e"
