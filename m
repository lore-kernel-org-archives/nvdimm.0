Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 025012095BB66
 for <linux-nvdimm@lists.01.org>; Tue,  5 Sep 2017 19:09:49 -0700 (PDT)
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
From: Eric Sandeen <esandeen@redhat.com>
Message-ID: <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
Date: Tue, 5 Sep 2017 21:12:35 -0500
MIME-Version: 1.0
In-Reply-To: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: sandeen@redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On 9/5/17 5:35 PM, Ross Zwisler wrote:
> The original intent of this series was to add a per-inode DAX flag to ext4
> so that it would be consistent with XFS.  In my travels I found and fixed
> several related issues in both ext4 and XFS.

Hi Ross -

hch had a lot of reasons to nuke the dax flag from orbit, and we just
/disabled/ it in xfs due to its habit of crashing the kernel...
so a couple questions:

1) does this series pass hch's "test the per-inode DAX flag" fstest?
2) do we have an agreement that we need this flag at all, or is this
   just a parity item because xfs has^whad a per-inode flag?

Thanks,
-Eric

> I'm not fully happy with the ways that ext4 DAX interacts with conflicting
> features (journaling, inline data and encryption).  My goal with this
> series was to make all these interactions as consistent as possilble, and
> of course to make them safe.  If anyone has ideas for improvements, I'm
> very open.
> 
> Ross Zwisler (9):
>   ext4: remove duplicate extended attributes defs
>   xfs: always use DAX if mount option is used
>   xfs: validate bdev support for DAX inode flag
>   ext4: add ext4_should_use_dax()
>   ext4: ext4_change_inode_journal_flag error handling
>   ext4: safely transition S_DAX on journaling changes
>   ext4: prevent data corruption with inline data + DAX
>   ext4: add sanity check for encryption + DAX
>   ext4: add per-inode DAX flag
> 
>  fs/ext4/ext4.h      | 47 ++++++---------------------------------------
>  fs/ext4/ext4_jbd2.h | 16 ++++++++++++++++
>  fs/ext4/inline.c    | 10 ----------
>  fs/ext4/inode.c     | 45 ++++++++++++++++++++++++-------------------
>  fs/ext4/ioctl.c     | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/ext4/super.c     |  8 ++++++++
>  fs/xfs/xfs_ioctl.c  | 14 +++++++++++---
>  7 files changed, 119 insertions(+), 76 deletions(-)
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
