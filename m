Received: from mta0.migadu.com (out-78.mta0.migadu.com [91.218.175.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3F331F9B9
	for <nvdimm@lists.linux.dev>; Sat, 19 Sep 2026 05:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789794269; cv=none; b=stBBViiGCPef3/BXiIo4Xi1fE5uKE1Bdcq5LrJdQryfrmb4k2ZC+o6y4gnwpTpDsb97O3cAT00M1KMTLOYgCOdZ6vfDse9o0UxLBTf2Kv7HQwqAaAbUR4YNv0rmgnonvdeU+eJ8ZVrViK7wfgEUGMvIX9G3J7Aj131sgFdKKiSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789794269; c=relaxed/simple;
	bh=5I0cr23layOUUFrQCtUSsraWauuJu7Tb+3NGrSlqoQ4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=BrYt4fqzqTfhOOONXc0BCdypHgoQoHOiLC6NOIF8gF/c6jlFj85kkpdp7s5zVhKD2GcbZLAP7FeBoqKfPY1G5CojoBvAw7QGwcu2fWViQw7dC3JUlX+pTeJvE6G9SVB28rbtMON11N4aZ04gcp/qXBksaUp/W9JlQ4TgQuEp1Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QL4xWcL6; arc=none smtp.client-ip=91.218.175.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QL4xWcL6"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=5I0cr23layOUUFrQCtUSsraWauuJu7Tb+3NGrSlqoQ4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789794264; v=1; x=1790399064;
 b=QL4xWcL6F2qii5FZmJmVKX8TpVgdkWigIyWrKho7+LYKfJTjma+I3kKhumgngIdE9JgEa3eu
 dqRrJer8hfvon2QWaq02MciuosmH6ZufSQQnHOU5oAlWfq0KN/jJdHjUCO9ja3ae/azZLK1xHBj
 E2LeJP43jlg2iL9HIM68If+4=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta11.migadu.com with ESMTPS id 5dbd40a902d5780f;
	Sat, 19 Sep 2026 05:04:14 +0000
X-Mizu-Trace-ID: 5dbd40a902d5780f
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 0/2] dax: Fix Device DAX range allocation validation
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ab129288-17e8-440d-b544-70ada8925cf0@intel.com>
Date: Sat, 19 Sep 2026 13:03:54 +0800
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
Message-Id: <0F332745-D70F-4C51-A597-50C1CAE53CCB@linux.dev>
References: <20260915095621.3744167-1-songmuchun@bytedance.com>
 <ab129288-17e8-440d-b544-70ada8925cf0@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 19, 2026, at 01:02, Dave Jiang <dave.jiang@intel.com> wrote:
>=20
>=20
>=20
> On 9/15/26 2:56 AM, Muchun Song wrote:
>> While working on the HugeTLB Vmemmap Optimization (HVO) =
generalization,
>> Sashiko reported that memmap_init_zone_device() could be asked to
>> initialize struct pages with a large-page order for a physical range
>> that was not naturally aligned to that order.
>>=20
>> Following the Device DAX call path confirmed that the condition was
>> reachable. Device DAX range validation checks the range size, but not
>> its start address. An unaligned range can therefore reach
>> memmap_init_zone_device() after the device binds, and a subsequent =
write
>> to a userspace mapping may trigger a kernel panic. With the help of =
an
>> LLM, I was able to reproduce the failure.
>>=20
>> The automatic resize path has a related problem. It can split an =
aligned
>> size request across arbitrary free gaps, consume an unaligned =
fragment,
>> and leave the resize partially applied when a later allocation fails.
>>=20
>> This series validates both the start and size of every Device DAX =
range
>> and makes automatic resize account only for usable aligned space. It
>> also fixes the mapping sysfs attribute to propagate validation =
failures
>> instead of reporting success without allocating the requested range.
>>=20
>> Muchun Song (2):
>>  dax/bus: fix Device DAX range alignment validation
>>  dax/bus: fix mapping attribute error reporting
>>=20
>> drivers/dax/bus.c | 144 =
+++++++++++++++++++++++++++++++++++-----------
>> 1 file changed, 109 insertions(+), 35 deletions(-)
>>=20
>>=20
>> base-commit: 1a1de54f7369cd2b5bac0f265910e60ad3a6b4c3
>=20
> This commit does not exist in Linus's tree. Can you please base the =
series on top of the latest 7.3-rc tag so sashiko can look over it? =
Thanks!

Hi,

The series is based on linux-next 20260914, and drivers/dax/bus.c is =
identical
between that branch and the latest 7.3-rc. Sashiko has also already =
reviewed it
here: [1].

Therefore, I didn't quite catch your point. Are you expecting Sashiko to =
conduct
another round of review based on the 7.3-rc code? (Are you concerned =
about issues
introduced by the additional commits in linux-next compared to 7.3-rc?)

[1] =
https://sashiko.dev/#/patchset/20260915095621.3744167-1-songmuchun%40byted=
ance.com

Thanks,
Muchun


