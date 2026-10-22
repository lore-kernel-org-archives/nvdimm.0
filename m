Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792653739;
	b=h1Bwf/Kx2P5ohFA1VVwikHfzJDCCgZC+Rwwt6Bp2dehwt2BW6/2RlaKbBQOmYedIkQh/
	 kYGMAM+O0C1ccaf+Ulnm3gvF+dfhrHfZaRdbcVDUlH0Z0VpBwOntkrQITOYx8JpeSVclH
	 nTYBf3UNcKXuCvp8rRhKpr916tqr8C4Pq1Cnchz5ws3ihwQPdAlMx7W1dhlEgPCLfqYyd
	 Q1fxl3/rqfXgekUaGmLhx7IIPazPuFslJqbUT4m3mLuLLdsOGmSXBGupk+hQtQNp2Foyh
	 sRw0+FzZrQ1r/1lHkdsIlh/z0+vUW0ONcruXZpp9kFmq3mne9JgD0eaY9xcS2wElngw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792653739;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=jf8P4XWcRz7X5zcfgDmz4Vg0q6xkZPNYQ/rfn5t3fNA=;
	b=AvvFTHpj/NRmATEJQr7iksH6UHJavOHHiBMh9Bucv7q1s9twfApYo0faJG9nLZpsIaiT
	 7UQsVFtRrYZuuNZrQ5LbRe6g/3YeUzF/n6l8Q5N8gu79aLh038JheOMmlJLr5piWztVuZ
	 vO9p3Q7perpH9u52yNcPepS3EBR01ctefYRA5KWeNhIgWF7ew5NEz8IVnXHe30j+d2TXZ
	 oQdUOiShRcL5aRRHzNzbr1z4UKAr777WfS7XlsxLGgk5s3c683hBG3kQ35B0+n4tY2TQA
	 Q9JMyyAar9dYAds/wvyuOWIjkWNEQ8KZDdhd7FefPIFcy7aKQfbSQ6uC2pDGCXTksOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ps9IzAoM;
	arc=none smtp.remote-ip=91.218.175.15
Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3145606A31D
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 07:22:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3145606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ps9IzAoM
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=lzEFVhQM3QVgAV/3EhVwgnWBENJztj7KAzIQybNKK7Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792653735; v=1; x=1793258535;
 b=ps9IzAoMAsRzz2hnOqfn8thFNvBflcznXyMscL7j+LjHDiyXgBNsJcaxr/3bBYMvieOIKJyr
 UeR8cNGIZlASr5hHSMEs9JEYjOIbGe3f8Qm+q+5n7Skow2+kBtH/wJZB0brIeYzxqdoETe/yQwp
 Ln7oY7WuLcULUPtwE3O9zOxI=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id f70173cbeb29589e;
	Thu, 22 Oct 2026 07:22:15 +0000
X-Mizu-Trace-ID: f70173cbeb29589e
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] dax/pmem: fix unaligned compound devmap initialization
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <jyna5rta.ritesh.list@gmail.com>
Date: Thu, 22 Oct 2026 15:21:55 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Joao Martins <joao.m.martins@oracle.com>,
 stable@vger.kernel.org,
 nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <60551F0C-D330-417A-AC8E-30E9BB00EA94@linux.dev>
References: <20261016054914.2601510-1-songmuchun@bytedance.com>
 <jyna5rta.ritesh.list@gmail.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On Oct 22, 2026, at 11:37, Ritesh Harjani (IBM) =
