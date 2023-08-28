Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520406126
	for <nvdimm@lists.linux.dev>; Mon, 28 Aug 2023 12:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=t/UAQopVsNp4is4uoKpwagnnGQ
	z1HSr9pWMwegGCdNOnN+AnuFV6zFD/Epz4FxFYrqkygX2JPMnl6z1ooNMvdraFw5eADQcIux8dLNy
	Valt2dsZTWys6PQmrSNeY5wUqT11kNwCIpJFz3/VUyQ05L3XzXG1zyqhZPPU2Aa7OJaFEDfPwPriu
	1pPhULBHmK4B+9mhdul7FgXMMtt8uDB7newAVu5InW4xTMcuXEW19gSV2J/ihEBwMuDW7HvQT0kjJ
	yGUMLLgwVXN0Z0QNLaKfr8ouaUVPlzYgAIWtseWHelDwdB71GSFwdlmq7imD6ulaNAK9SkXizk0vO
	sx4ijc/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qaavM-009WdP-1n;
	Mon, 28 Aug 2023 12:00:52 +0000
Date: Mon, 28 Aug 2023 05:00:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Xueshi Hu <xueshi.hu@smartx.com>
Cc: hch@infradead.org, dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, jayalk@intworks.biz, daniel@ffwll.ch,
	deller@gmx.de, bcrl@kvack.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.com, tytso@mit.edu,
	adilger.kernel@dilger.ca, miklos@szeredi.hu,
	mike.kravetz@oracle.com, muchun.song@linux.dev, djwong@kernel.org,
	willy@infradead.org, akpm@linux-foundation.org, hughd@google.com,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-aio@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] fs: clean up usage of noop_dirty_folio
Message-ID: <ZOyMdA/WSZMRWkWY@infradead.org>
References: <20230828075449.262510-1-xueshi.hu@smartx.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828075449.262510-1-xueshi.hu@smartx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
