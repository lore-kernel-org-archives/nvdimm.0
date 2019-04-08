From: Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH RFC tip/core/rcu 0/4] Forbid static SRCU use in modules
Date: Sun, 7 Apr 2019 20:36:46 -0400
Message-ID: <20190408003646.GA135726@google.com>
References: <161156422.1435.1554219247444.JavaMail.zimbra@efficios.com>
 <20190403133243.GE4102@linux.ibm.com>
 <1028306587.504.1554301662374.JavaMail.zimbra@efficios.com>
 <20190403162039.GA14111@linux.ibm.com>
 <20190405232835.GA24702@linux.ibm.com>
 <20190406230613.GA187766@google.com>
 <20190407133941.GC14111@linux.ibm.com>
 <20190407135937.GA30053@linux.ibm.com>
 <20190407154613.GA2770@localhost>
 <20190407170514.GE14111@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190407170514.GE14111-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Paul E. McKenney" <paulmck-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Jessica Yu <jeyu-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, amd-gfx <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, fweisbec <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Lai Jiangshan <jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, rcu <rcu-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dipankar <dipankar-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Sun, Apr 07, 2019 at 10:05:14AM -0700, Paul E. McKenney wrote:
> On Sun, Apr 07, 2019 at 03:46:13PM +0000, Joel Fernandes wrote:
> > On Sun, Apr 07, 2019 at 06:59:37AM -0700, Paul E. McKenney wrote:
> > > On Sun, Apr 07, 2019 at 06:39:41AM -0700, Paul E. McKenney wrote:
> > > > On Sat, Apr 06, 2019 at 07:06:13PM -0400, Joel Fernandes wrote:
> > > 
> > > [ . . . ]
> > > 
> > > > > > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > > > > > index f8f6f04c4453..c2d919a1566e 100644
> > > > > > --- a/include/asm-generic/vmlinux.lds.h
> > > > > > +++ b/include/asm-generic/vmlinux.lds.h
> > > > > > @@ -338,6 +338,10 @@
> > > > > >  		KEEP(*(__tracepoints_ptrs)) /* Tracepoints: pointer array */ \
> > > > > >  		__stop___tracepoints_ptrs = .;				\
> > > > > >  		*(__tracepoints_strings)/* Tracepoints: strings */	\
> > > > > > +		. = ALIGN(8);						\
> > > > > > +		__start___srcu_struct = .;				\
> > > > > > +		*(___srcu_struct_ptrs)					\
> > > > > > +		__end___srcu_struct = .;				\
> > > > > >  	}								\
> > > > > 
> > > > > This vmlinux linker modification is not needed. I tested without it and srcu
> > > > > torture works fine with rcutorture built as a module. Putting further prints
> > > > > in kernel/module.c verified that the kernel is able to find the srcu structs
> > > > > just fine. You could squash the below patch into this one or apply it on top
> > > > > of the dev branch.
> > > > 
> > > > Good point, given that otherwise FORTRAN named common blocks would not
> > > > work.
> > > > 
> > > > But isn't one advantage of leaving that stuff in the RO_DATA_SECTION()
> > > > macro that it can be mapped read-only?  Or am I suffering from excessive
> > > > optimism?
> > > 
> > > And to answer the other question, in the case where I am suffering from
> > > excessive optimism, it should be a separate commit.  Please see below
> > > for the updated original commit thus far.
> > 
> > Actually the vmlinux.lds.h file is unused for module building. For ex, if you
> > delete include/asm-generic/vmlinux.lds.h , then you can still build
> > rcutorture.ko. Did I miss something obvious? In that case the vmlinux.lds.h
> > are not needed since the __section annotations automatically place the srcu
> > structs in a separate section.
> 
> Hard to argue given that I just deleted include/asm-generic/vmlinux.lds.h,
> touched kernel/rcu/rcutorture.c, and rebuilt the corresponding .ko
> without errors.  ;-)
> 
> Hmmm...  Is there some way to place a section into a read-only page,
> for example, tagged onto the text section for that module?  That would
> get rid of a class of bugs, if nothing else.

Strictly speaking, the array of pointers in the new srcu section are fixed up
at runtime because the srcu_struct(s) they point to can be loaded at a
dynamic location in memory. The srcu_struct(s) are themselves in the .bss
section of the module and their locations depend on where the .bss section of
the module is loaded in memory at load time.

I agree that after such relocation fixups are done, there is no reason to keep
the array-of-pointers section readable but unfortunately I couldn't figure a
way out to make them read-only post the relocations.

I copied Jessica Yu who maintains module loading for any input. Jessica, as a
summary, we are trying to create a custom ELF section of srcu_struct pointers
in kernels modules, and then make the module loader do SRCU initialization
from structs pointed to by this section.  The srcu_struct themselves are defined
on the .bss section. Is there any way we can make this pointer array section
read-only *after* the relocation fixups of the array are completed?

> > Let me know if you would like me to send a patch separately, or if the
> > appended patch for the same in my previous email suffices.
> 
> Please do resend as a formal patch with the above in the commit log.
> I doubt that I am the only one needing a bit of module-build education!
> And thank you for providing that education, by the way!

Sounds great, I will go ahead and send out a patch in the morning for this
part.

> > > And may I have your Tested-by?
> > 
> > Absolutely, please do and thanks!
> 
> Done, and thank you for giving it a go!

You're very welcome. thanks,

 - Joel
