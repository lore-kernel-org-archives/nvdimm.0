Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755582C82
	for <nvdimm@lists.linux.dev>; Wed, 17 Nov 2021 09:37:36 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 68C3268B05; Wed, 17 Nov 2021 10:37:33 +0100 (CET)
Date: Wed, 17 Nov 2021 10:37:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Jane Chu <jane.chu@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
	nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 7/8] device-dax: ensure dev_dax->pgmap is valid for
 dynamic devices
Message-ID: <20211117093733.GB8429@lst.de>
References: <20211112150824.11028-1-joao.m.martins@oracle.com> <20211112150824.11028-8-joao.m.martins@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112150824.11028-8-joao.m.martins@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +bool static_dev_dax(struct dev_dax *dev_dax)
> +{
> +	return is_static(dev_dax->region);
> +}
> +EXPORT_SYMBOL_GPL(static_dev_dax);

This function would massively benefit from documentic what a static
DAX region is and why someone would want to care.  Because even as
someone occasionally dabbling with the DAX code I have no idea at all
what that means.
