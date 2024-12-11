Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9B26F073
	for <nvdimm@lists.linux.dev>; Wed, 11 Dec 2024 03:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733888543; cv=none; b=LeDJxnrw+S6TQgtj3/lIn8pq4cLZJgDIRmLm9Ya4kZUcn99Lpesp8ooMZX+3gnOIYM20seyUwLArA3DnJ7KDWUgqSmyMEjmK/SAeThiJSwn9vSBEHcuE5+tN+Q1ikF5PyFcklqaAHBopSpTaS/2Ql7eF4p2scoykOMHLSzVNi6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733888543; c=relaxed/simple;
	bh=oicPpklw009FqW4e5i8LSlbQIq4GW99lIiVOEEutCXw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=jGmVK5rD8Sz37sw3eqpq7VeoRz2YeLqnbE6oh0XvenykHBDUq3Ehy0xTOYm+NOXdEnxkVzoU38rOinN1Nqa4WnokuCO6sqQkzicB7PXj3OBZ487f+bGBnyUxmH4lJjB26wUuZoOj8rCjB9k1xMk6VRbA5liTQUFvfHmWQx9FXE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZbTAOulz; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZbTAOulz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733888541; x=1765424541;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=oicPpklw009FqW4e5i8LSlbQIq4GW99lIiVOEEutCXw=;
  b=ZbTAOulzClrnf7qULBxx6yxbAJlqwe6Kvoas+FrJOa8LVxGlD41sQS9U
   tuDS4EofRhwSTfC29s8PLUyYjJio1CXf2M8+o9C4CTlxspkbs5aCclDgy
   jnmfip9J6AB7aTBwIgvYzcLpA6DKe9CELlgVFABCo0ZAeGwsbH0fuYw93
   J/wfOyvjO0KVZvgOX2wbRpV5powsHH5mBZcNdgWAccZidOrNVjLT0yZX5
   q/ZEVTRkDb2jiFkEiqTNWMamZKPPrDVYdwz0R6PJ2X7inrotOcGXsGqL7
   CKCw7Hr7I5vFV/QAO4015L7C2xsT39s+qQTPIe5zl5sJ6T31yuQhaZ1aQ
   w==;
X-CSE-ConnectionGUID: nRxMNPcUQD+IcrPKu2I/zA==
X-CSE-MsgGUID: 5jIk03/ESLqpcucmWRk6xA==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="34395614"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="34395614"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 19:42:21 -0800
X-CSE-ConnectionGUID: LHaRrbWmSsmD+fT5amcDxQ==
X-CSE-MsgGUID: K1BMnLrAQTae22mffkmhag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="95696663"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO localhost) ([10.125.109.231])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 19:42:18 -0800
From: Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v8 00/21] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Date: Tue, 10 Dec 2024 21:42:15 -0600
Message-Id: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABcKWWcC/4XQzU7DMAwH8FeZeibI+bJbTrwH4pA4LosE7dSWi
 mnau5NOAraqwNGR/z/bOVWjDFnG6mF3qgaZ85j7rhT13a7ifeheROVU6sqAsYDgVOKkpuNBjHo
 /jNMg4U0BJ+1bNBrbVJVgDKOoOISO90v0tntpOAzS5o/L1KfnUu/zOPXD8bLErJfXP+fNWoEiH
 dE6HYN495i7SV7vub/oJerAmt+jkSJAQmPR+Kvossls/p9uCtGSA3Yk1GhcE/aLcFBr3CTscgA
 3sUGOAROtCfdNaADaJFwh2KAWQZEkaU34K8I0m4QvRE224YjEltyawB9Cg98kcCE8UxuMdtDKm
 qBrYvsQKoTHUDtBjGxvvvN8Pn8CyztjWaICAAA=
X-Change-ID: 20230604-dcd-type2-upstream-0cd15f6216fd
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-hardening@vger.kernel.org, Li Ming <ming.li@zohomail.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733888537; l=11963;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=oicPpklw009FqW4e5i8LSlbQIq4GW99lIiVOEEutCXw=;
 b=Wg+WIOn62r8+tDTjdhYRk+4Cr8dP9NuunxJSy9mTaXMAusp8zuBgnHzNg5ZT5RjPNM8u+K9yf
 NmfWkSEsvtqDKIU5iuzFIAe/w5rj2DStDxSg0viGwMHI/p18NSI3SfD
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

A git tree of this series can be found here:

	https://github.com/weiny2/linux-kernel/tree/dcd-v4-2024-12-10

Rebase this off 6.13 cleanups.

Series info
===========

This series has 2 parts:

Patch 1-19: Core DCD support
Patch 20-21: cxl_test support

Background
==========

A Dynamic Capacity Device (DCD) (CXL 3.1 sec 9.13.3) is a CXL memory
device that allows memory capacity within a region to change
dynamically without the need for resetting the device, reconfiguring
HDM decoders, or reconfiguring software DAX regions.

