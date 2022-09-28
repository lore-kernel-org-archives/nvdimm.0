Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7678A40
	for <nvdimm@lists.linux.dev>; Wed, 28 Sep 2022 07:50:14 +0000 (UTC)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28S687vn017098;
	Wed, 28 Sep 2022 07:49:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=Z5CQwcAourqH98znGxzDeEfutDxXG+NlzFIHs+kyvck=;
 b=XxDbva7EuQFfdpv1kZwsaX2mqJvRUNwzwfgH/qmPEOSHJnQESRFacQZ3NX8O1gwEnre4
 fs75TqDsR8nmDgc4Eewd7B2uM3jZHdAs219fji02gLI6OP8ft6320pZr3CGjkE8qV1pE
 ikPUD5H0HmfR2wXVWr0LEvt+EcO60cbodoysfFJRwCQX02pXtK4l3P338jEpCByqh36P
 qjFbRDNnoqIP5jJgefFgJ06icF35oAUexC6R7Z4kDJqi46IVg3nzrtF6VkOzy06iw9DH
 kU16j652wb3rpKgYDoJVdB60sJb+yhi9/xUVA2ZnrgdvZB3eGw1y0EnkLICKy4BIeHXN 6g== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jv6wjgtkt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Sep 2022 07:49:56 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28S7bd9G003677;
	Wed, 28 Sep 2022 07:49:55 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma02fra.de.ibm.com with ESMTP id 3jssh93nx5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Sep 2022 07:49:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28S7jbKX17891800
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Sep 2022 07:45:37 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9E1C552050;
	Wed, 28 Sep 2022 07:49:52 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.40.24])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id A79065204E;
	Wed, 28 Sep 2022 07:49:49 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Wed, 28 Sep 2022 13:19:43 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>, vishal.l.verma@intel.com,
        nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, sbhat@linux.ibm.com
Subject: Re: [PATCH] ndctl: Fix the NDCTL_TIMEOUT environment variable parsing
In-Reply-To: <166373424779.231228.12814077203589935658.stgit@LAPTOP-TBQTPII8>
References: <166373424779.231228.12814077203589935658.stgit@LAPTOP-TBQTPII8>
Date: Wed, 28 Sep 2022 13:19:43 +0530
Message-ID: <87ill8djl4.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iHYlcrl1dQWTHtj-Pu4wyCfzHDyQuPUt
X-Proofpoint-ORIG-GUID: iHYlcrl1dQWTHtj-Pu4wyCfzHDyQuPUt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_03,2022-09-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 suspectscore=0 clxscore=1011 bulkscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209280042

Hi Shiva,

Thanks for fixing this. Minor review comment below:

Shivaprasad G Bhat <sbhat@linux.ibm.com> writes:

> The strtoul(x, y, size) returns empty string on y when the x is "only"
> number with no other suffix strings. The code is checking if !null
> instead of comparing with empty string.
>
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
>  ndctl/lib/libndctl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index ad54f06..b0287e8 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -334,7 +334,7 @@ NDCTL_EXPORT int ndctl_new(struct ndctl_ctx **ctx)
>  		char *end;
>  
>  		tmo = strtoul(env, &end, 0);
> -		if (tmo < ULONG_MAX && !end)
> +		if (tmo < ULONG_MAX && strcmp(end, "") == 0)

Using strcmp would be better avoided in new code. Instead you can check
for the valid string to parse in strtoull() with simply checking against
*end == '\0' or !*end.

Quote for STRTOUL(3):

"if *nptr is not '\0' but **endptr is '\0' on return,  the  entire string
is valid."


>  			c->timeout = tmo;
>  		dbg(c, "timeout = %ld\n", tmo);
>  	}
>
>
>
>

-- 
Cheers
~ Vaibhav
