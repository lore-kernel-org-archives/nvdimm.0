Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C203043C6;
	Wed, 26 Nov 2025 13:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764163312; cv=none; b=E005dV9MzQHXzutJGwHaJCJPRF5KLdTit4Z+Tp6/fkmyRRkR9eQtTQJ7ahMhcFA3TqUAeNUvsPmBQ7MWFzFcZDMgman79svpY0toymwDBJ6neDi6jeqa4olimjjKuvOmryJ5byllfRO459AEjMLBWr0igGh7H7MgKiziJvppJGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764163312; c=relaxed/simple;
	bh=an4gRetSwz0oqqNoLANQvssGSiNOJqHrZzkDAFiebkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WdOdaBsepSdu5cLF4HjYnbeKDKMU0ZF49ek+ywiM955KIzkHkScv5TVVBJMqfysd6WyMwaeh7WTOUNnQ9d0v+fziP3Sssb43R10p853uJBiCA1dtYD/ouDGraA0Q3CXRPDUEaPmP6lPwQKfrF6ygv6qJVFFXdrbVRHD6CumPb4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DWUzfReG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DWUzfReG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21973C113D0;
	Wed, 26 Nov 2025 13:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764163312;
	bh=an4gRetSwz0oqqNoLANQvssGSiNOJqHrZzkDAFiebkM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DWUzfReGi5Y9SCPHnJvWSORCLTTzQc7wx4t3H+FjmSdriMXa3HUOAZer9dNofBeT+
	 pQwU5FOr7QNKcG8FAQ3RBko26NJ4P1zQOQ/63p0wjukKriivdstlxhz8cuzz5UnbZV
	 Cw/VQRcXFK0VdE9l83r7MrazKGU+w07uUZyolYtD1W/8su8/IFwIKWZ7Xyf+P2rnKn
	 HZJqqB64mI5SPg3uE4N6w5LVkBU4y5ZTtsx1pxLF1gX4kFJWMYAtR+hKzwPlHe0z96
	 FfSNEQMn9yXCNgP4CAhI4HbZYeu8YWuACkCCl/GwUsrvx1Q4TRxwcx62bwOjFhJrkm
	 EWCKxubcXizSw==
Date: Wed, 26 Nov 2025 15:21:46 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH next v2] nvdimm: Prevent integer overflow in
 ramdax_get_config_data()
Message-ID: <aSb-6ujzwZYtNFpf@kernel.org>
References: <aSbuiYCznEIZDa02@stanley.mountain>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSbuiYCznEIZDa02@stanley.mountain>

On Wed, Nov 26, 2025 at 03:11:53PM +0300, Dan Carpenter wrote:
> The "cmd->in_offset" variable comes from the user via the __nd_ioctl()
> function.  The problem is that the "cmd->in_offset + cmd->in_length"
> addition could have an integer wrapping issue if cmd->in_offset is close
> to UINT_MAX .  Both "cmd->in_offset" and "cmd->in_length" are u32
> variables.
> 
> Fixes: 43bc0aa19a21 ("nvdimm: allow exposing RAM carveouts as NVDIMM DIMM devices")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> v2: Ira Weiny pointed out that ramdax_set_config_data() needs to be
>     fixed as well.
> 
>  drivers/nvdimm/ramdax.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/ramdax.c b/drivers/nvdimm/ramdax.c
> index 63cf05791829..954cb7919807 100644
> --- a/drivers/nvdimm/ramdax.c
> +++ b/drivers/nvdimm/ramdax.c
> @@ -143,7 +143,7 @@ static int ramdax_get_config_data(struct nvdimm *nvdimm, int buf_len,
>  		return -EINVAL;
>  	if (struct_size(cmd, out_buf, cmd->in_length) > buf_len)
>  		return -EINVAL;
> -	if (cmd->in_offset + cmd->in_length > LABEL_AREA_SIZE)
> +	if (size_add(cmd->in_offset, cmd->in_length) > LABEL_AREA_SIZE)
>  		return -EINVAL;
>  
>  	memcpy(cmd->out_buf, dimm->label_area + cmd->in_offset, cmd->in_length);
> @@ -160,7 +160,7 @@ static int ramdax_set_config_data(struct nvdimm *nvdimm, int buf_len,
>  		return -EINVAL;
>  	if (struct_size(cmd, in_buf, cmd->in_length) > buf_len)
>  		return -EINVAL;
> -	if (cmd->in_offset + cmd->in_length > LABEL_AREA_SIZE)
> +	if (size_add(cmd->in_offset, cmd->in_length) > LABEL_AREA_SIZE)
>  		return -EINVAL;
>  
>  	memcpy(dimm->label_area + cmd->in_offset, cmd->in_buf, cmd->in_length);
> -- 
> 2.51.0
> 

-- 
Sincerely yours,
Mike.
