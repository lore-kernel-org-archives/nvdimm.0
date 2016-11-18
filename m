Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 383C181EC1
 for <linux-nvdimm@lists.01.org>; Fri, 18 Nov 2016 01:17:26 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/20 v5] dax: Clear dirty bits after flushing caches
Date: Fri, 18 Nov 2016 10:17:04 +0100
Message-Id: <1479460644-25076-1-git-send-email-jack@suse.cz>
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
To: linux-mm@kvack.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Hello,

This is the fifth revision of my patches to clear dirty bits from radix tree of
DAX inodes when caches for corresponding pfns have been flushed. In principle,
these patches enable handlers to easily update PTEs and do other work necessary
to finish the fault without duplicating the functionality present in the
generic code. I'd like to thank Kirill and Ross for reviews of the series!
Kirill has reviewed most of patches from mm side and is fine with them -
I'd just like his ack on the final version of patches 1, 2, 12 which I hope
I've updated as he wished. Then I think the series can go in.

The patches are based on Ross' DAX PMD page fault series [1] currently sitting
in XFS tree waiting for the merge window + ext4 conversion of DAX IO patch to
the iomap infrastructure [2]. For testing, I've pushed out a tree including all
these patches and further DAX fixes to:

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git dax

The patches pass testing with xfstests on ext4 and xfs on my end. I'd be
grateful for review so that we can push these patches for the next merge
window.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git dax-4.10-iomap-pmd
[2] Posted an hour ago - look for "ext4: Convert ext4 DAX IO to iomap framework"

Changes since v4:
* added acks and reviewed by's
* dropped cleanup patch to remove vma->vm_ops check
* make sure we restore original vmf->flags after using vm_fault structure for
  page_mkwrite handler
* mask vmf->address by PAGE_MASK in generic mm code rather than in ->fault
  handlers
* fixed up error handling dax_load_hole()

Changes since v3:
* rebased on top of 4.9-rc1 + DAX PMD fault series + ext4 iomap conversion
* reordered some of the patches
* killed ->virtual_address field in vm_fault structure as requested by
  Christoph

Changes since v2:
* rebased on top of 4.8-rc8 - this involved dealing with new fault_env
  structure
* changed calling convention for fault helpers

Changes since v1:
* make sure all PTE updates happen under radix tree entry lock to protect
  against races between faults & write-protecting code
* remove information about DAX locking from mm/memory.c
* smaller updates based on Ross' feedback

----
Background information regarding the motivation:

Currently we never clear dirty bits in the radix tree of a DAX inode. Thus
fsync(2) flushes all the dirty pfns again and again. This patches implement
clearing of the dirty tag in the radix tree so that we issue flush only when
needed.

The difficulty with clearing the dirty tag is that we have to protect against
a concurrent page fault setting the dirty tag and writing new data into the
page. So we need a lock serializing page fault and clearing of the dirty tag
and write-protecting PTEs (so that we get another pagefault when pfn is written
to again and we have to set the dirty tag again).

The effect of the patch set is easily visible:

Writing 1 GB of data via mmap, then fsync twice.

Before this patch set both fsyncs take ~205 ms on my test machine, after the
patch set the first fsync takes ~283 ms (the additional cost of walking PTEs,
clearing dirty bits etc. is very noticeable), the second fsync takes below
1 us.

As a bonus, these patches make filesystem freezing for DAX filesystems
reliable because mappings are now properly writeprotected while freezing the
fs.
								Honza
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
