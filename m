Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 13EB420337377
 for <linux-nvdimm@lists.01.org>; Tue, 10 Jul 2018 12:10:36 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v4 0/2] ext4: fix DAX dma vs truncate/hole-punch
Date: Tue, 10 Jul 2018 13:10:29 -0600
Message-Id: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
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
To: Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org, Jeff Moyer <jmoyer@redhat.com>, linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v3:
 * Added an ext4_break_layouts() call to ext4_insert_range() to ensure
   that the {ext4,xfs}_break_layouts() calls have the same meaning.
   (Dave, Darrick and Jan)

---

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
ext4_break_layouts(). Each of the four paths easily hits this race many
times in my test setup with the xfstest.  You can find that test here:

https://lists.01.org/pipermail/linux-nvdimm/2018-June/016435.html

With these patches applied, I've still seen occasional hits of the above
WARN_ON_ONCE(), which tells me that we still have some work to do.  I'll
continue looking at these more rare hits.

Ross Zwisler (2):
  dax: dax_layout_busy_page() warn on !exceptional
  ext4: handle layout changes to pinned DAX mappings

 fs/dax.c           | 10 +++++++++-
 fs/ext4/ext4.h     |  1 +
 fs/ext4/extents.c  | 17 +++++++++++++++++
 fs/ext4/inode.c    | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/truncate.h |  4 ++++
 5 files changed, 77 insertions(+), 1 deletion(-)

-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
