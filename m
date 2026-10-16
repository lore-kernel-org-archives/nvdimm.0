Received: from mta1.migadu.com (out-220.mta1.migadu.com [95.215.58.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E8F30F81A
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 14:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792159591; cv=none; b=lhEVAwS7wPT/7xUfSso5v/7uG5iNYJV90c9gHNWYvhgCBSVi5Pwg2OyNlLdNLyIxFela3m9e62rp807CxeS/SNjLV6AOSYj966Lgi8ytQ4ysexohctAhjiYYj+DPQZEqKrESrLPRfF0TMC1VmtYf+FdwCZswJs2xLpyHI8Yq73M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792159591; c=relaxed/simple;
	bh=kyoBK8WCWHp/eP+c0vx3teIgRzxLrJVt4wgAAkxJuAw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=nQ9Kxvq/kyPXDsyLjRIQAyRDn6boerf0WfQsasN0dHSW/lVHHrRTU/H0M+cD/yTprRyWqkRqcBcBIKohG0t8TGTnb35mG45BjLZyfHfhV1Q4g+7FPHuFP/yrDSj6kM+E6EY2B7V/mAG5st+aKkN1LVFf6+3A45bt72jDI33xKHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d8jD1YYB; arc=none smtp.client-ip=95.215.58.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d8jD1YYB"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=kyoBK8WCWHp/eP+c0vx3teIgRzxLrJVt4wgAAkxJuAw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792159586; v=1; x=1792764386;
 b=d8jD1YYBgSr8/dE0/FEbK5rEjeHtX9KDwubAL8R2IAXwxWcRcCIAWpglWm+6izYEY6ZrrFNg
 mj95WRc8Jwu80vua1jMv/5ZbP5TQ5ifYUIbjReK++UAvf9PLerCfx4jGqwhGbulBinnFsMX5xsH
 WFb7k7UR0QtKzQXhJVYI2zoA=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta11.migadu.com with ESMTPS id 5b7d4e89d766a128;
	Fri, 16 Oct 2026 14:06:26 +0000
X-Mizu-Trace-ID: 5b7d4e89d766a128
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] dax/pmem: fix unaligned compound devmap initialization
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <31c89da1-6d3f-4a42-b6bb-2b8f8170eed6@oracle.com>
Date: Fri, 16 Oct 2026 22:06:06 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ritesh Harjani <ritesh.list@gmail.com>,
 stable@vger.kernel.org,
 nvdimm@lists.linux.dev,
 Dan Williams <djbw@kernel.org>,
 linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FB79CEA5-ECA4-4313-9D9B-10B231C88E92@linux.dev>
References: <20261016054914.2601510-1-songmuchun@bytedance.com>
 <31c89da1-6d3f-4a42-b6bb-2b8f8170eed6@oracle.com>
To: Joao Martins <joao.m.martins@oracle.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On Oct 16, 2026, at 18:00, Joao Martins <joao.m.martins@oracle.com> =
wrote:
>=20
> On 16/10/2026 06:49, Muchun Song wrote:
>> Static pmem Device DAX namespaces reserve space for namespace =
metadata before
>> the user-visible data range, and may also include padding needed to =
satisfy the
>> Device DAX alignment. __dax_pmem_probe() adjusts the dax_region range =
to start
>> at the
>>=20
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
>> Closes: https://lore.kernel.org/r/wlrkqqvg.ritesh.list@gmail.com
>> Assisted-by: LLM
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> --->  drivers/dax/pmem.c | 7 +++++++
>> 1 file changed, 7 insertions(+)
>>=20
>> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
>> index bee93066a849..d3a9b85107b0 100644
>> --- a/drivers/dax/pmem.c
>> +++ b/drivers/dax/pmem.c
>> @@ -51,6 +51,13 @@ static struct dev_dax *__dax_pmem_probe(struct =
device *dev)
>> 	/* adjust the dax_region range to the start of data */
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
>> + 		pgmap.range.start =3D range.start;
>=20
> Should we need to check here for pgmap.type =3D=3D =
MEMORY_DEVICE_GENERIC ?
>=20
> Considering the dedup is not quite applicable for FSDAX.

Good point that FS-DAX does not use compound devmap initialization.
However, pgmap.type is not set until the Device DAX or FS-DAX driver
probes, so checking it here would always be false.

The pgmap is also copied into the static dev_dax and reused across
driver rebinds. Moving this adjustment into dev_dax_probe() would make
its range depend on the previous driver binding unless it were
restored on unbind. The removed prefix is only metadata and alignment
padding and is not exposed to devdax-backed FS-DAX, while its
vmemmap_shift remains zero. Therefore, keeping the adjustment here is
harmless for FS-DAX and keeps the static pgmap range consistent.

If you have a more elegant solution in mind, I'd be glad to hear it.

Thanks,
Muchun


