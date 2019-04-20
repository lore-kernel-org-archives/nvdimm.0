Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 309F12194EB7E
 for <linux-nvdimm@lists.01.org>; Sat, 20 Apr 2019 09:34:38 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id e5so5921383oii.0
 for <linux-nvdimm@lists.01.org>; Sat, 20 Apr 2019 09:34:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190420153148.21548-1-pasha.tatashin@soleen.com>
In-Reply-To: <20190420153148.21548-1-pasha.tatashin@soleen.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 20 Apr 2019 09:34:26 -0700
Message-ID: <CAPcyv4h73gUwntDYx012qcyMYCmzZDU3HOvKcW5DRkO-GoTc+w@mail.gmail.com>
Subject: Re: [v1 0/2] "Hotremove" persistent memory
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
To: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Sasha Levin <sashal@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Takashi Iwai <tiwai@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Huang, Ying" <ying.huang@intel.com>, James Morris <jmorris@namei.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Borislav Petkov <bp@suse.de>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Apr 20, 2019 at 8:32 AM Pavel Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> Recently, adding a persistent memory to be used like a regular RAM was
> added to Linux. This work extends this functionality to also allow hot
> removing persistent memory.
>
> We (Microsoft) have a very important use case for this functionality.
>
> The requirement is for physical machines with small amount of RAM (~8G)
> to be able to reboot in a very short period of time (<1s). Yet, there is
> a userland state that is expensive to recreate (~2G).
>
> The solution is to boot machines with 2G preserved for persistent
> memory.

Makes sense, but I have some questions about the details.

>
> Copy the state, and hotadd the persistent memory so machine still has all
> 8G for runtime. Before reboot, hotremove device-dax 2G, copy the memory
> that is needed to be preserved to pmem0 device, and reboot.
>
> The series of operations look like this:
>
>         1. After boot restore /dev/pmem0 to boot
>         2. Convert raw pmem0 to devdax
>         ndctl create-namespace --mode devdax --map mem -e namespace0.0 -f
>         3. Hotadd to System RAM
>         echo dax0.0 > /sys/bus/dax/drivers/device_dax/unbind
>         echo dax0.0 > /sys/bus/dax/drivers/kmem/new_id
>         4. Before reboot hotremove device-dax memory from System RAM
>         echo dax0.0 > /sys/bus/dax/drivers/kmem/unbind
>         5. Create raw pmem0 device
>         ndctl create-namespace --mode raw  -e namespace0.0 -f
>         6. Copy the state to this device

What is the source of this copy? The state that was in the hot-added
memory? Isn't it "already there" since you effectively renamed dax0.0
to pmem0?

>         7. Do kexec reboot, or reboot through firmware, is firmware does not
>         zero memory in pmem region.

Wouldn't the dax0.0 contents be preserved regardless? How does the
guest recover the pre-initialized state / how does the kernel know to
give out the same pages to the application as the previous boot?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
