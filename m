Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8776020945612
 for <linux-nvdimm@lists.01.org>; Thu,  7 Sep 2017 14:10:22 -0700 (PDT)
Date: Thu, 7 Sep 2017 15:13:03 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
Message-ID: <20170907211303.GA23212@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
 <20170906170754.GB17663@linux.intel.com>
 <CAPcyv4hfhDT9NFRXL+MT5epiqWHJ0RLraV4P3CZ4EJM6L-s0Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hfhDT9NFRXL+MT5epiqWHJ0RLraV4P3CZ4EJM6L-s0Nw@mail.gmail.com>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Lukas Czerner <lczerner@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 07, 2017 at 01:54:45PM -0700, Dan Williams wrote:
> On Wed, Sep 6, 2017 at 10:07 AM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > On Tue, Sep 05, 2017 at 09:12:35PM -0500, Eric Sandeen wrote:
> >> On 9/5/17 5:35 PM, Ross Zwisler wrote:
> >> > The original intent of this series was to add a per-inode DAX flag to ext4
> >> > so that it would be consistent with XFS.  In my travels I found and fixed
> >> > several related issues in both ext4 and XFS.
> >>
> >> Hi Ross -
> >>
> >> hch had a lot of reasons to nuke the dax flag from orbit, and we just
> >> /disabled/ it in xfs due to its habit of crashing the kernel...
> >
> > Ah, sorry, I wasn't CC'd on those threads and missed them.  For any interested
> > bystanders:
> >
> > https://www.spinics.net/lists/linux-ext4/msg57840.html
> > https://www.spinics.net/lists/linux-xfs/msg09831.html
> > https://www.spinics.net/lists/linux-xfs/msg10124.html
> >
> >> so a couple questions:
> >>
> >> 1) does this series pass hch's "test the per-inode DAX flag" fstest?
> >
> > Nope, it has the exact same problems as the XFS per-inode DAX flag.
> >
> >> 2) do we have an agreement that we need this flag at all, or is this
> >>    just a parity item because xfs has^whad a per-inode flag?
> >
> > It was for parity, and because it allows admins finer grained control over
> > their system.  Basically all things discussed in response to Lukas's original
> > patch in the first link above.
> 
> I think it's more than parity. When pmem is slower than page cache it
> is actively harmful to have DAX enabled globally for a filesystem. So,
> not only should we push for per-inode DAX control, we should also push
> to deprecate the mount option. I agree with Christoph that we should
> try to automatically and transparently enable DAX where it makes
> sense, but we also need a finer-grained mechanism than a mount flag to
> force the behavior one way or the other.

Yep, agreed.  I'll play with how to make this work after I've sorted out all
the data corruptions I've found. :)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
