Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 02/17] nd_btt: atomic sector updates
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 25 Jun 2015 05:36:29 -0400
Message-ID: <20150625093629.40066.70702.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
References: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, boaz@plexistor.com, toshi.kani@hp.com, Vishal Verma <vishal.l.verma@linux.intel.com>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, linux-acpi@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, hch@lst.de, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Vishal Verma <vishal.l.verma@intel.com>

BTT stands for Block Translation Table, and is a way to provide power
fail sector atomicity semantics for block devices that have the ability
to perform byte granularity IO. It relies on the capability of libnvdimm
namespace devices to do byte aligned IO.

The BTT works as a stacked blocked device, and reserves a chunk of space
from the backing device for its accounting metadata. It is a bio-based
driver because all IO is done synchronously, and there is no queuing or
asynchronous completions at either the device or the driver level.

The BTT uses 'lanes' to index into various 'on-disk' data structures,
and lanes also act as a synchronization mechanism in case there are more
CPUs than available lanes. We did a comparison between two lane lock
strategies - first where we kept an atomic counter around that tracked
which was the last lane that was used, and 'our' lane was determined by
atomically incrementing that. That way, for the nr_cpus > nr_lanes case,
theoretically, no CPU would be blocked waiting for a lane. The other
strategy was to use the cpu number we're scheduled on to and hash it to
a lane number. Theoretically, this could block an IO that could've
otherwise run using a different, free lane. But some fio workloads
showed that the direct cpu -> lane hash performed faster than tracking
'last lane' - my reasoning is the cache thrash caused by moving the
atomic variable made that approach slower than simply waiting out the
in-progress IO. This supports the conclusion that the driver can be a
very simple bio-based one that does synchronous IOs instead of queuing.

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
 Documentation/nvdimm/btt.txt    |  273 ++++++++
 drivers/acpi/nfit.c             |    1 
 drivers/nvdimm/Kconfig          |   28 +
 drivers/nvdimm/Makefile         |    3 
 drivers/nvdimm/btt.c            | 1371 +++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/btt.h            |  141 ++++
 drivers/nvdimm/btt_devs.c       |    3 
 drivers/nvdimm/namespace_devs.c |   24 +
 drivers/nvdimm/nd.h             |   22 +
 drivers/nvdimm/pmem.c           |   14 
 drivers/nvdimm/region.c         |   12 
 drivers/nvdimm/region_devs.c    |   82 ++
 include/linux/libnvdimm.h       |    1 
 13 files changed, 1950 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/nvdimm/btt.txt
 create mode 100644 drivers/nvdimm/btt.c

diff --git a/Documentation/nvdimm/btt.txt b/Documentation/nvdimm/btt.txt
new file mode 100644
index 000000000000..95134d5ec4a0
--- /dev/null
+++ b/Documentation/nvdimm/btt.txt
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
diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 35af6f7f0abd..fc38b49eff7d 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -902,6 +902,7 @@ static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
 		} else {
 			nd_mapping->size = nfit_mem->bdw->capacity;
 			nd_mapping->start = nfit_mem->bdw->start_address;
+			ndr_desc->num_lanes = nfit_mem->bdw->windows;
 			blk_valid = 1;
 		}
 
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 5680e8e7a7aa..204ee0796411 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -8,11 +8,11 @@ menuconfig LIBNVDIMM
 	  NFIT, or otherwise can discover NVDIMM resources, a libnvdimm
 	  bus is registered to advertise PMEM (persistent memory)
 	  namespaces (/dev/pmemX) and BLK (sliding mmio window(s))
