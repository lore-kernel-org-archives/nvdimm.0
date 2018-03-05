Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B88DF2034D8CB
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 15:28:37 -0800 (PST)
Received: by mail-oi0-x243.google.com with SMTP id c18so13444515oiy.9
 for <linux-nvdimm@lists.01.org>; Mon, 05 Mar 2018 15:34:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151977845090.31131.6667674364134899336.stgit@djiang5-desk3.ch.intel.com>
References: <151977844514.31131.543078368987798636.stgit@djiang5-desk3.ch.intel.com>
 <151977845090.31131.6667674364134899336.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 5 Mar 2018 15:34:49 -0800
Message-ID: <CAPcyv4hsDY-bjw27Vi2mPxD67ve1C=jqN6pdYrix947k5Xfh8w@mail.gmail.com>
Subject: Re: [PATCH 2/2] ndctl: merge firmware-update to dimm.c as one of the
 dimm ops
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 27, 2018 at 4:40 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Since update-firmware replicate a lot of the parsing code that dimm.c
> already uses, moving update-firmware to dimm.c and utilize the already
> working functionalities.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/Makefile.am |    1
>  ndctl/dimm.c      |  495 ++++++++++++++++++++++++++++++++++++++++++++++++
>  ndctl/update.c    |  549 -----------------------------------------------------
>  3 files changed, 493 insertions(+), 552 deletions(-)
>  delete mode 100644 ndctl/update.c

Looks good, although I notice some things now that I didn't realize
when this was first merged. Something to follow up on later...

[..]
> diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> index 7259506f..576e6342 100644
> --- a/ndctl/dimm.c
> +++ b/ndctl/dimm.c
> @@ -13,6 +13,8 @@
>  #include <stdio.h>
>  #include <errno.h>
>  #include <stdlib.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
>  #include <unistd.h>
>  #include <limits.h>
>  #include <syslog.h>
> @@ -29,11 +31,49 @@
>  #include <ccan/minmax/minmax.h>
>  #include <ccan/array_size/array_size.h>
>
> +#define ND_CMD_STATUS_SUCCESS  0
> +#define ND_CMD_STATUS_NOTSUPP  1
> +#define        ND_CMD_STATUS_NOTEXIST  2
> +#define ND_CMD_STATUS_INVALPARM        3
> +#define ND_CMD_STATUS_HWERR    4
> +#define ND_CMD_STATUS_RETRY    5
> +#define ND_CMD_STATUS_UNKNOWN  6
> +#define ND_CMD_STATUS_EXTEND   7
> +#define ND_CMD_STATUS_NORES    8
> +#define ND_CMD_STATUS_NOTREADY 9

It would be nice to translate these into standard posix error codes,
but that's a change for the future when we go to add support for a
NVDIMM_FAMILY_INTEL firmware update procedure.

> +
> +#define ND_CMD_STATUS_START_BUSY       0x10000
> +#define ND_CMD_STATUS_SEND_CTXINVAL    0x10000
> +#define ND_CMD_STATUS_FIN_CTXINVAL     0x10000
> +#define ND_CMD_STATUS_FIN_DONE         0x20000
> +#define ND_CMD_STATUS_FIN_BAD          0x30000
> +#define ND_CMD_STATUS_FIN_ABORTED      0x40000
> +#define ND_CMD_STATUS_FQ_CTXINVAL      0x10000
> +#define ND_CMD_STATUS_FQ_BUSY          0x20000
> +#define ND_CMD_STATUS_FQ_BAD           0x30000
> +#define ND_CMD_STATUS_FQ_ORDER         0x40000

These all seem to be binary api hard coded to the Intel format. These
might need pushing down into the library behind the abstraction. The
fact that these are in ndctl/dimm.c and not ndct/libndctl.h leads me
to believe that it's currently impossible to use the firmware update
library APIs in a 3rd party application, right?

> +
> +struct fw_info {
> +       uint32_t store_size;
> +       uint32_t update_size;
> +       uint32_t query_interval;
> +       uint32_t max_query;
> +       uint64_t run_version;
> +       uint32_t context;
> +};
> +
> +struct update_context {
> +       size_t fw_size;
> +       struct fw_info dimm_fw;
> +       struct ndctl_cmd *start;
> +};
> +
>  struct action_context {
>         struct json_object *jdimms;
>         enum ndctl_namespace_version labelversion;
>         FILE *f_out;
>         FILE *f_in;
> +       struct update_context update;
>  };

These definitions can move to their own ndctl/firmware-update.h header
file in the future.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
