Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 6E87B1A1E2C
 for <linux-nvdimm@lists.01.org>; Mon, 15 Aug 2016 12:42:41 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 0/3] 'slot' can be NULL in radix_tree_next_slot()
Date: Mon, 15 Aug 2016 13:42:34 -0600
Message-Id: <20160815194237.25967-1-ross.zwisler@linux.intel.com>
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
Cc: linux-nvdimm@lists.01.org, Konstantin Khlebnikov <koct9i@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <linux-nvdimm@lists.01.org>

This adds comments above radix_tree_next_slot() documenting the combination
of factors that prevent us from dereferencing a NULL 'slot' pointer.  It
also adds a radix tree unit test so that we can easily catch any unhandled
NULL pointer issues with radix_tree_next_slot().

Changes from V1:
 - Instead of adding an explicit check for 'slot' being NULL at the
   beginning of radix_tree_next_slot(), document what factors are keeping
   us safe instead.  (Konstantin)

Ross Zwisler (3):
  radix-tree: 'slot' can be NULL in radix_tree_next_slot()
  radix-tree tests: add iteration test
  radix-tree tests: properly initialize mutex

 include/linux/radix-tree.h                 |   8 ++
 tools/testing/radix-tree/Makefile          |   3 +-
 tools/testing/radix-tree/iteration_check.c | 180 +++++++++++++++++++++++++++++
 tools/testing/radix-tree/main.c            |   1 +
 tools/testing/radix-tree/regression1.c     |   2 +-
 tools/testing/radix-tree/test.h            |   1 +
 6 files changed, 193 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/radix-tree/iteration_check.c

-- 
2.9.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
