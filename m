Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E8F2F3B;
	Wed, 13 Apr 2022 18:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649875093; x=1681411093;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lXa4Y282B5NVbS7dWjueKTJ385VRxU8xt5dCliDGE/g=;
  b=KhPCrMH74jikueh+N46JsjL+MAQuU1aHkOh1P/ChvHQFgilGj5Q9+Bat
   lAXlvBd98jqQjtO1q7TFEWU7QWNHSIxNmNnZk7gtp1cviswvHROjb9Yx4
   NxpB/uPlH36GcrxtECM6HHr9+7VsGU3xtsuPvd7qdZvFHCAUvsDLU2OHa
   Dxs++HGmH31txkFG5WxDltYyJmVKKl/0mHcMkCCwfy8MJAf71NOLm/KQB
   g/VpBPMaurkaCf2ntHwoFUYbn/0CP1r9QTHfb94wRQJFGj0oElNsxzb9G
   wdvP/PFPJYWoHQn7sWVcWWVMS0r7OD/vglg2olrZkBLhwFpkXL5ad5gTL
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="244631835"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="244631835"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:47 -0700
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="725013560"
Received: from sushobhi-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.131.238])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:47 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 00/15] Region driver
Date: Wed, 13 Apr 2022 11:37:05 -0700
Message-Id: <20220413183720.2444089-1-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Spring cleaning is here and we're starting fresh so I won't be referencing
previous postings and I've removed revision history from commit messages.

This patch series introduces the CXL region driver as well as associated APIs in
CXL core to create and configure regions. Regions are defined by the CXL 2.0
specification [1], a summary follows.

A region surfaces a swath of RAM (persistent or volatile) that appears as normal
memory to the operating system. The memory, unless programmed by BIOS, or a
previous Operating System, is inaccessible until the CXL driver creates a region
for it.A region may be strided (interleave granularity) across multiple devices
(interleave ways). The interleaving may traverse multiple levels of the CXL
hierarchy.

+-------------------------+      +-------------------------+
|                         |      |                         |
|   CXL 2.0 Host Bridge   |      |   CXL 2.0 Host Bridge   |
|                         |      |                         |
|  +------+     +------+  |      |  +------+     +------+  |
|  |  RP  |     |  RP  |  |      |  |  RP  |     |  RP  |  |
+--+------+-----+------+--+      +--+------+-----+------+--+
      |            |                   |               \--
      |            |                   |        +-------+-\--+------+
   +------+    +-------+            +-------+   |       |USP |      |
   |Type 3|    |Type 3 |            |Type 3 |   |       +----+      |
   |Device|    |Device |            |Device |   |     CXL Switch    |
   +------+    +-------+            +-------+   | +----+     +----+ |
                                                | |DSP |     |DSP | |
                                                +-+-|--+-----+-|--+-+
                                                    |          |
                                                +------+    +-------+
                                                |Type 3|    |Type 3 |
                                                |Device|    |Device |
                                                +------+    +-------+

Region verification and programming state are owned by the cxl_region driver
(implemented in the cxl_region module). Much of the region driver is an
implementation of algorithms described in the CXL Type 3 Memory Device Software
Guide [2].

The region driver is responsible for configuring regions found on persistent
capacities in the Label Storage Area (LSA), it will also enumerate regions
configured by BIOS, usually volatile capacities, and will allow for dynamic
region creation (which can then be stored in the LSA). Only dynamically created
regions are implemented thus far.

Dan has previously stated that he doesn't want to merge ABI until the whole
series is posted and reviewed, to make sure we have no gaps. As such, the goal
of posting this series is *not* to discuss the ABI specifically, feedback is of
course welcome. In other wordsIt has been discussed previously. The goal is to find
architectural flaws in the implementation of the ABI that may pose problematic
for cases we haven't yet conceived.

