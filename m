Return-Path: <owner-linux-mm@kvack.org>
From: Keith Busch <keith.busch@intel.com>
Subject: [PATCH 0/5] Page demotion for memory reclaim
Date: Thu, 21 Mar 2019 14:01:52 -0600
Message-Id: <20190321200157.29678-1-keith.busch@intel.com>
Sender: owner-linux-mm@kvack.org
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org
Cc: Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The kernel has recently added support for using persistent memory as
normal RAM:

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c221c0b0308fd01d9fb33a16f64d2fd95f8830a4

The persistent memory is hot added to nodes separate from other memory
types, which makes it convenient to make node based memory policies.

When persistent memory provides a larger and cheaper address space, but
with slower access characteristics than system RAM, we'd like the kernel
to make use of these memory-only nodes as a migration tier for pages
that would normally be discared during memory reclaim. This is faster
than doing IO for swap or page cache, and makes better utilization of
available physical address space.

The feature is not enabled by default. The user must opt-in to kernel
managed page migration by defining the demotion path. In the future,
we may want to have the kernel automatically create this based on
heterogeneous memory attributes and CPU locality.

Keith Busch (5):
  node: Define and export memory migration path
  mm: Split handling old page for migration
  mm: Attempt to migrate page in lieu of discard
  mm: Consider anonymous pages without swap
  mm/migrate: Add page movement trace event

 Documentation/ABI/stable/sysfs-devices-node |  11 +-
 drivers/base/node.c                         |  73 +++++++++++++
 include/linux/migrate.h                     |   6 ++
 include/linux/node.h                        |   6 ++
 include/linux/swap.h                        |  20 ++++
 include/trace/events/migrate.h              |  29 ++++-
 mm/debug.c                                  |   1 +
 mm/migrate.c                                | 161 ++++++++++++++++++----------
 mm/vmscan.c                                 |  25 ++++-
 9 files changed, 271 insertions(+), 61 deletions(-)

-- 
2.14.4
