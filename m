Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3EAE3264FB
	for <nvdimm@lists.linux.dev>; Wed, 12 Aug 2026 05:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786513639; cv=none; b=tz1V2agoRz4oNiP3IC6ZnrMuLpJUR+vb60KU1sSt71phwttK5AzKsx95tcgrUzOan7vw4QcBW1mc3p5WWNgO2jwYyEfkJeG+1ekKrK1n+gRsgJY1HQLrB/XwwfBFjxluDXd9rpXD/GS1zlonHEbJzAfoDiyv4+Y6d5A5FQDjI44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786513639; c=relaxed/simple;
	bh=blh+ZG+nSTxFbTjdouTgQzr1fOBqH20ml2bI+cv0iuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1uwLpNVUzI9uW6VLxuQvL9ysIVmxEhgrPVJe8IHw36n2s8FkUXnrS6WjZ+VOZV0P/2gm9xBoCwh6u7T3EGiIwjkaIzZQUO/lxbIuCeaX5eHw0iJHQRlF2UPKMJ8imGKe0H0Gy2AZAdm4MDLq3yfJbYnubrHynYDP10rxEh9Zk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-fd-6a7c08d79c47
From: Rakie Kim <rakie.kim@sk.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: akpm@linux-foundation.org,
	gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
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
Date: Wed, 12 Aug 2026 14:46:57 +0900
Message-ID: <20260812054700.1803-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260811152951.195315-1-joshua.hahnjy@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsXC9ZZnoe51jposg3cNphZz1q9hs7j7+AKb
	xa4bIRYnbjayWay+uYbR4vnWX4wWP+8eZ7e4fmslo8X+p89ZLB40rWKyOL51HrvFulOH2CzO
	zzrFYnF51xw2i3tr/rNavHnsZvGtT9rifp+Dxcoff1gtjqzfzmQx+dICNouOl/dZLG5NOMZk
	sXpNhsXso/fYHSQ9ds66y+6xYFOpR3fbZXaPzSu0PBbvecnksWlVJ5vHpk+T2D1OzPjN4rHz
	oaXHi80zGT16m9+xeUydXe+xfstVFo/Pm+QC+KK4bFJSczLLUov07RK4Mh6v3sha8DC+YtL0
	BsYGxh6vLkZODgkBE4m58x+yw9j7Zj5g6mLk4GATUJI4tjcGJCwioClxonUScxcjFwezwAZW
	iVOn3zKDJIQFgiS6pj9nBLFZBFQljv5dywJi8wLNWfDrGyvETE2JdRtvgcU5BewkLn37BbZL
	SIBH4tWG/YwQ9YISJ2c+AathFpCXaN46G2yZhMBPdolNZ5cwQwySlDi44gbLBEb+WUh6ZiHp
	WcDItIpRKDOvLDcxM8dEL6MyL7NCLzk/dxMjMFaX1f6J3sH46ULwIUYBDkYlHt4LMtVZQqyJ
	ZcWVuYcYJTiYlUR4q1dVZQnxpiRWVqUW5ccXleakFh9ilOZgURLnNfpWniIkkJ5YkpqdmlqQ
	WgSTZeLglGpgdNQ/cEV389dDf1K1p536erdBYuJUfnNlXvEzkU9FK9h/JVm2z0ryujkz9KnO
	u306b8rjWG9tO7F/WdrUCaXMpk8+zhaZxV6fnfAoXGBm8elHG6xv33HbcWabirlfp7FyUa3W
	TJ6KlLXNe2UbljMdPfTuqaTP/hknH4Rt9n3zW2bB+pDv4bfX7FBiKc5INNRiLipOBAAzKRtA
	0QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYQCG/c45OzsOB8dldNDQGIQoZAYFXxkm/bAvf0UXixR05MFN55RN
	h5dKS7LSHKaJc2pYoulcTuctLRWX10kljjStecFymhneWOalckrgv4f3eXn/vBQuaCNcKYks
	npXLRFIhySN4as/QIyPUzSjfDJMnLNbrSGiZHiRh66fL8P2TIhL2jd4hYfWoDkBr4zqAvy29
	XDgyVgXgysw8Dju+WQk4eVeLwd7Gp1z4tqSfA2tMRhJ+0JgIaG4tJuG47i8H/pgOhDaVG5xQ
	BcCqtU0ONA5bObBL34zBvKFSEj6YmyDgWE4PBqt1YrjRVEnCou5xboA7atFYuKjUkICyMsxc
	VF/pjcrezGHIoH1IIsNyLhf1qTcI1DJ1Es3WFwKUnf6TRLbPCJXNLmIovygV6Rs+EmjF4H6B
	vs47HcFKJUpWftQ/nCeerq7jxE2FJeYWpIE08CgoEzhSDH2caS+cxDIBRZG0kOlpC7XHLrQX
	03cvF88EPAqnazmMaWABt4t99EUms8AK7EzQh5nurZeEnfnbO6XrNs7uphdTUze2kzvS/syQ
	bZ1rZwHtxHyv7QC7fWemv/DrTgenPZj0xiI8Bzhp9ijNHlUKMC1wkciUMSKJ9ISPIlqcJJMk
	+tyIjTGA7VMrbm0+fgVWzeeMgKaA0Ik/eDAlSsARKRVJMUbAULjQhZ+iTY4S8CNEScmsPDZM
	niBlFUbgRhHCA/ygq2y4gI4UxbPRLBvHyv9bjHJ0TQOdgeQpVlXBVizOFMdm56echSFryRn9
	vcFfyrfaVNr9anO0st+jTG9b1t7OcW5fCVEvtC6FStsDLw2vxkeWWJaeO/xyD7Olqho2Bgx+
	kx3ZGVj2mWtiB1i+kNB1vvu+V/e7mUPsn2euGpdNP3VTJ4nlzedesfqSwa+b/V6Ys4SEQiw6
	5o3LFaJ/JCQcpNACAAA=
