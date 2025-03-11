Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C081121E0B7
	for <nvdimm@lists.linux.dev>; Tue, 11 Mar 2025 07:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741677923; cv=none; b=AxIXRM/QvC/MnObhtMYRBUjmIEvd8gTM93UosBxqACZTBq7botJ0FyAeF/GHTFHnm+qRNT5CVtsH5IHOGx4nT1SWF2uNucv8gqluwMFdQgLCZWev8dOT8MfdzhyY6KWuPzDjyH61XDl1e0ve9s4am29Xz7ipvSlukcreNzMaeeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741677923; c=relaxed/simple;
	bh=eZEIIBt1kffWaB7xQ1NYDHiMf8e1m7zNRLt0RhBlNzM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p81+uKpS5ogXzlUSsghQSHxXmt+fMHDiDNC4s5QJMJ5tqWX65bIBohCYkHJ0RNm2AIcGm0R63jqR0WavPIw9M+RtoUArbUUyuEpGueb8q1PQ7zxbikvPeyPe/r7QjmsDT6z2+l8LBhGVyvN77F2tR5RTRaN/XUq8hiIc6oS+MYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R7LqgLUy; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R7LqgLUy"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-523edc385caso1509199e0c.3
        for <nvdimm@lists.linux.dev>; Tue, 11 Mar 2025 00:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741677920; x=1742282720; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14J+e5VuAf8KWTYGvfdl7Up5l3cKOJfv7HHosoMS/QI=;
        b=R7LqgLUyTKnqzvM4m+3l4h/0ZUySHy6e2hdyxUFCEmL1drzVZc/seyRwYsoLXoz6SR
         APWfd5GvbftxaCl3qNy5t+42pBPuu0S5C4tHYQjRBT/XxbPL86aErXWLlYLsUPu8kftf
         Q+PT2jvk4Z199xV4UoDROnL9cKYNE6vGFg+tOPgBQNvcchJNvbl1J4pYr0ET4xNVrSB9
         S8Qod+cLr2gCzYbvPyw6JaPIE9iBDehePNT+1A0nPvtgXcPX7Y2ww+5y/lAzA6jLJWhu
         mJMT38aElQ/RSxN1OOZmZl3yP0W3AoEBHOh49DJfw/nXSIDIt5B+aPvZy9DH5kqMZatp
         pXFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741677920; x=1742282720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=14J+e5VuAf8KWTYGvfdl7Up5l3cKOJfv7HHosoMS/QI=;
        b=VAcpEqoymsTL6j3yPp/CphsvRFJ9Pq5u0ZdLcTzmZ5Q6CxLZGUg+WfMZ5dKCowujtO
         dczsnHCYBQkN6AJwFjxXqOZjwrDUb2TVuavJNB7kyE2mbwiq6kewjAeTN0zaPtFPpTA9
         yrCEbjcYOFgQqnMgYZcT3ImVEkqAXNoiUiz46yosTKD1RP9r1yxF58G+WJx+5gh2WohF
         m9L7E+/TnRSh3LfefyFhk2UaoKd3VHq9d/b9JAthmAQ/5xvbvVWWfszqDZ6ZrlDSgy4b
         b29Ar3tPycUwbhmEcE12pRTdCoDHdl214aZ1RBcltaefbv55XfWgk2jXII99BF9PQ+zt
         /nBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTOOAd4JTm5mokeILSW69OIgMLbGRK2w+efK0XuEUQ4P31leCSdrnumwj1PfKygQvk5PuHb3w=@lists.linux.dev
X-Gm-Message-State: AOJu0YzApzRSMJL9b6SUZKav4D7p3gzfcV81MrOukZ6SgH5fpxrb7nBg
	44QT29zZc3jGB0zveMiiqcYlwHmvBAWMQlmlyWqHD2xNlJ+MEjasimG9lNBxtVted0T0dyzjSzD
	hsMJzD8aIUXo4Vv9FyJ2IkSrwALc=
