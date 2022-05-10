Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0980423C2
	for <nvdimm@lists.linux.dev>; Tue, 10 May 2022 09:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=G7+t/cAdYkqhs1QKuzowXwkwfS2OErx0X9UCnaiTRWU=; b=VgR1nQ1NVLWRbOgBvrbdCW/4tg
	ychxbwVZwl2wzAJjDn82fADKlUzvqITtssspoU+g2VDWJfuI9SKZDpw4BVKWlWrDTU0XfqXhbQrYZ
	WKsLZ/tHz1Oj9CIASd5pspPSEvR6ACnPwg6AFRYXHa3oDOfrd5yuWvTM17QxpTXCOioNjdDjldZ6d
	vyJ2XQVtb61LMMqHRwqmMMmqq8uttx8xIsYIvQWU3SR3NetOIhVS0qBwW4byGtvMzw6EzmDwGsyuN
	QHgviNlvIN8gesVdFW+7rdefORH7XD1/y3kq+w19jJFGCFb2ZW8B+r+RVhAarU07kW0L4Y5OwN5Ss
	mMbcdJaA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1noMER-000qQy-Rm; Tue, 10 May 2022 09:32:39 +0000
Date: Tue, 10 May 2022 02:32:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com, rgoldwyn@suse.de, viro@zeniv.linux.org.uk,
	willy@infradead.org, naoya.horiguchi@nec.com, linmiaohe@huawei.com
Subject: Re: [PATCHSETS] v14 fsdax-rmap + v11 fsdax-reflink
Message-ID: <YnoxN0T/RBbxsqI7@infradead.org>
References: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The patch numbering due looks odd due to the combination of the
two series.  But otherwise this looks good to me modulo the one
minor nitpick.
