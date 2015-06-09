Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v2 0/3] Add NUMA support for NVDIMM devices
Date: Tue,  9 Jun 2015 17:10:37 -0600
Message-Id: <1433891440-3515-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net, dan.j.williams@intel.com
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Since NVDIMMs are installed on memory slots, they expose the NUMA
topology of a platform.  This patchset adds support of sysfs
'numa_node' to I/O-related NVDIMM devices under /sys/bus/nd/devices.
This enables numactl(8) to accept 'block:' and 'file:' paths of
pmem and btt devices as shown in the examples below.
  numactl --preferred block:pmem0 --show
  numactl --preferred file:/dev/pmem0s --show

numactl can be used to bind an application to the locality of
a target NVDIMM for better performance.  Here is a result of fio
benchmark to ext4/dax on an HP DL380 with 2 sockets for local and
remote settings.

  Local [1] :  4098.3MB/s
  Remote [2]:  3718.4MB/s

[1] numactl --preferred block:pmem0 --cpunodebind block:pmem0 fio <fs-on-pmem0> 
[2] numactl --preferred block:pmem1 --cpunodebind block:pmem1 fio <fs-on-pmem0>

Patch 1/3 applies on top of the acpica branch of the pm tree.
Patch 2/3-3/3 apply on top of Dan Williams's v5 patch series of 
"libnvdimm: non-volatile memory devices".

---
v2:
 - Add acpi_map_pxm_to_online_node(), which returns an online node.
 - Manage visibility of sysfs numa_node with is_visible. (Dan Williams)
 - Check ACPI_NFIT_PROXIMITY_VALID in spa->flags.

---
Toshi Kani (3):
  1/3 acpi: Add acpi_map_pxm_to_online_node()
  2/3 libnvdimm: Set numa_node to NVDIMM devices
  3/3 libnvdimm: Add sysfs numa_node to NVDIMM devices

---
 drivers/acpi/nfit.c             |  7 +++++++
 drivers/acpi/numa.c             | 40 +++++++++++++++++++++++++++++++++++++---
 drivers/nvdimm/btt.c            |  2 ++
 drivers/nvdimm/btt_devs.c       |  1 +
 drivers/nvdimm/bus.c            | 30 ++++++++++++++++++++++++++++++
 drivers/nvdimm/namespace_devs.c |  1 +
 drivers/nvdimm/nd.h             |  1 +
 drivers/nvdimm/region.c         |  1 +
 drivers/nvdimm/region_devs.c    |  1 +
 include/linux/acpi.h            |  5 +++++
 include/linux/libnvdimm.h       |  2 ++
 11 files changed, 88 insertions(+), 3 deletions(-)
