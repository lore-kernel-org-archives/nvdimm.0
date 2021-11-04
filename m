Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC242C8B
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 17:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Wm7HH7oeUOYnXc3PtTYetZcfrk
	Nu0z4OEjT5QscgmkSbjP7OW5shwWG52n3nyGWqhDRazp2ncYeBJ+GISxHsAlaG5yNJYpSTcFYslh0
	Uo+KYvslb6PEFyIaZNa9fln6usRC2VmwyS8muOWIYztwN055cq81UvbdJQpm2TOobrPSrwX+QFKAM
	Jnb8300AR49JE2khtwTmKXFEQIwEs+BWcIkjxnF86GutadiM0EjX8FHPZh9RGacd/MM4Fxe+/TNfC
	SH9MvC0TlLKzI+UrPZq4BPqhCT5q3G98Z25l2gog5+x6YJS55hVJPmCxrXOCWV/V16IlbW9cQarst
	ZHMEpG5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1migvE-009iuC-7t; Thu, 04 Nov 2021 17:53:08 +0000
Date: Thu, 4 Nov 2021 10:53:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, viro@zeniv.linux.org.uk,
	willy@infradead.org, jack@suse.cz, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] dax: introduce dax_operation dax_clear_poison
Message-ID: <YYQeBM40BaZZGARU@infradead.org>
References: <20210914233132.3680546-1-jane.chu@oracle.com>
 <20210914233132.3680546-2-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914233132.3680546-2-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
