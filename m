Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9633D88E1
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386832; cv=none; b=uL3w5n2Wqv5d4xy9NxBVp24aiWt1/ff0uFLHyVLPdZOSfwQe5CoIgINQvZx58DDRRxDHyWcgtEz9uUiqSA+5hb/diWWis2Zn1JcojNCCybDqqXKYNAe3IZYQW/Xp9WYj6esEtQP4QSl0+aHuNxJj4PQAQWgPu1pG5XmmBX+9wUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386832; c=relaxed/simple;
	bh=LmvPCFD+L9lwBEig933fzBIMD0QXMC38dYdC1O3Oy30=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ggSDTN/my/d3cMWrXIu1a3XY2gI2a8+DkZ+WPQzKH4+tcxHGAfvp8SnqZ/iJ2jQkVQ5SUn6QGWm90OBYqZO3CsYg+/xIICe5rKhA25YlJAXjkcd6OwaE8JSaX4PAQLLf7NwRTO+rK1tBlIvq5jdujhK8Xoi1Uo6aR52D7QthAng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P2VzsZBf; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P2VzsZBf"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-30bf132969bso3016393eec.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386830; x=1782991630; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KbV+zTChUJJL9Nh9LhvDFMWNZUpm1oVcSOi1CT2kASE=;
        b=P2VzsZBf25yFmYVqH9qOwvgnjD5yHsoQAtwMV6f1Y34Y7GXiKRTnA8fAMCpcR0kzDl
         p43YSDK8gtU+eIOQDPl65aDPzwGXZyyIsob2PJDpl4MCzh18ZHUI7WrPttxttv6JZvv9
         V217emRq1nOSem6zEMTObikkdsR5bbRgVwOftU/xBy8vYq32BwkKIbnZCR6dlF/21aVg
         4hX9dvD4+yYccTCjACZBZplkGEhUGaIXdmYDb4mCMFUIH8PDsNRTaL0sgWmz+uahmUah
         DjRY+34+ar+Jzy6CJaVRIrzAVe7IzqVWelYFtZLTBBn0GVy2yTkKSU16flJ4Gki+UmBR
         7eGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386830; x=1782991630;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KbV+zTChUJJL9Nh9LhvDFMWNZUpm1oVcSOi1CT2kASE=;
        b=jgxUmermXu+uz22+i63GbWd+QxBlXWu8+ZND3p5DVlh3aiT1iLhD5Xi+VSpCNTF5of
         eWZdSun7iTJr4hNzoWxgYBYEGGgHFyLAXSMv34pRz67J8dpNEAHlj29O0/LXdYOuMyO+
         J0OU3zLkP+NtKyNLSx0JmcLPChmXSYRG+8uKIDcdlGdVvMW7kQNawO9cJ6+55moDjAAG
         D0c6sA1o3VbJDr2rGVnqYt610uzqVpIZFRZcj/z5ymOeenDjINj7oT3bbrtIIJ8Ha8eF
         JIRR+tYFGQBRTX03w1g0eyv39eeo2e62rw7lG2MEMfDay/8ePfpRlinGz24EqRU1uzHh
         KIvA==
X-Gm-Message-State: AOJu0YzpumBbZjpK9EG1KlAW0QXsh+Y0D2BfOFQycbOCbMH9Yto4NWJP
	mPACSQOCTcuheR6xbCI0FFMLzp+x26kaTiE0yCwU+PBm+c5X7mprPi+u
X-Gm-Gg: AfdE7cmM2mburU0Ae+1S4r/vymcNYGERxYkUiKdd1iXJi4E3dvkGU6lt/rzyDwH8JCk
	OAUSJzvX0ISE63aRoSF8o84DrSGoxArNSGz+wgOr+DW0yauEa3pXTL2QfkrrQt4Aq35HSpBXl+u
	XsBSYHT3KFizpV03loDyjLr0tXhVIKvxuPfbEvYD++QjICxBNlf2WMaF9Fr7ZvwON+q8hYf1ZfM
	u51phJ42u9N6PZj+yqQbQBej89taQUvf3hPPfnr/K1YPMK1TuVPc/yDYI+lYlPbag+Ee2mvRUyh
	T55CZpOSsrL7w/KyhjYTp9SrRt0a2kfGgzzVJLkjaNF8J7H1WD8Cji4/tB4mWX9iVjvIXC6D9ZG
	rPLlCongZNNT/FUemxI7vuSxYNkvQd6/QS8KBYi6e4LnwRkmi3fLkCS7fOsXO4SBbOtOc8fGI/N
	fbAHyomo++LC6YNUfpW0NI4acHZ4t+CHCwX5hvl4sdRNbQDAW1+ixWtqB+NEYPId8GCihS
