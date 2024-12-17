Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670841D47D9;
	Tue, 17 Dec 2024 12:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734439167; cv=none; b=Z422uieJfn/Khuh+EgoP/AvN6FfAwawGNhir55rv9kpZkMkKHZsPWmuNOzZ+sukaDv98N7Cuy88Q51flqm6b1jQ0huqEqDKHFqqxejmb7pjMYq99Tv7o/gfhkjd7VR9uUfe/8paY5lAv917uqigpNVzFWNNnvBoOYQxo8NLeH74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734439167; c=relaxed/simple;
	bh=eTTRXSGbxsxTHL/T+nTZZkKk4QZw6IxtSWXoc6XFwKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U/AugBm/wbczlYsE5nFAsfFXlrCSh1OQS7x20Dr80gG9+SJvLfZEZSYxBWzpS7EQFoToeNhrar2QOnMovzGGC9e6T1CmqvYYyrtqgCtC5gtIcVLaLXmIOBifsVz7Ajt091/WY30y3dqCCvuamT6o3vVZ9o8HmlM0+1KEI39o8HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AomPShh7; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AomPShh7"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BH85g0H032420;
	Tue, 17 Dec 2024 12:39:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=E7n2gj
	Aj00rD8fcFe/8kFFfWR0pcT0QnWH6RHPNN+lk=; b=AomPShh7RXZQygmTtRzlai
	br8ZZsvMiUoa4PXTe5PQ1SWaH7kxwNxRTu8/1HhUFb7BDVmrbFBIpVaJk2Y4oT+6
	kWwtHM4cSJRSqDkgZZjB5YyHqLyu6oorne4ZAED72E5f+JeYxC0GnBZidpsfRlQ9
	ehPvGeQ1Bogi2aESuIqxGaWPhY+jieTcSCd/z4imEN466xdwb16RHaYMHCRiW34O
	SnNIsKAoxxccR3RK78hJ0EmuezdoDthsDi1tXJiud0b1T9Lr4xUS/9UKi0fg/dWZ
	h1qZxl8HemcCoO/drXGR1oo5GkkFABa0X5zpyUDq3luBenhquwTpQweNKfVFRSvA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43k5g2h4x6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Dec 2024 12:39:23 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BH97PPk014412;
	Tue, 17 Dec 2024 12:39:23 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43hq21jc3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Dec 2024 12:39:23 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BHCdMsN24052252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Dec 2024 12:39:22 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28BAA58056;
	Tue, 17 Dec 2024 12:39:22 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 69B915803F;
	Tue, 17 Dec 2024 12:39:18 +0000 (GMT)
Received: from [9.43.38.38] (unknown [9.43.38.38])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Dec 2024 12:39:18 +0000 (GMT)
Message-ID: <a39d25d3-e6ac-4166-a75e-58a258da4101@linux.ibm.com>
Date: Tue, 17 Dec 2024 18:09:16 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Change in reported values of some block integrity sysfs
 attributes
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-scsi@vger.kernel.org, hare@suse.de, hch@lst.de,
        steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Nihar Panda <niharp@linux.ibm.com>
References: <f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com>
 <yq18qsjdz0r.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: M Nikhil <nikh1092@linux.ibm.com>
In-Reply-To: <yq18qsjdz0r.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hv8kafspI2C9X1TdImv_5JrFl2uNAJVP
X-Proofpoint-GUID: hv8kafspI2C9X1TdImv_5JrFl2uNAJVP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 clxscore=1011 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 suspectscore=0 spamscore=0 mlxlogscore=956 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412170101

Thanks for the inputs Martin.

We have observed that even though the HBA does not support DIX Type, 
still the integrity attributes 'write_generate' and 'read_verify' are 
set to 1 for the block devices.


a3560030:~ # cat /sys/class/scsi_host/host0/prot_capabilities
0
a3560030:~ # cat /sys/class/scsi_host/host1/prot_capabilities
0


a3560030:~ # cat /sys/block/sdc/integrity/write_generate
1
a3560030:~ # cat /sys/block/sdc/integrity/read_verify
1


Thanks and Regards,

Nikhil

On 14/12/24 4:00 am, Martin K. Petersen wrote:
>> The sysfs attributes related to block device integrity ,
>> write_generate and read_verify are enabled for the block device when
>> the parameter device_is_integrity_capable is disabled.
> 'device_is_integrity_capable' is set if storage device (media) is
> formatted with PI.
>
> That is completely orthogonal to 'write_generate' and 'read_verify'
> which are enabled if the HBA supports DIX. If the HBA supports DIX Type
> 0, 'write_generate' and 'read_verify' are enabled even if the attached
> disk is not formatted with PI.
>
> I don't see any change in what's reported with block/for-next in a
> regular SCSI HBA/disk setup. Will have to look at whether there is a
> stacking issue wrt. multipathing.
>
