Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B5DB1203BEA44
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 12:24:34 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/5] fix radix tree multi-order iteration race
Date: Thu,  3 May 2018 13:24:25 -0600
Message-Id: <20180503192430.7582-1-ross.zwisler@linux.intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

The following series gets the radix tree test suite compiling again in
the current linux/master, adds a unit test which exposes a race in the
radix tree multi-order iteration code, and then fixes that race.

This race was initially hit on a v4.15 based kernel and results in a GP
fault.  I've described the race in detail in patches 4 and 5.

The fix is simple and necessary, and I think it should be merged for
v4.17.

This tree has gotten positive build confirmation from the 0-day bot,
passes the updated radix tree test suite, xfstests, and the original
test that was hitting the race with the v4.15 based kernel.

Ross Zwisler (5):
  radix tree test suite: fix mapshift build target
  radix tree test suite: fix compilation issue
  radix tree test suite: add item_delete_rcu()
  radix tree test suite: multi-order iteration race
  radix tree: fix multi-order iteration race

 lib/radix-tree.c                      |  6 ++--
 tools/include/linux/spinlock.h        |  3 +-
 tools/testing/radix-tree/Makefile     |  6 ++--
 tools/testing/radix-tree/multiorder.c | 63 +++++++++++++++++++++++++++++++++++
 tools/testing/radix-tree/test.c       | 19 +++++++++++
 tools/testing/radix-tree/test.h       |  3 ++
 6 files changed, 91 insertions(+), 9 deletions(-)

-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
