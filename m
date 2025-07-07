Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687DF288C00
	for <nvdimm@lists.linux.dev>; Mon,  7 Jul 2025 06:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751871576; cv=none; b=cP7ELe3oiZeQiZXUTPMekNDjCWrk4wOWIHGTK9Q82W/PpxGnY5AYRCH9TNbeeXWIglnTvDOvAdsvtK+Gw6vdXD+9nbuoPskSiCgkGcVRbW/hbxgXKE++4aoGPWZuEFmZBK+Laxqj9cKR4ORD1kdXd5I/VQbI6dPrSPF33lvZW7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751871576; c=relaxed/simple;
	bh=SL/jnu/t6cs37SZ5bCObXOKvkKFEYBH7q45R0OfP7n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HSNJnqh30nHNWCJOJVkEe93kagzGpQN9G6bDF94BhcGxJLFJg6eq3Szaj77L9rezJIYxEweNXbKjGpgPTxN1WT394QyAIslKAxhhC38QQdJyfs5ZLdF+Ys/4bkDtTTY/ARhr313ICpxrWgMB0BJXeLbYgqJ2BekeO62XbR325+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jnZuvmWc; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jnZuvmWc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751871571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uEIbO0oNmeRqTEIgEwKQKDhhfia41tUeykp66UG68r4=;
	b=jnZuvmWclNg6Qnjg4qbdBt06wiI6Hdv4i73t3b7qH0onU909DdDAzR5Qlp8Ek6eNnB2eRO
	wfBx/ccFuZmfEmJatsjUzmPxJ+qJT1I+l8BCRPVZphHwvTnUapTvZZIuOio9aOHA3cES42
	oXRkMPOWlEZGiBThkr7t3Lnb5SpRB0c=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	dan.j.williams@intel.com,
	Jonathan.Cameron@Huawei.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	dm-devel@lists.linux.dev,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH v2 11/11] dm-pcache: initial dm-pcache target
Date: Mon,  7 Jul 2025 06:58:09 +0000
Message-ID: <20250707065809.437589-12-dongsheng.yang@linux.dev>
In-Reply-To: <20250707065809.437589-1-dongsheng.yang@linux.dev>
References: <20250707065809.437589-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add the top-level integration pieces that make the new persistent-memory
cache target usable from device-mapper:

* Documentation
  - `Documentation/admin-guide/device-mapper/dm-pcache.rst` explains the
    design, table syntax, status fields and runtime messages.

* Core target implementation
  - `dm_pcache.c` and `dm_pcache.h` register the `"pcache"` DM target,
    parse constructor arguments, create workqueues, and forward BIOS to
    the cache core added in earlier patches.
  - Supports flush/FUA, status reporting, and a “gc_percent” message.
  - Dont support discard currently.
  - Dont support table reload for live target currently.

* Device-mapper tables now accept lines like
    pcache <pmem_dev> <backing_dev> writeback <true|false>

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 .../admin-guide/device-mapper/dm-pcache.rst   | 201 ++++++++
 MAINTAINERS                                   |   8 +
 drivers/md/Kconfig                            |   2 +
 drivers/md/Makefile                           |   1 +
 drivers/md/dm-pcache/Kconfig                  |  17 +
 drivers/md/dm-pcache/Makefile                 |   3 +
 drivers/md/dm-pcache/dm_pcache.c              | 466 ++++++++++++++++++
 drivers/md/dm-pcache/dm_pcache.h              |  65 +++
 8 files changed, 763 insertions(+)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-pcache.rst
 create mode 100644 drivers/md/dm-pcache/Kconfig
 create mode 100644 drivers/md/dm-pcache/Makefile
 create mode 100644 drivers/md/dm-pcache/dm_pcache.c
 create mode 100644 drivers/md/dm-pcache/dm_pcache.h

