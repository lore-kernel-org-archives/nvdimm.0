Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-BL2-obe.outbound.protection.outlook.com
 (mail-bl2nam02on072a.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe46::72a])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 444D91A1ECA
 for <linux-nvdimm@lists.01.org>; Wed,  7 Sep 2016 05:49:29 -0700 (PDT)
From: "Boylston, Brian" <brian.boylston@hpe.com>
Subject: RE: [ndctl PATCH 2/2] ndctl, util: add support for HPE DSM SMART
 interfaces
Date: Wed, 7 Sep 2016 12:49:27 +0000
Message-ID: <CS1PR84MB01195F5EB620AFB55810D3AD8EF80@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
References: <20160902133238.22200-1-brian.boylston@hpe.com>
 <20160902133238.22200-3-brian.boylston@hpe.com>
 <CAPcyv4is4DqFi5yeW+hqegL5ArL7dvtxaZt9hwxii4gWcud0jA@mail.gmail.com>
In-Reply-To: <CAPcyv4is4DqFi5yeW+hqegL5ArL7dvtxaZt9hwxii4gWcud0jA@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams wrote on 2016-09-03:
> On Fri, Sep 2, 2016 at 6:32 AM, Brian Boylston <brian.boylston@hpe.com> wrote:
>> This patch introduces util_hpe_dimm_health_to_json(), which calls the HPE
>> DSM functions defined in [1] and populates a JSON object with health data.
>> This delivers health reporting parity for HPE type N NVDIMMs, but we are
>> planning a future patch to export JSON for some of the additional health
>> data defined in [1].
>> 
>> [1]
>> https://github.com/HewlettPackard/hpe-nvm/raw/master/Documentation/NFIT_
>> DSM_DDR4_NVDIMM- N_v84s.pdf
>> 
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Reviewed-by: Jerry Hoemann <jerry.hoemann@hpe.com>
>> Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
>> ---
>>  ndctl/Makefile.am       |   1 +
>>  ndctl/builtin-list.c    |   2 +
>>  ndctl/util/json-hpe.c   | 283 ++++++++++++++++++++++++++++++++++++++++
>>  ndctl/util/json.h       |   6 +
>>  ndctl/util/ndctl-hpe1.h | 335 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  5 files changed, 627 insertions(+)
>>  create mode 100644 ndctl/util/json-hpe.c
>>  create mode 100644 ndctl/util/ndctl-hpe1.h
> 
> Great!  Let's get this merged...
> 
>> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
>> index 04f3a63..ee1e856 100644
>> --- a/ndctl/Makefile.am
>> +++ b/ndctl/Makefile.am
>> @@ -48,6 +48,7 @@ ndctl_SOURCES = ndctl.c \
>> 
>>  if ENABLE_SMART ndctl_SOURCES += util/json-smart.c +ndctl_SOURCES +=
>>  util/json-hpe.c endif
>>  
>>  if ENABLE_DESTRUCTIVE
>> diff --git a/ndctl/builtin-list.c b/ndctl/builtin-list.c
>> index 0875ca9..fb1a361 100644
>> --- a/ndctl/builtin-list.c
>> +++ b/ndctl/builtin-list.c
>> @@ -316,6 +316,8 @@ int cmd_list(int argc, const char **argv)
>>                                 struct json_object *jhealth;
>>                                 
>>                                 jhealth = util_dimm_health_to_json(dimm);
>> +                               if (!jhealth)
>> +                                       jhealth = util_hpe_dimm_health_to_json(dimm);
>>                                 if (jhealth)
> 
> I'd rather see ndctl_dimm_cmd_new_smart() learn how to generate the
> smart health cmd that is proper for the given family of the dimm, and
> handle any command format translation internal to the library rather
> than adding a separate util_dimm_health_to_json().

Thanks for the guidance, Dan.  I'll work on this and come back.

Brian

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
