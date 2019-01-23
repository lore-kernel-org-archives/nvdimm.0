Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7A13C2194D387
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 17:27:41 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id n8so504886otl.6
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 17:27:41 -0800 (PST)
MIME-Version: 1.0
References: <20190122024810.4448-1-richardw.yang@linux.intel.com>
 <20190122024810.4448-2-richardw.yang@linux.intel.com>
In-Reply-To: <20190122024810.4448-2-richardw.yang@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 Jan 2019 17:27:29 -0800
Message-ID: <CAPcyv4htjAH8QEHbCzGR7X828Y4WWmw-30dchUNEfv7jK6w-fg@mail.gmail.com>
Subject: Re: [PATCH 2/2] libnvdimm, pfn: use PAGE_SIZE to calculate npfns
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
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: Ross Zwisler <zwisler@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 21, 2019 at 6:49 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
>
> There are two places to calculate npfns in nd_pfn_init(), while they use
> difference size to calculate.
>
> Use PAGE_SIZE would be more proper for calculation.

No, this would make the kernel have different output based on
PAGE_SIZE. It should be possible for a PAGE_SIZE==64K system to create
a valid info-block for PAGE_SIZE==4K system. This would need to encode
the PAGE_SIZE in the info-block if it were to ever support non-4K
PAGE_SIZE systems.

Another consideration is that a PAGE_SIZE==4K infoblock is compatible
with a PAGE_SIZE==64K system. All that happens is that the memmap
reserve area is oversized and portions go unused. The reverse is not
true.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
