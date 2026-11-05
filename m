Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.117.225.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793898065;
	b=bAoVySWQTGgzvSgq+QaptdKn68A/tqoj9dHCh9uLKB3iYMF+yqHvT/P0vOLPvvfjU4gV
	 UyzgsQOPmzaiDj1ywI4fC83gHHvsOJoxBJ2Fy0HNyB/UmcEyw/KenfVUB+AhAYUEy/VCg
	 tonlcx1+8l7sFxYTWYn446ax26A7Us64Cq+BxvDH0wh5XQIpqsf6isj4UR9LfeTpKnuew
	 mxASW9tLR89ihzkXOlwp0xAyOgpG9TqdoE8wrueevqCZ4YOI2vuaV2I0WI6w/+OYOmj0a
	 DYtyZiYrYikhpmXPPcpd5nyHahUYOJMLOD08HsgG2vzvfaZtWWIqLHUqwSubXxkg1+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793898065;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=HXXxntw3N6+3r5el/S4fsYJZf+fwgZXF2ZkkHndaSJY=;
	b=o9uYJUK+4WKMf4Kw2ofdViC9DxvBtdD9WYzu0M5u5p+mA2H9KoYqZ5g7VBMzq/O6evUr
	 /GUA29drHnWeQo9CLFJeLhOcLMpT7yQtgLoj8jbiE4Ckq6gTsBGIHkFQHclCvWaw7EvEW
	 VqeeMy3aI8odDNqLpjks/pXItKdoncjsWjNXeg0LAfHA4Qm/mrTUD0lY0+ssdz3FdFGnq
	 z0I6ulT7olD/8FwX/Vfcmo59tzu+6L18fYRogWJEkST+CmVgiyFXmMrC0bObQ6+lJzUcJ
	 p/dckwLZGT//+jyRcmj6Qv7rO1WA9CKTNoxaat5RE52IwzXwEMf0nqGooVvUYLue8cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=Z3FcGatH;
	arc=none smtp.remote-ip=130.117.225.111
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83D6606EE8D;
	Thu,  5 Nov 2026 17:01:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C83D6606EE8D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=Z3FcGatH
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=HXXxntw3N6+3r5el/S4fsYJZf+fwgZXF2ZkkHndaSJY=; b=Z3FcGatHAmaaMtTHFGN
	XRUyTO+7PgR0al+9t1V7X7qmHf5Z08XOxG1RSLEN6Cr8EWF4464PRc9RYRxotf3rG+1+TrBa0EH7k
	ptAyz5RrsiL0OifZuZdfFr5ISPEtBylEa+zc26BAQotyN7LExk4vPPwynl7K/PxfjW93/tbcghysR
	hk735R3qP6NwzC2zGYCzzibPj7BePtmlg51aZnDVTPR/VW/vqN/ZRAS+/KJ+8cGSKDhcEnToznfBj
	vP64c0U59MHgrzjWGUcfiIBlN9OgAun0dgyUUnbnI9Vk0mys0y+28AKNtua5aJ/0tnl8oleTEGU0n
	YRpufY5gE+WcwZg==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xP0li-005CiT-2t;
	Thu, 05 Nov 2026 18:00:59 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Thu, 05 Nov 2026 18:00:56 +0100
Subject: [PATCH v2 2/2] selftests/mm: test fork of a device DAX PUD
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-2-2828fe5a51ed@virtuozzo.com>
References: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com>
In-Reply-To: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Alistair Popple <apopple@nvidia.com>, 
 Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7747;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=08EkarCEIEU5kIOHQdB4jlyKF81Hi6noy3uR2a632eY=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq7LZL26cjP6Wh4UNkG9Nb1lmj8H9MsnrOZeb5x
 aBPVplukC2JAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCauy2SwAKCRBRlgpH+WFc
 KohtD/0WthLTe4ESLs4C0KYSFBzHyQbTJCyb1otLGqDQ5bsZeBvyUo2vXimwnLwhIcVzSL1Krmn
 0/fivjrThWzM4DTj0DuugHuZ3OuKTpHTxHrvP439CAYRiyWYfMA+FYtlUfTJMdzzYuO6+2GRuRx
 bVf+GLj95tFFnG2BZHYkkh/S03t4pd5IM2KXy2rYUqOO3zqg+AMcbqj1QEs0H+TebEqxV5RrRJk
 VkOAfQMjq1OBBUq/6OsB6Z0j0wNlacN0UMQdkB6g3eCHNOKbXI0MMPmIVQwhrfEl7hZcpR9OASl
 txwZwkRKa7tX0/fVfL/mze9C5rX/TnQ3aJ7tooAVvy3CWA9fWKRT3YUFJVNtqLoCNLVVBmNTTak
 oyh3unKjKuMBZEpX4/m6RCYhyzoh4BqGsdHTYITfjJghzCDaFdfvpHAEBzlnXG4IDBjBMavLM9P
 VoEg2OXCTIyZrzVu/oqs+srtg4N7h96ZMwbwWHffGDsnVXeJOzxipn22JOv3U1Kb+DHlAHXAkVJ
 Q8n0bx8T2zoa6Hd4E8hjoxfMLGK70D6PzSfxADJN037UG5lnwVRDfoknC5l+0AroQ0/HfiM1giN
 TA+J6Yyn9+5TExYfVXl/U40DlQyGLBMuYEffTNtx/VwAFloYVJTGwNEzohvDQ3bv9BAS/LO9W4x
 CGkDqsteJqTGKKA==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

