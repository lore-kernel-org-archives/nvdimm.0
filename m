Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE0C168
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 17:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BE5C36AE3;
	Wed,  5 Jan 2022 17:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1641405006;
	bh=kGMQK7S48NYYtzeG3Jx6fNlmZSW90MiCjA8dmUStu80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DcQj4GSLvWK7szMssp9UFdcYjvlpVb01nEC3aJCQhGMfIhRGkYDl6IWR7GmbDHbCX
	 Xsp0EmpJZHtmcVq0/dngKMqdMiNOvDslbl+TFDx96zb+Qf1id9BMkk91uU+QMyuYQ6
	 3Z8Pti+XA0ZTe1uVuT19tSI3yami5Tthlg/tEMKF1FbGRQCbTHvyczdZnHIs3gZjJM
	 AiZe4M3uJ6lm4quj4gWO3RzlL5/fMJCXvZ9MKGIo7Z0Dac0X/+tCcer/TNpQGAFW2g
	 /bp6chjr/gcQTacK49s7e417J3XCXSqKzVV8YGdMvPgupecEFJsQCQ5g+DiyTczGBl
	 YSMPQd8YzcrVw==
Date: Wed, 5 Jan 2022 09:50:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
	david@fromorbit.com, hch@infradead.org, jane.chu@oracle.com
Subject: Re: [PATCH v9 05/10] fsdax: fix function description
Message-ID: <20220105175006.GB398655@magnolia>
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com>
 <20211226143439.3985960-6-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211226143439.3985960-6-ruansy.fnst@fujitsu.com>

On Sun, Dec 26, 2021 at 10:34:34PM +0800, Shiyang Ruan wrote:
> The function name has been changed, so the description should be updated
> too.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/dax.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 1f46810d4b68..2ee2d5a525ee 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -390,7 +390,7 @@ static struct page *dax_busy_page(void *entry)
>  }
>  
>  /*
> - * dax_lock_mapping_entry - Lock the DAX entry corresponding to a page
> + * dax_lock_page - Lock the DAX entry corresponding to a page
>   * @page: The page whose entry we want to lock
>   *
>   * Context: Process context.
> -- 
> 2.34.1
> 
> 
> 
