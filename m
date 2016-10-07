Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5182B1A1E2A
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 10:08:51 -0700 (PDT)
Date: Fri, 7 Oct 2016 18:08:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] use a nocache copy for bvecs in copy_from_iter_nocache()
Message-ID: <20161007170842.GQ19539@ZenIV.linux.org.uk>
References: <20161007155511.21502-1-brian.boylston@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161007155511.21502-1-brian.boylston@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Brian Boylston <brian.boylston@hpe.com>
Cc: linux-nvdimm@lists.01.org, oliver.moreno@hpe.com, x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 07, 2016 at 10:55:11AM -0500, Brian Boylston wrote:
> copy_from_iter_nocache() is only "nocache" for iovecs.  Enhance it to also
> use a nocache copy for bvecs.  This improves performance by 2-3X when
> splice()ing to a file in a DAX-mounted, pmem-backed file system.

> +static void memcpy_from_page_nocache(char *to, struct page *page, size_t offset, size_t len)
> +{
> +	char *from = kmap_atomic(page);
> +	__copy_from_user_inatomic_nocache(to, from, len);
> +	kunmap_atomic(from);
> +}

At the very least, it will blow up on any architecture with split
userland and kernel MMU contexts.  You *can't* feed a kernel pointer
to things like that and expect it to work.  At the very least, you
need to add memcpy_nocache() and have it default to memcpy(), with
non-dummy version on x86.  And use _that_, rather than messing with
__copy_from_user_inatomic_nocache()
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
