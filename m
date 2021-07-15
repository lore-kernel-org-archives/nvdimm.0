Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760E872
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 06:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tu3LPaeNc/cjHdnxmndHXHDt0Qs5FRSDN7OvE4dRBvY=; b=SIWrtbcZB+IGv8e7rHuJmqhP2c
	RujBGejgN7XAqwaJ5SkADksYPEkhLzVBBllC7yuLqojfRUWrv75d/zX2gLkHZLHFvcERxvEFsbO/M
	jj2/+GJ64vufUcbTpdD8168xkdLJc4n1vb1HeIr6aT0DoFKvLYPjEo7VtIaVisKK7hwR5a9QmumyL
	qzL4GuONfd8yZFe1jzUeNL8Z7O7/H/aeykxlQLaQ0GsiI3FK065X0j5hZMKyLg++BTmPBP3DxyJoz
	qB+nIV7+aFK1oYkHAOmydq9P1QQ8AxEFldUTgmUIAHw/JVezm2twPAVSgPuCMQxAP9Zk7sRUPezU1
	ddJ3sRFA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m3v3A-00343f-Vb; Thu, 15 Jul 2021 06:41:10 +0000
Date: Thu, 15 Jul 2021 07:40:48 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Joao Martins <joao.m.martins@oracle.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Jane Chu <jane.chu@oracle.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [External] [PATCH v3 01/14] memory-failure: fetch compound_head
 after pgmap_pfn_valid()
Message-ID: <YO/YcBTzKTzzNUfK@infradead.org>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-2-joao.m.martins@oracle.com>
 <CAMZfGtWhx71w0b4FM_t2LCK-q1+ePv6YQtQat+9FozLPnN4x3Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZfGtWhx71w0b4FM_t2LCK-q1+ePv6YQtQat+9FozLPnN4x3Q@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Can you please fix up your mailer to not mess with the subject?
That makes the thread completely unreadable.
