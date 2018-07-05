Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C537203B99C3
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 14:13:38 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id v8-v6so19584315oie.5
 for <linux-nvdimm@lists.01.org>; Thu, 05 Jul 2018 14:13:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180705201726.512-2-keith.busch@intel.com>
References: <20180705201726.512-1-keith.busch@intel.com>
 <20180705201726.512-2-keith.busch@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 5 Jul 2018 14:13:37 -0700
Message-ID: <CAPcyv4gA_e-bSjRdDo8-LR1U8WqcOobsddP=ckvoo=X_A91WVQ@mail.gmail.com>
Subject: Re: [PATCHv2 2/2] libnvdimm: Export max available extent
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
To: Keith Busch <keith.busch@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 5, 2018 at 1:17 PM, Keith Busch <keith.busch@intel.com> wrote:
> The 'available_size' attribute showing the combined total of all
> unallocated space isn't always useful to know how large of a namespace
> a user may be able to allocate if the region is fragmented. This patch
> will export the largest extent of contiguous unallocated space that may
> be allocated to create a new namespace.
>
> Signed-off-by: Keith Busch <keith.busch@intel.com>

Looks good to me, applied to my for-4.19/libnvdimm tracking branch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
