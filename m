Received: from mta1.migadu.com (out-219.mta1.migadu.com [95.215.58.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3AD388890
	for <nvdimm@lists.linux.dev>; Tue, 22 Sep 2026 02:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790043731; cv=none; b=FongSpNNwmUUgtBW5q8Kapo28iqUU3vP9wBf4y0sN9GcxhL9IizqLxejcar12Q4TUlcEysbpHoFuK3MXfpu8CLdvOt4i6Ji0OUJwCCXpfXZYMNradKpPvUQnzZDRLFdIixHeCHtnj4DfU/hFEsetWu+xjpn70SL61ODQ5MvXLlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790043731; c=relaxed/simple;
	bh=uY4MN/p0vQ0kwgQ+QLFr385tvrIY8OSdK/akjMpR5d8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=PvYRvpuZSGMYhEhMA62XfIdqZu9ZjrwO9nyQdqgAR31+ZWCGQaKTsJM9IwgHmlmwkkrMWBm87tnWkoLtY24iyXRN6tjebvbFOWCGvNj6JLS9afk+Mhgn7XxfEfZUndbzEbJ+/cacWSPgK3k6cB4ngkBwjPyZVYqtDcnNyg6ajpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OlzDMFWF; arc=none smtp.client-ip=95.215.58.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OlzDMFWF"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=uY4MN/p0vQ0kwgQ+QLFr385tvrIY8OSdK/akjMpR5d8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790043725; v=1; x=1790648525;
 b=OlzDMFWFk5ohXDEjjdNc+vW69sfUXyvAdG1rhLt/mY8bhC2wpP05QX6VJtY8BShEpydhh3JY
 CoqDO/UiDXvUixFGhKJox+kUdNIi/jeOtECBXXgAXqe9PqmN1lZA704lT2Gut3cySUHFG+zJAQa
 W5kUh9Y3u+2U3yH8hbMM4tZM=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta12.migadu.com with ESMTPS id 3f4c559851bc5898;
	Tue, 22 Sep 2026 02:22:05 +0000
X-Mizu-Trace-ID: 3f4c559851bc5898
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 1/2] dax/bus: fix Device DAX range alignment validation
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <8a90ff33-97e4-4796-a8a6-f484760557ca@intel.com>
Date: Tue, 22 Sep 2026 10:21:50 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Joao Martins <joao.m.martins@oracle.com>,
 nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D5FDE914-C12B-4E34-B481-56BDEAE84118@linux.dev>
References: <20260915095621.3744167-1-songmuchun@bytedance.com>
 <20260915095621.3744167-2-songmuchun@bytedance.com>
 <8a90ff33-97e4-4796-a8a6-f484760557ca@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 22, 2026, at 05:01, Dave Jiang <dave.jiang@intel.com> wrote:
>=20
>=20
>=20
> On 9/15/26 2:56 AM, Muchun Song wrote:
>> dev_dax->align describes the page size used by a Device DAX mapping.
>> Both the start and size of every range must therefore be aligned to =
it;
>> otherwise the starting PFN cannot represent a naturally aligned page =
of
>> that size.
>>=20
>> Only range sizes are currently validated. A dynamic device can =
therefore
>> select a large-page alignment and allocate a range whose start is not
>> naturally aligned to that page size. The device binds successfully, =
but a
>> subsequent write to a userspace mapping may trigger a kernel panic.
>>=20
>> The automatic resize path can also split a size-aligned request =
across
>> arbitrary free gaps. When devices with different alignments fragment =
a
>> region, this can extend a range by less than its alignment. A later
>> allocation then fails, leaving the failed resize partially applied.
>>=20
>> Validate both the start and size of allocated and adjusted ranges. =
Make
>> the resize path account only for usable aligned space before changing =
any
>> ranges, and skip gaps that cannot satisfy the device alignment. =
Initialize
>> the device alignment before allocating its initial range so that all
>> allocations use the same validation.
>>=20
>> A mapping with an unaligned start is now rejected with -EINVAL, while =
a
>> naturally aligned mapping still binds successfully.
>>=20
>> Fixes: 6d82120f4156 ("device-dax: add an 'align' attribute")
>> Assisted-by: LLM
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> drivers/dax/bus.c | 143 =
+++++++++++++++++++++++++++++++++++-----------
>> 1 file changed, 109 insertions(+), 34 deletions(-)
>>=20
>> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
>> index b809e1a264af..54e4bbc98218 100644
>> --- a/drivers/dax/bus.c
>> +++ b/drivers/dax/bus.c
>> @@ -848,6 +848,44 @@ static int devm_register_dax_mapping(struct =
dev_dax *dev_dax, int range_id)
>> return 0;
>> }
>>=20
>> +static inline unsigned long dev_dax_min_align(struct dev_dax =
*dev_dax)
>> +{
>> + 	return max_t(unsigned long, dev_dax->align, =
memremap_compat_align());
>> +}
>> +
>> +static inline bool size_is_aligned(struct dev_dax *dev_dax, =
resource_size_t size)
>=20
> Leave the name alloc_is_aligned() may generate less churn in this =
patch
>=20

Yes, I initially thought that `alloc_is_aligned` was doing a size check,
in order to keep it clearly consistent with `range_is_aligned`. But this
did indeed introduce unnecessary churn, and it might be more suitable =
for
a separate cleanup later, rather than being squeezed into this series.

Thanks for your review.

Muchun=
