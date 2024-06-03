Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CD1129A78
	for <nvdimm@lists.linux.dev>; Mon,  3 Jun 2024 12:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717418907; cv=none; b=sJQl7Qr9oRL87Z1PGWoBepCcHm5uuAkNI5/NnY84C0nl/hB5wZ5lLpPNpgFUtH6q2IT68ob8KMpurOftXFhl3OTUGTp8zIiIGRp3lWBfderjKfwRn4JgRcWThZsZ8Pch+aYHjT0uRM5lNo9t36cgDdYgnwOpEvZiHwTCSy/qLOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717418907; c=relaxed/simple;
	bh=LU3VNWiMTpsMlsnk6QbX+f+ptU01h6D7q3/HM/MmTn4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZD4761pfl+6hyYEmPqhbfvODReMmR1nOPBAkUNM9TcX0E8kRZ0D7Fl9RQbqwWuCsJUYfK2a/imN066pRF02pvEJakZGE8/HpaxHoKOT8jLC/wCbhn3QeJjnV1yBTf61Dl4PE9hzAtqMdlY1+lUqCp69ytqNPFGOO4b/0HJOhagw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VtD5F0LhTz6K9Y7;
	Mon,  3 Jun 2024 20:47:13 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 1B017140B2A;
	Mon,  3 Jun 2024 20:48:21 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 13:48:20 +0100
Date: Mon, 3 Jun 2024 13:48:19 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Dongsheng Yang <dongsheng.yang@easystack.cn>, Gregory Price
	<gregory.price@memverge.com>, John Groves <John@groves.net>,
	<axboe@kernel.dk>, <linux-block@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <james.morse@arm.com>, Mark Rutland
	<mark.rutland@arm.com>
Subject: Re: [PATCH RFC 0/7] block: Introduce CBD (CXL Block Device)
Message-ID: <20240603134819.00001c5f@Huawei.com>
In-Reply-To: <665a9402445ee_166872941d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <ef0ee621-a2d2-e59a-f601-e072e8790f06@easystack.cn>
	<20240508164417.00006c69@Huawei.com>
	<3d547577-e8f2-8765-0f63-07d1700fcefc@easystack.cn>
	<20240509132134.00000ae9@Huawei.com>
	<a571be12-2fd3-e0ee-a914-0a6e2c46bdbc@easystack.cn>
	<664cead8eb0b6_add32947d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
	<8f161b2d-eacd-ad35-8959-0f44c8d132b3@easystack.cn>
	<ZldIzp0ncsRX5BZE@memverge.com>
	<5db870de-ecb3-f127-f31c-b59443b4fbb4@easystack.cn>
	<20240530143813.00006def@Huawei.com>
	<665a9402445ee_166872941d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Fri, 31 May 2024 20:22:42 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Jonathan Cameron wrote:
> > On Thu, 30 May 2024 14:59:38 +0800
> > Dongsheng Yang <dongsheng.yang@easystack.cn> wrote:
> >  =20
> > > =E5=9C=A8 2024/5/29 =E6=98=9F=E6=9C=9F=E4=B8=89 =E4=B8=8B=E5=8D=88 11=
:25, Gregory Price =E5=86=99=E9=81=93: =20
> > > > On Wed, May 22, 2024 at 02:17:38PM +0800, Dongsheng Yang wrote:   =
=20
> > > >>
> > > >>
> > > >> =E5=9C=A8 2024/5/22 =E6=98=9F=E6=9C=9F=E4=B8=89 =E4=B8=8A=E5=8D=88=
 2:41, Dan Williams =E5=86=99=E9=81=93:   =20
> > > >>> Dongsheng Yang wrote:
> > > >>>
> > > >>> What guarantees this property? How does the reader know that its =
local
> > > >>> cache invalidation is sufficient for reading data that has only r=
eached
> > > >>> global visibility on the remote peer? As far as I can see, there =
is
> > > >>> nothing that guarantees that local global visibility translates to
> > > >>> remote visibility. In fact, the GPF feature is counter-evidence o=
f the
> > > >>> fact that writes can be pending in buffers that are only flushed =
on a
> > > >>> GPF event.   =20
> > > >>
> > > >> Sounds correct. From what I learned from GPF, ADR, and eADR, there=
 would
> > > >> still be data in WPQ even though we perform a CPU cache line flush=
 in the
> > > >> OS.
> > > >>
> > > >> This means we don't have a explicit method to make data puncture a=
ll caches
> > > >> and land in the media after writing. also it seems there isn't a e=
xplicit
> > > >> method to invalidate all caches along the entire path.
> > > >>   =20
> > > >>>
> > > >>> I remain skeptical that a software managed inter-host cache-coher=
ency
> > > >>> scheme can be made reliable with current CXL defined mechanisms. =
  =20
