Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793369119;
	b=nPQWx6ynuTBcNu0QnGITrLOba1EKgnuFMooxsBbXm6YetFkb4sFbCaGSilI2Nehvyi8A
	 3WslRDmPIsioxlyHMLjs8LHxwtJnPaooJNmnzoLzGEgxnb+nZJ0pPLH2bOlFrkphfe0HY
	 9Pgkiy7HSh4PqBrVzGF1GB93Ao0yZX62sdcW4ylqB098hbf5FOtgzcYz4G+j3R/unNSVq
	 IpauvZ7stu8NZxwNi7f8dQq+vK+rMw8KWKWR3IWCkbj6aHg1JDM0fzuEjHHvQC24M/TiB
	 pMGg9q3NE0erFO8uj27t/g1jYuFkBImuFuxaHD7Yj/2c/7ekVIUV7qjL6jhitBeMAIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793369119;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=9UBOGrnevchYzRdIK+lYuYuVpkBp6bntw5wHhZWKMa0=;
	b=awXSsti9d2+6RoTXK+knu9O3PbxPWkA7aAvjGChiS2ScsXdoQu237ZRAX9cu3h4xAtLY
	 uepkYa7PXoq4c5VdWjXUvifE54aZWF+KMFW1xmgnMbHOXsEw1oaxNd8lGGK0e4UcGvyJF
	 Wp6n1bUxbecsvipqS/y7pp1R6htwLa5JXbx1NrObeA1Gc6vb8928yB+Yzns5UJ6zfP3Hc
	 e5eN8gyiKmblh4Rits7U9+VgE35ZVgKRSSqSyuGQ4FTkMDJviNEsiWBrivssFa2FZacgn
	 C7hOpHkUE2bs1uFqFNSW+RLU+p5nTWQU5wwIK5ZaVQaC3Pyjd4xdEFBG+k0eWpkt40Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=iCJ32sOK;
	arc=none smtp.remote-ip=209.85.217.51
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE498606A31C
	for <nvdimm@lists.linux.dev>; Fri, 30 Oct 2026 14:05:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE498606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=iCJ32sOK
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-7ccb2ffe333so489830137.2
        for <nvdimm@lists.linux.dev>; Fri, 30 Oct 2026 07:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793369117; x=1793973917; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9UBOGrnevchYzRdIK+lYuYuVpkBp6bntw5wHhZWKMa0=;
        b=iCJ32sOKZdJj/khzWWtn9N/z8AhjVtKkRT2IHQ+EoBchykH3C6gB2SpkX1mNKZQPac
         P1G2SjrIThW0ZkGZlURJ8GCiubFEvMUcbl2bw8bHfW6OjmqM0ut69cGyOmAsNgp1FCtj
         xSU1OsKxvZ1MHynC7ej7OLrJAlRlLTESmiDqoSb7FCnlSltiXEmK7uj9CTrzjy/OfRJG
         g72ly312yr4CS66GlcGE3SrUpFgx4rOXC+grcMM1sB7QB2xyN5wgAVFv4DHGEAXYVyXR
         5cyTosHWOgaUyQdjErBA0rQyVBVq0eehSdRA05RLcf//byDFSWLwI+uuZn0K6Ewu1ZJy
         iQ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793369117; x=1793973917;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9UBOGrnevchYzRdIK+lYuYuVpkBp6bntw5wHhZWKMa0=;
        b=bXRBU550TZ+hofvEEQF/LbGyIziUznbpOzc+/phF/oqBdRZyw80D95u3tWPvL/lEpH
         5ztD7vfRL/3jE6Xa9v5/UscSjZ5tI0MWQZr7YxqBTz3I4uNh4ssvqSErww07BEUVYXPV
         wISKT2GpKACUP7LgELt6zFcn4QDlH+hIxlOTqZJ1RQypOE9PQ+mo3lbfBpFvqCfKaRQk
         80QFSnR64OAhD0s/wSx51tO5cb7A1/46AhcZKVvJr9XNnzN0lxMKLv4V6uTAYp3amKRW
         GHmN1SbefDNwPmCa5N3Osm8d35Hu6BkzypGmVX+66SKN4wJzSnhBI1w2d4+LGjFrmsjO
         /d4g==
X-Forwarded-Encrypted: i=1; AKwUvBxN36l0lN45lBA6ja2TjYhSxBneDydMoDpAPrmrE69NGTZGiN+vbDLeCTBjh5guaaONoORA1GE=@lists.linux.dev
X-Gm-Message-State: AFq9FYKQRqxkDRxtrmP9PDleeownYmQrPxpttIiOhc15nC3p0xtknr1Z
	IzgWvZc2/gEynj2+ZItYbinmB8wVYhvGruaap3209rj5XywYCtrMVUkbH78BkbhuoAQ=
