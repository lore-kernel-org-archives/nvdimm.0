Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9321DA2FD;
	Tue, 17 Dec 2024 12:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734439609; cv=none; b=jURg2vEOjQzI6Pi58N9+YvQaC/ThqEXPyO6mTulzIOqSV7XP+fuVQryZtPkfmKiRZ6UNuat1MZCnCJV76dWMG7FuyTB6gBgpkPFhFFgWhoZVfREd5Tx/P7Kfg+cJWM03dCHD0oGjJyrFZ8o2YVubovqZxDd5W1z4tNt0XSwr5Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734439609; c=relaxed/simple;
	bh=evj4PxzEGydSuI2ztIHdBgp7ptFyHhJjEt/5IFZToZ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MQWBalSDxEjjHHgc8ow5qZuGn6OL2gmN5p1xQuT6AM+XUcEflMwTb1FOVzzdjKhl9CTsCYqcN4d6VoGuvh1mzI7+2MNzryzGqvHbO42miXnPkGc+qxc8yYmvAVioIwDIJbMVSi8PqQ0xSLE0JjGVUuw2lxHU4JiPUxN8jIfklrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JJJ3wBUP; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JJJ3wBUP"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BH85fMA032410;
	Tue, 17 Dec 2024 12:46:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=stztb+
	GXK1/u8xPmlrP951omaoVXmCKg16Xagl4aha8=; b=JJJ3wBUPR47LwKnhttFyWF
	LmEovCsJ5RbqDDL78hpbmLwfCd6/wRZOxmC9ygSh0m0cVA5Wt5XHChFbKe9WwjEH
	x8CuKAJfkkArVGg898XJ9yVG+L97M61jIOvihDF0ykcVq8ESZrv/vkkVey6xpVCx
	COeolMmu89cjCskfkDnsQ/w6LcYwe8Acc0c2xzM57FGimLKu48xZQgyrT6QHNSXY
	AhgYSN9M4qyZsvakAswZeL5eX9D+xJahPeAlF0kX8h5OGT3SGvBLpezYkQNR41qU
	qOUpowewHtcyl3R4TN7NN7SfKrQtNnGnm/uf3mzMy4efXu4SK3FGQ1AFFfzMihVg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43k5g2h5yt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Dec 2024 12:46:46 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BH8etAe014397;
	Tue, 17 Dec 2024 12:46:45 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43hq21jcwg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Dec 2024 12:46:45 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BHCkipb23134898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Dec 2024 12:46:44 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1AB5158064;
	Tue, 17 Dec 2024 12:46:44 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B683F58055;
	Tue, 17 Dec 2024 12:46:40 +0000 (GMT)
Received: from [9.43.38.38] (unknown [9.43.38.38])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Dec 2024 12:46:40 +0000 (GMT)
Message-ID: <274d9e53-0968-4fa6-9729-e81f7f3d660f@linux.ibm.com>
Date: Tue, 17 Dec 2024 18:16:39 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Change in reported values of some block integrity sysfs
 attributes
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-scsi@vger.kernel.org, hare@suse.de,
        steffen Maier
 <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Nihar Panda <niharp@linux.ibm.com>
References: <f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com>
 <20241213143351.GB16111@lst.de>
Content-Language: en-US
From: M Nikhil <nikh1092@linux.ibm.com>
In-Reply-To: <20241213143351.GB16111@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rdPrPVX8tBICgLZ8vA8-XwFtXA8H2YRR
X-Proofpoint-GUID: rdPrPVX8tBICgLZ8vA8-XwFtXA8H2YRR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 suspectscore=0 spamscore=0 mlxlogscore=911 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412170101

Hi Christoph,

We did not modify 'device_is_integrity_capable' attribute.

On 13/12/24 8:03 pm, Christoph Hellwig wrote:
> Hi M,
>
> On Fri, Dec 13, 2024 at 12:46:14PM +0530, M Nikhil wrote:
>> Hi Everyone,
>>
>>   * We have observed change in the values of some of the block integrity
>>     sysfs attributes for the block devices on the master branch. The
>>     sysfs attributes related to block device integrity , write_generate
>>     and read_verify are  enabled for the block device when the parameter
>>     device_is_integrity_capable is disabled. This behaviour is seen on
>>     the scsi disks irrespective of DIF protection enabled or disabled on
>>     the disks.
> As in after a "echo 1 > /sys/.../device_is_integrity_capable" ?
>
> I'll look into it.
>