> > > >>
> > > >>
> > > >> I got your point now, acorrding current CXL Spec, it seems softwar=
e managed
> > > >> cache-coherency for inter-host shared memory is not working. Will =
the next
> > > >> version of CXL spec consider it?   =20
> > > >>>   =20
> > > >=20
> > > > Sorry for missing the conversation, have been out of office for a b=
it.
> > > >=20
> > > > It's not just a CXL spec issue, though that is part of it. I think =
the
> > > > CXL spec would have to expose some form of puncturing flush, and th=
is
> > > > makes the assumption that such a flush doesn't cause some kind of
> > > > race/deadlock issue.  Certainly this needs to be discussed.
> > > >=20
> > > > However, consider that the upstream processor actually has to gener=
ate
> > > > this flush.  This means adding the flush to existing coherence prot=
ocols,
> > > > or at the very least a new instruction to generate the flush explic=
itly.
> > > > The latter seems more likely than the former.
> > > >=20
> > > > This flush would need to ensure the data is forced out of the local=
 WPQ
> > > > AND all WPQs south of the PCIE complex - because what you really wa=
nt to
> > > > know is that the data has actually made it back to a place where re=
mote
> > > > viewers are capable of percieving the change.
> > > >=20
> > > > So this means:
> > > > 1) Spec revision with puncturing flush
> > > > 2) Buy-in from CPU vendors to generate such a flush
> > > > 3) A new instruction added to the architecture.
> > > >=20
> > > > Call me in a decade or so.
> > > >=20
> > > >=20
> > > > But really, I think it likely we see hardware-coherence well before=
 this.
> > > > For this reason, I have become skeptical of all but a few memory sh=
aring
> > > > use cases that depend on software-controlled cache-coherency.   =20
> > >=20
> > > Hi Gregory,
> > >=20
> > > 	From my understanding, we actually has the same idea here. What I am=
=20
> > > saying is that we need SPEC to consider this issue, meaning we need t=
o=20
> > > describe how the entire software-coherency mechanism operates, which=
=20
> > > includes the necessary hardware support. Additionally, I agree that i=
f=20
> > > software-coherency also requires hardware support, it seems that=20
> > > hardware-coherency is the better path. =20
> > > >=20
> > > > There are some (FAMFS, for example). The coherence state of these
> > > > systems tend to be less volatile (e.g. mappings are read-only), or
> > > > they have inherent design limitations (cacheline-sized message pass=
ing
> > > > via write-ahead logging only).   =20
> > >=20
> > > Can you explain more about this? I understand that if the reader in t=
he=20
> > > writer-reader model is using a readonly mapping, the interaction will=
 be=20
> > > much simpler. However, after the writer writes data, if we don't have=
 a=20
> > > mechanism to flush and invalidate puncturing all caches, how can the=
=20
> > > readonly reader access the new data? =20
> >=20
> > There is a mechanism for doing coarse grained flushing that is known to
> > work on some architectures. Look at cpu_cache_invalidate_memregion().
> > On intel/x86 it's wbinvd_on_all_cpu_cpus() =20
>=20
> There is no guarantee on x86 that after cpu_cache_invalidate_memregion()
> that a remote shared memory consumer can be assured to see the writes
> from that event.

I was wondering about that after I wrote this...  I guess it guarantees
we won't get a late landing write or is that not even true?

So if we remove memory, then added fresh memory again quickly enough
can we get a left over write showing up?  I guess that doesn't matter as
the kernel will chase it with a memset(0) anyway and that will be ordered
as to the same address.

However we won't be able to elide that zeroing even if we know the device
did it which is makes some operations the device might support rather
pointless :(

>=20
> > on arm64 it's a PSCI firmware call CLEAN_INV_MEMREGION (there is a
> > public alpha specification for PSCI 1.3 with that defined but we
> > don't yet have kernel code.) =20
>=20
> That punches visibility through CXL shared memory devices?

It's a draft spec and Mark + James in +CC can hopefully confirm.
It does say
"Cleans and invalidates all caches, including system caches".
which I'd read as meaning it should but good to confirm.

>=20
> > These are very big hammers and so unsuited for anything fine grained.
> > In the extreme end of possible implementations they briefly stop all
> > CPUs and clean and invalidate all caches of all types.  So not suited
> > to anything fine grained, but may be acceptable for a rare setup event,
> > particularly if the main job of the writing host is to fill that memory
> > for lots of other hosts to use.
> >=20
> > At least the ARM one takes a range so allows for a less painful
> > implementation.  I'm assuming we'll see new architecture over time
> > but this is a different (and potentially easier) problem space
> > to what you need. =20
>=20
> cpu_cache_invalidate_memregion() is only about making sure local CPU
> sees new contents after an DPA:HPA remap event. I hope CPUs are able to
> get away from that responsibility long term when / if future memory
> expanders just issue back-invalidate automatically when the HDM decoder
> configuration changes.

I would love that to be the way things go, but I fear the overheads of
doing that on the protocol means people will want the option of the painful
approach.

Jonathan
=20

