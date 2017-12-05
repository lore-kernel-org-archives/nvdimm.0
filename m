Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AA86E2218E93D
 for <linux-nvdimm@lists.01.org>; Tue,  5 Dec 2017 15:52:34 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [xfsprogs PATCH v2 0/3] Add necessary items for MAP_SYNC testing
Date: Tue,  5 Dec 2017 16:56:48 -0700
Message-Id: <20171205235651.17102-1-ross.zwisler@linux.intel.com>
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
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

This is the second revision of my MAP_SYNC + dm-log-writes support for
xfsprogs.  The previous revision can be found here:

https://lists.01.org/pipermail/linux-nvdimm/2017-November/013326.html

Changes since v1:

 - Updated the dm-log-writes support so that it uses libdevmapper
   instead of calling the "dmsetup" stand-alone exectuable via system().
   (Eric and Darrick)

 - Fixed our MAP_SYNC handling so that instead of defining the flags for
   systems that don't have them in the headers, just set them to 0 and
   fail when the -S flag is used. (Dan)

You can find an xfsprogs branch with this series here:

https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/xfsprogs-dev.git/log/?h=map_sync_v2

Both MAP_SYNC and the DAX enhancements for dm-log-writes can be found in
v4.15-rc*.  For ease of testing I've posted a kernel that is v4.14 plus
just those two patch series here:

https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/linux.git/log/?h=map_sync_dm_log_writes

---

As suggested by Dave Chinner:

    As I say to all these sorts of one-off test prgrams: please add the
    new MAP_SYNC flag to xfs_io rather than writing a one-off
    test program to set it and write some data.

    And if we're going to be adding special custom tests just because
    we need to insert dm-log marks, add that functionality to xfs_io,
    too.

    That way we can create complex custom dm logwrite tests without
    needing one-off test programs for them all...

This series enhances xfs_io by adding support for the MAP_SYNC mmap() flag
and for dm-log-writes marks.  This allows the resulting xfstest for
MAP_SYNC to be much simpler and have no custom C programs.

Ross Zwisler (3):
  xfs_io: fix compiler warnings in getfsmap code
  xfs_io: add MAP_SYNC support to mmap()
  xfs_io: add a new 'log_writes' command

 configure.ac            |   2 +
 debian/control          |   2 +-
 include/builddefs.in    |   3 ++
 include/linux.h         |   8 ++++
 io/Makefile             |  10 +++++
 io/fsmap.c              |   4 +-
 io/init.c               |   1 +
 io/io.h                 |   7 ++++
 io/log_writes.c         | 101 ++++++++++++++++++++++++++++++++++++++++++++++++
 io/mmap.c               |  23 ++++++++---
 m4/Makefile             |   1 +
 m4/package_devmapper.m4 |  11 ++++++
 m4/package_libcdev.m4   |  16 ++++++++
 man/man8/xfs_io.8       |  29 +++++++++++++-
 14 files changed, 208 insertions(+), 10 deletions(-)
 create mode 100644 io/log_writes.c
 create mode 100644 m4/package_devmapper.m4

-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
