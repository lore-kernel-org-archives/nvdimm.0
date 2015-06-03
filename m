Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 0/3] Add NUMA support for NVDIMM devices
Date: Tue,  2 Jun 2015 18:26:49 -0600
Message-Id: <1433291212-23367-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net, dan.j.williams@intel.com
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Since NVDIMMs are installed on memory slots, they expose the NUMA
topology of a platform.  This patchset adds support of sysfs
'numa_node' to the NVDIMM devices under /sys/bus/nd/devices.
With this change, numactl(8) accepts 'block:' and 'file:' paths of
pmem and btt devices as shown in the examples below.
  numactl --preferred block:pmem0 --show
  numactl --preferred file:/dev/pmem0s --show

Here is a result of fio benchmark to ext4/dax on pmem0 using numactl
on an HP DL380 with 2 sockets; pmem0 on node 0, and pmem1 on node 1.

  Local [1] :  4098.3MB/s
  Remote [2]:  3718.4MB/s

[1] numactl --preferred block:pmem0 --cpunodebind block:pmem0 fio <fs-on-pmem0> 
[2] numactl --preferred block:pmem1 --cpunodebind block:pmem1 fio <fs-on-pmem0>

Patch 1/3-2/3 apply on top of the acpica branch of the pm tree.
Patch 3/3 applies on top of Dan Williams's v5 patch series of 
"libnvdimm: non-volatile memory devices".

---
Toshi Kani (3):
  1/3 acpi: Fix acpi_map_pxm_to_node() to handle numa_off
  2/3 acpi: Add export to acpi_map_pxm_to_node()
  3/3 libnvdimm: Add sysfs numa_node to NVDIMM devices

---
 drivers/acpi/nfit.c          |  2 ++
 drivers/acpi/numa.c          | 13 ++++++++++---
 drivers/nvdimm/btt.c         |  2 ++
 drivers/nvdimm/bus.c         | 12 ++++++++++++
 drivers/nvdimm/nd.h          |  1 +
 drivers/nvdimm/region.c      |  1 +
 drivers/nvdimm/region_devs.c |  1 +
 include/linux/acpi.h         |  5 +++++
 include/linux/libnvdimm.h    |  1 +
 9 files changed, 35 insertions(+), 3 deletions(-)