Fork a process that maps a device DAX instance with a PUD, in a VMA
whose page tables fork copies because it has a guard region. The child
must account the copied PUD in its RssFile, which a new rss_file() in
vm_util reads as rss_anon() reads RssAnon.

Without a reference, an rmap and a counter for the copied PUD, the
child's RssFile misses the PUD, and its exit leaves the child's file
counter negative: "Bad rss-counter state".

It runs only on a device named in argv[1] or $FORK_DAX_PUD_DEVICE: on
a kernel without the fix it leaves the device folio's mapcount below
zero.

Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 MAINTAINERS                               |   1 +
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/fork_dax_pud.c | 114 ++++++++++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |   1 +
 tools/testing/selftests/mm/vm_util.c      |  21 ++++++
 tools/testing/selftests/mm/vm_util.h      |   1 +
 6 files changed, 139 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d63d8b2152773..247e16f3276f4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17931,6 +17931,7 @@ F:	mm/huge_memory.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
 F:	tools/mm/thpmaps
+F:	tools/testing/selftests/mm/fork_dax_pud.c
 F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
 F:	tools/testing/selftests/mm/transhuge-stress.c
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 0ea72e9979347..130500f5f6e0a 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -108,6 +108,7 @@ TEST_GEN_FILES += folio_split_race_test
 TEST_GEN_FILES += folio_order_check
 TEST_GEN_FILES += khugepaged_sync_check
 TEST_GEN_FILES += khugepaged_race
+TEST_GEN_FILES += fork_dax_pud
 TEST_GEN_FILES += soft-dirty
 
 ifeq ($(ARCH),x86_64)
