Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793218341;
	b=WuA0jJnveBiAb0YSNyaKk4fRF0DWxZ/nQKQXrZHKSgYVhDxHjPPHPk8XKB4gtOuz5DYh
	 d4yWaTT4Lcjo/tRu5tMnI3TaABsXKQT33LTwb/kEhrot2I6E76lFZWG8yydvgotaMpUUm
	 tzlw89uMTrcJlDnPomX20JHoBEUIoiz2mi/2hnGjj2hMZpjz6PuiQQM8fKYLtCFNECrwW
	 8Msc5mxCXBUygXo21sTAPRdWlHftzvWCjUjW7ALjI8ql24GZUuZK2NQaCYvV6EjGcxE5o
	 mMWu9IPrtLpWCIpXZHDeilwy7/MdOkfgaXfn9QNyv3dlFNOnxuH9g7S5cMTNZt97zrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793218341;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id:X-Mailer;
	bh=bWRDA7A93lkdLQaskfQTKjWU2/DcAc6lekVUUxDbWlg=;
	b=kVvENP69amBf7b2o0abOGaPu17X7bIpb3HtsnX27Hd2VYvqNHAgF8cT2bi/BSVXSOegd
	 /E83uJnRR9H7o72wKUGnyNHFDqV1ku1maWLPdTXpZ/4eoYbgzHefP3rdRD72FS7WeUML4
	 JhdfP9wtgRmQt8p6DffUGGneuKJzNooWspEzqzt0+KfwtbBp8//D+bNs9PtG1THc2yAE5
	 Bx5FSymg/QbVDtx/4in6iDUVj2nMbuKLud7kxiNtKUTzObrapl0ulM7tT+yyBZKJ9D+um
	 Q5Iqvaq3/HRaNdQ0wr1aSBPdgXxv6t2r8ZoUJOeowJIZQFsng0KryM9jXcKNG2Nr+Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=VFBjcQlL;
	arc=none smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7658D606A31D
	for <nvdimm@lists.linux.dev>; Wed, 28 Oct 2026 20:12:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7658D606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=VFBjcQlL
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b3dd83e779so2752972a12.1
        for <nvdimm@lists.linux.dev>; Wed, 28 Oct 2026 13:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793218339; x=1793823139; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bWRDA7A93lkdLQaskfQTKjWU2/DcAc6lekVUUxDbWlg=;
        b=VFBjcQlL+3onVd5QAA94ELIE+Cs38J8B4i9Qq/rg5I6fj4HeVAe6n42DKpJqzpokqk
         5L3M7/wSCzBB25QZm73609QZbgzleg+s0P1Z27Mcj4vOTFtJtNCtGx4eAigHYUrgTS6l
         IobEgCNpnNpUlvnycQei9Jv2tTRhbG9DB/Q90KYqQ3ZKEU+TzqE6ND2El0NFWK82QxRI
         Rtei8DuFUhGOqqyszDYvRRmCFdIklvaXqXJyS7q8f9dVYKxaXTzbXXPMjPTvJW12Hxlr
         ubEy2nBEUZ35wYXeR6Df134uPV6KzdQLt27VYbEyIh4gRHbEqV5qjX0Pc7LpLCbTss2l
         yQ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793218339; x=1793823139;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bWRDA7A93lkdLQaskfQTKjWU2/DcAc6lekVUUxDbWlg=;
        b=J4OFP9LcDWK6FldChB1CTxAVWq3bhUPgWjkG75IWt5lrFE+vZ38nY5wlpiDk7XDkMZ
         ehlR/qjlQt0zEmmpvyJBmOONUudX0Xtc1ihnhYABVhE4Eu5DHvHC0IZ/0s4prgAeMi8a
         qiSl2MAx4SzEQ2105+saBJ+2n+Ki6ZhOcpS+8tsom+4CTAGwug7VDoQG/0UKJaqo4aZw
         JrKdJLctDM/wRArXH7kKCAgw+HmG1a0NvpGz5SjA40ErIoOp1KYq++xBYhOs+oE7Cvts
         5HDdt5xXhAbBuLqDhuI/S56uAmem1B3LjwpRmdARUv2MhQcJLxnqpH2yuYQxGKREEsaA
         mngw==
