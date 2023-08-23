Received: from out-50.mta1.migadu.com (out-50.mta1.migadu.com [95.215.58.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E04C17D4
	for <nvdimm@lists.linux.dev>; Wed, 23 Aug 2023 05:51:36 +0000 (UTC)
Date: Wed, 23 Aug 2023 14:51:25 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1692769894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Odcs+La8W+25TkUt+K6RaKD9ziJuPvmXdjnVRwvJfgg=;
	b=i1dp7p1lPp5w4+E7nyecWifJW/+v6fvRHu8j1S8oRc9lKaVWbUNrSjV5OOTmFc+jmCOaiP
	N5V+/ZadtchHoABOVuUrFQ0a7VYtt4F14NmH05FDiOgq3jR5XJpPNtzvFPfnT/fsGhuIt2
	jpLmcpTcIK+ReDltwc3hCgkSrao5bxI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Naoya Horiguchi <naoya.horiguchi@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Convert DAX lock/unlock page to lock/unlock folio
Message-ID: <20230823055125.GA3216577@ik1-406-35019.vs.sakura.ne.jp>
References: <20230822231314.349200-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230822231314.349200-1-willy@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 23, 2023 at 12:13:14AM +0100, Matthew Wilcox (Oracle) wrote:
> The one caller of DAX lock/unlock page already calls compound_head(),
> so use page_folio() instead, then use a folio throughout the DAX code
> to remove uses of page->mapping and page->index.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks like straightforward replacement, so I found no issue.

Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
