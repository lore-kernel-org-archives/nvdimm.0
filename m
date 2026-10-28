Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216708;
	b=A7VRbrNvBqlJb50LvinobZOrfAvz2jkznexJXeHX8OYgEW2095QRZyNBtIGrnfbhvq65
	 9J1hlW4L2ksQbjwq81HzTz9kSxraHMFY+A5zDFXBjJXwYP5zvo9pAjdCEa1SeSqBHX7SW
	 kHwBniInDakvsdOFu0WWBUWpt19XR+MwFQLSTT9VHnLSxoi5uYGzeN1ojdZWl65QDvPIy
	 ldFmIL4QSOngTtwtpu48nW178OwPR+WlDFOqa08m0XZjncYpQxikFM17hLMpLjrreS6ny
	 OvNyyqjFDAywoFmw0c811qvkT7cAOh71CPI45xO4iO0237vW7HGB7gUUJwkSxH+4RHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216708;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id:X-Mailer;
	bh=uHazdlEqe5IFRWvz2i4I2Ak+hY9HZ6HGVO6thNU7tPI=;
	b=CUASNvEUak4BP/wyfGXkYyFmhn4UwwgXgAjBXgj3mQCtSsUaFeExKz7pzo6Br1ysSCcP
	 QUCn01H/q2O8Jmqvil/b0qFTFsHV9NU7yO+FAT/TLk/up5vjCaUjAJ+T/AwrmkrD08Ik5
	 FHCgkzaK75k9XYMFXBdy79I4G+ELaxr0RtPL/HPGVutOJ8t/8MchJwq2hea9cLuZVPOQm
	 R+mYR6UhDncJDd9wVs+1gaa38kicyNFSlAGPPPW0eUr9Bh3z4ahLw9DWU53E42GOQ89wm
	 6s6tHvLFEZlxoKmtI4UEPrdPXh6X0jO6qfCT9pVL/yu+aRVtSxZiJzNoxEYb+1+8g3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=QEd7vhwj;
	arc=none smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F75606A31D
	for <nvdimm@lists.linux.dev>; Wed, 28 Oct 2026 19:45:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62F75606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=QEd7vhwj
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c43373ae89aso213217366b.3
        for <nvdimm@lists.linux.dev>; Wed, 28 Oct 2026 12:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793216706; x=1793821506; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uHazdlEqe5IFRWvz2i4I2Ak+hY9HZ6HGVO6thNU7tPI=;
        b=QEd7vhwjbIMcYuFM6vf9CuDtn+ug/HtB2QJYSvA5cNLGtvm+1FhORuLdEcYM/lrYNw
         CJ9/nG0qVuVTjU+NuQKhVGXo9EXMXalPNjgZnq3+u743C/A6Xbbt/y4vMFlMZk+vIk8a
         LQKVbZkKot1bAYEgZD6Pxxyb/O8Ya/7xrHaWQp7WxQlbGbawrbIju7mqyq0AwY2tZQhw
         7lJD2dDfHDila2HCcKNLdm5t/M/0lxzZGjC5DjchvBzcIsDDt2/Y+PCUzqZks/iCLl21
         VVtIb91PLtrhrjBIdcznPGYfTWyBbkDyTUcdJcnASlXsKLh+vCub3LihvPA/0XhVFOYo
         WByw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793216706; x=1793821506;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uHazdlEqe5IFRWvz2i4I2Ak+hY9HZ6HGVO6thNU7tPI=;
        b=HyWw9lvoTNL2emW1b4ooMaai8Rs90MNa1T/iBRPxKlwngMfCWXg55DqdUY36bSXY6E
         JkmZuE7nhDVThSTmlxCWNynWfNpuof8+avFAbi3B+AsT9YJRVTwvfhV6jYKFpTVXjQQV
         HCXPr0E2om8zTiCE8GOmXoMSG8djM/fxazhgyqBBxgIZaOJ2iQ8135k2rxAOXRVSone7
         BHB1BRge5lKfPZtGH2kVl9n6ZNWaD6Poi7XFbvfk1wv3ZOrkIZgP3Hr9F1JFqnaQI5OH
         FshtsPjPm6lU/SisyaJoXQJZmKXZz7wSI2FJC8RL2G4jUu5haO4m4dWrRONV/KVhYKvU
         OqNQ==
