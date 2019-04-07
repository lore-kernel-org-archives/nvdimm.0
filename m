From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH RFC tip/core/rcu 0/4] Forbid static SRCU use in modules
Date: Sun, 7 Apr 2019 21:07:18 +0000
Message-ID: <20190407210718.GA6656@localhost>
References: <20190402142816.GA13084@linux.ibm.com>
 <20190403162039.GA14111@linux.ibm.com>
 <20190405232835.GA24702@linux.ibm.com>
 <20190406230613.GA187766@google.com>
 <20190407133941.GC14111@linux.ibm.com>
 <20190407135937.GA30053@linux.ibm.com>
 <134026717.535.1554665176677.JavaMail.zimbra@efficios.com>
 <20190407193202.GA30934@localhost>
 <1632568795.549.1554669696728.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1632568795.549.1554669696728.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: paulmck <paulmck@linux.ibm.com>, rcu <rcu@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, dipankar <dipankar@in.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, rostedt <rostedt@goodmis.org>, David Howells <dhowells@redhat.com>, Eric Dumazet <edumazet@google.com>, fweisbec <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, dri-devel <dri-devel@lists.freedesktop.org>, amd-gfx <amd-gfx@lists.freedesktop.org>
List-Id: linux-nvdimm@lists.01.org

On Sun, Apr 07, 2019 at 04:41:36PM -0400, Mathieu Desnoyers wrote:
> 
> ----- On Apr 7, 2019, at 3:32 PM, Joel Fernandes, Google joel@joelfernandes.org wrote:
> 
> > On Sun, Apr 07, 2019 at 03:26:16PM -0400, Mathieu Desnoyers wrote:
> >> ----- On Apr 7, 2019, at 9:59 AM, paulmck paulmck@linux.ibm.com wrote:
> >> 
> >> > On Sun, Apr 07, 2019 at 06:39:41AM -0700, Paul E. McKenney wrote:
> >> >> On Sat, Apr 06, 2019 at 07:06:13PM -0400, Joel Fernandes wrote:
> >> > 
> >> > [ . . . ]
> >> > 
> >> >> > > diff --git a/include/asm-generic/vmlinux.lds.h
> >> >> > > b/include/asm-generic/vmlinux.lds.h
> >> >> > > index f8f6f04c4453..c2d919a1566e 100644
> >> >> > > --- a/include/asm-generic/vmlinux.lds.h
> >> >> > > +++ b/include/asm-generic/vmlinux.lds.h
> >> >> > > @@ -338,6 +338,10 @@
> >> >> > >  		KEEP(*(__tracepoints_ptrs)) /* Tracepoints: pointer array */ \
> >> >> > >  		__stop___tracepoints_ptrs = .;				\
> >> >> > >  		*(__tracepoints_strings)/* Tracepoints: strings */	\
> >> >> > > +		. = ALIGN(8);						\
> >> >> > > +		__start___srcu_struct = .;				\
> >> >> > > +		*(___srcu_struct_ptrs)					\
> >> >> > > +		__end___srcu_struct = .;				\
> >> >> > >  	}								\
> >> >> > 
> >> >> > This vmlinux linker modification is not needed. I tested without it and srcu
> >> >> > torture works fine with rcutorture built as a module. Putting further prints
> >> >> > in kernel/module.c verified that the kernel is able to find the srcu structs
> >> >> > just fine. You could squash the below patch into this one or apply it on top
> >> >> > of the dev branch.
> >> >> 
> >> >> Good point, given that otherwise FORTRAN named common blocks would not
> >> >> work.
> >> >> 
> >> >> But isn't one advantage of leaving that stuff in the RO_DATA_SECTION()
> >> >> macro that it can be mapped read-only?  Or am I suffering from excessive
> >> >> optimism?
> >> > 
> >> > And to answer the other question, in the case where I am suffering from
> >> > excessive optimism, it should be a separate commit.  Please see below
> >> > for the updated original commit thus far.
> >> > 
> >> > And may I have your Tested-by?
> >> 
> >> Just to confirm: does the cleanup performed in the modules going
> >> notifier end up acting as a barrier first before freeing the memory ?
> >> If not, is it explicitly stated that a barrier must be issued before
> >> module unload ?
> >> 
> > 
> > You mean rcu_barrier? It is mentioned in the documentation that this is the
> > responsibility of the module writer to prevent delays for all modules.
> 
> It's a srcu barrier yes. Considering it would be a barrier specific to the
> srcu domain within that module, I don't see how it would cause delays for
> "all" modules if we implicitly issue the barrier on module unload. What
> am I missing ?

Yes you are right. I thought of this after I just sent my email. I think it
makes sense for srcu case to do and could avoid a class of bugs.

thanks!

> 
> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