-	  namespaces (/dev/ndX). A PMEM namespace refers to a memory
-	  resource that may span multiple DIMMs and support DAX (see
-	  CONFIG_DAX).  A BLK namespace refers to an NVDIMM control
-	  region which exposes an mmio register set for windowed
-	  access mode to non-volatile memory.
+	  namespaces (/dev/ndblkX.Y). A PMEM namespace refers to a
+	  memory resource that may span multiple DIMMs and support DAX
+	  (see CONFIG_DAX).  A BLK namespace refers to an NVDIMM control
+	  region which exposes an mmio register set for windowed access
+	  mode to non-volatile memory.
 
 if LIBNVDIMM
 
@@ -20,6 +20,7 @@ config BLK_DEV_PMEM
 	tristate "PMEM: Persistent memory block device support"
 	default LIBNVDIMM
 	depends on HAS_IOMEM
+	select ND_BTT if BTT
 	help
 	  Memory ranges for PMEM are described by either an NFIT
 	  (NVDIMM Firmware Interface Table, see CONFIG_NFIT_ACPI), a
@@ -33,7 +34,22 @@ config BLK_DEV_PMEM
 
 	  Say Y if you want to use an NVDIMM
 
+config ND_BTT
+	tristate
+
 config BTT
-	def_bool y
+	bool "BTT: Block Translation Table (atomic sector updates)"
+	default y if LIBNVDIMM
+	help
+	  The Block Translation Table (BTT) provides atomic sector
+	  update semantics for persistent memory devices, so that
+	  applications that rely on sector writes not being torn (a
+	  guarantee that typical disks provide) can continue to do so.
+	  The BTT manifests itself as an alternate personality for an
+	  NVDIMM namespace, i.e. a namespace can be in raw mode (pmemX,
+	  ndblkX.Y, etc...), or 'sectored' mode, (pmemXs, ndblkX.Ys,
+	  etc...).
+
+	  Select Y if unsure
 
 endif
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index 6085b4bd7312..d2aab6c58492 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -1,8 +1,11 @@
 obj-$(CONFIG_LIBNVDIMM) += libnvdimm.o
 obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
+obj-$(CONFIG_ND_BTT) += nd_btt.o
 
 nd_pmem-y := pmem.o
 
