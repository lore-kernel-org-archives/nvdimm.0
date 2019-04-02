Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com
 [IPv6:2607:f8b0:4864:20::441])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE453211E7444
 for <linux-nvdimm@lists.01.org>; Tue,  2 Apr 2019 11:40:57 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id i17so6812354pfo.6
 for <linux-nvdimm@lists.01.org>; Tue, 02 Apr 2019 11:40:57 -0700 (PDT)
Date: Tue, 2 Apr 2019 14:40:54 -0400
From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH RFC tip/core/rcu 0/4] Forbid static SRCU use in modules
Message-ID: <20190402184054.GA18150@google.com>
References: <20190402142816.GA13084@linux.ibm.com>
 <886051277.1395.1554218080591.JavaMail.zimbra@efficios.com>
 <20190402152334.GC4102@linux.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190402152334.GC4102@linux.ibm.com>
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
Cc: David Howells <dhowells@redhat.com>, amd-gfx@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm@lists.01.org, Peter Zijlstra <peterz@infradead.org>, fweisbec <fweisbec@gmail.com>, dri-devel@lists.freedesktop.org, Lai Jiangshan <jiangshanlai@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Oleg Nesterov <oleg@redhat.com>, dipankar <dipankar@in.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 02, 2019 at 08:23:34AM -0700, Paul E. McKenney wrote:
> On Tue, Apr 02, 2019 at 11:14:40AM -0400, Mathieu Desnoyers wrote:
> > ----- On Apr 2, 2019, at 10:28 AM, paulmck paulmck@linux.ibm.com wrote:
> > 
> > > Hello!
> > > 
> > > This series prohibits use of DEFINE_SRCU() and DEFINE_STATIC_SRCU()
> > > by loadable modules.  The reason for this prohibition is the fact
> > > that using these two macros within modules requires that the size of
> > > the reserved region be increased, which is not something we want to
> > > be doing all that often.  Instead, loadable modules should define an
> > > srcu_struct and invoke init_srcu_struct() from their module_init function
> > > and cleanup_srcu_struct() from their module_exit function.  Note that
> > > modules using call_srcu() will also need to invoke srcu_barrier() from
> > > their module_exit function.
> > 
> > This arbitrary API limitation seems weird.
> > 
> > Isn't there a way to allow modules to use DEFINE_SRCU and DEFINE_STATIC_SRCU
> > while implementing them with dynamic allocation under the hood ?
> 
> Although call_srcu() already has initialization hooks, some would
> also be required in srcu_read_lock(), and I am concerned about adding
> memory allocation at that point, especially given the possibility
> of memory-allocation failure.  And the possibility that the first
> srcu_read_lock() happens in an interrupt handler or similar.
> 
> Or am I missing a trick here?

Hi Paul,

Which 'reserved region' are you referring to? Isn't this region also
used for non-module cases in which case the same problem applies to
non-modules?

thanks!

 - Joel

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
