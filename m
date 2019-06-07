Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 48A202128DD57
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jun 2019 13:37:19 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id z24so3080869oto.1
 for <linux-nvdimm@lists.01.org>; Fri, 07 Jun 2019 13:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <155993563277.3036719.17400338098057706494.stgit@dwillia2-desk3.amr.corp.intel.com>
 <86a49d1a-678e-5e86-180b-e48326d1bdb5@intel.com>
In-Reply-To: <86a49d1a-678e-5e86-180b-e48326d1bdb5@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 7 Jun 2019 13:37:08 -0700
Message-ID: <CAPcyv4gvToqPXSy5MKXOX=HvFP2R0F_6DY3qUiagQEKk84BKpg@mail.gmail.com>
Subject: Re: [PATCH v3 00/10] EFI Specific Purpose Memory Support
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
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, kbuild test robot <lkp@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Matthew Wilcox <willy@infradead.org>, Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@infradead.org>, Len Brown <lenb@kernel.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Thomas Gleixner <tglx@linutronix.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Shevchenko <andy@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 7, 2019 at 12:57 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 6/7/19 12:27 PM, Dan Williams wrote:
> > In support of optionally allowing either application-exclusive and
> > core-kernel-mm managed access to differentiated memory, claim
> > EFI_MEMORY_SP ranges for exposure as device-dax instances by default.
> > Such instances can be directly owned / mapped by a
> > platform-topology-aware application. Alternatively, with the new kmem
> > facility [4], the administrator has the option to instead designate that
> > those memory ranges be hot-added to the core-kernel-mm as a unique
> > memory numa-node. In short, allow for the decision about what software
> > agent manages specific-purpose memory to be made at runtime.
>
> It's probably worth noting that the reason the memory lands into the
> state of being controlled by device-dax by default is that device-dax is
> nice.  It's actually willing and able to give up ownership of the memory
> when we ask.  If we added to the core-mm, we'd almost certainly not be
> able to get it back reliably.
>
> Anyway, thanks for doing these, and I really hope that the world's
> BIOSes actually use this flag.

It should be noted that the flag is necessary, but not sufficient to
route this memory range to device-dax. The BIOS must also publish ACPI
HMAT performance data for the range so the OS has a chance of knowing
*why* the memory is "reserved for a specific purpose", and delineate
the boundaries of multiple performance differentiated memory ranges
that might be combined into one shared / contiguous EFI memory
descriptor.

With no HMAT the memory will be reserved, but no dax-device will be
surfaced. Perhaps this implementation also needs a WARN_TAINT(...,
TAINT_FIRMWARE_WORKAROUND...) to scream about a BIOS that fails to
publish the required HMAT entries, or perhaps even better a command
line option to ignore the flag so that the core-mm can pick up the
memory by default?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
