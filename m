Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAB646A0
	for <nvdimm@lists.linux.dev>; Mon, 26 Jun 2023 07:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OTrORPlbKtaN3ARiMValJAU7k9
	IrlfG5KofT8GcgxXEnXhrNmWJXxJz9safI/qfz+J7XpF856oWnay8+ENcuP2fqCjqQePt7UF7Y5bu
	27Q89P80Sc5w5iUAX61bw4l40tLqGjZL71gELDXCgd18UmEhnqfSjDg75ot10RFXQftXS0SwCfb/D
	ayPfvK7kcc6nPa5ncv2LMGfg1EWuzDP8FCOQ+GTcqBs17YcSL7/4Mg/PEitoqTDgfFnzpsAty/P+T
	51oAWDKiYJaVKQiHVyAAuSiNEvOj+FQB6psDbQNzIKzVRjK+08MPayVLd9/+IA7DVoGq8M+1bbo1Q
	WSr0idlQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qDh2t-009b7c-35;
	Mon, 26 Jun 2023 07:53:59 +0000
Date: Mon, 26 Jun 2023 00:53:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hou Tao <houtao@huaweicloud.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	virtualization@lists.linux-foundation.org, houtao1@huawei.com
Subject: Re: [PATCH v3] virtio_pmem: add the missing REQ_OP_WRITE for flush
 bio
Message-ID: <ZJlEF6PJE5W2JoQ2@infradead.org>
References: <ZJL3+E5P+Yw5jDKy@infradead.org>
 <20230625022633.2753877-1-houtao@huaweicloud.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230625022633.2753877-1-houtao@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
