Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1E15D750
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 10:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709720955; cv=none; b=bAT+2SSUzzuYZKzM/bw+QY/SeFM7GsY6GF6o4gw4lvKaRNkMaIy4/0qPuuy/3yZAQUwqGtoZfhAb9wKfn9NH+nGMxYvYvPVit9qCBR/Ue8th1oZ/LGbOpSIAdSDTwVKOeWBObOowq7bQrN4xou4/9dhappMJDvsgbjYx/3kJ5B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709720955; c=relaxed/simple;
	bh=L1uC7nmPQ3VWAXabC3fl20OZJAiFpMalcUh/l8cZZSY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oNt2qb3fbGKsNiTEKMrw3JCga4tD7BN7nCD0azM03GqjHo6DBupGzPZXqyGHPRSH/tZR0lzc1W/hXPobEqG4y6TFUjI1gG9sLfa4DVPvTHn3lbTJbEgyCB+vmv2xW02aaiDLNjDDNd+YNRgOImq9g/Oxl9IbUaEcuPPKsCPpDBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=bOOoL+v6; arc=none smtp.client-ip=68.232.139.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="bOOoL+v6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1709720953; x=1741256953;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=L1uC7nmPQ3VWAXabC3fl20OZJAiFpMalcUh/l8cZZSY=;
  b=bOOoL+v6ililZ8ZqzNqCbYpDiTxSZEqkXbDK00EwvWiud90QTOin0bKO
   P6xGRwK7ShBq71pNgQPeJrEA7bI0wZQD2pVqiPLHyb6/JeZir5NWPEU/x
   b9NKBt0IOAFMN3f2QfbqUTsfC9aBW38EqxHgFNfp201Gf32QyLhaDoEzN
   iNWmb0+TWwwSSn6X7MAQXiH1ZWwj66+X34fVL9rThzvpsa1pn0bkZizrk
   IB/MupIhuZ3fNLBlC4SixwCTEWago/KF1EYAppuD+EX9W0XvmxFpgHEEZ
   XSpYo975aEs/q1E34yZ0TKmYLJP23OHYayow6E2nvBbrcgGn4s4/9ncOm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="153205382"
X-IronPort-AV: E=Sophos;i="6.06,208,1705330800"; 
   d="scan'208";a="153205382"
Received: from unknown (HELO oym-r3.gw.nic.fujitsu.com) ([210.162.30.91])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 19:29:10 +0900
Received: from oym-m4.gw.nic.fujitsu.com (oym-nat-oym-m4.gw.nic.fujitsu.com [192.168.87.61])
	by oym-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id D42F312E239
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:07 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id E5387D5D17
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:06 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 6F8CB21735C
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:06 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 8455D1A006A;
	Wed,  6 Mar 2024 18:29:04 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: y-goto@fujitsu.com,
	Alison Schofield <alison.schofield@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	hpa@zytor.com,
	Ingo Molnar <mingo@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-cxl@vger.kernel.org,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	x86@kernel.org,
	kexec@lists.infradead.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [RFC PATCH v3 0/7] device backed vmemmap crash dump support
Date: Wed,  6 Mar 2024 18:28:39 +0800
Message-Id: <20240306102846.1020868-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28234.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28234.006
X-TMASE-Result: 10--12.047900-10.000000
X-TMASE-MatchedRID: WgnE0i2Gnm0S1H+wJnLU0xxQCXaqsX3JICcCYi/y4c1YC5LPd7BvbZVh
	8IAdHNwNV9EQFA1Eag8lMmENZ05/+9/K1ikJIsLOF+qQpCWTUjks9yCYjUR6S0u7cLcUs73+UAr
	JnwHoG3RN6oLBwrNlQwp3Fx4qZRwntpor8DSuIkBIK2DGByysyvrFoSv9vjATUYkZd9+4t2+K/w
	YsY7aZE7yLKxASOUwjkBUaTCifn9xExKw+e7wVxgPZZctd3P4BX098A7fr3Vfir9ZdeIDkfES3N
	7Ud/ZNyw3/C2qEmiGxJ7i3niaFL/WIo6q3zeo5wqhcdnP91eXGdj7YWJLs3nTb+WPFOeKNMsX5M
	tbDfIWiy+iBzQ4hgrIaPRWRVv3Ad5mMeg8RfsnWHmRpBdG9H1zX8AUEphxj0Blnw3dG9MzGjxYy
	RBa/qJcFwgTvxipFajoczmuoPCq3JpPrv+A3tItKgYcJqG5qWnoRh9cAERsgMkJ+raRGIqWxKck
	D0+Hnx
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Hello folks,

Compared with the V2[1] I posted a long time ago, this time it is a
completely new proposal design.

### Background and motivate overview ###
---
Crash dump is an important feature for troubleshooting the kernel. It is the
final way to chase what happened at the kernel panic, slowdown, and so on. It
is one of the most important tools for customer support.

Currently, there are 2 syscalls(kexec_file_load(2) and kexec_load(2)) to
configure the dumpable regions. Generally, (A)iomem resources registered with
flags (IORESOURCE_SYSTEM_RAM | IORESOUCE_BUSY) for kexec_file_load(2) or
(B)iomem resources registered with "System RAM" name prefix for kexec_load(2)
are dumpable.

