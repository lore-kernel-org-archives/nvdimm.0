Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2970121B00DC1
 for <linux-nvdimm@lists.01.org>; Fri, 17 Nov 2017 12:21:25 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [xfsprogs PATCH 0/2] Add necessary items for MAP_SYNC testing
Date: Fri, 17 Nov 2017 13:25:22 -0700
Message-Id: <20171117202524.24696-1-ross.zwisler@linux.intel.com>
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
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

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

You can find an xfsprogs branch with this series here:

https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/xfsprogs-dev.git/log/?h=map_sync

Both MAP_SYNC and the DAX enhancements for dm-log-writes will be found in
the upcoming v4.15-rc1.  For ease of testing I've posted a kernel that is
v4.14 plus just those two patch series here:

https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/linux.git/log/?h=map_sync_dm_log_writes

Ross Zwisler (2):
  xfs_io: add MAP_SYNC support to mmap()
  xfs_io: add a new 'log_writes' command

 configure.ac          |  1 +
 include/builddefs.in  |  1 +
 include/linux.h       |  5 ++++
 io/Makefile           |  5 ++--
 io/init.c             |  1 +
 io/io.h               |  2 ++
 io/log_writes.c       | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++
 io/mmap.c             | 19 +++++++++----
 m4/package_libcdev.m4 | 16 +++++++++++
 man/man8/xfs_io.8     | 25 ++++++++++++++++-
 10 files changed, 145 insertions(+), 8 deletions(-)
 create mode 100644 io/log_writes.c

--
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
