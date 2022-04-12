Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FB47B
	for <nvdimm@lists.linux.dev>; Tue, 12 Apr 2022 04:26:47 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id h15-20020a17090a054f00b001cb7cd2b11dso1530054pjf.5
        for <nvdimm@lists.linux.dev>; Mon, 11 Apr 2022 21:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UCrOTwn1Apaa4uQLVmk5UD3cOc527xiwJT4PNuBWV0U=;
        b=qj1azZVRiLRWoOmK62O5jlUS3eBsOBIqGZrTPkVTrhXug25XR9RPlwdGNSyUk6Cn4Q
         O2h7oNKaIwwR0F/KAXVsmKOmZQHsE4nq+VcPu6FVr2QkdlsNenKN4YVbKRVtAVD7u7b4
         I3TXIiz7RmEJHBwtR9BUhZjSikRfkKsP2qKeq9uIwnIe5tR2LVuM+/vMUI/GaRim758K
         qpLoQglwz9v9mBUy4ZF8OIj7vFFvKFSsACWjKZnX/zRinYHwXhHZ8rpo2gkwmxTBjBjs
         SyNSru4EiN82wpRW3gwhJCjwubkugBNJd5Ve8Thx53DS0elOAsHJVybqbBJhleyoy6f0
         XOqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UCrOTwn1Apaa4uQLVmk5UD3cOc527xiwJT4PNuBWV0U=;
        b=xFlTFsB3uJ7CFSLE7xORbP19Tpf0QPdCu5YCzkKMM0mc0aQH8yihDA1v0pKGa9rRFb
         3cRZkoWEA3qu52hr/gPtcMcR4Q2Xk9CUDzRwRaHUB+O5k1Bn4LOV6QvWsx/wxC0jPH8Q
         R/3b4Tblu1HPAFWj3M7KcdbpqFGEOAr7f/uyNrSDpDmERGD0PrL/hDCxIfdRCwhoza3P
         Uu37G7Zhb794Tma9xw6B3ltF9ujSgfHsL98AFc8zKHvqaSjAAc/V57VNX5WDTMOqaAgx
         cElhaVdBtsiVNjfA08hquJINPjFlPb9tFXqJ2vjbYC4GRnC98qQMsi5OFp6ZuqvxD/Oa
         oNiA==
X-Gm-Message-State: AOAM532FJaS2c/bx9l2Mr0E6d4Jlmpjt/9jkYvuHnMqEXxvG4lbgz2bw
	VJ4zeszr/XPV2d4snUAKx5xk7icdv6gyGH3T41n9lA==
X-Google-Smtp-Source: ABdhPJykgObq290XUnROGzq2QfTK7LzFthT5iMS5THy+7CybmACgJItes+F9wWuzrX+7pufyRJ0OO61OHh/NWBRaQSs=
X-Received: by 2002:a17:90b:1804:b0:1cb:82e3:5cd0 with SMTP id
 lw4-20020a17090b180400b001cb82e35cd0mr2859224pjb.8.1649737606512; Mon, 11 Apr
 2022 21:26:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com> <20220405194747.2386619-6-jane.chu@oracle.com>
In-Reply-To: <20220405194747.2386619-6-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Apr 2022 21:26:35 -0700
Message-ID: <CAPcyv4h4NGa7_mTrrY0EqXdGny5p9JtQZx+CVBcHxX6_ZuO9pg@mail.gmail.com>
Subject: Re: [PATCH v7 5/6] pmem: refactor pmem_clear_poison()
To: Jane Chu <jane.chu@oracle.com>
Cc: david <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Vishal L Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 
	device-mapper development <dm-devel@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Refactor the pmem_clear_poison() in order to share common code
> later.
>

I would just add a note here about why, i.e. to factor out the common
shared code between the typical write path and the recovery write
path.

> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  drivers/nvdimm/pmem.c | 78 ++++++++++++++++++++++++++++---------------
>  1 file changed, 52 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 0400c5a7ba39..56596be70400 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -45,10 +45,27 @@ static struct nd_region *to_region(struct pmem_device *pmem)
>         return to_nd_region(to_dev(pmem)->parent);
>  }
>
> -static void hwpoison_clear(struct pmem_device *pmem,
> -               phys_addr_t phys, unsigned int len)
> +static phys_addr_t to_phys(struct pmem_device *pmem, phys_addr_t offset)
>  {
> +       return (pmem->phys_addr + offset);

Christoph already mentioned dropping the unnecessary parenthesis.

> +}
> +
> +static sector_t to_sect(struct pmem_device *pmem, phys_addr_t offset)
> +{
> +       return (offset - pmem->data_offset) >> SECTOR_SHIFT;
> +}
> +
> +static phys_addr_t to_offset(struct pmem_device *pmem, sector_t sector)
> +{
> +       return ((sector << SECTOR_SHIFT) + pmem->data_offset);
> +}
> +
> +static void pmem_clear_hwpoison(struct pmem_device *pmem, phys_addr_t offset,
> +               unsigned int len)