X-Received: by 2002:a05:7300:c8d:b0:30c:5121:7c0f with SMTP id 5a478bee46e88-30c84d462d6mr2454156eec.21.1782386830137;
        Thu, 25 Jun 2026 04:27:10 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:27:09 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>
Subject: DCD: Add support for Dynamic Capacity Devices (DCD)
Date: Thu, 25 Jun 2026 04:04:37 -0700
Message-ID: <20260625112638.550691-1-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Table of Contents
=================
  1. Changes since v10
  2. Background
  3. Patch organization
  4. Noteable
  5. Testing

This series branch: https://github.com/anisa-su993/anisa-linux-kernel/tree/dcd-v11-06-23-26
NDCTL branch: https://github.com/anisa-su993/anisa-ndctl/tree/dcd-2026-06-24

v10: https://lore.kernel.org/linux-cxl/ajuMJi5nTQRB_ZP0@AnisaLaptop.localdomain/T/#mfdfc28c829071204333824c542ca3af4170dafb4

Changes since v10
=================
The overall architecture and semantics are unchanged; v11 is review
fixes, naming/ABI corrections, and irons out locking/concurrency edge cases
between the CXL and DAX layers.

Naming / ABI:
 - Renamed dynamic_ram_a to dynamic_ram_1 throughout (endpoint-decoder
   mode, the partition sysfs name, and enum CXL_PARTMODE_DYNAMIC_RAM_1),
   matching the numbered-partition convention.
 - Sharable extent sequence numbers are now a dense 0..n-1 (previously
   1..n); the CXL validation path and the DAX claim path enforce the same
   0..n-1 invariant.
 - The DAX 'uuid' attribute reads back the null UUID (all-zeroes) when
   untagged rather than "0".

Recovery and lifecycle:
 - Creating a region over a DC partition now reads the device's
   already-accepted extents at probe time. cxl_dax_region probe
   and recovered extents are not re-acknowledged via Add-DC-Response.  New
   add events are deferred until the initial scan completes so a tag already in use
   is never registered twice.
 - Per-tag-group add and release of DAX resources are atomic (all-or-none). Previously,
   adding a tag group only locked for each extent addition. The lock is widened to
   the entire group.
 - Upper bound of 100 pending extents to prevent 20-second timeout for the More
   chain to close from being infinitely refreshed (unlikely unless device is malicious)

Robustness (device-supplied data is treated as untrusted):
 - Various device-supplied payload sizing checks, overflow/underflow, etc.
 - Fix places where we need to check for native_cxl to avoid overriding
   BIOS-owned events

Documentation:
 - Small changes to reflect dynamic_ram_a to dynamic_ram_1 change and the
   sequence num change (0...n-1 instead of 1...n)
 - Bump kver to 7.3 and date for sysfs attribute documentation

Signoffs/Tags:
- updated Ira's signoffs and authored-by to use iweiny@kernel.org
- update Jonathan Cameron's email to jic23@kernel.org for various review tags
- update Fan's email to nifan.cxl@gmail.com
- update Dan's email to djbw@kernel.org

