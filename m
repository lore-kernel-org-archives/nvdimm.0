Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2671421256BBB
 for <linux-nvdimm@lists.01.org>; Thu, 16 May 2019 00:10:23 -0700 (PDT)
Subject: Re: [v5 0/3] "Hotremove" persistent memory
References: <20190502184337.20538-1-pasha.tatashin@soleen.com>
 <76dfe7943f2a0ceaca73f5fd23e944dfdc0309d1.camel@intel.com>
 <CA+CK2bCKcJjXo7BGAVxvbQNYQFSDVLH5aB=S9yTmZWEfexOvtg@mail.gmail.com>
 <CAPcyv4jj557QNNwyQ7ez+=PnURsnXk9cGZ11Mmihmtem2bJ-3A@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <9add7fd4-6d6e-fa80-08db-7cffc9ae0b75@redhat.com>
Date: Thu, 16 May 2019 09:10:12 +0200
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jj557QNNwyQ7ez+=PnURsnXk9cGZ11Mmihmtem2bJ-3A@mail.gmail.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: "sashal@kernel.org" <sashal@kernel.org>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "mhocko@suse.com" <mhocko@suse.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "tiwai@suse.de" <tiwai@suse.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Huang, Ying  <ying.huang@intel.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jglisse@redhat.com" <jglisse@redhat.com>, "Wu, Fengguang  <fengguang.wu@intel.com>, baiyaowei@cmss.chinamobile.com" <baiyaowei@cmss.chinamobile.com>, "zwisler@kernel.org" <zwisler@kernel.org>, "bhelgaas@google.com" <bhelgaas@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "bp@suse.de" <bp@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On 16.05.19 02:42, Dan Williams wrote:
> On Wed, May 15, 2019 at 11:12 AM Pavel Tatashin
> <pasha.tatashin@soleen.com> wrote:
>>
>>> Hi Pavel,
>>>
>>> I am working on adding this sort of a workflow into a new daxctl command
>>> (daxctl-reconfigure-device)- this will allow changing the 'mode' of a
>>> dax device to kmem, online the resulting memory, and with your patches,
>>> also attempt to offline the memory, and change back to device-dax.
>>>
>>> In running with these patches, and testing the offlining part, I ran
>>> into the following lockdep below.
>>>
>>> This is with just these three patches on top of -rc7.
>>>
>>>
>>> [  +0.004886] ======================================================
>>> [  +0.001576] WARNING: possible circular locking dependency detected
>>> [  +0.001506] 5.1.0-rc7+ #13 Tainted: G           O
>>> [  +0.000929] ------------------------------------------------------
>>> [  +0.000708] daxctl/22950 is trying to acquire lock:
>>> [  +0.000548] 00000000f4d397f7 (kn->count#424){++++}, at: kernfs_remove_by_name_ns+0x40/0x80
>>> [  +0.000922]
>>>               but task is already holding lock:
>>> [  +0.000657] 000000002aa52a9f (mem_sysfs_mutex){+.+.}, at: unregister_memory_section+0x22/0xa0
>>
>> I have studied this issue, and now have a clear understanding why it
>> happens, I am not yet sure how to fix it, so suggestions are welcomed
>> :)
> 
> I would think that ACPI hotplug would have a similar problem, but it does this:
> 
>                 acpi_unbind_memory_blocks(info);
>                 __remove_memory(nid, info->start_addr, info->length);
> 
> I wonder if that ordering prevents going too deep into the
> device_unregister() call stack that you highlighted below.
> 

If that doesn't help, after we have

[PATCH v2 0/8] mm/memory_hotplug: Factor out memory block device handling

we could probably pull the memory device removal phase out from the
mem_hotplug_lock protection and let it be protected by the
device_hotplug_lock only. Might require some more work, though.

-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
