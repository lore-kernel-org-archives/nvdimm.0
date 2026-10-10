Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097CA377553
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 22:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791673025; cv=none; b=bQ4HpwjdLKfo8DB43ZKf+Q7P2WmHRHyzMghpiU9A0It1/8yR8aCHK5fiwrufmgUcE1r3sDioOzsqQnG4LQBoJFecIg5HyNPY7sQK9/mRqgIjwpNHZefUfVcfkmJeXW00PEp5Hxuv5I84P81jTtrMAvivmIaExg4W4AM+fDWdWe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791673025; c=relaxed/simple;
	bh=v9xElfPDtUKLBbAOUyC6WEp4xXa0Taz+orpIfsa4F2k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jlUGgUw41AOb4rR1m9D1ChfBS1rLv1OWEQ9sbcEv/rGhPYbMStKZc6OzsdOpr/Hl/qpV6AJmmSIjn27Y+q+ILa7jIvreMDsFdtb6j3qyf3O1JGK5xl8QSFA1kVDpWVT7dqaPU9PzCYZAcUt9MXW4KeR//Gpr/7NK54iu2naJNZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iyl3cuZk; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iyl3cuZk"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8917c712f32so293480b3a.2
        for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 15:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791673023; x=1792277823; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ch8jJvcOl0DuSm2wf0+1Uy+KIAeGMYwyi2l0FK4u8IM=;
        b=Iyl3cuZk8K09Q0DsIsj+EHRKkNeq2Kvl/VOPhTEsZto0rLiKl80ZI2ievdj3H1i8G+
         oFx6NFBRfS50sVwcA3hPT5xaZceGQTXUsSNvWeodqGk9xS+6r93hNjxmI9MYouoNOLP2
         m8KLfHBAlsRnkyC15OUqw8b5wZd9PHGJNyt20kw1lkPIOj5JaWFUuSk4cVKNz7HNoNXc
         9ezyTwjAep9fLQvrNtIT5rVtmYDfChN/F7M17RVy7uA3OHAzwHTkse4KYwDkzLbaSRav
         y4rOxYa6ds7qss/km+l4y+EAoXV/QusbTeVPddjeZA+jS0UIbp0oY5NUBFEodSqztOha
         7V3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791673023; x=1792277823;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ch8jJvcOl0DuSm2wf0+1Uy+KIAeGMYwyi2l0FK4u8IM=;
        b=yBx4qDFK0FzqIBi8/xAmLesFCnvRBeU1Z1vAcD5CjC5bQ4AdpPUFCkP+iciQQd9VoI
         s+k5V2iNwtywZ0rePKnZZsA5eeUYe0e7m1MDHw6OpliwED+I7voIscg0mKqr9DE20y5A
         oSFyh5n1TL3pQbSObO470HauPgPFyZzjdCHw37A9kp7lxI+M2geSKXyF+vGLq5lMu+2Y
         Oppn8mGLpBGGAK4dHS+0xyIYl19+J/EkKD/o9X+V70LNBhybUSb86Nj24NjFADg/upzd
         7Zo3A3rqcT4TCOmuNRWBPr5OKa6ziSiD4Xvay6DO7OVaKgJZn3DBabT9xvG7hDIV/Mjb
         3TSg==
X-Gm-Message-State: AFq9FYK61bhlD1xcbwXA+plDIxf8AhHe1vkO93jYgQ/8dtDuxDo5/DQR
	O5gTo+8l1BD4tyPqLobtqkS/YNgqEMVgaJLLdOZVB2RW8qKpVDCEcLb3
