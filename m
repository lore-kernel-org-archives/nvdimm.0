Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792894640;
	b=ptk42sfqKdm+qm8fYgX1sO7Zxwg120OVU4w1EzHM8Uw5wGMomh9nEgqhXAuPL69fHlss
	 sE6nU4358u+Upg4x5EjPhV9mQNFPLB95VYqpGi9fHRwFOkh2sLn5v+I3K1mdUBABIf/iz
	 XIjBZYDqXEOOBA3K1hKgsnwFdVBM1cEXVBb47dlUKGXuxtInqtljNyxO/Z2VI0Tuo2hzJ
	 u5HhtNY737ZHmnW8TtItY0j5/ygLh+i6VZKwXpSRcbnf6IAgu06ZrC6newQFMNUxXJQN8
	 OcNyJyBMo4kx+miTZ1pxQQFN7WeS4zG6lIsdXNRbenfYnIgHKHdZsLP8RFpkrCQhipg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792894640;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References;
	bh=59O6YsOe2ZdqTEDOrhAn775YQJaCvGOavb/hzAN0T1U=;
	b=A74c8HAs5OygkdpvV20hyz3jJgNSqtMQD4PwrIARR8YmfMXQifkRn7OHNe4TPYo9TeZA
	 ga7uBGIi4h08CTwZeJwnVynqK/gjhBvt6MIzX7A4HR+n5UGBYtN4w6oHAn8JC0xzZ5tPt
	 sTR0NiJ0dW9JB6zHhjjzwr+5CtffgcoYB31UCp8CvIKO45V0+YYZAOgikHU/+QVo3RXeb
	 tgOOgcijEMxFz5NA7C0PBu2I609YJo8BXxPjl77r2XeFruT7FYDz7snlwjXOMCfCzyehu
	 uSatavBmYcnlztPQctYDlbgrgMGFaPiYVbsuk6tIGRj9OsnRUaQmyZe24kkrBCJJQhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=itq9Tsce;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CB5606A324
	for <nvdimm@lists.linux.dev>; Sun, 25 Oct 2026 02:17:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7CB5606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=itq9Tsce
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-3282db206d3so3470454eec.0
        for <nvdimm@lists.linux.dev>; Sat, 24 Oct 2026 19:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792894639; x=1793499439; darn=lists.linux.dev;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=59O6YsOe2ZdqTEDOrhAn775YQJaCvGOavb/hzAN0T1U=;
        b=itq9TsceoIuLfTmPBleKghRvDsiEU5wICo+iQEjshRqbvxZ9WXn3hUZnXFFeOYno2N
         567PiMFEYFhmvriiLwPUfP6XAY+Iy4rAca0ZcMTMnNkhq2Hbou2xUM+vnJMw9EX83t8d
         10iN8vMrF5CAQOZf46uOZ9a/7yBmCaXVuvmn7g3Tan0r4DuT/yZd9jL5/dxnqoIaGDKL
         sEUSlvBr3aHEP7M4aRZ20zbYKrZFC8P6HM6SlP/oUvG/AFKRSIa4kvhIln7TVUEBV6pd
         apu2CpXK52Ed/Ps1bwt86R6uA3zGFSPvlT9hn/Fl+CByQukMa/6Q+f1cYt85A/ubNIyv
         RyTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792894639; x=1793499439;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=59O6YsOe2ZdqTEDOrhAn775YQJaCvGOavb/hzAN0T1U=;
        b=fehNfElvkX53o3DKtiuSApc5IrIz0yQBJHiER6Loc0+RTRXtImSnMGNhBk7YymNJBd
         3pjxwO7HMPnLaME+afYF7ptaFI5TTd0FK36e51kt/4r4x9nAZLabwLfH8Z6WqV5Akava
         WA2hmntdhD1wiiEL64oMO1n8WMFc9QVJvFUUwYMZTHEwUXSb8XUUjKlZVqmJm9VFRgme
         Qdtqj/xXWwLFF7nrfCJqNl0D7UZRm9yiSynvkgp2Kl9KRGSJghr/YwenzOI7YpYq2Jf5
         mma4guxksblLtC6wkfNOvNS5quMmbqm89K7crBCiU2RjIBD5GIqyPBvsSqq7YTJt+gby
         V5Ng==
X-Forwarded-Encrypted: i=1; AKwUvBwy+z4nKiOVNhnvCcfMxkAIUumh+S6VMELtnoJynnTwJXb6hn8e0n6ApiSxkUVmS5YexDBTIrY=@lists.linux.dev
X-Gm-Message-State: AFq9FYLreJTbhQWDIM/mHifie5Yrmx9hx4m7rOo+WMvdhmxXDORwVaLg
	jCX3qvkgDkaUcFxkz+HX7b+3p6wN92iBTIBmGF7UfNtozPxWEuTRrfOo
