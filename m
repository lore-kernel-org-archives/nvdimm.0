Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id E07B11A1F5E
 for <linux-nvdimm@lists.01.org>; Fri, 29 Apr 2016 16:12:20 -0700 (PDT)
Date: Fri, 29 Apr 2016 17:12:19 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/3] Add alignment check for DAX mount
Message-ID: <20160429231219.GB20913@linux.intel.com>
References: <1461962375-3720-1-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461962375-3720-1-git-send-email-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org, tytso@mit.edu
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 29, 2016 at 02:39:32PM -0600, Toshi Kani wrote:
> When a partition is not aligned by 4KB, mount -o dax succeeds,
> but any read/write access to the filesystem fails, except for
> metadata update.
> 
> Add alignment check to ext4, ext2, and xfs.
> 
> ---
> Toshi Kani (3):
>  1/3 ext4: Add alignment check for DAX mount
>  2/3 ext2: Add alignment check for DAX mount
>  3/3 xfs: Add alignment check for DAX mount
> 
> ---
>  fs/ext2/super.c    | 6 ++++++
>  fs/ext4/super.c    | 6 ++++++
>  fs/xfs/xfs_super.c | 6 ++++++
>  3 files changed, 18 insertions(+)

For the series:
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
