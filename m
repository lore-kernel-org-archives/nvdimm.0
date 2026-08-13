Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6451AAE17
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 06:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786602246; cv=none; b=TBet4bDHj3DZ8jUYSi04E9MKolzRpf0jUAeWZTmqLUccYCcvgu8x/7vdBT5Ur3RHqDMateMnsgfcQGyIuK2kVcmzQObvgis7VA8crx1DQO8B2DDs55SOnIwZdDot4MPy52YYK1bvh6C7bvNmK7PkFsRqL6t3mtc7xOtSBx9uJ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786602246; c=relaxed/simple;
	bh=p9vlB+ACUZNAVmnFgplEx9kechMV0utghaut9CeHgiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q07cMdlWV9QMezEFrjhPKGYBAv2mC4sIjE8mV17cdga1AJCuHy443VCvTQxEhHiLkSS0g4siDmMSSVPGecMG/Yu2VoCUPpyoaDcQmeHP1VTRA5YZxyqwgQ1AlEJuMmFDtX8xtr1LH3HKZ/vu+kF+D/kyDvmjwhGesXUlYFULEOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-ad-6a7d62f9452f
From: Rakie Kim <rakie.kim@sk.com>
To: Gregory Price <gourry@gourry.net>
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	harry@kernel.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted interleave
Date: Thu, 13 Aug 2026 15:23:48 +0900
Message-ID: <20260813062351.1856-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <an0t0mP9JB8f4ILK@fedora>
References: 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsXC9ZZnoe6vpNosg3n9bBZz1q9hs7j7+AKb
	xa4bIRYnbjayWay+uYbR4vnWX4wWP+8eZ7e4fmslo8X+p89ZLB40rWKyOL51HrvFulOH2CzO
	zzrFYnF51xw2i3tr/rNavHnsZvGtT9rifp+Dxcoff1gtjqzfzmQx+dICNouOl/dZLG5NOMZk
	sXpNhsXso/fYHSQ9ds66y+6xYFOpR3fbZXaPzSu0PBbvecnksWlVJ5vHpk+T2D1OzPjN4rHz
	oaXHi80zGT16m9+xeUydXe+xfstVFo/Pm+QC+KK4bFJSczLLUov07RK4Mg5ezC+4IV/R9PkB
	SwPjE4kuRg4OCQETif5LJl2MnGDm+oa7rCBhNgEliWN7Y0BMEQFVibYr7iAVzALbWCVuXdQE
	sYUFgiS6pj9nBLFZgErWPp3LBGLzAk3ZsKmJDWKipsS6jbdYQGxOATWJrn8QNUICPBKvNuxn
	hKgXlDg58wkLxHx5ieats5m7GLmAej+yS5xYcYQJYpCkxMEVN1gmMPLPQtIzC0nPAkamVYxC
	mXlluYmZOSZ6GZV5mRV6yfm5mxiBMbqs9k/0DsZPF4IPMQpwMCrx8GY012QJsSaWFVfmHmKU
	4GBWEuGtXlWVJcSbklhZlVqUH19UmpNafIhRmoNFSZzX6Ft5ipBAemJJanZqakFqEUyWiYNT
	qoHRKHdT8Zr9rAVME2yOhHoHX1/Zwb542v6LL+4WvFpnwxHUtI+h8+AJWaN0/f8aYisCM4LP
	e36OrLmRb3rqFfPuvxH/N+s8+m4mnKz4RX3z/Nh1K+z3lC+eWOCf57F3QVW+2clF2+Z92Hfx
	nqG09JV7T1T2TVz1s+T4xp0GeY6fyjY03Km4Lfy5QomlOCPRUIu5qDgRAOp90W3NAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsXCNUM9RvdnUm2WwcH1BhZz1q9hs7j7+AKb
	xa4bIRbnpsxmszhxs5HNYvXNNYwWz7f+YrT4efc4u8X1WysZLT4/e81ssf/pcxaLB02rmCyO
	b53HbnF47klWi3WnDrFZnJ91isXi8q45bBb31vxntXjz2M3iW5+0xf0+B4uVP/6wWhy69pzV
	4sj67UwWky8tYLPoeHmfxeLWhGNMFqvXZFj83raCzWL20XvsDnIeO2fdZfdYsKnUo7vtMrvH
	5hVaHov3vGTy2LSqk81j06dJ7B4nZvxm8dj50NLjxeaZjB69ze/YPL7d9vBY/OIDk8fU2fUe
	67dcZfH4vEkuQCCKyyYlNSezLLVI3y6BK+PgxfyCG/IVTZ8fsDQwPpHoYuTkkBAwkVjfcJe1
	i5GDg01ASeLY3hgQU0RAVaLtijtIBbPANlaJWxc1QWxhgSCJrunPGUFsFqCStU/nMoHYvEBT
	NmxqYoOYqCmxbuMtFhCbU0BNousfRI2QAI/Eqw37GSHqBSVOznzCAjFfXqJ562zmCYw8s5Ck
	ZiFJLWBkWsUokplXlpuYmWOqV5ydUZmXWaGXnJ+7iREYo8tq/0zcwfjlsvshRgEORiUe3ozm
	miwh1sSy4srcQ4wSHMxKIrzVq6qyhHhTEiurUovy44tKc1KLDzFKc7AoifN6hacmCAmkJ5ak
	ZqemFqQWwWSZODilGhinT3rebX9+cXDdo8Nu/jMcpDMlz39/clMud6LFTZ2N/fu21W1W3hvh
	n7aqwfOtZ3HWrxP/t05M3CjyTsHmkKmtkWqWqlML04RVb22rLk4NF970+Y3m1K7VTXdNrmlf
	XrDkvY+L8wHzNXy/H8h0RN5J7Pvxxm1PiMO530f5zBdbrr3ZaKvLX52jxFKckWioxVxUnAgA
	4pG6rs0CAAA=