X-CFilter-Loop: Reflected

On Tue, 11 Aug 2026 08:29:51 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> On Thu,  6 Aug 2026 17:09:31 +0900 Rakie Kim <rakie.kim@sk.com> wrote:
> 
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
> Hello Rakie,
>
> I hope you are doing well! Sorry for the late repsonse.
>
> I have a few thoughts, some of which are carry-overs from the RFC
> discussion we had before! I think there are still some open questions,
> and I wanted to get your opinion on some of them.
>

Hello Joshua,

I am doing well, thank you, and I hope you are too. Thank you for
taking the time to review this series and for following up on the
questions from the RFC discussion.

> My first question is whether we want cross-socket allocations at all.
> The examples you gave seem to line up with node-restricted interleave,
> as opposed to cross-socket interleave. I think the wording that you
> use to describe the feature in 4/4 (which I will copy below)
> 
> > The resolved mask is by construction a subset of the policy nodemask, which
> > mempolicy already restricts to the task's cpuset; package mode can only
> > narrow that set, never widen it, so cpusets and the task nodemask remain
> > authoritative.
> 
> is 100% the right way to treat these package-aware (socket-aware)
> interleaving allocations, but the example below
> 
> [...snip...]
> 
> > Applied the same way to every source, these weights give the map:
> > 
> >               node0  node1  node2  node3
> > global:         2      2      1      1
> 
> [...snip...]
> 
> >               node0  node1  node2  node3
> > from CPU 0:     2      0      1      0
> > from CPU 1:     0      2      0      1
> 
> Is essentially the existing weighted interleave mechanism with a
> nodemask/cpuset applied.

The example I gave was not explained well enough, and I can see how
it reads as a manually applied nodemask.

A nodemask or a cpuset names a fixed set of nodes, while package mode
expresses a rule: use the nodes of the package the allocation is
requested from. The mask is resolved per allocation from the
requesting CPU, so a single policy gives {0,2} to a thread on package
0 and {1,3} to a thread on package 1 at the same time. One nodemask
cannot do that, since it is the same set for everyone who uses the
policy.

There is also the question of how a user would build such a nodemask.
The package a CXL node belongs to is not visible today: on the
systems I tested, the firmware reports node1 as the initiator for
both CXL nodes. The topology layer in this series is what makes that
association available, and the read-only view under
/sys/devices/system/package/ lets the user check it.

> With that said, I think a more interesting and
> illustrative example would be if the user truly would want to allow some
> allocations to go through cross-socket, but be able to control the
> ratio at which these slip through.
>
>               node0  node1  node2  node3
> from CPU 0:     3      1      2      0
> from CPU 1:     0      3      1      2
>
> Maybe even more illustrative of the true capabilities of this series
> would be if you have an asymmetric system where you bind some
> host-level monitoring / logging workloads to one node (say, node0) and
> want that to be able to cross through to the other socket, but not the
> other way around:
> 
>               node0  node1  node2  node3
> from CPU 0:     3      1      2      0
> from CPU 1:     0      2      0      1
> 
> Anyways, these are just super hypothetical scenarios and I don't even
> know if the configuration that I'm listing would really be beneficial
> for the system. I think that coming up with some illustrative usecases
> which are now made possible by this series could help motivate why we
> would want to interleave across sockets.
>

