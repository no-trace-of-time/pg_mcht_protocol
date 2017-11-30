%%%-------------------------------------------------------------------
%%% @author jiarj
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 十月 2017 13:56
%%%-------------------------------------------------------------------
-module(pg_mcht_protocol_req_pay).
-author("jiarj").
-include_lib("eunit/include/eunit.hrl").
-include_lib("mixer/include/mixer.hrl").

-behavior(pg_convert).
-behaviour(pg_protocol).
-behaviour(pg_mcht_protocol).

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

%%-------------------------------------------------------------------
-define(P, ?MODULE).

-record(?P, {
  mcht_id = 9999 :: pg_mcht_protocol:mcht_id()
  , txn_date = <<>> :: pg_mcht_protocol:txn_date()
  , txn_time = <<>> :: pg_mcht_protocol:txn_time()
  , txn_seq = <<"9999">> :: pg_mcht_protocol:txn_seq()
  , txn_amt = 0 :: pg_mcht_protocol:txn_amt()
  , order_desc = <<>> :: pg_mcht_protocol:order_desc()
  , front_url = <<>> :: pg_mcht_protocol:url()
  , back_url
  , signature = <<"9">> :: pg_mcht_protocol:signature()
  , bank_card_no = <<>> :: pg_mcht_protocol:bank_card_no()
  , bank_id = <<>> :: pg_mcht_protocol:bank_id()
}).

-type ?P() :: #?P{}.
-export_type([?P/0]).
-export_records([?P]).


%%-------------------------------------------------------------------
sign_fields() ->
  sign_fields(dict_order).

sign_fields(doc_order) ->
  [
    mcht_id
    , txn_date
    , txn_seq
    , txn_time
    , txn_amt
    , bank_id
    , order_desc
    , back_url
    , front_url
    , bank_card_no

  ];
sign_fields(dict_order) ->
  [
    bank_card_no
    , bank_id
    , mcht_id
    , order_desc
    , txn_amt
    , txn_date
    , txn_seq
    , txn_time
    , back_url
    , front_url

  ].


options() ->
  #{
    channel_type => mcht,
    txn_type => pay,
    direction => req
  }.


%%---------------------------------
