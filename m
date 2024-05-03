Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0162BB00
	for <nvdimm@lists.linux.dev>; Wed,  8 May 2024 09:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715159576; cv=none; b=CC90jSLE3u9kYvcajjPU8qrSSdpi4oDBEBhMIHJzoKPT0K71VvEe31toFBcrb5PZqvfIuL50zklBqG8/QA80Ue7OE76BIV5xnjWWWwYwcmsP7eFnSHW9jMzPvmcWqMIPcOZkQ7H7dnfw/BFXL5ZVkBMCYrNxN2H7NrHr4gmz8+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715159576; c=relaxed/simple;
	bh=6XVaT/rOwjD6l7J+zEX/991xLR3yWl6JEhyuKgB9bEE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rn1LU82gR4fozlFHz5/VKh5uWP+W4xvUArSkaYBQWJwwNpMsiZ/mlI7DxBmkgdAiqdxbC2qNiscuiQftVxwjoz3xFYvaHngGhkWwsVigKR8nepcUwkvh3yiuxBFevh8kaLztgdzzXBanek9H8ADqsxPApMcvHbprLPzivoIJrPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VZ8VL0CLvz6K63J;
	Wed,  8 May 2024 17:09:46 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 35040140B2A;
	Wed,  8 May 2024 17:12:51 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 8 May
 2024 10:12:50 +0100
Date: Fri, 3 May 2024 10:52:45 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: John Groves <John@groves.net>
CC: Dongsheng Yang <dongsheng.yang@easystack.cn>, Gregory Price
	<gregory.price@memverge.com>, Dan Williams <dan.j.williams@intel.com>,
	<axboe@kernel.dk>, <linux-block@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH RFC 0/7] block: Introduce CBD (CXL Block Device)
Message-ID: <20240503105245.00003676@Huawei.com>
In-Reply-To: <wold3g5ww63cwqo7rlwevqcpmlen3fl3lbtbq3qrmveoh2hale@e7carkmumnub>
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
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Sun, 28 Apr 2024 11:55:10 -0500
John Groves <John@groves.net> wrote:

