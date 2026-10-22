Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792642840;
	b=dBeOCZd34rQIpO8VTjy1Q3lYObq4z68IT4+AsZuZdGq1DQ13kusY7ol26gR4A3AuK1cC
	 HaHCanMZTDp8fg6VUbNDl8U/QXI4iPQlx4wgdFic6Nvg7OqCBMkcLaZZ5Ed8CG3BMVz/Q
	 Xpb+7M0sD15nLoCiWuiz2A+v8c/pn23cEvS7ZWKlOyn2xfcyeQLgkTc9yPV3pQb2cRiGR
	 mrf582FqP20/nNb258pbhCsfALC8/TEGS9PcWH5492cgrmTLRMS+DovRu7rC1O6r1JuPW
	 J5zWDYGDxbzBK1E6WHk1Q1+T6cv5xx3YXZu0jJ+fmsZ/i1HhW3rjNvvzAN0gqH3uHOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792642840;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References;
	bh=IYGqe8uHdvMKTGNalGzso/Hav7cwh06URO2tg9hCsgA=;
	b=XrZB8hBKkIp6R/ocrRwlX/0OgGVLM25bcE7R2OZUYG4YqbA+dOZHn0Nv6dbWhF15mj0F
	 ifWB2iXOiCp0jaxVWSgCrI8vIOcdx+9u5GGpEoAZBKpxBfCZRRujYOzlg6NtBS4RwcX2D
	 BSbYYKHONWFrm4fSQrmXbrFuC94S27AMMEOS+yQ196ZDbHd30nQYUWuKM8bMI96QpA/j7
	 zqt+TiE/VxOZ74sU2c4h4SauIQuSfshmakA03RWpdmz6xmumTG8nbfV6tXKkI4v41rfPd
	 Wh0iDcHXyMESTs+fIlTEd9ebysvMfM+pRgTogqICkWbXvQG8fdlgYV1+VzEHlLkPuJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PdwvlCc4;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81967606A31D
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 04:20:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81967606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PdwvlCc4
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36681e85e87so3016192eec.1
        for <nvdimm@lists.linux.dev>; Wed, 21 Oct 2026 21:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792642839; x=1793247639; darn=lists.linux.dev;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=IYGqe8uHdvMKTGNalGzso/Hav7cwh06URO2tg9hCsgA=;
        b=PdwvlCc4k28k7+BLBi35fY63YlomjDxF1Jj3c2XQiy7V1tedA56waT6kjA7XQkFFFR
         vm9S4lGkbYs3AVX0pDQx6dn7tBFPZOF5zHfkg/LMvFADAPeW6DrZWCQ5IzEUSjdzeqwX
         pIUBk+LNvhQUZa1pRsHHQwZa48keKIqhLqsIk9FZxGsD4sipbasg+u8S8EKBxH57KjWg
         bnftoYvR53ebkVz5+vOBNOw+Z5LKSMCjRBNwdh+Ea1vfKuy5k0Tbe1MgKp5zrxAQ07kC
         P5bzguJqJGXg0OLFm6j0+NV9312F3L4SNo+pGcUJISAvNhJA9ongDKyMj0qxBU8szRNt
         we4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792642839; x=1793247639;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IYGqe8uHdvMKTGNalGzso/Hav7cwh06URO2tg9hCsgA=;
        b=Ti9eVk3fW/WQJOoLcEJV2KPiuvC6Dwn28WGXpj8DT18e1WZLg00soxei7sVP+DJZg1
         cXqCdH+fa9kACWSI4oQH6lX5+vNj0VwcEo1dfOgLCQqL6N72CunZhtmoIVvWNn4FKAr6
         KJXD6Xbtw89uXDZzCpf24jFsfgAP+ffOwW5na3HpUD3134ThInhNLeAIJwkrHtt3MiMT
         JTXpO+wQU4rMk9/6u4o1Iqaa1MP9YKHUmoYQFyIi1bdu3ILNvGvg4VWtOcG1SWnTu3cC
         AfpaslOy+oJ5awD7Eo5jE/apJV4oSL7ZIQXreSkVYT3YcuGM/5ptlaO/rIedXWM2hiNa
         yU5Q==
X-Forwarded-Encrypted: i=1; AKwUvBx5RYE/lv0ldKYtunbRrM8QFjqT3uz1GqWCFK38ftZ4aoMN0kcuJxEDOfVl/ZPvq1Hx9ZB2ocA=@lists.linux.dev
X-Gm-Message-State: AFq9FYKGbXm09mN8jnCrSQXAKb5R/S+nKf0zUYa8wYLvDL/NTJC2cPpT
	eFjrTUwqhpmtXcMVrovBvAu+Ntcz9SfzEXvmaIFAp9zQJ/Ot6CYKyzfZ
