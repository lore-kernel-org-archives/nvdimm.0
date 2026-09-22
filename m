Received: from mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57981383998
	for <nvdimm@lists.linux.dev>; Tue, 22 Sep 2026 03:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790047074; cv=none; b=INNgqT18HcGogFBJ7Y5ef3taHU6WnHKr/MDjIru3la62ORk5Uzh/napEMvOhmECSqivRnU9NTkbcaBUKifpumoJaGTpDOd/Z2MOpiyQSTWEETdovvmMCOUTcE5/dQgZWlA9sIygHaEU6BQb+5L72dGlzBsdmkpdMjFnOorxhF1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790047074; c=relaxed/simple;
	bh=n5rx4IX4GsBUDhc4Iyun+qiv1PJKF2Xxv28G7taH6Vk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=GFPYJUhdSFTYDnT7eSfYOtDBgT+2CVoFcBib9dtc6ONcVV6V2rz6ka3Xbqg/L0iDGyKteZ9KMyi4OFSWnD9gCvtj0v4luAIrjpFWSIKOkcOwVu63BwWW3ZyAJhvlQJ/Ig9yzvJj5UJnhT1t6ojI25XBeKsf8+TqhzCWUWQOkeMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OXZdkHQ5; arc=none smtp.client-ip=91.218.175.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OXZdkHQ5"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=n5rx4IX4GsBUDhc4Iyun+qiv1PJKF2Xxv28G7taH6Vk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790047070; v=1; x=1790651870;
 b=OXZdkHQ5qaXAc8/OoEikBWoNlnVFMkAHE8uQc0aWfSKRzsW5dR7OSoOIsyTDF1S9ghN2J3W4
 wOpnAEU2hdKDZCN6XJvy26vEwrP0suDl0ycExkXUeqAMApj3rHmAyPSBiS0wVvMPv/EjqjRIuII
 hUQVD8AR5oxKbvTfTiuVTL/w=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id 007cbe3f9b98d031;
	Tue, 22 Sep 2026 03:17:50 +0000
X-Mizu-Trace-ID: 007cbe3f9b98d031
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <arEsjy0QwLekLVbf@localhost.localdomain>
Date: Tue, 22 Sep 2026 11:17:27 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dan Williams <djbw@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 linux-cxl@vger.kernel.org,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Mike Rapoport <rppt@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Ira Weiny <iweiny@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Matthew Wilcox <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B7DD4587-81DD-4B82-934B-67B80A3A2D92@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-4-songmuchun@bytedance.com>
 <arEsjy0QwLekLVbf@localhost.localdomain>
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 21, 2026, at 21:09, Oscar Salvador (SUSE) =
<osalvador@kernel.org> wrote:
>=20
> On Thu, Sep 03, 2026 at 08:21:26PM +0800, Muchun Song wrote:
>> FS-DAX registers persistent-memory ranges as ZONE_DEVICE memory, and =
the
>> kernel normally allocates and initializes vmemmap storage for every
>> advertised PFN up front. Sparse pmem images and workloads that only =
use the
>> DAX direct-access path may never need writable per-PFN state for most =
of
>> that range, but still pay the memory and initialization cost.
>>=20
>> Add an opt-in dev_pagemap mode that populates FS-DAX vmemmap PTEs =
from a
>> shared read-only metadata page. The shared page is initialized with =
the
>> common ZONE_DEVICE and dev_pagemap state, so every PFN still has a =
valid
>> struct page representation while private metadata allocation is =
deferred.
>>=20
>> This relies on sizeof(struct page) being a power of two, so each =
vmemmap
>> page contains a naturally aligned and repeatable set of struct page =
slots.
>> It also requires architecture support for runtime vmemmap remapping,
>> because shared mappings must be replaced with private writable pages =
before
>> a PFN can enter userspace mappings.
>>=20
>> The initial implementation is deliberately limited to a single
>> memory-block-aligned range. That is not a fundamental requirement, =
but keeps
>> the registration and teardown paths simple; support for multiple =
ranges or
>> less strict alignment can be added later.
>>=20
>> Provide vmemmap_materialize_page() to replace shared mappings in the
>> requested metadata range with private writable copies. A later patch =
will
>> call it from the FS-DAX fault path.
>>=20
>> No caller enables the mode yet.
> ... =20
>> +static int pgmap_vmemmap_shared_page_alloc(struct dev_pagemap =
*pgmap, int nid)
>> +{
>> + 	const struct range *range =3D &pgmap->range;
>> +
>> + 	if (!is_power_of_2(sizeof(struct page)) ||
>> + 	    !IS_ENABLED(CONFIG_ARCH_SUPPORTS_VMEMMAP_REMAP) ||
>> + 	    !(pgmap->flags & PGMAP_VMEMMAP_OPTIMIZATION))
>> + 		return 0;
>> +
>> + 	if (pgmap->nr_range !=3D 1 ||
>> + 	    !IS_ALIGNED(range->start | range_len(range), =
MIN_MEMORY_BLOCK_SIZE))
>> + 		return 0;
>> +
>> + 	pgmap->vmemmap_shared_page =3D alloc_pages_node(nid, GFP_KERNEL, =
0);
>> +
>> + 	return pgmap->vmemmap_shared_page ? 0 : -ENOMEM;
>=20
> I yet have to look into this with more detail, but this caught my eye.
> Should not this be a best-efford mode optimization? So, if we were
> unable to allocate the page, could not we treat this as a normal =
"cannot
> be optimized, follow by-default procedure" ?
>=20
>=20

My thinking is that if we fail to allocate memory here, the subsequent
vmemmap allocation will need way more memory than just this one page.
So it's very likely to fail anyway.

Thanks,
Muchun

>=20
> --=20
> Oscar Salvador
> SUSE Labs


