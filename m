Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDA81FDF
	for <nvdimm@lists.linux.dev>; Wed, 22 Mar 2023 23:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2CFC433EF;
	Wed, 22 Mar 2023 23:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1679526192;
	bh=zWqBbICixZh42505PIhrge5VLeLMCTCIFQuij+rAoTc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cp9/n/fn3sGbnyVcj6W2RTwOg5hx92YMGiUQDNRJhq/U/htA/4Rhx22bbXq6a8Dyv
	 Frn06TyBMmDq8TwF/oOq4upm6cZqLnn+Iuoot+2yToP+2sysKu49gb5YWY3ScbaVY6
	 z7NVJ9y2P34GXQf+xtFekOCbIYc4uVKhihq4l3Ok=
Date: Wed, 22 Mar 2023 16:03:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
 <dan.j.williams@intel.com>, <willy@infradead.org>, <jack@suse.cz>,
 <djwong@kernel.org>
Subject: Re: [PATCH] fsdax: unshare: zero destination if srcmap is HOLE or
 UNWRITTEN
Message-Id: <20230322160311.89efea3493db4c4ccad40a25@linux-foundation.org>
In-Reply-To: <1679483469-2-1-git-send-email-ruansy.fnst@fujitsu.com>
References: <1679483469-2-1-git-send-email-ruansy.fnst@fujitsu.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 Mar 2023 11:11:09 +0000 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:

> unshare copies data from source to destination. But if the source is
> HOLE or UNWRITTEN extents, we should zero the destination, otherwise the
> result will be unexpectable.

Please provide much more detail on the user-visible effects of the bug.
For example, are we leaking kernel memory contents to userspace?

Thanks.


