Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB1A3FC9
	for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 06:16:57 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9F53568AFE; Thu, 16 Sep 2021 08:16:54 +0200 (CEST)
Date: Thu, 16 Sep 2021 08:16:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, rgoldwyn@suse.de, viro@zeniv.linux.org.uk,
	willy@infradead.org, Ritesh Harjani <riteshh@linux.ibm.com>
Subject: Re: [PATCH v9 5/8] fsdax: Add dax_iomap_cow_copy() for
 dax_iomap_zero
Message-ID: <20210916061654.GB13306@lst.de>
References: <20210915104501.4146910-1-ruansy.fnst@fujitsu.com> <20210915104501.4146910-6-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915104501.4146910-6-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 15, 2021 at 06:44:58PM +0800, Shiyang Ruan wrote:
> +	rc = dax_direct_access(iomap->dax_dev, pgoff, 1, &kaddr, NULL);
> +	if (rc < 0)
> +		goto out;
> +	memset(kaddr + offset, 0, size);
> +	if (srcmap->addr != IOMAP_HOLE && srcmap->addr != iomap->addr) {

Should we also check that ->dax_dev for iomap and srcmap are different
first to deal with case of file system with multiple devices?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
