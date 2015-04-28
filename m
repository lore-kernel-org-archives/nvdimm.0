Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 19/20] nd_btt: atomic sector updates
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Apr 2015 14:25:57 -0400
Message-ID: <20150428182557.35812.38292.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Boaz Harrosh <boaz@plexistor.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, Jeff Moyer <jmoyer@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Vishal Verma <vishal.l.verma@linux.intel.com>

BTT stands for Block Translation Table, and is a way to provide power
fail sector atomicity semantics for block devices that have the ability
to perform byte granularity IO. It relies on the ->rw_bytes() capability
of provided nd namespace devices.

The BTT works as a stacked blocked device, and reserves a chunk of space
from the backing device for its accounting metadata.  BLK namespaces may
mandate use of a BTT and expect the bus to initialize a BTT if not
already present.  Otherwise if a BTT is desired for other namespaces (or
partitions of a namespace) a BTT may be manually configured.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
[jmoyer: fix nmi watchdog timeout in btt_map_init]
[jmoyer: move btt initialization to module load path]
[jmoyer: fix memory leak in the btt initialization path]
[jmoyer: Don't overwrite corrupted arenas]
Signed-off-by: Vishal Verma <vishal.l.verma@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/blockdev/btt.txt |  273 ++++++++
 drivers/block/nd/Kconfig       |   20 +
 drivers/block/nd/Makefile      |    3 
 drivers/block/nd/acpi.c        |    1 
 drivers/block/nd/btt.c         | 1423 ++++++++++++++++++++++++++++++++++++++++
 drivers/block/nd/btt.h         |  140 ++++
 drivers/block/nd/btt_devs.c    |    3 
 drivers/block/nd/libnd.h       |    1 
 drivers/block/nd/nd-private.h  |    1 
 drivers/block/nd/nd.h          |   10 
 drivers/block/nd/region.c      |   67 ++
 drivers/block/nd/region_devs.c |   10 
 12 files changed, 1948 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/blockdev/btt.txt
 create mode 100644 drivers/block/nd/btt.c

diff --git a/Documentation/blockdev/btt.txt b/Documentation/blockdev/btt.txt
new file mode 100644
index 000000000000..95134d5ec4a0
--- /dev/null
+++ b/Documentation/blockdev/btt.txt
@@ -0,0 +1,273 @@
+BTT - Block Translation Table
+=============================
+
+
+1. Introduction
+---------------
+
+Persistent memory based storage is able to perform IO at byte (or more
+accurately, cache line) granularity. However, we often want to expose such
+storage as traditional block devices. The block drivers for persistent memory
+will do exactly this. However, they do not provide any atomicity guarantees.
+Traditional SSDs typically provide protection against torn sectors in hardware,
+using stored energy in capacitors to complete in-flight block writes, or perhaps
+in firmware. We don't have this luxury with persistent memory - if a write is in
+progress, and we experience a power failure, the block will contain a mix of old
+and new data. Applications may not be prepared to handle such a scenario.
+
+The Block Translation Table (BTT) provides atomic sector update semantics for
+persistent memory devices, so that applications that rely on sector writes not
+being torn can continue to do so. The BTT manifests itself as a stacked block
+device, and reserves a portion of the underlying storage for its metadata. At
+the heart of it, is an indirection table that re-maps all the blocks on the
+volume. It can be thought of as an extremely simple file system that only
+provides atomic sector updates.
+
+
+2. Static Layout
+----------------
+
+The underlying storage on which a BTT can be laid out is not limited in any way.
+The BTT, however, splits the available space into chunks of up to 512 GiB,
+called "Arenas".
+
+Each arena follows the same layout for its metadata, and all references in an
+arena are internal to it (with the exception of one field that points to the
+next arena). The following depicts the "On-disk" metadata layout:
+
+
+  Backing Store     +------->  Arena
++---------------+   |   +------------------+
+|               |   |   | Arena info block |
+|    Arena 0    +---+   |       4K         |
+|     512G      |       +------------------+
+|               |       |                  |
++---------------+       |                  |
+|               |       |                  |
+|    Arena 1    |       |   Data Blocks    |
+|     512G      |       |                  |
+|               |       |                  |
++---------------+       |                  |
+|       .       |       |                  |
+|       .       |       |                  |
+|       .       |       |                  |
+|               |       |                  |
+|               |       |                  |
++---------------+       +------------------+
+                        |                  |
+                        |     BTT Map      |
+                        |                  |
+                        |                  |
+                        +------------------+
+                        |                  |
+                        |     BTT Flog     |
+                        |                  |
+                        +------------------+
+                        | Info block copy  |
+                        |       4K         |
+                        +------------------+
+
+
+3. Theory of Operation
+----------------------
+
+
+a. The BTT Map
+--------------
+
+The map is a simple lookup/indirection table that maps an LBA to an internal
+block. Each map entry is 32 bits. The two most significant bits are special
+flags, and the remaining form the internal block number.
+
+Bit      Description
+31     : TRIM flag - marks if the block was trimmed or discarded
+30     : ERROR flag - marks an error block. Cleared on write.
+29 - 0 : Mappings to internal 'postmap' blocks
+
+
+Some of the terminology that will be subsequently used:
+
+External LBA  : LBA as made visible to upper layers.
+ABA           : Arena Block Address - Block offset/number within an arena
+Premap ABA    : The block offset into an arena, which was decided upon by range
+		checking the External LBA
+Postmap ABA   : The block number in the "Data Blocks" area obtained after
+		indirection from the map
+nfree	      : The number of free blocks that are maintained at any given time.
+		This is the number of concurrent writes that can happen to the
+		arena.
+
+
+For example, after adding a BTT, we surface a disk of 1024G. We get a read for
+the external LBA at 768G. This falls into the second arena, and of the 512G
+worth of blocks that this arena contributes, this block is at 256G. Thus, the
+premap ABA is 256G. We now refer to the map, and find out the mapping for block
+'X' (256G) points to block 'Y', say '64'. Thus the postmap ABA is 64.
+
+
+b. The BTT Flog
+---------------
+
+The BTT provides sector atomicity by making every write an "allocating write",
+i.e. Every write goes to a "free" block. A running list of free blocks is
+maintained in the form of the BTT flog. 'Flog' is a combination of the words
+"free list" and "log". The flog contains 'nfree' entries, and an entry contains:
+
+lba     : The premap ABA that is being written to
+old_map : The old postmap ABA - after 'this' write completes, this will be a
+	  free block.
+new_map : The new postmap ABA. The map will up updated to reflect this
+	  lba->postmap_aba mapping, but we log it here in case we have to
+	  recover.
+seq	: Sequence number to mark which of the 2 sections of this flog entry is
+	  valid/newest. It cycles between 01->10->11->01 (binary) under normal
+	  operation, with 00 indicating an uninitialized state.
+lba'	: alternate lba entry
+old_map': alternate old postmap entry
+new_map': alternate new postmap entry
+seq'	: alternate sequence number.
+
+Each of the above fields is 32-bit, making one entry 16 bytes. Flog updates are
+done such that for any entry being written, it:
+a. overwrites the 'old' section in the entry based on sequence numbers
+b. writes the new entry such that the sequence number is written last.
+
+
+c. The concept of lanes
+-----------------------
+
+While 'nfree' describes the number of concurrent IOs an arena can process
+concurrently, 'nlanes' is the number of IOs the BTT device as a whole can
+process.
+ nlanes = min(nfree, num_cpus)
+A lane number is obtained at the start of any IO, and is used for indexing into
+all the on-disk and in-memory data structures for the duration of the IO. It is
+protected by a spinlock.
+
+
+d. In-memory data structure: Read Tracking Table (RTT)
+------------------------------------------------------
+
+Consider a case where we have two threads, one doing reads and the other,
+writes. We can hit a condition where the writer thread grabs a free block to do
+a new IO, but the (slow) reader thread is still reading from it. In other words,
+the reader consulted a map entry, and started reading the corresponding block. A
+writer started writing to the same external LBA, and finished the write updating
+the map for that external LBA to point to its new postmap ABA. At this point the
+internal, postmap block that the reader is (still) reading has been inserted
+into the list of free blocks. If another write comes in for the same LBA, it can
+grab this free block, and start writing to it, causing the reader to read
+incorrect data. To prevent this, we introduce the RTT.
+
+The RTT is a simple, per arena table with 'nfree' entries. Every reader inserts
+into rtt[lane_number], the postmap ABA it is reading, and clears it after the
+read is complete. Every writer thread, after grabbing a free block, checks the
+RTT for its presence. If the postmap free block is in the RTT, it waits till the
+reader clears the RTT entry, and only then starts writing to it.
+
+
+e. In-memory data structure: map locks
+--------------------------------------
+
+Consider a case where two writer threads are writing to the same LBA. There can
+be a race in the following sequence of steps:
+
+free[lane] = map[premap_aba]
+map[premap_aba] = postmap_aba
+
+Both threads can update their respective free[lane] with the same old, freed
+postmap_aba. This has made the layout inconsistent by losing a free entry, and
+at the same time, duplicating another free entry for two lanes.
+
+To solve this, we could have a single map lock (per arena) that has to be taken
+before performing the above sequence, but we feel that could be too contentious.
+Instead we use an array of (nfree) map_locks that is indexed by
+(premap_aba modulo nfree).
+
+
+f. Reconstruction from the Flog
+-------------------------------
+
+On startup, we analyze the BTT flog to create our list of free blocks. We walk
+through all the entries, and for each lane, of the set of two possible
+'sections', we always look at the most recent one only (based on the sequence
+number). The reconstruction rules/steps are simple:
+- Read map[log_entry.lba].
+- If log_entry.new matches the map entry, then log_entry.old is free.
+- If log_entry.new does not match the map entry, then log_entry.new is free.
+  (This case can only be caused by power-fails/unsafe shutdowns)
+
+
+g. Summarizing - Read and Write flows
+-------------------------------------
+
+Read:
+
+1.  Convert external LBA to arena number + pre-map ABA
+2.  Get a lane (and take lane_lock)
+3.  Read map to get the entry for this pre-map ABA
+4.  Enter post-map ABA into RTT[lane]
+5.  If TRIM flag set in map, return zeroes, and end IO (go to step 8)
+6.  If ERROR flag set in map, end IO with EIO (go to step 8)
+7.  Read data from this block
+8.  Remove post-map ABA entry from RTT[lane]
+9.  Release lane (and lane_lock)
+
+Write:
+
+1.  Convert external LBA to Arena number + pre-map ABA
+2.  Get a lane (and take lane_lock)
+3.  Use lane to index into in-memory free list and obtain a new block, next flog
+        index, next sequence number
+4.  Scan the RTT to check if free block is present, and spin/wait if it is.
+5.  Write data to this free block
+6.  Read map to get the existing post-map ABA entry for this pre-map ABA
+7.  Write flog entry: [premap_aba / old postmap_aba / new postmap_aba / seq_num]
+8.  Write new post-map ABA into map.
+9.  Write old post-map entry into the free list
+10. Calculate next sequence number and write into the free list entry
+11. Release lane (and lane_lock)
+
+
+4. Error Handling
+=================
+
+An arena would be in an error state if any of the metadata is corrupted
+irrecoverably, either due to a bug or a media error. The following conditions
+indicate an error:
+- Info block checksum does not match (and recovering from the copy also fails)
+- All internal available blocks are not uniquely and entirely addressed by the
+  sum of mapped blocks and free blocks (from the BTT flog).
+- Rebuilding free list from the flog reveals missing/duplicate/impossible
+  entries
+- A map entry is out of bounds
+
+If any of these error conditions are encountered, the arena is put into a read
+only state using a flag in the info block.
+
+
+5. In-kernel usage
+==================
+
+Any block driver that supports byte granularity IO to the storage may register
+with the BTT. It will have to provide the rw_bytes interface in its
+block_device_operations struct:
+
+	int (*rw_bytes)(struct gendisk *, void *, size_t, off_t, int rw);
+
+It may register with the BTT after it adds its own gendisk, using btt_init:
+
+	struct btt *btt_init(struct gendisk *disk, unsigned long long rawsize,
+			u32 lbasize, u8 uuid[], int maxlane);
+
+note that maxlane is the maximum amount of concurrency the driver wishes to
+allow the BTT to use.
+
+The BTT 'disk' appears as a stacked block device that grabs the underlying block
+device in the O_EXCL mode.
+
+When the driver wishes to remove the backing disk, it should similarly call
+btt_fini using the same struct btt* handle that was provided to it by btt_init.
+
+	void btt_fini(struct btt *btt);
+
diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
index 15896db4de37..612bf2b14283 100644
--- a/drivers/block/nd/Kconfig
+++ b/drivers/block/nd/Kconfig
@@ -93,9 +93,25 @@ config BLK_DEV_PMEM
 	  capable of DAX (direct-access) file system mappings.  See
 	  Documentation/blockdev/nd.txt for more details.
 
-	  Say Y if you want to use a NVDIMM described by NFIT
+	  Say Y if you want to use a NVDIMM described by ACPI, E820, etc...
 
 config ND_BTT_DEVS
-	def_bool y
+	bool
+
+config ND_BTT
+	tristate "BTT: Block Translation Table (atomic sector updates)"
+	depends on LIBND 
+	default LIBND
+	select ND_BTT_DEVS
+
+config ND_MAX_REGIONS
+	int "Maximum number of regions supported by the sub-system"
+	default 64
+	---help---
+	  A 'region' corresponds to an individual DIMM or an interleave
+	  set of DIMMs.  A typical maximally configured system may have
+	  up to 32 DIMMs.
+
+	  Leave the default of 64 if you are unsure.
 
 endif
diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
index 0c6d64b7a69d..7d778b4523d4 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_ND_ACPI) += nd_acpi.o
 obj-$(CONFIG_ND_E820) += nd_e820.o
 obj-$(CONFIG_NFIT_TEST) += test/
 obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
