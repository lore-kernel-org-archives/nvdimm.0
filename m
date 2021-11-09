Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC932C80
	for <nvdimm@lists.linux.dev>; Tue,  9 Nov 2021 08:14:55 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4D6F167373; Tue,  9 Nov 2021 09:14:46 +0100 (CET)
Date: Tue, 9 Nov 2021 09:14:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: Huaisheng Ye <huaisheng.ye@intel.com>
Cc: dan.j.williams@intel.com, hch@lst.de, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] add ro state control function for nvdimm drivers
Message-ID: <20211109081446.GE28785@lst.de>
References: <20211027120937.1163744-1-huaisheng.ye@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027120937.1163744-1-huaisheng.ye@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
