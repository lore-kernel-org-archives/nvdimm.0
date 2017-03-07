Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0AA2C8029F
 for <linux-nvdimm@lists.01.org>; Tue,  7 Mar 2017 08:00:59 -0800 (PST)
Subject: Re: [PATCH 4/5] acpi_nfit, libnvdimm: Add support for clear poison
 list and bad blocks
References: <148883211285.49239.17952572594430933942.stgit@djiang5-desk3.ch.intel.com>
 <148883236818.49239.12371446691877974041.stgit@djiang5-desk3.ch.intel.com>
 <ca401cc3-db44-32a7-ecc5-2c06c0322177@suse.de>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <7c50af6b-558d-76c8-faae-228e224fae75@intel.com>
Date: Tue, 7 Mar 2017 09:00:58 -0700
MIME-Version: 1.0
In-Reply-To: <ca401cc3-db44-32a7-ecc5-2c06c0322177@suse.de>
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
To: Johannes Thumshirn <jthumshirn@suse.de>, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 03/07/2017 02:30 AM, Johannes Thumshirn wrote:
> On 03/06/2017 09:32 PM, Dave Jiang wrote:
>> Providing mechanism to clear poison list via the ndctl ND_CMD_CLEAR_ERROR
>> call. We will update the poison list and also the badblocks at region level
>> if the region is in dax mode or in pmem mode and not active.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
> 
> [...]
> 
>> +	if ((cmd != ND_CMD_CLEAR_ERROR) || !nvdimm_bus || !clear_err->cleared)
>              ^~ Unnecessary parenthesis?
> 
> [...]
> 
>> +
>> +		/* make sure clear_err range is within a SPA range */
>> +		if (((clear_begin >= spa_begin) &&
>> +					(clear_begin < (spa_end))) &&
>> +				((clear_end > spa_begin) &&
>> +				 (clear_end <= spa_end))) {
> 
> Indentation looks a bit odd here and the superfluous parenthesis aren't
> improving the situation.
> 
> [...]

I'll fix that.

> 
> 
>> +	if (nd_btt || nd_pfn || nd_dax) {
>> +		if (nd_btt)
>> +			ndns = nd_btt->ndns;
>> +		else if (nd_pfn)
>> +			ndns = nd_pfn->ndns;
>> +		else if (nd_dax)
>> +			ndns = nd_dax->nd_pfn.ndns;
>> +
>> +		if (!ndns)
>> +			return 0;
> 
> How can this (the !ndns case) ever happen?

So if nd_btt->ndns or nd_pfn->ndns or nd_dax->nd_pfn.ndns happens to be
NULL, then this case can happen. I don't know how likely that is to
happen however. The code was lifted from nvdimm_namespace_common_probe().

> 
> And anyways isn't this sufficient, or am I missing something:
> 
> 	if (nd_btt)
> 		ndns = nd_btt->ndns;
> 	else if (nd_pfn)
> 		ndns = nd_pfn->ndns;
> 	else if (nd_dax)
> 		ndns = nd_dax->nd_pfn.ndns;
> 	else
> 		ndns = to_ndns(dev);
> 
>> +	} else
>> +		ndns = to_ndns(dev);
>> +
> 
> Thanks,
> 	Johannes
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
