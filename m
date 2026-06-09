Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FBB48AE2E
	for <nvdimm@lists.linux.dev>; Tue,  9 Jun 2026 15:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781018146; cv=none; b=NAnbGLIZBjcWw94/TjBScSCaxf7zINzponxb1+BMUp4yd0HEf0H9hPh5pOHYrPl9qnnmVp8Gt9ZkZp/CBhv7WwJydyx2HgLdwkv99m6ITluy8MbmsnTASXo9PCCfXUGiVkE0BZu1zevbqgAi3QUDNYp1KQXwaX3ptLI4nNsF6Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781018146; c=relaxed/simple;
	bh=4Q3lUCN/K5ogiGNFPWtDLaQVmKDt2aFt3PTUh0S3qXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TYpDxCVlMmocznlGDVDAXRInqzJIksjF6AAIYbywVrf41Ph1wW7v6a/MBDW7skavVbW7laf8JEnd53lTdlRN04GEv5JV+m/OtTumlIz3Dr4uWhKBLzrpYae8xZE16btkSlw42N7ffOLLmfTQdNlUxPgWOR1xmsHYdr+EVa/uBiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=XtDg+3yi; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="XtDg+3yi"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-9159da9bba5so409053685a.1
        for <nvdimm@lists.linux.dev>; Tue, 09 Jun 2026 08:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781018142; x=1781622942; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=01y5Yp7Lv2fsZ0TiFN6M9m/RLD3dl7/dyTYKRdYu1dc=;
        b=XtDg+3yivQKNeSEgvFeUUCVJ3s48/VXp0dnfpimG2M53aC/aib0l4YgCnATDqBQYGb
         wJ3SxzJpRpPAmzGc0QwRBcmWSJCZAaqDMaVTZZ9JkaMFnels09M66BXown1kBNHNie18
         gV8I1nD1ar5oszXYX/lj/z+IJb6QGj7oHQ5oFznGhc8hW/7gLndREYB6yoMO37KKs7pW
         iZtbySVTJKurtlmYGzWOglrJKYXqTr4d9hUPX0n3AWqb+NdHJ6Zj09am5sLidwn4g6I2
         zjgeCXVKyAG5uNoBw8HEYEOt3NmqrzeEhzAFcWv0RdYtv+floDNZ5uSo6hvesF8Aq3AR
         +B7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781018142; x=1781622942;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=01y5Yp7Lv2fsZ0TiFN6M9m/RLD3dl7/dyTYKRdYu1dc=;
        b=MnyaVsUZos1TKkNRYQA/uiTD2urnyB90w4M211xBX60LYDv8q0MI8RZwDxJizCeILN
         SHEqtMWXGqfM6pbTzm9OFfg2IsrgCirXvOc2r335iq7FUjZU/5+YYWqhoV16p0/wrSVW
         B+aDPX54T3m/0mgmsmWDhHOdcw+2+1BrMt5MaeB94pFzqma/o6csssocf/hNj607X1XR
         Xph0RovwrcR2mWMPqxPQb/9eaU0ORT62mb6cV8uP5JmlFzn/Anuxu4qSZSWDouz50FGy
         L4uaSFoqHazSAxR4EltAlk8+R/gdORiR/58obkCgknJfuAn3smzHFCyaJvsUUP2D0Xyl
         E+Og==
X-Forwarded-Encrypted: i=1; AFNElJ/z6QDIGs2cso9xEKKH+66KHCZAqCmknU1QfypTbNfXuBe6FUyEzqZ7GuOjlLr93FBpMQU0y0c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0dCKwUw2dB32KlMF77hIh3DFyJslNWFY1+490KvdMRlL1RvUm
	gJUmt+lFz0IM/m2KxmPC3kAehDEEtDkTuiXfMfhNOejk4JFQpN/C6/O/CeqSi5vwzv4=
