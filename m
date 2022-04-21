Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE4B1FA1
	for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 06:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Tca/BI+7yFtA63xtZOZsEXrGVX
	Q6x+UTA4JqrvDmlvssK3fOfWPzaPw4O7oHr+tDeAkZtQpjN3dFBPHyekV/lljdrdiTnfCa8Azpabf
	zSt7U+gCCyxRT6/7rLrD3RRip/e+ggKkCe4d2lCqj3NHlItI/KuFp95UNb+LhkxG0rJ9kmIxl1roF
	09luCT0w42YNIwreN0Ulm2Ei94FOA6HczHtXhEh8e4pqdl+Cvan6tBh2pffX1ivY+w5bJrl6Sr0Yv
	00KDaIhCF53xwefmTxNGwSh0Z5djXk7C9xh/DxoSZLsT/hpLly4mud0VzUd7Go1vADEJ86nfkSkCp
	F4d/hlPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nhQlH-00Buhd-5p; Thu, 21 Apr 2022 06:57:55 +0000
Date: Wed, 20 Apr 2022 23:57:55 -0700
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
Subject: Re: [PATCH v8 5/7] dax: add .recovery_write dax_operation
Message-ID: <YmEAc+10ztlpn54v@infradead.org>
References: <20220420020435.90326-1-jane.chu@oracle.com>
 <20220420020435.90326-6-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420020435.90326-6-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
