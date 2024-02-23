Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8AB12D758;
	Fri, 23 Feb 2024 17:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708709530; cv=none; b=rZ4y+k7c4Nz/CRAk1YlYryujK6+uMiywdMd2sjr5NWc+f9uZ/s4/j9opM7W330FKnCDkcD9CuvAhXw9yKbRzp77U6Oj/bwh5bdjhVWe0uBXJAAs1SvBfi54UN+eKxRfZroUjLBR4FQK74ikIPXhVLfDUxgn11WV4NgYBlXMIbRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708709530; c=relaxed/simple;
	bh=yd1ZQGZPNZs2YmoF4FDQ3WIBbppunlM0icmpKCF4RG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xm7ytqyiEA0txsh/PMQ+Haiiv4BC1vnIBWolHy6B9bDHlfs0nKIxMyZNJShk1y8QmlWQ2kmWlakh6VKNO0Ee9e2nS6XIlmm1e+mqlu/c1HEaM9y4wuxMEm1lfpbsrpy8IUG5cwm780wfNxpjq3GOL27UDMmLO7f0MH1Mpd+oNQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lfAvrP0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lfAvrP0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D65FC433C7;
	Fri, 23 Feb 2024 17:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708709530;
	bh=yd1ZQGZPNZs2YmoF4FDQ3WIBbppunlM0icmpKCF4RG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lfAvrP0t7JSGMunnRMLmHKdHZg+iAz3nH2csAJseBFh6AyoOGIVdF4OHXqVCdNyAe
	 eprOb49B6Qeu4AIkKXDT2DX6GY8E4DBkSDYzuP30ms19VqS9MpOP+co4gvxSPKyabu
	 mkRQZyvV01bwPp5qaFJwc0iHvtKNbm+6P9ogKeufjCop0nBuf71da0q5A4mDZb3Gkm
	 UiTbKHKYCQxScpsRX5sxt9EgqOWHEXEcFLZTmaFmVrZv2806OpxOw4WhZzibHPNahu
	 LDItREdev6DwiaFSf6i8qyHzN0jOxsOW70FrfY9yuIHNoIO3aMgGW/Ruw82RFTWFRt
	 yftpnzH93+kNg==
Date: Fri, 23 Feb 2024 09:32:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	chandan.babu@oracle.com, dan.j.williams@intel.com
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-ID: <20240223173209.GA616564@frogsfrogsfrogs>
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>

On Fri, Sep 15, 2023 at 02:38:54PM +0800, Shiyang Ruan wrote:
> FSDAX and reflink can work together now, let's drop this warning.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>

Chandan: Can we get this queued up for 6.8, please?  This has been a
loooooong time coming.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_super.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 1f77014c6e1a..faee773fa026 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -371,7 +371,6 @@ xfs_setup_dax_always(
>  		return -EINVAL;
>  	}
>  
> -	xfs_warn(mp, "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>  	return 0;
>  
>  disable_dax:
> -- 
> 2.42.0
> 