X-Gm-Gg: AYBFou217hg1Z7gT7AFMfSv3oeM8ARUMW2oyvb6duQy/LmMwJTIC8s16wE7ke7ZvuLR
	ekLzJKAlI0KA1f9wqZSg7AiSaeCtll9SERCwNlPuUkocWJ5N4YWBC05rJ282ekVQu3NnLWKiJgz
	Y/nY1UJAcRF4KqdR9kfFJLw0pYu7+iHXr0ctoYePDnPwGPtxCY+NOyCdPUFUlwz26vALafImDas
	RGH1zTTto4wfm83KJDv22RpbKeB/G0ikT3N8ZxLbU/IaPJaEHoc5BDIdnpc+DNjwqY2xF8du5rM
	chAxAw+Bv+7b7c727Z9F0rtUrjL35CHb3m+YJfvIlYXtsVdqLN6ZTvEwwZMf4/3Qi60xGWDMHDJ
	rIUIgnA6cGBJ43GKy7yXKKLqPv/g+mNdvjmmO0GFCr4EE5NTgXBodxczthrqOTHrruS6TXxVVXR
	hOrRKVBKpcgbbw+56W/BPtIEwUzTQT3s+IHdWMibZJCmy8woUUaj5S8fjw9c0JzzPQnop6Zj70n
	aUjvEiJuYwR5vQxvcUOozkeXpXJs0p5AV7J0D9v7PlDtUfQVX0CwQ==
X-Received: by 2002:a05:7022:628a:b0:144:c12b:dfc6 with SMTP id a92af1059eb24-190a80ee9a2mr7469795c88.44.1792642838435;
        Wed, 21 Oct 2026 21:20:38 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903ca044d4sm11690981c88.17.2026.10.21.21.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 21:20:37 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Muchun Song <songmuchun@bytedance.com>, Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joao Martins <joao.m.martins@oracle.com>, Muchun Song <muchun.song@linux.dev>, stable@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH] dax/pmem: fix unaligned compound devmap initialization
In-Reply-To: <20261016054914.2601510-1-songmuchun@bytedance.com>
Date: Thu, 22 Oct 2026 09:07:21 +0530
Message-ID: <jyna5rta.ritesh.list@gmail.com>
References: <20261016054914.2601510-1-songmuchun@bytedance.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list


+ linuxppc-dev (for awareness, since I also faced the same issue on
Power too, although this one is not related to PPC alone)

Muchun Song <songmuchun@bytedance.com> writes:

> Static pmem Device DAX namespaces reserve space for namespace metadata
> before the user-visible data range, and may also include padding needed
> to satisfy the Device DAX alignment. __dax_pmem_probe() adjusts the
> dax_region range to start at the data range, but the dev_pagemap range
> still starts at the beginning of the namespace.
>
> That is not valid for compound devmap mappings whose memmap is stored in
> system RAM. Compound page initialization requires the start PFN to be
> naturally aligned to the compound page size, because the head and tail
> struct pages are initialized according to that geometry. If the pgmap
> starts before the aligned data range, memmap_init_zone_device() can build
> compound page metadata from an unaligned PFN.
>
> The resulting struct page layout is inconsistent with the Device DAX
> mapping. A later mmap fault can then resolve the user-visible PFN through
> invalid compound page metadata and hit a kernel panic while inserting the
> DAX folio.
>
> Fix this by advancing the pgmap start to the aligned Device DAX data
> range for non-altmap compound mappings. Leave base-page namespaces
> unchanged, and leave the altmap path unchanged because
> memmap_init_zone_device() already skips the altmap reservation itself.
>
> Fixes: 14606001efb4 ("device-dax: compound devmap support")
> Cc: <stable@vger.kernel.org>
> Reported-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Thanks Muchun for fixing this. With this patch I am no more seeing the
following crash (tested on both Power and x86 kvm)

Feel free to add for this patch. 
Tested-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>


