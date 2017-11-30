%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 十月 2017 17:04
%%%-------------------------------------------------------------------
-module(pg_mcht_protocol_resp_pay).
-author("jiarj").
-include_lib("eunit/include/eunit.hrl").
-include_lib("mixer/include/mixer.hrl").
-behaviour(pg_convert).
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
]).
%% callbacks of pg_protocol
%%-------------------------------------------------------------------
-define(TXN, ?MODULE).

-record(?TXN, {
  id = 9999
  , txn_date = <<>>
  , txn_seq = <<"9999">>
  , txn_amt
  , query_id
  , settle_date
  , limit = 0
  , resp_code
  , resp_msg
  , front_url
  , back_url
  , signature
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
    , txn_amt
    , query_id
    , settle_date
    , limit
    , resp_code
    , resp_msg

  ];
sign_fields(dict_order) ->
  [
    limit
    , mcht_id
    , query_id
    , resp_code
    , resp_msg
    , settle_date
    , txn_amt
    , txn_date
    , txn_seq

  ].

options() ->
  #{
    channel_type => mcht,
    txn_type => pay,
    direction => resp
  }.


%%---------------------------------
save(M, Protocol) when is_atom(M), is_record(Protocol, ?TXN) ->
  VL = pg_model:get_proplist(M, Protocol, [query_id, settle_date, resp_code, resp_msg])
    ++ [{txn_status, xfutils:up_resp_code_2_txn_status(pg_model:get(M, Protocol, resp_code))}],

  PK = pg_protocol:get(M, Protocol, index_key),
  pg_repo:update_pk(repo_txn_log_pt, PK, VL).
