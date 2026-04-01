Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C14282F15
	for <nvdimm@lists.linux.dev>; Wed,  1 Apr 2026 04:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775018997; cv=none; b=vB3FYETaaoSiHR/ZMe7Qxe++gRGSGgV7TFC5xNcEsvSQ83ZS7KppdWkXqs2F217M/44cEAePvHD9RDFvhIvu/g1ckIFGHP9xu/Ho/s0l4webYqksGSBV5Lawy1WkzU8GO1+k9sUCxptnt7Y7q5WRzcRmT7vi18vO36W2sUOqscg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775018997; c=relaxed/simple;
	bh=4JshL7wW3S3ybdGtuhxNHwp8diUNssQY4gpTdK7CfKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rikGCp6GwQ/tZlArn13gLRWQNnjTx2TkdQD0JqEOqlWWD/n9eDl7ozb8XRGPVNcBCja0bl3SRxAcA9jCWcdj75iXsB9JQtgRMYizXzsJ4eqgXLxYnOYwWGFrQ7fr6rcXYeiAs7yCj+kwQhzYJx45XalgXoEa/uyoH5zvJUmbebY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dVg1OBJ5; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dVg1OBJ5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775018996; x=1806554996;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4JshL7wW3S3ybdGtuhxNHwp8diUNssQY4gpTdK7CfKM=;
  b=dVg1OBJ5D6WZwPUARZ5LPj7YOd7GdR7ooiwl+70lFo+HL73WUje0VeZA
   gU9xxH2JMeo1D2ZKslEYj4hEetsVVpjwL/C3hn0mC7HOSNLi4oivO/Kud
   OSxX7mlAzMGiCicxkzLYzumTObeIfYnXgeOmZtzNItM2Trjy91vEjRjUm
   f4X0zP32zWATY/ApdYJvv/Ne1+DRbYKfKzCUKr77Af6M/+zZIfk+QO/f/
   ngyh2FscNVgv2eboOTfG91olEoPt78T19y04jsMvmvXwP69K6Pwo6Psqt
   E/nmR9mQgSv4TA4hH4XUtKbUqs4F+vPpV0pKfyqN8woWc/dQxfMZxm9Fu
   Q==;
X-CSE-ConnectionGUID: wrLynohDTGm76s8vgzEkDw==
X-CSE-MsgGUID: j9jpYfi2Q9a3R9hBsohsMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="75218254"
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="75218254"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 21:49:54 -0700
X-CSE-ConnectionGUID: cmeAfgcOQtCS+XLopb9CwA==
X-CSE-MsgGUID: F4CMGuqRR/uxFTTeRh+gZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="249781863"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.223.4])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 21:49:54 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 2/3] test/mmap: move detailed tracing behind -v option
Date: Tue, 31 Mar 2026 21:49:46 -0700
Message-ID: <c17b7dd1d1efcb142d2b30e9a5740e4977a63788.1775018517.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <09ef1cacb6dcb0accae1756561b0f761a764aaba.1775018517.git.alison.schofield@intel.com>
References: <09ef1cacb6dcb0accae1756561b0f761a764aaba.1775018517.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mmap test helper (mmap.c) emits detailed progress and timing
information for each test case. While useful for debugging, this
output is unnecessarily verbose for all test runs.

Move the detailed tracing behind a -v option and emit only a minimal
per-run summary by default, while preserving full error reporting on
failure. This reduces log volume without changing test behavior.

Update mmap.sh to forward test arguments to the mmap helper.

Usage: meson test -C build mmap.sh --test-args='-v'

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/mmap.c  | 68 +++++++++++++++++++++++++++++++++++-----------------
 test/mmap.sh | 40 ++++++++++++++++---------------
 2 files changed, 67 insertions(+), 41 deletions(-)

diff --git a/test/mmap.c b/test/mmap.c
index 98b85fe8453e..56cc17a6d578 100644
--- a/test/mmap.c
+++ b/test/mmap.c
@@ -9,10 +9,12 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <stdarg.h>
 
 #define MiB(a)           ((a) * 1024UL * 1024UL)
 
 static struct timeval start_tv, stop_tv;
+static int verbose;
 
 // Calculate the difference between two time values.
 static void tvsub(struct timeval *tdiff, struct timeval *t1, struct timeval *t0)
@@ -39,6 +41,18 @@ static unsigned long long stop(void)
 	return (tdiff.tv_sec * 1000000 + tdiff.tv_usec);
 }
 
+static void trace(const char *fmt, ...)
+{
+	va_list ap;
+
+	if (!verbose)
+		return;
+
+	va_start(ap, fmt);
+	vprintf(fmt, ap);
+	va_end(ap);
+}
+
 static void test_write(unsigned long *p, size_t size)
 {
 	size_t i;
@@ -49,7 +63,7 @@ static void test_write(unsigned long *p, size_t size)
 	for (i=0, wp=p; i<(size/sizeof(*wp)); i++)
 		*wp++ = 1;
 	timeval = stop();
-	printf("Write: %10llu usec\n", timeval);
+	trace("Write: %10llu usec\n", timeval);
 }
 
 static void test_read(unsigned long *p, size_t size)
