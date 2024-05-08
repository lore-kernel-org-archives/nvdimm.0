Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF16127E28
	for <nvdimm@lists.linux.dev>; Wed,  8 May 2024 15:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715183065; cv=none; b=JI/XeHq8j+7+qkLG8wSAKwXc0m7v/a7vwsyaZQaD+zI3CAEeNEJRdfzRIJ6LJepU4XUvY4ic1YSy55Tfg+581D3SF/GxyvRAwlty39Mgjx6xxldeWsFHPfjChOIvGclS6z/bPO0LyB5Yp4nvCq9Hy4QRdzOWRkLB0K794Pnu0MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715183065; c=relaxed/simple;
	bh=fbytiBxk9aCvNLuZTIUm90QUNrs4BiaGpAjgwqM2sV8=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TW+tsv3/x4HfTjrymIJz5B2aDJqTVcB0YOaY9wyTIVNZ6YfcmpY5gzFqf5/O8QBhHbbGTE8J6bUkH1ldNDK4cCR24LH4kmhHevBzRIAIQNAwUrDCggvL47wpvQYtBXi7yT3UaDNWijF00+PYQuu41V59StroAtosSrG9ZulMwoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VZKB14wvMz6K6Lg;
	Wed,  8 May 2024 23:41:13 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id B60CC1400D1;
	Wed,  8 May 2024 23:44:19 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 8 May
 2024 16:44:18 +0100
Date: Wed, 8 May 2024 16:44:17 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dongsheng Yang <dongsheng.yang@easystack.cn>
CC: John Groves <John@groves.net>, Dan Williams <dan.j.williams@intel.com>,
	Gregory Price <gregory.price@memverge.com>, <axboe@kernel.dk>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH RFC 0/7] block: Introduce CBD (CXL Block Device)
Message-ID: <20240508164417.00006c69@Huawei.com>
In-Reply-To: <ef0ee621-a2d2-e59a-f601-e072e8790f06@easystack.cn>
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
	<20240508131125.00003d2b@Huawei.com>
	<ef0ee621-a2d2-e59a-f601-e072e8790f06@easystack.cn>
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

On Wed, 8 May 2024 21:03:54 +0800
Dongsheng Yang <dongsheng.yang@easystack.cn> wrote:

> =E5=9C=A8 2024/5/8 =E6=98=9F=E6=9C=9F=E4=B8=89 =E4=B8=8B=E5=8D=88 8:11, J=
onathan Cameron =E5=86=99=E9=81=93:
> > On Wed, 8 May 2024 19:39:23 +0800
> > Dongsheng Yang <dongsheng.yang@easystack.cn> wrote:
> >  =20
> >> =E5=9C=A8 2024/5/3 =E6=98=9F=E6=9C=9F=E4=BA=94 =E4=B8=8B=E5=8D=88 5:52=
, Jonathan Cameron =E5=86=99=E9=81=93: =20
> >>> On Sun, 28 Apr 2024 11:55:10 -0500
> >>> John Groves <John@groves.net> wrote:
> >>>     =20
> >>>> On 24/04/28 01:47PM, Dongsheng Yang wrote: =20
> >>>>>
> >>>>>
> >>>>> =E5=9C=A8 2024/4/27 =E6=98=9F=E6=9C=9F=E5=85=AD =E4=B8=8A=E5=8D=88 =
12:14, Gregory Price =E5=86=99=E9=81=93: =20
> >>>>>> On Fri, Apr 26, 2024 at 10:53:43PM +0800, Dongsheng Yang wrote: =20
> >>>>>>>
> >>>>>>>
> >>>>>>> =E5=9C=A8 2024/4/26 =E6=98=9F=E6=9C=9F=E4=BA=94 =E4=B8=8B=E5=8D=
=88 9:48, Gregory Price =E5=86=99=E9=81=93: =20
> >>>>>>>>        =20
> >>>>>>>    =20
> >>
> >> ... =20
> >>>>
> >>>> Just to make things slightly gnarlier, the MESI cache coherency prot=
ocol
> >>>> allows a CPU to speculatively convert a line from exclusive to modif=
ied,
> >>>> meaning it's not clear as of now whether "occasional" clean write-ba=
cks
> >>>> can be avoided. Meaning those read-only mappings may be more importa=
nt
> >>>> than one might think. (Clean write-backs basically make it
> >>>> impossible for software to manage cache coherency.) =20
> >>>
> >>> My understanding is that clean write backs are an implementation spec=
ific
> >>> issue that came as a surprise to some CPU arch folk I spoke to, we wi=
ll
> >>> need some path for a host to say if they can ever do that.
> >>>
> >>> Given this definitely effects one CPU vendor, maybe solutions that
> >>> rely on this not happening are not suitable for upstream.
> >>>
> >>> Maybe this market will be important enough for that CPU vendor to stop
> >>> doing it but if they do it will take a while...
> >>>
> >>> Flushing in general is as CPU architecture problem where each of the
> >>> architectures needs to be clear what they do / specify that their
> >>> licensees do.
> >>>
> >>> I'm with Dan on encouraging all memory vendors to do hardware coheren=
ce! =20
> >>
> >> Hi Gregory, John, Jonathan and Dan:
> >> 	Thanx for your information, they help a lot, and sorry for the late r=
eply.
> >>
> >> After some internal discussions, I think we can design it as follows:
> >>
> >> (1) If the hardware implements cache coherence, then the software layer
> >> doesn't need to consider this issue, and can perform read and write
> >> operations directly. =20
> >=20
> > Agreed - this is one easier case.
> >  =20
> >>
> >> (2) If the hardware doesn't implement cache coherence, we can consider=
 a
