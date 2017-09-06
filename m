Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 908C22095AE54
 for <linux-nvdimm@lists.01.org>; Wed,  6 Sep 2017 10:05:11 -0700 (PDT)
Date: Wed, 6 Sep 2017 11:07:54 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
Message-ID: <20170906170754.GB17663@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
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
To: sandeen@redhat.com, Lukas Czerner <lczerner@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 05, 2017 at 09:12:35PM -0500, Eric Sandeen wrote:
> On 9/5/17 5:35 PM, Ross Zwisler wrote:
> > The original intent of this series was to add a per-inode DAX flag to ext4
> > so that it would be consistent with XFS.  In my travels I found and fixed
> > several related issues in both ext4 and XFS.
> 
> Hi Ross -
> 
> hch had a lot of reasons to nuke the dax flag from orbit, and we just
> /disabled/ it in xfs due to its habit of crashing the kernel...

Ah, sorry, I wasn't CC'd on those threads and missed them.  For any interested
bystanders:

https://www.spinics.net/lists/linux-ext4/msg57840.html
https://www.spinics.net/lists/linux-xfs/msg09831.html
https://www.spinics.net/lists/linux-xfs/msg10124.html

> so a couple questions:
> 
> 1) does this series pass hch's "test the per-inode DAX flag" fstest?

Nope, it has the exact same problems as the XFS per-inode DAX flag.

> 2) do we have an agreement that we need this flag at all, or is this
>    just a parity item because xfs has^whad a per-inode flag?

It was for parity, and because it allows admins finer grained control over
their system.  Basically all things discussed in response to Lukas's original
patch in the first link above.

The way this series ended up the first 8 patches were all fixes for the
existing code, and only patch 9 introduced the new per-inode flag.  I'll drop
patch 9 for now and rework the first 8 patches so we can get safer behavior of
the existing DAX mount option in ext4.  We can try patch 9 again later if we
come to an agreement that re-enables the XFS per-inode DAX option.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
