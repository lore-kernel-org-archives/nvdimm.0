Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from imap.thunk.org (imap.thunk.org
 [IPv6:2600:3c02::f03c:91ff:fe96:be03])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 408AD20945BFC
 for <linux-nvdimm@lists.01.org>; Fri,  8 Sep 2017 08:36:30 -0700 (PDT)
Date: Fri, 8 Sep 2017 11:39:13 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
Message-ID: <20170908153913.jjhzogjs5zpeea5v@thunk.org>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
 <20170906170754.GB17663@linux.intel.com>
 <CAPcyv4hfhDT9NFRXL+MT5epiqWHJ0RLraV4P3CZ4EJM6L-s0Nw@mail.gmail.com>
 <20170907211303.GA23212@linux.intel.com>
 <5F58D3F5-D93B-4648-AE01-8A46956FBB4B@dilger.ca>
 <20170907215148.GA12669@linux.intel.com>
 <20170907221201.GZ17782@dastard>
 <20170907221900.GB12669@linux.intel.com>
 <20170907232543.GB17782@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170907232543.GB17782@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, Lukas Czerner <lczerner@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 08, 2017 at 09:25:43AM +1000, Dave Chinner wrote:
> > Okay, so other ideas (which you have also probably already though of) include:
> > 
> > 1) Just return -EBUSY if anyone tries to change the DAX flag of an inode with
> > open mappings or any open file handles.
> 
> You have to have an open fd to change the flag. :)

What if we only allow the S_DAX flag to be *set*, when i_size and
i_blocks is zero?  We could also require that only one file descriptor
be open against the inode, and that it be opened O_RDONLY.

						- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
