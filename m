Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9067E
	for <nvdimm@lists.linux.dev>; Wed,  6 Apr 2022 05:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zVzOJHB+H8iRFesrU56/irhLie
	iotr0hTlovIEUo912dvxARnVVCx6t6DV5lAx3zYKJlziIWEIfBrQ2zHnoFGaXQArPy9yyleUBXZmy
	pcIeBBzTX5JO/9vOb1ylmeBxT6apqXjjcd097JL406v8Y9igNE3OekXQLIU2opodfRk9z+uZR8EBM
	ZENWWoW9nwsdzMlLUzWTiTUAqYmS9bDVVwNXqTfku2sCLg+qt17ZOU252slhdrpCoRp0iiCMEw6Lk
	npUn9CChNnTsibkXBIRvfe/Owu2Uif45+Jt/ZD4Va6+XLoSNc238sTIDC/EIq111ltS3JHktff1/A
	dWXBkYHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nbxoN-003n8x-HC; Wed, 06 Apr 2022 05:02:31 +0000
Date: Tue, 5 Apr 2022 22:02:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v7 3/6] mce: fix set_mce_nospec to always unmap the whole
 page
Message-ID: <Yk0e57n4qNthDKXC@infradead.org>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-4-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405194747.2386619-4-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
