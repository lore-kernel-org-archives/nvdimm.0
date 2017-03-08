Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F94A8032B
 for <linux-nvdimm@lists.01.org>; Wed,  8 Mar 2017 08:29:16 -0800 (PST)
Subject: Re: [PATCH 3/5] acpi: cleanup acpi_nfit_ctl calling xlat_status
References: <148883211285.49239.17952572594430933942.stgit@djiang5-desk3.ch.intel.com>
 <148883236278.49239.9457895421265109054.stgit@djiang5-desk3.ch.intel.com>
 <58BF4E4D.8000406@hpe.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <e565aec9-b400-6712-25b2-904a64b87dc4@intel.com>
Date: Wed, 8 Mar 2017 09:29:15 -0700
MIME-Version: 1.0
In-Reply-To: <58BF4E4D.8000406@hpe.com>
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
To: Linda Knippers <linda.knippers@hpe.com>, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 03/07/2017 05:20 PM, Linda Knippers wrote:
> On 03/06/2017 03:32 PM, Dave Jiang wrote:
>> Make sure that xlat_status is unconditionally called.
> 
> Is this just code cleanup or is it fixing something?

This is code clean up requested by Dan.

> 
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  drivers/acpi/nfit/core.c |   15 +++++++--------
>>  1 file changed, 7 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
>> index 7361d00..9d4f461 100644
>> --- a/drivers/acpi/nfit/core.c
>> +++ b/drivers/acpi/nfit/core.c
>> @@ -199,7 +199,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>>  	acpi_handle handle;
>>  	unsigned int func;
>>  	const u8 *uuid;
>> -	int rc, i;
>> +	int rc = 0, xlat_rc, i;
>>  
>>  	func = cmd;
>>  	if (cmd == ND_CMD_CALL) {
>> @@ -343,21 +343,20 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>>  			 * unfilled in the output buffer
>>  			 */
>>  			rc = buf_len - offset - in_buf.buffer.length;
>> -			if (cmd_rc)
>> -				*cmd_rc = xlat_status(nvdimm, buf, cmd,
>> -						fw_status);
>>  		} else {
>>  			dev_err(dev, "%s:%s underrun cmd: %s buf_len: %d out_len: %d\n",
>>  					__func__, dimm_name, cmd_name, buf_len,
>>  					offset);
>>  			rc = -ENXIO;
>> +			goto out;
>>  		}
>> -	} else {
>> -		rc = 0;
>> -		if (cmd_rc)
>> -			*cmd_rc = xlat_status(nvdimm, buf, cmd, fw_status);
>>  	}
>>  
>> +	xlat_rc = xlat_status(nvdimm, buf, cmd, fw_status);
>> +
>> +	if (cmd_rc)
>> +		*cmd_rc = xlat_rc;
> 
> Is there some benefit of calling xlat_status and then throwing away the result?

It's not exactly thrown away. I tried to preserve the original code path
as much as possible. So in the current case, if xlat_status() fails,
then *cmd_rc gets it like in the original code. If it's succeeds, then
the forget_poison provides the status instead.

> 
>> +
>>   out:
>>  	ACPI_FREE(out_obj);
>>  
>>
>> _______________________________________________
>> Linux-nvdimm mailing list
>> Linux-nvdimm@lists.01.org
>> https://lists.01.org/mailman/listinfo/linux-nvdimm
>>
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
