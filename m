Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA9D7C
	for <nvdimm@lists.linux.dev>; Wed,  2 Mar 2022 11:41:59 +0000 (UTC)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222BQY6o031248;
	Wed, 2 Mar 2022 11:41:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=ZxtSJ7XC6ezmylp5YAAkzXk5tckyp7IaiPZSrZxCH7U=;
 b=Z0SWthH9J4vMrVzs558srqOj70UbQTTzrIGBV6fh2GhT+NDR/ax5LO5vPKC4z1bauOIM
 cTSkTgVVzSH9d0f+c0x2S6aksTt4gMyWU0jNbL7RpmBiK7izq7rih9D2CLp++SaNdbe9
 66+b+SONZSk2kFH5m6RxrBvu68JmqeoVBLz8qHr1EV+USJpfErNjCgWi75mTUOHqiqpR
 qRGEer+GYetoebOxe0IDmlubxJtboaQkdR12WJKSMP1ohm/dA4K8BziKZg7EWzfz/Ziq
 PBgYH/FnPBtbq6N+lrg2LHUbrleH07SpTKMNDpJlJCJ2Qq+Rt72GvQfXepVYi/o3w0dM SA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3ej5cccefr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Mar 2022 11:41:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 222BYlBX019817;
	Wed, 2 Mar 2022 11:41:53 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma03ams.nl.ibm.com with ESMTP id 3efbu9ej7b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Mar 2022 11:41:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 222BUrDW52494822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Mar 2022 11:30:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E12B4A405B;
	Wed,  2 Mar 2022 11:41:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 34982A405F;
	Wed,  2 Mar 2022 11:41:46 +0000 (GMT)
Received: from li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com (unknown [9.43.3.237])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
	Wed,  2 Mar 2022 11:41:45 +0000 (GMT)
Date: Wed, 2 Mar 2022 17:11:42 +0530
From: Tarun Sahu <tsahu@linux.ibm.com>
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: Re: [ndctl PATCH v5] ndctl,libndctl: Update nvdimm flags after
 smart-inject
Message-ID: <Yh9X9iP6WbhvErCe@li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com>
References: <20220222121519.1674117-1-vaibhav@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222121519.1674117-1-vaibhav@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MIgPnPkxnM-WrQSJqej04Vt6MeV25tSt
X-Proofpoint-GUID: MIgPnPkxnM-WrQSJqej04Vt6MeV25tSt
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_01,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1011 bulkscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020049

