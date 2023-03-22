Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A781BA53
	for <nvdimm@lists.linux.dev>; Wed, 22 Mar 2023 23:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3C5C433D2;
	Wed, 22 Mar 2023 23:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1679526757;
	bh=Z3s7pGu/ZPmhYfb4tbtIIOF0PXFxa6xDdetvTA1CXgY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HhkXw7aNQvuFo2gctIW+ghEbcHnEIlLThjR/eotpElfvBsN+HOlo6aFDIUSukd0vI
	 dc5g3YPtIFkAWZ18wzgo5rm6rT28RCqdQbrj2CoU4kRkQANg1TXH45I1LAAOiJooEF
	 57nk/Z+uul83TgfBy7KzCofk+W+dM5jn+YE6b9mY=
Date: Wed, 22 Mar 2023 16:12:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
 <dan.j.williams@intel.com>, <willy@infradead.org>, <jack@suse.cz>
Subject: Re: [PATCH] fsdax: dedupe should compare the min of two iters'
 length
Message-Id: <20230322161236.f90c21c8f668f551ee19d80b@linux-foundation.org>
In-Reply-To: <1679469958-2-1-git-send-email-ruansy.fnst@fujitsu.com>
References: <1679469958-2-1-git-send-email-ruansy.fnst@fujitsu.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 Mar 2023 07:25:58 +0000 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:

> In an dedupe corporation iter loop, the length of iomap_iter decreases
> because it implies the remaining length after each iteration.  The
> compare function should use the min length of the current iters, not the
> total length.

Please describe the user-visible runtime effects of this flaw, thanks.
