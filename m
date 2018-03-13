Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from merlin.infradead.org (merlin.infradead.org
 [IPv6:2001:8b0:10b:1231::1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 950C22263146F
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 03:14:52 -0700 (PDT)
Date: Tue, 13 Mar 2018 11:20:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH] sched/wait_bit: Introduce wait_var_event()/wake_up_var()
Message-ID: <20180313102056.GJ4043@hirez.programming.kicks-ass.net>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152066493247.40260.10849841915366086021.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180311112725.GC4043@hirez.programming.kicks-ass.net>
 <CAPcyv4jr53dqVTzdEQ6Ln1Qg7nWVMQSVTkf6uc+Lg6Y-xruhuw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jr53dqVTzdEQ6Ln1Qg7nWVMQSVTkf6uc+Lg6Y-xruhuw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Mar 11, 2018 at 10:15:55AM -0700, Dan Williams wrote:
> On Sun, Mar 11, 2018 at 4:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, Mar 09, 2018 at 10:55:32PM -0800, Dan Williams wrote:
> >> Add a generic facility for awaiting an atomic_t to reach a value of 1.
> >>
> >> Page reference counts typically need to reach 0 to be considered a
> >> free / inactive page. However, ZONE_DEVICE pages allocated via
> >> devm_memremap_pages() are never 'onlined', i.e. the put_page() typically
> >> done at init time to assign pages to the page allocator is skipped.
> >>
> >> These pages will have their reference count elevated > 1 by
> >> get_user_pages() when they are under DMA. In order to coordinate DMA to
> >> these pages vs filesytem operations like hole-punch and truncate the
> >> filesystem-dax implementation needs to capture the DMA-idle event i.e.
> >> the 2 to 1 count transition).
> >>
> >> For now, this implementation does not have functional behavior change,
> >> follow-on patches will add waiters for these page-idle events.
> >
> > Argh, no no no.. That whole wait_for_atomic_t thing is a giant
> > trainwreck already and now you're making it worse still.
> >
> > Please have a look here:
> >
> >   https://lkml.kernel.org/r/20171101190644.chwhfpoz3ywxx2m7@hirez.programming.kicks-ass.net
> 
> That thread seems to be worried about the object disappearing the
> moment it's reference count reaches a target. That isn't the case with
> the memmap / struct page objects for ZONE_DEVICE pages. I understand
> wait_for_atomic_one() is broken in the general case, but as far as I
> can see it works fine specifically for ZONE_DEVICE page busy tracking,
> just not generic object lifetime.

How's this, compile tested (x86_64-allmodconfig) only.

This allows you to write:

	wait_var_event(&your_atomic, atomic_read(&your_atomic) == 1);

Ralf, please have a look at the MIPS thing, current code seems to be
busted in that it can wait indefinitely due to a missing wakeup.

---
 arch/mips/kernel/process.c                         |   3 +
 arch/mips/kernel/traps.c                           |   6 +-
 drivers/gpu/drm/drm_dp_aux_dev.c                   |  13 +--
 drivers/gpu/drm/i915/selftests/intel_breadcrumbs.c |  14 +--
 drivers/media/platform/qcom/venus/hfi.c            |   8 +-
 fs/afs/cell.c                                      |   6 +-
 fs/afs/rxrpc.c                                     |   6 +-
 fs/afs/server.c                                    |   6 +-
 fs/btrfs/extent-tree.c                             |  14 ++-
 fs/btrfs/ioctl.c                                   |   2 +-
 fs/fscache/cookie.c                                |   7 +-
 fs/nfs/inode.c                                     |   5 -
 fs/nfs/pagelist.c                                  |   6 +-
 fs/nfs/pnfs_nfs.c                                  |   2 +-
 fs/nfs/write.c                                     |   6 +-
 fs/ocfs2/filecheck.c                               |   9 +-
 include/linux/fscache-cache.h                      |   2 +-
 include/linux/wait_bit.h                           |  95 +++++++++++++------
 kernel/sched/wait_bit.c                            | 103 +++++----------------
 19 files changed, 149 insertions(+), 164 deletions(-)

diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 57028d49c202..4369401361c3 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -781,6 +781,9 @@ int mips_set_process_fp_mode(struct task_struct *task, unsigned int value)
 	atomic_set(&task->mm->context.fp_mode_switching, 0);
 	preempt_enable();
 
