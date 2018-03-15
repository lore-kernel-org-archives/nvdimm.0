Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from merlin.infradead.org (merlin.infradead.org
 [IPv6:2001:8b0:10b:1231::1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B1296223FCF53
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 04:45:34 -0700 (PDT)
Date: Thu, 15 Mar 2018 12:51:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH] sched/wait_bit: Introduce
 wait_var_event()/wake_up_var()
Message-ID: <20180315115146.GX4064@hirez.programming.kicks-ass.net>
References: <20180313102056.GJ4043@hirez.programming.kicks-ass.net>
 <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152066493247.40260.10849841915366086021.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180311112725.GC4043@hirez.programming.kicks-ass.net>
 <CAPcyv4jr53dqVTzdEQ6Ln1Qg7nWVMQSVTkf6uc+Lg6Y-xruhuw@mail.gmail.com>
 <3396.1521107922@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3396.1521107922@warthog.procyon.org.uk>
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
To: David Howells <dhowells@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 15, 2018 at 09:58:42AM +0000, David Howells wrote:
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > > Argh, no no no.. That whole wait_for_atomic_t thing is a giant
> > > > trainwreck already and now you're making it worse still.
> 
> Your patch description needs to say why this isn't a trainwreck when you
> consider wait_for_atomic_t() to be one since it does things in a very similar
> way.

Does the below address things sufficiently clear?

---

Subject: sched/wait: Introduce wait_var_event()
From: Peter Zijlstra <peterz@infradead.org>
Date: Thu Mar 15 11:40:33 CET 2018

As a replacement for the wait_on_atomic_t() API provide the
wait_var_event() API.

The wait_var_event() API is based on the very same hashed-waitqueue
idea, but doesn't care about the type (atomic_t) or the specific
condition (atomic_read() == 0). IOW. it's much more widely
applicable/flexible.

It shares all the benefits/disadvantages of a hashed-waitqueue
approach with the existing wait_on_atomic_t/wait_on_bit() APIs.

The API is modeled after the existing wait_event() API, but instead of
taking a wait_queue_head, it takes an address. This addresses is
hashed to obtain a wait_queue_head from the bit_wait_table.

Similar to the wait_event() API, it takes a condition expression as
second argument and will wait until this expression becomes true.

The following are (mostly) identical replacements:

	wait_on_atomic_t(&my_atomic, atomic_t_wait, TASK_UNINTERRUPTIBLE);
	wake_up_atomic_t(&my_atomic);

	wait_var_event(&my_atomic, !atomic_read(&my_atomic));
	wake_up_var(&my_atomic);

The only difference is that wake_up_var() is an unconditional wakeup
and doesn't check the previously hard-coded (atomic_read() == 0)
condition here. This is of little concequence, since most callers are
already conditional on atomic_dec_and_test() and the ones that are
not, are trivial to make so.

Cc: David Howells <dhowells@redhat.com>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/wait_bit.h |   70 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/wait_bit.c  |   48 ++++++++++++++++++++++++++++++++
 2 files changed, 118 insertions(+)

--- a/include/linux/wait_bit.h
+++ b/include/linux/wait_bit.h
@@ -262,4 +262,74 @@ int wait_on_atomic_t(atomic_t *val, wait
 	return out_of_line_wait_on_atomic_t(val, action, mode);
 }
 
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
+
 #endif /* _LINUX_WAIT_BIT_H */
--- a/kernel/sched/wait_bit.c
+++ b/kernel/sched/wait_bit.c
@@ -149,6 +149,54 @@ void wake_up_bit(void *word, int bit)
 }
 EXPORT_SYMBOL(wake_up_bit);
 
+wait_queue_head_t *__var_waitqueue(void *p)
+{
+	if (BITS_PER_LONG == 64) {
+		unsigned long q = (unsigned long)p;
+
+		return bit_waitqueue((void *)(q & ~1), q & 1);
+	}
+	return bit_waitqueue(p, 0);
+}
+EXPORT_SYMBOL(__var_waitqueue);
+
+static int
+var_wake_function(struct wait_queue_entry *wq_entry, unsigned int mode,
+		  int sync, void *arg)
+{
+	struct wait_bit_key *key = arg;
+	struct wait_bit_queue_entry *wbq_entry =
+		container_of(wq_entry, struct wait_bit_queue_entry, wq_entry);
+
+	if (wbq_entry->key.flags != key->flags ||
+	    wbq_entry->key.bit_nr != key->bit_nr)
+		return 0;
+
+	return autoremove_wake_function(wq_entry, mode, sync, key);
+}
+
+void init_wait_var_entry(struct wait_bit_queue_entry *wbq_entry, void *var, int flags)
+{
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
+}
+EXPORT_SYMBOL(init_wait_var_entry);
+
+void wake_up_var(void *var)
+{
+	__wake_up_bit(__var_waitqueue(var), var, -1);
+}
+EXPORT_SYMBOL(wake_up_var);
+
 /*
  * Manipulate the atomic_t address to produce a better bit waitqueue table hash
  * index (we're keying off bit -1, but that would produce a horrible hash
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
