Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D758920214B3F
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 02:46:03 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x7S9hQFp004179
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 05:43:59 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
 by mx0b-001b2d01.pphosted.com with ESMTP id 2unpue1213-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 05:43:59 -0400
Received: from localhost
 by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Wed, 28 Aug 2019 10:43:57 +0100
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH] ndctl: Use the same align value as original namespace on
 reconfigure
In-Reply-To: <a6f0635109d75489144bd1b5985e8da44110b01b.camel@intel.com>
References: <20190807044416.30799-1-aneesh.kumar@linux.ibm.com>
 <a6f0635109d75489144bd1b5985e8da44110b01b.camel@intel.com>
Date: Wed, 28 Aug 2019 15:13:50 +0530
MIME-Version: 1.0
Message-Id: <87o909oca1.fsf@linux.ibm.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, Williams,
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

"Verma, Vishal L" <vishal.l.verma@intel.com> writes:

> On Wed, 2019-08-07 at 10:14 +0530, Aneesh Kumar K.V wrote:
>> When using reconfigure command to add a `name` to the namespace we end
>> up updating the align attribute. Avoid this by using the value from
>> the original namespace. Do this only if we are keeping the namespace mode
>> same.
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>> ---
>>  ndctl/namespace.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>
> Hi Aneesh,
>
> A few comments below:
>
>> 
>> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
>> index 1f212a2b3a9b..24e51bb35ae1 100644
>> --- a/ndctl/namespace.c
>> +++ b/ndctl/namespace.c
>> @@ -596,6 +596,22 @@ static int validate_namespace_options(struct ndctl_region *region,
>>  			return -ENXIO;
>>  		}
>>  	} else {
>> +
>> +		/*
>> +		 * If we are tryint to reconfigure with the same namespace mode
>
>                              ^trying
>
>> +		 * Use the align details from the origin namespace. Otherwise
>
> s/origin/original/
>
>> +		 * pick the align details from seed namespace
>> +		 */
>> +		if (ndns && p->mode == ndctl_namespace_get_mode(ndns)) {
>
> Do we need to depend on the mode here?
>
> I'm thinking it should be sufficient to do:
>   1. Check We're in 'reconfigure'
>   2. Check param.align was not supplied
>   3. Get alignment from the pfn/dax personality, and just use that.
>
> Does this make sense (Maybe I'm missing something).

We want to use the align value from the seed when we are trying
to reconfigure a namespace with a different mode. ie, if we are moving a
fsdax namespace with align value 64K to a devdax, IMHO we should pick 16M
as alignment for devdax.

>
>> +			struct ndctl_pfn *ns_pfn = ndctl_namespace_get_pfn(ndns);
>> +			struct ndctl_dax *ns_dax = ndctl_namespace_get_dax(ndns);
>> +			if (ns_pfn)
>> +				p->align = ndctl_pfn_get_align(ns_pfn);
>> +			else if (ns_dax)
>> +				p->align = ndctl_dax_get_align(ns_dax);
>> +			else
>> +				p->align = sysconf(_SC_PAGE_SIZE);
>
> Do we need the page size fallback here - there are other checks after
> this point that also do a similar fallback, do they not catch the
> default case?


I did that to simplify the code with that `else if`  

>
>> +		} else
>>  		/*
>>  		 * Use the seed namespace alignment as the default if we need
>>  		 * one. If we don't then use PAGE_SIZE so the size_align

-aneesh

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
