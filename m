Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com
 [IPv6:2607:f8b0:4864:20::542])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE3E6211F35EB
 for <linux-nvdimm@lists.01.org>; Wed,  3 Apr 2019 12:30:15 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id e6so4457163pgc.4
 for <linux-nvdimm@lists.01.org>; Wed, 03 Apr 2019 12:30:15 -0700 (PDT)
Date: Wed, 3 Apr 2019 15:30:12 -0400
From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH RFC tip/core/rcu 0/4] Forbid static SRCU use in modules
Message-ID: <20190403193012.GA55298@google.com>
References: <20190402142816.GA13084@linux.ibm.com>
 <886051277.1395.1554218080591.JavaMail.zimbra@efficios.com>
 <20190402152334.GC4102@linux.ibm.com>
 <161156422.1435.1554219247444.JavaMail.zimbra@efficios.com>
 <20190403133243.GE4102@linux.ibm.com>
 <1028306587.504.1554301662374.JavaMail.zimbra@efficios.com>
 <20190403162039.GA14111@linux.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190403162039.GA14111@linux.ibm.com>
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
To: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: David Howells <dhowells@redhat.com>, amd-gfx <amd-gfx@lists.freedesktop.org>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, fweisbec <fweisbec@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Lai Jiangshan <jiangshanlai@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, rcu <rcu@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Oleg Nesterov <oleg@redhat.com>, dipankar <dipankar@in.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 03, 2019 at 09:20:39AM -0700, Paul E. McKenney wrote:
> On Wed, Apr 03, 2019 at 10:27:42AM -0400, Mathieu Desnoyers wrote:
> > ----- On Apr 3, 2019, at 9:32 AM, paulmck paulmck@linux.ibm.com wrote:
> > 
> > > On Tue, Apr 02, 2019 at 11:34:07AM -0400, Mathieu Desnoyers wrote:
> > >> ----- On Apr 2, 2019, at 11:23 AM, paulmck paulmck@linux.ibm.com wrote:
> > >> 
> > >> > On Tue, Apr 02, 2019 at 11:14:40AM -0400, Mathieu Desnoyers wrote:
> > >> >> ----- On Apr 2, 2019, at 10:28 AM, paulmck paulmck@linux.ibm.com wrote:
> > >> >> 
> > >> >> > Hello!
> > >> >> > 
> > >> >> > This series prohibits use of DEFINE_SRCU() and DEFINE_STATIC_SRCU()
> > >> >> > by loadable modules.  The reason for this prohibition is the fact
> > >> >> > that using these two macros within modules requires that the size of
> > >> >> > the reserved region be increased, which is not something we want to
> > >> >> > be doing all that often.  Instead, loadable modules should define an
> > >> >> > srcu_struct and invoke init_srcu_struct() from their module_init function
> > >> >> > and cleanup_srcu_struct() from their module_exit function.  Note that
> > >> >> > modules using call_srcu() will also need to invoke srcu_barrier() from
> > >> >> > their module_exit function.
> > >> >> 
> > >> >> This arbitrary API limitation seems weird.
> > >> >> 
> > >> >> Isn't there a way to allow modules to use DEFINE_SRCU and DEFINE_STATIC_SRCU
> > >> >> while implementing them with dynamic allocation under the hood ?
> > >> > 
> > >> > Although call_srcu() already has initialization hooks, some would
> > >> > also be required in srcu_read_lock(), and I am concerned about adding
> > >> > memory allocation at that point, especially given the possibility
> > >> > of memory-allocation failure.  And the possibility that the first
> > >> > srcu_read_lock() happens in an interrupt handler or similar.
> > >> > 
> > >> > Or am I missing a trick here?
> > >> 
> > >> I was more thinking that under #ifdef MODULE, both DEFINE_SRCU and
> > >> DEFINE_STATIC_SRCU could append data in a dedicated section. module.c
> > >> would additionally lookup that section on module load, and deal with
> > >> those statically defined SRCU entries as if they were dynamically
> > >> allocated ones. It would of course cleanup those resources on module
> > >> unload.
> > >> 
> > >> Am I missing some subtlety there ?
> > > 
> > > If I understand you correctly, that is actually what is already done.  The
> > > size of this dedicated section is currently set by PERCPU_MODULE_RESERVE,
> > > and the additions of DEFINE{_STATIC}_SRCU() in modules was requiring that
> > > this to be increased frequently.  That led to a request that something
> > > be done, in turn leading to this patch series.
> > 
> > I think we are not expressing quite the same idea.
> > 
> > AFAIU, yours is to have DEFINE*_SRCU directly define per-cpu data within modules,
> > which ends up using percpu module reserved memory.
> > 
> > My idea is to make DEFINE*_SRCU have a different behavior under #ifdef MODULE.
> > It could emit a _global variable_ (_not_ per-cpu) within a new section. That
> > section would then be used by module init/exit code to figure out what "srcu
> > descriptors" are present in the modules. It would therefore rely on dynamic
> > allocation for those, therefore removing the need to involve the percpu module
> > reserved pool at all.
> > 
> > > 
> > > I don't see a way around this short of changing module loading to do
> > > alloc_percpu() and then updating the relocation based on this result.
> > > Which would admittedly be far more convenient.  I was assuming that
> > > this would be difficult due to varying CPU offsets or the like.
> > > 
> > > But if it can be done reasonably, it would be quite a bit nicer than
> > > forcing dynamic allocation in cases where it is not otherwise needed.
> > 
> > Hopefully my explanation above helps clear out what I have in mind.
> > 
> > You can find similar tricks performed by include/linux/tracepoint.h:
> > 
> > #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
> > static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
> > {
> >         return offset_to_ptr(p);
> > }
> > 
> > #define __TRACEPOINT_ENTRY(name)                                        \
> >         asm("   .section \"__tracepoints_ptrs\", \"a\"          \n"     \
> >             "   .balign 4                                       \n"     \
> >             "   .long   __tracepoint_" #name " - .              \n"     \
> >             "   .previous                                       \n")
> > #else
> > static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
> > {
> >         return *p;
> > }
> > 
> > #define __TRACEPOINT_ENTRY(name)                                         \
> >         static tracepoint_ptr_t __tracepoint_ptr_##name __used           \
> >         __attribute__((section("__tracepoints_ptrs"))) =                 \
> >                 &__tracepoint_##name
> > #endif
> > 
> > [...]
> > 
> > #define DEFINE_TRACE_FN(name, reg, unreg)                                \
> >         static const char __tpstrtab_##name[]                            \
> >         __attribute__((section("__tracepoints_strings"))) = #name;       \
> >         struct tracepoint __tracepoint_##name                            \
> >         __attribute__((section("__tracepoints"), used)) =                \
> >                 { __tpstrtab_##name, STATIC_KEY_INIT_FALSE, reg, unreg, NULL };\
> >         __TRACEPOINT_ENTRY(name);
> > 
> > And kernel/module.c:
> > 
> > find_module_sections():
> > 
> > #ifdef CONFIG_TRACEPOINTS
> >         mod->tracepoints_ptrs = section_objs(info, "__tracepoints_ptrs",
> >                                              sizeof(*mod->tracepoints_ptrs),
> >                                              &mod->num_tracepoints);
> > #endif
> > 
> > And kernel/tracepoint.c:tracepoint_module_notify() for the module coming/going
> > notifier.
> > 
> > Basically you would want to have your own structure within your own section of
> > the module which describes the srcu domain, and have a module coming/going
> > notifier responsible for dynamically allocating the srcu domain on "coming", and
> > doing a srcu barrier and cleanup the domain on "going".
> 
> Ah, sounds like an excellent approach!  I will give it a shot, thank you!

I agree with the idea as well. It is nice that tracepoints work with modules
so well, a feature that many folks use for debugging ;-)

thanks!

- Joel

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
