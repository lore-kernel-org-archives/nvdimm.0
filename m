Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B016940314E
	for <nvdimm@lists.linux.dev>; Wed, 12 Aug 2026 09:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786526313; cv=none; b=FUuuek4DbIBkWmmNJGFGBSKhrNNDHVItsSHCjD4uNhODV6Z8RxAeG4f8O7OYaa4Z89yAFIblVey+PRCUCxuswNNBgYMLFlbRNsOxPbR42L2YYbVAPNjeigGl7xR8iwn67K2Mq44glizb5zafa4XCp8w9A9c3/wj+KlAcqro36Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786526313; c=relaxed/simple;
	bh=fMFkGKGQ7IWELHdcg8i5WeaseJTu+tKJqwS8InsU7is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eX6PmwtahZkwvKiBHtN/uvBnwW9cNjlu2fBoaJ83NRV9oKzeadnPHvpYTQHVcxuh86Ov68uNBqyUXOdCbXfAUeo48d9SpoLy5AIQBqBeQLhdM226gW50U/yV47cajbO9ea8tEETW/B4zMTPz+kup02HTAoZnx5ETvGT7oFndSWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c45ff70000001609-b0-6a7c3a61053e
From: Rakie Kim <rakie.kim@sk.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org,
	gourry@gourry.net,
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
Date: Wed, 12 Aug 2026 18:18:20 +0900
Message-ID: <20260812091823.1817-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <anwcRyfzs5lklpzk@lucifer>
References: 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsXC9ZZnoW6SVU2WwZ61zBZz1q9hs7j7+AKb
	xa4bIRYnbjayWay+uYbR4vnWX4wWP+8eZ7e4fmslo8X+p89ZLB40rWKyOL51HrvFulOH2CzO
	zzrFYnF51xw2i3tr/rNavHnsZvGtT9rifp+Dxcoff1gtjqzfzmQx+dICNouOl/dZLG5NOMZk
	sXpNhsXso/fYHSQ9ds66y+6xYFOpR3fbZXaPzSu0PBbvecnksWlVJ5vHpk+T2D1OzPjN4rHz
	oaXHi80zGT16m9+xeUydXe+xfstVFo/Pm+QC+KK4bFJSczLLUov07RK4MjYt281csCi2Ysu2
	94wNjB9duxg5OSQETCS2HHjC3MXIAWa3LXYEMdkElCSO7Y0BqRAR0JG42TWNqYuRi4NZYCer
	xPyHe5lAEsICQRJd058zgtgsAqoSP15PB7N5gcYs2jOXEWK8psS6jbdYQGxOAXWJtZf/gvUK
	CfBIvNqwH6peUOLkzCdgNcwC8hLNW2czgyyTEPjKLvH2xxVmiEGSEgdX3GCZwMg/C0nPLCQ9
	CxiZVjEKZeaV5SZm5pjoZVTmZVboJefnbmIERuqy2j/ROxg/XQg+xCjAwajEw3tBpjpLiDWx
	rLgy9xCjBAezkghv9aqqLCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8Rt/KU4QE0hNLUrNTUwtS
	i2CyTBycUg2MEncvCV+zNc/7eFnOPniZs8S1sNsffSrrZFzUW67yMb5dMyGjVOruIQ7BiL9s
	J+yl134svLL360bbRc3i6QUv3O4/+z47NTxAnG/G5aXtm4t3/ZddyM5Z6PCkqGDWY7k0Vb0f
	vX//vtK4t2xW4Wapzbm3fFnVKr6Xa5WbLzrHa5K5wu+5FbeXEktxRqKhFnNRcSIA7Yb609AC
	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYQCG+87Ozo5jg9NadFIxGIkkqYUFXyFldPvqh1RkQXg75CGn25RN
	xUuSaYgtErXLdFMTLdF5n27eEZZ5I0uUTOct0ZpmpHkvtXJS4L8Hnvd9/7wkR9SM25NSRSSr
	VDAyCcHH+Vkufm7MybuhR5aGPWBOZRkBRyd7Cdg4eB2+e6ojYOfQfQKWDpUBaDX+AvDnaAcP
	frSUALj4ZZYDWz9bcfgpSY/BDmMeD77O7eLCim4zAd9ru3HY35hDwLGyP1z4bfICXElzgONp
	3rBkbYMLzQNWLmyrrMPgk758AqbOjOPQkt6OwdKyELhuKiag7s0Yz9sJNWhHeSjfEIUepfTz
	UE2xKypsnsGQQf+QQIaFTB7qzFrHUcPECTRdkw3Q4+TvBFoZRqhweh5Dz3T3UGXtBxwtGpyu
	ULf4XsGsTBrNKj1OBfFDDEVNnIgC/5ha0xxIBD/OqwFJ0tQxOqXwjA0JSkK3t/ipgR0ppg7T
	Q+rnmBrwSQ7VwKVfTLRgNrGHukarNVZgY5xyptdmNdss3JopaM7dZpo6RFdUW3Ab21EudHn/
	5nZXRAnor1Wt//K76a7sqe0MhzpAJxt1nHQg0O5Q2h0qH2B6IJYqouWMVHbcXRUWEquQxrjf
	DpcbwNanRQkbGfVgqf+iGVAkkAiEvY7xoSIuE62KlZsBTXIkYmG8Pi5UJAxmYuNYZXigMkrG
	qszAgcQl+4SXb7JBIuoOE8mGsWwEq/xvMdLOPhF0B/imh5tatJaClfpX9m9blSON9NjmoJ+P
	py5RLu9x1a5OVqUuJJW75S1P+WV4goFqSBl/TwkS+m4wmS48H9nI3gfz/ucW1YEOGseXlzSe
	vB7rnDFg19mN+fZVovz0ssm4VlXXO17Q1rT/6rwm0fmgWKLzDbtm8upTNIV2tUhwVQhz1JWj
	VDF/AdkS2W/PAgAA
