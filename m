Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1448907065.25710.0.camel@intel.com>
References: <CALCETrX_9WD=awMKLPoG81+W2K2gzWLSatbZr98w5m5-TujCzA@mail.gmail.com>
 <1448907065.25710.0.camel@intel.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 30 Nov 2015 11:02:04 -0800
Message-ID: <CALCETrWrUeqG2zKuvKSTEqsy=JDnPteHK=m9mhK6NqbsojAWxA@mail.gmail.com>
Subject: Re: Cleaning up e820_pmem?
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 30, 2015 at 10:11 AM, Williams, Dan J
<dan.j.williams@intel.com> wrote:
> On Sun, 2015-11-29 at 22:26 -0800, Andy Lutomirski wrote:
>> My laptop has /sys/devices/platform/e820_pmem and autoloads all the
>> nvdimm infrastructure.  While it would be really cool if my laptop
>> had
>> pmem, that's a bit of a pipe dream right now.  (Even if it did have
>> it, this laptop is brand new -- it should use NFIT, not e820_pmem.)
>>
>> Could we move the iomem_resource loop from drivers/nvdimm/e820.c to
>> arch/x86/kernel/pmem.c and actually list the iomem resources the
>> standard way as resources belonging to the platform device?  That
>> would match accepted practice, and it would keep the grossly
>> x86-specific part of the driver in arch/x86.  Then we could further
>> tweak it to skip creating the platform device at all if there are no
>> resources, and we'd avoid needlessly loading the module.
>>
>> I'd do this myself, except that my lovely machine that *does* support
>> e820 pmem has been repurposed, so testing on a machine that actually
>> supports this turd is awkward for me.
>
> This works for me...
>
> 8<---
> Subject: libnvdimm, e820: skip module loading when no type-12
>
> From: Dan Williams <dan.j.williams@intel.com>
>
> If there are no persistent memory ranges present then don't bother
> creating the platform device.  Otherwise, it loads the full libnvdimm
> sub-system only to discover no resources present.
>
> Reported-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/x86/kernel/pmem.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/arch/x86/kernel/pmem.c b/arch/x86/kernel/pmem.c
> index 4f00b63d7ff3..14415aff1813 100644
> --- a/arch/x86/kernel/pmem.c
> +++ b/arch/x86/kernel/pmem.c
> @@ -4,10 +4,22 @@
>   */
>  #include <linux/platform_device.h>
>  #include <linux/module.h>
> +#include <linux/ioport.h>
> +
> +static int found(u64 start, u64 end, void *data)
> +{
> +       return 1;
> +}
>
>  static __init int register_e820_pmem(void)
>  {
> +       char *pmem = "Persistent Memory (legacy)";
>         struct platform_device *pdev;
> +       int rc;
> +
> +       rc = walk_iomem_res(pmem, IORESOURCE_MEM, 0, -1, NULL, found);
> +       if (rc <= 0)
> +               return 0;
>
>         /*
>          * See drivers/nvdimm/e820.c for the implementation, this is

LGTM.

--Andy
