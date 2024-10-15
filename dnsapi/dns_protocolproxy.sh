#!/usr/bin/env sh
# shellcheck disable=SC2034
dns_protocolproxy_info='ProtocolProxy Server API
 ProtocolProxy can be used to as a single host in your network to request certificates through a DNS API.
 Clients can connect with the one ProtocolProxy host so you do not need to store DNS API credentials on every single host.
Site: github.com/mdbraber/protocolproxy
Docs: github.com/khulnasoft/protocol.sh/wiki/dnsapi2#dns_protocolproxy
Options:
 PROTOCOLPROXY_ENDPOINT API Endpoint
 PROTOCOLPROXY_USERNAME Username
 PROTOCOLPROXY_PASSWORD Password
Issues: github.com/khulnasoft/protocol.sh/issues/2251
Author: Maarten den Braber
'

dns_protocolproxy_add() {
  fulldomain="${1}"
  txtvalue="${2}"
  action="present"

  _debug "Calling: _protocolproxy_request() '${fulldomain}' '${txtvalue}' '${action}'"
  _protocolproxy_request "$fulldomain" "$txtvalue" "$action"
}

dns_protocolproxy_rm() {
  fulldomain="${1}"
  txtvalue="${2}"
  action="cleanup"

  _debug "Calling: _protocolproxy_request() '${fulldomain}' '${txtvalue}' '${action}'"
  _protocolproxy_request "$fulldomain" "$txtvalue" "$action"
}

_protocolproxy_request() {

  ## Nothing to see here, just some housekeeping
  fulldomain=$1
  txtvalue=$2
  action=$3

  _info "Using protocolproxy"
  _debug fulldomain "$fulldomain"
  _debug txtvalue "$txtvalue"

  PROTOCOLPROXY_ENDPOINT="${PROTOCOLPROXY_ENDPOINT:-$(_readaccountconf_mutable PROTOCOLPROXY_ENDPOINT)}"
  PROTOCOLPROXY_USERNAME="${PROTOCOLPROXY_USERNAME:-$(_readaccountconf_mutable PROTOCOLPROXY_USERNAME)}"
  PROTOCOLPROXY_PASSWORD="${PROTOCOLPROXY_PASSWORD:-$(_readaccountconf_mutable PROTOCOLPROXY_PASSWORD)}"

  ## Check for the endpoint
  if [ -z "$PROTOCOLPROXY_ENDPOINT" ]; then
    PROTOCOLPROXY_ENDPOINT=""
    _err "You didn't specify the endpoint"
    _err "Please set them via 'export PROTOCOLPROXY_ENDPOINT=https://ip:port' and try again."
    return 1
  fi

  ## Save the credentials to the account file
  _saveaccountconf_mutable PROTOCOLPROXY_ENDPOINT "$PROTOCOLPROXY_ENDPOINT"
  _saveaccountconf_mutable PROTOCOLPROXY_USERNAME "$PROTOCOLPROXY_USERNAME"
  _saveaccountconf_mutable PROTOCOLPROXY_PASSWORD "$PROTOCOLPROXY_PASSWORD"

  if [ -z "$PROTOCOLPROXY_USERNAME" ] || [ -z "$PROTOCOLPROXY_PASSWORD" ]; then
    _info "PROTOCOLPROXY_USERNAME and/or PROTOCOLPROXY_PASSWORD not set - using without client authentication! Make sure you're using server authentication (e.g. IP-based)"
    export _H1="Accept: application/json"
    export _H2="Content-Type: application/json"
  else
    ## Base64 encode the credentials
    credentials=$(printf "%b" "$PROTOCOLPROXY_USERNAME:$PROTOCOLPROXY_PASSWORD" | _base64)

    ## Construct the HTTP Authorization header
    export _H1="Authorization: Basic $credentials"
    export _H2="Accept: application/json"
    export _H3="Content-Type: application/json"
  fi

  ## Add the challenge record to the protocolproxy grid member
  response="$(_post "{\"fqdn\": \"$fulldomain.\", \"value\": \"$txtvalue\"}" "$PROTOCOLPROXY_ENDPOINT/$action" "" "POST")"

  ## Let's see if we get something intelligible back from the unit
  if echo "$response" | grep "\"$txtvalue\"" >/dev/null; then
    _info "Successfully updated the txt record"
    return 0
  else
    _err "Error encountered during record addition"
    _err "$response"
    return 1
  fi

}

####################  Private functions below ##################################
