Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com
 [IPv6:2607:f8b0:4864:20::332])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DA6B9211FB8A4
 for <linux-nvdimm@lists.01.org>; Sat, 20 Apr 2019 09:36:53 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 64so6512329otb.8
 for <linux-nvdimm@lists.01.org>; Sat, 20 Apr 2019 09:36:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190420153148.21548-1-pasha.tatashin@soleen.com>
 <20190420153148.21548-3-pasha.tatashin@soleen.com>
 <CAPcyv4j9sG6Wy3EfTuPb0uZ2qp=gr9UgUhpnXQA_g6Ko9KFmLA@mail.gmail.com>
 <CA+CK2bA2QTzZtFvGRMaG10_TretDr6CGgZc4Hyi_1pku4ECqXw@mail.gmail.com>
In-Reply-To: <CA+CK2bA2QTzZtFvGRMaG10_TretDr6CGgZc4Hyi_1pku4ECqXw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 20 Apr 2019 09:36:42 -0700
Message-ID: <CAPcyv4jrxMNEEeUZZG3=CdkYSyX7OtJLv_ZQ1gbML7bscePiQA@mail.gmail.com>
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

On Sat, Apr 20, 2019 at 9:30 AM Pavel Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> > > +
> > > +       /* Walk and offline every singe memory_block of the dax region. */
> > > +       lock_device_hotplug();
> > > +       rc = walk_memory_range(start_pfn, end_pfn, dev, offline_memblock_cb);
> > > +       unlock_device_hotplug();
> > > +       if (rc)
> > > +               return rc;
> >
> > This potential early return is the reason why memory hotremove is not
> > reliable vs the driver-core. If this walk fails to offline the memory
> > it will still be online, but the driver-core has no consideration for
> > device-unbind failing. The ubind will proceed while the memory stays
> > pinned.
>
> Hi Dan,
>
> Thank you for looking at this.  Are you saying, that if drv.remove()
> returns a failure it is simply ignored, and unbind proceeds?

Yeah, that's the problem. I've looked at making unbind able to fail,
but that can lead to general bad behavior in device-drivers. I.e. why
spend time unwinding allocated resources when the driver can simply
fail unbind? About the best a driver can do is make unbind wait on
some event, but any return results in device-unbind.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
