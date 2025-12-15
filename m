Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6F82E7BD3
	for <nvdimm@lists.linux.dev>; Mon, 15 Dec 2025 12:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765802418; cv=none; b=jufxfpkgCbKHMOYB/EWc++AIdkKEP8QqtjsDM3vIQGogyoH1J/aY27kR6P617j8E/65sFbgqZtSjbbKST/fZpkWL2f/fgUo5e3ikhbhGfUS88mmnaVopDi1o6vJrYvqejtd3OuIY7FwCdyQT3xd1xDgitFVJhoeWjcaOeq7nShs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765802418; c=relaxed/simple;
	bh=+PuE2tLBW1rXXQlqEJWcvvhfVKok2O1mj7zgRKhY0aM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MN0DYPyWANE4ytzrYYuHfSjYno0n24TBT/qH/n6gOUx2TLBmMksWg/eshz8i0VvTFbAT+KxUp4IQ6qJQ8r6NtUAFv8CHTHNvyeXV0gFjtd3yHUYP92ig9CzSLhwSjhQsJKDBIgrPLcOqyDHxSRn3Rw17EEV+2HlsVKqyWt1EyiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=K3Pfop8E; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="K3Pfop8E"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a0833b5aeeso32430495ad.1
        for <nvdimm@lists.linux.dev>; Mon, 15 Dec 2025 04:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1765802416; x=1766407216; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XQ+e85/bUCohfI0SHpL3374mINgtvuKmw5p+42PCaQ0=;
        b=K3Pfop8E39N/+wr7ICJJz5qlj6X+ZIr52Z0Ab4ZzNkVWyhEUQPb37j59kj4JtLWT8p
         JZpGkFsNob+U2zwguEAPGiFcwVPnAS5tCurWYMLawtSHWs0eA/J8R5EVULl+ZAgle7y2
         c+h8I4RjnmgDp4Rbjws4tTs7gnC82Cy1Ialjhn2eeun6J8PBpd/KZE5RclBjaXqlRJ9V
         6/YI+qDrjNuadwPMIwhEV3de3SQRTDZqBnltzWDph1rE5muXua6JX28e+STy6f5nhzs1
         d/j4UwmyAxSQj5Eaxx44qtjJyXazEG8Cyu2+yDrv3xwgKhMscfFZVXBm4+tKbhiWnqhN
         /Pkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765802416; x=1766407216;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQ+e85/bUCohfI0SHpL3374mINgtvuKmw5p+42PCaQ0=;
        b=c6RiU9Mqpo5n39Tyrs1ouC0vweuDmLaaEpuQIH4/F1slQ7Cu0+XW5KMzHwYnBI4K8c
         KvFiMfj9q2YdBNJPKsRIcGzq8M1xw0RjlCHkmWHXLCzYatJazUKWLCoxe1b0hja2kqj3
         tzEvrDukP+VYjC7vzL9+zrMg6HWUu2dkmO2DDey+kq4W5nfbyNdvZTK54yFhThiYSIJg
         P2TlMvGQbnGgMOVRsONT6HR1xNRxC1et9c9zDHEztQfC+y8q0V1Ns+vvVPSrXeBkiIpW
         zu1nSueikkmDkB65enA2NH+IR43qV65NXpLYs/aqEtL1hsFaQn1amM2HZtAj/JDhIPXj
         npcw==
X-Forwarded-Encrypted: i=1; AJvYcCWr4ck0RzZpV2AKMEX0j6e5JW++K9LlPpJAzgddXzQ7F9RMYQiwC4UHcnWP4eP2EAoV9QB6hWE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd9F15hxE/5mv1Sf244lpb17VzqvobVJdIYaPKBuUE4hOItNCS
	cAwJEWV+k1GA1w/lQaEmtYcMDOi26IhuzfDZr6sOeNUvwrLiub5Lw+ztCDeb0UODGy8=
