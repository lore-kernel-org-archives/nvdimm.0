Received: from mta1.migadu.com (out-13.mta1.migadu.com [95.215.58.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F1E38DC59
	for <nvdimm@lists.linux.dev>; Tue, 22 Sep 2026 02:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790044076; cv=none; b=YhE0JCpJ2YAuvOGDLXas5AFe321FAF6G+QoaO3OfRkdA0KdeXTAwNhQ6/yVDTeKtAyQocd1u3Fdl9QB1D3s5On+aiX9jMBNQBg7vRHzrq/Et2SUFgQLEVaYJzjr7+SPz2wpo89joQoSBsyMlTMklbCDMkgVL8+5Cj0LMvJ/dFik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790044076; c=relaxed/simple;
	bh=3CjXMS53zV+HLZvMtpnhDl9IakC1n27yfG/EDs9WPtk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=hBQBQVNH+2eAnKpNYtZgzvwRSSyq1K7toBL95amfioP137nN8OfU4j/qsZDA9ddTz+zPGTtKTSL5vev7xK8NUgd5/7p6GZIoThrvkfm9CtVFvwBYMDRUh+yjeBZ0hLl52yVzJ7HA2yj38jHx/xagF2tpXoJVteDkZpuSRFD2XmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NvkAojy3; arc=none smtp.client-ip=95.215.58.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NvkAojy3"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=3CjXMS53zV+HLZvMtpnhDl9IakC1n27yfG/EDs9WPtk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790044072; v=1; x=1790648872;
 b=NvkAojy3+JXGLruUXHAoKs2L2rw3SZYUjQoIDHO2Xjj78gDDouLACch1dqP577F4YsXSgcFX
 5rJ0CCLDq1SEjiOEhf+hQrqWHiZoGr+TX1khoSN/0IoZhBI11cWWugzJ3BU7XLEp7iUoJg2O66E
 CB1p84KJzhY1djZ2VxhJpyrc=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta12.migadu.com with ESMTPS id d6c94d2e8f1298ab;
	Tue, 22 Sep 2026 02:27:52 +0000
X-Mizu-Trace-ID: d6c94d2e8f1298ab
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 2/2] dax/bus: fix mapping attribute error reporting
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <7619863e-0690-4f45-ae99-c75ad7573c61@intel.com>
Date: Tue, 22 Sep 2026 10:27:38 +0800
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
Message-Id: <637AA252-C5EF-4BE0-AFAD-A037452B82F7@linux.dev>
References: <20260915095621.3744167-1-songmuchun@bytedance.com>
 <20260915095621.3744167-3-songmuchun@bytedance.com>
 <7619863e-0690-4f45-ae99-c75ad7573c61@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 22, 2026, at 03:23, Dave Jiang <dave.jiang@intel.com> wrote:
>=20
>=20
>=20
> On 9/15/26 2:56 AM, Muchun Song wrote:
>> After the DAX configuration locking was converted to rwsems, =
successful
>> lock acquisition leaves rc set to zero in mapping_store(). If the =
requested
>> range size is misaligned, the allocation is skipped and the zero rc =
is
>> converted to len. The sysfs write therefore reports success without
>> allocating the requested range.
>>=20
>> Call alloc_dev_dax_range() unconditionally and let its full range
>> validation return -EINVAL for a misaligned start or size.
>>=20
>> Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a =
local rwsem")
>> Assisted-by: LLM
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> drivers/dax/bus.c | 3 +--
>> 1 file changed, 1 insertion(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
>> index 54e4bbc98218..f232001ff5b7 100644
>> --- a/drivers/dax/bus.c
>> +++ b/drivers/dax/bus.c
>> @@ -1276,8 +1276,7 @@ static ssize_t mapping_store(struct device =
*dev, struct device_attribute *attr,
>> }
>>=20
>> 	to_alloc =3D range_len(&r);
>> - 	if (size_is_aligned(dev_dax, to_alloc))
>> - 		rc =3D alloc_dev_dax_range(dev_dax, r.start, to_alloc);
>> + 		rc =3D alloc_dev_dax_range(dev_dax, r.start, to_alloc);
>> 	up_write(&dax_dev_rwsem);
>> 	up_write(&dax_region_rwsem);
>>=20
>=20
> So this patch becomes somewhat of a backport issue as it depends on =
patch 1. Please consider swap the ordering of your patch series and fix =
this issue first. Maybe something like so the fix can be independently =
backported:

Make sense. I'll update soon.

Thanks,
Muchun

>=20
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index b809e1a264af..e40c25401cf0 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1192,7 +1192,7 @@ static ssize_t mapping_store(struct device *dev, =
struct de
> vice_attribute *attr,
>                return rc;
>        if (!dax_region->dev->driver) {
>                up_write(&dax_region_rwsem);
> -               return rc;
> +               return -ENXIO;
>        }
>        rc =3D down_write_killable(&dax_dev_rwsem);
>        if (rc) {
> @@ -1201,8 +1201,12 @@ static ssize_t mapping_store(struct device =
*dev, struct d
> evice_attribute *attr,
>        }
>=20
>        to_alloc =3D range_len(&r);
> -       if (alloc_is_aligned(dev_dax, to_alloc))
> +       if (!alloc_is_aligned(dev_dax, to_alloc)) {
> +               dev_dbg(dev, "%s: size: %zu misaligned\n", __func__, =
to_alloc);
> +               rc =3D -EINVAL;
> +       } else {
>                rc =3D alloc_dev_dax_range(dev_dax, r.start, to_alloc);
> +       }
>        up_write(&dax_dev_rwsem);
>        up_write(&dax_region_rwsem);


