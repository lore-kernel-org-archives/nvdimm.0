Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 12 Dec 2018 16:15:47 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: Snapshot target and DAX-capable devices
Message-ID: <20181212211547.GA24926@thunk.org>
References: <20180828175630.GA1197@redhat.com>
 <20180830093028.GC1767@quack2.suse.cz>
 <20180830184907.GA14867@redhat.com>
 <x494lfbabwi.fsf@segfault.boston.devel.redhat.com>
 <alpine.LRH.2.02.1808301545200.30950@file01.intranet.prod.int.rdu2.redhat.com>
 <20180830233809.GH1572@dastard>
 <20180831094255.GB11622@quack2.suse.cz>
 <167a3303a01.11a848ab768799.5161498967766415143@zoho.com>
 <20181212161254.GA20790@infradead.org>
 <20181212175047.GA24962@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181212175047.GA24962@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Huaisheng Ye <yehs2007@zoho.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, chengnt <chengnt@lenovo.com>, yehs1 <yehs1@lenovo.com>, colyli <colyli@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 12, 2018 at 12:50:47PM -0500, Mike Snitzer wrote:
> On Wed, Dec 12 2018 at 11:12am -0500,
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > Does it really make sense to enhance dm-snapshot?  I thought all serious
> > users of snapshots had moved on to dm-thinp?
> 
> There are cases where dm-snapshot is still useful for people.  But those
> are very niche users.  I'm not opposed to others proposing enhancements
> for dm-snapshot in general but it is definitely not a priority (Google's
> dm-bow is an example of a case where dm-snapshot may get extended to
> fulfill google's needs).

I would expect that dm-snapshot will be used quite a lot for
short-lived snapshots (that only live during a database backup or an
fsck run).  I would hardly call that a "niche use case".  One other
major advantage that dm-snapshot has is that you can take a snapshot
for any LVM volume.  For dm-thinp you have migrate your storage to a
thinp pool, and that adds a fair amount of friction to users migrating
to dm-thinp.

						- Ted
