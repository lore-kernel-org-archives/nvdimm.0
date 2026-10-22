Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792687754;
	b=lSe/Soa3Aa25hWNfn86gan76ClJXD+iw889ZOBBBnf3kygX/Ftn7Q7srDzib5xGeEBDv
	 YDAnn3SuuCScFsOnPK2vDWTMmsCkJTzw5vwgy+8NJ6bzCTG9In9AEYuQhRy2ESU1DeOFL
	 uXtrWqikA6//eCuTAgP2+vee+IkpIoIwa645oLITQDESIcAoH28zrAdJfImMdLzn4ucoN
	 RCN7oFqof51iew1bwGQxu1rUa+Hdq9UaC4BMZu8+GvPgdoXkMvazuiw89mVQi1fGWB0w2
	 X+mE8QxUrD1InUyVMXut/Shh8gzmMqTLvMypB5V1YZMKWAsNOGvqNNyeKlLleTtlNWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792687754;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=awSiD3BNPmvugsib7uxM0TSdgkvyo47qanCTaG8r0Rc=;
	b=I4ApT5F7x7h/XaySe+bKqTKZtC93B8Jc2re7VvWdiBaeefKdiPJbiwN6FlyGqoxE/Dp2
	 K9UvuPLZ0YvbJjzl8xHkAQptSdP1gX5On4Ttnn7QKF+ibOIkaxgj68tEg8Hexj55V4pNB
	 SC9OQe0zPtFNGNUKnqq6UUTvsQJI2dVV+1nb77iZVxtFK4YghXpYR/cJD/VCprfPk2vrP
	 IRNwyOtLkcUvqsuZwtflAg6YNqAUv59LOiVpqxsem1EDZbBraL0yHsVKbQ3VSuPs9d3JH
	 xBraVv+IoCZphbwh80hdcFcJwiWhcS3F0WIoM8upg2FQio0MhNPITBUY9E1GIjz86Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=riSjgT4Q;
	arc=none smtp.remote-ip=209.85.222.178
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DFE606A31A
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 16:49:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4DFE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=riSjgT4Q
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93e64d52949so180439085a.1
        for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 09:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792687753; x=1793292553; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=awSiD3BNPmvugsib7uxM0TSdgkvyo47qanCTaG8r0Rc=;
        b=riSjgT4Q7XdbU5BUkdUOdGillotkuRem0GZdaFuhANRwd5Qlts0KRlwS73UQq59eNH
         dOnFqwu0ZTFQ8J50Bz7GOU2Kxgp/OqIu3Lz+JiXjHjD1y+Cb1M6ZZoGUK8z92C+V9qgP
         vUB0u+Yz4h8ZuoFBEpNm4PL67eqdsgf2rGmvk5KzsMqXU9jw+pwv+CfLM8y79Sr58lM3
         ovRWVVaNRJgC/V59fH8Dv/Omz9621D2illAULwKaOk0HUlMSFSqc04666N7siuVfObIa
         7/aWVJm0QTmCAd5b6COYtEyqleQpHibi8ErgcG+KaZQWaDook0x+ZuGb7deqMWaeK5aX
         Q15Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792687753; x=1793292553;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=awSiD3BNPmvugsib7uxM0TSdgkvyo47qanCTaG8r0Rc=;
        b=jy7BuHl6Q8VNs8a+QnkLW1Z83uet+ehXwle1I2AqErQDvVZLOIqIeBGhJ9/W9hAcJH
         A3zYUTQG8VjyaAxUCbvj26kL91Wy5CrXEXRVE5j98U60WekRxZc8I0QfjuDN3TUNu8ON
         79Cn8iYfUPsLVA4lwkKaUNjJbrGN3SEhWVi5pHU8VhI2Ev7mP0DK+j97kMYurVcyupM0
         cKwp5Dku9kP1HgVJJiwimw6IaeabYEWM0r4hBZjzEbJ9FwAO6YbWTctGMqCQDqQCsoF6
         qZuYnT/MZ7OSjEEvtV9vFFq7cUzGqGk6sjYxmuPBgx07BLi99WdhSvR+QMeZmrP5kkqg
         HfLQ==
X-Forwarded-Encrypted: i=1; AKwUvBwY5N3TYhj8UdN1OnNJOwVATiofIvGvodrxyIAKKD/pI3MfqS8pe9WwstsLE7IvXTDXxX4r/4o=@lists.linux.dev
X-Gm-Message-State: AFq9FYISVg4jHDenXi/qFrBF/7pHd45DXy25zjlO14SWOY/wfK2i7Xxr
	B9Q2oUQ2juI1rQ26BJ9jkLh8pyrSW0w2TDsmrGruvWHZamSbjj21E6wVIlpfakdGGhk9/N7ACmH
	uIH1C
