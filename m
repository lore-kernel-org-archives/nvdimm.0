Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097D94B048A
	for <nvdimm@lists.linux.dev>; Mon, 17 Aug 2026 00:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786927582; cv=none; b=fNSZWjmhREfrwllNbYCBlzCv3HRzOPdNPqd6i2AAe4LQLyjolGObaInTmayfkcDSMtniRj/0tfRuRhcak6SnSfdJ3GosL3Hxfqls8BclM6v42B8oqWey38BE9BET43pBzToU19MxABktRff2gXW1hgqwQJJmml/Q6O14gRIwMII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786927582; c=relaxed/simple;
	bh=ZERJlqmkFypfjYaByxkccL/su6TxOP0i7lN3f2Qe8Mo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UlHZRlgWEJdJ6NGSklByieA/bbqk1Mj9vGygfhYLAqigxhOun5HUPOZEunJOzCRMCWnN1aMJGr5Xp5yZo6AmSnnw339Up0Xn+IIdzRpIGLF8F96RhKWcsw1KTX4i678kfpYPodhXoV+1/7mqE444UtcXhsNtnRK2CBSgi4OL8M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=XOI1JtO2; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="XOI1JtO2"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c16ac21acso17378771cf.0
        for <nvdimm@lists.linux.dev>; Sun, 16 Aug 2026 17:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786927580; x=1787532380; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1adrpR3QLynHsYFALPxmo4Zb1MnnrvFb0B1zDnSkG3k=;
        b=XOI1JtO2UlWg7fJyL1ZAsOZWHo1HBmIhjMWpR22x0+DjK7iUb29Pwsi0iVk6En0dhF
         YfhZeCHJL2tLygLgq84kgEhn/O3WxUND/2q+51dICFWhtPaNGiQleLVjGMsyfOyc+YQh
         0jAMAIa0TMt1aGx847D5MnoTMz8V6qZEsAeoWkLMncTe2bQKp8J2JBoSw+8x2U5hpGLP
         czXlMxHiyA1+C8EvTQQZintLPe2GxFd0K6unYaWaQECAjFqY21sy3v1OD95iNmTvv2W5
         t4Lm12ZqhHc2I8fP1hWZBzcUe5kRQsa7qzbxrbw7LBUhIVhRD3YINcFWDx7HTvzWb0xS
         ghkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786927580; x=1787532380;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1adrpR3QLynHsYFALPxmo4Zb1MnnrvFb0B1zDnSkG3k=;
        b=hSu89JgYwGUtl70Q2adegEnN59tRMGLzniXMI+mj0OmaCsCThA2c5932Y4BNnHVqSE
         /FIzVY7SXgqgZOVbvUk+vRBBFtHUJTrJ4/2lq1EG6cXVHeeTGr79MKNxDxT+V0p+Nq4p
         3FHDMqebJxa2i5bMSEGaja6A7coPJQZUsj7AOOnK+ccuK66LDHZgtE4tGZLPyymnbWn2
         ntejVPTahksi2Te+UWrWOCBrfYAhuCvNXMDXN0sL1GwOdyTYsas9VM669QplLiEv0qO3
         Pc4zkHvzzsNUrgCYa1I350ehVLdHPZ/kIL/ZX0a6nAbtMR10LOpNUAI8CyhQ+OGeR4FK
         pqaA==
X-Forwarded-Encrypted: i=1; AHgh+Rob8RPiDpL/eJmg1ZtKXo6WZvhnSNVThaV72t6C0StC5Mlz6uXS9c0a17Td4N69EufFDow5U9U=@lists.linux.dev
X-Gm-Message-State: AOJu0YyF/vPNf4OpmyTJ1rxsJ5EpQykG2Bg75S/by+3HhBWf64SjGSFi
	ujzkVxkYCjWbtUDaEyYM2j70EuxAomTR1Jesiq5o8d8JioNXb6bUS4B6kwp9S/PjCUQ=
X-Gm-Gg: AR+sD13igypzcRYpyJ3xTh61SZ7xEdzSRF7Jd0tyfwkbBNmmJwwyIpFuP2nrw8+hoyK
	kEi5+zOyGMWbmlIT0C6QnSVRje/nq4dVJ/2ByF7FsllLN2D3F5YGLyvdiehTqryfZLC/zJqOj8D
	8HTf3eC1JG2HSpTR46X83UF9W9B5JD5BCSYNho74yGIP3LR24T7twxXaNSxE1LLcBH6mj3SLNka
	MUuwxIhFBWvaOqAe0W/IQ6SuykkfFY2HQITvsFdnEKp0P1+kgnYcebp+i9KmrGWEt41/pJvLg7L
	qhpVebcFV/4vZ/mFUT2vkAisRGB9DcIVGEgQ6gTn5qWAHfwGcEcnFncO5aq2528BXr3cAG92it1
	5utkxIZ4efNMFKX395f0h0iO33bAbuLIZIhuGRwG0qy2NslHp5L71/QxzUiai0FA144bdWyX9yn
	Tq8rJAN6Rm4jb8uwANiz8pi+Ii4SHKv2eaWBMQL1mnt+/LRrgIIbdKbA2pXOC2lL6JEaDTr75+U
	RwjE0u2TqbQRsvP6i8ca8EKtFq4AGDdSlCNDC22slMf6BOcRDaiD2s=
X-Received: by 2002:ac8:5f10:0:b0:528:1478:e1fc with SMTP id d75a77b69052e-52d854a4899mr216242221cf.34.1786927579795;
        Sun, 16 Aug 2026 17:46:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52db612c2bfsm1249061cf.11.2026.08.16.17.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 17:46:19 -0700 (PDT)
Date: Sun, 16 Aug 2026 20:46:16 -0400
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
Message-ID: <aoJY53BJztPQYumw@gourry-fedora-PF4VCD3F>
References: <an0t0mP9JB8f4ILK@fedora>
 <20260813062351.1856-1-rakie.kim@sk.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813062351.1856-1-rakie.kim@sk.com>

On Thu, Aug 13, 2026 at 03:23:48PM +0900, Rakie Kim wrote:
> On Wed, 12 Aug 2026 22:37:06 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> The cpuset.mems = 0,2 you describe is the node set of package 0, so
> the tasks in that cgroup use node0 and node2 wherever they run.
> 

I think you are over-complicating the explanation and that's making it
hard for folks to reason about this.

My best understanding here is for multi-socket systems, weighted
interleave as-designed is inherently sub-optimal for scaled workloads
that utilize multi-socket ("package") memory resources (DRAM, CXL...)

I think there is also an assumption that total memory utilization is
less than the total capacity - otherwise some of the assumptions here
break, but that comes with the general weighted interleave story.

I'm getting back from vacation, I will take a closer look this week.

~Gregory
