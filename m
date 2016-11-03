Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AC5E381D40
 for <linux-nvdimm@lists.01.org>; Thu,  3 Nov 2016 14:04:38 -0700 (PDT)
Date: Thu, 3 Nov 2016 15:04:40 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 01/11] ext4: Factor out checks from ext4_file_write_iter()
Message-ID: <20161103210440.GA27351@linux.intel.com>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
 <1478034381-19037-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1478034381-19037-2-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 01, 2016 at 10:06:11PM +0100, Jan Kara wrote:
> Factor out checks of 'from' and whether we are overwriting out of
> ext4_file_write_iter() so that the function is easier to follow.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c | 97 ++++++++++++++++++++++++++++++----------------------------
>  1 file changed, 50 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 2a822d30e73f..a6a7becb9465 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -88,6 +88,51 @@ ext4_unaligned_aio(struct inode *inode, struct iov_iter *from, loff_t pos)
>  	return 0;
>  }
>  
> +/* Is IO overwriting allocated and initialized blocks? */
> +static bool ext4_overwrite_io(struct inode *inode, loff_t pos, loff_t len)
> +{
> +	struct ext4_map_blocks map;
> +	unsigned int blkbits = inode->i_blkbits;
> +	int err, blklen;
> +
> +	if (pos + len > i_size_read(inode))
> +		return false;
> +
> +	map.m_lblk = pos >> blkbits;
> +	map.m_len = EXT4_MAX_BLOCKS(len, pos, blkbits);
> +	blklen = map.m_len;
> +
> +	err = ext4_map_blocks(NULL, inode, &map, 0);
> +	/*
> +	 * 'err==len' means that all of blocks has been preallocated no matter
> +	 * they are initialized or not.  For excluding unwritten extents, we
> +	 * need to check m_flags.

Does it make sense to clean up this comment, since you're moving it anyway?

i.e.:

  'err==len' means that all of the blocks have been preallocated, regardless
  of whether they have been initialized or not.  To exclude unwritten extents
  we need to check m_flags.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
