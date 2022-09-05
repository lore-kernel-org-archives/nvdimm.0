Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C714406
	for <nvdimm@lists.linux.dev>; Mon,  5 Sep 2022 14:45:42 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 93E3F68AFE; Mon,  5 Sep 2022 16:45:39 +0200 (CEST)
Date: Mon, 5 Sep 2022 16:45:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, djwong@kernel.org,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Christoph Hellwig <hch@lst.de>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <david@fromorbit.com>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>,
	Jane Chu <jane.chu@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Ritesh Harjani <riteshh@linux.ibm.com>, nvdimm@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/4] mm/memory-failure: Fall back to vma_address() when
 ->notify_failure() fails
Message-ID: <20220905144539.GD6784@lst.de>
References: <166153426798.2758201.15108211981034512993.stgit@dwillia2-xfh.jf.intel.com> <166153429427.2758201.14605968329933175594.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166153429427.2758201.14605968329933175594.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
