#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <sys/klog.h>
MODULE = Linux::Dmesg		PACKAGE = Linux::Dmesg		

#define __PACKAGE__     "Linux::Dmesg"
#define __PACKAGE_LEN__ (sizeof(__PACKAGE__)-1)

#define KERN_EMERG    0  /* system is unusable               */
#define KERN_ALERT    1  /* action must be taken immediately */
#define KERN_CRIT     2  /* critical conditions              */
#define KERN_ERR      3  /* error conditions                 */
#define KERN_WARNING  4  /* warning conditions               */
#define KERN_NOTICE   5  /* normal but significant condition */
#define KERN_INFO     6  /* informational                    */
#define KERN_DEBUG    7  /* debug-level messages             */


PROTOTYPES: ENABLE

BOOT:
{
    HV *stash;
    stash = gv_stashpvn(__PACKAGE__, __PACKAGE_LEN__, TRUE);
    newCONSTSUB(stash, "KERN_EMERG",   newSViv(KERN_EMERG));
    newCONSTSUB(stash, "KERN_ALERT",   newSViv(KERN_ALERT));
    newCONSTSUB(stash, "KERN_CRIT",    newSViv(KERN_CRIT));
    newCONSTSUB(stash, "KERN_ERR",     newSViv(KERN_ERR));
    newCONSTSUB(stash, "KERN_WARNING", newSViv(KERN_WARNING));
    newCONSTSUB(stash, "KERN_NOTICE",  newSViv(KERN_NOTICE));
    newCONSTSUB(stash, "KERN_INFO",    newSViv(KERN_INFO));
    newCONSTSUB(stash, "KERN_DEBUG",   newSViv(KERN_DEBUG));
}


SV* read_buffer()
    CODE:
        char *buf;
        int bufsz = klogctl(10, 0, 0);
        if (bufsz == -1) bufsz = 16384;

        Newx(buf, bufsz, char);
        if (buf == NULL) {
          RETVAL = (SV *)&PL_sv_undef;
        } else {
          int len = klogctl(3, buf, bufsz);
          if (len == -1) {
            RETVAL = (SV *)&PL_sv_undef;
          } else {
            RETVAL = newSVpvn(buf, len);
          }
          Safefree(buf);
        }

    OUTPUT:
        RETVAL


int read_clear_buffer()
    CODE:
        RETVAL = klogctl(4, 0, 0);

    OUTPUT:
        RETVAL


int clear_buffer()
    CODE:
        RETVAL = klogctl(5, 0, 0);

    OUTPUT:
        RETVAL


int disable_printk()
    CODE:
        RETVAL = klogctl(6, 0, 0);

    OUTPUT:
        RETVAL


int enable_printk()
    CODE:
        RETVAL = klogctl(7, 0, 0);

    OUTPUT:
        RETVAL


int printk_level(int level)
    CODE:
        RETVAL = klogctl(8, 0, level);

    OUTPUT:
        RETVAL


int unread_count()
    CODE:
        RETVAL = klogctl(9, 0, 0);

    OUTPUT:
        RETVAL


int buffer_size()
    CODE:
        RETVAL = klogctl(10, 0, 0);

    OUTPUT:
        RETVAL
