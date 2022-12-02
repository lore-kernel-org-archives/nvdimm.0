Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0CCEA2
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 00:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7AFC433D6;
	Fri,  2 Dec 2022 00:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1669941570;
	bh=rRla3WD1t6c5uPu2w5Yjfhg4lc18eD2qbBTVmaDIASE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=d11f2HoAOPHkMupwCxvr8N4gFdCqA2nDVBUuNVJNKsPpcwu/qRpcAC3kgId3jJ+Ux
	 +XYLKR4qSoFJNi5/3n9O5u6v9QkDGivEKRTlNpnQdKJQrSAJt+qkr03Hqaq9LjsH99
	 qBMLCpiOIBQ/91h886TAbxuT0h3BFCCyjhshN0Zo=
Date: Thu, 1 Dec 2022 16:39:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, david@fromorbit.com,
 dan.j.williams@intel.com
Subject: Re: [PATCH v2 3/8] fsdax: zero the edges if source is HOLE or
 UNWRITTEN
Message-Id: <20221201163929.ddd992063d9872ab33459bbf@linux-foundation.org>
In-Reply-To: <Y4k/kxuPOirdlctI@magnolia>
References: <1669908538-55-1-git-send-email-ruansy.fnst@fujitsu.com>
	<1669908538-55-4-git-send-email-ruansy.fnst@fujitsu.com>
	<Y4k/kxuPOirdlctI@magnolia>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 1 Dec 2022 15:58:11 -0800 "Darrick J. Wong" <djwong@kernel.org> wrote:

> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -1092,7 +1092,7 @@ static int dax_iomap_direct_access(const struct iomap *iomap, loff_t pos,
> >  }
> >  
> >  /**
> > - * dax_iomap_cow_copy - Copy the data from source to destination before write
> > + * dax_iomap_copy_around - Copy the data from source to destination before write
> 
>  * dax_iomap_copy_around - Prepare for an unaligned write to a
>  * shared/cow page by copying the data before and after the range to be
>  * written.

Thanks, I added this:

--- a/fs/dax.c~fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix
+++ a/fs/dax.c
@@ -1092,7 +1092,8 @@ out:
 }
 
 /**
- * dax_iomap_copy_around - Copy the data from source to destination before write
+ * dax_iomap_copy_around - Prepare for an unaligned write to a shared/cow page
+ * by copying the data before and after the range to be written.
  * @pos:	address to do copy from.
  * @length:	size of copy operation.
  * @align_size:	aligned w.r.t align_size (either PMD_SIZE or PAGE_SIZE)
_