<ritesh.list@gmail.com> wrote:
>=20
>=20
> + linuxppc-dev (for awareness, since I also faced the same issue on
> Power too, although this one is not related to PPC alone)
>=20
> Muchun Song <songmuchun@bytedance.com> writes:
>=20
>> Static pmem Device DAX namespaces reserve space for namespace =
metadata
>> before the user-visible data range, and may also include padding =
needed
>> to satisfy the Device DAX alignment. __dax_pmem_probe() adjusts the
>> dax_region range to start at the data range, but the dev_pagemap =
range
>> still starts at the beginning of the namespace.
>>=20
>> That is not valid for compound devmap mappings whose memmap is stored =
in
>> system RAM. Compound page initialization requires the start PFN to be
>> naturally aligned to the compound page size, because the head and =
tail
>> struct pages are initialized according to that geometry. If the pgmap
>> starts before the aligned data range, memmap_init_zone_device() can =
build
>> compound page metadata from an unaligned PFN.
>>=20
>> The resulting struct page layout is inconsistent with the Device DAX
>> mapping. A later mmap fault can then resolve the user-visible PFN =
through
>> invalid compound page metadata and hit a kernel panic while inserting =
the
>> DAX folio.
>>=20
>> Fix this by advancing the pgmap start to the aligned Device DAX data
>> range for non-altmap compound mappings. Leave base-page namespaces
>> unchanged, and leave the altmap path unchanged because
>> memmap_init_zone_device() already skips the altmap reservation =
itself.
>>=20
>> Fixes: 14606001efb4 ("device-dax: compound devmap support")
>> Cc: <stable@vger.kernel.org>
>> Reported-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>=20
> Thanks Muchun for fixing this. With this patch I am no more seeing the
> following crash (tested on both Power and x86 kvm)
>=20
> Feel free to add for this patch.=20
> Tested-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Thanks for your testing.

>=20
>=20
> [    4.675578] page dumped because: =
VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn))
> [    4.675613] ------------[ cut here ]------------
> [    4.675615] kernel BUG at mm/page_alloc.c:373!
> [    4.675626] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
> [    4.678213] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted =
7.3.0-rc5-xfstests-01065-g45f4c1453cbe #33 PREEMPT(full)
> [    4.678213] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), =
BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [    4.678213] RIP: =
0010:__set_pfnblock_flags_mask.constprop.0+0xef/0x110
> <...>
> [    4.678213] Call Trace:
> [    4.678213]  <TASK>
> [    4.678213]  pageblock_migratetype_init_range.constprop.0+0x50/0x90
> [    4.678213]  memmap_init_zone_device+0x2fb/0x380
> [    4.678213]  pagemap_range+0x272/0x590
> [    4.678213]  memremap_pages+0x125/0x210
> [    4.678213]  ? lockdep_hardirqs_on+0x7d/0x100
> [    4.678213]  devm_memremap_pages+0x21/0x70
> [    4.678213]  dev_dax_probe+0x1db/0x300
> [    4.678213]  dax_bus_probe+0x6f/0xa0
> [    4.678213]  call_driver_probe+0x24/0xf0
> [    4.678213]  really_probe+0xb6/0x310
> [    4.678213]  ? __pfx___device_attach_driver+0x10/0x10
> [    4.678213]  __driver_probe_device+0x87/0x190
> [    4.678213]  ? __pfx___device_attach_driver+0x10/0x10
> [    4.678213]  driver_probe_device+0x1f/0x90
> [    4.678213]  __device_attach_driver+0x89/0x130
> [    4.678213]  bus_for_each_drv+0x86/0xe0
> [    4.678213]  __device_attach+0xb6/0x1d0
> [    4.678213]  device_initial_probe+0x40/0x60
> [    4.678213]  bus_probe_device+0x3d/0xa0
> [    4.678213]  device_add+0x4f0/0x6c0
> [    4.678213]  __devm_create_dev_dax+0x18b/0x3f0
> [    4.678213]  devm_create_dev_dax+0x21/0x40
> [    4.678213]  __dax_pmem_probe+0x1c3/0x200
> [    4.678213]  dax_pmem_probe+0xe/0x20
> [    4.678213]  nvdimm_bus_probe+0x89/0x250
> [    4.678213]  call_driver_probe+0x24/0xf0
> [    4.678213]  really_probe+0xb6/0x310
> [    4.678213]  ? __pfx___driver_attach+0x10/0x10
> [    4.678213]  __driver_probe_device+0x87/0x190
> [    4.678213]  ? __pfx___driver_attach+0x10/0x10
> [    4.678213]  driver_probe_device+0x1f/0x90
> [    4.678213]  __driver_attach+0xd7/0x200
> [    4.678213]  bus_for_each_dev+0x79/0xc0
> [    4.678213]  bus_add_driver+0x127/0x250
> [    4.678213]  driver_register+0x59/0x100
> [    4.678213]  ? __pfx_dax_pmem_init+0x10/0x10
> [    4.678213]  do_one_initcall+0x59/0x3a0
> [    4.678213]  do_initcalls+0xdd/0x1b0
> [    4.678213]  kernel_init_freeable+0x16f/0x2b0
> [    4.678213]  ? __pfx_kernel_init+0x10/0x10
> [    4.678213]  kernel_init+0x1f/0x1d0
> [    4.678213]  ret_from_fork+0x244/0x280
> [    4.678213]  ? __pfx_kernel_init+0x10/0x10
> [    4.678213]  ret_from_fork_asm+0x1a/0x30
> [    4.678213]  </TASK>
>=20
>=20
>> Closes: https://lore.kernel.org/r/wlrkqqvg.ritesh.list@gmail.com
>> Assisted-by: LLM
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> drivers/dax/pmem.c | 7 +++++++
>> 1 file changed, 7 insertions(+)
>>=20
>> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
>> index bee93066a849..d3a9b85107b0 100644
>> --- a/drivers/dax/pmem.c
>> +++ b/drivers/dax/pmem.c
>> @@ -51,6 +51,13 @@ static struct dev_dax *__dax_pmem_probe(struct =
device *dev)
>> /* adjust the dax_region range to the start of data */
>> 	range =3D pgmap.range;
>> 	range.start +=3D offset;
>> + 	/*
>> + 	 * When the memmap is stored in RAM, exclude metadata and =
alignment
>> + 	 * padding from compound page initialization.  Otherwise, the =
pgmap
>> + 	 * may start before the naturally aligned Device DAX data range.
>> + 	 */
>> + 	if (!pgmap_altmap(&pgmap) && le32_to_cpu(pfn_sb->align) > =
PAGE_SIZE)
>=20
> BTW, this check "le32_to_cpu(pfn_sb->align) > PAGE_SIZE" - Is that =
needed here?

