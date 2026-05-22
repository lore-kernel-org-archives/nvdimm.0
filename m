Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663AD24E4C3;
	Fri, 22 May 2026 00:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779410245; cv=none; b=jMkJlAkjym/5QT2YBbq25OfUZyNAPc7EuTalee8JBLkGLntx0wZd5Bu6POwRZxNfZ6wpgxiK3n/vlMlpBYNmkq+kiR7P8wZUutP7tdO3HBps3wEE0iJDONfzPYW7eZL65ffXQX9u8Jyn0344BOP+BDH6ehK53t3numaTcCyiVYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779410245; c=relaxed/simple;
	bh=PQlWfCYvLnhIfnTG3bXKLYMYsmGiuaS1LK0za3FsnpA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=U0lm2cZn23xYI50idSS23vLntzWdLCPLhKp/lumNc5KAPc5dNGStkRc0s0xBIZm6wxQvEhhsz6hCe2TBibRChh2ru+A7+LoZHSq/kFNFHJz+kR9lF2Zk/0kH+KRU4G6uQIJHcCDTYWpqftvxdxyiIhZ3jMNEfOjdCKjra74Hecw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z5SgS/6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z5SgS/6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876041F000E9;
	Fri, 22 May 2026 00:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779410244;
	bh=vb/NSjxWzcfzykw7RUnxGmgm9FcNB+S5bWotyUmGLbs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=z5SgS/6Scs6gzwAzXAZZj1I45LFxR/DzznVoUZCb+cdL3nccZjKp7KpekCUjegkEd
	 /20d6Ebtmf0sLshuUdhOu+VOqnZDAk67uMPWyLjF8bNcvmYBlxAW2ifoZUHhoXwIQo
	 x9V50ZEJUNAglos3nfAHHnv0vxWhBq3joMNAgv6I=
Date: Thu, 21 May 2026 17:37:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Juhyung Park
 <qkrwngud825@gmail.com>, linux-mm@kvack.org, stable@vger.kernel.org, Lu
 Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dan Williams <djbw@kernel.org>, Dave Jiang
 <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
Message-Id: <20260521173723.ab1637d13848fcd2738be480@linux-foundation.org>
In-Reply-To: <78ef8003-9c86-4969-95b9-589127b30be2@intel.com>
References: <20260519151008.1399226-1-qkrwngud825@gmail.com>
	<e9a08bed-3d5f-4606-8d17-80a16a4c82f1@kernel.org>
	<CAD14+f316+wMZNm_sJF6ULRDUD9EbkdecdDwhGQKcsu70Bdp0w@mail.gmail.com>
	<9c0e3e53-d284-4675-89d8-943f93436e07@kernel.org>
	<78ef8003-9c86-4969-95b9-589127b30be2@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 20 May 2026 14:54:30 -0700 Dave Hansen <dave.hansen@intel.com> wrote:

> On 5/20/26 14:52, David Hildenbrand (Arm) wrote:
> > On 5/20/26 12:33, Juhyung Park wrote:
> >> Neat. Any sign of it getting merged?
> > I hope it will catch the attention of more x86 maintainers soon 🙂
> 
> David, thanks a ton for that patch. It's in the queue behind a couple of
> other things, but I'll definitely take a look.
> 
> Attention caught, I promise! ;)

Oh, there it is.  I'll add a note to my copy reminding myself that
it'll be upstreamed via the x86 tree.
