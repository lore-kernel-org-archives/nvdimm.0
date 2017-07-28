Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3C2F321E2570E
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jul 2017 02:36:19 -0700 (PDT)
Date: Fri, 28 Jul 2017 11:38:21 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Message-ID: <20170728093821.GB29433@quack2.suse.cz>
References: <20170727131245.28279-1-jack@suse.cz>
 <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com>
 <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
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
To: Andy Lutomirski <luto@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 27-07-17 19:05:24, Andy Lutomirski wrote:
> On Thu, Jul 27, 2017 at 2:57 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > On Thu, Jul 27, 2017 at 10:09:07AM -0400, Jeff Moyer wrote:
> >> Jan Kara <jack@suse.cz> writes:
> >>
> >> Hi, Jan,
> >>
> >> Thanks for looking into this!
> >>
> >> > There are couple of open questions with this implementation:
> >> >
> >> > 1) Is it worth the hassle?
> >> > 2) Is S_SYNC good flag to use or should we use a new inode flag?
> >> > 3) VM_FAULT_RO and especially passing of resulting 'pfn' from
> >> >    dax_iomap_fault() through filesystem fault handler to dax_pfn_mkwrite() in
> >> >    vmf->orig_pte is a bit of a hack. So far I'm not sure how to refactor
> >> >    things to make this cleaner.
> >>
> >> 4) How does an application discover that it is safe to flush from
> >>    userspace?
> >
> > I think that we would be best off with a new flag available via
> > lsattr(1)/chattr(1).  This would have the following advantages:
> >
> > 1) We could only set the flag if the inode supported DAX (either via the mount
> > option or via the individual DAX flag).  This would give NVML et al. one
> > central way to detect whether it was safe to flush from userspace because the
> > FS supported synchronous faults.
> >
> > 2) Defining a new flag prevents any confusion about whether the kernel version
> > you have supports sync faults.  Otherwise NVML would have to do something like
> > look at the trio of (kernel version, S_SYNC flag, mount/inode option for DAX)
> > which is complex and of course breaks for OS kernel versions.
> >
> > 3) Defining the flag in a generic way via lsattr/chattr opens the door for the
> > same API and flag to be used by other filesystems in the future.
> 
> I would advocate using a new fcntl() instead of lsattr for the
> following reason: ISTM the fact that it's an *inode* flag in this
> patchset is a bit of an implementation detail.  I can easily imagine a
> future implementation that makes it per-struct-file instead.  A
> fcntl() that asks "can I flush from userspace" would still work under
> than scenario.

Well, you are right I can make the implementation work with struct file
flag as well - let's call it O_DAXDSYNC. However there are filesystem
operations where you may need to answer question: Is there any fd with
O_DAXDSYNC open against this inode (for operations that change file offset
-> block mapping)? And in that case inode flag is straightforward while
file flag is a bit awkward (you need to implement counter of fd's with that
flag in the inode).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
