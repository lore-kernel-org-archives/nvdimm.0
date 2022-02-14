Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD7E812
	for <nvdimm@lists.linux.dev>; Mon, 14 Feb 2022 14:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=oAU+VLSaXso0ujzSNwncj9WmEz
	yecfQzHvYbRWOmTGobVhVFC4e9WWlhA8gu0aNSK+SQshBtdyo4/urVl56PSmxAWJ7J9ZUKL+GttHa
	SBXQzqqJIZvmMplYqJHDsEDrfF8w7ysekOLgP4Y2phSCM7wiUKIwbJ6PtvQGSP4fbWTGChvLSVAhs
	m12/LtL2y1+UrqtkCHw8RyCPUAnWPVn1SApA9E41Be2y+jHbBSO1z2UFuCpGP377qprbHuyj0luyf
	lyl3c+C4vJaa8jNkrW/fyLNx8a6NGKVSUi+6wFv5Q6pQu1woliidn74j3OfUKZhXmQMnzU1Nq0apm
	yuVUqOjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nJc0m-00FaTJ-7K; Mon, 14 Feb 2022 14:07:28 +0000
Date: Mon, 14 Feb 2022 06:07:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Tong Zhang <ztong0001@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dax: make sure inodes are flushed before destroy cache
Message-ID: <YgpiIDyNfFTHafhP@infradead.org>
References: <20220212071111.148575-1-ztong0001@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220212071111.148575-1-ztong0001@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
