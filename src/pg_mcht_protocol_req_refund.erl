%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 十月 2017 13:58
%%%-------------------------------------------------------------------
-module(pg_mcht_protocol_req_refund).
-author("jiarj").
-include_lib("eunit/include/eunit.hrl").
-include_lib("mixer/include/mixer.hrl").
-behaviour(pg_protocol).
-behaviour(pg_mcht_protocol).

-compile(export_all).
%% API
%% callbacks of mcht_protocol
-mixin([{pg_mcht_protocol, [
  pr_formatter/1
  , in_2_out_map/0
]}]).
%% API
%% callbacks of pg_protocol
-export([
  sign_fields/0
  , options/0
  , save/2
]).
%% callbacks of pg_protocol
%%-------------------------------------------------------------------
-define(TXN, ?MODULE).

-record(?TXN, {
  id = 9999
  , txn_date = <<>>
  , txn_time = <<>>
  , txn_seq = <<"9999">>
  , txn_amt = 0
  , back_url
  , orig_txn_date = <<>>
  , orig_txn_seq = <<>>
  , orig_query_id = <<>>
  , signature = <<"9">>
}).

-type ?TXN() :: #?TXN{}.
-export_type([?TXN/0]).
-export_records([?TXN]).


%%-------------------------------------------------------------------
sign_fields() ->
  sign_fields(dict_order).

sign_fields(doc_order) ->
  [
    mcht_id
    , txn_date
    , txn_seq
    , txn_time
    , orig_txn_date
    , orig_txn_seq
    , orig_query_id
    , txn_amt
    , back_url
  ];
sign_fields(dict_order) ->
  [
    mcht_id
    , orig_query_id
    , orig_txn_date
    , orig_txn_seq
    , txn_amt
    , txn_date
    , txn_seq
    , txn_time
    , back_url
  ].

options() ->
  #{
    channel_type => mcht,
    txn_type => refund,
    direction => req
  }.


%%---------------------------------
save(M, Protocol) when is_atom(M), is_record(Protocol, ?TXN) ->
  VL = [
    {txn_type, refund}
    , {txn_status, waiting}
    , {index_key, pg_protocol:get(M, Protocol, index_key)}
  ] ++ pg_model:to(M, Protocol, proplists),

  Repo = pg_model:new(repo_txn_log_pt, VL),
  pg_repo:save(Repo).
