Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AB72D2381
	for <nvdimm@lists.linux.dev>; Wed,  7 Oct 2026 20:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791404317; cv=none; b=hW61YhR4EWt8XfeVRUeg0IDpgo7lk6aEckx4spido/dAMteXn3APDMFWA4J9Qm3ZddJcXwprqRMI0Pm0qJjDvHe5o8M3xNFlMO8gQ/ISqRT2ank8cACXhB35N5E84Ns5Z8tV1k+KncM0dKQUPSDr74aV1D5cWKx2sm3g0zQeF24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791404317; c=relaxed/simple;
	bh=Mm0fG/P6PzrdX8Rjw2ojzv5keGjmPaoO1yPnuUJtTyA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XpM0P94zI4asRt6jCkfm16iUqaSkRy350EbZOwu/6hX8h1KiDOpnBZE3hV1MFOQn4GWQoFyba0mcz+ZgRJB9Fru2obI55zNLFqCOTc3wFGIuT9tfmpSH2FIZ59HN+1oSf3Y2MS8IHu7hwpToA9EYPerh6F45aqNos5I+M3NgEp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=idbHKn/k; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="idbHKn/k"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cbe6295f05bso9013a12.1
        for <nvdimm@lists.linux.dev>; Wed, 07 Oct 2026 13:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791404315; x=1792009115; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fCLbHGwsWnPpim7MfXHsc24iqNdo+Md2nOyN7gtEbes=;
        b=idbHKn/kGtC7jyfdkPdhJbfrfe2Iw6nj+XUylLHAn3+aOeicvaZv3LWgpM8uep5wGa
         /IzyWpgHQbn1NjNLhn94WCHmjDAeLpbkkCtYH4j4fpeWPrWU/qBpmos7Od730cXnHjKM
         43VUpi+rdnx36Fc5TWGmvr9+m65TMyHz/ma4X5yACIMch40IIqnHZ7NsFvIZ6xxwJr3l
         drhG/wGs/snhx4zgOfbZ3P7NLEnJ2URPr1lxTF7NH+qcU71n0GmJV5t92SwclxxiiD8C
         mAsfjLyZurV6qT+Gw4DiZn8sQKw4tLN+qr8wNVS91lJ7E7zvAglFrYfbXRvqp1cpv/As
         hZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791404315; x=1792009115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fCLbHGwsWnPpim7MfXHsc24iqNdo+Md2nOyN7gtEbes=;
        b=czt3qy7BrOfCYaN30F4zQxPLPaynuJNzSVmz7JN47MXpzy5dCq5K4XCEeaUBhihgS6
         aPJeB9A5iDXYnlfgRTr4U90x1JsIkNDGTeEc7WXGGAT0Tb3JeL9I6/UJFVUIay6VqTN2
         Xg41ZiDDgSekU0udnKkgzqiZ2PnfwVTSlIoPE0jDujmKb4qjzDX3cWvUYesF4AZpYFBa
         AC/K2obzX9UEpk4DreU0Cv3s/n+4GMEfqRaUv9ZvqpAZKr1PEdLzfAg2yxVTPzh64U+e
         9DYrWsEe3vmO5yQM2O/mAW9HzM7rECeuB52jxiF8mBll5qcUd2GzsfjJcPYAN9fiIawW
         6Y4A==
X-Gm-Message-State: AFq9FYL3zrUtsIdVG4VckWytJfGegKF3vKGcTpzGVwbNdGJwZ0u/UYw4
	f8Ow1rXH4I3Zhsav0DjuTZiyrqz6LhIvT1Hz3vxGOvM3OpaE2oCF6+sf
