Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E087282F35
	for <nvdimm@lists.linux.dev>; Tue,  9 Jun 2026 18:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781029155; cv=none; b=sKFD7SxlZocF6ZEpS+tVaeSyrcSYBh8y7aza74+LSbwe1USUAIn9LYE3BWMM/LSN8oVW5N1JsgE2L/nrFx3w+3OeRhA59pwJJvfrAuvJhmxfIKPqC/SY0o7Uwnsu41n1MaTS7dRg4btnOuw8pZMXMwSpiLv1l2cMtwmfYsbcb8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781029155; c=relaxed/simple;
	bh=yN4njZ8y4hk97P/ujuc+3D9afHqUiRM9TkBrBVe5vEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=izcxkbKGguhGZkIi6fTYmxF2RjZtzaQnyesQYVKhwrwbpH601gKTPg1L+kaHV/HXU5vTMtaJ17qvvAzJuAB+bl8rKZ0G4s/t3G54aJG0gyZzxGjDYRzLcd1c4L7CZ0IEqzmeU75xhmIv11XTkl0CGq3arp8f47jnPsCF6N/QrDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Y6lsY6m1; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Y6lsY6m1"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-9159951f05aso683296985a.0
        for <nvdimm@lists.linux.dev>; Tue, 09 Jun 2026 11:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781029150; x=1781633950; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4KqE8R583ndPf0WEv0mevB0HU+y2IabL7k8Ouzc21Xc=;
        b=Y6lsY6m10jR/f8fhm1GO70b9ozACRvijHCk0V6Zs95GBLxRbdCh0VA4zMZukzLgrqO
         Bsxl45VMr3zHFQdFKSKFvmBB8do3Au9hSBju3er4e+CxWRTPVAltJ9T7LgDohoOzpCjw
         +b4y87Fi6bGMvJo7bucouylW8D9TFWE4xH4ni5bk30sfQD/dbp4t2X6v635yB5CK5SUy
         lUzNG9AC6dkSTikJmM/ZOoDMml9U31/YHyH288Wy9DvV1TBI22fZ95po7y6QJbTfpLlK
         kUkPpvC/Q1ORyEdXQbrSDhHsPxY+HYK87/hi1QovtpTaBE63f0FW9IWCbzB5Bri0qOBZ
         LUig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781029150; x=1781633950;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4KqE8R583ndPf0WEv0mevB0HU+y2IabL7k8Ouzc21Xc=;
        b=M+WSQ2v1MFb+o/t9l9Mv+RyBTJXPYG/nN76zL7rtlnQDUTax2OUAdBF/SkFXenwjto
         udVUPfZzBl0jRDHKi3q2/NfIBaowFYyfu0j1WhEu2ossSFFct4baVEpPc7K3FeQCx+Kk
         fEpVs87RHOm9cFiULy4lE52mRNGBWSeHZVo4gfdO92/rUYrPxFikXgaMco6TaTCiLvTs
         vwMiBG1ILWVCHxLYhtksmy5OqsT7pnErAaw7BUnxMt8wOllG2JKmU+Vm6lZwPu4C1X3T
         jJJ30/juD16xGjbYWAFFqNq2ej+TUM9dFFfSLOCeirublZp/pO/5A2rlKhQ+u9dNWsm5
         S3Zg==
X-Forwarded-Encrypted: i=1; AFNElJ/V8+tbC0N4v/V5INB/BSyKt2yYgNgzb8HFhOguoRX4FlUJFYFX/MpiXrVZ6/cRyvrMAI6ifJ0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzB/i8lfAlmDBkVb8cjt6P6k0C5OTWTB37ab6yOvarUeKI9zMG1
	eCCAhGTeU/FTIHtii2+Dicnpw8ZL883CiHBaeI57HGLO+DsxLaRWL8cJ4/a4VNj9QBk=
