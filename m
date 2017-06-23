Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C06F221BBC431
 for <linux-nvdimm@lists.01.org>; Thu, 22 Jun 2017 22:05:53 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id c189so20018916oia.2
 for <linux-nvdimm@lists.01.org>; Thu, 22 Jun 2017 22:07:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F612DCCAF@ORSMSX114.amr.corp.intel.com>
References: <20170616190200.6210-1-tony.luck@intel.com>
 <20170621021226.GA18024@hori1.linux.bs1.fc.nec.co.jp>
 <20170621175403.n5kssz32e2oizl7k@intel.com>
 <AT5PR84MB0082AF4EDEB05999494CA62FABDA0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
 <3908561D78D1C84285E8C5FCA982C28F612DCCAF@ORSMSX114.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Jun 2017 22:07:18 -0700
Message-ID: <CAPcyv4igNoRZ1EJxeD01xwq5AU_hhEs4LoXs-8XA2mFbWDr5eA@mail.gmail.com>
Subject: Re: [PATCH] mm/hwpoison: Clear PRESENT bit for kernel 1:1 mappings of
 poison pages
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
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Vaden, Tom (HPE Server OS Architecture)" <tom.vaden@hpe.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Hansen, Dave  <dave.hansen@intel.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Borislav Petkov" <bp@suse.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 21, 2017 at 1:30 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> Persistent memory does have unpoisoning and would require this inverse
>> operation - see drivers/nvdimm/pmem.c pmem_clear_poison() and core.c
>> nvdimm_clear_poison().
>
> Nice.  Well this code will need to cooperate with that ... in particular if the page
> is in an area that can be unpoisoned ... then we should do that *instead* of marking
> the page not present (which breaks up huge/large pages and so affects performance).
>
> Instead of calling it "arch_unmap_pfn" it could be called something like arch_handle_poison()
> and do something like:
>
> void arch_handle_poison(unsigned long pfn)
> {
>         if this is a pmem page && pmem_clear_poison(pfn)
>                 return
>         if this is a nvdimm page && nvdimm_clear_poison(pfn)
>                 return
>         /* can't clear, map out from 1:1 region */
>         ... code from my patch ...
> }
>
> I'm just not sure how those first two "if" bits work ... particularly in terms of CONFIG dependencies and system
> capabilities.  Perhaps each of pmem and nvdimm could register their unpoison functions and this code could
> just call each in turn?

We don't unpoison pmem without new data to write in it's place. What
context is arch_handle_poison() called? Ideally we only "clear" poison
when we know we are trying to write zero over the poisoned range.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