These maps are an interesting idea, and I would like to look at them
with you.

This series only narrows the candidate nodes; the weights themselves
stay global, so every source that reaches a node uses the same weight
for it. Both of your maps give a node a different weight depending on
which package the allocation comes from, so the weight table would
have to become per source rather than a single global one.

Encoding the weights that way came up in an earlier stage of this
work, and it was mentioned again briefly in the RFC thread. As I
recall, the difficulty then was less the placement logic than how a
user would drive it: weights would have to be configured for every
source, so both the interface and the structure behind it grow
considerably.

That does not make your suggestion less interesting to me. I think it
could work well once there are clear scenarios for it, and the
grouping added here is what such a table would be built on, since a
per source weight only has meaning when the kernel knows which
package each node belongs to. What I am unsure about is folding it
into this series, whose aim is the narrower one of raising effective
bandwidth by keeping interleave traffic within a package. Allowing a
controlled amount of cross-package traffic points the other way, so I
think it is a topic we could discuss separately, with the use cases
worked out first.

I agree that such use cases would make the direction much stronger,
and I will think about whether there are cases where allowing a
controlled amount of cross-package traffic would help.


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
> 
> I was also hoping to see what this interface looks like and maybe
> discuss how we should relay the information to the users, since this
> seems to be a new addition from the RFC.
>

Sure. The toggle lives with the existing weighted interleave knobs.
package_mode defaults to false, so nothing changes until the
operator explicitly enables it:

/sys/kernel/mm/mempolicy/weighted_interleave
|-- auto
|-- node0
|-- node1
|-- node2
|-- node3
`-- package_mode -> true/false

The package topology view is read-only and lives under
/sys/devices/system/package/. This is how it looks on the system I
am currently using:

/sys/devices/system/package
|-- package0
|   |-- package_cpu_nodes -> 0
|   |-- package_mem_only_nodes -> 2
|   |-- package_nodes -> 0,2
|   `-- physical_package_id -> 0
`-- package1
    |-- package_cpu_nodes -> 1
    |-- package_mem_only_nodes -> 3
    |-- package_nodes -> 1,3
    `-- physical_package_id -> 1

package_nodes shows every node grouped into that package, and the
cpu/mem_only files split them by type, so an operator can check how
the kernel grouped the topology before turning package_mode on. I
will update the documentation in the next version to describe this
interface and how to use it.


> > Measured results:
> > 
> > System Configuration:
> > - Processor: Dual-Socket Intel Xeon 6980P (Granite Rapids)
> 
> I think a description of this system's topology would help me understand
> the results below a bit better : -)
>

That is a fair point. The system used for the measurements is
configured as follows:

- Processor:                 Dual-Socket Intel Xeon 6980P
                             (Granite Rapids)
- Local memory (per socket): 12 channels, DDR5-6400
- CXL memory (per socket):   8 channels, DDR5-6400

It boots as two CPU+DRAM nodes and two CXL memory-only nodes, which
is the topology shown in the sysfs output above. I will add this
description to the measured results in the next version.


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
> 
> Really awesome results!
>

Thank you.


> > A small CXL driver change registers a CXL memory node into its package
> > as the node comes online, using the initiator the driver resolves for
> > the region; this is where the package layer gets the CPU-side
> > association that plain NUMA distance does not carry.
> > 
> > The memory_package layer offers a broader interface for grouping and
> > querying package topology - usable by memory tiering as well - and
> > package-aware weighted interleave uses the subset it needs.
> 
> I was hoping you could expand on this a bit more. Aside from the
> alloction-time placement strategy, did you have other ideas in mind for
> who could ingest the package information to make tiering decisions?
>

The case I had in mind is demotion and promotion target selection.
With the package information, tiering could keep those decisions
within a package: choosing the memory-only nodes of the task's
package as demotion targets, and symmetrically preferring the
package's CPU nodes when promoting, so that both hot and cold pages
stay close to the CPUs that use them.

To support this, the layer already exposes per-node "preferred" node
queries: for a CPU node it reports the nearest memory-only nodes in
the same package, and for a memory-only node the nearest CPU nodes.
Nothing consumes them yet; I kept them out of the placement path so
that tiering can adopt them separately when there is a real user.

> I definitely think this series makes a lot of sense and I am
> hoping to hear more about it. Thank you, I hope you have a great day!
>
> Joshua

Thank you again for the careful review and for the questions; they
were a great help in seeing what the cover letter needs to explain
better. I hope you have a great day too.

Rakie Kim
