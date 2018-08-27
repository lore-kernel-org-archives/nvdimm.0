Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D112202E5442
 for <linux-nvdimm@lists.01.org>; Mon, 27 Aug 2018 09:09:06 -0700 (PDT)
Date: Mon, 27 Aug 2018 18:09:03 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 1/2] dax: dax_layout_busy_page() warn on !exceptional
Message-ID: <20180827160903.GF4002@quack2.suse.cz>
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
 <20180710191031.17919-2-ross.zwisler@linux.intel.com>
 <6ca60cf6-f1dc-27d5-fb79-7547aea39dfa@redhat.com>
 <20180810203349.GH627@thunk.org> <20180811021053.GB14368@thunk.org>
 <20180813101252.GC8927@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180813101252.GC8927@quack2.suse.cz>
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
Cc: sandeen@redhat.com, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 13-08-18 12:12:52, Jan Kara wrote:
> On Fri 10-08-18 22:10:53, Theodore Y. Ts'o wrote:
> > On Fri, Aug 10, 2018 at 04:33:49PM -0400, Theodore Y. Ts'o wrote:
> > > I just kicked off a DAX test ("gce-xfstests -c dax -g auto") with
> > > CONFIG_KASAN disabled, and I expect it shouldn't show up anything
> > > concerning.  So assuming nothing surprising pops up, yes it should be
> > > merged at the next merge window.
> > 
> > ... and here are the results.  The first is 4.17, and the second is
> > the ext4 git tree:
> > 
> > ext4/dax: 488 tests, 4 failures, 97 skipped, 2647 seconds
> >   Failures: ext4/033 generic/344 generic/491 generic/503
> > 
> > ext4/dax: 488 tests, 3 failures, 97 skipped, 2637 seconds
> >   Failures: generic/081 generic/344 generic/388
> > 
> > The generic/388 failure is a known flake (shutdown stress test).
> > 
> > The generic/081 regression appears to be a device-mapper issue:
> > 
> > generic/081		[22:06:33][   15.079661] run fstests generic/081 at 2018-08-10 22:06:33
> > [   15.795745] device-mapper: ioctl: can't change device type (old=4 vs new=1) after initial table load.
> > [failed, exit status 1] [22:06:36]- output mismatch (see /results/ext4/results-dax/generic/081.out.bad)
> >     --- tests/generic/081.out	2018-08-09 18:00:42.000000000 -0400
> >     +++ /results/ext4/results-dax/generic/081.out.bad	2018-08-10 22:06:36.440005460 -0400
> >     @@ -1,2 +1,4 @@
> >      QA output created by 081
> >      Silence is golden
> >     +Failed to create snapshot
> >     +(see /results/ext4/results-dax/generic/081.full for details)
> >     ...
> >     (Run 'diff -u tests/generic/081.out /results/ext4/results-dax/generic/081.out.bad'  to see the entire diff)
> 
> I'll see if this reproduces for me. Doesn't seem to be related to the DAX
> patches you caary though.

This is caused by commit dbc626597c39b "dm: prevent DAX mounts if not
supported". I've started discussion with relevant developers how to fix
this.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
