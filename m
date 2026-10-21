Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.117.225.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792606274;
	b=DXEvlKCmnl0HuzFBF31gyat+jBLICCivzjShErxrOebQ+eU6b1NPlvEkVjShbfCl15uw
	 z9seWsic6M3LdV7r4wSuo1K7/qtbG6QoTlGjhG4TY4SaYtQHfnPyIDiCv3JwxOyE9ci5t
	 n8AfEiTwtgxN5uY7HhmyqBEJxAhololOBanju4Gf61blSkhA6rNEPNPwiK+cMqWkNJb2J
	 1nZk9BTAaGX79dwFjYKCXjahGLklGkgN2Ele95r8RpuH82yzTDZAyEnW/kADNaJTdvWBe
	 n5b2qsmF4H2a3+9HwWNpySy0Jde9W58LCc0Qkq09zA2qSaugfRWFFrYl2GRTrOk0bOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792606274;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=OsbhucexF+rcBAfrmOODWfn/JuMdIRafkiiNr+d0yZw=;
	b=XvEixtOKgOdxyGgY6Nh1chO0+eHNMSiH4cXoI8B1yFH82GObCjR/DARTK0JDXF2zMdiL
	 fLbknDJSfqdYu4ASwwPYpWSv8zoilwEPG1R6Lpz42KFeeptbvofXB5Su7aDcLFqOZPArF
	 R/jp5asLYOuA1LXb5mDVoA0rRL3jWi95PSpeukE2dDLpO90gH1WbCLSbViY4DITqfoOVt
	 +chl7eX3EyTla065JKBWpvIb0Z7ZB3n9Unybj+niBvIqrCiiy9cpAogGRF63BrvEL+qF1
	 fotabhUo72xCiLtm5sNLG9gPKh9bxCFxZTVWU0OTfth3J4Og1shTodEg+kID6Edq0qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=bphzNDuF;
	arc=none smtp.remote-ip=130.117.225.111
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63631606A31B;
	Wed, 21 Oct 2026 18:11:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63631606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=bphzNDuF
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=OsbhucexF+rcBAfrmOODWfn/JuMdIRafkiiNr+d0yZw=; b=bphzNDuFUs70GthFHdh
	VBWynZ5FxsGz8H4TEAMcQbU66HWmWkxqvBKaBHRMr5N/qcZVhuXAeMxThsyY+8trgi4n8eVV3KAoF
	3CRXP4gGNAMAG7UXd86ASLhrnylNtfHdUqGtO2o8L8qDVaZ8xTr56LCsNkqg7KDWkgQuLKQT33DSi
	Fnkt3VcWjQCQGhRQQTURXt0Pk7vNjujYMY9JM0WFYt06lRNoBZHP2Nz4RKnu820DwqJt8ESeQOHrZ
	7p8hXfJKPMuubxsW3/0y0V087C8afnPWHHHwXvgh+2q93m22pJZ9hgQWUNpxRv1aj7izo4U5RIesJ
	8jBspQL3QkZFdbQ==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xJaif-00ANvl-3C;
	Wed, 21 Oct 2026 20:11:04 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 21 Oct 2026 20:10:54 +0200