X-Gm-Gg: AYBFou3kzz3LEtYP3+3zZwph/ksOfGjjWSY+AoeBRBEDxHh28xoLK7mGKKh8n0QUbeo
	wED4y0V5svl66RCWJoJJypUlDi3AkmgSivt0xCdGjjpeSVHZuaB15xamCUjV+9LpYyFUziU+i5o
	jIBVS/Dy6x0A8t/lyHVN8uYclyBn3M+Rh8uOeKBK8rJ3V7SRaMOa+aBAMxP6KIDwKr2tQiBNvgh
	JNnZh1ToWt2jbfI48iqrazuadvUfDNzJ5dhmLqyDGOvjge2c4mp0ca/w2GQbBt1BYEzJ37538fJ
	LV2T9k9WDXqiYKpQE03KM5VweuIfvUI58nfT7S86cwgiDrUMiBjaXMP3mmi4SlDf8+WgKgdQGFG
	gD39lm4bwK0/YH1W8RtkWaicibqqDl+Dp2WKvTjfM6iVKFst8qq+eGcMVWGG18UNycuXUVqBXfd
	GLPxp0dhUslKUUhx4Mu9ZN1G3g/CHVR4IBnKYeZAr3RgM7dS5t9uyT254LJKkjJNrbL2M42NODN
	E2UkqHQE9WnDXcm8IPkbr2OoI9V
X-Received: by 2002:a05:6a21:398f:b0:3dd:85a9:55a3 with SMTP id adf61e73a8af0-3e16bee802emr5923819637.37.1791673023130;
        Sat, 10 Oct 2026 15:57:03 -0700 (PDT)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9e07329sm2603662a12.5.2026.10.10.15.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 15:57:02 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
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
Subject: [PATCH v16 0/8] DCD Prep Series
Date: Sun, 11 Oct 2026 07:54:51 +0900
Message-ID: <20261010225852.10727-1-anisa.su@samsung.com>
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
v15: https://lore.kernel.org/linux-cxl/20261007201828.952-1-anisa.su@samsung.com/

v15 -> v16 Changes:
===================
A quick respin:

 - Patch 2: cxl_configure_dcd() took Identify Total Capacity as the end
   of static capacity, but Total Capacity is only required to be >=
   ram + pmem. The static end now comes from the last static partition's end dpa
   +1 instead of info->size. Check that DC starts from there. (Richard).

 - Patch 3: dsmas_entry.qos_class initialized as CXL_QOS_CLASS_INVALID, so a
   DSMAS entry that is skipped for lack of DSLBIS, or whose QTG lookup
   fails, no longer reaches update_perf_entry() with qos_class 0, which
   is a valid class. (Sashiko).
   
   The DSMAD handle check now checks handle > U8_MAX instead of
   handle & ~0xFF (Dave).

 - Patch 6: when the DCD vector cannot be requested, tell the device
   not to use the vector: dcd_settings is cleared with
   Set Event Interrupt Policy, so a device does not keep signalling a
   vector with no handler while the
   host considers DCD off.  The Set command is re-factored into a new helper
   cxl_event_set_int_policy() (Richard).
   
All other patches are unchanged.
I kept the review tags on patch 3, since the changes are minimal and
dropped tags from 2 and 6.

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
Tested add and release of one 2G tagged extent on a DCD with a sharable
partition, driven from the system's BMC with FM-API Initiate Dynamic
Capacity Add / Release over MCTP, to confirm the DCD interrupt
configuration and the DSMAS attributes are read properly. The device
is sharable, so an add without a tag and sequence number is refused.


cxl_test:
ndctl cxl test suite
16 of 17 pass, cxl-features.sh skips for lack of FWCTL

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
 drivers/cxl/core/cdat.c                       |  99 +++++-
 drivers/cxl/core/hdm.c                        |  24 +-
 drivers/cxl/core/mbox.c                       | 285 ++++++++++++++++++
 drivers/cxl/core/memdev.c                     | 100 ++++--
 drivers/cxl/cxl.h                             |  14 +-
 drivers/cxl/cxlmem.h                          |  88 +++++-
 drivers/cxl/mem.c                             |   2 +-
 drivers/cxl/pci.c                             | 207 ++++++++++---
 include/cxl/cxl.h                             |  29 +-
 tools/testing/cxl/test/mem.c                  |   2 +-
 12 files changed, 792 insertions(+), 97 deletions(-)


base-commit: a90ee4305c4a5df72c11b31dacfdc76e00fcf78a
-- 
2.43.0

