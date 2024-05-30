Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D880A17C232
	for <nvdimm@lists.linux.dev>; Thu, 30 May 2024 13:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717076300; cv=none; b=toUj4qYCt3TcP64Os3ekaBTJkEVPzMWv7pJ/Oc/Teu+BInjCupy0Y2z0Q68D2MUe8LypFAgjhk7iW5Z+iK2t5WhPU1cJldihe5M6UDR+2fHpxQHfx3tFvl/4K11KvslVWL+IFpXuNK9PAXnpJ/DmU5fszmBQWQ5SNz4yfsnsCWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717076300; c=relaxed/simple;
	bh=S55mCDwB/L5bdVzNJdlQckiADHtrRU057V4YeMUyCks=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mBsm+uY0bq0rwFqLyE5eXJd2LThWuHFmYS2Z9k4PneqpDvtrTfCZETVFkLrPQdl7TJ2/AiqEsDW8Su5vEPpDh4LyMO8p7ykq2+1OvrUKSGKM9VoFc229/G/qGRAGluuCkGjbLND7/NP0nhvz+1i9jicjkKDXm2O8hOlxP+S77G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VqnKK2qwNz6J9yY;
	Thu, 30 May 2024 21:34:13 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 61233140B38;
	Thu, 30 May 2024 21:38:15 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 30 May
 2024 14:38:14 +0100
Date: Thu, 30 May 2024 14:38:13 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dongsheng Yang <dongsheng.yang@easystack.cn>
CC: Gregory Price <gregory.price@memverge.com>, Dan Williams
	<dan.j.williams@intel.com>, John Groves <John@groves.net>, <axboe@kernel.dk>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH RFC 0/7] block: Introduce CBD (CXL Block Device)
Message-ID: <20240530143813.00006def@Huawei.com>
In-Reply-To: <5db870de-ecb3-f127-f31c-b59443b4fbb4@easystack.cn>
References: <20240503105245.00003676@Huawei.com>
	<5b7f3700-aeee-15af-59a7-8e271a89c850@easystack.cn>
	<20240508131125.00003d2b@Huawei.com>
	<ef0ee621-a2d2-e59a-f601-e072e8790f06@easystack.cn>
	<20240508164417.00006c69@Huawei.com>
	<3d547577-e8f2-8765-0f63-07d1700fcefc@easystack.cn>
	<20240509132134.00000ae9@Huawei.com>
	<a571be12-2fd3-e0ee-a914-0a6e2c46bdbc@easystack.cn>
	<664cead8eb0b6_add32947d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
	<8f161b2d-eacd-ad35-8959-0f44c8d132b3@easystack.cn>
	<ZldIzp0ncsRX5BZE@memverge.com>
	<5db870de-ecb3-f127-f31c-b59443b4fbb4@easystack.cn>
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
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Thu, 30 May 2024 14:59:38 +0800
Dongsheng Yang <dongsheng.yang@easystack.cn> wrote:

> =E5=9C=A8 2024/5/29 =E6=98=9F=E6=9C=9F=E4=B8=89 =E4=B8=8B=E5=8D=88 11:25,=
 Gregory Price =E5=86=99=E9=81=93:
