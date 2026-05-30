Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A3F189F43
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 14:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780151582; cv=none; b=Y6eiIBuZwwXGDyML+FmLZUS5q3a6++5pPXWlKhhn9heiMNaD0ZfNzkCOdRLQbKMaGKMp+V+SyZlid4j6Yo78FKQv/At6Y+rk9H2cgRnfugesfcQW1AwYghYM5ODWjqV2AJUaiIYy4mqSF3D/jnEeQ/J6EwoN+Ny9e9B3K7Iiqb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780151582; c=relaxed/simple;
	bh=E/XDp+eWdqQAu3IyCSIN3kRr4XZzuU40athJzxE9XlI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=FKo4idN5QdVzMEE9M3Eppb/HfgnDFbSuEQ6WvLdbp3N0o9QmhBPyx/rKVc+mmPUQ3CcI28tRwVFefo0O7StC8oSLWQ2HIDT8raboudyGbiXkLH4oCh1CVK+asGNtHcVMydetp3kQnCEulWv/e4faV+YZLkSjz22yAkX+KFerIRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 503941403AD;
	Sat, 30 May 2026 14:32:53 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf14.hostedemail.com (Postfix) with ESMTPA id 0D7C23C;
	Sat, 30 May 2026 14:32:50 +0000 (UTC)
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 891ACF40070;
	Sat, 30 May 2026 10:32:49 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-09.internal (MEProxy); Sat, 30 May 2026 10:32:49 -0400
X-ME-Sender: <xms:EfUaagjFfBHuv006BYFOpx0rMSWcKiovZ6gOXDVZZMc-cuuMv-Tgkw>
    <xme:EfUaaj3oE_qt3JIzNqXUvOjCjhENSwOL46Jsr04JE8RIiCKvAuYH3bvy6RuAVJM97
    vYMvsIeJqFrix_H2LjUgy9tnmMc2HPXLBNRJsC-LmZtxz5N4nv6i0U>
X-ME-Proxy-Cause: dmFkZTEHK+ZwXaFFoz3BsXuk5775ZxCf2ZEleDq20BxjZXQO1/oPR21Vmndo0Ymkwckhc6
    UXrGSNJYkcz6rg45PtyRVnNYJTW6UgTyVrIOJpXLmxGmhBL8bht+rGDIV+AxAuF1MGYMAh
    mbFQ6N6zQ/pmxt0tqePv1jYualjM0bdaQjEYovvSrl3E4tEQGZSiiTzVbFRYyqf/0GDzT0
    XF4C5a/pKSRMO2PkKTgDnzwwP8+bLLgzN7Dx9hq1KXnaf/4cT5UrhnfU31vAeU2Z/7/rFd
    xA1c2OhFB6DHTJGnTAneoTSQx/EIrSOTDpGg1fTDckrbT6N5u9FG2kI8M3e2X2aQisDkBt
    0r6dgc3OtcWyblYmgRy/kBqE2QWTsvw/DzNcbyQt8TdF+UKkSD6p5CJapi1cFKZ3REqNPV
    0epGHvM++zKJcdYbUr5IdjyVZVBlCiVkXPLBmiK9I/X0z57orVN1LBh8Ngqyp/bAHb+Wp3
    cLTNKSUND4jXTLtCKAnBe+e9lQMG8R2eYRlltqSVR4/wO6P1KZrQ3Zpfxw54lMS9ZrDwUo
    t8MS38lHjZhJYVcTUb96KtSrfdwrkCm0uH0HmC1ezPb8cZt28hHhKqvIdHw14vwbEXJLYu
    tuYzNZkQWuPadMB3vsIRThEadXYs2kvP8AzZ4G2E+yy/SumK4BCrSov/dXAQ
X-ME-Proxy: <xmx:EfUaajF8V3CVaOIk5quETcmEdpDOo15g3rO565BXGHUIHlii3gkFgA>
    <xmx:EfUaapGCKAe6Xp5qKUCZ07R98XgOf2K924WlTEXgA9HvFJOfEp30RA>
    <xmx:EfUaaj392NcDr_UPTcW0z3hZCOQkU7k7Jj2B5yHcQNU8S53OEopweQ>
    <xmx:EfUaajc4P5cum6E8gLEbWPethtIiYGYZ7XCDJWrDEWhv1IP9YBbTuA>
    <xmx:EfUaatIY11IHi5tDpzk0lxUdkoEKO81TiMD5-vP0Uez9ydDNbQvPf3rl>
