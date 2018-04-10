Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3DCFB2267F0E5
 for <linux-nvdimm@lists.01.org>; Mon,  9 Apr 2018 18:03:09 -0700 (PDT)
Received: from mail-qk0-f179.google.com (mail-qk0-f179.google.com
 [209.85.220.179])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DCC6A217DF
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 01:03:08 +0000 (UTC)
Received: by mail-qk0-f179.google.com with SMTP id w6so11610562qkb.4
 for <linux-nvdimm@lists.01.org>; Mon, 09 Apr 2018 18:03:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iCkc7ZSB7Sjk-O7iBWvvTzhTmdccucC4uN6GEu5Bjotw@mail.gmail.com>
References: <20180409074604.17671-1-oohall@gmail.com>
 <CAL_Jsq+ho2QhmNmPZMDJcfSxposJd=jYDvjhXH8cMAtVFP7n4A@mail.gmail.com>
 <CAPcyv4iCkc7ZSB7Sjk-O7iBWvvTzhTmdccucC4uN6GEu5Bjotw@mail.gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Mon, 9 Apr 2018 20:02:47 -0500
Message-ID: <CAL_JsqJY-sh+KBVAja=epesGdd=OKJzooeLTpZZD0Z++ZxqzfA@mail.gmail.com>
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

You mean the stuff reviewed last week in the middle of the merge
window? Sounds like 4.18 material to me.

Rob
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
