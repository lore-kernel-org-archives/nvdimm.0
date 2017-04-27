Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x244.google.com (mail-wm0-x244.google.com
 [IPv6:2a00:1450:400c:c09::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 45FFD21951CA6
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 23:30:59 -0700 (PDT)
Received: by mail-wm0-x244.google.com with SMTP id z129so2324100wmb.1
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 23:30:59 -0700 (PDT)
Date: Thu, 27 Apr 2017 08:30:54 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH] x86, uaccess, pmem: introduce
 copy_from_iter_writethru for dax + pmem
Message-ID: <20170427063054.soejyqocqqrihfdw@gmail.com>
References: <20170425012230.GX29622@ZenIV.linux.org.uk>
 <149324377946.28224.12306514223331326459.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149324377946.28224.12306514223331326459.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, viro@zeniv.linux.org.uk, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>


* Dan Williams <dan.j.williams@intel.com> wrote:

> +#ifdef CONFIG_ARCH_HAS_UACCESS_WRITETHRU
> +#define __HAVE_ARCH_MEMCPY_WRITETHRU 1
> +void memcpy_writethru(void *dst, const void *src, size_t cnt);
> +#endif

This should be named memcpy_wt(), which is the well-known postfix for 
write-through.

We already have ioremap_wt(), set_memory_wt(), etc. - no need to introduce a 
longer variant with uncommon spelling.

Thanks,

	Ingo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
