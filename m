Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B7D4481AEA
 for <linux-nvdimm@lists.01.org>; Tue, 10 Jan 2017 13:52:36 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v4 0/7] DAX tracepoints, mm argument simplification
Date: Tue, 10 Jan 2017 14:52:15 -0700
Message-Id: <1484085142-2297-1-git-send-email-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, Steven Rostedt <rostedt@goodmis.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Andrew,

This contains both my DAX tracepoint code and Dave Jiang's MM argument
simplifications.  Dave's code was written with my tracepoint code as a
baseline, so it seemed simplest to keep them together in a single series.

This series is based on the v4.10-rc3-mmots-2017-01-09-17-08 snapshot.  A
working tree can be found here:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=mmots_dax_tracepoint

Changes from the previous versions of these patches:
 - Combined Dave's code and mine into a single series.
 - Resolved some minor merge conflics in Dave's patches so they could be
   applied to the latest mmots snapshot.
 - Added Reviewed-by and Acked-by tags to patches as appropriate.

My goal for this series is to get it merged for v4.11.

Thanks,
- Ross

Dave Jiang (2):
  mm, dax: make pmd_fault() and friends to be the same as fault()
  mm, dax: move pmd_fault() to take only vmf parameter

Ross Zwisler (5):
  tracing: add __print_flags_u64()
  dax: add tracepoint infrastructure, PMD tracing
  dax: update MAINTAINERS entries for FS DAX
  dax: add tracepoints to dax_pmd_load_hole()
  dax: add tracepoints to dax_pmd_insert_mapping()

 MAINTAINERS                   |   5 +-
 drivers/dax/dax.c             |  26 ++++---
 fs/dax.c                      | 114 ++++++++++++++++--------------
 fs/ext4/file.c                |  13 ++--
 fs/xfs/xfs_file.c             |  15 ++--
 include/linux/dax.h           |   6 +-
 include/linux/mm.h            |  28 +++++++-
 include/linux/pfn_t.h         |   6 ++
 include/linux/trace_events.h  |   4 ++
 include/trace/events/fs_dax.h | 156 ++++++++++++++++++++++++++++++++++++++++++
 include/trace/trace_events.h  |  11 +++
 kernel/trace/trace_output.c   |  38 ++++++++++
 mm/memory.c                   |  11 ++-
 13 files changed, 338 insertions(+), 95 deletions(-)
 create mode 100644 include/trace/events/fs_dax.h

-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
