Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E5FBC21A1348D
 for <linux-nvdimm@lists.01.org>; Fri,  5 May 2017 12:41:57 -0700 (PDT)
Subject: Re: [PATCH v6 1/3] ndctl: add clear-error to ndctl for device dax
References: <149393422747.2642.5136375594842641153.stgit@djiang5-desk3.ch.intel.com>
 <149393454140.2642.16610436149753296619.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4j0DKBBfjybWmkqNByJqL4VA_fw-0myLggBYiScvkMc2g@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <590CD566.6090307@hpe.com>
Date: Fri, 5 May 2017 15:41:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4j0DKBBfjybWmkqNByJqL4VA_fw-0myLggBYiScvkMc2g@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 05/05/2017 03:14 PM, Dan Williams wrote:
> On Thu, May 4, 2017 at 2:49 PM, Dave Jiang <dave.jiang@intel.com> wrote:
>> Adding ndctl support that will allow clearing of bad blocks for a device.
>> Initial implementation will only support device dax devices. The ndctl
>> takes a device path and parameters of the starting bad block, and the number
>> of bad blocks to clear.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  Documentation/ndctl-clear-error.txt |   38 ++++++
>>  builtin.h                           |    1
>>  ndctl/Makefile.am                   |    1
>>  ndctl/clear-error.c                 |  239 +++++++++++++++++++++++++++++++++++
>>  ndctl/lib/libndctl.c                |   72 +++++++++++
>>  ndctl/lib/libndctl.sym              |    2
>>  ndctl/libndctl.h.in                 |   10 +
>>  ndctl/ndctl.c                       |    1
>>  8 files changed, 364 insertions(+)
>>  create mode 100644 Documentation/ndctl-clear-error.txt
>>  create mode 100644 ndctl/clear-error.c
>>
>> diff --git a/Documentation/ndctl-clear-error.txt b/Documentation/ndctl-clear-error.txt
>> new file mode 100644
>> index 0000000..b14521a
>> --- /dev/null
>> +++ b/Documentation/ndctl-clear-error.txt
>> @@ -0,0 +1,38 @@
>> +ndctl-clear-error(1)
>> +====================
>> +
>> +NAME
>> +----
>> +ndctl-clear-error - clear badblocks for a device
> 
> I think "clear-error" is too ambiguous of a name, lets call the
> commands repair-media-errors and list-media-errors.
> 
> I'd also like to see the list-media-errors patch first in the series
> since repairing is just an incremental step on top of listing. I don't
> think the word "badblocks" should appear anywhere in this document.
> That's a kernel implementation detail.

Is this just for device dax?  If so, that should be more clear in the text,
rather than just used in the example.  If it's for other types of pmem devices,
then badblocks would make sense to keep, assuming it relates to the
badblocks information exposed in /sys.

> The other benefit of "repair" vs "clear" is communicating that the
> data may be indeterminate after repair. 

For me, repair means you fixed it. If you want to communicate that the
data is indeterminate, I think you should say that in the doc rather
than assuming people interpret the word the same way you do.

> Hopefully in the future we'll
> get a standard mechanism to determine if the platform supports atomic
> error clearing with a determinate value.
> 
>> +
>> +SYNOPSIS
>> +--------
>> +[verse]
>> +'ndctl clear-error' [<options>]
>> +
>> +EXAMPLES
>> +--------
>> +
>> +Clear poison (bad blocks) for the provided device
>> +[verse]
>> +ndctl clear-error -f /dev/dax0.0 -s 0 -l 8
>> +
>> +Clear poison (bad blocks) at block offset 0 for 8 blocks on device /dev/dax0.0
> 
> The "poison" term is x86 specific. Lets just use "media error" everywhere.

If you really mean uncorrectable error reported by an Address Range Scrub, you
could say that too.  Or are there other types of media errors that this could
work with?

> 
>> +
>> +OPTIONS
>> +-------
>> +-f::
>> +--file::
>> +       The device/file to be cleared of poison (bad blocks).
> 
> Let's make this --d/--device and drop the "file" option. For files on
> filesystems there's other ways to clear errors and I wouldn't
> necessarily want them to use this tool. Should also make it clear that
> the device argument must refer to a device in an nvdimm bus hierarchy.
> 
>> +
>> +-s::
>> +--start::
>> +       The offset where the poison (bad block) starts for this device.
>> +       Typically this is acquired from the sysfs badblocks file.
> 
> I assume this is in terms of 512-byte blocks, but we should clarify
> the units. The second sentence can be reworded to recommend using the
> list-media-errors command. Lets call the option -o / --offset and also
> allow a "-o all" to repair all errors reported by list-media-errors.
> 
>> +
>> +-l::
>> +--len::
>> +       The number of badblocks to clear in size of 512 bytes increments. The
>> +       length must fit within the badblocks range. If the length exceeds the
>> +       badblock range or is 0, the command will fail. Not providing a len
>> +       will result in a single block being cleared.
> 
> s/badblocks/media error/

If it's really not a badblock, does the 512 byte increment still make sense?
There's a DSM to get the unit size for what can be cleared which may not
be 512.  If the clearable unit is smaller, we're clearing too much.  If the unit
is larger, then we can't clear less than that.

-- ljk

