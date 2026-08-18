Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D420547886A
	for <nvdimm@lists.linux.dev>; Tue, 18 Aug 2026 13:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787059843; cv=none; b=D7OJBE7S8g8MOS59WsbrQXULDBYv98OsGt+Q/Md42xdLiEdkGFggDDh3BanCjk9ZBwyMPY8VDeSrlwjmjgJI1Dam5AvzEm61wMLua/D+WK9VYvAsVVtJiFwEt93ese653atf631gHUGGHKcjNJls7cNHkmY0viyFvuj8TlxiBqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787059843; c=relaxed/simple;
	bh=9EtrV7OjP64RmR5TwTSWprliKDtLV5/e6pRMrGJB82k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YVUA5ldXuT10fCwilVG7WeWoDKFm7TEAWTTGSmGY5HI3m8A6d/Nl9uEmpkMHQmpCYgQh6up0q2HzkkkA20qiaKr1di5xsk1ZwMbW2sPFsSBoz3TCGbVHBC8CL58w9mioS1yxotGmVzEWfWtrUnLNNyG23GtsGtNZ4zOmBvGsr0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=k68DMtyq; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="k68DMtyq"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8f186025973so42435296d6.0
        for <nvdimm@lists.linux.dev>; Tue, 18 Aug 2026 06:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787059839; x=1787664639; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ax6pSQ+/xfd4HZ06hVopmXYjHWPwUVuXeBPTbOtm2CI=;
        b=k68DMtyq32ujZVD7Z3pJZT751NsCKAosIH8aGviK767auPbGfMCCu0TBipoQ5mtTf6
         b+93BV46WXA+Q6RXbOpUz2NtAKgB2FOD3MLiKNVKspoFJmoDDeXKRCKQXgX1Jmzzq4Zq
         EsTrz2BOQO7A2ZCzx/b1dkUl/uHNNlfByZVVCSjpoloPO6W6QmDQsWwdF0nstjnep/te
         gIR6Yz7twql/iLV2nwqbuVTmMQHnTLCsIpR4uEVlCIEobt5kxbAxKWVyV74covP3yopt
         mv8g7vCGu4i89Kegs4G/UeCjKbAQIOxVbvCh2J1uuvmBVTVi+ZSwuGvES0LK4EZ2V9iw
         rnrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787059839; x=1787664639;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ax6pSQ+/xfd4HZ06hVopmXYjHWPwUVuXeBPTbOtm2CI=;
        b=sJ71Eof5a4M8SLi4rRe9ODfkcXdn6KrnKUJQFhOz5IF8HgxlnUon/ho4Li5PYm8Qag
         PpidAxhLisP1Z1PL/DwnB6hRrQaSRosQ7Grbk5TYCC15mKs6WiY4FuUJFPynMK0hgJqf
         BfXvV0zS3d3FEzZExackJ585oHUy88fTGvqE3sRfLXSo9xtEh+eXqklhECvaCaHvXU8U
         2mydquvm5ZkP8MGP5+B/Llv0V3IhusCpuU60s/oY3IXCnokUwDqzwzMFW+J4oVQD+zcG
         pcOngPirzt8h/+rDvDuz3QUER40FtuCCZZ6Lkbkmh66yXr8Gip07+4d9zfUZncvMh6or
         1b6Q==
X-Forwarded-Encrypted: i=1; AHgh+RrMeazgCWdH2UGk328iX9M9GnHipe4Bxzyj9JNu4YRp6V4xcI2UpELZwNKZBkqQyi7EyB/0U0w=@lists.linux.dev
X-Gm-Message-State: AOJu0YxzE991v/ye/bbAGcZKdjpwMas41FG60/Zh52BNI/3NV22v6UYX
	btCvPlF8m77ccjpFgju8+tY7M5sO4Y/SSX0NIaPg8Zm9r5iFoecvx0C4m4Ji4J6VmqA=
