Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 367AE2095B9D8
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 00:13:53 -0700 (PDT)
Date: Thu, 24 Aug 2017 09:16:24 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 10/13] mm: Wire up MAP_SYNC
Message-ID: <20170824071624.GB20465@quack2.suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-11-jack@suse.cz>
 <20170823184349.GA12660@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170823184349.GA12660@infradead.org>
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
Cc: Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 23-08-17 11:43:49, Christoph Hellwig wrote:
> On Thu, Aug 17, 2017 at 06:08:12PM +0200, Jan Kara wrote:
> > Pretty crude for now...
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/file.c                  | 2 ++
> >  include/linux/mm.h              | 1 +
> >  include/linux/mman.h            | 3 ++-
> >  include/uapi/asm-generic/mman.h | 1 +
> >  mm/mmap.c                       | 5 +++++
> >  5 files changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index f84bb29e941e..850037e140d7 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -340,6 +340,8 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
> >  		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
> >  	} else {
> >  		vma->vm_ops = &ext4_file_vm_ops;
> > +		if (vma->vm_flags & VM_SYNC)
> > +			return -EOPNOTSUPP;
> >  	}
> 
> So each mmap instance would need to reject the flag explicitly?
> 
> Or do I misunderstand this VM_SYNC flag?

Yes, if this should be cleaned up, then each mmap instance not supporting
it would need to reject it. However Dan has in his version of mmap()
syscall a mask of supported flags so when I switch to that, it would be
just opt-in. Or I could just reject VM_SYNC for any !IS_DAX inode so then
only ext2 & xfs would need to reject it... But the biggest problem with
this patch is that we need to settle on a safe way of adding new mmap flag.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