X-Gm-Gg: AY/fxX4UuTWyUYl7pvLbmCMlRyJdFscDFoU/vA7LYK0rr0db+630F7bCYaBMEqJ3TsP
	ct8/t3+bkntzncjQ7d8U36cD2gRFXtdegH/rbBK3lQ7I/Pql7iIISPSw1jl+fo98qzWY5jtxVAj
	/ZfBMppuG+JFTgcJ9lkkcpLNcLqqi8+Pm+rz01PZrA919K+UTv9bKjU1ive9wQh/wWdn0cv0n8F
	IegYOau5Mqs2rTyX1DY5sZPfEPp0l3cyvirY5qiMOPVvpMj88ZIDBacH6gUDQ89/COTo0cdPBu8
	cSty0BvuUXPIg8z6RPevfVgdQHqsgEIiLPY4l++e42+7IoCAWxu/SiCL5AHZMLAaY8NPr/wTq28
	AunDe4qTPfVPl8Ydug4FZX/iBue9eaEtBxCAz87vvs2d/P4z0n8wOfeB1Wo1Ut0tIsu88pwrptD
	/x0nmHV/eakXN5llo+I4naEPDGU+VGTg==
X-Google-Smtp-Source: AGHT+IGs9Ux4WT36PFE81Ye+THAzlPoeoI649XuOQnWr/+KqI/OdcXZ3NL6DeXTGnqp6jXKC8WolKA==
X-Received: by 2002:a05:701a:c965:b0:11a:2f10:fa46 with SMTP id a92af1059eb24-11f3484e8cemr6230501c88.0.1765802416021;
        Mon, 15 Dec 2025 04:40:16 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F ([205.220.129.38])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f446460c8sm8475705c88.10.2025.12.15.04.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 04:40:15 -0800 (PST)
Date: Mon, 15 Dec 2025 05:38:47 -0700
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com, mingo@redhat.com,
	peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, kees@kernel.org, muchun.song@linux.dev,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	rientjes@google.com, jackmanb@google.com, cl@gentwo.org,
	harry.yoo@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com, rrichter@amd.com,
	ming.li@zohomail.com, usamaarif642@gmail.com, brauner@kernel.org,
	oleg@redhat.com, namcao@linutronix.de, escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: Re: [RFC PATCH v2 02/11] mm: change callers of __cpuset_zone_allowed
 to cpuset_zone_allowed
Message-ID: <aUABV3sQyaTksz54@gourry-fedora-PF4VCD3F>
References: <20251112192936.2574429-1-gourry@gourry.net>
 <20251112192936.2574429-3-gourry@gourry.net>
 <dda1fab7-5cb9-4d83-8b60-f4ed75a03aa8@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dda1fab7-5cb9-4d83-8b60-f4ed75a03aa8@nvidia.com>

On Mon, Dec 15, 2025 at 05:14:07PM +1100, Balbir Singh wrote:
> On 11/13/25 06:29, Gregory Price wrote:
> > @@ -2829,10 +2829,9 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
> >  					ac->highest_zoneidx, ac->nodemask) {
> >  		enum compact_result status;
> >  
> > -		if (cpusets_enabled() &&
> > -			(alloc_flags & ALLOC_CPUSET) &&
> > -			!__cpuset_zone_allowed(zone, gfp_mask))
> > -				continue;
> > +		if ((alloc_flags & ALLOC_CPUSET) &&
> > +		    !cpuset_zone_allowed(zone, gfp_mask))
> > +			continue;
> >  
> 
> Shouldn't this become one inline helper -- alloc_flags and cpuset_zone_allowed.
>

I actually went back and took a look at this code and I think there was
a corner case I missed by re-ordering cpusets_enabled and ALLOC_CPUSET
when the GFP flag was added.

I will take another look here and see if it can't be fully abstracted
into a helper, but i remember thinking to myself "Damn, i have to open
code this to deal with the cpusets_disabled case".

Will double check on next version.

> Balbir
> <snip>
