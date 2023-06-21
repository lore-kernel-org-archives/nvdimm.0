Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570C511CA1
	for <nvdimm@lists.linux.dev>; Wed, 21 Jun 2023 13:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7KtYi3eep9XbX588SNTMn5wloXG6pscuzpNL2Pfc/eI=; b=NpVRqyd25XnP+LIMi0RBCfaMb1
	C979QWJcaCpZ9oWDTPhnKiGBGmXmF80gnUoRdljpTV8/TiFMlIG/oCiDKnRc9ylgniKn1TocD54UV
	Wa7Tsq+j99vPRMp2Cpymkun14uEMRTUyR9m5oRV8TYopVNzdwjke0kXM/0FEZRsK4wrkhNKEmw+fh
	Wfhqrx1rgIiieFhpa+rqJkCqifgpvAyWMjPFvAMv3U0MOQaXAJJs6SABcM8lJXIMViHkXKyZetFXS
	tjxIlwBNGdlbJAGIoAOPWHsteifabiK47EeBRM1I1nHsLnCbHQ1WpHp6pF7hL6kBNIIoV+MV6sp7M
	MfcL0fnw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qBxgO-00EeS1-3C;
	Wed, 21 Jun 2023 13:15:36 +0000
Date: Wed, 21 Jun 2023 06:15:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hou Tao <houtao@huaweicloud.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux-foundation.org,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>, houtao1@huawei.com
Subject: Re: [PATCH v2] virtio_pmem: add the missing REQ_OP_WRITE for flush
 bio
Message-ID: <ZJL3+E5P+Yw5jDKy@infradead.org>
References: <ZJLpYMC8FgtZ0k2k@infradead.org>
 <20230621134340.878461-1-houtao@huaweicloud.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230621134340.878461-1-houtao@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Please avoid the overly long line.  With that fixe this looks good
to me.

