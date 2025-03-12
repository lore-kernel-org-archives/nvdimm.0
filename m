Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4435D1B6CFE
	for <nvdimm@lists.linux.dev>; Wed, 12 Mar 2025 05:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741756752; cv=none; b=tbCnaDr1giiAImWSqmvZcbKpxzL6QRm+R3CoKpEbvHkZ9G3VPWwwF3ea38YL5LB/2Jx+goGex/egnRdl97DcXPiPQLDed6fWQhqpkS77Xv5Dp00wazJKxW3AguFu67MVz9RXmtKDmyqOas2uIanfX+qUEeXHNt19cM5zg5Wd+3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741756752; c=relaxed/simple;
	bh=xyGd4vz/Vem50KOki9HZJ8te8e8Qsp7r5/o+J9MvuqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+t08xmgjzSOKg3DyWHX0a3/uaZSPoHJir/Lsi68l2byrR1NSqInPT4FyjhQsQZnDWRmisvzXOmvDh6DGtUgowd7/ljpcUFCA+EUhvQ3Ql9DuUAZENCwF3L3bEpqIxAyVP0liSU7jy7WRiU/lFj1Bh4bhHf5VUbp50cGqp7Epcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=dTJugpll; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dTJugpll"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22355618fd9so119882955ad.3
        for <nvdimm@lists.linux.dev>; Tue, 11 Mar 2025 22:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1741756750; x=1742361550; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MatbiHDO0DCUqMkCHmZ0elSs7NnL3O74U74cu1zQUug=;
        b=dTJugpllNfmq3Hxz6TYWnwU4KCmmFmc5frhMVnUkiTnc/QHa86eMUi8+MEZFhm49l2
         ujQKe5SX/l8x1UkS2m9fd/FhGxZlDSK1GG0rZIglcuw2hcaAZHcE6TH5jW11jPokSKZV
         xbq22Y6Td6ow0xzhgk/p3tTHH8Wlpvi/YfzKs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741756750; x=1742361550;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MatbiHDO0DCUqMkCHmZ0elSs7NnL3O74U74cu1zQUug=;
        b=VyGon8YyyNc+ATImo4mNyyQ0jQjvm2nFkVZwb6BDhm/AiVwU34CaFyZjWw3hggk7QU
         CXGzBlLkKFpIqpa3qMDxzApismSjfixvTn2vfcSTqNdqQ3Myiy5G7DTOkBKl84sVUkQN
         dLdZvRb8Sh1zHpmUqjfEu3XNoK7EbH6qNE8ynas8qCxLoUjW9E4jFuFdoA2pEkybwOCb
         UTa7PhIg0EQKHJdnToNlwPIcqf68hWbERYX0WwmhbX1GBcWhSZbK2NTVNrD7mtVwsAS1
         WVgbhjhoKvhFCKiw/uSSzSa3Wu+e5yK6p7NpmwkQP0eUKF/MsdRmQbaOu/0lUoNs3eQ7
         wRpA==
X-Forwarded-Encrypted: i=1; AJvYcCU+wFa1+NprUK9k/JIzSHN7L+t2/QiyXKjVczV8CWeRfTcAA/rfo0BV454VZRLtYyTKvNHuPBs=@lists.linux.dev
X-Gm-Message-State: AOJu0YypmOVdt9vETsB/PJZIFGEphm+XhDg3aNBbukHYKIrlwkILViSn
	SkNTdjMB90HFkNrMc5WzKqz9O5unNPhZxWhvaaNM115WwsA4Z5Cg2sNwQRXiMA==
X-Gm-Gg: ASbGnctkj4xVvuF/v2YkUHfQDeTncD3i9T78sNpwp3BdSTne5VuAM0TO58WhZGK7X5x
	aZHp9zS0CCE1df0FpgL5yMIe9hdOGroxAU33sT0IUJaDWmlUZuzbmeflNdm1MesPZkFvKAEzwk8
	NrzHKFoUkJrG09+KvJM278+SthHs1/f8bM3fLOc918K+fWM6XzaFs0VaH6pqh4RrK4EjuYMzrV6
	0zx/P6P04K1JxnwuQs4TrcvZinuv/UgpksXZ04/CT7qefbjj7uspTUsAxfqU8cmDZGEvaE0QvTV
	cwP+FeKX8smMIHCkO9XzobwHd+9svn6qUM9vdjb/eA6EcyOA7vwNKuUAmZ8=
X-Google-Smtp-Source: AGHT+IFe2j1+GACtRUcv6p7Y8qMgiJICjpvUMqBu5x7qOSpIgXxXSdQ6F+GhVarFS/5mqmKsiN8Zkg==
X-Received: by 2002:a17:903:46c8:b0:224:1c41:a4cd with SMTP id d9443c01a7336-22592e207damr74581435ad.3.1741756750550;
        Tue, 11 Mar 2025 22:19:10 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:713f:ff5a:f7a8:2aae])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109df232sm107260695ad.41.2025.03.11.22.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 22:19:10 -0700 (PDT)