I have tested the patch, which is working on the system
Kernel Version: 5.17.0 + patch (https://patchwork.ozlabs.org/project/linuxppc-dev/patch/20220124202204.1488346-1-vaibhav@linux.ibm.com/)
System: Power-9, PPC64le, RHEL 8.1

Results:
Without this patch, building ndctl on base commit: 6e85cac1958f920f231b94ff570ac0e434595b7d

$ sudo ndctl inject-smart -fU nmem0
[
  {
    "dev":"nmem0",
    "health":{
      "health_state":"fatal",
      "shutdown_state":"dirty",
      "shutdown_count":0
    }
  }
]

With the patch applied,

$ sudo ndctl inject-smart -fU nmem0
[
  {
    "dev":"nmem0",
    "flag_failed_flush":true,
    "flag_smart_event":true,
    "health":{
      "health_state":"fatal",
      "shutdown_state":"dirty",
      "shutdown_count":0
    }
  }
]

it update flags also when flags are unset (implies flags get removed from the output):

$ ./builddir/ndctl/ndctl inject-smart -fU nmem0
[
  {
    "dev":"nmem0",
    "flag_failed_flush":true,
    "flag_smart_event":true,
    "health":{
      "health_state":"fatal",
      "shutdown_state":"dirty",
      "shutdown_count":0
    }
  }
]

$ ./ndctl inject-smart --fatal-uninject nmem0
[
  {
    "dev":"nmem0",
    "flag_failed_flush":true,
    "health":{
      "health_state":"ok",
      "shutdown_state":"dirty",
      "shutdown_count":0
    }
  }
]


Tested-by: Tarun Sahu <tsahu@linux.ibm.com>


On Tue, Feb 22, 2022 at 05:45:19PM +0530, Vaibhav Jain wrote:
> Presently after performing an inject-smart command the nvdimm flags reported are
> out of date as shown below where no 'smart_notify' or 'flush_fail' flags were
> reported even though they are set after injecting the smart error:
> 
> $ sudo ndctl inject-smart -fU nmem0
> [
>   {
>     "dev":"nmem0",
>     "health":{
>       "health_state":"fatal",
>       "shutdown_state":"dirty",
>       "shutdown_count":0
>     }
>   }
> ]
> $ sudo cat /sys/class/nd/ndctl0/device/nmem0/papr/flags
> flush_fail smart_notify
> 
> This happens because nvdimm flags are only parsed once during its probe
> and not refreshed even after a inject-smart operation makes them out of
> date. To fix this the patch forces an update of nvdimm flags via newly
> introduced export from libndctl named ndctl_dimm_refresh_flags() thats called
> from dimm_inject_smart() after inject-smart command is successfully
> submitted. This ensures that correct nvdimm flags are displayed later in that
> function. With this implemented correct nvdimm flags are reported after a
> inject-smart operation:
> 
> $ sudo ndctl inject-smart -fU nmem0
> [
>   {
>     "dev":"nmem0",
>     "flag_failed_flush":true,
>     "flag_smart_event":true,
>     "health":{
>       "health_state":"fatal",
>       "shutdown_state":"dirty",
>       "shutdown_count":0
>     }
>   }
> ]
> 
> The patch refactors populate_dimm_attributes() to move the nvdimm flags
> parsing code to the newly introduced ndctl_dimm_refresh_flags()
> export. Since reading nvdimm flags requires constructing path using
> 'bus_prefix' which is only available during add_dimm(), the patch
> introduces a new member 'struct ndctl_dimm.bus_prefix' to cache its
> value. During ndctl_dimm_refresh_flags() the cached bus_prefix is used to
> read the contents of the nvdimm flag file and pass it on to the appropriate
> flag parsing function. Finally dimm_inject_smart() is updated to issue call to
> ndctl_dimm_refresh_flags() before generating json output of the nvdimm status
> 
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
> Changelog:
> 
> Since v4:
> https://lore.kernel.org/nvdimm/20220124205822.1492702-1-vaibhav@linux.ibm.com
> 
> * Instead of updating nvdimm flags in cmd_submit() only refresh when for
> inject-smart command [ Vishal ]
> * Added the export of ndctl_dimm_refresh_flags() to libndctl exports [ Vishal ]
> * Updated changes to add_dimm() to make then more readable [ Vishal ]
> * Updated patch description.
> ---
>  ndctl/inject-smart.c   |  4 +++
>  ndctl/lib/libndctl.c   | 55 +++++++++++++++++++++++++++++++-----------
>  ndctl/lib/libndctl.sym |  4 +++
>  ndctl/lib/private.h    |  1 +
>  ndctl/libndctl.h       |  1 +
>  5 files changed, 51 insertions(+), 14 deletions(-)
> 
> diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
> index bd8c01e000d4..d7da5ad8c425 100644
> --- a/ndctl/inject-smart.c
> +++ b/ndctl/inject-smart.c
> @@ -467,6 +467,10 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
>  		jdimms = json_object_new_array();
>  		if (!jdimms)
>  			goto out;
> +
> +		/* Ensure the dimm flags are upto date before reporting them */
> +		ndctl_dimm_refresh_flags(dimm);
> +
>  		jdimm = util_dimm_to_json(dimm, sctx.flags);
>  		if (!jdimm)
>  			goto out;
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 5979a92c113c..8b92d0419871 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -608,6 +608,7 @@ static void free_dimm(struct ndctl_dimm *dimm)
>  	free(dimm->unique_id);
>  	free(dimm->dimm_buf);
>  	free(dimm->dimm_path);
> +	free(dimm->bus_prefix);
>  	if (dimm->module)
>  		kmod_module_unref(dimm->module);
>  	if (dimm->health_eventfd > -1)
> @@ -1670,14 +1671,34 @@ static int ndctl_bind(struct ndctl_ctx *ctx, struct kmod_module *module,
>  static int ndctl_unbind(struct ndctl_ctx *ctx, const char *devpath);
>  static struct kmod_module *to_module(struct ndctl_ctx *ctx, const char *alias);
>  
> +NDCTL_EXPORT void ndctl_dimm_refresh_flags(struct ndctl_dimm *dimm)
> +{
> +	struct ndctl_ctx *ctx = dimm->bus->ctx;
> +	char *path = dimm->dimm_buf;
> +	char buf[SYSFS_ATTR_SIZE];
> +
> +	/* Construct path to dimm flags sysfs file */
> +	sprintf(path, "%s/%s/flags", dimm->dimm_path, dimm->bus_prefix);
> +
> +	if (sysfs_read_attr(ctx, path, buf) < 0)
> +		return;
> +
> +	/* Reset the flags */
> +	dimm->flags.flags = 0;
> +	if (ndctl_bus_has_nfit(dimm->bus))
> +		parse_nfit_mem_flags(dimm, buf);
> +	else if (ndctl_bus_is_papr_scm(dimm->bus))
> +		parse_papr_flags(dimm, buf);
> +}
> +
>  static int populate_dimm_attributes(struct ndctl_dimm *dimm,
> -				    const char *dimm_base,
> -				    const char *bus_prefix)
> +				    const char *dimm_base)
>  {
>  	int i, rc = -1;
>  	char buf[SYSFS_ATTR_SIZE];
>  	struct ndctl_ctx *ctx = dimm->bus->ctx;
>  	char *path = calloc(1, strlen(dimm_base) + 100);
> +	const char *bus_prefix = dimm->bus_prefix;
>  
>  	if (!path)
>  		return -ENOMEM;
> @@ -1761,16 +1782,10 @@ static int populate_dimm_attributes(struct ndctl_dimm *dimm,
>  	}
>  
>  	sprintf(path, "%s/%s/flags", dimm_base, bus_prefix);
> -	if (sysfs_read_attr(ctx, path, buf) == 0) {
> -		if (ndctl_bus_has_nfit(dimm->bus))
> -			parse_nfit_mem_flags(dimm, buf);
> -		else if (ndctl_bus_is_papr_scm(dimm->bus)) {
> -			dimm->cmd_family = NVDIMM_FAMILY_PAPR;
> -			parse_papr_flags(dimm, buf);
> -		}
> -	}
> -
>  	dimm->health_eventfd = open(path, O_RDONLY|O_CLOEXEC);
> +
> +	ndctl_dimm_refresh_flags(dimm);
> +
>  	rc = 0;
>   err_read:
>  
> @@ -1826,8 +1841,9 @@ static int add_papr_dimm(struct ndctl_dimm *dimm, const char *dimm_base)
>  
>  		rc = 0;
>  	} else if (strcmp(buf, "nvdimm_test") == 0) {
> +		dimm->cmd_family = NVDIMM_FAMILY_PAPR;
>  		/* probe via common populate_dimm_attributes() */
> -		rc = populate_dimm_attributes(dimm, dimm_base, "papr");
> +		rc = populate_dimm_attributes(dimm, dimm_base);
>  	}
>  out:
>  	free(path);
> @@ -1924,9 +1940,20 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
>  	dimm->formats = formats;
>  	/* Check if the given dimm supports nfit */
>  	if (ndctl_bus_has_nfit(bus)) {
> -		rc = populate_dimm_attributes(dimm, dimm_base, "nfit");
> +		dimm->bus_prefix = strdup("nfit");
> +		if (!dimm->bus_prefix) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +		rc =  populate_dimm_attributes(dimm, dimm_base);
> +
>  	} else if (ndctl_bus_has_of_node(bus)) {
> -		rc = add_papr_dimm(dimm, dimm_base);
> +		dimm->bus_prefix = strdup("papr");
> +		if (!dimm->bus_prefix) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +		rc =  add_papr_dimm(dimm, dimm_base);
>  	}
>  
>  	if (rc == -ENODEV) {
> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> index 3557b32c50ea..f1f9edd4b6ff 100644
> --- a/ndctl/lib/libndctl.sym
> +++ b/ndctl/lib/libndctl.sym
> @@ -458,3 +458,7 @@ LIBNDCTL_26 {
>  	ndctl_set_config_path;
>  	ndctl_get_config_path;
>  } LIBNDCTL_25;
> +
> +LIBNDCTL_27 {
> +	ndctl_dimm_refresh_flags;
> +} LIBNDCTL_26;
> diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
> index 4d8622978790..e5c56295556d 100644
> --- a/ndctl/lib/private.h
> +++ b/ndctl/lib/private.h
> @@ -75,6 +75,7 @@ struct ndctl_dimm {
>  	char *unique_id;
>  	char *dimm_path;
>  	char *dimm_buf;
> +	char *bus_prefix;
>  	int health_eventfd;
>  	int buf_len;
>  	int id;
> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index 4d5cdbf6f619..57cf93d8d151 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -223,6 +223,7 @@ int ndctl_dimm_is_active(struct ndctl_dimm *dimm);
>  int ndctl_dimm_is_enabled(struct ndctl_dimm *dimm);
>  int ndctl_dimm_disable(struct ndctl_dimm *dimm);
>  int ndctl_dimm_enable(struct ndctl_dimm *dimm);
> +void ndctl_dimm_refresh_flags(struct ndctl_dimm *dimm);
>  
>  struct ndctl_cmd;
>  struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
> 
> base-commit: 6e85cac1958f920f231b94ff570ac0e434595b7d
> -- 
> 2.35.1
> 
> 