X-CFilter-Loop: Reflected

On Wed, 12 Aug 2026 22:37:06 -0400 Gregory Price <gourry@gourry.net> wrote:
> On Thu, Aug 06, 2026 at 05:09:31PM +0900, Rakie Kim wrote:
> > Package-aware weighted interleave places a task's weighted-interleave
> > pages on the NUMA nodes of its local package, so that interleave traffic
> > does not have to cross the interconnect to another package. This keeps
> > each node's weight aligned with the bandwidth the task actually gets
> > from it, so effective bandwidth holds up on a system that has more than
> > one package. (A package is a CPU socket together with the memory
> > attached to it.)
> >
>
> The only major question I have before I dig into the actual patches is
> whether you actually need this on a *per-task* basis, rather than simply
> a *per-process* basis - because that's all this really buys you.
>
> You can already do what is described here by simply using a combination
> of cpuset and mempolicy
>
> cpuset.mems = 0,2
> mempolicy = weighted interleave --all
>
> If this is actually required on a per-task basis, then I agree this
> concept is reasonable.  I just want to make we're grounded on a real
> use case before we go adding this complexity.
>
> ~Gregory

Hello Gregory,

Thank you for reviewing this series. My description was not precise
enough, and it seems to have confused several people. Let me go over
the example again.

I labelled the rows "from CPU 0" and "from CPU 1", which reads as two
separate tasks, each pinned to one place. What the rows were meant to
show is which package the allocation is requested from:

                  node0  node1  node2  node3
from package 0:     2      0      1      0
from package 1:     0      2      0      1

Both rows come from one policy at the same time. Which row applies is
decided per allocation, by the package the requesting CPU is in.

The cpuset.mems = 0,2 you describe is the node set of package 0, so
the tasks in that cgroup use node0 and node2 wherever they run.

The feature I am proposing does not fix a package that way. It uses
the nodes of the package the request comes from.

To build the feature I am proposing with cpuset, I think you would
need a cgroup per package and would have to place each thread in the
one matching the package its CPU is in.

cpuset.mems does not follow the CPU, so unless cpuset.cpus is set
alongside it, a thread running on a CPU of package 1 would use node0
and node2. For a program with tens or hundreds of threads, keeping
that placement right does not look easy.

To put it plainly, what this series aims for is that when a process
with many threads runs across several packages, each thread's
allocations are weighted-interleaved within the nodes of the package
that thread is on.

There is one process and one policy, but the nodes actually used
differ with where each thread sits. That is why I think this has to be
per task rather than per process.

The workloads I had in mind are memory-intensive server workloads:
vector databases as used in AI applications, or in-memory key-value
caching services that sit in front of large services and keep their
data in memory.

They run with a great many threads, spread across several packages and
running at the same time, and they want as much memory bandwidth as
they can get.

That is also why the numbers were measured with MLC. It produces high
bandwidth from many threads, much like those workloads, while still
giving a quantitative result.

The runs used "numactl -w all mlc" with no CPU binding, so the threads
were spread over both packages, and in that configuration the
bandwidth was higher than with the existing weighted interleave.

That is the reasoning behind my thinking that this belongs at the task
level. In the next version I will strengthen the documentation,
including why this feature is needed.

Thank you for taking the time to review this and for the question. It
made it much clearer to me what the cover letter still needs to
explain.

Rakie Kim