@@ -63,7 +77,7 @@ static void test_read(unsigned long *p, size_t size)
 		tmp = *wp++;
 	tmp = tmp;
 	timeval = stop();
-	printf("Read : %10llu usec\n", timeval);
+	trace("Read : %10llu usec\n", timeval);
 }
 
 int main(int argc, char **argv)
@@ -78,40 +92,43 @@ int main(int argc, char **argv)
 	size_t size, cpy_size;
 	const char *file_name = NULL;
 
-	while ((opt = getopt(argc, argv, "RMSApsrw")) != -1) {
+	while ((opt = getopt(argc, argv, "RMSApsrwv")) != -1) {
 		switch (opt) {
 			case 'R':
-				printf("> mmap: read-only\n");
+				trace("> mmap: read-only\n");
 				is_read_only = 1;
 				break;
 			case 'M':
-				printf("> mlock\n");
+				trace("> mlock\n");
 				is_mlock = 1;
 				break;
 			case 'S':
-				printf("> mlock - skip first iteration\n");
+				trace("> mlock - skip first iteration\n");
 				mlock_skip = 1;
 				break;
 			case 'A':
-				printf("> mlockall\n");
+				trace("> mlockall\n");
 				is_mlockall = 1;
 				break;
 			case 'p':
-				printf("> MAP_POPULATE\n");
+				trace("> MAP_POPULATE\n");
 				mflags |= MAP_POPULATE;
 				break;
 			case 's':
-				printf("> MAP_SHARED\n");
+				trace("> MAP_SHARED\n");
 				mflags |= MAP_SHARED;
 				break;
 			case 'r':
-				printf("> read-test\n");
+				trace("> read-test\n");
 				read_test = 1;
 				break;
 			case 'w':
-				printf("> write-test\n");
+				trace("> write-test\n");
 				write_test = 1;
 				break;
+			case 'v':
+				verbose = 1;
+				break;
 		}
 	}
 
@@ -122,7 +139,7 @@ int main(int argc, char **argv)
 	file_name = argv[optind];
 
 	if (!(mflags & MAP_SHARED)) {
-		printf("> MAP_PRIVATE\n");
+		trace("> MAP_PRIVATE\n");
 		mflags |= MAP_PRIVATE;
 	}
 
@@ -147,36 +164,36 @@ int main(int argc, char **argv)
 	}
 	size = stat.st_size;
 
-	printf("> open %s size %#zx flags %#x\n", file_name, size, oflags);
+	trace("> open %s size %#zx flags %#x\n", file_name, size, oflags);
 
 	ret = posix_memalign(&mptr, MiB(2), size);
 	if (ret ==0)
 		free(mptr);
 
-	printf("> mmap mprot 0x%x flags 0x%x\n", mprot, mflags);
+	trace("> mmap mprot 0x%x flags 0x%x\n", mprot, mflags);
 	p = mmap(mptr, size, mprot, mflags, fd, 0x0);
 	if (p == MAP_FAILED) {
 		perror("mmap failed");
 		return EXIT_FAILURE;
 	}
 	if ((long unsigned)p & (MiB(2)-1))
-		printf("> mmap: NOT 2MiB aligned: 0x%p\n", p);
+		trace("> mmap: NOT 2MiB aligned: 0x%p\n", p);
 	else
