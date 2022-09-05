Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8752561
	for <nvdimm@lists.linux.dev>; Mon,  5 Sep 2022 14:44:38 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id D3CBB68AA6; Mon,  5 Sep 2022 16:44:33 +0200 (CEST)
Date: Mon, 5 Sep 2022 16:44:33 +0200
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
Subject: Re: [PATCH 2/4] xfs: Fix SB_BORN check in xfs_dax_notify_failure()
Message-ID: <20220905144433.GB6784@lst.de>
References: <166153426798.2758201.15108211981034512993.stgit@dwillia2-xfh.jf.intel.com> <166153428094.2758201.7936572520826540019.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166153428094.2758201.7936572520826540019.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 26, 2022 at 10:18:01AM -0700, Dan Williams wrote:
> The SB_BORN flag is stored in the vfs superblock, not xfs_sb.

Oops, yes:

Reviewed-by: Christoph Hellwig <hch@lst.de>