X-Gm-Message-State: AFq9FYLIoHyiEH6J9oZKaWCIZDu68zaYLs2vw4LJ8AqmmjXp+FX+wDYK
	Awf/P8pXpZSh83ai5aVkmujUDTsVeKC1VMMzUsFtg7BPM90XySvOUbzSoeKTuEn5h4U=
X-Gm-Gg: AYBFou15gDcOYW2BB/Z5Lgld5LQHH4PGUm3ivB67VOSHgeuKl/9XFlcE3feMeivg+Hg
	q3Nb9ycZTUzxWtYTJJe63VM4DTGzdOXjtiAkJ+VLIFmsoytkB9k2u1Z5x4fjbwA1ZNwkXxCg/ej
	TISr+vOIwFutKqJ22IvMy3aaxCdNBTN+8M2aMKEOHzlMAT1vvc9TtAhxCHcrcl8TTN7sj+3Uk2b
	fPSbe0+6QlhVTiYUfHKDs2NMMDc6ixWMrxV16FpdBvp7RldSfSe/hpbd6NMsobJDLHvTx1bh9T7
	cOcWPfSDz92zrCrKlIYTEutpmDncVCxvGQ/8Qa2M12bc2HnvpVwu26qdXNvb/7vVVCJwUJCwk5h
	6BrsnDCXu2dIaZfuQ8WvLOW0O26O7P2GzcGxOpwXFULf+BvOnhufSIeNOXk6jjhdlK3ipG6gGsB
	JgRN6W87y8SR1sh1KtGh1g6DdVi/K8HWpUzll7jKl8QIU9npxZf805NzClso8mtpsw1k+Gs7uSr
	Y4bvSy1gGpS/lpUqXGGVzez3VCy0nmEW2HrqxzedxbFMSxcV4Q53PzOuiEyW+dq60ha39n5OoEr
	w1mwh91qoxsIhQhramP1Mg==
X-Received: by 2002:a17:907:2dab:b0:c48:ddac:7eb1 with SMTP id a640c23a62f3a-c49be042430mr290009866b.45.1793216705514;
        Wed, 28 Oct 2026 12:45:05 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff:4c::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd66bd3asm646335266b.56.2026.10.28.12.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 12:45:05 -0700 (PDT)
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
Subject: Re: [ndctl PATCH 4/4] test/daxctl-create.sh: count memory blocks
 across dax mappings
From: Gregory Price <gourry@gourry.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, Gregory Price <gourry@gourry.net>, 
 linux-cxl@vger.kernel.org
In-Reply-To: <55162d83dfab6101fca10df09b6baacac1834b17.1792695259.git.alison.schofield@intel.com>
References: <cover.1792695259.git.alison.schofield@intel.com>
 <55162d83dfab6101fca10df09b6baacac1834b17.1792695259.git.alison.schofield@intel.com>
Date: Wed, 28 Oct 2026 12:45:03 -0700
Message-Id: <179321670319.1001257.10248433152118734594.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-22 12:56 -0700, Alison Schofield wrote:
> Existing tests use single-range devices and cannot detect incorrect memory
> block accounting across discontiguous mappings. A two-range device exposed
> this bug by reporting only one of its two blocks.
> 
> Create a device with two separated mappings and verify its memory block
> count against the expected count from both mappings.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

I think this misses an over-count scenario:

   A=dax0.1   create 512M
   B=dax0.2   create 512M
              destroy A
   C=dax0.1   create 1G  -> hole before B + space after B

140...15ff...  dax0.1
160...17ff...  dax0.2
180...19ff...  dax0.1

Not sure if you want to extend the test to add that or not, or if it's
out of scope.  But the test as-written otherwise seems ok.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price (Meta) <gourry@gourry.net>
