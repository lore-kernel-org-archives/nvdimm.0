Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x231.google.com (mail-ob0-x231.google.com
 [IPv6:2607:f8b0:4003:c01::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3098A1A1E5E
 for <linux-nvdimm@lists.01.org>; Wed,  9 Mar 2016 15:07:51 -0800 (PST)
Received: by mail-ob0-x231.google.com with SMTP id m7so62974545obh.3
 for <linux-nvdimm@lists.01.org>; Wed, 09 Mar 2016 15:07:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457564634.4525.32.camel@intel.com>
References: <20160308224713.16298.33547.stgit@dwillia2-desk3.jf.intel.com>
 <20160308224718.16298.47066.stgit@dwillia2-desk3.jf.intel.com>
 <1457564634.4525.32.camel@intel.com>
Date: Wed, 9 Mar 2016 15:07:36 -0800
Message-ID: <CAPcyv4gjGV3jXJuKh8i6sQ2X+BAxayiXVQtNUsgo5VLi7rQjAA@mail.gmail.com>
Subject: Re: [PATCH 1/3] nfit, libnvdimm: clear poison command support
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 9, 2016 at 3:03 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Tue, 2016-03-08 at 14:47 -0800, Dan Williams wrote:
>> Add the boiler-plate for a 'clear error' command based on section
>> 9.20.7.6 "Function Index 4 - Clear Uncorrectable Error" from the ACPI
>> 6.1 specification, and add a reference implementation in nfit_test.
>>
>> Cc: Vishal Verma <vishal.l.verma@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/acpi/nfit.c              |   12 +++++++++++-
>>  drivers/nvdimm/bus.c             |   19 +++++++++++++++++++
>>  include/uapi/linux/ndctl.h       |   13 +++++++++++++
>>  tools/testing/nvdimm/test/nfit.c |   29 +++++++++++++++++++++++++++++
>>  4 files changed, 72 insertions(+), 1 deletion(-)
>>
>
> <snip>
>
>> diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
>> index cc68b92124d4..0f001c571cdd 100644
>> --- a/include/uapi/linux/ndctl.h
>> +++ b/include/uapi/linux/ndctl.h
>> @@ -98,6 +98,14 @@ struct nd_cmd_ars_status {
>>       } __packed records[0];
>>  } __packed;
>>
>> +struct nd_cmd_clear_error {
>> +     __u64 address;
>> +     __u64 length;
>> +     __u32 status;
>> +     __u8 reserved[4];
>> +     __u64 cleared;
>> +} __packed;
>> +
>>  enum {
>>       ND_CMD_IMPLEMENTED = 0,
>>
>> @@ -105,6 +113,7 @@ enum {
>>       ND_CMD_ARS_CAP = 1,
>>       ND_CMD_ARS_START = 2,
>>       ND_CMD_ARS_STATUS = 3,
>> +     ND_CMD_CLEAR_ERROR = 4,
>>
>>       /* per-dimm commands */
>>       ND_CMD_SMART = 1,
>> @@ -129,6 +138,7 @@ static inline const char
>> *nvdimm_bus_cmd_name(unsigned cmd)
>>               [ND_CMD_ARS_CAP] = "ars_cap",
>>               [ND_CMD_ARS_START] = "ars_start",
>>               [ND_CMD_ARS_STATUS] = "ars_status",
>> +             [ND_CMD_CLEAR_ERROR] = "clear_error",
>>       };
>>
>>       if (cmd < ARRAY_SIZE(names) && names[cmd])
>> @@ -187,6 +197,9 @@ static inline const char *nvdimm_cmd_name(unsigned
>> cmd)
>>  #define ND_IOCTL_ARS_STATUS          _IOWR(ND_IOCTL,
>> ND_CMD_ARS_STATUS,\
>>                                       struct nd_cmd_ars_status)
>>
>> +#define ND_IOCTL_CLEAR_ERROR         _IOWR(ND_IOCTL,
>> ND_CMD_CLEAR_ERROR,\
>> +                                     struct nd_cmd_ars_status)
>> +
>
> Typo here? Should be struct nd_cmd_clear_error.

Good catch!

/me goes to write the libndctl enabling for this command which also
would have caught this.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
