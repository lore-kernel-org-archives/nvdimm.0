Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2EEDB211D9155
 for <linux-nvdimm@lists.01.org>; Wed,  3 Apr 2019 11:31:13 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id v7so14416602oie.8
 for <linux-nvdimm@lists.01.org>; Wed, 03 Apr 2019 11:31:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190402142816.GA13084@linux.ibm.com>
 <20190402142933.14547-1-paulmck@linux.ibm.com>
In-Reply-To: <20190402142933.14547-1-paulmck@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 3 Apr 2019 11:31:01 -0700
Message-ID: <CAPcyv4gOQ_KpZm8ediav4O-cLzqP6Fsd3ZmFC-AKeAh77i0N+A@mail.gmail.com>
Subject: Re: [PATCH RFC tip/core/rcu 1/4] dax/super: Dynamically allocate
 dax_srcu
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
Cc: David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, fweisbec@gmail.com, jiangshanlai@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Oleg Nesterov <oleg@redhat.com>, dipankar@in.ibm.com, joel@joelfernandes.org, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 2, 2019 at 7:29 AM Paul E. McKenney <paulmck@linux.ibm.com> wrote:
>
> Having DEFINE_SRCU() or DEFINE_STATIC_SRCU() in a loadable module
> requires that the size of the reserved region be increased, which is
> not something we really want to be doing.  This commit therefore removes
> the DEFINE_STATIC_SRCU() from drivers/dax/super.c in favor of defining
> dax_srcu as a simple srcu_struct, initializing it in dax_core_init(),
> and cleaning it up in dax_core_exit().
>
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>

Looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