Perhaps now is a good time to rename this to something else like
pmem_clear_mce_nospec()? Just to make it more distinct from
pmem_clear_poison(). While "hwpoison" is the page flag name
pmem_clear_poison() is the function that's actually clearing the
poison in hardware ("hw") and the new pmem_clear_mce_nospec() is
toggling the page back into service.

> +{
> +       phys_addr_t phys = to_phys(pmem, offset);
>         unsigned long pfn_start, pfn_end, pfn;
> +       unsigned int blks = len >> SECTOR_SHIFT;
>
>         /* only pmem in the linear map supports HWPoison */
>         if (is_vmalloc_addr(pmem->virt_addr))
> @@ -67,35 +84,44 @@ static void hwpoison_clear(struct pmem_device *pmem,
>                 if (test_and_clear_pmem_poison(page))
>                         clear_mce_nospec(pfn);
>         }
> +
> +       dev_dbg(to_dev(pmem), "%#llx clear %u sector%s\n",
> +               (unsigned long long) to_sect(pmem, offset), blks,
> +               blks > 1 ? "s" : "");

In anticipation of better tracing support and the fact that this is no
longer called from pmem_clear_poison() let's drop it for now.

>  }
>
> -static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
> +static void pmem_clear_bb(struct pmem_device *pmem, sector_t sector, long blks)
> +{
> +       if (blks == 0)
> +               return;
> +       badblocks_clear(&pmem->bb, sector, blks);
> +       if (pmem->bb_state)
> +               sysfs_notify_dirent(pmem->bb_state);
> +}
> +
> +static long __pmem_clear_poison(struct pmem_device *pmem,
>                 phys_addr_t offset, unsigned int len)
>  {
> -       struct device *dev = to_dev(pmem);
> -       sector_t sector;
> -       long cleared;
> -       blk_status_t rc = BLK_STS_OK;
> -
> -       sector = (offset - pmem->data_offset) / 512;
> -
> -       cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);
> -       if (cleared < len)
> -               rc = BLK_STS_IOERR;
> -       if (cleared > 0 && cleared / 512) {
> -               hwpoison_clear(pmem, pmem->phys_addr + offset, cleared);
> -               cleared /= 512;
> -               dev_dbg(dev, "%#llx clear %ld sector%s\n",
> -                               (unsigned long long) sector, cleared,
> -                               cleared > 1 ? "s" : "");
> -               badblocks_clear(&pmem->bb, sector, cleared);
> -               if (pmem->bb_state)
> -                       sysfs_notify_dirent(pmem->bb_state);
> +       phys_addr_t phys = to_phys(pmem, offset);
> +       long cleared = nvdimm_clear_poison(to_dev(pmem), phys, len);
> +
> +       if (cleared > 0) {
> +               pmem_clear_hwpoison(pmem, offset, cleared);
> +               arch_invalidate_pmem(pmem->virt_addr + offset, len);
>         }
> +       return cleared;
> +}
>
> -       arch_invalidate_pmem(pmem->virt_addr + offset, len);
> +static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
> +               phys_addr_t offset, unsigned int len)
> +{
> +       long cleared = __pmem_clear_poison(pmem, offset, len);
>
> -       return rc;
> +       if (cleared < 0)
> +               return BLK_STS_IOERR;
> +
> +       pmem_clear_bb(pmem, to_sect(pmem, offset), cleared >> SECTOR_SHIFT);
> +       return (cleared < len) ? BLK_STS_IOERR : BLK_STS_OK;

I prefer "if / else" syntax instead of a ternary conditional.

>  }
>
>  static void write_pmem(void *pmem_addr, struct page *page,
> @@ -143,7 +169,7 @@ static blk_status_t pmem_do_read(struct pmem_device *pmem,
>                         sector_t sector, unsigned int len)
>  {
>         blk_status_t rc;
> -       phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
> +       phys_addr_t pmem_off = to_offset(pmem, sector);
>         void *pmem_addr = pmem->virt_addr + pmem_off;
>
>         if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
> @@ -158,7 +184,7 @@ static blk_status_t pmem_do_write(struct pmem_device *pmem,
>                         struct page *page, unsigned int page_off,
>                         sector_t sector, unsigned int len)
>  {
> -       phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
> +       phys_addr_t pmem_off = to_offset(pmem, sector);
>         void *pmem_addr = pmem->virt_addr + pmem_off;
>
>         if (unlikely(is_bad_pmem(&pmem->bb, sector, len))) {

With those small fixups you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