X-Gm-Gg: AYBFou3vLzSnctfFgoe80fFPr1UpqJcq8y0dbUOmL3OjeO50ThCZGJVRgQ0INoRR7I+
	9woMfM+lp+eBXO6f4BZ3DhXePoI77DThflZdr1u6gRdMEqWfeoIB1cK/z2wZUSilZwAfmHUwDfn
	hadkYBOh5aOYkhesXD5BGdkQcIU52dgwTqTRMKtzgYzM5p89W6QKrX+qyUYQncl/NKeDzIO3R4r
	brm+ZDFPeaJAbN+EbCXs67PoDtk9odKLksaoeQa7wAxuw5UX+SNs6QN7iDISmOH/J7KXxBZG/gS
	V/aEGv6BbzqQcc62RDRaASuRgJwL5aZeRuaS0GIN7pdKGdOwUdRB7bem3pUyQM6EAXzCEkUuKF8
	LqvZW5LFSZ7GtsF3TPm3EridrdPEMEAVRpKeCZvmVgF0wqNiS6etzh+eYB22uxz132BKHdFlt0d
	LhQl+OUsmijLEvsqi3ZSd6k9Y7Ail88vfjJ4g5QS1wUrGpSp6KoQyJmLeRP5OuW7ye4mkjrV6RH
	XonbNJlAYrbKW1QYSGBzfQAwCfFvPFJpEdISV6Y+4x7mnVSIdRq02fUKvW2Fli6KVqJKioiR4uZ
	Qebdcaqwu+imkQ==
X-Received: by 2002:a17:90a:c88b:b0:3a8:63da:44b5 with SMTP id 98e67ed59e1d1-3aaed7e77a6mr144349a91.24.1791404314693;
        Wed, 07 Oct 2026 13:18:34 -0700 (PDT)
Received: from 4470NRD-ASU.ssi.samsung.com (c-24-19-224-150.hsd1.wa.comcast.net. [24.19.224.150])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9ff7ab034sm967623a91.4.2026.10.07.13.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 13:18:34 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Richard Cheng <icheng@nvidia.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v15 0/8] DCD Prep Series
Date: Wed,  7 Oct 2026 13:16:33 -0700
Message-ID: <20261007201828.952-1-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are the first eight patches of the Dynamic Capacity Device (DCD)
series. They set up: DCD enumeration, CDAT handling for DC partitions,
the event interrupt plumbing, a preparatory refactor, and
documentation of the DPA partition layout. They stand alone and keep DCD
disabled. They are not dependent on the rest of the series.

Patch 1 detects the 48h command set and then leaves mds->dcd_supported
false. The flag is only turned on by the series that adds DCD event
handling, so every DCD specific path added here is shut off at runtime:
cxl_configure_dcd() never runs, no DC partition is created, no DCD
interrupt is armed, and the CXL_PARTMODE_DYNAMIC_RAM paths are
unreachable. The intent is to land the enumeration and plumbing while
the extent to DAX pipeline is still under review.

Based on v7.3-rc6

v14: https://lore.kernel.org/linux-cxl/20260918203049.7273-1-anisa.su@samsung.com/T/#m0b6ade9da2d4fefa8aab3bb7db7c29516bc3f955

v14 -> v15 Changes:
===================
The first and only supported DC partition's DPA resource name is still
dynamic_ram_1 because the partition's sysfs directory comes from the DPA
resource name. So it would show up as /sys/bus/.../dynamic_ram_1/
No sysfs patches are in this series, those come later.

 - Patch 1: cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
        - No change.

 - Patch 2: cxl/mem: Read dynamic capacity configuration from the device
        - Renamed partition mode from CXL_PARTMODE_DYNAMIC_RAM_1 to
	  CXL_PARTMODE_DYNAMIC_RAM.
	  The mode should only describe the capacity type, not the number of
	  the partition. The _1 looks to be an artifact from v8 to v9, when we
	  went from supporting all 8 partitions down to limiting to 1.
	  The first and only supported DC partition's DPA resource name is still
	  dynamic_ram_1 because the partition's sysfs directory comes from the DPA
	  resource name. So it would show up as /sys/bus/.../dynamic_ram_1/
	  when the sysfs patches from the rest of the series are added.

 - Patch 3: cxl/cdat: Gather DSMAS data for DCD partitions
        - Disable DCD when the DC partition has no valid DSMAS entry:
          no CDAT, CDAT parse failure, or no entry matching the
          partition. A DCD shall describe its DC partition in a DSMAS
          (CXL r4.0 9.13.3), so rather than run with unknown attributes
          the device keeps its static capacity and loses DCD (Richard,
          Dave).
        - DSLBIS is optional. cxl_cdat_endpoint_process() treated zero
          DSLBIS entries as a parse failure, which with the change above
          would have disabled DCD on a device with a perfectly valid
          DSMAS. An empty DSLBIS no longer fails the parse, and
          cxl_port_perf_data_calculate() skips DSMAS entries that have
          no DSLBIS coordinates so the QTG _DSM is never evaluated with
          zero bandwidth
        - cxl_memdev_apply_dsmas() takes an enum cxl_dsmas_apply
          (FLAGS / FLAGS_PERF) instead of a bool so the call sites say
          what is applied (Dave).
        - The DSMAS read-only flag (CDAT 1.04, Flags bit 6) is recorded
          on the partition alongside shareable. (Jonathan)

 - Patch 4: cxl/events: Split event msgnum configuration from irq setup
        - No code change.

 - Patch 5: cxl/pci: Factor out interrupt policy check
        - No code change.

 - Patch 6: cxl/mem: Configure dynamic capacity interrupts
        - CXLDEV_EVENT_STATUS_STANDARD_LOGS names the four standard
          logs (INFO | WARN | FAIL | FATAL) that cxl_event_drain_mask()
          and the cxl_test mock's probe-time drain spelled out long-hand
          (Dave/Jonathan)
        - On platforms where BIOS owns the event logs, a failed Get or
          Set Event Interrupt Policy now disables DCD instead of failing
          the memdev probe. Before this series that path never reached
          the mailbox on such a platform; DCD is now the only reason it
          does, so a failure there costs DCD, not the device. With OS
          owned logs the commands remain fatal to probe as before
          (Sashiko).

 - Patch 7: cxl/core: Enforce partition order/simplify partition calls
        - No change.

 - Patch 8: Documentation/cxl: Document DPA partition layout and
   ordering rules
        - No change.

