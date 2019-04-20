Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190420153148.21548-1-pasha.tatashin@soleen.com>
 <20190420153148.21548-3-pasha.tatashin@soleen.com> <CAPcyv4j9sG6Wy3EfTuPb0uZ2qp=gr9UgUhpnXQA_g6Ko9KFmLA@mail.gmail.com>
In-Reply-To: <CAPcyv4j9sG6Wy3EfTuPb0uZ2qp=gr9UgUhpnXQA_g6Ko9KFmLA@mail.gmail.com>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 20 Apr 2019 12:30:14 -0400
Message-ID: <CA+CK2bA2QTzZtFvGRMaG10_TretDr6CGgZc4Hyi_1pku4ECqXw@mail.gmail.com>
Subject: Re: [v1 2/2] device-dax: "Hotremove" persistent memory that is used
 like normal RAM
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: James Morris <jmorris@namei.org>, Sasha Levin <sashal@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Dave Hansen <dave.hansen@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ross Zwisler <zwisler@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Huang, Ying" <ying.huang@intel.com>, Fengguang Wu <fengguang.wu@intel.com>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Takashi Iwai <tiwai@suse.de>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

> > +
> > +       /* Walk and offline every singe memory_block of the dax region. */
> > +       lock_device_hotplug();
> > +       rc = walk_memory_range(start_pfn, end_pfn, dev, offline_memblock_cb);
> > +       unlock_device_hotplug();
> > +       if (rc)
> > +               return rc;
>
> This potential early return is the reason why memory hotremove is not
> reliable vs the driver-core. If this walk fails to offline the memory
> it will still be online, but the driver-core has no consideration for
> device-unbind failing. The ubind will proceed while the memory stays
> pinned.

Hi Dan,

Thank you for looking at this.  Are you saying, that if drv.remove()
returns a failure it is simply ignored, and unbind proceeds?

Pasha
