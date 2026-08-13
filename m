Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E2220ADF8
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 02:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786588632; cv=none; b=jPh0CwUNbbSORqZ1DzJ5J6fJYOKcJsm43WZ0a9Iqf/aYBbjHL5I9j296ozcafWuYGuK1wGYDMRpKAMSyNERlSPITZncwKrcA8ekuey36WTg93KSk8ixIqRKzWCBvLSpqnVaLtawUXoFd/8fU22fhNcZeo9bp5supYVL1pbWo8C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786588632; c=relaxed/simple;
	bh=ZAxW5Wglg+eNEd/7E2VgSitqFFT3iAHesn5itEgojfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sE+0Ttr/MPGMwJc63axv1lbjYIbkhG6Hr9giqlHC3N+1BZ026Fyuw5UHAH1XYRxB33/dNv3yoyKfKCYEsn5yid2uBbUvMFFghMfQpOO/6XslaDDryBeIirV7i4uXz+zePG0xXPzxC8gUjkCkIyicNJRT9iDlD74XXAOaXktGfWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=NOS0flO0; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="NOS0flO0"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e65e18969so39503885a.1
        for <nvdimm@lists.linux.dev>; Wed, 12 Aug 2026 19:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786588630; x=1787193430; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iAIlYFnXn3LVoMPX9IDRNtgfCfuZ8em86m2CaDU8/H0=;
        b=NOS0flO0eeGHeH8K8qp3eI8kxK0yXK+Wvg0Q2zXYqwKJC62CtGDEx8n2W5cOdElz3e
         54MctC7dmJ3CNmmGqdEsna/04sqYxUW0d+LvFBNZ9IHXVhixC4pvEMhUtTeUm/8XCh5r
         oLiwge8luzzm4eo73mcrtEw/yzYL1A+DGPTenSFnUEvMQAhpyDnAt4ZGf6IN0zWkGvPY
         tFqg0UrzRn/m7SCr9Sma8Klhm6bmoUkxRgVWNMJQCzWWXf5gLhSKqm6vhrmG86CTrI8U
         ByVFC+Xr/SxzzWS/pOcuAgI1kSAn9y/jfFyfRfeE9C4xkuLNvbTAtnPkhp+WKtzwHBQG
         AeIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786588630; x=1787193430;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iAIlYFnXn3LVoMPX9IDRNtgfCfuZ8em86m2CaDU8/H0=;
        b=gnbrL/FOT0rk0/6EXZ27V8ds4Qghi57iwdaWrzNXUOMLlm1KEIaWq2jChCkCTgqlXy
         y3LiwTeu7DQ1ml3u8FIrHqjzp76lvG4qE4XD3yxBzXgz+y1qth1uYqbbu2Lz2pyalny1
         Xk6tc8hRISNe5Bj1RQj9oWSH0S3nNXkljhOChfCALE8fv8gEEvltIHwhVB2zA8KOdl9i
         xv2Jyd/OVrGDeE8cD04B1QVZbtW2P/B1Fvo2VHfJCY1oEOmpdE7x05WCAhPHndiUR99g
         kxOhQ7ygKez/5rsz58wXsUYCJ0LmQGuhrtl41oSBk0DlAsh+Tx+xIISiM4Cb3H+L3kze
         rUJA==
X-Forwarded-Encrypted: i=1; AHgh+RoQsWceTlDULwlRppJTtS2q8j4vOLntcXaoTaHe/zOP98jmAaVUIy+U9bziYNchqVCfC6B9u4Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YwfSO5KO3X8iBcdcp+674rY8nd6/Ur/x/sJ0IOohXhO3cwaKcRp
	DvBSQvRxb6Vk8HDwGF+sVzcY36ZdO1hOFTP6uGYwzrnp1qyPlVEOF7nAXsdw2gwwnRE=
X-Gm-Gg: AR+sD106DY/WdbnMy+j+Q8AVGmgV+vz0X9mHPabWjsEghfmKk7lqx+nAqV5RLk5LnvC
	AudH10J9YeIf9qXSTUHHPHCbVFiffJBLP/5qpmvVEg9klfxZLeEJJwSnQJKOX2rr6WMdUYfQFrB
	yPNq3+pMVhcw8t+TbeV38e02tWcrEdrkpa8VEeDfkK5TJR+kvh5WOmojyeMaBTIWHm1uYj1lLdP
	ud2WpL1OkVWyMG9Qmv7HMhKYuDb7bonPNGbFkxQ+3NV1UJDF0WNLy8MYj4Ih7z+OatX7wKaXGxG
	4Hi4pDOqo0ANZJqS2RMlZGb/6vQw64QDDhVmBY4Ewv6VnvFPRq9ZVYSpeLO3Sm6a1nmm8fHZ0d5
	HQXKqxpwORWNTFoEDpongBQ9DjKV6r8VhvQ8E3vXSjwD+CycH0CBFzgOpxZ3+pKP12wZVtH//wd
	lB9bf8cjGhGRLFdDhggyKSuS9I7iZ4lbcMCYp3DPOmmIezlw==
X-Received: by 2002:a05:620a:2727:b0:92b:3203:ea70 with SMTP id af79cd13be357-936c0b68fa2mr178922485a.12.1786588630298;
        Wed, 12 Aug 2026 19:37:10 -0700 (PDT)
Received: from fedora ([2601:19e:8500:d3c0::28fe])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-936c199108csm48835385a.19.2026.08.12.19.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 19:37:09 -0700 (PDT)
Date: Wed, 12 Aug 2026 22:37:06 -0400
From: Gregory Price <gourry@gourry.net>
To: Rakie Kim <rakie.kim@sk.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	dave@stgolabs.net, jic23@kernel.org, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, harry@kernel.org, kernel_team@skhynix.com,
	honggyu.kim@sk.com, yunjeong.mun@sk.com
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted
 interleave
Message-ID: <an0t0mP9JB8f4ILK@fedora>
References: <20260806080936.421-1-rakie.kim@sk.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806080936.421-1-rakie.kim@sk.com>

On Thu, Aug 06, 2026 at 05:09:31PM +0900, Rakie Kim wrote:
> Package-aware weighted interleave places a task's weighted-interleave
> pages on the NUMA nodes of its local package, so that interleave traffic
> does not have to cross the interconnect to another package. This keeps
> each node's weight aligned with the bandwidth the task actually gets
> from it, so effective bandwidth holds up on a system that has more than
> one package. (A package is a CPU socket together with the memory
> attached to it.)
>

The only major question I have before I dig into the actual patches is
whether you actually need this on a *per-task* basis, rather than simply
a *per-process* basis - because that's all this really buys you.

You can already do what is described here by simply using a combination
of cpuset and mempolicy

cpuset.mems = 0,2
mempolicy = weighted interleave --all

If this is actually required on a per-task basis, then I agree this
concept is reasonable.  I just want to make we're grounded on a real
use case before we go adding this complexity.

~Gregory
