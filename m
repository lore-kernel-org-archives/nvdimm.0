Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1D51B76
	for <nvdimm@lists.linux.dev>; Sat,  5 Mar 2022 16:19:22 +0000 (UTC)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 477DE2C0;
	Sat,  5 Mar 2022 16:19:16 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 477DE2C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1646497156; bh=wbmSN0XAWd/p5Obom7aNHflhn4a2z3r19rCRcNA/yjU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=FycWCprH4PjyR41XCWGQOpDj1/UCaMiTPKyW0+rKcCkuBs7wgUsuTvaP30bs+rDnm
	 4sobDfotD1bWr4loohaBxiabDp8/G59IFU+o1niWZr5pqimk5aKpQVxilDbK6SoYqA
	 7X/72G/JZk4aTde3COzU08X5FhrIFzrJmm8pMo+ieWuZgj6LGEl8BpAGayJHGf9Gis
	 vMbzeWuq2MgMw78KHH4rzJJtPOG/t8UT4QF37sl3ifRwXPpNxmpqI538zYzIDufs54
	 XsrOWcJrooHwZvjkhHvwUOPAJNj46uRQ96n+olyb2f4OWbB9vlzZSWCTWTLBrLlYgS
	 JOhMXpFraxZKw==
From: Jonathan Corbet <corbet@lwn.net>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, Muchun Song
 <songmuchun@bytedance.com>, Mike Kravetz <mike.kravetz@oracle.com>, Andrew
 Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
 nvdimm@lists.linux.dev, linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 3/5] mm/hugetlb_vmemmap: move comment block to
 Documentation/vm
In-Reply-To: <9928f476-baa7-68b8-ed82-2b37d48a10a6@oracle.com>
References: <20220303213252.28593-1-joao.m.martins@oracle.com>
 <20220303213252.28593-4-joao.m.martins@oracle.com>
 <87r17hhhfr.fsf@meer.lwn.net>
 <9928f476-baa7-68b8-ed82-2b37d48a10a6@oracle.com>
Date: Sat, 05 Mar 2022 09:19:15 -0700
Message-ID: <87r17ge5j0.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Joao Martins <joao.m.martins@oracle.com> writes:

>>> +HugeTLB pages consist of multiple base page size pages and is supported by
>>> +many architectures. See hugetlbpage.rst in the Documentation directory for
>
> While at it, I'll replace hugetlbpage.rst in the Documentation directory to be:
>
> See :ref:`Documentation/vm/hugetlbpage.rst <hugetlbpage>` for more details.

You can make that just:

	See Documentation/vm/hugetlbpage.rst for more details

...and the Right Thing will happen.

Otherwise looks good.

Thanks,

jon
