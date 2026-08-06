Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C81B376A04;
	Thu,  6 Aug 2026 21:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786052322; cv=none; b=Zo0UWeFtnUGAnozVZoxeVq2WI17vtWNUV/67B4cIVp483Bm8vObrELKEB+t+D7xQ6H29EI6RoPcBKCEaCf16mxA4LMk4Zm85P24DEIgtqFwZZe1M6lm21rj7SGGf9VB5Kvv0lg9SsJWhp3VD9RnvK+LAEcra6b7412xs+cEUCtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786052322; c=relaxed/simple;
	bh=G/AeLCiYuC6h5MsNlRZ0dPttAI1A1OX1jswN7jaE8gA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ngFJorlJuib19aSEVaZBIHU0F7aL2YWhALgvhoCzEQ0IPk5RPGDz44MGM9uF4Avumrbijoo+N4D028lW6fhk+lr+je2l2wrhKaYz/qy6EXJd4i6GY92Uoz5PaFmE6Qlxxe6q41sV+YtRf6NE1X+QU0pb/Iz+TghUEpghN7/u/mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zjxy54s0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zjxy54s0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CE11F000E9;
	Thu,  6 Aug 2026 21:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786052320;
	bh=OdSJMrJlxA1asmksffSS7egTxrO++CqOSNiKS3XRtU4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zjxy54s0gXPPsGHZIbAvAKttEKxy2PzcRJmEIuRHuJ97thXY4DxgfdKV5f2fK4/0A
	 AttBLyPvNdIZR/74p8R2Ye3DhHCLys2g+CmbnhbeR/JdYRlV/nMjV8SDBR6m8I6rHn
	 pSeQv6rAxWR0oHt0WqIfcFQyb+GQBe8ri9AiY5ug=
Date: Thu, 6 Aug 2026 14:38:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rakie Kim <rakie.kim@sk.com>
Cc: gourry@gourry.net, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, dave@stgolabs.net, jic23@kernel.org,
 dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com,
 ira.weiny@intel.com, harry@kernel.org, kernel_team@skhynix.com,
 honggyu.kim@sk.com, yunjeong.mun@sk.com
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted
 interleave
Message-Id: <20260806143839.cf5226e6d5c8254098bf3d74@linux-foundation.org>
In-Reply-To: <20260806080936.421-1-rakie.kim@sk.com>
References: <20260806080936.421-1-rakie.kim@sk.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  6 Aug 2026 17:09:31 +0900 Rakie Kim <rakie.kim@sk.com> wrote:

> Package-aware weighted interleave places a task's weighted-interleave
> pages on the NUMA nodes of its local package, so that interleave traffic
> does not have to cross the interconnect to another package. This keeps
> each node's weight aligned with the bandwidth the task actually gets
> from it, so effective bandwidth holds up on a system that has more than
> one package. (A package is a CPU socket together with the memory
> attached to it.)

"package" is not a familiar term in MM.  It would be helpful if the
[0/N] were to carefully and fully define/describe the new term before
using it 40 times!

> Measured results:
> 
> System Configuration:
> - Processor: Dual-Socket Intel Xeon 6980P (Granite Rapids)
> 
> 1) Throughput (System Bandwidth)
>    - DRAM Only: 966 GB/s
>    - Weighted Interleave: 903 GB/s (7% decrease compared to DRAM Only)
>    - Package-Aware Weighted Interleave: 1329 GB/s (1.33 TB/s)
>      (38% increase compared to DRAM Only,
>       47% increase compared to Weighted Interleave)
> 
> 2) Loaded Latency (Under High Bandwidth)
>    - DRAM Only: 544 ns
>    - Weighted Interleave: 545 ns
>    - Package-Aware Weighted Interleave: 436 ns
>      (20% reduction compared to both)

Well that sounds nice.

>  .../ABI/testing/sysfs-devices-system-package  |   35 +
>  ...fs-kernel-mm-mempolicy-weighted-interleave |   17 +
>  drivers/cxl/core/region.c                     |   54 +
>  drivers/cxl/cxl.h                             |    1 +
>  drivers/dax/kmem.c                            |    3 +
>  include/linux/memory-tiers.h                  |  113 ++
>  include/linux/numa.h                          |   11 +
>  mm/memory-tiers.c                             | 1009 +++++++++++++++++
>  mm/mempolicy.c                                |  200 +++-

Are some user-facing Documentation/ updates appropriate?

The Documentation/ABI things are rather dry and information-free.  How
about some documentation for the operator who is wondering "should I
use this and if so why and how"?


The runtime sysfs on/off tunable is interesting.  I hear from google
operations people that every new feature should have such an "off"
switch so that if development send them a new thing and they think it's
problematic, they can disable it in order to quickly get back to the
old regime.  Perhaps that was your motivation, perhaps not.  Can you
please describe?


I see you've been emailed the Sashiko report, which appears substantial.
	https://sashiko.dev/#/patchset/20260806080936.421-1-rakie.kim@sk.com

