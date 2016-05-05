Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 349C51A1F3D
 for <linux-nvdimm@lists.01.org>; Thu,  5 May 2016 16:38:52 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id v145so120923153oie.0
 for <linux-nvdimm@lists.01.org>; Thu, 05 May 2016 16:38:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160505162451.GB6808@tevye.fc.hp.com>
References: <146189774241.29835.12947278159500915461.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146189774794.29835.11997438198616276280.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160505162451.GB6808@tevye.fc.hp.com>
Date: Thu, 5 May 2016 16:38:51 -0700
Message-ID: <CAPcyv4gVfWF_O0CFKON+263DfPO5SCTkTkM6QrJ0V9cg9U8wew@mail.gmail.com>
Subject: Re: [PATCH v11 1/5] nfit, libnvdimm: clarify "commands" vs "_DSMs"
From: Dan Williams <dan.j.williams@intel.com>
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
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Rafael J Wysocki <rafael.j.wysocki@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 5, 2016 at 9:24 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Thu, Apr 28, 2016 at 07:42:28PM -0700, Dan Williams wrote:
>> Clarify the distinction between "commands", the ioctls userspace calls
>> to request the kernel take some action on a given dimm device, and
>> "_DSMs", the actual function numbers used in the firmware interface to
>> the DIMM.  _DSMs are ACPI specific whereas commands are Linux kernel
>> generic.
>>
>> This is in preparation for breaking the 1:1 implicit relationship
>> between the kernel ioctl number space and the firmware specific function
>> numbers.
>>
>> Cc: Jerry Hoemann <jerry.hoemann@hpe.com>
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/acpi/nfit.c              |   21 +++++++++++++--------
>>  drivers/acpi/nfit.h              |    4 ++--
>>  drivers/nvdimm/bus.c             |    8 ++++----
>>  drivers/nvdimm/core.c            |    2 +-
>>  drivers/nvdimm/dimm_devs.c       |   18 ++++++++++++------
>>  drivers/nvdimm/nd-core.h         |    2 +-
>>  include/linux/libnvdimm.h        |    5 +++--
>>  tools/testing/nvdimm/test/nfit.c |   27 ++++++++++++++-------------
>>  8 files changed, 50 insertions(+), 37 deletions(-)
>>
>
> ....
>
>
>> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
>> index 3187322eeed7..ed899a411c22 100644
>> --- a/tools/testing/nvdimm/test/nfit.c
>> +++ b/tools/testing/nvdimm/test/nfit.c
>> @@ -344,8 +344,9 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
>>
>>       if (nvdimm) {
>>               struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
>> +             unsigned long cmd_mask = nvdimm_cmd_mask(nvdimm);
>>
>> -             if (!nfit_mem || !test_bit(cmd, &nfit_mem->dsm_mask))
>> +             if (!nfit_mem || !test_bit(cmd, &cmd_mask))
>>                       return -ENOTTY;
>>
>>               /* lookup label space for the given dimm */
>> @@ -374,7 +375,7 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
>>       } else {
>>               struct ars_state *ars_state = &t->ars_state;
>>
>> -             if (!nd_desc || !test_bit(cmd, &nd_desc->dsm_mask))
>> +             if (!nd_desc || !test_bit(cmd, &nd_desc->cmd_mask))
>>                       return -ENOTTY;
>>
>>               switch (cmd) {
>> @@ -1251,13 +1252,13 @@ static void nfit_test0_setup(struct nfit_test *t)
>>       post_ars_status(&t->ars_state, t->spa_set_dma[0], SPA0_SIZE);
>>
>>       acpi_desc = &t->acpi_desc;
>> -     set_bit(ND_CMD_GET_CONFIG_SIZE, &acpi_desc->dimm_dsm_force_en);
>> -     set_bit(ND_CMD_GET_CONFIG_DATA, &acpi_desc->dimm_dsm_force_en);
>> -     set_bit(ND_CMD_SET_CONFIG_DATA, &acpi_desc->dimm_dsm_force_en);
>> -     set_bit(ND_CMD_ARS_CAP, &acpi_desc->bus_dsm_force_en);
>> -     set_bit(ND_CMD_ARS_START, &acpi_desc->bus_dsm_force_en);
>> -     set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_dsm_force_en);
>> -     set_bit(ND_CMD_CLEAR_ERROR, &acpi_desc->bus_dsm_force_en);
>> +     set_bit(ND_CMD_GET_CONFIG_SIZE, &acpi_desc->dimm_cmd_force_en);
>> +     set_bit(ND_CMD_GET_CONFIG_DATA, &acpi_desc->dimm_cmd_force_en);
>> +     set_bit(ND_CMD_SET_CONFIG_DATA, &acpi_desc->dimm_cmd_force_en);
>> +     set_bit(ND_CMD_ARS_CAP, &acpi_desc->bus_cmd_force_en);
>> +     set_bit(ND_CMD_ARS_START, &acpi_desc->bus_cmd_force_en);
>> +     set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_cmd_force_en);
>> +     set_bit(ND_CMD_CLEAR_ERROR, &acpi_desc->bus_cmd_force_en);
>>  }
>
>
> Do you still want to have ND_CMD_CALL bit set?
>
> ND_CMD_CALL is defined in your next patch, so you'll need
> to re-order or put another patch to this function to set ND_CMD_CALL.

It's set automatically in acpi_nfit_register_dimms().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
