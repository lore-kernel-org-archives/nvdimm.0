Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0722A29408
	for <nvdimm@lists.linux.dev>; Fri, 24 Apr 2026 03:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777002216; cv=none; b=LLWRMsVhyrl8UgSKXGXx45LTIkB/dzdFCKh8n9atQmp0dBDUdssK94D5fj/wHd1MsaIjcPV5uyJrMkFTJB0yh11xL3jmZt2MVzlomYbBXTTsDqtcFXG2UrtbEyQo94Nqys7KlPl1n0HVBOHhGUPZiw+jHrjKY7hkFhuAxBb+FAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777002216; c=relaxed/simple;
	bh=qnZobKXXKxR1wvldR94gOPnl1Z8QgD0VXdOMyBWMks8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ddknNGuZ/54iF76JhZx9cLd3ER04ZMDYV3dOlOyQkPzdCEC0daKtWLBqqywkONkuPEf1BCU/lgM63q0RtxR3/G2fPEySeji1XdLRVWB9UnmnLOTX+0I+IspmmiLIGFsJM7dAtH+UOX12ZgXuQgk0liyH+JZgrs33Rfejr6zpfQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=daqhdSBj; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="daqhdSBj"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8f15e900586so67091085a.1
        for <nvdimm@lists.linux.dev>; Thu, 23 Apr 2026 20:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1777002214; x=1777607014; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CkBeqEq2+AtENzGlt9HMZzE8R+M0m7SyEcN2haGEWFI=;
        b=daqhdSBjqSeFT78QtZ16JMu/bEyb7FmBH0p02BbwrWqWuN/lvg212WEbsTIsSReFX3
         t2uw2Ent5Gx//4Jc9Y91zdLiIavnzQcAwfzhES39tgBHj9HkQQv/t6+IsNQeor/HTkox
         gOpmDwqjdnN70MdxVCxECqPsZfKwqdyP4Lr1p1nHKnDB5rMWS29NjjJeAngl5J9Bm6K5
         tD7MqWjS+UKAxE1UJ8NnZuIRONAq43u1ZFeydAxJ9NtCDWphE0qGkTzhkPCvHe8U62mK
         3rcfna5JOV13ozAZI7k0180a2LQSxCMVL7GcAk5QioaBrJQz3FHZd/ocZAvlgVvVn6xm
         o/9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777002214; x=1777607014;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CkBeqEq2+AtENzGlt9HMZzE8R+M0m7SyEcN2haGEWFI=;
        b=hMUorZiubf8IGO6endVt/Cw++J03yGd6z5TP/tiz/CoO8rakWdj1acTgt1r2oEzh8B
         MoTJIMuhrUYXmao4mPruYsChAmYPB+DrDVd/LEZrymn42rVOVs67x3YsDbVALTNtV8VE
         zKzpOyXtFZmIEeB/9frlulZOmtRQh0OF1vKqgr1uAWO6KNuya53PC9FAmxjqZ+E2jag1
         fHbOYs3vdCgfBzkFr1wrzXNVX6RtlbUBK+XwCfIOtsr7S+sSqfIgtNNAA7iB6WMYJ4KK
         xbYvqNmIJzczO5I1RaFcCXK9l3CkCpNZ0NrBdHGFwDlgh5BEsxlU10L9TdG5bAV+e+mO
         6TLw==
X-Forwarded-Encrypted: i=1; AFNElJ8JT0iFk/T7FtVkfwJccLh1mVUlx8ZtLlhBMkJDftqTs1szathKa/R1bW7KX6Z1fXHmaT0Og4k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+65BOZBAagf4eBDikywxvNlMNYEHjc0726ei9v0r7sILdvGVy
	pHVgTSwHtnjn+iZbICCK7d5o49ch2eBChXfhAjH+JdOM2rj9elWKAcoDeonrHoe0qEc=