Feedback-ID: i3a164872:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 549AE700065; Sat, 30 May 2026 10:32:49 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Sat, 30 May 2026 09:32:28 -0500
From: "John Groves" <John@groves.net>
To: "Dave Jiang" <dave.jiang@intel.com>
Cc: "John Groves" <john@jagalactic.com>, "Dan Williams" <djbw@kernel.org>,
 "John Groves (jgroves)" <jgroves@micron.com>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>,
 "Miklos Szeredi" <miklos@szeredi.hu>,
 "Alison Schofield" <alison.schofield@intel.com>,
 "Ira Weiny" <iweiny@kernel.org>, "Jonathan Cameron" <jic23@kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Message-Id: <52611d85-7145-454a-97f7-c2a5986f109f@app.fastmail.com>
In-Reply-To: <ahrrs8hg9mTpgePM@groves.net>
References: 
 <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
 <20260522191917.79204-1-john@jagalactic.com>
 <0100019e5120c6c2-6fee7a58-7fb8-4c80-a229-4b5573e0e2c0-000000@email.amazonses.com>
 <e7655b88-c56d-4d9a-8ae1-68eb9448bb87@intel.com>
 <ahrrs8hg9mTpgePM@groves.net>
Subject: Re: [PATCH V2 5/7] dax: fix holder_ops race in fs_put_dax()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 0D7C23C
X-Stat-Signature: 7bc1omp538qy6jaqkhb9bz6k5rc3ihp4
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1/pRYS5UclZxvRZCUrS2rKPhsi0wMeQm9E=
X-HE-Tag: 1780151570-905402
X-HE-Meta: U2FsdGVkX18tgnruOM7ocHJv5fGj09qbCePbS5dzLmSm5AUJ9V6BY8gvCQId2dkYuacOa6nb7qps3PTWZ9ElcO9LKyYLuBSyF9vSy61cNlZJuBOaJchUpajtxeshjN9WMeF++NBSuqbp+shYDdeJnw8UtPOhZ7ye9Batt7Shc6g55hlPqH0LrocFupL0gNp2t1oocIreZiwgxIr8GMi5q8yv/EUFEtjvxtik8EpltrXzGt6SyZ6FsZzRrPE67WCoC5gkjjsxS85k/s2OjBLb8LCNISnWZj8UznhUSGJtipw2QdhgrDyqCCyeGVsVy2zgRy9CaR8Zn1/d+vzbW6BHYDYgcoY/5Jpxzz0x/yeJyDsdaxmmJqYKDRIc4biFnm+uXZGouzMZa5EB8MTk3PFuNlPE5AIuB7B7brVWzluI1cw=



On Sat, May 30, 2026, at 9:02 AM, John Groves wrote:
> On 26/05/26 05:16PM, Dave Jiang wrote:
> >=20
> >=20
> > On 5/22/26 12:19 PM, John Groves wrote:
> > > From: John Groves <John@Groves.net>
> > >=20
> > > Clear holder_ops before holder_data so that a concurrent fs_dax_ge=
t()
> > > cannot have its newly installed holder_ops overwritten. Also add a
> > > kerneldoc comment documenting that fs_put_dax() must only be called
> > > by the current holder.
> > >=20
> > > Fixes: eec38f5d86d27 ("dax: add fs_dax_get() for devdax")
> > > Signed-off-by: John Groves <john@groves.net>
> >=20
> > Couple things from Claude that may be worth taking a look at:
> >=20
> >   1. Memory ordering is now load-bearing and missing
> >=20
> >   The whole correctness argument depends on the reader observing hol=
der_ops =3D
> >   NULL before observing holder_data =3D NULL. The patch uses a plain=
 store
> >   followed by cmpxchg. On x86 plain stores are ordered, but on arm64=
/ppc they
> >   are not =E2=80=94 the reader can observe cmpxchg's release of hold=
er_data while still
> >   seeing the old holder_ops. That puts us back in the dangerous (hol=
der_data =3D=3D
> >   NULL, holder_ops =3D=3D old) state on weakly-ordered arches.
> >=20
> >   Required:
> >=20
> >   smp_store_release(&dax_dev->holder_ops, NULL);   /* publish ops=3D=
NULL first */
> >   cmpxchg(&dax_dev->holder_data, holder, NULL);    /* then release h=
older_data
> >   */
>=20
> Updating to WRITE_ONCE(), which I think is the right choice
>=20
> >=20
> >   And the reader in dax_holder_notify_failure should use
> >   smp_load_acquire/READ_ONCE because today it reads dax_dev->holder_=
ops twice
> >   (line 334 and line 339), allowing tearing or stale-cache reads. Pr=
e-existing
> >   weakness, but this patch is what makes the ordering matter.
> >=20
> >   kill_dax (line 461-462) has the same naked-store pattern =E2=80=94=
 it should be made
> >   consistent.
>=20
> Will study this and post a separate patch for kill_dax if I think it's
> warranted
>=20

Fixing kill_dax() isn't necessary because it does a synchronize_srcu() a=
fter
clear_bit(DAXDEV_ALIVE). So it can't race with fs_dax_get()...

Thanks,
John
