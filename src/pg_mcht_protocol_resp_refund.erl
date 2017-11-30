%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 十月 2017 17:05
%%%-------------------------------------------------------------------
-module(pg_mcht_protocol_resp_refund).
-author("jiarj").
-include_lib("eunit/include/eunit.hrl").
-include_lib("mixer/include/mixer.hrl").
-behaviour(pg_convert).
-behaviour(pg_protocol).
-behaviour(pg_mcht_protocol).

-compile(export_all).
%% API
%% callbacks of protocol
-mixin([{pg_protocol, [
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
  , txn_time = <<>>
  , txn_seq = <<"9999">>
  , txn_amt = 0
  , orig_txn_date = <<>>
  , orig_txn_seq = <<>>
  , orig_query_id = <<>>
  , signature = <<"9">>
  , txn_status = waiting
  , back_url = <<>>
  , resp_code = <<"05">>
  , resp_msg = <<"accepted">>
  , query_id = <<>>
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
    , query_id
    , resp_code
    , resp_msg
  ];
sign_fields(dict_order) ->
  [
    mcht_id
    , orig_query_id
    , orig_txn_date
    , orig_txn_seq
    , query_id
    , resp_code
    , resp_msg
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
    direction => resp
  }.

