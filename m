Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 11D2C1A1DF6
 for <linux-nvdimm@lists.01.org>; Wed, 17 Aug 2016 10:21:14 -0700 (PDT)
Date: Wed, 17 Aug 2016 19:21:11 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/7] re-enable DAX PMD support
Message-ID: <20160817172111.GA30584@quack2.suse.cz>
References: <20160815190918.20672-1-ross.zwisler@linux.intel.com>
 <CAPcyv4j_eh8Rcozb40JeiPwvbPoMY2sCt+yTewZ-MZzUkBbj-Q@mail.gmail.com>
 <20160815211106.GA31566@linux.intel.com>
 <CAPcyv4i+XHZSN_3T_vcrv+sOkEMQzuTKRo4WBFcPxN=TzSk9iw@mail.gmail.com>
 <20160817162124.GA16779@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160817162124.GA16779@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 17-08-16 10:21:24, Ross Zwisler wrote:
> On Mon, Aug 15, 2016 at 02:14:14PM -0700, Dan Williams wrote:
> > On Mon, Aug 15, 2016 at 2:11 PM, Ross Zwisler
> > <ross.zwisler@linux.intel.com> wrote:
> > > On Mon, Aug 15, 2016 at 01:21:47PM -0700, Dan Williams wrote:
> > >> On Mon, Aug 15, 2016 at 12:09 PM, Ross Zwisler
> > >> <ross.zwisler@linux.intel.com> wrote:
> > >> > DAX PMDs have been disabled since Jan Kara introduced DAX radix tree based
> > >> > locking.  This series allows DAX PMDs to participate in the DAX radix tree
> > >> > based locking scheme so that they can be re-enabled.
> > >>
> > >> Looks good to me.
> > >>
> > >> > This series restores DAX PMD functionality back to what it was before it
> > >> > was disabled.  There is still a known issue between DAX PMDs and hole
> > >> > punch, which I am currently working on and which I plan to address with a
> > >> > separate series.
> > >>
> > >> Perhaps we should hold off on applying patch 6 and 7 until after the
> > >> hole-punch fix is ready?
> > >
> > > Sure, I'm cool with holding off on patch 7 (the Kconfig change) until after
> > > the hole punch fix is ready.
> > >
> > > I don't see a reason to hold off on patch 6, though?  It stands on it's own,
> > > implements the correct locking, and doesn't break anything.
> > 
> > Whoops, I just meant 7.
> 
> Well, it looks like the hole punch case is much improved since I tested it
> last!  :)  I used to be able to generate a few different kernel BUGs when hole
> punching DAX PMDs, but those have apparently been fixed in the mm layer since
> I was last testing, which admittedly was quite a long time ago (February?).
> 
> The only issue I was able to find with DAX PMD hole punching was that ext4
> wasn't properly doing a writeback before the hole was unmapped and the radix
> tree entries were removed.  This issue applies equally to the 4k case, so I've
> submitted a bug fix for v4.8:
> 
> https://lists.01.org/pipermail/linux-nvdimm/2016-August/006621.html
> 
> With that applied, I don't know of any more issues related to DAX PMDs and
> hole punch.  I've tested ext4 and XFS (ext2 doesn't support hole punch), and
> they both properly do a writeback of all affected PMDs, fully unmap all
> affected PMDs, and remove the radix tree entries.  I've tested that new page
> faults for addresses previously covered by the old PMDs generate new page
> faults, and 4k pages are now faulted in because the block allocator no longer
> has 2MiB contiguous allocations.
> 
> One question (probably for Jan): should the above ext4 fix be marked for
> stable?

Yes, probably it should be.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