> > On Wed, May 22, 2024 at 02:17:38PM +0800, Dongsheng Yang wrote: =20
> >>
> >>
> >> =E5=9C=A8 2024/5/22 =E6=98=9F=E6=9C=9F=E4=B8=89 =E4=B8=8A=E5=8D=88 2:4=
1, Dan Williams =E5=86=99=E9=81=93: =20
> >>> Dongsheng Yang wrote:
> >>>
> >>> What guarantees this property? How does the reader know that its local
> >>> cache invalidation is sufficient for reading data that has only reach=
ed
> >>> global visibility on the remote peer? As far as I can see, there is
> >>> nothing that guarantees that local global visibility translates to
> >>> remote visibility. In fact, the GPF feature is counter-evidence of the
> >>> fact that writes can be pending in buffers that are only flushed on a
> >>> GPF event. =20
> >>
> >> Sounds correct. From what I learned from GPF, ADR, and eADR, there wou=
ld
> >> still be data in WPQ even though we perform a CPU cache line flush in =
the
> >> OS.
> >>
> >> This means we don't have a explicit method to make data puncture all c=
aches
> >> and land in the media after writing. also it seems there isn't a expli=
cit
> >> method to invalidate all caches along the entire path.
> >> =20
> >>>
> >>> I remain skeptical that a software managed inter-host cache-coherency
> >>> scheme can be made reliable with current CXL defined mechanisms. =20
> >>
> >>
> >> I got your point now, acorrding current CXL Spec, it seems software ma=
naged
> >> cache-coherency for inter-host shared memory is not working. Will the =
next
> >> version of CXL spec consider it? =20
> >>> =20
> >=20
> > Sorry for missing the conversation, have been out of office for a bit.
> >=20
> > It's not just a CXL spec issue, though that is part of it. I think the
> > CXL spec would have to expose some form of puncturing flush, and this
> > makes the assumption that such a flush doesn't cause some kind of
> > race/deadlock issue.  Certainly this needs to be discussed.
> >=20
> > However, consider that the upstream processor actually has to generate
> > this flush.  This means adding the flush to existing coherence protocol=
s,
> > or at the very least a new instruction to generate the flush explicitly.
> > The latter seems more likely than the former.
> >=20
> > This flush would need to ensure the data is forced out of the local WPQ
> > AND all WPQs south of the PCIE complex - because what you really want to
> > know is that the data has actually made it back to a place where remote
> > viewers are capable of percieving the change.
> >=20
> > So this means:
> > 1) Spec revision with puncturing flush
> > 2) Buy-in from CPU vendors to generate such a flush
> > 3) A new instruction added to the architecture.
> >=20
> > Call me in a decade or so.
> >=20
> >=20
> > But really, I think it likely we see hardware-coherence well before thi=
s.
> > For this reason, I have become skeptical of all but a few memory sharing
> > use cases that depend on software-controlled cache-coherency. =20
>=20
> Hi Gregory,
>=20
> 	From my understanding, we actually has the same idea here. What I am=20
> saying is that we need SPEC to consider this issue, meaning we need to=20
> describe how the entire software-coherency mechanism operates, which=20
> includes the necessary hardware support. Additionally, I agree that if=20
> software-coherency also requires hardware support, it seems that=20
> hardware-coherency is the better path.
> >=20
> > There are some (FAMFS, for example). The coherence state of these
> > systems tend to be less volatile (e.g. mappings are read-only), or
> > they have inherent design limitations (cacheline-sized message passing
> > via write-ahead logging only). =20
>=20
> Can you explain more about this? I understand that if the reader in the=20
> writer-reader model is using a readonly mapping, the interaction will be=
=20
> much simpler. However, after the writer writes data, if we don't have a=20
> mechanism to flush and invalidate puncturing all caches, how can the=20
> readonly reader access the new data?

There is a mechanism for doing coarse grained flushing that is known to
work on some architectures. Look at cpu_cache_invalidate_memregion().
On intel/x86 it's wbinvd_on_all_cpu_cpus()
on arm64 it's a PSCI firmware call CLEAN_INV_MEMREGION (there is a
public alpha specification for PSCI 1.3 with that defined but we
don't yet have kernel code.)

These are very big hammers and so unsuited for anything fine grained.
In the extreme end of possible implementations they briefly stop all
CPUs and clean and invalidate all caches of all types.  So not suited
to anything fine grained, but may be acceptable for a rare setup event,
particularly if the main job of the writing host is to fill that memory
for lots of other hosts to use.

At least the ARM one takes a range so allows for a less painful
implementation.  I'm assuming we'll see new architecture over time
but this is a different (and potentially easier) problem space
to what you need.

Jonathan



> > ~Gregory
> >  =20

