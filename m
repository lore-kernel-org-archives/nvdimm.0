Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792687231;
	b=iIjulJFhpsEuY9JXvdCi2hh5kWB/jHSVlyho0P+pD8OhI2Kmn8f5qVe0K/ZN7DE8BNbl
	 NCT0yQGG/JF1tfnJwDm0zrk5WJh6eCOclj8Yb5ntWLGsrvCCnEGIsSWlHAB8COC39XU3c
	 7wqPCAuzjUZfdSsELDjllljtHBTAmItMOmX4JTomhp+sJ2NtBefG6f0Hw4DJV/8B+VIIP
	 0v9m0ipAKMqco3rhfLrmpPajQGoAQXVGeOL9XN6TfmqUgE0zVGY5rlsp7Gy/6vzSfxpYB
	 gTBs+YXnzGBC44vj5DV/EkWsLUwnvIbgyiqldhg3ZxOrR8BC40f5j2MCFg9ZN4mdN2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792687231;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=pBCWQ7jscdfKZcHIgslgXKhcbj8ko2Frw+3Y69vYvjU=;
	b=D1p6xNcncRXOQ9Vc9wIERS8Bo5OooMsjUycn4EA2sWDazOglAmpoOgZE7B1szOgM01Jf
	 KeU7K0e1vcaXo4qwVa2fxcWCDxLm7412oUPSA/g+5viyVv4RkzK6YntaLReO8Ae6JhMho
	 yAPkE/2ru4PSUhRbjIudzmBBZxv+/Wn6bDvpi/KpjqzLHx4rNXqdWHDbZXCTAzl/TM07n
	 y0b2veqbkllKF2ozOm1H5E71T3/iO/kGZhGMOiCCzMzSqDmHto9Jr+181LLvyNNnjDcTl
	 rs+7PP7ASYMCnFIeViAM7JVYFrItFP0eAUicdNwnIP0XOyjJ05vZ2nBec+djeun+aDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=j+Qj9NPi;
	arc=none smtp.remote-ip=209.85.160.174
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4DA606A31D
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 16:40:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E4DA606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=j+Qj9NPi
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5367cc15121so27957941cf.0
        for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 09:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792687230; x=1793292030; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pBCWQ7jscdfKZcHIgslgXKhcbj8ko2Frw+3Y69vYvjU=;
        b=j+Qj9NPiPpWHCMKNtPBbDofKTF5XwrsKuMAKOedAjVMOjUCf8NO86X7zTCZGETZiDF
         5srj5cv7zO/FIjAv2zYpQZeOy6dorIbcNyqOD5IT3GxRpqgfT61F0vJKJfPvKLS8CeQ3
         xTIe01FYexk+DDzYNGLSbWKbsGnUCLNyu19+j6RrF0Fz79CwO2Va85RWJpIen1VkQTDy
         ejrqWfRxG5eVWIcAWA/tT95j2jzkuHzM4iSweHFmCzsR0gND2Dvbzhp2XiaIELugODQj
         uQ3+RM09SiPGWuGqZ9M96Xu0+H99md8qYtixXXx5PO8dk6zbiSKX3Eclgrzv7PJ5nFx3
         TixQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792687230; x=1793292030;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pBCWQ7jscdfKZcHIgslgXKhcbj8ko2Frw+3Y69vYvjU=;
        b=xI7Q5Dto6q9NrDz7XECwOqImWF/ZQLAnz9AHOy5EC24oCL+w4Mz6l4VgyBJd6KexX0
         06XvgxuNbmuLRB7Xv0X4WaJv9lK4Gnm/XERCVbKa9DuSSndhy4PyVQV3v/CPnwwI+sob
         yTz50PiKH+RB7vdXZFu1oZ5jDcOuvKzXQrqRGp0OFetd61Qtzspnbwqokv8niFtBqMwH
         +XVT92PHyKcnakXf1cTVCkyggR/t85TsHzVPv0BH3Qulj9ChgdHAhuxWAIK5Oz3NAnbN
         8mrsZj9KLW+uNmC/NgyH8ms+KJPwkhX81kaeLRxjVYrIFATOQTDoiR8Xj/xcjiKyfc0E
         5YwA==
X-Forwarded-Encrypted: i=1; AKwUvBxU3XCUI+QzYT95V8exc/qqCiPFa6QSQzOJr19rvgZLZSFZlL7bsJu+E4p5c0jEzXw0jdv0zao=@lists.linux.dev
X-Gm-Message-State: AFq9FYJZt8Sb1l5XHAql6W/QlMVLnbelvvl2eDFBbj/qaBeL8/IEbo8V
	BO8IYCyvu1So/+ZD6OJPZiXnEH/Aps0MRYXyKiaz+fo/Kw3Iqbg3NznRImNqYRdoY+Dyg2jtRPN
	/m5u6
