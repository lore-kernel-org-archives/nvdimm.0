Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190501191846.12634-1-pasha.tatashin@soleen.com>
 <20190501191846.12634-3-pasha.tatashin@soleen.com> <CAPcyv4iPzpP-gzuDtPB2ixd6_uTuO8-YdVSfGw_Dq=igaKuOEg@mail.gmail.com>
In-Reply-To: <CAPcyv4iPzpP-gzuDtPB2ixd6_uTuO8-YdVSfGw_Dq=igaKuOEg@mail.gmail.com>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 2 May 2019 12:47:52 -0400
Message-ID: <CA+CK2bB3G_tO04M1eXPdm4b=OojD6QpYkW51YArj6z44RhQo+g@mail.gmail.com>
Subject: Re: [v4 2/2] device-dax: "Hotremove" persistent memory that is used
 like normal RAM
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: James Morris <jmorris@namei.org>, Sasha Levin <sashal@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Dave Hansen <dave.hansen@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ross Zwisler <zwisler@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Huang, Ying" <ying.huang@intel.com>, Fengguang Wu <fengguang.wu@intel.com>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Takashi Iwai <tiwai@suse.de>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, David Hildenbrand <david@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

> Currently the kmem driver can be built as a module, and I don't see a
> need to drop that flexibility. What about wrapping these core
> routines:
>
>     unlock_device_hotplug
>     __remove_memory
>     walk_memory_range
>     lock_device_hotplug
>
> ...into a common exported (gpl) helper like:
>
>     int try_remove_memory(int nid, struct resource *res)
>
> Because as far as I can see there's nothing device-dax specific about
> this "try remove iff offline" functionality outside of looking up the
> related 'struct resource'. The check_devdax_mem_offlined_cb callback
> can be made generic if the callback argument is the resource pointer.

Makes sense, I will do both things that you suggested.

Thank you,
Pasha
