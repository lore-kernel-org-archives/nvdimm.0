Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53F7EC2
	for <nvdimm@lists.linux.dev>; Fri,  1 Jul 2022 00:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677BCC341C8;
	Fri,  1 Jul 2022 00:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1656635480;
	bh=J7ImuKdJ6+zEtg8+RKZmBJGvKiGXLBeyOKApUc64ZV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PANuqOf/g0LVn60DqP56O2GljuQgbPY7B0v7h7TK5GGYRkojuT1e6rk+9sDvdQehc
	 EwbRjOzB0KPehn/IOBtviLao84pgrUY78eftOfVfsLC+ROvjcr5H/J+RtIV4Bd34kp
	 7kB2sfUXVc5+S6gU7Gq5f3FkOfh7MsGYGfywx0q59jDxrq8lUMMva1bs7Lo1tFxyQc
	 CDQfvbFOnm5FLdcZT6BL1hT8Esx6YqI3ER0FxhPC4/loE10LqVar5aH9N4s6xLpWi/
	 TwPVTd5CyhGOWw+2/+rGMJYYUh2x+dr7SvBtk2hW8va6f06lpklhAg7su9K7kN2adm
	 p0SQBXzdpIlKQ==
Date: Thu, 30 Jun 2022 17:31:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH] xfs: fail dax mount if reflink is enabled on a partition
Message-ID: <Yr5AV5HaleJXMmUm@magnolia>
References: <20220609143435.393724-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609143435.393724-1-ruansy.fnst@fujitsu.com>

On Thu, Jun 09, 2022 at 10:34:35PM +0800, Shiyang Ruan wrote:
> Failure notification is not supported on partitions.  So, when we mount
> a reflink enabled xfs on a partition with dax option, let it fail with
> -EINVAL code.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>

Looks good to me, though I think this patch applies to ... wherever all
those rmap+reflink+dax patches went.  I think that's akpm's tree, right?

Ideally this would go in through there to keep the pieces together, but
I don't mind tossing this in at the end of the 5.20 merge window if akpm
is unwilling.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_super.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 8495ef076ffc..a3c221841fa6 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -348,8 +348,10 @@ xfs_setup_dax_always(
>  		goto disable_dax;
>  	}
>  
> -	if (xfs_has_reflink(mp)) {
> -		xfs_alert(mp, "DAX and reflink cannot be used together!");
> +	if (xfs_has_reflink(mp) &&
> +	    bdev_is_partition(mp->m_ddev_targp->bt_bdev)) {
> +		xfs_alert(mp,
> +			"DAX and reflink cannot work with multi-partitions!");
>  		return -EINVAL;
>  	}
>  
> -- 
> 2.36.1
> 
> 
> 
