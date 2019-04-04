Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 90847211F99AA
 for <linux-nvdimm@lists.01.org>; Thu,  4 Apr 2019 14:05:06 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x34L48aD027937
 for <linux-nvdimm@lists.01.org>; Thu, 4 Apr 2019 17:05:05 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2rnr6ukc5s-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Thu, 04 Apr 2019 17:05:04 -0400
Received: from localhost
 by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <paulmck@linux.vnet.ibm.com>;
 Thu, 4 Apr 2019 22:05:02 +0100
Date: Thu, 4 Apr 2019 14:04:56 -0700
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [PATCH RFC tip/core/rcu 1/4] dax/super: Dynamically allocate
 dax_srcu
References: <20190402142816.GA13084@linux.ibm.com>
 <20190402142933.14547-1-paulmck@linux.ibm.com>
 <CAPcyv4gOQ_KpZm8ediav4O-cLzqP6Fsd3ZmFC-AKeAh77i0N+A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gOQ_KpZm8ediav4O-cLzqP6Fsd3ZmFC-AKeAh77i0N+A@mail.gmail.com>
Message-Id: <20190404210456.GN14111@linux.ibm.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: paulmck@linux.ibm.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, fweisbec@gmail.com, jiangshanlai@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Oleg Nesterov <oleg@redhat.com>, dipankar@in.ibm.com, joel@joelfernandes.org, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 03, 2019 at 11:31:01AM -0700, Dan Williams wrote:
> On Tue, Apr 2, 2019 at 7:29 AM Paul E. McKenney <paulmck@linux.ibm.com> wrote:
> >
> > Having DEFINE_SRCU() or DEFINE_STATIC_SRCU() in a loadable module
> > requires that the size of the reserved region be increased, which is
> > not something we really want to be doing.  This commit therefore removes
> > the DEFINE_STATIC_SRCU() from drivers/dax/super.c in favor of defining
> > dax_srcu as a simple srcu_struct, initializing it in dax_core_init(),
> > and cleaning it up in dax_core_exit().
> >
> > Reported-by: kbuild test robot <lkp@intel.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>
> 
> Looks good to me.
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Applied, thank you!

							Thanx, Paul

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
