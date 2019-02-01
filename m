Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7424421B02822
 for <linux-nvdimm@lists.01.org>; Fri,  1 Feb 2019 09:29:39 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id u16so6664653otk.8
 for <linux-nvdimm@lists.01.org>; Fri, 01 Feb 2019 09:29:39 -0800 (PST)
MIME-Version: 1.0
References: <PU1P153MB01690EDA138D3ABDE5B4A482BF970@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4jD1oRWzA4ZiMYZm1uxsbOdgqzbb9raH70-HBDqapcE_g@mail.gmail.com>
 <PU1P153MB0169977604493B82B662A01CBF920@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169977604493B82B662A01CBF920@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 1 Feb 2019 09:29:27 -0800
Message-ID: <CAPcyv4haUouYs_Vfju2SMvjcwc7rqY06zqT8NJ-3uakGMZSu0w@mail.gmail.com>
Subject: Re: [PATCH v2] nfit: add Hyper-V NVDIMM DSM command set to white list
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
Cc: Josh Poulson <jopoulso@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Haiyang Zhang <haiyangz@microsoft.com>, "driverdev-devel@linuxdriverproject.org" <driverdev-devel@linuxdriverproject.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Kelley <mikelley@microsoft.com>, Sasha Levin <Alexander.Levin@microsoft.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Stephen Hemminger <sthemmin@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 1, 2019 at 9:14 AM Dexuan Cui <decui@microsoft.com> wrote:
>
> > From: Dan Williams <dan.j.williams@intel.com>
> > Sent: Tuesday, January 29, 2019 10:24 PM
> > On Mon, Jan 28, 2019 at 4:56 PM Dexuan Cui <decui@microsoft.com> wrote:
> > >
> > >
> > > Add the Hyper-V _DSM command set to the white list of NVDIMM command
> > > sets.
> > >
> > > Thanks Dan Williams <dan.j.williams@intel.com> for writing the
> > > comment change.
> > > ---
> > > Changes in v2:
> > >     Updated the comment and changelog (Thanks, Dan!)
> > >     Rebased to the tag libnvdimm-fixes-5.0-rc4 of the nvdimm tree.
> >
> > Thanks for the re-spin, applied.
>
> Hi Dan,
> Unluckily it looks this commit causes a regression on
> https://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git/log/?h=libnvdimm-pending
>
> With the patch, "ndctl list" shows nothing, and /dev/pmem0 can't appear.
> If I revert the patch, it will be back to normal.
>
> I attached the config/logs. In the bad case, "dmesg" shows a line
> [    5.259017] nd_pmem namespace0.0: 0x0000000000000000, too small must be at least 0x1000
>
> Any idea why this happens? I'm digging into the details and I appreciate your insights.

Looks like it is working as expected. The regression you are seeing is
the fact that the patch enables the kernel to enable
nvdimm-namespace-label reads. Those reads find a namespace index block
and a label. Unfortunately the label has the LOCAL flag set and Linux
explicitly ignores pmem namespace labels with that bit set. The reason
for that is due to the fact that the original definition of the LOCAL
bit from v1.1 of the namespace label implementation [1] explicitly
limited the LOCAL flag to "block aperture" regions. If you clear that
LOCAL flag I expect it will work. To my knowledge Windows pretends
that the v1.1 definition never existed.

The UEFI 2.7 specification for v1.2 labels states that setting the
LOCAL flag is optional when "nlabel", number of labels in the set, is
1. Linux makes that mandatory as LOCAL is redundant when nlabel is 1.

That said, the Robustness Principle makes a case that Linux should
tolerate the bit being set. However, it's just a non-trivial amount of
work to unwind the ingrained block-aperture assumptions of that bit.

[1]: http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