X-Gm-Gg: AYBFou0ki1i6gsv9DhZn5kGZWjIu0HaQIni4PLIOhbAtVt5uw5MMfRks0JObVItI22P
	ee49Gdm6VX68CteBFqbszAXdLqZ4EAAagnm1/1sJ0/uZXJ2LlKfuU+DKHHKJu5x0PG23Tndw7Aa
	S/8CIpofKcWGj/+Bbg7i6flPM+Jo+Xg9VLmYkNJlGP+xMqyrjiBjIIfikoMgcM3ULjipR7NGwZn
	uoI2H472EKGEHh0uZdN3L8bJG/Z2igWDr1BtiKJZ8i+cJgxrMH9ZWWo9/cV6IReyyGeGoOXiv0+
	LBengaVPXalkPYLT/qnU1m2eeUiKXNjWl6krGGGBpZKkZ2FcryOP541dd+OwwbDyjmzFo4XxN3U
	6mbSNFfKpggoZ5I6jATrHUcgmovlaIktQmwE4m+D0knM267AC6FxJkYNbd1JlC98OUAwg1ylNON
	KdWPEKW13p3dr6K/7lPFpA+IZn8YsNpfNW4C5U3jX9hVBR95mY5wnTwcRFjaPv5kfY6QDkzQzO9
	xgr3q4K7xztsWtcUGvyOlNlsqvjs+fT+81vbIWKF9LhPhqDPDXB2j3435o9J+ZlWcPQXCRrTELY
	pYPfXQlakJwtRBQBVlDQxhzUYf6/MAcys8WGpAXlthF+d7AAe2Rsdj/YPBPpZdeaiLzR8hZPDcP
	R
X-Received: by 2002:a05:6102:c4f:b0:7cc:3eb0:6ece with SMTP id ada2fe7eead31-7d072d53fa3mr1222192137.33.1793369117323;
        Fri, 30 Oct 2026 07:05:17 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca806aeeasm15954726d6.35.2026.10.30.07.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:05:15 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [ndctl PATCH] libdaxctl: check the zone of onlined memory
 blocks
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org
In-Reply-To: <auP1-iC_4r0lF7dV@aschofie-mobl2.lan>
References: <179322248318.3398847.13424413341337264007@gourry.net>
 <auP1-iC_4r0lF7dV@aschofie-mobl2.lan>
Date: Fri, 30 Oct 2026 10:05:14 -0400
Message-Id: <179336911439.2951797.4892975963347452252.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-29 18:42 -0700, Alison Schofield wrote:
> On Wed, Oct 28, 2026 at 02:21:23PM -0700, Gregory Price (Meta) wrote:
> > daxctl_memory_online_with_zone() is meant to scan the device's blocks
> > after onlining them and fail with -EBUSY if any block is not in the
> > requested zone: an agent such as an auto-online policy or a udev rule
> > may have onlined some blocks first, into a zone daxctl did not ask for.
> > online_one_memblock() relies on that scan, it ignores a failed write
> > for a block that someone else onlined ("There will be a full scan for
> > zone correctness later").
> > 
> > But daxctl_memory_op() returns the number of blocks it onlined, and the
> > function returns early on any non-zero value, so the scan only ever
> > runs when no block was onlined at all.  Whenever daxctl does online
> > memory, a zone mismatch goes unreported.
> > 
> > Example: 
> >   memory_hotplug.online_policy=auto-movable
> >   reconfigure-device --no-movable -m system-ram
> > 
> >   => reports success with the memory in ZONE_MOVABLE.
> 
> Hi Gregory,
> 
> Does writing "online" let the kernels auto-movable policy select
> ZONE_MOVABLE? I'm wondering if this is a race, or if daxctl should
> be using "online_kernel" for --no-movable.
> 

'online' basically means "kernel picks".  I think it's reasonable to
convert to using 'online_kernel' for --no-movable.

> > @@ -1704,8 +1704,9 @@ static int daxctl_memory_online_with_zone(struct daxctl_memory *mem,
> >  		err(ctx, "%s: BUG: invalid zone for onlining\n", devname);
> >  		rc = -EINVAL;
> >  	}
> > -	if (rc)
> > +	if (rc < 0)
> >  		return rc;
> 
> What happens if the kernel places memory in ZONE_DMA32?
> Will that lead to a MEM_ZONE_UNKNOWN and then an -EBUSY?
> 

Hm, let me dig into this a little bit.  I didn't think this could happen
for dax hotplug - but it is subject to default_kernel_zone_for_pfn.

Give me a bit

-- 
~Gregory

