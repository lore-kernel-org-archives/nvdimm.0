Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792720102;
	b=qqXT13p/fDFKYd2di3238xM0jIHPFsRuEwpePQDMt+lfAa7a+ICTOKmx2L8ZPuikOH9Z
	 5miNRLkpC4KFbck6OsEqBiW/HdH9SRxgyLImBcaPyRHrQdLQwJkXIkrEj0aMKMvxIlWUg
	 v9iafX8WXczbBaI2t0sa+qP6GgmfCwezRW77RDDmhT1oZpSYVRBFOgm5lbCJHnYAJCGdg
	 bxxwiD/71JmBnu5NhnoO5LZYWF6Sp9cz/qjszSQ8LfEuEDUm8Wnz55f7FQ7AzhQpXPzvN
	 wK9SzJ/hzvAM1lCOm4lVxabGKtw1husY6zEq1CU1IRLVx1CA1M5CADGTSPCaj3ks53A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792720102;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=83wWFvyslHeXKdJBa6hq+X7wIniIzuYJyFQhzC6bhJI=;
	b=2oWkNGMW0ESOlzb5wsP/EJJPgnxYge2Kzl4UrFRPiWThvu/FzSUh5EnFA5xhchTFx4yZ
	 oAm9E/YxYgz7S0F8+l1JHynf4IM761+M7TN1Zct6ge5BNiYDxZeqpXC1x7tDKq/KYJ1Xi
	 VmYwcNup8D8d85UMr/vmG4+IZUlriyv0cl8mym1hProTe/MDjIcO04OfgwvlaHcFiEWNZ
	 QSGcwM6I3jGGh2Wxc2/mw8jGqofdbBpcZllzxfKAbcXdd/Qrkx5dzY2UjGfyK5w8JiEbf
	 Eqx7/1hZ8HT3iC3fiXCiXmzH+msm/bEsCigiTDNneCkW0METp38u/SjJnOC8x8/mvCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=VxcZf+BW;
	arc=none smtp.remote-ip=209.85.219.48
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB1B606A31B
	for <nvdimm@lists.linux.dev>; Fri, 23 Oct 2026 01:48:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1CB1B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=VxcZf+BW
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-91791ec1b83so3886996d6.1
        for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 18:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792720100; x=1793324900; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=83wWFvyslHeXKdJBa6hq+X7wIniIzuYJyFQhzC6bhJI=;
        b=VxcZf+BWHAD6+jj4XOOmrVvzMHN75kHZ9+YLprd6iCBWx++0rOqzoqV7x1jrY4BhXn
         Yg+stmOgQO8YyH3GXgRO1/MQp6WHRuUYt4IboNpBYSLN6Qv0a8svgqx87UFg8FutUtC2
         QdtbkICVZ6sfccnflRvqmTy89kRdwRA27rXZYSG0MZHoxjYmEWsF8423Is8gKrQZblx6
         qVitznGN5RbhjBk9PjDOCLRTEI31l2Tng3Ie1e4eLHWjkraJ1Dk5s1kkUDsSuyfd1kZ1
         n5n8SCim60xdDS1iMSshxw3HQDAB+buH1tPlTnkloFerZbH6XYIEhLMUDxbji6rNHOwW
         4CBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792720100; x=1793324900;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=83wWFvyslHeXKdJBa6hq+X7wIniIzuYJyFQhzC6bhJI=;
        b=tJPl/Q15siHOsyhhHwggHlD/d6UYKFQR+7bE1itnYRQhr1mmlJCzrj+2noGoivNbCS
         mf93PPQeTNVBzfrimDhoABxepG3S3Wlv7nVljk3nfl4NdfNTjf/XnVTZP78ieaWiiWXG
         H1bW+1H/leoVxLts6VsByLSrMxJDrDACvI1fYOINqafvfBHzXvCxKFzh3fffa0uXWfd/
         64eA+Lt6A2W7KbY9rpBJGnfWtPUstBI0ZKoTKsy9xTBtTqqyBm/6YqhLjUYDutdxcpdw
         3gqFZmSTMkJeJ2mY5CCHym1arNHGTr6MNujYPQAfQOnSEZD2kJQty8ZjMEkjYlhLcUQu
         i+Xw==
X-Forwarded-Encrypted: i=1; AKwUvBxWyZIA/pc/uXP4lg6wAIDdcNHZwXXHG9HElvWI2oxuzRZCll3ZgWM+IV6wBsrRDRlwAZNRTAc=@lists.linux.dev
X-Gm-Message-State: AFq9FYKFwMBC4mAEcTIHmbivUVd5TkmrRgvsTlfYj7aWrnD1ENRvzXfU
	0S7rS73crE6gM7I8KM7Mj5MmdGq6Uyg3w6r3dJhw7YDGdiFsZ7cPs0UmUP1moXT9x78=
