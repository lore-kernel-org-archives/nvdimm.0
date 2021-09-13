Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF463FC3
	for <nvdimm@lists.linux.dev>; Mon, 13 Sep 2021 04:57:14 +0000 (UTC)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18D49Uhd029648;
	Mon, 13 Sep 2021 00:57:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=3yvgybRayxMUrOmjyC0XQIGJ7qdgf+ZGA6QmT8QBEHE=;
 b=W+LQHta4aACZtuRuPMU2K4xjLpM30p4WKRl5mYRtKkJH3AA9x8sToZLupg/zNDCD3pa7
 MY0NM7A0JEFk6aB8s2BHzNfvW96dNDhygLAS8gTg4UCS36IP+jrxAnox3XSKL2suAbKm
 E5AatgllYVDsv06N9sYkrvRStxqmQMQfMAd/LYuUwwqffl/99CzDlYulIjEme6gKAsdJ
 PS3yFWHCxNmIeOY+XyI6GDPk66vgu5QkGPhIjMuBcjpO2ZUkShvXc2IH7MBVLFVp0c16
 tW1KKRAFXMl8WtZ0vW3JedSIB/KIz1t7AibDg+92UTCS/YBTDZVjqjsGkdHKLBMe5Cs4 dw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3b19j78m23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Sep 2021 00:57:12 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18D4uFH1017614;
	Mon, 13 Sep 2021 00:57:11 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3b19j78m1k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Sep 2021 00:57:11 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
	by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18D4tIvq024300;
	Mon, 13 Sep 2021 04:57:10 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by ppma04wdc.us.ibm.com with ESMTP id 3b0m39yv5d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Sep 2021 04:57:10 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18D4vARp10879732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Sep 2021 04:57:10 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 030FE124055;
	Mon, 13 Sep 2021 04:57:10 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1CB4B124053;
	Mon, 13 Sep 2021 04:57:08 +0000 (GMT)
Received: from skywalker.linux.ibm.com (unknown [9.43.86.25])
	by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
	Mon, 13 Sep 2021 04:57:07 +0000 (GMT)
X-Mailer: emacs 28.0.50 (via feedmail 11-beta-1 I)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To: Dan Williams <dan.j.williams@intel.com>, Yi Zhang <yi.zhang@redhat.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] ndctl: Avoid confusing error message when operating on
 all the namespaces
In-Reply-To: <CAPcyv4iP50kaPk8fVmPOMWbVngeLmEhC9nsEBnhgU0C-Er0U+w@mail.gmail.com>
References: <20210708100104.168348-1-aneesh.kumar@linux.ibm.com>
 <CAHj4cs_t9sMw9b5XRPMkYE37BfAEMkWCFFpU1C8heKYBbRcnbA@mail.gmail.com>
 <CAPcyv4iP50kaPk8fVmPOMWbVngeLmEhC9nsEBnhgU0C-Er0U+w@mail.gmail.com>
Date: Mon, 13 Sep 2021 10:27:05 +0530
Message-ID: <87tuipt6n2.fsf@linux.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mUzxbBwyOMExRcVpfns5z_rRcnICgUD2
X-Proofpoint-GUID: 0X65ZJEftunSMbOvupnhUL1RQ9untiYo
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 spamscore=0 clxscore=1011 priorityscore=1501 lowpriorityscore=0
 adultscore=0 impostorscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109120024

Dan Williams <dan.j.williams@intel.com> writes:

> On Mon, Jul 12, 2021 at 5:20 PM Yi Zhang <yi.zhang@redhat.com> wrote:
>>
>> Jeff had posted one patch to fix similar issue
>> https://lore.kernel.org/linux-nvdimm/x49r1lohpty.fsf@segfault.boston.devel.redhat.com/T/#u
>>
>> Hi Dan/Visha
>> Could we make some progress on this issue?
>
> Apologies, we had some internal administrivia to address, but are
> getting back to regular releases now and catching up on the backlog.

Any update on this patch? Without this I get failures with 
https://github.com/avocado-framework-tests/avocado-misc-tests/blob/master/memory/ndctl.py
because the return status is 1 for disable-namespace command with only
seed namespace.

-aneesh
