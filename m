Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FE93A255F
	for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 08:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487763; cv=none; b=QjAewWqXve1FQzcMlrlJ1VFHrjY2qedy8PybmaQb1tZDCgoIEGdqY3oSGpjvi321M87URTWoV6mgAZa7gYmd1cEaea1PkcQejyuUsopNVZFXgyWQ5LDOtCUa+tmji3TTBqi82VTWhUHv2slIeQ/MHm7z3MvyAI1GLeOY33MbEzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487763; c=relaxed/simple;
	bh=7EXJ/G0Pc7WGa2dz40IdLuVJeR6loF+lYJObwJCcpLA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QxOcnqfH2dOlqS/VZYipQJzS1+Rf9S6RLHz1q3pgmj3ejyhUtGycoxf8TLS2TA9k2YSYwiB4Ysp7kkDXyqmf5xHL4wp5nKuvZhuZwaXGfQBqzsvgs9A4rV0FUP2dmCA3pjimuf7C+8H1lI2CvIAbLHMuseN7EXSt5y1qFUBi4Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bRot3Zd2; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bRot3Zd2"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso6058755ad.3
        for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 01:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785487761; x=1786092561; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HfOGJ/oCq2h0EMXcanwDEj3Yl0Tslr9AcWcPdwXvyEs=;
        b=bRot3Zd2EhVRHpqexeAANjAGKtRaWt5Rd3VRoEvkUmc567pKaV7r7JliB2bMK08yH6
         d5rv/Cv8kK2sYY8VFuZGHd7VQ4wqQwrgQBfu7FzYItcTJbULKZ6tZxnYd992muLqW2lS
         5nIo+bfQWZQSOOrSRxwUq6Lo7sx0Vlqq3Ovrw7ZyLfLXoB5VXd6YhxYpPgrrC/3R+plC
         rCXUW5s4lR1qmFQhzw5OJZ0cqumPwqFd+XqNkAwT2l5Clx9KOwJtO9jcP9kqXeXVaDAq
         FWFpoNgl4BEj5YM64Aiu184cILKy5MFLgLLs75UfUAk3sIvuXl9WZVBCbRprTeESHorI
         osqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785487761; x=1786092561;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HfOGJ/oCq2h0EMXcanwDEj3Yl0Tslr9AcWcPdwXvyEs=;
        b=ZJnGPDcPPHbIsOc5b92wjc+JO7qzBC2KSb4Z3MblrtfkJKmYNAUDADHfDehM+BjlAe
         Blem8Ohze/he0XNzXHwMxg/zP4Re+i0Nn8Jln5dDUImugcQQ4Fpxv5Td/vowN7f17zNq
         /lg9JhC18FKm9OGZr0Gsi29oupOn3er1uiteQTU0raTHDGzKDiXe8rRLkbxKRZLzfxhe
         2qnELGiRTj88igUnfEWeSBndlb4qNo/4X3mwYjbBWGn9+olQZUUubd5UOooPv4OVQZUo
         LZ+PWjtvUgbahORLNwZQMtC6/yq/BocA3k1FkFJhFcI2T8832jLWZfYfndF1xMnvrRtu
         Fv7Q==
X-Gm-Message-State: AOJu0YzsK/wlAas1XDEABrdptBtbZnVsRQRo++xAdnIzZ5E55N/h6HlV
	g+aNtVrhytmOI3dBHNMs1mQ3nnlrRQFJK8Zz7Gfxvu8Fzpsa50IJgJS5
