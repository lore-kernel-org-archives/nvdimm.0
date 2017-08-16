Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.sfc.wide.ad.jp (shonan.sfc.wide.ad.jp [203.178.142.130])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3FBC721E2DA43
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 21:38:55 -0700 (PDT)
Subject: Re: get_user_pages_unlocked() fails for mmap()-ed nvdimm-backed file
References: <CA+Sc9E0KYUB2BexdwhG5wvMLu38TLagqgEyzQDthpv3L+YuTBA@mail.gmail.com>
 <CAPcyv4hY1Ceg2yHvO2OX=x5kZE6Tmypnctc0oPL6A6a4hWX20A@mail.gmail.com>
From: Michio Honda <micchie@sfc.wide.ad.jp>
Message-ID: <a7bb4181-26f0-b6d4-f2fa-6b51defa70bd@sfc.wide.ad.jp>
Date: Wed, 16 Aug 2017 06:41:12 +0200
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hY1Ceg2yHvO2OX=x5kZE6Tmypnctc0oPL6A6a4hWX20A@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Giuseppe Lettieri <g.lettieri@iet.unipi.it>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

You were right and it perfectly works now (I used "pending" branch of 
ndctl). Thanks a lot!

Cheers,
- Michio

On 08/16/2017 12:05 AM, Dan Williams wrote:
> On Tue, Aug 15, 2017 at 2:56 PM, Honda Michio <micchie@sfc.wide.ad.jp> wrote:
>> Dear Linux NVDIMM developers,
>>
>> We are implementing a kernel module that get_user_pages()s an address
>> provided by a user-space application. This address is a mmap()-ed region of
>> a file backed by pmem (XFS with DAX).
>> It works or successfully gets a kernel virtual address for emulated PMEM
>> with memmap grub option but doesn't work with a real NVDIMM (I use HPE's
>> NVDIMM).
>>
>> I wonder if I am doing something fundamentally wrong, or just making a
>> mistake about kernel configuration or arguments passed to
>> get_user_pages_unlocked().
>>
>> I am giving FOLL_WRITE | FOLL_GET | FOLL_SPLIT | FOLL_POPULATE to
>> get_user_pages_unlocked(); it fails in vm_normal_page() in
>> follow_page_pte(), then falls into follow_pfn_pte() with flags & FOLL_GET
>> to be true, causing -EFAULT returned.
>>
>> I use libnvdimm-for-next branch
>> (bbb3be170ac2891526ad07b18af7db226879a8e7) and my kernel configuration
>> looks like:
>>
>> root@c402:~/deployed/net-next# egrep -i "(dax|nvdimm|pmem)" .config
>> CONFIG_X86_PMEM_LEGACY_DEVICE=y
>> CONFIG_X86_PMEM_LEGACY=y
>> CONFIG_LIBNVDIMM=y
>> CONFIG_BLK_DEV_PMEM=m
>> CONFIG_NVDIMM_PFN=y
>> CONFIG_NVDIMM_DAX=y
>> CONFIG_DAX=y
>> CONFIG_DEV_DAX=y
>> CONFIG_DEV_DAX_PMEM=y
>> CONFIG_FS_DAX=y
>> CONFIG_FS_DAX_PMD=y
>> CONFIG_ARCH_HAS_PMEM_API=y
> 
> Kernel configuration looks ok, but by default the kernel does not
> enable get_user_pages() for dax mappings because it assumes a 'struct
> page' entry has been allocated for every page of pmem. We don't do
> that allocation in the kernel by default because the memmap (struct
> page) array can be quite large and may not fit in available DRAM.
> Instead we require a configuration step to place the pmem namespace
> into 'memory' mode (see ndctl create-namespace --help).
> 
> I suspect if you do "ndctl list" you'll see that your namespace is in
> 'raw' mode. Convert that to 'memory' mode with the (destructive)
> command below.
> 
>       ndctl create-namespace --reconfig=namespace0.0 --mode=memory --force
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
