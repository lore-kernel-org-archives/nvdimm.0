Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6322821CA35B8
 for <linux-nvdimm@lists.01.org>; Thu, 15 Jun 2017 15:41:26 -0700 (PDT)
Subject: [PATCH] ndctl: daxctl: Adding io option for daxctl
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 15 Jun 2017 15:42:30 -0700
Message-ID: <149756654995.49071.10157586966796129090.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The daxctl io option allows I/Os to be performed between block/file to
and from device dax files. It also provides a way to zero a device dax
device.

i.e. daxctl io --input=/home/myfile --output=/dev/dax1.0

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/Makefile.am   |    3 
 Documentation/daxctl-io.txt |   71 +++++
 daxctl/Makefile.am          |    5 
 daxctl/daxctl.c             |    2 
 daxctl/io.c                 |  567 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 646 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/daxctl-io.txt
 create mode 100644 daxctl/io.c

diff --git a/Documentation/Makefile.am b/Documentation/Makefile.am
index c7e0758..8efdbc2 100644
--- a/Documentation/Makefile.am
+++ b/Documentation/Makefile.am
@@ -26,7 +26,8 @@ man1_MANS = \
 	ndctl-destroy-namespace.1 \
 	ndctl-check-namespace.1 \
 	ndctl-list.1 \
-	daxctl-list.1
+	daxctl-list.1 \
+	daxctl-io.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/daxctl-io.txt b/Documentation/daxctl-io.txt
new file mode 100644
index 0000000..c3ddd15
--- /dev/null
+++ b/Documentation/daxctl-io.txt
@@ -0,0 +1,71 @@
+daxctl-io(1)
+===========
+
+NAME
+----
+daxctl-io - Perform I/O on Device-DAX devices or zero a Device-DAX device.
+
+SYNOPSIS
+--------
+[verse]
+'daxctl io' [<options>]
+
+There must be a Device-DAX device involved whether as the input or the output
+device. Read from a Device-DAX device and write to a file, a block device,
+another Device-DAX device, or stdout (if no output is provided). Write
+to a Device-DAX device from a file, a block device, or stdin, or another
+Device-DAX device.
+
+No length specified will default to input file/device length. If input is
+a special char file then length will be the output file/device length.
+
+No input will default to stdin. No output will default to stdout.
+
+For a Device-DAX device, attempts to clear badblocks within range of writes
+will be performed.
+
+EXAMPLE
+-------
+[verse]
+# daxctl io --zero /dev/dax1.0
+
+# daxctl io --input=/dev/dax1.0 --output=/home/myfile --len=2097152 --seek=4096
+
+# cat /dev/zero | daxctl io --output=/dev/dax1.0
+
+# daxctl io --input=/dev/zero --output=/dev/dax1.0 --skip=4096
+
+OPTIONS
+-------
+-i::
+--input=::
+	Input device or file to read from.
+
+-o::
+--output=::
+	Output device or file to write to.
+
+-z::
+--zero::
+	Zero the output device for 'len' size. Or the entire device if no
+	length was provided. The output device must be a Device DAX device.
+
+-l::
+--len::
+	The length in bytes to perform the I/O.
+
+-s::
+--seek::
+	The number of bytes to skip over on the output before performing a
+	write.
+
+-k::
+--skip::
+	The number of bytes to skip over on the input before performing a read.
+
+COPYRIGHT
+---------
+Copyright (c) 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
index fe467d0..1ba1f07 100644
--- a/daxctl/Makefile.am
+++ b/daxctl/Makefile.am
@@ -5,10 +5,13 @@ bin_PROGRAMS = daxctl
 daxctl_SOURCES =\
 		daxctl.c \
 		list.c \
+		io.c \
 		../util/json.c
 
 daxctl_LDADD =\
 	lib/libdaxctl.la \
+	../ndctl/lib/libndctl.la \
 	../libutil.a \
 	$(UUID_LIBS) \
-	$(JSON_LIBS)
+	$(JSON_LIBS) \
+	-lpmem
diff --git a/daxctl/daxctl.c b/daxctl/daxctl.c
index 91a4600..db2e495 100644
--- a/daxctl/daxctl.c
+++ b/daxctl/daxctl.c
@@ -67,11 +67,13 @@ static int cmd_help(int argc, const char **argv, void *ctx)
 }
 
 int cmd_list(int argc, const char **argv, void *ctx);
