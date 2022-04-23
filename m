Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D557A
	for <nvdimm@lists.linux.dev>; Sat, 23 Apr 2022 05:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=39tGASCppitBw9qugg5r56wj62
	Jf8sdO8uXWNE4HIXNeHrtKaykeZ5DO+94eRpvw8pnrtbSQ7VDahHVrmViqg6kRDNBKZRSfTgwInNY
	unl0E3iqwHBg0thXw/V+ZyDEo5MCXDJdJCPn1HgyXc3eSAL2LSFvrmKWLvAN2xoHCk3mzEaijdfKP
	JKNYT6kB0U/JtdZz+dGFTjaBgcjfH6PUHIaYwOJ0/wKrB5ZdbG/WRRxv2yrsGLB9u+8mrQEtMTg72
	nAQcyvrcP2sK22TldA20/jVnw3JkukZ24qHcLhnkMClZOMmvka9I6+ZE3+mT+XTDGb0i5uF9REcnT
	YxYRKO4Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1ni8D1-003TQU-QW; Sat, 23 Apr 2022 05:21:27 +0000
Date: Fri, 22 Apr 2022 22:21:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: dan.j.williams@intel.com, bp@alien8.de, hch@infradead.org,
	dave.hansen@intel.com, peterz@infradead.org, luto@kernel.org,
	david@fromorbit.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com, agk@redhat.com,
	snitzer@redhat.com, dm-devel@redhat.com, ira.weiny@intel.com,
	willy@infradead.org, vgoyal@redhat.com
Subject: Re: [PATCH v9 7/7] pmem: implement pmem_recovery_write()
Message-ID: <YmOM1zSl94nrPpNg@infradead.org>
References: <20220422224508.440670-1-jane.chu@oracle.com>
 <20220422224508.440670-8-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422224508.440670-8-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
