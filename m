Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C94208989
	for <nvdimm@lists.linux.dev>; Fri,  7 Mar 2025 23:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741389206; cv=none; b=s4SaPq02M7nneE5dsEBs+KuwPpcreiuHywg6xt0zIYpEMtmRjzPeRKyRupKSdQRRk339VLSM5ZM0Pv0R2N8wEheW+12Fca4nck0zLVIdViW1DdVuFW1PerKl4UWIW8OwRoATrM6by6S1iv3hzRUmyk/RxZCrZvTYMkxhD6yuy0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741389206; c=relaxed/simple;
	bh=G63d06X8W9arXCJggGOHT2w3cbPycEOHJ8wMoqYNgPQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=STk+pPd2Po0kaRIQf8NdnlBpE0zDvdLdNjjpJwYiyhFSZ3imMqMgE7AQOpleKqCKB3Izm9pgdfowfeZQKCIPEO91f5h6svVZB1QqsoJptMmkPPiJik2GZ48cxZAa/kOE5/Kojmg6zgyunwUdvIctuft7BaeUyB1X8qGegR3dAzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TWwfXLwg; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TWwfXLwg"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6e41e18137bso17003216d6.1
        for <nvdimm@lists.linux.dev>; Fri, 07 Mar 2025 15:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741389203; x=1741994003; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cqomUUPjRLiQmonoip8f3BCduAZxVjsjo6bLnE0yfxE=;
        b=TWwfXLwg/RV5EY04hH13l7Ks5mWAlRMxQda2gLL43EjGaIySeMLfaQ7nMCCCUO4Yh/
         TzuE2s/OMt2b5CEi3KmkZU1FooYcN5xvzXnuXOnpDAg2hd3T5SgsFYC1N5HOzQuNL/ar
         5WR+tHiCcsL43oI1JNVlX0XbOCUL981qxnqYww6GJhLai3nwf37RoN2SvjizQe41STeu
         G9MhMpHO8ptbiTWBnsj2Oti29djwEzMkwaOQsXDhB5vq2vCdaoQkQ3QcVhTzCPqzxHFs
         +dZ80UO3K0vkwvVwAUbefRZveTaAKyIss8xKMDDfDCxwGX+N0/1DNUM5V8+i5apwOGnb
         oW/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741389203; x=1741994003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cqomUUPjRLiQmonoip8f3BCduAZxVjsjo6bLnE0yfxE=;
        b=ku90cR8xEQ3AIil2XbvsIZcy+eC6/DWuGY7K7shIUA52usK4j4QcMLxCSjl9Oq61dP
         lxYSC2PpD1IZFACkLJunD4usnrT1lf9aexSDytnVT/zz5KtEcDYFQAX5v1qQSoyffWpd
         JBFaMj1HIqDbzmFUWDwy46S9zz+Kj2TkVwAmPG9ozzck7AhnyDTnMdRMD7jUzJltC6B+
         5hvbbkVpYoua46JoPLOwDvY1IxiouW7zhJhRA+IjiLHj02N6hJY40DE4yxKwjxGKxP3j
         4pem+fG0tOelHBYQVf2qgOkQdz5L6C2CIpD0YAMz0xVv7rfcd0TZfRLNM/oqlWHCACDa
         zgVg==
X-Forwarded-Encrypted: i=1; AJvYcCWwxYYqk0En8EYE1rPpoBrDH9YT08nhHodEVZ/1D3mY8uNV2Mj8vd5S6IEQrIvFN40W4paTttE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzoImuISniAWoq8ZrmWm5cbZ8emJuAJVYosIKw2oW/a0DhM3FEY
	nxS0sWvhBIWVFPugol9lQEoLtDCJjQpXIHB79LA9xFqiyhDbHY2aesL3koUAYaE8vY2k9vXwpg3
	b4MtcnoLOAS3alODXQ5KyFhDCEuc=
X-Gm-Gg: ASbGncsKzUHV7uVIbjWB9TLYVXTlf4T1/QxzgLxooSDWIF5ovE/vAMzcIUokK5JwAE3
	3SYZ2QfCSwN7xlhC6JZ9dbK4i+ogebCel49WZSECB6TuEju0luYGJRFa7CeFcbHWbdgkUjFF3kf
	cgmduUp+O6kj+jZ2HD7ErBrkYl0894DKLrg8vm5VUMjA==
