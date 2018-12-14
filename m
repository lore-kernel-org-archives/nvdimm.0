Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from imap.thunk.org (imap.thunk.org
 [IPv6:2600:3c02::f03c:91ff:fe96:be03])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0761A211A2DA1
 for <linux-nvdimm@lists.01.org>; Thu, 13 Dec 2018 20:11:23 -0800 (PST)
Date: Thu, 13 Dec 2018 23:11:18 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [dm-devel] Snapshot target and DAX-capable devices
Message-ID: <20181214041118.GE20880@thunk.org>
References: <20180830184907.GA14867@redhat.com>
 <x494lfbabwi.fsf@segfault.boston.devel.redhat.com>
 <alpine.LRH.2.02.1808301545200.30950@file01.intranet.prod.int.rdu2.redhat.com>
 <20180830233809.GH1572@dastard>
 <20180831094255.GB11622@quack2.suse.cz>
 <167a3303a01.11a848ab768799.5161498967766415143@zoho.com>
 <20181212161254.GA20790@infradead.org>
 <20181212175047.GA24962@redhat.com>
 <20181212211547.GA24926@thunk.org>
 <20181212224321.GA2902@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181212224321.GA2902@redhat.com>
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, chengnt <chengnt@lenovo.com>, Dave Chinner <david@fromorbit.com>, colyli <colyli@suse.de>, Christoph Hellwig <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 12, 2018 at 05:43:22PM -0500, Mike Snitzer wrote:
> > I would expect that dm-snapshot will be used quite a lot for
> > short-lived snapshots (that only live during a database backup or an
> > fsck run).  I would hardly call that a "niche use case".
> 
> dm-snapshot is only ~60% performant for 1 snapshot.  Try to do
> additional snapshots and performance crawls to a stop (though I haven't
> reassessed performance in a while).
> 
> dm-snapshot has been in Linux since before 2005, I don't know of all the
> users of it -- maybe there are a ton of users who only take a single
> temporary snapshot and we're all oblivious.

Well, here's one user:

https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git/tree/scrub/e2scrub.in

This is a spiffed up version of my original script:

https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git/tree/contrib/e2croncheck

I suppose we should look into enhancing e2scrub so it can deal with
volumes stored on dm-thin pools.....

> dm-thinp has the concept of an "external origin".  Changes to origin LVM
> volume get copied out to the thin-pool (same copy cost as old
> dm-snapshot).  But IIRC from that point on your LVM volume is a dm-thin
> device.

I would think the *snapshot* would have to be the dm-thin device, not
the origin volume, correct?

The original LVM module would still be mounted through the original
LVM device-mapper device, so it couldn't get transmogrified to be a
dm-thin device, right?

					- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
