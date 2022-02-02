Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90CA2F21
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 13:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d5HzwnDAaTCuQg45tXQKIbOlDLhSfo0od23DSrVaQM0=; b=Ws0XgUhXHFWiaj7ZbmQAzfp+Bd
	HDzQKBN/Jneu0amc/KZFCv9dknq8oga0KJ3o0DNsvbXoNhEdIwHEyUgWdkLmAyYK+Tr21OYWFbEB2
	RjKCYoyIZMr5Tj59RtZb6we/A2sVc90Yb3urUVH8mvIpruqvKY5VKHPlG9+bGyKpzECb/qrExiOTv
	195SGLh17lSKwXJrD9LSVnaPUFiECf3OZrZ+kR3c3QsvFxbGy+YZsGF0juQQdaQ6izj5etGATm43N
	IAx0NsrloLNl8PKrirvc86J4YATPjI1TI+qBCppEiP/jqbzUf5FdOGHOPdRsLx3cMdGgfM+WvaxZT
	UUN1wrqw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nFFIy-00FIJ7-Fc; Wed, 02 Feb 2022 13:04:12 +0000
Date: Wed, 2 Feb 2022 05:04:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v10 4/9] fsdax: fix function description
Message-ID: <YfqBTDp0XEbExOyy@infradead.org>
References: <20220127124058.1172422-1-ruansy.fnst@fujitsu.com>
 <20220127124058.1172422-5-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127124058.1172422-5-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Dan, can you send this to Linus for 5.17 to get it out of the queue?