X-Google-Smtp-Source: AGHT+IGgO4waxliJRJEjcjUATYM+tLYXbT7o9vAllgT5zmhdZvJYwca7AqrIUigw62PVDCYdl3bzS0BOeN1gV1tcJBc=
X-Received: by 2002:a05:6214:21a6:b0:6e4:2dd7:5c88 with SMTP id
 6a1803df08f44-6e90068196dmr70464496d6.38.1741389203258; Fri, 07 Mar 2025
 15:13:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
 <20250307120141.1566673-3-qun-wei.lin@mediatek.com> <CAGsJ_4xtp9iGPQinu5DOi3R2B47X9o=wS94GdhdY-0JUATf5hw@mail.gmail.com>
In-Reply-To: <CAGsJ_4xtp9iGPQinu5DOi3R2B47X9o=wS94GdhdY-0JUATf5hw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 7 Mar 2025 15:13:12 -0800
X-Gm-Features: AQ5f1JooOtTd4HVR7CCnLuHoQkyIFVDhrvbdPzpgk1fPg8et0mZMLZfSKYeQ1OE
Message-ID: <CAKEwX=OP9PJ9YeUvy3ZMQPByH7ELHLDfeLuuYKvPy3aCQCAJwQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] kcompressd: Add Kcompressd for accelerated zram compression
To: Barry Song <21cnbao@gmail.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>, Jens Axboe <axboe@kernel.dk>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthias Brugger <matthias.bgg@gmail.com>, 
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

On Fri, Mar 7, 2025 at 11:41=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Sat, Mar 8, 2025 at 1:02=E2=80=AFAM Qun-Wei Lin <qun-wei.lin@mediatek.=
com> wrote:
> >
> > Introduced Kcompressd to offload zram page compression, improving
> > system efficiency by handling compression separately from memory
> > reclaiming. Added necessary configurations and dependencies.
> >
> > Signed-off-by: Qun-Wei Lin <qun-wei.lin@mediatek.com>
> > ---
> >  drivers/block/zram/Kconfig      |  11 ++
> >  drivers/block/zram/Makefile     |   3 +-
> >  drivers/block/zram/kcompressd.c | 340 ++++++++++++++++++++++++++++++++
> >  drivers/block/zram/kcompressd.h |  25 +++
> >  drivers/block/zram/zram_drv.c   |  22 ++-
> >  5 files changed, 397 insertions(+), 4 deletions(-)
> >  create mode 100644 drivers/block/zram/kcompressd.c
> >  create mode 100644 drivers/block/zram/kcompressd.h
> >
> > diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
> > index 402b7b175863..f0a1b574f770 100644
> > --- a/drivers/block/zram/Kconfig
> > +++ b/drivers/block/zram/Kconfig
> > @@ -145,3 +145,14 @@ config ZRAM_MULTI_COMP
> >           re-compress pages using a potentially slower but more effecti=
ve
> >           compression algorithm. Note, that IDLE page recompression
> >           requires ZRAM_TRACK_ENTRY_ACTIME.
> > +
> > +config KCOMPRESSD
> > +       tristate "Kcompressd: Accelerated zram compression"
> > +       depends on ZRAM
> > +       help
> > +         Kcompressd creates multiple daemons to accelerate the compres=
sion of pages
> > +         in zram, offloading this time-consuming task from the zram dr=
iver.
> > +
> > +         This approach improves system efficiency by handling page com=
pression separately,
> > +         which was originally done by kswapd or direct reclaim.
>
> For direct reclaim, we were previously able to compress using multiple CP=
Us
> with multi-threading.
> After your patch, it seems that only a single thread/CPU is used for comp=
ression
> so it won't necessarily improve direct reclaim performance?
>
> Even for kswapd, we used to have multiple threads like [kswapd0], [kswapd=
1],
> and [kswapd2] for different nodes. Now, are we also limited to just one t=
hread?
> I also wonder if this could be handled at the vmscan level instead of the=
 zram
> level. then it might potentially help other sync devices or even zswap la=
ter.

Agree. A shared solution would be much appreciated. We can keep the
kcompressd idea, but have it accept IO work from multiple sources
(zram, zswap, whatever) through a shared API.

Otherwise we would need to reinvent the wheel multiple times :)
