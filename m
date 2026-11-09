Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.90
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794191682;
	b=d0drsgsrS2kxzN256V67V3plwiH7KU/i/rD7DzKeYSXkkGVRdRA/mTV3Nj5az/jBDBsS
	 ZacFckk7+dc7O7AfVld0EoglV7pDm6qIOcqqLy3NImcwd4RY9rIwEMQDQF9Z/UJt6d/+H
	 OXmwK/vOOBmMZd+9BFfiIO1sNXTBuZ/V7yQUpJbaU31qVy1WVjxmji2KY9F1vJK60htwx
	 IzXHeGeiiZW0Je34zGkriLDny6HDq9EP0FpdialQwwKpECbzPp00S6exY8UHhaMccSMhM
	 dHYXw5T7jo1PTaG5sPWcOQj9VuY/Wsv++lUKjwSPe+sg2UuPmnsi8Y/D/50ApFEF2GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794191682;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=17hrMgRLWHFMxzi/w8AjQ1hc79wxooWOGGXrIHOf1cE=;
	b=Fy4KXVO7szVSUHPhqp800nLZA236zkTO1y6ODj486r5iqMMBpU571k/Rg/WJqibGvxC2
	 KncV34mAZyBKHqH0qdtEoyAhdMibSX9Bd5MtzR3TmovOt+DZ+QgGcJwtzswUDY8sf4fmW
	 7n2D5L33qAzWtExta8gsw8/IvbKWKUUtdg5QPz1B8T3EerkhWWMNx9ByawqiFMoeUpgg6
	 eJDi82V4F5KomwNzheQRsnGLXHnvUd0n43HEO3sfLPlrkn2wg93XoItMzvn3JG0p1Wao9
	 BQT4CZZkOuV88r/o2rNOY+Zv5/LGrHcH9vgQcNVNRmuyk7rb4TbyG1Dci0Litppk5ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=E1kYaEH6;
	arc=none smtp.remote-ip=91.218.175.90
Received: from mta0.migadu.com (out-90.mta0.migadu.com [91.218.175.90])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612C5606A325
	for <nvdimm@lists.linux.dev>; Mon,  9 Nov 2026 02:34:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 612C5606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=E1kYaEH6
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=5+eXtFOPw8ri8zVpqqb1XMOQVeMGX4sPLIb3BO8RS5s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794191679; v=1; x=1794796479;
 b=E1kYaEH6geZzRwSNpJrbVowY52bR/Gl+rBzc2FmVZw4opA/3j74cqrHLhGZeiHPlS+VZ3xp7
 jTq/g0+e9GhGcqRh1Fq69ENp8y4v3w1lfF7MLjz2IueEs7rPga97rVYfX/15zvySxtFsGvp/CLN
 Tw7sjx/gzOcNDTCYJszTiX8s=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id 9205fe4f08972061;
	Mon, 09 Nov 2026 02:34:39 +0000
X-Mizu-Trace-ID: 9205fe4f08972061
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
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2] dax/pmem: fix unaligned compound devmap initialization
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <cxseojgn.ritesh.list@gmail.com>
Date: Mon, 9 Nov 2026 10:34:18 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Joao Martins <joao.m.martins@oracle.com>,
 Pavithra Prakash <pavrampu@linux.ibm.com>,
 stable@vger.kernel.org,
 nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1672E495-DED0-4475-B17E-DB63D10DD529@linux.dev>
References: <20261107030126.90894-1-songmuchun@bytedance.com>
 <cxseojgn.ritesh.list@gmail.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)



