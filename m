Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87446025
	for <nvdimm@lists.linux.dev>; Tue,  5 Jul 2022 21:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0628BC341C7;
	Tue,  5 Jul 2022 21:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1657055900;
	bh=fVMogeJmga7ig2AqAptnQCM6iwfe/+yH29ZcV4O2RYQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QWun8u4MHhoyUSkwZohNmRQwRv7GVlpNYY4UFDCOICjc5tU5TthBsgHZagQmAbVD1
	 wiE67Q6NMkkaAqzWiUVvGH7ntoTYz1e7WXwoh+M8lHBN8tf/6A+o2eUAi6Cb/J8oDT
	 YHuoio/B5MHzUnlBSZWENzYaWv+N3wQDwVEJ1Atc=
Date: Tue, 5 Jul 2022 14:18:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: willy@infradead.org, jgg@ziepe.ca, jhubbard@nvidia.com,
 william.kucharski@oracle.com, dan.j.williams@intel.com, jack@suse.cz,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: fix missing wake-up event for FSDAX pages
Message-Id: <20220705141819.804eb972d43be3434dc70192@linux-foundation.org>
In-Reply-To: <20220705123532.283-1-songmuchun@bytedance.com>
References: <20220705123532.283-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  5 Jul 2022 20:35:32 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> FSDAX page refcounts are 1-based, rather than 0-based: if refcount is
> 1, then the page is freed.  The FSDAX pages can be pinned through GUP,
> then they will be unpinned via unpin_user_page() using a folio variant
> to put the page, however, folio variants did not consider this special
> case, the result will be to miss a wakeup event (like the user of
> __fuse_dax_break_layouts()).  Since FSDAX pages are only possible get
> by GUP users, so fix GUP instead of folio_put() to lower overhead.
> 

What are the user visible runtime effects of this bug?
