Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2657E10B;
	Mon, 10 Jun 2024 11:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718020587; cv=fail; b=eMB7EQd3IgAOFsshJd86znnNhcYBzDyN/RENEE65/mgS0wToTgf9+kAH82d3gm7I+c7pHAe5cFTG6wGH2JX4eSEVzuo4TWnnfs4tkHsc/qzop1C8QUmUXUmxIVBJmyNB467gvppSmx+uUkHYtTj08M1ZlbDvWciFuyjERFFZQvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718020587; c=relaxed/simple;
	bh=VNHPSAT9o4XuAw7rr1oXu55zlc230EybjHvprzhmTyM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=D8A3m06q3kvh3e0JPAFCh1BgC6wrE4rVR34ZfjO/NfbLdyvF6NJCHHRHVmjfDSdTJs5RBY0fV9Aq4Er09bmJQqpp+ZYzSKRtZAWEunRZ7Cs2Wesloka8wsehcplMkvYw4M0XheN9Xo8xJHTD50dUBSCUh71mHgz5u43yPO4RkKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZqcFI+qW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=D4ApwkUU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZqcFI+qW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="D4ApwkUU"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4BR5C024983;
	Mon, 10 Jun 2024 11:56:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=uB18lRN2IhktXP
	gR2lXwogokfaX79Bt02Gi266OMg5U=; b=ZqcFI+qWv/J51N7pieJKbZINhSpRpK
	2sjl5tZdbEbRSisOFRDbtMlZfpx1azSRaw5KCGaGreqB0XO/SUvtVaKuplsPzITh
	jS0NNX+GP0qT4iMmPk3VjAqgRYGMkv16SxFMcVVeXqlaDPBNHv0NoAo0UlOYn4d0
	H0Bd1VOLnPHjFUriUKw1WIhDaSvMoMsxS6YNdpPhNXEaglwucbDqQvFOQN6it58n
	YLbFuSZCQcpKo4byg+c3qlfyAbe3jU0gggms55LS/Vzng3uxSq7s2LN2zUmGp9Co
	Rlz1+ihKFjlpSSPJRIh5ObJgE6b0jeK0QlhaYwhFPTe3JXgXrkjXuKfg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh7djbyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 11:56:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45AA3GQS014489;
	Mon, 10 Jun 2024 11:56:05 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yncesdbw0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 11:56:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Px1EPDvfrNRA/bMQ6cybNwMjtMmYhI5U0UqPiJ6mpu4MMqHDAIGf2UXzwDDii9k5S1T/1JpThoSpL7+mCgl9e8iulXltGVdgLACypjhe52aJOMymBmbnvxvkgmJSo19iDdKg8JhzdQ2rcU8lRoSapE4hl+6PyyaTALk7gtwp+EOt+lKw+Zt6TerY1JmiNI/DIUv5Kz3AUmwaolPVQGUdjfmJZYtOIcGJCP8CnWqKFg9KsJ2Vyn8OvhdlrRno5zBwqtS/nHBFK3J7VHIxFoDe/JazrpNojCDTrPuwEEWcUzlLdB7vSkGDm2desIcwP6ABFb0vtQn+uELVXjRt1nMbSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uB18lRN2IhktXPgR2lXwogokfaX79Bt02Gi266OMg5U=;
 b=JNfAkJ3BR/j0VohhVXrhbRyjhYGcXOr8lXzQ5tQHhoFOarh1lEfdQlo3/EZEPU4z6QC4NkzVgDhPseWDhpgeT4LL8jT9AfVxLLdUIVkEYEUGWb3Zv6uSue2teZbFFX5D/afHidgZ4Fg+uoOzPTiMy952/jiEdDYiOtbXYlFEaKC4hAvcEhTq9Zk/LYt3UsKT1DfPMJEJ2fuR329KjPrROsC6OjbhjV43pAUH459+m8uFPNIk4qPo8iOopULDaFJEvjagx3/2nGMnttj55ey4ooXfuXdNzhdRHYLH50Gm+riNLZCC2M2KVaBS1vq8A7QoYTvH1SfidT3CtkTZvDKqIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uB18lRN2IhktXPgR2lXwogokfaX79Bt02Gi266OMg5U=;
 b=D4ApwkUUI+UiF8NlAotb533ruxZSzZ5E22Y8OeQZdxBmAU2dGuDIJ4wDRU7lzOoqn51jZDjtaWSjJJr9dYcFcwlOkw++TNwtf2vktiv+QdkSgjviynIaR/2wRyhfTT6J8Si9vaDiSZE6Nltbkgra49lz0/TXW0K+F7mPCsHeTpQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BY5PR10MB4132.namprd10.prod.outlook.com (2603:10b6:a03:20b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 11:56:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 11:56:01 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Mikulas
 Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
        Yu Kuai
 <yukuai3@huawei.com>, Dan Williams <dan.j.williams@intel.com>,
        Vishal
 Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Ira
 Weiny <ira.weiny@intel.com>,
        Keith Busch <kbusch@kernel.org>, Sagi
 Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Bart Van
 Assche <bvanassche@acm.org>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH 03/11] block: remove the BIP_IP_CHECKSUM flag
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240607055912.3586772-4-hch@lst.de> (Christoph Hellwig's
	message of "Fri, 7 Jun 2024 07:58:57 +0200")
