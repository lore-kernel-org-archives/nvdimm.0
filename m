Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 302FC21A00A1B
 for <linux-nvdimm@lists.01.org>; Thu, 18 May 2017 06:27:05 -0700 (PDT)
Date: Thu, 18 May 2017 09:27:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/23] xfs: use uuid_copy() helper to abstract uuid_t
Message-ID: <20170518132701.GC18240@bfoster.bfoster>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-2-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170518062705.25902-2-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 18, 2017 at 08:26:43AM +0200, Christoph Hellwig wrote:
> From: Amir Goldstein <amir73il@gmail.com>
> 
> uuid_t definition is about to change.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode_item.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 08cb7d1a4a3a..013cc78d7daf 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -834,9 +834,7 @@ xfs_inode_item_format_convert(
>  		in_f->ilf_dsize = in_f32->ilf_dsize;
>  		in_f->ilf_ino = in_f32->ilf_ino;
>  		/* copy biggest field of ilf_u */
> -		memcpy(in_f->ilf_u.ilfu_uuid.__u_bits,
> -		       in_f32->ilf_u.ilfu_uuid.__u_bits,
> -		       sizeof(uuid_t));
> +		uuid_copy(&in_f->ilf_u.ilfu_uuid, &in_f32->ilf_u.ilfu_uuid);
>  		in_f->ilf_blkno = in_f32->ilf_blkno;
>  		in_f->ilf_len = in_f32->ilf_len;
>  		in_f->ilf_boffset = in_f32->ilf_boffset;
> @@ -851,9 +849,7 @@ xfs_inode_item_format_convert(
>  		in_f->ilf_dsize = in_f64->ilf_dsize;
>  		in_f->ilf_ino = in_f64->ilf_ino;
>  		/* copy biggest field of ilf_u */
> -		memcpy(in_f->ilf_u.ilfu_uuid.__u_bits,
> -		       in_f64->ilf_u.ilfu_uuid.__u_bits,
> -		       sizeof(uuid_t));
> +		uuid_copy(&in_f->ilf_u.ilfu_uuid, &in_f64->ilf_u.ilfu_uuid);
>  		in_f->ilf_blkno = in_f64->ilf_blkno;
>  		in_f->ilf_len = in_f64->ilf_len;
>  		in_f->ilf_boffset = in_f64->ilf_boffset;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
