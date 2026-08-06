Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8477C3E009B
	for <nvdimm@lists.linux.dev>; Thu,  6 Aug 2026 08:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786004700; cv=none; b=sVTPSilGbOnBb5NychgFmVeeLloMBLQGR4LE55KR/MqzcRvU9eITQxAzvlEP+28fdXX646fJrOFT1nxPqwYLQnb614TbYXfK8gz8KbkJXI8yuGt5OFS0cc9jJYtU/iLcSOia6ixWbaP2WqVZy0s6d8dhIkwaxIa8FpCEO5/PsE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786004700; c=relaxed/simple;
	bh=+/7EMSK/F5QNYXEvg6wkhMeDmgtSeWcJuYsMODyu89A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r0cyByjznYoviznYFFi+mEZeyOLvoIdyb4Vnp6Yd1i6owL2KgDTr035hvqKfkMkTtlXB2FeUGfbfnwyHWiO/xIc/KA2kEBMngCRZwl6nSe3pPcTYtXKCt6NEzbne4MrR3Zd0M05avh5tyvILCkVTfyzawttS77wQ5uirBnYRBgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c45ff70000001609-90-6a74414a2abd
From: Rakie Kim <rakie.kim@sk.com>
To: akpm@linux-foundation.org
Cc: gourry@gourry.net,
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
	rakie.kim@sk.com
Subject: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted interleave
Date: Thu,  6 Aug 2026 17:09:31 +0900
Message-ID: <20260806080936.421-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsXC9ZZnoa6XY0mWwb3F8hZz1q9hs7j7+AKb
	xa4bIRYnbjayWay+uYbR4vnWX4wWP+8eZ7e4fmslo8X+p89ZLB40rWKyOL51HrvFulOH2CzO
	zzrFYnF51xw2i3tr/rNavHnsZvGtT9rifp+Dxcoff1gtjqzfzmQx+dICNouOl/dZLG5NOMZk
	sXpNhsXso/fYHSQ9ds66y+6xYFOpR3fbZXaPzSu0PBbvecnksWlVJ5vHpk+T2D1OzPjN4rHz
	oaXHi80zGT16m9+xeUydXe+xfstVFo/Pm+QC+KK4bFJSczLLUov07RK4Mq7P+c9cMMW54mn3
	D6YGxrnGXYycHBICJhKv2zYywdhrj/UxdzFycLAJKEkc2xsDEhYRkJWY+vc8SxcjFwezwCJW
	iROfz7KCJIQF/CRmnHnCBlLPIqAq8f6zL0iYV8BYYmnbOnaIkZoS6zbeYoGIC0qcnPkEzGYW
	kJdo3jqbGWSmhMA1don+FcdZIBokJQ6uuMEygZF3FpKeWUh6FjAyrWIUyswry03MzDHRy6jM
	y6zQS87P3cQIjLxltX+idzB+uhB8iFGAg1GJh/eCcXGWEGtiWXFl7iFGCQ5mJRFe1oNFWUK8
	KYmVValF+fFFpTmpxYcYpTlYlMR5jb6VpwgJpCeWpGanphakFsFkmTg4pRoYmZ+LLb8345DN
	7k9LLtqzPpR66bid0ezWfueyM//U/+2WnVmtMvlQlHHdjUssj5rkNARusqpazZ+QYml3+pjj
	5VqXpy6rV9U92LzlnC7njZ/nshvrT29e3ZH7ojSsbH7L4XPLZOuu/k84XmGu5t39zeR772SB
	yexpLLH/Ps+zt7G4dnFHVzGDmxJLcUaioRZzUXEiAEucgZW4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYQCG+XauGw3O1sKDltEkKsFLLOELSoyoPoRCKBmFlCMPOZ1TznSo
	EVoDSS1RU5ibxmiWOuekmaZWRCuvmI5GedfK6zJKWoqlZZkE/nt5npf3z0tj0mrcn1Zr0zle
	q9LISREuMu6LC4k+lp4UbpiVwspGOwnHp9wkbB86B/vLzCTsHr5OwvphO4BzzT8B/DHeRcHB
	kToAfbMLGHw+M4fD9zdsAtjVfJeCL6t6COjodZFwwNSLQ097JQkn7OsE/Dx1Ei4XBcDJoihY
	t7JGQNe7OQK+anwsgHfeWEh40zuJw5HiTgGstyfC1ZZaEpo7JqioQNRmGqeQxZmBCvM8FGqq
	DUbWp14BctrySeT8VkqhbuMqjto+HEbzTRUA3TZ8IdHyKELW+UUBKjfnoMZHb3HkcwbGMBdE
	RxI4jVrP8WGR8aLEwcp1LK3seOZM4YogF1QpCoCQZplDbENnEVYAaJpk5Gzns7gNLGN2seW/
	BvACIKIx5h7BdvteExtiO3OGNfZNkxt9nNnLfvWd3sBiRsHez3NQm5MHWMfDEXyTS9ieiul/
	GWN2s4ZmM1YMRKYtyrRFWYDABmRqrT5FpdZEhOqSE7O06szQy6kpTvD3uwfX1kpawXfPKRdg
	aCDfJnYrdElSQqXXZaW4AEtjcpmYeMEnScUJqqxsjk+9xGdoOJ0LBNC43E8creTipcwVVTqX
	zHFpHP/fCmihfy7oiF2iZIvuowWGUpM2zBq981OQ1u4+yyuM1coIh1+L1R7920v3nvd5bB7v
	k8DW9f1LeyTm+LVYQ06D74Re3Deamc/7Sm4lLCzaJf7tox6Lc0w5FxHysS3y6vRF4ahGqARu
	o43sCAoKqAlv2jEUMyV2j/VLsmu58uKaNq8c1yWqDgZjvE71BxYXHTq3AgAA