X-Gm-Gg: Acq92OHeLyXHwp1Pr8P4F8VWYUWmpzdN0Xb6UH4pUN6ISESp6+8kz1ZyHaegszKYJ8y
	b/NmIKwZJjszSUp64t7NBWQYlt9+/yKRdxEmMgzuDV78wUMjLKjFzj9nmvQJV6fWGGdIDAaKJUf
	GjSN97sK9XsdTIY2q9crZ95lCZ7tlycE2MRxBgKcTs7QBoo59lrHMb8P04MvGDeLqkxWr/3ILj3
	P74XEkaAkqdO2jIqOyPM3Tq5G3XGscnjU2d0bhYDEmsX7OYzkNBx+Ve07tbQ+HdrEEyNJu6dC0T
	5gY1r0a/M0PnaTw/oFbmHACD+Aq7+V31tLCy9W15UsH6ip6ATPJGgCE9lb7Z9PC4/IJGPjhvOya
	5ApSVzNQWGsJWFGnuQLtPG68cp6OWwmA2Q0kQv3xyPfjuGuSAg97kPkApGMjMItVqzMN1V3qATa
	iST5Ks9S3kFjCjk54ob3A3n2qY9kYWGqz2Ak3XaMyRqtNGAkI4S5WI7FtnX8L7sAYoaxlfAL0iv
	YIaVOaqddFT0ITHEg==
X-Received: by 2002:a05:620a:2547:b0:915:9972:cfc with SMTP id af79cd13be357-915a9c7bba3mr3335701585a.19.1781018139752;
        Tue, 09 Jun 2026 08:15:39 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91589ea0bcfsm2153439585a.0.2026.06.09.08.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:15:39 -0700 (PDT)
Date: Tue, 9 Jun 2026 11:15:37 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	linux-cxl@vger.kernel.org, linux-kselftest@vger.kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, osalvador@suse.de, shuah@kernel.org,
	alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com, apopple@nvidia.com
Subject: Re: [PATCH v4 5/9] mm/memory_hotplug: add multi-range hotunplug
Message-ID: <aiguGeKKfSOu8haT@gourry-fedora-PF4VCD3F>
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-6-gourry@gourry.net>
 <b62e071b-9dec-423f-9b4b-e3c34ea0a409@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b62e071b-9dec-423f-9b4b-e3c34ea0a409@kernel.org>

On Tue, Jun 09, 2026 at 12:06:38PM +0200, David Hildenbrand (Arm) wrote:
> 
> >  EXPORT_SYMBOL_GPL(offline_and_remove_memory);
> > +
> > +/**
> > + * offline_and_remove_memory_ranges - offline and remove multiple memory ranges
> > + * @ranges: array of physical address ranges to offline and remove
> > + * @nr_ranges: number of entries in @ranges
> > + *
> > + * Offline and remove several memory ranges as one operation, serialized
> > + * against other hotplug operations by a single lock_device_hotplug().
> > + *
> > + * Unlike calling offline_and_remove_memory() in a loop, this offlines *all*
> > + * ranges before removing any of them.  If offlining any range fails, the
> > + * offlining of the ranges processed so far is reverted and nothing is
> > + * removed, leaving every range online as it was before the call.  This gives
> > + * callers all-or-nothing semantics for the offline step, so a failed unplug
> > + * does not leave a device split between online and removed ranges.
> > + *
> > + * Each range must be memory-block aligned in start and size.
> > + *
> > + * Return: 0 on success, negative errno otherwise.  On failure no range has
> > + * been removed.
> > + */
> > +int offline_and_remove_memory_ranges(const struct range *ranges, int nr_ranges)
> > +{
> 
> Is there a way to just generalize the logic in offline_and_remove_memory() to
> multiple ranges, making offline_and_remove_memory() then a simple wrapper around
> the new offline_and_remove_memory_ranges(), providing only a single range?
> 

Yeah that's reasonable, I'll look at what can be done.

~Gregory