X-Gm-Gg: AYBFou3HxnLKcPfwIfHzRSuF9hJv+Yf6/K0q+m2WQZIwLSCbJ5vbL6PvrqHFx2ucI0f
	Yrp6NepOzJVY0pvxiioveIlBGNEHq2sfLA66iLxsEZ2BlTL5YXbqNx4E3fKso0arsW4+vqmRCqV
	xugaqKq9Ix51iB8/g2gFu+T/iYAkH1YjKLcGR1GWniEuGULOOdSoDW/XZz17qLJTchExTaRWHfd
	xrIqcDvt5gAALS829U2fpTwIriQr2v2AE64hEAvYKl8FI6EaLLGbctu2dS7FxMyADPb4fQwz5YB
	b8Tidlq76msEXF+YgBr0qZsGrV8NQ2o47xh+nznbTCemuk1G5EYxman/Ba232Uhdm3DtFl6iZFx
	kYX7c4RJm1eQjwsgAgOgZ//YuUFYhJI/VynPEfJqivQLMAZA0T+cYMokzewxmkVOIbe7+e9tV52
	/XWQV9LrFpH0RdRMIrGH/mdEUuzuSTSyXn9ivQnrrDI/Gf93PYw6JPwLTFoefR34q+MrA0gxfj8
	9SOhJEgdZD/9riy0zj2xoaALweJF+hF0r7SGsdn779LpKA4PbZfVg==
X-Received: by 2002:a05:693c:2d86:b0:35c:707b:acba with SMTP id 5a478bee46e88-369e8369d86mr7944429eec.3.1792894638749;
        Sat, 24 Oct 2026 19:17:18 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8d812d6sm12003945eec.10.2026.10.24.19.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 19:17:17 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Muchun Song <songmuchun@bytedance.com>
Cc: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, Joao Martins <joao.m.martins@oracle.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH v5] dax/bus: Fix Device DAX range alignment validation
In-Reply-To: <20261024183853.6803ce81788636e94d8c16a4@linux-foundation.org>
Date: Sun, 25 Oct 2026 07:40:03 +0530
Message-ID: <cxsy5y4k.ritesh.list@gmail.com>
References: <20261024112555.2476001-1-songmuchun@bytedance.com> <20261024183853.6803ce81788636e94d8c16a4@linux-foundation.org>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sat, 24 Oct 2026 19:25:55 +0800 Muchun Song <songmuchun@bytedance.com> wrote:
>
>> Only range sizes are currently validated against dev_dax->align. A
>> dynamic device can therefore select a large-page alignment and allocate a
>> range whose start is not naturally aligned.
>> 
>> Sashiko found that memmap_init_zone_device() could then initialize the
>> struct pages with a large-page order for a physical range that is not
>> naturally aligned. A subsequent write to a userspace mapping then
>> triggered a kernel panic in testing.
>> 
>> The automatic resize path can also split a size-aligned request across
>> arbitrary free gaps. When devices with different alignments fragment a
>> region, this can extend a range by less than the device alignment. A later
>> allocation then fails, leaving the failed resize partially applied.
>> 
>> Initialize the device alignment before its first allocation. Validate both
>> the start and size of allocated and adjusted ranges. Use the same
>> aligned-gap iterator for free-space accounting and range allocation so the
>> pre-check and allocation path cannot diverge. Skip unusable gaps and
>> serialize size validation with alignment updates.
>> 
>> Static Device DAX already has a pre-populated pgmap whose full range was
>> validated against memremap_compat_align(). Its usable data range may begin
>> after namespace metadata, so require only dev_dax->align for static
>> devices. Dynamic Device DAX builds its pgmap from the allocated ranges and
>> must continue to satisfy both alignments.
>
> Thanks.  This is now a must-have for 7.4.
>
> I suggest that the changelog mention that the bug becomes hittable once
> your series "mm: Unify device DAX and HugeTLB vmemmap population paths"
> exposes it.  That's 
>
> 4b77739fe789 ("mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX").
>
> I intend to send this to Linus next week.
>
> Maybe also a Fixes: 4b77739fe789.  That series didn't create the bug,
> but this data provides notification to people who are backporting this
> series (unlikely) "hey, you need to add this fix as well".
>
> Also
> Reported-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Closes: https://lore.kernel.org/wlrkqqvg.ritesh.list@gmail.com

I think, the fix for the issue (the one that I reported) is a different
patch [1]. And I did give my tested by there.

[1]: https://lore.kernel.org/all/20261016054914.2601510-1-songmuchun@bytedance.com/

>
> I don't believe that Ritesh has tested this?  He wasn't cc'ed...

Nopes, I haven't.
But I am looking into another open issue on Power which this series
exposes. So while at it, I can test this as well.

Thanks for the cc'

-ritesh
