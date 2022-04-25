Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA687C
	for <nvdimm@lists.linux.dev>; Mon, 25 Apr 2022 12:37:52 +0000 (UTC)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PBCbpF028542;
	Mon, 25 Apr 2022 12:37:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WBj+lF9crn38ly64rAu2SUr2YafyK9xDqlUy7yre2+k=;
 b=Jw2cgn9LgESvEtFhIp6TLAZ7Z9apFYCjCWkVeDz+QhZInD4bqzCnYT9yg6MiQxIrlvXL
 E7symT6mR+vW/86EhrXFsYiGDVEBvnDiz45xQWerNJuVxbAKiMTWoBKx3K4SZX0VP0yV
 tR2h4aZCqR+d8QQsR14OJ6zHDJDMHXgjt2RE8esM1axqlb4PpZyt2MVpnvTfT+RZtIvi
 GQkG58LcumWe+MUHt320XkM7NC4TAj10kXRVSL5NmsSPTLr2oXo+AnUgZN5UhsZlu7Hx
 bx/wRFtmkZ4XHO7H1i5C96LLnKq1VgiJv9+pNpYj4bF7+ufZW9Jx6JhU/WLZ6AomFqtL eA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fnraumrrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Apr 2022 12:37:44 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23PCKTVu023144;
	Mon, 25 Apr 2022 12:37:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma03ams.nl.ibm.com with ESMTP id 3fm938tcs6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Apr 2022 12:37:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23PCbdq847907080
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Apr 2022 12:37:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F9C44203F;
	Mon, 25 Apr 2022 12:37:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F35C442045;
	Mon, 25 Apr 2022 12:37:36 +0000 (GMT)
Received: from [9.43.33.161] (unknown [9.43.33.161])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 25 Apr 2022 12:37:36 +0000 (GMT)
Message-ID: <d1aec1cf-86c5-ad64-3d29-cdce12a923ba@linux.ibm.com>
Date: Mon, 25 Apr 2022 18:07:35 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/2] ndctl/namespace:Implement write-infoblock for sector
 mode namespaces
Content-Language: en-US
To: Tarun Sahu <tsahu@linux.ibm.com>, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, vaibhav@linux.ibm.com
References: <20220413035252.161527-1-tsahu@linux.ibm.com>
 <20220413035252.161527-3-tsahu@linux.ibm.com>
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <20220413035252.161527-3-tsahu@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xTCVjZnV2NZh24JdoSRONO4_sOVJzoRE
X-Proofpoint-GUID: xTCVjZnV2NZh24JdoSRONO4_sOVJzoRE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_08,2022-04-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 impostorscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204250055



On 4/13/22 09:22, Tarun Sahu wrote:
> Following to the previous patch in this series,
> once the namespace info has been collected in ns_info,
> while writing to the infoblock for sector mode, it can be
> written with original infoblock values except the ones that
> have been provided by parameter arguments to write-infoblock command.

<snip>

>   }
>   
> +static int write_btt_sb(const int fd, unsigned long long size, struct ns_info *ns_info)
> +{
> +	int rc = 0;
> +	uuid_t uuid, parent_uuid;
> +
> +	// updating the original values which are asked to change,
> +	// rest will be unchanged
> +	if (param.uuid) {
> +		rc = uuid_parse(param.uuid, uuid);
> +		if (rc) {
> +			pr_verbose("Failed to parse UUID");

Use error("Failed ... instead

> +			return rc;
> +		}
> +		memcpy(((struct btt_sb *)(ns_info->ns_sb_buf + ns_info->offset))->uuid,
> +				uuid, sizeof(uuid_t));
> +	}
> +	if (param.parent_uuid) {
> +		rc = uuid_parse(param.parent_uuid, parent_uuid);
> +		if (rc) {
> +			pr_verbose("Failed to parse UUID");

Same here

> +			return rc;
> +		}
> +		memcpy(((struct btt_sb *)(ns_info->ns_sb_buf + ns_info->offset))->parent_uuid,
> +				parent_uuid, sizeof(uuid_t));
> +	}
> +
> +	if (pwrite(fd, ns_info->ns_sb_buf + ns_info->offset, sizeof(struct btt_sb),
> +			       ns_info->offset) < 0) {
> +		pr_verbose("Unable to write the info block: %s\n",
> +				strerror(errno));

Same here
> +		rc = -errno;
> +	}
> +
> +	if (pwrite(fd, ns_info->ns_sb_buf + ns_info->offset, sizeof(struct btt_sb),
> +				size - sizeof(struct btt_sb)) < 0) {
> +		pr_verbose("Unable to write the info block: %s\n",
> +			strerror(errno));

Same here

Thanks,
Shivaprasad