+obj-$(CONFIG_ND_BTT) += nd_btt.o
 
 nd_acpi-y := acpi.o
 
@@ -24,6 +25,8 @@ nd_e820-y := e820.o
 
 nd_pmem-y := pmem.o
 
+nd_btt-y := btt.o
+
 libnd-y := core.o
 libnd-y += bus.o
 libnd-y += dimm_devs.o
diff --git a/drivers/block/nd/acpi.c b/drivers/block/nd/acpi.c
index d34cefe38e2f..5b9997fbc344 100644
--- a/drivers/block/nd/acpi.c
+++ b/drivers/block/nd/acpi.c
@@ -926,6 +926,7 @@ static int nd_acpi_register_region(struct acpi_nfit_desc *acpi_desc,
 			} else {
 				nd_mapping->size = nfit_mem->bdw->blk_capacity;
 				nd_mapping->start = nfit_mem->bdw->blk_offset;
+				ndr_desc.num_lanes = nfit_mem->bdw->num_bdw;
 			}
 
 			ndr_desc.nd_mapping = nd_mapping;
diff --git a/drivers/block/nd/btt.c b/drivers/block/nd/btt.c
new file mode 100644
index 000000000000..abcefb7aeed1
--- /dev/null
+++ b/drivers/block/nd/btt.c
@@ -0,0 +1,1423 @@
+/*
+ * Block Translation Table
+ * Copyright (c) 2014-2015, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#include <linux/highmem.h>
+#include <linux/debugfs.h>
+#include <linux/blkdev.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/hdreg.h>
+#include <linux/genhd.h>
+#include <linux/sizes.h>
+#include <linux/ndctl.h>
+#include <linux/fs.h>
+#include <linux/nd.h>
+#include "btt.h"
+#include "nd.h"
+
+enum log_ent_request {
+	LOG_NEW_ENT = 0,
+	LOG_OLD_ENT
+};
+
+static int btt_major;
+
+static int nd_btt_rw_bytes(struct nd_btt *nd_btt, void *buf, size_t offset,
+		size_t n, unsigned long flags)
+{
+	struct nd_io *ndio = nd_btt->ndio;
+
+	if (unlikely(nd_data_dir(flags) == WRITE)
+			&& bdev_read_only(nd_btt->backing_dev))
+		return -EACCES;
+
+	return ndio->rw_bytes(ndio, buf, offset + nd_btt->offset, n, flags);
+}
+
+static int arena_rw_bytes(struct arena_info *arena, void *buf, size_t n,
+		size_t offset, unsigned long flags)
+{
+	/* yes, FIXME,  'offset' and 'n' are swapped */
+	return nd_btt_rw_bytes(arena->nd_btt, buf, offset, n, flags);
+}
+
+static int btt_info_write(struct arena_info *arena, struct btt_sb *super)
+{
+	int ret;
+
+	ret = arena_rw_bytes(arena, super, sizeof(struct btt_sb),
+			arena->info2off, WRITE);
+	if (ret)
+		return ret;
+
+	return arena_rw_bytes(arena, super, sizeof(struct btt_sb),
+			arena->infooff, WRITE);
+}
+
+static int btt_info_read(struct arena_info *arena, struct btt_sb *super)
+{
+	WARN_ON(!super);
+	return arena_rw_bytes(arena, super, sizeof(struct btt_sb),
+			arena->infooff, READ);
+
+}
+
+/*
+ * 'raw' version of btt_map write
+ * Assumptions:
+ *   mapping is in little-endian
+ *   mapping contains 'E' and 'Z' flags as desired
+ */
+static int __btt_map_write(struct arena_info *arena, u32 lba, __le32 mapping)
+{
+	u64 ns_off = arena->mapoff + (lba * MAP_ENT_SIZE);
+
+	WARN_ON(lba >= arena->external_nlba);
+	return arena_rw_bytes(arena, &mapping, MAP_ENT_SIZE, ns_off, WRITE);
+}
+
+static int btt_map_write(struct arena_info *arena, u32 lba, u32 mapping,
+			u32 z_flag, u32 e_flag)
+{
+	u32 ze;
+	__le32 mapping_le;
+
+	/*
+	 * This 'mapping' is supposed to be just the LBA mapping, without
+	 * any flags set, so strip the flag bits.
+	 */
+	mapping &= MAP_LBA_MASK;
+
+	ze = (z_flag << 1) + e_flag;
+	switch (ze) {
+	case 0:
+		/*
+		 * We want to set neither of the Z or E flags, and
+		 * in the actual layout, this means setting the bit
+		 * positions of both to '1' to indicate a 'normal'
+		 * map entry
+		 */
+		mapping |= MAP_ENT_NORMAL;
+		break;
+	case 1:
+		mapping |= (1 << MAP_ERR_SHIFT);
+		break;
+	case 2:
+		mapping |= (1 << MAP_TRIM_SHIFT);
+		break;
+	default:
+		/*
+		 * The case where Z and E are both sent in as '1' could be
+		 * construed as a valid 'normal' case, but we decide not to,
+		 * to avoid confusion
+		 */
+		WARN_ONCE(1, "Invalid use of Z and E flags\n");
+		return -EIO;
+	}
+
+	mapping_le = cpu_to_le32(mapping);
+	return __btt_map_write(arena, lba, mapping_le);
+}
+
+static int btt_map_read(struct arena_info *arena, u32 lba, u32 *mapping,
+			int *trim, int *error)
+{
+	int ret;
+	__le32 in;
+	u32 raw_mapping, postmap, ze, z_flag, e_flag;
+	u64 ns_off = arena->mapoff + (lba * MAP_ENT_SIZE);
+
+	WARN_ON(lba >= arena->external_nlba);
+
+	ret = arena_rw_bytes(arena, &in, MAP_ENT_SIZE, ns_off, READ);
+	if (ret)
+		return ret;
+
+	raw_mapping = le32_to_cpu(in);
+
+	z_flag = (raw_mapping & MAP_TRIM_MASK) >> MAP_TRIM_SHIFT;
+	e_flag = (raw_mapping & MAP_ERR_MASK) >> MAP_ERR_SHIFT;
+	ze = (z_flag << 1) + e_flag;
+	postmap = raw_mapping & MAP_LBA_MASK;
+
+	/* Reuse the {z,e}_flag variables for *trim and *error */
+	z_flag = 0;
+	e_flag = 0;
+
+	switch (ze) {
+	case 0:
+		/* Initial state. Return postmap = premap */
+		*mapping = lba;
+		break;
+	case 1:
+		*mapping = postmap;
+		e_flag = 1;
+		break;
+	case 2:
+		*mapping = postmap;
+		z_flag = 1;
+		break;
+	case 3:
+		*mapping = postmap;
+		break;
+	default:
+		return -EIO;
+	}
+
+	if (trim)
+		*trim = z_flag;
+	if (error)
+		*error = e_flag;
+
+	return ret;
+}
+
+static int btt_log_read_pair(struct arena_info *arena, u32 lane,
+			struct log_entry *ent)
+{
+	WARN_ON(!ent);
+	return arena_rw_bytes(arena, ent, 2 * LOG_ENT_SIZE,
+			arena->logoff + (2 * lane * LOG_ENT_SIZE), READ);
+}
+
+static struct dentry *debugfs_root;
+
+static void arena_debugfs_init(struct arena_info *a, struct dentry *parent,
+				int idx)
+{
+	char dirname[32];
+	struct dentry *d;
+
+	/* If for some reason, parent bttN was not created, exit */
+	if (!parent)
+		return;
+
+	snprintf(dirname, 32, "arena%d", idx);
+	d = debugfs_create_dir(dirname, parent);
+	if (IS_ERR_OR_NULL(d))
+		return;
+	a->debugfs_dir = d;
+
+	debugfs_create_x64("size", S_IRUGO, d, &a->size);
+	debugfs_create_x64("external_lba_start", S_IRUGO, d,
+				&a->external_lba_start);
+	debugfs_create_x32("internal_nlba", S_IRUGO, d, &a->internal_nlba);
+	debugfs_create_u32("internal_lbasize", S_IRUGO, d,
+				&a->internal_lbasize);
+	debugfs_create_x32("external_nlba", S_IRUGO, d, &a->external_nlba);
+	debugfs_create_u32("external_lbasize", S_IRUGO, d,
+				&a->external_lbasize);
+	debugfs_create_u32("nfree", S_IRUGO, d, &a->nfree);
+	debugfs_create_u16("version_major", S_IRUGO, d, &a->version_major);
+	debugfs_create_u16("version_minor", S_IRUGO, d, &a->version_minor);
+	debugfs_create_x64("nextoff", S_IRUGO, d, &a->nextoff);
+	debugfs_create_x64("infooff", S_IRUGO, d, &a->infooff);
+	debugfs_create_x64("dataoff", S_IRUGO, d, &a->dataoff);
+	debugfs_create_x64("mapoff", S_IRUGO, d, &a->mapoff);
+	debugfs_create_x64("logoff", S_IRUGO, d, &a->logoff);
+	debugfs_create_x64("info2off", S_IRUGO, d, &a->info2off);
+	debugfs_create_x32("flags", S_IRUGO, d, &a->flags);
+}
+
+static void btt_debugfs_init(struct btt *btt)
+{
+	int i = 0;
+	struct arena_info *arena;
+
+	btt->debugfs_dir = debugfs_create_dir(dev_name(&btt->nd_btt->dev),
+						debugfs_root);
+	if (IS_ERR_OR_NULL(btt->debugfs_dir))
+		return;
+
+	list_for_each_entry(arena, &btt->arena_list, list) {
+		arena_debugfs_init(arena, btt->debugfs_dir, i);
+		i++;
+	}
+}
+
+/*
+ * This function accepts two log entries, and uses the
+ * sequence number to find the 'older' entry.
+ * It also updates the sequence number in this old entry to
+ * make it the 'new' one if the mark_flag is set.
+ * Finally, it returns which of the entries was the older one.
+ *
+ * TODO The logic feels a bit kludge-y. make it better..
+ */
+static int btt_log_get_old(struct log_entry *ent)
+{
+	int old;
+
+	/*
+	 * the first ever time this is seen, the entry goes into [0]
+	 * the next time, the following logic works out to put this
+	 * (next) entry into [1]
+	 */
+	if (ent[0].seq == 0) {
+		ent[0].seq = cpu_to_le32(1);
+		return 0;
+	}
+
+	if (ent[0].seq == ent[1].seq)
+		return -EINVAL;
+	if (le32_to_cpu(ent[0].seq) + le32_to_cpu(ent[1].seq) > 5)
+		return -EINVAL;
+
+	if (le32_to_cpu(ent[0].seq) < le32_to_cpu(ent[1].seq)) {
+		if (le32_to_cpu(ent[1].seq) - le32_to_cpu(ent[0].seq) == 1)
+			old = 0;
+		else
+			old = 1;
+	} else {
+		if (le32_to_cpu(ent[0].seq) - le32_to_cpu(ent[1].seq) == 1)
+			old = 1;
+		else
+			old = 0;
+	}
+
+	return old;
+}
+
+static struct device *to_dev(struct arena_info *arena)
+{
+	return &arena->nd_btt->dev;
+}
+
+/*
+ * This function copies the desired (old/new) log entry into ent if
+ * it is not NULL. It returns the sub-slot number (0 or 1)
+ * where the desired log entry was found. Negative return values
+ * indicate errors.
+ */
+static int btt_log_read(struct arena_info *arena, u32 lane,
+			struct log_entry *ent, int old_flag)
+{
+	int ret;
+	int old_ent, ret_ent;
+	struct log_entry log[2];
+
+	ret = btt_log_read_pair(arena, lane, log);
+	if (ret)
+		return -EIO;
+
+	old_ent = btt_log_get_old(log);
+	if (old_ent < 0 || old_ent > 1) {
+		dev_info(to_dev(arena),
+				"log corruption (%d): lane %d seq [%d, %d]\n",
+			old_ent, lane, log[0].seq, log[1].seq);
+		/* TODO set error state? */
+		return -EIO;
+	}
+
+	ret_ent = (old_flag ? old_ent : (1 - old_ent));
+
+	if (ent != NULL)
+		memcpy(ent, &log[ret_ent], LOG_ENT_SIZE);
+
+	return ret_ent;
+}
+
+/*
+ * This function commits a log entry to media
+ * It does _not_ prepare the freelist entry for the next write
+ * btt_flog_write is the wrapper for updating the freelist elements
+ */
+static int __btt_log_write(struct arena_info *arena, u32 lane,
+			u32 sub, struct log_entry *ent)
+{
+	int ret;
+	/*
+	 * Ignore the padding in log_entry for calculating log_half.
+	 * The entry is 'committed' when we write the sequence number,
+	 * and we want to ensure that that is the last thing written.
+	 * We don't bother writing the padding as that would be extra
+	 * media wear and write amplification
+	 */
+	unsigned int log_half = (LOG_ENT_SIZE - 2 * sizeof(u64)) / 2;
+	u64 ns_off = arena->logoff + (((2 * lane) + sub) * LOG_ENT_SIZE);
+	void *src = ent;
+
+	/* split the 16B write into atomic, durable halves */
+	ret = arena_rw_bytes(arena, src, log_half, ns_off, WRITE);
+	if (ret)
+		return ret;
+
+	ns_off += log_half;
+	src += log_half;
+	return arena_rw_bytes(arena, src, log_half, ns_off, WRITE);
+}
+
+static int btt_flog_write(struct arena_info *arena, u32 lane, u32 sub,
+			struct log_entry *ent)
+{
+	int ret;
+
+	ret = __btt_log_write(arena, lane, sub, ent);
+	if (ret)
+		return ret;
+
+	/* prepare the next free entry */
+	arena->freelist[lane].sub = 1 - arena->freelist[lane].sub;
+	if (++(arena->freelist[lane].seq) == 4)
+		arena->freelist[lane].seq = 1;
+	arena->freelist[lane].block = le32_to_cpu(ent->old_map);
+
+	return ret;
+}
+
+/*
+ * This function initializes the BTT map to a state with all externally
+ * exposed blocks having an identity mapping, and the TRIM flag set
+ */
+static int btt_map_init(struct arena_info *arena)
+{
+	int ret = -EINVAL;
+	void *zerobuf;
+	size_t offset = 0;
+	size_t chunk_size = SZ_2M;
+	size_t mapsize = arena->logoff - arena->mapoff;
+
+	zerobuf = kzalloc(chunk_size, GFP_KERNEL);
+	if (!zerobuf)
+		return -ENOMEM;
+
+	while (mapsize) {
+		size_t size = min(mapsize, chunk_size);
+
+		ret = arena_rw_bytes(arena, zerobuf, size,
+				arena->mapoff + offset, WRITE);
+		if (ret)
+			goto free;
+
+		offset += size;
+		mapsize -= size;
+		cond_resched();
+	}
+
+ free:
+	kfree(zerobuf);
+	return ret;
+}
+
+/*
+ * This function initializes the BTT log with 'fake' entries pointing
+ * to the initial reserved set of blocks as being free
+ */
+static int btt_log_init(struct arena_info *arena)
+{
+	int ret;
+	u32 i;
+	struct log_entry log, zerolog;
+
+	memset(&zerolog, 0, sizeof(zerolog));
+
+	for (i = 0; i < arena->nfree; i++) {
+		log.lba = cpu_to_le32(i);
+		log.old_map = cpu_to_le32(arena->external_nlba + i);
+		log.new_map = cpu_to_le32(arena->external_nlba + i);
+		log.seq = cpu_to_le32(LOG_SEQ_INIT);
+		ret = __btt_log_write(arena, i, 0, &log);
+		if (ret)
+			return ret;
+		ret = __btt_log_write(arena, i, 1, &zerolog);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int btt_freelist_init(struct arena_info *arena)
+{
+	int old, new, ret;
+	u32 i, map_entry;
+	struct log_entry log_new, log_old;
+
+	arena->freelist = kcalloc(arena->nfree, sizeof(struct free_entry),
+					GFP_KERNEL);
+	if (!arena->freelist)
+		return -ENOMEM;
+
+	for (i = 0; i < arena->nfree; i++) {
+		old = btt_log_read(arena, i, &log_old, LOG_OLD_ENT);
+		if (old < 0)
+			return old;
+
+		new = btt_log_read(arena, i, &log_new, LOG_NEW_ENT);
+		if (new < 0)
+			return new;
+
+		/* sub points to the next one to be overwritten */
+		arena->freelist[i].sub = 1 - new;
+		arena->freelist[i].seq = nd_inc_seq(le32_to_cpu(log_new.seq));
+		arena->freelist[i].block = le32_to_cpu(log_new.old_map);
+
+		/* This implies a newly created or untouched flog entry */
+		if (log_new.old_map == log_new.new_map)
+			continue;
+
+		/* Check if map recovery is needed */
+		ret = btt_map_read(arena, le32_to_cpu(log_new.lba), &map_entry,
+				NULL, NULL);
+		if (ret)
+			return ret;
+		if ((le32_to_cpu(log_new.new_map) != map_entry) &&
+				(le32_to_cpu(log_new.old_map) == map_entry)) {
+			/*
+			 * Last transaction wrote the flog, but wasn't able
+			 * to complete the map write. So fix up the map.
+			 */
+			ret = btt_map_write(arena, le32_to_cpu(log_new.lba),
+					le32_to_cpu(log_new.new_map), 0, 0);
+			if (ret)
+				return ret;
+		}
+
+	}
+
+	return 0;
+}
+
+static int btt_rtt_init(struct arena_info *arena)
+{
+	arena->rtt = kcalloc(arena->nfree, sizeof(u32), GFP_KERNEL);
+	if (arena->rtt == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int btt_maplocks_init(struct arena_info *arena)
+{
+	u32 i;
+
+	arena->map_locks = kcalloc(arena->nfree, sizeof(struct aligned_lock),
+				GFP_KERNEL);
+	if (!arena->map_locks)
+		return -ENOMEM;
+
+	for (i = 0; i < arena->nfree; i++)
+		spin_lock_init(&arena->map_locks[i].lock);
+
+	return 0;
+}
+
+static struct arena_info *alloc_arena(struct btt *btt, size_t size,
+				size_t start, size_t arena_off)
+{
+	struct arena_info *arena;
+	u64 logsize, mapsize, datasize;
+	u64 available = size;
+
+	arena = kzalloc(sizeof(struct arena_info), GFP_KERNEL);
+	if (!arena)
+		return NULL;
+	arena->nd_btt = btt->nd_btt;
+
+	if (!size)
+		return arena;
+
+	arena->size = size;
+	arena->external_lba_start = start;
+	arena->external_lbasize = btt->lbasize;
+	arena->internal_lbasize = roundup(arena->external_lbasize,
+					INT_LBASIZE_ALIGNMENT);
+	arena->nfree = BTT_DEFAULT_NFREE;
+	arena->version_major = 1;
+	arena->version_minor = 1;
+
+	if (available % BTT_PG_SIZE)
+		available -= (available % BTT_PG_SIZE);
+
+	/* Two pages are reserved for the super block and its copy */
+	available -= 2 * BTT_PG_SIZE;
+
+	/* The log takes a fixed amount of space based on nfree */
+	logsize = roundup(2 * arena->nfree * sizeof(struct log_entry),
+				BTT_PG_SIZE);
+	available -= logsize;
+
+	/* Calculate optimal split between map and data area */
+	arena->internal_nlba = div_u64(available - BTT_PG_SIZE,
+			arena->internal_lbasize + MAP_ENT_SIZE);
+	arena->external_nlba = arena->internal_nlba - arena->nfree;
+
+	mapsize = roundup((arena->external_nlba * MAP_ENT_SIZE), BTT_PG_SIZE);
+	datasize = available - mapsize;
+
+	/* 'Absolute' values, relative to start of storage space */
+	arena->infooff = arena_off;
+	arena->dataoff = arena->infooff + BTT_PG_SIZE;
+	arena->mapoff = arena->dataoff + datasize;
+	arena->logoff = arena->mapoff + mapsize;
+	arena->info2off = arena->logoff + logsize;
+	return arena;
+}
+
+static void free_arenas(struct btt *btt)
+{
+	struct arena_info *arena, *next;
+
+	list_for_each_entry_safe(arena, next, &btt->arena_list, list) {
+		list_del(&arena->list);
+		kfree(arena->rtt);
+		kfree(arena->map_locks);
+		kfree(arena->freelist);
+		debugfs_remove_recursive(arena->debugfs_dir);
+		kfree(arena);
+	}
+}
+
+/*
+ * This function checks if the metadata layout is valid and error free
+ */
+static int arena_is_valid(struct arena_info *arena, struct btt_sb *super,
+				u8 *uuid)
+{
+	u64 checksum;
+
+	if (memcmp(super->uuid, uuid, 16))
+		return 0;
+
+	checksum = le64_to_cpu(super->checksum);
+	super->checksum = 0;
+	if (checksum != nd_btt_sb_checksum(super))
+		return 0;
+	super->checksum = cpu_to_le64(checksum);
+
+	/* TODO: figure out action for this */
+	if ((le32_to_cpu(super->flags) & IB_FLAG_ERROR_MASK) != 0)
+		dev_info(to_dev(arena), "Found arena with an error flag\n");
+
+	return 1;
+}
+
+/*
+ * This function reads an existing valid btt superblock and
+ * populates the corresponding arena_info struct
+ */
+static void parse_arena_meta(struct arena_info *arena, struct btt_sb *super,
+				u64 arena_off)
+{
+	arena->internal_nlba = le32_to_cpu(super->internal_nlba);
+	arena->internal_lbasize = le32_to_cpu(super->internal_lbasize);
+	arena->external_nlba = le32_to_cpu(super->external_nlba);
+	arena->external_lbasize = le32_to_cpu(super->external_lbasize);
+	arena->nfree = le32_to_cpu(super->nfree);
+	arena->version_major = le16_to_cpu(super->version_major);
+	arena->version_minor = le16_to_cpu(super->version_minor);
+
+	arena->nextoff = (super->nextoff == 0) ? 0 : (arena_off +
+			le64_to_cpu(super->nextoff));
+	arena->infooff = arena_off;
+	arena->dataoff = arena_off + le64_to_cpu(super->dataoff);
+	arena->mapoff = arena_off + le64_to_cpu(super->mapoff);
+	arena->logoff = arena_off + le64_to_cpu(super->logoff);
+	arena->info2off = arena_off + le64_to_cpu(super->info2off);
+
+	arena->size = (super->nextoff > 0) ? (le64_to_cpu(super->nextoff)) :
+			(arena->info2off - arena->infooff + BTT_PG_SIZE);
+
+	arena->flags = le32_to_cpu(super->flags);
+}
+
+static int discover_arenas(struct btt *btt)
+{
+	int ret = 0;
+	struct arena_info *arena;
+	struct btt_sb *super;
+	size_t remaining = btt->rawsize;
+	u64 cur_nlba = 0;
+	size_t cur_off = 0;
+	int num_arenas = 0;
+
+	super = kzalloc(sizeof(*super), GFP_KERNEL);
+	if (!super)
+		return -ENOMEM;
+
+	while (remaining) {
+		/* Alloc memory for arena */
+		arena = alloc_arena(btt, 0, 0, 0);
+		if (!arena) {
+			ret = -ENOMEM;
+			goto out_super;
+		}
+
+		arena->infooff = cur_off;
+		ret = btt_info_read(arena, super);
+		if (ret)
+			goto out;
+
+		if (!arena_is_valid(arena, super, btt->nd_btt->uuid)) {
+			if (remaining == btt->rawsize) {
+				btt->init_state = INIT_NOTFOUND;
+				dev_info(to_dev(arena), "No existing arenas\n");
+				goto out;
+			} else {
+				dev_info(to_dev(arena),
+						"Found corrupted metadata!\n");
+				ret = -ENODEV;
+				goto out;
+			}
+		}
+
+		arena->external_lba_start = cur_nlba;
+		parse_arena_meta(arena, super, cur_off);
+
+		ret = btt_freelist_init(arena);
+		if (ret)
+			goto out;
+
+		ret = btt_rtt_init(arena);
+		if (ret)
+			goto out;
+
+		ret = btt_maplocks_init(arena);
+		if (ret)
+			goto out;
+
+		list_add_tail(&arena->list, &btt->arena_list);
+
+		remaining -= arena->size;
+		cur_off += arena->size;
+		cur_nlba += arena->external_nlba;
+		num_arenas++;
+
+		if (arena->nextoff == 0)
+			break;
+	}
+	btt->num_arenas = num_arenas;
+	btt->nlba = cur_nlba;
+	btt->init_state = INIT_READY;
+
+	kfree(super);
+	return ret;
+
+ out:
+	kfree(arena);
+	free_arenas(btt);
+ out_super:
+	kfree(super);
+	return ret;
+}
+
+static int create_arenas(struct btt *btt)
+{
+	size_t remaining = btt->rawsize;
+	size_t cur_off = 0;
+
+	while (remaining) {
+		struct arena_info *arena;
+		size_t arena_size = min_t(u64, ARENA_MAX_SIZE, remaining);
+
+		remaining -= arena_size;
+		if (arena_size < ARENA_MIN_SIZE)
+			break;
+
+		arena = alloc_arena(btt, arena_size, btt->nlba, cur_off);
+		if (!arena) {
+			free_arenas(btt);
+			return -ENOMEM;
+		}
+		btt->nlba += arena->external_nlba;
+		if (remaining >= ARENA_MIN_SIZE)
+			arena->nextoff = arena->size;
+		else
+			arena->nextoff = 0;
+		cur_off += arena_size;
+		list_add_tail(&arena->list, &btt->arena_list);
+	}
+
+	return 0;
+}
+
+/*
+ * This function completes arena initialization by writing
+ * all the metadata.
+ * It is only called for an uninitialized arena when a write
+ * to that arena occurs for the first time.
+ */
+static int btt_arena_write_layout(struct arena_info *arena, u8 *uuid)
+{
+	int ret;
+	struct btt_sb *super;
+
+	ret = btt_map_init(arena);
+	if (ret)
+		return ret;
+
+	ret = btt_log_init(arena);
+	if (ret)
+		return ret;
+
+	super = kzalloc(sizeof(struct btt_sb), GFP_NOIO);
+	if (!super)
+		return -ENOMEM;
+
+	strncpy(super->signature, BTT_SIG, BTT_SIG_LEN);
+	memcpy(super->uuid, uuid, 16);
+	super->flags = cpu_to_le32(arena->flags);
+	super->version_major = cpu_to_le16(arena->version_major);
+	super->version_minor = cpu_to_le16(arena->version_minor);
+	super->external_lbasize = cpu_to_le32(arena->external_lbasize);
+	super->external_nlba = cpu_to_le32(arena->external_nlba);
+	super->internal_lbasize = cpu_to_le32(arena->internal_lbasize);
+	super->internal_nlba = cpu_to_le32(arena->internal_nlba);
+	super->nfree = cpu_to_le32(arena->nfree);
+	super->infosize = cpu_to_le32(sizeof(struct btt_sb));
+
+	/* TODO: make these relative to arena start. For now we get this
+	 * since each file = 1 arena = 1 dimm, but will change */
+	super->nextoff = cpu_to_le64(arena->nextoff);
+	/*
+	 * Subtract arena->infooff (arena start) so numbers are relative
+	 * to 'this' arena
+	 */
+	super->dataoff = cpu_to_le64(arena->dataoff - arena->infooff);
+	super->mapoff = cpu_to_le64(arena->mapoff - arena->infooff);
+	super->logoff = cpu_to_le64(arena->logoff - arena->infooff);
+	super->info2off = cpu_to_le64(arena->info2off - arena->infooff);
+
+	super->flags = 0;
+	super->checksum = cpu_to_le64(nd_btt_sb_checksum(super));
+
+	ret = btt_info_write(arena, super);
+
+	kfree(super);
+	return ret;
+}
+
+/*
+ * This function completes the initialization for the BTT namespace
+ * such that it is ready to accept IOs
+ */
+static int btt_meta_init(struct btt *btt)
+{
+	int ret = 0;
+	struct arena_info *arena;
+
+	mutex_lock(&btt->init_lock);
+	list_for_each_entry(arena, &btt->arena_list, list) {
+		ret = btt_arena_write_layout(arena, btt->nd_btt->uuid);
+		if (ret)
+			goto unlock;
+
+		ret = btt_freelist_init(arena);
+		if (ret)
+			goto unlock;
+
+		ret = btt_rtt_init(arena);
+		if (ret)
+			goto unlock;
+
+		ret = btt_maplocks_init(arena);
+		if (ret)
+			goto unlock;
+	}
+
+	btt->init_state = INIT_READY;
+
+ unlock:
+	mutex_unlock(&btt->init_lock);
+	return ret;
+}
+
+/*
+ * This function calculates the arena in which the given LBA lies
+ * by doing a linear walk. This is acceptable since we expect only
+ * a few arenas. If we have backing devices that get much larger,
+ * we can construct a balanced binary tree of arenas at init time
+ * so that this range search becomes faster.
+ */
+static int lba_to_arena(struct btt *btt, sector_t sector, __u32 *premap,
+				struct arena_info **arena)
+{
+	struct arena_info *arena_list;
+	__u64 lba = div_u64(sector << SECTOR_SHIFT, btt->lbasize);
+
+	list_for_each_entry(arena_list, &btt->arena_list, list) {
+		if (lba < arena_list->external_nlba) {
+			*arena = arena_list;
+			*premap = lba;
+			return 0;
+		}
+		lba -= arena_list->external_nlba;
+	}
+
+	return -EIO;
+}
+
+/*
+ * The following (lock_map, unlock_map) are mostly just to improve
+ * readability, since they index into an array of locks
+ */
+static void lock_map(struct arena_info *arena, u32 premap)
+{
+	u32 idx = (premap * MAP_ENT_SIZE / L1_CACHE_BYTES) % arena->nfree;
+
+	spin_lock(&arena->map_locks[idx].lock);
+}
+
+static void unlock_map(struct arena_info *arena, u32 premap)
+{
+	u32 idx = (premap * MAP_ENT_SIZE / L1_CACHE_BYTES) % arena->nfree;
+
+	spin_unlock(&arena->map_locks[idx].lock);
+}
+
+static u64 to_namespace_offset(struct arena_info *arena, u64 lba)
+{
+	return arena->dataoff + ((u64)lba * arena->internal_lbasize);
+}
+
+static int btt_data_read(struct arena_info *arena, struct page *page,
+			unsigned int off, u32 lba, u32 len)
+{
+	int ret;
+	u64 nsoff = to_namespace_offset(arena, lba);
+	void *mem = kmap_atomic(page);
+
+	ret = arena_rw_bytes(arena, mem + off, len, nsoff, READ);
+	kunmap_atomic(mem);
+
+	return ret;
+}
+
+static int btt_data_write(struct arena_info *arena, u32 lba,
+			struct page *page, unsigned int off, u32 len)
+{
+	int ret;
+	u64 nsoff = to_namespace_offset(arena, lba);
+	void *mem = kmap_atomic(page);
+
+	ret = arena_rw_bytes(arena, mem + off, len, nsoff, WRITE);
+	kunmap_atomic(mem);
+
+	return ret;
+}
+
+static void zero_fill_data(struct page *page, unsigned int off, u32 len)
+{
+	void *mem = kmap_atomic(page);
+
+	memset(mem + off, 0, len);
+	kunmap_atomic(mem);
+}
+
+static int btt_read_pg(struct btt *btt, struct page *page, unsigned int off,
+			sector_t sector, unsigned int len)
+{
+	int ret = 0;
+	int t_flag, e_flag;
+	struct arena_info *arena = NULL;
+	u32 lane = 0, premap, postmap;
+
+	while (len) {
+		u32 cur_len;
+
+		lane = nd_region_acquire_lane(btt->nd_region);
+
+		ret = lba_to_arena(btt, sector, &premap, &arena);
+		if (ret)
+			goto out_lane;
+
+		cur_len = min(arena->external_lbasize, len);
+
+		ret = btt_map_read(arena, premap, &postmap, &t_flag, &e_flag);
+		if (ret)
+			goto out_lane;
+
+		/*
+		 * We loop to make sure that the post map LBA didn't change
+		 * from under us between writing the RTT and doing the actual
+		 * read.
+		 */
+		while (1) {
+			u32 new_map;
+
+			if (t_flag) {
+				zero_fill_data(page, off, cur_len);
+				goto out_lane;
+			}
+
+			if (e_flag) {
+				ret = -EIO;
+				goto out_lane;
+			}
+
+			arena->rtt[lane] = RTT_VALID | postmap;
+			/*
+			 * Barrier to make sure this write is not reordered
+			 * to do the verification map_read before the RTT store
+			 */
+			barrier();
+
+			ret = btt_map_read(arena, premap, &new_map, &t_flag,
+						&e_flag);
+			if (ret)
+				goto out_rtt;
+
+			if (postmap == new_map)
+				break;
+
+			postmap = new_map;
+		}
+
+		ret = btt_data_read(arena, page, off, postmap, cur_len);
+		if (ret)
+			goto out_rtt;
+
+		arena->rtt[lane] = RTT_INVALID;
+		nd_region_release_lane(btt->nd_region, lane);
+
+		len -= cur_len;
+		off += cur_len;
+		sector += arena->external_lbasize >> SECTOR_SHIFT;
+	}
+
+	return 0;
+
+ out_rtt:
+	arena->rtt[lane] = RTT_INVALID;
+ out_lane:
+	nd_region_release_lane(btt->nd_region, lane);
+	return ret;
+}
+
+static int btt_write_pg(struct btt *btt, sector_t sector, struct page *page,
+		unsigned int off, unsigned int len)
+{
+	int ret = 0;
+	struct arena_info *arena = NULL;
+	u32 premap = 0, old_postmap, new_postmap, lane = 0, i;
+	struct log_entry log;
+	int sub;
+
+	while (len) {
+		u32 cur_len;
+
+		lane = nd_region_acquire_lane(btt->nd_region);
+
+		ret = lba_to_arena(btt, sector, &premap, &arena);
+		if (ret)
+			goto out_lane;
+		cur_len = min(arena->external_lbasize, len);
+
+		if ((arena->flags & IB_FLAG_ERROR_MASK) != 0) {
+			ret = -EIO;
+			goto out_lane;
+		}
+
+		new_postmap = arena->freelist[lane].block;
+
+		/* Wait if the new block is being read from */
+		for (i = 0; i < arena->nfree; i++)
+			while (arena->rtt[i] == (RTT_VALID | new_postmap))
+				cpu_relax();
+
+
+		if (new_postmap >= arena->internal_nlba) {
+			ret = -EIO;
+			goto out_lane;
+		} else
+			ret = btt_data_write(arena, new_postmap, page,
+						off, cur_len);
+		if (ret)
+			goto out_lane;
+
+		lock_map(arena, premap);
+		ret = btt_map_read(arena, premap, &old_postmap, NULL, NULL);
+		if (ret)
+			goto out_map;
+		if (old_postmap >= arena->internal_nlba) {
+			ret = -EIO;
+			goto out_map;
+		}
+
+		log.lba = cpu_to_le32(premap);
+		log.old_map = cpu_to_le32(old_postmap);
+		log.new_map = cpu_to_le32(new_postmap);
+		log.seq = cpu_to_le32(arena->freelist[lane].seq);
+		sub = arena->freelist[lane].sub;
+		ret = btt_flog_write(arena, lane, sub, &log);
+		if (ret)
+			goto out_map;
+
+		ret = btt_map_write(arena, premap, new_postmap, 0, 0);
+		if (ret)
+			goto out_map;
+
+		unlock_map(arena, premap);
+		nd_region_release_lane(btt->nd_region, lane);
+
+		len -= cur_len;
+		off += cur_len;
+		sector += arena->external_lbasize >> SECTOR_SHIFT;
+	}
+
+	return 0;
+
+ out_map:
+	unlock_map(arena, premap);
+ out_lane:
+	nd_region_release_lane(btt->nd_region, lane);
+	return ret;
+}
+
+static int btt_do_bvec(struct btt *btt, struct page *page,
+			unsigned int len, unsigned int off, int rw,
+			sector_t sector)
+{
+	int ret;
+
+	if (rw == READ) {
+		ret = btt_read_pg(btt, page, off, sector, len);
+		flush_dcache_page(page);
+	} else {
+		flush_dcache_page(page);
+		ret = btt_write_pg(btt, sector, page, off, len);
+	}
+
+	return ret;
+}
+
+static void btt_make_request(struct request_queue *q, struct bio *bio)
+{
+	struct block_device *bdev = bio->bi_bdev;
+	struct btt *btt = q->queuedata;
+	int rw;
+	struct bio_vec bvec;
+	sector_t sector;
+	struct bvec_iter iter;
+	int err = 0;
+
+	sector = bio->bi_iter.bi_sector;
+	if (bio_end_sector(bio) > get_capacity(bdev->bd_disk)) {
+		err = -EIO;
+		goto out;
+	}
+
+	BUG_ON(bio->bi_rw & REQ_DISCARD);
+
+	rw = bio_rw(bio);
+	if (rw == READA)
+		rw = READ;
+
+	bio_for_each_segment(bvec, bio, iter) {
+		unsigned int len = bvec.bv_len;
+
+		BUG_ON(len > PAGE_SIZE);
+		/* Make sure len is in multiples of lbasize. */
+		/* XXX is this right? */
+		BUG_ON(len < btt->lbasize);
+		BUG_ON(len % btt->lbasize);
+
+		err = btt_do_bvec(btt, bvec.bv_page, len, bvec.bv_offset,
+				rw, sector);
+		if (err) {
+			dev_info(&btt->nd_btt->dev,
+					"io error in %s sector %lld, len %d,\n",
+					(rw == READ) ? "READ" : "WRITE",
+					(unsigned long long) sector, len);
+			goto out;
+		}
+		sector += len >> SECTOR_SHIFT;
+	}
+
+out:
+	bio_endio(bio, err);
+}
+
+static int btt_getgeo(struct block_device *bd, struct hd_geometry *geo)
+{
+	/* some standard values */
+	geo->heads = 1 << 6;
+	geo->sectors = 1 << 5;
+	geo->cylinders = get_capacity(bd->bd_disk) >> 11;
+	return 0;
+}
+
+static const struct block_device_operations btt_fops = {
+	.owner =		THIS_MODULE,
+	/* TODO: Disable rw_page till lazy init is reworked */
+	/*.rw_page =		btt_rw_page, */
+	.getgeo =		btt_getgeo,
+};
+
+static int btt_blk_init(struct btt *btt)
+{
+	int ret;
+
+	/* create a new disk and request queue for btt */
+	btt->btt_queue = blk_alloc_queue(GFP_KERNEL);
+	if (!btt->btt_queue)
+		return -ENOMEM;
+
+	btt->btt_disk = alloc_disk(0);
+	if (!btt->btt_disk) {
+		ret = -ENOMEM;
+		goto out_free_queue;
+	}
+
+	sprintf(btt->btt_disk->disk_name, "nd%d", btt->nd_btt->id);
+	btt->btt_disk->driverfs_dev = &btt->nd_btt->dev;
+	btt->btt_disk->major = btt_major;
+	btt->btt_disk->first_minor = 0;
+	btt->btt_disk->fops = &btt_fops;
+	btt->btt_disk->private_data = btt;
+	btt->btt_disk->queue = btt->btt_queue;
+	btt->btt_disk->flags = GENHD_FL_EXT_DEVT;
+
+	blk_queue_make_request(btt->btt_queue, btt_make_request);
+	blk_queue_max_hw_sectors(btt->btt_queue, 1024);
+	blk_queue_bounce_limit(btt->btt_queue, BLK_BOUNCE_ANY);
+	blk_queue_logical_block_size(btt->btt_queue, btt->lbasize);
+	btt->btt_queue->queuedata = btt;
+
+	set_capacity(btt->btt_disk, btt->nlba * btt->lbasize >> SECTOR_SHIFT);
+	add_disk(btt->btt_disk);
+
+	return 0;
+
+out_free_queue:
+	blk_cleanup_queue(btt->btt_queue);
+	return ret;
+}
+
+static void btt_blk_cleanup(struct btt *btt)
+{
+	del_gendisk(btt->btt_disk);
+	put_disk(btt->btt_disk);
+	blk_cleanup_queue(btt->btt_queue);
+}
+
+/**
+ * btt_init - initialize a block translation table for the given device
+ * @nd_btt:	device with BTT geometry and backing device info
+ * @rawsize:	raw size in bytes of the backing device
+ * @lbasize:	lba size of the backing device
+ * @uuid:	A uuid for the backing device - this is stored on media
+ * @maxlane:	maximum number of parallel requests the device can handle
+ *
+ * Initialize a Block Translation Table on a backing device to provide
+ * single sector power fail atomicity.
+ *
+ * Context:
+ * Might sleep.
+ *
+ * Returns:
+ * Pointer to a new struct btt on success, NULL on failure.
+ */
+static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
+		u32 lbasize, u8 *uuid, struct nd_region *nd_region)
+{
+	int ret;
+	struct btt *btt;
+	struct device *dev = &nd_btt->dev;
+
+	btt = kzalloc(sizeof(struct btt), GFP_KERNEL);
+	if (!btt)
+		return NULL;
+
+	btt->nd_btt = nd_btt;
+	btt->rawsize = rawsize;
+	btt->lbasize = lbasize;
+	INIT_LIST_HEAD(&btt->arena_list);
+	mutex_init(&btt->init_lock);
+	btt->nd_region = nd_region;
+
+	ret = discover_arenas(btt);
+	if (ret) {
+		dev_err(dev, "init: error in arena_discover: %d\n", ret);
+		goto out_free;
+	}
+
+	if (btt->init_state != INIT_READY) {
+		btt->num_arenas = (rawsize / ARENA_MAX_SIZE) +
+			((rawsize % ARENA_MAX_SIZE) ? 1 : 0);
+		dev_dbg(dev, "init: %d arenas for %llu rawsize\n",
+				btt->num_arenas, rawsize);
+
+		ret = create_arenas(btt);
+		if (ret) {
+			dev_info(dev, "init: create_arenas: %d\n", ret);
+			goto out_free;
+		}
+
+		ret = btt_meta_init(btt);
+		if (ret) {
+			dev_err(dev, "init: error in meta_init: %d\n", ret);
+			return NULL;
+		}
+	}
+
+	ret = btt_blk_init(btt);
+	if (ret) {
+		dev_err(dev, "init: error in blk_init: %d\n", ret);
+		goto out_free;
+	}
+
+	btt_debugfs_init(btt);
+
+	return btt;
+
+ out_free:
+	kfree(btt);
+	return NULL;
+}
+
+/**
+ * btt_fini - de-initialize a BTT
+ * @btt:	the BTT handle that was generated by btt_init
+ *
+ * De-initialize a Block Translation Table on device removal
+ *
+ * Context:
+ * Might sleep.
+ */
+static void btt_fini(struct btt *btt)
+{
+	if (btt) {
+		btt_blk_cleanup(btt);
+		free_arenas(btt);
+		debugfs_remove_recursive(btt->debugfs_dir);
+		kfree(btt);
+	}
+}
+
+static int link_btt(struct nd_btt *nd_btt)
+{
+	struct block_device *bdev = nd_btt->backing_dev;
+	struct kobject *dir = &part_to_dev(bdev->bd_part)->kobj;
+
+	return sysfs_create_link(dir, &nd_btt->dev.kobj, "nd_btt");
+}
+
+static void unlink_btt(struct nd_btt *nd_btt)
+{
+	struct block_device *bdev = nd_btt->backing_dev;
+	struct kobject *dir;
+
+	/* if backing_dev was deleted first we may have nothing to unlink */
+	if (!nd_btt->backing_dev)
+		return;
+
+	dir = &part_to_dev(bdev->bd_part)->kobj;
+	sysfs_remove_link(dir, "nd_btt");
+}
+
+static int nd_btt_probe(struct device *dev)
+{
+	struct nd_btt *nd_btt = to_nd_btt(dev);
+	struct nd_io_claim *ndio_claim = nd_btt->ndio_claim;
+	struct nd_region *nd_region;
+	struct block_device *bdev;
+	struct btt *btt;
+	size_t rawsize;
+	int rc;
+
+	if (!ndio_claim || !nd_btt->uuid || !nd_btt->backing_dev
+			|| !nd_btt->lbasize)
+		return -ENODEV;
+
+	rc = link_btt(nd_btt);
+	if (rc)
+		return rc;
+
+	bdev = nd_btt->backing_dev;
+	/* the first 4K of a device is padding */
+	nd_btt->offset = nd_partition_offset(bdev) + SZ_4K;
+	rawsize = (bdev->bd_part->nr_sects << SECTOR_SHIFT) - SZ_4K;
+	if (rawsize < ARENA_MIN_SIZE) {
+		rc = -ENXIO;
+		goto err_btt;
+	}
+	nd_btt->ndio = nd_btt->ndio_claim->parent;
+	nd_region = to_nd_region(nd_btt->ndio->dev->parent);
+	btt = btt_init(nd_btt, rawsize, nd_btt->lbasize, nd_btt->uuid,
+			nd_region);
+	if (!btt) {
+		rc = -ENOMEM;
+		goto err_btt;
+	}
+	btt->backing_dev = bdev;
+	dev_set_drvdata(dev, btt);
+
+	return 0;
+ err_btt:
+	unlink_btt(nd_btt);
+	return rc;
+}
+
+static int nd_btt_remove(struct device *dev)
+{
+	struct nd_btt *nd_btt = to_nd_btt(dev);
+	struct btt *btt = dev_get_drvdata(dev);
+
+	btt_fini(btt);
+	unlink_btt(nd_btt);
+
+	return 0;
+}
+
+static struct nd_device_driver nd_btt_driver = {
+	.probe = nd_btt_probe,
+	.remove = nd_btt_remove,
+	.drv = {
+		.name = "nd_btt",
+	},
+	.type = ND_DRIVER_BTT,
+};
+
+static int __init nd_btt_init(void)
+{
+	int rc;
+
+	BUILD_BUG_ON(sizeof(struct btt_sb) != SZ_4K);
+
+	btt_major = register_blkdev(0, "btt");
+	if (btt_major < 0)
+		return btt_major;
+
+	debugfs_root = debugfs_create_dir("btt", NULL);
+	if (IS_ERR_OR_NULL(debugfs_root)) {
+		rc = -ENXIO;
+		goto err_debugfs;
+	}
+
+	rc = nd_driver_register(&nd_btt_driver);
+	if (rc < 0)
+		goto err_driver;
+	return 0;
+
+ err_driver:
+	debugfs_remove_recursive(debugfs_root);
+ err_debugfs:
+	unregister_blkdev(btt_major, "btt");
+
+	return rc;
+}
+
+static void __exit nd_btt_exit(void)
+{
+	driver_unregister(&nd_btt_driver.drv);
+	debugfs_remove_recursive(debugfs_root);
+	unregister_blkdev(btt_major, "btt");
+}
+
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_BTT);
+MODULE_AUTHOR("Vishal Verma <vishal.l.verma@linux.intel.com>");
+MODULE_LICENSE("GPL v2");
+module_init(nd_btt_init);
+module_exit(nd_btt_exit);
diff --git a/drivers/block/nd/btt.h b/drivers/block/nd/btt.h
index e8f6d8e0ddd3..d4e67c75c91f 100644
--- a/drivers/block/nd/btt.h
+++ b/drivers/block/nd/btt.h
@@ -19,6 +19,39 @@
 
 #define BTT_SIG_LEN 16
 #define BTT_SIG "BTT_ARENA_INFO\0"
+#define MAP_ENT_SIZE 4
+#define MAP_TRIM_SHIFT 31
+#define MAP_TRIM_MASK (1 << MAP_TRIM_SHIFT)
+#define MAP_ERR_SHIFT 30
+#define MAP_ERR_MASK (1 << MAP_ERR_SHIFT)
+#define MAP_LBA_MASK (~((1 << MAP_TRIM_SHIFT) | (1 << MAP_ERR_SHIFT)))
+#define MAP_ENT_NORMAL 0xC0000000
+#define LOG_ENT_SIZE sizeof(struct log_entry)
+#define ARENA_MIN_SIZE (1UL << 24)	/* 16 MB */
+#define ARENA_MAX_SIZE (1ULL << 39)	/* 512 GB */
+#define RTT_VALID (1UL << 31)
+#define RTT_INVALID 0
+#define INT_LBASIZE_ALIGNMENT 256
+#define BTT_PG_SIZE 4096
+#define BTT_DEFAULT_NFREE ND_MAX_LANES
+#define LOG_SEQ_INIT 1
+
+#define IB_FLAG_ERROR 0x00000001
+#define IB_FLAG_ERROR_MASK 0x00000001
+
+enum btt_init_state {
+	INIT_UNCHECKED = 0,
+	INIT_NOTFOUND,
+	INIT_READY
+};
+
+struct log_entry {
+	__le32 lba;
+	__le32 old_map;
+	__le32 new_map;
+	__le32 seq;
+	__le64 padding[2];
+};
 
 struct btt_sb {
 	u8 signature[BTT_SIG_LEN];
@@ -42,4 +75,111 @@ struct btt_sb {
 	__le64 checksum;
 };
 
+struct free_entry {
+	u32 block;
+	u8 sub;
+	u8 seq;
+};
+
+struct aligned_lock {
+	union {
+		spinlock_t lock;
+		u8 cacheline_padding[L1_CACHE_BYTES];
+	};
+};
+
+/**
+ * struct arena_info - handle for an arena
+ * @size:		Size in bytes this arena occupies on the raw device.
+ *			This includes arena metadata.
+ * @external_lba_start:	The first external LBA in this arena.
+ * @internal_nlba:	Number of internal blocks available in the arena
+ *			including nfree reserved blocks
+ * @internal_lbasize:	Internal and external lba sizes may be different as
+ *			we can round up 'odd' external lbasizes such as 520B
+ *			to be aligned.
+ * @external_nlba:	Number of blocks contributed by the arena to the number
+ *			reported to upper layers. (internal_nlba - nfree)
+ * @external_lbasize:	LBA size as exposed to upper layers.
+ * @nfree:		A reserve number of 'free' blocks that is used to
+ *			handle incoming writes.
+ * @version_major:	Metadata layout version major.
+ * @version_minor:	Metadata layout version minor.
+ * @nextoff:		Offset in bytes to the start of the next arena.
+ * @infooff:		Offset in bytes to the info block of this arena.
+ * @dataoff:		Offset in bytes to the data area of this arena.
+ * @mapoff:		Offset in bytes to the map area of this arena.
+ * @logoff:		Offset in bytes to the log area of this arena.
+ * @info2off:		Offset in bytes to the backup info block of this arena.
+ * @freelist:		Pointer to in-memory list of free blocks
+ * @rtt:		Pointer to in-memory "Read Tracking Table"
+ * @map_locks:		Spinlocks protecting concurrent map writes
+ * @nd_btt:		Pointer to parent nd_btt structure.
+ * @list:		List head for list of arenas
+ * @debugfs_dir:	Debugfs dentry
+ * @flags:		Arena flags - may signify error states.
+ *
+ * arena_info is a per-arena handle. Once an arena is narrowed down for an
+ * IO, this struct is passed around for the duration of the IO.
+ */
+struct arena_info {
+	u64 size;			/* Total bytes for this arena */
+	u64 external_lba_start;
+	u32 internal_nlba;
+	u32 internal_lbasize;
+	u32 external_nlba;
+	u32 external_lbasize;
+	u32 nfree;
+	u16 version_major;
+	u16 version_minor;
+	/* Byte offsets to the different on-media structures */
+	u64 nextoff;
+	u64 infooff;
+	u64 dataoff;
+	u64 mapoff;
+	u64 logoff;
+	u64 info2off;
+	/* Pointers to other in-memory structures for this arena */
+	struct free_entry *freelist;
+	u32 *rtt;
+	struct aligned_lock *map_locks;
+	struct nd_btt *nd_btt;
+	struct list_head list;
+	struct dentry *debugfs_dir;
+	/* Arena flags */
+	u32 flags;
+};
+
+/**
+ * struct btt - handle for a BTT instance
+ * @btt_disk:		Pointer to the gendisk for BTT device
+ * @btt_queue:		Pointer to the request queue for the BTT device
+ * @arena_list:		Head of the list of arenas
+ * @debugfs_dir:	Debugfs dentry
+ * @backing_dev:	Backing block device for the BTT
+ * @nd_btt:		Parent nd_btt struct
+ * @nlba:		Number of logical blocks exposed to the	upper layers
+ *			after removing the amount of space needed by metadata
+ * @rawsize:		Total size in bytes of the available backing device
+ * @lbasize:		LBA size as requested and presented to upper layers
+ * @lanes:		Per-lane spinlocks
+ * @init_lock:		Mutex used for the BTT initialization
+ * @init_state:		Flag describing the initialization state for the BTT
+ * @num_arenas:		Number of arenas in the BTT instance
+ */
+struct btt {
+	struct gendisk *btt_disk;
+	struct request_queue *btt_queue;
+	struct list_head arena_list;
+	struct dentry *debugfs_dir;
+	struct block_device *backing_dev;
+	struct nd_btt *nd_btt;
+	u64 nlba;
+	unsigned long long rawsize;
+	u32 lbasize;
+	struct nd_region *nd_region;
+	struct mutex init_lock;
+	int init_state;
+	int num_arenas;
+};
 #endif
diff --git a/drivers/block/nd/btt_devs.c b/drivers/block/nd/btt_devs.c
index e6f0b8b999d8..0746db70973c 100644
--- a/drivers/block/nd/btt_devs.c
+++ b/drivers/block/nd/btt_devs.c
@@ -342,7 +342,8 @@ struct nd_btt *nd_btt_create(struct nd_bus *nd_bus)
  */
 u64 nd_btt_sb_checksum(struct btt_sb *btt_sb)
 {
-	u64 sum, sum_save;
+	u64 sum;
+	__le64 sum_save;
 
 	sum_save = btt_sb->checksum;
 	btt_sb->checksum = 0;
diff --git a/drivers/block/nd/libnd.h b/drivers/block/nd/libnd.h
index 3f6b5e09cd67..e188840ed2b9 100644
--- a/drivers/block/nd/libnd.h
+++ b/drivers/block/nd/libnd.h
@@ -76,6 +76,7 @@ struct nd_region_desc {
 	const struct attribute_group **attr_groups;
 	struct nd_interleave_set *nd_set;
 	void *provider_data;
+	int num_lanes;
 };
 
 struct nd_bus;
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index 4ab4765dc9ee..68e9ec824dc8 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -76,6 +76,7 @@ int __init nd_bus_init(void);
 void nd_bus_exit(void);
 int __init nd_dimm_init(void);
 int __init nd_region_init(void);
+void __init nd_region_init_locks(void);
 void nd_dimm_exit(void);
 int nd_region_exit(void);
 void nd_region_probe_start(struct nd_bus *nd_bus, struct device *dev);
diff --git a/drivers/block/nd/nd.h b/drivers/block/nd/nd.h
index c6ed26d4dcad..a29fb7409925 100644
--- a/drivers/block/nd/nd.h
+++ b/drivers/block/nd/nd.h
@@ -22,6 +22,12 @@
 #include "label.h"
 
 enum {
+	/*
+	 * Limits the maximum number of block apertures a dimm can
+	 * support and is an input to the geometry/on-disk-format of a
+	 * BTT instance
+	 */
+	ND_MAX_LANES = 256,
 	SECTOR_SHIFT = 9,
 };
 
@@ -101,7 +107,7 @@ struct nd_region {
 	u16 ndr_mappings;
 	u64 ndr_size;
 	u64 ndr_start;
-	int id;
+	int id, num_lanes;
 	void *provider_data;
 	struct nd_interleave_set *nd_set;
 	struct nd_mapping mapping[0];
@@ -226,6 +232,8 @@ struct nd_btt *to_nd_btt(struct device *dev);
 struct btt_sb;
 u64 nd_btt_sb_checksum(struct btt_sb *btt_sb);
 struct nd_region *to_nd_region(struct device *dev);
+unsigned int nd_region_acquire_lane(struct nd_region *nd_region);
+void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane);
 int nd_region_to_namespace_type(struct nd_region *nd_region);
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
 u64 nd_region_interleave_set_cookie(struct nd_region *nd_region);
diff --git a/drivers/block/nd/region.c b/drivers/block/nd/region.c
index 9d1fd45d78a1..dd5a885cea11 100644
--- a/drivers/block/nd/region.c
+++ b/drivers/block/nd/region.c
@@ -15,6 +15,72 @@
 #include <linux/nd.h>
 #include "nd.h"
 
+static struct {
+	struct {
+		int count[CONFIG_ND_MAX_REGIONS];
+		spinlock_t lock[CONFIG_ND_MAX_REGIONS];
+	} lane[NR_CPUS];
+} nd_percpu_lane;
+
+static void __init nd_region_init_locks(void)
+{
+	int i, j;
+
+	for (i = 0; i < NR_CPUS; i++)
+		for (j = 0; j < CONFIG_ND_MAX_REGIONS; j++)
+			spin_lock_init(&nd_percpu_lane.lane[i].lock[j]);
+}
+
+/**
+ * nd_region_acquire_lane - allocate and lock a lane
+ * @nd_region: region id and number of lanes possible
+ *
+ * A lane correlates to a BLK-data-window and/or a log slot in the BTT.
+ * We optimize for the common case where there are 256 lanes, one
+ * per-cpu.  For larger systems we need to lock to share lanes.  For now
+ * this implementation assumes the cost of maintaining an allocator for
+ * free lanes is on the order of the lock hold time, so it implements a
+ * static lane = cpu % num_lanes mapping.
+ *
+ * In the case of a BTT instance on top of a BLK namespace a lane may be
+ * acquired recursively.  We lock on the first instance.
+ *
+ * In the case of a BTT instance on top of PMEM, we only acquire a lane
+ * for the BTT metadata updates.
+ */
+unsigned int nd_region_acquire_lane(struct nd_region *nd_region)
+{
+	unsigned int cpu, lane;
+
+	cpu = get_cpu();
+
+	if (nd_region->num_lanes < NR_CPUS) {
+		unsigned int id = nd_region->id;
+
+		lane = cpu % nd_region->num_lanes;
+		if (nd_percpu_lane.lane[cpu].count[id]++ == 0)
+			spin_lock(&nd_percpu_lane.lane[lane].lock[id]);
+	} else
+		lane = cpu;
+
+	return lane;
+}
+EXPORT_SYMBOL(nd_region_acquire_lane);
+
+void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane)
+{
+	if (nd_region->num_lanes < NR_CPUS) {
+		unsigned int cpu = get_cpu();
+		unsigned int id = nd_region->id;
+
+		if (--nd_percpu_lane.lane[cpu].count[id] == 0)
+			spin_unlock(&nd_percpu_lane.lane[lane].lock[id]);
+		put_cpu();
+	}
+	put_cpu();
+}
+EXPORT_SYMBOL(nd_region_release_lane);
+
 static int nd_region_probe(struct device *dev)
 {
 	int err;
@@ -76,6 +142,7 @@ static struct nd_device_driver nd_region_driver = {
 
 int __init nd_region_init(void)
 {
+	nd_region_init_locks();
 	return nd_driver_register(&nd_region_driver);
 }
 
diff --git a/drivers/block/nd/region_devs.c b/drivers/block/nd/region_devs.c
index bcdd8e1e21a2..268d9ef67f9c 100644
--- a/drivers/block/nd/region_devs.c
+++ b/drivers/block/nd/region_devs.c
@@ -538,6 +538,12 @@ static noinline struct nd_region *nd_region_create(struct nd_bus *nd_bus,
 	if (nd_region->id < 0) {
 		kfree(nd_region);
 		return NULL;
+	} else if (nd_region->id >= CONFIG_ND_MAX_REGIONS) {
+		dev_err(&nd_bus->dev, "max region limit %d reached\n",
+				CONFIG_ND_MAX_REGIONS);
+		ida_simple_remove(&region_ida, nd_region->id);
+		kfree(nd_region);
+		return NULL;
 	}
 
 	memcpy(nd_region->mapping, ndr_desc->nd_mapping,
@@ -551,6 +557,7 @@ static noinline struct nd_region *nd_region_create(struct nd_bus *nd_bus,
 	nd_region->ndr_mappings = ndr_desc->num_mappings;
 	nd_region->provider_data = ndr_desc->provider_data;
 	nd_region->nd_set = ndr_desc->nd_set;
+	nd_region->num_lanes = ndr_desc->num_lanes;
 	ida_init(&nd_region->ns_ida);
 	dev = &nd_region->dev;
 	dev_set_name(dev, "region%d", nd_region->id);
@@ -567,6 +574,7 @@ static noinline struct nd_region *nd_region_create(struct nd_bus *nd_bus,
 struct nd_region *nd_pmem_region_create(struct nd_bus *nd_bus,
 		struct nd_region_desc *ndr_desc)
 {
+	ndr_desc->num_lanes = ND_MAX_LANES;
 	return nd_region_create(nd_bus, ndr_desc, &nd_pmem_device_type);
 }
 EXPORT_SYMBOL_GPL(nd_pmem_region_create);
@@ -576,6 +584,7 @@ struct nd_region *nd_blk_region_create(struct nd_bus *nd_bus,
 {
 	if (ndr_desc->num_mappings > 1)
 		return NULL;
+	ndr_desc->num_lanes = min(ndr_desc->num_lanes, ND_MAX_LANES);
 	return nd_region_create(nd_bus, ndr_desc, &nd_blk_device_type);
 }
 EXPORT_SYMBOL_GPL(nd_blk_region_create);
@@ -583,6 +592,7 @@ EXPORT_SYMBOL_GPL(nd_blk_region_create);
 struct nd_region *nd_volatile_region_create(struct nd_bus *nd_bus,
 		struct nd_region_desc *ndr_desc)
 {
+	ndr_desc->num_lanes = ND_MAX_LANES;
 	return nd_region_create(nd_bus, ndr_desc, &nd_volatile_device_type);
 }
 EXPORT_SYMBOL_GPL(nd_volatile_region_create);

