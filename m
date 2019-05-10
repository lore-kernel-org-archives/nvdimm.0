Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B8A421268FBA
 for <linux-nvdimm@lists.01.org>; Fri, 10 May 2019 08:59:55 -0700 (PDT)
Date: Fri, 10 May 2019 11:59:53 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1582528207.27988270.1557503993894.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAPcyv4jPF70QECzpgDCwzasJT38eOqG9tfQRbo37OWg+YzGu_w@mail.gmail.com>
References: <20190429172649.8288-13-rgoldwyn@suse.de>
 <20190510153222.24665-1-kilobyte@angband.pl>
 <CAPcyv4jPF70QECzpgDCwzasJT38eOqG9tfQRbo37OWg+YzGu_w@mail.gmail.com>
Subject: Re: [PATCH for-goldwyn] btrfs: disallow MAP_SYNC outside of DAX mounts
MIME-Version: 1.0
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
Cc: Adam Borowski <kilobyte@angband.pl>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, nborisov@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, dsterba@suse.cz, Matthew Wilcox <willy@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>


> >
> > Even if allocation is done synchronously, data would be lost except on
> > actual pmem.  Explicit msync()s don't need MAP_SYNC, and don't require
> > a sync per page.
> >
> > Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> > ---
> > MAP_SYNC can't be allowed unconditionally, as cacheline flushes don't help
> > guarantee persistency in page cache.  This fixes an error in my earlier
> > patch "btrfs: allow MAP_SYNC mmap" -- you'd probably want to amend that.
> >
> >
> >  fs/btrfs/file.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index 362a9cf9dcb2..0bc5428037ba 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > @@ -2233,6 +2233,13 @@ static int btrfs_file_mmap(struct file   *filp,
> > struct vm_area_struct *vma)
> >         if (!IS_DAX(inode) && !mapping->a_ops->readpage)
> >                 return -ENOEXEC;
> >
> > +       /*
> > +        * Normal operation of btrfs is pretty much an antithesis of
> > MAP_SYNC;
> > +        * supporting it outside DAX is pointless.
> > +        */
> > +       if (!IS_DAX(inode) && (vma->vm_flags & VM_SYNC))
> > +               return -EOPNOTSUPP;
> > +
> 
> If the virtio-pmem patch set goes upstream prior to btrfs-dax support
> this will need to switch over to the new daxdev_mapping_supported()
> helper.

I was planning to do changes for virtio pmem & BTRFS. I was waiting for 
DAX support for BTRFS to merge upstream.

Thank you,
Pankaj 
 
> 
> https://lore.kernel.org/lkml/20190426050039.17460-5-pagupta@redhat.com/
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