X-Gm-Gg: AYBFou0yhQonNtiKevoELNl9fVNrTyjSiPAq87FBQhxROFCoFbu/5g1zT1igME9TGIw
	W9Xlk1VB6Y4pCoxbYUFBKC/FAvE+RjT9AkgkX5LVQirbpRjippUsk3qhCG2VqmwOkR/Yl0q7deN
	KgWOTua7bkeAibqo1jqXNWGQsUQEnol+V1rKrmK1v3qnlWuh34d5Wl21yysq6N4zr2+hQi2Jsto
	HG4idlYUjpsHKI91wqxtK/j+sL3KcQNyPU/VSc2QIaegfXLEbfnRODsvicnXn2hoARg2oJrkPFq
	82cWf1brCF3E3W/VzJ3VQaQAmk9Z5IhETBqJnQPcip7uA+v7ZLm1sM1GblX+TlDRCKy5voKH1Dk
	ubYqtyhvSfsqBnaYI1NVlgrGX97W7YcscipnpC9u2+Bug6UDgL2ziUJIJXFUNd3Nf8J9gL7//RC
	x2iQxA4ijGD5LzEcCaCDbBmQZvp/n7jnu5B2M9OmIGhUDoj6Exs9OvR/Bj8oI4TkG6lZd9x8F/S
	Tfjm/GkZmpraLpddjg9TqBEtto8ITvAHskrVaDCo8UlXF4j2K6Yy9SdxH4/fWoxLgV8dGQ2aRFS
	eiLN+dO0IrJHxB985qEaLjgzBwU=
X-Received: by 2002:a05:620a:4394:b0:93f:38ee:68b9 with SMTP id af79cd13be357-93f6f657640mr3328385a.28.1792687230176;
        Thu, 22 Oct 2026 09:40:30 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56e1db54sm552080985a.36.2026.10.22.09.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 09:40:29 -0700 (PDT)
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
Subject: Re: [PATCH 2/6] daxctl: online whole-device memory atomically when
 available
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org
In-Reply-To: <atlxIz7uZhH9y_ac@aschofie-mobl2.lan>
References: <20261016214248.443247-1-gourry@gourry.net>
 <20261016214248.443247-3-gourry@gourry.net>
 <atlxIz7uZhH9y_ac@aschofie-mobl2.lan>
Date: Thu, 22 Oct 2026 12:40:28 -0400
Message-Id: <179268722868.4072493.14547635108872148543.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-21 19:12 -0700, Alison Schofield wrote:
> On Fri, Oct 16, 2026 at 05:42:44PM -0400, Gregory Price (Meta) wrote:
> > From: Gregory Price <gourry@gourry.net>
> > +	if (param.no_movable)
> > +		target = DAXCTL_KMEM_ONLINE;
> > +	else
> > +		target = DAXCTL_KMEM_ONLINE_MOVABLE;
> > +
> 
> Hi Greg, 
> 
> A couple of things here...
> 
> The atomic --no-movable path uses DAXCTL_KMEM_ONLINE, leaving zone selection
> to the kernel. With memory_hotplug.online_policy=auto-movable, IIUC this could
> place memory in ZONE_MOVABLE despite --no-movable.
> 
> The per-block path checks the resulting zone and fails if it isn't ZONE_NORMAL,
> but the atomic path skips that check.
> 
> Should this use DAXCTL_KMEM_ONLINE_KERNEL instead, or retain DAXCTL_KMEM_ONLINE
> and add the same zone check?
>

I think you are right, let me go test.

> 
> > +	if (state == DAXCTL_KMEM_OFFLINE) {
> > +		/*
> > +		 * Onlining requires 'unplugged'. Don't unplug memory another
> > +		 * agent onlined meanwhile (a small window remains).
> > +		 */
> 
> With this, a "reconfigure-device -m system-ram" may add the memory twice.
> First kmem adds it offline at probe and then daxctl unplugs it and adds it
> back online. If that re-add fails, the device is left unplugged rather than
> offline.
>

This was the intended behavior because otherwise a concurrent
block/state change would end up making the blocks unrecoverable.

> I get that falling back to per-block onlining would reopen the race this
> series is addressing. Could the kernel interface support transitioning
> directly from offline to an online state instead? It seems that would avoid
> both the extra hotplug work and the left-unplugged failure case.
> 

This is an unfortunate wart for backward compatibility sake.  It would
have been preferable to create the dax device without auto-hotplugging
the kmem region (hotplug but offline), but that would break userspace.

I can take another look whether i can get offline->online to work
internally, but this may still require the hotplug work you're concerned
about.

-- 
~Gregory

