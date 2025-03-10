Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6EC23026D
	for <nvdimm@lists.linux.dev>; Mon, 10 Mar 2025 16:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741625898; cv=none; b=nw0wT7ASqVN8uXKBQa86zAQ7+TyAHlsowE6wSISL3FbjgWrga8ZtOpoC9AKWMkxcGDBEUpS9liEeHsbJhS21x7pDrzKsGcVKVDZDFL7Lopt8YjggSiKUJGr7B0Kbd0/RaK9Mu6KpMGrHbLH/FNup84UD7QuWezmuY0sN2JxJITE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741625898; c=relaxed/simple;
	bh=zU9J6Uelg3E0m0JOwnGynjWuNU4lkeTgew4U9lN434I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JqjM+b5LQfn4wjGfJ+tmMoMxh76Tq4NcNC1VRZ+myHKkwKBueVNbFyiV+dIPPmN77id19huWy4uOfLKvqpG1X71Kku9EK6frNqR3ftolUvYwlFFxyxskMyWsXVRyLPA2EwaU7QWFU8Tj3AInwmx836wtc/lb+g4o4LkatYQNJP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TxTb+5tD; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TxTb+5tD"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6e90b1b20c6so10746346d6.3
        for <nvdimm@lists.linux.dev>; Mon, 10 Mar 2025 09:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741625895; x=1742230695; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ZRKJKZ9nlIeWSuKxcLT+2RQaSrxw/L262gLI4l/W7Y=;
        b=TxTb+5tDYaTfrz7jvC06f0LNMizXtqW44LFQv3YhSaqScAfdR6TcpoHT2pH8jIAZUy
         JYSpSu9JR+XJ5iHfJ2d7//7DlNeTonIoxNwL5hYUo054y4lGVLbGG5g2550aXu8D6A+t
         qAUKnrQviSB9WA9379IPATDh6SwEdMan61Nwg2+TsN0B//fu54TWWmzL6qXqAbQVUUaH
         tWRUwWZss/D9mj2un1U8f7+YFuwWvXv90rhCPtI698EdeYuwu97tuZ8w4+ZgohlTm5LS
         A9hwyO52KScXU1Qwre9GM51B+Znh7Hpq6ll2dc8MvVtY8YGeYlXRgs61p9WJcAIHe6Fs
         1xWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741625895; x=1742230695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ZRKJKZ9nlIeWSuKxcLT+2RQaSrxw/L262gLI4l/W7Y=;
        b=cBX6hxJ9YuqsHvdGzLtDtlHnBzrRA6AkuwqrbJjPZ7o5iBEixCUxd7HppkrW1uxe1o
         g8y0VDD6utKInWtnXYE1HMSdaQGITxaqAhgBwalv32jXsNNGK2Uxf6/svSwEds8uORI4
         x7SXkrpmbUtZeNBPli/Mg3UZQbiRwzs9cbfqXP3Q4u0OCK5dBX56/iokxKZhY+mCGeLe
         UyOPz6KScW/S2kf6xIlER2sIa57iRCdgbKb/PRY+bblXUo5iMb2SSTfnHfbMoxhrHgM6
         7LeL5unB3VYVKMmWStxnx5y6snPG6QJy6f5FU2IhCcouJTEtpTevoRzbmECqXFngqzoO
         /YJA==
X-Forwarded-Encrypted: i=1; AJvYcCWm/odYzJk3RGHaOA9Zu/qUqlFLIEBCVFafFSnXQQf2J1MrFwVq0mcyw5musnMRo4OMzhcP160=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJm7E8ZFTNHJfHMG87VR3XLVMTyFptveen/mBIsjZVwAVISa3r
	K4v0saxjqnC794QDCgi6woYoqeR68F/t/Bngnqkld4OdSUPgrgpvbt1TLTdZdKwJDIfPf519xkp
	5dPvF30r4+8KO8vihZLbyWJvZT+U=
X-Gm-Gg: ASbGncvviH6RZlAW4zXwAwTFwSsF2ozt6wgC4KYB4W8BbAF50PpJw6Hwc0T2thDwK/5
	InwvTtCuXTo/svH9gz29qUINry2FLCskffULXrSj7fF/3Fb1onC/+q7so5nTCBCKoorU0ax55Bd
	KW63PU128K8OaZUwdXT4GwgOxP1pTqTL0Ly5mY5DFMtpEGPCs1kNe7D+Qehk/DC+0suWBp