-		printf("> mmap: 2MiB aligned: 0x%p\n", p);
+		trace("> mmap: 2MiB aligned: 0x%p\n", p);
 
 	cpy_size = size;
 
 	for (i=0; i<3; i++) {
 
 		if (is_mlock && !mlock_skip) {
-			printf("> mlock 0x%p\n", p);
+			trace("> mlock 0x%p\n", p);
 			ret = mlock(p, size);
 			if (ret < 0) {
 				perror("mlock failed");
 				return EXIT_FAILURE;
 			}
 		} else if (is_mlockall) {
-			printf("> mlockall\n");
+			trace("> mlockall\n");
 			ret = mlockall(MCL_CURRENT|MCL_FUTURE);
 			if (ret < 0) {
 				perror("mlockall failed");
@@ -184,21 +201,21 @@ int main(int argc, char **argv)
 			}
 		}
 
-		printf("===== %d =====\n", i+1);
+		trace("===== %d =====\n", i+1);
 		if (write_test)
 			test_write(p, cpy_size);
 		if (read_test)
 			test_read(p, cpy_size);
 
 		if (is_mlock && !mlock_skip) {
-			printf("> munlock 0x%p\n", p);
+			trace("> munlock 0x%p\n", p);
 			ret = munlock(p, size);
 			if (ret < 0) {
 				perror("munlock failed");
 				return EXIT_FAILURE;
 			}
 		} else if (is_mlockall) {
-			printf("> munlockall\n");
+			trace("> munlockall\n");
 			ret = munlockall();
 			if (ret < 0) {
 				perror("munlockall failed");
@@ -210,8 +227,15 @@ int main(int argc, char **argv)
 		mlock_skip = 0;
 	}
 
-	printf("> munmap 0x%p\n", p);
+	trace("> munmap 0x%p\n", p);
 	munmap(p, size);
+	printf("mmap: ok prot=%#x flags=%#x%s%s%s%s%s\n",
+		mprot, mflags,
+		is_read_only ? " RO" : "",
+		is_mlock ? " MLOCK" : "",
+		is_mlockall ? " MLOCKALL" : "",
+		read_test ? " READ" : "",
+		write_test ? " WRITE" : "");
 	return EXIT_SUCCESS;
 }
 
diff --git a/test/mmap.sh b/test/mmap.sh
index 760257dc7f93..7d0053da0e1a 100755
--- a/test/mmap.sh
+++ b/test/mmap.sh
@@ -2,12 +2,14 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (C) 2015-2020 Intel Corporation. All rights reserved.
 
+MMAP_ARGS=("$@")
+
 . $(dirname $0)/common
 
 MNT=test_mmap_mnt
 FILE=image
 DEV=""
-TEST=$TEST_PATH/mmap
+TEST=("$TEST_PATH/mmap" "${MMAP_ARGS[@]}")
 rc=77
 
 cleanup() {
@@ -23,26 +25,26 @@ cleanup() {
 
 test_mmap() {
 	# SHARED
-	$TEST -Mrwps $MNT/$FILE     # mlock, populate, shared (mlock fail)
-	$TEST -Arwps $MNT/$FILE     # mlockall, populate, shared
-	$TEST -RMrps $MNT/$FILE     # read-only, mlock, populate, shared (mlock fail)
-	$TEST -rwps  $MNT/$FILE     # populate, shared (populate no effect)
-	$TEST -Rrps  $MNT/$FILE     # read-only populate, shared (populate no effect)
-	$TEST -Mrws  $MNT/$FILE     # mlock, shared (mlock fail)
-	$TEST -RMrs  $MNT/$FILE     # read-only, mlock, shared (mlock fail)
-	$TEST -rws   $MNT/$FILE     # shared (ok)
-	$TEST -Rrs   $MNT/$FILE     # read-only, shared (ok)
+	"${TEST[@]}" -Mrwps "$MNT/$FILE"     # mlock, populate, shared (mlock fail)
+	"${TEST[@]}" -Arwps "$MNT/$FILE"     # mlockall, populate, shared
+	"${TEST[@]}" -RMrps "$MNT/$FILE"     # read-only, mlock, populate, shared (mlock fail)
+	"${TEST[@]}" -rwps  "$MNT/$FILE"     # populate, shared (populate no effect)
+	"${TEST[@]}" -Rrps  "$MNT/$FILE"     # read-only populate, shared (populate no effect)
+	"${TEST[@]}" -Mrws  "$MNT/$FILE"     # mlock, shared (mlock fail)
+	"${TEST[@]}" -RMrs  "$MNT/$FILE"     # read-only, mlock, shared (mlock fail)
+	"${TEST[@]}" -rws   "$MNT/$FILE"     # shared (ok)
+	"${TEST[@]}" -Rrs   "$MNT/$FILE"     # read-only, shared (ok)
 
 	# PRIVATE
-	$TEST -Mrwp  $MNT/$FILE      # mlock, populate, private (ok)
-	$TEST -RMrp  $MNT/$FILE      # read-only, mlock, populate, private (mlock fail)
-	$TEST -rwp   $MNT/$FILE      # populate, private (ok)
-	$TEST -Rrp   $MNT/$FILE      # read-only, populate, private (populate no effect)
-	$TEST -Mrw   $MNT/$FILE      # mlock, private (ok)
-	$TEST -RMr   $MNT/$FILE      # read-only, mlock, private (mlock fail)
-	$TEST -MSr   $MNT/$FILE      # private, read before mlock (ok)
-	$TEST -rw    $MNT/$FILE      # private (ok)
-	$TEST -Rr    $MNT/$FILE      # read-only, private (ok)
+	"${TEST[@]}" -Mrwp  "$MNT/$FILE"     # mlock, populate, private (ok)
+	"${TEST[@]}" -RMrp  "$MNT/$FILE"     # read-only, mlock, populate, private (mlock fail)
+	"${TEST[@]}" -rwp   "$MNT/$FILE"     # populate, private (ok)
+	"${TEST[@]}" -Rrp   "$MNT/$FILE"     # read-only, populate, private (populate no effect)
+	"${TEST[@]}" -Mrw   "$MNT/$FILE"     # mlock, private (ok)
+	"${TEST[@]}" -RMr   "$MNT/$FILE"     # read-only, mlock, private (mlock fail)
+	"${TEST[@]}" -MSr   "$MNT/$FILE"     # private, read before mlock (ok)
+	"${TEST[@]}" -rw    "$MNT/$FILE"     # private (ok)
+	"${TEST[@]}" -Rr    "$MNT/$FILE"     # read-only, private (ok)
 }
 
 set -e
-- 
2.37.3

