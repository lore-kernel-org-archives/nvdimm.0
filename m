Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x243.google.com (mail-pf0-x243.google.com
 [IPv6:2607:f8b0:400e:c00::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 274EE21E1DAD9
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 00:46:01 -0700 (PDT)
Received: by mail-pf0-x243.google.com with SMTP id e3so781540pfc.5
 for <linux-nvdimm@lists.01.org>; Thu, 03 Aug 2017 00:48:12 -0700 (PDT)
From: Steven Swanson <swanson@eng.ucsd.edu>
Subject: [RFC 00/16] NOVA: a new file system for persistent memory
Date: Thu, 03 Aug 2017 00:48:09 -0700
Message-ID: <150174646416.104003.14042713459553361884.stgit@hn>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Steven Swanson <steven.swanson@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

This is an RFC patch series that impements NOVA (NOn-Volatile memory
Accelerated file system), a new file system built for PMEM.

NOVA's goal is to provide a high-performance, full-featured, production-ready
file system tailored for byte-addressable non-volatile memories (e.g., NVDIMMs
and Intel's soon-to-be-released 3DXpoint DIMMs).  It combines design elements
from many other file systems to provide a combination of high-performance,
strong consistency guarantees, and comprehensive data protection.  NOVA supports
DAX-style mmap, and making DAX perform well is a first-order priority in NOVA's
design.

NOVA was developed at the Non-Volatile Systems Laboratory in the Computer
Science and Engineering Department at the University of California, San Diego.
Its primary authors are Andiry Xu <jix024@eng.ucsd.edu>, Lu Zhang
<luzh@eng.ucsd.edu>, and Steven Swanson <swanson@eng.ucsd.edu>.

NOVA is stable enough to run complex applications, but there is substantial
work left to do.  This RFC is intended to gather feedback to guide its
development toward eventual inclusion upstream.

The patches are relative Linux 4.12.

Overview
========

NOVA is primarily a log-structured file system, but rather than maintain a
single global log for the entire file system, it maintains separate logs for
each file (inode).  NOVA breaks the logs into 4KB pages, they need not be
contiguous in memory.  The logs only contain metadata.

File data pages reside outside the log, and log entries for write operations
point to data pages they modify.  File modification uses copy-on-write (COW) to
provide atomic file updates.

For file operations that involve multiple inodes, NOVA use small, fixed-sized
redo logs to atomically append log entries to the logs of the inodes involved.

This structure keeps logs small and makes garbage collection very fast.  It also
enables enormous parallelism during recovery from an unclean unmount, since
threads can scan logs in parallel.

NOVA replicates and checksums all metadata structures and protects file data
with RAID-4-style parity.  It supports checkpoints to facilitate backups.

Documentation/filesystems/NOVA.txt contains some lower-level implementation and
usage information.  A more thorough discussion of NOVA's goals and design is
avaialable in two papers:

NOVA: A Log-structured File system for Hybrid Volatile/Non-volatile Main Memories
http://cseweb.ucsd.edu/~swanson/papers/FAST2016NOVA.pdf
Jian Xu and Steven Swanson
Published in FAST 2016

Hardening the NOVA File System
http://cseweb.ucsd.edu/~swanson/papers/TechReport2017HardenedNOVA.pdf UCSD-CSE
Techreport CS2017-1018
Jian Xu, Lu Zhang, Amirsaman Memaripour, Akshatha
Gangadharaiah, Amit Borase, Tamires Brito Da Silva, Andy Rudoff, Steven
Swanson

-steve


---

Steven Swanson (16):
      NOVA: Documentation
      NOVA: Superblock and fs layout
      NOVA: PMEM allocation system
      NOVA: Inode operations and structures
      NOVA: Log data structures and operations
      NOVA: Lite-weight journaling for complex ops
      NOVA: File and directory operations
      NOVA: Garbage collection
      NOVA: DAX code
      NOVA: File data protection
      NOVA: Snapshot support
      NOVA: Recovery code
      NOVA: Sysfs and ioctl
      NOVA: Read-only pmem devices
      NOVA: Performance measurement
      NOVA: Build infrastructure


 Documentation/filesystems/00-INDEX |    2 
 Documentation/filesystems/nova.txt |  771 +++++++++++++++++
 MAINTAINERS                        |    8 
 README.md                          |  173 ++++
 arch/x86/include/asm/io.h          |    1 
 arch/x86/mm/fault.c                |   11 
 arch/x86/mm/ioremap.c              |   25 -
 drivers/nvdimm/pmem.c              |   14 
 fs/Kconfig                         |    2 
 fs/Makefile                        |    1 
 fs/nova/Kconfig                    |   15 
 fs/nova/Makefile                   |    9 
 fs/nova/balloc.c                   |  827 +++++++++++++++++++
 fs/nova/balloc.h                   |  118 +++
 fs/nova/bbuild.c                   | 1602 ++++++++++++++++++++++++++++++++++++
 fs/nova/checksum.c                 |  912 ++++++++++++++++++++
 fs/nova/dax.c                      | 1346 ++++++++++++++++++++++++++++++
 fs/nova/dir.c                      |  760 +++++++++++++++++
 fs/nova/file.c                     |  943 +++++++++++++++++++++
 fs/nova/gc.c                       |  739 +++++++++++++++++
 fs/nova/inode.c                    | 1467 +++++++++++++++++++++++++++++++++
 fs/nova/inode.h                    |  389 +++++++++
 fs/nova/ioctl.c                    |  185 ++++
 fs/nova/journal.c                  |  474 +++++++++++
 fs/nova/journal.h                  |   61 +
 fs/nova/log.c                      | 1411 ++++++++++++++++++++++++++++++++
 fs/nova/log.h                      |  333 +++++++
 fs/nova/mprotect.c                 |  604 ++++++++++++++
 fs/nova/mprotect.h                 |  190 ++++
 fs/nova/namei.c                    |  919 +++++++++++++++++++++
 fs/nova/nova.h                     | 1137 ++++++++++++++++++++++++++
 fs/nova/nova_def.h                 |  154 +++
 fs/nova/parity.c                   |  411 +++++++++
 fs/nova/perf.c                     |  594 +++++++++++++
 fs/nova/perf.h                     |   96 ++
 fs/nova/rebuild.c                  |  847 +++++++++++++++++++
 fs/nova/snapshot.c                 | 1407 ++++++++++++++++++++++++++++++++
 fs/nova/snapshot.h                 |   98 ++
 fs/nova/stats.c                    |  685 +++++++++++++++
 fs/nova/stats.h                    |  218 +++++
 fs/nova/super.c                    | 1222 +++++++++++++++++++++++++++
 fs/nova/super.h                    |  216 +++++
 fs/nova/symlink.c                  |  153 +++
 fs/nova/sysfs.c                    |  543 ++++++++++++
 include/linux/io.h                 |    2 
 include/linux/mm.h                 |    2 
 include/linux/mm_types.h           |    3 
 kernel/memremap.c                  |   24 +
 mm/memory.c                        |    2 
 mm/mmap.c                          |    1 
 mm/mprotect.c                      |   13 
 51 files changed, 22129 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/filesystems/nova.txt
 create mode 100644 README.md
 create mode 100644 fs/nova/Kconfig
 create mode 100644 fs/nova/Makefile
 create mode 100644 fs/nova/balloc.c
 create mode 100644 fs/nova/balloc.h
 create mode 100644 fs/nova/bbuild.c
 create mode 100644 fs/nova/checksum.c
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
 create mode 100644 fs/nova/mprotect.c
 create mode 100644 fs/nova/mprotect.h
 create mode 100644 fs/nova/namei.c
 create mode 100644 fs/nova/nova.h
 create mode 100644 fs/nova/nova_def.h
 create mode 100644 fs/nova/parity.c
 create mode 100644 fs/nova/perf.c
 create mode 100644 fs/nova/perf.h
 create mode 100644 fs/nova/rebuild.c
 create mode 100644 fs/nova/snapshot.c
 create mode 100644 fs/nova/snapshot.h
 create mode 100644 fs/nova/stats.c
 create mode 100644 fs/nova/stats.h
 create mode 100644 fs/nova/super.c
 create mode 100644 fs/nova/super.h
 create mode 100644 fs/nova/symlink.c
 create mode 100644 fs/nova/sysfs.c

--
Signature
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
