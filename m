Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 66FFD2194D3B3
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 21:41:21 -0700 (PDT)
Subject: [ndctl PATCH] test,
 device-dax: Fix intermittent poison handling failures
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 12 Oct 2018 21:29:32 -0700
Message-ID: <153940497244.1425803.2319137619591631976.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The device-dax unit test sometimes fails with the following kernel
message signature:

     Memory failure: Unable to find user space address 204300 in lt-device-dax
     Memory failure: 0x204300: forcibly killing lt-device-dax:1334 because of failure to unmap

This happens when there is a 3rd party vma in the rmap that has an entry
at the same index as the currently failing page. While the test has
munmap()'d the previous mapping we still trip over the fact that the
kernel memory-failure code does not differentiate munmap vs mremap and
upgrades the failure to process fatal.

The add_to_kill() routine in the kernel has a comment that says:

        /*
         * In theory we don't have to kill when the page was
         * munmaped. But it could be also a mremap. Since that's
         * likely very rare kill anyways just out of paranoia, but use
         * a SIGKILL because the error is not contained anymore.
         */

...when it is determining what to do when it can't find the given pfn
mapped into the process at the given index.

Avoid this case by munmap()'ing *and* closing the file to trigger old /
stale vma's to be reaped. With that the only vma that can be looked up
is the one the error was injected, the lookup succeeds, and the test
passes.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/device-dax.c |   49 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/test/device-dax.c b/test/device-dax.c
index 46580fcbaae3..b19c1ed0b535 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -244,23 +244,8 @@ static int __test_device_dax(unsigned long align, int loglevel,
 	if (rc)
 		goto out;
 
-	/* upgrade to a writable mapping */
 	close(fd);
 	munmap(buf, VERIFY_SIZE(align));
-	fd = open(path, O_RDWR);
-	if (fd < 0) {
-		fprintf(stderr, "%s: failed to open(O_RDWR) device-dax instance\n",
-				daxctl_dev_get_devname(dev));
-		rc = -ENXIO;
-		goto out;
-	}
-
-	buf = mmap(NULL, VERIFY_SIZE(align), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
-	if (buf == MAP_FAILED) {
-		fprintf(stderr, "%s: expected PROT_WRITE + MAP_SHARED success\n",
-				path);
-		return -ENXIO;
-	}
 
 	/*
 	 * Prior to 4.8-final these tests cause crashes, or are
@@ -270,21 +255,39 @@ static int __test_device_dax(unsigned long align, int loglevel,
 		static const bool devdax = false;
 		int fd2;
 
+		fd = open(path, O_RDWR);
+		if (fd < 0) {
+			fprintf(stderr, "%s: failed to open for direct-io test\n",
+					daxctl_dev_get_devname(dev));
+			rc = -ENXIO;
+			goto out;
+		}
 		rc = test_dax_directio(fd, align, NULL, 0);
 		if (rc) {
 			fprintf(stderr, "%s: failed dax direct-i/o\n",
 					ndctl_namespace_get_devname(ndns));
 			goto out;
 		}
+		close(fd);
 
 		fprintf(stderr, "%s: test dax poison\n",
 				ndctl_namespace_get_devname(ndns));
+
+		fd = open(path, O_RDWR);
+		if (fd < 0) {
+			fprintf(stderr, "%s: failed to open for poison test\n",
+					daxctl_dev_get_devname(dev));
+			rc = -ENXIO;
+			goto out;
+		}
+
 		rc = test_dax_poison(test, fd, align, NULL, 0, devdax);
 		if (rc) {
 			fprintf(stderr, "%s: failed dax poison\n",
 					ndctl_namespace_get_devname(ndns));
 			goto out;
 		}
+		close(fd);
 
 		fd2 = open("/proc/self/smaps", O_RDONLY);
 		if (fd2 < 0) {
@@ -306,6 +309,22 @@ static int __test_device_dax(unsigned long align, int loglevel,
 		}
 	}
 
+	/* establish a writable mapping */
+	fd = open(path, O_RDWR);
+	if (fd < 0) {
+		fprintf(stderr, "%s: failed to open(O_RDWR) device-dax instance\n",
+				daxctl_dev_get_devname(dev));
+		rc = -ENXIO;
+		goto out;
+	}
+
+	buf = mmap(NULL, VERIFY_SIZE(align), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (buf == MAP_FAILED) {
+		fprintf(stderr, "%s: expected PROT_WRITE + MAP_SHARED success\n",
+				path);
+		return -ENXIO;
+	}
+
 	rc = reset_device_dax(ndns);
 	if (rc < 0) {
 		fprintf(stderr, "%s: failed to reset device-dax instance\n",

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
