Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B2B2C80
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 21:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641418356; x=1672954356;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yzq8zcue0vHSD6aiYYZ2CTEkWbHldxvMWQ0RcCMCF+I=;
  b=A6JWlr9akalNILCxZE/YjAyQ5L8vv6RUzGu07xe02NFZSlNEb5lQKfir
   w0+I4ve6tu7PHi0gALoD9a9g2M0VdIvqeea29FaiPh9DLGO/onounS1UH
   GNzzw+Q6klVnEnn/NCZXPu56VItn0yzqFi+4/eocN/mxOGCh9YGh+lKlg
   Q7m5ws0qk5g2gWo06EGzfJF5v3sIlvBhYW9kfxqqUOVWAwj7f+Dw1nCi+
   gtqLW8YX8zZtMnRa2mYYlvH8L0WBiCdgq2d4TZx2R6RulNW9j4SV4iSci
   ZLeT+RsXBSAYFUcBjGW66CXcuf4QsBRjg96TUlvi687wsuEdDRiJzyXnJ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242495991"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="242495991"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:16 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="763309968"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:16 -0800
Subject: [ndctl PATCH v3 07/16] ndctl: Deprecate BLK aperture support
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Wed, 05 Jan 2022 13:32:15 -0800
Message-ID: <164141833579.3990253.17885822648406789915.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The kernel is dropping its BLK aperture support, so deprecate the same in
ndctl. The options will still be supported, and the library calls will not
be deleted in case code needs them to compile. However the documentation
and the tests for BLK mode can be removed.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 .gitignore                                     |    4 
 Documentation/ndctl/labels-description.txt     |    5 
 Documentation/ndctl/ndctl-create-namespace.txt |   29 +-
 Documentation/ndctl/ndctl-init-labels.txt      |    7 
 Documentation/ndctl/ndctl-list.txt             |    4 
 Documentation/ndctl/region-description.txt     |   10 -
 README.md                                      |    1 
 contrib/nfit_test_depmod.conf                  |    1 
 ndctl/Makefile.am                              |    6 
 ndctl/bat.c                                    |    5 
 ndctl/test.c                                   |   11 -
 test.h                                         |    3 
 test/Makefile.am                               |   31 --
 test/blk-exhaust.sh                            |   30 --
 test/blk_namespaces.c                          |  357 ------------------------
 test/core.c                                    |    1 
 test/create.sh                                 |   13 -
 test/dpa-alloc.c                               |  326 ----------------------
 test/libndctl.c                                |  198 ++-----------
 test/multi-pmem.c                              |  285 -------------------
 test/parent-uuid.c                             |  254 -----------------
 21 files changed, 51 insertions(+), 1530 deletions(-)
 delete mode 100755 test/blk-exhaust.sh
 delete mode 100644 test/blk_namespaces.c
 delete mode 100644 test/dpa-alloc.c
 delete mode 100644 test/multi-pmem.c
 delete mode 100644 test/parent-uuid.c

diff --git a/.gitignore b/.gitignore
index 6468c7a91f06..6b19d90a12f1 100644
--- a/.gitignore
+++ b/.gitignore
@@ -42,20 +42,16 @@ cscope*.out
 tags
 test/*.log
 test/*.trs
-test/blk-ns
 test/dax-dev
 test/dax-errors
 test/dax-pmd
 test/daxdev-errors
 test/device-dax
-test/dpa-alloc
 test/dsm-fail
 test/hugetlb
 test/image
 test/libndctl
 test/mmap
-test/multi-pmem
-test/parent-uuid
 test/pmem-ns
 test/smart-listen
 test/smart-notify
diff --git a/Documentation/ndctl/labels-description.txt b/Documentation/ndctl/labels-description.txt
index 6244a49a9d3f..a246edcd369b 100644
--- a/Documentation/ndctl/labels-description.txt
+++ b/Documentation/ndctl/labels-description.txt
@@ -3,6 +3,5 @@
 DESCRIPTION
 -----------
 The namespace label area is a small persistent partition of capacity
-available on some NVDIMM devices.  The label area is used to resolve
-aliasing between 'pmem' and 'blk' capacity by delineating namespace
-boundaries.
+available on some NVDIMM devices.  The label area is used to provision
+one, or more, namespaces from regions.
diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
index 92a89dd71e82..afb085efc6e7 100644
--- a/Documentation/ndctl/ndctl-create-namespace.txt
+++ b/Documentation/ndctl/ndctl-create-namespace.txt
@@ -28,27 +28,17 @@ ndctl create-namespace -f -e namespace0.0 --mode=sector
 
 OPTIONS
 -------
--t::
---type=::
-	Create a 'pmem' or 'blk' namespace (subject to available
-	capacity).  A pmem namespace supports the dax (direct access)
-	capability to linkndctl:mmap[2] persistent memory directly into
-	a process address space.  A blk namespace access persistent
-	memory through a block-window-aperture.  Compared to pmem it
-	supports a traditional storage error model (EIO on error rather
-	than a cpu exception on a bad memory access), but it does not
-	support dax.
-
 -m::
 --mode=::
 	- "raw": expose the namespace capacity directly with
-	  limitations.  Neither a raw pmem namepace nor raw blk
-	  namespace support sector atomicity by default (see "sector"
-	  mode below).  A raw pmem namespace may have limited to no dax
-	  support depending the kernel. In other words operations like
-	  direct-I/O targeting a dax buffer may fail for a pmem
-	  namespace in raw mode or indirect through a page-cache buffer.
-	  See "fsdax" and "devdax" mode for dax operation.
+	  limitations. A raw pmem namepace namespace does not support
+	  sector atomicity (see "sector" mode below). A raw pmem
+	  namespace may have limited to no dax support depending the
+	  kernel. In other words operations like direct-I/O targeting a
+	  dax buffer may fail for a pmem namespace in raw mode or
+	  indirect through a page-cache buffer.  See "fsdax" and
+	  "devdax" mode for dax operation.
+
 
 	- "sector": persistent memory, given that it is byte
 	  addressable, does not support sector atomicity.  The
@@ -206,8 +196,7 @@ OPTIONS
 	  * NVDIMM does not support labels
 
 	  * The NVDIMM supports labels, but the Label Index Block (see
-	    UEFI 2.7) is not present and there is no capacity aliasing
-	    between 'blk' and 'pmem' regions.
+	    UEFI 2.7) is not present.
 
 	- In the latter case the configuration can be upgraded to
 	  labelled operation by writing an index block on all DIMMs in a
diff --git a/Documentation/ndctl/ndctl-init-labels.txt b/Documentation/ndctl/ndctl-init-labels.txt
index 733ef0ebddfa..73685b3336b3 100644
--- a/Documentation/ndctl/ndctl-init-labels.txt
+++ b/Documentation/ndctl/ndctl-init-labels.txt
@@ -13,10 +13,9 @@ SYNOPSIS
 'ndctl init-labels' <nmem0> [<nmem1>..<nmemN>] [<options>]
 
 include::labels-description.txt[]
-By default, and in kernels prior to v4.10, the kernel only honors labels
-when a DIMM aliases PMEM and BLK capacity. Starting with v4.10 the
-kernel will honor labels for sub-dividing PMEM if all the DIMMs in an
-interleave set / region have a valid namespace index block.
+Starting with v4.10 the kernel will honor labels for sub-dividing PMEM
+if all the DIMMs in an interleave set / region have a valid namespace
+index block.
 
 This command can be used to initialize the namespace index block if it
 is missing or reinitialize it if it is damaged.  Note that
diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
index b8d517d784b4..2922f10e06c7 100644
--- a/Documentation/ndctl/ndctl-list.txt
+++ b/Documentation/ndctl/ndctl-list.txt
@@ -82,10 +82,6 @@ include::xable-bus-options.txt[]
 	'X.Y'. Limit the namespace list to the single identified device
 	if present.
 
--t::
---type=::
-	Filter listing by region type ('pmem' or 'blk')
-
 -m::
 --mode=::
 	Filter listing by the mode ('raw', 'fsdax', 'sector' or 'devdax')
diff --git a/Documentation/ndctl/region-description.txt b/Documentation/ndctl/region-description.txt
index c14416a3be69..ce268a015b83 100644
--- a/Documentation/ndctl/region-description.txt
+++ b/Documentation/ndctl/region-description.txt
@@ -2,9 +2,7 @@
 
 DESCRIPTION
 -----------
-A generic REGION device is registered for each PMEM range or
-BLK-aperture set.  LIBNVDIMM provides a built-in driver for these REGION
-devices.  This driver is responsible for reconciling the aliased DPA
-mappings across all regions, parsing the LABEL, if present, and then
-emitting NAMESPACE devices with the resolved/exclusive DPA-boundaries
-for the nd_pmem or nd_blk device driver to consume.
+A generic REGION device is registered for each PMEM range /
+interleave-set. LIBNVDIMM provides a built-in driver for these REGION
+devices. This driver is responsible for parsing namespace labels and
+instantiating PMEM namespaces for each coherent set of labels.
diff --git a/README.md b/README.md
index 89dfc8798603..6f36a6d9410c 100644
--- a/README.md
+++ b/README.md
@@ -110,7 +110,6 @@ override dax_pmem * extra
 override dax_pmem_core * extra
 override dax_pmem_compat * extra
 override libnvdimm * extra
-override nd_blk * extra
 override nd_btt * extra
 override nd_e820 * extra
 override nd_pmem * extra
diff --git a/contrib/nfit_test_depmod.conf b/contrib/nfit_test_depmod.conf
index 9f8498e58ff3..0e0574e03670 100644
--- a/contrib/nfit_test_depmod.conf
+++ b/contrib/nfit_test_depmod.conf
@@ -5,7 +5,6 @@ override dax_pmem * extra
 override dax_pmem_core * extra
 override dax_pmem_compat * extra
 override libnvdimm * extra
-override nd_blk * extra
 override nd_btt * extra
 override nd_e820 * extra
 override nd_pmem * extra
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 4e995108e96a..93b682e8b202 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -45,8 +45,7 @@ endif
 EXTRA_DIST += keys.readme monitor.conf ndctl-monitor.service ndctl.conf
 
 if ENABLE_DESTRUCTIVE
-ndctl_SOURCES += ../test/blk_namespaces.c \
-		 ../test/pmem_namespaces.c
+ndctl_SOURCES += ../test/pmem_namespaces.c
 ndctl_SOURCES += bat.c
 endif
 
@@ -67,9 +66,6 @@ if ENABLE_TEST
 ndctl_SOURCES += ../test/libndctl.c \
 		 ../test/dsm-fail.c \
 		 ../util/sysfs.c \
-		 ../test/dpa-alloc.c \
-		 ../test/parent-uuid.c \
-		 ../test/multi-pmem.c \
 		 ../test/core.c \
 		 test.c
 endif
diff --git a/ndctl/bat.c b/ndctl/bat.c
index ef00a3ba3d0b..13e964dc17cf 100644
--- a/ndctl/bat.c
+++ b/ndctl/bat.c
@@ -41,11 +41,6 @@ int cmd_bat(int argc, const char **argv, struct ndctl_ctx *ctx)
 		return EXIT_FAILURE;
 	}
 
-	rc = test_blk_namespaces(loglevel, test, ctx);
-	fprintf(stderr, "test_blk_namespaces: %s\n", rc ? "FAIL" : "PASS");
-	if (rc && rc != 77)
-		return rc;
-
 	rc = test_pmem_namespaces(loglevel, test, ctx);
 	fprintf(stderr, "test_pmem_namespaces: %s\n", rc ? "FAIL" : "PASS");
 	return ndctl_test_result(test, rc);
diff --git a/ndctl/test.c b/ndctl/test.c
index 6a05d8d62e46..a0f5bc95ae1d 100644
--- a/ndctl/test.c
+++ b/ndctl/test.c
@@ -58,16 +58,5 @@ int cmd_test(int argc, const char **argv, struct ndctl_ctx *ctx)
 	if (rc && rc != 77)
 		return rc;
 
-	rc = test_dpa_alloc(loglevel, test, ctx);
-	fprintf(stderr, "test-dpa-alloc: %s\n", result(rc));
-	if (rc && rc != 77)
-		return rc;
-
-	rc = test_parent_uuid(loglevel, test, ctx);
-	fprintf(stderr, "test-parent-uuid: %s\n", result(rc));
-
-	rc = test_multi_pmem(loglevel, test, ctx);
-	fprintf(stderr, "test-multi-pmem: %s\n", result(rc));
-
 	return ndctl_test_result(test, rc);
 }
diff --git a/test.h b/test.h
index 7de13fe33ea3..b2267e669911 100644
--- a/test.h
+++ b/test.h
@@ -26,7 +26,6 @@ int ndctl_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
 
 struct ndctl_ctx;
 int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
-int test_multi_pmem(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t offset);
 int test_dax_remap(struct ndctl_test *test, int dax_fd, unsigned long align, void *dax_addr,
 		off_t offset, bool fsdax);
@@ -40,9 +39,7 @@ static inline int test_dax_poison(struct ndctl_test *test, int dax_fd,
 	return 0;
 }
 #endif
-int test_dpa_alloc(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_dsm_fail(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_libndctl(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
-int test_blk_namespaces(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_pmem_namespaces(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 #endif /* __TEST_H__ */
diff --git a/test/Makefile.am b/test/Makefile.am
index c5b8764389ea..a5a54df4f260 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -3,9 +3,6 @@ include $(top_srcdir)/Makefile.am.in
 TESTS =\
 	libndctl \
 	dsm-fail \