Making pgmap.range.start consistently match the Device DAX
data range initially looked reasonable, but I think the
align > PAGE_SIZE condition is still needed for backward
compatibility.

Before commit a3619190d62e ("libnvdimm/pfn: stop padding
pmem namespaces to section alignment"), a RAM-backed
namespace calculated dataoff from the 8 KiB info block using
the namespace's requested alignment. On a system with 4 KiB
pages and align =3D=3D PAGE_SIZE, this could produce an 8 KiB
dataoff, which is not subsection-aligned.

Newly created namespaces now use at least subsection
alignment, but existing superblocks with the older layout
remain supported. nd_pfn_validate() requires the original
pgmap boundaries to satisfy memremap_compat_align(), while
dataoff itself only needs to be page-aligned.

Therefore, unconditionally advancing pgmap.range.start by
dataoff can make the pgmap start and length subsection-
unaligned. check_pfn_span() will then reject the range during
memremap_pages(), causing the Device DAX device to fail
probing with -EINVAL.

Thanks,
Muchun

>=20
> I am trying to understand this better - so that I can add more such
> testcases internally. For the test I mentioned earlier [1] - even w/o
> that align check, the test passes.
>=20
> [1]: https://lore.kernel.org/r/wlrkqqvg.ritesh.list@gmail.com
>=20
> -ritesh
>=20
>> + pgmap.range.start =3D range.start;
>> dax_region =3D alloc_dax_region(dev, region_id, &range,
>> nd_region->target_node, le32_to_cpu(pfn_sb->align),
>> IORESOURCE_DAX_STATIC);
>>=20
>> base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
>> --=20
>> 2.54.0


