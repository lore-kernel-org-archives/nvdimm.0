From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC tip/core/rcu 0/4] Forbid static SRCU use in modules
Date: Tue, 9 Apr 2019 11:56:03 -0400 (EDT)
Message-ID: <534133139.2374.1554825363211.JavaMail.zimbra@efficios.com>
References: <20190402142816.GA13084@linux.ibm.com>
 <20190408022728.GF14111@linux.ibm.com>
 <1504296005.857.1554728734661.JavaMail.zimbra@efficios.com>
 <20190408142230.GJ14111@linux.ibm.com>
 <1447252022.1166.1554734972823.JavaMail.zimbra@efficios.com>
 <20190408154616.GO14111@linux.ibm.com>
 <1489474416.1465.1554744287985.JavaMail.zimbra@efficios.com>
 <20190409154012.GC248418@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190409154012.GC248418-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Joel Fernandes, Google" <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, amd-gfx <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, fweisbec <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Lai Jiangshan <jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, rcu <rcu-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dipankar <dipankar-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, paulmck <paulmck-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

----- On Apr 9, 2019, at 11:40 AM, Joel Fernandes, Google joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org wrote:

> On Mon, Apr 08, 2019 at 01:24:47PM -0400, Mathieu Desnoyers wrote:
>> ----- On Apr 8, 2019, at 11:46 AM, paulmck paulmck-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org wrote:
>> 
>> > On Mon, Apr 08, 2019 at 10:49:32AM -0400, Mathieu Desnoyers wrote:
>> >> ----- On Apr 8, 2019, at 10:22 AM, paulmck paulmck-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org wrote:
>> >> 
>> >> > On Mon, Apr 08, 2019 at 09:05:34AM -0400, Mathieu Desnoyers wrote:
>> >> >> ----- On Apr 7, 2019, at 10:27 PM, paulmck paulmck-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org wrote:
>> >> >> 
>> >> >> > On Sun, Apr 07, 2019 at 09:07:18PM +0000, Joel Fernandes wrote:
>> >> >> >> On Sun, Apr 07, 2019 at 04:41:36PM -0400, Mathieu Desnoyers wrote:
>> >> >> >> > 
>> >> >> >> > ----- On Apr 7, 2019, at 3:32 PM, Joel Fernandes, Google joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org
>> >> >> >> > wrote:
>> >> >> >> > 
>> >> >> >> > > On Sun, Apr 07, 2019 at 03:26:16PM -0400, Mathieu Desnoyers wrote:
>> >> >> >> > >> ----- On Apr 7, 2019, at 9:59 AM, paulmck paulmck-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org wrote:
>> >> >> >> > >> 
>> >> >> >> > >> > On Sun, Apr 07, 2019 at 06:39:41AM -0700, Paul E. McKenney wrote:
>> >> >> >> > >> >> On Sat, Apr 06, 2019 at 07:06:13PM -0400, Joel Fernandes wrote:
>> >> >> >> > >> > 
>> >> >> >> > >> > [ . . . ]
>> >> >> >> > >> > 
>> >> >> >> > >> >> > > diff --git a/include/asm-generic/vmlinux.lds.h
>> >> >> >> > >> >> > > b/include/asm-generic/vmlinux.lds.h
>> >> >> >> > >> >> > > index f8f6f04c4453..c2d919a1566e 100644
>> >> >> >> > >> >> > > --- a/include/asm-generic/vmlinux.lds.h
>> >> >> >> > >> >> > > +++ b/include/asm-generic/vmlinux.lds.h
>> >> >> >> > >> >> > > @@ -338,6 +338,10 @@
>> >> >> >> > >> >> > >  		KEEP(*(__tracepoints_ptrs)) /* Tracepoints: pointer array */ \
>> >> >> >> > >> >> > >  		__stop___tracepoints_ptrs = .;				\
>> >> >> >> > >> >> > >  		*(__tracepoints_strings)/* Tracepoints: strings */	\
>> >> >> >> > >> >> > > +		. = ALIGN(8);						\
>> >> >> >> > >> >> > > +		__start___srcu_struct = .;				\
>> >> >> >> > >> >> > > +		*(___srcu_struct_ptrs)					\
>> >> >> >> > >> >> > > +		__end___srcu_struct = .;				\
>> >> >> >> > >> >> > >  	}								\
>> >> >> >> > >> >> > 
>> >> >> >> > >> >> > This vmlinux linker modification is not needed. I tested without it and srcu
>> >> >> >> > >> >> > torture works fine with rcutorture built as a module. Putting further prints
>> >> >> >> > >> >> > in kernel/module.c verified that the kernel is able to find the srcu structs
>> >> >> >> > >> >> > just fine. You could squash the below patch into this one or apply it on top
>> >> >> >> > >> >> > of the dev branch.
>> >> >> >> > >> >> 
>> >> >> >> > >> >> Good point, given that otherwise FORTRAN named common blocks would not
>> >> >> >> > >> >> work.
>> >> >> >> > >> >> 
>> >> >> >> > >> >> But isn't one advantage of leaving that stuff in the RO_DATA_SECTION()
>> >> >> >> > >> >> macro that it can be mapped read-only?  Or am I suffering from excessive
>> >> >> >> > >> >> optimism?
>> >> >> >> > >> > 
>> >> >> >> > >> > And to answer the other question, in the case where I am suffering from
>> >> >> >> > >> > excessive optimism, it should be a separate commit.  Please see below
>> >> >> >> > >> > for the updated original commit thus far.
>> >> >> >> > >> > 
>> >> >> >> > >> > And may I have your Tested-by?
>> >> >> >> > >> 
>> >> >> >> > >> Just to confirm: does the cleanup performed in the modules going
>> >> >> >> > >> notifier end up acting as a barrier first before freeing the memory ?
>> >> >> >> > >> If not, is it explicitly stated that a barrier must be issued before
>> >> >> >> > >> module unload ?
>> >> >> >> > >> 
>> >> >> >> > > 
>> >> >> >> > > You mean rcu_barrier? It is mentioned in the documentation that this is the
>> >> >> >> > > responsibility of the module writer to prevent delays for all modules.
>> >> >> >> > 
>> >> >> >> > It's a srcu barrier yes. Considering it would be a barrier specific to the
>> >> >> >> > srcu domain within that module, I don't see how it would cause delays for
>> >> >> >> > "all" modules if we implicitly issue the barrier on module unload. What
>> >> >> >> > am I missing ?
>> >> >> >> 
>> >> >> >> Yes you are right. I thought of this after I just sent my email. I think it
>> >> >> >> makes sense for srcu case to do and could avoid a class of bugs.
>> >> >> > 
>> >> >> > If there are call_srcu() callbacks outstanding, the module writer still
>> >> >> > needs the srcu_barrier() because otherwise callbacks arrive after
>> >> >> > the module text has gone, which will be disappoint the CPU when it
>> >> >> > tries fetching instructions that are no longer mapped.  If there are
>> >> >> > no call_srcu() callbacks from that module, then there is no need for
>> >> >> > srcu_barrier() either way.
>> >> >> > 
>> >> >> > So if an srcu_barrier() is needed, the module developer needs to
>> >> >> > supply it.
>> >> >> 
>> >> >> When you say "callbacks arrive after the module text has gone",
>> >> >> I think you assume that free_module() is invoked before the
>> >> >> MODULE_STATE_GOING notifiers are called. But it's done in the
>> >> >> opposite order: going notifiers are called first, and then
>> >> >> free_module() is invoked.
>> >> >> 
>> >> >> So AFAIU it would be safe to issue the srcu_barrier() from the module
>> >> >> going notifier.
>> >> >> 
>> >> >> Or am I missing something ?
>> >> > 
>> >> > We do seem to be talking past each other.  ;-)
>> >> > 
>> >> > This has nothing to do with the order of events at module-unload time.
>> >> > 
>> >> > So please let me try again.
>> >> > 
>> >> > If a given srcu_struct in a module never has call_srcu() invoked, there
>> >> > is no need to invoke rcu_barrier() at any time, whether at module-unload
>> >> > time or not.  Adding rcu_barrier() in this case adds overhead and latency
>> >> > for no good reason.
>> >> 
>> >> Not if we invoke srcu_barrier() for that specific domain. If
>> >> call_srcu was never invoked for a srcu domain, I don't see why
>> >> srcu_barrier() should be more expensive than a simple check that
>> >> the domain does not have any srcu work queued.
>> > 
>> > But that simple check does involve a cache miss for each possible CPU (not
>> > just each online CPU), so it is non-trivial, especially on large systems.
>> > 
>> >> > If a given srcu_struct in a module does have at least one call_srcu()
>> >> > invoked, it is already that module's responsibility to make sure that
>> >> > the code sticks around long enough for the callback to be invoked.
>> >> 
>> >> I understand that when users do explicit dynamic allocation/cleanup of
>> >> srcu domains, they indeed need to take care of doing explicit srcu_barrier().
>> >> However, if they do static definition of srcu domains, it would be nice
>> >> if we can handle the barriers under the hood.
>> > 
>> > All else being equal, of course.  But...
>> > 
>> >> > This means that correct SRCU users that invoke call_srcu() already
>> >> > have srcu_barrier() at module-unload time.  Incorrect SRCU users, with
>> >> > reasonable probability, now get a WARN_ON() at module-unload time, with
>> >> > the per-CPU state getting leaked.  Before this change, they would (also
>> >> > with reasonable probability) instead get an instruction-fetch fault when
>> >> > the SRCU callback was invoked after the completion of the module unload.
>> >> > Furthermore, in all cases where they would previously have gotten the
>> >> > instruction-fetch fault, they now get the WARN_ON(), like this:
>> >> > 
>> >> >	if (WARN_ON(rcu_segcblist_n_cbs(&sdp->srcu_cblist)))
>> >> >		return; /* Forgot srcu_barrier(), so just leak it! */
>> >> > 
>> >> > So this change already represents an improvement in usability.
>> >> 
>> >> Considering that we can do a srcu_barrier() for the specific domain,
>> >> and that it should add no noticeable overhead if there is no queued
>> >> callbacks, I don't see a good reason for leaving the srcu_barrier
>> >> invocation to the user rather than implicitly doing it from the
>> >> module going notifier.
>> > 
>> > Now, I could automatically add an indicator of whether or not a
>> > call_srcu() had happened, but then again, that would either add a
>> > call_srcu() scalability bottleneck or again require a scan of all possible
>> > CPUs...  to figure out if it was necessary to scan all possible CPUs.
>> > 
>> > Or is scanning all possible CPUs down in the noise in this case?  Or
>> > am I missing a trick that would reduce the overhead?
>> 
>> Module unloading implicitly does a synchronize_rcu (for RCU-sched), and
>> a stop_machine. So I would be tempted to say that overhead of iteration
>> over all CPUs might not matter that much considering the rest.
>> 
>> About notifying that a call_srcu has happened for the srcu domain in a
>> scalable fashion, let's see... We could have a flag "call_srcu_used"
>> for each call_srcu domain. Whenever call_srcu is invoked, it would
>> load that flag. It sets it on first use.
>> 
>> The idea here is to only use that flag when srcu_barrier is performed
>> right before the srcu domain cleanup (it could become part of that
>> cleanup). Else, using it in all srcu_barrier() might be tricky, because
>> we may then need to add memory barriers or locking to the call_srcu
>> fast-path, which is an overhead we try to avoid.
>> 
>> However, if we only use that flag as part of the srcu domain cleanup,
>> it's already prohibited to invoke call_srcu concurrently with the
>> cleanup of the same domain, so I don't think we would need any
>> memory barriers in call_srcu.
> 
> About the last part of your email, it seems to that if after call_srcu has
> returned, if the module could be unloaded on some other CPU - then it would
> need to see the flag stored by the preceding call_srcu, so I believe there
> would be a memory barrier between the two opreations (call_srcu and module
> unload).

In order for the module unload not to race against module execution, it needs
to happen after the call_srcu in a way that is already ordered by other means,
else module unload races against the module code.

> 
> Also about doing the unconditional srcu_barrier, since a module could be
> unloaded at any time - don't all SRCU using modules need to invoke
> srcu_barrier() during their clean up anyway so we are incurring the barrier
> overhead anyway? Or, am I missing a design pattern here? It seems to me
> rcutorture module definitely calls srcu_barrier() before it is unloaded.

I think a valid approach which is even simpler might be: if a module statically
defines a SRCU domain, it should be expected to use it. So adding a srcu_barrier()
to its module going notifier should not hurt. The rare case where a module defines
a static SRCU domain *and* does not actually use it with call_srcu() does not
seem that usual, and not worth optimizing for.

Thoughts ?

Thanks,

Mathieu


> 
> thanks,
> 
> - Joel
> 
>> Thoughts ?
>> 
>> Thanks,
>> 
>> Mathieu
>> 
>> --
>> Mathieu Desnoyers
>> EfficiOS Inc.
> > http://www.efficios.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
