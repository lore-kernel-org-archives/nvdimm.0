Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6C9FF21A02920
 for <linux-nvdimm@lists.01.org>; Mon,  5 Jun 2017 12:49:56 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [resend RFC 0/6] Add support for Heterogeneous Memory Attribute Table
Date: Mon,  5 Jun 2017 13:50:51 -0600
Message-Id: <20170605195057.31492-1-ross.zwisler@linux.intel.com>
In-Reply-To: <20170602205956.28351-1-ross.zwisler@linux.intel.com>
References: <20170602205956.28351-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-kernel@vger.kernel.org
Cc: "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Nachimuthu,, Lukasz, Robert, David, Joonas, "Lukasz  <lukasz.odzioba@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Zheng, Lv" <lv.zheng@intel.com>, devel@acpica.org, Schmauss,
List-ID: <linux-nvdimm@lists.01.org>

[ Apologies for the resend.  The devel@acpica.org list rejected my first
  posting because I wasn't subscribed. ]

==== Quick summary ====

This series adds kernel support for the Heterogeneous Memory Attribute
Table (HMAT) table, newly defined in ACPI 6.2:

http://www.uefi.org/sites/default/files/resources/ACPI_6_2.pdf

The HMAT table, in concert with the existing System Resource Affinity Table
(SRAT), provides users with information about memory initiators and memory
targets in the system.

A "memory initiator" in this case is any device such as a CPU or a separate
memory I/O device that can initiate a memory request.  A "memory target" is
a CPU-accessible physical address range.

The HMAT provides performance information (expected latency and bandwidth,
etc.) for various (initiator,target) pairs.  This is mostly motivated by
the need to optimally use performance-differentiated DRAM, but it also
allows us to describe the performance characteristics of persistent memory.

The purpose of this RFC is to gather feedback on the different options for
enabling the HMAT in the kernel and in userspace.

==== Lots of details ====

The HMAT only covers CPU-addressable memory types, not on-device memory
like what we have with Jerome Glisse's HMM series:

https://lkml.org/lkml/2017/5/24/731

One major conceptual change in ACPI 6.2 related to this work is that
proximity domains no longer need to contain a processor.  We can now have
memory-only proximity domains, which means that we can now have memory-only
Linux NUMA nodes.

Here is an example configuration where we have a single processor, one
range of regular memory and one range of High Bandwidth Memory (HBM):

  +---------------+   +----------------+
  | Processor     |   | Memory         |
  | prox domain 0 +---+ prox domain 1  |
  | NUMA node 1   |   | NUMA node 2    |
  +-------+-------+   +----------------+
          |
  +-------+----------+
  | HBM              |
  | prox domain 2    |
  | NUMA node 0      |
  +------------------+

This gives us one initiator (the processor) and two targets (the two memory
ranges).  Each of these three has its own ACPI proximity domain and
associated Linux NUMA node.  Note also that while there is a 1:1 mapping
from each proximity domain to each NUMA node, the numbers don't necessarily
match up.  Additionally we can have extra NUMA nodes that don't map back to
ACPI proximity domains.

The above configuration could also have the processor and one of the two
memory ranges sharing a proximity domain and NUMA node, but for the
purposes of the HMAT the two memory ranges will always need to be
separated.

The overall goal of this series and of the HMAT is to allow users to
identify memory using its performance characteristics.  This can broadly be
done in one of two ways:

Option 1: Provide the user with a way to map between proximity domains and
NUMA nodes and a way to access the HMAT directly (probably via
/sys/firmware/acpi/tables).  Then, through possibly a library and a daemon,
provide an API so that applications can either request information about
memory ranges, or request memory allocations that meet a given set of
performance characteristics.

Option 2: Provide the user with HMAT performance data directly in sysfs,
allowing applications to directly access it without the need for the
library and daemon.

The kernel work for option 1 is started by patches 1-4.  These just surface
the minimal amount of information in sysfs to allow userspace to map
between proximity domains and NUMA nodes so that the raw data in the HMAT
table can be understood.

Patches 5 and 6 enable option 2, adding performance information from the
HMAT to sysfs.  The second option is complicated by the amount of HMAT data
that could be present in very large systems, so in this series we only
surface performance information for local (initiator,target) pairings.  The
changelog for patch 6 discusses this in detail.

==== Next steps ====

There is still a lot of work to be done on this series, but the overall
goal of this RFC is to gather feedback on which of the two options we
should pursue, or whether some third option is preferred.  After that is
done and we have a solid direction we can add support for ACPI hot add,
test more complex configurations, etc.

So, for applications that need to differentiate between memory ranges based
on their performance, what option would work best for you?  Is the local
(initiator,target) performance provided by patch 6 enough, or do you
require performance information for all possible (initiator,target)
pairings?

If option 1 looks best, do we have ideas on what the userspace API would
look like?

For option 2 Dan Williams had suggested that it may be worthwhile to allow
for multiple memory initiators to be listed as "local" if they all have the
same performance, even if the HMAT's Memory Subsystem Address Range
Structure table only defines a single local initiator.  Do others agree?

What other things should we consider, or what needs do you have that aren't
being addressed?

Ross Zwisler (6):
  ACPICA: add HMAT table definitions
  acpi: add missing include in acpi_numa.h
  acpi: HMAT support in acpi_parse_entries_array()
  hmem: add heterogeneous memory sysfs support
  sysfs: add sysfs_add_group_link()
  hmem: add performance attributes

 MAINTAINERS                         |   5 +
 drivers/acpi/Kconfig                |   1 +
 drivers/acpi/Makefile               |   1 +
 drivers/acpi/hmem/Kconfig           |   7 +
 drivers/acpi/hmem/Makefile          |   2 +
 drivers/acpi/hmem/core.c            | 679 ++++++++++++++++++++++++++++++++++++
 drivers/acpi/hmem/hmem.h            |  56 +++
 drivers/acpi/hmem/initiator.c       |  61 ++++
 drivers/acpi/hmem/perf_attributes.c | 158 +++++++++
 drivers/acpi/hmem/target.c          |  97 ++++++
 drivers/acpi/numa.c                 |   2 +-
 drivers/acpi/tables.c               |  52 ++-
 fs/sysfs/group.c                    |  30 +-
 include/acpi/acpi_numa.h            |   1 +
 include/acpi/actbl1.h               | 119 +++++++
 include/linux/sysfs.h               |   2 +
 16 files changed, 1254 insertions(+), 19 deletions(-)
 create mode 100644 drivers/acpi/hmem/Kconfig
 create mode 100644 drivers/acpi/hmem/Makefile
 create mode 100644 drivers/acpi/hmem/core.c
 create mode 100644 drivers/acpi/hmem/hmem.h
 create mode 100644 drivers/acpi/hmem/initiator.c
 create mode 100644 drivers/acpi/hmem/perf_attributes.c
 create mode 100644 drivers/acpi/hmem/target.c

-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
