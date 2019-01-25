Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com
 [IPv6:2a00:1450:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C59FF211BA456
 for <linux-nvdimm@lists.01.org>; Fri, 25 Jan 2019 13:19:02 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id y139so8013800wmc.5
 for <linux-nvdimm@lists.01.org>; Fri, 25 Jan 2019 13:19:02 -0800 (PST)
MIME-Version: 1.0
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190124231444.38182DD8@viggo.jf.intel.com>
In-Reply-To: <20190124231444.38182DD8@viggo.jf.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 25 Jan 2019 15:18:49 -0600
Message-ID: <CAErSpo4oSjQAxeRy8Tz_Jvo+cRovBvVx9WBeNb_P6PxT-A_XhA@mail.gmail.com>
Subject: Re: [PATCH 2/5] mm/resource: move HMM pr_debug() deeper into resource
 code
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
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, Huang Ying <ying.huang@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Jerome Glisse <jglisse@redhat.com>, zwisler@kernel.org, Wu Fengguang <fengguang.wu@intel.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 24, 2019 at 5:21 PM Dave Hansen <dave.hansen@linux.intel.com> wrote:
>
>
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> HMM consumes physical address space for its own use, even
> though nothing is mapped or accessible there.  It uses a
> special resource description (IORES_DESC_DEVICE_PRIVATE_MEMORY)
> to uniquely identify these areas.
>
> When HMM consumes address space, it makes a best guess about
> what to consume.  However, it is possible that a future memory
> or device hotplug can collide with the reserved area.  In the
> case of these conflicts, there is an error message in
> register_memory_resource().
>
> Later patches in this series move register_memory_resource()
> from using request_resource_conflict() to __request_region().
> Unfortunately, __request_region() does not return the conflict
> like the previous function did, which makes it impossible to
> check for IORES_DESC_DEVICE_PRIVATE_MEMORY in a conflicting
> resource.
>
> Instead of warning in register_memory_resource(), move the
> check into the core resource code itself (__request_region())
> where the conflicting resource _is_ available.  This has the
> added bonus of producing a warning in case of HMM conflicts
> with devices *or* RAM address space, as opposed to the RAM-
> only warnings that were there previously.
>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Ross Zwisler <zwisler@kernel.org>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: linux-nvdimm@lists.01.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Jerome Glisse <jglisse@redhat.com>
> ---
>
>  b/kernel/resource.c   |   10 ++++++++++
>  b/mm/memory_hotplug.c |    5 -----
>  2 files changed, 10 insertions(+), 5 deletions(-)
>
> diff -puN kernel/resource.c~move-request_region-check kernel/resource.c
> --- a/kernel/resource.c~move-request_region-check       2019-01-24 15:13:14.453199539 -0800
> +++ b/kernel/resource.c 2019-01-24 15:13:14.458199539 -0800
> @@ -1123,6 +1123,16 @@ struct resource * __request_region(struc
>                 conflict = __request_resource(parent, res);
>                 if (!conflict)
>                         break;
> +               /*
> +                * mm/hmm.c reserves physical addresses which then
> +                * become unavailable to other users.  Conflicts are
> +                * not expected.  Be verbose if one is encountered.
> +                */
> +               if (conflict->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY) {
> +                       pr_debug("Resource conflict with unaddressable "
> +                                "device memory at %#010llx !\n",
> +                                (unsigned long long)start);

I don't object to the change, but are you really OK with this being a
pr_debug() message that is only emitted when enabled via either the
dynamic debug mechanism or DEBUG being defined?  From the comments, it
seems more like a KERN_INFO sort of message.

Also, maybe the message would be more useful if it included the
conflicting resource as well as the region you're requesting?  Many of
the other callers of request_resource_conflict() have something like
this:

  dev_err(dev, "resource collision: %pR conflicts with %s %pR\n",
        new, conflict->name, conflict);

> +               }
>                 if (conflict != parent) {
>                         if (!(conflict->flags & IORESOURCE_BUSY)) {
>                                 parent = conflict;
> diff -puN mm/memory_hotplug.c~move-request_region-check mm/memory_hotplug.c
> --- a/mm/memory_hotplug.c~move-request_region-check     2019-01-24 15:13:14.455199539 -0800
> +++ b/mm/memory_hotplug.c       2019-01-24 15:13:14.459199539 -0800
> @@ -109,11 +109,6 @@ static struct resource *register_memory_
>         res->flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
>         conflict =  request_resource_conflict(&iomem_resource, res);
>         if (conflict) {
> -               if (conflict->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY) {
> -                       pr_debug("Device unaddressable memory block "
> -                                "memory hotplug at %#010llx !\n",
> -                                (unsigned long long)start);
> -               }
>                 pr_debug("System RAM resource %pR cannot be added\n", res);
>                 kfree(res);
>                 return ERR_PTR(-EEXIST);
> _
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
