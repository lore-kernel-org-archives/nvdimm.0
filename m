Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0905F14D29B
	for <nvdimm@lists.linux.dev>; Thu, 13 Mar 2025 16:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741885094; cv=none; b=VEHXQKLvvRm3/wyCcnLOtFcti+xdBGaAfkCpeBpsoCXo/CJTvOaPU+wP8MJ/HySq8LHF3UPx7sMfv9IVR+jwW0/KIrW/u+oFD+ExJV+0UYTQrCOrmg1WY6OpEbs/m1Q8rOvzeEmcmmeQSdk0siM8zUNpjy400djyHv4cd1BfXpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741885094; c=relaxed/simple;
	bh=dOjWRShq6ygvAR2+lt108hDkTe/ci/6IY91umv/ucrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o4IClWQA2Q5s/HoLDivHh070g9thKvgEJ7dom9ysPW/5AVMbGHJ64tZLIwP4eI7MasCye3z1Uk9mVlOmq8ASgCESxY5QwiL/4wBg37x3sve18mH9Ck/mSUe9zV25CY/iJ+k7QQrEDHfcTyVp/FhgQs3S1yDSbw3GSfUEMlMRn5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VcTP9zkj; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VcTP9zkj"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-523de5611a3so474462e0c.1
        for <nvdimm@lists.linux.dev>; Thu, 13 Mar 2025 09:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741885092; x=1742489892; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ADIdlKa1fA4/imYaZXygiUs98rCXU1xydtVTW+Hgst4=;
        b=VcTP9zkjOf6jRCMpY346pKc///SXQ3IX78laabTlgEeJRj73B8yLJ5tb9VdVEDj1C/
         MP9CdLWTagTkye2EOf+ptozLT9OYtcJhrHjCeJMulbAauADGDfRI08vnXQVhiLVcPd8U
         5OKd3hr79SXqRlG22Z0SFA89Ptower9+nCMXaTC5Scad393ZB81JCZ2fVLqs0aJTkxiX
         gpleF/atujHA2zvxQuOHP5uL+4KtMJMcnGtFiUxryX/byzvDy2fI36NMbQ3+bv4EK3Cg
         SrqqrMlp/aFzKUZhfWPNCALD5gs2UVo3wVv3pNrA1eBZAj+nInZaZEAGpp7M70+/xo0n
         MyvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741885092; x=1742489892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ADIdlKa1fA4/imYaZXygiUs98rCXU1xydtVTW+Hgst4=;
        b=Y1lfhGpdsxg3GeMokZgycCiQrYSy5M+3SX+2XBvLurJ03Tz4K1n52+pABvzXPf5aEP
         HMkw3MCXCqhdCZ+HNj56qtS8Uw/lSUkHzearmNYLQNkhRnbmHKYETvkAumBmilqwEFZH
         wVyGpGhO4+kvqZj+F77HNQUGEh9EbANBFa2xQiNqfFYzIRZTROHrH2WE04SEiCYNIw4J
         qQR6BsWvhbRU/m+RV7M0hq/CF1kNJ0Hoj82r6Dw+OCWngVKC/XFPIWYohowiyMxXC262
         89pyX/Nonr4yqQiIE+vvBcHn864jCmOOyiyxGi5AXzZRJjX6H4xeiIQGbGsJsXXltc8d
         QU9g==
X-Forwarded-Encrypted: i=1; AJvYcCXhSIJIyCI81usTxQskFzh7tZtNX9L1ot4sn5sVAky4ziVmxAptwfR1fn8BvxD/iUUEtKsvW2w=@lists.linux.dev
X-Gm-Message-State: AOJu0YzoC8yLH6ANLjMfnWDduh9bqNdZ6cSbOTnN0cPE2/qLte9SGFHJ
	N9kCAlem4e0Eyv+kIklhm+0AiXm2/iIF2NV1+6dxyBkyl6V1JTKpFqJsLrgCz69cZdZ+dU480pI
	IwREC+gUCW0ABPICY3ZPOyH2zmiU=
X-Gm-Gg: ASbGncsrAUkhApAHW3GVSma9o4BArVXVvUhpX8zjLhKxQf59FcXikAYWZ92OUjDYRQA
	GAqWOPKqVJMXQxPSksVAixP3vl0W+XaRJng7b/mCgO0uosWulpacdyD+S8oGF68vkxhANooOO3Z
	Ltfj9sku4oHlGOlHdD4GfMHGERtQ==
X-Google-Smtp-Source: AGHT+IGqd4mPuYQMTlhSCpe62t8tLvAKCPyLobikqm+RE8kQK34379HRDecEtPPNH8Li/NEYmxYtyykiKOTPdHHJXWU=
X-Received: by 2002:a05:6122:2001:b0:51f:3eee:89f4 with SMTP id
 71dfb90a1353d-524462587bbmr1339574e0c.9.1741885091858; Thu, 13 Mar 2025
 09:58:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
 <Z9HOavSkFf01K9xh@google.com> <5gqqbq67th4xiufiw6j3ewih6htdepa4u5lfirdeffrui7hcdn@ly3re3vgez2g>
 <CAGsJ_4xwnVxn1odj=j+z0VXm1DRUmnhugnwCH-coqBLJweDu9Q@mail.gmail.com> <Z9MCwXzYDRJoTiIr@google.com>