X-Gm-Gg: ASbGnctbp6OH2zPvhVEDUufzlhzBKux4/7v80m7dmRCuaTI3EjzhyShNfNCDRLzcvHz
	pAnwG5Qnbo0+6CjixeMPK6FVNbS6ZripkpTJg03swUMqfRdfJcWkIOlrdZgNw7Or/28STl1DjIu
	U79hTif8w1eIfIZHxfF1afDei8exi5pVIrSPgs
X-Google-Smtp-Source: AGHT+IFsyBlzqjw152fKM+F/V/k1af7P7Im6Vh9k8Vu1jHuGXnkPe4wU95quHjQWRTZpr4F4NdrxAPjlRVLxhAwp+VQ=
X-Received: by 2002:a05:6122:2189:b0:520:5a87:6708 with SMTP id
 71dfb90a1353d-523e3d9bfbfmr8599088e0c.0.1741677920409; Tue, 11 Mar 2025
 00:25:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
 <20250307120141.1566673-3-qun-wei.lin@mediatek.com> <CAGsJ_4xtp9iGPQinu5DOi3R2B47X9o=wS94GdhdY-0JUATf5hw@mail.gmail.com>
 <7938f840136165be1c50050feb39fb14ee37721b.camel@mediatek.com> <CAGsJ_4zzZdjbr2DbRybHYDmL2EuUBohOP1=ho7fjx1XWoKDDGw@mail.gmail.com>
