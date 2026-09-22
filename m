Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D24381EAF
	for <nvdimm@lists.linux.dev>; Tue, 22 Sep 2026 02:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790043955; cv=none; b=l7ao8HiBXalW8kaXO1Ch52INgwoogmOWJzafuImyfECG7mR8phdB3CzGtiuHcSxmdCiB61qikSN7mlRbkAdRkY9MiA13OeMUoV+pGxbzLNEEcNU2oZskksXnkkRT2PJVcElwvM4C6ZASOF+G9GYc0kqg23PmbFy2jjtVXljW/T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790043955; c=relaxed/simple;
	bh=4gc+jBBr4dVHvxgW7Bn8V2HFGQ7eMX4V2yrN0xf5vLs=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=BVo8RPN/04Dt1+aT0GjUXxI6eRSMmBd1RaRPkmAoSjgb/Kzo9WTjn+eihjK+Y5VRlBhGAoJfHYmtTAaAjRuBoODT0qr9hgQKQn6RGaIPOBk9iTF6kb3zgoLgQIG4/5BfpPkRGdJA7OUBoOxcfw+oLfTeg55qd4Okaaww9PghjUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xoFrseCD; arc=none smtp.client-ip=91.218.175.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xoFrseCD"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=4gc+jBBr4dVHvxgW7Bn8V2HFGQ7eMX4V2yrN0xf5vLs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790043950; v=1; x=1790648750;
 b=xoFrseCDGiccgrO54Wga9HT0Eo7jpD5hVVVCTvLsCiWXH6M4/DyCWPRhAyEl9Dgc2cMjRfFq
 I5FUJTRxHgfhIcLL5ZTWrcpvBZaLNisnq+z2FYTeghl1Fg2XI4YRzYfbvtHDmHiz5pcTuginiP2
 HxWFI9zpSfWz/93R/WEUpBJY=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta12.migadu.com with ESMTPS id e4625a046478f653;
	Tue, 22 Sep 2026 02:25:50 +0000
X-Mizu-Trace-ID: e4625a046478f653
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
In-Reply-To: <2a2df8f0-ec31-4350-b1ef-3bdd2a76948e@intel.com>
Date: Tue, 22 Sep 2026 10:25:31 +0800
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
Message-Id: <432E37F0-2AD7-49D5-B608-E38F7C4B8DFF@linux.dev>
References: <20260915095621.3744167-1-songmuchun@bytedance.com>
 <ab129288-17e8-440d-b544-70ada8925cf0@intel.com>
 <0F332745-D70F-4C51-A597-50C1CAE53CCB@linux.dev>
 <2a2df8f0-ec31-4350-b1ef-3bdd2a76948e@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 22, 2026, at 02:58, Dave Jiang <dave.jiang@intel.com> wrote:
>=20
>=20
>=20
> On 9/18/26 10:03 PM, Muchun Song wrote:
>>=20
>>=20
>>> On Sep 19, 2026, at 01:02, Dave Jiang <dave.jiang@intel.com> wrote:
>>>=20
>>>=20
>>>=20
>>> On 9/15/26 2:56 AM, Muchun Song wrote:
>>>> While working on the HugeTLB Vmemmap Optimization (HVO) =
generalization,
>>>> Sashiko reported that memmap_init_zone_device() could be asked to
>>>> initialize struct pages with a large-page order for a physical =
range
>>>> that was not naturally aligned to that order.
>>>>=20
>>>> Following the Device DAX call path confirmed that the condition was
>>>> reachable. Device DAX range validation checks the range size, but =
not
>>>> its start address. An unaligned range can therefore reach
>>>> memmap_init_zone_device() after the device binds, and a subsequent =
write
>>>> to a userspace mapping may trigger a kernel panic. With the help of =
an
>>>> LLM, I was able to reproduce the failure.
>>>>=20
>>>> The automatic resize path has a related problem. It can split an =
aligned
>>>> size request across arbitrary free gaps, consume an unaligned =
fragment,
>>>> and leave the resize partially applied when a later allocation =
fails.
>>>>=20
>>>> This series validates both the start and size of every Device DAX =
range
>>>> and makes automatic resize account only for usable aligned space. =
It
>>>> also fixes the mapping sysfs attribute to propagate validation =
failures
>>>> instead of reporting success without allocating the requested =
range.
>>>>=20
>>>> Muchun Song (2):
>>>> dax/bus: fix Device DAX range alignment validation
>>>> dax/bus: fix mapping attribute error reporting
>>>>=20
>>>> drivers/dax/bus.c | 144 =
+++++++++++++++++++++++++++++++++++-----------
>>>> 1 file changed, 109 insertions(+), 35 deletions(-)
>>>>=20
>>>>=20
>>>> base-commit: 1a1de54f7369cd2b5bac0f265910e60ad3a6b4c3
>>>=20
>>> This commit does not exist in Linus's tree. Can you please base the =
series on top of the latest 7.3-rc tag so sashiko can look over it? =
Thanks!
>>=20
>> Hi,
>>=20
>> The series is based on linux-next 20260914, and drivers/dax/bus.c is =
identical
>> between that branch and the latest 7.3-rc. Sashiko has also already =
reviewed it
>> here: [1].
>>=20
>> Therefore, I didn't quite catch your point. Are you expecting Sashiko =
to conduct
>> another round of review based on the 7.3-rc code? (Are you concerned =
about issues
>> introduced by the additional commits in linux-next compared to =
7.3-rc?)
>=20
> Ok that's fine. But next time please use a tag that's valid from Linus =
tree and not linux-next. While there's a sashiko link, I'd like to see =
the sashiko response on the mailing list for easier review. I'm not sure =
if it's due to the base commit or something else for it to not show up. =
Sometimes sashiko responds with no regression found and sometimes it =
just does not respond. I'm not sure why the varied behavior.

I previously worked based on the mm development model, and this is my
first time learning about the development rules for DAX. I will develop
DAX based on Linus's tree going forward.

Thanks,
Muchun

>=20
> DJ
>=20
>=20
>>=20
>> [1] =
https://sashiko.dev/#/patchset/20260915095621.3744167-1-songmuchun%40byted=
ance.com
>>=20
>> Thanks,
>> Muchun


