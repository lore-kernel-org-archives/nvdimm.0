Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5944681C81
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jan 2017 16:20:09 -0800 (PST)
Date: Fri, 13 Jan 2017 17:20:08 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [LSF/MM TOPIC] Future direction of DAX
Message-ID: <20170114002008.GA25379@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This past year has seen a lot of new DAX development.  We have added support
for fsync/msync, moved to the new iomap I/O data structure, introduced radix
tree based locking, re-enabled PMD support (twice!), and have fixed a bunch of
bugs.

We still have a lot of work to do, though, and I'd like to propose a discussion
around what features people would like to see enabled in the coming year as
well as what what use cases their customers have that we might not be aware of.

Here are a few topics to start the conversation:

- The current plan to allow users to safely flush dirty data from userspace is
  built around the PMEM_IMMUTABLE feature [1].  I'm hoping that by LSF/MM we
  will have at least started work on PMEM_IMMUTABLE, but I'm guessing there
  will be more to discuss.

- The DAX fsync/msync model was built for platforms that need to flush dirty
  processor cache lines in order to make data durable on NVDIMMs.  There exist
  platforms, however, that are set up so that the processor caches are
  effectively part of the ADR safe zone.  This means that dirty data can be
  assumed to be durable even in the processor cache, obviating the need to
  manually flush the cache during fsync/msync.  These platforms still need to
  call fsync/msync to ensure that filesystem metadata updates are properly
  written to media.  Our first idea on how to properly support these platforms
  would be for DAX to be made aware that in some cases doesn't need to keep
  metadata about dirty cache lines.  A similar issue exists for volatile uses
  of DAX such as with BRD or with PMEM and the memmap command line parameter,
  and we'd like a solution that covers them all.

- If I recall correctly, at one point Dave Chinner suggested that we change
  DAX so that I/O would use cached stores instead of the non-temporal stores
  that it currently uses.  We would then track pages that were written to by
  DAX in the radix tree so that they would be flushed later during
  fsync/msync.  Does this sound like a win?  Also, assuming that we can find a
  solution for platforms where the processor cache is part of the ADR safe
  zone (above topic) this would be a clear improvement, moving us from using
  non-temporal stores to faster cached stores with no downside.

- Jan suggested [2] that we could use the radix tree as a cache to service DAX
  faults without needing to call into the filesystem.  Are there any issues
  with this approach, and should we move forward with it as an optimization?

- Whenever you mount a filesystem with DAX, it spits out a message that says
  "DAX enabled. Warning: EXPERIMENTAL, use at your own risk".  What criteria
  needs to be met for DAX to no longer be considered experimental?

- When we msync() a huge page, if the range is less than the entire huge page,
  should we flush the entire huge page and mark it clean in the radix tree, or
  should we only flush the requested range and leave the radix tree entry
  dirty?

- Should we enable 1 GiB huge pages in filesystem DAX?  Does anyone have any
  specific customer requests for this or performance data suggesting it would
  be a win?  If so, what work needs to be done to get 1 GiB sized and aligned
  filesystem block allocations, to get the required enabling in the MM layer,
  etc?

Thanks,
- Ross

[1] https://lkml.org/lkml/2016/12/19/571
[2] https://lkml.org/lkml/2016/10/12/70
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
