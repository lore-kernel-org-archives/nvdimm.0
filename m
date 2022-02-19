Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F905393
	for <nvdimm@lists.linux.dev>; Sat, 19 Feb 2022 12:40:07 +0000 (UTC)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21JCGipa004231;
	Sat, 19 Feb 2022 12:39:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=peZXfNjMfPySnYJNhjOpCUNPLlJABAnFhtuiRRHqwvw=;
 b=A2BbjuZzfGYktMm80aGlwDmdp56uFfH2dFI27PVChAzqKFgmF2v2D4gxUqT3nwvP/Wam
 KDlYpg29CA7J6XTOlRPa6ZgQ3M1eYRnfUbsHAgYvj9EivnsGTl7peUQVGFFiGFXBfK1E
 fvysg/Oqqs3YwmuB+DxzVR7xZrgbaKDxYMqLXXuPNDXzhpZxSPCACX+6N1m0oOTw2zXa
 yOe/aLGZRj7RGZFjNvFMYL1gMZAXh1u/vTYHnPWp024h4agiRXB60lM0jLpLG69nMzRN
 819Guqfjo5UMyvTtkdLuzU4vzxB4cKtCJp2fTlWH/75MqIOpU8uut5bIDk029AUJWpTI 6w== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3eb0dt894h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Feb 2022 12:39:57 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
	by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21JCWZOH009817;
	Sat, 19 Feb 2022 12:39:56 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma01fra.de.ibm.com with ESMTP id 3ear68hj1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Feb 2022 12:39:56 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21JCdmHl56689110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Feb 2022 12:39:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 661A042045;
	Sat, 19 Feb 2022 12:39:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A95024203F;
	Sat, 19 Feb 2022 12:39:45 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.28.28])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Sat, 19 Feb 2022 12:39:45 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Sat, 19 Feb 2022 18:09:44 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "nvdimm@lists.linux.dev"
 <nvdimm@lists.linux.dev>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "sbhat@linux.ibm.com" <sbhat@linux.ibm.com>,
        "Weiny, Ira"
 <ira.weiny@intel.com>
Subject: Re: [ndctl PATCH v4] libndctl: Update nvdimm flags in
 ndctl_cmd_submit()
In-Reply-To: <555f5d150e4d55dce788bf0ebfbc029409b21260.camel@intel.com>
References: <20220124205822.1492702-1-vaibhav@linux.ibm.com>
 <555f5d150e4d55dce788bf0ebfbc029409b21260.camel@intel.com>
Date: Sat, 19 Feb 2022 18:09:44 +0530
Message-ID: <87h78v9gj3.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eepu8abOaUKulzwXQOI_WpVHb62B0olM
X-Proofpoint-ORIG-GUID: eepu8abOaUKulzwXQOI_WpVHb62B0olM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-19_04,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 adultscore=0 clxscore=1011 mlxlogscore=999
 phishscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202190081


Hi Vishal,

Thanks for reviewing this patch,

"Verma, Vishal L" <vishal.l.verma@intel.com> writes:

> On Tue, 2022-01-25 at 02:28 +0530, Vaibhav Jain wrote:
>> Presently after performing an inject-smart the nvdimm flags reported are
>> out of date as shown below where no 'smart_notify' or 'flush_fail' flags
>> were reported even though they are set after injecting the smart error:
>> 
>> $ sudo inject-smart -fU nmem0
>> [
>>   {
>>     "dev":"nmem0",
>>     "health":{
>>       "health_state":"fatal",
>>       "shutdown_state":"dirty",
>>       "shutdown_count":0
>>     }
>>   }
>> ]
>> $ sudo cat /sys/class/nd/ndctl0/device/nmem0/papr/flags
>> flush_fail smart_notify
>> 
>> This happens because nvdimm flags are only parsed once during its probe
>> and not refreshed even after a inject-smart operation makes them out of
>> date. To fix this the patch forces an update of nvdimm flags via newly
>> introduced ndctl_refresh_dimm_flags() thats called successfully submitting
>> a 'struct ndctl_cmd' in ndctl_cmd_submit(). This ensures that correct
>> nvdimm flags are reported after an interaction with the kernel module which
>> may trigger a change nvdimm-flags. With this implemented correct nvdimm
>> flags are reported after a inject-smart operation:
>> 
>> $ sudo ndctl inject-smart -fU nmem0
>> [
>>   {
>>     "dev":"nmem0",
>>     "flag_failed_flush":true,
>>     "flag_smart_event":true,
>>     "health":{
>>       "health_state":"fatal",
>>       "shutdown_state":"dirty",
>>       "shutdown_count":0
>>     }
>>   }
>> ]
>> 
>> The patch refactors populate_dimm_attributes() to move the nvdimm flags
>> parsing code to the newly introduced ndctl_refresh_dimm_flags()
>> export. Since reading nvdimm flags requires constructing path using
>> 'bus_prefix' which is only available during add_dimm(), the patch
>> introduces a new member 'struct ndctl_dimm.bus_prefix' to cache its
>> value. During ndctl_refresh_dimm_flags() the cached bus_prefix is used to
>> read the contents of the nvdimm flag file and pass it on to the appropriate
>> flag parsing function. Finally ndctl_refresh_dimm_flags() is invoked at the
>> end of ndctl_cmd_submit() if nd-command submission succeeds.
>
> I think instead of making it ndctl_cmd_submit()'s responsibility to
> update any stale state, we should simply NDCTL_EXPORT the refresh
> function (also rename it to conform to other ndctl_dimm functions -
> ndctl_dimm_refresh_flags()). Then if any operation expects to change
> state, it can call the refresh API directly.
>
> In this case, ndctl/inject-smart.c would call
> ndctl_dimm_refresh_flags() if its command submission succeeded.
Agree and will update v5 of the patch to
s/ndctl_refresh_dimm_flags/ndctl_dimm_refresh_flags/g