X-CFilter-Loop: Reflected

On Wed, 12 Aug 2026 08:16:23 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

Hello Lorenzo,

Thank you for taking the time to review this series and for the
advice on how to submit it.

> On Thu, Aug 06, 2026 at 05:09:31PM +0900, Rakie Kim wrote:
> > Package-aware weighted interleave places a task's weighted-interleave
> > pages on the NUMA nodes of its local package, so that interleave traffic
> > does not have to cross the interconnect to another package. This keeps
> > each node's weight aligned with the bandwidth the task actually gets
> > from it, so effective bandwidth holds up on a system that has more than
> > one package. (A package is a CPU socket together with the memory
> > attached to it.)
> >
> > Changes from RFC:
> > https://lore.kernel.org/all/20260316051258.246-1-rakie.kim@sk.com/
> > - Added an opt-in sysfs toggle (off by default) and a read-only sysfs
> >   view of the package topology
> > - Added topology validation with a clean fallback to plain weighted
> >   interleave on unsupported topologies
> > - Hardened the allocation, device-teardown, and node-hotplug paths
> 
> Please put change logs under the cover letter :) in mm we put the cover
> letter in the actual upstream commit so it's better to keep separate for
> reviewers.
>

Thank you, I did not know that. I will keep the change log out of the
cover letter body from the next version.


> I see the RFC was from march and tied to an LSF session I think?
> 
> While I don't want to be too pedantic, I think you should only really
> un-RFC in a situation where you have a good sense that the relevant
> maintainers are happy with the _concept_.
> 
> Looking at the RFC thread it's not clear that David was OK with this on the
> mm side, though I see you got some feedback from Jonathan on the CXL driver
> side.
> 
> So I wonder whether next respin this should be re-RFC'd unless you get
> clear feedback that we want to go in this direction?
>

You are right about the LSF session: the RFC was posted with that
proposal in mind, but I could not attend for personal reasons, so the
discussion I had hoped for there did not happen.

Your point about the concept is fair as well, so I will post the next
version as an RFC again.


