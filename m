Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A419F61FFE;
	Thu, 24 Jul 2025 16:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753374354; cv=none; b=tOAlW9LEitvvS8LWjbJZUEPVGMxKVwcacCdavUMRoaSHiliAdm2OwE1GrKOCSyiPZLihMQtJYlXDghIITyabgUkljUseFPoaJ5lhQuz/Ppym+Qc6/dp2Q4xo0EJuiKhuQ24flz02mCk7sBtQAjt2cv3WzFAbCJv8LwH9Drj+Tck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753374354; c=relaxed/simple;
	bh=vRnMpS06lf761Q10bV3WJB6gy82RFQ4f91cCwBCMQEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V3/NHnS+i/kvsHQKuLVDrDcmnOA4QUWpNB4KKfnp/wY2JpdXqlpIj/nNTIGyrMx0snItBZi+JQ25C3euUO6Gv+EJ9QZ8/RRmMrkyuqxnKbJ8g6X3/lh7hfxY0WjsvAdYz1LGiGWDX12ySBVPxxjdlAeEck4BLl1GZgEe+eCAEmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h0Cu9r2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h0Cu9r2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199ACC4CEED;
	Thu, 24 Jul 2025 16:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753374354;
	bh=vRnMpS06lf761Q10bV3WJB6gy82RFQ4f91cCwBCMQEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h0Cu9r2UYJyrkXm29fM6PHOIi1KPwS+JYGVaQOWJu/fC5Spd6i3TWR4jyoTofpmoy
	 zifizSH/lCltwLzuk1+oG7gmnd0NW4/2a8dXQc9o9oDwbxT9BQSd4yK5FKxK5DwVDQ
	 6lNcNvzxwy0ENXfGQwwabiC447YJZAGQMWCxgFwOFdSLuirwj0yoGWasH/O4I5yCGV
	 DBYWAHo7UOufqZnVX/V3ZInbjU0L5T1gdUbh7mUCtnEfOWD4APy/u/ko23jVUTbuFq
	 9Y8b7Aa2HIS2abqcZE0yS08JbXJw6hjM603+ZC48Dt93kfFBPZfuRAwlNoXvIaK7vf
	 BpkebQfnv2utw==
Date: Thu, 24 Jul 2025 09:25:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, cem@kernel.org, dan.j.williams@intel.com,
	willy@infradead.org, jack@suse.cz, brauner@kernel.org,
	viro@zeniv.linux.org.uk, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] fs/dax: Reject IOCB_ATOMIC in dax_iomap_rw()
Message-ID: <20250724162553.GM2672029@frogsfrogsfrogs>
References: <20250724081215.3943871-1-john.g.garry@oracle.com>
 <20250724081215.3943871-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724081215.3943871-2-john.g.garry@oracle.com>

On Thu, Jul 24, 2025 at 08:12:13AM +0000, John Garry wrote:
> The DAX write path does not support IOCB_ATOMIC, so reject it when set.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/dax.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index ea0c35794bf9..d9ce810fee9e 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1756,6 +1756,9 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	loff_t done = 0;
>  	int ret;
>  
> +	if (WARN_ON_ONCE(iocb->ki_flags & IOCB_ATOMIC))
> +		return -EIO;
> +
>  	if (!iomi.len)
>  		return 0;
>  
> -- 
> 2.43.5
> 
> 
