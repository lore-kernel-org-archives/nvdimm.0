Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C6EA21D2E623
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 14:45:38 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id k77so38071517oib.2
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 14:48:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1504042255.7034.1.camel@intel.com>
References: <150403689024.8240.10207637569759874850.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150403692821.8240.17921098591962254302.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1504042255.7034.1.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Aug 2017 14:48:17 -0700
Message-ID: <CAPcyv4jEGG8aRZOqJGJkuh=GfqFpsh1=BGchmjPXzS3b42vO7g@mail.gmail.com>
Subject: Re: [ndctl PATCH 7/7] ndctl: auto initialize labels
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

On Tue, Aug 29, 2017 at 2:32 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Tue, 2017-08-29 at 13:02 -0700, Dan Williams wrote:
>> If we are reconfiguring an ND_DEVICE_NAMESPACE_IO namespace take the
>> opportunity to potentially initialize labels. DIMM capacity that is
>> not
>> aliased will surface as a label-less namespace by default. If every
>> DIMM
>> in the interleave set supports labels we can switch a more dynamic
>> configuration, i.e. enable pmem sub-division.
>>
>> The --no-autolabel option is added to disable this behavior if it is
>> not
>> wanted.
>>
>> Cc: Vishal Verma <vishal.l.verma@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  Documentation/ndctl/ndctl-create-namespace.txt |    7 ++
>>  ndctl/namespace.c                              |   90
>> +++++++++++++++++++++++-
>>  2 files changed, 95 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/ndctl/ndctl-create-namespace.txt
>> b/Documentation/ndctl/ndctl-create-namespace.txt
>> index 85d1f8db792f..3844ff74a9f1 100644
>> --- a/Documentation/ndctl/ndctl-create-namespace.txt
>> +++ b/Documentation/ndctl/ndctl-create-namespace.txt
>> @@ -138,6 +138,13 @@ OPTIONS
>>       active.  Specifying --force causes the namespace to be
>> disabled
>>       before reconfiguring.
>>
>> +-L::
>> +--autolabel::
>
> Shouldn't this be --no-autolabel
>
>> +     When ndctl encounters a label-less namespace while
>> +     performing a reconfigure operation it will try to enable
>> labels
>> +     for the region. This behavior can be suppressed with
>> +     "--no-autolabel".
>
> And the text description matched to describe only the --no-autolabel
> option instead of describing both a positive and negative

I'm using a side effect of the way ndctl (and git) implement
OPT_BOOLEAN() options. They all automatically get a --no-<option>. So
"--autolabel" is the default.

>
>> +
>>  -v::
>>  --verbose::
>>       Emit debug messages for the namespace creation process
>>
>
> [...]
>
>> +
>> +     /* all the dimms must support labelling */
>
> s/labelling/labeling/

Yup, thanks.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