-	dpa-alloc \
-	parent-uuid \
-	multi-pmem \
 	create.sh \
 	clear.sh \
 	pmem-errors.sh \
@@ -13,7 +10,6 @@ TESTS =\
 	multi-dax.sh \
 	btt-check.sh \
 	label-compat.sh \
-	blk-exhaust.sh \
 	sector-mode.sh \
 	inject-error.sh \
 	btt-errors.sh \
@@ -35,9 +31,6 @@ EXTRA_DIST += $(TESTS) common \
 check_PROGRAMS =\
 	libndctl \
 	dsm-fail \
-	dpa-alloc \
-	parent-uuid \
-	multi-pmem \
 	dax-errors \
 	smart-notify \
 	smart-listen \
@@ -48,7 +41,6 @@ check_PROGRAMS =\
 
 if ENABLE_DESTRUCTIVE
 TESTS +=\
-	blk-ns \
 	pmem-ns \
 	sub-section.sh \
 	dax-dev \
@@ -68,7 +60,6 @@ TESTS += security.sh
 endif
 
 check_PROGRAMS +=\
-	blk-ns \
 	pmem-ns \
 	dax-dev \
 	dax-pmd \
@@ -108,18 +99,9 @@ ack_shutdown_count_set_SOURCES =\
 
 ack_shutdown_count_set_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
 
-blk_ns_SOURCES = blk_namespaces.c $(testcore)
-blk_ns_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS) $(UUID_LIBS)
-
 pmem_ns_SOURCES = pmem_namespaces.c $(testcore)
 pmem_ns_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS) $(UUID_LIBS)
 
-dpa_alloc_SOURCES = dpa-alloc.c $(testcore)
-dpa_alloc_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
-
-parent_uuid_SOURCES = parent-uuid.c $(testcore)
-parent_uuid_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
-
 dax_dev_SOURCES = dax-dev.c $(testcore)
 dax_dev_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
 
@@ -169,19 +151,6 @@ smart_notify_LDADD = $(LIBNDCTL_LIB)
 smart_listen_SOURCES = smart-listen.c
 smart_listen_LDADD = $(LIBNDCTL_LIB)
 
-multi_pmem_SOURCES = \
-		multi-pmem.c \
-		$(testcore) \
-		../ndctl/namespace.c \
-		../ndctl/check.c \
-		../util/json.c
-multi_pmem_LDADD = \
-		$(LIBNDCTL_LIB) \
-		$(JSON_LIBS) \
-		$(UUID_LIBS) \
-		$(KMOD_LIBS) \
-		../libutil.a
-
 list_smart_dimm_SOURCES = \
 		list-smart-dimm.c \
 		../util/json.c
