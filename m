Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EED19224DCA3A
 for <linux-nvdimm@lists.01.org>; Thu,  8 Mar 2018 09:43:46 -0800 (PST)
Received: by mail-oi0-x244.google.com with SMTP id c12so4985060oic.7
 for <linux-nvdimm@lists.01.org>; Thu, 08 Mar 2018 09:50:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180308172134.GC18491@linux.intel.com>
References: <CAPcyv4gSMyVRbVNRubtdQ7_mrY8NpKWwx0p1vdz6j1KLGssSEw@mail.gmail.com>
 <20180307185355.4425-1-ross.zwisler@linux.intel.com>
 <1520455336.6316.4.camel@intel.com>
 <CAPcyv4jC3G0CdBwY_4EVOqNEgYvxmGPiHPt5yUFMH0PJ0jxxVA@mail.gmail.com>
 <20180308172134.GC18491@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 8 Mar 2018 09:50:01 -0800
Message-ID: <CAPcyv4ijd3=drHj2bPhyqUW0u1PeWGbv2J8riS9n19iLkz-+Kw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ndctl: add filtering based on numa_node
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 8, 2018 at 9:21 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Wed, Mar 07, 2018 at 12:48:28PM -0800, Dan Williams wrote:
>> On Wed, Mar 7, 2018 at 12:42 PM, Verma, Vishal L
>> <vishal.l.verma@intel.com> wrote:
>> >
>> > On Wed, 2018-03-07 at 11:53 -0700, Ross Zwisler wrote:
>> >> Add support to 'ndctl list' so that we can filter DIMMs, regions and
>> >> namespaces based on numa node.
>> >
>> > Something for the future - perhaps we can add this same numa node based
>> > filtering to all the operations on namespaces/regions/dimms.
>>
>> This does have the region filtering, and that should also
>> automatically filter namespaces since we wouldn't even consider the
>> namespaces on a region where the numa node doesn't match.
>
> What other supports of operations were you thinking about?  Like
>
> ndctl disable-region --numa_node=0
>
> or something?  It doesn't look like we use other ndctl list type filters for
> other operations like that today?  This seems powerful if we were to implement
> it, but easy to accidentally operate on namespaces/regions you didn't intend.

This is Linux, defer to giving users all the rope they want.

>
>> > Does it make sense to accept an 'all' option for numa node? We're only
>> > using it for filtering, and 'all' == not supplying the option at all..
>>
>> Same could be said for all the other places we accept all, I think it
>> should be "all or nothing" (heh heh heh), i.e. if we accept it as an
>> option for dimms regions and namespaces, why not numa nodes?
>
> On a somewhat related note, what do you guys think of an option like this:
>
> ndctl list --all
>
> Which would just give you a full dump of all the various bits of info, so it
> would currently be equivalent to:
>
> ndctl list --buses --dimms --health --device-dax  --regions --namespaces
>         --idle --media-errors
>
> Providing you with a single short command to get as much info about a system
> as possible?

Sounds good to me... should also include --firmware in that list. I'd
probably call it --everything since "all" is already reserved as a
keyword for specific object types. I.e. "ndct list" by default is
"all" namespaces so I would expect "ndctl list --all" to also be all
namespaces.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
