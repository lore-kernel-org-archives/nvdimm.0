Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48074C7B
	for <nvdimm@lists.linux.dev>; Wed, 25 Jan 2023 15:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CBDC433D2;
	Wed, 25 Jan 2023 15:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1674662314;
	bh=aUkUHwB0Xq0oSmDtb8Ps0uypEki5oRPSjQ+9ZXsbQpQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bd/qPBy7SrLfQAuZ9JSfkCuSJNpOuQb2TjGJ+gIWalTOgOFE3uYUzPD/8iFs+30ue
	 tXsOJueXU6KgxSRsN29umipxzyFhudNla3UMJeYGzwHbsozsSONQsM8bjN84uHny8r
	 IhS3nSt8ST8dR56KmBhyUM8/BdcZxA1Pi08NEfOeOdom3hGZqkmM7Fo9FYdWQT3I0O
	 kNXVa6/2CvVk12LePVQIjq1DKkwtGkP68WuJzfo9SCGvyzld6nDLZPL8keFOfYWFEe
	 kIulbruoWh1IKa5NicW8ACkm6qixyuSeNpW7RBxkrRzyJx0euXhw98VtLUN/AH48/2
	 l5wig70p4uoMQ==
Date: Wed, 25 Jan 2023 08:58:31 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/7] mm: remove the swap_readpage return value
Message-ID: <Y9FRpwaiee2GaOm+@kbusch-mbp.dhcp.thefacebook.com>
References: <20230125133436.447864-1-hch@lst.de>
 <20230125133436.447864-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125133436.447864-3-hch@lst.de>

On Wed, Jan 25, 2023 at 02:34:31PM +0100, Christoph Hellwig wrote:
> -static inline int swap_readpage(struct page *page, bool do_poll,
> -				struct swap_iocb **plug)
> +static inline void swap_readpage(struct page *page, bool do_poll,
> +		struct swap_iocb **plug)
>  {
>  	return 0;
>  }

Need to remove the 'return 0'.
