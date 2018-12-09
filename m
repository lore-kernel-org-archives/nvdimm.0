Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 602CD21196812
 for <linux-nvdimm@lists.01.org>; Sun,  9 Dec 2018 11:49:52 -0800 (PST)
Date: Sun, 9 Dec 2018 11:49:46 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [GIT PULL] dax fixes for 4.20-rc6
Message-ID: <20181209194946.GA6830@bombadil.infradead.org>
References: <6be0835bf256755375f3b5822bf70d74538d1d6e.camel@intel.com>
 <CAHk-=wgAONwr6pMn+D2OsMZjAB5zNaMWSW5KdTM+L72gGnhV2Q@mail.gmail.com>
 <CAPcyv4jznHRB=BCsm8Y3d-uqDy_OWHSgTsPZoPK-L80FiQftFg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jznHRB=BCsm8Y3d-uqDy_OWHSgTsPZoPK-L80FiQftFg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Dec 09, 2018 at 10:26:54AM -0800, Dan Williams wrote:
> [ add Willy and Jan ]
> 
> On Sun, Dec 9, 2018 at 10:02 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Sat, Dec 8, 2018 at 10:26 PM Williams, Dan J
> > <dan.j.williams@intel.com> wrote:
> > >
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-fixes-4.20-rc6
> >
> > What's going on with the odd non-exclusive exclusive wait?
> >
> >         prepare_to_wait_exclusive(wq, &ewait.wait, TASK_UNINTERRUPTIBLE);
> >         ...
> >         /*
> >          * Entry lock waits are exclusive. Wake up the next waiter since
> >          * we aren't sure we will acquire the entry lock and thus wake
> >          * the next waiter up on unlock.
> >          */
> >         if (waitqueue_active(wq))
> >                 __wake_up(wq, TASK_NORMAL, 1, &ewait.key);
> >
> > that seems to make little or no sense.
> >
> > Why isn't that prepare_to_wait_exclusive() just a regular
> > prepare_to_wait(), and then the whole "let's wake up anybody else" can
> > be removed?
> >
> > I've pulled it, but am awaiting explanation of what looks like some
> > pretty crazy code. I *suspect* it's a copy-and-paste situation where
> > you took the exclusive wait from somewhere else.
> 
> Yes, I believe that's true. In the other instances of waiting for an
> entry to be in unlocked there is a guarantee that the waiter will
> attain the lock and perform an unlock + wakeup. In the dax_lock_page()
> path there is the possibility that the inode dies before the lock is
> attained and a subsequent unlock sequence is not guaranteed. So, I
> believe the intent, Willy correct me if I am wrong, was to keep all
> waits "exclusive" for some sense of symmetry, but this one can and
> should be a non-exclusive wait.

I did indeed just copy it from elsewhere.  As I said at the time,

"This is the best I've come up with.  Could we do better by not using
the _exclusive form of prepare_to_wait()?  I'm not familiar with all the
things that need to be considered when using this family of interfaces."

but nobody suggested what the right way to use these interfaces was.

https://lists.01.org/pipermail/linux-nvdimm/2018-November/018892.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
