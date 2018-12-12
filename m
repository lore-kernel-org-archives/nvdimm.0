Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9FF1C2119C8B0
 for <linux-nvdimm@lists.01.org>; Wed, 12 Dec 2018 14:43:27 -0800 (PST)
Date: Wed, 12 Dec 2018 17:43:22 -0500
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Snapshot target and DAX-capable devices
Message-ID: <20181212224321.GA2902@redhat.com>
References: <20180830093028.GC1767@quack2.suse.cz>
 <20180830184907.GA14867@redhat.com>
 <x494lfbabwi.fsf@segfault.boston.devel.redhat.com>
 <alpine.LRH.2.02.1808301545200.30950@file01.intranet.prod.int.rdu2.redhat.com>
 <20180830233809.GH1572@dastard>
 <20180831094255.GB11622@quack2.suse.cz>
 <167a3303a01.11a848ab768799.5161498967766415143@zoho.com>
 <20181212161254.GA20790@infradead.org>
 <20181212175047.GA24962@redhat.com>
 <20181212211547.GA24926@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181212211547.GA24926@thunk.org>
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
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, chengnt <chengnt@lenovo.com>, Dave Chinner <david@fromorbit.com>, colyli <colyli@suse.de>, Christoph Hellwig <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 12 2018 at  4:15pm -0500,
Theodore Y. Ts'o <tytso@mit.edu> wrote:

> On Wed, Dec 12, 2018 at 12:50:47PM -0500, Mike Snitzer wrote:
> > On Wed, Dec 12 2018 at 11:12am -0500,
> > Christoph Hellwig <hch@infradead.org> wrote:
> > 
> > > Does it really make sense to enhance dm-snapshot?  I thought all serious
> > > users of snapshots had moved on to dm-thinp?
> > 
> > There are cases where dm-snapshot is still useful for people.  But those
> > are very niche users.  I'm not opposed to others proposing enhancements
> > for dm-snapshot in general but it is definitely not a priority (Google's
> > dm-bow is an example of a case where dm-snapshot may get extended to
> > fulfill google's needs).
> 
> I would expect that dm-snapshot will be used quite a lot for
> short-lived snapshots (that only live during a database backup or an
> fsck run).  I would hardly call that a "niche use case".

dm-snapshot is only ~60% performant for 1 snapshot.  Try to do
additional snapshots and performance crawls to a stop (though I haven't
reassessed performance in a while).

dm-snapshot has been in Linux since before 2005, I don't know of all the
users of it -- maybe there are a ton of users who only take a single
temporary snapshot and we're all oblivious.

Definitely not seeing many bugs against it (but it has been around
forever).  I do know that there are relatively few people showing
interest in it.  But for 4.21 I did stage a couple useful performance
fixes:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.21&id=61d594bb7e1cf86dca49cbc9524eb80169d9fca6
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.21&id=d1f7898c7a1b24aa9ae670f9cc21b65e730827eb

> One other major advantage that dm-snapshot has is that you can take a
> snapshot for any LVM volume.  For dm-thinp you have migrate your
> storage to a thinp pool, and that adds a fair amount of friction to
> users migrating to dm-thinp.

dm-thinp has the concept of an "external origin".  Changes to origin LVM
volume get copied out to the thin-pool (same copy cost as old
dm-snapshot).  But IIRC from that point on your LVM volume is a dm-thin
device.

Mike
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
