From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [PATCH RFC tip/core/rcu 0/4] Forbid static SRCU use in modules
Date: Tue, 9 Apr 2019 12:14:06 -0700
Message-ID: <20190409191406.GJ14111@linux.ibm.com>
References: <20190402142816.GA13084@linux.ibm.com>
 <20190408154616.GO14111@linux.ibm.com>
 <1489474416.1465.1554744287985.JavaMail.zimbra@efficios.com>
 <20190409154012.GC248418@google.com>
 <534133139.2374.1554825363211.JavaMail.zimbra@efficios.com>
 <20190409164031.GE14111@linux.ibm.com>
 <1958511501.2412.1554828325809.JavaMail.zimbra@efficios.com>
 <20190409175549.GG14111@linux.ibm.com>
 <1445093299.2510.1554833051142.JavaMail.zimbra@efficios.com>
Reply-To: paulmck@linux.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445093299.2510.1554833051142.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Joel Fernandes, Google" <joel@joelfernandes.org>, rcu <rcu@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, dipankar <dipankar@in.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, rostedt <rostedt@goodmis.org>, David Howells <dhowells@redhat.com>, Eric Dumazet <edumazet@google.com>, fweisbec <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, dri-devel <dri-devel@lists.freedesktop.org>, amd-gfx <amd-gfx@lists.freedesktop.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, Apr 09, 2019 at 02:04:11PM -0400, Mathieu Desnoyers wrote:
> ----- On Apr 9, 2019, at 1:55 PM, paulmck paulmck@linux.ibm.com wrote:
> [...]
> > The current state is not horrible, so my thought would be to give it
> > some time to see if better thoughts arise.
> > 
> > Either way, cleanup_srcu_struct() keeps its current checks for callbacks
> > still being in flight, which is why I believe that the current state is
> > not horrible.  ;-)
> 
> In that case, I think the comment above cleanup_srcu_struct_quiesced() in
> include/linux/srcu.h needs to be updated to cover situations where API
> users statically define a SRCU domain in a module and intend to unload
> that module.
> 
> Given that we end up doing the allocation/cleanup under the hood, the
> API users don't interact with init_srcu_struct() nor cleanup_srcu_struct(),
> so it's not obvious that this comment also applies to them.

Actually, it turned out that cleanup_srcu_struct_quiesced() is extremely
hard to use correctly, and maybe even impossible to use correctly.
So cleanup_srcu_struct_quiesced has been eliminated in current -rcu.

							Thanx, Paul

> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
> 