+	/* XXX is this right ?! */
+	wake_up_var(&task->mm->context.fp_mode_switching);
+
 	return 0;
 }
 
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 0ae4a731cc12..fd536b2f22ee 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -1247,9 +1247,11 @@ static int enable_restore_fp_context(int msa)
 	/*
 	 * If an FP mode switch is currently underway, wait for it to
 	 * complete before proceeding.
+	 *
+	 * XXX where is the wakeup ?!?
 	 */
-	wait_on_atomic_t(&current->mm->context.fp_mode_switching,
-			 atomic_t_wait, TASK_KILLABLE);
+	wait_var_event(&current->mm->context.fp_mode_switching,
+		       !atomic_read(&current->mm->context.fp_mode_switching));
 
 	if (!used_math()) {
 		/* First time FP context user. */
diff --git a/drivers/gpu/drm/drm_dp_aux_dev.c b/drivers/gpu/drm/drm_dp_aux_dev.c
index 053044201e31..74832c0920b6 100644
--- a/drivers/gpu/drm/drm_dp_aux_dev.c
+++ b/drivers/gpu/drm/drm_dp_aux_dev.c
@@ -177,8 +177,9 @@ static ssize_t auxdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		res = pos - iocb->ki_pos;
 	iocb->ki_pos = pos;
 
-	atomic_dec(&aux_dev->usecount);
-	wake_up_atomic_t(&aux_dev->usecount);
+	if (atomic_dec_and_test(&aux_dev->usecount))
+		wake_up_var(&aux_dev->usecount);
+
 	return res;
 }
 
@@ -218,8 +219,9 @@ static ssize_t auxdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		res = pos - iocb->ki_pos;
 	iocb->ki_pos = pos;
 
-	atomic_dec(&aux_dev->usecount);
-	wake_up_atomic_t(&aux_dev->usecount);
+	if (atomic_dec_and_test(&aux_dev->usecount))
+		wake_up_var(&aux_dev->usecount);
+
 	return res;
 }
 
@@ -277,8 +279,7 @@ void drm_dp_aux_unregister_devnode(struct drm_dp_aux *aux)
 	mutex_unlock(&aux_idr_mutex);
 
 	atomic_dec(&aux_dev->usecount);
-	wait_on_atomic_t(&aux_dev->usecount, atomic_t_wait,
-			 TASK_UNINTERRUPTIBLE);
+	wait_var_event(&aux_dev->usecount, !atomic_read(&aux_dev->usecount));
 
 	minor = aux_dev->index;
 	if (aux_dev->dev)
diff --git a/drivers/gpu/drm/i915/selftests/intel_breadcrumbs.c b/drivers/gpu/drm/i915/selftests/intel_breadcrumbs.c
index 54fc571b1102..f594926b8e9f 100644
--- a/drivers/gpu/drm/i915/selftests/intel_breadcrumbs.c
+++ b/drivers/gpu/drm/i915/selftests/intel_breadcrumbs.c
@@ -271,18 +271,13 @@ struct igt_wakeup {
 	u32 seqno;
 };
 
-static int wait_atomic_timeout(atomic_t *p, unsigned int mode)
-{
-	return schedule_timeout(10 * HZ) ? 0 : -ETIMEDOUT;
-}
-
 static bool wait_for_ready(struct igt_wakeup *w)
 {
 	DEFINE_WAIT(ready);
 
 	set_bit(IDLE, &w->flags);
 	if (atomic_dec_and_test(w->done))
-		wake_up_atomic_t(w->done);
+		wake_up_var(w->done);
 
 	if (test_bit(STOP, &w->flags))
 		goto out;
@@ -299,7 +294,7 @@ static bool wait_for_ready(struct igt_wakeup *w)
 out:
 	clear_bit(IDLE, &w->flags);
 	if (atomic_dec_and_test(w->set))
-		wake_up_atomic_t(w->set);
+		wake_up_var(w->set);
 
 	return !test_bit(STOP, &w->flags);
 }