X-Gm-Gg: AR+sD12DisjcPNF6wpLUBKqk2CXLaJAOsID7mCPBXLbSyRS9+MavZJABnFHjjOANCsz
	ZXraxllssd6Xa8XdE1Vgr9DOOYLpXmCPsIGcybnv5uMOilMluEigVHGtiUSX0n+5p0S0jCN4eLX
	XyBODr77d9zg6wTQpnUnbk15m1Rc1PJZeFlQdZIr+pd3YOt+QODvzhGOxQFX9Bdb3Sy7OqdxV1a
	Ctrapa+qJDjpVYlKUcNEEk6mj8TyWu+i/JROpRKoXn/pseryNs3wFyLLVHHRmW6faFERjBCCQq3
	fVyp8hjXLj6lezjLD6J5YxH5KTqxChcrq27sM5rgvNQ221XBRh+LKPN6yeZRBXd/9+M4jfY75K8
	9xFay/XhQ3tT8kLkvlO8SrulrJtDRWvMaf/NUmZFUcwpsycza7t8jz9tV7zzq9hbgpyVjfX+iKM
	Ihml+du8bumf+9ffo/nkMlwKp+7XPg1sid2TnjeeMaCf3kShKschXZB6yWD+T+tzZUgwX5v1KaX
	3V2CwXjPO4L2GGu0MbMY1Qmd0O7sfMcGv2Sos5xIcUd
X-Received: by 2002:a05:6214:498a:b0:908:a54a:5b29 with SMTP id 6a1803df08f44-90a91deefccmr394858816d6.24.1787059838767;
        Tue, 18 Aug 2026 06:30:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c4580fcc4sm32688846d6.4.2026.08.18.06.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 06:30:38 -0700 (PDT)
Date: Tue, 18 Aug 2026 09:30:36 -0400
From: Gregory Price <gourry@gourry.net>
To: Rakie Kim <rakie.kim@sk.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, dave@stgolabs.net, 
	jic23@kernel.org, dave.jiang@intel.com, alison.schofield@intel.com, 
	vishal.l.verma@intel.com, ira.weiny@intel.com, harry@kernel.org, kernel_team@skhynix.com, 
	honggyu.kim@sk.com, yunjeong.mun@sk.com
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted
 interleave
Message-ID: <aoRbDEn1sQ7b22dy@gourry-fedora-PF4VCD3F>
References: <aoMv3OhqkBTzSfek@gourry-fedora-PF4VCD3F>
 <20260818060201.1907-1-rakie.kim@sk.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818060201.1907-1-rakie.kim@sk.com>

On Tue, Aug 18, 2026 at 03:01:58PM +0900, Rakie Kim wrote:
> On Mon, 17 Aug 2026 12:19:51 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > I have some concerns with the now additional filtering mechanism
> > introdced into the allocation stack, but fundamentally I think this is
> > a *better* solution than a straight weight-matrix.
> 
> About the cost of the filter: when the toggle is off, the filter does
> not run. When it is on, node selection needs a nodemask filtering
> step, but in my tests the overhead was negligible. I will look at
> this part further and check whether there is more room to optimize.
> 

Not concerned about the performance, concerned about how complicated the
mempolicy - cgroup - zonelist - page_alloc interaction already is, and
then adding another filtering mechanism on top.

Today we have:

1) cpuset constrains mempolicy (nodemask remaps)
2) cpuset constrains zonelist walks
3) mempolicy nodemask constrains zonelist walks
4) memory-tiers.c nodemask constrains zonelist walks for demotion
5) zonelist membership constrains allocation access
6) a bunch of corner conditions that violate 1-3 for the sake of forward
   progress

now we're adding:

7) memory-tiers.c nodemask constrains mempolicy nodemask
   except when it doesn't, because fallbacks occurred hard enough

It's already un-intuitive how and when memory lands on certain nodes.

To be clear, I'm not saying this idea is bad - either as-is or in some
other form - just that adding another nodemask filtering path is making
it harder and harder to understand what lands where.

Mostly starting to wonder if we're reaching the point where the page
allocator needs to take something a little more descriptive than a
nodemask to dictate placement.

~Gregory
