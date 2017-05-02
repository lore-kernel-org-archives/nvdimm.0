Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4300B21A13494
 for <linux-nvdimm@lists.01.org>; Tue,  2 May 2017 13:54:10 -0700 (PDT)
Received: by mail-oi0-x22b.google.com with SMTP id b204so864423oii.1
 for <linux-nvdimm@lists.01.org>; Tue, 02 May 2017 13:54:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <149375673867.14088.8455971000052942105.stgit@djiang5-desk3.ch.intel.com>
References: <149375673867.14088.8455971000052942105.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 May 2017 13:54:08 -0700
Message-ID: <CAPcyv4jYsPCvp5_kgVvGxGy-YT84ADM2QdCRSwGh3kLB+pzeqQ@mail.gmail.com>
Subject: Re: [PATCH v5] ndctl: add clear error support for ndctl
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 2, 2017 at 1:26 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding ndctl support that will allow clearing of bad blocks for a device.
> Initial implementation will only support device dax devices. The ndctl
> takes a device path and parameters of the starting bad block, and the number
> of bad blocks to clear.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>
> v2: Addressed comments from Vishal
> - added bounds checking for the badblocks region.
> - updated verbiage to use badblocks instead of poison.
> - set default len to 1.
> - fixed error out for stat
> - fixed error out that was copy/paste error
> - remove duplicate check_min_kver() in shell script
> - fixed logic of checking empty badblocks
>
> v3: Addressed comments from Toshi
> - Fixed bad region path for badblocks
>
> v4: Address comments from Toshi
> - Added error output for length that exceeds badblock coverage.
>
> v5: Address comments from Toshi
> - Made -l 0 to error out and no length means 1 block cleared.
[..]
> --- /dev/null
> +++ b/ndctl/clear-error.c
> @@ -0,0 +1,241 @@
> +#include <stdio.h>
> +#include <errno.h>
> +#include <stdlib.h>
> +#include <stdint.h>
> +#include <stdbool.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +#include <libgen.h>
> +#include <string.h>
> +#include <limits.h>
> +#include <ccan/short_types/short_types.h>
> +#include <ccan/array_size/array_size.h>
> +#include <util/filter.h>
> +#include <util/parse-options.h>
> +#include <util/log.h>
> +#include <ndctl/libndctl.h>
> +#include <ndctl.h>
> +
> +struct clear_err {
> +       const char *dev_name;
> +       u64 bb_start;
> +       unsigned int bb_len;
> +       struct ndctl_cmd *ars_cap;
> +       struct ndctl_cmd *clear_err;
> +       struct ndctl_bus *bus;
> +       struct ndctl_region *region;
> +       struct ndctl_dax *dax;
> +       struct ndctl_ctx *ctx;
> +} clear_err;

Let's use C99 struct initialization to set the bb_len default:

[..]
} clear_err = {
    .bb_len = 1,
};

[..]
> +read sector len < /sys/bus/platform/devices/nfit_test.0/$dev/$region/badblocks
> +echo "sector: $sector len: $len"
> +
> +# clearing using ndctl
> +$NDCTL clear-error -f /dev/$chardev -s $sector -l $len

Ok, so I'm glad you wrote this test it highlights one mismatched
assumption.  The "ndctl clear-error" options should be device-relative
"sector" offsets not region offsets. So, "ndctl clear-error
/dev/dev0.0 -s 0" should clear device-dax instance offset 0, not
region offset 0 A device-dax instance starts at an offset from the
namespace, and the namespace may start anywhere within a region. So
the clear-error command needs to translate that device-dax sector
offset to the region offset. device-dax offset to namespace offset can
be calculated by subtracting the device-dax instance size from the
namespace size, the namespace offset can be calculated by subtracting
the region resource base from the namespace resource base. Now, the
difficulty will be that the resource values for nfit_test are garbage
because they are vmalloc'd based, I need to give that some thought...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