Subject: [PATCH 2/2] selftests/mm: test fork of a device DAX PUD
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
Message-Id: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-2-8bd88551f9be@virtuozzo.com>
References: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com>
In-Reply-To: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6368;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=BeNA8ETryoYJiw28wyqlB0gBoEmrqSoabqrZQEIon90=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq2QA4NM4cK0BSXBvs719jhs+keVlGRHdHBjcML
 wTBgkR55mCJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCatkAOAAKCRBRlgpH+WFc
 KtfAD/9QxPEoE+F/QytUzjVMxLm6TvuTIS+leZuqy1dsU6rztem0HhWwd5w4656mYyhJVWZFtPE
 P84j2qHMDV2/6LfwwCPP6BoVMolw0BAbKKeqVPAPQ+2Fj3lkfttcskPevVlHeqZxvRSV6pcVOf/
 VSjHJ3bAkiPZrywR9k1B7N0nA6+uvj5WEQf3uno73/RMT5vH/jABaRxfhLQb2EywjclU41G6iYq
 wLrPPmpToN0oIR0Y2d+OqqZsIyqbgi66kRIiYCFeNXg4Si8LVmfqTs+4DiO1B/l6d/u7Du8R/9d
 A73Sqicb8snS3pbCF9H2Guw6wR43/Dm9t58PK2WGbB1NssBF8OmKhreg8G2ovYf7pJVE6M8Tatw
 K7EIlTnl6IqXcFsNWKBdGy25i+kMYUFXQP3c+Xs2Yzwst67zy72nIZ1vy9JUTZUqE/0V4T4JPiX
 i/AUgo691TA6rzytxstQCYFeuzxYtcnAHSnPxaoVGPTLbYk2t9WhhlBtyUWaL+b1CoBfC571CJC
 V3TZ9b2frpEy7Yx2bSaLXwPVSMfzyeeoYnHSTNuxgsqbFr0DNy86yyA9+WpF7NZoEuE5qERUB80
 Woob7YObg2T/Wh5Bpg4MvDMBhFCsP5QYXPHd2E/bV5WVbN/nHVyUUkDtq71wlRVSfNVB/XUsui6
 zvYyybekvCWG2tw==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

Fork a process that maps a device DAX instance with a PUD, in a VMA
whose page tables fork copies because it has a guard region. The child
must account the copied PUD in its RssFile.

Without a reference, an rmap and a counter for the copied PUD, the
child's RssFile misses the PUD, and its exit leaves the child's file
counter negative: "Bad rss-counter state".

It runs only on a device named in argv[1] or $FORK_DAX_PUD_DEVICE: on
a kernel without the fix it leaves the device folio's mapcount below
zero.

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 MAINTAINERS                               |   1 +
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/fork_dax_pud.c | 136 ++++++++++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |   1 +
 4 files changed, 139 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7b5cab72d851b..48653704007f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17481,6 +17481,7 @@ F:	include/trace/events/huge_memory.h
 F:	mm/huge_memory.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
+F:	tools/testing/selftests/mm/fork_dax_pud.c
 F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
 F:	tools/testing/selftests/mm/transhuge-stress.c
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 2d5366196e309..86914aaf8e6ad 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -104,6 +104,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
+TEST_GEN_FILES += fork_dax_pud
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/fork_dax_pud.c b/tools/testing/selftests/mm/fork_dax_pud.c
new file mode 100644
index 0000000000000..1fcf46341ace2
--- /dev/null
+++ b/tools/testing/selftests/mm/fork_dax_pud.c
@@ -0,0 +1,136 @@
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
+static unsigned long sysfs_ul(const char *dev, const char *attr)
+{
+	char path[PATH_MAX], buf[64];
+	unsigned long val = 0;
+	FILE *f;
+
+	snprintf(path, sizeof(path), DAX_SYSFS "/%s/%s", dev, attr);
+	f = fopen(path, "r");
+	if (!f)
+		return 0;
+	if (fgets(buf, sizeof(buf), f))
+		val = strtoul(buf, NULL, 0);
+	fclose(f);
+	return val;
+}
+
+static bool dax_dev_ok(const char *path)
+{
+	const char *name = strrchr(path, '/');
+
+	name = name ? name + 1 : path;
+	return sysfs_ul(name, "align") == SZ_1G &&
+	       sysfs_ul(name, "size") >= 2 * SZ_1G;
+}
+
+static long rss_file_kb(void)
+{
+	char line[256];
+	long kb = -1;
+	FILE *f = fopen("/proc/self/status", "r");
+
+	if (!f)
+		return -1;
+	while (fgets(line, sizeof(line), f))
+		if (sscanf(line, "RssFile: %ld", &kb) == 1)
+			break;
+	fclose(f);
+	return kb;
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
+		_exit(rss_file_kb() < (long)(SZ_1G >> 10) ? 10 : 0);
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
index d09f9f6a384ee..7294e1334d1da 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -445,6 +445,7 @@ fi
 CATEGORY="thp" run_test ./transhuge-stress -d 20
 
 CATEGORY="thp" run_test ./folio_split_race_test
+CATEGORY="thp" run_test ./fork_dax_pud
 
 CATEGORY="migration" run_test ./migration
 

-- 
2.43.0

