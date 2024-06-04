Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1482AEFE
	for <nvdimm@lists.linux.dev>; Tue,  4 Jun 2024 14:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717511215; cv=none; b=HwL85Qd9j2xwR3whdAo4V1rx8XFZ5FrMJev7QUKZmpdsYR4JftBytXYGZT7TBBMd7aueEVBRqi23cvynkc5FCGve8KPmpenHxPdkniJnvlwkKtvmzoP2592MksE7iKVZVUZDJIuX+PIM/M6HhtXlosBdwke6WvDpl9WgKD0Osig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717511215; c=relaxed/simple;
	bh=7+91b/Mzn/+lSMt/L+Per4bli8Defp55Ltg9xOXNCLI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VdDxc9LrG2d+2oGwbgPEjUtKegT3fZ1t1ft2tVReSkg6dB8QDlV5YXn2HqwwzP73zEHxG4b7Zpy/mSpy9Y6Ul0n4NDFXGVNnihxcm0Ia7gj1V7/DHVZWeCV4m0kJE/80Ujjfmf4/6c0TwdfRmxwgcGVyfZmMekfyJepexPZ8pZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Vtt8n1FWTz6JBWr;
	Tue,  4 Jun 2024 22:22:33 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 5968C140D37;
	Tue,  4 Jun 2024 22:26:49 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 4 Jun
 2024 15:26:48 +0100
Date: Tue, 4 Jun 2024 15:26:48 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: James Morse <james.morse@arm.com>
CC: Dan Williams <dan.j.williams@intel.com>, Dongsheng Yang
	<dongsheng.yang@easystack.cn>, Gregory Price <gregory.price@memverge.com>,
	John Groves <John@groves.net>, <axboe@kernel.dk>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, Mark Rutland
	<mark.rutland@arm.com>
Subject: Re: [PATCH RFC 0/7] block: Introduce CBD (CXL Block Device)
Message-ID: <20240604152648.000071f8@Huawei.com>
In-Reply-To: <3c7c9b07-78b2-4b8d-968e-0c395c8f22b3@arm.com>
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
	<20240603134819.00001c5f@Huawei.com>
	<3c7c9b07-78b2-4b8d-968e-0c395c8f22b3@arm.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Mon, 3 Jun 2024 18:28:51 +0100
James Morse <james.morse@arm.com> wrote:

> Hi guys,
>=20
> On 03/06/2024 13:48, Jonathan Cameron wrote:
> > On Fri, 31 May 2024 20:22:42 -0700
> > Dan Williams <dan.j.williams@intel.com> wrote: =20
> >> Jonathan Cameron wrote: =20
> >>> On Thu, 30 May 2024 14:59:38 +0800
> >>> Dongsheng Yang <dongsheng.yang@easystack.cn> wrote: =20
> >>>> =E5=9C=A8 2024/5/29 =E6=98=9F=E6=9C=9F=E4=B8=89 =E4=B8=8B=E5=8D=88 1=
1:25, Gregory Price =E5=86=99=E9=81=93:   =20
> >>>>> It's not just a CXL spec issue, though that is part of it. I think =
the
> >>>>> CXL spec would have to expose some form of puncturing flush, and th=
is
> >>>>> makes the assumption that such a flush doesn't cause some kind of
> >>>>> race/deadlock issue.  Certainly this needs to be discussed.
> >>>>>
> >>>>> However, consider that the upstream processor actually has to gener=
ate
> >>>>> this flush.  This means adding the flush to existing coherence prot=
ocols,
> >>>>> or at the very least a new instruction to generate the flush explic=
itly.
> >>>>> The latter seems more likely than the former.
> >>>>>
> >>>>> This flush would need to ensure the data is forced out of the local=
 WPQ
> >>>>> AND all WPQs south of the PCIE complex - because what you really wa=
nt to
> >>>>> know is that the data has actually made it back to a place where re=
mote
> >>>>> viewers are capable of percieving the change.
> >>>>>
> >>>>> So this means:
> >>>>> 1) Spec revision with puncturing flush
> >>>>> 2) Buy-in from CPU vendors to generate such a flush
> >>>>> 3) A new instruction added to the architecture.
> >>>>>
> >>>>> Call me in a decade or so.
> >>>>>
> >>>>>
> >>>>> But really, I think it likely we see hardware-coherence well before=
 this.
