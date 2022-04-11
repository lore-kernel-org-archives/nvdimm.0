Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A0310EC
	for <nvdimm@lists.linux.dev>; Mon, 11 Apr 2022 06:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xKP1rw8lzQQLTwv1zSc1+CqbU2
	7PNfGfQbN8HONCSR4A5n9NXBhr5mBBQSbcu1yxNeUrtLUeNDQyBR5syPtmTkDcYXAaZrIH7US11Ig
	cCUXszZtVn0vtmYU/QzpmxiBfg00h8wbwLSmGYXriD745mwAQ2jT7gV+tQNX/mztpgon7Qs6nurmB
	k0GKtDTgV77CQ0/NfroqP6j2sWSRPWmKjeqwdR0L3btWGpeiy133rGlQkzYvkCzPla9V+GFgQFpVR
	/AYsrAk64q/L9DlT2L2NkUPQkXV1wuxNkW8Z8AcoGgMObbcR1rNdWeTGADN7fqWUlO6bQrBRJ7uQO
	gm91kNLQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1ndneP-006wKh-J8; Mon, 11 Apr 2022 06:35:49 +0000
Date: Sun, 10 Apr 2022 23:35:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v12 1/7] dax: Introduce holder for dax_device
Message-ID: <YlPMRWvqFp7K3I85@infradead.org>
References: <20220410160904.3758789-1-ruansy.fnst@fujitsu.com>
 <20220410160904.3758789-2-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410160904.3758789-2-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
