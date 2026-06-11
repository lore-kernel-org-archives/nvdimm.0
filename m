Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E033FD94C;
	Thu, 11 Jun 2026 16:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781193669; cv=none; b=q5jhENJANKH0OfH+Ks65/73R0sK/V3ZtxOu/jyEbgZfLL8MqYa6h7P8GezwH0MkUSyIuppI5RtAUslVb3tctYHYbYfQ/A7QMstiXG8FgXhe/LKvBzGAOR6j5MPGoQqX0KrkgsqxdinBu/jD5ABC1bxAVe6e1aoewLY0jCxYuOts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781193669; c=relaxed/simple;
	bh=8Fh4IVoDtk0GLFrzgFzfzN0FNODMW++KeLv36dKvg3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tR+W8IdwrrLFzToXzj0OFuPtIWRQTqAwyJaTrna3Mqzu9Lf3JzErD+i59HsSQoS3pKp9RiMGG8R3PJCKBcTP4pAF7T4jg9ZYLNkUkLmYvEsVImhMJjPyU/hXBghJzNC5BZSpeLh3/xCjL4KfCLiIegjSTozso/Po2M0veh4BWiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Agon439w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Agon439w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7491F00893;
	Thu, 11 Jun 2026 16:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781193667;
	bh=OwWE4lbKK0T3ZfG4RSM1mqAP2yW+nfdYO3kCAr+3V9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Agon439wUBrQ/uonepv6QEQHD/Z6m9RS5Xb1WWxv0Q0wtFCqyeaUMDuH0YQ8F7h0k
	 poSBPrZ26U6e7yClapl80sHwPywpSo1ut24RqLlXqmKw9hqFEnVKp4lveByc+2vqB3
	 EclGyTzkzaf/JuT0Y3YBNKGWeKbjVkE7GFozcXEUaXdNNGcdC3plff9fkmEzUEr8SF
	 yLRHAf/w30nkrr5M5sh+jsu8VOfRlN45yDsLJie0TAMYvIFEMuSK4TFwnyZ712ahH2
	 NhS25Ts0oai4t03guxudm8WtA2u3sbx6tJpv0YIWL+aZL2eWXqKdHCQGfxrg1QzJzC
	 +XiDkTpLLoHog==
Date: Thu, 11 Jun 2026 17:00:49 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Huang Shijie <huangsj@hygon.cn>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	surenb@google.com, mjguzik@gmail.com, liam@infradead.org, vbabka@kernel.org, 
	shakeel.butt@linux.dev, rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, linux@armlinux.org.uk, dinguyen@kernel.org, 
	schuster.simon@siemens-energy.com, James.Bottomley@hansenpartnership.com, deller@gmx.de, 
	djbw@kernel.org, willy@infradead.org, peterz@infradead.org, mingo@redhat.com, 
	acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	james.clark@linaro.org, mhiramat@kernel.org, oleg@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, linmiaohe@huawei.com, 
	nao.horiguchi@gmail.com, jannh@google.com, pfalcato@suse.de, riel@surriel.com, 
	harry@kernel.org, will@kernel.org, brian.ruley@gehealthcare.com, 
	rmk+kernel@armlinux.org.uk, dave.anglin@bell.net, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, zhongyuan@hygon.cn, fangbaoshun@hygon.cn, yingzhiwei@hygon.cn
Subject: Re: [PATCH v2 0/4] mm: split the file's i_mmap tree for NUMA
Message-ID: <airY5q_SspdbQDbi@lucifer>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611061915.2354307-1-huangsj@hygon.cn>

Hi Huang,

You seem to be replacing the file rmap altogether here, so you really ought
to have sent this as an RFC so we could discuss it as a community first.

Especially so as Pedro had publicly mentioned his plans to implement
something similar here, so coordination would have been appreciated.

Anyway, as Pedro has pointed out, the code is overly complicated, it's far
too configurable (not always a good thing), and the locking implementation
is questionable.

You seem to be adding a whole bunch of open-coded complexity too, which is
not something we want. Abstraction is key for the rmap.

You're also not adding any kdoc comments or really many comments at all,
and you've not added any tests (though perhaps it's difficult given how
core this is).

So I would suggest that perhaps any respin should be sent as an RFC so we
can engage in that conversation and ensure we're all on the same page?

Especially since Pedro plans to send an alternative, simpler, solution I
believe.

It's also not helpful that you haven't examined the non-NUMA case :)
perhaps your particular server behaves a certain way that this approach
aids, but regresses other NUMA configurations?

We'd really need to be sure of this before accepting invasive changes like
this.

Thanks, Lorenzo

On Thu, Jun 11, 2026 at 02:18:56PM +0800, Huang Shijie wrote:
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

You really need to send detailed, statistically valid numbers across
different NUMA configurations for changes like this to be considered.

>
> patch 1 & patch 2 are try to hide the direct access of i_mmap.
> patch 3 splits the i_mmap into sibling trees, each tree has separate lock,
> and we can get better performance with this patch set in our NUMA server:
>     we can get over 400% performance improvement.
>
> I did not test the non-NUMA case, since I do not have such server.

Yeah this isn't a great thing to hear :) you need to demonstrate this
doesn't regress non-NUMA machines or NUMA machines of a different
configuration.

>
> v1 --> v2:
> 	Not only split the immap tree, but also split the lock.
> 	v1 : https://lkml.org/lkml/2026/4/13/199
>
> Huang Shijie (4):
>   mm: use mapping_mapped to simplify the code
>   mm: use get_i_mmap_root to access the file's i_mmap
>   mm/fs: split the file's i_mmap tree
>   docs/mm: update document for split i_mmap tree
>
>  Documentation/mm/process_addrs.rst |  63 +++++++---
>  arch/arm/mm/fault-armv.c           |   3 +-
>  arch/arm/mm/flush.c                |   3 +-
>  arch/nios2/mm/cacheflush.c         |   3 +-
>  arch/parisc/kernel/cache.c         |   4 +-
>  fs/Kconfig                         |   8 ++
>  fs/dax.c                           |   3 +-
>  fs/hugetlbfs/inode.c               |  30 +++--
>  fs/inode.c                         |  75 +++++++++++-
>  include/linux/fs.h                 | 179 ++++++++++++++++++++++++++++-
>  include/linux/mm.h                 |  81 +++++++++++++
>  include/linux/mm_types.h           |   3 +
>  kernel/events/uprobes.c            |   3 +-
>  mm/hugetlb.c                       |   7 +-
>  mm/internal.h                      |   3 +-
>  mm/khugepaged.c                    |   6 +-
>  mm/memory-failure.c                |   8 +-
>  mm/memory.c                        |   8 +-
>  mm/mmap.c                          |  11 +-
>  mm/nommu.c                         |  28 +++--
>  mm/pagewalk.c                      |   4 +-
>  mm/rmap.c                          |   2 +-
>  mm/vma.c                           |  74 +++++++++---
>  mm/vma_init.c                      |   3 +
>  24 files changed, 534 insertions(+), 78 deletions(-)

This is a _lot_ of changes you're making here. It therefore feels like the
abstraction is broken somewhat?

>
> --
> 2.53.0
>
>

Thanks, Lorenzo
