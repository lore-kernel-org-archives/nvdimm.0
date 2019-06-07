Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 098E521290DFC
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jun 2019 15:07:31 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id w79so2468971oif.10
 for <linux-nvdimm@lists.01.org>; Fri, 07 Jun 2019 15:07:31 -0700 (PDT)
MIME-Version: 1.0
References: <155993563277.3036719.17400338098057706494.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155993564854.3036719.3692507629721494555.stgit@dwillia2-desk3.amr.corp.intel.com>
 <f6c2d673-a202-4ad5-7055-5aaece9356e1@intel.com>
 <CAPcyv4iFG3Z9xL9TSmqLVHxLZ6oiz-uWD6iKgJ8LF4f0n=m9=w@mail.gmail.com>
 <c8b2048e-5e0f-fdbe-1347-4e36de6c0387@intel.com>
In-Reply-To: <c8b2048e-5e0f-fdbe-1347-4e36de6c0387@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 7 Jun 2019 15:07:19 -0700
Message-ID: <CAPcyv4h-LLqmvHfRPYDcvNLexZrEiBcNbui0bz3z1TAydMB0Uw@mail.gmail.com>
Subject: Re: [PATCH v3 03/10] efi: Enumerate EFI_MEMORY_SP
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
Cc: X86 ML <x86@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 7, 2019 at 2:12 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 6/7/19 1:03 PM, Dan Williams wrote:
> >> Separate from these patches, should we have a runtime file that dumps
> >> out the same info?  dmesg isn't always available, and hotplug could
> >> change this too, I'd imagine.
> > Perhaps, but I thought /proc/iomem was that runtime file. Given that
> > x86/Linux only seems to care about the the EFI to E820 translation of
> > the map and the E820 map is directly reflected in /proc/iomem, do we
> > need another file?
>
> Probably not.
>
> I'm just trying to think of ways that we can debug systems where someone
> "loses" a bunch of memory, especially if they're moving from an old
> kernel to a new one with these patches.  From their perspective, they
> just lost a bunch of expensive memory.
>
> Do we owe a pr_info(), perhaps?  Or even a /proc/meminfo entry for how
> much memory these devices own?

We have this existing print when this bit is found:

[    0.023650] e820: update [mem 0x240000000-0x43fffffff] usable ==>
application reserved

...but perhaps /proc/meminfo could grow:

ApplicationReservedOffline
ApplicationReservedOnline

...to show the relative amount of this memory that has been routed to
device-dax and how much has been returned to the core-mm?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