[    4.675578] page dumped because: VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn))
[    4.675613] ------------[ cut here ]------------
[    4.675615] kernel BUG at mm/page_alloc.c:373!
[    4.675626] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
[    4.678213] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted 7.3.0-rc5-xfstests-01065-g45f4c1453cbe #33 PREEMPT(full)
[    4.678213] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[    4.678213] RIP: 0010:__set_pfnblock_flags_mask.constprop.0+0xef/0x110
<...>
[    4.678213] Call Trace:
[    4.678213]  <TASK>
[    4.678213]  pageblock_migratetype_init_range.constprop.0+0x50/0x90
[    4.678213]  memmap_init_zone_device+0x2fb/0x380
[    4.678213]  pagemap_range+0x272/0x590
[    4.678213]  memremap_pages+0x125/0x210
[    4.678213]  ? lockdep_hardirqs_on+0x7d/0x100
[    4.678213]  devm_memremap_pages+0x21/0x70
[    4.678213]  dev_dax_probe+0x1db/0x300
[    4.678213]  dax_bus_probe+0x6f/0xa0
[    4.678213]  call_driver_probe+0x24/0xf0
[    4.678213]  really_probe+0xb6/0x310
[    4.678213]  ? __pfx___device_attach_driver+0x10/0x10
[    4.678213]  __driver_probe_device+0x87/0x190
[    4.678213]  ? __pfx___device_attach_driver+0x10/0x10
[    4.678213]  driver_probe_device+0x1f/0x90
[    4.678213]  __device_attach_driver+0x89/0x130
[    4.678213]  bus_for_each_drv+0x86/0xe0
[    4.678213]  __device_attach+0xb6/0x1d0
[    4.678213]  device_initial_probe+0x40/0x60
[    4.678213]  bus_probe_device+0x3d/0xa0
[    4.678213]  device_add+0x4f0/0x6c0
[    4.678213]  __devm_create_dev_dax+0x18b/0x3f0
[    4.678213]  devm_create_dev_dax+0x21/0x40
[    4.678213]  __dax_pmem_probe+0x1c3/0x200
[    4.678213]  dax_pmem_probe+0xe/0x20
[    4.678213]  nvdimm_bus_probe+0x89/0x250
[    4.678213]  call_driver_probe+0x24/0xf0
[    4.678213]  really_probe+0xb6/0x310
[    4.678213]  ? __pfx___driver_attach+0x10/0x10
[    4.678213]  __driver_probe_device+0x87/0x190
[    4.678213]  ? __pfx___driver_attach+0x10/0x10
[    4.678213]  driver_probe_device+0x1f/0x90
[    4.678213]  __driver_attach+0xd7/0x200
[    4.678213]  bus_for_each_dev+0x79/0xc0
[    4.678213]  bus_add_driver+0x127/0x250
[    4.678213]  driver_register+0x59/0x100
[    4.678213]  ? __pfx_dax_pmem_init+0x10/0x10
[    4.678213]  do_one_initcall+0x59/0x3a0
[    4.678213]  do_initcalls+0xdd/0x1b0
[    4.678213]  kernel_init_freeable+0x16f/0x2b0
[    4.678213]  ? __pfx_kernel_init+0x10/0x10
[    4.678213]  kernel_init+0x1f/0x1d0
[    4.678213]  ret_from_fork+0x244/0x280
[    4.678213]  ? __pfx_kernel_init+0x10/0x10
[    4.678213]  ret_from_fork_asm+0x1a/0x30
[    4.678213]  </TASK>


> Closes: https://lore.kernel.org/r/wlrkqqvg.ritesh.list@gmail.com
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  drivers/dax/pmem.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
> index bee93066a849..d3a9b85107b0 100644
> --- a/drivers/dax/pmem.c
> +++ b/drivers/dax/pmem.c
> @@ -51,6 +51,13 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
>  	/* adjust the dax_region range to the start of data */
>  	range = pgmap.range;
>  	range.start += offset;
> +	/*
> +	 * When the memmap is stored in RAM, exclude metadata and alignment
> +	 * padding from compound page initialization.  Otherwise, the pgmap
> +	 * may start before the naturally aligned Device DAX data range.
> +	 */
> +	if (!pgmap_altmap(&pgmap) && le32_to_cpu(pfn_sb->align) > PAGE_SIZE)

BTW, this check "le32_to_cpu(pfn_sb->align) > PAGE_SIZE" - Is that needed here?

I am trying to understand this better - so that I can add more such
testcases internally. For the test I mentioned earlier [1] - even w/o
that align check, the test passes.

[1]: https://lore.kernel.org/r/wlrkqqvg.ritesh.list@gmail.com

-ritesh

> +		pgmap.range.start = range.start;
>  	dax_region = alloc_dax_region(dev, region_id, &range,
>  			nd_region->target_node, le32_to_cpu(pfn_sb->align),
>  			IORESOURCE_DAX_STATIC);
>
> base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
> -- 
> 2.54.0
