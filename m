Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC6115A7
	for <nvdimm@lists.linux.dev>; Mon,  2 May 2022 05:17:52 +0000 (UTC)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2425B3wu009994;
	Mon, 2 May 2022 05:17:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=AVXhO8VsX0+fFUM9mxqBr40OXq/BNe0dOnqu/hecdGc=;
 b=NwUSdPjlJE1yDPdZohbSR0yc5VYdG7W54l4xzD2W0jby9lzSM1Ldr7C6v/sz3Vrl3reK
 GX74KOesn33Mdg2BglQvpDqArf0mg/IpQXswdIJDKBdzmR4mKP7jQ9UjgA8yMcL3zLxa
 n3v+KGw6d4+m+UiBJI/mQNrN2UQfs1NgRZvhL0ohtY1FAwHlNO+o1XkGpQ8H21cgyziA
 Z8A3FgIY4LfrxCWOwhLK2LoqhQne4Yvt+NPjmUtVhlQg6OnV57o+PBTF3oMo3HN1ayjX
 JjA9qbdLYHU+6/694BBOx0hT3t3hta8+M211wyWhETDAmVdwqsSJk7duAGAnbvfsyQDM fA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ft7css3uj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 May 2022 05:17:45 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2425CcI9006784;
	Mon, 2 May 2022 05:17:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma06ams.nl.ibm.com with ESMTP id 3frvcj2657-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 May 2022 05:17:43 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2425HewI32899378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 May 2022 05:17:40 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E5478AE04D;
	Mon,  2 May 2022 05:17:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D6AACAE045;
	Mon,  2 May 2022 05:17:36 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.58.177])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Mon,  2 May 2022 05:17:36 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Mon, 02 May 2022 10:47:35 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Tarun Sahu <tsahu@linux.ibm.com>, nvdimm@lists.linux.dev
Cc: tsahu@linux.ibm.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com
Subject: Re: [PATCH] ndctl/bus:Handling the scrub related command more
 gracefully
In-Reply-To: <20220427153751.190286-1-tsahu@linux.ibm.com>
References: <20220427153751.190286-1-tsahu@linux.ibm.com>
Date: Mon, 02 May 2022 10:47:35 +0530
Message-ID: <87r15cwm1c.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pGPh51rLkqNe-EL7nlHtEYZOhd4sJHe0
X-Proofpoint-ORIG-GUID: pGPh51rLkqNe-EL7nlHtEYZOhd4sJHe0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_01,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 bulkscore=0 clxscore=1011 adultscore=0 lowpriorityscore=0 impostorscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205020038

Hi Tarun,

Minor review comments below
Tarun Sahu <tsahu@linux.ibm.com> writes:

> For the buses, that don't have nfit support, they use to
> return "No such file or directory" for start-scrub/
> wait-scrub command.
s/they use to//

>
> Though, non-nfit support buses do not support start-scrub/
> wait-scrub operation. I propose this patch to handle these
> commands more gracefully by returning "Operation not
> supported".
>
s/Though/Presently/
s/non-nfit support buses do not support/non-nfit support buses do not support/

> Previously:
> $ ./ndctl start-scrub ndbus0
> error starting scrub: No such file or directory
>
> Now:
> $ ./ndctl start-scrub ndbus0
> error starting scrub: Operation not supported
>
The code changes look good to me though. But it would be better if you
can describe the test setup that resulted in above output.

I was able to test the patch on PPC64LE guest with an nvdimm device with
following expected results:

# Valid ndbus
$ sudo ./ndctl start-scrub ndbus0
error starting scrub: Operation not supported

# Invalid ndbus
$ sudo ./ndctl start-scrub ndbus5
error starting scrub: No such device or address


Hence,

> Signed-off-by: Tarun Sahu <tsahu@linux.ibm.com>
Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>


> ---
>  ndctl/lib/libndctl.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index ccca8b5..8bfad6a 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -938,10 +938,14 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
>  	if (!bus->wait_probe_path)
>  		goto err_read;
>  
> -	sprintf(path, "%s/device/nfit/scrub", ctl_base);
> -	bus->scrub_path = strdup(path);
> -	if (!bus->scrub_path)
> -		goto err_read;
> +	if (ndctl_bus_has_nfit(bus)) {
> +		sprintf(path, "%s/device/nfit/scrub", ctl_base);
> +		bus->scrub_path = strdup(path);
> +		if (!bus->scrub_path)
> +			goto err_read;
> +	} else {
> +		bus->scrub_path = NULL;
> +	}
>  
>  	sprintf(path, "%s/device/firmware/activate", ctl_base);
>  	if (sysfs_read_attr(ctx, path, buf) < 0)
> @@ -1377,6 +1381,9 @@ NDCTL_EXPORT int ndctl_bus_start_scrub(struct ndctl_bus *bus)
>  	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
>  	int rc;
>  
> +	if (bus->scrub_path == NULL)
> +		return -EOPNOTSUPP;
> +
>  	rc = sysfs_write_attr(ctx, bus->scrub_path, "1\n");
>  
>  	/*
> @@ -1447,6 +1454,9 @@ NDCTL_EXPORT int ndctl_bus_poll_scrub_completion(struct ndctl_bus *bus,
>  	char in_progress;
>  	int fd = 0, rc;
>  
> +	if (bus->scrub_path == NULL)
> +		return -EOPNOTSUPP;
> +
>  	fd = open(bus->scrub_path, O_RDONLY|O_CLOEXEC);
>  	if (fd < 0)
>  		return -errno;
> -- 
> 2.35.1
>
>

-- 
Cheers
~ Vaibhav
