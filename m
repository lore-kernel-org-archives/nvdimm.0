Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com
 [IPv6:2607:f8b0:4864:20::332])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D0F52121797D
 for <linux-nvdimm@lists.01.org>; Sat, 20 Apr 2019 14:02:16 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 103so6783302otd.9
 for <linux-nvdimm@lists.01.org>; Sat, 20 Apr 2019 14:02:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190420153148.21548-1-pasha.tatashin@soleen.com>
 <20190420153148.21548-3-pasha.tatashin@soleen.com>
 <CAPcyv4j9sG6Wy3EfTuPb0uZ2qp=gr9UgUhpnXQA_g6Ko9KFmLA@mail.gmail.com>
 <CA+CK2bA2QTzZtFvGRMaG10_TretDr6CGgZc4Hyi_1pku4ECqXw@mail.gmail.com>
 <CAPcyv4jrxMNEEeUZZG3=CdkYSyX7OtJLv_ZQ1gbML7bscePiQA@mail.gmail.com>
 <CA+CK2bA-wDwRT5Gv2p9Nm1Vr8LNg84rQdE6=s2m2hQLYqj5Rog@mail.gmail.com>
In-Reply-To: <CA+CK2bA-wDwRT5Gv2p9Nm1Vr8LNg84rQdE6=s2m2hQLYqj5Rog@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 20 Apr 2019 14:02:04 -0700
Message-ID: <CAPcyv4gBu5QhgRQ+maJs108JwBrcCa9U1e9wgO8FP6Q3qwy69g@mail.gmail.com>
Subject: Re: [v1 2/2] device-dax: "Hotremove" persistent memory that is used
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
To: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Sasha Levin <sashal@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Takashi Iwai <tiwai@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Huang, Ying" <ying.huang@intel.com>, James Morris <jmorris@namei.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Borislav Petkov <bp@suse.de>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Apr 20, 2019 at 10:02 AM Pavel Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> > > Thank you for looking at this.  Are you saying, that if drv.remove()
> > > returns a failure it is simply ignored, and unbind proceeds?
> >
> > Yeah, that's the problem. I've looked at making unbind able to fail,
> > but that can lead to general bad behavior in device-drivers. I.e. why
> > spend time unwinding allocated resources when the driver can simply
> > fail unbind? About the best a driver can do is make unbind wait on
> > some event, but any return results in device-unbind.
>
> Hm, just tested, and it is indeed so.
>
> I see the following options:
>
> 1. Move hot remove code to some other interface, that can fail. Not
> sure what that would be, but outside of unbind/remove_id. Any
> suggestion?
> 2. Option two is don't attept to offline memory in unbind. Do
> hot-remove memory in unbind if every section is already offlined.
> Basically, do a walk through memblocks, and if every section is
> offlined, also do the cleanup.

I think something like option-2 could work just as long as the user is
ok with failure and prepared to handle it. It's already the case that
the request_region() in kmem permanently prevents the memory range
from being reused by any other driver. So if the hot-unplug fails it
could skip the corresponding release_region() and effectively it's the
same as what we have now in terms of reuse protection. In your flow if
the memory remove failed then the conversion attempt from devdax to
raw mode would also fail and presumably you could fall back to doing a
full reboot / rebuild of the application state?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