X-Gm-Gg: AR+sD13ASHEuAZD5l/w9tPDvn+TxO/kC35PMxzMCA19gUXmO+dnaLcEkOj2IkWvJ5nH
	jtw6u/ez4Sw0jcGkq8IXs4o9QnLAoETenxhoW/0wsrBcM0laJt+E8Gva0UNBcB+5R1TCPT1ZT5F
	BLE3oRb8fc2qYvIzX1DmLKCDWIHroscSRQ3nmbbTQR2OZZgtqTHPWoXwM2DiV4lY4grYAAYeTNd
	uEe8b1KXveuK2c89KRvQyvkXOf7NMgsWReQqpvtpRHEYWDRDE83dMAaBXyJc/GM+6mvrQgpyJtp
	y4mZxyAo2Zqgc91ggyAC7aSu/IOm1TENish4ZRwrN3K8YecaLkREXvyZzyYUbFsRVFInYjRJZL7
	mQH8gSSiIP7QRUtkjRZpNg2TBAg4Ak03QQq9O1OzgpsGgTfxwAJeTBeAblAQVKcVzElydwwUcn8
	haI28BBtHGtKh6YGeDIfX2HRsYXea78AZe7dhVzY/zVV3ozyBGw+G5bzw2LxC2BS8TqVkwr8xgC
	6CASecKc41wT97lJIfS14AGXeJE8Nu8iamDzkZZMm7Y
X-Received: by 2002:a17:903:1b0d:b0:2cc:aa36:c04c with SMTP id d9443c01a7336-2d046d6fac4mr12405165ad.1.1785487760433;
        Fri, 31 Jul 2026 01:49:20 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae5abaesm2708425ad.27.2026.07.31.01.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 01:49:19 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Wonjae Lee <wj28.lee@samsung.com>,
	Junhee Park <jh9934.park@samsung.com>,
	Heesoo Kim <habil.kim@samsung.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v12 0/8] DCD Prep Series
Date: Fri, 31 Jul 2026 01:48:05 -0700
Message-ID: <20260731084901.1512819-1-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These are the first eight patches of the Dynamic Capacity Device (DCD)
series, split from v11 and posted on their own: DCD enumeration, CDAT handling
for DC partitions, the event interrupt plumbing, and two prepatory refactors.
They stand alone, and keep DCD disabled. They are not dependent on the
rest of the series, so I think they are safe enough to pick up ahead
of the rest.

Patch 1 detects the 48h command set and then leaves mds->dcd_supported
false. The flag is only turned on by the event handling patch later
in the full series, so every DCD specific path added here is shut off at
runtime: cxl_configure_dcd() never runs, no DC partition is created,
no DCD interrupt is armed, and the CXL_PARTMODE_DYNAMIC_RAM_1 paths are
unreachable.  The intent is to land the enumeration and plumbing while
the extent to DAX pipeline is still under review.

Based on v7.2-rc5.

GitHub Branch:
https://github.com/anisa-su993/anisa-linux-kernel/tree/dcd-prep-series