In-Reply-To: <Z9MCwXzYDRJoTiIr@google.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 14 Mar 2025 05:58:00 +1300
X-Gm-Features: AQ5f1JoQPpin_yzy1xmzTa5CZUM1Y8yc8ZWtftl1w5WEvizQdxmWfzWVnzMz6I0
Message-ID: <CAGsJ_4yaSx1vEiZdCouBveeH3D-bQDdvrhRpz=Kbvqn30Eh-nA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Improve Zram by separating compression context from kswapd
To: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Qun-Wei Lin <qun-wei.lin@mediatek.com>, 
	Jens Axboe <axboe@kernel.dk>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Chris Li <chrisl@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, "Huang, Ying" <ying.huang@intel.com>, 
	Kairui Song <kasong@tencent.com>, Dan Schatzberg <schatzberg.dan@gmail.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	Casper Li <casper.li@mediatek.com>, Chinwen Chang <chinwen.chang@mediatek.com>, 
	Andrew Yang <andrew.yang@mediatek.com>, James Hsu <james.hsu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 14, 2025 at 5:07=E2=80=AFAM Minchan Kim <minchan@kernel.org> wr=
ote:
>
> On Thu, Mar 13, 2025 at 04:45:54PM +1300, Barry Song wrote:
> > On Thu, Mar 13, 2025 at 4:09=E2=80=AFPM Sergey Senozhatsky
> > <senozhatsky@chromium.org> wrote:
> > >
> > > On (25/03/12 11:11), Minchan Kim wrote:
> > > > On Fri, Mar 07, 2025 at 08:01:02PM +0800, Qun-Wei Lin wrote:
> > > > > This patch series introduces a new mechanism called kcompressd to
> > > > > improve the efficiency of memory reclaiming in the operating syst=
em. The
> > > > > main goal is to separate the tasks of page scanning and page comp=
ression
> > > > > into distinct processes or threads, thereby reducing the load on =
the
> > > > > kswapd thread and enhancing overall system performance under high=
 memory
> > > > > pressure conditions.
> > > > >
> > > > > Problem:
> > > > >  In the current system, the kswapd thread is responsible for both
> > > > >  scanning the LRU pages and compressing pages into the ZRAM. This
> > > > >  combined responsibility can lead to significant performance bott=
lenecks,
> > > > >  especially under high memory pressure. The kswapd thread becomes=
 a
> > > > >  single point of contention, causing delays in memory reclaiming =
and
> > > > >  overall system performance degradation.
> > > >
> > > > Isn't it general problem if backend for swap is slow(but synchronou=
s)?
> > > > I think zram need to support asynchrnous IO(can do introduce multip=
le
> > > > threads to compress batched pages) and doesn't declare it's
> > > > synchrnous device for the case.
> > >
> > > The current conclusion is that kcompressd will sit above zram,
> > > because zram is not the only compressing swap backend we have.
>
> Then, how handles the file IO case?

I didn't quite catch your question :-)

>
> >
> > also. it is not good to hack zram to be aware of if it is kswapd
> > , direct reclaim , proactive reclaim and block device with
> > mounted filesystem.
>
> Why shouldn't zram be aware of that instead of just introducing
> queues in the zram with multiple compression threads?
>

My view is the opposite of yours :-)

Integrating kswapd, direct reclaim, etc., into the zram driver
would violate layering principles. zram is purely a block device
driver, and how it is used should be handled separately. Callers have
greater flexibility to determine its usage, similar to how different
I/O models exist in user space.

Currently, Qun-Wei's patch checks whether the current thread is kswapd.
If it is, compression is performed asynchronously by threads;
otherwise, it is done in the current thread. In the future, we may
have additional reclaim threads, such as for damon or
madv_pageout, etc.

> >
> > so i am thinking sth as below
> >
> > page_io.c
> >
> > if (sync_device or zswap_enabled())
> >    schedule swap_writepage to a separate per-node thread
>
> I am not sure that's a good idea to mix a feature to solve different
> layers. That wouldn't be only swap problem. Such an parallelism under
> device  is common technique these days and it would help file IO cases.
>

zswap and zram share the same needs, and handling this in page_io
can benefit both through common code. It is up to the callers to decide
the I/O model.

I agree that "parallelism under the device" is a common technique,
but our case is different=E2=80=94the device achieves parallelism with
offload hardware, whereas we rely on CPUs, which can be scarce.
These threads may also preempt CPUs that are critically needed
by other non-compression tasks, and burst power consumption
can sometimes be difficult to control.

> Furthermore, it would open the chance for zram to try compress
> multiple pages at once.

We are already in this situation when multiple callers use zram simultaneou=
sly,
such as during direct reclaim or with a mounted filesystem.

Of course, this allows multiple pages to be compressed simultaneously,
even if the user is single-threaded. However, determining when to enable
these threads and whether they will be effective is challenging, as it
depends on system load. For example, Qun-Wei's patch chose not to use
threads for direct reclaim as, I guess,  it might be harmful.

Thanks
Barry
