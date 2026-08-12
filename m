Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B744357D12;
	Wed, 12 Aug 2026 07:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786519008; cv=none; b=hh9T3pEtAh5OO4Z5Hqb/XMOksHhRujOEVTuPLK3CoHI80fAENJRXcIhYyRhe6h/06f3V0S3wtbnbPoxteNl8GON8fa5OkVKW8CmR8fWgCmca1ZD/83mtsX+LdQ+p+nkNUNU+yjS813qseWO7hNRTB60iecNxwSC+kaFvrDkagkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786519008; c=relaxed/simple;
	bh=e75onvjPBRb2hJYGf0/2rSsAMR/+0pFYOGit7CfKW14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=il3I7RNzFyo+8EfLAAUDQpC5q14sOm/XrkG154XLIxl5H6eGP4XcKIBIjACQX74lVF+TCPtUL93PgkUR1tYYlkAo5vhNuqC+xIP27g0cs6q0nsF1AQYLHB2p1+EJ8aVWnVi0NObMlPDmMwOoHZxWIVMkavmtY5sEjEOSyzZANb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jfUvDiAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jfUvDiAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16061F000E9;
	Wed, 12 Aug 2026 07:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786519006;
	bh=YtcFPckNRhnB0NSBekrVdrI1nx3c9jQI/qZ671uj+E4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jfUvDiAVnm1uecPldZ04arCCOPdU6I/PZxFMo0pClK4MQsDI4iKIE5C5K9KMFNDlu
	 6xaw2tAerpjM5G6w9HoKl74wKXEdir3hoXDpCZPGxXtLK7UHqUEuPyM8bTiePZZMUu
	 0hks3MSHUKBu4gWTi6AIg6xePZgJTSZ7SG2/p8Dji9VI+wS75+WAikdMOc4BFFNoEf
	 tp+nzk2CCBcqsu5yRqKqJfE6VV8WeRbkj26YTBKK0OxDH4wnIMsRRJlsRkpw4aZ2Oz
	 6Ljd4L2kdI3h70rt1q1eQHSwharzCvN/2qJd6IXblE9VDP+0f84AFvQXKxpBB5MtjI
	 il/H9ZX9iGbIA==
Date: Wed, 12 Aug 2026 08:16:23 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Rakie Kim <rakie.kim@sk.com>
Cc: akpm@linux-foundation.org, gourry@gourry.net, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, dave@stgolabs.net, jic23@kernel.org, 
	dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com, 
	ira.weiny@intel.com, harry@kernel.org, kernel_team@skhynix.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted
 interleave
Message-ID: <anwcRyfzs5lklpzk@lucifer>
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
> Changes from RFC:
> https://lore.kernel.org/all/20260316051258.246-1-rakie.kim@sk.com/
> - Added an opt-in sysfs toggle (off by default) and a read-only sysfs
>   view of the package topology
> - Added topology validation with a clean fallback to plain weighted
>   interleave on unsupported topologies
> - Hardened the allocation, device-teardown, and node-hotplug paths

Please put change logs under the cover letter :) in mm we put the cover
letter in the actual upstream commit so it's better to keep separate for
reviewers.

I see the RFC was from march and tied to an LSF session I think?

While I don't want to be too pedantic, I think you should only really
un-RFC in a situation where you have a good sense that the relevant
maintainers are happy with the _concept_.

Looking at the RFC thread it's not clear that David was OK with this on the
mm side, though I see you got some feedback from Jonathan on the CXL driver
side.

So I wonder whether next respin this should be re-RFC'd unless you get
clear feedback that we want to go in this direction?

>
> Weighted interleave places pages on nodes in proportion to per-node
> weights that are set from each node's bandwidth. Within one package the
> weight given to a node matches the bandwidth a task sees from it. Across
> packages it no longer does: a memory node's physical bandwidth is fixed,
> but the bandwidth a task effectively sees depends on which package its
> CPU is in, because memory reached from another package, over the
> interconnect between them, is slower than the same memory reached within
> the package. The weights are set once from device bandwidth and applied
> the same way wherever the task runs, so a node in another package is
> given a weight higher than the bandwidth it can deliver to that task.
> The kernel has no package abstraction and does not record which package
> a node belongs to, so it cannot tell which node pairs are separated by
> the interconnect.

Please please - break up huge paragraphs like this :)

It's 2026 so I have to mention that if you've used AI to assist with
writing it (which is fine) please do a pass over it manually to curb AI's
tendency to be overly verbose + definitely try to break up paragraphs into
smaller charts at least :)

>
>           node0             node1
>         +-------+         +-------+
>         | CPU 0 |---------| CPU 1 |
>         +-------+         +-------+
>         | DRAM0 |         | DRAM1 |
>         +---+---+         +---+---+
>             |                 |
>         +---+---+         +---+---+
>         | CXL 0 |         | CXL 1 |
>         +-------+         +-------+
>           node2             node3

...though I _love_ ASCII diagrams so this is great ;)