diff --git a/tools/testing/selftests/mm/fork_dax_pud.c b/tools/testing/selftests/mm/fork_dax_pud.c
new file mode 100644
index 0000000000000..0d19c30b1dc6f
--- /dev/null
+++ b/tools/testing/selftests/mm/fork_dax_pud.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * fork() of a process that maps a device DAX instance with a PUD, in a VMA
+ * whose page tables fork copies because it has a guard region. The child
+ * must account the copied PUD in its RssFile.
+ *
+ * Runs only on a device named in argv[1] or $FORK_DAX_PUD_DEVICE that
+ * nothing else maps, with 1 GiB alignment and at least 2 GiB. To make one
+ * on pmem emulated in RAM, with CONFIG_X86_PMEM_LEGACY and
+ * CONFIG_DEV_DAX_PMEM:
+ *
+ *	boot with memmap=3G!4G
+ *	ndctl create-namespace -f -e namespace0.0 -m devdax -a 1G
+ *	FORK_DAX_PUD_DEVICE=/dev/dax0.0 ./fork_dax_pud
+ */
+#define _GNU_SOURCE
+#include <asm-generic/mman.h> /* Force the import of the tools version. */
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <setjmp.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
+
+#include "kselftest.h"
+#include "vm_util.h"
+
+#define SZ_1G		(1UL << 30)
+#define DAX_SYSFS	"/sys/bus/dax/devices"
+
+static sigjmp_buf sigbus_jmp;
+
+static void sigbus_handler(int sig)
+{
+	siglongjmp(sigbus_jmp, 1);
+}
+
+static bool dax_attr(const char *dev, const char *attr, unsigned long *val)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, sizeof(path), DAX_SYSFS "/%s/%s", dev, attr);
+	return !read_sysfs(path, val);
+}
+
+static bool dax_dev_ok(const char *path)
+{
+	const char *name = strrchr(path, '/');
+	unsigned long align, size;
+
+	name = name ? name + 1 : path;
+	return dax_attr(name, "align", &align) && align == SZ_1G &&
+	       dax_attr(name, "size", &size) && size >= 2 * SZ_1G;
+}
+
+int main(int argc, char **argv)
+{
+	const char *path = argc > 1 ? argv[1] : getenv("FORK_DAX_PUD_DEVICE");
+	char *area, *mem;
+	int fd, status;
+	pid_t pid;
+
+	ksft_print_header();
+	if (!path)
+		ksft_exit_skip("no devdax device given\n");
+	if (!dax_dev_ok(path))
+		ksft_exit_skip("%s: needs 1 GiB alignment and 2 GiB\n", path);
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		ksft_exit_skip("%s: %s\n", path, strerror(errno));
+	area = mmap(NULL, 3 * SZ_1G, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (area == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
+	mem = (char *)(((unsigned long)area + SZ_1G - 1) & ~(SZ_1G - 1));
+	mem = mmap(mem, 2 * SZ_1G, PROT_READ, MAP_SHARED | MAP_FIXED, fd, 0);
+	if (mem == MAP_FAILED)
+		ksft_exit_skip("mmap %s: %s\n", path, strerror(errno));
+
+	/* A PUD in the first GiB, a guard page at the end of the second. */
+	signal(SIGBUS, sigbus_handler);
+	if (sigsetjmp(sigbus_jmp, 1))
+		ksft_exit_skip("%s cannot be mapped with a PUD\n", path);
+	FORCE_READ(mem[0]);
+	signal(SIGBUS, SIG_DFL);
+	if (madvise(mem + 2 * SZ_1G - getpagesize(), getpagesize(),
+		    MADV_GUARD_INSTALL))
+		ksft_exit_skip("MADV_GUARD_INSTALL: %s\n", strerror(errno));
+
+	ksft_set_plan(1);
+	fflush(stdout);
+	pid = fork();
+	if (pid < 0)
+		ksft_exit_fail_perror("fork");
+	if (!pid)
+		_exit(rss_file() < (SZ_1G >> 10) ? 10 : 0);
+	if (waitpid(pid, &status, 0) != pid)
+		ksft_exit_fail_perror("waitpid");
+
+	if (!WIFEXITED(status) || WEXITSTATUS(status))
+		ksft_test_result_fail("child does not account the copied PUD\n");
+	else
+		ksft_test_result_pass("devdax PUD copied by fork\n");
+
+	munmap(area, 3 * SZ_1G);
+	close(fd);
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index a1b45a3dedaee..0d5f3b325e84b 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -433,6 +433,7 @@ fi
 CATEGORY="thp" run_test ./transhuge-stress -d 20
 
 CATEGORY="thp" run_test ./folio_split_race_test
+CATEGORY="thp" run_test ./fork_dax_pud
 
 CATEGORY="migration" run_test ./migration
 
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 515031b8283da..1407ef83d44eb 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -197,6 +197,27 @@ unsigned long rss_anon(void)
 	return rss_anon;
 }
 
+unsigned long rss_file(void)
+{
+	unsigned long rss_file = 0;
+	FILE *fp;
+	char buffer[MAX_LINE_LENGTH];
+
+	fp = fopen(STATUS_FILE_PATH, "r");
+	if (!fp)
+		ksft_exit_fail_msg("%s: Failed to open file %s\n", __func__, STATUS_FILE_PATH);
+
+	if (!check_for_pattern(fp, "RssFile:", buffer, sizeof(buffer)))
+		goto err_out;
+
+	if (sscanf(buffer, "RssFile:%10lu kB", &rss_file) != 1)
+		ksft_exit_fail_msg("Reading status error\n");
+
+err_out:
+	fclose(fp);
+	return rss_file;
+}
+
 static int vaddr_pageflags_get(char *vaddr, int pagemap_fd, int kpageflags_fd,
 		uint64_t *flags)
 {
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index b5d59729d4327..211f9f6699231 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -94,6 +94,7 @@ void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
 uint64_t read_pmd_pagesize(void);
 unsigned long rss_anon(void);
+unsigned long rss_file(void);
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);

-- 
2.43.0

