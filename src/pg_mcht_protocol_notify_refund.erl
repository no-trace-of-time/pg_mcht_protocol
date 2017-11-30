%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 十月 2017 17:02
%%%-------------------------------------------------------------------
-module(pg_mcht_protocol_notify_refund).
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
]).
%% callbacks of pg_protocol
%%-------------------------------------------------------------------
-define(TXN, ?MODULE).

-record(?TXN, {
  mcht_id = 9999
  , txn_date = <<>>
  , txn_time = <<>>
  , txn_seq = <<"9999">>
  , txn_amt = 0
  , signature = <<"9">>
  , txn_status = success
  , resp_code = <<"00">>
  , resp_msg = <<"success">>
  , back_url = <<>>
  , settle_date = <<>>
  , query_id = <<>>
  , limit = 0
}).

-type ?TXN() :: #?TXN{}.
-export_type([?TXN/0]).
-export_records([?TXN]).


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
    txn_type => refund,
    direction => notify
  }.

