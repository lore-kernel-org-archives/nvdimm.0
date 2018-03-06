Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EECA022135D28
 for <linux-nvdimm@lists.01.org>; Tue,  6 Mar 2018 13:00:26 -0800 (PST)
Subject: Re: [PATCH v2 1/2] ndctl: add check for update firmware supported
References: <152036051666.9605.11333285528137008907.stgit@djiang5-desk3.ch.intel.com>
 <152036074146.9605.16255604270824668249.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4ioOKcoDthYZVMvHSpWEnXrv1H8RF7yMyoqOdr7xBLpYw@mail.gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <48b09848-1304-2a3f-448c-42d01597331e@intel.com>
Date: Tue, 6 Mar 2018 14:06:40 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4ioOKcoDthYZVMvHSpWEnXrv1H8RF7yMyoqOdr7xBLpYw@mail.gmail.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 03/06/2018 01:55 PM, Dan Williams wrote:
> On Tue, Mar 6, 2018 at 10:25 AM, Dave Jiang <dave.jiang@intel.com> wrote:
>> Adding generic and intel support function to allow check if update firmware
>> is supported by the kernel.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> [..]
>> diff --git a/ndctl/update.c b/ndctl/update.c
>> index 0f0f0d81..b4ae1ddb 100644
>> --- a/ndctl/update.c
>> +++ b/ndctl/update.c
>> @@ -449,11 +449,24 @@ static int get_ndctl_dimm(struct update_context *uctx, void *ctx)
>>  {
>>         struct ndctl_dimm *dimm;
>>         struct ndctl_bus *bus;
>> +       int rc;
>>
>>         ndctl_bus_foreach(ctx, bus)
>>                 ndctl_dimm_foreach(bus, dimm) {
>>                         if (!util_dimm_filter(dimm, uctx->dimm_id))
>>                                 continue;
>> +                       rc = ndctl_dimm_fw_update_supported(dimm);
>> +                       switch (rc) {
>> +                       case -ENOTTY:
>> +                               error("DIMM firmware update not supported by ndctl.");
>> +                               return rc;
>> +                       case -EOPNOTSUPP:
>> +                               error("DIMM firmware update not supported by the kernel");
>> +                               return rc;
>> +                       case -EIO:
>> +                               error("DIMM firmware update not supported by platform firmware.");
> 
> I like that you separated the no ND_CMD_CALL case from the
> test_dimm_dsm(ND_INTEL_FW_GET_INFO) case, however this error message
> should be:
> 
>      "DIMM firmware update not supported by either platform firmware
> or the kernel"
> 
> ...because it could be the case that the kernel has ND_CMD_CALL
> support but has not been updated for the given DSM mask.
> 
> Other than that you can add:
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 

Thanks. I'll just change it in patch 2/2 instead of here.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
