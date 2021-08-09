Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB756177
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 16:17:11 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C89A60F56;
	Mon,  9 Aug 2021 16:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1628525831;
	bh=m7vz8d21YvgM97Zc8xDXGqr8lxsPtm8hfHCZhKbGpCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=egKA3KD7B6v1ERvonhRjVesfgBDvdO2MhAem4ByYiMIzs3uwHP8qjIl6OfBg7CCUv
	 DbNYINxgKfJK7L1ZvfgtpagYBjvsGqpSJ8MbpT7v50JVPdbJIB5CFL7tbZ+DQaTOZV
	 0ptnZDZKvakvEJ7243AD2B3YtcNdmB3ZGmVuGqhuObkcBaP5WeXY1mx789JDbHzWDO
	 qu2D/oGSJ29q6QKK8Hl25me6geokS7GuFdaipDHayaj6zIIHU41qMWxjGvM4ILFs8q
	 m16i6ci9QnBYBCyvs42HTvcZu3t3s65xCMSxsy5+MeX/Ugwwb8DKthRipqqkwFAq1B
	 2HZuAO+jLU/hA==
Date: Mon, 9 Aug 2021 09:17:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 05/30] iomap: mark the iomap argument to
 iomap_inline_data_valid const
Message-ID: <20210809161711.GE3601443@magnolia>
References: <20210809061244.1196573-1-hch@lst.de>
 <20210809061244.1196573-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809061244.1196573-6-hch@lst.de>

On Mon, Aug 09, 2021 at 08:12:19AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  include/linux/iomap.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 560247130357b5..76bfc5d16ef49d 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -109,7 +109,7 @@ static inline void *iomap_inline_data(const struct iomap *iomap, loff_t pos)
>   * This is used to guard against accessing data beyond the page inline_data
>   * points at.
>   */
> -static inline bool iomap_inline_data_valid(struct iomap *iomap)
> +static inline bool iomap_inline_data_valid(const struct iomap *iomap)
>  {
>  	return iomap->length <= PAGE_SIZE - offset_in_page(iomap->inline_data);
>  }
> -- 
> 2.30.2
> 