The pmem use cases including fsdax and devdax, could map their vmemmap to
their own devices. In this case, these part of vmemmap will not be dumped when
crash happened since these regions are satisfied with neither the above (A)
nor (B).

In fsdax, the vmemmap(struct page array) becomes very important, it is one of
the key data to find status of reverse map. Lacking of the information may
cause difficulty to analyze trouble around pmem (especially Filesystem-DAX).
That means troubleshooters are unable to check more details about pmem from
the dumpfile.

### Proposal ###
---
In this proposal, register the device backed vmemmap as a separate resource.
This resource has its own new flag and name, and then teaches kexec_file_load(2)
and kexec_load(2) to mark it as dumpable.

Proposed flag: IORESOURCE_DEVICE_BACKED_VMEMMAP
Proposed name: "Device Backed Vmemmap"

NOTE: crash-utils also needs to adapt to this new name for kexec_load()

With current proposal, the /proc/iomem should show as following for device
backed vmemmap
# cat /proc/iomem
...
fffc0000-ffffffff : Reserved
100000000-13fffffff : Persistent Memory
  100000000-10fffffff : namespace0.0
    100000000-1005fffff : Device Backed Vmemmap  # fsdax
a80000000-b7fffffff : CXL Window 0
  a80000000-affffffff : Persistent Memory
    a80000000-affffffff : region1
      a80000000-a811fffff : namespace1.0
        a80000000-a811fffff : Device Backed Vmemmap # devdax
      a81200000-abfffffff : dax1.0
b80000000-c7fffffff : CXL Window 1
c80000000-147fffffff : PCI Bus 0000:00
  c80000000-c801fffff : PCI Bus 0000:01
...

### Kdump service reloading ###
---
Once the kdump service is loaded, if changes to CPUs or memory occur,
either by hot un/plug or off/onlining, the crash elfcorehdr should also
be updated. There are 2 approaches to make the reloading more efficient.
1) Use udev rules to watch CPU and memory events, then reload kdump
2) Enable kernel crash hotplug to automatically reload elfcorehdr (>= 6.5)

This reloading also needed when device backed vmemmap layouts change, Similar
to what 1) does now, one could add the following as the first lines to the
RHEL udev rule file /usr/lib/udev/rules.d/98-kexec.rules:

# namespace updated: watch daxX.Y(devdax) and pfnX.Y(fsdax) of nd
SUBSYSTEM=="nd", KERNEL=="[dp][af][xn][0-9].*", ACTION=="bind", GOTO="kdump_reload"
SUBSYSTEM=="nd", KERNEL=="[dp][af][xn][0-9].*", ACTION=="unbind", GOTO="kdump_reload"
# devdax <-> system-ram updated: watch daxX.Y of dax
SUBSYSTEM=="dax", KERNEL=="dax[0-9].*", ACTION=="bind", GOTO="kdump_reload"
SUBSYSTEM=="dax", KERNEL=="dax[0-9].*", ACTION=="unbind", GOTO="kdump_reload"

Regarding 2), my idea is that it would need to call the memory_notify() in
devm_memremap_pages_release() and devm_memremap_pages() to trigger the crash
hotplug. This part is not yet mature, but it does not affect the whole feature
because we can still use method 1) alternatively.

[1] https://lore.kernel.org/lkml/02066f0f-dbc0-0388-4233-8e24b6f8435b@fujitsu.com/T/
--------------------------------------------
changes from V2[1]
- new proposal design

CC: Alison Schofield <alison.schofield@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Baoquan He <bhe@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Dave Hansen <dave.hansen@linux.intel.com>
CC: Dave Jiang <dave.jiang@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Ira Weiny <ira.weiny@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Vishal Verma <vishal.l.verma@intel.com>
CC: linux-cxl@vger.kernel.org
CC: linux-mm@kvack.org
CC: nvdimm@lists.linux.dev
CC: x86@kernel.org

Li Zhijian (7):
  mm: memremap: register/unregister altmap region to a separate resource
  mm: memremap: add pgmap_parent_resource() helper
  nvdimm: pmem: assign a parent resource for vmemmap region for the
    fsdax
  dax: pmem: assign a parent resource for vmemmap region for the devdax
  resource: Introduce walk device_backed_vmemmap res() helper
  x86/crash: make device backed vmemmap dumpable for kexec_file_load
  nvdimm: set force_raw=1 in kdump kernel

 arch/x86/kernel/crash.c         |  5 +++++
 drivers/dax/pmem.c              |  8 ++++++--
 drivers/nvdimm/namespace_devs.c |  3 +++
 drivers/nvdimm/pmem.c           |  9 ++++++---
 include/linux/ioport.h          |  4 ++++
 include/linux/memremap.h        |  4 ++++
 kernel/resource.c               | 13 +++++++++++++
 mm/memremap.c                   | 30 +++++++++++++++++++++++++++++-
 8 files changed, 70 insertions(+), 6 deletions(-)

-- 
2.29.2

