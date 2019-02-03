Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 59525211C7F39
 for <linux-nvdimm@lists.01.org>; Sun,  3 Feb 2019 11:13:50 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id y1so9807765oie.12
 for <linux-nvdimm@lists.01.org>; Sun, 03 Feb 2019 11:13:50 -0800 (PST)
MIME-Version: 1.0
References: <PU1P153MB0169977604493B82B662A01CBF920@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <154915640488.3541628.4947340559510114602.stgit@dwillia2-desk3.amr.corp.intel.com>
 <PU1P153MB0169BD9237F2DC1FA64721BABF6C0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4h0B0sBMjiAC=Tk=Mu58A4vZ5F9yUPQsXqf5jyYF37VCw@mail.gmail.com>
 <PU1P153MB0169F7C111EEC5890D3F840ABF6C0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169F7C111EEC5890D3F840ABF6C0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 3 Feb 2019 11:13:38 -0800
Message-ID: <CAPcyv4iMau=fvOfubDvK=cg5v5287TvXqBCm=p8nqbz2es6YEg@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm/dimm: Add a no-BLK quirk based on NVDIMM family
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
To: Dexuan Cui <decui@microsoft.com>
Cc: Michael Kelley <mikelley@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Feb 3, 2019 at 10:13 AM Dexuan Cui <decui@microsoft.com> wrote:
>
> > From: Dan Williams <dan.j.williams@intel.com>
> > Sent: Sunday, February 3, 2019 9:49 AM
> > > ...
> > > It looks the namespace created by Ubuntu 19.04 (4.18) is incompatible with
> > > the libnvdimm-pending branch + this patch.
> >
> > This is correct, the configuration switched from label-less by default
> > to labeled.
> Thanks for the confirmation!
>
> > > It looks we need to completely disable the label usage for
> > NVDIMM_FAMILY_HYPERV
> > > due to compability?
> >
> > It's either going to be a quirk in Linux or a quirk in the Hyper-V
> > configuration. I think it's more manageable for Hyper-V to ship a
> > "label disable" switch than to try to ship a workaround in Linux. The
> > "noblk" quirk in Linux works around the LOCAL bit in the labels.
> > However, the namespace mode regression can only be resolved by hiding
> > the label capability until the administrator manually switches from
> > label-less to labeled operation.
>
> As I understand, the essence of the issue is: Hyper-V emulates the
> label mechanism (i.e. it supports _LSI and LSR), but doesn't do it
> right (i.e. it doesn't support _LSW).
>
> To manage the namespaces, Linux can choose to use label or not.
>
> If _LSI/_LSR are supported, Linux assumes _LSW is supported as well
> and chooses to use label (i.e. the label mode), but since Hyper-V doesn't
> support _LSW, Linux fails to change the namespace configuration.

No, that's not quite right. The reason Linux does not see the fsdax
mode configuration is due to the missing "address abstraction GUID" in
the label produced the default Hyper-V configuration. In label-less
mode there is no "address abstraction GUID" to validate so it falls
back to just using the info-block directly.

The _LSW issue is if you wanted to reconfigure a raw namespace to
fsdax mode. The current flow tries to delete the label, but that's
only for reconfiguration, not the initial boot-up case that is
currently failing. The deletion would fail on finding no label-write
capability, but to be clear the boot-up case does not perform any
writes.

> In
> Ubuntu 19.04 (4.18), the kernel is not aware of Hyper-V _LSI/_LSR, so
> the created namespace is in "label-less" mode, and hence can't be used
> with the libnvdimm-pending branch + this patch, unless we add a quirk
> in Linux to explicitly not use the label.
>
> I agree ideally Hyper-V should hide the label capability, and I'll request
> Hyper-V team to do that. I hope Hyper-V guys are still able to do that
> in time so we won't need a quirk in Linux kernel.

After some more thought, the "no regressions" rule means that Linux
should ship a quirk for this by default. I think a good heuristic is
to disable label support by default if no _LSW method is detected. An
opt-in can be specified to accept "read-only" configurations, but
that's an exceptional case. I'll send a patch for this.

> BTW, I suppose Windows VM should be in "label-less" mode.

I expect Windows mandates labeled operation. This label-less concept
was something Linux shipped in advance of a specification being
ratified and to support early NVDIMMs that don't advertise label
space.

> Thanks for the help, Dan!

Thanks for the quick feedback and testing.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
