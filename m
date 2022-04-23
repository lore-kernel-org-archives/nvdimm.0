Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9209C7A
	for <nvdimm@lists.linux.dev>; Sat, 23 Apr 2022 05:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1Pd0EN3sl1N8+yOIX9ZvqsKxN/
	mLyovwdLfqA8Ua0rnflF4QFeCkpAhAFTFtTPP8y6Een5eQUgbVBnGSb9O9LcsY5mp8Y/eossw1iVJ
	n//G2gxdoKibnpQot99FOYMA+3gssXrNlbjyNben3j5U15364xRr43gwxx1xaLjE1eLBalkOsO1W1
	VeENhlptLVaNSEUhhBFUThN7kCm0zeog2sPLIl3qDU+XvnduLpanMNcetTRYnvVlOPjZC6jZyJfzv
	1nIgvRo3vtdmoHXjVQDMVA+7eVt6Nwy95WfaY27l+PzQ9p+FlJqbLI7JwGRizoOlepcS7+JF2UhQ7
	HjTE/09A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1ni8CP-003TJ8-92; Sat, 23 Apr 2022 05:20:49 +0000
Date: Fri, 22 Apr 2022 22:20:49 -0700
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
Subject: Re: [PATCH v9 4/7] dax: introduce DAX_RECOVERY_WRITE dax access mode
Message-ID: <YmOMsTyGhD73koYH@infradead.org>
References: <20220422224508.440670-1-jane.chu@oracle.com>
 <20220422224508.440670-5-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422224508.440670-5-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