> >
> > Weighted interleave places pages on nodes in proportion to per-node
> > weights that are set from each node's bandwidth. Within one package the
> > weight given to a node matches the bandwidth a task sees from it. Across
> > packages it no longer does: a memory node's physical bandwidth is fixed,
> > but the bandwidth a task effectively sees depends on which package its
> > CPU is in, because memory reached from another package, over the
> > interconnect between them, is slower than the same memory reached within
> > the package. The weights are set once from device bandwidth and applied
> > the same way wherever the task runs, so a node in another package is
> > given a weight higher than the bandwidth it can deliver to that task.
> > The kernel has no package abstraction and does not record which package
> > a node belongs to, so it cannot tell which node pairs are separated by
> > the interconnect.
> 
> Please please - break up huge paragraphs like this :)
> 
> It's 2026 so I have to mention that if you've used AI to assist with
> writing it (which is fine) please do a pass over it manually to curb AI's
> tendency to be overly verbose + definitely try to break up paragraphs into
> smaller charts at least :)
>

I agree. Reading it again, my sentences are too long and the
explanation is more verbose than it needs to be, which makes the
cover letter hard to read. This needs to be fixed.

I will rewrite the cover letter for the next version in a form that
is easier to read.


> >
> >           node0             node1
> >         +-------+         +-------+
> >         | CPU 0 |---------| CPU 1 |
> >         +-------+         +-------+
> >         | DRAM0 |         | DRAM1 |
> >         +---+---+         +---+---+
> >             |                 |
> >         +---+---+         +---+---+
> >         | CXL 0 |         | CXL 1 |
> >         +-------+         +-------+
> >           node2             node3
> 
> ...though I _love_ ASCII diagrams so this is great ;)
>

Thank you.


> >
> > The numbers below are illustrative single-stream bandwidths (GB/s).
> > Local DRAM sustains 300 and local CXL 150; any path that crosses to
> > another package, over the interconnect, is capped at 100, so a node in
> > another package delivers 100 whether it is DRAM or CXL. Note that local
> > CXL (150) is still faster than any node in another package (100). The
> > effective bandwidth each CPU sees is therefore:
> >
> >               node0  node1  node2  node3
> > from CPU 0:    300    100    150    100
> > from CPU 1:    100    300    100    150
> >
> > Since a single per-node weight cannot encode the interconnect penalty,
> > a reasonable set of global weights is taken from local device bandwidth
> > (local DRAM : local CXL = 300 : 150 = 2 : 1): node0=2 node1=2 node2=1
> > node3=1.
> 
> Also great that you provide the receipts on actual observed real-world
> numbers that's great.
> 
> NUMA isn't my area so I can't comment here on the technical details but
> thanks for providing this :)
>

Thank you. I will keep reporting measured results with the next
versions.


