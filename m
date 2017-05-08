Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B63921A0BAA9
 for <linux-nvdimm@lists.01.org>; Mon,  8 May 2017 16:28:21 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id w10so69072028oif.0
 for <linux-nvdimm@lists.01.org>; Mon, 08 May 2017 16:28:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <149428467512.44955.4085670669863366983.stgit@djiang5-desk3.ch.intel.com>
References: <149428467512.44955.4085670669863366983.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 8 May 2017 16:28:19 -0700
Message-ID: <CAPcyv4jniszzAUaz=cZA0nGxej8=WONF2rnxiK768bqgGv8nqg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ndctl: add foreach helper for region badblocks in
 libndctl
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

On Mon, May 8, 2017 at 4:04 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> The helper function allow iteration through the badblocks file that's part
> of the region sysfs attributes. This will support the region list badblocks
> code that's coming.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/lib/libndctl.c   |   72 ++++++++++++++++++++++++++++++++++++++++++++++++
>  ndctl/lib/libndctl.sym |    2 +
>  ndctl/libndctl.h.in    |   10 +++++++
>  3 files changed, 84 insertions(+)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index ac1fc63..40d9463 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -229,6 +229,8 @@ struct ndctl_region {
>                 int state;
>                 unsigned long long cookie;
>         } iset;
> +       FILE *badblocks;
> +       struct badblock bb;
>  };
>
>  /**
> @@ -1867,6 +1869,76 @@ NDCTL_EXPORT struct ndctl_dimm *ndctl_region_get_next_dimm(struct ndctl_region *
>         return NULL;
>  }
>
> +static int regions_badblocks_init(struct ndctl_region *region)
> +{
> +       struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
> +       char *bb_path;
> +       int rc = 0;
> +
> +       /* if the file is already open */
> +       if (region->badblocks) {
> +               fclose(region->badblocks);
> +               region->badblocks = NULL;
> +       }
> +
> +       if (asprintf(&bb_path, "%s/badblocks",
> +                               region->region_path) < 0) {
> +               rc = -errno;
> +               err(ctx, "region badblocks path allocation failure\n");
> +               return rc;
> +       }
> +
> +       region->badblocks = fopen(bb_path, "r");

Can you change this to fopen(bb_path, "re") so that we get O_CLOEXEC behavior?

> +       if (!region->badblocks) {
> +               rc = -errno;
> +               free(bb_path);
> +               return -rc;
> +       }
> +
> +       free(bb_path);
> +       return rc;
> +}
> +
> +NDCTL_EXPORT struct badblock *ndctl_region_get_next_badblock(struct ndctl_region *region)
> +{
> +       int rc;
> +       char *buf = NULL;
> +       size_t rlen = 0;
> +
> +       if (!region->badblocks)
> +               return NULL;
> +
> +       rc = getline(&buf, &rlen, region->badblocks);
> +       if (rc == -1) {
> +               free(buf);
> +               return NULL;
> +       }
> +
> +       rc = sscanf(buf, "%llu %u", &region->bb.offset, &region->bb.len);
> +       free(buf);
> +       if (rc != 2) {
> +               /* end of the road, clean up */

What if they only consume the first entry and never get here? I think
we need to clean up any leftovers and free_region() time as well.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