+nd_btt-y := btt.o
+
 libnvdimm-y := core.o
 libnvdimm-y += bus.o
 libnvdimm-y += dimm_devs.o
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
new file mode 100644
index 000000000000..7ae38aac2c25
--- /dev/null
+++ b/drivers/nvdimm/btt.c
@@ -0,0 +1,1371 @@
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
+static int arena_read_bytes(struct arena_info *arena, resource_size_t offset,
+		void *buf, size_t n)
+{
+	struct nd_btt *nd_btt = arena->nd_btt;
+	struct nd_namespace_common *ndns = nd_btt->ndns;
+
+	/* arena offsets are 4K from the base of the device */
+	offset += SZ_4K;
+	return nvdimm_read_bytes(ndns, offset, buf, n);
+}
+
+static int arena_write_bytes(struct arena_info *arena, resource_size_t offset,
+		void *buf, size_t n)
+{
+	struct nd_btt *nd_btt = arena->nd_btt;
+	struct nd_namespace_common *ndns = nd_btt->ndns;
+
+	/* arena offsets are 4K from the base of the device */
+	offset += SZ_4K;
+	return nvdimm_write_bytes(ndns, offset, buf, n);
+}
+
+static int btt_info_write(struct arena_info *arena, struct btt_sb *super)
+{
+	int ret;
+
+	ret = arena_write_bytes(arena, arena->info2off, super,
+			sizeof(struct btt_sb));
+	if (ret)
+		return ret;
+
+	return arena_write_bytes(arena, arena->infooff, super,
+			sizeof(struct btt_sb));
+}
+
+static int btt_info_read(struct arena_info *arena, struct btt_sb *super)
+{
+	WARN_ON(!super);
+	return arena_read_bytes(arena, arena->infooff, super,
+			sizeof(struct btt_sb));
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
+	return arena_write_bytes(arena, ns_off, &mapping, MAP_ENT_SIZE);
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
+	ret = arena_read_bytes(arena, ns_off, &in, MAP_ENT_SIZE);
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
+	return arena_read_bytes(arena,
+			arena->logoff + (2 * lane * LOG_ENT_SIZE), ent,
+			2 * LOG_ENT_SIZE);
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
+	ret = arena_write_bytes(arena, ns_off, src, log_half);
+	if (ret)
+		return ret;
+
+	ns_off += log_half;
+	src += log_half;
+	return arena_write_bytes(arena, ns_off, src, log_half);
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
+ * This function initializes the BTT map to the initial state, which is
+ * all-zeroes, and indicates an identity mapping
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
+		ret = arena_write_bytes(arena, arena->mapoff + offset, zerobuf,
+				size);
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
+				u8 *uuid, u32 lbasize)
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
+	if (lbasize != le32_to_cpu(super->external_lbasize))
+		return 0;
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
+		if (!arena_is_valid(arena, super, btt->nd_btt->uuid,
+				btt->lbasize)) {
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
+	__u64 lba = div_u64(sector << SECTOR_SHIFT, btt->sector_size);
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
+		__acquires(&arena->map_locks[idx].lock)
+{
+	u32 idx = (premap * MAP_ENT_SIZE / L1_CACHE_BYTES) % arena->nfree;
+
+	spin_lock(&arena->map_locks[idx].lock);
+}
+
+static void unlock_map(struct arena_info *arena, u32 premap)
+		__releases(&arena->map_locks[idx].lock)
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
+	ret = arena_read_bytes(arena, nsoff, mem + off, len);
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
+	ret = arena_write_bytes(arena, nsoff, mem + off, len);
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
+		cur_len = min(btt->sector_size, len);
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
+		sector += btt->sector_size >> SECTOR_SHIFT;
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
+		cur_len = min(btt->sector_size, len);
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
+		sector += btt->sector_size >> SECTOR_SHIFT;
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
+	struct btt *btt = q->queuedata;
+	struct bvec_iter iter;
+	struct bio_vec bvec;
+	int err = 0, rw;
+
+	rw = bio_data_dir(bio);
+	bio_for_each_segment(bvec, bio, iter) {
+		unsigned int len = bvec.bv_len;
+
+		BUG_ON(len > PAGE_SIZE);
+		/* Make sure len is in multiples of sector size. */
+		/* XXX is this right? */
+		BUG_ON(len < btt->sector_size);
+		BUG_ON(len % btt->sector_size);
+
+		err = btt_do_bvec(btt, bvec.bv_page, len, bvec.bv_offset,
+				rw, iter.bi_sector);
+		if (err) {
+			dev_info(&btt->nd_btt->dev,
+					"io error in %s sector %lld, len %d,\n",
+					(rw == READ) ? "READ" : "WRITE",
+					(unsigned long long) iter.bi_sector, len);
+			goto out;
+		}
+	}
+
+out:
+	bio_endio(bio, err);
+}
+
+static int btt_rw_page(struct block_device *bdev, sector_t sector,
+		struct page *page, int rw)
+{
+	struct btt *btt = bdev->bd_disk->private_data;
+
+	btt_do_bvec(btt, page, PAGE_CACHE_SIZE, 0, rw, sector);
+	page_endio(page, rw & WRITE, 0);
+	return 0;
+}
+
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
+	.rw_page =		btt_rw_page,
+	.getgeo =		btt_getgeo,
+};
+
+static int btt_blk_init(struct btt *btt)
+{
+	struct nd_btt *nd_btt = btt->nd_btt;
+	struct nd_namespace_common *ndns = nd_btt->ndns;
+
+	/* create a new disk and request queue for btt */
+	btt->btt_queue = blk_alloc_queue(GFP_KERNEL);
+	if (!btt->btt_queue)
+		return -ENOMEM;
+
+	btt->btt_disk = alloc_disk(0);
+	if (!btt->btt_disk) {
+		blk_cleanup_queue(btt->btt_queue);
+		return -ENOMEM;
+	}
+
+	nvdimm_namespace_disk_name(ndns, btt->btt_disk->disk_name);
+	btt->btt_disk->driverfs_dev = &btt->nd_btt->dev;
+	btt->btt_disk->major = btt_major;
+	btt->btt_disk->first_minor = 0;
+	btt->btt_disk->fops = &btt_fops;
+	btt->btt_disk->private_data = btt;
+	btt->btt_disk->queue = btt->btt_queue;
+	btt->btt_disk->flags = GENHD_FL_EXT_DEVT;
+
+	blk_queue_make_request(btt->btt_queue, btt_make_request);
+	blk_queue_logical_block_size(btt->btt_queue, btt->sector_size);
+	blk_queue_max_hw_sectors(btt->btt_queue, UINT_MAX);
+	blk_queue_bounce_limit(btt->btt_queue, BLK_BOUNCE_ANY);
+	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, btt->btt_queue);
+	btt->btt_queue->queuedata = btt;
+
+	set_capacity(btt->btt_disk,
+			btt->nlba * btt->sector_size >> SECTOR_SHIFT);
+	add_disk(btt->btt_disk);
+
+	return 0;
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
+	btt->sector_size = ((lbasize >= 4096) ? 4096 : 512);
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
+int nvdimm_namespace_attach_btt(struct nd_namespace_common *ndns)
+{
+	struct nd_btt *nd_btt = to_nd_btt(ndns->claim);
+	struct nd_region *nd_region;
+	struct btt *btt;
+	size_t rawsize;
+
+	if (!nd_btt->uuid || !nd_btt->ndns || !nd_btt->lbasize)
+		return -ENODEV;
+
+	rawsize = nvdimm_namespace_capacity(ndns) - SZ_4K;
+	if (rawsize < ARENA_MIN_SIZE) {
+		return -ENXIO;
+	}
+	nd_region = to_nd_region(nd_btt->dev.parent);
+	btt = btt_init(nd_btt, rawsize, nd_btt->lbasize, nd_btt->uuid,
+			nd_region);
+	if (!btt)
+		return -ENOMEM;
+	nd_btt->btt = btt;
+
+	return 0;
+}
+EXPORT_SYMBOL(nvdimm_namespace_attach_btt);
+
+int nvdimm_namespace_detach_btt(struct nd_namespace_common *ndns)
+{
+	struct nd_btt *nd_btt = to_nd_btt(ndns->claim);
+	struct btt *btt = nd_btt->btt;
+
+	btt_fini(btt);
+	nd_btt->btt = NULL;
+
+	return 0;
+}
+EXPORT_SYMBOL(nvdimm_namespace_detach_btt);
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
+	return 0;
+
+ err_debugfs:
+	unregister_blkdev(btt_major, "btt");
+
+	return rc;
+}
+
+static void __exit nd_btt_exit(void)
+{
+	debugfs_remove_recursive(debugfs_root);
+	unregister_blkdev(btt_major, "btt");
+}
+
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_BTT);
+MODULE_AUTHOR("Vishal Verma <vishal.l.verma@linux.intel.com>");
+MODULE_LICENSE("GPL v2");
+module_init(nd_btt_init);
+module_exit(nd_btt_exit);
diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
index e8f6d8e0ddd3..8c95a7792c3e 100644
--- a/drivers/nvdimm/btt.h
+++ b/drivers/nvdimm/btt.h
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
@@ -42,4 +75,112 @@ struct btt_sb {
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
+ * @nd_btt:		Parent nd_btt struct
+ * @nlba:		Number of logical blocks exposed to the	upper layers
+ *			after removing the amount of space needed by metadata
+ * @rawsize:		Total size in bytes of the available backing device
+ * @lbasize:		LBA size as requested and presented to upper layers.
+ *			This is sector_size + size of any metadata.
+ * @sector_size:	The Linux sector size - 512 or 4096
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
+	struct nd_btt *nd_btt;
+	u64 nlba;
+	unsigned long long rawsize;
+	u32 lbasize;
+	u32 sector_size;
+	struct nd_region *nd_region;
+	struct mutex init_lock;
+	int init_state;
+	int num_arenas;
+};
 #endif
diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index 4636beb8b7ed..cde9f075fcea 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -349,7 +349,8 @@ struct device *nd_btt_create(struct nd_region *nd_region)
  */
 u64 nd_btt_sb_checksum(struct btt_sb *btt_sb)
 {
-	u64 sum, sum_save;
+	u64 sum;
+	__le64 sum_save;
 
 	sum_save = btt_sb->checksum;
 	btt_sb->checksum = 0;
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 2c50a0719f8d..4aa647c8d644 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -76,6 +76,30 @@ static bool is_namespace_io(struct device *dev)
 	return dev ? dev->type == &namespace_io_device_type : false;
 }
 
+const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
+		char *name)
+{
+	struct nd_region *nd_region = to_nd_region(ndns->dev.parent);
+	const char *suffix = "";
+
+	if (ndns->claim && is_nd_btt(ndns->claim))
+		suffix = "s";
+
+	if (is_namespace_pmem(&ndns->dev) || is_namespace_io(&ndns->dev))
+		sprintf(name, "pmem%d%s", nd_region->id, suffix);
+	else if (is_namespace_blk(&ndns->dev)) {
+		struct nd_namespace_blk *nsblk;
+
+		nsblk = to_nd_namespace_blk(&ndns->dev);
+		sprintf(name, "ndblk%d.%d%s", nd_region->id, nsblk->id, suffix);
+	} else {
+		return NULL;
+	}
+
+	return name;
+}
+EXPORT_SYMBOL(nvdimm_namespace_disk_name);
+
 static ssize_t nstype_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 329e4d54969f..78177a76a05d 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -20,6 +20,12 @@
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
 