X-CFilter-Loop: Reflected

Package-aware weighted interleave places a task's weighted-interleave
pages on the NUMA nodes of its local package, so that interleave traffic
does not have to cross the interconnect to another package. This keeps
each node's weight aligned with the bandwidth the task actually gets
from it, so effective bandwidth holds up on a system that has more than
one package. (A package is a CPU socket together with the memory
attached to it.)

Changes from RFC:
https://lore.kernel.org/all/20260316051258.246-1-rakie.kim@sk.com/
- Added an opt-in sysfs toggle (off by default) and a read-only sysfs
  view of the package topology
- Added topology validation with a clean fallback to plain weighted
  interleave on unsupported topologies
- Hardened the allocation, device-teardown, and node-hotplug paths

Weighted interleave places pages on nodes in proportion to per-node
weights that are set from each node's bandwidth. Within one package the
weight given to a node matches the bandwidth a task sees from it. Across
packages it no longer does: a memory node's physical bandwidth is fixed,
but the bandwidth a task effectively sees depends on which package its
CPU is in, because memory reached from another package, over the
interconnect between them, is slower than the same memory reached within
the package. The weights are set once from device bandwidth and applied
the same way wherever the task runs, so a node in another package is
given a weight higher than the bandwidth it can deliver to that task.
The kernel has no package abstraction and does not record which package
a node belongs to, so it cannot tell which node pairs are separated by
the interconnect.

          node0             node1
        +-------+         +-------+
        | CPU 0 |---------| CPU 1 |
        +-------+         +-------+
        | DRAM0 |         | DRAM1 |
        +---+---+         +---+---+
            |                 |
        +---+---+         +---+---+
        | CXL 0 |         | CXL 1 |
        +-------+         +-------+
          node2             node3

The numbers below are illustrative single-stream bandwidths (GB/s).
Local DRAM sustains 300 and local CXL 150; any path that crosses to
another package, over the interconnect, is capped at 100, so a node in
another package delivers 100 whether it is DRAM or CXL. Note that local
CXL (150) is still faster than any node in another package (100). The
effective bandwidth each CPU sees is therefore:

              node0  node1  node2  node3
from CPU 0:    300    100    150    100
from CPU 1:    100    300    100    150

Since a single per-node weight cannot encode the interconnect penalty,
a reasonable set of global weights is taken from local device bandwidth
(local DRAM : local CXL = 300 : 150 = 2 : 1): node0=2 node1=2 node2=1
node3=1.

Applied the same way to every source, these weights give the map:

              node0  node1  node2  node3
global:         2      2      1      1

A task on CPU 0 gives node1 - remote DRAM, effective 100 - the same
weight 2 as its own local node0 at 300. Worse, node1 is weighted above
node2, the task's local CXL at effective 150, even though node2 is the
faster of the two. The flat weights rank a slower interconnect-bound
node above a faster local one, which is exactly backwards.

