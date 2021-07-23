#!/bin/bash
 
case "$1" in
# События при поступлении SMS-сообщения.
RECEIVED)
        # Проверка кодировки тела входящего SMS-сообщения.
        # Если кодировка UCS2, то перекодируем в UTF-8
        if grep "Alphabet: UCS2" $2 > /dev/null; then
                head -5 "$2" | grep -e "^From: " -e "^Received: " >> /var/log/sms/incoming.txt
                sed -e '1,/^$/ d' $2 | recode UCS-2..utf8 >> /var/log/sms/incoming.txt
                echo "========================================" >> /var/log/sms/incoming.txt
        else
                head -5 "$2" | grep -e "^From: " -e "^Received: " >> /var/log/sms/incoming.txt
                sed -e '1,/^$/ d' $2 >> /var/log/sms/incoming.txt
                echo "========================================" >> /var/log/sms/incoming.txt
        fi
 
;;
# События при исходящих SMS-сообщениях.
SENT)
        # Проверяем кодировку тела исходящего SMS-сообщения.
        # Если кодировка UCS, то перекодируем в UTF-8
        if grep "Alphabet: UCS" $2 > /dev/null; then
                sed -e '1,/^$/ d' $2 | recode UCS-2..utf8 >> /var/log/sms/send.txt
                echo "========================================" >> /var/log/sms/send.txt
        else
                sed -e '1,/^$/ d' $2 >> /var/log/sms/send.txt
                echo "========================================" >> /var/log/sms/send.txt
        fi
;;
# События при получении ответа на USSD-запрос.
USSD)
;;
esac