X-Gm-Gg: Acq92OG+eYncltx8kki7Ed+vyNnNuMozIqQYOQDrvSKfqOpckTEjGY3R3mmRCUZzTuG
	6sibZyHlhE5GunBYD5zmcdhNUvYZ7NaFxYWPJhQRo1NnY+QIn5siBHJFXFC4TagvF2jrS7MYP0e
	wKhEoRcu9NL58n5LWYMIVNy0NkKm6arH2kdowy4/dv+3mf8cZ8GB34u1pjOkuAeaCnha7GEJLks
	zPVksP6a7P294yJ0FjgIs9PPBl6Ci0YZbAnjk6DXNGOXK91N9OwP1637J5N3lAaJpOiptNH7zbt
	QP2RP4eTsiGCRab5bPfX61yzHz7JFoeb3eJ9XV74ebNAKQchl/Vgi9ff3XEzhzpj7In2tx7zqWG
	Ma++iDkvqiDaOj43ov5xwDgPPOB+IhgsRq8LG8QxeKqloyn72ABWlIbfrtlM/cNxoM8PnphUEfH
	dLbEpDQ4SzPSGZp0UkKgR7SVylUvkqBDsjcDhjHadY3k6fJrouywxiWGVp8txD+aZP7/KJv+JWx
	jXdCW3KUnUpzPvl7Q==
X-Received: by 2002:a05:620a:17a6:b0:915:6758:222c with SMTP id af79cd13be357-915a9db8ab5mr3329361185a.46.1781029149586;
        Tue, 09 Jun 2026 11:19:09 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a402ff9sm2211734985a.45.2026.06.09.11.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 11:19:09 -0700 (PDT)
Date: Tue, 9 Jun 2026 14:19:07 -0400
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
	ira.weiny@intel.com, apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 8/9] dax/kmem: add sysfs interface for atomic hotplug
Message-ID: <aihZG8WKVSvA86mA@gourry-fedora-PF4VCD3F>
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-9-gourry@gourry.net>
 <1cb0514b-c753-411e-8ff8-80fa29837441@kernel.org>
 <aigy0ut410TItkgB@gourry-fedora-PF4VCD3F>
 <e6e7453a-d2af-4f1a-8930-5e5e5c5879cd@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6e7453a-d2af-4f1a-8930-5e5e5c5879cd@kernel.org>

On Tue, Jun 09, 2026 at 08:11:42PM +0200, David Hildenbrand (Arm) wrote:
> On 6/9/26 17:35, Gregory Price wrote:
> > On Tue, Jun 09, 2026 at 12:26:07PM +0200, David Hildenbrand (Arm) wrote:
> >> On 6/5/26 23:19, Gregory Price wrote:
> >>
> >>>  
> >>> +static int dax_kmem_parse_state(const char *buf)
> >>> +{
> >>> +	if (sysfs_streq(buf, "unplugged"))
> >>> +		return DAX_KMEM_UNPLUGGED;
> >>> +	if (sysfs_streq(buf, "online"))
> >>> +		return MMOP_ONLINE;
> >>> +	if (sysfs_streq(buf, "online_kernel"))
> >>> +		return MMOP_ONLINE_KERNEL;
> >>> +	if (sysfs_streq(buf, "online_movable"))
> >>> +		return MMOP_ONLINE_MOVABLE;
> >>> +	return -EINVAL;
> >>
> >> Should we try making use of mhp_online_type_from_str()/online_type_to_str()
> >> [possibly a nicer exported function for the latter] to avoid duplicating this ...
> >>
> > 
> > In patch 6 response i point out adding MMOP_UNPLUGGED
> > 
> > If we add MMOP_UNPLUGGED as a state that is only use by callers of
> > memory hotplug to represent the current state - but not as a valid input
> > to memory_hotplug.c - then we can simply this as you request.
> > 
> > Although we'll need to add a couple lines to memoryN/state parsing code
> > to disallow MMOP_UNPLUGGED as a valid input (otherwise you could
> > permanently unplug memory without the ability to get it back... unless
> > you want that?  Seems useless to me.)
> 
> I would just special-case your KMEM-special value, and then branch off to the
> core helpers?
> 
> static int dax_kmem_parse_state(const char *buf)
> {
> 	if (sysfs_streq(buf, "unplugged"))
> 		return DAX_KMEM_UNPLUGGED;
> 	return mhp_online_type_from_str(...);
> }
> 
> So there is no need to add a value to MM core?
> 

Was going to propose this, but then I thought... well if CXL detactes
itself from dax and does this same pattern, maybe MMOP_UNPLUGGED makes
sense.

But i'll leave that for another day and do as you suggest.

Thanks!

~Gregory
