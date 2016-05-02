Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x230.google.com (mail-wm0-x230.google.com
 [IPv6:2a00:1450:400c:c09::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E376E1A1EDC
 for <linux-nvdimm@lists.01.org>; Mon,  2 May 2016 12:20:24 -0700 (PDT)
Received: by mail-wm0-x230.google.com with SMTP id e201so119333804wme.0
 for <linux-nvdimm@lists.01.org>; Mon, 02 May 2016 12:20:24 -0700 (PDT)
Message-ID: <5727A875.6010003@plexistor.com>
Date: Mon, 02 May 2016 22:20:21 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 0/3] Add alignment check for DAX mount
References: <1462214578-27122-1-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1462214578-27122-1-git-send-email-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>, dan.j.williams@intel.com, jack@suse.cz, david@fromorbit.com
Cc: tytso@mit.edu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, hch@infradead.org, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 05/02/2016 09:42 PM, Toshi Kani wrote:
> When a partition is not aligned by 4KB, mount -o dax succeeds,
> but any read/write access to the filesystem fails, except for
> metadata update.
> 
> Add alignment check to ext4, ext2, and xfs.
> 
> v2:
>  - Use a helper function via ->direct_access for the check.
>    (Christoph Hellwig)
>  - Call bdev_direct_access() with sector 0 for the check.
>    (Boaz Harrosh)
> 
> ---
> Toshi Kani (3):
>  1/3 ext4: Add alignment check for DAX mount
>  2/3 ext2: Add alignment check for DAX mount
>  3/3 xfs: Add alignment check for DAX mount
> 

All patches look very good to me, and keep the
internals internal. Thanks Toshi

Review-by: Boaz Harrosh <boaz@plexistor.com>

> ---
>  fs/ext2/super.c    | 21 +++++++++++++++++++--
>  fs/ext4/super.c    | 20 ++++++++++++++++++--
>  fs/xfs/xfs_super.c | 23 +++++++++++++++++++----
>  3 files changed, 56 insertions(+), 8 deletions(-)
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
