Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A392561
	for <nvdimm@lists.linux.dev>; Mon,  5 Sep 2022 14:48:57 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 68A1B68D05; Mon,  5 Sep 2022 16:42:29 +0200 (CEST)
Date: Mon, 5 Sep 2022 16:42:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, djwong@kernel.org,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <david@fromorbit.com>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>,
	Jane Chu <jane.chu@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Ritesh Harjani <riteshh@linux.ibm.com>, nvdimm@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: Quiet notify_failure EOPNOTSUPP cases
Message-ID: <20220905144228.GA6784@lst.de>
References: <166153426798.2758201.15108211981034512993.stgit@dwillia2-xfh.jf.intel.com> <166153427440.2758201.6709480562966161512.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166153427440.2758201.6709480562966161512.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 26, 2022 at 10:17:54AM -0700, Dan Williams wrote:
> XFS always registers dax_holder_operations regardless of whether the
> filesystem is capable of handling the notifications. The expectation is
> that if the notify_failure handler cannot run then there are no
> scenarios where it needs to run. In other words the expected semantic is
> that page->index and page->mapping are valid for memory_failure() when
> the conditions that cause -EOPNOTSUPP in xfs_dax_notify_failure() are
> present.
> 
> A fallback to the generic memory_failure() path is expected so do not
> warn when that happens.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
