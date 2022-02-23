Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6491800
	for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 05:36:22 +0000 (UTC)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21N5Gf39003838;
	Wed, 23 Feb 2022 05:36:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=bLT4Smv1hy4NCUBiYWVB4HDs+Dj5+wnSXRlqrKPPvNw=;
 b=n5cRw/MpZb/PfO5/aCjXsu1qSFaPNR65drHR8IE5jIj3nLTR6CZ104g28FxwF1bugVqY
 TBP5GfSUIMTR1OxfbQQyYXva/4Yji7kSqOgAleJHFij5yrkHUxr8ng4+hDGwmWwUaWD/
 kJFbhp4w60kd8uo2NtFmjNJhzwiO7RQxobIYMozbiEkHbKaGT1+NMr+UTXX3qoVygTvz
 J2K49+KGGuOJUxoLXyIH27ZTDTIuIYkmqpkNffz6TdIEO7y3I/dpxlFAqdy7dZD7fmg8
 S//TJMScaF7S8EM7HNwEKczCty3drewlUgKDObV8UMnGsO6VbTJtl4rx4LVbk5ZpnIQa rw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3edemwg8cv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Feb 2022 05:36:20 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21N5Xk6x000834;
	Wed, 23 Feb 2022 05:36:18 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma04ams.nl.ibm.com with ESMTP id 3ear697amw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Feb 2022 05:36:18 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21N5aD1l57409802
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Feb 2022 05:36:13 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 95C0B52051;
	Wed, 23 Feb 2022 05:36:13 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.30.90])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 218735204E;
	Wed, 23 Feb 2022 05:36:10 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Wed, 23 Feb 2022 11:06:10 +0530
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
In-Reply-To: <5e159e75b9ff3dfdaa46a7cbcb1c251786294f0b.camel@intel.com>
References: <20220124205822.1492702-1-vaibhav@linux.ibm.com>
 <555f5d150e4d55dce788bf0ebfbc029409b21260.camel@intel.com>
 <87h78v9gj3.fsf@vajain21.in.ibm.com>
 <5e159e75b9ff3dfdaa46a7cbcb1c251786294f0b.camel@intel.com>
Date: Wed, 23 Feb 2022 11:06:10 +0530
Message-ID: <87tucqdu0l.fsf@vajain21.in.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: njgUfpTFjbzrD3qSovu5en0pjxQluBnD
X-Proofpoint-ORIG-GUID: njgUfpTFjbzrD3qSovu5en0pjxQluBnD
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-23_01,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 mlxscore=0 bulkscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230026

Thanks Vishal,

I have addressed your review comments in v5 of the patch here at
https://lore.kernel.org/nvdimm/20220222121519.1674117-1-vaibhav@linux.ibm.com

~ Vaibhav

"Verma, Vishal L" <vishal.l.verma@intel.com> writes:

> On Sat, 2022-02-19 at 18:09 +0530, Vaibhav Jain wrote:
>> 
>> > > @@ -1924,9 +1940,13 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
>> > >  	dimm->formats = formats;
>> > >  	/* Check if the given dimm supports nfit */
>> > >  	if (ndctl_bus_has_nfit(bus)) {
>> > > -		rc = populate_dimm_attributes(dimm, dimm_base, "nfit");
>> > > +		dimm->bus_prefix = strdup("nfit");
>> > > +		rc = dimm->bus_prefix ?
>> > > +			populate_dimm_attributes(dimm, dimm_base) : -ENOMEM
>> > >  	} else if (ndctl_bus_has_of_node(bus)) {
>> > > -		rc = add_papr_dimm(dimm, dimm_base);
>> > > +		dimm->bus_prefix = strdup("papr");
>> > > +		rc = dimm->bus_prefix ?
>> > > +			add_papr_dimm(dimm, dimm_base) : -ENOMEM;
>> > 
>> > For both of the above, it would be a bit more readable to just return
>> > ENOMEM directly after strdup() if it fails, and then carry on with
>> > add_<foo>_dimm().
>> > 
>> > 	dimm->bus_prefix = strdup("papr");
>> > 	if (!dimm->bus_prefix)
>> > 		return -ENOMEM;
>> > 	rc = add_papr_dimm(dimm, dimm_base);
>> > 	...
>> > 
>> Agree on the readability part but returning from there right away would
>> prevent the allocated 'struct ndctl_dimm *dimm' from being freed in the
>> error path. Also the function add_dimm() returns a 'void *' to 'struct
>> ndctl_dimm*' right now rather than an 'int'.
>> 
>> I propose updating the code as:
>> 
>> 	if (ndctl_bus_has_nfit(bus)) {
>> 		dimm->bus_prefix = strdup("nfit");
>> 		if (!dimm->bus_prefix) {
>> 			rc = -ENOMEM;
>> 			goto out;
>> 		}
>> 		rc =  populate_dimm_attributes(dimm, dimm_base);
>>          }
>
> Yes, that looks good, thanks!
>
>> 
>> > >  	}
>> > >  
>> > >  	if (rc == -ENODEV) {
>> > > @@ -3506,6 +3526,10 @@ NDCTL_EXPORT int ndctl_cmd_submit(struct ndctl_cmd *cmd)
>> > >  		rc = -ENXIO;
>> > >  	}
>> > >  	close(fd);
>> > > +
>> > > +	/* update dimm-flags if command submitted successfully */
>> > > +	if (!rc && cmd->dimm)
>> > > +		ndctl_refresh_dimm_flags(cmd->dimm);
>> > >   out:
>> > >  	cmd->status = rc;
>> > >  	return rc;
>> > > diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
>> > > index 4d8622978790..e5c56295556d 100644
>> > > --- a/ndctl/lib/private.h
>> > > +++ b/ndctl/lib/private.h
>> > > @@ -75,6 +75,7 @@ struct ndctl_dimm {
>> > >  	char *unique_id;
>> > >  	char *dimm_path;
>> > >  	char *dimm_buf;
>> > > +	char *bus_prefix;
>> > >  	int health_eventfd;
>> > >  	int buf_len;
>> > >  	int id;
>> > > diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
>> > > index 4d5cdbf6f619..b1bafd6d9788 100644
>> > > --- a/ndctl/libndctl.h
>> > > +++ b/ndctl/libndctl.h
>> > > @@ -223,6 +223,7 @@ int ndctl_dimm_is_active(struct ndctl_dimm *dimm);
>> > >  int ndctl_dimm_is_enabled(struct ndctl_dimm *dimm);
>> > >  int ndctl_dimm_disable(struct ndctl_dimm *dimm);
>> > >  int ndctl_dimm_enable(struct ndctl_dimm *dimm);
>> > > +void ndctl_refresh_dimm_flags(struct ndctl_dimm *dimm);
>> > >  
>> > >  struct ndctl_cmd;
>> > >  struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
>> > 
>> 
>

-- 
Cheers
~ Vaibhav
