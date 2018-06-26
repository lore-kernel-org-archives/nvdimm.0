Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 513D121A143EF
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 16:20:43 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id 18-v6so129627oiq.6
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 16:20:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1530053956.27147.34.camel@intel.com>
References: <20180626204649.7665-1-keith.busch@intel.com>
 <20180626204649.7665-2-keith.busch@intel.com>
 <1530053956.27147.34.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Jun 2018 16:20:42 -0700
Message-ID: <CAPcyv4giqb-SN96Jpq_o0_2R6TjR7N3uwf64YjUo_gKEkni3yw@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/2] ndctl: Add 'list' verbose documentation
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

On Tue, Jun 26, 2018 at 3:59 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Tue, 2018-06-26 at 14:46 -0600, Keith Busch wrote:
>> Signed-off-by: Keith Busch <keith.busch@intel.com>
>> ---
>>  Documentation/ndctl/ndctl-list.txt | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>
> I think this can all just go in the first patch?
>
>> diff --git a/Documentation/ndctl/ndctl-list.txt
>> b/Documentation/ndctl/ndctl-list.txt
>> index 13ebdcd..791638c 100644
>> --- a/Documentation/ndctl/ndctl-list.txt
>> +++ b/Documentation/ndctl/ndctl-list.txt
>> @@ -200,6 +200,18 @@ include::xable-region-options.txt[]
>>    ]
>>  }
>>
>> +-v::
>> +--verbose::
>> +     Increase verbosity of the output. This can be specified
>> +     multiple times to be even more verbose on the informational and
>> +     miscellaneous output, and can be used to override the flags for
>> +     showing specific information.
>
> Should we detail here what verbosity level enables which flags? Or is that
> too much upkeep in case things change..

Hopefully does not change too much. We've had some contention about
which fields are available in the listing, so it would be nice to give
a heads up when people say "hey! where did my numa node and
sector_size fields go?".
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
