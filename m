Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 970732097215B
 for <linux-nvdimm@lists.01.org>; Mon,  4 Jun 2018 10:39:49 -0700 (PDT)
Received: by mail-ot0-x241.google.com with SMTP id n1-v6so38676216otf.7
 for <linux-nvdimm@lists.01.org>; Mon, 04 Jun 2018 10:39:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180604170801.GA17234@agluck-desk>
References: <152800336321.17112.3300876636370683279.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152800340082.17112.1154560126059273408.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180604170801.GA17234@agluck-desk>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 4 Jun 2018 10:39:48 -0700
Message-ID: <CAPcyv4g76nv=D2NXrpFLS-aWQR=N0T2n01WhrVY2_KPavkvLCA@mail.gmail.com>
Subject: Re: [PATCH v2 07/11] x86, memory_failure: Introduce {set,
 clear}_mce_nospec()
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Linux MM <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 4, 2018 at 10:08 AM, Luck, Tony <tony.luck@intel.com> wrote:
> On Sat, Jun 02, 2018 at 10:23:20PM -0700, Dan Williams wrote:
>> +static inline int set_mce_nospec(unsigned long pfn)
>> +{
>> +     int rc;
>> +
>> +     rc = set_memory_uc((unsigned long) __va(PFN_PHYS(pfn)), 1);
>
> You should really do the decoy_addr thing here that I had in mce_unmap_kpfn().
> Putting the virtual address of the page you mustn't accidentally prefetch
> from into a register is a pretty good way to make sure that the processor
> does do a prefetch.

Maybe I'm misreading, but doesn't that make the page completely
inaccessible? We still want to read pmem through the driver and the
linear mapping with memcpy_mcsafe(). Alternatively I could just drop
this patch and setup a private / alias mapping for the pmem driver to
use. It seems aliased mappings would be the safer option, but I want
to make sure I've comprehended your suggestion correctly?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
