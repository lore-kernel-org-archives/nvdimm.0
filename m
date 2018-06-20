Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8ED64211C608A
 for <linux-nvdimm@lists.01.org>; Wed, 20 Jun 2018 15:15:14 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/2] ext4: fix DAX dma vs truncate/hole-punch
Date: Wed, 20 Jun 2018 16:15:01 -0600
Message-Id: <20180620221503.25237-1-ross.zwisler@linux.intel.com>
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
To: Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org, Jeff Moyer <jmoyer@redhat.com>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This series from Dan:

https://lists.01.org/pipermail/linux-nvdimm/2018-March/014913.html

added synchronization between DAX dma and truncate/hole-punch in XFS.
This short series adds analogous support to ext4.

I've added calls to ext4_break_layouts() everywhere that ext4 removes
blocks from an inode's map.

The timings in XFS are such that it's difficult to hit this race.  Dan
was able to show the race by manually introducing delays in the direct
I/O path.

For ext4, though, its trivial to hit this race, and a hit will result in
a trigger of this WARN_ON_ONCE() in dax_disassociate_entry():

	WARN_ON_ONCE(trunc && page_ref_count(page) > 1);

I've made an xfstest which tests all the paths where we now call
ext4_break_layouts(), with the exception of the site in
ext4_truncate_failed_write() which is an error path.  Each of the other
4 paths easily hits this race many times in my test setup with the
xfstest.  I'll post this test shortly.

With these patches applied, I've still seen occasional hits of the above
WARN_ON_ONCE(), which tells me that we still have some work to do.  I'll
continue looking at these more rare hits while we review this set.

Ross Zwisler (2):
  dax: dax_layout_busy_page() warn on !exceptional
  ext4: handle layout changes to pinned DAX mappings

 fs/dax.c           |  9 ++++++++-
 fs/ext4/ext4.h     |  1 +
 fs/ext4/extents.c  | 12 ++++++++++++
 fs/ext4/inode.c    | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/truncate.h |  1 +
 5 files changed, 70 insertions(+), 1 deletion(-)

-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
