Received: from mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D3847B422
	for <nvdimm@lists.linux.dev>; Mon, 21 Sep 2026 09:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983262; cv=none; b=Ta66xx3XLOMz+9QUgthorgrOFzUJ2Wk7I19ZYtohehlmoPubbj4Tiv0nueYtFWnJwsLnFy2ER4KgKpZYUKhNbWUA+D+Eeb1/MTfXQXaIBxvjjkRxkp7yRFanEXPhRbferWxNunFA40F6LNtB3QcdCCw5Zojnc3YRKrJZ3f/XIuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983262; c=relaxed/simple;
	bh=W/5SMKE/9tmAzOhRzQxPsUoau/+8Db+SQdb2yaLqIhM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=M78+9InYXKUF78WLhHoDN08GTtoJqmwzXRbE4FZen/lB1d8gZpMLMcABuVN+GLUP53pn6XzxcXcAGwEjKSCuD5hPq9fYtf260Uf6bRbcv8MHQW1ToLtW2Kyo5Y//LPWuwKOmm+/ZbX/hvRd7pgzEdsY9W9q59gGJr/K9YuZ2NxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c6Os8atR; arc=none smtp.client-ip=95.215.58.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c6Os8atR"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=W/5SMKE/9tmAzOhRzQxPsUoau/+8Db+SQdb2yaLqIhM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789983258; v=1; x=1790588058;
 b=c6Os8atRqZ5IOtBMgSskrLlStpXT8MVK8CqJ7Yv63HAJX/WHryA+40KMliTNtWsf6xWdQGvj
 wmjWIOE1G63vgzDq/RUknmhoHWmNqew2W3aTnFWP+95SotIa2H3tfPmfYMRp9zI0c5zl/k1LgwU
 Mjus/yuzkYpOcv/lJtVhAIsA=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id a40a32e2570dfc55;
	Mon, 21 Sep 2026 09:34:18 +0000
X-Mizu-Trace-ID: a40a32e2570dfc55
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
In-Reply-To: <4bc1f4de-40ad-46f0-8d37-4c4e0cad0ad6@amd.com>
Date: Mon, 21 Sep 2026 17:33:56 +0800
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
Message-Id: <8EA6782C-7A3D-411F-91CD-031AB97CD024@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-4-songmuchun@bytedance.com>
 <4bc1f4de-40ad-46f0-8d37-4c4e0cad0ad6@amd.com>
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 21, 2026, at 14:42, Gupta, Pankaj <pankaj.gupta@amd.com> wrote:
>=20
>>=20
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
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>>  include/linux/memremap.h | 11 ++++++-
>>  mm/memremap.c            | 38 ++++++++++++++++++++++--
>>  mm/mm_init.c             | 11 +++++++
>>  mm/sparse-vmemmap.c      | 64 =
+++++++++++++++++++++++++++++++++++++---
>>  4 files changed, 116 insertions(+), 8 deletions(-)
>>=20
>> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
>> index e3c2ccf872a8..21c9b6aeef67 100644
>> --- a/include/linux/memremap.h
>> +++ b/include/linux/memremap.h
>> @@ -9,6 +9,7 @@
>>    struct resource;
>>  struct device;
>> +struct page;
>>    /**
>>   * struct vmem_altmap - pre-allocated storage for vmemmap_populate
>> @@ -108,7 +109,8 @@ struct dev_pagemap_ops {
>>   	void (*folio_split)(struct folio *head, struct folio *tail);
>>  };
>>  -#define PGMAP_ALTMAP_VALID (1 << 0)
>> +#define PGMAP_ALTMAP_VALID BIT(0)
>> +#define PGMAP_VMEMMAP_OPTIMIZATION BIT(1)
>=20
> I liked the overall idea.
>=20
> Minor naming suggestion I have:
>=20
> 'PGMAP_VMEMMAP_OPTIMIZATION' feel too generic to me.
>=20
> Maybe something on the lines to reflect the actual optimization:
>=20
> |PGMAP_SHARED_VMEMMAP or PGMAP_VMEMMAP_ON_DEMAND or some_other_name?|

Maybe PGMAP_VMEMMAP_SHARED? It describes the shared vmemmap backing
more precisely. I prefer SHARED over ON_DEMAND.

If you are OK with this, I will keep it for the next version.

Thanks,
Muchun

