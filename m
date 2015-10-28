Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/2] "big hammer" for DAX msync/fsync correctness
Date: Wed, 28 Oct 2015 16:09:34 -0600
Message-Id: <1446070176-14568-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm@lists.01.org, x86@kernel.org, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

This series implements the very slow but correct handling for
blkdev_issue_flush() with DAX mappings, as discussed here:

https://lkml.org/lkml/2015/10/26/116

I don't think that we can actually do the

    on_each_cpu(sync_cache, ...);

...where sync_cache is something like:

    cache_disable();
    wbinvd();
    pcommit();
    cache_enable();

solution as proposed by Dan because WBINVD + PCOMMIT doesn't guarantee that
your writes actually make it durably onto the DIMMs.  I believe you really do
need to loop through the cache lines, flush them with CLWB, then fence and
PCOMMIT.

I do worry that the cost of blindly flushing the entire PMEM namespace on each
fsync or msync will be prohibitively expensive, and that we'll by very
incentivized to move to the radix tree based dirty page tracking as soon as
possible. :)

Ross Zwisler (2):
  pmem: add wb_cache_pmem() to the PMEM API
  pmem: Add simple and slow fsync/msync support

 arch/x86/include/asm/pmem.h | 11 ++++++-----
 drivers/nvdimm/pmem.c       | 10 +++++++++-
 include/linux/pmem.h        | 22 +++++++++++++++++++++-
 3 files changed, 36 insertions(+), 7 deletions(-)

-- 
2.1.0

