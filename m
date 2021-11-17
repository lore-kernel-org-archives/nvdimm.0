Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF842C82
	for <nvdimm@lists.linux.dev>; Wed, 17 Nov 2021 09:43:38 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6E65068AFE; Wed, 17 Nov 2021 10:37:22 +0100 (CET)
Date: Wed, 17 Nov 2021 10:37:22 +0100
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
Subject: Re: [PATCH v5 6/8] device-dax: use struct_size()
Message-ID: <20211117093722.GA8429@lst.de>
References: <20211112150824.11028-1-joao.m.martins@oracle.com> <20211112150824.11028-7-joao.m.martins@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112150824.11028-7-joao.m.martins@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +		pgmap = devm_kzalloc(
> +                       dev, struct_size(pgmap, ranges, dev_dax->nr_range - 1),
> +                       GFP_KERNEL);

Keeping the dev argument on the previous line would not only make this
much more readable but also avoid the overly long line.