@@ -342,7 +337,7 @@ static void igt_wake_all_sync(atomic_t *ready,
 	atomic_set(ready, 0);
 	wake_up_all(wq);
 
-	wait_on_atomic_t(set, atomic_t_wait, TASK_UNINTERRUPTIBLE);
+	wait_var_event(set, !atomic_read(set));
 	atomic_set(ready, count);
 	atomic_set(done, count);
 }
@@ -350,7 +345,6 @@ static void igt_wake_all_sync(atomic_t *ready,
 static int igt_wakeup(void *arg)
 {
 	I915_RND_STATE(prng);
-	const int state = TASK_UNINTERRUPTIBLE;
 	struct intel_engine_cs *engine = arg;
 	struct igt_wakeup *waiters;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
@@ -418,7 +412,7 @@ static int igt_wakeup(void *arg)
 		 * that they are ready for the next test. We wait until all
 		 * threads are complete and waiting for us (i.e. not a seqno).
 		 */
-		err = wait_on_atomic_t(&done, wait_atomic_timeout, state);
+		err = wait_var_event_timeout(&done, !atomic_read(&done), 10 * HZ);
 		if (err) {
 			pr_err("Timed out waiting for %d remaining waiters\n",
 			       atomic_read(&done));
diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
index 1baf78d3c02d..785627cf172c 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -106,8 +106,8 @@ int hfi_core_deinit(struct venus_core *core, bool blocking)
 
 	if (!empty) {
 		mutex_unlock(&core->lock);
-		wait_on_atomic_t(&core->insts_count, atomic_t_wait,
-				 TASK_UNINTERRUPTIBLE);
+		wait_var_event(&core->insts_count,
+			       !atomic_read(&core->insts_count));
 		mutex_lock(&core->lock);
 	}
 
@@ -229,8 +229,8 @@ void hfi_session_destroy(struct venus_inst *inst)
 
 	mutex_lock(&core->lock);
 	list_del_init(&inst->list);
-	atomic_dec(&core->insts_count);
-	wake_up_atomic_t(&core->insts_count);
+	if (atomic_dec_and_test(&core->insts_count))
+		wake_up_var(&core->insts_count);
 	mutex_unlock(&core->lock);
 }
 EXPORT_SYMBOL_GPL(hfi_session_destroy);
diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index 9bb921d120d0..6393107e05cb 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -25,7 +25,7 @@ static void afs_manage_cell(struct work_struct *);
 static void afs_dec_cells_outstanding(struct afs_net *net)
 {
 	if (atomic_dec_and_test(&net->cells_outstanding))
-		wake_up_atomic_t(&net->cells_outstanding);
+		wake_up_var(&net->cells_outstanding);
 }
 
 /*
@@ -764,7 +764,7 @@ void afs_cell_purge(struct afs_net *net)
 	afs_queue_cell_manager(net);
 
 	_debug("wait");
-	wait_on_atomic_t(&net->cells_outstanding, atomic_t_wait,
-			 TASK_UNINTERRUPTIBLE);
+	wait_var_event(&net->cells_outstanding,
+		       !atomic_read(&net->cells_outstanding));
 	_leave("");
 }
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index e1126659f043..e613dd754383 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -103,8 +103,8 @@ void afs_close_socket(struct afs_net *net)
 	}
 
 	_debug("outstanding %u", atomic_read(&net->nr_outstanding_calls));
-	wait_on_atomic_t(&net->nr_outstanding_calls, atomic_t_wait,
-			 TASK_UNINTERRUPTIBLE);
+	wait_var_event(&net->nr_outstanding_calls,
+		       !atomic_read(&net->nr_outstanding_calls));
 	_debug("no outstanding calls");
 
 	kernel_sock_shutdown(net->socket, SHUT_RDWR);
@@ -175,7 +175,7 @@ void afs_put_call(struct afs_call *call)
 		trace_afs_call(call, afs_call_trace_free, 0, o,
 			       __builtin_return_address(0));
 		if (o == 0)
-			wake_up_atomic_t(&net->nr_outstanding_calls);
+			wake_up_var(&net->nr_outstanding_calls);
 	}
 }
 
diff --git a/fs/afs/server.c b/fs/afs/server.c
index 1880f1b6a9f1..a43ef77dabae 100644
--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -25,7 +25,7 @@ static void afs_inc_servers_outstanding(struct afs_net *net)
 static void afs_dec_servers_outstanding(struct afs_net *net)
 {
 	if (atomic_dec_and_test(&net->servers_outstanding))
-		wake_up_atomic_t(&net->servers_outstanding);
+		wake_up_var(&net->servers_outstanding);
 }
 
 /*
@@ -521,8 +521,8 @@ void afs_purge_servers(struct afs_net *net)
 	afs_queue_server_manager(net);
 
 	_debug("wait");
-	wait_on_atomic_t(&net->servers_outstanding, atomic_t_wait,
-			 TASK_UNINTERRUPTIBLE);
+	wait_var_event(&net->servers_outstanding,
+		       !atomic_read(&net->servers_outstanding));
 	_leave("");
 }
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c1618ab9fecf..e0460d7b5622 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3990,7 +3990,7 @@ void btrfs_dec_nocow_writers(struct btrfs_fs_info *fs_info, u64 bytenr)
 	bg = btrfs_lookup_block_group(fs_info, bytenr);
 	ASSERT(bg);
 	if (atomic_dec_and_test(&bg->nocow_writers))
-		wake_up_atomic_t(&bg->nocow_writers);
+		wake_up_var(&bg->nocow_writers);
 	/*
 	 * Once for our lookup and once for the lookup done by a previous call
 	 * to btrfs_inc_nocow_writers()
@@ -4001,8 +4001,7 @@ void btrfs_dec_nocow_writers(struct btrfs_fs_info *fs_info, u64 bytenr)
 
 void btrfs_wait_nocow_writers(struct btrfs_block_group_cache *bg)
 {
-	wait_on_atomic_t(&bg->nocow_writers, atomic_t_wait,
-			 TASK_UNINTERRUPTIBLE);
+	wait_var_event(&bg->nocow_writers, !atomic_read(&bg->nocow_writers));
 }
 
 static const char *alloc_name(u64 flags)
@@ -6526,7 +6525,7 @@ void btrfs_dec_block_group_reservations(struct btrfs_fs_info *fs_info,
 	bg = btrfs_lookup_block_group(fs_info, start);
 	ASSERT(bg);
 	if (atomic_dec_and_test(&bg->reservations))
-		wake_up_atomic_t(&bg->reservations);
+		wake_up_var(&bg->reservations);
 	btrfs_put_block_group(bg);
 }
 
@@ -6552,8 +6551,7 @@ void btrfs_wait_block_group_reservations(struct btrfs_block_group_cache *bg)
 	down_write(&space_info->groups_sem);
 	up_write(&space_info->groups_sem);
 
-	wait_on_atomic_t(&bg->reservations, atomic_t_wait,
-			 TASK_UNINTERRUPTIBLE);
+	wait_var_event(&bg->reservations, !atomic_read(&bg->reservations));
 }
 
 /**
@@ -11061,7 +11059,7 @@ void btrfs_wait_for_snapshot_creation(struct btrfs_root *root)
 		ret = btrfs_start_write_no_snapshotting(root);
 		if (ret)
 			break;
-		wait_on_atomic_t(&root->will_be_snapshotted, atomic_t_wait,
-				 TASK_UNINTERRUPTIBLE);
+		wait_var_event(&root->will_be_snapshotted,
+			       !atomic_read(&root->will_be_snapshotted));
 	}
 }
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 111ee282b777..3278ae592a2c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -723,7 +723,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	btrfs_subvolume_release_metadata(fs_info, &pending_snapshot->block_rsv);
 dec_and_free:
 	if (atomic_dec_and_test(&root->will_be_snapshotted))
-		wake_up_atomic_t(&root->will_be_snapshotted);
+		wake_up_var(&root->will_be_snapshotted);
 free_pending:
 	kfree(pending_snapshot->root_item);
 	btrfs_free_path(pending_snapshot->path);
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index ff84258132bb..d705125665f0 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -557,9 +557,10 @@ void __fscache_disable_cookie(struct fscache_cookie *cookie, bool invalidate)
 	 * n_active reaches 0).  This makes sure outstanding reads and writes
 	 * have completed.
 	 */
-	if (!atomic_dec_and_test(&cookie->n_active))
-		wait_on_atomic_t(&cookie->n_active, atomic_t_wait,
-				 TASK_UNINTERRUPTIBLE);
+	if (!atomic_dec_and_test(&cookie->n_active)) {
+		wait_var_event(&cookie->n_active,
+			       !atomic_read(&cookie->n_active));
+	}
 
 	/* Make sure any pending writes are cancelled. */
 	if (cookie->def->type != FSCACHE_COOKIE_TYPE_INDEX)
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 7d893543cf3b..d17a90c4fa37 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -85,11 +85,6 @@ int nfs_wait_bit_killable(struct wait_bit_key *key, int mode)
 }
 EXPORT_SYMBOL_GPL(nfs_wait_bit_killable);
 
-int nfs_wait_atomic_killable(atomic_t *p, unsigned int mode)
-{
-	return nfs_wait_killable(mode);
-}
-
 /**
  * nfs_compat_user_ino64 - returns the user-visible inode number
  * @fileid: 64-bit fileid
diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index 18a7626ac638..67d19cd92e44 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -98,8 +98,8 @@ nfs_page_free(struct nfs_page *p)
 int
 nfs_iocounter_wait(struct nfs_lock_context *l_ctx)
 {
-	return wait_on_atomic_t(&l_ctx->io_count, nfs_wait_atomic_killable,
-			TASK_KILLABLE);
+	return wait_var_event_killable(&l_ctx->io_count,
+				       !atomic_read(&l_ctx->io_count));
 }
 
 /**
@@ -395,7 +395,7 @@ static void nfs_clear_request(struct nfs_page *req)
 	}
 	if (l_ctx != NULL) {
 		if (atomic_dec_and_test(&l_ctx->io_count)) {
-			wake_up_atomic_t(&l_ctx->io_count);
+			wake_up_var(&l_ctx->io_count);
 			if (test_bit(NFS_CONTEXT_UNLOCK, &ctx->flags))
 				rpc_wake_up(&NFS_SERVER(d_inode(ctx->dentry))->uoc_rpcwaitq);
 		}
diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index 03aaa60c7768..32ba2d471853 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -245,7 +245,7 @@ pnfs_generic_commit_cancel_empty_pagelist(struct list_head *pages,
 {
 	if (list_empty(pages)) {
 		if (atomic_dec_and_test(&cinfo->mds->rpcs_out))
-			wake_up_atomic_t(&cinfo->mds->rpcs_out);
+			wake_up_var(&cinfo->mds->rpcs_out);
 		/* don't call nfs_commitdata_release - it tries to put
 		 * the open_context which is not acquired until nfs_init_commit
 		 * which has not been called on @data */
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 7428a669d7a7..fd805771ea2f 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1620,8 +1620,8 @@ static void nfs_writeback_result(struct rpc_task *task,
 
 static int wait_on_commit(struct nfs_mds_commit_info *cinfo)
 {
-	return wait_on_atomic_t(&cinfo->rpcs_out,
-			nfs_wait_atomic_killable, TASK_KILLABLE);
+	return wait_var_event_killable(&cinfo->rpcs_out,
+				       !atomic_read(&cinfo->rpcs_out));
 }
 
 static void nfs_commit_begin(struct nfs_mds_commit_info *cinfo)
@@ -1632,7 +1632,7 @@ static void nfs_commit_begin(struct nfs_mds_commit_info *cinfo)
 static void nfs_commit_end(struct nfs_mds_commit_info *cinfo)
 {
 	if (atomic_dec_and_test(&cinfo->rpcs_out))
-		wake_up_atomic_t(&cinfo->rpcs_out);
+		wake_up_var(&cinfo->rpcs_out);
 }
 
 void nfs_commitdata_release(struct nfs_commit_data *data)
diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index e87279e49ba3..6b92cb241138 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -134,9 +134,10 @@ ocfs2_filecheck_sysfs_free(struct ocfs2_filecheck_sysfs_entry *entry)
 {
 	struct ocfs2_filecheck_entry *p;
 
-	if (!atomic_dec_and_test(&entry->fs_count))
-		wait_on_atomic_t(&entry->fs_count, atomic_t_wait,
-				 TASK_UNINTERRUPTIBLE);
+	if (!atomic_dec_and_test(&entry->fs_count)) {
+		wait_var_event(&entry->fs_count,
+			       !atomic_read(&entry->fs_count));
+	}
 
 	spin_lock(&entry->fs_fcheck->fc_lock);
 	while (!list_empty(&entry->fs_fcheck->fc_head)) {
@@ -183,7 +184,7 @@ static void
 ocfs2_filecheck_sysfs_put(struct ocfs2_filecheck_sysfs_entry *entry)
 {
 	if (atomic_dec_and_test(&entry->fs_count))
-		wake_up_atomic_t(&entry->fs_count);
+		wake_up_var(&entry->fs_count);
 }
 
 static struct ocfs2_filecheck_sysfs_entry *
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 4c467ef50159..3b03e29e2f1a 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -496,7 +496,7 @@ static inline bool __fscache_unuse_cookie(struct fscache_cookie *cookie)
 
 static inline void __fscache_wake_unused_cookie(struct fscache_cookie *cookie)
 {
-	wake_up_atomic_t(&cookie->n_active);
+	wake_up_var(&cookie->n_active);
 }
 
 /**
diff --git a/include/linux/wait_bit.h b/include/linux/wait_bit.h
index 61b39eaf7cad..9318b2166439 100644
--- a/include/linux/wait_bit.h
+++ b/include/linux/wait_bit.h
@@ -10,7 +10,6 @@
 struct wait_bit_key {
 	void			*flags;
 	int			bit_nr;
-#define WAIT_ATOMIC_T_BIT_NR	-1
 	unsigned long		timeout;
 };
 
@@ -22,21 +21,15 @@ struct wait_bit_queue_entry {
 #define __WAIT_BIT_KEY_INITIALIZER(word, bit)					\
 	{ .flags = word, .bit_nr = bit, }
 
-#define __WAIT_ATOMIC_T_KEY_INITIALIZER(p)					\
-	{ .flags = p, .bit_nr = WAIT_ATOMIC_T_BIT_NR, }
-
 typedef int wait_bit_action_f(struct wait_bit_key *key, int mode);
-typedef int wait_atomic_t_action_f(atomic_t *counter, unsigned int mode);
 
 void __wake_up_bit(struct wait_queue_head *wq_head, void *word, int bit);
 int __wait_on_bit(struct wait_queue_head *wq_head, struct wait_bit_queue_entry *wbq_entry, wait_bit_action_f *action, unsigned int mode);
 int __wait_on_bit_lock(struct wait_queue_head *wq_head, struct wait_bit_queue_entry *wbq_entry, wait_bit_action_f *action, unsigned int mode);
 void wake_up_bit(void *word, int bit);
-void wake_up_atomic_t(atomic_t *p);
 int out_of_line_wait_on_bit(void *word, int, wait_bit_action_f *action, unsigned int mode);
 int out_of_line_wait_on_bit_timeout(void *word, int, wait_bit_action_f *action, unsigned int mode, unsigned long timeout);
 int out_of_line_wait_on_bit_lock(void *word, int, wait_bit_action_f *action, unsigned int mode);
-int out_of_line_wait_on_atomic_t(atomic_t *p, wait_atomic_t_action_f action, unsigned int mode);
 struct wait_queue_head *bit_waitqueue(void *word, int bit);
 extern void __init wait_bit_init(void);
 
@@ -57,7 +50,6 @@ extern int bit_wait(struct wait_bit_key *key, int mode);
 extern int bit_wait_io(struct wait_bit_key *key, int mode);
 extern int bit_wait_timeout(struct wait_bit_key *key, int mode);
 extern int bit_wait_io_timeout(struct wait_bit_key *key, int mode);
-extern int atomic_t_wait(atomic_t *counter, unsigned int mode);
 
 /**
  * wait_on_bit - wait for a bit to be cleared
@@ -243,23 +235,74 @@ wait_on_bit_lock_action(unsigned long *word, int bit, wait_bit_action_f *action,
 	return out_of_line_wait_on_bit_lock(word, bit, action, mode);
 }
 
-/**
- * wait_on_atomic_t - Wait for an atomic_t to become 0
- * @val: The atomic value being waited on, a kernel virtual address
- * @action: the function used to sleep, which may take special actions
- * @mode: the task state to sleep in
- *
- * Wait for an atomic_t to become 0.  We abuse the bit-wait waitqueue table for
- * the purpose of getting a waitqueue, but we set the key to a bit number
- * outside of the target 'word'.
- */
-static inline
-int wait_on_atomic_t(atomic_t *val, wait_atomic_t_action_f action, unsigned mode)
-{
-	might_sleep();
-	if (atomic_read(val) == 0)
-		return 0;
-	return out_of_line_wait_on_atomic_t(val, action, mode);
-}
+extern void init_wait_var_entry(struct wait_bit_queue_entry *wbq_entry, void *var, int flags);
+extern void wake_up_var(void *var);
+extern wait_queue_head_t *__var_waitqueue(void *p);
+
+#define ___wait_var_event(var, condition, state, exclusive, ret, cmd)	\
+({									\
+	__label__ __out;						\
+	struct wait_queue_head *__wq_head = __var_waitqueue(var);	\
+	struct wait_bit_queue_entry __wbq_entry;			\
+	long __ret = ret; /* explicit shadow */				\
+									\
+	init_wait_var_entry(&__wbq_entry, var,				\
+			    exclusive ? WQ_FLAG_EXCLUSIVE : 0);		\
+	for (;;) {							\
+		long __int = prepare_to_wait_event(__wq_head,		\
+						   &__wbq_entry.wq_entry, \
+						   state);		\
+		if (condition)						\
+			break;						\
+									\
+		if (___wait_is_interruptible(state) && __int) {		\
+			__ret = __int;					\
+			goto __out;					\
+		}							\
+									\
+		cmd;							\
+	}								\
+	finish_wait(__wq_head, &__wbq_entry.wq_entry);			\
+__out:	__ret;								\
+})
+
+#define __wait_var_event(var, condition)				\
+	___wait_var_event(var, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
+			  schedule())
+
+#define wait_var_event(var, condition)					\
+do {									\
+	might_sleep();							\
+	if (condition)							\
+		break;							\
+	__wait_var_event(var, condition);				\
+} while (0)
+
+#define __wait_var_event_killable(var, condition)			\
+	___wait_var_event(var, condition, TASK_KILLABLE, 0, 0,		\
+			  schedule())
+
+#define wait_var_event_killable(var, condition)				\
+({									\
+	int __ret = 0;							\
+	might_sleep();							\
+	if (!(condition))						\
+		__ret = __wait_var_event_killable(var, condition);	\
+	__ret;								\
+})
+
+#define __wait_var_event_timeout(var, condition, timeout)		\
+	___wait_var_event(var, ___wait_cond_timeout(condition),		\
+			  TASK_UNINTERRUPTIBLE, 0, timeout,		\
+			  __ret = schedule_timeout(__ret))
+
+#define wait_var_event_timeout(var, condition, timeout)			\
+({									\
+	long __ret = timeout;						\
+	might_sleep();							\
+	if (!___wait_cond_timeout(condition))				\
+		__ret = __wait_var_event_timeout(var, condition, timeout); \
+	__ret;								\
+})
 
 #endif /* _LINUX_WAIT_BIT_H */
diff --git a/kernel/sched/wait_bit.c b/kernel/sched/wait_bit.c
index 4239c78f5cd3..60a84f5a6cb4 100644
--- a/kernel/sched/wait_bit.c
+++ b/kernel/sched/wait_bit.c
@@ -149,12 +149,7 @@ void wake_up_bit(void *word, int bit)
 }
 EXPORT_SYMBOL(wake_up_bit);
 
-/*
- * Manipulate the atomic_t address to produce a better bit waitqueue table hash
- * index (we're keying off bit -1, but that would produce a horrible hash
- * value).
- */
-static inline wait_queue_head_t *atomic_t_waitqueue(atomic_t *p)
+wait_queue_head_t *__var_waitqueue(void *p)
 {
 	if (BITS_PER_LONG == 64) {
 		unsigned long q = (unsigned long)p;
@@ -163,92 +158,44 @@ static inline wait_queue_head_t *atomic_t_waitqueue(atomic_t *p)
 	}
 	return bit_waitqueue(p, 0);
 }
+EXPORT_SYMBOL(__var_waitqueue);
 
-static int wake_atomic_t_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync,
-				  void *arg)
+static int
+var_wake_function(struct wait_queue_entry *wq_entry, unsigned int mode,
+		  int sync, void *arg)
 {
 	struct wait_bit_key *key = arg;
-	struct wait_bit_queue_entry *wait_bit = container_of(wq_entry, struct wait_bit_queue_entry, wq_entry);
-	atomic_t *val = key->flags;
+	struct wait_bit_queue_entry *wbq_entry =
+		container_of(wq_entry, struct wait_bit_queue_entry, wq_entry);
 
-	if (wait_bit->key.flags != key->flags ||
-	    wait_bit->key.bit_nr != key->bit_nr ||
-	    atomic_read(val) != 0)
+	if (wbq_entry->key.flags != key->flags ||
+	    wbq_entry->key.bit_nr != key->bit_nr)
 		return 0;
 
 	return autoremove_wake_function(wq_entry, mode, sync, key);
 }
 
-/*
- * To allow interruptible waiting and asynchronous (i.e. nonblocking) waiting,
- * the actions of __wait_on_atomic_t() are permitted return codes.  Nonzero
- * return codes halt waiting and return.
- */
-static __sched
-int __wait_on_atomic_t(struct wait_queue_head *wq_head, struct wait_bit_queue_entry *wbq_entry,
-		       wait_atomic_t_action_f action, unsigned int mode)
+void init_wait_var_entry(struct wait_bit_queue_entry *wbq_entry, void *var, int flags)
 {
-	atomic_t *val;
-	int ret = 0;
-
-	do {
-		prepare_to_wait(wq_head, &wbq_entry->wq_entry, mode);
-		val = wbq_entry->key.flags;
-		if (atomic_read(val) == 0)
-			break;
-		ret = (*action)(val, mode);
-	} while (!ret && atomic_read(val) != 0);
-	finish_wait(wq_head, &wbq_entry->wq_entry);
-
-	return ret;
+	*wbq_entry = (struct wait_bit_queue_entry){
+		.key = {
+			.flags	= (var),
+			.bit_nr = -1,
+		},
+		.wq_entry = {
+			.private = current,
+			.func	 = var_wake_function,
+			.entry	 = LIST_HEAD_INIT(wbq_entry->wq_entry.entry),
+		},
+	};
 }
+EXPORT_SYMBOL(init_wait_var_entry);
 
-#define DEFINE_WAIT_ATOMIC_T(name, p)					\
-	struct wait_bit_queue_entry name = {				\
-		.key = __WAIT_ATOMIC_T_KEY_INITIALIZER(p),		\
-		.wq_entry = {						\
-			.private	= current,			\
-			.func		= wake_atomic_t_function,	\
-			.entry		=				\
-				LIST_HEAD_INIT((name).wq_entry.entry),	\
-		},							\
-	}
-
-__sched int out_of_line_wait_on_atomic_t(atomic_t *p,
-					 wait_atomic_t_action_f action,
-					 unsigned int mode)
-{
-	struct wait_queue_head *wq_head = atomic_t_waitqueue(p);
-	DEFINE_WAIT_ATOMIC_T(wq_entry, p);
-
-	return __wait_on_atomic_t(wq_head, &wq_entry, action, mode);
-}
-EXPORT_SYMBOL(out_of_line_wait_on_atomic_t);
-
-__sched int atomic_t_wait(atomic_t *counter, unsigned int mode)
-{
-	schedule();
-	if (signal_pending_state(mode, current))
-		return -EINTR;
-
-	return 0;
-}
-EXPORT_SYMBOL(atomic_t_wait);
-
-/**
- * wake_up_atomic_t - Wake up a waiter on a atomic_t
- * @p: The atomic_t being waited on, a kernel virtual address
- *
- * Wake up anyone waiting for the atomic_t to go to zero.
- *
- * Abuse the bit-waker function and its waitqueue hash table set (the atomic_t
- * check is done by the waiter's wake function, not the by the waker itself).
- */
-void wake_up_atomic_t(atomic_t *p)
+void wake_up_var(void *var)
 {
-	__wake_up_bit(atomic_t_waitqueue(p), p, WAIT_ATOMIC_T_BIT_NR);
+	__wake_up_bit(__var_waitqueue(var), var, -1);
 }
-EXPORT_SYMBOL(wake_up_atomic_t);
+EXPORT_SYMBOL(wake_up_var);
 
 __sched int bit_wait(struct wait_bit_key *word, int mode)
 {
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
