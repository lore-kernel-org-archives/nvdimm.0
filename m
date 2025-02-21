Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E6E1917E3;
	Fri, 21 Feb 2025 06:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740117688; cv=none; b=KNFUsUMvPSpSZDZTsAh/m862VCf5vUaOR/vQn4yj6+idwGpK4/1V9TjnyEAlZgdaMpVbe9Ea4qCB7wK6UEGe/6Lek75v4HqjmiM6z2SWd9Fg30FAZjEXDEKh+t3KVNKQm0x0R/O+UwrFU+JT9ICrtAe3EtXE4Y955PsqXuk1b4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740117688; c=relaxed/simple;
	bh=fCzc/nNMh2KfoFPRA/XbYY9gHWRIDSlx5rH678Vgm/o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=eepA6u3yw835P4DAVVrJvwKv6egTMhiPGQplRzrnXRifZYs6ITwmStHXWuFKSaeItpo3Om95BSXrEoazOpjXjPeW06FYhj3idLngUKzDfpZVMpev6ALAQBOMtb7HvkomkFOP1uM+k1n/lcChdZJ7VLyIt0MnGTsxd9DtwNWMsOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OCOHGOcg; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OCOHGOcg"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51L5P45s003571;
	Fri, 21 Feb 2025 06:01:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=d4FmSe
	9M3mZq4yCy32/8QHZt9cN5EPgh9r7qE2bLzdc=; b=OCOHGOcgdKmfZCTNoj9LQX
	ajTY+gxx8a9BeumZM6wrDYOwTU/L6t0GLLRDZXRlg6waNOcvr7Tp8hv+FSHsPydZ
	gHJsiRVTQP77+RcAi5KbQeJno0Q30BiDnEtU8W5T9+nSerJusRF1xVXQZU++ufyb
	eobpb4tEPRbxaMe4CduxaezUTymQEshiTvwveiJNjnHJV76TPc3ZHCgQ7G1lO7qT
	6VTjoGTJMkycbNX03ic4PlcVNKj0zNZ8KGijjTUGdhjC09AVQv5XXBUG11bDaETF
	T1TBZXmSyKrIp+AUmA3t3zbkB6lAp8i4B+z6clOTDUfMw2vXdMS6XFatS9UjiHqQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44xka8g4bn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Feb 2025 06:01:26 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51L5CtZa027050;
	Fri, 21 Feb 2025 06:01:25 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44w025e86v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Feb 2025 06:01:25 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51L61ODj28902054
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Feb 2025 06:01:24 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5514458062;
	Fri, 21 Feb 2025 06:01:24 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9BAA55805A;
	Fri, 21 Feb 2025 06:01:20 +0000 (GMT)
Received: from [9.109.211.178] (unknown [9.109.211.178])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 21 Feb 2025 06:01:20 +0000 (GMT)
Message-ID: <21af17ce-e125-4c6c-8826-f6cf6b2448d3@linux.ibm.com>
Date: Fri, 21 Feb 2025 11:31:19 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Change in reported values of some block integrity sysfs
 attributes
From: M Nikhil <nikh1092@linux.ibm.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-scsi@vger.kernel.org, hare@suse.de, hch@lst.de,
        steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Nihar Panda <niharp@linux.ibm.com>
References: <f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com>
 <yq18qsjdz0r.fsf@ca-mkp.ca.oracle.com>
 <a39d25d3-e6ac-4166-a75e-58a258da4101@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <a39d25d3-e6ac-4166-a75e-58a258da4101@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ntn5dI55lF0o7GPFgeztaTKLqIk3V94R
X-Proofpoint-ORIG-GUID: ntn5dI55lF0o7GPFgeztaTKLqIk3V94R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-21_01,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 suspectscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=807 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502210044

gentle ping!!!

Hopefully I haven't missed anything. I was wondering if you could find 
out something and if I can provide more information.

