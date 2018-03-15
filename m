Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from merlin.infradead.org (merlin.infradead.org
 [IPv6:2001:8b0:10b:1231::1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0B53B20954B8F
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 04:13:08 -0700 (PDT)
Date: Thu, 15 Mar 2018 12:19:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH] sched/wait_bit: Introduce
 wait_var_event()/wake_up_var()
Message-ID: <20180315111915.GV4064@hirez.programming.kicks-ass.net>
References: <20180313102056.GJ4043@hirez.programming.kicks-ass.net>
 <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152066493247.40260.10849841915366086021.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180311112725.GC4043@hirez.programming.kicks-ass.net>
 <CAPcyv4jr53dqVTzdEQ6Ln1Qg7nWVMQSVTkf6uc+Lg6Y-xruhuw@mail.gmail.com>
 <3396.1521107922@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3396.1521107922@warthog.procyon.org.uk>
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
To: David Howells <dhowells@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 15, 2018 at 09:58:42AM +0000, David Howells wrote:
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > > Argh, no no no.. That whole wait_for_atomic_t thing is a giant
> > > > trainwreck already and now you're making it worse still.
> 
> Your patch description needs to say why this isn't a trainwreck when you
> consider wait_for_atomic_t() to be one since it does things in a very similar
> way.

Yeah, still writing changelogs..
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
