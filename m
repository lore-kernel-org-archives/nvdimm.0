Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A0E14211B81AC
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 08:51:09 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id t204so6667138oie.7
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 08:51:09 -0800 (PST)
MIME-Version: 1.0
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <x49sgxr9rjd.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49sgxr9rjd.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 17 Jan 2019 08:50:57 -0800
Message-ID: <CAPcyv4je0XXWjej+xM4+gidryQH=p_sevD=eL6w8f-vDQzMm3w@mail.gmail.com>
Subject: Re: [PATCH 0/4] Allow persistent memory to be used like normal RAM
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Dave Hansen <dave@sr71.net>, linux-nvdimm <linux-nvdimm@lists.01.org>, Takashi Iwai <tiwai@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Huang, Ying  <ying.huang@intel.com>, Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.com>, Borislav Petkov <bp@suse.de>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 17, 2019 at 8:29 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Dave Hansen <dave.hansen@linux.intel.com> writes:
>
> > Persistent memory is cool.  But, currently, you have to rewrite
> > your applications to use it.  Wouldn't it be cool if you could
> > just have it show up in your system like normal RAM and get to
> > it like a slow blob of memory?  Well... have I got the patch
> > series for you!
>
> So, isn't that what memory mode is for?
>   https://itpeernetwork.intel.com/intel-optane-dc-persistent-memory-operating-modes/

That's a hardware cache that privately manages DRAM in front of PMEM.
It benefits from some help from software [1].

> Why do we need this code in the kernel?

This goes further and enables software managed allocation decisions
with the full DRAM + PMEM address space.

[1]: https://lore.kernel.org/lkml/154767945660.1983228.12167020940431682725.stgit@dwillia2-desk3.amr.corp.intel.com/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
