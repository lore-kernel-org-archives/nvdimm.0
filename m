Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C013A31
	for <nvdimm@lists.linux.dev>; Tue, 22 Mar 2022 08:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=R/9PiHNeZAvuJT4xxt7KVry0YR
	8jtzFPgJ7lZiZejMRxmKXMZgSOilMgK1WCzKDK2oTozIeLQLh5WtsDjTMqLUpIpoRGNulLcDOgp4p
	Hz4kQ0LQMQQpqGRKdZLNOwi0x0KLjD8qn2FvoOz5RKof2fLKVQKxEmPgcexZjpQ7GWRarkZThWmuN
	e79Q1jH+4OrjSlm01MvoEOhvRBVXPE1S+JCMPRJdUR+8lym/8Gi9PKyepcv/4YI+l1kINPKGrcwwO
	pnUchuGpnkzHPtSrfKNZNsQoT3Rv+ztkJI0lOj3v8+T8ACsL2V3VH8ujapTRqTUmiCiV116/kXrky
	chzF1GnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nWZz1-00ARCq-Bk; Tue, 22 Mar 2022 08:35:15 +0000
Date: Tue, 22 Mar 2022 01:35:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
	apopple@nvidia.com, shy828301@gmail.com, rcampbell@nvidia.com,
	hughd@google.com, xiyuyang19@fudan.edu.cn,
	kirill.shutemov@linux.intel.com, zwisler@kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, duanxiongchun@bytedance.com, smuchun@gmail.com
Subject: Re: [PATCH v5 6/6] mm: simplify follow_invalidate_pte()
Message-ID: <YjmKQxntxt9VJGHX@infradead.org>
References: <20220318074529.5261-1-songmuchun@bytedance.com>
 <20220318074529.5261-7-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318074529.5261-7-songmuchun@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
