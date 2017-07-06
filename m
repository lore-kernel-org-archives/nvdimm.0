Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <20170706215233.11329-2-ross.zwisler@linux.intel.com>
References: <20170706215233.11329-1-ross.zwisler@linux.intel.com> <20170706215233.11329-2-ross.zwisler@linux.intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 7 Jul 2017 00:08:36 +0200
Message-ID: <CAJZ5v0hsNT6VzgxsC7KG2+N1wv0Yc54qQEG3WWt2Lro+ij8ZEA@mail.gmail.com>
Subject: Re: [RFC v2 1/5] acpi: add missing include in acpi_numa.h
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Anaczkowski, Lukasz" <lukasz.anaczkowski@intel.com>, "Box, David E" <david.e.box@intel.com>, "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, "Lahtinen, Joonas" <joonas.lahtinen@intel.com>, "Moore, Robert" <robert.moore@intel.com>, "Nachimuthu, Murugasamy" <murugasamy.nachimuthu@intel.com>, "Odzioba, Lukasz" <lukasz.odzioba@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Schmauss, Erik" <erik.schmauss@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jerome Glisse <jglisse@redhat.com>, Len Brown <lenb@kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>, "devel@acpica.org" <devel@acpica.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 6, 2017 at 11:52 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Right now if a file includes acpi_numa.h and they don't happen to include
> linux/numa.h before it, they get the following warning:
>
> ./include/acpi/acpi_numa.h:9:5: warning: "MAX_NUMNODES" is not defined [-Wundef]
>  #if MAX_NUMNODES > 256
>      ^~~~~~~~~~~~
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  include/acpi/acpi_numa.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/acpi/acpi_numa.h b/include/acpi/acpi_numa.h
> index d4b7294..1e3a74f 100644
> --- a/include/acpi/acpi_numa.h
> +++ b/include/acpi/acpi_numa.h
> @@ -3,6 +3,7 @@
>
>  #ifdef CONFIG_ACPI_NUMA
>  #include <linux/kernel.h>
> +#include <linux/numa.h>
>
>  /* Proximity bitmap length */
>  #if MAX_NUMNODES > 256
> --
> 2.9.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
