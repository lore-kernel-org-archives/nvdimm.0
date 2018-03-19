Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8D40B20954BA5
 for <linux-nvdimm@lists.01.org>; Mon, 19 Mar 2018 11:13:07 -0700 (PDT)
Date: Mon, 19 Mar 2018 11:19:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v6 12/15] xfs: require mmap lock for xfs_break_layouts()
Message-ID: <20180319181930.GH1757@magnolia>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152112914933.24669.5543317105428477772.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180319173345.GF1757@magnolia>
 <CAPcyv4hsLSR=eG8=yLtOhrOaUjqjV5S8pwwmP3oOLrknWQS6Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hsLSR=eG8=yLtOhrOaUjqjV5S8pwwmP3oOLrknWQS6Mg@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 19, 2018 at 10:57:55AM -0700, Dan Williams wrote:
> On Mon, Mar 19, 2018 at 10:33 AM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > On Thu, Mar 15, 2018 at 08:52:29AM -0700, Dan Williams wrote:
> >> In preparation for adding coordination between truncate operations and
> >> busy dax-pages, extend xfs_break_layouts() to assume it must be called
> >> with the mmap lock held. This locking scheme will be required for
> >> coordinating the break of 'dax layouts' (non-idle dax (ZONE_DEVICE)
> >> pages mapped into the file's address space).
> >
> > If I'm reading this right, you've added a requirement (for xfs anyway)
> > that we have to have grabbed MMAPLOCK_EXCL before calling break_layout()
> > so that the layout breaking process will block until active dmas have
> > finished.
> >
> > In 4.16 we added xfs_iolock_two_inodes_and_break_layout (in
> > xfs_reflink.c) to break pnfs leases for files that are about to be
> > reflinked (since pnfs and reflink aren't compatible either).  I think
> > that function will have to be adapted to take the appropriate mmap locks
> > too -- definitely the exclusive mmap lock for the destination file
> > because we anticipate punching out blocks.  I'm not sure about the
> > source file; I think taking the shared mmap lock is fine for that?
> 
> I don't see anything to adapt with respect to mmap locks since reflink
> and dax are mutually exclusive. The new lock coordination and layout
> breaking in xfs_break_dax_layouts() only applies to dax vs truncate,
> so xfs_iolock_two_inodes_and_break_layout() looks ok to me as is.

I was aiming for DAX + reflink someday working together.  :)

As far as that goes, I think the only thing we really have to do is
figure out how to make iomap_begin do the cow operation before letting
userspace write to (or MAP_SYNC a writable region) pmem, right?

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
