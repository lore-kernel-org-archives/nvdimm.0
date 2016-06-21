Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 558D21A1E53
 for <linux-nvdimm@lists.01.org>; Tue, 21 Jun 2016 08:45:54 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3 v1] dax: Clear dirty bits after flushing caches
Date: Tue, 21 Jun 2016 17:45:12 +0200
Message-Id: <1466523915-14644-1-git-send-email-jack@suse.cz>
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
To: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Hello,

currently we never clear dirty bits in the radix tree of a DAX inode. Thus
fsync(2) or even periodical writeback flush all the dirty pfns again and
again. This patches implement clearing of the dirty tag in the radix tree
so that we issue flush only when needed.

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

So far the patches don't work with PMD pages - that's next on my todo list.

								Honza
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
