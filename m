Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A8D83211CAF42
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 08:15:48 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id v62so32206567otb.3
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 08:15:48 -0800 (PST)
MIME-Version: 1.0
References: <154958385172.3932544.193235520333886200.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49lg2bql2v.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4iiZS_zfroRtmS-zD-cCDj1yQonBsWM23utR9m9kiBizA@mail.gmail.com>
 <b1f73551-5c11-3651-dc6f-5cdcf815e0d0@suse.de>
In-Reply-To: <b1f73551-5c11-3651-dc6f-5cdcf815e0d0@suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 Feb 2019 08:15:35 -0800
Message-ID: <CAPcyv4hZXJbrLc9f3xsOTPs_RYVH9vhuxSxHj-4L56ZNi+ZRZg@mail.gmail.com>
Subject: Re: [PATCH] acpi/nfit: Fix bus command validation
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Vishal Verma <vishal.verma@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 20, 2019 at 12:30 AM Johannes Thumshirn <jthumshirn@suse.de> wrote:
>
> On 20/02/2019 03:58, Dan Williams wrote:
> [...]
>
> >>
> >> Tricky code path, eh?
> >
> > ioctl path, number one source of bugs / thrash in this subsystem. 2nd
> > place, ARS.
>
> Possibly unpopular idea, but should we maybe teach trinity/syzcaller
> about these ioctl()s?
>
> Better we find the bugs in a QA like environment than in the filed, I guess?

I wouldn't be opposed to syzkaller fuzzing the nvdimm-ioctl path.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