X-Gm-Gg: AYBFou2ndxvUr9U8KdlbHW0ZkSUznH4e0gaXm9SMTLjpd00jYq0p9h6jIgIjqYVVsw+
	k30wagudnRnL4+qARdZ/Fl6aSSyjExUbGXFmG0wDxzhlVbt2LMN0LxSTMzd4TydWIx3C9JDmuH5
	vBW33p1CCDUEFCpoJRSRQRWSNa/hoM7di0A0BSMA+wKsFqY94d75wB8xvmBtLG+DBY+tlqwxp8e
	LAnMEo4HNoVBq2LD86lVc2bDgEI205EOv+Qlmvjzlz71ciFEU19qbqt5tZwtI9PPI+VPh+G+qUz
	VDnii5l4Xoj7+xs9wWC+X+Pl/vCArVgXacIHF8nw7uwdfKHxjqO3WZPvj+ZYa2mYJooJbEEQ0UT
	PS14tJ/+LiMDMswiw1Ke8aeQUjL8YCMaN248h8lkTwBE4l8sot3UecDk6Kk2q64zEQs1TFojQt7
	1LLW9F/8r//YzPI3XPRcO5p7xBKXONJT5d+BjzSlFzx48VAm5VpLO5KLmuKr4MeVReROTI5Qwup
	A2HU6QC2jCms8yLQK/f14KFbNn87SNTqnvbfsiSRMGYyJ/wtNYgOZFrKdUu4RNFJs06KoBM6JiZ
	ibvtrlQPmTs9QRgwNK8qM6Efwd8=
X-Received: by 2002:a05:620a:284a:b0:93a:2611:270f with SMTP id af79cd13be357-93f6f907c65mr207694785a.13.1792720099877;
        Thu, 22 Oct 2026 18:48:19 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c396e3662sm7533396d6.20.2026.10.22.18.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 18:48:19 -0700 (PDT)
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
Subject: Re: [PATCH 3/6] daxctl: offline whole-device memory via atomic
 unplug when available
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org
In-Reply-To: <atqHe2AK6Tka4t6f@aschofie-mobl2.lan>
References: <20261016214248.443247-1-gourry@gourry.net>
 <20261016214248.443247-4-gourry@gourry.net>
 <atly9gd-Rsf-AoqB@aschofie-mobl2.lan>
 <179268760050.4072493.10054383256417425305.b4-reply@b4>
 <atqHe2AK6Tka4t6f@aschofie-mobl2.lan>
Date: Thu, 22 Oct 2026 21:48:18 -0400
Message-Id: <179272009864.802238.3707618429496053322.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-22 15:00 -0700, Alison Schofield wrote:
> On Thu, Oct 22, 2026 at 12:46:40PM -0400, Gregory Price (Meta) wrote:
> > On 2026-10-21 19:20 -0700, Alison Schofield wrote:
> > > On Fri, Oct 16, 2026 at 05:42:45PM -0400, Gregory Price (Meta) wrote:
> > The only scenario I could come up with is having two versions of daxctl
> > fight with each other (old - no awareness of dax/state, new - uses
> > dax/state) but is this a real concern?
> 
> My concern isn't about 2 version of daxctl fighting. It's about
> preserving the documented behavior for "daxctl offline-memory". And just
> generally, if there is no need to change it, rather not change it.
> 
> From the daxctl offline-memory man page:
> If all blocks were already offline, print a message and return success
> without actually doing anything.
> 
> It seems the benefit of atomic unplug is w "daxctl reconfigure-device"
> path where memory needs to be removed before unbinding dax_kmem. Could
> we limit atomic unplug to that path?
> 
> To be clear, I don't know if that (limiting) is doable and I also don't
> know if any current user would care either way. I'm just defending the
> documentated behavior (FWIW).
> 

hm, maybe instead:

daxctl offline-memory      - stays exactly as-is
daxctl unplug-memory       - does the unplug
daxctl reconfigure-device  - converts to unplug-memory under the hood

userland that is suffering from these races can update their scripts
from offline-memory to unplug-memory, but if they're getting it from
reconfigure-device, they get it for free.

Unfortunately this is the painful result of `offline` having been the
default hotplug state when dax/kmem gets probed, instead of `unplugged`.
So we're a bit stuck with the `offline -> unplugged -> online` pattern.

The intent here was to try to get drivers creating dax/kmem to actively
set a default and effectively deprecate the global hotplug auto-online
setting (because a single auto-online setting for all devices does not
make much sense).

I intended to follow up the series with a CXL build parameter that lets
a system owner set the default, but omit "offline" and instead make them
choose between unplugged and some form of online.

I think that resolves the daxctl problem entirely more or less?

-- 
~Gregory

