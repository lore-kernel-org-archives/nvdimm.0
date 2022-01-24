Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236BE2C80
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 00:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642984162; x=1674520162;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k0XhA7pSlOBp9D/wBrI3FsZj1B5eEzrI4kbiQ3pUgbA=;
  b=D7lta/5H7RAFMF7cNAr28YyN0dPsSe0ddEmdpNNcpXT86ukwODNtlwhy
   wQcnE4OBDcHorZVq7Tv6YYwQ1f3olPsPJLTni2hr711Qc9359GlhAmJXA
   2QxKci9FpGD+GDEewjTPnswSE8gjsn0wsmsiusTIARtaWGEdEvSx/A39s
   x3IgiC2zcymi+71XDw4tpHmlghclCPuiWwCsJNNB5BdmA2BrvFTdROvfu
   K0k8rl+A7Eu2K0xrXUVXb3jLbPh+UIgvQ1d2HXiyiuTEecvLRwrPauLkA
   g8PwT5D6Hbo3mybGD0VjJB8RSIt+/JqGRGl6HgSbvuAxMYMx49/FEqL4l
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="226607998"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="226607998"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:29:21 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="519730715"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:29:21 -0800
Subject: [PATCH v3 08/40] cxl/core/port: Rename bus.c to port.c
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 23 Jan 2022 16:29:21 -0800
Message-ID: <164298416136.3018233.15442880970000855425.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Given it is dominated by port infrastructure, and will only acquire
more, rename bus.c to port.c.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/driver-api/cxl/memory-devices.rst |    4 ++--
 drivers/cxl/core/Makefile                       |    2 +-
 drivers/cxl/core/port.c                         |    0 
 tools/testing/cxl/Kbuild                        |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)
 rename drivers/cxl/core/{bus.c => port.c} (100%)

diff --git a/Documentation/driver-api/cxl/memory-devices.rst b/Documentation/driver-api/cxl/memory-devices.rst
index 3b8f41395f6b..c8f7a16cd0e3 100644
--- a/Documentation/driver-api/cxl/memory-devices.rst
+++ b/Documentation/driver-api/cxl/memory-devices.rst
@@ -36,10 +36,10 @@ CXL Core
 .. kernel-doc:: drivers/cxl/cxl.h
    :internal:
 
-.. kernel-doc:: drivers/cxl/core/bus.c
+.. kernel-doc:: drivers/cxl/core/port.c
    :doc: cxl core
 
-.. kernel-doc:: drivers/cxl/core/bus.c
+.. kernel-doc:: drivers/cxl/core/port.c
    :identifiers:
 
 .. kernel-doc:: drivers/cxl/core/pmem.c
diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index 40ab50318daf..a90202ac88d2 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -2,7 +2,7 @@
 obj-$(CONFIG_CXL_BUS) += cxl_core.o
 
 ccflags-y += -I$(srctree)/drivers/cxl
-cxl_core-y := bus.o
+cxl_core-y := port.o
 cxl_core-y += pmem.o
 cxl_core-y += regs.o
 cxl_core-y += memdev.o
diff --git a/drivers/cxl/core/bus.c b/drivers/cxl/core/port.c
similarity index 100%
rename from drivers/cxl/core/bus.c
rename to drivers/cxl/core/port.c
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index 1acdf2fc31c5..3299fb0977b2 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -25,7 +25,7 @@ cxl_pmem-y += config_check.o
 
 obj-m += cxl_core.o
 
-cxl_core-y := $(CXL_CORE_SRC)/bus.o
+cxl_core-y := $(CXL_CORE_SRC)/port.o
 cxl_core-y += $(CXL_CORE_SRC)/pmem.o
 cxl_core-y += $(CXL_CORE_SRC)/regs.o
 cxl_core-y += $(CXL_CORE_SRC)/memdev.o

