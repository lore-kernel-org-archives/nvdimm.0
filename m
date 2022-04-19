Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC267A
	for <nvdimm@lists.linux.dev>; Tue, 19 Apr 2022 07:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=max1nfoHANuyh9gL3fVc7pOfnK
	XANQhXogVRAki2FCZgXupfOQQCObmBs6wnR1pry/Utov/d8C2PsOH6O8BOVINf23HcpDINQgNGoKe
	1k3XFkJhPZIs+pib0qFZbuSx7Sa/YNTYujUlGwYW4/GnrYphDvbaG3Sa4w+G6lvFzQzFBRzoem1kw
	H+u+Y5dBbe0mYW8gdmWkgt1rGHafrxC4wo4c7mjXg+2Uvq/zrBymYDwCwq1U7Bp5ELvr9mWEim5Zn
	yrcKSWkMdRXabGD+Bf5c6+L/IPnMqgi3bvjxmxUh0og7JWpoMSclODM5JozgA4s/najzH5rIp1Z2k
	EfVDQJMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1ngiGe-001ywc-Eb; Tue, 19 Apr 2022 07:27:20 +0000
Date: Tue, 19 Apr 2022 00:27:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v13 7/7] fsdax: set a CoW flag when associate reflink
 mappings
Message-ID: <Yl5kWMI81T9SorTL@infradead.org>
References: <20220419045045.1664996-1-ruansy.fnst@fujitsu.com>
 <20220419045045.1664996-8-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419045045.1664996-8-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
