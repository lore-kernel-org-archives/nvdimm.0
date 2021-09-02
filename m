Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787243FC1
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 07:34:34 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7D7B168B05; Thu,  2 Sep 2021 09:34:30 +0200 (CEST)
Date: Thu, 2 Sep 2021 09:34:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, rgoldwyn@suse.de, viro@zeniv.linux.org.uk,
	willy@infradead.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH v8 5/7] fsdax: Dedup file range to use a compare
 function
Message-ID: <20210902073429.GD13867@lst.de>
References: <20210829122517.1648171-1-ruansy.fnst@fujitsu.com> <20210829122517.1648171-6-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210829122517.1648171-6-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +EXPORT_SYMBOL(vfs_dedupe_file_range_compare);

I don't see why this would need to be exported.

> @@ -370,6 +384,15 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL(__generic_remap_file_range_prep);

Same here.
