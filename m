Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vk0-x22c.google.com (mail-vk0-x22c.google.com
 [IPv6:2607:f8b0:400c:c05::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0089021D491AD
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 16:41:37 -0700 (PDT)
Received: by mail-vk0-x22c.google.com with SMTP id u133so11063486vke.3
 for <linux-nvdimm@lists.01.org>; Fri, 04 Aug 2017 16:43:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170804233140.GF21024@dastard>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150181369754.32119.7390149918955188408.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170804233140.GF21024@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 4 Aug 2017 16:43:50 -0700
Message-ID: <CAPcyv4iHjLag-YRO3kgHMzED1vpLh28Lo+JZULAeRtiq8QGP+g@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] fs, xfs: introduce FALLOC_FL_SEAL_BLOCK_MAP
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 4, 2017 at 4:31 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Aug 03, 2017 at 07:28:17PM -0700, Dan Williams wrote:
>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>> index fe0f8f7f4bb7..46d8eb9e19fc 100644
>> --- a/fs/xfs/xfs_bmap_util.c
>> +++ b/fs/xfs/xfs_bmap_util.c
>> @@ -1393,6 +1393,107 @@ xfs_zero_file_space(
>>
>>  }
>>
>> +/* Return 1 if hole detected, 0 if not, and < 0 if fail to determine */
>> +STATIC int
>> +xfs_file_has_holes(
>> +     struct xfs_inode        *ip)
>> +{
>
> Why do we need this function?
>
> We've just run xfs_alloc_file_space() across the entire range we
> are sealing, so we've already guaranteed that it won't have holes
> in it.

I'm sure this is due to my ignorance of the scope of XFS_IOLOCK_EXCL
vs XFS_ILOCK_EXCL. I had assumed that since we drop and retake
XFS_ILOCK_EXCL that we need to re-validate the block map before
setting S_IOMAP_IMMUTABLE.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
