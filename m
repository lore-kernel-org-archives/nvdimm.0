Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE2E30C37E
	for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 20:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774124808; cv=none; b=o07KEjJdQPJtGoJbsPnDYoHwowobw46Eg4ZZGvMIcXlsHCgEcw+S2L8U98bKFjvagP5bo2tBet27AMQt7PQS2ayPX3tsQ5fvTZO4hCyUMIQkiTkt41nGINdoHgFShJoeCSw2EKrM70PZBA4qNiGevYYdIU3d6uKiBO2fkGZrSXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774124808; c=relaxed/simple;
	bh=0o7bVmmzRFp2N7/OlVNvlYnXrmD3xdgI8R7r+xdEOBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gpxsQqF2cQ9v6KgaF7kYujwkWPbZKcQsyFe+2QLPr0tB2OlAlE/NjFDabihKyE+QsKH8lcSkJ6cnDGGL6aQ7E6RS7CuBrktUmc/hf2hJyM4TaNaxVtRjScF6iF1BiPFSH8wn6vtKjR67S60hmkcNTlijkKFEgtelhHEOfeilaYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=aBbcfKlI; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="aBbcfKlI"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cb4136d865so212732985a.1
        for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 13:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774124806; x=1774729606; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0tEq3kR663AZN+wJIQdRtj/jb9LMYPMsRdvJZPaBgUg=;
        b=aBbcfKlIOy3UZS1CKir1vcqa+DDUCHgxvE9c0ZhHo+wzWNl2OsiJyoMC8X+WdHqq6u
         Yn9jTVVrkjFRg4KKTkNObyZOkfdHysNj82k7aBldYpPn4TChv4s/eRXZmLpirZlptvE4
         iyjLhz+5ZYrfvFxcFv9KlpJlYNXn7s/lR2pPjtqpQ48hcU8VgBwnXzRJtoXAui/Obcdl
         FbB5zmatKIXlTou9ycJRrn9yOUiIDqLUO0GRRzpfErTvativlc+i3pdoxrpSHSfk7I0w
         2QwjFpHukgPBXCrR5joMryVDjR+JA4zUpLG5kAElX1rbou/8FZQ4ek/86TYQeZkItjKH
         MEeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774124806; x=1774729606;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0tEq3kR663AZN+wJIQdRtj/jb9LMYPMsRdvJZPaBgUg=;
        b=TaxNZ5zoTzSoRhVnrVvtvjCNR1GA3iThKt5NotqhDnexWSf4J0fN8o5/967Iwb5Xm4
         7MwArgjsOcr5/Uz4weIJHoBAbMBWG3ZydQl73wBQKIEx7ltUcICVQyIpR2DiKLMvW+wv
         kEmr/3YNpS8bYgErZaMHpyUsU9JJ3Llc2VdV7j0jT2mQT9Cc8t8vTjhIgMbcH4bIJwc2
         NzKHR54B4q4wg6fNw0VP8pzVoEScYgw9FZPVawoDB4AeAOmvBFjZGWCdrvH3JnNtLgo9
         mP86FQKtCLEHIN6Hb7yK8VA+VbKh7tRP5F06N1FzrgEbhOUsGTe+bDtRORCTsP9y6tUe
         wHoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhUMslE0OjESUAl0iD1jtfO+dXzhhK1qwCSGRj6+9PO0sdETQqyXyfHRuqU27EzIC/a/0l4FU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxknmxuwD9Zlrug1YJXhN3S6hEgLbUUogCAjTIWBsVY0uWYGb7M
	kWlXap0dtaFHIixT7HI9YrDi7wrgm0ot07JrnAY/j+tFirpcniBr09QiSInh042tYh0=
