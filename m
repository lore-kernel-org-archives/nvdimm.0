From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC tip/core/rcu 0/4] Forbid static SRCU use in modules
Date: Sun, 7 Apr 2019 16:41:36 -0400 (EDT)
Message-ID: <1632568795.549.1554669696728.JavaMail.zimbra@efficios.com>
References: <20190402142816.GA13084@linux.ibm.com>
 <20190403162039.GA14111@linux.ibm.com> <20190405232835.GA24702@linux.ibm.com>
 <20190406230613.GA187766@google.com> <20190407133941.GC14111@linux.ibm.com>
 <20190407135937.GA30053@linux.ibm.com>
 <134026717.535.1554665176677.JavaMail.zimbra@efficios.com>
 <20190407193202.GA30934@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190407193202.GA30934@localhost>
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


----- On Apr 7, 2019, at 3:32 PM, Joel Fernandes, Google joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org wrote:

> On Sun, Apr 07, 2019 at 03:26:16PM -0400, Mathieu Desnoyers wrote:
>> ----- On Apr 7, 2019, at 9:59 AM, paulmck paulmck-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org wrote:
>> 
>> > On Sun, Apr 07, 2019 at 06:39:41AM -0700, Paul E. McKenney wrote:
>> >> On Sat, Apr 06, 2019 at 07:06:13PM -0400, Joel Fernandes wrote:
>> > 
>> > [ . . . ]
>> > 
>> >> > > diff --git a/include/asm-generic/vmlinux.lds.h
>> >> > > b/include/asm-generic/vmlinux.lds.h
>> >> > > index f8f6f04c4453..c2d919a1566e 100644
>> >> > > --- a/include/asm-generic/vmlinux.lds.h
>> >> > > +++ b/include/asm-generic/vmlinux.lds.h
>> >> > > @@ -338,6 +338,10 @@
>> >> > >  		KEEP(*(__tracepoints_ptrs)) /* Tracepoints: pointer array */ \
>> >> > >  		__stop___tracepoints_ptrs = .;				\
>> >> > >  		*(__tracepoints_strings)/* Tracepoints: strings */	\
>> >> > > +		. = ALIGN(8);						\
>> >> > > +		__start___srcu_struct = .;				\
>> >> > > +		*(___srcu_struct_ptrs)					\
>> >> > > +		__end___srcu_struct = .;				\
>> >> > >  	}								\
>> >> > 
>> >> > This vmlinux linker modification is not needed. I tested without it and srcu
>> >> > torture works fine with rcutorture built as a module. Putting further prints
>> >> > in kernel/module.c verified that the kernel is able to find the srcu structs
>> >> > just fine. You could squash the below patch into this one or apply it on top
>> >> > of the dev branch.
>> >> 
>> >> Good point, given that otherwise FORTRAN named common blocks would not
>> >> work.
>> >> 
>> >> But isn't one advantage of leaving that stuff in the RO_DATA_SECTION()
>> >> macro that it can be mapped read-only?  Or am I suffering from excessive
>> >> optimism?
>> > 
>> > And to answer the other question, in the case where I am suffering from
>> > excessive optimism, it should be a separate commit.  Please see below
>> > for the updated original commit thus far.
>> > 
>> > And may I have your Tested-by?
>> 
>> Just to confirm: does the cleanup performed in the modules going
>> notifier end up acting as a barrier first before freeing the memory ?
>> If not, is it explicitly stated that a barrier must be issued before
>> module unload ?
>> 
> 
> You mean rcu_barrier? It is mentioned in the documentation that this is the
> responsibility of the module writer to prevent delays for all modules.

It's a srcu barrier yes. Considering it would be a barrier specific to the
srcu domain within that module, I don't see how it would cause delays for
"all" modules if we implicitly issue the barrier on module unload. What
am I missing ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