diff --git a/test/blk-exhaust.sh b/test/blk-exhaust.sh
deleted file mode 100755
index b6d3808969f1..000000000000
--- a/test/blk-exhaust.sh
+++ /dev/null
@@ -1,30 +0,0 @@
-#!/bin/bash -x
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (C) 2015-2020 Intel Corporation. All rights reserved.
-
-set -e
-
-rc=77
-
-. $(dirname $0)/common
-
-check_min_kver "4.11" || do_skip "may lack blk-exhaustion fix"
-
-trap 'err $LINENO' ERR
-
-# setup (reset nfit_test dimms)
-modprobe nfit_test
-reset
-
-# if the kernel accounting is correct we should be able to create two
-# pmem and two blk namespaces on nfit_test.0
-rc=1
-$NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem
-$NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem
-$NDCTL create-namespace -b $NFIT_TEST_BUS0 -t blk -m raw
-$NDCTL create-namespace -b $NFIT_TEST_BUS0 -t blk -m raw
-
-# clearnup and exit
-_cleanup
-
-exit 0
diff --git a/test/blk_namespaces.c b/test/blk_namespaces.c
deleted file mode 100644
index f076e853ddda..000000000000
--- a/test/blk_namespaces.c
+++ /dev/null
@@ -1,357 +0,0 @@
-// SPDX-License-Identifier: LGPL-2.1
-// Copyright (C) 2015-2020, Intel Corporation. All rights reserved.
-#include <errno.h>
-#include <fcntl.h>
-#include <linux/fs.h>
-#include <ndctl/libndctl.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <sys/ioctl.h>
-#include <syslog.h>
-#include <sys/stat.h>
-#include <sys/types.h>
-#include <ndctl.h>
-#include <unistd.h>
-#include <uuid/uuid.h>
-#include <linux/version.h>
-#include <test.h>
-#include <libkmod.h>
-#include <ccan/array_size/array_size.h>
-
-/* The purpose of this test is to verify that we can successfully do I/O to
- * multiple nd_blk namespaces that have discontiguous segments.  It first
- * sets up two namespaces, each 1/2 the total size of the NVDIMM and each with
- * two discontiguous segments, arranged like this:
- *
- * +-------+-------+-------+-------+
- * |  nd0  |  nd1  |  nd0  |  nd1  |
- * +-------+-------+-------+-------+
- *
- * It then runs some I/O to the beginning, middle and end of each of these
- * namespaces, checking data integrity.  The I/O to the middle of the
- * namespace will hit two pages, one on either side of the segment boundary.
- */
-#define err(msg)\
-	fprintf(stderr, "%s:%d: %s (%s)\n", __func__, __LINE__, msg, strerror(errno))
-
-static struct ndctl_namespace *create_blk_namespace(int region_fraction,
-		struct ndctl_region *region)
-{
-	struct ndctl_namespace *ndns, *seed_ns = NULL;
-	unsigned long long size;
-	uuid_t uuid;
-
-	ndctl_region_set_align(region, sysconf(_SC_PAGESIZE));
-	ndctl_namespace_foreach(region, ndns)
-		if (ndctl_namespace_get_size(ndns) == 0) {
-			seed_ns = ndns;
-			break;
-		}
-
-	if (!seed_ns)
-		return NULL;
-
-	uuid_generate(uuid);
-	size = ndctl_region_get_size(region)/region_fraction;
-
-	if (ndctl_namespace_set_uuid(seed_ns, uuid) < 0)
-		return NULL;
-
-	if (ndctl_namespace_set_size(seed_ns, size) < 0)
-		return NULL;
-
-	if (ndctl_namespace_set_sector_size(seed_ns, 512) < 0)
-		return NULL;
-
-	if (ndctl_namespace_enable(seed_ns) < 0)
-		return NULL;
-
-	return seed_ns;
-}
-
-static int disable_blk_namespace(struct ndctl_namespace *ndns)
-{
-	if (ndctl_namespace_disable_invalidate(ndns) < 0)
-		return -ENODEV;
-
-	if (ndctl_namespace_delete(ndns) < 0)
-		return -ENODEV;
-
-	return 0;
-}
-
-static int ns_do_io(const char *bdev)
-{
-	int fd, i;
-	int rc = 0;
-	const int page_size = 4096;
-	const int num_pages = 4;
-	unsigned long num_dev_pages, num_blocks;
-	off_t addr;
-
-	void *random_page[num_pages];
-	void *blk_page[num_pages];
-
-	rc = posix_memalign(random_page, page_size, page_size * num_pages);
-	if (rc) {
-		fprintf(stderr, "posix_memalign failure\n");
-		return rc;
-	}
-
-	rc = posix_memalign(blk_page, page_size, page_size * num_pages);
-	if (rc) {
-		fprintf(stderr, "posix_memalign failure\n");
-		goto err_free_blk;
-	}
-
-	for (i = 1; i < num_pages; i++) {
-		random_page[i] = (char*)random_page[0] + page_size * i;
-		blk_page[i] = (char*)blk_page[0] + page_size * i;
-	}
-
-	/* read random data into random_page */
-	if ((fd = open("/dev/urandom", O_RDONLY)) < 0) {
-		err("open");
-		rc = -ENODEV;
-		goto err_free_all;
-	}
-
-	rc = read(fd, random_page[0], page_size * num_pages);
-	if (rc < 0) {
-		err("read");
-		close(fd);
-		goto err_free_all;
-	}
-
-	close(fd);
-
-	if ((fd = open(bdev, O_RDWR|O_DIRECT)) < 0) {
-		err("open");
-		rc = -ENODEV;
-		goto err_free_all;
-	}
-
-	ioctl(fd, BLKGETSIZE, &num_blocks);
-	num_dev_pages = num_blocks / 8;
-
-	/* write the random data out to each of the segments */
-	rc = pwrite(fd, random_page[0], page_size, 0);
-	if (rc < 0) {
-		err("write");
-		goto err_close;
-	}
-
-	/* two pages that span the region discontinuity */
-	addr = page_size * (num_dev_pages/2 - 1);
-	rc = pwrite(fd, random_page[1], page_size*2, addr);
-	if (rc < 0) {
-		err("write");
-		goto err_close;
-	}
-
-	addr = page_size * (num_dev_pages - 1);
-	rc = pwrite(fd, random_page[3], page_size, addr);
-	if (rc < 0) {
-		err("write");
-		goto err_close;
-	}
-
-	/* read back the random data into blk_page */
-	rc = pread(fd, blk_page[0], page_size, 0);
-	if (rc < 0) {
-		err("read");
-		goto err_close;
-	}
-
-	/* two pages that span the region discontinuity */
-	addr = page_size * (num_dev_pages/2 - 1);
-	rc = pread(fd, blk_page[1], page_size*2, addr);
-	if (rc < 0) {
-		err("read");
-		goto err_close;
-	}
-
-	addr = page_size * (num_dev_pages - 1);
-	rc = pread(fd, blk_page[3], page_size, addr);
-	if (rc < 0) {
-		err("read");
-		goto err_close;
-	}
-
-	/* verify the data */
-	if (memcmp(random_page[0], blk_page[0], page_size * num_pages)) {
-		fprintf(stderr, "Block data miscompare\n");
-		rc = -EIO;
-		goto err_close;
-	}
-
-	rc = 0;
- err_close:
-	close(fd);
- err_free_all:
-	free(random_page[0]);
- err_free_blk:
-	free(blk_page[0]);
-	return rc;
-}
-
-static const char *comm = "test-blk-namespaces";
-
-int test_blk_namespaces(int log_level, struct ndctl_test *test,
-		struct ndctl_ctx *ctx)
-{
-	char bdev[50];
-	int rc = -ENXIO;
-	struct ndctl_bus *bus;
-	struct ndctl_dimm *dimm;
-	struct kmod_module *mod = NULL;
-	struct kmod_ctx *kmod_ctx = NULL;
-	struct ndctl_namespace *ndns[2];
-	struct ndctl_region *region, *blk_region = NULL;
-
-	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
-		return 77;
-
-	ndctl_set_log_priority(ctx, log_level);
-
-	bus = ndctl_bus_get_by_provider(ctx, "ACPI.NFIT");
-	if (bus) {
-		/* skip this bus if no BLK regions */
-		ndctl_region_foreach(bus, region)
-			if (ndctl_region_get_nstype(region)
-					== ND_DEVICE_NAMESPACE_BLK)
-				break;
-		if (!region)
-			bus = NULL;
-	}
-
-	if (!bus) {
-		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
-		rc = ndctl_test_init(&kmod_ctx, &mod, NULL, log_level, test);
-		ndctl_invalidate(ctx);
-		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
-		if (rc < 0 || !bus) {
-			ndctl_test_skip(test);
-			fprintf(stderr, "nfit_test unavailable skipping tests\n");
-			return 77;
-		}
-	}
-
-	fprintf(stderr, "%s: found provider: %s\n", comm,
-			ndctl_bus_get_provider(bus));
-
-	/* get the system to a clean state */
-        ndctl_region_foreach(bus, region)
-                ndctl_region_disable_invalidate(region);
-
-        ndctl_dimm_foreach(bus, dimm) {
-                rc = ndctl_dimm_zero_labels(dimm);
-                if (rc < 0) {
-                        fprintf(stderr, "failed to zero %s\n",
-                                        ndctl_dimm_get_devname(dimm));
-			goto err_module;
-                }
-        }
-
-	/* create our config */
-	ndctl_region_foreach(bus, region)
-		if (strcmp(ndctl_region_get_type_name(region), "blk") == 0) {
-			blk_region = region;
-			break;
-		}
-
-	if (!blk_region || ndctl_region_enable(blk_region) < 0) {
-		fprintf(stderr, "%s: failed to find block region\n", comm);
-		rc = -ENODEV;
-		goto err_cleanup;
-	}
-
-	rc = -ENODEV;
-	ndns[0] = create_blk_namespace(4, blk_region);
-	if (!ndns[0]) {
-		fprintf(stderr, "%s: failed to create block namespace\n", comm);
-		goto err_cleanup;
-	}
-
-	ndns[1] = create_blk_namespace(4, blk_region);
-	if (!ndns[1]) {
-		fprintf(stderr, "%s: failed to create block namespace\n", comm);
-		goto err_cleanup;
-	}
-
-	rc = disable_blk_namespace(ndns[0]);
-	if (rc < 0) {
-		fprintf(stderr, "%s: failed to disable block namespace\n", comm);
-		goto err_cleanup;
-	}
-
-	ndns[0] = create_blk_namespace(2, blk_region);
-	if (!ndns[0]) {
-		fprintf(stderr, "%s: failed to create block namespace\n", comm);
-		rc = -ENODEV;
-		goto err_cleanup;
-	}
-
-	rc = disable_blk_namespace(ndns[1]);
-	if (rc < 0) {
-		fprintf(stderr, "%s: failed to disable block namespace\n", comm);
-		goto err_cleanup;
-	}
-
-	rc = -ENODEV;
-	ndns[1] = create_blk_namespace(2, blk_region);
-	if (!ndns[1]) {
-		fprintf(stderr, "%s: failed to create block namespace\n", comm);
-		goto err_cleanup;
-	}
-
-	/* okay, all set up, do some I/O */
-	rc = -EIO;
-	sprintf(bdev, "/dev/%s", ndctl_namespace_get_block_device(ndns[0]));
-	if (ns_do_io(bdev))
-		goto err_cleanup;
-	sprintf(bdev, "/dev/%s", ndctl_namespace_get_block_device(ndns[1]));
-	if (ns_do_io(bdev))
-		goto err_cleanup;
-	rc = 0;
-
- err_cleanup:
-	/* unload nfit_test */
-	bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
-	if (bus)
-		ndctl_region_foreach(bus, region)
-			ndctl_region_disable_invalidate(region);
-	bus = ndctl_bus_get_by_provider(ctx, "nfit_test.1");
-	if (bus)
-		ndctl_region_foreach(bus, region)
-			ndctl_region_disable_invalidate(region);
-	if (mod)
-		kmod_module_remove_module(mod, 0);
-
- err_module:
-	if (kmod_ctx)
-		kmod_unref(kmod_ctx);
-	return rc;
-}
-
-int __attribute__((weak)) main(int argc, char *argv[])
-{
-	struct ndctl_test *test = ndctl_test_new(0);
-	struct ndctl_ctx *ctx;
-	int rc;
-
-	comm = argv[0];
-	if (!test) {
-		fprintf(stderr, "failed to initialize test\n");
-		return EXIT_FAILURE;
-	}
-
-	rc = ndctl_new(&ctx);
-	if (rc)
-		return ndctl_test_result(test, rc);
-
-	rc = test_blk_namespaces(LOG_DEBUG, test, ctx);
-	ndctl_unref(ctx);
-	return ndctl_test_result(test, rc);
-}
diff --git a/test/core.c b/test/core.c
index 93e1dae5a144..dc1405d75c49 100644
--- a/test/core.c
+++ b/test/core.c
@@ -123,7 +123,6 @@ int ndctl_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
 		"dax_pmem_core",
 		"dax_pmem_compat",
 		"libnvdimm",