> >>>>> For this reason, I have become skeptical of all but a few memory sh=
aring
> >>>>> use cases that depend on software-controlled cache-coherency.     =
=20
> >>>>
> >>>> Hi Gregory,
> >>>>
> >>>> 	From my understanding, we actually has the same idea here. What I a=
m=20
> >>>> saying is that we need SPEC to consider this issue, meaning we need =
to=20
> >>>> describe how the entire software-coherency mechanism operates, which=
=20
> >>>> includes the necessary hardware support. Additionally, I agree that =
if=20
> >>>> software-coherency also requires hardware support, it seems that=20
> >>>> hardware-coherency is the better path.   =20
> >>>>>
> >>>>> There are some (FAMFS, for example). The coherence state of these
> >>>>> systems tend to be less volatile (e.g. mappings are read-only), or
> >>>>> they have inherent design limitations (cacheline-sized message pass=
ing
> >>>>> via write-ahead logging only).     =20
> >>>>
> >>>> Can you explain more about this? I understand that if the reader in =
the=20
> >>>> writer-reader model is using a readonly mapping, the interaction wil=
l be=20
> >>>> much simpler. However, after the writer writes data, if we don't hav=
e a=20
> >>>> mechanism to flush and invalidate puncturing all caches, how can the=
=20
> >>>> readonly reader access the new data?   =20
> >>>
> >>> There is a mechanism for doing coarse grained flushing that is known =
to
> >>> work on some architectures. Look at cpu_cache_invalidate_memregion().
> >>> On intel/x86 it's wbinvd_on_all_cpu_cpus()   =20
> >>
> >> There is no guarantee on x86 that after cpu_cache_invalidate_memregion=
()
> >> that a remote shared memory consumer can be assured to see the writes
> >> from that event. =20
> >=20
> > I was wondering about that after I wrote this...  I guess it guarantees
> > we won't get a late landing write or is that not even true?
> >=20
> > So if we remove memory, then added fresh memory again quickly enough
> > can we get a left over write showing up?  I guess that doesn't matter as
> > the kernel will chase it with a memset(0) anyway and that will be order=
ed
> > as to the same address.
> >=20
> > However we won't be able to elide that zeroing even if we know the devi=
ce
> > did it which is makes some operations the device might support rather
> > pointless :( =20
>=20
> >>> on arm64 it's a PSCI firmware call CLEAN_INV_MEMREGION (there is a
> >>> public alpha specification for PSCI 1.3 with that defined but we
> >>> don't yet have kernel code.)   =20
>=20
> I have an RFC for that - but I haven't had time to update and re-test it.

If it's useful, I might either be able to find time to take that forwards
(or get someone else to do it).

Let me know if that would be helpful; I'd love to add this to the list
of things I can forget about because it just works for kernel
(and hence is a problem for the firmware and uarch folk).

>=20
> If you need this, and have a platform where it can be implemented, please=
 get in touch
> with the people that look after the specs to move it along from alpha.
>=20
>=20
> >> That punches visibility through CXL shared memory devices? =20
>=20
> > It's a draft spec and Mark + James in +CC can hopefully confirm.
> > It does say
> > "Cleans and invalidates all caches, including system caches".
> > which I'd read as meaning it should but good to confirm. =20
>=20
> It's intended to remove any cached entries - including lines in what the =
arm-arm calls
> "invisible" system caches, which typically only platform firmware can tou=
ch. The next
> access should have to go all the way to the media. (I don't know enough a=
bout CXL to say
> what a remote shared memory consumer observes)

If it's out of the host bridge buffers (and known to have succeeded in writ=
e back) which I
think the host should know, I believe what happens next is a device impleme=
nter problem.
Hopefully anyone designing a device that does memory sharing has built that=
 part right.

>=20
> Without it, all we have are the by-VA operations which are painfully slow=
 for large
> regions, and insufficient for system caches.
>=20
> As with all those firmware interfaces - its for the platform implementer =
to wire up
> whatever is necessary to remove cached content for the specified range. J=
ust because there
> is an (alpha!) spec doesn't mean it can be supported efficiently by a par=
ticular platform.
>=20
>=20
> >>> These are very big hammers and so unsuited for anything fine grained.=
 =20
>=20
> You forgot really ugly too!

I was being polite :)

>=20
>=20
> >>> In the extreme end of possible implementations they briefly stop all
> >>> CPUs and clean and invalidate all caches of all types. So not suited
> >>> to anything fine grained, but may be acceptable for a rare setup even=
t,
> >>> particularly if the main job of the writing host is to fill that memo=
ry
> >>> for lots of other hosts to use.
> >>>
> >>> At least the ARM one takes a range so allows for a less painful
> >>> implementation.  =20
>=20
> That is to allow some ranges to fail. (e.g. you can do this to the CXL wi=
ndows, but not
> the regular DRAM).
>=20
> On the less painful implementation, arm's interconnect has a gadget that =
does "Address
> based flush" which could be used here. I'd hope platforms with that don't=
 need to
> interrupt all CPUs - but it depends on what else needs to be done.
>=20
>=20
> >>> I'm assuming we'll see new architecture over time
> >>> but this is a different (and potentially easier) problem space
> >>> to what you need.   =20
> >>
> >> cpu_cache_invalidate_memregion() is only about making sure local CPU
> >> sees new contents after an DPA:HPA remap event. I hope CPUs are able to
> >> get away from that responsibility long term when / if future memory
> >> expanders just issue back-invalidate automatically when the HDM decoder
> >> configuration changes. =20
> >=20
> > I would love that to be the way things go, but I fear the overheads of
> > doing that on the protocol means people will want the option of the pai=
nful
> > approach. =20
>=20
>=20
>=20
> Thanks,
>=20
> James

Thanks for the info,

Jonathan

>=20

