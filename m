Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5B79481EF0
 for <linux-nvdimm@lists.01.org>; Wed, 30 Nov 2016 15:45:54 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 0/6] introduce DAX tracepoint support
Date: Wed, 30 Nov 2016 16:45:27 -0700
Message-Id: <1480549533-29038-1-git-send-email-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Steven Rostedt <rostedt@goodmis.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Tracepoints are the standard way to capture debugging and tracing
information in many parts of the kernel, including the XFS and ext4
filesystems.  This series creates a tracepoint header for FS DAX and add
the first few DAX tracepoints to the PMD fault handler.  This allows the
tracing for DAX to be done in the same way as the filesystem tracing so
that developers can look at them together and get a coherent idea of what
the system is doing.

I do intend to add tracepoints to the normal 4k DAX fault path and to the
DAX I/O path, but I wanted to get feedback on the PMD tracepoints before I
went any further.

This series is based on Jan Kara's "dax: Clear dirty bits after flushing
caches" series:

https://lists.01.org/pipermail/linux-nvdimm/2016-November/007864.html

I've pushed a git tree with this work here:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=dax_tracepoints_v2

Changes since v1:
 - Dropped the patch fixing the build issue between DAX, ext4 and FS_IOMAP.
   I'll resend an updated patch if needed once Jan's patches for this issue
   are applied.
 - Added incude/linux/dax.h to MAINTAINERS in patch 4. (Matthew)
 - Begin each DAX tracepoint with the device major/minor and the inode so
   that we are consistent with the XFS tracepoints. This will allow for
   easy grepping of the tracepoint output. (Dave)
 - Print all PMD fault flags, not just whether we are doing a read or a
   write. (Jan)
 - Added __print_flags_u64() and the necessary helpers to the tracing
   infrastructure.  These functions allow us to print symbols associated
   with flags that are 64 bits wide even on 32 bit machines.  We need this
   for the pfn_t flags.

Ross Zwisler (6):
  tracing: add __print_flags_u64()
  dax: remove leading space from labels
  dax: add tracepoint infrastructure, PMD tracing
  dax: update MAINTAINERS entries for FS DAX
  dax: add tracepoints to dax_pmd_load_hole()
  dax: add tracepoints to dax_pmd_insert_mapping()

 MAINTAINERS                   |   5 +-
 fs/dax.c                      |  80 +++++++++++++--------
 include/linux/mm.h            |  25 +++++++
 include/linux/pfn_t.h         |   6 ++
 include/linux/trace_events.h  |   4 ++
 include/trace/events/fs_dax.h | 161 ++++++++++++++++++++++++++++++++++++++++++
 include/trace/trace_events.h  |  11 +++
 kernel/trace/trace_output.c   |  38 ++++++++++
 8 files changed, 300 insertions(+), 30 deletions(-)
 create mode 100644 include/trace/events/fs_dax.h

-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
