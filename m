Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x229.google.com (mail-it0-x229.google.com
 [IPv6:2607:f8b0:4001:c0b::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E7A8481CC4
 for <linux-nvdimm@lists.01.org>; Wed,  9 Nov 2016 15:39:53 -0800 (PST)
Received: by mail-it0-x229.google.com with SMTP id u205so308340575itc.0
 for <linux-nvdimm@lists.01.org>; Wed, 09 Nov 2016 15:39:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <147873364251.45471.9613527969861188296.stgit@djiang5-desk3.ch.intel.com>
References: <147873364251.45471.9613527969861188296.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Nov 2016 15:39:56 -0800
Message-ID: <CAPcyv4iez0t0=zAJypr5C6yMm3QN=veHWggbB-hRx8q-FA4r_A@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: check and clear poison before writing to pmem
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

On Wed, Nov 9, 2016 at 3:20 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> We need to clear any poison when we are writing to pmem. The granularity
> will be sector size. If it's less then we can't do anything about it
> barring corruption.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/claim.c |   20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
> index d5dc80c..2078d25 100644
> --- a/drivers/nvdimm/claim.c
> +++ b/drivers/nvdimm/claim.c
> @@ -226,6 +226,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>                 resource_size_t offset, void *buf, size_t size, int rw)
>  {
>         struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
> +       unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
>
>         if (unlikely(offset + size > nsio->size)) {
>                 dev_WARN_ONCE(&ndns->dev, 1, "request out of range\n");
> @@ -233,12 +234,27 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>         }
>
>         if (rw == READ) {
> -               unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
> -
>                 if (unlikely(is_bad_pmem(&nsio->bb, offset / 512, sz_align)))
>                         return -EIO;
>                 return memcpy_from_pmem(buf, nsio->addr + offset, size);
>         } else {
> +               sector_t sector = offset / 512;
> +
> +               if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
> +                       if (IS_ALIGNED(offset, 512) &&
> +                           IS_ALIGNED(size, 512) && (size >= 512)) {
> +                               int rc;
> +
> +                               rc = nvdimm_clear_poison(&ndns->dev, offset,
> +                                                        size);
> +                               if (rc != size)
> +                                       return -EIO;
> +
> +                               badblocks_clear(&nsio->bb, sector, rc / 512);
> +                       } else
> +                               return -EIO;
> +               }
> +
>                 memcpy_to_pmem(nsio->addr + offset, buf, size);

Looks good.

After this the last piece remaining to fully close the "badblocks in
metadata" problem is to go update __nvdimm_setup_pfn().  Teach it to
walk and clear the badblocks in the range from the end of the 'pfn'
infoblock (8K offset from the start of the namespace) to the start of
data (pfn_sb->dataoff).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
