-module(p01).

-export([main/0]).

read_and_build_lists(Device, L1, L2) ->
    case io:get_line(Device, "") of
        eof ->
            {lists:reverse(L1), lists:reverse(L2)};
        Line ->
            TrimmedLine = string:trim(Line),
            case string:split(TrimmedLine, "   ", all) of
                [E1, E2] ->
                    case {string:to_integer(E1), string:to_integer(E2)} of
                        {{I1, ""}, {I2, ""}} ->
                            read_and_build_lists(Device, [I1 | L1], [I2 | L2]);
                        _ ->
                            io:format("Invalid integer format: ~p~n", [TrimmedLine]),
                            read_and_build_lists(Device, L1, L2)
                    end;
                _ ->
                    io:format("Invalid line format: ~p~n", [TrimmedLine]),
                    read_and_build_lists(Device, L1, L2)
            end
    end.

calculate_total_distance(L1, L2, Distance) ->
    case {L1, L2} of
        {[], []} ->
            Distance;
        {[H1 | T1], [H2 | T2]} ->
            NewDistance = Distance + abs(H1 - H2),
            calculate_total_distance(T1, T2, NewDistance)
    end.

main() ->
    io:format("Starting...~n"),
    case file:open("p01.input", [read]) of
        {ok, Device} ->
            try
                {List1, List2} = read_and_build_lists(Device, [], []),
                SortedList1 = lists:sort(List1),
                SortedList2 = lists:sort(List2),
                Distance = calculate_total_distance(SortedList1, SortedList2, 0),
                io:format("Distance: ~p~n", [Distance])
            catch
                error:Error ->
                    io:format("Error occurred: ~p~n", [Error])
            after
                file:close(Device)
            end;
        {error, Reason} ->
            io:format("Failed to open file: ~p~n", [Reason])
    end,
    init:stop().
