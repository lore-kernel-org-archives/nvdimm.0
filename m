Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598AC3B8922;
	Tue, 11 Aug 2026 06:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786431041; cv=none; b=Lsx8tyMsStTHpNIJs/aJ/xZvhmNZDhUdFERJRyM6afnCk2npUpQcKtaXeSKEFtmcACRXYFTbPNPFyMs52MLFRuO1+G9HK6Jj6xufUrCkdf6JLZH3N4VNDqFvMCFvtnMq3deVvdeeKXH7Q5g2DXu1EanXgPDpr2IBnkjwkgIz1c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786431041; c=relaxed/simple;
	bh=CzHBWChTN+6+uruFg+0n5ByPo/z+t/ZyUXdOmMwot1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDBDZfQq35tDZxym9qX0GNSqnLm/2Fk+vc0sHdHIqEMhM/RaspAw+AefipiKk1EuOl3gduYLFpftso/6CCe31hYZpXPhUDqrwGFzEOUo3rCKGGE2wXiXxFYO6REzAbCVSei86zgMZJh5Y/hqbUqs3Q+Arbl9GcWbbPmenAvK6Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSNrlRyj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSNrlRyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013BB1F00A3A;
	Tue, 11 Aug 2026 06:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786431038;
	bh=c3hXD+R0mYxZwUJd+E8dww3Fu0OdFHhTiqFxeoSQZOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MSNrlRyjdL0PbrVLNZ0N2bIveWHjzVZ20AyrRatf+Cxq1LGLdzCv4JpVjtnng9KLF
	 ecR11ajA9NN/Vqo7IR/IzPuCtMt6PPRuKdPMAPI/XRSvq+0ltYMfOZCScBimcNL2b6
	 Whv8IKMvGI/R/2ZvzBinVOY3iZy57Hpy3yvHSrEWcmoFR3Nbh64hyNpNOk2308nctS
	 my/xzSZpKnYH2M9r0JXmibnl082yJd8/7WlLpGiT54SDBeHg0LWjakQuPkj0W9MTjO
	 cvbDKIWd+QcdQYvQVaZ9x0ZNekH4zwdvaG99Wnf0EAVTdd3yPrt/uqeDo0omFJfgOn
	 FSEB34WguwFJg==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>,
	Tao Cui <cui.tao@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Ming Lei <ming.lei@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 1/4] blk-cgroup: wait for old blkgs to leave queue before disk rebind
Date: Tue, 11 Aug 2026 14:47:41 +0800
Message-ID: <20260811064744.1139446-2-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260811064744.1139446-1-yukuai@kernel.org>
References: <20260811064744.1139446-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

blkcg_init_disk() currently waits for q->root_blkg to become NULL before
initializing blkcg state for a rebound disk. However, blkg_destroy_all()
clears q->root_blkg after calling blkg_destroy() for each blkg. At that
point the initial references have only been killed, and the blkgs remain
on q->blkg_list until the remaining references drain and
blkg_free_workfn() removes them.

A rebound disk can therefore install new blkcg state while old blkgs are
still attached to the request queue. Wait for q->blkg_list to become empty
instead, and wake the waiter when the final blkg is removed. This covers
the complete queue-side blkg lifetime without adding separate state.

Fixes: 3dbaacf6ab68 ("blk-cgroup: wait for blkcg cleanup before initializing new disk")
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 354637f3b158..229348273437 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -131,10 +131,12 @@ static void blkg_free_workfn(struct work_struct *work)
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
 	if (blkg->parent)
 		blkg_put(blkg->parent);
 	spin_lock_irq(&q->queue_lock);
 	list_del_init(&blkg->q_node);
+	if (list_empty(&q->blkg_list))
+		wake_up_var(&q->blkg_list);
 	spin_unlock_irq(&q->queue_lock);
 	mutex_unlock(&q->blkcg_mutex);
 
 	/*
 	 * Release blkcg css ref only after blkg is removed from q->blkg_list,
@@ -607,12 +609,10 @@ static void blkg_destroy_all(struct gendisk *disk)
 	}
 
 	q->root_blkg = NULL;
 	spin_unlock_irq(&q->queue_lock);
 	mutex_unlock(&q->blkcg_mutex);
-
-	wake_up_var(&q->root_blkg);
 }
 
 static void blkg_iostat_set(struct blkg_iostat *dst, struct blkg_iostat *src)
 {
 	int i;
@@ -1457,18 +1457,14 @@ int blkcg_init_disk(struct gendisk *disk)
 	bool preloaded;
 
 	/*
 	 * If the queue is shared across disk rebind (e.g., SCSI), the
 	 * previous disk's blkcg state is cleaned up asynchronously via
-	 * disk_release() -> blkcg_exit_disk(). Wait for that cleanup to
-	 * finish (indicated by root_blkg becoming NULL) before setting up
-	 * new blkcg state. Otherwise, we may overwrite q->root_blkg while
-	 * the old one is still alive, and radix_tree_insert() in
-	 * blkg_create() will fail with -EEXIST because the old entries
-	 * still occupy the same queue id slot in blkcg->blkg_tree.
+	 * disk_release() -> blkcg_exit_disk(). Wait for all old blkgs to be
+	 * removed from the queue list before setting up new blkcg state.
 	 */
-	wait_var_event(&q->root_blkg, !READ_ONCE(q->root_blkg));
+	wait_var_event(&q->blkg_list, list_empty_careful(&q->blkg_list));
 
 	new_blkg = blkg_alloc(&blkcg_root, disk, GFP_KERNEL);
 	if (!new_blkg)
 		return -ENOMEM;
 
-- 
2.51.0

