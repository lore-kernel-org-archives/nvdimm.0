Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com
 [IPv6:2a00:1450:4864:20::532])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF30021250479
 for <linux-nvdimm@lists.01.org>; Mon,  6 May 2019 11:18:32 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id p26so16244882edr.2
 for <linux-nvdimm@lists.01.org>; Mon, 06 May 2019 11:18:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190502184337.20538-1-pasha.tatashin@soleen.com>
 <20190502184337.20538-3-pasha.tatashin@soleen.com>
 <cac721ed-c404-19d1-71d1-37c66df9b2a8@intel.com>
 <CAPcyv4greisKBSorzQWebcVOf2AqUH6DwbvNKMW0MQ5bCwYZrw@mail.gmail.com>
 <cf793443-c14a-a1e0-856e-15e416c7f874@intel.com>
In-Reply-To: <cf793443-c14a-a1e0-856e-15e416c7f874@intel.com>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 6 May 2019 14:18:20 -0400
Message-ID: <CA+CK2bAfjXCtRRV2DWy8huCvJ-y0L5cMvOh+9CS40WZfhx-aeg@mail.gmail.com>
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
Cc: Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>, Takashi Iwai <tiwai@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, Linux MM <linux-mm@kvack.org>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Sasha Levin <sashal@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, James Morris <jmorris@namei.org>, "Huang, Ying" <ying.huang@intel.com>, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 6, 2019 at 2:04 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 5/6/19 11:01 AM, Dan Williams wrote:
> >>> +void __remove_memory(int nid, u64 start, u64 size)
> >>>  {
> >>> +
> >>> +     /*
> >>> +      * trigger BUG() is some memory is not offlined prior to calling this
> >>> +      * function
> >>> +      */
> >>> +     if (try_remove_memory(nid, start, size))
> >>> +             BUG();
> >>> +}
> >> Could we call this remove_offline_memory()?  That way, it makes _some_
> >> sense why we would BUG() if the memory isn't offline.
> > Please WARN() instead of BUG() because failing to remove memory should
> > not be system fatal.
>
> That is my preference as well.  But, the existing code BUG()s, so I'm
> OK-ish with this staying for the moment until we have a better handle on
> what all the callers do if this fails.

Yes, this is the reason why I BUG() here. The current code does this,
and I was not sure what would happen if we simply continue executing.
Of course, I would prefer to return failure, so the callers can act
appropriately, but let's make one thing at a time, this should not be
part of this series.

Thank you,
Pasha
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
