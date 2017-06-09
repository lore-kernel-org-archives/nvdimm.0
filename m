Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x235.google.com (mail-ot0-x235.google.com
 [IPv6:2607:f8b0:4003:c0f::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 335BC21A143C4
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 22:27:43 -0700 (PDT)
Received: by mail-ot0-x235.google.com with SMTP id t31so33904260ota.1
 for <linux-nvdimm@lists.01.org>; Thu, 08 Jun 2017 22:28:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f9c399bb-7ef7-7a95-cbf4-5937a8737b92@suse.de>
References: <cover.1496852665.git.jerry.hoemann@hpe.com>
 <1fa949387694a4b6200309d592e78f435f065f75.1496852665.git.jerry.hoemann@hpe.com>
 <f9c399bb-7ef7-7a95-cbf4-5937a8737b92@suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 8 Jun 2017 22:28:51 -0700
Message-ID: <CAPcyv4jruPLuqU-6s_2e_FtTtPuMPg9bkbR1qw8VNXsj=EUqpg@mail.gmail.com>
Subject: Re: [PATCH 3/3] libnvdimm: New ACPI 6.2 DSM functions
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 8, 2017 at 1:02 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On 06/07/2017 07:04 PM, Jerry Hoemann wrote:
>> @@ -179,6 +217,10 @@ static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
>>               [ND_CMD_ARS_START] = "ars_start",
>>               [ND_CMD_ARS_STATUS] = "ars_status",
>>               [ND_CMD_CLEAR_ERROR] = "clear_error",
>> +             [5] = "trans_spa",
>> +             [7] = "ars_err_inj",
>> +             [8] = "ars_err_inj_clr",
>> +             [9] = "ars_err_inj_stat",
>>               [ND_CMD_CALL] = "cmd_call",
>>       };
>
> Can you please add the new values to the enum in uapi/ndctl.h? I don't
> really like the magic numbers here.

I think the reason Jerry didn't add them is due to symmetry. All the
current ND_CMD_ definitions have corresponding ND_IOCTL_ definitions.
These new commands we're only adding function number support and using
ND_CMD_CALL for the ioctl transport. We can still add definitions for
them, but perhaps with an ACPI_NFIT_DSM_ prefix? The only consumer in
the kernel of this is debug output code. I think perhaps we should
just delete them here and either print raw numbers or enable
acpi_nfit_ctl() to the decode and not rely on nvdimm_bus_cmd_name()
which is meant to represent NVDIMM bus type generic command numbers.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
