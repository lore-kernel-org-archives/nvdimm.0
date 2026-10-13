Received: from mta0.migadu.com (out-137.mta0.migadu.com [91.218.175.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3842D42DA36
	for <nvdimm@lists.linux.dev>; Tue, 13 Oct 2026 06:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791872856; cv=none; b=DiMzzObYxCWa90QsIUzlebBiXh6BZcXRjzm3p/sQ5LrTujjPRqI3sIm2honyXz2VSXVr0qP0S8kPiq+ajva51tXxTHpO0LTho9QsORIFc/qnCCGdSOTX8FwyJrs/3nn5d9/bBbopotZB3dfVg3uy/3K0km69+rOpd0fuQ/Brpvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791872856; c=relaxed/simple;
	bh=F9PuqLINOQFgmQyW7R6+BMZOP2DWjF8nm7Pit+6gdRE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=UxTHoO8wqUX0+piEH7KiT13+HlSrMjumHatzh3Kf5O1Rx0nbsb2jzz4u8q64cdPTmuKa+Lj80WIjv03lmc7aZwnY5esnP0MLJfjrK4NycVV5fUFQRYk3NUc7k2jMogMieasy8dDaN/NUKrxTdoIqgOyqKMq84EClzRsYuVBhxVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ui66fJHL; arc=none smtp.client-ip=91.218.175.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ui66fJHL"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=F9PuqLINOQFgmQyW7R6+BMZOP2DWjF8nm7Pit+6gdRE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791872853; v=1; x=1792477653;
 b=Ui66fJHLaO5KVxvN7O+TQbaU6xHnQtuqYnSNbUGyvD2CYeILnWMHIzUJJjq28KFzE2rNoPLj
 pSQO0TsWo9YzGiusTlGx0r/YSLZDl8o0M1/z/ObmIA5Xt0f/Qt09dmKTux22beuiESVg7yQImA2
 AkfGcavjD4zEBjftjy2POr5k=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 6566544149091e28;
	Tue, 13 Oct 2026 06:27:33 +0000
X-Mizu-Trace-ID: 6566544149091e28
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v3 1/2] dax/bus: fix mapping attribute error reporting
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <as13np-95gSaBbQm@aschofie-mobl2.lan>
Date: Tue, 13 Oct 2026 14:27:15 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Joao Martins <joao.m.martins@oracle.com>,
 nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <AAB2A53F-1D2B-44FA-9D36-C393444C6DAA@linux.dev>
References: <20260924025035.1265035-1-songmuchun@bytedance.com>
 <20260924025035.1265035-2-songmuchun@bytedance.com>
 <as13np-95gSaBbQm@aschofie-mobl2.lan>
To: Alison Schofield <alison.schofield@intel.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On Oct 13, 2026, at 08:13, Alison Schofield =
<alison.schofield@intel.com> wrote:
>=20
> On Thu, Sep 24, 2026 at 10:50:34AM +0800, Muchun Song wrote:
>> After the DAX configuration locking was converted to rwsems, =
successful
>> lock acquisition leaves rc set to zero in mapping_store(). Two error
>> paths can return this stale value: an unbound region driver and a
>> misaligned range size. The sysfs write therefore reports success =
without
>> allocating the requested range.
>>=20
>> Return -ENXIO when the region driver is not bound and -EINVAL when =
the
>> range size is misaligned.
>=20
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>

Thanks.

>=20
> Will modify subject line upon applying like so:
> dax/bus: Return errors for invalid mapping requests

No problem.

Thanks,
Muchun=
