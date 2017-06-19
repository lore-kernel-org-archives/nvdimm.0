Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AE89221C8F608
 for <linux-nvdimm@lists.01.org>; Sun, 18 Jun 2017 19:01:34 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id b6so47002889oia.1
 for <linux-nvdimm@lists.01.org>; Sun, 18 Jun 2017 19:02:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170618082841.GA26456@lst.de>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703983098.20620.14791162611225792317.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170618082841.GA26456@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 18 Jun 2017 19:02:54 -0700
Message-ID: <CAPcyv4iLtL5bJbxcLYwkJzTPk69Fam8xHdpdyGYPgNqNUC9qbQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/14] x86, uaccess: introduce copy_from_iter_flushcache
 for pmem / cache-bypass operations
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, dm-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jun 18, 2017 at 1:28 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Jun 09, 2017 at 01:23:51PM -0700, Dan Williams wrote:
>> Implement a __copy_from_user_inatomic_flushcache, memcpy_page_flushcache, and
>> memcpy_flushcache, that guarantee that the destination buffer is not dirty in
>> the cpu cache on completion. The new copy_from_iter_flushcache and sub-routines
>
> Wouldn't writethrough be a better name?

I started with _writethrough, Ingo suggested _wt, and then Toshi
rightly pointed out that _wt might lead applications to assume that
the involved cache-lines are valid on return which may not be true. So
we settled on _flushcache in this thread [1].

[1]: https://lkml.org/lkml/2017/5/6/99

>> will be used to replace the "pmem api" (include/linux/pmem.h +
>> arch/x86/include/asm/pmem.h). The availability of copy_from_iter_flushcache()
>> and memcpy_flushcache() are gated by the CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
>> config symbol, and fallback to copy_from_iter_nocache() and plain memcpy()
>> otherwise.
>
> What is UACCESS about memcpy_flushcache?

The uaccess part comes from the fact that the conversion provides all
the _flushcache versions of the copy_from_iter() operations
(__copy_from_user_flushcache, memcpy_page_flushcache,
memcpy_flushcache). It also stems from Al asking that
__copy_user_flushcache() live in arch/x86/lib/usercopy_64.c. That
said, I wouldn't object to a different name for the config symbol.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
