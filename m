From: Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH RFC tip/core/rcu 0/4] Forbid static SRCU use in modules
Date: Sat, 6 Apr 2019 19:06:13 -0400
Message-ID: <20190406230613.GA187766@google.com>
References: <20190402142816.GA13084@linux.ibm.com>
 <886051277.1395.1554218080591.JavaMail.zimbra@efficios.com>
 <20190402152334.GC4102@linux.ibm.com>
 <161156422.1435.1554219247444.JavaMail.zimbra@efficios.com>
 <20190403133243.GE4102@linux.ibm.com>
 <1028306587.504.1554301662374.JavaMail.zimbra@efficios.com>
 <20190403162039.GA14111@linux.ibm.com>
 <20190405232835.GA24702@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190405232835.GA24702-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Paul E. McKenney" <paulmck-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, amd-gfx <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, fweisbec <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Lai Jiangshan <jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, rcu <rcu-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dipankar <dipankar-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Fri, Apr 05, 2019 at 04:28:35PM -0700, Paul E. McKenney wrote:
> On Wed, Apr 03, 2019 at 09:20:39AM -0700, Paul E. McKenney wrote:
> > On Wed, Apr 03, 2019 at 10:27:42AM -0400, Mathieu Desnoyers wrote:
> > > ----- On Apr 3, 2019, at 9:32 AM, paulmck paulmck-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org wrote:
> > > 
> > > > On Tue, Apr 02, 2019 at 11:34:07AM -0400, Mathieu Desnoyers wrote:
> > > >> ----- On Apr 2, 2019, at 11:23 AM, paulmck paulmck-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org wrote:
> > > >> 
> > > >> > On Tue, Apr 02, 2019 at 11:14:40AM -0400, Mathieu Desnoyers wrote:
> > > >> >> ----- On Apr 2, 2019, at 10:28 AM, paulmck paulmck-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org wrote:
> > > >> >> 
> > > >> >> > Hello!
> > > >> >> > 
> > > >> >> > This series prohibits use of DEFINE_SRCU() and DEFINE_STATIC_SRCU()
> > > >> >> > by loadable modules.  The reason for this prohibition is the fact
> > > >> >> > that using these two macros within modules requires that the size of
> > > >> >> > the reserved region be increased, which is not something we want to
> > > >> >> > be doing all that often.  Instead, loadable modules should define an
> > > >> >> > srcu_struct and invoke init_srcu_struct() from their module_init function
> > > >> >> > and cleanup_srcu_struct() from their module_exit function.  Note that
> > > >> >> > modules using call_srcu() will also need to invoke srcu_barrier() from
> > > >> >> > their module_exit function.
> > > >> >> 
> > > >> >> This arbitrary API limitation seems weird.
> > > >> >> 
> > > >> >> Isn't there a way to allow modules to use DEFINE_SRCU and DEFINE_STATIC_SRCU
> > > >> >> while implementing them with dynamic allocation under the hood ?
> > > >> > 
> > > >> > Although call_srcu() already has initialization hooks, some would
> > > >> > also be required in srcu_read_lock(), and I am concerned about adding
> > > >> > memory allocation at that point, especially given the possibility
> > > >> > of memory-allocation failure.  And the possibility that the first
> > > >> > srcu_read_lock() happens in an interrupt handler or similar.
> > > >> > 
> > > >> > Or am I missing a trick here?
> > > >> 
> > > >> I was more thinking that under #ifdef MODULE, both DEFINE_SRCU and
> > > >> DEFINE_STATIC_SRCU could append data in a dedicated section. module.c
> > > >> would additionally lookup that section on module load, and deal with
> > > >> those statically defined SRCU entries as if they were dynamically
> > > >> allocated ones. It would of course cleanup those resources on module
> > > >> unload.
> > > >> 
> > > >> Am I missing some subtlety there ?
> > > > 
> > > > If I understand you correctly, that is actually what is already done.  The
> > > > size of this dedicated section is currently set by PERCPU_MODULE_RESERVE,
> > > > and the additions of DEFINE{_STATIC}_SRCU() in modules was requiring that
> > > > this to be increased frequently.  That led to a request that something
> > > > be done, in turn leading to this patch series.
> > > 
> > > I think we are not expressing quite the same idea.
> > > 
> > > AFAIU, yours is to have DEFINE*_SRCU directly define per-cpu data within modules,
> > > which ends up using percpu module reserved memory.
> > > 
> > > My idea is to make DEFINE*_SRCU have a different behavior under #ifdef MODULE.
> > > It could emit a _global variable_ (_not_ per-cpu) within a new section. That
> > > section would then be used by module init/exit code to figure out what "srcu
> > > descriptors" are present in the modules. It would therefore rely on dynamic
> > > allocation for those, therefore removing the need to involve the percpu module
> > > reserved pool at all.
> > > 
> > > > 
> > > > I don't see a way around this short of changing module loading to do
> > > > alloc_percpu() and then updating the relocation based on this result.
> > > > Which would admittedly be far more convenient.  I was assuming that
> > > > this would be difficult due to varying CPU offsets or the like.
> > > > 
> > > > But if it can be done reasonably, it would be quite a bit nicer than
> > > > forcing dynamic allocation in cases where it is not otherwise needed.
> > > 
> > > Hopefully my explanation above helps clear out what I have in mind.
> > > 
> > > You can find similar tricks performed by include/linux/tracepoint.h:
> > > 
> > > #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
> > > static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
> > > {
> > >         return offset_to_ptr(p);
> > > }
> > > 
> > > #define __TRACEPOINT_ENTRY(name)                                        \
> > >         asm("   .section \"__tracepoints_ptrs\", \"a\"          \n"     \
> > >             "   .balign 4                                       \n"     \
> > >             "   .long   __tracepoint_" #name " - .              \n"     \
> > >             "   .previous                                       \n")
> > > #else
> > > static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
> > > {
> > >         return *p;
> > > }
> > > 
> > > #define __TRACEPOINT_ENTRY(name)                                         \
> > >         static tracepoint_ptr_t __tracepoint_ptr_##name __used           \
> > >         __attribute__((section("__tracepoints_ptrs"))) =                 \
> > >                 &__tracepoint_##name
> > > #endif
> > > 
> > > [...]
> > > 
> > > #define DEFINE_TRACE_FN(name, reg, unreg)                                \
> > >         static const char __tpstrtab_##name[]                            \
> > >         __attribute__((section("__tracepoints_strings"))) = #name;       \
> > >         struct tracepoint __tracepoint_##name                            \
> > >         __attribute__((section("__tracepoints"), used)) =                \
> > >                 { __tpstrtab_##name, STATIC_KEY_INIT_FALSE, reg, unreg, NULL };\
> > >         __TRACEPOINT_ENTRY(name);
> > > 
> > > And kernel/module.c:
> > > 
> > > find_module_sections():
> > > 
> > > #ifdef CONFIG_TRACEPOINTS
> > >         mod->tracepoints_ptrs = section_objs(info, "__tracepoints_ptrs",
> > >                                              sizeof(*mod->tracepoints_ptrs),
> > >                                              &mod->num_tracepoints);
> > > #endif
> > > 
> > > And kernel/tracepoint.c:tracepoint_module_notify() for the module coming/going
> > > notifier.
> > > 
> > > Basically you would want to have your own structure within your own section of
> > > the module which describes the srcu domain, and have a module coming/going
> > > notifier responsible for dynamically allocating the srcu domain on "coming", and
> > > doing a srcu barrier and cleanup the domain on "going".
> > 
> > Ah, sounds like an excellent approach!  I will give it a shot, thank you!
> 
> Please see below for an untested shot.
> 
> The original commits posted in this series are still available within
> the -srcu tree at branch srcunomod.2019.04.05a.  Yes, I am a digital
> packrat.  Why do you ask?
> 
> Thoughts?  Or more accurately, given that this is the first time I
> have used linker sections, what did I mess up?
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> commit e24a0dab1414c563bb96bcb28d5963c9df18b1e8
> Author: Paul E. McKenney <paulmck-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
> Date:   Fri Apr 5 16:15:00 2019 -0700
> 
>     srcu: Allocate per-CPU data for DEFINE_SRCU() in modules
>     
>     Adding DEFINE_SRCU() or DEFINE_STATIC_SRCU() to a loadable module requires
>     that the size of the reserved region be increased, which is not something
>     we want to be doing all that often.  One approach would be to require
>     that loadable modules define an srcu_struct and invoke init_srcu_struct()
>     from their module_init function and cleanup_srcu_struct() from their
>     module_exit function.  However, this is more than a bit user unfriendly.
>     
>     This commit therefore creates an ___srcu_struct_ptrs linker section,
>     and pointers to srcu_struct structures created by DEFINE_SRCU() and
>     DEFINE_STATIC_SRCU() within a module are placed into that module's
>     ___srcu_struct_ptrs section.  The required init_srcu_struct() and
>     cleanup_srcu_struct() functions are then automatically invoked as needed
>     when that module is loaded and unloaded, thus allowing modules to continue
>     to use DEFINE_SRCU() and DEFINE_STATIC_SRCU() while avoiding the need
>     to increase the size of the reserved region.
>     
>     Many of the algorithms and some of the code was cheerfully cherry-picked
>     from other code making use of linker sections, perhaps most notably from
>     tracepoints.  All bugs are nevertheless the sole property of the author.
>     
>     Suggested-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>     Signed-off-by: Paul E. McKenney <paulmck-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index f8f6f04c4453..c2d919a1566e 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -338,6 +338,10 @@
>  		KEEP(*(__tracepoints_ptrs)) /* Tracepoints: pointer array */ \
>  		__stop___tracepoints_ptrs = .;				\
>  		*(__tracepoints_strings)/* Tracepoints: strings */	\
> +		. = ALIGN(8);						\
> +		__start___srcu_struct = .;				\
> +		*(___srcu_struct_ptrs)					\
> +		__end___srcu_struct = .;				\
>  	}								\

