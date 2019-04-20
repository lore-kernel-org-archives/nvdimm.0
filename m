Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190420153148.21548-1-pasha.tatashin@soleen.com> <CAPcyv4h73gUwntDYx012qcyMYCmzZDU3HOvKcW5DRkO-GoTc+w@mail.gmail.com>
In-Reply-To: <CAPcyv4h73gUwntDYx012qcyMYCmzZDU3HOvKcW5DRkO-GoTc+w@mail.gmail.com>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 20 Apr 2019 12:56:09 -0400
Message-ID: <CA+CK2bBpyiUKeiT5tPtT9Dt73DmKX9pOFLU2iZy=Xpubt1AhAA@mail.gmail.com>
Subject: Re: [v1 0/2] "Hotremove" persistent memory
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: James Morris <jmorris@namei.org>, Sasha Levin <sashal@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Dave Hansen <dave.hansen@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ross Zwisler <zwisler@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Huang, Ying" <ying.huang@intel.com>, Fengguang Wu <fengguang.wu@intel.com>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Takashi Iwai <tiwai@suse.de>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

> Makes sense, but I have some questions about the details.
>
> >
> > Copy the state, and hotadd the persistent memory so machine still has all
> > 8G for runtime. Before reboot, hotremove device-dax 2G, copy the memory
> > that is needed to be preserved to pmem0 device, and reboot.
> >
> > The series of operations look like this:
> >
> >         1. After boot restore /dev/pmem0 to boot

s/boot/to a ramdisk from which is is picked by apps/

> >         2. Convert raw pmem0 to devdax
> >         ndctl create-namespace --mode devdax --map mem -e namespace0.0 -f
> >         3. Hotadd to System RAM
> >         echo dax0.0 > /sys/bus/dax/drivers/device_dax/unbind
> >         echo dax0.0 > /sys/bus/dax/drivers/kmem/new_id
> >         4. Before reboot hotremove device-dax memory from System RAM
> >         echo dax0.0 > /sys/bus/dax/drivers/kmem/unbind
> >         5. Create raw pmem0 device
> >         ndctl create-namespace --mode raw  -e namespace0.0 -f
> >         6. Copy the state to this device
>
> What is the source of this copy? The state that was in the hot-added
> memory? Isn't it "already there" since you effectively renamed dax0.0
> to pmem0?

Before hotremove, applications create a file in a ramdisk that is 2G
in size. After that applications, exist. We copy this file from
ramdisk to /dev/pmem0  (RAM to RAM copy) to be able to quickly restore
after reboot. After reboot, applications take that file from ramdisk,
and ramdisk is freed.

>
> >         7. Do kexec reboot, or reboot through firmware, is firmware does not
> >         zero memory in pmem region.
s/is/if/
>
> Wouldn't the dax0.0 contents be preserved regardless? How does the
> guest recover the pre-initialized state / how does the kernel know to
> give out the same pages to the application as the previous boot?

On these machines we do not have real persistent memory, only regular
volatile RAM. So, kernel has to either be booted via memap arguments
that specify persistent range, or via special pmem device node in DTB.
