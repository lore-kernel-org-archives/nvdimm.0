Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1CD0D22085883
 for <linux-nvdimm@lists.01.org>; Thu, 21 Dec 2017 14:03:20 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [xfsprogs PATCH v4 0/2] Add necessary items for MAP_SYNC testing
Date: Thu, 21 Dec 2017 15:07:58 -0700
Message-Id: <20171221220800.14382-1-ross.zwisler@linux.intel.com>
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
To: linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

This is the fourth revision of my MAP_SYNC + dm-log-writes support for
xfsprogs.  The previous revision can be found here:

https://lists.01.org/pipermail/linux-nvdimm/2017-December/013473.html

Changes since v3:

 - Fixed indentation of variable declarations (Darrick).

 - Added a comment for the case where MAP_SYNC and MAP_SHARED_VALIDATE
   aren't defined in system headers and we fail an msync command
   (Darrick).
 
 - Dropped patch 1 of the previous series which fixed compiler warnings.
   A fix for this issue was already submitted by Dave.

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

Ross Zwisler (2):
  xfs_io: add MAP_SYNC support to mmap()
  xfs_io: add a new 'log_writes' command

 configure.ac            |   2 +
 debian/control          |   2 +-
 include/builddefs.in    |   3 ++
 include/linux.h         |   8 ++++
 io/Makefile             |  10 +++++
 io/init.c               |   1 +
 io/io.h                 |   7 ++++
 io/log_writes.c         | 106 ++++++++++++++++++++++++++++++++++++++++++++++++
 io/mmap.c               |  29 ++++++++++---
 m4/Makefile             |   1 +
 m4/package_devmapper.m4 |  11 +++++
 m4/package_libcdev.m4   |  16 ++++++++
 man/man8/xfs_io.8       |  29 ++++++++++++-
 13 files changed, 217 insertions(+), 8 deletions(-)
 create mode 100644 io/log_writes.c
 create mode 100644 m4/package_devmapper.m4

-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
