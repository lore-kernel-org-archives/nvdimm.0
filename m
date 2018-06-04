Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DDC392110C803
 for <linux-nvdimm@lists.01.org>; Mon,  4 Jun 2018 07:31:27 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id k5-v6so28588954oiw.0
 for <linux-nvdimm@lists.01.org>; Mon, 04 Jun 2018 07:31:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180604124031.GP19202@dhcp22.suse.cz>
References: <152800336321.17112.3300876636370683279.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180604124031.GP19202@dhcp22.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 4 Jun 2018 07:31:25 -0700
Message-ID: <CAPcyv4gLxz7Ke6ApXoATDN31PSGwTgNRLTX-u1dtT3d+6jmzjw@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] mm: Teach memory_failure() about ZONE_DEVICE
 pages
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
To: Michal Hocko <mhocko@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Souptick Joarder <jrdr.linux@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 4, 2018 at 5:40 AM, Michal Hocko <mhocko@kernel.org> wrote:
> On Sat 02-06-18 22:22:43, Dan Williams wrote:
>> Changes since v1 [1]:
>> * Rework the locking to not use lock_page() instead use a combination of
>>   rcu_read_lock(), xa_lock_irq(&mapping->pages), and igrab() to validate
>>   that dax pages are still associated with the given mapping, and to
>>   prevent the address_space from being freed while memory_failure() is
>>   busy. (Jan)
>>
>> * Fix use of MF_COUNT_INCREASED in madvise_inject_error() to account for
>>   the case where the injected error is a dax mapping and the pinned
>>   reference needs to be dropped. (Naoya)
>>
>> * Clarify with a comment that VM_FAULT_NOPAGE may not always indicate a
>>   mapping of the storage capacity, it could also indicate the zero page.
>>   (Jan)
>>
>> [1]: https://lists.01.org/pipermail/linux-nvdimm/2018-May/015932.html
>>
>> ---
>>
>> As it stands, memory_failure() gets thoroughly confused by dev_pagemap
>> backed mappings. The recovery code has specific enabling for several
>> possible page states and needs new enabling to handle poison in dax
>> mappings.
>>
>> In order to support reliable reverse mapping of user space addresses:
>>
>> 1/ Add new locking in the memory_failure() rmap path to prevent races
>> that would typically be handled by the page lock.
>>
>> 2/ Since dev_pagemap pages are hidden from the page allocator and the
>> "compound page" accounting machinery, add a mechanism to determine the
>> size of the mapping that encompasses a given poisoned pfn.
>>
>> 3/ Given pmem errors can be repaired, change the speculatively accessed
>> poison protection, mce_unmap_kpfn(), to be reversible and otherwise
>> allow ongoing access from the kernel.
>
> This doesn't really describe the problem you are trying to solve and why
> do you believe that HWPoison is the best way to handle it. As things
> stand HWPoison is rather ad-hoc and I am not sure adding more to it is
> really great without some deep reconsidering how the whole thing is done
> right now IMHO. Are you actually trying to solve some real world problem
> or you merely want to make soft offlining work properly?

I'm trying to solve this real world problem when real poison is
consumed through a dax mapping:

        mce: Uncorrected hardware memory error in user-access at af34214200
        {1}[Hardware Error]: It has been corrected by h/w and requires
no further action
        mce: [Hardware Error]: Machine check events logged
        {1}[Hardware Error]: event severity: corrected
        Memory failure: 0xaf34214: reserved kernel page still
referenced by 1 users
        [..]
        Memory failure: 0xaf34214: recovery action for reserved kernel
page: Failed
        mce: Memory error not recovered

...i.e. currently all poison consumed through dax mappings is
needlessly system fatal.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