v11 -> v12 Changes:
===================
 - Patch 1: cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
        - now leaves DCD disabled (mds->dcd_supported = false)

 - Patch 2: cxl/mem: Read dynamic capacity configuration from the device
        - mbox.c: bound the Get DC Config request by the negotiated
          mailbox payload. Requesting all 8 partitions needs 328 bytes,
          which exceeds a spec-minimum 256-byte mailbox and fails -E2BIG,
          disabling DCD. Cap partition_count per call and read the rest
          via the existing loop (Sashiko)

        - cxlmem.h/mbox.c: bump DC config comment references from CXL 3.2
          to CXL r4.0 (Tables 8-178/179/180), matching the commit log (Dave)

 - Patch 3: cxl/cdat: Gather DSMAS data for DCD partitions\
        - No functional change. Just added the tags below
        + Co-developed-by: Anisa Su (for shareable support)
        + Reviewed-by: Dave Jiang

 - Patch 6:
        - pci.c: size the Set Event Interrupt Policy payload by the
          device's policy layout (Get reply length) instead of assuming
          based on DCD command support; a CXL 3.0+ non-DCD device can have
          the dcd_settings policy bit but not support DCD commands (Benjamin Cheatham).
        - link to report: https://lore.kernel.org/linux-cxl/20260625112638.550691-1-anisa.su@samsung.com/T/#m09b4512dbde6e1f47a27f28c44e23d83a2d628e4

        - pci.c: add cxl_event_drain_mask() helper to set drain mask
          (standard logs when native_cxl, DCD when supported). Shared by
          cxl_event_thread() and the initial drain in cxl_event_config() to
          address the 2 issues reported by Sashiko below:
          1. If cxl_event_req_irq() fails for the DCD log, cxl_irqsetup()
            calls cxl_disable_dcd() — which clears the driver's flag but
            leaves the device armed for DCD interrupts. Then cxl_event_thread(),
            whose drain mask still included the DCD bit, would see
            CXLDEV_EVENT_STATUS_DCD set while cxl_mem_get_event_records()
            refused to drain that log (it checks cxl_dcd_supported(), now false),
            leaving the bit permanently set and spinning the
            do { } while (status) loop forever.
          2. The probe-time drain was gated on native_cxl, but the driver owns the
            DCD log regardless of who owns standard error handling (firmware cannot take DCD).
            So on a BIOS-first platform with a DCD device, the pre-existing DCD events were
            never drained at probe. Because the interrupts are edge-triggered, that already-set
            status bit could strand future notifications
          > link to report: https://lore.kernel.org/linux-cxl/20260625112638.550691-1-anisa.su@samsung.com/T/#m9141704ffeadd08ea86d16121575c4b5c400d107

 - misc. checkpatch and comment cleanups across the set

 - Tested-by: from Wonjae Lee, Junhee Park and Heesoo Kim on all 8 patches

