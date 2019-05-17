Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 28C35211F9D4F
 for <linux-nvdimm@lists.01.org>; Fri, 17 May 2019 08:08:39 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id v2so5397609oie.6
 for <linux-nvdimm@lists.01.org>; Fri, 17 May 2019 08:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <155805321833.867447.3864104616303535270.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190517084739.GB20550@quack2.suse.cz>
In-Reply-To: <20190517084739.GB20550@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 May 2019 08:08:27 -0700
Message-ID: <CAPcyv4iZZCgcC657ZOysBP9=1ejp3jfFj=VETVBPrgmfg7xUEw@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
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
To: Jan Kara <jack@suse.cz>
Cc: Jeff Smits <jeff.smits@intel.com>, Matthew Wilcox <willy@infradead.org>, Kees Cook <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 17, 2019 at 1:47 AM Jan Kara <jack@suse.cz> wrote:
>
> Let's add Kees to CC for usercopy expertise...
>
> On Thu 16-05-19 17:33:38, Dan Williams wrote:
> > Jeff discovered that performance improves from ~375K iops to ~519K iops
> > on a simple psync-write fio workload when moving the location of 'struct
> > page' from the default PMEM location to DRAM. This result is surprising
> > because the expectation is that 'struct page' for dax is only needed for
> > third party references to dax mappings. For example, a dax-mapped buffer
> > passed to another system call for direct-I/O requires 'struct page' for
> > sending the request down the driver stack and pinning the page. There is
> > no usage of 'struct page' for first party access to a file via
> > read(2)/write(2) and friends.
> >
> > However, this "no page needed" expectation is violated by
> > CONFIG_HARDENED_USERCOPY and the check_copy_size() performed in
> > copy_from_iter_full_nocache() and copy_to_iter_mcsafe(). The
> > check_heap_object() helper routine assumes the buffer is backed by a
> > page-allocator DRAM page and applies some checks.  Those checks are
> > invalid, dax pages are not from the heap, and redundant,
> > dax_iomap_actor() has already validated that the I/O is within bounds.
>
> So this last paragraph is not obvious to me as check_copy_size() does a lot
> of various checks in CONFIG_HARDENED_USERCOPY case. I agree that some of
> those checks don't make sense for PMEM pages but I'd rather handle that by
> refining check_copy_size() and check_object_size() functions to detect and
> appropriately handle pmem pages rather that generally skip all the checks
> in pmem_copy_from/to_iter(). And yes, every check in such hot path is going
> to cost performance but that's what user asked for with
> CONFIG_HARDENED_USERCOPY... Kees?

As far as I can see it's mostly check_heap_object() that is the
problem, so I'm open to finding a way to just bypass that sub-routine.
However, as far as I can see none of the other block / filesystem user
copy implementations submit to the hardened checks, like
bio_copy_from_iter(), and iov_iter_copy_from_user_atomic() . So,
either those need to grow additional checks, or the hardened copy
implementation is targeting single object copy use cases, not
necessarily block-I/O. Yes, Kees, please advise.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
