Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995A42C82
	for <nvdimm@lists.linux.dev>; Fri, 15 Oct 2021 06:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jjb73SnOF4EFSmxfE0GW++wiA9PYNWRHRopAu7TvRYQ=; b=OT8rv34auPM5wdh4ZHemPKgNAh
	zHfqzy/4zRn2M4ITRnGp7Qsj3/M6fiIiclv8TEMv9COQdMvAKGd7TBGOw48avBLRVzJ/K5rbklwpI
	SYJaYDqCqv792TTOlbHDLaDr8VfldPohu46sTPnXwl+hBoCcy5ApjtuYoZAu0X+xBsBYboGGP5HRg
	/zou75h9G0NmPWKG/R1dxVu0W0r0O3BKgMhMjUKHZsAU7IpV6xKgsBV8PLHeNxC/py3I3G6zHgW0L
	HVVV+bdU5HYLM2W0BsFEdCApY8fw9RQpD8jn9w+mVPzwXmTg4MA8QP72g4tKVnRo55d8Si7dZWFOw
	F8j2qBjw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mbGpb-005Yii-Sc; Fri, 15 Oct 2021 06:36:39 +0000
Date: Thu, 14 Oct 2021 23:36:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v7 4/8] pagemap,pmem: Introduce ->memory_failure()
Message-ID: <YWkhd2/x8Art8izR@infradead.org>
References: <20210924130959.2695749-1-ruansy.fnst@fujitsu.com>
 <20210924130959.2695749-5-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924130959.2695749-5-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Except for the error code inversion noticed by Darrick this looks fine
to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
