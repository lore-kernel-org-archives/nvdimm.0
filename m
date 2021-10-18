Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0325572
	for <nvdimm@lists.linux.dev>; Mon, 18 Oct 2021 06:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=izDfR9SwcFzSyTnZJFqCWReef4we6QD3oEEjm4zYDu8=; b=DgTu3C+9wyERU8rsuNvvSmWm1m
	/JuzHY5bH9imkxhhFpSijjhLVx8ASufxR3aS5S7x4ew6dVfzlTh901qkd0RmGuz2NbAdmconU4lNy
	eg9xl+fpDb9TKjSDGqzlliD4+EsgD0udMgpNDALbv7wTQtGyMx5w8qK7x+v5yYcH/RNpgy88HFCTB
	5Qm+wZ5JrK52vO1KrkZWiv0iR0ki6/54xQZnUECnDziBPBIQFhi660iEpT+ADWuAw75UrL6R+v8f2
	X8pSsgUEJ0rdEhGJO6V1WYOHDnuoZ/glstakiYjrgQPgH+amV2oF8HWB4DjKH1s30mEcClPmQPztI
	ehPfvz4g==;
Received: from 089144211028.atnat0020.highway.a1.net ([89.144.211.28] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mcLt8-00EHrO-UY; Mon, 18 Oct 2021 06:12:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev
Subject: use bvec_kmap_local
Date: Mon, 18 Oct 2021 08:12:42 +0200
Message-Id: <20211018061244.1816503-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series uses the bvec_kmap_local helper in the nvdimm subsystem.

Diffstat:
 blk.c |    7 +++----
 btt.c |   10 ++++------
 2 files changed, 7 insertions(+), 10 deletions(-)