Background
=============
A Dynamic Capacity Device (DCD) (CXL 3.1 sec 9.13.3) is a CXL memory
device that allows memory capacity within a region to change
dynamically without the need for resetting the device, reconfiguring
HDM decoders, or reconfiguring software DAX regions.
One of the biggest anticipated use cases for Dynamic Capacity is to
allow hosts to dynamically add or remove memory from a host within a
data center without physically changing the per-host attached memory nor
rebooting the host.
The general flow for the addition or removal of memory is to have an
orchestrator coordinate the use of the memory.  Generally there are 5
actors in such a system, the Orchestrator, Fabric Manager, the Logical
device, the Host Kernel, and a Host User.
An example work flow is shown below.
Orchestrator      FM         Device       Host Kernel    Host User
    |             |           |            |               |
    |-------------- Create region ------------------------>|
    |             |           |            |               |
    |             |           |            |<-- Create ----|
    |             |           |            |    Region     |
    |             |           |            |(dynamic_ram_1)|
    |<------------- Signal done ---------------------------|
    |             |           |            |               |
    |-- Add ----->|-- Add --->|--- Add --->|               |
    |  Capacity   |  Extent   |   Extent   |               |
    |             |           |            |               |
    |             |<- Accept -|<- Accept  -|               |
    |             |   Extent  |   Extent   |               |
    |             |           |            |<- Create -----|
    |             |           |            |   DAX dev     |-- Use memory
    |             |           |            |               |   |
    |             |           |            |               |   |
    |             |           |            |<- Release ----| <-+
    |             |           |            |   DAX dev     |
    |             |           |            |               |
    |<------------- Signal done ---------------------------|
    |             |           |            |               |
    |-- Remove -->|- Release->|- Release ->|               |
    |  Capacity   |  Extent   |   Extent   |               |
    |             |           |            |               |
    |             |<- Release-|<- Release -|               |
    |             |   Extent  |   Extent   |               |
    |             |           |            |               |
    |-- Add ----->|-- Add --->|--- Add --->|               |
    |  Capacity   |  Extent   |   Extent   |               |
    |             |           |            |               |
    |             |<- Accept -|<- Accept  -|               |
    |             |   Extent  |   Extent   |               |
    |             |           |            |<- Create -----|
    |             |           |            |   DAX dev     |-- Use memory
    |             |           |            |               |   |
    |             |           |            |<- Release ----| <-+
    |             |           |            |   DAX dev     |
    |<------------- Signal done ---------------------------|
    |             |           |            |               |
    |-- Remove -->|- Release->|- Release ->|               |
    |  Capacity   |  Extent   |   Extent   |               |
    |             |           |            |               |
    |             |<- Release-|<- Release -|               |
    |             |   Extent  |   Extent   |               |
    |             |           |            |               |
    |-- Add ----->|-- Add --->|--- Add --->|               |
    |  Capacity   |  Extent   |   Extent   |               |
    |             |           |            |<- Create -----|
    |             |           |            |   DAX dev     |-- Use memory
    |             |           |            |               |   |
    |-- Remove -->|- Release->|- Release ->|               |   |
    |  Capacity   |  Extent   |   Extent   |               |   |
    |             |           |            |               |   |
    |             |           |     (Release Ignored)      |   |
    |             |           |            |               |   |
    |             |           |            |<- Release ----| <-+
    |             |           |            |   DAX dev     |
    |<------------- Signal done ---------------------------|
    |             |           |            |               |
    |             |- Release->|- Release ->|               |
    |             |  Extent   |   Extent   |               |
    |             |           |            |               |
    |             |<- Release-|<- Release -|               |
    |             |   Extent  |   Extent   |               |
    |             |           |            |<- Destroy ----|
    |             |           |            |   Region      |
    |             |           |            |               |


Patch organization
==================
Device enablement and partition configuration:
 - cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
 - cxl/mem: Read dynamic capacity configuration from the device
 - cxl/cdat: Gather DSMAS data for DCD partitions
 - cxl/core: Enforce partition order/simplify partition calls
 - cxl/mem: Expose dynamic ram 1 partition in sysfs
 - cxl/port: Add 'dynamic_ram_1' to endpoint decoder mode
 - cxl/region: Add DC DAX region support

Event and interrupt plumbing:
 - cxl/events: Split event msgnum configuration from irq setup
 - cxl/pci: Factor out interrupt policy check
 - cxl/mem: Configure dynamic capacity interrupts
 - cxl/core: Return endpoint decoder information from region search
 - cxl/mem: Set up framework for handling DC Events
 - cxl/mem: Add 20 second timeout for stalled DC_ADD_CAPACITY chains

