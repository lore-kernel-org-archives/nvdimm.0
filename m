Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785CF2BB03
	for <nvdimm@lists.linux.dev>; Wed,  8 May 2024 12:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715170291; cv=none; b=rpIZS379epGMRYDnxOrcs+5IXDOd+QjZi7Dg+OTDfIn5f5ot/QywmBVBheTfIuQ3FTNdxK7BTDDBbrG4uH6+vC/fGuc/8d+StaPk94IgnOfPFh7/x3vxT9kh/p48lis2+akTfUj9shBXaos7aOVvQEZ95WQ5eWyGeTGg5JXkx4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715170291; c=relaxed/simple;
	bh=CvC4SaTrCKbShgiA1w33VZZILcCw+uE0dnFnAgjYmGM=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=osLpBY/U/ja+syuOPxUKFJ4+z5tWTDwUaVI93+A6OsnaV2MTWMMDBaeDKY/Y0x1q3yYbCTfGvQ1tc+OS2vEDC3NdHD7DuNUGzMq25ALPv0WNAtZhMDs4E6+4uTgI14bUkxs4TSScXnOT38fVoIgGqGcOPuQ0dipVQztYWtCIEaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VZDWQ05bHz6D9DJ;
	Wed,  8 May 2024 20:10:58 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 3E1D31402CB;
	Wed,  8 May 2024 20:11:27 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 8 May
 2024 13:11:26 +0100
Date: Wed, 8 May 2024 13:11:25 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dongsheng Yang <dongsheng.yang@easystack.cn>
CC: John Groves <John@groves.net>, Dan Williams <dan.j.williams@intel.com>,
	Gregory Price <gregory.price@memverge.com>, <axboe@kernel.dk>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH RFC 0/7] block: Introduce CBD (CXL Block Device)
Message-ID: <20240508131125.00003d2b@Huawei.com>
In-Reply-To: <5b7f3700-aeee-15af-59a7-8e271a89c850@easystack.cn>
References: <20240422071606.52637-1-dongsheng.yang@easystack.cn>
	<66288ac38b770_a96f294c6@dwillia2-mobl3.amr.corp.intel.com.notmuch>
	<ef34808b-d25d-c953-3407-aa833ad58e61@easystack.cn>
	<ZikhwAAIGFG0UU23@memverge.com>
	<bbf692ec-2109-baf2-aaae-7859a8315025@easystack.cn>
	<ZiuwyIVaKJq8aC6g@memverge.com>
	<98ae27ff-b01a-761d-c1c6-39911a000268@easystack.cn>
	<ZivS86BrfPHopkru@memverge.com>
	<8f373165-dd2b-906f-96da-41be9f27c208@easystack.cn>
	<wold3g5ww63cwqo7rlwevqcpmlen3fl3lbtbq3qrmveoh2hale@e7carkmumnub>
	<20240503105245.00003676@Huawei.com>
	<5b7f3700-aeee-15af-59a7-8e271a89c850@easystack.cn>
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
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Wed, 8 May 2024 19:39:23 +0800
Dongsheng Yang <dongsheng.yang@easystack.cn> wrote:

