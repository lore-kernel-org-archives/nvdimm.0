Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7012421E87985
 for <linux-nvdimm@lists.01.org>; Mon, 11 Sep 2017 01:44:43 -0700 (PDT)
Date: Mon, 11 Sep 2017 10:47:33 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
Message-ID: <20170911084733.GB7120@quack2.suse.cz>
References: <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
 <20170906170754.GB17663@linux.intel.com>
 <CAPcyv4hfhDT9NFRXL+MT5epiqWHJ0RLraV4P3CZ4EJM6L-s0Nw@mail.gmail.com>
 <20170907211303.GA23212@linux.intel.com>
 <5F58D3F5-D93B-4648-AE01-8A46956FBB4B@dilger.ca>
 <20170907215148.GA12669@linux.intel.com>
 <20170907221201.GZ17782@dastard>
 <20170907221900.GB12669@linux.intel.com>
 <20170907232543.GB17782@dastard>
 <20170908153913.jjhzogjs5zpeea5v@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170908153913.jjhzogjs5zpeea5v@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, Lukas Czerner <lczerner@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 08-09-17 11:39:13, Ted Tso wrote:
> On Fri, Sep 08, 2017 at 09:25:43AM +1000, Dave Chinner wrote:
> > > Okay, so other ideas (which you have also probably already though of) include:
> > > 
> > > 1) Just return -EBUSY if anyone tries to change the DAX flag of an inode with
> > > open mappings or any open file handles.
> > 
> > You have to have an open fd to change the flag. :)
> 
> What if we only allow the S_DAX flag to be *set*, when i_size and
> i_blocks is zero?  We could also require that only one file descriptor
> be open against the inode, and that it be opened O_RDONLY.

We could do something like that but IMHO it will be a pain to use (e.g.
think how difficult it would be to switch your existing database to use DAX
for data files). We can make transition reliable whenever
inode->i_mapping->i_mmap RB tree is empty (effectively: whenever the file
is not mmaped). And that should be relaxed enough for most usecases... But
I agree that it will be somewhat tricky to prevent creation of new mappings
while we are switching S_DAX flag so it needs more though.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