Organization: Oracle Corporation
Message-ID: <yq1frtl3tmw.fsf@ca-mkp.ca.oracle.com>
References: <20240607055912.3586772-1-hch@lst.de>
	<20240607055912.3586772-4-hch@lst.de>
Date: Mon, 10 Jun 2024 07:56:00 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:208:d4::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BY5PR10MB4132:EE_
X-MS-Office365-Filtering-Correlation-Id: 1896625a-471d-47ca-51a4-08dc89444cb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|7416005|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?2qtakTBzCMA2eANJOxpHpn8gEqAfyXlFJiwtG+rMT8Z5mJPxKI13mQmDua4P?=
 =?us-ascii?Q?S+WTNgigscH44/di4SuAidqmUMjt/iVlN5IhG9JcETD0OLQsa0Nv3GNuWtD8?=
 =?us-ascii?Q?QULilVbh+5m32V9fSSZpZMjkqO2yrVIYJRB8feFRobj0i5m44sFPGST+i6gC?=
 =?us-ascii?Q?f0BncKN+7Y0wszk8MaZjhAU6K4LvCvrc0jdAMQSGVq11eydWvyFKYTvqDEjA?=
 =?us-ascii?Q?T/BLsEQNH56MnWlhHykdtL1kZUxNIU4f/RhLS+8jLsfpJb1x3UKAUnw1ATmP?=
 =?us-ascii?Q?jRJTR5wjc7QK7ziS7GJbmIxUb1XJpbXfo+bTvt777yHlSRgNlmmNKtxqiz2A?=
 =?us-ascii?Q?gJUT8iXfp5Rcbf3V1tkAm80XtdzItTji7JawVnNLfRogCwJB5TIUbUDJ8uLK?=
 =?us-ascii?Q?oENdU4e4l9ePr7zecmIAUjZnoflCmFoNVCxWAmWKZSqJoBl05Mr5vYElMviY?=
 =?us-ascii?Q?ymTH8FaFHHzov+vP9+FaRA79aGGpSUUztRiotlHDJoAPFxrV+TU81wtW03iu?=
 =?us-ascii?Q?w5BbGIa7B/Y34K0KAgEaE5PB0GhTGyFMnrCNQlqRmG1arzJ0ya7NsX8jWDK6?=
 =?us-ascii?Q?KMAn1ZzC4s1deNB4F9yVfDhnjAvenWtP4sJFt+BqCGlhFtjSTiaQe4qRwSIM?=
 =?us-ascii?Q?mkRn2XmINM7QESiKA0T+/ZcvYeGNftc3kOXxtq/sYUz4Wp6ADCB5aGtz/3a1?=
 =?us-ascii?Q?T/hp7OL52zC+KU0gi9XSbAJMSSdegdpvMxFhdCOfGg75T0jMKW9WzcvlUUDN?=
 =?us-ascii?Q?U/jUP60YsGR/q7dDImJXvFUo8dydb+i4sPPxUnfNl72UhbZkqWAq1YC5buIo?=
 =?us-ascii?Q?LSbhqFXS2jZdYqKxPonUoqiQfPmtoq84kwAR5UetbRKTdo44I0JLUh9zLCPe?=
 =?us-ascii?Q?O37YMfhi/Ea9siUEn6Q8dkOPtXfz9oOloPh/cuLbWV0x5LfNaRgmAPrjBpHU?=
 =?us-ascii?Q?GIHOLyiPN+m0AZpvGmhNNb13I4upc4OU4BbIxHZlNdc+5GZn/SerMMxqlmqY?=
 =?us-ascii?Q?pOHDGcNe5j1eT9qfFVkOO/w65eGz6/Ef8NBkS66cH3x6yASHbDsV4ZQAj7T4?=
 =?us-ascii?Q?Dd6YnDqrlEM/bBwtAUOnnW22jbcJ9ZokYXYok3Dxe3u8M/RQFgfJ7RvOJaU1?=
 =?us-ascii?Q?QTV/E3RSLn+zFU7HsaFDMLnnRB/rO991JqgzWm3JyDQt9R22XpGdATOqrpps?=
 =?us-ascii?Q?0Gcp65ZcuOxYyAznWtymTVDNvU1EMdZsFsd7LBrNLFA7XDxMYnaGp4qgoPvr?=
 =?us-ascii?Q?ilxdRoApGZ/khW8B6dCqNhOrnR3Wb4SYWugOvwLaX9LoRwypM24ycRY1biGp?=
 =?us-ascii?Q?P1cqGO7eP/IGp4oAvoVLV9Gp?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?iIBoDraSCcyQ+TmDK/hzIB6OEnyGg4dG2VzjV0yNk2gu7dDsymBWKTCG4N41?=
 =?us-ascii?Q?tE/IZtSU5EVlGPQsssSuVd/If54rA6nGVt3xdOyxSmNdFsPKbGsC8PJ6NwY4?=
 =?us-ascii?Q?0kDuafXCOL5tFV7ZgAivAzH4C7Lv7+7Uh3ETk3iFXP1Piq6KKGLzxRbxNvDk?=
 =?us-ascii?Q?bmymIF7tADGsDYl6eIS2G0mO6ySqmusvVVQYuqWFuQO0W3w0s7ICN9hiT2ve?=
 =?us-ascii?Q?B3oKUh/1iCzeeY4+cIzeIqWELarStanOeDHzCPwSAKZ0hKtqDGFXjehkM3k/?=
 =?us-ascii?Q?BS/Kq5v3+gCq9lacc9lEk1phTAu/U4vWdBn253EDi6TyCHB+I+rznAQL+Rpe?=
 =?us-ascii?Q?oXMl+PB8fXTAybH6GjTilgXnrduKnfozeTzobgYBX86i3tjRm+KbRtBmld1V?=
 =?us-ascii?Q?Ig8w1Ndufp9BaHc422lbYbVQ1rBiXTvMWumS5vuPAUwgYYOKlK+ydIU25F3p?=
 =?us-ascii?Q?JbAmyQdbV3lcJTPc1JinFJpOUxE+gbp0ZwrnC7QVKDo1QxTYsperDCWRFEF3?=
 =?us-ascii?Q?e+klg4/eVrWbKKLChkwgd6ivCAfHCY3sbWYxh6zxG3YMG6Owqa/HHjLdz5lv?=
 =?us-ascii?Q?U8iVMF3BmldG/25IHDypMx/GuDx9hjgu1+W8P29DY5lwfmOiSK2d4jiWOIpq?=
 =?us-ascii?Q?ZzqqeAnjKQ5DLCsRBP3oStt03sSsTo+6wlDf9OMx7x+GLIxJN+9QYS//PesF?=
 =?us-ascii?Q?3MBOjLEAO/jI+mFrLtJekjkxWburyyYlHk+BRuRAlQNYR/wNSE0MkNulg2JR?=
 =?us-ascii?Q?7BiC16AKTG74uvAFCUf/xx3118YBguI47ccwbYarKCLhuus+pntLZtOQwtaH?=
 =?us-ascii?Q?fBTtUwDHWz5xxpYUBZ4uHZZV3P/VJecvIPtvJkDJCcIRec1AyjBBe1DVZlQa?=
 =?us-ascii?Q?hXNgZfpPZY/J+guBz5LdDXoNXP6JmjPc/s4kzb+zWKHK0nAFljD8F7SUAQ4V?=
 =?us-ascii?Q?NE2GCLn0259OLi+ZGzamgMQCtI2qToq//XogzIwjdvjOxUbeDs9OXXdl8yar?=
 =?us-ascii?Q?whDR7gP/NMK/dEHg3ooPN+Qx9okzOBEe6//1PUWysS2zpGG426Jo4NFrVHVY?=
 =?us-ascii?Q?lW4ExL1vU5kz9A1KsVH/ELz67HRTe+rLOkn3uuaTNsFmuD8jHHcL5gbiuWcX?=
 =?us-ascii?Q?JHQYbq9opjt3L9Cmo7aWImAAm0tSKIHdyBG6pwPyG//dLT/HTjfuqm54fFqx?=
 =?us-ascii?Q?L7QXWn5L7CRpLHZBjIpkiboBihzXT5MPeKB762VY/YWBkYvLjKuNwRsEvu2t?=
 =?us-ascii?Q?tb+uRLA13OPt/fXZ+ySne+9RxZxA/kM4sPGd91IIxzmGbqi3wDdiW5N5NvSy?=
 =?us-ascii?Q?Ph5OZ/y5vRNtoa47eQvDhVZXSbm3OUmAvTIQW/ItQW9/0o0/ZeS3hIAN9Ets?=
 =?us-ascii?Q?iV6xKvfzKWsxQ8wiJPyo1yKXGPYOuvUWONPClZm4ujQYW6KN4WDUPkHwsXkh?=
 =?us-ascii?Q?+KKBSLoPyR75vAVlD/cdgRs658HzsC8hFo9Itlqftj4TRXozq5XSb9XnoAC/?=
 =?us-ascii?Q?mfL/H5j9fp4eN+/slJeA84OGoFbiih0VPmDepgff9ptD5xd47QwljdXljMeA?=
 =?us-ascii?Q?+9OidXyOF8IsT4qLva+dp6baWUShd9sDJqF83OuPUwDFJLoysjGsPxl/8OSK?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	42nyl/cFljZFNzTi2UhQ11AI8Tfr3QjCspHKk36p0GI6w9iCnBSG1UH3CDx/k/ysxMWy8rBMQCwwCCHh8hZYodzRfPOSDS2/kbPAgODKaee7KVUMC6ouszps5Pobl+s7MgtpAS2Y5P7rg7ILOPT/N7NqlzOjuBCVauJW+lUNlILEbjet2LwrPSFzGD8t5P4p9DD/G9NXjVithDFYum8ksU4J+u280Vcxu6ti7kOIv0RFjZzlLrCkReBoZl81xBVvE1Mcz//tpPbpCuyWUqkGBwsXUC+9u1edUpGHxzJvaEl+fsIcJknqPrpA3i4MjMRghqxcuWAh+b8PYid0KR8g9yMDgZMPLHzY3GcX2qNIiDN5MLeJew9W7ByF52wCfllLK8+8jBhbLs+a6oqEvQBU0nNq3bLDv3VtmB5Q1k4U+TjNZt314iXKOzd09tAwoKnHbNbv25zetvZyhE0XtcPTAf9b2ko80CO4uK+9x41qLwbxWp8TF9oC555bCcGSKcaInqN/h1WIEewm2Rr2Kd9+9aud230NRTFtxdjw1xeGETZk87n5wEoxSzyAZAY5TkntjJukwnp5CU9/7f/W/xTi/arC6cHc5VTed5OYeKhb8SA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1896625a-471d-47ca-51a4-08dc89444cb6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 11:56:01.8371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HGkAVTEA8AR2JvciQI5ayxptiHhzgQf+AmiYJtzdoEiTNN/uq0cLDHmNW2Qt1yBHD9psMj4wixprCiNW9mJ6w8Z0ovLSZSX+eNQIt2bsRjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=901 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406100090
X-Proofpoint-GUID: 5X_XC0UrnAEtwiThl92H6Cu5p_5yDLYv
X-Proofpoint-ORIG-GUID: 5X_XC0UrnAEtwiThl92H6Cu5p_5yDLYv


Christoph,

> Remove the BIP_IP_CHECKSUM as sd can just look at the per-disk
> checksum type instead.

This removes the ability to submit an individual I/O using a CRC instead
of the IP checksum. There are cases which can't be expressed when
the controller is operating in IP checksum mode.

-- 
Martin K. Petersen	Oracle Linux Engineering
