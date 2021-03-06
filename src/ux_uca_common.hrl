%%
%% Helpers
%%     
-spec do_alt(fun(), binary()|integer()) -> [integer()].
-spec get_ducet() -> fun().
-spec do_extract(#uca_options{}, string(), fun()) -> 
        {integer(), string()}.
-spec get_options() -> #uca_options{}.

do_alt(A, W) -> A(W).
do_alt(A, W, S) -> 
    {NewA, AltW} = A(W),
    NewAltW = lists:sublist(AltW, S),
    {NewA, NewAltW}.

get_ducet() -> ux_unidata:ducet(skip_check).

%% Extract a weight from the string.
%% Weights is [<<L1, L2, L3, L4>>, <<L1, L2, L3, L4>>].
do_extract(C, S, D) ->
    {_Weights, _NewS} = ux_uca_extract:extract(C, D, S).

get_options() -> #uca_options{}.
    

%%
%% Sort Key Functions
%%

% L2 is backward.
-spec split_levels(integer(), boolean(), [[integer()]]) -> 
        {[integer()], [[integer()]]}.

split_levels(_L=2, _B=true, W) -> 
    {Res, Rem} = do_split_levels(W, [], []),
    {Res, lists:reverse(Rem)};
split_levels(_L, _B, W) -> 
    {Res, Rem} = do_split_levels(W, [], []),
    {lists:reverse(Res), lists:reverse(Rem)}.
    
do_split_levels([WH|WT], Res, Rem) ->
    case WH of
    [0] -> do_split_levels(WT, Res, Rem);
    [0|T] -> do_split_levels(WT, Res, [T|Rem]);
    [H] -> do_split_levels(WT, [H|Res], Rem);
    [H|T] -> do_split_levels(WT, [H|Res], [T|Rem])
    end;
do_split_levels([], Res, Rem) ->
    {Res, Rem}.
    
get_reassign_function(D, L) ->
    D({reassign_function, L}).