X-Gm-Gg: AeBDiev8JBDj+Pv1l42xaXsKETzFAB/saCutlD3AmGqu+EjDqMj9xwdbF+vUHzx8XL0
	ONbS2vBws9VuFwY+nq0ppOAAPWijxNsDIHpfiROIzYZHeo3SEMpD2FfWj9pCNngh7k042na3+AP
	RyHbKpT3hTg6M2P0u8J8jp7W4qgoDEmlNyxDtcvc7IN8fGckccvVlFkvjYpbtYYbrBnkakh7mOO
	a7xBa2ViBWfW87/kbZXcaoBY/9zc14mQwbKSxApHRYYm35C7Fbwg8rbA40UXLEeb+kEB6IxZ41i
	Mnd/v0xdIFQYtxwzdRc54hCXgtS91sFwCmnN0CV56N7s1150TgEVvIZVuNtSojs82a+nethdIdn
	MGnYEMRnOARsuq1tcw4CczNE2efkNu7QAla9nFbYtOlIOuETa4oB3T4fR+LFba4Gsn5Sg9oQ0pg
	K9wk6vWzVF7H6s+Z39Lr6kWZ8meZlMzO3PfnBmjoGF2CtfOQ7gQTlfWuusvkcErip55gulnsZEL
	S9NFlesxI/Ck/2Hkg==
X-Received: by 2002:a05:620a:9042:b0:8ec:c4a7:f8fc with SMTP id af79cd13be357-8ecc4a80004mr1763332385a.43.1777002213846;
        Thu, 23 Apr 2026 20:43:33 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-70-94.washdc.fios.verizon.net. [173.79.70.94])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ebce6ef86dsm1128038085a.30.2026.04.23.20.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 20:43:33 -0700 (PDT)
Date: Thu, 23 Apr 2026 23:43:31 -0400
From: Gregory Price <gourry@gourry.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, djbw@kernel.org,
	iweiny@kernel.org, pasha.tatashin@soleen.com, mclapinski@google.com,
	rppt@kernel.org, joao.m.martins@oracle.com, jic23@kernel.org,
	john@groves.net, rick.p.edgecombe@intel.com
Subject: Re: [RFC PATCH 00/12] dax: Add DAX to guest memfd support for KVM
Message-ID: <aerm4yDVYpOhxXEF@gourry-fedora-PF4VCD3F>
References: <20260423170219.281618-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423170219.281618-1-dave.jiang@intel.com>

On Thu, Apr 23, 2026 at 10:02:07AM -0700, Dave Jiang wrote:
> This RFC series is created as a proof of concept to connect device DAX to guest
> memory by riding on top of guest memfd in order to prove out that device DAX
> can be used as guest memory. The series seeks to jump start a discussion on
> if there are interests in creating a DAX bridge to utilize CXL memory for guest
> memory until the N_PRIVATE implementation by Gregory [1] is available upstream
> and DAX users are ready to move to the new scheme. Once there's an established
> consensus of interest, we can move the discussion to the best way to implement
> the DAX bridge and the future of device DAX as guest.
>
> I did the bare minimal to get the PoC to pass a modified version of KVM gmem
> selftest (guest_memfd_test) in order to prove out that DAX can go in the gmem
> path. A DAX char dev is created and the fd is passed in user space with
> vm_set_user_memory_region2(). The DAX region is passed in as a whole when used
> unlike memfd where any size can be passed in to be allocated.
> 
> The folks on the cc line are people that Dan Williams has mentioned that may be
> of interest to this.

I see these as *mildly* orthogonal, but I think maybe you should propose
a discussion at LSF to talk about this.

guest_memfd in particular wants the host to never map the memory - and
guests *generally* want 1GB huge page support (TLB go brrrrr).

There's a real argument for just handing a physical memory region over
to guest_memfd and making it manage the region manually, rather than
doing a bunch of nonsense just so you can call alloc_pages_node()

So I see an extension like this as genuinely useful regardless of
whether private nodes actually end up merged.  It's a matter of
flexibility and use cases.

With this plumbing, you get less flexible use of the memory (you're tied
to dax abstractions), whereas with private nodes you can build slightly
more flexible general-system support.

IN THEORY you could add something like an NP_OP_NOMAP to private nodes
to make the buddy manage pages that don't have a direct map - BUT - in
practice that's likely to be more of a bodge rather than a good design.

So I will say - to the detriment of private nodes ;] - I like this idea.

The question is ultimately how much flexibility you need to shuffle this
capacity from one guest to another.

~Gregory
