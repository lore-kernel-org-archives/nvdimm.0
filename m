Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B9A9921A02937
 for <linux-nvdimm@lists.01.org>; Tue, 18 Sep 2018 13:53:14 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id y207-v6so3078655oie.13
 for <linux-nvdimm@lists.01.org>; Tue, 18 Sep 2018 13:53:14 -0700 (PDT)
MIME-Version: 1.0
References: <20180918200750.4413-1-vishal.l.verma@intel.com>
In-Reply-To: <20180918200750.4413-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 18 Sep 2018 13:53:01 -0700
Message-ID: <CAPcyv4gnrEbSvQeVR_FpcZmWPMvHoQ3Gg3qsdYvp_7dyvOn-sw@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm, pfn: during init,
 clear errors in the metadata area
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
To: Vishal L Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 18, 2018 at 1:08 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> If there are badblocks present in the 'struct page' area for pfn
> namespaces, until now, the only way to clear them has been to force the
> namespace into raw mode, clear the errors, and re-enable the fsdax mode.
> This is clunky, given that it should be easy enough for the pfn driver
> to do the same.
>
> Add a new helper that uses the most recently available badblocks list to
> check whether there are any badblocks that lie in the volatile struct
> page area. If so, before initializing the struct pages, send down
> targeted writes via nvdimm_write_bytes to write zeroes to the affected
> blocks, and thus clear errors.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/nvdimm/pfn_devs.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
>
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 3f7ad5bc443e..04b341758cd6 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -361,8 +361,59 @@ struct device *nd_pfn_create(struct nd_region *nd_region)
>         return dev;
>  }
>

Perhaps a comment here about the fact that we are clearing the
volatile memmap metadata space associated with a pfn instance.

> +static int nd_pfn_clear_meta_errors(struct nd_pfn *nd_pfn)

Let's just say "memmap" rather than "meta" to be more explicit.

> +{
> +       struct nd_region *nd_region = to_nd_region(nd_pfn->dev.parent);
> +       struct nd_namespace_common *ndns = nd_pfn->ndns;
> +       void *zero_page = page_address(ZERO_PAGE(0));
> +       struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
> +       sector_t first_bad, meta_start;
> +       struct nd_namespace_io *nsio;
> +       int num_bad, meta_num, rc;
> +       bool bb_present;
> +
> +       nsio = to_nd_namespace_io(&ndns->dev);
> +       meta_start = (SZ_4K + sizeof(*pfn_sb)) >> 9;
> +       meta_num = (le64_to_cpu(pfn_sb->dataoff) >> 9) - meta_start;
> +
> +       do {
> +               unsigned long zero_len;
> +               u64 nsoff;
> +
> +               bb_present = !!badblocks_check(&nd_region->bb, meta_start,
> +                               meta_num, &first_bad, &num_bad);

The !! throws me off, I don't think it's necessary. You could just
make bb_present an int.

> +               if (bb_present) {
> +                       dev_dbg(&nd_pfn->dev, "meta: %x badblocks at %lx\n",
> +                                       num_bad, first_bad);
> +                       nsoff = (nd_region->ndr_start + (first_bad << 9)) -
> +                                       nsio->res.start;

Perhaps this should be ALIGN_DOWN((nd_region->ndr_start + (first_bad
<< 9)) - nsio->res.start, PAGE_SIZE)...

> +                       zero_len = num_bad << 9;

...and then make this ALIGN(num_bad << 9, PAGE_SIZE), or otherwise a
comment about zero_len being zero...

> +                       while (zero_len) {
> +                               unsigned long chunk = min(zero_len, PAGE_SIZE);

...because the min(x, PAGE_SIZE) seems arbitrary.

Aligned clearing may be preferable considering we may be needing to
fixup page protections.

> +
> +                               rc = nvdimm_write_bytes(ndns, nsoff, zero_page,
> +                                                       chunk, 0);
> +                               if (rc)
> +                                       break;
> +
> +                               zero_len -= chunk;
> +                               nsoff += chunk;
> +                       }
> +                       if (rc) {
> +                               dev_err(&nd_pfn->dev,
> +                                       "error clearing %x badblocks at %lx\n",
> +                                       num_bad, first_bad);
> +                               return rc;
> +                       }
> +               }
> +       } while (bb_present);
> +
> +       return 0;
> +}
> +
>  int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>  {
> +       int rc;
>         u64 checksum, offset;
>         enum nd_pfn_mode mode;
>         struct nd_namespace_io *nsio;
> @@ -477,6 +528,12 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>                 return -ENXIO;
>         }
>
> +       if (mode == PFN_MODE_PMEM) {
> +               rc = nd_pfn_clear_meta_errors(nd_pfn);
> +               if (rc)
> +                       return rc;

I think this can just be "return nd_pfn_clear_meta_errors()", and
maybe move the mode check inside nd_pfn_clear_meta_errors() to return
early if no volatile metadata to clear.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
