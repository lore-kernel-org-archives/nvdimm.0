Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A313FC3
	for <nvdimm@lists.linux.dev>; Fri, 10 Sep 2021 15:42:33 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id w8so2179329pgf.5
        for <nvdimm@lists.linux.dev>; Fri, 10 Sep 2021 08:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SiGov35SyrsNa0p/ygBsXRJGs1dQPnAwPQrLMje8peY=;
        b=OhnY6WvivfLN56CFZm2k0VBJ7cJc6GXoso1feCmNuLK8xVSKyNXzypQNHUMoueR81T
         7BAQp8lvgS6+TnBycew5IfreukV5O+HzfQAtQ7TL/uBxrlNXrKBmpJj/yHZMNJ0/7R6g
         IY58OotEPjfFC/tQGdNvx8wa8I46YCObxV3jV/MCEmfvZb+6ypkV9Khryt80BGswpAwm
         8sqtZ/FZygb5Zm33K0mpwsWQlH78jEQEfxT02gtE5FRC/SkrWoEx7FbVMKuGfQ0SoljM
         lSBHY8KsBFLsPIHxc8BNhCHsrBf9E9seNirDnGkTqbnNf84BdhGzyhrY+mmy5OTDo6W/
         YSOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SiGov35SyrsNa0p/ygBsXRJGs1dQPnAwPQrLMje8peY=;
        b=pLEXGILa4DEMDXsAC8Y7e1yKKJ8EEPkpEEXepEwyrRa+G9S1w0laZ4ZrfFGRFaXJ/D
         CGAECnlBmtToaoa6jYbJKeSp1PAGCwTQ6eK1c7jBF8eDe7mEYdgjWQkenYjaVNvrApib
         N5zdu/LB93JqOHXUcKq41F5OqfADaT5Btx0g+4Vj1FQK3jY2DfsRKCTgZ+j5t4PvLniB
         jgrmQpCcDXlo7Z6B+hc86Gf0XChcy1BYMsQwz1q2mtKPDlcFgSmFFPV6VVdpdBihZUKd
         4wEdEQ51KK75i5eNokkddQd0q89uZ/Qo+mjc9fpfQQtSoYK7ELga67cTcuZJ55oHoPI/
         a6jQ==
X-Gm-Message-State: AOAM531oszQ5kXEOYbNFfIQHz3Kt0fEy6TttSdsJ7JKpz5oDztkuY9cJ
	NLYHJ+s4ruLLuNutIulqgMWle0MNTkTZusVPm2G80OI0KgBp4g==
X-Google-Smtp-Source: ABdhPJySmKiB3mBJQHU9hN5iTUa8KrMdmCh9lgDsiS2zVvc6bLRexKehjl8yUaSsg/UkCBe+LeshF6hEHQSQKLitJ4s=
X-Received: by 2002:a05:6a00:1a10:b0:412:448c:89ca with SMTP id
 g16-20020a056a001a1000b00412448c89camr8871652pfv.86.1631288552597; Fri, 10
 Sep 2021 08:42:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210910124628.6261-1-justin.he@arm.com>
In-Reply-To: <20210910124628.6261-1-justin.he@arm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 10 Sep 2021 08:42:21 -0700
Message-ID: <CAPcyv4ie_ZzEwrrKJEVrDP19UWAgSiW3GU9f99EqX0e6BPQDPA@mail.gmail.com>
Subject: Re: [PATCH v2] device-dax: use fallback nid when numa node is invalid
To: Jia He <justin.he@arm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	David Hildenbrand <david@redhat.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Sep 10, 2021 at 5:46 AM Jia He <justin.he@arm.com> wrote:
>
> Previously, numa_off was set unconditionally in dummy_numa_init()
> even with a fake numa node. Then ACPI sets node id as NUMA_NO_NODE(-1)
> after acpi_map_pxm_to_node() because it regards numa_off as turning
> off the numa node. Hence dev_dax->target_node is NUMA_NO_NODE on
> arm64 with fake numa case.
>
> Without this patch, pmem can't be probed as RAM devices on arm64 if
> SRAT table isn't present:
>   $ndctl create-namespace -fe namespace0.0 --mode=devdax --map=dev -s 1g -a 64K
>   kmem dax0.0: rejecting DAX region [mem 0x240400000-0x2bfffffff] with invalid node: -1
>   kmem: probe of dax0.0 failed with error -22
>
> This fixes it by using fallback memory_add_physaddr_to_nid() as nid.
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Jia He <justin.he@arm.com>
> ---
> v2: - rebase it based on David's "memory group" patch.
>     - drop the changes in dev_dax_kmem_remove() since nid had been
>       removed in remove_memory().
>  drivers/dax/kmem.c | 31 +++++++++++++++++--------------
>  1 file changed, 17 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index a37622060fff..e4836eb7539e 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -47,20 +47,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>         unsigned long total_len = 0;
>         struct dax_kmem_data *data;
>         int i, rc, mapped = 0;
> -       int numa_node;
> -
> -       /*
> -        * Ensure good NUMA information for the persistent memory.
> -        * Without this check, there is a risk that slow memory
> -        * could be mixed in a node with faster memory, causing
> -        * unavoidable performance issues.
> -        */
> -       numa_node = dev_dax->target_node;
> -       if (numa_node < 0) {
> -               dev_warn(dev, "rejecting DAX region with invalid node: %d\n",
> -                               numa_node);
> -               return -EINVAL;
> -       }
> +       int numa_node = dev_dax->target_node;
>
>         for (i = 0; i < dev_dax->nr_range; i++) {
>                 struct range range;
> @@ -71,6 +58,22 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>                                         i, range.start, range.end);
>                         continue;
>                 }
> +
> +               /*
> +                * Ensure good NUMA information for the persistent memory.
> +                * Without this check, there is a risk but not fatal that slow
> +                * memory could be mixed in a node with faster memory, causing
> +                * unavoidable performance issues. Warn this and use fallback
> +                * node id.
> +                */
> +               if (numa_node < 0) {
> +                       int new_node = memory_add_physaddr_to_nid(range.start);
> +
> +                       dev_info(dev, "changing nid from %d to %d for DAX region [%#llx-%#llx]\n",
> +                                numa_node, new_node, range.start, range.end);
> +                       numa_node = new_node;
> +               }
> +
>                 total_len += range_len(&range);

This fallback change belongs where the parent region for the namespace
adopts its target_node, because it's not clear
memory_add_physaddr_to_nid() is the right fallback in all situations.
Here is where this setting is happening currently:

drivers/acpi/nfit/core.c:3004:          ndr_desc->target_node =
pxm_to_node(spa->proximity_domain);
drivers/acpi/nfit/core.c:3007:          ndr_desc->target_node = NUMA_NO_NODE;
drivers/nvdimm/e820.c:29:       ndr_desc.target_node = nid;
drivers/nvdimm/of_pmem.c:58:            ndr_desc.target_node =
ndr_desc.numa_node;
drivers/nvdimm/region_devs.c:1127:      nd_region->target_node =
ndr_desc->target_node;

...where is this pmem region originating on this arm64 platform?
