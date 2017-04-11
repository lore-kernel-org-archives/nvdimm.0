Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E36BC21A04823
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 15:46:31 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH] x86,
 mce: change the mce notifier to 'blocking' from 'atomic'
Date: Tue, 11 Apr 2017 16:44:57 -0600
Message-Id: <20170411224457.24777-1-vishal.l.verma@intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Borislav Petkov <bp@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

The NFIT MCE handler callback (for handling media errors on NVDIMMs)
takes a mutex to add the location of a memory error to a list. But since
the notifier call chain for machine checks (x86_mce_decoder_chain) is
atomic, we get a lockdep splat like:

  BUG: sleeping function called from invalid context at kernel/locking/mutex.c:620
  in_atomic(): 1, irqs_disabled(): 0, pid: 4, name: kworker/0:0
  [..]
  Call Trace:
   dump_stack+0x86/0xc3
   ___might_sleep+0x178/0x240
   __might_sleep+0x4a/0x80
   mutex_lock_nested+0x43/0x3f0
   ? __lock_acquire+0xcbc/0x1290
   nfit_handle_mce+0x33/0x180 [nfit]
   notifier_call_chain+0x4a/0x70
   atomic_notifier_call_chain+0x6e/0x110
   ? atomic_notifier_call_chain+0x5/0x110
   mce_gen_pool_process+0x41/0x70

Commit 648ed94038c030245a06e4be59744fd5cdc18c40
      x86/mce: Provide a lockless memory pool to save error records
Changes the mce notifier callbacks to be run in a process context, and
this can allow us to use the 'blocking' type notifier, where we can take
mutexes etc. in the call chain functions.

Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-genpool.c  | 2 +-
 arch/x86/kernel/cpu/mcheck/mce-internal.h | 2 +-
 arch/x86/kernel/cpu/mcheck/mce.c          | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

While this patch almost solves the problem, I think it is not quite right.
The x86_mce_decoder_chain is also called from print_mce for fatal machine
checks, and that is, afaict, still from an atomic context. One thing Tony
suggested was splitting the notifier chain into two distinct chains, one
for regular logging and recoverable actions that allows blocking, the
other from the panic path.

diff --git a/arch/x86/kernel/cpu/mcheck/mce-genpool.c b/arch/x86/kernel/cpu/mcheck/mce-genpool.c
index 1e5a50c..217cd44 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-genpool.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-genpool.c
@@ -85,7 +85,7 @@ void mce_gen_pool_process(struct work_struct *__unused)
 	head = llist_reverse_order(head);
 	llist_for_each_entry_safe(node, tmp, head, llnode) {
 		mce = &node->mce;
-		atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, mce);
+		blocking_notifier_call_chain(&x86_mce_decoder_chain, 0, mce);
 		gen_pool_free(mce_evt_pool, (unsigned long)node, sizeof(*node));
 	}
 }
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 903043e..19592ba 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -13,7 +13,7 @@ enum severity_level {
 	MCE_PANIC_SEVERITY,
 };
 
-extern struct atomic_notifier_head x86_mce_decoder_chain;
+extern struct blocking_notifier_head x86_mce_decoder_chain;
 
 #define ATTR_LEN		16
 #define INITIAL_CHECK_INTERVAL	5 * 60 /* 5 minutes */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 8e9725c..b39ca29 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -121,7 +121,7 @@ static void (*quirk_no_way_out)(int bank, struct mce *m, struct pt_regs *regs);
  * CPU/chipset specific EDAC code can register a notifier call here to print
  * MCE errors in a human-readable form.
  */
-ATOMIC_NOTIFIER_HEAD(x86_mce_decoder_chain);
+BLOCKING_NOTIFIER_HEAD(x86_mce_decoder_chain);
 
 /* Do initial initialization of a struct mce */
 void mce_setup(struct mce *m)
@@ -218,7 +218,7 @@ void mce_register_decode_chain(struct notifier_block *nb)
 
 	WARN_ON(nb->priority > MCE_PRIO_LOWEST && nb->priority < MCE_PRIO_EDAC);
 
-	atomic_notifier_chain_register(&x86_mce_decoder_chain, nb);
+	blocking_notifier_chain_register(&x86_mce_decoder_chain, nb);
 }
 EXPORT_SYMBOL_GPL(mce_register_decode_chain);
 
@@ -226,7 +226,7 @@ void mce_unregister_decode_chain(struct notifier_block *nb)
 {
 	atomic_dec(&num_notifiers);
 
-	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, nb);
+	blocking_notifier_chain_unregister(&x86_mce_decoder_chain, nb);
 }
 EXPORT_SYMBOL_GPL(mce_unregister_decode_chain);
 
@@ -327,7 +327,7 @@ static void print_mce(struct mce *m)
 	 * Print out human-readable details about the MCE error,
 	 * (if the CPU has an implementation for that)
 	 */
-	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
+	ret = blocking_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
 	if (ret == NOTIFY_STOP)
 		return;
 
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
