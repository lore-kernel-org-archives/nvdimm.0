Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EF14C81CE2
 for <linux-nvdimm@lists.01.org>; Tue,  1 Nov 2016 15:37:31 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/21 v4] dax: Clear dirty bits after flushing caches
Date: Tue,  1 Nov 2016 23:36:06 +0100
Message-Id: <1478039794-20253-1-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hello,

this is the fourth revision of my patches to clear dirty bits from radix tree
of DAX inodes when caches for corresponding pfns have been flushed. This patch
set is significantly larger than the previous version because I'm changing how
->fault, ->page_mkwrite, and ->pfn_mkwrite handlers may choose to handle the
fault so that we don't have to leak details about DAX locking into the generic
code. In principle, these patches enable handlers to easily update PTEs and do
other work necessary to finish the fault without duplicating the functionality
present in the generic code. I'd be really like feedback from mm folks whether
such changes to fault handling code are fine or what they'd do differently.

The patches are based on 4.9-rc1 + Ross' DAX PMD page fault series [1] + ext4
conversion of DAX IO patch to the iomap infrastructure [2]. For testing,
I've pushed out a tree including all these patches and further DAX fixes
to:

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git dax

The patches pass testing with xfstests on ext4 and xfs on my end. I'd be
grateful for review so that we can push these patches for the next merge
window.

[1] http://www.spinics.net/lists/linux-mm/msg115247.html
[2] Posted an hour ago - look for "ext4: Convert ext4 DAX IO to iomap framework"

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