The tags apply to the v11 series but I carried the tags over because
the changes detailed above (256B mailbox size, card with dcd_settings policy
bit but doesn't support 48xx cmds) are not relevant to the test configuration,
which has a sufficiently large mailbox size, and has both the
dcd_settings policy bit + supports the 48xx commands.
But if needed, this can be re-tested on HW. I thought
it might not be very meaningful since DCD is turned off.

Instead, I emulated a 256B mailbox with QEMU and a 3.0 non-DCD device to
check that the fixes work. Detailed below.

v11 (full series):
https://lore.kernel.org/linux-cxl/20260625112638.550691-1-anisa.su@samsung.com/

What changes for devices without DCD
====================================
Code that touches non-DCD devices:

 - ram_size and ram qos_class locate the RAM partition by mode instead of
   assuming index 0; cxl_pmem_size() becomes cxl_part_size().

 - CXL_NR_PARTITIONS_MAX goes from 2 to 3, and each partition records its
   DSMAS handle and shareable flag from CDAT. Both fields are written
   here but not consumed until the rest of the patchset.

Review status
=============
Patches 1, 2 and 6 carry no Reviewed-by: the DCD capability flag, the
Get DC Config read, and the event interrupt configuration, so review
there is especially welcome.  Patches 3 and 8 picked up Dave Jiang's
Reviewed-by since v11; the rest carry their v11 tags unchanged.

Patch organization
==================
 1-3: enumerate DCD command support, read the DC configuration, and pick
      up DSMAS data for DC partitions.
 4-6: split event msgnum configuration from irq setup, factor out the
      interrupt policy check, then configure the DCD event interrupt.
 7-8: prepatory refactors -- return the endpoint decoder from the region
      search, and enforce partition order while collapsing the ram/pmem
      specific partition helpers into one.

Testing
=======
As I mentioned above, the full v11 series was tested on shareable DCD hw
on GNR platform, but since the test configuration doesn't apply to
the changes made in this version, I quickly tweaked QEMU to emulate a
256B mailbox (set CXL_MAILBOX_PAYLOAD_SHIFT = 8) and set the minimum
policy length from 4 to 5 (to include dcd_settings).

The relevant conclusion from the HW testing on v11 is that adding
and releasing extents succeeded, so the event interrupts were working.
Additionally, the device is shareable and an untagged (null uuid)
extent was rejected, so partition data is probably read correctly.

Also used ndctl-test-runner to run cxl_test to test for regressions.
The NDCTL branch tested against is pmem/pending:
https://github.com/anisa-su993/ndctl-test-runner/actions/runs/30613886000

QEMU test results: interrupt policy sizing and Get DC Config bounding
=====================================================================
QEMU:   cxl-type3, two local modifications described per test

Test 1: Set Event Interrupt Policy against a strict device
----------------------------------------------------------
Models the card Benjamin Cheatham reported: CXL 3.0+, exposes the DCD
interrupt-policy field, does NOT advertise the 48h DCD command set.

QEMU modification -- make the device reject the 4 byte policy payload:

    --- a/include/hw/cxl/cxl_events.h
    +++ b/include/hw/cxl/cxl_events.h
    -#define CXL_EVENT_INT_SETTING_MIN_LEN 4
    +#define CXL_EVENT_INT_SETTING_MIN_LEN 5

Topology: plain cxl-type3 (no dc-regions), so no 48h commands appear in
the CEL and the driver leaves DCD unsupported.

With the fix (payload sized from the device's Get reply):

    Event config : OS DCD not supported
    memdev count:  1

The device probes, and the Set succeeds because the driver echoes back
the 5-byte layout the device declared in its Get reply, even though DCD
command support is off.

Without the fix -- same topology
(.size_in = CXL_EVENT_INT_POLICY_BASE_SIZE, i.e. always 4 bytes):

    [   13.635070] cxl_pci:__cxl_pci_mbox_send_cmd:346: cxl_pci 0000:0d:00.0: Mailbox operation had an error: invalid payload length
    [   13.638125] cxl_pci 0000:0d:00.0: Failed to set event interrupt policy : -6
    memdev count:  0

The failure is not cosmetic: cxl_event_config() propagates the error and
cxl_pci_probe() returns it, so the memory device does not attach at all.
This reproduces the reported failure and confirms the fix addresses it.


Test 2: Get DC Config on a spec-minimum mailbox
-----------------------------------------------
CXL r3.1 allows a 256-byte mailbox payload.  Before the v12 change the
driver asked for all CXL_MAX_DC_PARTITIONS (8) partitions in one Get DC
Config -- 8 + 8 * 40 = 328 bytes -- which cxl_internal_send_cmd() rejects
with -E2BIG before the command reaches the device, leaving DCD silently
unavailable.

QEMU modification -- shrink the mailbox to the spec minimum:

    --- a/include/hw/cxl/cxl_device.h
    +++ b/include/hw/cxl/cxl_device.h
    -#define CXL_MAILBOX_PAYLOAD_SHIFT 11        /* 2048 bytes */
    +#define CXL_MAILBOX_PAYLOAD_SHIFT 8         /*  256 bytes */

2a. Single DC region -- PASSES

    [  370.443819] cxl_pci_setup_mailbox: Mailbox payload sized 256
    [  370.574517] cxl_dc_check: DC partition 0 start 0 size 12884901888 blk_size: 2097152
    [  370.579817] cxl_dev_dc_identify: Returning partition 0 0 size 12884901888
    [  370.584529] cxl_configure_dcd: Adding dynamic ram partition 1; 0 size 12884901888
    [  370.588750] add_dpa_res: DPA(dynamic_ram_1): [mem 0x00000000-0x2ffffffff flags 0x200]

    # cat /sys/bus/cxl/devices/mem0/dynamic_ram_1/size
    0x300000000

cxl_dc_check() and cxl_dev_dc_identify() only reach those dev_dbg()s
after cxl_get_dc_config() returns successfully, so the read completed
rather than failing -E2BIG.  Exactly one "Sending command: 0x4800"
appears: the device has one region, so the per-call cap is exercised but
the start_partition continuation loop is not.

2b. Eight DC regions -- PASSES

Re-run with num-dc-regions=8 to force more partitions than fit in one
payload to test that the loop for retrieving all paritions is working.

    Mailbox payload sized 256
    "Sending command: 0x4800" count: 2

    [   13.037634] cxl_pci:__cxl_pci_mbox_send_cmd:263: cxl_pci 0000:0d:00.0: Sending command: 0x4800
    [   13.039762] cxl_pci:cxl_pci_mbox_wait_for_doorbell:74: cxl_pci 0000:0d:00.0: Doorbell wait took 0ms
    [   13.042483] cxl_core:cxl_get_dc_config:2166: cxl_pci 0000:0d:00.0: Read 5/8 DC partitions
    [   13.044020] cxl_core:cxl_dc_check:2111: cxl_pci 0000:0d:00.0: DC partition 0 start 0 size 1610612736 blk_size: 2097152
    [   13.046735] cxl_core:cxl_dc_check:2111: cxl_pci 0000:0d:00.0: DC partition 1 start 1610612736 size 1610612736 blk_size: 2097152
    [   13.049732] cxl_core:cxl_dc_check:2111: cxl_pci 0000:0d:00.0: DC partition 2 start 3221225472 size 1610612736 blk_size: 2097152
    [   13.053862] cxl_core:cxl_dc_check:2111: cxl_pci 0000:0d:00.0: DC partition 3 start 4831838208 size 1610612736 blk_size: 2097152
    [   13.056833] cxl_core:cxl_dc_check:2111: cxl_pci 0000:0d:00.0: DC partition 4 start 6442450944 size 1610612736 blk_size: 2097152
    [   13.059801] cxl_pci:__cxl_pci_mbox_send_cmd:263: cxl_pci 0000:0d:00.0: Sending command: 0x4800
    [   13.062293] cxl_pci:cxl_pci_mbox_wait_for_doorbell:74: cxl_pci 0000:0d:00.0: Doorbell wait took 0ms
    [   13.064680] cxl_core:cxl_get_dc_config:2166: cxl_pci 0000:0d:00.0: Read 3/8 DC partitions
    [   13.066897] cxl_core:cxl_dc_check:2111: cxl_pci 0000:0d:00.0: DC partition 5 start 8053063680 size 1610612736 blk_size: 2097152
    [   13.072694] cxl_core:cxl_dc_check:2111: cxl_pci 0000:0d:00.0: DC partition 6 start 9663676416 size 1610612736 blk_size: 2097152
    [   13.076634] cxl_core:cxl_dc_check:2111: cxl_pci 0000:0d:00.0: DC partition 7 start 11274289152 size 1610612736 blk_size: 2097152
    [   13.080084] cxl_core:cxl_dev_dc_identify:2256: cxl_pci 0000:0d:00.0: Returning partition 0 0 size 1610612736

Two Get DC Config commands rather than one: the device holds eight
partitions and only five fit per call, so start_partition advances and
the remaining three are read in a second call. 

Ira Weiny (8):
  cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
  cxl/mem: Read dynamic capacity configuration from the device
  cxl/cdat: Gather DSMAS data for DCD partitions
  cxl/events: Split event msgnum configuration from irq setup
  cxl/pci: Factor out interrupt policy check
  cxl/mem: Configure dynamic capacity interrupts
  cxl/core: Return endpoint decoder information from region search
  cxl/core: Enforce partition order/simplify partition calls

 drivers/cxl/core/cdat.c   |  13 ++
 drivers/cxl/core/core.h   |   6 +-
 drivers/cxl/core/hdm.c    |  14 +-
 drivers/cxl/core/mbox.c   | 286 +++++++++++++++++++++++++++++++++++++-
 drivers/cxl/core/memdev.c |  36 ++---
 drivers/cxl/core/region.c |   8 +-
 drivers/cxl/cxl.h         |   4 +-
 drivers/cxl/cxlmem.h      |  88 +++++++++++-
 drivers/cxl/mem.c         |   2 +-
 drivers/cxl/pci.c         | 161 ++++++++++++++++-----
 include/cxl/cxl.h         |   7 +-
 11 files changed, 546 insertions(+), 79 deletions(-)


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
2.43.0

