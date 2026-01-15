Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68B33624C4
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 17:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498968; cv=none; b=oLddLcu5eiCsgaED1zDkvC9caGTAeFMZIAnd7q9tUFzWMR+VojUBJa4ptk5iGpkSgvbZw78ZB7g+B8GG3R6VtsoIQQDPylFZ2YGhCkcEcyjsdmnfAkm6jUP2Ha9OHL9IZ+4KZVgFV2yEzgO5wfZXlTEbEtz5yY1/2NvMN+fi3IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498968; c=relaxed/simple;
	bh=7rVJtF+bvJULYMq8lpChlQoAbB/f9XjCtTYOiHbBkFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J3JAHEKizVSl1NP2wnAWGwyNOoow4jdGmWjosxxoDYNbyY+Ve2Ew+Yh7pUFl2ORJltZBiJE5qoqCbcAWjP3CCJ0ga/98UhZRPkIQPmaRkn1PMcEqn48Yl9JOUK9eqKf+TAVnAW3vPGCy1PZ9kVrgp6EZKtNNqIS4fnI2HRk1iC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=IWiKImR/; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="IWiKImR/"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8c2c36c10dbso139469885a.2
        for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 09:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768498966; x=1769103766; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qzIg+4sDQXFup5j8N72u0s9znKRCdSZxBT6As8A61p4=;
        b=IWiKImR/bWZjCs1tk+8dhbWQEgApkOjHViLWNNqX3nxB7jDfEoBKid/PBMmpf9z0Gq
         vM8wHzl/fYuqkAJ7bMres1aLOhMrlzvZtqNkabOnKnmGsePnp0rkbpemgwY/FvniR3Iy
         iOFZstHSqYcup4uBUw5k0blPb6Oyd95QAe2XUxPvmAAM3sOcWTOPda/iHQvwYExDA0P8
         phQixmDFtppce4H4Ygvk87j76Nv3KY5DQBDz36bKrjIRJDKQXhkyZtUIViMK6NlNdabc
         QkhtmcQEpowyC/jN7SW2xUF8qXyomuY+bqH7io5GwXTOP7hD8fKX47FbHiuk60JAQM/b
         wNxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768498966; x=1769103766;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qzIg+4sDQXFup5j8N72u0s9znKRCdSZxBT6As8A61p4=;
        b=dk+UM158vr1DyknbrRJFHYZZLYsZNjCEgY/kzQ9oFVubUwAp/TkjJx127HUWMqaXNY
         4+OzPHApSM2/+UnsKfc73Jl2DIKRczkBeVLjM+PvP5tvVG/zBHAimHPgRf2LQTX5mt9L
         rcL9mm+LYmbRcyF6VNLerUYVoSj1kTc/5+QcPOrdC23pWbWCGp5i5qkOQaBtmGA3EG1i
         XFivLnuASHl1suhjfMRSO3v1JMHFgtgTBQ9iO+a6I7EFSPmdUqIpRAJvO8ZZUGCtYELQ
         f48X6hI+Ql15V7f+myDTW8CbZlbfc93hkNZ5PMkHYbaBvA3ZdNmLSzOHw7YTz+x/35VP
         gTkA==
X-Forwarded-Encrypted: i=1; AJvYcCXg9s4ojcUk/y0DrcgZ8vGdDNPJUHuELJRZNYx8nBuujErgKyL+h65bf0ZBWo2P7Fe8Fozk8OQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJ5WuIUgJs9SmAYmo1T5irw84IMqlaCE9dp1oOUpZuQsgRkuAW
	twLeyFuwpdzdtSYEha0cGoChLHkVWU4vhcnFY/FS2pg92+pXFo+mfu25oCqzFMeGUdI=
X-Gm-Gg: AY/fxX57ydWA3qUCjmbFwd3NynyAVfRT4ULf7zBukwbWY/P/vUaLyye092QjbAe6Bv7
	/HXihE28jjd5i86K7tMfSF4DKJf+X4Kvzve/ENJaN5vds8cufPSmfTHmAAkZXQiXTFem3fM4Vdd
	SuPSvCaIIItsWFdR+DEEXrpV4Ww0nCZjxpeinmrZ9Kjh4V/AzBtW3aNe7z9i8uorgafhhU49Sxj
	f1FtVeiZKJAX42My+5rMPwb9kLuWcSCoQsnFcckK2loWd6ohaNPst9fHCGXvQdq+VO6hY/sVn3/
	g8T9mTvWVBTYAa6eDNTE7xEHXSUK1W0IXylBll34CoSMHkSMOnEysKLar5XH8YlW/9oIqIb4GIt
	oCwQlY01iSXJHB9UxrcljkL9X9KUrJEYMOkD9OcFrx5u66Q/cUTaS3MlzOx48ctJ9ciOipRlNxj
	n/X1xrPcqDeQeb2k3Ue61ummLJ6XRQEQLYdIRA9RCviqRK10kG4YXumluFYS20KoA0274sfg==
X-Received: by 2002:a05:620a:6c0d:b0:8b2:e533:66f7 with SMTP id af79cd13be357-8c6a66da89bmr35061185a.10.1768498965430;
        Thu, 15 Jan 2026 09:42:45 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c530bacb43sm463952585a.41.2026.01.15.09.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 09:42:44 -0800 (PST)
Date: Thu, 15 Jan 2026 12:42:11 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH v2 0/5] add runtime hotplug state control
Message-ID: <aWkm8zVc9zy1w3eM@gourry-fedora-PF4VCD3F>
References: <20260114235022.3437787-1-gourry@gourry.net>
 <eb3e6ae9-d296-465f-a5a9-963da4d8ce6a@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb3e6ae9-d296-465f-a5a9-963da4d8ce6a@kernel.org>

On Thu, Jan 15, 2026 at 06:26:21PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/15/26 00:50, Gregory Price wrote:
> > The dax kmem driver currently onlines memory automatically during
> > probe using the system's default online policy but provides no way
> > to control or query the entire region state at runtime.
> > 
> > This series adds a sysfs interface to control DAX kmem memory
> > hotplug state, and refactors the memory_hotplug paths to make it
> > possible for drivers to request an online type at hotplug time.
> 
> Gregory, slow down a bit please. I haven't even had the chance to go through
> your replies on v1.
>

Sorry, i realized your feedback on v1 showed there was just too much
complexity.  I would ignore v1 entirely at this point, this version is
significantly simpler.

> I'm currently on PTO and don't have the full day to review stuff :) And boy
> oh boy, do I have a lot of stuff in my inbox.
>
> Maybe given this is the second time the patch subject is suboptimal is
> another sign to slow down a bit? :P
> 

Apologies, and I will let this one sit.

~Gregory
