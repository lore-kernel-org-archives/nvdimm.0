Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305142C80
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 22:41:40 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 309DA61059;
	Wed, 24 Nov 2021 22:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1637793699;
	bh=t6nhrqreNuM33hHGV7qFkDic+ebJMIcuLBmKnL7LpKc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UIzHMyTjfK7aOx71sECnjBZcg/FFu17xVhq3TzirhPfwEOLWm1td6uZ2nCjBD+Scq
	 SLfB5DPnTik6ttlCEgB2GeV6scznAs+BM+FFDjNeYlGSxgmg6G9bUSudfaNcS5TzGF
	 sgP/zl1hMm8raey4FBAELIOtqnSJA3+TPy/0EMHk=
Date: Wed, 24 Nov 2021 14:41:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>, Linux MM <linux-mm@kvack.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Naoya Horiguchi <naoya.horiguchi@nec.com>, Matthew Wilcox
 <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard
 <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>, Muchun Song
 <songmuchun@bytedance.com>, Mike Kravetz <mike.kravetz@oracle.com>,
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Linux
 NVDIMM <nvdimm@lists.linux.dev>, Linux Doc Mailing List
 <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v6 00/10] mm, device-dax: Introduce compound pages in
 devmap
Message-Id: <20211124144137.e8a6fe1b8a2ab05f62e4a6a7@linux-foundation.org>
In-Reply-To: <CAPcyv4jxQTMoz7wnzzspm85o+buD2M+KKuBoHZvn7VEVsCFzsQ@mail.gmail.com>
References: <20211124191005.20783-1-joao.m.martins@oracle.com>
	<CAPcyv4jxQTMoz7wnzzspm85o+buD2M+KKuBoHZvn7VEVsCFzsQ@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 Nov 2021 14:30:56 -0800 Dan Williams <dan.j.williams@intel.com> wrote:

> It might end up colliding with some of the DAX cleanups that are
> brewing, but if that happens I might apply them to resolve conflicts
> and ask Andrew to drop them out of -mm. We can cross that bridge
> later.

Yep, not a problem.
