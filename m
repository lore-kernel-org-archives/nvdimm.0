Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C985B2C80
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 00:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642984225; x=1674520225;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TKw70AgVSmJbbUvZiEhzBMjVlCr5iAywMIryPYGbqI4=;
  b=K77z+bAfD4ul+dOCCnACaez0/N61+1XaGGUpc5Sk8hp7PlraH5T3qj9+
   423TuJzVjZa255xIzooJeF1v7XHA1DP87b5WCw2e+WrxN9HOrE50BwJLn
   Ec/O0epvcNZxN/HjgRJMfWJzdR7kdqqjR+i7WbNPepCEwbtpEsMFsxKqg
   X/u8dSJDQvfy4c0YMh6LbT8JxIi35EnFTswXmdjNLCAq3ozj+FrqQyKQT
   M4ICRY5z7ctB9AF4QKmqcxU16p+izP8cN5fi8Fg4pW21z567kIP6UCXY8
   JpgZX2QtrZGzxj9qxrSbeKLQkmh0LSFGUYLFI++8WoLnqlEJ4uVTadoqj
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="246151673"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="246151673"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:30:25 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="623902792"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:30:25 -0800
Subject: [PATCH v3 20/40] cxl/pci: Rename pci.h to cxlpci.h
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: kernel test robot <lkp@intel.com>, linux-pci@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Sun, 23 Jan 2022 16:30:25 -0800
Message-ID: <164298422510.3018233.14693126572756675563.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Similar to the mem.h rename, if the core wants to reuse definitions from
drivers/cxl/pci.h it is unable to use <pci.h> as that collides with
archs that have an arch/$arch/include/asm/pci.h, like MIPS.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/acpi.c      |    2 +-
 drivers/cxl/core/regs.c |    2 +-
 drivers/cxl/cxlpci.h    |    1 +
 drivers/cxl/pci.c       |    2 +-
 4 files changed, 4 insertions(+), 3 deletions(-)
 rename drivers/cxl/{pci.h => cxlpci.h} (99%)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index e596dc375267..3485ae9d3baf 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -6,8 +6,8 @@
 #include <linux/kernel.h>
 #include <linux/acpi.h>
 #include <linux/pci.h>
+#include "cxlpci.h"
 #include "cxl.h"
-#include "pci.h"
 
 /* Encode defined in CXL 2.0 8.2.5.12.7 HDM Decoder Control Register */
 #define CFMWS_INTERLEAVE_WAYS(x)	(1 << (x)->interleave_ways)
diff --git a/drivers/cxl/core/regs.c b/drivers/cxl/core/regs.c
index 12a6cbddf110..65d7f5880671 100644
--- a/drivers/cxl/core/regs.c
+++ b/drivers/cxl/core/regs.c
@@ -5,7 +5,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <cxlmem.h>
-#include <pci.h>
+#include <cxlpci.h>
 
 /**
  * DOC: cxl registers
diff --git a/drivers/cxl/pci.h b/drivers/cxl/cxlpci.h
similarity index 99%
rename from drivers/cxl/pci.h
rename to drivers/cxl/cxlpci.h
index 0623bb85f30a..eb00f597a157 100644
--- a/drivers/cxl/pci.h
+++ b/drivers/cxl/cxlpci.h
@@ -2,6 +2,7 @@
 /* Copyright(c) 2020 Intel Corporation. All rights reserved. */
 #ifndef __CXL_PCI_H__
 #define __CXL_PCI_H__
+#include "cxl.h"
 
 #define CXL_MEMORY_PROGIF	0x10
 
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index bdfeb92ed028..c29d50660c21 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -10,7 +10,7 @@
 #include <linux/pci.h>
 #include <linux/io.h>
 #include "cxlmem.h"
-#include "pci.h"
+#include "cxlpci.h"
 #include "cxl.h"
 
 /**

