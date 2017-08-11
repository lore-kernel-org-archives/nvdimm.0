Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x233.google.com (mail-yw0-x233.google.com
 [IPv6:2607:f8b0:4002:c05::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A48442095DFFA
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 09:45:51 -0700 (PDT)
Received: by mail-yw0-x233.google.com with SMTP id u207so25583480ywc.3
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 09:48:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <46f34f90-1f1b-759c-2ef5-137726cb49b9@hpe.com>
References: <20170811000000.18672-1-jerry.hoemann@hpe.com>
 <CAPcyv4grN7RXfkxNfXad79FAKJzwrAxit-xXW4J7n22i-s+Dvg@mail.gmail.com>
 <20170811021221.GA19197@anatevka.americas.hpqcorp.net>
 <CAPcyv4hAkqTZe-NnyQ7xFPjNg2aw8ob06ppfg_tDx-bywOHvAw@mail.gmail.com>
 <46f34f90-1f1b-759c-2ef5-137726cb49b9@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Aug 2017 09:48:10 -0700
Message-ID: <CAPcyv4gn3a9CqjdCc-wrkaLSNnUhLXqLQaAecdDgPoTi2YXEjQ@mail.gmail.com>
Subject: Re: [PATCH] ndctl: New structure definitions.
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 11, 2017 at 6:36 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>
>
> On 8/10/2017 10:27 PM, Dan Williams wrote:
>>
>> On Thu, Aug 10, 2017 at 7:12 PM, Jerry Hoemann <jerry.hoemann@hpe.com>
>> wrote:
>>>
>>> On Thu, Aug 10, 2017 at 05:47:10PM -0700, Dan Williams wrote:
>>>>
>>>> On Thu, Aug 10, 2017 at 5:00 PM, Jerry Hoemann <jerry.hoemann@hpe.com>
>>>> wrote:
>>>>>
>>>>> Add structure definitions newly published/modified in v0.85:
>>>>>
>>>>>
>>>>> https://github.com/HewlettPackard/hpe-nvm/blob/master/Documentation/NFIT_DSM_DDR4_NVDIMM-N_v85.pdf
>>>>
>>>>
>>>> Are there going to be follow-on patches that make use of these
>>>> definitions? I would save this update for when those follow-on patches
>>>> are ready.
>>>
>>>
>>> There are multiple projects both inside and outside of HPE that need to
>>> make DSM calls.
>>>
>>> The DSM ioctl is an interface exported to user applications.  Customers
>>> and vendors can and will use this interface for their own tools and this
>>> use need not result in patches sent back to the ndctl project.
>>
>>
>> My hope was that the existing extra definitions in ndctl-hpe1.h would
>> gain some users at some point in the future,
>
>
> It hasn't been easy to add things to ndctl but we would like to add more.
> Otherwise we'll have to create yet another tool.

Understood. The goal I've had with ndctl is to be vendor agnostic out
of the gate. The trajectory of vendor tools is that each vendor
releases their own special sauce and sometime later someone who is
tired of dealing with that differentiation writes a library to undo
it, like system-storage-manager or smartmontools, and provide a
unified interface. If you need to do truly vendor specific things that
probably needs a new tool, but if there's any commonality for a
feature across vendors then I think we should look to add a common
ndctl front-end for it. For example, I'm looking to add a firmware
update mechanism that provides a framework to hide all the "if (vendor
== X)" details behind the libndctl api.

>> but there's otherwise no
>> need to add dead code to ndctl-hpe1.h. That header is only used at
>> compile time it's not shipped so it doesn't provide any benefit to
>> those third party applications that you mention.
>
>
> We've thought about shipping this include file.  I think there's
> a library or developer package for ndctl?

It does have a devel package for users to write against the libndctl.h
api. There's also general if 'platform == NFIT' vs 'platform == e820'
differentiation. What it doesn't have is any api that externally
presents a vendor specific interface.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
