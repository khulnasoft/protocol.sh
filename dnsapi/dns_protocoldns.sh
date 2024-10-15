#!/usr/bin/env sh
# shellcheck disable=SC2034
dns_protocoldns_info='protocol-dns Server API
 The protocol-dns is a limited DNS server with RESTful API to handle PROTOCOL DNS challenges.
Site: github.com/joohoi/protocol-dns
Docs: github.com/khulnasoft/protocol.sh/wiki/dnsapi#dns_protocoldns
Options:
 PROTOCOLDNS_USERNAME Username. Optional.
 PROTOCOLDNS_PASSWORD Password. Optional.
 PROTOCOLDNS_SUBDOMAIN Subdomain. Optional.
 PROTOCOLDNS_BASE_URL API endpoint. Default: "https://auth.protocol-dns.io".
Issues: github.com/dampfklon/protocol.sh
Author: Wolfgang Ebner, Sven Neubuaer
'

########  Public functions #####################

#Usage: dns_protocoldns_add   _protocol-challenge.www.domain.com   "XKrxpRBosdIKFzxW_CT3KLZNf6q0HG9i01zxXp5CPBs"
# Used to add txt record
dns_protocoldns_add() {
  fulldomain=$1
  txtvalue=$2
  _info "Using protocol-dns"
  _debug "fulldomain $fulldomain"
  _debug "txtvalue $txtvalue"

  #for compatiblity from account conf
  PROTOCOLDNS_USERNAME="${PROTOCOLDNS_USERNAME:-$(_readaccountconf_mutable PROTOCOLDNS_USERNAME)}"
  _clearaccountconf_mutable PROTOCOLDNS_USERNAME
  PROTOCOLDNS_PASSWORD="${PROTOCOLDNS_PASSWORD:-$(_readaccountconf_mutable PROTOCOLDNS_PASSWORD)}"
  _clearaccountconf_mutable PROTOCOLDNS_PASSWORD
  PROTOCOLDNS_SUBDOMAIN="${PROTOCOLDNS_SUBDOMAIN:-$(_readaccountconf_mutable PROTOCOLDNS_SUBDOMAIN)}"
  _clearaccountconf_mutable PROTOCOLDNS_SUBDOMAIN

  PROTOCOLDNS_BASE_URL="${PROTOCOLDNS_BASE_URL:-$(_readdomainconf PROTOCOLDNS_BASE_URL)}"
  PROTOCOLDNS_USERNAME="${PROTOCOLDNS_USERNAME:-$(_readdomainconf PROTOCOLDNS_USERNAME)}"
  PROTOCOLDNS_PASSWORD="${PROTOCOLDNS_PASSWORD:-$(_readdomainconf PROTOCOLDNS_PASSWORD)}"
  PROTOCOLDNS_SUBDOMAIN="${PROTOCOLDNS_SUBDOMAIN:-$(_readdomainconf PROTOCOLDNS_SUBDOMAIN)}"

  if [ "$PROTOCOLDNS_BASE_URL" = "" ]; then
    PROTOCOLDNS_BASE_URL="https://auth.protocol-dns.io"
  fi

  PROTOCOLDNS_UPDATE_URL="$PROTOCOLDNS_BASE_URL/update"
  PROTOCOLDNS_REGISTER_URL="$PROTOCOLDNS_BASE_URL/register"

  if [ -z "$PROTOCOLDNS_USERNAME" ] || [ -z "$PROTOCOLDNS_PASSWORD" ]; then
    response="$(_post "" "$PROTOCOLDNS_REGISTER_URL" "" "POST")"
    _debug response "$response"
    PROTOCOLDNS_USERNAME=$(echo "$response" | sed -n 's/^{.*\"username\":[ ]*\"\([^\"]*\)\".*}/\1/p')
    _debug "received username: $PROTOCOLDNS_USERNAME"
    PROTOCOLDNS_PASSWORD=$(echo "$response" | sed -n 's/^{.*\"password\":[ ]*\"\([^\"]*\)\".*}/\1/p')
    _debug "received password: $PROTOCOLDNS_PASSWORD"
    PROTOCOLDNS_SUBDOMAIN=$(echo "$response" | sed -n 's/^{.*\"subdomain\":[ ]*\"\([^\"]*\)\".*}/\1/p')
    _debug "received subdomain: $PROTOCOLDNS_SUBDOMAIN"
    PROTOCOLDNS_FULLDOMAIN=$(echo "$response" | sed -n 's/^{.*\"fulldomain\":[ ]*\"\([^\"]*\)\".*}/\1/p')
    _info "##########################################################"
    _info "# Create $fulldomain CNAME $PROTOCOLDNS_FULLDOMAIN DNS entry #"
    _info "##########################################################"
    _info "Press enter to continue... "
    read -r _
  fi

  _savedomainconf PROTOCOLDNS_BASE_URL "$PROTOCOLDNS_BASE_URL"
  _savedomainconf PROTOCOLDNS_USERNAME "$PROTOCOLDNS_USERNAME"
  _savedomainconf PROTOCOLDNS_PASSWORD "$PROTOCOLDNS_PASSWORD"
  _savedomainconf PROTOCOLDNS_SUBDOMAIN "$PROTOCOLDNS_SUBDOMAIN"

  export _H1="X-Api-User: $PROTOCOLDNS_USERNAME"
  export _H2="X-Api-Key: $PROTOCOLDNS_PASSWORD"
  data="{\"subdomain\":\"$PROTOCOLDNS_SUBDOMAIN\", \"txt\": \"$txtvalue\"}"

  _debug data "$data"
  response="$(_post "$data" "$PROTOCOLDNS_UPDATE_URL" "" "POST")"
  _debug response "$response"

  if ! echo "$response" | grep "\"$txtvalue\"" >/dev/null; then
    _err "invalid response of protocol-dns"
    return 1
  fi

}

#Usage: fulldomain txtvalue
#Remove the txt record after validation.
dns_protocoldns_rm() {
  fulldomain=$1
  txtvalue=$2
  _info "Using protocol-dns"
  _debug "fulldomain $fulldomain"
  _debug "txtvalue $txtvalue"
}

####################  Private functions below ##################################