+int cmd_io(int argc, const char **argv, void *ctx);
 
 static struct cmd_struct commands[] = {
 	{ "version", cmd_version },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
+	{ "io", cmd_io },
 };
 
 int main(int argc, const char **argv)
diff --git a/daxctl/io.c b/daxctl/io.c
new file mode 100644
index 0000000..92e2878
--- /dev/null
+++ b/daxctl/io.c
@@ -0,0 +1,567 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/sysmacros.h>
+#include <sys/param.h>
+#include <sys/mman.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <limits.h>
+#include <libgen.h>
+#include <libpmem.h>
+#include <util/json.h>
+#include <util/filter.h>
+#include <json-c/json.h>
+#include <daxctl/libdaxctl.h>
+#include <ccan/short_types/short_types.h>
+#include <util/parse-options.h>
+#include <ccan/array_size/array_size.h>
+#include <ndctl/ndctl.h>
+
+enum io_direction {
+	IO_READ = 0,
+	IO_WRITE,
+};
+
+struct io_dev {
+	int fd;
+	int major;
+	int minor;
+	void *mmap;
+	const char *parm_path;
+	char *real_path;
+	uint64_t offset;
+	enum io_direction direction;
+	bool is_dax;
+	bool is_char;
+	bool is_new;
+	bool need_trunc;
+	struct ndctl_ctx *ndctx;
+	struct ndctl_region *region;
+	struct ndctl_dax *dax;
+	uint64_t size;
+};
+
+static struct {
+	struct io_dev dev[2];
+	bool zero;
+	uint64_t len;
+	struct ndctl_cmd *ars_cap;
+	struct ndctl_cmd *clear_err;
+} io = {
+	.dev[0].fd = -1,
+	.dev[1].fd = -1,
+};
+
+#define fail(fmt, ...) \
+do { \
+	fprintf(stderr, "daxctl-%s:%s:%d: " fmt, \
+			VERSION, __func__, __LINE__, ##__VA_ARGS__); \
+} while (0)
+
+static bool is_stdinout(struct io_dev *io_dev)
+{
+	return (io_dev->fd == STDIN_FILENO ||
+			io_dev->fd == STDOUT_FILENO) ? true : false;
+}
+
+static int setup_device(struct io_dev *io_dev, struct ndctl_ctx *ctx,
+		size_t size)
+{
+	int flags, rc;
+
+	if (is_stdinout(io_dev))
+		return 0;
+
+	if (io_dev->is_new)
+		flags = O_CREAT|O_WRONLY|O_TRUNC;
+	else if (io_dev->need_trunc)
+		flags = O_RDWR | O_TRUNC;
+	else
+		flags = O_RDWR;
+
+	io_dev->fd = open(io_dev->parm_path, flags, S_IRUSR|S_IWUSR);
+	if (io_dev->fd == -1) {
+		rc = -errno;
+		perror("open");
+		return rc;
+	}
+
+	if (!io_dev->is_dax)
+		return 0;
+
+	flags = (io_dev->direction == IO_READ) ? PROT_READ : PROT_WRITE;
+	io_dev->mmap = mmap(NULL, size, flags, MAP_SHARED, io_dev->fd, 0);
+	if (io_dev->mmap == MAP_FAILED) {
+		rc = -errno;
+		perror("mmap");
+		return rc;
+	}
+
+	return 0;
+}
+
+static int match_device(struct io_dev *io_dev, struct daxctl_region *dregion)
+{
+	struct daxctl_dev *dev;
+
+	daxctl_dev_foreach(dregion, dev) {
+		if (io_dev->major == daxctl_dev_get_major(dev) &&
+			io_dev->minor == daxctl_dev_get_minor(dev)) {
+			io_dev->is_dax = true;
+			io_dev->size = daxctl_dev_get_size(dev);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static int find_dax_device(struct io_dev *io_dev, struct ndctl_ctx *ndctx,
+		enum io_direction dir)
+{
+	struct ndctl_bus *bus;
+	struct ndctl_region *region;
+	struct ndctl_dax *dax;
+	struct daxctl_region *dregion;
+	struct stat st;
+	int rc;
+	char cdev_path[256];
+	char link_path[256];
+	char *dev_name;
+
+	if (is_stdinout(io_dev)) {
+		io_dev->size = ULONG_MAX;
+		return 0;
+	}
+
+	rc = stat(io_dev->parm_path, &st);
+	if (rc == -1) {
+		rc = -errno;
+		if (rc == -ENOENT && dir == IO_WRITE) {
+			io_dev->is_new = true;
+			io_dev->size = ULONG_MAX;
+			return 0;
+		}
+		perror("stat");
+		return rc;
+	}
+
+	if (S_ISREG(st.st_mode)) {
+		if (dir == IO_WRITE) {
+			io_dev->need_trunc = true;
+			io_dev->size = ULONG_MAX;
+		} else
+			io_dev->size = st.st_size;
+		return 0;
+	} else if (S_ISBLK(st.st_mode)) {
+		io_dev->size = st.st_size;
+		return 0;
+	} else if (S_ISCHR(st.st_mode)) {
+		io_dev->size = ULONG_MAX;
+		io_dev->is_char = true;
+		io_dev->major = major(st.st_rdev);
+		io_dev->minor = minor(st.st_rdev);
+	} else
+		return -ENODEV;
+
+	rc = snprintf(cdev_path, 255, "/sys/dev/char/%u:%u", io_dev->major,
+			io_dev->minor);
+	if (rc < 0) {
+		fail("snprintf\n");
+		return -ENXIO;
+	}
+
+	rc = readlink(cdev_path, link_path, 255);
+	if (rc == -1) {
+		rc = errno;
+		perror("readlink");
+		return rc;
+	}
+	link_path[rc] = '\0';
+	dev_name = basename(link_path);
+
+	ndctl_bus_foreach(ndctx, bus)
+		ndctl_region_foreach(bus, region)
+			ndctl_dax_foreach(region, dax) {
+				if (strncmp(dev_name,
+						ndctl_dax_get_devname(dax),
+						256))
+					continue;
+
+				dregion = ndctl_dax_get_daxctl_region(dax);
+				if(match_device(io_dev, dregion)) {
+					io_dev->region = region;
+					io_dev->dax = dax;
+					return 1;
+				}
+			}
+	return 0;
+}
+
+static int send_clear_error(struct ndctl_bus *bus, uint64_t start, uint64_t size)
+{
+	uint64_t cleared;
+	int rc;
+
+	io.clear_err = ndctl_bus_cmd_new_clear_error(start, size, io.ars_cap);
+	if (!io.clear_err) {
+		fail("bus: %s failed to create cmd\n",
+				ndctl_bus_get_provider(bus));
+		return -ENXIO;
+	}
+
+	rc = ndctl_cmd_submit(io.clear_err);
+	if (rc) {
+		fail("bus: %s failed to submit cmd: %d\n",
+				ndctl_bus_get_provider(bus), rc);
+				ndctl_cmd_unref(io.clear_err);
+		return rc;
+	}
+
+	cleared = ndctl_cmd_clear_error_get_cleared(io.clear_err);
+	if (cleared != size) {
+		fail("bus: %s expected to clear: %ld actual: %ld\n",
+				ndctl_bus_get_provider(bus),
+				size, cleared);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static int get_ars_cap(struct ndctl_bus *bus, uint64_t start, uint64_t size)
+{
+	int rc;
+
+	io.ars_cap = ndctl_bus_cmd_new_ars_cap(bus, start, size);
+	if (!io.ars_cap) {
+		fail("bus: %s failed to create cmd\n",
+				ndctl_bus_get_provider(bus));
+		return -ENOTTY;
+	}
+
+	rc = ndctl_cmd_submit(io.ars_cap);
+	if (rc) {
+		fail("bus: %s failed to submit cmd: %d\n",
+				ndctl_bus_get_provider(bus), rc);
+		ndctl_cmd_unref(io.ars_cap);
+		return rc;
+	}
+
+	if (ndctl_cmd_ars_cap_get_size(io.ars_cap) <
+			sizeof(struct nd_cmd_ars_status)) {
+		fail("bus: %s expected size >= %zd got: %d\n",
+				ndctl_bus_get_provider(bus),
+				sizeof(struct nd_cmd_ars_status),
+				ndctl_cmd_ars_cap_get_size(io.ars_cap));
+		ndctl_cmd_unref(io.ars_cap);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+int clear_errors(struct ndctl_bus *bus, uint64_t start, uint64_t len)
+{
+	int rc;
+
+	rc = get_ars_cap(bus, start, len);
+	if (rc) {
+		fail("get_ars_cap failed\n");
+		return rc;
+	}
+
+	rc = send_clear_error(bus, start, len);
+	if (rc) {
+		fail("send_clear_error failed\n");
+		return rc;
+	}
+
+	return 0;
+}
+
+static int clear_badblocks(struct io_dev *dev, uint64_t len)
+{
+	unsigned long long dax_begin, dax_size, dax_end;
+	unsigned long long region_begin, offset;
+	unsigned long long size, io_begin, io_end, io_len;
+	struct badblock *bb;
+	int rc;
+
+	dax_begin = ndctl_dax_get_resource(dev->dax);
+	if (dax_begin == ULLONG_MAX)
+		return -ERANGE;
+
+	dax_size = ndctl_dax_get_size(dev->dax);
+	if (dax_size == ULLONG_MAX)
+		return -ERANGE;
+
+	dax_end = dax_begin + dax_size - 1;
+
+	region_begin = ndctl_region_get_resource(dev->region);
+	if (region_begin == ULLONG_MAX)
+		return -ERANGE;
+
+	ndctl_region_badblock_foreach(dev->region, bb) {
+		unsigned long long bb_begin, bb_end, begin, end;
+
+		bb_begin = region_begin + (bb->offset << 9);
+		bb_end = bb_begin + (bb->len << 9) - 1;
+
+		if (bb_end <= dax_begin || bb_begin >= dax_end)
+			continue;
+
+		if (bb_begin < dax_begin)
+			begin = dax_begin;
+		else
+			begin = bb_begin;
+
+		if (bb_end > dax_end)
+			end = dax_end;
+		else
+			end = bb_end;
+
+		offset = begin - dax_begin;
+		size = end - begin + 1;
+
+		/*
+		 * If end of I/O is before badblock or the offset of the
+		 * I/O is greater than the actual size of badblock range
+		 */
+		if (dev->offset + len - 1 < offset || dev->offset > size)
+			continue;
+
+		io_begin = (dev->offset < offset) ? offset : dev->offset;
+		if ((dev->offset + len) < (offset + size))
+			io_end = offset + len;
+		else
+			io_end = offset + size;
+
+		io_len = io_end - io_begin;
+		io_begin += dax_begin;
+		rc = clear_errors(ndctl_region_get_bus(dev->region),
+				io_begin, io_len);
+		if (rc < 0)
+			return rc;
+	}
+
+	return 0;
+}
+
+static ssize_t __do_io(struct io_dev *dst_dev, struct io_dev *src_dev,
+		uint64_t len, bool zero)
+{
+	void *src, *dst;
+	ssize_t rc, count = 0;
+
+	if (zero && dst_dev->is_dax) {
+		dst = (uint8_t *)dst_dev->mmap + dst_dev->offset;
+		memset(dst, 0, len);
+		pmem_persist(dst, len);
+		rc = len;
+	} else if (dst_dev->is_dax && src_dev->is_dax) {
+		src = (uint8_t *)src_dev->mmap + src_dev->offset;
+		dst = (uint8_t *)dst_dev->mmap + dst_dev->offset;
+		pmem_memcpy_persist(dst, src, len);
+		rc = len;
+	} else if (src_dev->is_dax) {
+		src = (uint8_t *)src_dev->mmap + src_dev->offset;
+		if (dst_dev->offset) {
+			rc = lseek(dst_dev->fd, dst_dev->offset, SEEK_SET);
+			if (rc < 0) {
+				rc = -errno;
+				perror("lseek");
+				return rc;
+			}
+		}
+		do {
+			rc = write(dst_dev->fd, (uint8_t *)src + count,
+					len - count);
+			if (rc == -1) {
+				rc = -errno;
+				perror("write");
+				return rc;
+			}
+			count += rc;
+		} while (count != (ssize_t)len);
+		rc = count;
+		if (rc != (ssize_t)len)
+			printf("Requested size %lu larger than source.\n", len);
+	} else if (dst_dev->is_dax) {
+		dst = (uint8_t *)dst_dev->mmap + dst_dev->offset;
+		if (src_dev->offset) {
+			rc = lseek(src_dev->fd, src_dev->offset, SEEK_SET);
+			if (rc < 0) {
+				rc = -errno;
+				perror("lseek");
+				return rc;
+			}
+		}
+		do {
+			rc = read(src_dev->fd, (uint8_t *)dst + count,
+					len - count);
+			if (rc == -1) {
+				rc = -errno;
+				perror("pread");
+				return rc;
+			}
+			/* end of file */
+			if (rc == 0)
+				break;
+			count += rc;
+		} while (count != (ssize_t)len);
+		pmem_persist(dst, count);
+		rc = count;
+		if (rc != (ssize_t)len)
+			printf("Requested size %lu larger than destination.\n", len);
+	} else
+		return -EINVAL;
+
+	return rc;
+}
+
+static int do_io(struct ndctl_ctx *ctx)
+{
+	int rc, i, dax_devs = 0;
+
+	/* if we are zeroing the device, we just need output */
+	i = io.zero ? 1 : 0;
+	for (; i < 2; i++) {
+		if (!io.dev[i].parm_path)
+			continue;
+		rc = find_dax_device(&io.dev[i], ctx, i);
+		if (rc < 0)
+			return rc;
+
+		if (rc == 1)
+			dax_devs++;
+	}
+
+	if (dax_devs == 0) {
+		fail("No DAX devices for input or output, fail\n");
+		return -ENODEV;
+	}
+
+	if (io.len == 0) {
+		if (is_stdinout(&io.dev[0]))
+			io.len = io.dev[1].size;
+		else
+			io.len = io.dev[0].size;
+	}
+
+	io.dev[1].direction = IO_WRITE;
+	i = io.zero ? 1 : 0;
+	for (; i < 2; i++) {
+		if (!io.dev[i].parm_path)
+			continue;
+		rc = setup_device(&io.dev[i], ctx, io.len);
+		if (rc < 0)
+			return rc;
+	}
+
+	if (io.dev[1].is_dax) {
+		rc = clear_badblocks(&io.dev[1], io.len);
+		if (rc < 0) {
+			fail("Failed to clear badblocks on %s\n",
+					io.dev[1].parm_path);
+			return rc;
+		}
+	}
+
+	rc = __do_io(&io.dev[1], &io.dev[0], io.len, io.zero);
+	if (rc < 0) {
+		fail("Failed to perform I/O\n");
+		return rc;
+	}
+
+	printf("Data copied %u bytes to device %s\n",
+			rc, io.dev[1].parm_path);
+
+	return 0;
+}
+
+static void cleanup(struct ndctl_ctx *ctx)
+{
+	int i;
+
+	for (i = 0; i < 2; i++) {
+		if (is_stdinout(&io.dev[i]))
+			continue;
+		close(io.dev[i].fd);
+	}
+}
+
+int cmd_io(int argc, const char **argv, void *ctx)
+{
+	const struct option options[] = {
+		OPT_STRING('i', "input", &io.dev[0].parm_path, "in device",
+				"input device/file"),
+		OPT_STRING('o', "output", &io.dev[1].parm_path, "out device",
+				"output device/file"),
+		OPT_BOOLEAN('z', "zero", &io.zero, "zeroing the device"),
+		OPT_U64('l', "len", &io.len, "total length to perform the I/O"),
+		OPT_U64('s', "seek", &io.dev[1].offset, "seek offset for output"),
+		OPT_U64('k', "skip", &io.dev[0].offset, "skip offset for input"),
+	};
+	const char * const u[] = {
+		"daxctl io [<options>]",
+		NULL
+	};
+	int i, rc;
+	struct ndctl_ctx *ndctx;
+
+	argc = parse_options(argc, argv, options, u, 0);
+	for (i = 0; i < argc; i++) {
+		fail("Unknown parameter \"%s\"\n", argv[i]);
+		return -EINVAL;
+	}
+
+	if (argc) {
+		usage_with_options(u, options);
+		return 0;
+	}
+
+	if (!io.dev[0].parm_path && !io.dev[1].parm_path) {
+		usage_with_options(u, options);
+		return 0;
+	}
+
+	if (!io.dev[0].parm_path) {
+		io.dev[0].fd = STDIN_FILENO;
+		io.dev[0].offset = 0;
+	}
+
+	if (!io.dev[1].parm_path) {
+		io.dev[1].fd = STDOUT_FILENO;
+		io.dev[1].offset = 0;
+	}
+
+	rc = ndctl_new(&ndctx);
+	if (rc)
+		return -ENOMEM;
+
+	rc = do_io(ndctx);
+	if (rc < 0)
+		goto out;
+
+	rc = 0;
+out:
+	cleanup(ndctx);
+	ndctl_unref(ndctx);
+	return rc;
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
