Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam02on072d.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe44::72d])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5BF081A1E06
 for <linux-nvdimm@lists.01.org>; Fri,  2 Sep 2016 09:31:49 -0700 (PDT)
From: "Boylston, Brian" <brian.boylston@hpe.com>
Subject: RE: [ndctl PATCH 2/2] ndctl, util: add support for HPE DSM SMART
 interfaces
Date: Fri, 2 Sep 2016 16:31:47 +0000
Message-ID: <CS1PR84MB0119C5EBB8A0720D9BA5CFDC8EE50@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
References: <20160902133238.22200-1-brian.boylston@hpe.com>
 <20160902133238.22200-3-brian.boylston@hpe.com>
 <20160902142405.frslxn2zocx5joga@c203.arch.suse.de>
In-Reply-To: <20160902142405.frslxn2zocx5joga@c203.arch.suse.de>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Johannes Thumshirn wrote on 2016-09-02:
> On Fri, Sep 02, 2016 at 08:32:38AM -0500, Brian Boylston wrote:
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
>>  				struct json_object *jhealth;
>>  
>>  				jhealth = util_dimm_health_to_json(dimm);
>> +				if (!jhealth)
>> +					jhealth = util_hpe_dimm_health_to_json(dimm);
> 
> Try and error probing for the correct vendor? There surely must be a
> better way to do.

Yes, sorry, I had intended to raise this in the cover, but forgot.
util_dimm_health_to_json() results in a check to see if ND_CMD_SMART is
supported by the device.  It isn't supported by our type N DIMMs, so I
don't think ndctl gets as far as actually attempting the ioctl.  I didn't
see an existing ndctl_dimm_is_cmd_supported() equivalent for the DSM
families (NVDIMM_FAMILY_*), so I started with the smallest change to the
existing framework.

Any suggestions here?

What about adding an ndctl_dimm_is_family_supported()?  Is there a way to
determine support other than by probing (e.g. trying function 0 for each
family)?

> 
> But anyway nice job Brian (way better than my attempts to "live patch"
> the ioctls in the kernel)

Thanks.  The similarities in the interface make it tempting, but massaging
the differences probably becomes awkward.

Brian

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