> >> DMA-like approach, where we check architectural features to determine =
if
> >> cache coherence is supported. This could be similar to
> >> `dev_is_dma_coherent`. =20
> >=20
> > Ok. So this would combine host support checks with checking if the shar=
ed
> > memory on the device is multi host cache coherent (it will be single ho=
st
> > cache coherent which is what makes this messy) =20
> >>
> >> Additionally, if the architecture supports flushing and invalidating C=
PU
> >> caches (`CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE`,
> >> `CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU`,
> >> `CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL`), =20
> >=20
> > Those particular calls won't tell you much at all. They indicate that a=
 flush
> > can happen as far as a common point for DMA engines in the system. No
> > information on whether there are caches beyond that point.
> >  =20
> >>
> >> then we can handle cache coherence at the software layer.
> >> (For the clean writeback issue, I think it may also require
> >> clarification from the architecture, and how DMA handles the clean
> >> writeback problem, which I haven't further checked.) =20
> >=20
> > I believe the relevant architecture only does IO coherent DMA so it is
> > never a problem (unlike with multihost cache coherence).Hi Jonathan, =20
>=20
> let me provide an example,
> In nvmeof-rdma, the `nvme_rdma_queue_rq` function places a request into=20
> `req->sqe.dma`.
>=20
> (1) First, it calls `ib_dma_sync_single_for_cpu()`, which invalidates=20
> the CPU cache:
>=20
>=20
> ib_dma_sync_single_for_cpu(dev, sqe->dma,
>                              sizeof(struct nvme_command), DMA_TO_DEVICE);
>=20
>=20
> For example, on ARM64, this would call `arch_sync_dma_for_cpu`, followed=
=20
> by `dcache_inval_poc(start, start + size)`.

Key here is the POC. It's a flush to the point of coherence of the local
system.  It has no idea about interhost coherency and is not necessarily
the DRAM (in CXL or otherwise).

If you are doing software coherence, those devices will plug into today's
hosts and they have no idea that such a flush means pushing out into
the CXL fabric and to the type 3 device.

>=20
> (2) Setting up data related to the NVMe request.
>=20
> (3) then Calls `ib_dma_sync_single_for_device` to flush the CPU cache to=
=20
> DMA memory:
>=20
> ib_dma_sync_single_for_device(dev, sqe->dma,
>                                  sizeof(struct nvme_command),=20
> DMA_TO_DEVICE);
>=20
> Of course, if the hardware ensures cache coherency, the above operations=
=20
> are skipped. However, if the hardware does not guarantee cache=20
> coherency, RDMA appears to ensure cache coherency through this method.
>=20
> In the RDMA scenario, we also face the issue of multi-host cache=20
> coherence. so I'm thinking, can we adopt a similar approach in CXL=20
> shared memory to achieve data sharing?

You don't face the same coherence issues, or at least not in the same way.
In that case the coherence guarantees are actually to the RDMA NIC.
It is guaranteed to see the clean data by the host - that may involve
flushes to PoC.  A one time snapshot is then sent to readers on other
hosts. If writes occur they are also guarantee to replace cached copies
on this host - because there is well define guarantee of IO coherence
or explicit cache maintenance to the PoC.

=20
>=20
> >>
> >> (3) If the hardware doesn't implement cache coherence and the cpu
> >> doesn't support the required CPU cache operations, then we can run in
> >> nocache mode. =20
> >=20
> > I suspect that gets you no where either.  Never believe an architecture
> > that provides a flag that says not to cache something.  That just means
> > you should not be able to tell that it is cached - many many implementa=
tions
> > actually cache such accesses. =20
>=20
> Sigh, then that really makes thing difficult.

Yes. I think we are going to have to wait on architecture specific clarific=
ations
before any software coherent use case can be guaranteed to work beyond the =
3.1 ones
for temporal sharing (only one accessing host at a time) and read only shar=
ing where
writes are dropped anyway so clean write back is irrelevant beyond some noi=
se in
logs possibly (if they do get logged it is considered so rare we don't care=
!).

> >  =20
> >>
> >> CBD can initially support (3), and then transition to (1) when hardware
> >> supports cache-coherency. If there's sufficient market demand, we can
> >> also consider supporting (2). =20
> > I'd assume only (3) works.  The others rely on assumptions I don't thin=
k =20
>=20
> I guess you mean (1), the hardware cache-coherency way, right?

Indeed - oops!
Hardware coherency is the way to go, or a well defined and clearly document
description of how to play with the various host architectures.

Jonathan


>=20
> :)
> Thanx
>=20
> > you can rely on.
> >=20
> > Fun fun fun,
> >=20
> > Jonathan
> >  =20
> >>
> >> How does this approach sound?
> >>
> >> Thanx =20
> >>>
> >>> J
> >>>     =20
> >>>>
> >>>> Keep in mind that I don't think anybody has cxl 3 devices or CPUs ye=
t, and
> >>>> shared memory is not explicitly legal in cxl 2, so there are things =
a cpu
> >>>> could do (or not do) in a cxl 2 environment that are not illegal bec=
ause
> >>>> they should not be observable in a no-shared-memory environment.
> >>>>
> >>>> CBD is interesting work, though for some of the reasons above I'm so=
mewhat
> >>>> skeptical of shared memory as an IPC mechanism.
> >>>>
> >>>> Regards,
> >>>> John
> >>>>
> >>>>
> >>>>    =20
> >>>
> >>> .
> >>>     =20
> >=20
> > .
> >  =20

