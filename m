Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com
 [209.85.167.196])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EC41B212ACEAC
 for <linux-nvdimm@lists.01.org>; Wed,  3 Jul 2019 04:11:10 -0700 (PDT)
Received: by mail-oi1-f196.google.com with SMTP id g7so1708437oia.8
 for <linux-nvdimm@lists.01.org>; Wed, 03 Jul 2019 04:11:10 -0700 (PDT)
MIME-Version: 1.0
References: <156140036490.2951909.1837804994781523185.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156140037770.2951909.3387200938880485927.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156140037770.2951909.3387200938880485927.stgit@dwillia2-desk3.amr.corp.intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 3 Jul 2019 13:10:58 +0200
Message-ID: <CAJZ5v0gAVXxnu22it_YTTm1HQPiBj5DOuiC1YCg5Eem8RQW0Ww@mail.gmail.com>
Subject: Re: [PATCH v4 02/10] acpi/numa/hmat: Skip publishing target info for
 nodes with no online memory
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Zijlstra <peterz@infradead.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 24, 2019 at 8:33 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> There are multiple scenarios where the HMAT may contain information
> about proximity domains that are not currently online. Rather than fail
> to report any HMAT data just elide those offline domains.
>
> If and when those domains are later onlined they can be added to the
> HMEM reporting at that point.
>
> This was found while testing EFI_MEMORY_SP support which reserves
> "specific purpose" memory from the general allocation pool. If that
> reservation results in an empty numa-node then the node is not marked
> online leading a spurious:
>
>     "acpi/hmat: Ignoring HMAT: Invalid table"
>
> ...result for HMAT parsing.
>
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/acpi/numa/hmat.c |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
> index 96b7d39a97c6..2c220cb7b620 100644
> --- a/drivers/acpi/numa/hmat.c
> +++ b/drivers/acpi/numa/hmat.c
> @@ -96,9 +96,6 @@ static __init void alloc_memory_target(unsigned int mem_pxm)
>  {
>         struct memory_target *target;
>
> -       if (pxm_to_node(mem_pxm) == NUMA_NO_NODE)
> -               return;
> -
>         target = find_mem_target(mem_pxm);
>         if (target)
>                 return;
> @@ -588,6 +585,17 @@ static __init void hmat_register_targets(void)
>         struct memory_target *target;
>
>         list_for_each_entry(target, &targets, node) {
> +               int nid = pxm_to_node(target->memory_pxm);
> +
> +               /*
> +                * Skip offline nodes. This can happen when memory
> +                * marked EFI_MEMORY_SP, "specific purpose", is applied
> +                * to all the memory in a promixity domain leading to
> +                * the node being marked offline / unplugged, or if
> +                * memory-only "hotplug" node is offline.
> +                */
> +               if (nid == NUMA_NO_NODE || !node_online(nid))
> +                       continue;
>                 hmat_register_target_initiators(target);
>                 hmat_register_target_perf(target);
>         }
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
