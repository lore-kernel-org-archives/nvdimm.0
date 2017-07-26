Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x229.google.com (mail-yw0-x229.google.com
 [IPv6:2607:f8b0:4002:c05::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 94A2121D091AC
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 13:17:38 -0700 (PDT)
Received: by mail-yw0-x229.google.com with SMTP id u207so33253219ywc.3
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 13:19:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9f1c0f31-7e74-3c1d-b88a-406db8f4c43f@hpe.com>
References: <150109896285.13943.15686058156974485950.stgit@dwillia2-desk3.amr.corp.intel.com>
 <9f1c0f31-7e74-3c1d-b88a-406db8f4c43f@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jul 2017 13:19:40 -0700
Message-ID: <CAPcyv4hEGA2xaEGsht4v3HBTX=gXjwL-OHQppLVNfbpeUxK-qw@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl,
 create-namespace: fix size alignment validation
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

On Wed, Jul 26, 2017 at 1:12 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 7/26/2017 3:56 PM, Dan Williams wrote:
>>
>> Linda reports:
>>
>>     I was creating a namespace on a 4-way interleave set and got an error
>>     I didn't expect:
>>
>>     $ sudo ndctl create-namespace -m sector -s 10G -n number2
>>       Error: '--size=' must align to interleave-width: 4 and alignment:
>> 2097152
>>       did you intend --size=12G?
>>
>>     What's happening is that since I specified my size in units of G,
>>     the function wants the namespace to be 1G * 4 aligned rather than
>>     2M * 4 aligned.
>>
>> Fix this by using the base "align * interleave_ways" for the alignment
>> check, and later calculate a 'friendly' recommended size value that
>> takes into account the units specified for --size.
>>
>> Reported-by: Linda Knippers <linda.knippers@hpe.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  ndctl/namespace.c |    9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
>> index 73a422633a0f..c4d70c39c6c4 100644
>> --- a/ndctl/namespace.c
>> +++ b/ndctl/namespace.c
>> @@ -557,8 +557,7 @@ static int validate_namespace_options(struct
>> ndctl_region *region,
>>
>>         /* (re-)validate that the size satisfies the alignment */
>>         ways = ndctl_region_get_interleave_ways(region);
>> -       size_align = max(units, size_align) * ways;
>> -       if (p->size % size_align) {
>> +       if (p->size % (size_align * ways)) {
>>                 char *suffix = "";
>>
>>                 if (units == SZ_1K)
>> @@ -570,6 +569,12 @@ static int validate_namespace_options(struct
>> ndctl_region *region,
>>                 else if (units == SZ_1T)
>>                         suffix = "T";
>>
>> +               /*
>> +                * Make the recommendation in the units of the '--size'
>> +                * option
>> +                */
>> +               size_align = max(units, size_align) * ways;
>
>
> I can't test this because I don't have the system now but doesn't this
> introduce the same problem, but only in the failure case?  I think I'll
> get a different recommendation if I use a size of 1M vs. 1024K vs. just
> bytes.
> Or is that what you want?  You want the closest value in that unit rather
> than
> the closest value that would meet the requirements?

Right, the former, i.e. the closest without changing units.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
