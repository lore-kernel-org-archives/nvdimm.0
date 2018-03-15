Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6CFE22095606B
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 02:52:24 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20180313102056.GJ4043@hirez.programming.kicks-ass.net>
References: <20180313102056.GJ4043@hirez.programming.kicks-ass.net>
 <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152066493247.40260.10849841915366086021.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180311112725.GC4043@hirez.programming.kicks-ass.net>
 <CAPcyv4jr53dqVTzdEQ6Ln1Qg7nWVMQSVTkf6uc+Lg6Y-xruhuw@mail.gmail.com>
Subject: Re: [RFC][PATCH] sched/wait_bit: Introduce
 wait_var_event()/wake_up_var()
MIME-Version: 1.0
Content-ID: <3395.1521107922.1@warthog.procyon.org.uk>
Date: Thu, 15 Mar 2018 09:58:42 +0000
Message-ID: <3396.1521107922@warthog.procyon.org.uk>
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
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>, dhowells@redhat.com, Ingo Molnar <mingo@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Peter Zijlstra <peterz@infradead.org> wrote:

> > > Argh, no no no.. That whole wait_for_atomic_t thing is a giant
> > > trainwreck already and now you're making it worse still.

Your patch description needs to say why this isn't a trainwreck when you
consider wait_for_atomic_t() to be one since it does things in a very similar
way.

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