This series makes weighted interleave package-aware. When it is on,
weighted interleave prefers the task's current package: while the
package's nodes have room, the task's pages are spread across them by
weight, so allocations stay off the interconnect. The rest of the
policy nodemask is used when the local package cannot serve the request
- when a node in it is under pressure and the page allocator falls back
along the zonelist, or when the policy nodemask happens to exclude every
node of the current package, in which case the package spanned by the
policy's own nodes is used instead. The nodes considered are always
within the policy nodemask, which mempolicy already narrows to the
task's cpuset, so cpusets and the task nodemask stay in control.

              node0  node1  node2  node3
from CPU 0:     2      0      1      0
from CPU 1:     0      2      0      1

A task on CPU 0 now places pages on node0 (weight 2) and node2
(weight 1) at 2:1, which matches their effective bandwidth of 300:150;
a task on CPU 1 places on node1 and node3 the same way. Placement
follows the bandwidth each task actually sees, NUMA locality is
preserved, and interleave traffic stays off the interconnect.

To make this possible the kernel needs a notion of which nodes share a
package. The NUMA distance model offers only relative latencies and no
structural grouping, which is especially limiting for CXL memory nodes
that come online without an explicit package association.

The series adds a package-aware topology layer that groups CPU and
memory-only nodes into a "memory package", built from the physical
package ids firmware reports and, for a memory-only node, an initiator
CPU node or SLIT distances. A package can contain more than one CPU node
or more than one memory-only node, so the layer maps a package to a set
of nodes rather than to a single node or a single CXL device.

The feature is off by default and opt-in through a sysfs toggle. The
package topology itself is exposed read-only under
/sys/devices/system/package/; there is deliberately no writable
override, since a machine whose firmware describes its topology
incorrectly should be fixed in firmware. On a topology that does not
have the symmetric shape the placement relies on, enabling is refused
and any active mode degrades cleanly to the original flat behavior.

Measured results:

System Configuration:
- Processor: Dual-Socket Intel Xeon 6980P (Granite Rapids)

1) Throughput (System Bandwidth)
   - DRAM Only: 966 GB/s
   - Weighted Interleave: 903 GB/s (7% decrease compared to DRAM Only)
   - Package-Aware Weighted Interleave: 1329 GB/s (1.33 TB/s)
     (38% increase compared to DRAM Only,
      47% increase compared to Weighted Interleave)

2) Loaded Latency (Under High Bandwidth)
   - DRAM Only: 544 ns
   - Weighted Interleave: 545 ns
   - Package-Aware Weighted Interleave: 436 ns
     (20% reduction compared to both)

A small CXL driver change registers a CXL memory node into its package
as the node comes online, using the initiator the driver resolves for
the region; this is where the package layer gets the CPU-side
association that plain NUMA distance does not carry.

The memory_package layer offers a broader interface for grouping and
querying package topology - usable by memory tiering as well - and
package-aware weighted interleave uses the subset it needs.

[PATCH 1/4] mm/numa: introduce nearest_nodes_nodemask()
  Add a NUMA helper that returns every node sharing the minimum distance
  from a source node.

[PATCH 2/4] mm/memory-tiers: package-aware topology management
  Group NUMA nodes into memory packages from firmware topology data,
  expose the grouping read-only under /sys/devices/system/package/, and
  validate the symmetric shape that package-aware placement relies on.

[PATCH 3/4] mm/memory-tiers: register CXL nodes to packages
  Bind a CXL memory node to a package using an initiator CPU node.

[PATCH 4/4] mm/mempolicy: package-aware weighted interleave
  Prefer the current package for weighted interleave node selection,
  behind an opt-in package_mode sysfs toggle that is off by default.

Rakie Kim (4):
  mm/numa: introduce nearest_nodes_nodemask()
  mm/memory-tiers: introduce package-aware topology management for NUMA
    nodes
  mm/memory-tiers: register CXL nodes to memory packages via initiator
  mm/mempolicy: enhance weighted interleave with package-aware locality

 .../ABI/testing/sysfs-devices-system-package  |   35 +
 ...fs-kernel-mm-mempolicy-weighted-interleave |   17 +
 drivers/cxl/core/region.c                     |   54 +
 drivers/cxl/cxl.h                             |    1 +
 drivers/dax/kmem.c                            |    3 +
 include/linux/memory-tiers.h                  |  113 ++
 include/linux/numa.h                          |   11 +
 mm/memory-tiers.c                             | 1009 +++++++++++++++++
 mm/mempolicy.c                                |  200 +++-
 9 files changed, 1439 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-system-package


base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
2.25.1