One of the biggest use cases for Dynamic Capacity is to allow hosts to
share memory dynamically within a data center without increasing the
per-host attached memory.

The general flow for the addition or removal of memory is to have an
orchestrator coordinate the use of the memory.  Generally there are 5
actors in such a system, the Orchestrator, Fabric Manager, the Logical
device, the Host Kernel, and a Host User.

Typical work flows are shown below.

Orchestrator      FM         Device       Host Kernel    Host User

    |             |           |            |              |
    |-------------- Create region ----------------------->|
    |             |           |            |              |
    |             |           |            |<-- Create ---|
    |             |           |            |    Region    |
    |<------------- Signal done --------------------------|
    |             |           |            |              |
    |-- Add ----->|-- Add --->|--- Add --->|              |
    |  Capacity   |  Extent   |   Extent   |              |
    |             |           |            |              |
    |             |<- Accept -|<- Accept  -|              |
    |             |   Extent  |   Extent   |              |
    |             |           |            |<- Create --->|
    |             |           |            |   DAX dev    |-- Use memory
    |             |           |            |              |   |
    |             |           |            |              |   |
    |             |           |            |<- Release ---| <-+
    |             |           |            |   DAX dev    |
    |             |           |            |              |
    |<------------- Signal done --------------------------|
    |             |           |            |              |
    |-- Remove -->|- Release->|- Release ->|              |
    |  Capacity   |  Extent   |   Extent   |              |
    |             |           |            |              |
    |             |<- Release-|<- Release -|              |
    |             |   Extent  |   Extent   |              |
    |             |           |            |              |
    |-- Add ----->|-- Add --->|--- Add --->|              |
    |  Capacity   |  Extent   |   Extent   |              |
    |             |           |            |              |
    |             |<- Accept -|<- Accept  -|              |
    |             |   Extent  |   Extent   |              |
    |             |           |            |<- Create ----|
    |             |           |            |   DAX dev    |-- Use memory
    |             |           |            |              |   |
    |             |           |            |<- Release ---| <-+
    |             |           |            |   DAX dev    |
    |<------------- Signal done --------------------------|
    |             |           |            |              |
    |-- Remove -->|- Release->|- Release ->|              |
    |  Capacity   |  Extent   |   Extent   |              |
    |             |           |            |              |
    |             |<- Release-|<- Release -|              |
    |             |   Extent  |   Extent   |              |
    |             |           |            |              |
    |-- Add ----->|-- Add --->|--- Add --->|              |
    |  Capacity   |  Extent   |   Extent   |              |
    |             |           |            |<- Create ----|
    |             |           |            |   DAX dev    |-- Use memory
    |             |           |            |              |   |
    |-- Remove -->|- Release->|- Release ->|              |   |
    |  Capacity   |  Extent   |   Extent   |              |   |
    |             |           |            |              |   |
    |             |           |     (Release Ignored)     |   |
    |             |           |            |              |   |
    |             |           |            |<- Release ---| <-+
    |             |           |            |   DAX dev    |
    |<------------- Signal done --------------------------|
    |             |           |            |              |
    |             |- Release->|- Release ->|              |
    |             |  Extent   |   Extent   |              |
    |             |           |            |              |
    |             |<- Release-|<- Release -|              |
    |             |   Extent  |   Extent   |              |
    |             |           |            |<- Destroy ---|
    |             |           |            |   Region     |
    |             |           |            |              |

Implementation
==============

The series still requires the creation of regions and DAX devices to be
closely synchronized with the Orchestrator and Fabric Manager.  The host
kernel will reject extents if a region is not yet created.  It also
ignores extent release if memory is in use (DAX device created).  These
synchronizations are not anticipated to be an issue with real
applications.

In order to allow for capacity to be added and removed a new concept of
a sparse DAX region is introduced.  A sparse DAX region may have 0 or
more bytes of available space.  The total space depends on the number
and size of the extents which have been added.

Initially it is anticipated that users of the memory will carefully
coordinate the surfacing of additional capacity with the creation of DAX
devices which use that capacity.  Therefore, the allocation of the
memory to DAX devices does not allow for specific associations between
DAX device and extent.  This keeps allocations very similar to existing
DAX region behavior.

To keep the DAX memory allocation aligned with the existing DAX devices
which do not have tags extents are not allowed to have tags.  Future
support for tags is planned.

Great care was taken to keep the extent tracking simple.  Some xarray's
needed to be added but extra software objects were kept to a minimum.

Region extents continue to be tracked as sub-devices of the DAX region.
This ensures that region destruction cleans up all extent allocations
properly.

The major functionality of this series includes:

- Getting the dynamic capacity (DC) configuration information from cxl
  devices

- Configuring the DC partitions reported by hardware

