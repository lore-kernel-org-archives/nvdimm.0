Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1B4431A1E8B
 for <linux-nvdimm@lists.01.org>; Fri, 14 Oct 2016 07:15:04 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id d132so138135678oib.2
 for <linux-nvdimm@lists.01.org>; Fri, 14 Oct 2016 07:15:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <147629530854.10618.10383744751594021268.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147629530854.10618.10383744751594021268.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Oct 2016 07:15:02 -0700
Message-ID: <CAPcyv4ix3h-7WN36JCmD_X5TN3t63Rqjz6tGgHgEditVVK1Kig@mail.gmail.com>
Subject: Re: [PATCH] x86/e820: don't merge consecutive E820_PRAM ranges
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 12, 2016 at 11:01 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> Commit 917db484dc6a "x86/boot: Fix kdump, cleanup aborted E820_PRAM
> max_pfn manipulation" fixed up the broken manipulations of max_pfn in
> the presence of E820_PRAM ranges. However, it also broke the
> sanitize_e820_map() support for not merging E820_PRAM ranges.
> Re-introduce the enabling to keep resource boundaries between
> consecutive defined ranges. Otherwise, for example, an environment that
> boots with memmap=2G!8G,2G!10G will end up with a single 4G /dev/pmem0
> device instead of a /dev/pmem0 and /dev/pmem1 device 2G in size.
>
> Cc: <stable@vger.kernel.org>
> Cc: Zhang Yi <yizhan@redhat.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Reported-by: Dave Chinner <david@fromorbit.com>
> Fixes: 917db484dc6a ("x86/boot: Fix kdump, cleanup aborted E820_PRAM max_pfn manipulation")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/x86/kernel/e820.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index b85fe5f91c3f..90e8dde3ec26 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -350,7 +350,7 @@ int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
>                  * continue building up new bios map based on this
>                  * information
>                  */
> -               if (current_type != last_type) {
> +               if (current_type != last_type || current_type == E820_PRAM) {
>                         if (last_type != 0)      {
>                                 new_bios[new_bios_entry].size =
>                                         change_point[chgidx]->addr - last_addr;
>

Hi Ingo, can you grab this one for 4.9-rc1?  The regression is now
making its way to the -stable branches, so this fix is needed there
now as well.

Let me know, I can also just take it through libnvdimm.git with an ack.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
