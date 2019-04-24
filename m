Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com
 [IPv6:2a00:1450:4864:20::541])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 374C62121C11E
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 14:34:57 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g6so17308989edc.8
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 14:34:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190421014429.31206-1-pasha.tatashin@soleen.com>
 <20190421014429.31206-3-pasha.tatashin@soleen.com>
 <4ad3c587-6ab8-1307-5a13-a3e73cf569a5@redhat.com>
 <CAPcyv4h3+hU=MmB=RCc5GZmjLW_ALoVg_C4Z7aw8NQ=1LzPKaw@mail.gmail.com>
In-Reply-To: <CAPcyv4h3+hU=MmB=RCc5GZmjLW_ALoVg_C4Z7aw8NQ=1LzPKaw@mail.gmail.com>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 24 Apr 2019 17:34:45 -0400
Message-ID: <CA+CK2bDB5o4+NMc7==_ipVAZoEo7fdrkjZ4etU0LUCqxnmN-Rg@mail.gmail.com>
Subject: Re: [v2 2/2] device-dax: "Hotremove" persistent memory that is used
 like normal RAM
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Sasha Levin <sashal@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Takashi Iwai <tiwai@suse.de>, David Hildenbrand <david@redhat.com>, "Huang, Ying  <ying.huang@intel.com>, Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@suse.de>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

> > > +static int
> > > +offline_memblock_cb(struct memory_block *mem, void *arg)
> >
> > Function name suggests that you are actually trying to offline memory
> > here. Maybe check_memblocks_offline_cb(), just like we have in
> > mm/memory_hotplug.c.

Makes sense, I will rename to check_memblocks_offline_cb()

> > > +     lock_device_hotplug();
> > > +     rc = walk_memory_range(start_pfn, end_pfn, dev, offline_memblock_cb);
> > > +     unlock_device_hotplug();
> > > +
> > > +     /*
> > > +      * If admin has not offlined memory beforehand, we cannot hotremove dax.
> > > +      * Unfortunately, because unbind will still succeed there is no way for
> > > +      * user to hotremove dax after this.
> > > +      */
> > > +     if (rc)
> > > +             return rc;
> >
> > Can't it happen that there is a race between you checking if memory is
> > offline and an admin onlining memory again? maybe pull the
> > remove_memory() into the locked region, using __remove_memory() instead.
>
> I think the race is ok. The admin gets to keep the pieces of allowing
> racing updates to the state and the kernel will keep the range active
> until the next reboot.

Thank you for noticing this. I will pull it into locking region.
Because, __remove_memory() has this code:

1868   ret = walk_memory_range(PFN_DOWN(start), PFN_UP(start + size - 1), NULL,
1869   check_memblock_offlined_cb);
1870   if (ret)
1871      BUG();

Basically, panic if at least something is not offlined.

Pasha
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
