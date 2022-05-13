Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5252100
	for <nvdimm@lists.linux.dev>; Fri, 13 May 2022 07:32:37 +0000 (UTC)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D7DG4m021928;
	Fri, 13 May 2022 07:17:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=vmvsnaCzpj7+qz8z3cQoPIWHizHvpNXjrMqWzkh3xhw=;
 b=fHuXvkZClJ+/gx6jueUa4GBGyWSuLYZMJDTCgeSCJS/v/Yj+VqY5PE/aQfX9FNC8JrB2
 XvMYLaJrPKtdBJOG004qenNR5J5s8NQra1XaGINon2xPOpEMchgojAJQWK+ipbtb5lVx
 jMdplOzWWjB0l8aEx6aqyxkrXpjTM0alhtqlzoli01/K9BjKb1cjsVnJcj/jaLOSyCz8
 NofqcmX3rhKAffxKXjGp2r6jzutukJgK8hzHehCEDeIng4mbCPcY5mAQ9z1pzP8yqCPk
 9XkcYY8Ic0aEOxeYkCV3IIy8H2vDFZvxPxEBj1icOBX+WdyOkLZxFCiGe+nLhIIYqhMU Eg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1jrer2e6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 May 2022 07:17:28 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24D7HQZY022934;
	Fri, 13 May 2022 07:17:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma06ams.nl.ibm.com with ESMTP id 3fyrkk41am-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 May 2022 07:17:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24D7HNOI36110598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 May 2022 07:17:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 29AC542041;
	Fri, 13 May 2022 07:17:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F3B124203F;
	Fri, 13 May 2022 07:17:20 +0000 (GMT)
Received: from li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com (unknown [9.43.42.168])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri, 13 May 2022 07:17:20 +0000 (GMT)
Message-ID: <16def0fc12e6efe90e47f997429fee545c719f10.camel@linux.ibm.com>
Subject: Re: [PATCH v2] ndctl/bus:Handling the scrub related command more
 gracefully
From: Tarun Sahu <tsahu@linux.ibm.com>
Reply-To: tsahu@linux.ibm.com
To: nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Date: Fri, 13 May 2022 12:47:19 +0530
In-Reply-To: <20220502070454.179153-1-tsahu@linux.ibm.com>
References: <20220502070454.179153-1-tsahu@linux.ibm.com>
Organization: IBM
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I1o0CmzKaXteeYhisNyrjuLmk5GWVp2E
X-Proofpoint-ORIG-GUID: I1o0CmzKaXteeYhisNyrjuLmk5GWVp2E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 adultscore=0 spamscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130029

Hi,

Just a gentle reminder, Kindly Let me know if any changes are needed in
this patch.

Thank you,
Tarun


On Mon, 2022-05-02 at 12:34 +0530, Tarun Sahu wrote:
> The buses, that don't have nfit support, return "No such file or
> directory" for start-scrub/wait-scrub command.
> 
> Presently, non-nfit support buses do not support start-scrub/
> wait-scrub operation. This patch is to handle these commands
> more gracefully by returning" Operation not supported".
> 
> This patch is tested on PPC64le lpar with nvdimm that does
> not support scrub.
> 
> Previously:
> $ ./ndctl start-scrub ndbus0
> error starting scrub: No such file or directory
> 
> Now:
> $ ./ndctl start-scrub ndbus0
> error starting scrub: Operation not supported
> 
> - Invalid ndbus
> $ sudo ./ndctl start-scrub ndbus5
> error starting scrub: No such device or address
> 
> Signed-off-by: Tarun Sahu <tsahu@linux.ibm.com>
> Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
>  ndctl/lib/libndctl.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index ccca8b5..8bfad6a 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -938,10 +938,14 @@ static void *add_bus(void *parent, int id,
> const char *ctl_base)
>         if (!bus->wait_probe_path)
>                 goto err_read;
>  
> -       sprintf(path, "%s/device/nfit/scrub", ctl_base);
> -       bus->scrub_path = strdup(path);
> -       if (!bus->scrub_path)
> -               goto err_read;
> +       if (ndctl_bus_has_nfit(bus)) {
> +               sprintf(path, "%s/device/nfit/scrub", ctl_base);
> +               bus->scrub_path = strdup(path);
> +               if (!bus->scrub_path)
> +                       goto err_read;
> +       } else {
> +               bus->scrub_path = NULL;
> +       }
>  
>         sprintf(path, "%s/device/firmware/activate", ctl_base);
>         if (sysfs_read_attr(ctx, path, buf) < 0)
> @@ -1377,6 +1381,9 @@ NDCTL_EXPORT int ndctl_bus_start_scrub(struct
> ndctl_bus *bus)
>         struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
>         int rc;
>  
> +       if (bus->scrub_path == NULL)
> +               return -EOPNOTSUPP;
> +
>         rc = sysfs_write_attr(ctx, bus->scrub_path, "1\n");
>  
>         /*
> @@ -1447,6 +1454,9 @@ NDCTL_EXPORT int
> ndctl_bus_poll_scrub_completion(struct ndctl_bus *bus,
>         char in_progress;
>         int fd = 0, rc;
>  
> +       if (bus->scrub_path == NULL)
> +               return -EOPNOTSUPP;
> +
>         fd = open(bus->scrub_path, O_RDONLY|O_CLOEXEC);
>         if (fd < 0)
>                 return -errno;

