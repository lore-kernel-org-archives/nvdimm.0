From: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/4] src/t_mmap_dio: add mmap dio test
Date: Wed, 18 Jan 2017 11:07:04 +0800
Message-ID: <1484708826-23529-3-git-send-email-xzhou@redhat.com>
References: <1484708826-23529-1-git-send-email-xzhou@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1484708826-23529-1-git-send-email-xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

To test read/write between a mmap area of one file
and another file directly, with different size.

Signed-off-by: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 .gitignore       |  1 +
 src/Makefile     |  2 +-
 src/t_mmap_dio.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+), 1 deletion(-)
 create mode 100644 src/t_mmap_dio.c

diff --git a/.gitignore b/.gitignore
index 7dcea14..48a40a0 100644
--- a/.gitignore
+++ b/.gitignore
@@ -129,6 +129,7 @@
 /src/cloner
 /src/renameat2
 /src/t_rename_overwrite
+/src/t_mmap_dio
 
 # dmapi/ binaries
 /dmapi/src/common/cmd/read_invis
diff --git a/src/Makefile b/src/Makefile
index 94d74aa..eb5a56c 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -12,7 +12,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	godown resvtest writemod makeextents itrash rename \
 	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
 	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
-	holetest t_truncate_self
+	holetest t_truncate_self t_mmap_dio
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/t_mmap_dio.c b/src/t_mmap_dio.c
new file mode 100644
index 0000000..545e900
--- /dev/null
+++ b/src/t_mmap_dio.c
@@ -0,0 +1,81 @@
+/*
+ * This programme was originally written by
+ *     Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
+ */
+#define _GNU_SOURCE 1
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/mman.h>
+#include <libaio.h>
+#include <errno.h>
+#include <sys/time.h>
+
+void usage(char *prog)
+{
+	fprintf(stderr,
+		"usage: %s <source file> <dest file> <test size>\n",
+		prog);
+	exit(1);
+}
+
+void err_exit(char *op, unsigned long len)
+{
+	fprintf(stderr, "%s(%s) len %lu\n",
+		op, strerror(errno), len);
+	exit(1);
+}
+
+int main(int argc, char **argv)
+{
+	int fd, fd2, ret;
+	char *map;
+	unsigned long len;
+
+	if (argc < 3)
+		usage(basename(argv[0]));
+
+	len = strtoul(argv[3], NULL, 10);
+	if (errno == ERANGE)
+		err_exit("strtoul", 0);
+
+	/* Open source file and mmap*/
+	fd = open(argv[1], O_RDWR, 0644);
+	if (fd < 0)
+		err_exit("open s", len);
+
+	map = (char *)mmap(NULL, len,
+		PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (map == MAP_FAILED)
+		err_exit("mmap", len);
+
+	/* Open dest file with O_DIRECT */
+	fd2 = open(argv[2], O_RDWR|O_DIRECT, 0644);
+	if (fd2 < 0)
+		err_exit("open d", len);
+
+	/* First, test storing to dest file from source mapping */
+	ret = write(fd2, map, len);
+	if (ret != len)
+		err_exit("write", len);
+
+	ret = (int)lseek(fd2, 0, SEEK_SET);
+	if (ret == -1)
+		err_exit("lseek", len);
+
+	/* Next, test reading from dest file into source mapping */
+	ret = read(fd2, map, len);
+	if (ret != len)
+		err_exit("read", len);
+	ret = msync(map, len, MS_SYNC);
+	if (ret < 0)
+		err_exit("msync", len);
+
+	ret = munmap(map, len);
+	if (ret < 0)
+		err_exit("munmap", len);
+
+	exit(0);
+}
-- 
1.8.3.1