Also will make it a libndctl export that can be called after
smart-inject and before the nvdimm flags are reported.

>
> Also some minor comments below.
>
>> 
>> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
>> ---
>> Changelog:
>> 
>> Since v3-Resend:
>> 164009789816.744139.2870779016511283907.stgit@lep8c.aus.stglabs.ibm.com
>> * Rebased this on top of latest ndctl-pending tree that includes changes to
>> switch to meson build system.
>> ---
>>  ndctl/lib/libndctl.c | 52 ++++++++++++++++++++++++++++++++------------
>>  ndctl/lib/private.h  |  1 +
>>  ndctl/libndctl.h     |  1 +
>>  3 files changed, 40 insertions(+), 14 deletions(-)
>> 
>> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
>> index 5979a92c113c..abff4ececa27 100644
>> --- a/ndctl/lib/libndctl.c
>> +++ b/ndctl/lib/libndctl.c
>> @@ -608,6 +608,7 @@ static void free_dimm(struct ndctl_dimm *dimm)
>>  	free(dimm->unique_id);
>>  	free(dimm->dimm_buf);
>>  	free(dimm->dimm_path);
>> +	free(dimm->bus_prefix);
>>  	if (dimm->module)
>>  		kmod_module_unref(dimm->module);
>>  	if (dimm->health_eventfd > -1)
>> @@ -1670,14 +1671,34 @@ static int ndctl_bind(struct ndctl_ctx *ctx, struct kmod_module *module,
>>  static int ndctl_unbind(struct ndctl_ctx *ctx, const char *devpath);
>>  static struct kmod_module *to_module(struct ndctl_ctx *ctx, const char *alias);
>>  
>> +void ndctl_refresh_dimm_flags(struct ndctl_dimm *dimm)
>> +{
>> +	struct ndctl_ctx *ctx = dimm->bus->ctx;
>> +	char *path = dimm->dimm_buf;
>> +	char buf[SYSFS_ATTR_SIZE];
>> +
>> +	/* Construct path to dimm flags sysfs file */
>> +	sprintf(path, "%s/%s/flags", dimm->dimm_path, dimm->bus_prefix);
>> +
>> +	if (sysfs_read_attr(ctx, path, buf) < 0)
>> +		return;
>> +
>> +	/* Reset the flags */
>> +	dimm->flags.flags = 0;
>> +	if (ndctl_bus_has_nfit(dimm->bus))
>> +		parse_nfit_mem_flags(dimm, buf);
>> +	else if (ndctl_bus_is_papr_scm(dimm->bus))
>> +		parse_papr_flags(dimm, buf);
>> +}
>> +
>>  static int populate_dimm_attributes(struct ndctl_dimm *dimm,
>> -				    const char *dimm_base,
>> -				    const char *bus_prefix)
>> +				    const char *dimm_base)
>>  {
>>  	int i, rc = -1;
>>  	char buf[SYSFS_ATTR_SIZE];
>>  	struct ndctl_ctx *ctx = dimm->bus->ctx;
>>  	char *path = calloc(1, strlen(dimm_base) + 100);
>> +	const char *bus_prefix = dimm->bus_prefix;
>>  
>>  	if (!path)
>>  		return -ENOMEM;
>> @@ -1761,16 +1782,10 @@ static int populate_dimm_attributes(struct ndctl_dimm *dimm,
>>  	}
>>  
>>  	sprintf(path, "%s/%s/flags", dimm_base, bus_prefix);
>> -	if (sysfs_read_attr(ctx, path, buf) == 0) {
>> -		if (ndctl_bus_has_nfit(dimm->bus))
>> -			parse_nfit_mem_flags(dimm, buf);
>> -		else if (ndctl_bus_is_papr_scm(dimm->bus)) {
>> -			dimm->cmd_family = NVDIMM_FAMILY_PAPR;
>> -			parse_papr_flags(dimm, buf);
>> -		}
>> -	}
>> -
>>  	dimm->health_eventfd = open(path, O_RDONLY|O_CLOEXEC);
>> +
>> +	ndctl_refresh_dimm_flags(dimm);
>> +
>>  	rc = 0;
>>   err_read:
>>  
>> @@ -1826,8 +1841,9 @@ static int add_papr_dimm(struct ndctl_dimm *dimm, const char *dimm_base)
>>  
>>  		rc = 0;
>>  	} else if (strcmp(buf, "nvdimm_test") == 0) {
>> +		dimm->cmd_family = NVDIMM_FAMILY_PAPR;
>>  		/* probe via common populate_dimm_attributes() */
>> -		rc = populate_dimm_attributes(dimm, dimm_base, "papr");
>> +		rc = populate_dimm_attributes(dimm, dimm_base);
>>  	}
>>  out:
>>  	free(path);
>> @@ -1924,9 +1940,13 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
>>  	dimm->formats = formats;
>>  	/* Check if the given dimm supports nfit */
>>  	if (ndctl_bus_has_nfit(bus)) {
>> -		rc = populate_dimm_attributes(dimm, dimm_base, "nfit");
>> +		dimm->bus_prefix = strdup("nfit");
>> +		rc = dimm->bus_prefix ?
>> +			populate_dimm_attributes(dimm, dimm_base) : -ENOMEM
>>  	} else if (ndctl_bus_has_of_node(bus)) {
>> -		rc = add_papr_dimm(dimm, dimm_base);
>> +		dimm->bus_prefix = strdup("papr");
>> +		rc = dimm->bus_prefix ?
>> +			add_papr_dimm(dimm, dimm_base) : -ENOMEM;
>
> For both of the above, it would be a bit more readable to just return
> ENOMEM directly after strdup() if it fails, and then carry on with
> add_<foo>_dimm().
>
> 	dimm->bus_prefix = strdup("papr");
> 	if (!dimm->bus_prefix)
> 		return -ENOMEM;
> 	rc = add_papr_dimm(dimm, dimm_base);
> 	...
>
Agree on the readability part but returning from there right away would
prevent the allocated 'struct ndctl_dimm *dimm' from being freed in the
error path. Also the function add_dimm() returns a 'void *' to 'struct
ndctl_dimm*' right now rather than an 'int'.

I propose updating the code as:

	if (ndctl_bus_has_nfit(bus)) {
		dimm->bus_prefix = strdup("nfit");
		if (!dimm->bus_prefix) {
			rc = -ENOMEM;
			goto out;
		}
		rc =  populate_dimm_attributes(dimm, dimm_base);
         }

>>  	}
>>  
>>  	if (rc == -ENODEV) {
>> @@ -3506,6 +3526,10 @@ NDCTL_EXPORT int ndctl_cmd_submit(struct ndctl_cmd *cmd)
>>  		rc = -ENXIO;
>>  	}
>>  	close(fd);
>> +
>> +	/* update dimm-flags if command submitted successfully */
>> +	if (!rc && cmd->dimm)
>> +		ndctl_refresh_dimm_flags(cmd->dimm);
>>   out:
>>  	cmd->status = rc;
>>  	return rc;
>> diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
>> index 4d8622978790..e5c56295556d 100644
>> --- a/ndctl/lib/private.h
>> +++ b/ndctl/lib/private.h
>> @@ -75,6 +75,7 @@ struct ndctl_dimm {
>>  	char *unique_id;
>>  	char *dimm_path;
>>  	char *dimm_buf;
>> +	char *bus_prefix;
>>  	int health_eventfd;
>>  	int buf_len;
>>  	int id;
>> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
>> index 4d5cdbf6f619..b1bafd6d9788 100644
>> --- a/ndctl/libndctl.h
>> +++ b/ndctl/libndctl.h
>> @@ -223,6 +223,7 @@ int ndctl_dimm_is_active(struct ndctl_dimm *dimm);
>>  int ndctl_dimm_is_enabled(struct ndctl_dimm *dimm);
>>  int ndctl_dimm_disable(struct ndctl_dimm *dimm);
>>  int ndctl_dimm_enable(struct ndctl_dimm *dimm);
>> +void ndctl_refresh_dimm_flags(struct ndctl_dimm *dimm);
>>  
>>  struct ndctl_cmd;
>>  struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
>

-- 
Cheers
~ Vaibhav
