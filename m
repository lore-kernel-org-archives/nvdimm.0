Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A2A3221DF9699
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 14:55:10 -0700 (PDT)
Date: Thu, 27 Jul 2017 15:57:13 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Message-ID: <20170727215713.GA22000@linux.intel.com>
References: <20170727131245.28279-1-jack@suse.cz>
 <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 27, 2017 at 10:09:07AM -0400, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> Hi, Jan,
> 
> Thanks for looking into this!
> 
> > There are couple of open questions with this implementation:
> >
> > 1) Is it worth the hassle?
> > 2) Is S_SYNC good flag to use or should we use a new inode flag?
> > 3) VM_FAULT_RO and especially passing of resulting 'pfn' from
> >    dax_iomap_fault() through filesystem fault handler to dax_pfn_mkwrite() in
> >    vmf->orig_pte is a bit of a hack. So far I'm not sure how to refactor
> >    things to make this cleaner.
> 
> 4) How does an application discover that it is safe to flush from
>    userspace?

I think that we would be best off with a new flag available via
lsattr(1)/chattr(1).  This would have the following advantages:

1) We could only set the flag if the inode supported DAX (either via the mount
option or via the individual DAX flag).  This would give NVML et al. one
central way to detect whether it was safe to flush from userspace because the
FS supported synchronous faults.

2) Defining a new flag prevents any confusion about whether the kernel version
you have supports sync faults.  Otherwise NVML would have to do something like
look at the trio of (kernel version, S_SYNC flag, mount/inode option for DAX)
which is complex and of course breaks for OS kernel versions.

3) Defining the flag in a generic way via lsattr/chattr opens the door for the
same API and flag to be used by other filesystems in the future.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