X-Gm-Gg: AYBFou153sUekndPNG1Fn/TtXqEcR4j7B68PNbw0NuYLkcYWGJqseaixWIDYpcCCcYS
	qdTaEHWc5l0gmRmP10WgVzefJzjb5NGU+Vh3BW7zoWr0nxx+fKsIFmz4/JeSE+nlW7U0VXG+jZD
	hfUdCdN5StTS5PfU6P6ofIEb+5U7ygCc7kXCraasdhEmSuvP0TKbiuP4ukaJ3QRnyP5K9ZHFCqW
	NcNZXCyG/Dh40R7R94TjUio1o9koonkYsvcGtsCpsio72T0oV4cxX8fOzIk7j5r+6myiRMy9zgl
	I1C0lfEMMuHLhXVrcjBnF8Z4nbVEvYZjf//X/rTkQDKWG1YKVsd+JFfKMDhZgwC25OVfqxMVM/c
	7W05ixk0XD1MB6Js3U4a+O/f4PTtJZNhtsJKue18HM5HcovRhCFGOSuG/+iZhsqjcOfT6MpOf0Y
	fA6j0tLkIjcBMFif7jzSXRMVJicbvK9icVAtjDpRribLi23diKGEwIF0lXPStTSdwnE4tJ4yYFW
	OBUwRJi2Hdjr1IP9u8WmiyxyV0gG5WNtJLYe7g/zYTfzRMWOAqVcerjEMVzT1e/EFF/q2RCvx26
	aiwxsycFs86HXOyoD9jnxrZNV28=
X-Received: by 2002:a05:620a:450b:b0:93f:1823:308f with SMTP id af79cd13be357-93f6f87bdffmr2749585a.81.1792687752774;
        Thu, 22 Oct 2026 09:49:12 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56e0b402sm560253585a.33.2026.10.22.09.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 09:49:12 -0700 (PDT)
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
Subject: Re: [PATCH 6/6] test/daxctl-devices.sh: cycle offline/online to
 cover unplug and replug
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org
In-Reply-To: <atl2HyXaNB6-6j8f@aschofie-mobl2.lan>
References: <20261016214248.443247-1-gourry@gourry.net>
 <20261016214248.443247-7-gourry@gourry.net>
 <atl2HyXaNB6-6j8f@aschofie-mobl2.lan>
Date: Thu, 22 Oct 2026 12:49:11 -0400
Message-Id: <179268775162.4072493.12508126317533540624.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-21 19:34 -0700, Alison Schofield wrote:
> On Fri, Oct 16, 2026 at 05:42:48PM -0400, Gregory Price (Meta) wrote:
> > From: Gregory Price <gourry@gourry.net>
> > 
> > Repeat the online/offline pair to cover onlining from 'unplugged', and
> > check that offline-memory unplugs an already offline device. After each
> > step, check block counts and, where present, daxX.Y/state and the
> > 'hotplug_state' reported by 'daxctl list'.
> 
> Hi Greg,
> 
> Please change how the tests handle the absence of the new sysfs attribute.
> If a test expects the new interface, a missing attribute should cause
> the test to fail, with a clear error message. We have had problems in
> the past with tests silently not executing letting defects go undetected.
> 

ack

> Note that we don't require backward compatibility for the unit tests.
> The utilities must continue working with older kernels, but tests for new
> functionality should fail loudly when that functionality is missing.
> (I'm aware that not all tests follow that guideline, and they need fixing.)
> 

this is slightly confusing, but noted.  I would have expected the tests
to test backward compatibility.  But ack.

> Please also leave the existing test cases as they were and run the new
> state-dependent cases last.
> 

ack.

> A few stale state cases would exercise daxctl behavior that the kernel
> selftest can't cover - 
> 
>   - Offline one memory block out-of-band, verify that daxctl list
>     reports hotplug_state "inconsistent", then verify that
>     offline-memory still leaves the device unplugged with its blocks
>     removed.
> 
>   - Offline all blocks out-of-band, then verify that
>     "reconfigure-device -m devdax" succeeds and the blocks are removed.
> 
>   - With all blocks offline but the device state still reporting
>     online, verify that online-memory falls back to the per-block path
>     and brings everything online.
> 

good idea.

> For "blocks removed", please check that the device's memory blocks
> are gone from /sys/devices/system/memory.  ie verify in sysfs directly
> independent of the libdaxctl code being tested.
> 

ack

> About multi-range devices-
> 
> I found that libdaxctl undercounts memory blocks on multi-range devices.
> I'm posting a separate fix and test for that. Nothing in this series needs
> to change. I'll cc you for review.
> 

ack

> Our ndctl emulation can't exercise multi-range hotplug, but the kernel
> selftest can run against a real multi-range device. Could you add coverage
> there, including the partial-add case where the kernel reports success
> even though not all ranges were added?
> 

ack.

Thanks Alison!

-- 
~Gregory

