Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 4 Nov 2016 08:16:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v9 00/16] re-enable DAX PMD support
Message-ID: <20161103211646.GB28177@dastard>
References: <1478030058-1422-1-git-send-email-ross.zwisler@linux.intel.com>
 <20161103015826.GI9920@dastard>
 <20161103175102.GA11784@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161103175102.GA11784@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 03, 2016 at 11:51:02AM -0600, Ross Zwisler wrote:
> On Thu, Nov 03, 2016 at 12:58:26PM +1100, Dave Chinner wrote:
> > On Tue, Nov 01, 2016 at 01:54:02PM -0600, Ross Zwisler wrote:
> > > DAX PMDs have been disabled since Jan Kara introduced DAX radix tree based
> > > locking.  This series allows DAX PMDs to participate in the DAX radix tree
> > > based locking scheme so that they can be re-enabled.
> > 
> > I've seen patch 0/16 - where did you send the other 16? I need to
> > pick up the bug fix that is in this patch set...
> 
> I CC'd your "david@fromorbit.com" address on the entire set, as well as all
> the usual lists (linux-xfs, linux-fsdevel, linux-nvdimm, etc).

Ok, now I'm /really/ confused. Procmail logs show:

>From ross.zwisler@linux.intel.com Wed Nov 02 06:56:46 2016
Subject: [PATCH v9 00/16] re-enable DAX PMD support
Folder: incoming/xfs-linux/new/1478030206.9177_1.dastard 5348
>From ross.zwisler@linux.intel.com Wed Nov 02 06:56:48 2016
Subject: [PATCH v9 01/16] ext4: tell DAX the size of allocation holes
Folder: incoming/xfs-linux/new/1478030208.9182_1.dastard 3725
>From ross.zwisler@linux.intel.com Wed Nov 02 06:56:49 2016
Subject: [PATCH v9 02/16] dax: remove buffer_size_valid()
Folder: incoming/xfs-linux/new/1478030209.9187_1.dastard 4692
.....

so procmail has seen them, and put them all in the same bucket like
it has for everything else.

But only patch 0 appeared in my linux-xfs mail box - the rest of the
files logged by procmail don't exist. No errors or indications of
failures anywhere. They've just vanished into thin air...

> They are also available via the libnvdimm patchwork:
> 
> https://patchwork.kernel.org/project/linux-nvdimm/list/
> 
> or via my tree:
> 
> https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=dax_pmd_v9
> 
> The only patch that is different between v8 and v9 is:
> [PATCH v9 14/16] dax: add struct iomap based DAX PMD support

OK, thanks, I'll pull it in.

> 
> > > Previously we had talked about this series going through the XFS tree, but
> > > Jan has a patch set that will need to build on this series and it heavily
> > > modifies the MM code.  I think he would prefer that series to go through
> > > Andrew Morton's -MM tree, so it probably makes sense for this series to go
> > > through that same tree.
> > 
> > Seriously, I was 10 minutes away from pushing out the previous
> > version of this patchset as a stable topic branch, just like has
> > been discussed and several times over the past week.  Indeed, I
> > mentioned that I was planning on pushing out this topic branch today
> > not more than 4 hours ago, and you were on the cc list.
> 
> I'm confused - I sent v9 of this series out 2 days ago, on Tuesday?
> I have seen multiple messages from you this week saying you were going to pick
> this series up, but I saw them all after I had already sent this series out.

That's what I'm really confused - I replied immediately after this
email appeared in my in-box - I was working from v8 because I didn't
know this version existed. This v9 patch zero email hit procmail on
"Wed Nov 02 06:56:46 2016" and i replied immediately when i saw it:
"On Thu, Nov 03, 2016 at 12:58:26PM +1100,"

So there's some 30 hours between it passing through procmail and
mutt adding it to my inbox. And mutt hasn't see any of the other
emails in the thread.

/me sighs and wonders how much other email has been going missing
lately....

> Sorry for the confusion,

Clearly not your fault, Ross.

> I was just trying to figure out a way that Jan's
> changes could also be merged.  Please do pick up v9 of my PMD set. :)

Will do, but I've got to find my way out of WTF-Landia first...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
