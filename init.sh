#!/bin/bash -x

env | sort

pin=${SOFTHSM_PIN:-1234}
sopin=${SOFTHSM_SOPIN:-0000}
keyid=${SOFTHSM_KEYID:-BEEF}
PKCS11_DAEMON_SOCKET="tcp://0.0.0.0:${SOFTHSM_PORT:-5657}"

env | sort

if ! [[ -f /var/lib/softhsm/key.pem ]]
then
  openssl genrsa -out /var/lib/softhsm/key.pem 4096
fi

if ! [[ -f /var/lib/softhsm/slot0.db ]]
then
  softhsm2-util --init-token --slot 0 --label key --pin $pin --so-pin $sopin
  SLOTNO=`softhsm2-util --show-slots | grep ^Slot | sed '1!d;s/Slot \(.*\)/\1/'`
  softhsm2-util --import /var/lib/softhsm/key.pem --slot $SLOTNO --label key --id BEEF --pin $pin
fi


/usr/local/bin/pkcs11-daemon /usr/lib/x86_64-linux-gnu/softhsm/libsofthsm2.so