X-Google-Smtp-Source: AGHT+IGLgqTmt1SDyAD0npx1AoBzMAH3/wL78InRxx9wcGrHh376yvWmApG86TD6jVVvmno+Mrl+M1sPXtYY48F+++4=
X-Received: by 2002:a05:6214:268b:b0:6e8:9e9c:d212 with SMTP id
 6a1803df08f44-6e9004f8506mr237299696d6.0.1741625894265; Mon, 10 Mar 2025
 09:58:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
 <CAKEwX=NfKrisQL-DBcNxBwK2ErK-u=MSzHNpETcuWWNBh9s9Bg@mail.gmail.com>
 <CAGsJ_4ysL1xV=902oNM3vBfianF6F_iqDgyck6DGzFrZCtOprw@mail.gmail.com> <52896654fa07a685707b11cfcc141b038a13b649.camel@mediatek.com>
In-Reply-To: <52896654fa07a685707b11cfcc141b038a13b649.camel@mediatek.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 10 Mar 2025 09:58:03 -0700
X-Gm-Features: AQ5f1JoVlbRC8ML7j1bVCk8yzJp1pkIWgzfAiwocC8Jva43BmjLh8eyu6rj7o_I
Message-ID: <CAKEwX=PNHik8O6swwRPsuDovtCNLxXRQUsiXZSSq8ZbzFvJV0w@mail.gmail.com>
Subject: Re: [PATCH 0/2] Improve Zram by separating compression context from kswapd
To: =?UTF-8?B?UXVuLXdlaSBMaW4gKOael+e+pOW0tCk=?= <Qun-wei.Lin@mediatek.com>
Cc: "21cnbao@gmail.com" <21cnbao@gmail.com>, =?UTF-8?B?QW5kcmV3IFlhbmcgKOaliuaZuuW8tyk=?= <Andrew.Yang@mediatek.com>, 
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
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 10, 2025 at 6:22=E2=80=AFAM Qun-wei Lin (=E6=9E=97=E7=BE=A4=E5=
=B4=B4)
<Qun-wei.Lin@mediatek.com> wrote:
>
>
> Thank you for your explanation. Compared to the original single kswapd,
> we expect t1 to have a slight increase in re-scan time. However, since
> our kcompressd can focus on compression tasks and we can have multiple
> kcompressd instances (kcompressd0, kcompressd1, ...) running in
> parallel, we anticipate that the number of times a folio needs be re-
> scanned will not be too many.
>
> In our experiments, we fixed the CPU and DRAM at a certain frequency.
> We created a high memory pressure enviroment using a memory eater and
> recorded the increase in pgsteal_anon per second, which was around 300,
> 000. Then we applied our patch and measured again, that pgsteal_anon/s
> increased to over 800,000.
>
> > >
> > > >
> > > > Problem:
> > > >  In the current system, the kswapd thread is responsible for both
> > > >  scanning the LRU pages and compressing pages into the ZRAM. This
> > > >  combined responsibility can lead to significant performance
> > > > bottlenecks,
> > >
> > > What bottleneck are we talking about? Is one stage slower than the
> > > other?
> > >
> > > >  especially under high memory pressure. The kswapd thread becomes
> > > > a
> > > >  single point of contention, causing delays in memory reclaiming
> > > > and
> > > >  overall system performance degradation.
> > > >
> > > > Target:
> > > >  The target of this invention is to improve the efficiency of
> > > > memory
> > > >  reclaiming. By separating the tasks of page scanning and page
> > > >  compression into distinct processes or threads, the system can
> > > > handle
> > > >  memory pressure more effectively.
> > >
> > > I'm not a zram maintainer, so I'm definitely not trying to stop
> > > this
> > > patch. But whatever problem zram is facing will likely occur with
> > > zswap too, so I'd like to learn more :)
> >
> > Right, this is likely something that could be addressed more
> > generally
> > for zswap and zram.
> >
>
> Yes, we also hope to extend this to other swap devices, but currently,
> we have only modified zram. We are not very familiar with zswap and
> would like to ask if anyone has any suggestions for modifications?
>

My understanding is right now schedule_bio_write is the work
submission API right? We can make it generic, having it accept a
callback and a generic untyped pointer which can be casted into a
backend-specific context struct. For zram it would contain struct zram
and the bio. For zswap, depending on at which point do you want to
begin offloading the work - it could simply be just the folio itself
if we offload early, or a more complicated scheme.



> > Thanks
> > Barry
>
> Best Regards,
> Qun-wei
>
>
