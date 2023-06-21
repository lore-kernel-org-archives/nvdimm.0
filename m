Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214B9134A2
	for <nvdimm@lists.linux.dev>; Wed, 21 Jun 2023 12:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HJ6aMao89kw04QUy0/JqLw3tiRnJ7tZ8x7GgW+IP8+0=; b=1iKNaLttZfW89my+DszE0wSaLz
	3iTgPmiJbY9ulm4tEmY9q+uzOBG9C0FAuJkIq3SeTTqymhPuuf3/8ZDxXwia2FzhYPjqr1/CYxb0F
	FZNrwGLxCCCSxsItwui2ZusZTblvBv8qbJxefK6wn24OlMe7ngHelTRF5UggmHfPeSP8s2M7rQ6Ce
	CtC4irb/lY4lFcaWJmLzDmrxCU2AnAh5n9IVZhgya/1Pq3Sjv8BPErClJKhF/OiNl2qLx3tkaGCx4
	YeRn57kBD6/hzbXUYohe8x9RwMZO0jj+RtYuOpQD4VTc8M+k3UjcquSQFbAVx/rqQxMDqFwhc6MeE
	q+vQdTFA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qBwi8-00EV4i-1o;
	Wed, 21 Jun 2023 12:13:20 +0000
Date: Wed, 21 Jun 2023 05:13:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hou Tao <houtao@huaweicloud.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	virtualization@lists.linux-foundation.org,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Christoph Hellwig <hch@infradead.org>, houtao1@huawei.com
Subject: Re: [PATCH] virtio_pmem: do flush synchronously
Message-ID: <ZJLpYMC8FgtZ0k2k@infradead.org>
References: <20230620032838.1598793-1-houtao@huaweicloud.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230620032838.1598793-1-houtao@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I think the proper minimal fix is to pass in a REQ_WRITE in addition to
REQ_PREFLUSH.  We can than have a discussion on the merits of this
weird async pmem flush scheme separately.

