Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C550C1A1EDF
 for <linux-nvdimm@lists.01.org>; Mon,  9 May 2016 01:31:29 -0700 (PDT)
Date: Mon, 9 May 2016 10:31:25 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 4/5] ext2: Add alignment check for DAX mount
Message-ID: <20160509083125.GC11897@quack2.suse.cz>
References: <1462494596-20938-1-git-send-email-toshi.kani@hpe.com>
 <1462494596-20938-5-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462494596-20938-5-git-send-email-toshi.kani@hpe.com>
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
Cc: hch@infradead.org, jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, axboe@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, tytso@mit.edu
List-ID: <linux-nvdimm@lists.01.org>

On Thu 05-05-16 18:29:55, Toshi Kani wrote:
> When a partition is not aligned by 4KB, mount -o dax succeeds,
> but any read/write access to the filesystem fails, except for
> metadata update.
> 
> Call bdev_supports_dax() to perform proper precondition checks
> which includes this partition alignment check.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Boaz Harrosh <boaz@plexistor.com>

Looks good to me. Since this patch depends on the first two in your series,
just feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

and merge it along with other patches. I've removed the ext2 patch from
the previous version from my tree.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
