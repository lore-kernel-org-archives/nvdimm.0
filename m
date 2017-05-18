From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/23] xfs: use uuid_copy() helper to abstract uuid_t
Date: Thu, 18 May 2017 16:32:48 -0700
Message-ID: <20170518233248.GE4519@birch.djwong.org>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170518062705.25902-2-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Thu, May 18, 2017 at 08:26:43AM +0200, Christoph Hellwig wrote:
> From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> uuid_t definition is about to change.
> 
> Signed-off-by: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Reviewed-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> ---
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
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
