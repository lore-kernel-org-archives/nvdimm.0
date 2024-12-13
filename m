Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682231552FC;
	Fri, 13 Dec 2024 07:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074186; cv=none; b=fzXsGutNdxi07LiyC47StKw+qup67IGO/nsvbRJkWvYpSrbJ1+p29jR0hAEEGsKn5/ANodqLKGMBO41pTuWuHFqsTVd6mX89XnL3zo9wVlc36qee5JYXiaSGhKS90OR+fR5COBtnu+Xwh1CoMl0CLIZfs0Ha/ZuAmKf3k0ec2nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074186; c=relaxed/simple;
	bh=Hr3hwFuzFkYYHl1m8O4baQEsPK0Xs3hONmPqtZrPWYc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=BsRQoMIjzA/YodXluZK/Ym4ryBQaOYbICx1/qIlzk43nc4BcF6G/ZECbQrPDWze/9/uQUA2hh1hElIlrlen1gxgWVUomXQ3PthIFCmWXIfVPEawnyfpm1La2HyI4JqXuXh9SAKMbDsvp8Gcly9ABJXimJVAcAP86vml/3EHdosY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VNxsQp+m; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VNxsQp+m"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BD3xiEj029658;
	Fri, 13 Dec 2024 07:16:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=IgZ7cZ+16ESsDPfDeuwM+zyJIXs1
	iIg6IinIyl1DzJY=; b=VNxsQp+mfl4yyF6yv0wlkFqu4pQMv8j2C+IyyJ7o4WeS
	iNdKgImEqbT/dCfeIdQbSsrrdIOz6xTA4j0psqeF0Ft8S89xpNe91aq/CE0dkqlm
	OBSVL9vM+HHNG5iMBDHH1yK8AYBnHx+H1Kl9/JtkoAn6+PGgBLQqUalDvkfjoG/Q
	q1Xyx+VU5ZTrOJRg1NPfPl18gUimPD11vu+5qWwRpSrzOlQEJAVgRvMK9YclgZCp
	XXrek4mIKi4Ux/T/zPg9lpB7Pgz0Y8e2vrvxVsDUY0UYqoPCP/3SwG7v87TV16oG
	tdmyWzrhYhtwtIytIT8REy0mImLTHL47dW+XJFCiTg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ccsjyfc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Dec 2024 07:16:22 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BD34Fih029309;
	Fri, 13 Dec 2024 07:16:22 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43gcprrv2n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Dec 2024 07:16:22 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BD7GKuM25297624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Dec 2024 07:16:20 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 959E15805F;
	Fri, 13 Dec 2024 07:16:20 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF8B35805D;
	Fri, 13 Dec 2024 07:16:16 +0000 (GMT)
Received: from [9.43.77.91] (unknown [9.43.77.91])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 13 Dec 2024 07:16:16 +0000 (GMT)
Message-ID: <f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com>
Date: Fri, 13 Dec 2024 12:46:14 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: M Nikhil <nikh1092@linux.ibm.com>
Subject: Change in reported values of some block integrity sysfs attributes
To: linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-scsi@vger.kernel.org, hare@suse.de, hch@lst.de
Cc: steffen Maier <maier@linux.ibm.com>,
        Benjamin Block
 <bblock@linux.ibm.com>,
        Nihar Panda <niharp@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pNrUCGEOCIZLXuwnpAdUiLLv66Vx_bzk
X-Proofpoint-ORIG-GUID: pNrUCGEOCIZLXuwnpAdUiLLv66Vx_bzk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 adultscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=554
 mlxscore=0 priorityscore=1501 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2412130049

Hi Everyone,

  * We have observed change in the values of some of the block integrity
    sysfs attributes for the block devices on the master branch. The
    sysfs attributes related to block device integrity , write_generate
    and read_verify are  enabled for the block device when the parameter
    device_is_integrity_capable is disabled. This behaviour is seen on
    the scsi disks irrespective of DIF protection enabled or disabled on
    the disks.

    *Logs of the block integrity sysfs attributes for one of the block
    device:*

a3560030:~ # cat /sys/block/sda/integrity/write_generate

1

a3560030:~ # cat /sys/block/sda/integrity/read_verify

1

a3560030:~ # cat /sys/block/sda/integrity/device_is_integrity_capable

0

  * Similarly unexpected values of block integrity sysfs attributes are
    seen for multipath devices as well. Multipath device reporting value
    1 for device_is_integrity_capable even though it is based on SCSI
    disk devices, which all have 0 for device_is_integrity_capable.

a3560030:~ # cat /sys/block/dm-0/integrity/device_is_integrity_capable

1

a3560030:~ # cat /sys/block/dm-0/integrity/read_verify

1

a3560030:~ # cat /sys/block/dm-0/integrity/write_generate

1

  * Earlier the block integrity sysfs parameters "write_generate" and
    "read_verify" reported value 0 when the sysfs attribute
    device_is_integrity_capable was not set. But when tested with a
    recent upstream kernel, there is a change in the block device
    integrity sysfs attributes.
  * In the process of finding the kernel changes which might have caused
    the change in functionality, we have identified the below commit
    which was leading to the change in the sysfs attributes.
    9f4aa46f2a74 ("block: invert the BLK_INTEGRITY_{GENERATE,VERIFY} flags")
  * By reverting the code changes which are part of above commit and
    when tested the values of attributes read_verify and write_generate
    were set to 0 which was the older functionality.
   * From the description in the patch related to above commit, what we
    understand is that the changes are meant to invert the block
    integrity flags(READ_VERIFY and WRITE_GENERATE) vs the values in
    sysfs for making the user values persistent.
  * We would like to know if the change in the values of sysfs
    attributes write_generate and read_verify is expected?
  * And some additional information on in which scenario the attributes
    will be disabled or set to 0 and the affect of other block integrity
    attribute device_is_integrity_capable on attributes read_verify and
    write_generate.


Regards,

*M Nikhil
*

Software Engineer

ISDL, Bangalore, India

Linux on IBM Z and LinuxONE

