Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED36921E1452B
 for <linux-nvdimm@lists.01.org>; Tue, 22 Aug 2017 02:33:54 -0700 (PDT)
Date: Tue, 22 Aug 2017 11:36:25 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 10/13] mm: Wire up MAP_SYNC
Message-ID: <20170822093625.GD4909@quack2.suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-11-jack@suse.cz>
 <20170821213704.GG26220@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170821213704.GG26220@linux.intel.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 21-08-17 15:37:04, Ross Zwisler wrote:
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index f19efcf75418..18453c04b09f 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1423,12 +1423,17 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
> >  				return -ENODEV;
> >  			if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
> >  				return -EINVAL;
> > +			if (!(vm_flags & VM_SHARED) && (vm_flags & VM_SYNC))
> > +				return -EINVAL;
> 
> I know this will be reworked with Dan's new mmap() interface, but I was
> curious what the !(vm_flags & VM_SHARED) check here was for.  We're in a
> MAP_PRIVATE case, so is it ever possible for VM_SHARED to be set in vm_flags?
> I tried to make this happen with some various test scenarios, but wasn't able.

I was also caught by this :). Check how MAP_SHARED case above falls through
to the MAP_PRIVATE case...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