- Enhancing the CXL and DAX regions for dynamic capacity support
	a. Maintain a logical separation between hardware extents and
	   software managed region extents.  This provides an
	   abstraction between the layers and should allow for
	   interleaving in the future

- Get hardware extent lists for endpoint decoders upon
  region creation.

- Adjust extent/region memory available on the following events.
        a. Add capacity Events
	b. Release capacity events

- Host response for add capacity
	a. do not accept the extent if:
		If the region does not exist
		or an error occurs realizing the extent
	b. If the region does exist
		realize a DAX region extent with 1:1 mapping (no
		interleave yet)
	c. Support the event more bit by processing a list of extents
	   marked with the more bit together before setting up a
	   response.

- Host response for remove capacity
	a. If no DAX device references the extent; release the extent
	b. If a reference does exist, ignore the request.
	   (Require FM to issue release again.)

- Modify DAX device creation/resize to account for extents within a
  sparse DAX region

- Trace Dynamic Capacity events for debugging

- Add cxl-test infrastructure to allow for faster unit testing
  (See new ndctl branch for cxl-dcd.sh test[1])

- Only support 0 value extent tags

Fan Ni's upstream of Qemu DCD was used for testing.

Remaining work:

	1) Allow mapping to specific extents (perhaps based on
	   label/tag)
	   1a) devise region size reporting based on tags
	2) Interleave support

Possible additional work depending on requirements:

	1) Accept a new extent which extends (but overlaps) an existing
	   extent(s)
	2) Release extents when DAX devices are released if a release
	   was previously seen from the device
	3) Rework DAX device interfaces, memfd has been explored a bit

[1] https://github.com/weiny2/ndctl/tree/dcd-region2-2024-12-11

---
Changes in v8:
- iweiny: rebase off of 6.13
- iweiny: Use %pra which landed in 6.13
- Link to v7: https://patch.msgid.link/20241107-dcd-type2-upstream-v7-0-56a84e66bc36@intel.com

---
Ira Weiny (21):
      cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
      cxl/mem: Read dynamic capacity configuration from the device
      cxl/core: Separate region mode from decoder mode
      cxl/region: Add dynamic capacity decoder and region modes
      cxl/hdm: Add dynamic capacity size support to endpoint decoders
      cxl/cdat: Gather DSMAS data for DCD regions
      cxl/mem: Expose DCD partition capabilities in sysfs
      cxl/port: Add endpoint decoder DC mode support to sysfs
      cxl/region: Add sparse DAX region support
      cxl/events: Split event msgnum configuration from irq setup
      cxl/pci: Factor out interrupt policy check
      cxl/mem: Configure dynamic capacity interrupts
      cxl/core: Return endpoint decoder information from region search
      cxl/extent: Process DCD events and realize region extents
      cxl/region/extent: Expose region extent information in sysfs
      dax/bus: Factor out dev dax resize logic
      dax/region: Create resources on sparse DAX regions
      cxl/region: Read existing extents on region creation
      cxl/mem: Trace Dynamic capacity Event Record
      tools/testing/cxl: Make event logs dynamic
      tools/testing/cxl: Add DC Regions to mock mem data

 Documentation/ABI/testing/sysfs-bus-cxl |  125 +++-
 drivers/cxl/core/Makefile               |    2 +-
 drivers/cxl/core/cdat.c                 |   42 +-
 drivers/cxl/core/core.h                 |   34 +-
 drivers/cxl/core/extent.c               |  494 +++++++++++++++
 drivers/cxl/core/hdm.c                  |  210 ++++++-
 drivers/cxl/core/mbox.c                 |  603 +++++++++++++++++-
 drivers/cxl/core/memdev.c               |  128 +++-
 drivers/cxl/core/port.c                 |   19 +-
 drivers/cxl/core/region.c               |  165 ++++-
 drivers/cxl/core/trace.h                |   65 ++
 drivers/cxl/cxl.h                       |  122 +++-
 drivers/cxl/cxlmem.h                    |  132 +++-
 drivers/cxl/pci.c                       |  116 +++-
 drivers/dax/bus.c                       |  356 +++++++++--
 drivers/dax/bus.h                       |    4 +-
 drivers/dax/cxl.c                       |   71 ++-
 drivers/dax/dax-private.h               |   40 ++
 drivers/dax/hmem/hmem.c                 |    2 +-
 drivers/dax/pmem.c                      |    2 +-
 include/cxl/event.h                     |   32 +
 include/linux/ioport.h                  |    3 +
 tools/testing/cxl/Kbuild                |    3 +-
 tools/testing/cxl/test/mem.c            | 1019 +++++++++++++++++++++++++++----
 24 files changed, 3499 insertions(+), 290 deletions(-)
---
base-commit: 7cb1b466315004af98f6ba6c2546bb713ca3c237
change-id: 20230604-dcd-type2-upstream-0cd15f6216fd

Best regards,
-- 
Ira Weiny <ira.weiny@intel.com>

