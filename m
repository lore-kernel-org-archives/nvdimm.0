Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0A0752098C209
 for <linux-nvdimm@lists.01.org>; Wed, 30 May 2018 20:42:19 -0700 (PDT)
Date: Wed, 30 May 2018 23:42:17 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [patch 4/4] dm-writecache: use new API for flushing
Message-ID: <20180531034216.GB88973@redhat.com>
References: <CAPcyv4jXV4aZ6wqqjVPL8J4LxwTtXnzQCLZ0Wk5oB4_0uxpg7g@mail.gmail.com>
 <alpine.LRH.2.02.1805300903220.1090@file01.intranet.prod.int.rdu2.redhat.com>
 <20180530131623.GB2106@redhat.com>
 <alpine.LRH.2.02.1805300919070.11327@file01.intranet.prod.int.rdu2.redhat.com>
 <20180530132647.GB5157@redhat.com>
 <alpine.LRH.2.02.1805300929500.11327@file01.intranet.prod.int.rdu2.redhat.com>
 <20180530135421.GA81788@redhat.com>
 <alpine.LRH.2.02.1805300959460.16696@file01.intranet.prod.int.rdu2.redhat.com>
 <20180530142104.GA5416@redhat.com>
 <alpine.LRH.2.02.1805301023380.21890@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1805301023380.21890@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 30 2018 at 10:46P -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Wed, 30 May 2018, Mike Snitzer wrote:
> 
> > > > Fine I'll deal with it.  reordering the fields eliminated holes in the
> > > > structure and reduced struct members spanning cache lines.
> > > 
> > > And what about this?
> > > #define WC_MODE_PMEM(wc)                        ((wc)->pmem_mode)
> > > 
> > > The code that I had just allowed the compiler to optimize out 
> > > persistent-memory code if we have DM_WRITECACHE_ONLY_SSD defined - and you 
> > > deleted it.
> > > 
> > > Most architectures don't have persistent memory and the dm-writecache 
> > > driver could work in ssd-only mode on them. On these architectures, I 
> > > define
> > > #define WC_MODE_PMEM(wc)                        false
> > > - and the compiler will just automatically remove the tests for that 
> > > condition and the unused branch. It does also eliminate unused static 
> > > functions.
> > 
> > This level of microoptimization can be backfilled.  But as it was, there
> > were too many #defines.  And I'm really not concerned with eliminating
> > unused static functions for this case.
> 
> I don't see why "too many defines" would be a problem.
> 
> If I compile it with and without pmem support, the difference is 
> 15kB-vs-12kB. If we look at just one function (writecache_map), the 
> difference is 1595 bytes - vs - 1280 bytes. So, it produces real savings 
> in code size.
> 
> The problem with performance is not caused a condition that always jumps 
> the same way (that is predicted by the CPU and it causes no delays in the 
> pipeline) - the problem is that a bigger function consumes more i-cache. 
> There is no reason to include code that can't be executed.

Please double check you see the reduced code size you're expecting using
the latest dm-writecache.c in linux-dm.git's dm-4.18 branch.

Thanks,
Mike
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
