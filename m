Return-Path: <owner-linux-mm@kvack.org>
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/20 v3] dax: Clear dirty bits after flushing caches
Date: Tue, 27 Sep 2016 18:08:04 +0200
Message-Id: <1474992504-20133-1-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Hello,

this is a third revision of my patches to clear dirty bits from radix tree of
DAX inodes when caches for corresponding pfns have been flushed. This patch set
is significantly larger than the previous version because I'm changing how
->fault, ->page_mkwrite, and ->pfn_mkwrite handlers may choose to handle the
fault so that we don't have to leak details about DAX locking into the generic
code. In principle, these patches enable handlers to easily update PTEs and do
other work necessary to finish the fault without duplicating the functionality
present in the generic code. I'd be really like feedback from mm folks whether
such changes to fault handling code are fine or what they'd do differently.

The patches pass testing with xfstests on ext4 and xfs on my end
- just be aware they are basis for further DAX fixes without which some
stress tests can still trigger failures. I'll be sending these fixes separately
in order to keep the series of reasonable size. For full testing, you
can pull all the patches from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git dax

but be aware I will likely rebase that branch and do other nasty stuff with
it so don't use it as a basis of your git trees.

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

Patches have passed xfstests for both xfs and ext4.

								Honza

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
