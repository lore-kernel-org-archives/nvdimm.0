Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6022D1FA1
	for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 06:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=e3Har+rE46oN9tVjkAakWJYHtW
	OE12i0bttnBLRZvoim2RjDmKYMhJU6CdbbkaxcamE92w072N9viXb0rmwsbceO+WfuChRoR/Wnmad
	G5ms2QSGlpBKVMq2Pw2eVSnnUrSy2ULzARQAvnS54YpP9CQN1Q2QidrDiQRGY5gEHcDEyZR5/8oTC
	1EohFfCdTUl2kAImUgj7b1lJ2fjrYdFiMnfbXydn36owPdYfkvh2YPX2IfX9zxZ8ZUjD8liueYU7y
	I1cSRM4gdJEoT3d8zqAgirt3CCWvXJ9OFOWc0BVrtm5niA4GZ87nGGMhJigTFOY/ohwCYDlyLIbDh
	+ux3nKJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nhQfT-00BsA0-CB; Thu, 21 Apr 2022 06:51:55 +0000
Date: Wed, 20 Apr 2022 23:51:55 -0700
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
Subject: Re: [PATCH v8 3/7] mce: fix set_mce_nospec to always unmap the whole
 page
Message-ID: <YmD/CwS8AsbiC3af@infradead.org>
References: <20220420020435.90326-1-jane.chu@oracle.com>
 <20220420020435.90326-4-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420020435.90326-4-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
