Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22BBA21A04804
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 17:31:31 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id g204so29539485oib.1
 for <linux-nvdimm@lists.01.org>; Fri, 07 Apr 2017 17:31:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <149160287433.35898.11185611077109003916.stgit@djiang5-desk3.ch.intel.com>
References: <149160286313.35898.16564013661054174450.stgit@djiang5-desk3.ch.intel.com>
 <149160287433.35898.11185611077109003916.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 7 Apr 2017 17:31:30 -0700
Message-ID: <CAPcyv4hnx6dN-v4PRNyGbypY+AQG=VJ=DM6WFzBx4nHHZGJz4w@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] libnvdimm: add support for clear poison list and
 badblocks for device dax
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

On Fri, Apr 7, 2017 at 3:07 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Providing mechanism to clear poison list via the ndctl ND_CMD_CLEAR_ERROR
> call. We will update the poison list and also the badblocks at region level
> if the region is in dax mode or in pmem mode and not active. In other
> words we force badblocks to be cleared through write requests if the
> address is currently accessed through a block device, otherwise it can
> only be done via the ioctl+dsm path.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/nvdimm/bus.c      |   78 +++++++++++++++++++++++++++++++++++++++++----
>  drivers/nvdimm/core.c     |   17 ++++++++--
>  drivers/nvdimm/region.c   |   25 ++++++++++++++
>  include/linux/libnvdimm.h |    7 +++-
>  4 files changed, 115 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 351bac8..af64e9c 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -27,6 +27,7 @@
>  #include <linux/nd.h>
>  #include "nd-core.h"
>  #include "nd.h"
> +#include "pfn.h"
>
>  int nvdimm_major;
>  static int nvdimm_bus_major;
> @@ -218,11 +219,19 @@ long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
>         if (cmd_rc < 0)
>                 return cmd_rc;
>
> -       nvdimm_clear_from_poison_list(nvdimm_bus, phys, len);
>         return clear_err.cleared;

This seems like a typo. We want to clear poison in the pmem write path.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