diff --git a/Documentation/admin-guide/device-mapper/dm-pcache.rst b/Documentation/admin-guide/device-mapper/dm-pcache.rst
new file mode 100644
index 000000000000..e6433fab7bd6
--- /dev/null
+++ b/Documentation/admin-guide/device-mapper/dm-pcache.rst
@@ -0,0 +1,201 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================================
+dm-pcache — Persistent Cache
+=================================
+
+*Author: Dongsheng Yang <dongsheng.yang@linux.dev>*
+
+This document describes *dm-pcache*, a Device-Mapper target that lets a
+byte-addressable *DAX* (persistent-memory, “pmem”) region act as a
+high-performance, crash-persistent cache in front of a slower block
+device.  The code lives in `drivers/md/dm-pcache/`.
+
+Quick feature summary
+=====================
+
+* *Write-back* caching (only mode currently supported).
+* *16 MiB segments* allocated on the pmem device.
+* *Data CRC32* verification (optional, per cache).
+* Crash-safe: every metadata structure is duplicated (`PCACHE_META_INDEX_MAX
+  == 2`) and protected with CRC+sequence numbers.
+* *Multi-tree indexing* (one radix tree per CPU backend) for high PMem
+  parallelism
+* Pure *DAX path* I/O – no extra BIO round-trips
+* *Log-structured write-back* that preserves backend crash-consistency
+
+-------------------------------------------------------------------------------
+Constructor
+===========
+
+::
+
+    pcache <cache_dev> <backing_dev> [<number_of_optional_arguments> <cache_mode writeback> <data_crc true|false>]
+
+=========================  ====================================================
+``cache_dev``               Any DAX-capable block device (``/dev/pmem0``…).
+                            All metadata *and* cached blocks are stored here.
+
+``backing_dev``             The slow block device to be cached.
+
+``cache_mode``              Optional, Only ``writeback`` is accepted at the moment.
+
+``data_crc``                Optional, default to ``false``
+                            ``true``  – store CRC32 for every cached entry and
+                                      verify on reads
+                            ``false`` – skip CRC (faster)
+=========================  ====================================================
+
+Example
+-------
+
+.. code-block:: shell
+
+   dmsetup create pcache_sdb --table \
+     "0 $(blockdev --getsz /dev/sdb) pcache /dev/pmem0 /dev/sdb 4 cache_mode writeback data_crc true"
+
+The first time a pmem device is used, dm-pcache formats it automatically
+(super-block, cache_info, etc.).
+
+-------------------------------------------------------------------------------
+Status line
+===========
+
+``dmsetup status <device>`` (``STATUSTYPE_INFO``) prints:
+
+::
+
+   <sb_flags> <seg_total> <cache_segs> <segs_used> \
+   <gc_percent> <cache_flags> \
+   <key_head_seg>:<key_head_off> \
+   <dirty_tail_seg>:<dirty_tail_off> \
+   <key_tail_seg>:<key_tail_off>
+
+Field meanings
+--------------
+
+===============================  =============================================
+``sb_flags``                     Super-block flags (e.g. endian marker).
+
+``seg_total``                    Number of physical *pmem* segments.
+
+``cache_segs``                   Number of segments used for cache.
+
+``segs_used``                    Segments currently allocated (bitmap weight).
+
+``gc_percent``                   Current GC high-water mark (0-90).
+
+``cache_flags``                  Bit 0 – DATA_CRC enabled
+                                 Bit 1 – INIT_DONE (cache initialised)
+                                 Bits 2-5 – cache mode (0 == WB).
+
+``key_head``                     Where new key-sets are being written.
+
+``dirty_tail``                   First dirty key-set that still needs
+                                 write-back to the backing device.
+
+``key_tail``                     First key-set that may be reclaimed by GC.
+===============================  =============================================
+
+-------------------------------------------------------------------------------
+Messages
+========
+
+*Change GC trigger*
+
+::
+
+   dmsetup message <dev> 0 gc_percent <0-90>
+
+-------------------------------------------------------------------------------
+Theory of operation
+===================
+
+Sub-devices
+-----------
+
+====================  =========================================================
+backing_dev             Any block device (SSD/HDD/loop/LVM, etc.).
+cache_dev               DAX device; must expose direct-access memory.
+====================  =========================================================
+
+Segments and key-sets
+---------------------
+
+* The pmem space is divided into *16 MiB segments*.
+* Each write allocates space from a per-CPU *data_head* inside a segment.
+* A *cache-key* records a logical range on the origin and where it lives
+  inside pmem (segment + offset + generation).
+* 128 keys form a *key-set* (kset); ksets are written sequentially in pmem
+  and are themselves crash-safe (CRC).
+* The pair *(key_tail, dirty_tail)* delimit clean/dirty and live/dead ksets.
+
+Write-back
+----------
+
+Dirty keys are queued into a tree; a background worker copies data
+back to the backing_dev and advances *dirty_tail*.  A FLUSH/FUA bio from the
+upper layers forces an immediate metadata commit.
+
+Garbage collection
+------------------
+
+GC starts when ``segs_used >= seg_total * gc_percent / 100``.  It walks
+from *key_tail*, frees segments whose every key has been invalidated, and
+advances *key_tail*.
+
+CRC verification
+----------------
+
+If ``data_crc is enabled`` dm-pcache computes a CRC32 over every cached data
+range when it is inserted and stores it in the on-media key.  Reads
+validate the CRC before copying to the caller.
+
+-------------------------------------------------------------------------------
+Failure handling
+================
+
+* *pmem media errors* – all metadata copies are read with
+  ``copy_mc_to_kernel``; an uncorrectable error logs and aborts initialisation.
+* *Cache full* – if no free segment can be found, writes return ``-EBUSY``;
+  dm-pcache retries internally (request deferral).
+* *System crash* – on attach, the driver replays ksets from *key_tail* to
+  rebuild the in-core trees; every segment’s generation guards against
+  use-after-free keys.
+
+-------------------------------------------------------------------------------
+Limitations & TODO
+==================
+
+* Only *write-back* mode; other modes planned.
+* Only FIFO cache invalidate; other (LRU, ARC...) planned.
+* Table reload is not supported currently.
+* Discard planned.
+
+-------------------------------------------------------------------------------
+Example workflow
+================
+
+.. code-block:: shell
+
+   # 1.  Create devices
+   dmsetup create pcache_sdb --table \
+     "0 $(blockdev --getsz /dev/sdb) pcache /dev/pmem0 /dev/sdb 4 cache_mode writeback data_crc true"
+
+   # 2.  Put a filesystem on top
+   mkfs.ext4 /dev/mapper/pcache_sdb
+   mount /dev/mapper/pcache_sdb /mnt
+
+   # 3.  Tune GC threshold to 80 %
+   dmsetup message pcache_sdb 0 gc_percent 80
+
+   # 4.  Observe status
+   watch -n1 'dmsetup status pcache_sdb'
+
+   # 5.  Shutdown
+   umount /mnt
+   dmsetup remove pcache_sdb
+
+-------------------------------------------------------------------------------
+``dm-pcache`` is under active development; feedback, bug reports and patches
+are very welcome!
diff --git a/MAINTAINERS b/MAINTAINERS
index dd844ac8d910..0a7aa53eef96 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6838,6 +6838,14 @@ S:	Maintained
 F:	Documentation/admin-guide/device-mapper/vdo*.rst
 F:	drivers/md/dm-vdo/
 
