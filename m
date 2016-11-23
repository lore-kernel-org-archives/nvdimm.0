Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5351981E8B
 for <linux-nvdimm@lists.01.org>; Wed, 23 Nov 2016 10:45:05 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/6] introduce DAX tracepoint support
Date: Wed, 23 Nov 2016 11:44:16 -0700
Message-Id: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Steven Rostedt <rostedt@goodmis.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
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
                                                                                
https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=dax_tracepoints

Ross Zwisler (6):
  dax: fix build breakage with ext4, dax and !iomap
  dax: remove leading space from labels
  dax: add tracepoint infrastructure, PMD tracing
  dax: update MAINTAINERS entries for FS DAX
  dax: add tracepoints to dax_pmd_load_hole()
  dax: add tracepoints to dax_pmd_insert_mapping()

 MAINTAINERS                   |   4 +-
 fs/Kconfig                    |   1 +
 fs/dax.c                      |  78 ++++++++++++++----------
 fs/ext2/Kconfig               |   1 -
 include/linux/mm.h            |  14 +++++
 include/linux/pfn_t.h         |   6 ++
 include/trace/events/fs_dax.h | 135 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 206 insertions(+), 33 deletions(-)
 create mode 100644 include/trace/events/fs_dax.h

-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