Since region creation is done via sysfs, it is left to userspace to prevent
racing for resource usage. Here is an overview for creating a x1 256M
dynamically created region programming to be used by userspace clients. In this
example, the following topology is used (cropped for brevity):
/sys/bus/cxl/devices/
├── decoder0.0 -> ../../../devices/platform/ACPI0017:00/root0/decoder0.0
├── decoder0.1 -> ../../../devices/platform/ACPI0017:00/root0/decoder0.1
├── decoder1.0 -> ../../../devices/platform/ACPI0017:00/root0/port1/decoder1.0
├── decoder2.0 -> ../../../devices/platform/ACPI0017:00/root0/port2/decoder2.0
├── decoder3.0 -> ../../../devices/platform/ACPI0017:00/root0/port1/endpoint3/decoder3.0
├── decoder4.0 -> ../../../devices/platform/ACPI0017:00/root0/port2/endpoint4/decoder4.0
├── decoder5.0 -> ../../../devices/platform/ACPI0017:00/root0/port1/endpoint5/decoder5.0
├── decoder6.0 -> ../../../devices/platform/ACPI0017:00/root0/port2/endpoint6/decoder6.0
├── endpoint3 -> ../../../devices/platform/ACPI0017:00/root0/port1/endpoint3
├── endpoint4 -> ../../../devices/platform/ACPI0017:00/root0/port2/endpoint4
├── endpoint5 -> ../../../devices/platform/ACPI0017:00/root0/port1/endpoint5
├── endpoint6 -> ../../../devices/platform/ACPI0017:00/root0/port2/endpoint6
...

1. Select a Root Decoder whose interleave spans the desired interleave config
   - devices, IG, IW, Large enough address space.
   - ie. pick decoder0.0
2. Program the decoders for the endpoints comprising the interleave set.
   - ie. echo $((256 << 20)) > /sys/bus/cxl/devices/decoder3.0
3. Create a region
   - ie. echo $(cat create_pmem_region) >| create_pmem_region
4. Configure a region
   - ie. echo 256 >| interleave_granularity
	 echo 1 >| interleave_ways
	 echo $((256 << 20)) >| size
	 echo decoder3.0 >| target0
5. Bind the region driver to the region
   - ie. echo region0 > /sys/bus/cxl/drivers/cxl_region/bind


[1]: https://www.computeexpresslink.org/download-the-specification
[2]: https://cdrdv2.intel.com/v1/dl/getContent/643805?wapkw=CXL%20memory%20device%20sw%20guide

Ben Widawsky (15):
  cxl/core: Use is_endpoint_decoder
  cxl/core/hdm: Bail on endpoint init fail
  Revert "cxl/core: Convert decoder range to resource"
  cxl/core: Create distinct decoder structs
  cxl/acpi: Reserve CXL resources from request_free_mem_region
  cxl/acpi: Manage root decoder's address space
  cxl/port: Surface ram and pmem resources
  cxl/core/hdm: Allocate resources from the media
  cxl/core/port: Add attrs for size and volatility
  cxl/core: Extract IW/IG decoding
  cxl/acpi: Use common IW/IG decoding
  cxl/region: Add region creation ABI
  cxl/core/port: Add attrs for root ways & granularity
  cxl/region: Introduce configuration
  cxl/region: Introduce a cxl_region driver

 Documentation/ABI/testing/sysfs-bus-cxl       |  96 ++-
 .../driver-api/cxl/memory-devices.rst         |  14 +
 drivers/cxl/Kconfig                           |  10 +
 drivers/cxl/Makefile                          |   2 +
 drivers/cxl/acpi.c                            |  83 ++-
 drivers/cxl/core/Makefile                     |   1 +
 drivers/cxl/core/core.h                       |   4 +
 drivers/cxl/core/hdm.c                        |  44 +-
 drivers/cxl/core/port.c                       | 363 ++++++++--
 drivers/cxl/core/region.c                     | 669 ++++++++++++++++++
 drivers/cxl/cxl.h                             | 168 ++++-
 drivers/cxl/mem.c                             |   7 +-
 drivers/cxl/region.c                          | 333 +++++++++
 drivers/cxl/region.h                          | 105 +++
 include/linux/ioport.h                        |   1 +
 kernel/resource.c                             |  11 +-
 tools/testing/cxl/Kbuild                      |   1 +
 tools/testing/cxl/test/cxl.c                  |   2 +-
 18 files changed, 1810 insertions(+), 104 deletions(-)
 create mode 100644 drivers/cxl/core/region.c
 create mode 100644 drivers/cxl/region.c
 create mode 100644 drivers/cxl/region.h


base-commit: 7dc1d11d7abae52aada5340fb98885f0ddbb7c37
-- 
2.35.1

