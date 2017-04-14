Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5AF8F2194EB69
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 12:04:01 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id x184so10979139oia.1
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 12:04:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1492196446.1657.1.camel@intel.com>
References: <20170414000251.23904-1-vishal.l.verma@intel.com>
 <F7CF62AA-B1F5-486D-AA87-F61674B86AC5@intel.com>
 <1492196446.1657.1.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 12:04:00 -0700
Message-ID: <CAPcyv4hc8d15yUs133ZG5V4+7R+CfdPaDA0661JX95ZcnLK0sw@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, check: Add a sigbus handler to detect
 metadata corruption
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 14, 2017 at 12:00 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Fri, 2017-04-14 at 00:10 +0000, Rudoff, Andy wrote:
>> > If we have poison/badblocks in the BTT metadata sections, the mmap-
>> > reads
>> > happening in the checker will trigger a SIGBUS, and the program
>> > will
>> > halt abruptly. Add a sigbus handler which notifies the user of
>> > this, and
>> > prints out a relevant error message:
>> >
>> >  namespace5.0: namespace_check: checking namespace5.0
>> >  namespace5.0: btt_discover_arenas: found 1 BTT arena
>> >  namespace5.0: btt_check_arenas: checking arena 0
>> >  namespace5.0: namespace_check: Received a SIGBUS
>> >  namespace5.0: namespace_check: Metadata corruption found, recovery
>> > is not possible
>> >  error checking namespaces: Bad address
>>
>> If in repair mode, should a SIGBUS cause you to set the error state
>> in the associated arena?
>>
>> -andy
>>
> So I thought a bit about this -
> While we can set the error state, that leaves the BTT with no way to
> get any data off it (currently).
>
> If we allow the kernel to enable the namespace, the user has some
> chance to do at least partial recovery until they hit the badblock.
> (assuming the badblock is in the map, which is the largest on-disk
> structure). If it is on the flog or info block, then, yes, there is no
> recovery.

Also, the kernel currently does nothing with the error bit besides
print out that it saw it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
