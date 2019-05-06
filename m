Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com
 [IPv6:2607:f8b0:4864:20::329])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 567522121AA3A
 for <linux-nvdimm@lists.01.org>; Mon,  6 May 2019 11:01:27 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id l17so2790287otq.1
 for <linux-nvdimm@lists.01.org>; Mon, 06 May 2019 11:01:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190502184337.20538-1-pasha.tatashin@soleen.com>
 <20190502184337.20538-3-pasha.tatashin@soleen.com>
 <cac721ed-c404-19d1-71d1-37c66df9b2a8@intel.com>
In-Reply-To: <cac721ed-c404-19d1-71d1-37c66df9b2a8@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 6 May 2019 11:01:14 -0700
Message-ID: <CAPcyv4greisKBSorzQWebcVOf2AqUH6DwbvNKMW0MQ5bCwYZrw@mail.gmail.com>
Subject: Re: [v5 2/3] mm/hotplug: make remove_memory() interface useable
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
To: Dave Hansen <dave.hansen@intel.com>
Cc: Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>, Takashi Iwai <tiwai@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, Linux MM <linux-mm@kvack.org>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Sasha Levin <sashal@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, James Morris <jmorris@namei.org>, "Huang, Ying" <ying.huang@intel.com>, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 6, 2019 at 10:57 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> > -static inline void remove_memory(int nid, u64 start, u64 size) {}
> > +static inline bool remove_memory(int nid, u64 start, u64 size)
> > +{
> > +     return -EBUSY;
> > +}
>
> This seems like an appropriate place for a WARN_ONCE(), if someone
> manages to call remove_memory() with hotplug disabled.
>
> BTW, I looked and can't think of a better errno, but -EBUSY probably
> isn't the best error code, right?
>
> > -void remove_memory(int nid, u64 start, u64 size)
> > +/**
> > + * remove_memory
> > + * @nid: the node ID
> > + * @start: physical address of the region to remove
> > + * @size: size of the region to remove
> > + *
> > + * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
> > + * and online/offline operations before this call, as required by
> > + * try_offline_node().
> > + */
> > +void __remove_memory(int nid, u64 start, u64 size)
> >  {
> > +
> > +     /*
> > +      * trigger BUG() is some memory is not offlined prior to calling this
> > +      * function
> > +      */
> > +     if (try_remove_memory(nid, start, size))
> > +             BUG();
> > +}
>
> Could we call this remove_offline_memory()?  That way, it makes _some_
> sense why we would BUG() if the memory isn't offline.

Please WARN() instead of BUG() because failing to remove memory should
not be system fatal.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
