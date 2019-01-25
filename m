Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F660211AEA71
 for <linux-nvdimm@lists.01.org>; Thu, 24 Jan 2019 22:28:10 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id a77so6938056oii.5
 for <linux-nvdimm@lists.01.org>; Thu, 24 Jan 2019 22:28:10 -0800 (PST)
MIME-Version: 1.0
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190124231448.E102D18E@viggo.jf.intel.com>
 <0852310e-41dc-dc96-2da5-11350f5adce6@oracle.com>
In-Reply-To: <0852310e-41dc-dc96-2da5-11350f5adce6@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Jan 2019 22:27:58 -0800
Message-ID: <CAPcyv4hjJhUQpMy1CVJZur0Ssr7Cr2fkcD50L5gzx6v_KY14vg@mail.gmail.com>
Subject: Re: [PATCH 5/5] dax: "Hotplug" persistent memory for use like normal
 RAM
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
To: Jane Chu <jane.chu@oracle.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Takashi Iwai <tiwai@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Huang, Ying  <ying.huang@intel.com>, Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Borislav Petkov <bp@suse.de>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 24, 2019 at 10:13 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Hi, Dave,
>
> While chatting with my colleague Erwin about the patchset, it occurred
> that we're not clear about the error handling part. Specifically,
>
> 1. If an uncorrectable error is detected during a 'load' in the hot
> plugged pmem region, how will the error be handled?  will it be
> handled like PMEM or DRAM?

DRAM.

> 2. If a poison is set, and is persistent, which entity should clear
> the poison, and badblock(if applicable)? If it's user's responsibility,
> does ndctl support the clearing in this mode?

With persistent memory advertised via a static logical-to-physical
storage/dax device mapping, once an error develops it destroys a
physical *and* logical part of a device address space. That loss of
logical address space makes error clearing a necessity. However, with
the DRAM / "System RAM" error handling model, the OS can just offline
the page and map a different one to repair the logical address space.
So, no, ndctl will not have explicit enabling to clear volatile
errors, the OS will just dynamically offline problematic pages.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
