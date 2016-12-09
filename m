Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E886A2B2377@SHSMSX101.ccr.corp.intel.com>
References: <cover.1480490191.git.lv.zheng@intel.com>
 <411c4b5987a902e037bf8c969513853dc960cc8a.1480490191.git.lv.zheng@intel.com>
 <CAA9_cmeUNuvfSSVWWiUt3PLG0WDUCw6m8uK4n5Doh3u_OtRDEg@mail.gmail.com>
 <1AE640813FDE7649BE1B193DEA596E886A2B2377@SHSMSX101.ccr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 8 Dec 2016 17:57:52 -0800
Message-ID: <CAPcyv4iEo2yEQrMNpGjhR6N5qE-YmTDzQ0ch9QMZEi4b5jN5UQ@mail.gmail.com>
Subject: Re: [PATCH 08/11] ACPICA: Tables: Back port acpi_get_table_with_size()
 and early_acpi_os_unmap_memory() from Linux kernel
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
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Wysocki, Rafael J  <rafael.j.wysocki@intel.com>, Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lv Zheng <zetalog@gmail.com>, "Moore, Robert" <robert.moore@intel.com>, Linux ACPI <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 8, 2016 at 5:49 PM, Zheng, Lv <lv.zheng@intel.com> wrote:
> Hi, Dan
>
> Good to see you here!
>
>> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On Behalf Of Dan Williams
>> Subject: Re: [PATCH 08/11] ACPICA: Tables: Back port acpi_get_table_with_size() and
>> early_acpi_os_unmap_memory() from Linux kernel
>>
>> On Tue, Nov 29, 2016 at 11:21 PM, Lv Zheng <lv.zheng@intel.com> wrote:
>> > ACPICA commit cac6790954d4d752a083e6122220b8a22febcd07
>> >
>> > This patch back ports Linux acpi_get_table_with_size() and
>> > early_acpi_os_unmap_memory() into ACPICA upstream to reduce divergences.
>> >
>> > The 2 APIs are used by Linux as table management APIs for long time, it
>> > contains a hidden logic that during the early stage, the mapped tables
>> > should be unmapped before the early stage ends.
>> >
>> > During the early stage, tables are handled by the following sequence:
>> >  acpi_get_table_with_size();
>> >  parse the table
>> >  early_acpi_os_unmap_memory();
>> > During the late stage, tables are handled by the following sequence:
>> >  acpi_get_table();
>> >  parse the table
>> > Linux uses acpi_gbl_permanent_mmap to distinguish the early stage and the
>> > late stage.
>> >
>> > The reasoning of introducing acpi_get_table_with_size() is: ACPICA will
>> > remember the early mapped pointer in acpi_get_table() and Linux isn't able to
>> > prevent ACPICA from using the wrong early mapped pointer during the late
>> > stage as there is no API provided from ACPICA to be an inverse of
>> > acpi_get_table() to forget the early mapped pointer.
>> >
>> > But how ACPICA can work with the early/late stage requirement? Inside of
>> > ACPICA, tables are ensured to be remained in "INSTALLED" state during the
>> > early stage, and they are carefully not transitioned to "VALIDATED" state
>> > until the late stage. So the same logic is in fact implemented inside of
>> > ACPICA in a different way. The gap is only that the feature is not provided
>> > to the OSPMs in an accessible external API style.
>> >
>> > It then is possible to fix the gap by providing an inverse of
>> > acpi_get_table() from ACPICA, so that the two Linux sequences can be
>> > combined:
>> >  acpi_get_table();
>> >  parse the table
>> >  acpi_put_table();
>> > In order to work easier with the current Linux code, acpi_get_table() and
>> > acpi_put_table() is implemented in a usage counting based style:
>> >  1. When the usage count of the table is increased from 0 to 1, table is
>> >     mapped and .Pointer is set with the mapping address (VALIDATED);
>> >  2. When the usage count of the table is decreased from 1 to 0, .Pointer
>> >     is unset and the mapping address is unmapped (INVALIDATED).
>> > So that we can deploy the new APIs to Linux with minimal effort by just
>> > invoking acpi_get_table() in acpi_get_table_with_size() and invoking
>> > acpi_put_table() in early_acpi_os_unmap_memory(). Lv Zheng.
>> >
>> > Link: https://github.com/acpica/acpica/commit/cac67909
>> > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
>> > Signed-off-by: Bob Moore <robert.moore@intel.com>
>>
>> This commit in -next (071b39575679 ACPICA: Tables: Back port
>> acpi_get_table_with_size() and early_acpi_os_unmap_memory() from Linux
>> kernel) causes a regression in my nfit/nvdimm test environment. The
>> nfit produced by QEMU no longer results in a nvdimm bus being created.
>
> This commit is almost a no-op, unless some code in kernel is using the length field returned by old acpi_get_table_with_size().
>
>>
>> I have not root caused it, but I'm using the following command line
>> options to create an nfit in qemu-2.6.  Reverting the commit leads
>> compile failures.
>>
>> qemu=$HOME/git/qemu/build/x86_64-softmmu/qemu-system-x86_64
>> mem=$HOME/mem
>> label_size=$((128*1024))
>> mem_size=$(((3*1024*1024*1024) + (64 * 1024 *1024)))
>> IMAGE=$HOME/ahci.img
>>
>> kvm=(
>>         $qemu
>>         -enable-kvm
>>         -cpu kvm64
>>         -kernel $kernel
>>         -initrd $initrd
>>         -m 12G,slots=3,maxmem=40G
>>
>>         -machine pc-i440fx-2.4,accel=kvm,usb=off,vmport=off,nvdimm
>>         -cpu SandyBridge
>>         -smp 2
>>         -netdev tap,id=hostnet0,ifname=tap0,script=no,downscript=no
>>         -device
>> virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:b7:a1:ad,bus=pci.0,addr=0x7
>>         -object
>> memory-backend-file,id=mem1,share,mem-path=${mem},size=$((label_size +
>> mem_size))
>>         -device nvdimm,memdev=mem1,id=nv1,label-size=${label_size}
>>         -device ahci,id=sata0,bus=pci.0,addr=0x8
>>         -drive file=$IMAGE,if=none,id=drive-sata0-0-0,format=raw
>>         -device ide-hd,bus=sata0.0,drive=drive-sata0-0-0,id=sata0-0-0
>>         -boot order=nc
>>         -no-reboot
>>         -watchdog i6300esb
>>         -rtc base=localtime
>>         -serial stdio
>>         -display none
>>         -monitor null
>> )
>
> Let me file a kernel Bugzilla bug to track this issue:
> https://bugzilla.kernel.org/show_bug.cgi?id=189891
> And see if we can quickly fix it.
>
> Could you also point me the NFIT code that I should take a look at.
> Thanks in advance.
>

Yes, the nfit code is here:

drivers/acpi/nfit/core.c

...and yes it does currently use the size returned from
acpi_get_table_with_size() as a double-check against the size supplied
in the header. See acpi_nfit_add().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
