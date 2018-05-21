Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7267A20348610
 for <linux-nvdimm@lists.01.org>; Mon, 21 May 2018 09:32:11 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [qemu PATCH v4 4/4] ACPI testing: test NFIT platform capabilities
Date: Mon, 21 May 2018 10:32:03 -0600
Message-Id: <20180521163203.26590-5-ross.zwisler@linux.intel.com>
In-Reply-To: <20180521163203.26590-1-ross.zwisler@linux.intel.com>
References: <20180521163203.26590-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Igor Mammedov <imammedo@redhat.com>, qemu-devel@nongnu.org
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Add testing for the newly added NFIT Platform Capabilities Structure.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Igor Mammedov <imammedo@redhat.com>
---
 tests/acpi-test-data/pc/NFIT.dimmpxm  | Bin 224 -> 240 bytes
 tests/acpi-test-data/q35/NFIT.dimmpxm | Bin 224 -> 240 bytes
 tests/bios-tables-test.c              |   2 +-
 3 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/acpi-test-data/pc/NFIT.dimmpxm b/tests/acpi-test-data/pc/NFIT.dimmpxm
index 2bfc6c51f31c25a052803c494c933d4948fc0106..598d331b751cd3cb2137d431c1f34bb8957a0d31 100644
GIT binary patch
delta 35
lcmaFB_<@nj&&@OB0|NsCqsm0CYXa;H0t}2m9y1Vw005dH1-}3Q

delta 18
Zcmeys_<)hi&&@OB0RsaAqyI#%YXCU~1+M@A

diff --git a/tests/acpi-test-data/q35/NFIT.dimmpxm b/tests/acpi-test-data/q35/NFIT.dimmpxm
index 2bfc6c51f31c25a052803c494c933d4948fc0106..598d331b751cd3cb2137d431c1f34bb8957a0d31 100644
GIT binary patch
delta 35
lcmaFB_<@nj&&@OB0|NsCqsm0CYXa;H0t}2m9y1Vw005dH1-}3Q

delta 18
Zcmeys_<)hi&&@OB0RsaAqyI#%YXCU~1+M@A

diff --git a/tests/bios-tables-test.c b/tests/bios-tables-test.c
index bf3e193ae9..256d463cb8 100644
--- a/tests/bios-tables-test.c
+++ b/tests/bios-tables-test.c
@@ -830,7 +830,7 @@ static void test_acpi_tcg_dimm_pxm(const char *machine)
     memset(&data, 0, sizeof(data));
     data.machine = machine;
     data.variant = ".dimmpxm";
-    test_acpi_one(" -machine nvdimm=on"
+    test_acpi_one(" -machine nvdimm=on,nvdimm-cap=3"
                   " -smp 4,sockets=4"
                   " -m 128M,slots=3,maxmem=1G"
                   " -numa node,mem=32M,nodeid=0"
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