> 
> s/--len/--length/
> 
>> diff --git a/builtin.h b/builtin.h
>> index a8bc848..f522d00 100644
>> --- a/builtin.h
>> +++ b/builtin.h
>> @@ -30,4 +30,5 @@ int cmd_test(int argc, const char **argv, void *ctx);
>>  #ifdef ENABLE_DESTRUCTIVE
>>  int cmd_bat(int argc, const char **argv, void *ctx);
>>  #endif
>> +int cmd_clear_error(int argc, const char **argv, void *ctx);
>>  #endif /* _NDCTL_BUILTIN_H_ */
>> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
>> index d346c04..8123169 100644
>> --- a/ndctl/Makefile.am
>> +++ b/ndctl/Makefile.am
>> @@ -11,6 +11,7 @@ ndctl_SOURCES = ndctl.c \
>>                  ../util/log.c \
>>                 list.c \
>>                 test.c \
>> +               clear-error.c \
>>                 ../util/json.c
>>
>>  if ENABLE_SMART
>> diff --git a/ndctl/clear-error.c b/ndctl/clear-error.c
>> new file mode 100644
>> index 0000000..29cd471
>> --- /dev/null
>> +++ b/ndctl/clear-error.c
>> @@ -0,0 +1,239 @@
>> +#include <stdio.h>
>> +#include <errno.h>
>> +#include <stdlib.h>
>> +#include <stdint.h>
>> +#include <stdbool.h>
>> +#include <sys/types.h>
>> +#include <sys/stat.h>
>> +#include <unistd.h>
>> +#include <libgen.h>
>> +#include <string.h>
>> +#include <limits.h>
>> +#include <ccan/short_types/short_types.h>
>> +#include <ccan/array_size/array_size.h>
>> +#include <util/parse-options.h>
>> +#include <util/log.h>
>> +#include <ndctl/libndctl.h>
>> +#include <ndctl.h>
>> +
>> +struct clear_err {
>> +       const char *dev_name;
>> +       u64 bb_start;
>> +       unsigned int bb_len;
>> +       struct ndctl_cmd *ars_cap;
>> +       struct ndctl_cmd *clear_err;
>> +       struct ndctl_bus *bus;
>> +       struct ndctl_region *region;
>> +       struct ndctl_dax *dax;
>> +       struct ndctl_ctx *ctx;
>> +} clear_err = {
>> +       .bb_len = 1,
>> +};
>> +
>> +static int send_clear_error(struct ndctl_bus *bus, u64 start, u64 size)
>> +{
>> +       u64 cleared;
>> +       int rc;
>> +
>> +       clear_err.clear_err = ndctl_bus_cmd_new_clear_error(
>> +                       start, size, clear_err.ars_cap);
>> +       if (!clear_err.clear_err) {
>> +               error("%s: bus: %s failed to create cmd\n",
>> +                               __func__, ndctl_bus_get_provider(bus));
>> +               return -ENXIO;
>> +       }
>> +
>> +       rc = ndctl_cmd_submit(clear_err.clear_err);
>> +       if (rc) {
>> +               error("%s: bus: %s failed to submit cmd: %d\n",
>> +                               __func__, ndctl_bus_get_provider(bus), rc);
>> +               ndctl_cmd_unref(clear_err.clear_err);
>> +               return rc;
>> +       }
>> +
>> +       cleared = ndctl_cmd_clear_error_get_cleared(clear_err.clear_err);
>> +       if (cleared != size) {
>> +               error("%s: bus: %s expected to clear: %ld actual: %ld\n",
>> +                               __func__, ndctl_bus_get_provider(bus),
>> +                               size, cleared);
>> +               return -ENXIO;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int get_ars_cap(struct ndctl_bus *bus, u64 start, u64 size)
>> +{
>> +       int rc;
>> +
>> +       clear_err.ars_cap = ndctl_bus_cmd_new_ars_cap(bus, start, size);
>> +       if (!clear_err.ars_cap) {
>> +               error("%s: bus: %s failed to create cmd\n",
>> +                               __func__, ndctl_bus_get_provider(bus));
>> +               return -ENOTTY;
>> +       }
>> +
>> +       rc = ndctl_cmd_submit(clear_err.ars_cap);
>> +       if (rc) {
>> +               error("%s: bus: %s failed to submit cmd: %d\n",
>> +                               __func__, ndctl_bus_get_provider(bus), rc);
>> +               ndctl_cmd_unref(clear_err.ars_cap);
>> +               return rc;
>> +       }
>> +
>> +       if (ndctl_cmd_ars_cap_get_size(clear_err.ars_cap) <
>> +                       sizeof(struct nd_cmd_ars_status)){
>> +               error("%s: bus: %s expected size >= %zd got: %d\n",
>> +                               __func__, ndctl_bus_get_provider(bus),
>> +                               sizeof(struct nd_cmd_ars_status),
>> +                               ndctl_cmd_ars_cap_get_size(clear_err.ars_cap));
>> +               ndctl_cmd_unref(clear_err.ars_cap);
>> +               return -ENXIO;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int match_dev(struct clear_err *ce, char *dev_name)
>> +{
>> +       ndctl_bus_foreach(ce->ctx, ce->bus)
>> +               ndctl_region_foreach(ce->bus, ce->region)
>> +                       ndctl_dax_foreach(ce->region, ce->dax)
>> +                               if (strncmp(basename(dev_name),
>> +                                       ndctl_dax_get_devname(ce->dax), 256)
> 
> This device is an nvdimm nd_dax device, not a device-dax character
> device instance. See calls to util_daxctl_region_to_json() and the
> implementation of that routine for how to lookup the device-dax
> character device from the ndctl_dax instance returned by
> ndctl_dax_foreach().
> 
> I don't like that this routine is silently trampling on ce->dax. If it
> finds the proper dax instance it should return it directly or NULL
> otherwise.
> 
> Lastly you'll need to match by actual major:minor number otherwise how
> do you know that an argument of /dev/my-special-device-dax-symlink
> refers to the device-dax instance you're attempting to match?
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
