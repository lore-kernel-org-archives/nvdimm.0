From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC tip/core/rcu 0/4] Forbid static SRCU use in modules
Date: Tue, 9 Apr 2019 14:04:11 -0400 (EDT)
Message-ID: <1445093299.2510.1554833051142.JavaMail.zimbra@efficios.com>
References: <20190402142816.GA13084@linux.ibm.com>
 <20190408154616.GO14111@linux.ibm.com>
 <1489474416.1465.1554744287985.JavaMail.zimbra@efficios.com>
 <20190409154012.GC248418@google.com>
 <534133139.2374.1554825363211.JavaMail.zimbra@efficios.com>
 <20190409164031.GE14111@linux.ibm.com>
 <1958511501.2412.1554828325809.JavaMail.zimbra@efficios.com>
 <20190409175549.GG14111@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190409175549.GG14111-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: paulmck <paulmck-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, amd-gfx <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, fweisbec <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Lai Jiangshan <jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, rcu <rcu-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dipankar <dipankar-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>, "Joel Fernandes, Google" <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

----- On Apr 9, 2019, at 1:55 PM, paulmck paulmck-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org wrote:
[...]
> The current state is not horrible, so my thought would be to give it
> some time to see if better thoughts arise.
> 
> Either way, cleanup_srcu_struct() keeps its current checks for callbacks
> still being in flight, which is why I believe that the current state is
> not horrible.  ;-)

In that case, I think the comment above cleanup_srcu_struct_quiesced() in
include/linux/srcu.h needs to be updated to cover situations where API
users statically define a SRCU domain in a module and intend to unload
that module.

Given that we end up doing the allocation/cleanup under the hood, the
API users don't interact with init_srcu_struct() nor cleanup_srcu_struct(),
so it's not obvious that this comment also applies to them.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
