Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4BEA11A1F5F
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 20:08:48 -0800 (PST)
Received: by mail-oi0-x22e.google.com with SMTP id c203so77182951oia.2
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 20:08:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457659174.4525.39.camel@intel.com>
References: <20160311004511.27582.63304.stgit@dwillia2-desk3.jf.intel.com>
 <20160311004526.27582.46416.stgit@dwillia2-desk3.jf.intel.com>
 <1457659174.4525.39.camel@intel.com>
Date: Thu, 10 Mar 2016 20:08:32 -0800
Message-ID: <CAPcyv4j7-G1eVsm8ovAbNuf3tLRt-gTUmL_4BvgouRK5N_0eSg@mail.gmail.com>
Subject: Re: [ndctl PATCH 3/3] ndctl: add 'clear error' command support
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 10, 2016 at 5:19 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Thu, 2016-03-10 at 16:45 -0800, Dan Williams wrote:
>> Import the clear error command definition from the latest kernel, wire
>> it up with a new ndctl_bus_cmd_new_clear_error() api, and add an
>> invocation to the unit test.
>>
>> Since, the unit test requires the ability to recall the range of an
>> ars_cap command a new ndctl_cmd_ars_cap_get_range() api is added.
>>
>> Reported-by: Vishal Verma <vishal.l.verma@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  configure.ac           |   19 +++++++
>>  lib/libndctl-ars.c     |  125
>> +++++++++++++++++++++++++++++++++++++++++++-----
>>  lib/libndctl-private.h |    5 ++
>>  lib/libndctl.c         |    3 +
>>  lib/libndctl.sym       |    3 +
>>  lib/ndctl/libndctl.h   |   41 +++++++++++++++-
>>  ndctl.h                |   13 +++++
>>  test/libndctl.c        |   62 +++++++++++++++++++++++-
>>  8 files changed, 253 insertions(+), 18 deletions(-)
>>
>>
>
> <>
>
>> diff --git a/ndctl.h b/ndctl.h
>> index 0c50ff4dc3b1..11c4adf7f49c 100644
>> --- a/ndctl.h
>> +++ b/ndctl.h
>> @@ -98,6 +98,14 @@ struct nd_cmd_ars_status {
>>       } __attribute__((packed)) records[0];
>>  } __attribute__((packed));
>>
>> +struct nd_cmd_clear_error {
>> +     __u64 address;
>> +     __u64 length;
>> +     __u32 status;
>> +     __u8 reserved[4];
>> +     __u64 cleared;
>> +} __attribute__((packed));
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
>> @@ -129,6 +138,7 @@ static __inline__ const char
>> *nvdimm_bus_cmd_name(unsigned cmd)
>>               [ND_CMD_ARS_CAP] = "ars_cap",
>>               [ND_CMD_ARS_START] = "ars_start",
>>               [ND_CMD_ARS_STATUS] = "ars_status",
>> +             [ND_CMD_CLEAR_ERROR] = "clear_error",
>>       };
>>
>>       if (cmd < ARRAY_SIZE(names) && names[cmd])
>> @@ -187,6 +197,9 @@ static __inline__ const char
>> *nvdimm_cmd_name(unsigned cmd)
>>  #define ND_IOCTL_ARS_STATUS          _IOWR(ND_IOCTL,
>> ND_CMD_ARS_STATUS,\
>>                                       struct nd_cmd_ars_status)
>>
>> +#define ND_IOCTL_CLEAR_ERROR         _IOWR(ND_IOCTL,
>> ND_CMD_CLEAR_ERROR,\
>> +                                     struct nd_cmd_ars_status)
>> +
>
> Did you copy from the old version of this kernel header with the copy-
> paste error :)
>

If I said "no" I don't think you'd believe me.

> Rest of it looks good,
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

Thanks!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
