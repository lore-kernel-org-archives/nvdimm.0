Return-Path: <linux-nvdimm-bounces@lists.01.org>
From: "Zheng, Lv" <lv.zheng@intel.com>
Subject: RE: [PATCH 08/11] ACPICA: Tables: Back port
 acpi_get_table_with_size() and early_acpi_os_unmap_memory() from Linux kernel
Date: Fri, 9 Dec 2016 02:27:08 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E886A2B3409@SHSMSX101.ccr.corp.intel.com>
References: <cover.1480490191.git.lv.zheng@intel.com>
 <411c4b5987a902e037bf8c969513853dc960cc8a.1480490191.git.lv.zheng@intel.com>
 <CAA9_cmeUNuvfSSVWWiUt3PLG0WDUCw6m8uK4n5Doh3u_OtRDEg@mail.gmail.com>
 <CAJZ5v0jYijDj2+UiPp41pHWdpuJvMUFoonViSvaCdBknkrbo2Q@mail.gmail.com>
 <CAPcyv4jNyH4Aq9SptOV+iOY8ncYiL19SwEhwzkFoUecp6nLTzA@mail.gmail.com>
 <1AE640813FDE7649BE1B193DEA596E886A2B2398@SHSMSX101.ccr.corp.intel.com>
 <CAPcyv4gVuay4uZu5qgDidWyj_LV9s+eRNW6CUZaELHxNtSeHtQ@mail.gmail.com>
In-Reply-To: <CAPcyv4gVuay4uZu5qgDidWyj_LV9s+eRNW6CUZaELHxNtSeHtQ@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rafael@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Wysocki, Rafael J  <rafael.j.wysocki@intel.com>, Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lv Zheng <zetalog@gmail.com>, "Moore, Robert" <robert.moore@intel.com>, Linux ACPI <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi, Dan

> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Dan
> Williams
> Subject: Re: [PATCH 08/11] ACPICA: Tables: Back port acpi_get_table_with_size() and
> early_acpi_os_unmap_memory() from Linux kernel
> 
> On Thu, Dec 8, 2016 at 5:59 PM, Zheng, Lv <lv.zheng@intel.com> wrote:
> > Hi, Rafael and Dan
> >
> >> From: Dan Williams [mailto:dan.j.williams@intel.com]
> >> Subject: Re: [PATCH 08/11] ACPICA: Tables: Back port acpi_get_table_with_size() and
> >> early_acpi_os_unmap_memory() from Linux kernel
> >>
> >> On Thu, Dec 8, 2016 at 5:18 AM, Rafael J. Wysocki <rafael@kernel.org> wrote:
> >> > On Thu, Dec 8, 2016 at 2:11 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> >> >> On Tue, Nov 29, 2016 at 11:21 PM, Lv Zheng <lv.zheng@intel.com> wrote:
> >> >>> ACPICA commit cac6790954d4d752a083e6122220b8a22febcd07
> >> >>>
> >> >>> This patch back ports Linux acpi_get_table_with_size() and
> >> >>> early_acpi_os_unmap_memory() into ACPICA upstream to reduce divergences.
> >> >>>
> >> >>> The 2 APIs are used by Linux as table management APIs for long time, it
> >> >>> contains a hidden logic that during the early stage, the mapped tables
> >> >>> should be unmapped before the early stage ends.
> >> >>>
> >> >>> During the early stage, tables are handled by the following sequence:
> >> >>>  acpi_get_table_with_size();
> >> >>>  parse the table
> >> >>>  early_acpi_os_unmap_memory();
> >> >>> During the late stage, tables are handled by the following sequence:
> >> >>>  acpi_get_table();
> >> >>>  parse the table
> >> >>> Linux uses acpi_gbl_permanent_mmap to distinguish the early stage and the
> >> >>> late stage.
> >> >>>
> >> >>> The reasoning of introducing acpi_get_table_with_size() is: ACPICA will
> >> >>> remember the early mapped pointer in acpi_get_table() and Linux isn't able to
> >> >>> prevent ACPICA from using the wrong early mapped pointer during the late
> >> >>> stage as there is no API provided from ACPICA to be an inverse of
> >> >>> acpi_get_table() to forget the early mapped pointer.
> >> >>>
> >> >>> But how ACPICA can work with the early/late stage requirement? Inside of
> >> >>> ACPICA, tables are ensured to be remained in "INSTALLED" state during the
> >> >>> early stage, and they are carefully not transitioned to "VALIDATED" state
> >> >>> until the late stage. So the same logic is in fact implemented inside of
> >> >>> ACPICA in a different way. The gap is only that the feature is not provided
> >> >>> to the OSPMs in an accessible external API style.
> >> >>>
> >> >>> It then is possible to fix the gap by providing an inverse of
> >> >>> acpi_get_table() from ACPICA, so that the two Linux sequences can be
> >> >>> combined:
> >> >>>  acpi_get_table();
> >> >>>  parse the table
> >> >>>  acpi_put_table();
> >> >>> In order to work easier with the current Linux code, acpi_get_table() and
> >> >>> acpi_put_table() is implemented in a usage counting based style:
> >> >>>  1. When the usage count of the table is increased from 0 to 1, table is
> >> >>>     mapped and .Pointer is set with the mapping address (VALIDATED);
> >> >>>  2. When the usage count of the table is decreased from 1 to 0, .Pointer
> >> >>>     is unset and the mapping address is unmapped (INVALIDATED).
> >> >>> So that we can deploy the new APIs to Linux with minimal effort by just
> >> >>> invoking acpi_get_table() in acpi_get_table_with_size() and invoking
> >> >>> acpi_put_table() in early_acpi_os_unmap_memory(). Lv Zheng.
> >> >>>
> >> >>> Link: https://github.com/acpica/acpica/commit/cac67909
> >> >>> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> >> >>> Signed-off-by: Bob Moore <robert.moore@intel.com>
> >> >>
> >> >> This commit in -next (071b39575679 ACPICA: Tables: Back port
> >> >> acpi_get_table_with_size() and early_acpi_os_unmap_memory() from Linux
> >> >> kernel) causes a regression in my nfit/nvdimm test environment. The
> >> >> nfit produced by QEMU no longer results in a nvdimm bus being created.
> >> >>
> >> >> I have not root caused it, but I'm using the following command line
> >> >> options to create an nfit in qemu-2.6.  Reverting the commit leads
> >> >> compile failures.
> >> >
> >> > Would the build problems go away if you reverted "ACPICA: Tables:
> >> > Allow FADT to be customized with virtual address" (linux-next commit
> >> > cf334d3174f9) in addition to it?
> >>
> >> Yes, reverting those two commits gets me back to a functional environment:
> >>
> >> Revert "ACPICA: Tables: Allow FADT to be customized with virtual address"
> >> Revert "ACPICA: Tables: Back port acpi_get_table_with_size() and
> >> early_acpi_os_un
> >
> > To Dan:
> > It seems in drivers/acpi/nfit/core.c.
> > The returned table size is used by the NFIT code.
> > I think it should be changed to use table_header->length.
> 
> Does the acpi core already validate that table_header->length is
> correct? i.e. is is possible that a broken implementation could have
> the wrong length in the header? I was assuming that was the purpose of
> the _with_size(), but maybe I was wrong?

There is no such breakage.
The purpose is not that.

The purpose of the API is:
During the Linux early stage, it is required to unmap the early maps as such pointer cannot be used by late stage.
While ACPICA keeps such pointer in table_desc if acpi_get_table() is called.

So Linux guys provided acpi_get_table_with_size(), in which table_desc will not remember the mapped pointer.
The size must be returned to the caller as the caller need to use it as a parameter to unmap the memory during early stage.

Thanks and best regards
Lv



> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