> =E5=9C=A8 2024/5/3 =E6=98=9F=E6=9C=9F=E4=BA=94 =E4=B8=8B=E5=8D=88 5:52, J=
onathan Cameron =E5=86=99=E9=81=93:
> > On Sun, 28 Apr 2024 11:55:10 -0500
> > John Groves <John@groves.net> wrote:
> >  =20
> >> On 24/04/28 01:47PM, Dongsheng Yang wrote: =20
> >>>
> >>>
> >>> =E5=9C=A8 2024/4/27 =E6=98=9F=E6=9C=9F=E5=85=AD =E4=B8=8A=E5=8D=88 12=
:14, Gregory Price =E5=86=99=E9=81=93: =20
> >>>> On Fri, Apr 26, 2024 at 10:53:43PM +0800, Dongsheng Yang wrote: =20
> >>>>>
> >>>>>
> >>>>> =E5=9C=A8 2024/4/26 =E6=98=9F=E6=9C=9F=E4=BA=94 =E4=B8=8B=E5=8D=88 =
9:48, Gregory Price =E5=86=99=E9=81=93: =20
> >>>>>>     =20
> >>>>> =20
>=20
> ...
> >>
> >> Just to make things slightly gnarlier, the MESI cache coherency protoc=
ol
> >> allows a CPU to speculatively convert a line from exclusive to modifie=
d,
> >> meaning it's not clear as of now whether "occasional" clean write-backs
> >> can be avoided. Meaning those read-only mappings may be more important
> >> than one might think. (Clean write-backs basically make it
> >> impossible for software to manage cache coherency.) =20
> >=20
> > My understanding is that clean write backs are an implementation specif=
ic
> > issue that came as a surprise to some CPU arch folk I spoke to, we will
> > need some path for a host to say if they can ever do that.
> >=20
> > Given this definitely effects one CPU vendor, maybe solutions that
> > rely on this not happening are not suitable for upstream.
> >=20
> > Maybe this market will be important enough for that CPU vendor to stop
> > doing it but if they do it will take a while...
> >=20
> > Flushing in general is as CPU architecture problem where each of the
> > architectures needs to be clear what they do / specify that their
> > licensees do.
> >=20
> > I'm with Dan on encouraging all memory vendors to do hardware coherence=
! =20
>=20
> Hi Gregory, John, Jonathan and Dan:
> 	Thanx for your information, they help a lot, and sorry for the late repl=
y.
>=20
> After some internal discussions, I think we can design it as follows:
>=20
> (1) If the hardware implements cache coherence, then the software layer=20
> doesn't need to consider this issue, and can perform read and write=20
> operations directly.

Agreed - this is one easier case.

>=20
> (2) If the hardware doesn't implement cache coherence, we can consider a=
=20
> DMA-like approach, where we check architectural features to determine if=
=20
> cache coherence is supported. This could be similar to=20
> `dev_is_dma_coherent`.

Ok. So this would combine host support checks with checking if the shared
memory on the device is multi host cache coherent (it will be single host
cache coherent which is what makes this messy)
>=20
> Additionally, if the architecture supports flushing and invalidating CPU=
=20
> caches (`CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE`,=20
> `CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU`,=20
> `CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL`),

Those particular calls won't tell you much at all. They indicate that a flu=
sh
can happen as far as a common point for DMA engines in the system. No
information on whether there are caches beyond that point.

>=20
> then we can handle cache coherence at the software layer.
> (For the clean writeback issue, I think it may also require=20
> clarification from the architecture, and how DMA handles the clean=20
> writeback problem, which I haven't further checked.)

I believe the relevant architecture only does IO coherent DMA so it is
never a problem (unlike with multihost cache coherence).
>=20
> (3) If the hardware doesn't implement cache coherence and the cpu=20
> doesn't support the required CPU cache operations, then we can run in=20
> nocache mode.

I suspect that gets you no where either.  Never believe an architecture
that provides a flag that says not to cache something.  That just means
you should not be able to tell that it is cached - many many implementations
actually cache such accesses.

>=20
> CBD can initially support (3), and then transition to (1) when hardware=20
> supports cache-coherency. If there's sufficient market demand, we can=20
> also consider supporting (2).
I'd assume only (3) works.  The others rely on assumptions I don't think
you can rely on.

Fun fun fun,

Jonathan

>=20
> How does this approach sound?
>=20
> Thanx
> >=20
> > J
> >  =20
> >>
> >> Keep in mind that I don't think anybody has cxl 3 devices or CPUs yet,=
 and
> >> shared memory is not explicitly legal in cxl 2, so there are things a =
cpu
> >> could do (or not do) in a cxl 2 environment that are not illegal becau=
se
> >> they should not be observable in a no-shared-memory environment.
> >>
> >> CBD is interesting work, though for some of the reasons above I'm some=
what
> >> skeptical of shared memory as an IPC mechanism.
> >>
> >> Regards,
> >> John
> >>
> >>
> >> =20
> >=20
> > .
> >  =20