+DEVICE-MAPPER PCACHE TARGET
+M:	Dongsheng Yang <dongsheng.yang@linux.dev>
+M:	Zheng Gu <cengku@gmail.com>
+L:	dm-devel@lists.linux.dev
+S:	Maintained
+F:	Documentation/admin-guide/device-mapper/dm-pcache.rst
+F:	drivers/md/dm-pcache/
+
 DEVLINK
 M:	Jiri Pirko <jiri@resnulli.us>
 L:	netdev@vger.kernel.org
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index ddb37f6670de..cd4d8d1705bb 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -659,4 +659,6 @@ config DM_AUDIT
 
 source "drivers/md/dm-vdo/Kconfig"
 
+source "drivers/md/dm-pcache/Kconfig"
+
 endif # MD
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 87bdfc9fe14c..f91a3133677f 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_DM_RAID)		+= dm-raid.o
 obj-$(CONFIG_DM_THIN_PROVISIONING) += dm-thin-pool.o
 obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
 obj-$(CONFIG_DM_VDO)            += dm-vdo/
+obj-$(CONFIG_DM_PCACHE)		+= dm-pcache/
 obj-$(CONFIG_DM_CACHE)		+= dm-cache.o
 obj-$(CONFIG_DM_CACHE_SMQ)	+= dm-cache-smq.o
 obj-$(CONFIG_DM_EBS)		+= dm-ebs.o