Date: Wed, 12 Mar 2025 14:19:02 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Qun-wei Lin =?utf-8?B?KOael+e+pOW0tCk=?= <Qun-wei.Lin@mediatek.com>
Cc: "21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	Chinwen Chang =?utf-8?B?KOW8temMpuaWhyk=?= <chinwen.chang@mediatek.com>, 
	Andrew Yang =?utf-8?B?KOaliuaZuuW8tyk=?= <Andrew.Yang@mediatek.com>, Casper Li =?utf-8?B?KOadjuS4reamrik=?= <casper.li@mediatek.com>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chrisl@kernel.org" <chrisl@kernel.org>, 
	James Hsu =?utf-8?B?KOW+kOaFtuiWsCk=?= <James.Hsu@mediatek.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, "ira.weiny@intel.com" <ira.weiny@intel.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.jiang@intel.com" <dave.jiang@intel.com>, 
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, "schatzberg.dan@gmail.com" <schatzberg.dan@gmail.com>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"minchan@kernel.org" <minchan@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, 
	"ying.huang@intel.com" <ying.huang@intel.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Subject: Re: [PATCH 0/2] Improve Zram by separating compression context from
 kswapd
Message-ID: <y2jpx4xcl34xxrh76jms7wojyhvjvigto4phmdek2ewbcyq32f@2owu5ndtama7>
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
 <CAKEwX=NfKrisQL-DBcNxBwK2ErK-u=MSzHNpETcuWWNBh9s9Bg@mail.gmail.com>
 <CAGsJ_4ysL1xV=902oNM3vBfianF6F_iqDgyck6DGzFrZCtOprw@mail.gmail.com>
 <dubgo2s3xafoitc2olyjqmkmroiowxbpbswefhdioaeupxoqs2@z3s4uuvojvyu>
 <CAGsJ_4wbgEGKDdUqa8Kpw952qiM_H5V-3X+BH6SboJMh8k2sRg@mail.gmail.com>
 <32d951629ab18bcb2cb59b0c0baab65de915dbea.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32d951629ab18bcb2cb59b0c0baab65de915dbea.camel@mediatek.com>

On (25/03/11 14:12), Qun-wei Lin (林群崴) wrote:
> > > If compression kthread-s can run (have CPUs to be scheduled on).
> > > This looks a bit like a bottleneck.  Is there anything that
> > > guarantees forward progress?  Also, if compression kthreads
> > > constantly preempt kswapd, then it might not be worth it to
> > > have compression kthreads, I assume?
> >
> > Thanks for your critical insights, all of which are valuable.
> >
> > Qun-Wei is likely working on an Android case where the CPU is
> > relatively idle in many scenarios (though there are certainly cases
> > where all CPUs are busy), but free memory is quite limited.
> > We may soon see benefits for these types of use cases. I expect
> > Android might have the opportunity to adopt it before it's fully
> > ready upstream.
> >
> > If the workload keeps all CPUs busy, I suppose this async thread
> > won’t help, but at least we might find a way to mitigate regression.
> >
> > We likely need to collect more data on various scenarios—when
> > CPUs are relatively idle and when all CPUs are busy—and
> > determine the proper approach based on the data, which we
> > currently lack :-)

Right.  The scan/unmap can move very fast (a rabbit) while the
compressor can move rather slow (a tortoise.)  There is some
benefit in the fact that kswap does compression directly, I'd
presume.

Another thing to consider, perhaps, is that not every page is
necessarily required to go through the compressor queue and stay
there until the woken-up compressor finally picks it up just to
realize that the page is filled with 0xff (or any other pattern).
At least on the zram side such pages are not compressed and stored
as an 8-byte pattern in the zram meta table (w/o using any zsmalloc
memory.)

> > > If we have a pagefault and need to map a page that is still in
> > > the compression queue (not compressed and stored in zram yet, e.g.
> > > dut to scheduling latency + slow compression algorithm) then what
> > > happens?
> >
> > This is happening now even without the patch?  Right now we are
> > having 4 steps:
> > 1. add_to_swap: The folio is added to the swapcache.
> > 2. try_to_unmap: PTEs are converted to swap entries.
> > 3. pageout: The folio is written back.
> > 4. Swapcache is cleared.
> >
> > If a swap-in occurs between 2 and 4, doesn't that mean
> > we've already encountered the case where we hit
> > the swapcache for a folio undergoing compression?
> >
> > It seems we might have an opportunity to terminate
> > compression if the request is still in the queue and
> > compression hasn’t started for a folio yet? seems
> > quite difficult to do?
> 
> As Barry explained, these folios that are being compressed are in the
> swapcache. If a refault occurs during the compression process, its
> correctness is already guaranteed by the swap subsystem (similar to
> other asynchronous swap devices).

Right.  I just was thinking that now there is a wake_up between
scan/unmap and compress.  Not sure how much trouble this can make.

> Indeed, terminating a folio that is already in the queue waiting for
> compression is a challenging task. Will this require some modifications
> to the current architecture of swap subsystem?

Yeah, I'll leave it mm folks to decide :)
