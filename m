Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 12 Apr 2017 15:42:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] x86, mce: change the mce notifier to 'blocking' from
 'atomic'
References: <20170411224457.24777-1-vishal.l.verma@intel.com>
 <20170412091442.dwonfr4dwyta7nvx@pd.tnic>
 <20170412195903.GA29506@omniknight.lm.intel.com>
 <20170412202238.5d327vmwjqvbzzop@pd.tnic>
 <1492028744.2738.14.camel@intel.com>
 <20170412211302.3d2cxe34sgiu3dag@pd.tnic>
 <alpine.DEB.2.20.1704122342130.2548@nanos>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1704122342130.2548@nanos>
Message-Id: <20170412224232.GM3956@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: paulmck@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Borislav Petkov <bp@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 12, 2017 at 11:50:45PM +0200, Thomas Gleixner wrote:
> On Wed, 12 Apr 2017, Borislav Petkov wrote:
> 
> > On Wed, Apr 12, 2017 at 08:27:05PM +0000, Verma, Vishal L wrote:
> > > But isn't the atomic notifier call chain always called in atomic
> > > context?
> > 
> > No, it isn't. We're calling it in normal process context in
> > mce_gen_pool_process() too.
> > 
> > So this early exit will avoid any sleeping in atomic context. And since
> > there's nothing you can do about the errors reported in atomic context,
> > we can actually use that fact.
> 
> No, you can't.
> 
> CONFIG_RCU_PREEMPT=n + CONFIG_PREEMPT_COUNT will disable preemption from
> within __atomic_notifier_call_chain() via rcu_read_lock(). Ergo you wont
> ever enter the handler.
> 
> The behaviour in the RCU code is inconsistent. CONFIG_RCU_PREEMPT=y does
> obviouly not disable preemption, but it should still trigger the
> might_sleep() check when a blocking function is called from within a rcu
> read side critical section.

Maybe something like the (untested) patch below.  Please note that this
would need some help to work correctly in -rt.  This applies only against
-rcu tip, but in that case you can just get it directly from -rcu.

							Thanx, Paul

------------------------------------------------------------------------

commit 122acec803471468d8a453d08219ca2fc94f5556
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Wed Apr 12 15:29:14 2017 -0700

    rcu: Complain if blocking in preemptible RCU read-side critical section
    
    Although preemptible RCU allows its read-side critical sections to be
    preempted, general blocking is forbidden.  The reason for this is that
    excessive preemption times can be handled by CONFIG_RCU_BOOST=y, but a
    voluntarily blocked task doesn't care how high you boost its priority.
    Because preemptible RCU is a global mechanism, one ill-behaved reader
    hurts everyone.  Hence the prohibition against general blocking in
    RCU-preempt read-side critical sections.  Preemption yes, blocking no.
    
    This commit enforces this prohibition.
    
    There is a special exception for the -rt patchset (which they kindly
    volunteered to implement):  It is OK to block (as opposed to merely being
    preempted) within an RCU-preempt read-side critical section, but only if
    the blocking is subject to priority inheritance.  This exception permits
    CONFIG_RCU_BOOST=y to get -rt RCU readers out of trouble.
    
    Why doesn't this exception also apply to mainline's rt_mutex?  Because
    of the possibility that someone does general blocking while holding
    an rt_mutex.  Yes, the priority boosting will affect the rt_mutex,
    but it won't help with the task doing general blocking while holding
    that rt_mutex.
    
    Reported-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index d013bd4767a7..abc09d368b3a 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -465,7 +465,7 @@ void rcu_note_context_switch(bool preempt)
 	barrier(); /* Avoid RCU read-side critical sections leaking down. */
 	trace_rcu_utilization(TPS("Start context switch"));
 	rcu_sched_qs();
-	rcu_preempt_note_context_switch();
+	rcu_preempt_note_context_switch(preempt);
 	/* Load rcu_urgent_qs before other flags. */
 	if (!smp_load_acquire(this_cpu_ptr(&rcu_dynticks.rcu_urgent_qs)))
 		goto out;
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 0e598ab08fea..781fe684f230 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -476,7 +476,7 @@ DECLARE_PER_CPU(char, rcu_cpu_has_work);
 
 /* Forward declarations for rcutree_plugin.h */
 static void rcu_bootup_announce(void);
-static void rcu_preempt_note_context_switch(void);
+static void rcu_preempt_note_context_switch(bool preempt);
 static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static bool rcu_preempt_has_tasks(struct rcu_node *rnp);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 6d8f7f82259c..67a90158f32e 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -286,12 +286,13 @@ static void rcu_preempt_qs(void)
  *
  * Caller must disable interrupts.
  */
-static void rcu_preempt_note_context_switch(void)
+static void rcu_preempt_note_context_switch(bool preempt)
 {
 	struct task_struct *t = current;
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
 
+	WARN_ON_ONCE(!preempt && t->rcu_read_lock_nesting > 0);
 	if (t->rcu_read_lock_nesting > 0 &&
 	    !t->rcu_read_unlock_special.b.blocked) {
 
@@ -738,7 +739,7 @@ static void __init rcu_bootup_announce(void)
  * Because preemptible RCU does not exist, we never have to check for
  * CPUs being in quiescent states.
  */
-static void rcu_preempt_note_context_switch(void)
+static void rcu_preempt_note_context_switch(bool preempt)
 {
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