Review status
=============
Dropped all tested-by tags for patches 1-8

Patch 2: Dropped all Review tags.

Patch 3: Dropped all Review tags.

Patch 6: Dropped all Review tags.

Patch organization
==================
 1-3: enumerate DCD command support, read the DC configuration, and pick
      up DSMAS data for DC partitions.
 4-6: split event msgnum configuration from irq setup, factor out the
      interrupt policy check, then configure the DCD event interrupt.
   7: preparatory refactor -- enforce partition order while collapsing
      the ram/pmem specific partition helpers into one.
   8: document the DPA partition layout the previous patches enforce,
      and where Linux is stricter than the specification.

Testing
=======
This series leaves mds->dcd_supported false on purpose, so
cxl_configure_dcd(), cxl_dev_dc_identify() and cxl_dc_check() are
unreachable at runtime as posted. The tests below are done with the rest
of the series on top, otherwise testing would not yield any meaningful
results.

HW:
Waiting on results from partner team.

cxl_test:
ndctl's cxl suite against cxl_test (7.3.0-rc6, CXL as modules)
16 of 17 pass, cxl-features.sh skips for lack of FWCTL, and
cxl-dcd.sh passes.

QEMU:
Tested extent add/release and DAX device create/destroy.
Tested that expected errors are printed from malformed Get DC Configuration
payload.

Anisa Su (1):
  Documentation/cxl: Document DPA partition layout and ordering rules

Ira Weiny (7):
  cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
  cxl/mem: Read dynamic capacity configuration from the device
  cxl/cdat: Gather DSMAS data for DCD partitions
  cxl/events: Split event msgnum configuration from irq setup
  cxl/pci: Factor out interrupt policy check
  cxl/mem: Configure dynamic capacity interrupts
  cxl/core: Enforce partition order/simplify partition calls

 .../driver-api/cxl/linux/cxl-driver.rst       |  35 +++
 Documentation/driver-api/cxl/maturity-map.rst |   4 +
 drivers/cxl/core/cdat.c                       |  97 +++++-
 drivers/cxl/core/hdm.c                        |  24 +-
 drivers/cxl/core/mbox.c                       | 285 ++++++++++++++++++
 drivers/cxl/core/memdev.c                     |  94 ++++--
 drivers/cxl/cxl.h                             |  14 +-
 drivers/cxl/cxlmem.h                          |  88 +++++-
 drivers/cxl/mem.c                             |   2 +-
 drivers/cxl/pci.c                             | 176 +++++++++--
 include/cxl/cxl.h                             |  29 +-
 tools/testing/cxl/test/mem.c                  |   2 +-
 12 files changed, 761 insertions(+), 89 deletions(-)


base-commit: a90ee4305c4a5df72c11b31dacfdc76e00fcf78a
-- 
2.43.0

