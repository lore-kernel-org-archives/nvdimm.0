Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190421014429.31206-1-pasha.tatashin@soleen.com>
 <20190421014429.31206-3-pasha.tatashin@soleen.com> <4ad3c587-6ab8-1307-5a13-a3e73cf569a5@redhat.com>
 <CAPcyv4h3+hU=MmB=RCc5GZmjLW_ALoVg_C4Z7aw8NQ=1LzPKaw@mail.gmail.com>
 <CA+CK2bDB5o4+NMc7==_ipVAZoEo7fdrkjZ4etU0LUCqxnmN-Rg@mail.gmail.com> <180d6250-8a6a-0b5d-642a-ec6648cb45b1@redhat.com>
In-Reply-To: <180d6250-8a6a-0b5d-642a-ec6648cb45b1@redhat.com>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 25 Apr 2019 08:30:40 -0400
Message-ID: <CA+CK2bBt0vHr9D+BuvM=GmjCMESu5iBiUTdvid_TaoE6j2daQg@mail.gmail.com>
Subject: Re: [v2 2/2] device-dax: "Hotremove" persistent memory that is used
 like normal RAM
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, James Morris <jmorris@namei.org>, Sasha Levin <sashal@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Dave Hansen <dave.hansen@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ross Zwisler <zwisler@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Huang, Ying" <ying.huang@intel.com>, Fengguang Wu <fengguang.wu@intel.com>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Takashi Iwai <tiwai@suse.de>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

>
> Yes, also I think you can let go of the device_lock in
> check_memblocks_offline_cb, lock_device_hotplug() should take care of
> this (see Documentation/core-api/memory-hotplug.rst - "locking internals")
>
Hi David,

Thank you for your comments. I went through memory-hotplug.rst, and I
still think that device_lock() is needed here. In this particular case
it can be replaced with something like READ_ONCE(), but for simplicity
it is better to have device_lock()/device_unlock() as this is not a
performance critical code.

I do not see any lock ordering issues with this code, as we are
holding lock_device_hotplug() first that prevents userland from
adding/removing memory during this check.

https://soleen.com/source/xref/linux/arch/powerpc/platforms/powernv/memtrace.c?r=98fa15f3#248

Here we have a similar code:
lock_device_hotplug();
   online_mem_block();
    device_online()
     device_lock(dev);

Pasha
