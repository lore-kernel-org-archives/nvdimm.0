Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CCA29CA
	for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 06:17:41 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6FCCC68AFE; Thu, 16 Sep 2021 08:17:39 +0200 (CEST)
Date: Thu, 16 Sep 2021 08:17:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, rgoldwyn@suse.de, viro@zeniv.linux.org.uk,
	willy@infradead.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH v9 6/8] fsdax: Dedup file range to use a compare
 function
Message-ID: <20210916061739.GC13306@lst.de>
References: <20210915104501.4146910-1-ruansy.fnst@fujitsu.com> <20210915104501.4146910-7-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915104501.4146910-7-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