In-Reply-To: <CAGsJ_4zzZdjbr2DbRybHYDmL2EuUBohOP1=ho7fjx1XWoKDDGw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 11 Mar 2025 20:25:09 +1300
X-Gm-Features: AQ5f1JpKxaLImM0wsAF8CYe72YVs87H6q9d9biQ7imNBdrvywmaFTR6ikJ3uks4
Message-ID: <CAGsJ_4yuyJc_-Ods-um_jtAgFFJ_qJi1=b8Kf-_ngU0UHjMQYA@mail.gmail.com>
Subject: Re: [PATCH 2/2] kcompressd: Add Kcompressd for accelerated zram compression
To: =?UTF-8?B?UXVuLXdlaSBMaW4gKOael+e+pOW0tCk=?= <Qun-wei.Lin@mediatek.com>
Cc: =?UTF-8?B?QW5kcmV3IFlhbmcgKOaliuaZuuW8tyk=?= <Andrew.Yang@mediatek.com>, 
	=?UTF-8?B?Q2FzcGVyIExpICjmnY7kuK3mpq4p?= <casper.li@mediatek.com>, 
	"chrisl@kernel.org" <chrisl@kernel.org>, =?UTF-8?B?SmFtZXMgSHN1ICjlvpDmhbbolrAp?= <James.Hsu@mediatek.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, 
	"ira.weiny@intel.com" <ira.weiny@intel.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"dave.jiang@intel.com" <dave.jiang@intel.com>, 
	"schatzberg.dan@gmail.com" <schatzberg.dan@gmail.com>, 
	=?UTF-8?B?Q2hpbndlbiBDaGFuZyAo5by16Yym5paHKQ==?= <chinwen.chang@mediatek.com>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"minchan@kernel.org" <minchan@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, 
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"ying.huang@intel.com" <ying.huang@intel.com>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2025 at 8:05=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Tue, Mar 11, 2025 at 2:26=E2=80=AFAM Qun-wei Lin (=E6=9E=97=E7=BE=A4=
=E5=B4=B4)
> <Qun-wei.Lin@mediatek.com> wrote:
> >
> > On Sat, 2025-03-08 at 08:41 +1300, Barry Song wrote:
> > >
> > > External email : Please do not click links or open attachments until
> > > you have verified the sender or the content.
> > >
> > >
> > > On Sat, Mar 8, 2025 at 1:02=E2=80=AFAM Qun-Wei Lin <qun-wei.lin@media=
tek.com>
> > > wrote:
> > > >
> > > > Introduced Kcompressd to offload zram page compression, improving
> > > > system efficiency by handling compression separately from memory
> > > > reclaiming. Added necessary configurations and dependencies.
> > > >
> > > > Signed-off-by: Qun-Wei Lin <qun-wei.lin@mediatek.com>
> > > > ---
> > > >  drivers/block/zram/Kconfig      |  11 ++
> > > >  drivers/block/zram/Makefile     |   3 +-
> > > >  drivers/block/zram/kcompressd.c | 340
> > > > ++++++++++++++++++++++++++++++++
> > > >  drivers/block/zram/kcompressd.h |  25 +++
> > > >  drivers/block/zram/zram_drv.c   |  22 ++-
> > > >  5 files changed, 397 insertions(+), 4 deletions(-)
> > > >  create mode 100644 drivers/block/zram/kcompressd.c
> > > >  create mode 100644 drivers/block/zram/kcompressd.h
> > > >
> > > > diff --git a/drivers/block/zram/Kconfig
> > > > b/drivers/block/zram/Kconfig
> > > > index 402b7b175863..f0a1b574f770 100644
> > > > --- a/drivers/block/zram/Kconfig
> > > > +++ b/drivers/block/zram/Kconfig
> > > > @@ -145,3 +145,14 @@ config ZRAM_MULTI_COMP
> > > >           re-compress pages using a potentially slower but more
> > > > effective
> > > >           compression algorithm. Note, that IDLE page recompression
> > > >           requires ZRAM_TRACK_ENTRY_ACTIME.
> > > > +
> > > > +config KCOMPRESSD
> > > > +       tristate "Kcompressd: Accelerated zram compression"
> > > > +       depends on ZRAM
> > > > +       help
> > > > +         Kcompressd creates multiple daemons to accelerate the
> > > > compression of pages
> > > > +         in zram, offloading this time-consuming task from the
> > > > zram driver.
> > > > +
> > > > +         This approach improves system efficiency by handling page
> > > > compression separately,
> > > > +         which was originally done by kswapd or direct reclaim.
> > >
> > > For direct reclaim, we were previously able to compress using
> > > multiple CPUs
> > > with multi-threading.
> > > After your patch, it seems that only a single thread/CPU is used for
> > > compression
> > > so it won't necessarily improve direct reclaim performance?
> > >
> >
> > Our patch only splits the context of kswapd. When direct reclaim is
> > occurred, it is bypassed, so direct reclaim remains unchanged, with
> > each thread that needs memory directly reclaiming it.
>
> Qun-wei, I=E2=80=99m getting a bit confused. Looking at the code in page_=
io.c,
> you always call swap_writepage_bdev_async() no matter if it is kswapd
> or direct reclaim:
>
> - else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> + else if (data_race(sis->flags & SWP_WRITE_SYNCHRONOUS_IO))
>            swap_writepage_bdev_sync(folio, wbc, sis);
>   else
>             swap_writepage_bdev_async(folio, wbc, sis);
>
> In zram, I notice you are bypassing kcompressd by:
>
> + if (!nr_kcompressd || !current_is_kswapd())
> +        return -EBUSY;
>
> How will this work if no one is calling __end_swap_bio_write(&bio),
> which is present in swap_writepage_bdev_sync()?
> Am I missing something? Or is it done by zram_bio_write() ?
>
> On the other hand, zram is a generic block device, and coupling its
> code with kswapd/direct reclaim somehow violates layering
> principles :-)
>
> >
> > > Even for kswapd, we used to have multiple threads like [kswapd0],
> > > [kswapd1],
> > > and [kswapd2] for different nodes. Now, are we also limited to just
> > > one thread?
> >
> > We only considered a single kswapd here and didn't account for multiple
> > instances. Since I use kfifo to collect the bios, if there are multiple
> > kswapds, we need to add a lock to protect the bio queue. I can revise
> > this in the 2nd version, or do you have any other suggested approaches?
>
> I'm wondering if we can move the code to vmscan/page_io instead
> of zram. If we're using a sync I/O swap device or have enabled zswap,
> we could run reclamation in this separate thread, which should also be

Sorry for the typo:
s/reclamation/__swap_writepage/g

> NUMA-aware.
>
> I would definitely be interested in prototyping it when I have the time.
>

Thanks
Barry