> 
> >
> > Applied the same way to every source, these weights give the map:
> >
> >               node0  node1  node2  node3
> > global:         2      2      1      1
> >
> > A task on CPU 0 gives node1 - remote DRAM, effective 100 - the same
> > weight 2 as its own local node0 at 300. Worse, node1 is weighted above
> > node2, the task's local CXL at effective 150, even though node2 is the
> > faster of the two. The flat weights rank a slower interconnect-bound
> > node above a faster local one, which is exactly backwards.
> >
> > This series makes weighted interleave package-aware. When it is on,
> > weighted interleave prefers the task's current package: while the
> > package's nodes have room, the task's pages are spread across them by
> > weight, so allocations stay off the interconnect. The rest of the
> > policy nodemask is used when the local package cannot serve the request
> > - when a node in it is under pressure and the page allocator falls back
> > along the zonelist, or when the policy nodemask happens to exclude every
> > node of the current package, in which case the package spanned by the
> > policy's own nodes is used instead. The nodes considered are always
> > within the policy nodemask, which mempolicy already narrows to the
> > task's cpuset, so cpusets and the task nodemask stay in control.
> >
> >               node0  node1  node2  node3
> > from CPU 0:     2      0      1      0
> > from CPU 1:     0      2      0      1
> >
> > A task on CPU 0 now places pages on node0 (weight 2) and node2
> > (weight 1) at 2:1, which matches their effective bandwidth of 300:150;
> > a task on CPU 1 places on node1 and node3 the same way. Placement
> > follows the bandwidth each task actually sees, NUMA locality is
> > preserved, and interleave traffic stays off the interconnect.
> >
> > To make this possible the kernel needs a notion of which nodes share a
> > package. The NUMA distance model offers only relative latencies and no
> > structural grouping, which is especially limiting for CXL memory nodes
> > that come online without an explicit package association.
> >
> > The series adds a package-aware topology layer that groups CPU and
> > memory-only nodes into a "memory package", built from the physical
> > package ids firmware reports and, for a memory-only node, an initiator
> > CPU node or SLIT distances. A package can contain more than one CPU node
> > or more than one memory-only node, so the layer maps a package to a set
> > of nodes rather than to a single node or a single CXL device.
> >
> > The feature is off by default and opt-in through a sysfs toggle. The
> > package topology itself is exposed read-only under
> > /sys/devices/system/package/; there is deliberately no writable
> > override, since a machine whose firmware describes its topology
> > incorrectly should be fixed in firmware. On a topology that does not
> > have the symmetric shape the placement relies on, enabling is refused
> > and any active mode degrades cleanly to the original flat behavior.
> >
> > Measured results:
> >
> > System Configuration:
> > - Processor: Dual-Socket Intel Xeon 6980P (Granite Rapids)
> >
> > 1) Throughput (System Bandwidth)
> >    - DRAM Only: 966 GB/s
> >    - Weighted Interleave: 903 GB/s (7% decrease compared to DRAM Only)
> >    - Package-Aware Weighted Interleave: 1329 GB/s (1.33 TB/s)
> >      (38% increase compared to DRAM Only,
> >       47% increase compared to Weighted Interleave)
> >
> > 2) Loaded Latency (Under High Bandwidth)
> >    - DRAM Only: 544 ns
> >    - Weighted Interleave: 545 ns
> >    - Package-Aware Weighted Interleave: 436 ns
> >      (20% reduction compared to both)
> >
> > A small CXL driver change registers a CXL memory node into its package
> > as the node comes online, using the initiator the driver resolves for
> > the region; this is where the package layer gets the CPU-side
> > association that plain NUMA distance does not carry.
> >
> > The memory_package layer offers a broader interface for grouping and
> > querying package topology - usable by memory tiering as well - and
> > package-aware weighted interleave uses the subset it needs.
> >
> > [PATCH 1/4] mm/numa: introduce nearest_nodes_nodemask()
> >   Add a NUMA helper that returns every node sharing the minimum distance
> >   from a source node.
> >
> > [PATCH 2/4] mm/memory-tiers: package-aware topology management
> >   Group NUMA nodes into memory packages from firmware topology data,
> >   expose the grouping read-only under /sys/devices/system/package/, and
> >   validate the symmetric shape that package-aware placement relies on.
> >
> > [PATCH 3/4] mm/memory-tiers: register CXL nodes to packages
> >   Bind a CXL memory node to a package using an initiator CPU node.
> >
> > [PATCH 4/4] mm/mempolicy: package-aware weighted interleave
> >   Prefer the current package for weighted interleave node selection,
> >   behind an opt-in package_mode sysfs toggle that is off by default.
> >
> > Rakie Kim (4):
> >   mm/numa: introduce nearest_nodes_nodemask()
> >   mm/memory-tiers: introduce package-aware topology management for NUMA
> >     nodes
> >   mm/memory-tiers: register CXL nodes to memory packages via initiator
> >   mm/mempolicy: enhance weighted interleave with package-aware locality
> >
> >  .../ABI/testing/sysfs-devices-system-package  |   35 +
> >  ...fs-kernel-mm-mempolicy-weighted-interleave |   17 +
> >  drivers/cxl/core/region.c                     |   54 +
> >  drivers/cxl/cxl.h                             |    1 +
> >  drivers/dax/kmem.c                            |    3 +
> >  include/linux/memory-tiers.h                  |  113 ++
> >  include/linux/numa.h                          |   11 +
> >  mm/memory-tiers.c                             | 1009 +++++++++++++++++
> >  mm/mempolicy.c                                |  200 +++-
> >  9 files changed, 1439 insertions(+), 4 deletions(-)
> >  create mode 100644 Documentation/ABI/testing/sysfs-devices-system-package
> >
> >
> > base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
> > --
> > 2.25.1
> >
>
> --
> Cheers, Lorenzo

Thank you again for the excellent advice. What you pointed out matters
for how a patch is delivered, so I will keep it in mind for the next
version and the ones after it.

Thanks again for your time and review.

Rakie Kim
