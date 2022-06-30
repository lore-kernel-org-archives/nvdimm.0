Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF947469
	for <nvdimm@lists.linux.dev>; Thu, 30 Jun 2022 18:29:41 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id C8CEF68AA6; Thu, 30 Jun 2022 20:29:37 +0200 (CEST)
Date: Thu, 30 Jun 2022 20:29:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jane Chu <jane.chu@oracle.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org, hch@lst.de,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v2] pmem: fix a name collision
Message-ID: <20220630182937.GA19534@lst.de>
References: <20220630182802.3250449-1-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630182802.3250449-1-jane.chu@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