>
> The numbers below are illustrative single-stream bandwidths (GB/s).
> Local DRAM sustains 300 and local CXL 150; any path that crosses to
> another package, over the interconnect, is capped at 100, so a node in
> another package delivers 100 whether it is DRAM or CXL. Note that local
> CXL (150) is still faster than any node in another package (100). The
> effective bandwidth each CPU sees is therefore:
>
>               node0  node1  node2  node3
> from CPU 0:    300    100    150    100
> from CPU 1:    100    300    100    150
>
> Since a single per-node weight cannot encode the interconnect penalty,
> a reasonable set of global weights is taken from local device bandwidth
> (local DRAM : local CXL = 300 : 150 = 2 : 1): node0=2 node1=2 node2=1
> node3=1.

Also great that you provide the receipts on actual observed real-world
numbers that's great.

NUMA isn't my area so I can't comment here on the technical details but
thanks for providing this :)


>
> Applied the same way to every source, these weights give the map:
>
>               node0  node1  node2  node3
> global:         2      2      1      1
>
> A task on CPU 0 gives node1 - remote DRAM, effective 100 - the same
> weight 2 as its own local node0 at 300. Worse, node1 is weighted above
> node2, the task's local CXL at effective 150, even though node2 is the
> faster of the two. The flat weights rank a slower interconnect-bound
> node above a faster local one, which is exactly backwards.
>
> This series makes weighted interleave package-aware. When it is on,
> weighted interleave prefers the task's current package: while the
> package's nodes have room, the task's pages are spread across them by
> weight, so allocations stay off the interconnect. The rest of the
> policy nodemask is used when the local package cannot serve the request
> - when a node in it is under pressure and the page allocator falls back
> along the zonelist, or when the policy nodemask happens to exclude every
> node of the current package, in which case the package spanned by the
> policy's own nodes is used instead. The nodes considered are always
> within the policy nodemask, which mempolicy already narrows to the
> task's cpuset, so cpusets and the task nodemask stay in control.
>
>               node0  node1  node2  node3
> from CPU 0:     2      0      1      0
> from CPU 1:     0      2      0      1
>
> A task on CPU 0 now places pages on node0 (weight 2) and node2
> (weight 1) at 2:1, which matches their effective bandwidth of 300:150;
> a task on CPU 1 places on node1 and node3 the same way. Placement
> follows the bandwidth each task actually sees, NUMA locality is
> preserved, and interleave traffic stays off the interconnect.
>
> To make this possible the kernel needs a notion of which nodes share a
> package. The NUMA distance model offers only relative latencies and no
> structural grouping, which is especially limiting for CXL memory nodes
> that come online without an explicit package association.
>
> The series adds a package-aware topology layer that groups CPU and
> memory-only nodes into a "memory package", built from the physical
> package ids firmware reports and, for a memory-only node, an initiator
> CPU node or SLIT distances. A package can contain more than one CPU node
> or more than one memory-only node, so the layer maps a package to a set
> of nodes rather than to a single node or a single CXL device.
>
> The feature is off by default and opt-in through a sysfs toggle. The
> package topology itself is exposed read-only under
> /sys/devices/system/package/; there is deliberately no writable
> override, since a machine whose firmware describes its topology
> incorrectly should be fixed in firmware. On a topology that does not
> have the symmetric shape the placement relies on, enabling is refused
> and any active mode degrades cleanly to the original flat behavior.
>
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
>
> A small CXL driver change registers a CXL memory node into its package
> as the node comes online, using the initiator the driver resolves for
> the region; this is where the package layer gets the CPU-side
> association that plain NUMA distance does not carry.
>
> The memory_package layer offers a broader interface for grouping and
> querying package topology - usable by memory tiering as well - and
> package-aware weighted interleave uses the subset it needs.
>
> [PATCH 1/4] mm/numa: introduce nearest_nodes_nodemask()
>   Add a NUMA helper that returns every node sharing the minimum distance
>   from a source node.
>
> [PATCH 2/4] mm/memory-tiers: package-aware topology management
>   Group NUMA nodes into memory packages from firmware topology data,
>   expose the grouping read-only under /sys/devices/system/package/, and
>   validate the symmetric shape that package-aware placement relies on.
>
> [PATCH 3/4] mm/memory-tiers: register CXL nodes to packages
>   Bind a CXL memory node to a package using an initiator CPU node.
>
> [PATCH 4/4] mm/mempolicy: package-aware weighted interleave
>   Prefer the current package for weighted interleave node selection,
>   behind an opt-in package_mode sysfs toggle that is off by default.
>
> Rakie Kim (4):
>   mm/numa: introduce nearest_nodes_nodemask()
>   mm/memory-tiers: introduce package-aware topology management for NUMA
>     nodes
>   mm/memory-tiers: register CXL nodes to memory packages via initiator
>   mm/mempolicy: enhance weighted interleave with package-aware locality
>
>  .../ABI/testing/sysfs-devices-system-package  |   35 +
>  ...fs-kernel-mm-mempolicy-weighted-interleave |   17 +
>  drivers/cxl/core/region.c                     |   54 +
>  drivers/cxl/cxl.h                             |    1 +
>  drivers/dax/kmem.c                            |    3 +
>  include/linux/memory-tiers.h                  |  113 ++
>  include/linux/numa.h                          |   11 +
>  mm/memory-tiers.c                             | 1009 +++++++++++++++++
>  mm/mempolicy.c                                |  200 +++-
>  9 files changed, 1439 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-devices-system-package
>
>
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
> --
> 2.25.1
>

--
Cheers, Lorenzo
