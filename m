Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 249972263DD64
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 09:48:07 -0700 (PDT)
Received: from mail-qt0-f180.google.com (mail-qt0-f180.google.com
 [209.85.216.180])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C4CFD21837
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 16:48:06 +0000 (UTC)
Received: by mail-qt0-f180.google.com with SMTP id a25so9721929qtm.1
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 09:48:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iCkc7ZSB7Sjk-O7iBWvvTzhTmdccucC4uN6GEu5Bjotw@mail.gmail.com>
References: <20180409074604.17671-1-oohall@gmail.com>
 <CAL_Jsq+ho2QhmNmPZMDJcfSxposJd=jYDvjhXH8cMAtVFP7n4A@mail.gmail.com>
 <CAPcyv4iCkc7ZSB7Sjk-O7iBWvvTzhTmdccucC4uN6GEu5Bjotw@mail.gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Mon, 16 Apr 2018 11:47:45 -0500
Message-ID: <CAL_JsqLujBZzo5T0118QiX-CvxfetaBcPG9rC_WGCCK8k4Ka7Q@mail.gmail.com>
Subject: Re: [PATCH] drivers/of: Introduce ARCH_HAS_OWN_OF_NUMA
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-nvdimm <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Device Tree <devicetree@vger.kernel.org>, sparclinux@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 9, 2018 at 4:05 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Apr 9, 2018 at 1:52 PM, Rob Herring <robh@kernel.org> wrote:
>> On Mon, Apr 9, 2018 at 2:46 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
>>> Some OF platforms (pseries and some SPARC systems) has their own
>>> implementations of NUMA affinity detection rather than using the generic
>>> OF_NUMA driver, which mainly exists for arm64. For other platforms one
>>> of two fallbacks provided by the base OF driver are used depending on
>>> CONFIG_NUMA.
>>>
>>> In the CONFIG_NUMA=n case the fallback is an inline function in of.h.
>>> In the =y case the fallback is a real function which is defined as a
>>> weak symbol so that it may be overwritten by the architecture if desired.
>>>
>>> The problem with this arrangement is that the real implementations all
>>> export of_node_to_nid(). Unfortunately it's not possible to export the
>>> fallback since it would clash with the non-weak version. As a result
>>> we get build failures when:
>>>
>>> a) CONFIG_NUMA=y && CONFIG_OF=y, and
>>> b) The platform doesn't implement of_node_to_nid(), and
>>> c) A module uses of_node_to_nid()
>>>
>>> Given b) will be true for most platforms this is fairly easy to hit
>>> and has been observed on ia64 and x86.
>>
>> How specifically do we hit this? The only module I see using
>> of_node_to_nid in mainline is Cell EDAC driver.
>
> The of_pmem driver is using it currently pending for a 4.17 pull
> request. Stephen hit the compile failure in -next.

I took a look at this. The correct fix here is to use dev_to_node() instead:

diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
index 85013bad35de..0a701837dfc0 100644
--- a/drivers/nvdimm/of_pmem.c
+++ b/drivers/nvdimm/of_pmem.c
@@ -67,7 +67,7 @@ static int of_pmem_region_probe(struct platform_device *pdev)
                 */
                memset(&ndr_desc, 0, sizeof(ndr_desc));
                ndr_desc.attr_groups = region_attr_groups;
-               ndr_desc.numa_node = of_node_to_nid(np);
+               ndr_desc.numa_node = dev_to_node(&pdev->dev);
                ndr_desc.res = &pdev->resource[i];
                ndr_desc.of_node = np;
                set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);


And we should remove the exported symbol.

I'll send a proper patch.

Rob
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
