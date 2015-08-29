Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] nfit: Fix undefined mmio_flush_range on x86_32
Date: Fri, 28 Aug 2015 19:18:44 -0600
Message-Id: <1440811124-1634-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dan.j.williams@intel.com
Cc: ross.zwisler@linux.intel.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

The following compile error was observed on x86_32 since nfit.c
relies on <asm/pmem.h> to include <asm/cacheflush.h>, which only
works when CONFIG_ARCH_HAS_PMEM_API is set on x86_64.

  drivers/acpi/nfit.c:1085:5: error: implicit declaration of
  function 'mmio_flush_range' [-Werror=implicit-function-declaration]

Change nfit.c to include <asm/cacheflush.h> directly for now.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
---
Apply on top of libnvdimm-for-next of the nvdimm tree.
This is a temporary fix and please feel free to replace it with
a better solution.
---
 drivers/acpi/nfit.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 82d07e8..f61e69f 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -20,6 +20,7 @@
 #include <linux/sort.h>
 #include <linux/pmem.h>
 #include <linux/io.h>
+#include <asm/cacheflush.h>
 #include "nfit.h"
 
 /*
