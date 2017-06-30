Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9824A21BADABB
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 08:18:08 -0700 (PDT)
Subject: Re: Standardization of ACPI NVDIMM DSMs
References: <20170628094025.00001fc0@bluestop.org>
 <9f16559d-fc0f-ad0d-2c13-1fc0b38aa733@hpe.com>
 <20170630101854.B36F.E1E9C6FF@jp.fujitsu.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <1b5d08fa-620b-0233-2cc4-8648a631931e@hpe.com>
Date: Fri, 30 Jun 2017 11:19:35 -0400
MIME-Version: 1.0
In-Reply-To: <20170630101854.B36F.E1E9C6FF@jp.fujitsu.com>
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 6/29/2017 9:18 PM, Yasunori Goto wrote:
> Hello, Linda-san,
>
>> There is more standardization that will likely happen.  The most
>> interesting is probably standard health status information.  Today
>> the Linux ndctl command can display health status for the NVDIMMs
>> and it hides some of the differences by calling the appropriate
>> DSM for the platform/NVDIMM combination but we need to do more
>> work there.
>
> Could you tell me what works are necessary?

There is work in two areas.  One is standardization work, mostly
likely through the ACPI NVM working group of the UEFI Forum, to define
some common functions for health information.  There was a lot of work
focused on getting standardization of label formats and access
methods into ACPI 6.2 and UEFI 2.7 so not much effort yet on
health information but perhaps that will be next.

The other area is work within the ndctl tool itself.  It already
knows how to get some health information using the Intel, HPE, and
MSFT SMART health DSMs but there is more information related to
NVDIMM-N devices that we'd like to expose.

> I also have concern around here, and I'm investgating source code of
> ndctl and NVDIMM drivers to check what works are still needed.
> So, your opinion will be very helpful for me.

As an example, this is a patch I posted to expose more information.
https://lists.01.org/pipermail/linux-nvdimm/2017-June/010682.html
Dan had some feedback but I haven't had a chance to post a v2 patch yet.
The patch touches a number of files/functions that are involved in getting
the health information so you could look at those to see how it works today.

If there is a particular type of NVDIMM or existing DSM specification
that you're interesting in supporting, that would be interesting to know.
If you're thinking of defining something new, I encourage you to get
involved in the standards activities.

Thanks,

-- ljk

>
> Thanks.
>
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
