Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABD83CBE69
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 15:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776094416; cv=none; b=d6BASd8ZwtsRVLZobRevMiA3YoAQECtjTR8jS+bOmVkxv/gg/DI3rpyWay3G+DJ/p6cjZdnL/SV48RSdmi8jWxkqKcEvQ4Qxf5kNDwWE7qzG1e2fjgTjF/8CL7dN5tcFiT8KtenF3R9YUjh7le6uGgFcKtxgo4408Gat09lKs1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776094416; c=relaxed/simple;
	bh=iX4hzBFj2m2KZiJVUrG8vp2JMXC1uhBlllLkPM8W0L4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jqckXQuCiMOJVQTbylQ1eKoO3n+yyOpwf23vqLi1Sy8Imup3uh6SWVbzqaoToZd6HNVFTUXYlZhRGo7+/PxR+2ewoZqjwXd/Vz+PKZApxKPDJiG4itYMOtMpOGKk2P8hlfp0BnSCzxNaqVmgOALMaeT4CYx/CyIHA4jNE59I/Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jSBrHPB5; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jSBrHPB5"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4887fd35e60so32363425e9.2
        for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 08:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776094414; x=1776699214; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ShgF/BpsS7cAVnwA77xlwKbX+t0sp7V8xBcXlbEXIY=;
        b=jSBrHPB5aB+KtBHxqGW6Fz81tXyRDW5tzFEm4zg3lpe85WPoDagRA6pyE0BzqLEMYa
         nj/mNhYmyF/tYSIv6A6epkEZ1bVMANx2XSBtlxXWXQhyoB+bAuY9pBx7Awmr21cdKNPv
         3RuE9P3K0PDwQ3fTgwyh89ZlINjOAOL7wJ54/2EKABVpTFfnwDH3SNNSKJ9gAQ08ePwa
         p2pDGH4OuhdgqCzcg2NhIm3fkwbkvE6JcIILLVdes6BnWVv991AKrxTPvqziPvGYm9+J
         1ZmZug1I0lE4Ol6NtcTs0okv7w4aEAo/mkKXT5s0+7g2mBRT8Hnp4X562MbwZERMne6a
         nIUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776094414; x=1776699214;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ShgF/BpsS7cAVnwA77xlwKbX+t0sp7V8xBcXlbEXIY=;
        b=kTLlxZoM4ucLRdGtzsieieKVQ8be7C77bckYJ1QThcndoBbc8U1sKAg6T+lbosDDYX
         r4PEtrUYqiq+lprQD6xGmeBys5s4J5Tq8mDJYmydL9xm7d/TNfmoaFOhpTXTHYRSd0h9
         22ea1FMLlrjrQ42/hEM0pA3m67JhQgePqjd3sMz61W5BJ4ecJuf04Im8Ugu5fpDAKMqE
         T2/lY7gZgXe2nutNoth3OkV5TGGOG+f1y74Nki/y1WTjHRwsAxMtRl4hj0P7XsS4d3cO
         Z+TuL/tcHM5W3y0prAKJNZKTat7cPF4E7PVHXKBO1R2JOhzy3QE/52tKR5hwCArw/+D0
         f18A==
X-Forwarded-Encrypted: i=1; AFNElJ+cfnjZIybZ+xbyDa9yp9P4EzVEEQd0VxU95LHJzp6nyOTPeloASyFEFgsSw1Z+JLquZv3kvoU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTPFlPa1FPt1D9EcjV/WsErgrqyL2PlQVHuX3LUn4467bZ8EeU
	MG51aa//Xw5w6gjgUe1mzdv4jIx3g/X1PZx/JVFa2GW85BSMss/lq9Rj
