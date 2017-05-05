Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x236.google.com (mail-it0-x236.google.com
 [IPv6:2607:f8b0:4001:c0b::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2581121A18AAB
 for <linux-nvdimm@lists.01.org>; Fri,  5 May 2017 07:12:06 -0700 (PDT)
Received: by mail-it0-x236.google.com with SMTP id x188so5842616itb.0
 for <linux-nvdimm@lists.01.org>; Fri, 05 May 2017 07:12:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170505065404.llj4ym3thrmmlhyo@gmail.com>
References: <20170427063054.soejyqocqqrihfdw@gmail.com>
 <149340820800.28724.16189291963486607562.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170505065404.llj4ym3thrmmlhyo@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 5 May 2017 07:12:03 -0700
Message-ID: <CAPcyv4j=8cR-=73Nbz1VKd2MiZ5eT=gp1rWS14EJmSzY=u6VWw@mail.gmail.com>
Subject: Re: [PATCH v2] x86, uaccess: introduce copy_from_iter_wt for pmem /
 writethrough operations
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
To: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 4, 2017 at 11:54 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Dan Williams <dan.j.williams@intel.com> wrote:
>
>> The pmem driver has a need to transfer data with a persistent memory
>> destination and be able to rely on the fact that the destination writes
>> are not cached. It is sufficient for the writes to be flushed to a
>> cpu-store-buffer (non-temporal / "movnt" in x86 terms), as we expect
>> userspace to call fsync() to ensure data-writes have reached a
>> power-fail-safe zone in the platform. The fsync() triggers a REQ_FUA or
>> REQ_FLUSH to the pmem driver which will turn around and fence previous
>> writes with an "sfence".
>>
>> Implement a __copy_from_user_inatomic_wt, memcpy_page_wt, and memcpy_wt,
>> that guarantee that the destination buffer is not dirty in the cpu cache
>> on completion. The new copy_from_iter_wt and sub-routines will be used
>> to replace the "pmem api" (include/linux/pmem.h +
>> arch/x86/include/asm/pmem.h). The availability of copy_from_iter_wt()
>> and memcpy_wt() are gated by the CONFIG_ARCH_HAS_UACCESS_WT config
>> symbol, and fallback to copy_from_iter_nocache() and plain memcpy()
>> otherwise.
>>
>> This is meant to satisfy the concern from Linus that if a driver wants
>> to do something beyond the normal nocache semantics it should be
>> something private to that driver [1], and Al's concern that anything
>> uaccess related belongs with the rest of the uaccess code [2].
>>
>> [1]: https://lists.01.org/pipermail/linux-nvdimm/2017-January/008364.html
>> [2]: https://lists.01.org/pipermail/linux-nvdimm/2017-April/009942.html
>>
>> Cc: <x86@kernel.org>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Jeff Moyer <jmoyer@redhat.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Matthew Wilcox <mawilcox@microsoft.com>
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>> Changes since the initial RFC:
>> * s/writethru/wt/ since we already have ioremap_wt(), set_memory_wt(),
>>   etc. (Ingo)
>
> Looks good to me. I suspect you'd like to carry this in the nvdimm tree?
>
> Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks, Ingo!. Yes, I'll carry it in nvdimm.git for 4.13.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
