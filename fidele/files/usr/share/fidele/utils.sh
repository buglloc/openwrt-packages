#!/bin/sh

FIDELE_LUKS_PATH="/usr/share/fidele/fidele.extroot"
FIDELE_LUKS_LABLE="extroot"
FIDELE_ASSERT_PATH="/etc/fidele.f2ap"
FIDELE_RP="fidele@buglloc"
FIDELE_USER_NAME="gabriel"
FIDELE_UP_REQUIRED="true"
FIDELE_UV_REQUIRED="true"

if [ -r /etc/fidele.conf ]; then
  . /etc/fidele.conf
fi

base64_blob() {
    dd if=/dev/urandom bs=1 count=32 2> /dev/null | base64
}

fido2_device() {
    device=$(fido2-token -L | sed 's/:.*//')
    if [ -z "$device" ] ; then
        return 1
    else
        echo "$device"
    fi
}

fido2_new_credential() {
    # When making a credential, fido2-cred expects its input to consist of:
    #  1. client data hash (base64 blob);
    #  2. relying party id (UTF-8 string);
    #  3. user name (UTF-8 string);
    #  4. user id (base64 blob).
    param_file=$(mktemp)
    echo $(base64_blob) > $param_file
    echo $FIDELE_RP >> $param_file
    echo $FIDELE_USER_NAME >> $param_file
    echo $(base64_blob) >> $param_file

    cred_flags="-M -h"
    if [ "$FIDELE_UV_REQUIRED" = "true" ]; then
        cred_flags="$cred_flags -v"
    fi

    # Upon the successful generation of a credential, fido2-cred outputs:
    #  1. client data hash (base64 blob);
    #  2. relying party id (UTF-8 string);
    #  3. credential format (UTF-8 string);
    #  4. authenticator data (base64 blob);
    #  5. credential id (base64 blob);
    #  6. attestation signature (base64 blob);
    #  7. attestation certificate, if present (base64 blob).

    echo "Touch Fido2 device button to generate a new credentials" >&2
    credential_id=$(fido2-cred $cred_flags -i $param_file $(fido2_device) | sed -n "5p" || (rm -f $param_file ; exit 1))
    rm -f "$param_file"
    if [ -z "$credential_id" ] ; then
      echo "No crenedtial id was generated"
      exit 1
    fi

    # When obtaining an assertion, fido2-assert expects its input to consist of:
    #  1. client data hash (base64 blob);
    #  2. relying party id (UTF-8 string);
    #  4. credential id, if credential not resident (base64 blob);
    #  5. hmac salt, if the FIDO2 hmac-secret extension is enabled (base64 blob);
    param_file=$(mktemp)
    echo "#CLIENT_DATA_HASH#" > $param_file
    echo $FIDELE_RP >> $param_file
    echo $credential_id >> $param_file
    echo $(base64_blob) >> $param_file
    mv "$param_file" "$FIDELE_ASSERT_PATH"
}

fido2_print_passphrase() {
    param_file=$(mktemp)
    client_data_hash=$(dd if=/dev/urandom bs=1 count=32 2> /dev/null | base64)
    cat "$FIDELE_ASSERT_PATH" | sed "s@#CLIENT_DATA_HASH#@${client_data_hash}@" > $param_file

    assert_flags="-G -h"
    assert_flags="$assert_flags -t up=$FIDELE_UP_REQUIRED"

    if [ ! -z "$FIDELE_PIN" ] ; then
        assert_flags="$assert_flags -t pin=true"
        assert_flags="$assert_flags -t uv=$FIDELE_UV_REQUIRED"
    fi

    # For each generated assertion, fido2-assert outputs:
    # 1. client data hash (base64 blob);
    # 2. relying party id (UTF-8 string);
    # 3. authenticator data (base64 blob);
    # 4. assertion signature (base64 blob);
    # 5. user id, if credential resident (base64 blob);
    # 6. hmac secret, if the FIDO2 hmac-secret extension is enabled (base64 blob);

    echo "Touch Fido2 device button to get passphrase" >&2
    echo $(echo -n "$FIDELE_PIN" | fido2-assert $assert_flags -i "$param_file" $(fido2_device) | tail -1 || (rm -f $param_file ; exit 1))
    rm -f "$param_file"
}