X-Gm-Gg: AeBDietJ2rPZPf9bNtKUCtvKNZKDVNJVqKzRaxlOPLKLhMgEoNCEGpkoS4P0f7Qt46I
	T1Cb3f9V4w+2MUxMH4vS12FRWGrK2YOMP0LSDqLQW8SVtNfwtkZhY5JG8JI4bcCkbohZAV+caWd
	VBQ3FV/7EJ37CxxRrMgrS25p+qacNV8M8GLJ2pBT21hyj9MGvNtaGxaBps7I3vE8nZCMx7TUNA/
	PTUilHSU7WxsfkOblyHwFTkOz2biA/SOJpKNJU00puHhLI2HIUjEkJ1WRq8UK8QBikkQVkSi6wn
	0S6qiwR4ric86dAlMo1NWHEnSlAhMJe0nbgC/oqMOSHeFHFUkyDfGWhMnbaw7YTHvbxJSi8d+Je
	CA6L2kKWxzbhedg3fSc5Ab86cOYoXrQ7z9WbZyRbOSgyWjQAKboplj5AE9/4gWY/S6vDW4lX1+6
	DW8ThMU9n13RrjowyqkWmI+880WtpaT0FnPn7khd+zl6tH2DdBnWPu6FbKNg4ugPtLuftkGu8=
X-Received: by 2002:a05:600c:314b:b0:488:b241:2c5f with SMTP id 5b1f17b1804b1-488d687c076mr159606435e9.26.1776094413364;
        Mon, 13 Apr 2026 08:33:33 -0700 (PDT)
Received: from f (cst-prg-89-171.cust.vodafone.cz. [46.135.89.171])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d684406bsm94248555e9.24.2026.04.13.08.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 08:33:31 -0700 (PDT)
Date: Mon, 13 Apr 2026 17:33:21 +0200
From: Mateusz Guzik <mjguzik@gmail.com>
To: Huang Shijie <huangsj@hygon.cn>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, muchun.song@linux.dev, 
	osalvador@suse.de, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-parisc@vger.kernel.org, nvdimm@lists.linux.dev, 
	zhongyuan@hygon.cn, fangbaoshun@hygon.cn, yingzhiwei@hygon.cn
Subject: Re: [PATCH 0/3] mm: split the file's i_mmap tree for NUMA
Message-ID: <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
References: <20260413062042.804-1-huangsj@hygon.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260413062042.804-1-huangsj@hygon.cn>

On Mon, Apr 13, 2026 at 02:20:39PM +0800, Huang Shijie wrote:
>   In NUMA, there are maybe many NUMA nodes and many CPUs.
> For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
> In the UnixBench tests, there is a test "execl" which tests
> the execve system call.
> 
>   When we test our server with "./Run -c 384 execl",
> the test result is not good enough. The i_mmap locks contended heavily on
> "libc.so" and "ld.so". For example, the i_mmap tree for "libc.so" can have 
> over 6000 VMAs, all the VMAs can be in different NUMA mode.
> The insert/remove operations do not run quickly enough.
> 
> patch 1 & patch 2 are try to hide the direct access of i_mmap.
> patch 3 splits the i_mmap into sibling trees, and we can get better 
> performance with this patch set:
>     we can get 77% performance improvement(10 times average)
> 

To my reading you kept the lock as-is and only distributed the protected
state.

While I don't doubt the improvement, I'm confident should you take a
look at the profile you are going to find this still does not scale with
rwsem being one of the problems (there are other global locks, some of
which have experimental patches for).

Apart from that this does nothing to help high core systems which are
all one node, which imo puts another question mark on this specific
proposal.

Of course one may question whether a RB tree is the right choice here,
it may be the lock-protected cost can go way down with merely a better
data structure.

Regardless of that, for actual scalability, there will be no way around
decentralazing locking around this and partitioning per some core count
(not just by numa awareness).

Decentralizing locking is definitely possible, but I have not looked
into specifics of how problematic it is. Best case scenario it will
merely with separate locks. Worst case scenario something needs a fully
stabilized state for traversal, in that case another rw lock can be
slapped around this, creating locking order read lock -> per-subset
write lock -- this will suffer scalability due to the read locking, but
it will still scale drastically better as apart from that there will be
no serialization. In this setting the problematic consumer will write
lock the new thing to stabilize the state.

So my non-maintainer opinion is that the patchset is not worth it as it
fails to address anything for significantly more common and already
affected setups.

Have you looked into splitting the lock?