Extent handling - add, release, and validation:
 - cxl/extent: Handle DC Add Capacity events
 - cxl/mem: Drop misaligned DCD extent groups
 - cxl/extent: Validate DC extent partition
 - cxl/mem: Enforce tag-group semantics
 - cxl/extent: Handle DC Release Capacity events
 - cxl/extent: Enforce cross-region tag uniqueness
 - cxl/region/extent: Expose dc_extent information in sysfs

DAX resource surfacing and device model:
 - cxl + dax: Surface dax_resources on DCD Add Capacity events
 - cxl + dax: Release dax_resources on DCD Release Capacity events
 - dax/bus: Factor out dev dax resize logic
 - dax/bus: Add uuid sysfs attribute to dax devices
 - dax/bus: Reject resize on DC dax devices and enforce 0-size creation
 - dax/bus: Tag-aware uuid claim and show on DC dax devices
 - cxl/region: Read existing extents on region creation

Tracing, test infrastructure, and documentation:
 - cxl/mem: Trace Dynamic capacity Event Record
 - tools/testing/cxl: Make event logs dynamic
 - tools/testing/cxl: Add DC Regions to mock mem data
 - Documentation/cxl: Document DCD extent handling and DC-backed DAX regions


Noteable
========
 - A More=1 add chain is bounded by the 20s timeout and CXL_DC_MAX_PENDING_EXTENTS,
   set to 100. Suggested by Sashiko as a defensive cap against a fabric manager
   that never closes the chain.  The value is arbitrary; feedback on it is welcome.

 - Several Sashiko review comments assumed multiple host threads could process a
   single DCD add event, or concurrently mutate one tag group, at the same
   time. But I don't think that happens because DCD events for a memdev are delivered
   and handled serially by that device's event-interrupt thread,
   and a tag group is owned by exactly one memory device.  Those comments
   were therefore ignored. Please correct me if this assumption is wrong
   so I can fix those.

Testing
=======
ndctl unit suite: built and run against the QEMU cxl_test mock with the
ndctl 'cxl' suite (branch dcd-2026-06-24): 16 of 17 tests pass and
cxl-features is skipped as unsupported, including cxl-dcd.sh and the
cxl-region-replay.sh crash-recovery test that exercises reading
pre-existing extents on region creation.

QEMU end-to-end: used Ali's QEMU patchset adding tag support
[1], with the below topology:

TOPO='-object memory-backend-file,id=cxl-mem1,mem-path=/tmp/t3_cxl1.raw,size=12G \
     -object memory-backend-file,id=cxl-lsa1,mem-path=/tmp/t3_lsa1.raw,size=1G \
     -device usb-ehci,id=ehci \
     -device pxb-cxl,bus_nr=12,bus=pcie.0,id=cxl.1,hdm_for_passthrough=true \
     -device cxl-rp,port=0,bus=cxl.1,id=cxl_rp_port0,chassis=0,slot=2 \
     -device cxl-type3,bus=cxl_rp_port0,id=cxl-dcd0,dc-regions-total-size=12G,num-dc-regions=1,sn=99 \
     -device usb-cxl-mctp,bus=ehci.0,id=usb1,target=cxl-dcd0\
     -machine cxl-fmw.0.targets.0=cxl.1,cxl-fmw.0.size=12G,cxl-fmw.0.interleave-granularity=1k'

The exact instructions are the same as the previous version, so I've truncated some details.

  1. Boot the guest.
  2. QMP object-add a tagged 8G memory-backend-ram
     (tag 5be13bce-ae34-4a77-b6c3-16df975fcf1a).
  3. cxl create-region -m -d decoder0.0 -w 1 -s 8G mem0 -t dynamic_ram_1
  4. QMP cxl-add-dynamic-capacity (prescriptive, region 0, same tag)
     injecting an 8G extent at offset 0.
  5. The extent surfaces under the region: dax_region0/extent0.0 reports
     offset 0x0, length 0x200000000, uuid 5be13bce-...
  6. daxctl create-device -r region0 --uuid 5be13bce-... creates the 8G
     devdax device.

We are also working with some internal teams to test on real hardware, so
I'll report any findings as we go.

