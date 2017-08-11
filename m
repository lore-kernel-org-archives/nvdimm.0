Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB5BC21D49119
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 06:33:47 -0700 (PDT)
Received: from G4W9119.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net
 [16.210.20.214])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g2t2352.austin.hpe.com (Postfix) with ESMTPS id 48D0199
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 13:36:07 +0000 (UTC)
Subject: Re: [PATCH] ndctl: New structure definitions.
References: <20170811000000.18672-1-jerry.hoemann@hpe.com>
 <CAPcyv4grN7RXfkxNfXad79FAKJzwrAxit-xXW4J7n22i-s+Dvg@mail.gmail.com>
 <20170811021221.GA19197@anatevka.americas.hpqcorp.net>
 <CAPcyv4hAkqTZe-NnyQ7xFPjNg2aw8ob06ppfg_tDx-bywOHvAw@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <46f34f90-1f1b-759c-2ef5-137726cb49b9@hpe.com>
Date: Fri, 11 Aug 2017 09:36:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hAkqTZe-NnyQ7xFPjNg2aw8ob06ppfg_tDx-bywOHvAw@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 8/10/2017 10:27 PM, Dan Williams wrote:
> On Thu, Aug 10, 2017 at 7:12 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> On Thu, Aug 10, 2017 at 05:47:10PM -0700, Dan Williams wrote:
>>> On Thu, Aug 10, 2017 at 5:00 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>>>> Add structure definitions newly published/modified in v0.85:
>>>>
>>>> https://github.com/HewlettPackard/hpe-nvm/blob/master/Documentation/NFIT_DSM_DDR4_NVDIMM-N_v85.pdf
>>>
>>> Are there going to be follow-on patches that make use of these
>>> definitions? I would save this update for when those follow-on patches
>>> are ready.
>>
>> There are multiple projects both inside and outside of HPE that need to
>> make DSM calls.
>>
>> The DSM ioctl is an interface exported to user applications.  Customers
>> and vendors can and will use this interface for their own tools and this
>> use need not result in patches sent back to the ndctl project.
>
> My hope was that the existing extra definitions in ndctl-hpe1.h would
> gain some users at some point in the future,

It hasn't been easy to add things to ndctl but we would like to add more.
Otherwise we'll have to create yet another tool.

> but there's otherwise no
> need to add dead code to ndctl-hpe1.h. That header is only used at
> compile time it's not shipped so it doesn't provide any benefit to
> those third party applications that you mention.

We've thought about shipping this include file.  I think there's
a library or developer package for ndctl?

-- ljk
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
