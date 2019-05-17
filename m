Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com
 [IPv6:2607:f8b0:4864:20::642])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A055621BC6A80
 for <linux-nvdimm@lists.01.org>; Fri, 17 May 2019 08:56:54 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id r18so3524426pls.13
 for <linux-nvdimm@lists.01.org>; Fri, 17 May 2019 08:56:54 -0700 (PDT)
Date: Fri, 17 May 2019 08:56:52 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
Message-ID: <201905170855.8E2E1AC616@keescook>
References: <155805321833.867447.3864104616303535270.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190517084739.GB20550@quack2.suse.cz>
 <CAPcyv4iZZCgcC657ZOysBP9=1ejp3jfFj=VETVBPrgmfg7xUEw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iZZCgcC657ZOysBP9=1ejp3jfFj=VETVBPrgmfg7xUEw@mail.gmail.com>
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
Cc: Jeff Smits <jeff.smits@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 17, 2019 at 08:08:27AM -0700, Dan Williams wrote:
> As far as I can see it's mostly check_heap_object() that is the
> problem, so I'm open to finding a way to just bypass that sub-routine.
> However, as far as I can see none of the other block / filesystem user
> copy implementations submit to the hardened checks, like
> bio_copy_from_iter(), and iov_iter_copy_from_user_atomic() . So,
> either those need to grow additional checks, or the hardened copy
> implementation is targeting single object copy use cases, not
> necessarily block-I/O. Yes, Kees, please advise.

The intention is mainly for copies that haven't had explicit bounds
checking already performed on them, yes. Is there something getting
checked out of the slab, or is it literally just the overhead of doing
the "is this slab?" check that you're seeing?

-- 
Kees Cook
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