diff --git a/drivers/md/dm-pcache/Kconfig b/drivers/md/dm-pcache/Kconfig
new file mode 100644
index 000000000000..0e251eca892e
--- /dev/null
+++ b/drivers/md/dm-pcache/Kconfig
@@ -0,0 +1,17 @@
+config DM_PCACHE
+	tristate "Persistent cache for Block Device (Experimental)"
+	depends on BLK_DEV_DM
+	depends on DEV_DAX
+	help
+	  PCACHE provides a mechanism to use persistent memory (e.g., CXL persistent memory,
+	  DAX-enabled devices) as a high-performance cache layer in front of
+	  traditional block devices such as SSDs or HDDs.
+
+	  PCACHE is implemented as a kernel module that integrates with the block
+	  layer and supports direct access (DAX) to persistent memory for low-latency,
+	  byte-addressable caching.
+
+	  Note: This feature is experimental and should be tested thoroughly
+	  before use in production environments.
+
+	  If unsure, say 'N'.
diff --git a/drivers/md/dm-pcache/Makefile b/drivers/md/dm-pcache/Makefile
new file mode 100644
index 000000000000..86776e4acad2
--- /dev/null
+++ b/drivers/md/dm-pcache/Makefile
@@ -0,0 +1,3 @@
+dm-pcache-y := dm_pcache.o cache_dev.o segment.o backing_dev.o cache.o cache_gc.o cache_writeback.o cache_segment.o cache_key.o cache_req.o
+
+obj-m += dm-pcache.o
diff --git a/drivers/md/dm-pcache/dm_pcache.c b/drivers/md/dm-pcache/dm_pcache.c
new file mode 100644
index 000000000000..ee707d33635e
--- /dev/null
+++ b/drivers/md/dm-pcache/dm_pcache.c
@@ -0,0 +1,466 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/module.h>
+#include <linux/blkdev.h>
+#include <linux/bio.h>
+
+#include "../dm-core.h"
+#include "cache_dev.h"
+#include "backing_dev.h"
+#include "cache.h"
+#include "dm_pcache.h"
+
+void pcache_defer_reqs_kick(struct dm_pcache *pcache)
+{
+	struct pcache_cache *cache = &pcache->cache;
+
+	spin_lock(&cache->seg_map_lock);
+	if (!cache->cache_full)
+		queue_work(pcache->task_wq, &pcache->defered_req_work);
+	spin_unlock(&cache->seg_map_lock);
+}
+
+static void defer_req(struct pcache_request *pcache_req)
+{
+	struct dm_pcache *pcache = pcache_req->pcache;
+
+	BUG_ON(!list_empty(&pcache_req->list_node));
+
+	spin_lock(&pcache->defered_req_list_lock);
+	list_add(&pcache_req->list_node, &pcache->defered_req_list);
+	pcache_defer_reqs_kick(pcache);
+	spin_unlock(&pcache->defered_req_list_lock);
+}
+
+static void defered_req_fn(struct work_struct *work)
+{
+	struct dm_pcache *pcache = container_of(work, struct dm_pcache, defered_req_work);
+	struct pcache_request *pcache_req;
+	LIST_HEAD(tmp_list);
+	int ret;
+
+	if (pcache_is_stopping(pcache))
+		return;
+
+	spin_lock(&pcache->defered_req_list_lock);
+	list_splice_init(&pcache->defered_req_list, &tmp_list);
+	spin_unlock(&pcache->defered_req_list_lock);
+
+	while (!list_empty(&tmp_list)) {
+		pcache_req = list_first_entry(&tmp_list,
+					    struct pcache_request, list_node);
+		list_del_init(&pcache_req->list_node);
+		pcache_req->ret = 0;
+		ret = pcache_cache_handle_req(&pcache->cache, pcache_req);
+		if (ret == -EBUSY)
+			defer_req(pcache_req);
+		else
+			pcache_req_put(pcache_req, ret);
+	}
+}
+
+void pcache_req_get(struct pcache_request *pcache_req)
+{
+	kref_get(&pcache_req->ref);
+}
+
+static void end_req(struct kref *ref)
+{
+	struct pcache_request *pcache_req = container_of(ref, struct pcache_request, ref);
+	struct bio *bio = pcache_req->bio;
+	int ret = pcache_req->ret;
+
+	if (ret == -EBUSY) {
+		pcache_req_get(pcache_req);
+		defer_req(pcache_req);
+	} else {
+		bio->bi_status = errno_to_blk_status(ret);
+		bio_endio(bio);
+	}
+}
+
+void pcache_req_put(struct pcache_request *pcache_req, int ret)
+{
+	/* Set the return status if it is not already set */
+	if (ret && !pcache_req->ret)
+		pcache_req->ret = ret;
+
+	kref_put(&pcache_req->ref, end_req);
+}
+
+static bool at_least_one_arg(struct dm_arg_set *as, char **error)
+{
+	if (!as->argc) {
+		*error = "Insufficient args";
+		return false;
+	}
+
+	return true;
+}
+
+static int parse_cache_dev(struct dm_pcache *pcache, struct dm_arg_set *as,
+				char **error)
+{
+	int ret;
+
+	if (!at_least_one_arg(as, error))
+		return -EINVAL;
+	ret = dm_get_device(pcache->ti, dm_shift_arg(as),
+			  BLK_OPEN_READ | BLK_OPEN_WRITE,
+			  &pcache->cache_dev.dm_dev);
+	if (ret) {
+		*error = "Error opening cache device";
+		return ret;
+	}
+
+	return 0;
+}
+
+static int parse_backing_dev(struct dm_pcache *pcache, struct dm_arg_set *as,
+				char **error)
+{
+	int ret;
+
+	if (!at_least_one_arg(as, error))
+		return -EINVAL;
+
+	ret = dm_get_device(pcache->ti, dm_shift_arg(as),
+			  BLK_OPEN_READ | BLK_OPEN_WRITE,
+			  &pcache->backing_dev.dm_dev);
+	if (ret) {
+		*error = "Error opening backing device";
+		return ret;
+	}
+
+	return 0;
+}
+
+static void pcache_init_opts(struct pcache_cache_options *opts)
+{
+	opts->cache_mode = PCACHE_CACHE_MODE_WRITEBACK;
+	opts->data_crc = false;
+}
+
+static int parse_cache_opts(struct dm_pcache *pcache, struct dm_arg_set *as,
+			    char **error)
+{
+	struct pcache_cache_options *opts = &pcache->opts;
+	static const struct dm_arg _args[] = {
+		{0, 4, "Invalid number of cache option arguments"},
+	};
+	unsigned int argc;
+	const char *arg;
+	int ret;
+
+	pcache_init_opts(opts);
+	if (!as->argc)
+		return 0;
+
+	ret = dm_read_arg_group(_args, as, &argc, error);
+	if (ret)
+		return -EINVAL;
+
+	while (argc) {
+		arg = dm_shift_arg(as);
+		argc--;
+
+		if (!strcmp(arg, "cache_mode")) {
+			arg = dm_shift_arg(as);
+			if (!strcmp(arg, "writeback")) {
+				opts->cache_mode = PCACHE_CACHE_MODE_WRITEBACK;
+			} else {
+				*error = "Invalid cache mode parameter";
+				return -EINVAL;
+			}
+			argc--;
+		} else if (!strcmp(arg, "data_crc")) {
+			arg = dm_shift_arg(as);
+			if (!strcmp(arg, "true")) {
+				opts->data_crc = true;
+			} else if (!strcmp(arg, "false")) {
+				opts->data_crc = false;
+			} else {
+				*error = "Invalid data crc parameter";
+				return -EINVAL;
+			}
+			argc--;
+		} else {
+			*error = "Unrecognised cache option requested";
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int pcache_start(struct dm_pcache *pcache, char **error)
+{
+	int ret;
+
+	ret = cache_dev_start(pcache);
+	if (ret) {
+		*error = "Failed to start cache dev";
+		return ret;
+	}
+
+	ret = backing_dev_start(pcache);
+	if (ret) {
+		*error = "Failed to start backing dev";
+		goto stop_cache;
+	}
+
+	ret = pcache_cache_start(pcache);
+	if (ret) {
+		*error = "Failed to start pcache";
+		goto stop_backing;
+	}
+
+	return 0;
+stop_backing:
+	backing_dev_stop(pcache);
+stop_cache:
+	cache_dev_stop(pcache);
+
+	return ret;
+}
+
+static void pcache_destroy_args(struct dm_pcache *pcache)
+{
+	if (pcache->cache_dev.dm_dev)
+		dm_put_device(pcache->ti, pcache->cache_dev.dm_dev);
+	if (pcache->backing_dev.dm_dev)
+		dm_put_device(pcache->ti, pcache->backing_dev.dm_dev);
+}
+
+static int pcache_parse_args(struct dm_pcache *pcache, unsigned int argc, char **argv,
+				char **error)
+{
+	struct dm_arg_set as;
+	int ret;
+
+	as.argc = argc;
+	as.argv = argv;
+
+	/*
+	 * Parse cache device
+	 */
+	ret = parse_cache_dev(pcache, &as, error);
+	if (ret)
+		return ret;
+	/*
+	 * Parse backing device
+	 */
+	ret = parse_backing_dev(pcache, &as, error);
+	if (ret)
+		goto out;
+	/*
+	 * Parse optional arguments
+	 */
+	ret = parse_cache_opts(pcache, &as, error);
+	if (ret)
+		goto out;
+
+	return 0;
+out:
+	pcache_destroy_args(pcache);
+	return ret;
+}
+
+static int dm_pcache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct mapped_device *md = ti->table->md;
+	struct dm_pcache *pcache;
+	int ret;
+
+	if (md->map) {
+		ti->error = "Don't support table loading for live md";
+		return -EOPNOTSUPP;
+	}
+
+	/* Allocate memory for the cache structure */
+	pcache = kzalloc(sizeof(struct dm_pcache), GFP_KERNEL);
+	if (!pcache)
+		return -ENOMEM;
+
+	pcache->task_wq = alloc_workqueue("pcache-%s-wq",  WQ_UNBOUND | WQ_MEM_RECLAIM,
+					  0, md->name);
+	if (!pcache->task_wq) {
+		ret = -ENOMEM;
+		goto free_pcache;
+	}
+
+	spin_lock_init(&pcache->defered_req_list_lock);
+	INIT_LIST_HEAD(&pcache->defered_req_list);
+	INIT_WORK(&pcache->defered_req_work, defered_req_fn);
+	pcache->ti = ti;
+
+	ret = pcache_parse_args(pcache, argc, argv, &ti->error);
+	if (ret)
+		goto destroy_wq;
+
+	ret = pcache_start(pcache, &ti->error);
+	if (ret)
+		goto destroy_args;
+
+	ti->num_flush_bios = 1;
+	ti->flush_supported = true;
+	ti->per_io_data_size = sizeof(struct pcache_request);
+	ti->private = pcache;
+	atomic_set(&pcache->state, PCACHE_STATE_RUNNING);
+
+	return 0;
+destroy_args:
+	pcache_destroy_args(pcache);
+destroy_wq:
+	destroy_workqueue(pcache->task_wq);
+free_pcache:
+	kfree(pcache);
+
+	return ret;
+}
+
+static void defer_req_stop(struct dm_pcache *pcache)
+{
+	struct pcache_request *pcache_req;
+	LIST_HEAD(tmp_list);
+
+	flush_work(&pcache->defered_req_work);
+
+	spin_lock(&pcache->defered_req_list_lock);
+	list_splice_init(&pcache->defered_req_list, &tmp_list);
+	spin_unlock(&pcache->defered_req_list_lock);
+
+	while (!list_empty(&tmp_list)) {
+		pcache_req = list_first_entry(&tmp_list,
+					    struct pcache_request, list_node);
+		list_del_init(&pcache_req->list_node);
+		pcache_req_put(pcache_req, -EIO);
+	}
+}
+
+static void dm_pcache_dtr(struct dm_target *ti)
+{
+	struct dm_pcache *pcache;
+
+	pcache = ti->private;
+
+	atomic_set(&pcache->state, PCACHE_STATE_STOPPING);
+
+	defer_req_stop(pcache);
+	pcache_cache_stop(pcache);
+	backing_dev_stop(pcache);
+	cache_dev_stop(pcache);
+
+	pcache_destroy_args(pcache);
+	drain_workqueue(pcache->task_wq);
+	destroy_workqueue(pcache->task_wq);
+
+	kfree(pcache);
+}
+
+static int dm_pcache_map_bio(struct dm_target *ti, struct bio *bio)
+{
+	struct pcache_request *pcache_req = dm_per_bio_data(bio, sizeof(struct pcache_request));
+	struct dm_pcache *pcache = ti->private;
+	int ret;
+
+	pcache_req->pcache = pcache;
+	kref_init(&pcache_req->ref);
+	pcache_req->ret = 0;
+	pcache_req->bio = bio;
+	pcache_req->off = (u64)bio->bi_iter.bi_sector << SECTOR_SHIFT;
+	pcache_req->data_len = bio->bi_iter.bi_size;
+	INIT_LIST_HEAD(&pcache_req->list_node);
+
+	ret = pcache_cache_handle_req(&pcache->cache, pcache_req);
+	if (ret == -EBUSY)
+		defer_req(pcache_req);
+	else
+		pcache_req_put(pcache_req, ret);
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+static void dm_pcache_status(struct dm_target *ti, status_type_t type,
+			     unsigned int status_flags, char *result,
+			     unsigned int maxlen)
+{
+	struct dm_pcache *pcache = ti->private;
+	struct pcache_cache_dev *cache_dev = &pcache->cache_dev;
+	struct pcache_backing_dev *backing_dev = &pcache->backing_dev;
+	struct pcache_cache *cache = &pcache->cache;
+	unsigned int sz = 0;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		DMEMIT("%x %u %u %u %u %x %u:%u %u:%u %u:%u",
+		       cache_dev->sb_flags,
+		       cache_dev->seg_num,
+		       cache->n_segs,
+		       bitmap_weight(cache->seg_map, cache->n_segs),
+		       pcache_cache_get_gc_percent(cache),
+		       cache->cache_info.flags,
+		       cache->key_head.cache_seg->cache_seg_id,
+		       cache->key_head.seg_off,
+		       cache->dirty_tail.cache_seg->cache_seg_id,
+		       cache->dirty_tail.seg_off,
+		       cache->key_tail.cache_seg->cache_seg_id,
+		       cache->key_tail.seg_off);
+		break;
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s %s writeback %s",
+		       cache_dev->dm_dev->name,
+		       backing_dev->dm_dev->name,
+		       cache_data_crc_on(cache) ? "true" : "false");
+		break;
+	case STATUSTYPE_IMA:
+		*result = '\0';
+		break;
+	}
+}
+
+static int dm_pcache_message(struct dm_target *ti, unsigned int argc,
+			     char **argv, char *result, unsigned int maxlen)
+{
+	struct dm_pcache *pcache = ti->private;
+	unsigned long val;
+
+	if (argc != 2)
+		goto err;
+
+	if (!strcasecmp(argv[0], "gc_percent")) {
+		if (kstrtoul(argv[1], 10, &val))
+			goto err;
+
+		return pcache_cache_set_gc_percent(&pcache->cache, val);
+	}
+err:
+	return -EINVAL;
+}
+
+static struct target_type dm_pcache_target = {
+	.name		= "pcache",
+	.version	= {0, 1, 0},
+	.module		= THIS_MODULE,
+	.features	= DM_TARGET_SINGLETON,
+	.ctr		= dm_pcache_ctr,
+	.dtr		= dm_pcache_dtr,
+	.map		= dm_pcache_map_bio,
+	.status		= dm_pcache_status,
+	.message	= dm_pcache_message,
+};
+
+static int __init dm_pcache_init(void)
+{
+	return dm_register_target(&dm_pcache_target);
+}
+module_init(dm_pcache_init);
+
+static void __exit dm_pcache_exit(void)
+{
+	dm_unregister_target(&dm_pcache_target);
+}
+module_exit(dm_pcache_exit);
+
+MODULE_DESCRIPTION("dm-pcache Persistent Cache for block device");
+MODULE_AUTHOR("Dongsheng Yang <dongsheng.yang@linux.dev>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/md/dm-pcache/dm_pcache.h b/drivers/md/dm-pcache/dm_pcache.h
new file mode 100644
index 000000000000..c0d7b7078640
--- /dev/null
+++ b/drivers/md/dm-pcache/dm_pcache.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _DM_PCACHE_H
+#define _DM_PCACHE_H
+#include <linux/device-mapper.h>
+
+#include "../dm-core.h"
+
+#define CACHE_DEV_TO_PCACHE(cache_dev)		(container_of(cache_dev, struct dm_pcache, cache_dev))
+#define BACKING_DEV_TO_PCACHE(backing_dev)	(container_of(backing_dev, struct dm_pcache, backing_dev))
+#define CACHE_TO_PCACHE(cache)			(container_of(cache, struct dm_pcache, cache))
+
+#define PCACHE_STATE_RUNNING			1
+#define PCACHE_STATE_STOPPING			2
+
+struct pcache_cache_dev;
+struct pcache_backing_dev;
+struct pcache_cache;
+struct pcache_cache_options;
+struct dm_pcache {
+	struct dm_target *ti;
+	struct pcache_cache_dev cache_dev;
+	struct pcache_backing_dev backing_dev;
+	struct pcache_cache cache;
+	struct pcache_cache_options opts;
+
+	spinlock_t			defered_req_list_lock;
+	struct list_head		defered_req_list;
+	struct workqueue_struct		*task_wq;
+
+	struct work_struct		defered_req_work;
+
+	atomic_t			state;
+};
+
+static inline bool pcache_is_stopping(struct dm_pcache *pcache)
+{
+	return (atomic_read(&pcache->state) == PCACHE_STATE_STOPPING);
+}
+
+#define pcache_dev_err(pcache, fmt, ...)							\
+	pcache_err("%s " fmt, pcache->ti->table->md->name, ##__VA_ARGS__)
+#define pcache_dev_info(pcache, fmt, ...)							\
+	pcache_info("%s " fmt, pcache->ti->table->md->name, ##__VA_ARGS__)
+#define pcache_dev_debug(pcache, fmt, ...)							\
+	pcache_debug("%s " fmt, pcache->ti->table->md->name, ##__VA_ARGS__)
+
+struct pcache_request {
+	struct dm_pcache	*pcache;
+	struct bio		*bio;
+
+	u64			off;
+	u32			data_len;
+
+	struct kref		ref;
+	int			ret;
+
+	struct list_head	list_node;
+};
+
+void pcache_req_get(struct pcache_request *pcache_req);
+void pcache_req_put(struct pcache_request *pcache_req, int ret);
+
+void pcache_defer_reqs_kick(struct dm_pcache *pcache);
+
+#endif /* _DM_PCACHE_H */
-- 
2.43.0

