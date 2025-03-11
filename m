Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742C51E9B1A
	for <nvdimm@lists.linux.dev>; Tue, 11 Mar 2025 05:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741669372; cv=none; b=GXwJdX1SDhEJIopMOFVs54WOW0OiNsZboINEXh9IOr7Kpwo2uUsR3CvmLtyrerJ2PG+Rbp960TDmChYu2JukAO8noQbqR4oUw2SPPDpL/In1rPNQUk9MRv6xsGW9yzqCIE4Vg9umgwDpkpNoYwRfzCXvlinbzzs1q+R7l/BuxJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741669372; c=relaxed/simple;
	bh=RhaZm/cSv+yC3HFSPC17iQsu6nY2OVc5d4bSK3oNuHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9ZNmHJKNHabXo1hctp6NWsvAH9H9yBHdQ/5VLxDtsgkiSHOtIqLu1vA1Fo1gerV3Fc8I8ncmoix3mcgERK3A8x1u+XaBNWQ0NRk1J66UXB1hNfsFG8HvxQeeSPJ41P9mLylI5hRfRTjYIvg3ZzdzYL9EoJ47D6htMpzRayTY4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=CJ1y/Fjt; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CJ1y/Fjt"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2243803b776so85371845ad.0
        for <nvdimm@lists.linux.dev>; Mon, 10 Mar 2025 22:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1741669371; x=1742274171; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YsL06UvFaIQXEiahdE6DhBRWjwB8pb861e5j/ftXC1c=;
        b=CJ1y/FjtCnwLLIjSjC8wbUbC8Rb0s4ZNHCNgRC+Q5l7yJAYoReRPsvCiP9IKR3/HjZ
         6jJ6SP0ViZzneoOiDCXZazm/t2TKSLaoHn1TliqViL3EFnTKPJKbt4kI/ApF1FcKrZyq
         f32tFF6ocDSi4xVODS/6QECL/SxG3LPKWr2J0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741669371; x=1742274171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YsL06UvFaIQXEiahdE6DhBRWjwB8pb861e5j/ftXC1c=;
        b=W6baiurMQxGdMXlnnxt/kCTNS1W5rJoao2d9/1hh0aKWg+v2GNAJ9AefB6dlRpof1Y
         x5OZj7I8WsxU7H9TJvzezhjMYikGXm+XnATQXap+VP+ePpK+PnYO6w3kBvHiaHAbc9ds
         HBp5dRt7IQQ3HcVWgf4RyBfdRlBfIH89ZYEbdgVacbonbi1VeQVXDuRtsvwVcCMx+kni
         iO5MFlMOE+lhO9MppngpRn8+Hl2lfPet/0RXLh3lw5B6Pm9FdOh3H/BLiFV9fpL+nM9s
         VeYEpMYXxX/OQcID7EsLaV1E6VcalQgzHWFia25/GT7Du5iZOyIczI8sgY45PPQ8qkmY
         +izg==
X-Forwarded-Encrypted: i=1; AJvYcCX03l+ZKxWY+GX1AKKVM3cdTxjyc1rTD1gg4QEaVAOk9Rkz+pU3/p4eA/8/v4KRAkf7kYVBp9o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0KW3ZJ0tFNKhPiC/6TqbPD8pPWvO/8eOozrpDpQTkCO4sUAK9
	RgjMVRaA0MwsYWXLootpB8V9ciYVVE3aKskkZZqxBrMVtntoU8e3VG71xzz9lQ==
X-Gm-Gg: ASbGncuAX5f18yt46druR4WBB0UKyFZi4ysoNpwu85y8ICSXLX3EaTzxZS78+MFPU+p
	p6jNJWjB3Xujze2qQoL2WD7lupMKNlMTX/T6eQmyfzljU1ibj1gA2T4fNUNX+70Ecf/DGcBNv7n
	bub0EEg2o5wW7TEerto1pBil9BmkdxGqTVE5lcYd2EyQ0wXGJtxR4rLqLB4Id5MPYZAfF4vuKZN
	mMNJMwsg6Va01xOQRPnGKlv8xu67AKMf9Z/Z6ZqobljUezUU3H8mqGPYduF66RP7Y9BezbKvgit
	v9CIPmD3oe8vMHKfaZFrxasqkjxYKBH6XytPXcpg1dXNshni
X-Google-Smtp-Source: AGHT+IFKfiFQm8ms/qPRi+wcBaiWNYQfbAZZRcHY4n0zNhnBnJ9IpLaSuc9kTChF2fwrDmR2pqJfNQ==
X-Received: by 2002:a17:903:40cb:b0:223:6744:bfb9 with SMTP id d9443c01a7336-22428ab7691mr283789275ad.41.1741669370601;
        Mon, 10 Mar 2025 22:02:50 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:cce8:82e2:587d:db6a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109ddca2sm87480825ad.13.2025.03.10.22.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 22:02:50 -0700 (PDT)
Date: Tue, 11 Mar 2025 14:02:42 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>, Qun-Wei Lin <qun-wei.lin@mediatek.com>, 
	Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Chris Li <chrisl@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, "Huang, Ying" <ying.huang@intel.com>, 
	Kairui Song <kasong@tencent.com>, Dan Schatzberg <schatzberg.dan@gmail.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-mediatek@lists.infradead.org, Casper Li <casper.li@mediatek.com>, 
	Chinwen Chang <chinwen.chang@mediatek.com>, Andrew Yang <andrew.yang@mediatek.com>, 
	James Hsu <james.hsu@mediatek.com>
Subject: Re: [PATCH 2/2] kcompressd: Add Kcompressd for accelerated zram
 compression
Message-ID: <mzythwqmi22gmuunmqcyyn7eiggevvrzkpqmjkoxsj4q4jc46s@64jdco5s6spa>
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
 <20250307120141.1566673-3-qun-wei.lin@mediatek.com>
 <CAGsJ_4xtp9iGPQinu5DOi3R2B47X9o=wS94GdhdY-0JUATf5hw@mail.gmail.com>
 <CAKEwX=OP9PJ9YeUvy3ZMQPByH7ELHLDfeLuuYKvPy3aCQCAJwQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=OP9PJ9YeUvy3ZMQPByH7ELHLDfeLuuYKvPy3aCQCAJwQ@mail.gmail.com>

On (25/03/07 15:13), Nhat Pham wrote:
> > > +config KCOMPRESSD
> > > +       tristate "Kcompressd: Accelerated zram compression"
> > > +       depends on ZRAM
> > > +       help
> > > +         Kcompressd creates multiple daemons to accelerate the compression of pages
> > > +         in zram, offloading this time-consuming task from the zram driver.
> > > +
> > > +         This approach improves system efficiency by handling page compression separately,
> > > +         which was originally done by kswapd or direct reclaim.
> >
> > For direct reclaim, we were previously able to compress using multiple CPUs
> > with multi-threading.
> > After your patch, it seems that only a single thread/CPU is used for compression
> > so it won't necessarily improve direct reclaim performance?
> >
> > Even for kswapd, we used to have multiple threads like [kswapd0], [kswapd1],
> > and [kswapd2] for different nodes. Now, are we also limited to just one thread?
> > I also wonder if this could be handled at the vmscan level instead of the zram
> > level. then it might potentially help other sync devices or even zswap later.
> 
> Agree. A shared solution would be much appreciated. We can keep the
> kcompressd idea, but have it accept IO work from multiple sources
> (zram, zswap, whatever) through a shared API.

I guess it also need to take swapoff into consideration (especially
if it takes I/O from multiple sources)?
