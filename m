Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8542B20985990
 for <linux-nvdimm@lists.01.org>; Wed, 30 May 2018 06:33:47 -0700 (PDT)
Date: Wed, 30 May 2018 09:33:46 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [patch 4/4] dm-writecache: use new API for flushing
In-Reply-To: <20180530132647.GB5157@redhat.com>
Message-ID: <alpine.LRH.2.02.1805300929500.11327@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1805250213270.13894@file01.intranet.prod.int.rdu2.redhat.com>
 <20180525125126.GA9275@redhat.com>
 <CAPcyv4j-v5HGBg9JMBXt7UUyw=K_bGC7t5tQGfXM9G4qjOpFjQ@mail.gmail.com>
 <alpine.LRH.2.02.1805260246250.15978@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4jwLsCNvNhgvv2DDSZuQsQXYEpKUU_5w1pTnyKj-uDBbQ@mail.gmail.com>
 <alpine.LRH.2.02.1805280922190.13486@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4jXV4aZ6wqqjVPL8J4LxwTtXnzQCLZ0Wk5oB4_0uxpg7g@mail.gmail.com>
 <alpine.LRH.2.02.1805300903220.1090@file01.intranet.prod.int.rdu2.redhat.com>
 <20180530131623.GB2106@redhat.com>
 <alpine.LRH.2.02.1805300919070.11327@file01.intranet.prod.int.rdu2.redhat.com>
 <20180530132647.GB5157@redhat.com>
MIME-Version: 1.0
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On Wed, 30 May 2018, Mike Snitzer wrote:

> On Wed, May 30 2018 at  9:21am -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Wed, 30 May 2018, Mike Snitzer wrote:
> > 
> > > That is really great news, can you submit an incremental patch that
> > > layers ontop of the linux-dm.git 'dm-4.18' branch?
> > > 
> > > Thanks,
> > > Mike
> > 
> > I've sent the current version that I have. I fixed the bugs that were 
> > reported here (missing DAX, dm_bufio_client_create, __branch_check__ 
> > long->int truncation).
> 
> OK, but a monolithic dm-writecache.c is no longer useful to me.  I can
> drop Arnd's gcc warning fix (with the idea that Ingo or Steve will take
> your __branch_check__ patch).  Not sure what the dm_bufio_client_create
> fix is... must've missed a report about that.
> 
> ANyway, point is we're on too a different phase of dm-writecache.c's
> development.  I've picked it up and am trying to get it ready for the
> 4.18 merge window (likely opening Sunday).  Therefore it needs to be in
> a git tree, and incremental changes overlayed.  I cannot be rebasing at
> this late stage in the 4.18 development window.
> 
> Thanks,
> Mike

I downloaded dm-writecache from your git repository some times ago - but 
you changed a lot of useless things (i.e. reordering the fields in the 
structure) since that time - so, you'll have to merge the changes.

You dropped the latency measuring code - why? We still would like to 
benchmark the driver.

Mikulas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