-		"nd_blk",
 		"nd_btt",
 		"nd_e820",
 		"nd_pmem",
diff --git a/test/create.sh b/test/create.sh
index e9baaa075a28..9a6f3733939e 100755
--- a/test/create.sh
+++ b/test/create.sh
@@ -40,19 +40,6 @@ eval $(echo $json | json2var)
 # free capacity for blk creation
 $NDCTL destroy-namespace -f $dev
 
-# create blk
-dev="x"
-json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -t blk -m raw -v)
-eval $(echo $json | json2var)
-[ $dev = "x" ] && echo "fail: $LINENO" && exit 1
-[ $mode != "raw" ] && echo "fail: $LINENO" &&  exit 1
-
-# convert blk to sector mode
-json=$($NDCTL create-namespace -m sector -l $SECTOR_SIZE -f -e $dev)
-eval $(echo $json | json2var)
-[ $sector_size != $SECTOR_SIZE ] && echo "fail: $LINENO" &&  exit 1
-[ $mode != "sector" ] && echo "fail: $LINENO" &&  exit 1
-
 _cleanup
 
 exit 0
diff --git a/test/dpa-alloc.c b/test/dpa-alloc.c
deleted file mode 100644
index 59185cf8cf3b..000000000000
--- a/test/dpa-alloc.c
+++ /dev/null
@@ -1,326 +0,0 @@
-// SPDX-License-Identifier: LGPL-2.1
-// Copyright (C) 2014-2020, Intel Corporation. All rights reserved.
-#include <stdio.h>
-#include <stddef.h>
-#include <stdlib.h>
-#include <string.h>
-#include <fcntl.h>
-#include <ctype.h>
-#include <errno.h>
-#include <unistd.h>
-#include <limits.h>
-#include <syslog.h>
-#include <libkmod.h>
-#include <uuid/uuid.h>
-
-#include <test.h>
-#include <ndctl.h>
-#include <util/size.h>
-#include <linux/version.h>
-#include <ndctl/libndctl.h>
-#include <ccan/array_size/array_size.h>
-
-static const char *NFIT_PROVIDER0 = "nfit_test.0";
-static const char *NFIT_PROVIDER1 = "nfit_test.1";
-#define NUM_NAMESPACES 4
-
-struct test_dpa_namespace {
-	struct ndctl_namespace *ndns;
-	unsigned long long size;
-	uuid_t uuid;
-} namespaces[NUM_NAMESPACES];
-
-#define MIN_SIZE SZ_4M
-
-static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
-{
-	unsigned int default_available_slots, available_slots, i;
-	struct ndctl_region *region, *blk_region = NULL;
-	struct ndctl_namespace *ndns;
-	struct ndctl_dimm *dimm;
-	unsigned long size, page_size;
-	struct ndctl_bus *bus;
-	char uuid_str[40];
-	int round;
-	int rc;
-
-	page_size = sysconf(_SC_PAGESIZE);
-	/* disable nfit_test.1, not used in this test */
-	bus = ndctl_bus_get_by_provider(ctx, NFIT_PROVIDER1);
-	if (!bus)
-		return -ENXIO;
-	ndctl_region_foreach(bus, region) {
-		ndctl_region_disable_invalidate(region);
-		ndctl_region_set_align(region, sysconf(_SC_PAGESIZE)
-				* ndctl_region_get_interleave_ways(region));
-	}
-
-	/* init nfit_test.0 */
-	bus = ndctl_bus_get_by_provider(ctx, NFIT_PROVIDER0);
-	if (!bus)
-		return -ENXIO;
-	ndctl_region_foreach(bus, region) {
-		ndctl_region_disable_invalidate(region);
-		ndctl_region_set_align(region, sysconf(_SC_PAGESIZE)
-				* ndctl_region_get_interleave_ways(region));
-	}
-
-	ndctl_dimm_foreach(bus, dimm) {
-		rc = ndctl_dimm_zero_labels(dimm);
-		if (rc < 0) {
-			fprintf(stderr, "failed to zero %s\n",
-					ndctl_dimm_get_devname(dimm));
-			return rc;
-		}
-	}
-
-	/*
-	 * Find a guineapig BLK region, we know that the dimm with
-	 * handle==0 from nfit_test.0 always allocates from highest DPA
-	 * to lowest with no excursions into BLK only ranges.
-	 */
-	ndctl_region_foreach(bus, region) {
-		if (ndctl_region_get_type(region) != ND_DEVICE_REGION_BLK)
-			continue;
-		dimm = ndctl_region_get_first_dimm(region);
-		if (!dimm)
-			continue;
-		if (ndctl_dimm_get_handle(dimm) == 0) {
-			blk_region = region;
-			break;
-		}
-	}
-	if (!blk_region || ndctl_region_enable(blk_region) < 0) {
-		fprintf(stderr, "failed to find a usable BLK region\n");
-		return -ENXIO;
-	}
-	region = blk_region;
-
-	if (ndctl_region_get_available_size(region) / MIN_SIZE < NUM_NAMESPACES) {
-		fprintf(stderr, "%s insufficient available_size\n",
-				ndctl_region_get_devname(region));
-		return -ENXIO;
-	}
-
-	default_available_slots = ndctl_dimm_get_available_labels(dimm);
-
-	/* grow namespaces */
-	for (i = 0; i < ARRAY_SIZE(namespaces); i++) {
-		uuid_t uuid;
-
-		ndns = ndctl_region_get_namespace_seed(region);
-		if (!ndns) {
-			fprintf(stderr, "%s: failed to get seed: %d\n",
-					ndctl_region_get_devname(region), i);
-			return -ENXIO;
-		}
-		uuid_generate_random(uuid);
-		ndctl_namespace_set_uuid(ndns, uuid);
-		ndctl_namespace_set_sector_size(ndns, 512);
-		ndctl_namespace_set_size(ndns, MIN_SIZE);
-		rc = ndctl_namespace_enable(ndns);
-		if (rc) {
-			fprintf(stderr, "failed to enable %s: %d\n",
-					ndctl_namespace_get_devname(ndns), rc);
-			return rc;
-		}
-		ndctl_namespace_disable_invalidate(ndns);
-		rc = ndctl_namespace_set_size(ndns, page_size);
-		if (rc) {
-			fprintf(stderr, "failed to init %s to size: %lu\n",
-					ndctl_namespace_get_devname(ndns),
-					page_size);
-			return rc;
-		}
-		namespaces[i].ndns = ndns;
-		ndctl_namespace_get_uuid(ndns, namespaces[i].uuid);
-	}
-
-	available_slots = ndctl_dimm_get_available_labels(dimm);
-	if (available_slots != default_available_slots
-			- ARRAY_SIZE(namespaces)) {
-		fprintf(stderr, "expected %ld slots available\n",
-				default_available_slots
-				- ARRAY_SIZE(namespaces));
-		return -ENOSPC;
-	}
-
-	/* exhaust label space, by round-robin allocating 4K */
-	round = 1;
-	for (i = 0; i < available_slots; i++) {
-		ndns = namespaces[i % ARRAY_SIZE(namespaces)].ndns;
-		if (i % ARRAY_SIZE(namespaces) == 0)
-			round++;
-		size = page_size * round;
-		rc = ndctl_namespace_set_size(ndns, size);
-		if (rc) {
-			fprintf(stderr, "%s: set_size: %lx failed: %d\n",
-				ndctl_namespace_get_devname(ndns), size, rc);
-			return rc;
-		}
-	}
-
-	/*
-	 * The last namespace we updated should still be modifiable via
-	 * the kernel's reserve label
-	 */
-	i--;
-	round++;
-	ndns = namespaces[i % ARRAY_SIZE(namespaces)].ndns;
-	size = page_size * round;
-	rc = ndctl_namespace_set_size(ndns, size);
-	if (rc) {
-		fprintf(stderr, "%s failed to update while labels full\n",
-				ndctl_namespace_get_devname(ndns));
-		return rc;
-	}
-
-	round--;
-	size = page_size * round;
-	rc = ndctl_namespace_set_size(ndns, size);
-	if (rc) {
-		fprintf(stderr, "%s failed to reduce size while labels full\n",
-				ndctl_namespace_get_devname(ndns));
-		return rc;
-	}
-
-	/* do the allocations survive a region cycle? */
-	for (i = 0; i < ARRAY_SIZE(namespaces); i++) {
-		ndns = namespaces[i].ndns;
-		namespaces[i].size = ndctl_namespace_get_size(ndns);
-		namespaces[i].ndns = NULL;
-	}
-
-	ndctl_region_disable_invalidate(region);
-	rc = ndctl_region_enable(region);
-	if (rc) {
-		fprintf(stderr, "failed to re-enable %s: %d\n",
-				ndctl_region_get_devname(region), rc);
-		return rc;
-	}
-
-	ndctl_namespace_foreach(region, ndns) {
-		uuid_t uuid;
-
-		ndctl_namespace_get_uuid(ndns, uuid);
-		for (i = 0; i < ARRAY_SIZE(namespaces); i++) {
-			if (uuid_compare(uuid, namespaces[i].uuid) == 0) {
-				namespaces[i].ndns = ndns;
-				break;
-			}
-		}
-	}
-
-	/* validate that they all came back */
-	for (i = 0; i < ARRAY_SIZE(namespaces); i++) {
-		ndns = namespaces[i].ndns;
-		size = ndns ? ndctl_namespace_get_size(ndns) : 0;
-
-		if (ndns && size == namespaces[i].size)
-			continue;
-		uuid_unparse(namespaces[i].uuid, uuid_str);
-		fprintf(stderr, "failed to recover %s\n", uuid_str);
-		return -ENODEV;
-	}
-
-	/* test deletion and merging */
-	ndns = namespaces[0].ndns;
-	for (i = 1; i < ARRAY_SIZE(namespaces); i++) {
-		struct ndctl_namespace *victim = namespaces[i].ndns;
-
-		uuid_unparse(namespaces[i].uuid, uuid_str);
-		size = ndctl_namespace_get_size(victim);
-		rc = ndctl_namespace_disable(victim);
-		if (rc) {
-			fprintf(stderr, "failed to disable %s\n", uuid_str);
-			return rc;
-		}
-		rc = ndctl_namespace_delete(victim);
-		if (rc) {
-			fprintf(stderr, "failed to delete %s\n", uuid_str);
-			return rc;
-		}
-		size += ndctl_namespace_get_size(ndns);
-		rc = ndctl_namespace_set_size(ndns, size);
-		if (rc) {
-			fprintf(stderr, "failed to merge %s\n", uuid_str);
-			return rc;
-		}
-	}
-
-	/* there can be only one */
-	i = 0;
-	ndctl_namespace_foreach(region, ndns) {
-		unsigned long long sz = ndctl_namespace_get_size(ndns);
-
-		if (sz) {
-			i++;
-			if (sz == size)
-				continue;
-			fprintf(stderr, "%s size: %llx expected %lx\n",
-					ndctl_namespace_get_devname(ndns),
-					sz, size);
-			return -ENXIO;
-		}
-	}
-	if (i != 1) {
-		fprintf(stderr, "failed to delete namespaces\n");
-		return -ENXIO;
-	}
-
-	available_slots = ndctl_dimm_get_available_labels(dimm);
-	if (available_slots != default_available_slots - 1) {
-		fprintf(stderr, "mishandled slot count\n");
-		return -ENXIO;
-	}
-
-	ndctl_region_foreach(bus, region)
-		ndctl_region_disable_invalidate(region);
-
-	return 0;
-}
-
-int test_dpa_alloc(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
-{
-	struct kmod_module *mod;
-	struct kmod_ctx *kmod_ctx;
-	int err, result = EXIT_FAILURE;
-
-	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
-		return 77;
-
-	ndctl_set_log_priority(ctx, loglevel);
-	err = ndctl_test_init(&kmod_ctx, &mod, NULL, loglevel, test);
-	if (err < 0) {
-		ndctl_test_skip(test);
-		fprintf(stderr, "nfit_test unavailable skipping tests\n");
-		return 77;
-	}
-
-	err = do_test(ctx, test);
-	if (err == 0)
-		result = EXIT_SUCCESS;
-	kmod_module_remove_module(mod, 0);
-	kmod_unref(kmod_ctx);
-	return result;
-}
-
-int __attribute__((weak)) main(int argc, char *argv[])
-{
-	struct ndctl_test *test = ndctl_test_new(0);
-	struct ndctl_ctx *ctx;
-	int rc;
-
-	if (!test) {
-		fprintf(stderr, "failed to initialize test\n");
-		return EXIT_FAILURE;
-	}
-
-	rc = ndctl_new(&ctx);
-	if (rc)
-		return ndctl_test_result(test, rc);
-
-	rc = test_dpa_alloc(LOG_DEBUG, test, ctx);
-	ndctl_unref(ctx);
-	return ndctl_test_result(test, rc);
-}
diff --git a/test/libndctl.c b/test/libndctl.c
index aa624289c708..0bee06b93787 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -30,46 +30,35 @@
 /*
  * Kernel provider "nfit_test.0" produces an NFIT with the following attributes:
  *
- *                              (a)               (b)           DIMM   BLK-REGION
- *           +-------------------+--------+--------+--------+
- * +------+  |       pm0.0       | blk2.0 | pm1.0  | blk2.1 |    0      region2
- * | imc0 +--+- - - region0- - - +--------+        +--------+
- * +--+---+  |       pm0.0       | blk3.0 | pm1.0  | blk3.1 |    1      region3
- *    |      +-------------------+--------v        v--------+
- * +--+---+                               |                 |
- * | cpu0 |                                     region1
- * +--+---+                               |                 |
- *    |      +----------------------------^        ^--------+
- * +--+---+  |           blk4.0           | pm1.0  | blk4.0 |    2      region4
- * | imc1 +--+----------------------------|        +--------+
- * +------+  |           blk5.0           | pm1.0  | blk5.0 |    3      region5
- *           +----------------------------+--------+--------+
+ *                               (a)               (b)           DIMM
+ *            +-------------------+--------+--------+--------+
+ *  +------+  |       pm0.0       |  free  | pm1.0  |  free  |    0
+ *  | imc0 +--+- - - region0- - - +--------+        +--------+
+ *  +--+---+  |       pm0.0       |  free  | pm1.0  |  free  |    1
+ *     |      +-------------------+--------v        v--------+
+ *  +--+---+                               |                 |
+ *  | cpu0 |                                     region1
+ *  +--+---+                               |                 |
+ *     |      +----------------------------^        ^--------+
+ *  +--+---+  |           free             | pm1.0  |  free  |    2
+ *  | imc1 +--+----------------------------|        +--------+
+ *  +------+  |           free             | pm1.0  |  free  |    3
+ *            +----------------------------+--------+--------+
  *
- * *) In this layout we have four dimms and two memory controllers in one
- *    socket.  Each unique interface ("blk" or "pmem") to DPA space
- *    is identified by a region device with a dynamically assigned id.
+ * In this platform we have four DIMMs and two memory controllers in one
+ * socket.  Each PMEM interleave set is identified by a region device with
+ * a dynamically assigned id.
  *
- * *) The first portion of dimm0 and dimm1 are interleaved as REGION0.
- *    A single "pmem" namespace is created in the REGION0-"spa"-range
- *    that spans dimm0 and dimm1 with a user-specified name of "pm0.0".
- *    Some of that interleaved "spa" range is reclaimed as "bdw"
- *    accessed space starting at offset (a) into each dimm.  In that
- *    reclaimed space we create two "bdw" "namespaces" from REGION2 and
- *    REGION3 where "blk2.0" and "blk3.0" are just human readable names
- *    that could be set to any user-desired name in the label.
+ *    1. The first portion of DIMM0 and DIMM1 are interleaved as REGION0. A
+ *       single PMEM namespace is created in the REGION0-SPA-range that spans most
+ *       of DIMM0 and DIMM1 with a user-specified name of "pm0.0". Some of that
+ *       interleaved system-physical-address range is left free for
+ *       another PMEM namespace to be defined.
  *
- * *) In the last portion of dimm0 and dimm1 we have an interleaved
- *    "spa" range, REGION1, that spans those two dimms as well as dimm2
- *    and dimm3.  Some of REGION1 allocated to a "pmem" namespace named
- *    "pm1.0" the rest is reclaimed in 4 "bdw" namespaces (for each
- *    dimm in the interleave set), "blk2.1", "blk3.1", "blk4.0", and
- *    "blk5.0".
- *
- * *) The portion of dimm2 and dimm3 that do not participate in the
- *    REGION1 interleaved "spa" range (i.e. the DPA address below
- *    offset (b) are also included in the "blk4.0" and "blk5.0"
- *    namespaces.  Note, that this example shows that "bdw" namespaces
- *    don't need to be contiguous in DPA-space.
+ *    2. In the last portion of DIMM0 and DIMM1 we have an interleaved
+ *       system-physical-address range, REGION1, that spans those two DIMMs as
+ *       well as DIMM2 and DIMM3.  Some of REGION1 is allocated to a PMEM namespace
+ *       named "pm1.0".
  *
  * Kernel provider "nfit_test.1" produces an NFIT with the following attributes:
  *
@@ -127,10 +116,10 @@ struct dimm {
 	(((n & 0xfff) << 16) | ((s & 0xf) << 12) | ((i & 0xf) << 8) \
 	 | ((c & 0xf) << 4) | (d & 0xf))
 static struct dimm dimms0[] = {
-	{ DIMM_HANDLE(0, 0, 0, 0, 0), 0, 0, 2016, 10, 42, { 0 }, 2, { 0x201, 0x301, }, },
-	{ DIMM_HANDLE(0, 0, 0, 0, 1), 1, 0, 2016, 10, 42, { 0 }, 2, { 0x201, 0x301, }, },
-	{ DIMM_HANDLE(0, 0, 1, 0, 0), 2, 0, 2016, 10, 42, { 0 }, 2, { 0x201, 0x301, }, },
-	{ DIMM_HANDLE(0, 0, 1, 0, 1), 3, 0, 2016, 10, 42, { 0 }, 2, { 0x201, 0x301, }, },
+	{ DIMM_HANDLE(0, 0, 0, 0, 0), 0, 0, 2016, 10, 42, { 0 }, 1, { 0x201, }, },
+	{ DIMM_HANDLE(0, 0, 0, 0, 1), 1, 0, 2016, 10, 42, { 0 }, 1, { 0x201, }, },
+	{ DIMM_HANDLE(0, 0, 1, 0, 0), 2, 0, 2016, 10, 42, { 0 }, 1, { 0x201, }, },
+	{ DIMM_HANDLE(0, 0, 1, 0, 1), 3, 0, 2016, 10, 42, { 0 }, 1, { 0x201, }, },
 };
 
 static struct dimm dimms1[] = {
@@ -240,7 +229,6 @@ struct namespace {
 };
 
 static uuid_t null_uuid;
-static unsigned long blk_sector_sizes[] = { 512, 520, 528, 4096, 4104, 4160, 4224, };
 static unsigned long pmem_sector_sizes[] = { 512, 4096 };
 static unsigned long io_sector_sizes[] = { 0 };
 
@@ -262,60 +250,6 @@ static struct namespace namespace1_pmem0 = {
 	ARRAY_SIZE(pmem_sector_sizes), pmem_sector_sizes,
 };
 
-static struct namespace namespace2_blk0 = {
-	0, "namespace_blk", NULL, NULL, NULL, SZ_7M,
-	{ 3, 3, 3, 3,
-	  3, 3, 3, 3,
-	  3, 3, 3, 3,
-	  3, 3, 3, 3, }, 1, 1, 0,
-	ARRAY_SIZE(blk_sector_sizes), blk_sector_sizes,
-};
-
-static struct namespace namespace2_blk1 = {
-	1, "namespace_blk", NULL, NULL, NULL, SZ_11M,
-	{ 4, 4, 4, 4,
-	  4, 4, 4, 4,
-	  4, 4, 4, 4,
-	  4, 4, 4, 4, }, 1, 1, 0,
-	ARRAY_SIZE(blk_sector_sizes), blk_sector_sizes,
-};
-
-static struct namespace namespace3_blk0 = {
-	0, "namespace_blk", NULL, NULL, NULL, SZ_7M,
-	{ 5, 5, 5, 5,
-	  5, 5, 5, 5,
-	  5, 5, 5, 5,
-	  5, 5, 5, 5, }, 1, 1, 0,
-	ARRAY_SIZE(blk_sector_sizes), blk_sector_sizes,
-};
-
-static struct namespace namespace3_blk1 = {
-	1, "namespace_blk", NULL, NULL, NULL, SZ_11M,
-	{ 6, 6, 6, 6,
-	  6, 6, 6, 6,
-	  6, 6, 6, 6,
-	  6, 6, 6, 6, }, 1, 1, 0,
-	ARRAY_SIZE(blk_sector_sizes), blk_sector_sizes,
-};
-
-static struct namespace namespace4_blk0 = {
-	0, "namespace_blk", &btt_settings, NULL, NULL, SZ_27M,
-	{ 7, 7, 7, 7,
-	  7, 7, 7, 7,
-	  7, 7, 7, 7,
-	  7, 7, 7, 7, }, 1, 1, 0,
-	ARRAY_SIZE(blk_sector_sizes), blk_sector_sizes,
-};
-
-static struct namespace namespace5_blk0 = {
-	0, "namespace_blk", &btt_settings, NULL, NULL, SZ_27M,
-	{ 8, 8, 8, 8,
-	  8, 8, 8, 8,
-	  8, 8, 8, 8,
-	  8, 8, 8, 8, }, 1, 1, 0,
-	ARRAY_SIZE(blk_sector_sizes), blk_sector_sizes,
-};
-
 static struct region regions0[] = {
 	{ { 1 }, 2, 1, "pmem", SZ_32M, SZ_32M, { 1 },
 		.namespaces = {
@@ -339,40 +273,6 @@ static struct region regions0[] = {
 			[0] = &default_pfn,
 		},
 	},
-	{ { DIMM_HANDLE(0, 0, 0, 0, 0) }, 1, 1, "blk", SZ_18M, SZ_32M,
-		.namespaces = {
-			[0] = &namespace2_blk0,
-			[1] = &namespace2_blk1,
-		},
-		.btts = {
-			[0] = &default_btt,
-		},
-	},
-	{ { DIMM_HANDLE(0, 0, 0, 0, 1) }, 1, 1, "blk", SZ_18M, SZ_32M,
-		.namespaces = {
-			[0] = &namespace3_blk0,
-			[1] = &namespace3_blk1,
-		},
-		.btts = {
-			[0] = &default_btt,
-		},
-	},
-	{ { DIMM_HANDLE(0, 0, 1, 0, 0) }, 1, 1, "blk", SZ_27M, SZ_32M,
-		.namespaces = {
-			[0] = &namespace4_blk0,
-		},
-		.btts = {
-			[0] = &default_btt,
-		},
-	},
-	{ { DIMM_HANDLE(0, 0, 1, 0, 1) }, 1, 1, "blk", SZ_27M, SZ_32M,
-		.namespaces = {
-			[0] = &namespace5_blk0,
-		},
-		.btts = {
-			[0] = &default_btt,
-		},
-	},
 };
 
 static struct namespace namespace1 = {
@@ -485,26 +385,6 @@ static struct ndctl_region *get_pmem_region_by_range_index(struct ndctl_bus *bus
 	return NULL;
 }
 
-static struct ndctl_region *get_blk_region_by_dimm_handle(struct ndctl_bus *bus,
-		unsigned int handle)
-{
-	struct ndctl_region *region;
-
-	ndctl_region_foreach(bus, region) {
-		struct ndctl_mapping *map;
-
-		if (ndctl_region_get_type(region) != ND_DEVICE_REGION_BLK)
-			continue;
-		ndctl_mapping_foreach(region, map) {
-			struct ndctl_dimm *dimm = ndctl_mapping_get_dimm(map);
-
-			if (ndctl_dimm_get_handle(dimm) == handle)
-				return region;
-		}
-	}
-	return NULL;
-}
-
 enum ns_mode {
 	BTT, PFN, DAX,
 };
@@ -522,11 +402,8 @@ static int check_regions(struct ndctl_bus *bus, struct region *regions, int n,
 		struct ndctl_interleave_set *iset;
 		char devname[50];
 
-		if (strcmp(regions[i].type, "pmem") == 0)
-			region = get_pmem_region_by_range_index(bus, regions[i].range_index);
-		else
-			region = get_blk_region_by_dimm_handle(bus, regions[i].handle);
-
+		region = get_pmem_region_by_range_index(bus,
+							regions[i].range_index);
 		if (!region) {
 			fprintf(stderr, "failed to find region type: %s ident: %x\n",
 					regions[i].type, regions[i].handle);
@@ -1065,7 +942,6 @@ static int check_btt_create(struct ndctl_region *region, struct ndctl_namespace
 		return -ENXIO;
 
 	for (i = 0; i < btt_s->num_sector_sizes; i++) {
-		struct ndctl_namespace *ns_seed = ndctl_region_get_namespace_seed(region);
 		struct ndctl_btt *btt_seed = ndctl_region_get_btt_seed(region);
 		enum ndctl_namespace_mode mode;
 
@@ -1115,16 +991,6 @@ static int check_btt_create(struct ndctl_region *region, struct ndctl_namespace
 			goto err;
 		}
 
-		/* check new seed creation for BLK regions */
-		if (ndctl_region_get_type(region) == ND_DEVICE_REGION_BLK) {
-			if (ns_seed == ndctl_region_get_namespace_seed(region)
-					&& ndns == ns_seed) {
-				fprintf(stderr, "%s: failed to advance namespace seed\n",
-						ndctl_region_get_devname(region));
-				goto err;
-			}
-		}
-
 		if (namespace->ro) {
 			ndctl_region_set_ro(region, 0);
 			rc = ndctl_btt_enable(btt);
diff --git a/test/multi-pmem.c b/test/multi-pmem.c
deleted file mode 100644
index 3ea08cc43f9a..000000000000
--- a/test/multi-pmem.c
+++ /dev/null
@@ -1,285 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-// Copyright (C) 2015-2020 Intel Corporation. All rights reserved.
-#include <stdio.h>
-#include <errno.h>
-#include <unistd.h>
-#include <stdlib.h>
-#include <syslog.h>
-#include <string.h>
-#include <sys/stat.h>
-#include <sys/mman.h>
-#include <sys/time.h>
-#include <libkmod.h>
-#include <uuid/uuid.h>
-#include <sys/types.h>
-#include <util/size.h>
-#include <linux/falloc.h>
-#include <linux/version.h>
-#include <ndctl/libndctl.h>
-#include <ccan/array_size/array_size.h>
-
-#include <ndctl.h>
-#include <builtin.h>
-#include <test.h>
-
-#define NUM_NAMESPACES 4
-#define SZ_NAMESPACE SZ_16M
-
-static int setup_namespace(struct ndctl_region *region)
-{
-	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
-	const char *argv[] = {
-		"__func__", "-v", "-m", "raw", "-s", "16M", "-r", "",
-	};
-	int argc = ARRAY_SIZE(argv);
-
-	argv[argc - 1] = ndctl_region_get_devname(region);
-	builtin_xaction_namespace_reset();
-	return cmd_create_namespace(argc, argv, ctx);
-}
-
-static void destroy_namespace(struct ndctl_namespace *ndns)
-{
-	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
-	const char *argv[] = {
-		"__func__", "-v", "-f", "",
-	};
-	int argc = ARRAY_SIZE(argv);
-
-	argv[argc - 1] = ndctl_namespace_get_devname(ndns);
-	builtin_xaction_namespace_reset();
-	cmd_destroy_namespace(argc, argv, ctx);
-}
-
-/* Check that the namespace device is gone (if it wasn't the seed) */
-static int check_deleted(struct ndctl_region *region, const char *devname,
-		struct ndctl_test *test)
-{
-	struct ndctl_namespace *ndns;
-
-	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 10, 0)))
-		return 0;
-
-	ndctl_namespace_foreach(region, ndns) {
-		if (strcmp(devname, ndctl_namespace_get_devname(ndns)))
-			continue;
-		if (ndns == ndctl_region_get_namespace_seed(region))
-			continue;
-		fprintf(stderr, "multi-pmem: expected %s to be deleted\n",
-				devname);
-		return -ENXIO;
-	}
-
-	return 0;
-}
-
-static int do_multi_pmem(struct ndctl_ctx *ctx, struct ndctl_test *test)
-{
-	int i;
-	char devname[100];
-	struct ndctl_bus *bus;
-	uuid_t uuid[NUM_NAMESPACES];
-	struct ndctl_namespace *ndns;
-	struct ndctl_dimm *dimm_target, *dimm;
-	struct ndctl_region *region, *target = NULL;
-	struct ndctl_namespace *namespaces[NUM_NAMESPACES];
-	unsigned long long blk_avail, blk_avail_orig, expect;
-
-	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0))) {
-		ndctl_test_skip(test);
-		return 77;
-	}
-
-	bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
-	if (!bus)
-		return -ENXIO;
-
-	/* disable all regions so that set_config_data commands are permitted */
-	ndctl_region_foreach(bus, region)
-		ndctl_region_disable_invalidate(region);
-
-	ndctl_dimm_foreach(bus, dimm) {
-		int rc = ndctl_dimm_zero_labels(dimm);
-
-		if (rc < 0) {
-			fprintf(stderr, "failed to zero %s\n",
-					ndctl_dimm_get_devname(dimm));
-			return rc;
-		}
-	}
-
-	/*
-	 * Set regions back to their default state and find our target
-	 * region.
-	 */
-	ndctl_region_foreach(bus, region) {
-		ndctl_region_enable(region);
-		if (ndctl_region_get_available_size(region)
-				== SZ_NAMESPACE * NUM_NAMESPACES)
-			target = region;
-	}
-
-	if (!target) {
-		fprintf(stderr, "multi-pmem: failed to find target region\n");
-		return -ENXIO;
-	}
-	region = target;
-
-	for (i = 0; i < (int) ARRAY_SIZE(uuid); i++) {
-		if (setup_namespace(region) != 0) {
-			fprintf(stderr, "multi-pmem: failed to setup namespace: %d\n", i);
-			return -ENXIO;
-		}
-		sprintf(devname, "namespace%d.%d",
-				ndctl_region_get_id(region), i);
-		ndctl_namespace_foreach(region, ndns)
-			if (strcmp(ndctl_namespace_get_devname(ndns), devname) == 0
-					&& ndctl_namespace_is_enabled(ndns))
-				break;
-		if (!ndns) {
-			fprintf(stderr, "multi-pmem: failed to find namespace: %s\n",
-					devname);
-			return -ENXIO;
-		}
-		ndctl_namespace_get_uuid(ndns, uuid[i]);
-	}
-
-	/* bounce the region and verify everything came back as expected */
-	ndctl_region_disable_invalidate(region);
-	ndctl_region_enable(region);
-
-	for (i = 0; i < (int) ARRAY_SIZE(uuid); i++) {
-		char uuid_str1[40], uuid_str2[40];
-		uuid_t uuid_check;
-
-		sprintf(devname, "namespace%d.%d",
-				ndctl_region_get_id(region), i);
-		ndctl_namespace_foreach(region, ndns)
-			if (strcmp(ndctl_namespace_get_devname(ndns), devname) == 0
-					&& ndctl_namespace_is_enabled(ndns))
-				break;
-		if (!ndns) {
-			fprintf(stderr, "multi-pmem: failed to restore namespace: %s\n",
-					devname);
-			return -ENXIO;
-		}
-
-		ndctl_namespace_get_uuid(ndns, uuid_check);
-		uuid_unparse(uuid_check, uuid_str2);
-		uuid_unparse(uuid[i], uuid_str1);
-		if (uuid_compare(uuid_check, uuid[i]) != 0) {
-			fprintf(stderr, "multi-pmem: expected uuid[%d]: %s, got %s\n",
-					i, uuid_str1, uuid_str2);
-			return -ENXIO;
-		}
-		namespaces[i] = ndns;
-	}
-
-	/*
-	 * Check that aliased blk capacity does not increase until the
-	 * highest dpa pmem-namespace is deleted.
-	 */
-	dimm_target = ndctl_region_get_first_dimm(region);
-	if (!dimm_target) {
-		fprintf(stderr, "multi-pmem: failed to retrieve dimm from %s\n",
-				ndctl_region_get_devname(region));
-		return -ENXIO;
-	}
-
-	dimm = NULL;
-	ndctl_region_foreach(bus, region) {
-		if (ndctl_region_get_type(region) != ND_DEVICE_REGION_BLK)
-			continue;
-		ndctl_dimm_foreach_in_region(region, dimm)
-			if (dimm == dimm_target)
-				break;
-		if (dimm)
-			break;
-	}
-
-	blk_avail_orig = ndctl_region_get_available_size(region);
-	for (i = 1; i < NUM_NAMESPACES - 1; i++) {
-		ndns = namespaces[i];
-		sprintf(devname, "%s", ndctl_namespace_get_devname(ndns));
-		destroy_namespace(ndns);
-		blk_avail = ndctl_region_get_available_size(region);
-		if (blk_avail != blk_avail_orig) {
-			fprintf(stderr, "multi-pmem: destroy %s %llx avail, expect %llx\n",
-					devname, blk_avail, blk_avail_orig);
-			return -ENXIO;
-		}
-
-		if (check_deleted(target, devname, test) != 0)
-			return -ENXIO;
-	}
-
-	ndns = namespaces[NUM_NAMESPACES - 1];
-	sprintf(devname, "%s", ndctl_namespace_get_devname(ndns));
-	destroy_namespace(ndns);
-	blk_avail = ndctl_region_get_available_size(region);
-	expect = (SZ_NAMESPACE / ndctl_region_get_interleave_ways(target))
-		* (NUM_NAMESPACES - 1) + blk_avail_orig;
-	if (blk_avail != expect) {
-		fprintf(stderr, "multi-pmem: destroy %s %llx avail, expect %llx\n",
-				devname, blk_avail, expect);
-		return -ENXIO;
-	}
-
-	if (check_deleted(target, devname, test) != 0)
-		return -ENXIO;
-
-	ndctl_bus_foreach(ctx, bus) {
-		if (strncmp(ndctl_bus_get_provider(bus), "nfit_test", 9) != 0)
-			continue;
-		ndctl_region_foreach(bus, region)
-			ndctl_region_disable_invalidate(region);
-	}
-
-	return 0;
-}
-
-int test_multi_pmem(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
-{
-	struct kmod_module *mod;
-	struct kmod_ctx *kmod_ctx;
-	int err, result = EXIT_FAILURE;
-
-	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
-		return 77;
-
-	ndctl_set_log_priority(ctx, loglevel);
-
-	err = ndctl_test_init(&kmod_ctx, &mod, NULL, loglevel, test);
-	if (err < 0) {
-		result = 77;
-		ndctl_test_skip(test);
-		fprintf(stderr, "%s unavailable skipping tests\n",
-				"nfit_test");
-		return result;
-	}
-
-	result = do_multi_pmem(ctx, test);
-
-	kmod_module_remove_module(mod, 0);
-	kmod_unref(kmod_ctx);
-	return result;
-}
-
-int __attribute__((weak)) main(int argc, char *argv[])
-{
-	struct ndctl_test *test = ndctl_test_new(0);
-	struct ndctl_ctx *ctx;
-	int rc;
-
-	if (!test) {
-		fprintf(stderr, "failed to initialize test\n");
-		return EXIT_FAILURE;
-	}
-
-	rc = ndctl_new(&ctx);
-	if (rc)
-		return ndctl_test_result(test, rc);
-	rc = test_multi_pmem(LOG_DEBUG, test, ctx);
-	ndctl_unref(ctx);
-	return ndctl_test_result(test, rc);
-}
diff --git a/test/parent-uuid.c b/test/parent-uuid.c
deleted file mode 100644
index bded33afbf23..000000000000
--- a/test/parent-uuid.c
+++ /dev/null
@@ -1,254 +0,0 @@
-// SPDX-License-Identifier: LGPL-2.1
-// Copyright (C) 2015-2020, Intel Corporation. All rights reserved.
-#include <stdio.h>
-#include <stddef.h>
-#include <stdlib.h>
-#include <string.h>
-#include <fcntl.h>
-#include <ctype.h>
-#include <errno.h>
-#include <unistd.h>
-#include <limits.h>
-#include <syslog.h>
-#include <libkmod.h>
-#include <uuid/uuid.h>
-#include <linux/version.h>
-#include <test.h>
-
-#include <ndctl/libndctl.h>
-
-static const char *PROVIDER = "nfit_test.0";
-
-static struct ndctl_bus *get_bus_by_provider(struct ndctl_ctx *ctx,
-		const char *provider)
-{
-	struct ndctl_bus *bus;
-
-        ndctl_bus_foreach(ctx, bus)
-		if (strcmp(provider, ndctl_bus_get_provider(bus)) == 0)
-			return bus;
-
-	return NULL;
-}
-
-static struct ndctl_btt *get_idle_btt(struct ndctl_region *region)
-{
-	struct ndctl_btt *btt;
-
-	ndctl_btt_foreach(region, btt)
-		if (!ndctl_btt_is_enabled(btt)
-				&& !ndctl_btt_is_configured(btt))
-			return btt;
-	return NULL;
-}
-
-static struct ndctl_namespace *create_blk_namespace(int region_fraction,
-		struct ndctl_region *region, unsigned long long req_size,
-		uuid_t uuid)
-{
-	struct ndctl_namespace *ndns, *seed_ns = NULL;
-	unsigned long long size;
-
-	ndctl_region_set_align(region, sysconf(_SC_PAGESIZE));
-	ndctl_namespace_foreach(region, ndns)
-		if (ndctl_namespace_get_size(ndns) == 0) {
-			seed_ns = ndns;
-			break;
-		}
-
-	if (!seed_ns)
-		return NULL;
-
-	size = ndctl_region_get_size(region)/region_fraction;
-	if (req_size)
-		size = req_size;
-
-	if (ndctl_namespace_set_uuid(seed_ns, uuid) < 0)
-		return NULL;
-
-	if (ndctl_namespace_set_size(seed_ns, size) < 0)
-		return NULL;
-
-	if (ndctl_namespace_set_sector_size(seed_ns, 512) < 0)
-		return NULL;
-
-	if (ndctl_namespace_enable(seed_ns) < 0)
-		return NULL;
-
-	return seed_ns;
-}
-
-static int disable_blk_namespace(struct ndctl_namespace *ndns)
-{
-	if (ndctl_namespace_disable_invalidate(ndns) < 0)
-		return -ENODEV;
-
-	if (ndctl_namespace_delete(ndns) < 0)
-		return -ENODEV;
-
-	return 0;
-}
-
-static struct ndctl_btt *check_valid_btt(struct ndctl_region *region,
-		struct ndctl_namespace *ndns, uuid_t btt_uuid)
-{
-	struct ndctl_btt *btt = NULL;
-	ndctl_btt_foreach(region, btt) {
-		struct ndctl_namespace *btt_ndns;
-		uuid_t uu;
-
-		ndctl_btt_get_uuid(btt, uu);
-		if (uuid_compare(uu, btt_uuid) != 0)
-			continue;
-		if (!ndctl_btt_is_enabled(btt))
-			continue;
-		btt_ndns = ndctl_btt_get_namespace(btt);
-		if (!btt_ndns || strcmp(ndctl_namespace_get_devname(btt_ndns),
-				ndctl_namespace_get_devname(ndns)) != 0)
-			continue;
-		return btt;
-	}
-	return NULL;
-}
-
-static int do_test(struct ndctl_ctx *ctx)
-{
-	int rc;
-	struct ndctl_bus *bus;
-	struct ndctl_btt *btt, *found = NULL, *_btt;
-	struct ndctl_region *region, *blk_region = NULL;
-	struct ndctl_namespace *ndns, *_ndns;
-	unsigned long long ns_size = 18874368;
-	uuid_t uuid = {0,  1,  2,  3,  4,  5,  6,  7, 8, 9, 10, 11, 12, 13, 14, 16};
-	uuid_t btt_uuid;
-
-	bus = get_bus_by_provider(ctx, PROVIDER);
-	if (!bus) {
-		fprintf(stderr, "failed to find NFIT-provider: %s\n", PROVIDER);
-		return -ENODEV;
-	}
-
-	ndctl_region_foreach(bus, region)
-		if (strcmp(ndctl_region_get_type_name(region), "blk") == 0) {
-			blk_region = region;
-			break;
-		}
-
-	if (!blk_region) {
-		fprintf(stderr, "failed to find block region\n");
-		return -ENODEV;
-	}
-
-	/* create a blk namespace */
-	ndns = create_blk_namespace(1, blk_region, ns_size, uuid);
-	if (!ndns) {
-		fprintf(stderr, "failed to create block namespace\n");
-		return -ENXIO;
-	}
-
-	/* create a btt for this namespace */
-	uuid_generate(btt_uuid);
-	btt = get_idle_btt(region);
-	if (!btt)
-		return -ENXIO;
-
-	ndctl_namespace_disable_invalidate(ndns);
-	ndctl_btt_set_uuid(btt, btt_uuid);
-	ndctl_btt_set_sector_size(btt, 512);
-	ndctl_btt_set_namespace(btt, ndns);
-	rc = ndctl_btt_enable(btt);
-	if (rc) {
-		fprintf(stderr, "failed to create btt 0\n");
-		return rc;
-	}
-
-	/* re-create the namespace - this should auto-enable the btt */
-	disable_blk_namespace(ndns);
-	ndns = create_blk_namespace(1, blk_region, ns_size, uuid);
-	if (!ndns) {
-		fprintf(stderr, "failed to re-create block namespace\n");
-		return -ENXIO;
-	}
-
-	/* Verify btt was auto-created */
-	found = check_valid_btt(blk_region, ndns, btt_uuid);
-	if (!found)
-		return -ENXIO;
-	btt = found;
-
-	/*disable the btt and namespace again */
-	ndctl_btt_delete(btt);
-	disable_blk_namespace(ndns);
-
-	/* recreate the namespace with a different uuid */
-	uuid_generate(uuid);
-	ndns = create_blk_namespace(1, blk_region, ns_size, uuid);
-	if (!ndns) {
-		fprintf(stderr, "failed to re-create block namespace\n");
-		return -ENXIO;
-	}
-
-	/* make sure there is no btt on this namespace */
-	found = check_valid_btt(blk_region, ndns, btt_uuid);
-	if (found) {
-		fprintf(stderr, "found a stale btt\n");
-		return -ENXIO;
-	}
-
-	ndctl_btt_foreach_safe(blk_region, btt, _btt)
-		ndctl_btt_delete(btt);
-
-	ndctl_namespace_foreach_safe(blk_region, ndns, _ndns)
-		if (ndctl_namespace_get_size(ndns) != 0)
-			disable_blk_namespace(ndns);
-
-	ndctl_region_foreach(bus, region)
-		ndctl_region_disable_invalidate(region);
-
-	return 0;
-}
-
-int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
-{
-	struct kmod_module *mod;
-	struct kmod_ctx *kmod_ctx;
-	int err, result = EXIT_FAILURE;
-
-	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 3, 0)))
-		return 77;
-
-	ndctl_set_log_priority(ctx, loglevel);
-	err = ndctl_test_init(&kmod_ctx, &mod, NULL, loglevel, test);
-	if (err < 0) {
-		ndctl_test_skip(test);
-		fprintf(stderr, "nfit_test unavailable skipping tests\n");
-		return 77;
-	}
-
-	err = do_test(ctx);
-	if (err == 0)
-		result = EXIT_SUCCESS;
-	kmod_module_remove_module(mod, 0);
-	kmod_unref(kmod_ctx);
-	return result;
-}
-
-int __attribute__((weak)) main(int argc, char *argv[])
-{
-	struct ndctl_test *test = ndctl_test_new(0);
-	struct ndctl_ctx *ctx;
-	int rc;
-
-	if (!test) {
-		fprintf(stderr, "failed to initialize test\n");
-		return EXIT_FAILURE;
-	}
-
-	rc = ndctl_new(&ctx);
-	if (rc)
-		return ndctl_test_result(test, rc);
-
-	rc = test_parent_uuid(LOG_DEBUG, test, ctx);
-	ndctl_unref(ctx);
-	return ndctl_test_result(test, rc);
-}