X-Gm-Message-State: AFq9FYL7w/GSItwSDAZZYKqLhq8K530yLvMKGliNuji8Zp0Po8uUAFxx
	/oJtBDE+6pk+C9XjSmzz4jVo5Dy0I7Fee3jPrcw9u6tvi4Ub6a3Z1pJGlbHrqtYZ0rg=
X-Gm-Gg: AYBFou3ZozVlH/SpYDNDfpflP8/Q4QOKsB5hrrYRLVuozDrHAfBReK1MmW6GCa2BX5s
	o7DHCsImv/OXdPNIrFvZTyIaHUTBP+L3P5mFhwMjQB4zCkzUPKMRy1bjiJqpX+aRywZMxyJ130B
	Unbz3iYDrmS6AnS3n65phAM3xd2mZhjwJBV/GWbGwxI0YMNXzkhfjjzy2DDJcCAYN2RISvkiWqA
	dj0wmI4EIGhfpsifICrXoeY++yOwyM3rYfLPZREyFLlKvvYvuI/4PF48PxIuSM+tzqLBq9nwJEX
	i0/4DsIg7AKaVYW/4AStTaZqu+NmvftwUpzt8q+cTNs5IYh80rjUTSoZHEBlGtk46f/gZj/UYoy
	OKuJTk2FyfOaOaFZdG82Nx8x/NMQNymnHOB/MZ0+SW2B6vRPsBzel2PZf7GMarzao/evCwZr5aF
	M3DPNaaJzdCiac+eUsBWI0pVaBLUf7x6wtvI0wScZzxn6uHAvvT+KgYJdGR1pAOqbJK9GVdSl4T
	iwaT6P+AadcRI210MH0CZt2zTutWgwtS5vQod9kLBQWDFyvhZyKXt70X+0sqG+v6LLdHyWN0R8n
	0ardWU7xhxF5h9yO/02n8HTHAuVJ97sTSDU7Hr00Hw==
X-Received: by 2002:a17:906:ee8b:b0:c29:659e:2fd2 with SMTP id a640c23a62f3a-c49bdf309a0mr272007966b.27.1793218338561;
        Wed, 28 Oct 2026 13:12:18 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff:4e::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c49a4e2401bsm331870166b.84.2026.10.28.13.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 13:12:18 -0700 (PDT)
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
Subject: Re: [ndctl PATCH 2/4] libdaxctl: tie mapping cache lifetime to the
 device
From: Gregory Price <gourry@gourry.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, Gregory Price <gourry@gourry.net>, 
 linux-cxl@vger.kernel.org
In-Reply-To: <6b3b42e253c4aca3f4c080d0a7698a09ef24465e.1792695259.git.alison.schofield@intel.com>
References: <cover.1792695259.git.alison.schofield@intel.com>
 <6b3b42e253c4aca3f4c080d0a7698a09ef24465e.1792695259.git.alison.schofield@intel.com>
Date: Wed, 28 Oct 2026 13:12:17 -0700
Message-Id: <179321833706.1001257.465249667653833159.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-22 12:56 -0700, Alison Schofield wrote:
> Cached mappings are not freed when a device is destroyed or invalidated
> when its ranges change. This leaks memory and can leave callers using
> obsolete physical address ranges, potentially operating on memory blocks
> that no longer belong to the device.
> 
> Free mappings on device destruction and invalidate the cache when device
> ranges may have changed.
> 
> Fixes: 5a31bf710399 ("libdaxctl: add mapping iterator APIs")
> Fixes: 52a2653098a5 ("libdaxctl: add daxctl_dev_set_mapping()")
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Looks right to me.  I'm a little light on the lifetime details for
the cached mappings, but i couldn't find any obvious issues.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price (Meta) <gourry@gourry.net>