This vmlinux linker modification is not needed. I tested without it and srcu
torture works fine with rcutorture built as a module. Putting further prints
in kernel/module.c verified that the kernel is able to find the srcu structs
just fine. You could squash the below patch into this one or apply it on top
of the dev branch.

Thanks!

---8<-----------------------

>From 369ad090f706ce8e1facdd18eb10828b5f7e2b72 Mon Sep 17 00:00:00 2001
From: "Joel Fernandes (Google)" <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>
Date: Sat, 6 Apr 2019 18:57:17 -0400
Subject: [PATCH] srcu: Remove unused vmlinux srcu linker entries

The SRCU for modules optimization introduced vmlinux linker entries
which is unused since it applies only to the built-in vmlinux. So remove
it to prevent any space usage due to the 8 byte alignment.

Tested with SRCU torture_type and rcutorture.

Cc: kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org
Cc: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Signed-off-by: Joel Fernandes (Google) <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>
---
 include/asm-generic/vmlinux.lds.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index c2d919a1566e..f8f6f04c4453 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -338,10 +338,6 @@
 		KEEP(*(__tracepoints_ptrs)) /* Tracepoints: pointer array */ \
 		__stop___tracepoints_ptrs = .;				\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
-		. = ALIGN(8);						\
-		__start___srcu_struct = .;				\
-		*(___srcu_struct_ptrs)					\
-		__end___srcu_struct = .;				\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
-- 
2.21.0.392.gf8f6787159e-goog
