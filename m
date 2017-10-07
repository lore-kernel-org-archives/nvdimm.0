Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 382A82095B06F
 for <linux-nvdimm@lists.01.org>; Sat,  7 Oct 2017 08:17:42 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, test: rdma vs dax
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 07 Oct 2017 08:14:42 -0700
Message-ID: <150738928223.25087.18137727671163532987.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Use the rxe (Soft-ROCE) driver to unit test the DAX paths in ibverbs
memory registration (ib_umem_get).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 configure.ac     |   11 +++
 test/Makefile.am |   13 +++
 test/rdma.c      |  224 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 test/rdma.sh     |   54 +++++++++++++
 4 files changed, 302 insertions(+)
 create mode 100644 test/rdma.c
 create mode 100755 test/rdma.sh

diff --git a/configure.ac b/configure.ac
index 5b103813ee6f..087df2f7b3a6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -94,6 +94,17 @@ PKG_CHECK_MODULES([UDEV], [libudev])
 PKG_CHECK_MODULES([UUID], [uuid])
 PKG_CHECK_MODULES([JSON], [json-c])
 
+AC_ARG_WITH([libibverbs],
+	AS_HELP_STRING([--with-libibverbs],
+		       [Enable RDMA functionality. @<:@default=no@:>@]),
+	[], [with_libibverbs=no])
+if test "x$with_libibverbs" = "xyes"; then
+	AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
+		AC_MSG_ERROR([libibverbs not found.]))
+	AC_DEFINE(ENABLE_RDMA, 1, [Enable RDMA])
+fi
+AM_CONDITIONAL([ENABLE_RDMA], [test "x$with_libibverbs" = "xyes"])
+
 AC_ARG_WITH([libpmem],
 	AS_HELP_STRING([--with-libpmem],
 		       [Install with libpmem support. @<:@default=no@:>@]),
diff --git a/test/Makefile.am b/test/Makefile.am
index 9223628b2608..0be0d0ab8828 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -42,6 +42,11 @@ check_PROGRAMS +=\
 	dax-pmd \
 	device-dax \
 	mmap
+
+if ENABLE_RDMA
+TESTS += rdma.sh
+check_PROGRAMS += rdma
+endif
 endif
 
 LIBNDCTL_LIB =\
@@ -110,3 +115,11 @@ multi_pmem_LDADD = \
 		$(UUID_LIBS) \
 		$(KMOD_LIBS) \
 		../libutil.a
+
+rdma_SOURCES =\
+	      rdma.c \
+	      $(testcore)
+
+rdma_LDADD = \
+	     $(LIBNDCTL_LIB)
+	     -libverbs
diff --git a/test/rdma.c b/test/rdma.c
new file mode 100644
index 000000000000..043483272162
--- /dev/null
+++ b/test/rdma.c
@@ -0,0 +1,224 @@
+/*
+ * Copyright (c) 2014-2017, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
+ * more details.
+ */
+#include <stdio.h>
+#include <stddef.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <ctype.h>
+#include <errno.h>
+#include <unistd.h>
+#include <limits.h>
+#include <syslog.h>
+#include <sys/mman.h>
+#include <linux/mman.h>
+
+#include <util/size.h>
+#include <ndctl/libndctl.h>
+#include <infiniband/verbs.h>
+#include <ccan/array_size/array_size.h>
+
+static struct ibv_qp *create_qp(struct ibv_pd *pd, struct ibv_cq *cq)
+{
+	struct ibv_qp *qp;
+	struct ibv_qp_init_attr qp_attr = {
+		.send_cq = cq,
+		.recv_cq = cq,
+		.cap = {
+			.max_send_wr = 1,
+			.max_recv_wr = 1,
+			.max_send_sge = 1,
+			.max_recv_sge = 1,
+		},
+		.qp_type = IBV_QPT_RC,
+	};
+
+	qp = ibv_create_qp(pd, &qp_attr);
+	if (!qp)
+		return NULL;
+	if (qp_attr.cap.max_send_wr < 1 || qp_attr.cap.max_recv_wr < 1
+			|| qp_attr.cap.max_send_sge < 1
+			|| qp_attr.cap.max_recv_sge < 1) {
+		fprintf(stderr, "%s: insufficient queue pair capabilities\n",
+				__func__);
+		ibv_destroy_qp(qp);
+		return NULL;
+	}
+	return qp;
+}
+
+static int post_recv(struct ibv_qp *qp, struct ibv_mr *mr, void *addr,
+		size_t len)
+{
+	struct ibv_recv_wr wr = {
+		.sg_list = &(struct ibv_sge) {
+			.addr = (uint64_t) addr,
+			.length = len,
+			.lkey = mr->lkey
+		},
+		.num_sge = 1,
+		.next = NULL,
+	};
+	struct ibv_recv_wr *bad_wr;
+
+	return ibv_post_recv(qp, &wr, &bad_wr);
+}
+
+static int do_rdma(struct ndctl_ctx *ctx, int fd, unsigned long map_flags)
+{
+	int nr_devs, rc = -ENXIO;
+	void *addr;
+	struct ibv_pd *pd;
+	struct ibv_mr *mr;
+	struct ibv_cq *cq;
+	struct ibv_qp *qp;
+	struct ibv_context *ictx;
+	size_t map_len = 4*HPAGE_SIZE;
+	struct ibv_device **idevs, *idev;
+
+	addr = mmap(NULL, map_len, PROT_READ|PROT_WRITE, map_flags, fd, 0);
+	if (addr == MAP_FAILED) {
+		fprintf(stderr, "failed to map test file\n");
+		return -ENXIO;
+	}
+
+	idevs = ibv_get_device_list(&nr_devs);
+	if (!idevs || !nr_devs) {
+		fprintf(stderr, "ibverbs device not found\n");
+		goto err_dev;
+	}
+
+	idev = idevs[0];
+	ictx = ibv_open_device(idev);
+	if (ictx)
+		fprintf(stderr, "%s: opened dev: %s\n", __func__,
+				ibv_get_device_name(idev));
+	else {
+		fprintf(stderr, "%s: failed to open dev: %s\n", __func__,
+				ibv_get_device_name(idev));
+		goto err_open;
+	}
+
+	pd = ibv_alloc_pd(ictx);
+	if (!pd) {
+		fprintf(stderr, "%s: failed alloc_pd dev: %s\n", __func__,
+				ibv_get_device_name(idev));
+		goto err_pd;
+	}
+
+	mr = ibv_reg_mr(pd, addr, map_len, IBV_ACCESS_LOCAL_WRITE
+			| IBV_ACCESS_REMOTE_WRITE | IBV_ACCESS_REMOTE_READ);
+	if (!mr) {
+		fprintf(stderr, "%s: failed reg_mr dev: %s\n", __func__,
+				ibv_get_device_name(idev));
+		goto err_mr;
+	}
+
+	cq = ibv_create_cq(ictx, 1, NULL, NULL, 0);
+	if (!cq) {
+		fprintf(stderr, "%s: failed create_cq dev: %s\n", __func__,
+				ibv_get_device_name(idev));
+		goto err_cq;
+	}
+
+	qp = create_qp(pd, cq);
+	if (!cq) {
+		fprintf(stderr, "%s: failed create_qp dev: %s\n", __func__,
+				ibv_get_device_name(idev));
+		goto err_qp;
+	}
+
+	rc = post_recv(qp, mr, addr, map_len);
+	if (rc) {
+		fprintf(stderr, "%s: failed post_recv (%d) dev: %s\n", __func__,
+				rc, ibv_get_device_name(idev));
+		goto err_post_recv;
+	}
+
+	fprintf(stderr, "%s: successful post_recv dev: %s\n", __func__,
+				ibv_get_device_name(idev));
+	rc = 0;
+err_post_recv:
+	ibv_destroy_qp(qp);
+err_qp:
+	ibv_destroy_cq(cq);
+err_cq:
+	ibv_dereg_mr(mr);
+err_mr:
+	ibv_dealloc_pd(pd);
+err_pd:
+	ibv_close_device(ictx);
+err_open:
+	ibv_free_device_list(idevs);
+err_dev:
+	munmap(addr, map_len);
+	return rc;
+}
+
+static int test_rdma(int fd, int loglevel)
+{
+	int err, i;
+	struct ndctl_ctx *ctx;
+	unsigned long test_flags[] = {
+		MAP_SHARED,
+		MAP_SHARED_VALIDATE | MAP_DIRECT,
+	};
+
+	err = ndctl_new(&ctx);
+	if (err < 0)
+		return err;
+
+	ndctl_set_log_priority(ctx, loglevel);
+
+	for (i = 0; i < (int) ARRAY_SIZE(test_flags); i++) {
+		unsigned long map_flags = test_flags[i];
+
+		err = do_rdma(ctx, fd, map_flags);
+		switch (map_flags) {
+		case MAP_SHARED:
+			if (err == 0) {
+				fprintf(stderr, "expected failure map_flags: %#lx\n",
+						map_flags);
+				return EXIT_FAILURE;
+			}
+			break;
+		case (MAP_SHARED_VALIDATE | MAP_DIRECT):
+			if (err != 0) {
+				fprintf(stderr, "expected success map_flags: %#lx\n",
+						map_flags);
+				return EXIT_FAILURE;
+			}
+			break;
+		default:
+			fprintf(stderr, "unhandled test case\n");
+			return EXIT_FAILURE;
+		}
+	}
+
+	ndctl_unref(ctx);
+	return err;
+}
+
+int __attribute__((weak)) main(int argc, char *argv[])
+{
+	int rc, fd;
+
+	if (argc < 1)
+		return -EINVAL;
+
+	fd = open(argv[1], O_RDWR);
+	rc = test_rdma(fd, LOG_DEBUG);
+	if (fd >= 0)
+		close(fd);
+	return rc;
+}
diff --git a/test/rdma.sh b/test/rdma.sh
new file mode 100755
index 000000000000..3b486d7b1680
--- /dev/null
+++ b/test/rdma.sh
@@ -0,0 +1,54 @@
+#!/bin/bash
+
+# Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of version 2 of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+
+MNT=test_dax_mnt
+FILE=image
+NDCTL="../ndctl/ndctl"
+json2var="s/[{}\",]//g; s/:/=/g"
+blockdev=""
+
+err() {
+	echo "test-rdma: failed at line $1"
+	if [ -n "$blockdev" ]; then
+		umount /dev/$blockdev
+	else
+		rc=77
+	fi
+	rmdir $MNT
+	exit $rc
+}
+
+set -e
+mkdir -p $MNT
+trap 'err $LINENO' ERR
+
+rxe_cfg stop
+rxe_cfg start
+if ! rxe_cfg status | grep -n rxe0; then
+	rxe_cfg add eth0
+fi
+
+dev=$(./dax-dev)
+json=$($NDCTL list -N -n $dev)
+eval $(echo $json | sed -e "$json2var")
+rc=1
+
+# TODO test with sparse file, and a file that needs to do unwritten
+# extent conversion
+mkfs.xfs -f /dev/$blockdev
+mount /dev/$blockdev $MNT -o dax
+dd if=/dev/zero of=$MNT/$FILE bs=1G count=1
+./rdma $MNT/$FILE
+umount $MNT
+
+exit 0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
