Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4917B
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 00:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689C7C433D6;
	Fri,  2 Dec 2022 00:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669939557;
	bh=IiyeaxPs1EhycV7peY0dBQYNbMUN49afQfqrUQHkEN0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eyDO0VhDx1Pp6jGfI1Xr4ASibW0lwj74pBQbNpHOlFB1z67REe5U86dIMwo+tvB9r
	 WCx5fRLPRoQ8uiYSt7JHhXQmgQi7B4f4D1B7rW8FpUx8SxDYfiPyGyNDvduN4OXq6+
	 gpkZzvmtKwYFUfwfvpHQ2HAGNBMNgL3QfmyAH6JQFzOeenyY54G+fr0yvvf9G0ADZv
	 WHd1cnH1q+q5qD5bI34s1GCHwMo/El4vGCDRiqaWwQzWDQuKqRnARgP7l0Q7ugfGp+
	 HxcbOuHQd9uABhgaZ9LyeDn7PFIFB8SjA5w0my3uHCnqkMkKaKGLXHLa+noQjZbzVj
	 Vx3cFppGgkQGA==
Date: Thu, 1 Dec 2022 16:05:57 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	david@fromorbit.com, dan.j.williams@intel.com,
	akpm@linux-foundation.org
Subject: Re: [PATCH v2 6/8] xfs: use dax ops for zero and truncate in fsdax
 mode
Message-ID: <Y4lBZUEkK/oYHeX9@magnolia>
References: <1669908538-55-1-git-send-email-ruansy.fnst@fujitsu.com>
 <1669908730-131-1-git-send-email-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1669908730-131-1-git-send-email-ruansy.fnst@fujitsu.com>

On Thu, Dec 01, 2022 at 03:32:10PM +0000, Shiyang Ruan wrote:
> Zero and truncate on a dax file may execute CoW.  So use dax ops which
> contains end work for CoW.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iomap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 881de99766ca..d9401d0300ad 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1370,7 +1370,7 @@ xfs_zero_range(
>  
>  	if (IS_DAX(inode))
>  		return dax_zero_range(inode, pos, len, did_zero,
> -				      &xfs_direct_write_iomap_ops);
> +				      &xfs_dax_write_iomap_ops);
>  	return iomap_zero_range(inode, pos, len, did_zero,
>  				&xfs_buffered_write_iomap_ops);
>  }
> @@ -1385,7 +1385,7 @@ xfs_truncate_page(
>  
>  	if (IS_DAX(inode))
>  		return dax_truncate_page(inode, pos, did_zero,
> -					&xfs_direct_write_iomap_ops);
> +					&xfs_dax_write_iomap_ops);
>  	return iomap_truncate_page(inode, pos, did_zero,
>  				   &xfs_buffered_write_iomap_ops);
>  }
> -- 
> 2.38.1
> 
