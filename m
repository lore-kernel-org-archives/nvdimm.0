Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB1F132492;
	Wed,  6 Mar 2024 14:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709735264; cv=none; b=Of8Sq3mV4cwuORdWKXPIsRbhhvmKNrccDCrXMNTeuOd1u35HDFlw0AgWfDWb/+G/Ab/SRf9haW1re9cmgUCd9AFDWVAQeGH6LDno/2NJ3tKR4r6xSt74dWgrvqmRuAsYLn/k0ZJgplL6IgwnWAcc4ET9BFi+c0rPDOgbCYwQ7DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709735264; c=relaxed/simple;
	bh=XL6QE58M1iFe/XIAe7ruihw5Zk7dX/36Cwcp5BY2dQg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=euAdQfyv3WiPL1TM9kn5m5D9FKeOL7X5JTy/z5cq0cnJ+M7zYPygwuIKquxeg0I3a95vIRPQX/O7qKbItRvt7rl8tGctUYPrV99CjGbp+Cvl+UtYiM1aYYLQaEcHPRVu4C93xJt1jU+/dVG3teVNeZIBSDiV+zIQyQJyFvqaTn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W1sBNu6L; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W1sBNu6L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=sK1ki9ofpn+/NZBKJibcoYH2pOB6nC2QnO5+csns/+M=; b=W1sBNu6L6KRdBf7oxRfOzAriSR
	EB79TAa4Z9V7jikeI+3UVSoU/st7Nvx8/vMaVLdh7q4uX3hxlbCtAGcwSXPoGyjqfnHkxfo1p4L5H
	QBkYHc1s7pGWKmGsH5Tx8w0j+67eH+J94VXdaAWVSmm0I1wtZ+a0u612MUpt8uxiEknB6cNqLF2W0
	Tp5268kurqE3lrf4C0CH6o9+lAHftMlnpHqRYdW/Nq1nI/ouGCbnJhHm+Fcn+FnO1R2ITVCzkiO30
	MZFHKuWVrJqPi9e0oVC4OgUI0zGiRNfvJKeg+w6gvSYwSl52FDU47Vpd0qq2IakxRPzRDftK0rjdw
	dxV1utoQ==;
Received: from [66.60.99.14] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rhsFB-00000000ZYJ-1cBR;
	Wed, 06 Mar 2024 14:27:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: remove calls to blk_queue_max_integrity_segments
Date: Wed,  6 Mar 2024 07:27:36 -0700
Message-Id: <20240306142739.237234-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

I forgot to convert two callers of blk_queue_max_integrity_segments to
the atomic queue_limits API.  This series fixes that and also cleans up
the nvdimm code a bit.

The patches are against Jens' for-6.9/block tree and it would be good if
we could still get them into the 6.9 merge window.

Diffstat:
 md/dm-integrity.c |    2 +-
 nvdimm/btt.c      |   12 ++++++++----
 nvdimm/core.c     |   30 ------------------------------
 nvdimm/nd.h       |    1 -
 4 files changed, 9 insertions(+), 36 deletions(-)
