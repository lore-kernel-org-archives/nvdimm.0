Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x244.google.com (mail-pl0-x244.google.com
 [IPv6:2607:f8b0:400e:c01::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7AEFA220C2A5E
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:13:54 -0800 (PST)
Received: by mail-pl0-x244.google.com with SMTP id w12-v6so7030138plp.4
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:13 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 00/83] NOVA: a new file system for persistent memory
Date: Sat, 10 Mar 2018 10:17:41 -0800
Message-Id: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: coughlan@redhat.com, miklos@szeredi.hu, Andiry Xu <jix024@cs.ucsd.edu>, david@fromorbit.com, jack@suse.com, swanson@cs.ucsd.edu, swhiteho@redhat.com, andiry.xu@gmail.com
List-ID: <linux-nvdimm@lists.01.org>

From: Andiry Xu <jix024@cs.ucsd.edu>

This is the second version of RFC patch series that impements
NOVA (NOn-Volatile memory Accelerated file system), a new file system built for PMEM.

NOVA's goal is to provide a high performance, production-ready
file system tailored for byte-addressable non-volatile memories (e.g., NVDIMMs
and Intel's soon-to-be-released 3DXpoint DIMMs).
     
NOVA was developed at the Non-Volatile Systems Laboratory in the Computer
Science and Engineering Department at the University of California, San Diego.
Its primary authors are Andiry Xu <jix024@cs.ucsd.edu>, Lu Zhang
<luzh@eng.ucsd.edu>, and Steven Swanson <swanson@eng.ucsd.edu>.
     
NOVA is stable enough to run complex applications, but there is substantial
work left to do.  This RFC is intended to gather feedback to guide its
development toward eventual inclusion upstream.
     
The patches are based on Linux 4.16-rc4.


Changes from v1:

* Remove snapshot, metadata replication and data parity for future submission.
  This significantly reduces complexity and LOC: 22129 -> 13834.

* Breakdown the code in a more reviewer-friendly way:
  The patchset starts with a simple skeleton and adds more features gradually.
  Each patch leaves the tree in a compilable and working state,
  and is self-contained and small, so easier to review.

* Fix bugs so that NOVA passes xfstests: https://github.com/NVSL/xfstests


Overview
========

NOVA is primarily a log-structured file system, but rather than maintain a
single global log for the entire file system, it maintains separate logs for
each inode.  NOVA breaks the logs into 4KB pages, they need not be
contiguous in memory.  The logs only contain metadata.
	
File data pages reside outside the log, and log entries for write operations
point to data pages they modify.  File modification can be done in
either inplace update or copy-on-write (COW) way to provide atomic file updates.
	
For file operations that involve multiple inodes, NOVA use small, fixed-sized
redo logs to atomically append log entries to the logs of the inodes involved.
	
This structure keeps logs small and makes garbage collection very fast.  It also
enables enormous parallelism during recovery from an unclean unmount, since
threads can scan logs in parallel.
	
Documentation/filesystems/NOVA.txt contains some lower-level implementation and
usage information.  A more thorough discussion of NOVA's goals and design is
avaialable in two papers:
	
NOVA: A Log-structured File system for Hybrid Volatile/Non-volatile Main Memories
http://cseweb.ucsd.edu/~swanson/papers/FAST2016NOVA.pdf
Jian Xu and Steven Swanson
Published in FAST 2016

NOVA-Fortis: A Fault-Tolerant Non-Volatile Main Memory File System
http://cseweb.ucsd.edu/~swanson/papers/SOSP2017-NOVAFortis.pdf
Jian Xu, Lu Zhang, Amirsaman Memaripour, Akshatha Gangadharaiah,
Amit Borase, Tamires Brito Da Silva, Andy Rudoff, Steven Swanson
Published in SOSP 2017

This version contains features from the FAST paper. We leave NOVA-Fortis
features for future.


Build and Run
=============

To build NOVA, build the kernel with PMEM (`CONFIG_BLK_DEV_PMEM`),
DAX (`CONFIG_FS_DAX`) and NOVA (`CONFIG_NOVA_FS`) support.  Install as usual.

NOVA runs on a pmem non-volatile memory region created by memmap kernel option.
For instance, adding 'memmap=16G!8G' to the kernel boot parameters will reserve
16GB memory starting from address 8GB, and the kernel will create a pmem0 
block device under the /dev directory.

After the OS has booted, initialize a NOVA instance with the following commands:

# modprobe nova
# mount -t NOVA -o init /dev/pmem0 /mnt/nova

The above commands create a NOVA instance on /dev/pmem0 and mounts it on
/mnt/nova. Currently NOVA does not have mkfs or fsck support.


Performance
===========

Comparing to other DAX file systems such as ext4-DAX and xfs-DAX,
NOVA provides fine-grained, byte granularity metadata operation,
and it performs better in metadata-intensive and write-intensive applications.
NOVA also excel in append-fsync access pattern, i.e. write-ahead logging,
which is very common in DBMS and key-value stores.

The following test is performed on Intel i7-3770K with 16GB DRAM
and 8GB PMEM emulated with DRAM. The kernel is 4.16-rc4 64bit on Ubuntu 16.04.
Performance may vary on different platforms.


Filebench throughout (ops/s):
		xfs-DAX	ext4-DAX	NOVA
Fileserver	86971	177826		334166
Varmail		148032	288033		999794
Webserver	370245	370144		374130
Webproxy	315084	737544		927216

Webserver is read-intensive and all the file systems have similar performance.


SQLite test:
SQLite has four journaling modes:
Delete: delete the undo log file after transaction commit
Truncate: truncate the undo log file to zero after transaction commit
Persist: write a flag at the beginning of the log file after transaction commit
WAL: write-ahead logging

SQLite insert (transactions/s):
		xfs-DAX	ext4-DAX	NOVA
Delete		18525	23615		45289
Truncate	21930	26391		52046	
Persist		58053	56106		50554
WAL		38622	62703		85395

NOVA performs bad in Persist mode because it does copy-on-write for writes,
and writes 4KB for sub-page writes.


Redis: fsync the WAL file after every set.
Redis set throughout (trans/s):
xfs-DAX	ext4-DAX	NOVA
49771	88308		102560


RocksDB fillunique test (ops/s):
		xfs-DAX	ext4-DAX	NOVA
WAL sync	33563	62066		295655
WAL nosync	254533	288106		393713

Both ext4-DAX and xfs-DAX suffer from high fsync overhead.

More test results are available in the two NOVA papers.

NOVA uses per-inode logging, per-CPU inode table and journal to avoid lock contention.
We use the FxMark test suite (https://github.com/sslab-gatech/fxmark)
to test the filesystem scalability. The result is at
http://cseweb.ucsd.edu/~jix024/sc.pdf


Thanks,
Andiry

---

Andiry Xu (83):
  Introduction and documentation of NOVA filesystem.
  Add nova_def.h.
  Add super.h.
  NOVA inode definition.
  Add NOVA filesystem definitions and useful helper routines.
  Add inode get/read methods.
  Initialize inode_info and rebuild inode information in nova_iget().
  NOVA superblock operations.
  Add Kconfig and Makefile
  Add superblock integrity check.
  Add timing and I/O statistics for performance analysis and profiling.
  Add timing for mount and init.
  Add remount_fs and show_options methods.
  Add range node kmem cache.
  Add free list data structure.
  Initialize block map and free lists in nova_init().
  Add statfs support.
  Add freelist statistics printing.
  Add pmem block free routines.
  Pmem block allocation routines.
  Add log structure.
  Inode log pages allocation and reclaimation.
  Save allocator to pmem in put_super.
  Initialize and allocate inode table.
  Support get normal inode address and inode table extentsion.
  Add inode_map to track inuse inodes.
  Save the inode inuse list to pmem upon umount
  Add NOVA address space operations
  Add write_inode and dirty_inode routines.
  New NOVA inode allocation.
  Add new vfs inode allocation.
  Add log entry definitions.
  Inode log and entry printing for debug purpose.
  Journal: NOVA light weight journal definitions.
  Journal: Lite journal helper routines.
  Journal: Lite journal recovery.
  Journal: Lite journal create and commit.
  Journal: NOVA lite journal initialization.
  Log operation: dentry append.
  Log operation: file write entry append.
  Log operation: setattr entry append
  Log operation: link change append.
  Log operation: in-place update log entry
  Log operation: invalidate log entries
  Log operation: file inode log lookup and assign
  Dir: Add Directory radix tree insert/remove methods.
  Dir: Add initial dentries when initializing a directory inode log.
  Dir: Readdir operation.
  Dir: Append create/remove dentry.
  Inode: Add nova_evict_inode.
  Rebuild: directory inode.
  Rebuild: file inode.
  Namei: lookup.
  Namei: create and mknod.
  Namei: mkdir
  Namei: link and unlink.
  Namei: rmdir
  Namei: rename
  Namei: setattr
  Add special inode operations.
  Super: Add nova_export_ops.
  File: getattr and file inode operations
  File operation: llseek.
  File operation: open, fsync, flush.
  File operation: read.
  Super: Add file write item cache.
  Dax: commit list of file write items to log.
  File operation: copy-on-write write.
  Super: Add module param inplace_data_updates.
  File operation: Inplace write.
  Symlink support.
  File operation: fallocate.
  Dax: Add iomap operations.
  File operation: Mmap.
  File operation: read/write iter.
  Ioctl support.
  GC: Fast garbage collection.
  GC: Thorough garbage collection.
  Normal recovery.
  Failure recovery: bitmap operations.
  Failure recovery: Inode pages recovery routines.
  Failure recovery: Per-CPU recovery.
  Sysfs support.

 Documentation/filesystems/00-INDEX |    2 +
 Documentation/filesystems/nova.txt |  498 +++++++++++++
 MAINTAINERS                        |    8 +
 fs/Kconfig                         |    2 +
 fs/Makefile                        |    1 +
 fs/nova/Kconfig                    |   15 +
 fs/nova/Makefile                   |    8 +
 fs/nova/balloc.c                   |  730 ++++++++++++++++++
 fs/nova/balloc.h                   |   96 +++
 fs/nova/bbuild.c                   | 1437 ++++++++++++++++++++++++++++++++++++
 fs/nova/bbuild.h                   |   28 +
 fs/nova/dax.c                      |  970 ++++++++++++++++++++++++
 fs/nova/dir.c                      |  520 +++++++++++++
 fs/nova/file.c                     |  728 ++++++++++++++++++
 fs/nova/gc.c                       |  459 ++++++++++++
 fs/nova/inode.c                    | 1310 ++++++++++++++++++++++++++++++++
 fs/nova/inode.h                    |  277 +++++++
 fs/nova/ioctl.c                    |  184 +++++
 fs/nova/journal.c                  |  412 +++++++++++
 fs/nova/journal.h                  |   56 ++
 fs/nova/log.c                      | 1111 ++++++++++++++++++++++++++++
 fs/nova/log.h                      |  417 +++++++++++
 fs/nova/namei.c                    |  848 +++++++++++++++++++++
 fs/nova/nova.h                     |  566 ++++++++++++++
 fs/nova/nova_def.h                 |  128 ++++
 fs/nova/rebuild.c                  |  499 +++++++++++++
 fs/nova/stats.c                    |  600 +++++++++++++++
 fs/nova/stats.h                    |  178 +++++
 fs/nova/super.c                    | 1063 ++++++++++++++++++++++++++
 fs/nova/super.h                    |  171 +++++
 fs/nova/symlink.c                  |  133 ++++
 fs/nova/sysfs.c                    |  379 ++++++++++
 32 files changed, 13834 insertions(+)
 create mode 100644 Documentation/filesystems/nova.txt
 create mode 100644 fs/nova/Kconfig
 create mode 100644 fs/nova/Makefile
 create mode 100644 fs/nova/balloc.c
 create mode 100644 fs/nova/balloc.h
 create mode 100644 fs/nova/bbuild.c
 create mode 100644 fs/nova/bbuild.h
 create mode 100644 fs/nova/dax.c
 create mode 100644 fs/nova/dir.c
 create mode 100644 fs/nova/file.c
 create mode 100644 fs/nova/gc.c
 create mode 100644 fs/nova/inode.c
 create mode 100644 fs/nova/inode.h
 create mode 100644 fs/nova/ioctl.c
 create mode 100644 fs/nova/journal.c
 create mode 100644 fs/nova/journal.h
 create mode 100644 fs/nova/log.c
 create mode 100644 fs/nova/log.h
 create mode 100644 fs/nova/namei.c
 create mode 100644 fs/nova/nova.h
 create mode 100644 fs/nova/nova_def.h
 create mode 100644 fs/nova/rebuild.c
 create mode 100644 fs/nova/stats.c
 create mode 100644 fs/nova/stats.h
 create mode 100644 fs/nova/super.c
 create mode 100644 fs/nova/super.h
 create mode 100644 fs/nova/symlink.c
 create mode 100644 fs/nova/sysfs.c

-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