> On Nov 9, 2026, at 09:57, Ritesh Harjani (IBM) <ritesh.list@gmail.com> =
wrote:
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
>> Fix this by rounding the pgmap start up to the Device DAX alignment =
for
>> non-altmap mappings. This gives compound mappings the required =
naturally
>> aligned start while retaining full-section vmemmap savings when the
>> original start is already aligned. The altmap path remains unchanged
>> because memmap_init_zone_device() skips the altmap reservation =
itself.
>>=20
>> Fixes: 14606001efb4 ("device-dax: compound devmap support")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Reported-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>> Closes: https://lore.kernel.org/r/wlrkqqvg.ritesh.list@gmail.com
>=20
> Tested v2 also on my Power dev test setup. With this patch the =
reported
> problem is fixed. I am no more hitting the following warning and =
crash:
>=20
> [    3.071811][    T1] WARNING: mm/mm_init.c:1175 at =
memmap_init_zone_device+0x144/0x470, CPU#0: swapper/0/1
> [    3.082276][    T1] NIP [c000000000596604] =
memmap_init_zone_device+0x144/0x470
> [    3.082763][    T1] LR [c0000000006d72b8] =
memremap_pages+0x3b0/0x974
> [    3.083345][    T1] Call Trace:
> [    3.083629][    T1] [c000000006d86e00] [c000000006d86e40] =
0xc000000006d86e40 (unreliable)
> [    3.084975][    T1] [c000000006d86f10] [c0000000006d72b8] =
memremap_pages+0x3b0/0x974
> [    3.085449][    T1] [c000000006d86fe0] [c0000000006d78b8] =
devm_memremap_pages+0x3c/0xa4
> [    3.085891][    T1] [c000000006d87020] [c00000000125c084] =
dev_dax_probe+0x264/0x3d0
> [    3.086339][    T1] [c000000006d870c0] [c000000001259a28] =
dax_bus_probe+0x140/0x1c8
> [    3.086778][    T1] [c000000006d87110] [c0000000011ce640] =
really_probe+0x108/0x580
> [    3.087218][    T1] [c000000006d871a0] [c0000000011ceb84] =
__driver_probe_device+0xcc/0x284
> [    3.087668][    T1] [c000000006d87230] [c0000000011ceea0] =
driver_probe_device+0x5c/0x10c
> [    3.088123][    T1] [c000000006d87270] [c0000000011cf05c] =
__device_attach_driver+0x10c/0x1e8
> [    3.088582][    T1] [c000000006d872f0] [c0000000011cab70] =
bus_for_each_drv+0xc0/0x13c
> [    3.089035][    T1] [c000000006d87350] [c0000000011cf65c] =
__device_attach+0xdc/0x2b0
> [    3.089467][    T1] [c000000006d873f0] [c0000000011cfaac] =
device_initial_probe+0x80/0x98
> [    3.089910][    T1] [c000000006d87420] [c0000000011cac44] =
__bus_probe_device+0x58/0xf4
> [    3.090358][    T1] [c000000006d87470] [c0000000011c8030] =
device_add+0x850/0xa78
> [    3.090778][    T1] [c000000006d87530] [c00000000125b040] =
__devm_create_dev_dax+0x1c0/0x638
> [    3.091236][    T1] [c000000006d875d0] [c00000000125b6c8] =
devm_create_dev_dax+0x44/0x7c
> [    3.091676][    T1] [c000000006d87600] [c00000000125dbe8] =
__dax_pmem_probe+0x238/0x27c
> [    3.092120][    T1] [c000000006d87770] [c00000000125dc4c] =
dax_pmem_probe+0x20/0x44
> [    3.092542][    T1] [c000000006d87790] [c000000001237a14] =
nvdimm_bus_probe+0xcc/0x370
> [    3.093097][    T1] [c000000006d87830] [c0000000011ce640] =
really_probe+0x108/0x580
> [    3.093610][    T1] [c000000006d878c0] [c0000000011ceb84] =
__driver_probe_device+0xcc/0x284
> <...>
> [    3.099405][    T1] ---- interrupt: 0 at 0x0
> [    3.099837][    T1] Code: 7c0802a6 fa8100b0 faa100b8 fb8100f0 =
7d574030 7d4a4030 f8010120 fbe10108 3917ffff 7d294038 3109ffff 7d284910 =
<0b090000> 3d2201c5 7bb53664 7ed607b4
> [    3.101209][    T1] ---[ end trace 0000000000000000 ]---
> [    3.104702][    T1] BUG: Unable to handle kernel data access on =
write at 0xc00c000000210000
> [    3.105209][    T1] Faulting instruction address: =
0xc000000000596394
> cpu 0x0: Vector: 300 (Data Access) at [c000000006d86aa0]
>    lr: c0000000005962c4: memmap_init_compound+0xac/0x2a8
>    sp: c000000006d86d40
>   msr: 8000000002009033
>   dar: c00c000000210000
> dsisr: a000000
>  current =3D 0xc000000006d33e00
>  paca    =3D 0xc000000005010000   irqmask: 0x03   irq_happened: 0x01
>    pid   =3D 1, comm =3D swapper/0
> Linux version 7.3.0-17056-gc0944ee4a2c4 (powerpc64le-linux-gnu-gcc =
(Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40) #111 =
SMP PREEMPT Mon Nov  9 07:25:29 IST 2026
> enter ? for help
> [c000000006d86e00] c0000000005968f8 =
memmap_init_zone_device+0x438/0x470
> [c000000006d86f10] c0000000006d72b8 memremap_pages+0x3b0/0x974
> [c000000006d86fe0] c0000000006d78b8 devm_memremap_pages+0x3c/0xa4
> [c000000006d87020] c00000000125c084 dev_dax_probe+0x264/0x3d0
> [c000000006d870c0] c000000001259a28 dax_bus_probe+0x140/0x1c8
> [c000000006d87110] c0000000011ce640 really_probe+0x108/0x580
> [c000000006d871a0] c0000000011ceb84 __driver_probe_device+0xcc/0x284
> [c000000006d87230] c0000000011ceea0 driver_probe_device+0x5c/0x10c
> [c000000006d87270] c0000000011cf05c __device_attach_driver+0x10c/0x1e8
> [c000000006d872f0] c0000000011cab70 bus_for_each_drv+0xc0/0x13c
> [c000000006d87350] c0000000011cf65c __device_attach+0xdc/0x2b0
> [c000000006d873f0] c0000000011cfaac device_initial_probe+0x80/0x98
> [c000000006d87420] c0000000011cac44 __bus_probe_device+0x58/0xf4
> [c000000006d87470] c0000000011c8030 device_add+0x850/0xa78
> [c000000006d87530] c00000000125b040 __devm_create_dev_dax+0x1c0/0x638
> [c000000006d875d0] c00000000125b6c8 devm_create_dev_dax+0x44/0x7c
> [c000000006d87600] c00000000125dbe8 __dax_pmem_probe+0x238/0x27c
> [c000000006d87770] c00000000125dc4c dax_pmem_probe+0x20/0x44
> [c000000006d87790] c000000001237a14 nvdimm_bus_probe+0xcc/0x370
> [c000000006d87830] c0000000011ce640 really_probe+0x108/0x580
> <...>
>=20
> Feel free to add:
>=20
> Tested-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Thanks for testing again.

Muchun

