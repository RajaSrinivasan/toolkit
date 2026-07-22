#include <stdio.h>
#include <stdint.h>
#include <pb_encode.h>
#include <pb_decode.h>
#include "simple_pb.h"

int set(void *buffer, size_t buflen, uint32_t _seq, uint32_t _now)
{
    size_t message_length;
    bool status;
    
        /* Allocate space on the stack to store the message data.
         *
         * Nanopb generates simple struct definitions for all the messages.
         * - check out the contents of simple.pb.h!
         * It is a good idea to always initialize your structures
         * so that you do not have garbage data from RAM in there.
         */
        msgtime message = msgtime_init_zero;
        
        /* Create a stream that will write to our buffer. */
        pb_ostream_t stream = pb_ostream_from_buffer(buffer, buflen);
        
        /* Fill in the lucky number */
        message.seq = _seq;
        message.now = _now;
        
        /* Now we are ready to encode the message! */
        status = pb_encode(&stream, msgtime_fields, &message);
        message_length = stream.bytes_written;
        
        /* Then just check for any errors.. */
        if (!status)
        {
            printf("Encoding failed: %s\n", PB_GET_ERROR(&stream));
            return -1 ;
        }
        return message_length;
}
  
int get(void *buffer, size_t buflen, uint32_t *_seq, uint32_t *_now)
    
{
    size_t message_length;
    bool status;

    /* Allocate space for the decoded message. */
    msgtime message = msgtime_init_zero;
    /* Create a stream that reads from the buffer. */
    pb_istream_t stream = pb_istream_from_buffer(buffer, buflen);
    
    /* Now we are ready to decode the message. */
    status = pb_decode(&stream, msgtime_fields, &message);
        
        /* Check for errors... */
    if (!status)
    {
        printf("Decoding failed: %s\n", PB_GET_ERROR(&stream));
        return -1;
    }
    *_seq = message.seq ;
    *_now = message.now ;
    return 0;
}