> On 24/04/28 01:47PM, Dongsheng Yang wrote:
> >=20
> >=20
> > =E5=9C=A8 2024/4/27 =E6=98=9F=E6=9C=9F=E5=85=AD =E4=B8=8A=E5=8D=88 12:1=
4, Gregory Price =E5=86=99=E9=81=93: =20
> > > On Fri, Apr 26, 2024 at 10:53:43PM +0800, Dongsheng Yang wrote: =20
> > > >=20
> > > >=20
> > > > =E5=9C=A8 2024/4/26 =E6=98=9F=E6=9C=9F=E4=BA=94 =E4=B8=8B=E5=8D=88 =
9:48, Gregory Price =E5=86=99=E9=81=93: =20
> > > > >  =20
> > > >=20
> > > > In (5) of the cover letter, I mentioned that cbd addresses cache co=
herence
> > > > at the software level:
> > > >=20
> > > > (5) How do blkdev and backend interact through the channel?
> > > > 	a) For reader side, before reading the data, if the data in this c=
hannel
> > > > may be modified by the other party, then I need to flush the cache =
before
> > > > reading to ensure that I get the latest data. For example, the blkd=
ev needs
> > > > to flush the cache before obtaining compr_head because compr_head w=
ill be
> > > > updated by the backend handler.
> > > > 	b) For writter side, if the written information will be read by ot=
hers,
> > > > then after writing, I need to flush the cache to let the other part=
y see it
> > > > immediately. For example, after blkdev submits cbd_se, it needs to =
update
> > > > cmd_head to let the handler have a new cbd_se. Therefore, after upd=
ating
> > > > cmd_head, I need to flush the cache to let the backend see it.
> > > >  =20
> > >=20
> > > Flushing the cache is insufficient.  All that cache flushing guarante=
es
> > > is that the memory has left the writer's CPU cache.  There are potent=
ially
> > > many write buffers between the CPU and the actual backing media that =
the
> > > CPU has no visibility of and cannot pierce through to force a full
> > > guaranteed flush back to the media.
> > >=20
> > > for example:
> > >=20
> > > memcpy(some_cacheline, data, 64);
> > > mfence();
> > >=20
> > > Will not guarantee that after mfence() completes that the remote host
> > > will have visibility of the data.  mfence() does not guarantee a full
> > > flush back down to the device, it only guarantees it has been pushed =
out
> > > of the CPU's cache.
> > >=20
> > > similarly:
> > >=20
> > > memcpy(some_cacheline, data, 64);
> > > mfence();
> > > memcpy(some_other_cacheline, data, 64);
> > > mfence()
> > >=20
> > > Will not guarantee that some_cacheline reaches the backing media prior
> > > to some_other_cacheline, as there is no guarantee of write-ordering in
> > > CXL controllers (with the exception of writes to the same cacheline).
> > >=20
> > > So this statement:
> > >  =20
> > > > I need to flush the cache to let the other party see it immediately=
. =20
> > >=20
> > > Is misleading.  They will not see is "immediately", they will see it
> > > "eventually at some completely unknowable time in the future". =20
> >=20
> > This is indeed one of the issues I wanted to discuss at the RFC stage. =
Thank
> > you for pointing it out.
> >=20
> > In my opinion, using "nvdimm_flush" might be one way to address this is=
sue,
> > but it seems to flush the entire nd_region, which might be too heavy.
> > Moreover, it only applies to non-volatile memory.
> >=20
> > This should be a general problem for cxl shared memory. In theory, FAMFS
> > should also encounter this issue.
> >=20
> > Gregory, John, and Dan, Any suggestion about it?
> >=20
> > Thanx a lot =20
> > >=20
> > > ~Gregory
> > >  =20
>=20
> Hi Dongsheng,
>=20
> Gregory is right about the uncertainty around "clflush" operations, but
> let me drill in a bit further.
>=20
> Say you copy a payload into a "bucket" in a queue and then update an
> index in a metadata structure; I'm thinking of the standard producer/
> consumer queuing model here, with one index mutated by the producer and
> the other mutated by the consumer.=20
>=20
> (I have not reviewed your queueing code, but you *must* be using this
> model - things like linked-lists won't work in shared memory without=20
> shared locks/atomics.)
>=20
> Normal logic says that you should clflush the payload before updating
> the index, then update and clflush the index.
>=20
> But we still observe in non-cache-coherent shared memory that the payload=
=20
> may become valid *after* the clflush of the queue index.
>=20
> The famfs user space has a program called pcq.c, which implements a
> producer/consumer queue in a pair of famfs files. The only way to=20
> currently guarantee a valid read of a payload is to use sequence numbers=
=20
> and checksums on payloads.  We do observe mismatches with actual shared=20
> memory, and the recovery is to clflush and re-read the payload from the=20
> client side. (Aside: These file pairs theoretically might work for CBD=20
> queues.)
>=20
> Anoter side note: it would be super-helpful if the CPU gave us an explici=
t=20
> invalidate rather than just clflush, which will write-back before=20
> invalidating *if* the cache line is marked as dirty, even when software
> knows this should not happen.
>=20
> Note that CXL 3.1 provides a way to guarantee that stuff that should not
> be written back can't be written back: read-only mappings. This one of
> the features I got into the spec; using this requires CXL 3.1 DCD, and=20
> would require two DCD allocations (i.e. two tagged-capacity dax devices -=
=20
> one writable by the server and one by the client).
>=20
> Just to make things slightly gnarlier, the MESI cache coherency protocol
> allows a CPU to speculatively convert a line from exclusive to modified,
> meaning it's not clear as of now whether "occasional" clean write-backs
> can be avoided. Meaning those read-only mappings may be more important
> than one might think. (Clean write-backs basically make it
> impossible for software to manage cache coherency.)

My understanding is that clean write backs are an implementation specific
issue that came as a surprise to some CPU arch folk I spoke to, we will
need some path for a host to say if they can ever do that.

Given this definitely effects one CPU vendor, maybe solutions that
rely on this not happening are not suitable for upstream.

Maybe this market will be important enough for that CPU vendor to stop
doing it but if they do it will take a while...

Flushing in general is as CPU architecture problem where each of the
architectures needs to be clear what they do / specify that their
licensees do.

I'm with Dan on encouraging all memory vendors to do hardware coherence!

J

>=20
> Keep in mind that I don't think anybody has cxl 3 devices or CPUs yet, an=
d=20
> shared memory is not explicitly legal in cxl 2, so there are things a cpu=
=20
> could do (or not do) in a cxl 2 environment that are not illegal because=
=20
> they should not be observable in a no-shared-memory environment.
>=20
> CBD is interesting work, though for some of the reasons above I'm somewhat
> skeptical of shared memory as an IPC mechanism.
>=20
> Regards,
> John
>=20
>=20
>=20