References:
[1] https://lore.kernel.org/linux-cxl/20260325184259.366-1-alireza.sanaee@huawei.com/T/#t

This series applies on the v7.1 tag (Linus' tree).

base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6

Anisa Su (6):
  cxl/mem: Add 20 second timeout for stalled DC_ADD_CAPACITY chains
  cxl/mem: Enforce tag-group semantics
  cxl/extent: Enforce cross-region tag uniqueness
  dax/bus: Add uuid sysfs attribute to dax devices
  dax/bus: Tag-aware uuid claim and show on DC dax devices
  Documentation/cxl: Document DCD extent handling and DC-backed DAX
    regions

Ira Weiny (25):
  cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
  cxl/mem: Read dynamic capacity configuration from the device
  cxl/cdat: Gather DSMAS data for DCD partitions
  cxl/core: Enforce partition order/simplify partition calls
  cxl/mem: Expose dynamic ram 1 partition in sysfs
  cxl/port: Add 'dynamic_ram_1' to endpoint decoder mode
  cxl/region: Add DC DAX region support
  cxl/events: Split event msgnum configuration from irq setup
  cxl/pci: Factor out interrupt policy check
  cxl/mem: Configure dynamic capacity interrupts
  cxl/core: Return endpoint decoder information from region search
  cxl/mem: Set up framework for handling DC Events
  cxl/extent: Handle DC Add Capacity events
  cxl/mem: Drop misaligned DCD extent groups
  cxl/extent: Validate DC extent partition
  cxl/extent: Handle DC Release Capacity events
  cxl/region/extent: Expose dc_extent information in sysfs
  cxl + dax: Surface dax_resources on DCD Add Capacity events
  cxl + dax: Release dax_resources on DCD Release Capacity events
  dax/bus: Factor out dev dax resize logic
  dax/bus: Reject resize on DC dax devices and enforce 0-size creation
  cxl/region: Read existing extents on region creation
  cxl/mem: Trace Dynamic capacity Event Record
  tools/testing/cxl: Make event logs dynamic
  tools/testing/cxl: Add DC Regions to mock mem data

 Documentation/ABI/testing/sysfs-bus-cxl       |  100 +-
 Documentation/ABI/testing/sysfs-bus-dax       |   18 +
 .../driver-api/cxl/linux/cxl-driver.rst       |  149 +++
 .../driver-api/cxl/linux/dax-driver.rst       |  169 +++
 drivers/cxl/core/Makefile                     |    2 +-
 drivers/cxl/core/cdat.c                       |   12 +
 drivers/cxl/core/core.h                       |   67 +-
 drivers/cxl/core/extent.c                     |  783 ++++++++++++
 drivers/cxl/core/hdm.c                        |   14 +-
 drivers/cxl/core/mbox.c                       | 1107 +++++++++++++++-
 drivers/cxl/core/memdev.c                     |   87 +-
 drivers/cxl/core/port.c                       |    9 +
 drivers/cxl/core/region.c                     |   53 +-
 drivers/cxl/core/region_dax.c                 |   49 +-
 drivers/cxl/core/trace.h                      |   75 ++
 drivers/cxl/cxl.h                             |  114 +-
 drivers/cxl/cxlmem.h                          |  162 ++-
 drivers/cxl/mem.c                             |    2 +-
 drivers/cxl/pci.c                             |  136 +-
 drivers/dax/bus.c                             |  653 +++++++++-
 drivers/dax/bus.h                             |    4 +-
 drivers/dax/cxl.c                             |  115 +-
 drivers/dax/dax-private.h                     |   63 +
 drivers/dax/hmem/hmem.c                       |    2 +-
 drivers/dax/pmem.c                            |    2 +-
 include/cxl/cxl.h                             |    7 +-
 include/cxl/event.h                           |   38 +
 tools/testing/cxl/Kbuild                      |    5 +-
 tools/testing/cxl/test/cxl.c                  |   12 +
 tools/testing/cxl/test/mem.c                  | 1109 +++++++++++++++--
 tools/testing/cxl/test/mock.h                 |    9 +
 31 files changed, 4858 insertions(+), 269 deletions(-)
 create mode 100644 drivers/cxl/core/extent.c

-- 
2.43.0

