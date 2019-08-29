Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1E77A20215F59
 for <linux-nvdimm@lists.01.org>; Thu, 29 Aug 2019 12:18:23 -0700 (PDT)
Subject: Re: [ndctl PATCH 3/3] ndctl/namespace: add a --continue option to
 create namespaces greedily
References: <20190829001735.30289-1-vishal.l.verma@intel.com>
 <20190829001735.30289-4-vishal.l.verma@intel.com>
 <179261bd-9812-6bba-6710-19a77cf3acc6@oracle.com>
 <e343ace46d7243632eec594f679759fac78814ba.camel@intel.com>
 <CAPcyv4iQ8=yLGA0E2=puqV+mC7HxNW-RP-0EtVeU2hN6HsNxKQ@mail.gmail.com>
From: jane.chu@oracle.com
Message-ID: <bca384f1-46c9-54c5-2df3-e2575c57c694@oracle.com>
Date: Thu, 29 Aug 2019 12:16:28 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iQ8=yLGA0E2=puqV+mC7HxNW-RP-0EtVeU2hN6HsNxKQ@mail.gmail.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Scargall, Steve" <steve.scargall@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 8/29/19 11:28 AM, Dan Williams wrote:
> On Thu, Aug 29, 2019 at 11:08 AM Verma, Vishal L
> <vishal.l.verma@intel.com> wrote:
>>
>> On Thu, 2019-08-29 at 10:38 -0700, jane.chu@oracle.com wrote:
>>> Hi, Vishal,
>>>
>>>
>>> On 8/28/19 5:17 PM, Vishal Verma wrote:
>>>> Add a --continue option to ndctl-create-namespaces to allow the creation
>>>> of as many namespaces as possible, that meet the given filter
>>>> restrictions.
>>>>
>>>> The creation loop will be aborted if a failure is encountered at any
>>>> point.
>>>
>>> Just wondering what is the motivation behind providing this option?
>>
>> Hi Jane,
>>
>> See Steve's email here:
>> https://lists.01.org/pipermail/linux-nvdimm/2019-August/023390.html
>>
>> Essentially it lets sysadmins create a simple, maximal configuration
>> without everyone having to script it.
> 
> It also gives a touch point to start thinking about parallel namespace
> creation. The large advancements in boot time that Alex achieved were
> mainly from parallelizing namespace init. With --continue we could
> batch the namespace enable calls and kick off a bind thread per
> namespace.
> 

Thanks Dan!  Sorry I was reading email backwards, just caught up with 
the earlier discussions.

With the --continue option, assuming the --size option will be taken if 
specified, it would be possible to end up with a large number of small 
namespaces
with a simple command that runs for a long while, right? can it be 
killed by ctrl-c once the innocent user regrets? :)

thanks,
-jane

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
