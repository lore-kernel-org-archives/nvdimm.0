Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C184B2034B9C3
 for <linux-nvdimm@lists.01.org>; Wed, 13 Dec 2017 13:28:31 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch] btt: fix uninitialized err_lock
Date: Wed, 13 Dec 2017 16:33:09 -0500
Message-ID: <x49d13i9uui.fsf@segfault.boston.devel.redhat.com>
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
To: dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi,

When a sector mode namespace is initially created, the arena's err_lock
is not initialized.  If, on the other hand, the namespace already
exists, the mutex is initialized.  To fix the issue, I moved the mutex
initialization into the arena_alloc, which is called by both
discover_arenas and create_arenas.

This was discovered on an older kernel where mutex_trylock checks the
count to determine whether the lock is held.  Because the data structure
is kzalloc-d, that count was 0 (held), and I/O to the device would hang
forever waiting for the lock to be released (see btt_write_pg, for
example).  Current kernels have a different mutex implementation that
checks for a non-null owner, and so this doesn't show up as a problem.
If that lock were ever contended, it might cause issues, but you'd have
to be really unlucky, I think.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index e949e33..5860f99 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -630,6 +630,7 @@ static struct arena_info *alloc_arena(struct btt *btt, size_t size,
 		return NULL;
 	arena->nd_btt = btt->nd_btt;
 	arena->sector_size = btt->sector_size;
+	mutex_init(&arena->err_lock);
 
 	if (!size)
 		return arena;
@@ -758,7 +759,6 @@ static int discover_arenas(struct btt *btt)
 		arena->external_lba_start = cur_nlba;
 		parse_arena_meta(arena, super, cur_off);
 
-		mutex_init(&arena->err_lock);
 		ret = btt_freelist_init(arena);
 		if (ret)
 			goto out;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
