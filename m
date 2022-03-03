Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F126A2F5D
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 11:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=GgYkIlG3yranRNJR3Y/rvu7hg+GB7NS4kIBFodjdNpE=; b=SNvalMi+z2f6mfymAx12T0DeLv
	QtJG1xDGz/n/hQCexCbZ+2gBUD23L590KrAzmuB5ydI0D6JwOd7G5DKefIlkvlrDEhHp4EWGNtsNQ
	5e92riqhdl5M8/RLX6a9/tJgMnXQLeLz7G+b/NPKPOvBPfJYBmvjarOafMwI5poSZM+bbD/TZETiW
	RAvbW+YYm1IBhxSJdOOArX2P+DPn0T1t351obF+HFAA6XxGba2VlCsNNhwYLx9pcy2ZN63nc2Akyn
	1NIPsaiWgyuPmF2WQ7LNnZIWEW6AaC3GyOuisf82TvvKG4/jppTYszC7BE6/2ihypQ3J5GzacOkFw
	dkCnkJFQ==;
Received: from [91.93.38.115] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nPjUL-006BsV-PU; Thu, 03 Mar 2022 11:19:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Justin Sanders <justin@coraid.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Denis Efremov <efremov@linux.com>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Coly Li <colyli@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	linux-xtensa@linux-xtensa.org,
	linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: remove opencoded kmap of bio_vecs v2
Date: Thu,  3 Mar 2022 14:18:55 +0300
Message-Id: <20220303111905.321089-1-hch@lst.de>
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

this series replaces various open coded kmaps of bio_vecs with higher
level helpers that use kmap_local_page underneath.  It does not touch
other kmap calls in these drivers even if those should probably also
be switched to use kmap_local eventually.

Changes since v1:
 - fix missing switches to kunmap_local