X-Gm-Gg: ATEYQzwnX95PCerQMqEipFCDU1gkVLf8+WcWtnlnFrhreXJiCfsj4LJ8ez6OX6f+XeC
	UsqvO/fd+aa306bfMMGMT6nX62RTCjiGQaOPR7br91WThizsN4/j31fEFwJMUdHmoVRNKqR/bwE
	KckdiPXeX+Vmw2hmIVhkExaLvgT/unasLVd0hLUp/mBbaWHN0JMG0j3pAZv/AVJMYaNSdxSP7eW
	kmu7JUHWkBw6OsYblRrFN5fh+SNCpib68pmS3av+GthQoXLurtyeMpPt0lwYVv4VSZd1naCNUUS
	AImUUue/H3qXi2rga+1S6c/Uc8jN4XN6vl4/Lzbk2hls48oOc8l6Mi+TmFLnN5ooL7Y5n5ml0Sj
	Nlbrwb0CK4lwUBPlQml1TsmczIFVI0POjES05A7r1Ie9lR2jNCtAsIp2MOZZvvTyjQc0OVKDxbv
	GBbYRGz9k1nZuU3J2VPTpzM3saWKiNVSpIjy2aORINMm29gj5JwEgjjYYbeLs81BIVzZRGXUWRI
	3EvgkINiQ==
X-Received: by 2002:a05:620a:4010:b0:8cf:e19e:b4ce with SMTP id af79cd13be357-8cfe19eb50emr74563885a.71.1774124806341;
        Sat, 21 Mar 2026 13:26:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc9089bebsm467118485a.27.2026.03.21.13.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 13:26:44 -0700 (PDT)
Date: Sat, 21 Mar 2026 16:26:41 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	david@kernel.org, osalvador@suse.de, dan.j.williams@intel.com,
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 0/8] dax/kmem: atomic whole-device hotplug via sysfs
Message-ID: <ab7_AVLgzLaDRcv5@gourry-fedora-PF4VCD3F>
References: <20260321150404.3288786-1-gourry@gourry.net>
 <20260321104021.4a6074330131a2058e8706bd@linux-foundation.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260321104021.4a6074330131a2058e8706bd@linux-foundation.org>

On Sat, Mar 21, 2026 at 10:40:21AM -0700, Andrew Morton wrote:
> On Sat, 21 Mar 2026 11:03:56 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > The dax kmem driver currently onlines memory during probe using the
> > system default policy, with no way to control or query the region state
> > at runtime - other than by inspecting the state of individual blocks.
> > 
> > Offlining and removing an entire region requires operating on individual
> > memory blocks, creating race conditions where external entities can
> > interfere between the offline and remove steps.
> > 
> > The problem was discussed specifically in the LPC2025 device memory
> > sessions - https://lpc.events/event/19/contributions/2016/ - where
> > it was discussed how the non-atomic interface for dax hotplug is causing
> > issues in some distributions which have competing userland controllers
> > that interfere with each other.
> > 
> > This series adds a sysfs "hotplug" attribute for atomic whole-device
> > hotplug control, along with the mm and dax plumbing to support it.
> 
> AI review (which hasn't completed at this time) has a lot to say:
> 	https://sashiko.dev/#/patchset/20260321150404.3288786-1-gourry@gourry.net

Looking at the results - i mucked up a UAF during the rebase that i
didn't catch during testing.  Will clean that up.

I also just realized I left an extern in one of the patches that I
thought I had removed.

So I owe a respin on this in more ways than one.

But on the AI review comment for non-trivial stuff
---

Much of the remaining commentary is about either the pre-existing code
race conditions, or design questions in the space of that race
condition.

Specifically: userland can still try to twiddle the memoryN/state bits
while the dax device loops over non-contiguous regions.

I dropped this commit:
https://lore.kernel.org/all/20260114235022.3437787-6-gourry@gourry.net/

From the series, because the feedback here:
https://lore.kernel.org/linux-mm/d1938a63-839b-44a5-a68f-34ad290fef21@kernel.org/

suggested that offline_and_remove_memory() would resolve the race
condition problem - but the patch proposed actually solved two issues:

1) Inconsistent hotplug state issue (user is still using the old
   per-block offlining pattern)

2) The old offline pattern calling BUG() instead of WARN() when trying
   to unbind while things are still online.

But this goes to the issue of:  If the race condition in userland has
been around for many years, is it to be considered a feature we should
not break - or on what time scale should we consider breaking it?

I don't know the answer, David will have to weigh in on that.

~Gregory