@@ -75,6 +81,11 @@ static inline struct nd_namespace_index *to_next_namespace_index(
 	for (res = (ndd)->dpa.child, next = res ? res->sibling : NULL; \
 			res; res = next, next = next ? next->sibling : NULL)
 
+struct nd_percpu_lane {
+	int count;
+	spinlock_t lock;
+};
+
 struct nd_region {
 	struct device dev;
 	struct ida ns_ida;
@@ -83,9 +94,10 @@ struct nd_region {
 	u16 ndr_mappings;
 	u64 ndr_size;
 	u64 ndr_start;
-	int id;
+	int id, num_lanes;
 	void *provider_data;
 	struct nd_interleave_set *nd_set;
+	struct nd_percpu_lane __percpu *lane;
 	struct nd_mapping mapping[0];
 };
 
@@ -99,9 +111,11 @@ static inline unsigned nd_inc_seq(unsigned seq)
 	return next[seq & 3];
 }
 
+struct btt;
 struct nd_btt {
 	struct device dev;
 	struct nd_namespace_common *ndns;
+	struct btt *btt;
 	unsigned long lbasize;
 	u8 *uuid;
 	int id;
@@ -156,6 +170,8 @@ static inline struct device *nd_btt_create(struct nd_region *nd_region)
 
 #endif
 struct nd_region *to_nd_region(struct device *dev);
+unsigned int nd_region_acquire_lane(struct nd_region *nd_region);
+void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane);
 int nd_region_to_nstype(struct nd_region *nd_region);
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
 u64 nd_region_interleave_set_cookie(struct nd_region *nd_region);
@@ -171,4 +187,8 @@ struct resource *nvdimm_allocate_dpa(struct nvdimm_drvdata *ndd,
 		resource_size_t n);
 resource_size_t nvdimm_namespace_capacity(struct nd_namespace_common *ndns);
 struct nd_namespace_common *nvdimm_namespace_common_probe(struct device *dev);
+int nvdimm_namespace_attach_btt(struct nd_namespace_common *ndns);
+int nvdimm_namespace_detach_btt(struct nd_namespace_common *ndns);
+const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
+		char *name);
 #endif /* __ND_H__ */
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index d0c6b4bdba69..7346054bccbb 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -160,7 +160,6 @@ static void pmem_detach_disk(struct pmem_device *pmem)
 static int pmem_attach_disk(struct nd_namespace_common *ndns,
 		struct pmem_device *pmem)
 {
-	struct nd_region *nd_region = to_nd_region(ndns->dev.parent);
 	struct gendisk *disk;
 
 	pmem->pmem_queue = blk_alloc_queue(GFP_KERNEL);
@@ -183,7 +182,7 @@ static int pmem_attach_disk(struct nd_namespace_common *ndns,
 	disk->private_data	= pmem;
 	disk->queue		= pmem->pmem_queue;
 	disk->flags		= GENHD_FL_EXT_DEVT;
-	sprintf(disk->disk_name, "pmem%d", nd_region->id);
+	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	disk->driverfs_dev = &ndns->dev;
 	set_capacity(disk, pmem->size >> 9);
 	pmem->pmem_disk = disk;
@@ -211,17 +210,6 @@ static int pmem_rw_bytes(struct nd_namespace_common *ndns,
 	return 0;
 }
 
-static int nvdimm_namespace_attach_btt(struct nd_namespace_common *ndns)
-{
-	/* TODO */
-	return -ENXIO;
-}
-
-static void nvdimm_namespace_detach_btt(struct nd_namespace_common *ndns)
-{
-	/* TODO */
-}
-
 static void pmem_free(struct pmem_device *pmem)
 {
 	iounmap(pmem->virt_addr);
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 2a5f3f53d79d..eb8aebcd4800 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -10,6 +10,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
+#include <linux/cpumask.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/nd.h>
@@ -18,10 +19,21 @@
 static int nd_region_probe(struct device *dev)
 {
 	int err;
+	static unsigned long once;
 	struct nd_region_namespaces *num_ns;
 	struct nd_region *nd_region = to_nd_region(dev);
 	int rc = nd_region_register_namespaces(nd_region, &err);
 
+	if (nd_region->num_lanes > num_online_cpus()
+			&& nd_region->num_lanes < num_possible_cpus()
+			&& !test_and_set_bit(0, &once)) {
+		dev_info(dev, "online cpus (%d) < concurrent i/o lanes (%d) < possible cpus (%d)\n",
+				num_online_cpus(), nd_region->num_lanes,
+				num_possible_cpus());
+		dev_info(dev, "setting nr_cpus=%d may yield better libnvdimm device performance\n",
+				nd_region->num_lanes);
+	}
+
 	num_ns = devm_kzalloc(dev, sizeof(*num_ns), GFP_KERNEL);
 	if (!num_ns)
 		return -ENOMEM;
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index f4cc1d848156..abf344651358 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -32,6 +32,7 @@ static void nd_region_release(struct device *dev)
 
 		put_device(&nvdimm->dev);
 	}
+	free_percpu(nd_region->lane);
 	ida_simple_remove(&region_ida, nd_region->id);
 	kfree(nd_region);
 }
@@ -531,13 +532,66 @@ void *nd_region_provider_data(struct nd_region *nd_region)
 }
 EXPORT_SYMBOL_GPL(nd_region_provider_data);
 
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
+	if (nd_region->num_lanes < nr_cpu_ids) {
+		struct nd_percpu_lane *ndl_lock, *ndl_count;
+
+		lane = cpu % nd_region->num_lanes;
+		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
+		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
+		if (ndl_count->count++ == 0)
+			spin_lock(&ndl_lock->lock);
+	} else
+		lane = cpu;
+
+	return lane;
+}
+EXPORT_SYMBOL(nd_region_acquire_lane);
+
+void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane)
+{
+	if (nd_region->num_lanes < nr_cpu_ids) {
+		unsigned int cpu = get_cpu();
+		struct nd_percpu_lane *ndl_lock, *ndl_count;
+
+		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
+		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
+		if (--ndl_count->count == 0)
+			spin_unlock(&ndl_lock->lock);
+		put_cpu();
+	}
+	put_cpu();
+}
+EXPORT_SYMBOL(nd_region_release_lane);
+
 static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_region_desc *ndr_desc, struct device_type *dev_type,
 		const char *caller)
 {
 	struct nd_region *nd_region;
 	struct device *dev;
-	u16 i;
+	unsigned int i;
 
 	for (i = 0; i < ndr_desc->num_mappings; i++) {
 		struct nd_mapping *nd_mapping = &ndr_desc->nd_mapping[i];
@@ -557,9 +611,19 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 	if (!nd_region)
 		return NULL;
 	nd_region->id = ida_simple_get(&region_ida, 0, 0, GFP_KERNEL);
-	if (nd_region->id < 0) {
-		kfree(nd_region);
-		return NULL;
+	if (nd_region->id < 0)
+		goto err_id;
+
+	nd_region->lane = alloc_percpu(struct nd_percpu_lane);
+	if (!nd_region->lane)
+		goto err_percpu;
+
+        for (i = 0; i < nr_cpu_ids; i++) {
+		struct nd_percpu_lane *ndl;
+
+		ndl = per_cpu_ptr(nd_region->lane, i);
+		spin_lock_init(&ndl->lock);
+		ndl->count = 0;
 	}
 
 	memcpy(nd_region->mapping, ndr_desc->nd_mapping,
@@ -573,6 +637,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 	nd_region->ndr_mappings = ndr_desc->num_mappings;
 	nd_region->provider_data = ndr_desc->provider_data;
 	nd_region->nd_set = ndr_desc->nd_set;
+	nd_region->num_lanes = ndr_desc->num_lanes;
 	ida_init(&nd_region->ns_ida);
 	dev = &nd_region->dev;
 	dev_set_name(dev, "region%d", nd_region->id);
@@ -584,11 +649,18 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 	nd_device_register(dev);
 
 	return nd_region;
+
+ err_percpu:
+	ida_simple_remove(&region_ida, nd_region->id);
+ err_id:
+	kfree(nd_region);
+	return NULL;
 }
 
 struct nd_region *nvdimm_pmem_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_region_desc *ndr_desc)
 {
+	ndr_desc->num_lanes = ND_MAX_LANES;
 	return nd_region_create(nvdimm_bus, ndr_desc, &nd_pmem_device_type,
 			__func__);
 }
@@ -599,6 +671,7 @@ struct nd_region *nvdimm_blk_region_create(struct nvdimm_bus *nvdimm_bus,
 {
 	if (ndr_desc->num_mappings > 1)
 		return NULL;
+	ndr_desc->num_lanes = min(ndr_desc->num_lanes, ND_MAX_LANES);
 	return nd_region_create(nvdimm_bus, ndr_desc, &nd_blk_device_type,
 			__func__);
 }
@@ -607,6 +680,7 @@ EXPORT_SYMBOL_GPL(nvdimm_blk_region_create);
 struct nd_region *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_region_desc *ndr_desc)
 {
+	ndr_desc->num_lanes = ND_MAX_LANES;
 	return nd_region_create(nvdimm_bus, ndr_desc, &nd_volatile_device_type,
 			__func__);
 }
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index a59dca17b3aa..531d99dfac68 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -85,6 +85,7 @@ struct nd_region_desc {
 	const struct attribute_group **attr_groups;
 	struct nd_interleave_set *nd_set;
 	void *provider_data;
+	int num_lanes;
 };
 
 struct nvdimm_bus;

