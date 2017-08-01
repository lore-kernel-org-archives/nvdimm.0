Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7395D21D2DD0D
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 04:23:56 -0700 (PDT)
Date: Tue, 1 Aug 2017 13:26:03 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Message-ID: <20170801112603.GG4215@quack2.suse.cz>
References: <20170727131245.28279-1-jack@suse.cz>
 <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com>
 <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
 <20170728093821.GB29433@quack2.suse.cz>
 <20170801110241.GE6742@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170801110241.GE6742@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 01-08-17 04:02:41, Christoph Hellwig wrote:
> On Fri, Jul 28, 2017 at 11:38:21AM +0200, Jan Kara wrote:
> > Well, you are right I can make the implementation work with struct file
> > flag as well - let's call it O_DAXDSYNC. However there are filesystem
> > operations where you may need to answer question: Is there any fd with
> > O_DAXDSYNC open against this inode (for operations that change file offset
> > -> block mapping)? And in that case inode flag is straightforward while
> > file flag is a bit awkward (you need to implement counter of fd's with that
> > flag in the inode).
> 
> We can still keep and inode flag as the internal implementation
> detail.  As mentioned earlier the right flag to control behavior
> of a mapping is an mmap flag.  And the initial naive implementation
> would simply mark the inode as sync once the first MAP_SYNC open happens
> on it.  We could then move to more precise tracking if/when needed.

OK, makes sense and I like the MAP_SYNC proposal. I'll change it in my
implementation.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
