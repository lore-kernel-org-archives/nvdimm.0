Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 0C34F1A1DFF
 for <linux-nvdimm@lists.01.org>; Wed,  3 Aug 2016 16:25:49 -0700 (PDT)
Subject: [ndctl PATCH 3/4] test: skip pmem/blk-ns tests on KVM
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 03 Aug 2016 16:23:21 -0700
Message-ID: <147026660186.11162.5796906746157807312.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147026658649.11162.4510254495491443980.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147026658649.11162.4510254495491443980.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

KVM produces label-less pmem regions causing these tests to fail.  Skip
these tests when the NFIT does not describe aliased BLK + PMEM.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/blk_namespaces.c  |   17 +++++++++++++++++
 test/pmem_namespaces.c |   18 ++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/test/blk_namespaces.c b/test/blk_namespaces.c
index 0ef5b65fd511..2e25c19b2f59 100644
--- a/test/blk_namespaces.c
+++ b/test/blk_namespaces.c
@@ -28,6 +28,13 @@
 #include <linux/version.h>
 #include <test.h>
 #include <libkmod.h>
+#include <ccan/array_size/array_size.h>
+
+#ifdef HAVE_NDCTL_H
+#include <linux/ndctl.h>
+#else
+#include <ndctl.h>
+#endif
 
 /* The purpose of this test is to verify that we can successfully do I/O to
  * multiple nd_blk namespaces that have discontiguous segments.  It first
@@ -229,6 +236,16 @@ int test_blk_namespaces(int log_level, struct ndctl_test *test)
 	ndctl_set_log_priority(ctx, log_level);
 
 	bus = ndctl_bus_get_by_provider(ctx, "ACPI.NFIT");
+	if (bus) {
+		/* skip this bus if no BLK regions */
+		ndctl_region_foreach(bus, region)
+			if (ndctl_region_get_nstype(region)
+					== ND_DEVICE_NAMESPACE_BLK)
+				break;
+		if (!region)
+			bus = NULL;
+	}
+
 	if (!bus) {
 		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
 		kmod_ctx = kmod_new(NULL, NULL);
diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
index 387c5e011f66..8edfaba2d7f3 100644
--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -29,6 +29,14 @@
 #include <linux/version.h>
 #include <test.h>
 
+#include <ccan/array_size/array_size.h>
+
+#ifdef HAVE_NDCTL_H
+#include <linux/ndctl.h>
+#else
+#include <ndctl.h>
+#endif
+
 #define err(msg)\
 	fprintf(stderr, "%s:%d: %s (%s)\n", __func__, __LINE__, msg, strerror(errno))
 
@@ -192,6 +200,16 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test)
 	ndctl_set_log_priority(ctx, log_level);
 
 	bus = ndctl_bus_get_by_provider(ctx, "ACPI.NFIT");
+	if (bus) {
+		/* skip this bus if no label-enabled PMEM regions */
+		ndctl_region_foreach(bus, region)
+			if (ndctl_region_get_nstype(region)
+					== ND_DEVICE_NAMESPACE_PMEM)
+				break;
+		if (!region)
+			bus = NULL;
+	}
+
 	if (!bus) {
 		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
 		kmod_ctx = kmod_new(NULL, NULL);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
