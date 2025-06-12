Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854C82222A6
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 17:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749748179; cv=fail; b=eAG++101zmbnQVyp762s2XQ+vJPZDURJCJzUMBa0d2YvfYCqrKjb3SIPu+vhvFIPR/9OrNR7xqqfmeJ6GT2Qybm/8wMLZZcohMtVw+D5My+S8BXrlaim83lNpcBkVIFQa8UN4GPvmgPpG5p40BQNUkzt5NAFXGzL8nec+5bo7sQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749748179; c=relaxed/simple;
	bh=C9+BiGSDXzbqPB8jDaxT5fGAvT9QHX/FCNWSwooJSgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dzhkJGd4oVhJ5pm2j6T4rK7htKBGsXnLDLWuMerYnFWTFy/bxm6dB0jmrYIxF++Q54/8aHrT5tp9M7f0zSTlq+HWWRfvuUNc2ACtN0MDUMMQVPiXFssxqtHnbUfitqLEGZdzACDvXvDz7nAzTPWX6DnKr3Wr1NJrenjpZ817mmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D4L+xe43; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WQZPMSgg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D4L+xe43";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WQZPMSgg"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55CEte8i004346;
	Thu, 12 Jun 2025 17:09:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VHsCJm/qNaqqS2Qv1x
	CrTPh+geM4Jt9GFbUVXOHR6xM=; b=D4L+xe43cN3ew2/zFQS2G84N33YwQW7J0I
	sKNwkSXC0QbP1/EKRnI177RvpL0Qk9jz4QxCaPHj9qFlLuihmPpZODgyHuarmn4L
	49sDYuSJSi1AthHHIIyVFrGD0XjrIMTc3yQuByeK8/8sDnKFPEk9NSOHzJL9xCqF
	/5ajZWjPoH5AvELQ2eSyP0P9pXz9ylv0vr5Tpw5Bju5uvFhMW7L0m3aaj5UwlJ8k
	G12wi6XK/bQYtK6dzBcQIp1RyjPP1a4DpT7r7PaPGiXk5Nnv+VYN+qAgqfWQROKJ
	Fm2NMkrYE6/1Q0Oe1BNFc0oPenjPrGCvfN3U+znuEqZsG0RWY42A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474c752711-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 17:09:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55CH6oBw040793;
	Thu, 12 Jun 2025 17:09:17 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010002.outbound.protection.outlook.com [52.101.193.2])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bvcv16s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 17:09:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IH8qUMFsRCQ6MeBRgK2I0zDXxUMbYMRLB+4S9OUvfdiXCVAs8Q/d8TWY5hmTI9TwrGmsCOsgjydZoj1cN3rY6gSLp3h+thGMmbOuZ1eNzqiJwiJnJ9hVvY+lE07Szk/ascA0P5A/YNV0+zHH8FmW/bUM8S3wsRyikmw3nHsusoS/14mk+6BgzFdC/cyKPZDiPQd2zICanl/7bZkd3Ie45+OhQv3A3qq5gq8IydyDgU/Tz6V52y2/m5N7AIEOJoyUmJY0/A6g9lno1q4FuojdOGDp/LdGxwr5nvwJCsIxkzmUaWDd8DW7TFUM3VYIOxau6iZgppbhzJ6MbpEkVK5S2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VHsCJm/qNaqqS2Qv1xCrTPh+geM4Jt9GFbUVXOHR6xM=;
 b=q6cN2bptmSquke44+RpJT6xUGT+0y6cfBqNSGtP5oagz1w7Ffcvhl8fz3JpwjOv2mqZQFsycNZhzF42Hl+jqQFRO2GcUWM5Tt7OksgNKHYEiWN5r2U3WJDqTkAmyTfoOs2AZrLiu/QEIf1ArAoRp202I1aN6RAPD9DZFW9mly2AXM6EQN4SLtlXr2Ypu8Y/uIeZrb38t+IOpLkUzsxiyoA84ARi+xmvGVEuH/81EFoZaFLYINwL9C7SwaTohOLiSH4BcUC0k0QKKJceqlOwUy8AW8MOEZNvJBPDgHwqsZi8YM6bAZ+vfyIyxZjLrfPgpOUlsbMA6F4H7nZ/ut3SxNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHsCJm/qNaqqS2Qv1xCrTPh+geM4Jt9GFbUVXOHR6xM=;
 b=WQZPMSggaS7BdbQ9/GHlG5rM9jqWPjnM4YJ7/hhvtKv5OyQP+ggHYMgKdmuLnCKOf1yVsO26qdCyAx0Ak8BZ4q5rVqsozGTda1UY84l/m8WRPvgcpCZhYZKqszpgO7Dt1Tl0FrLO0F1aJlcOA7NAY4+xSZrcj7qkclPcHqq1ob8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH2PR10MB4149.namprd10.prod.outlook.com (2603:10b6:610:a7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 17:08:04 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 17:08:04 +0000
Date: Thu, 12 Jun 2025 18:08:01 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev,
        linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alistair Popple <apopple@nvidia.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Dan Williams <dan.j.williams@intel.com>,
        Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v2 3/3] mm/huge_memory: don't mark refcounted folios
 special in vmf_insert_folio_pud()
Message-ID: <43e2b05f-c499-48c3-b8e4-a23ef5efc818@lucifer.local>
References: <20250611120654.545963-1-david@redhat.com>
 <20250611120654.545963-4-david@redhat.com>
 <177cb5d1-4fde-4fa0-adbc-8e295fba403b@lucifer.local>
 <11d1ff4d-3f75-42a5-968e-8f4bad84ab78@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11d1ff4d-3f75-42a5-968e-8f4bad84ab78@redhat.com>
X-ClientProxiedBy: LNXP265CA0040.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::28) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH2PR10MB4149:EE_
X-MS-Office365-Filtering-Correlation-Id: fd0aba07-efbc-4b55-b33f-08dda9d3b19e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B4PdzHv4zRVd0FXSVjm57i5X6SHSC4zUf5VlFAd3+qJUHwCbJdUdPmP2Itkb?=
 =?us-ascii?Q?37v4ZDim5pqi/bzPY7ZlSKL0tXMSDa+oZyjdMr0AWYctoTH+7VGMtz5aaZNf?=
 =?us-ascii?Q?Oht5LWIiAyWoGOgPac/0gWV/aQldaUnhhzMyqWGdu2MdSYn7937+GGgVvjtM?=
 =?us-ascii?Q?mx0IvszjEJtKGbOM18+X7mGE6crFkdlaz/D+Gli/ZLvSZf1WSWR8HucVPGrI?=
 =?us-ascii?Q?d+y1nHF9k/nXM+MiMJDJh1RwUzEacm9tyeTBH684EGrWjGeLBYHMI4Jc7K5x?=
 =?us-ascii?Q?UQIk5STwAgMLYafkuDyQKye+JMB1Bd260NxqdbaA9qofaSxaBg1cobH0DrTj?=
 =?us-ascii?Q?6TKv7lX0is1+KcmSvQJ9Cq2D+EFrS62syXTxkvr2BdKLH17j4JndCAhXoZo9?=
 =?us-ascii?Q?wmbDF9wdtqozfukmUzdZDY63E+P0vXbquYCQcUwZVWE0YRGcU47BH5s2s4N7?=
 =?us-ascii?Q?oGU8KyeCkcAhfUlwkigK1q0FAzJ+Qy4SkFYfB3ngODcNqSDk97whTbbbM6Tn?=
 =?us-ascii?Q?6fa1ZOyTMfx9PvfVojNeImDGYxhGOHYb48FFLsDcUN8Fp/SYh0bQCMQmWS06?=
 =?us-ascii?Q?byP9V8H0+RWMC7UCb4WmwVVvFndDo1jOX9ytZtKWIFLxp2LONHFofM8d8fOG?=
 =?us-ascii?Q?aJVE8THMYbSslf1QmlX1PhpXhAzVT9ToM/QAi3TWEyq1k4yJJW+6dGUzBKsf?=
 =?us-ascii?Q?quVyj1lYS+5PfUjtIZpwH3rm3b5x72GbxJlDnL/3aqIwgjwpeaQNI2DBjupm?=
 =?us-ascii?Q?52lfOinCkj7A+gRag7OPBC6wvHsKF8YqkqR71W/aSSQo/XYvbFUM62tuxO7P?=
 =?us-ascii?Q?IoBP3442Qb8d8/6Z6iQs9JbeD19XXk17xxSg3c0e7hDTP68RPmkyJR/3W+Xq?=
 =?us-ascii?Q?/d/G2w/rWLJIIqk5/nYWkGGKJJjfTdOGjXMa98C6wDao6gxxkc935bwRaCmB?=
 =?us-ascii?Q?R38+n8zdjstSRm+rZ4mR1MF+J+4IkbowcERmjlf6Fyr6Wmtlrr5bO1s3wXnb?=
 =?us-ascii?Q?zGkfiQ2GJMIAyfQacVXKWbmOPmoxtSD4Og/CrK+2jEbVh1qY0w/MSHkgfPPv?=
 =?us-ascii?Q?wj0ja00N2/tLiq0D64zK4hmhI+LG1bEVu7KhSivUHgqSJIIFXO5HF1JRzE2c?=
 =?us-ascii?Q?53FS4ICF4YxuUI4flIDujmQPU3+t16aqqOO5HjcQHDayHl8mawyeGndwAWl/?=
 =?us-ascii?Q?B7P8i6VZOZs8EL5Rcl2oVP8inTjE5nBU6DX5oM6tPrD0I/3Ebh/lwnhaifza?=
 =?us-ascii?Q?DPOIt90Rjo1PSO1HnKD27Um4lHOmCItAzDYaAQ/M7AcJvfPCLBupl4gLdB9J?=
 =?us-ascii?Q?uBMwIcJ37vuvV+ryEQ2TTVRy8k4/X8knkEG/cKLvhxOQCXDeoTvunrkbv22L?=
 =?us-ascii?Q?ukzkYszi1EsZXQTz0zRRgQ4VtHXiho9XyyERr9aDcFZy+GDazOe8Khs+2Bxt?=
 =?us-ascii?Q?0hH7w5WZa8w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LE/GHveheym/w/BokIrt8zkQKL3EFuIw7Lnp6Zo3+UxKnbt1+sdcd8l0cNvW?=
 =?us-ascii?Q?A8cUSFrec5xJ5VYvSYNroaaJ4dpzmtsNDe/L6GynB79tUMN97UKlKqGpZh4y?=
 =?us-ascii?Q?w/3b7H1oE5l6VHjCp8sQGof0guU6KVbqrdq3bHePCK7H2kTCCu9GDG2UAt64?=
 =?us-ascii?Q?zqxr3pDfx3j6QoiSkRgF17bciihenVvRHakucLTHeLzS6dVNlNjlElHX/a8X?=
 =?us-ascii?Q?LIvGFxCurwwe5Fuya9DovkATMYQV+LlbgA012g6yqLZ4nAQFqcyUoEtRvWXr?=
 =?us-ascii?Q?OKBh7wz8qRtqZovC8jmjxHvQlLRzTOPESm9lxB9VppYLONYmKR0h4FImaJBN?=
 =?us-ascii?Q?EeU28QWnijfqzM/L0Gl/1BOflnWx0LO1dRDbgWUsxl620nbbKTdRvqNki8m6?=
 =?us-ascii?Q?mMkp9q184TY7holToK+zNi2ouCBpcwqzGK9b83dQXzzzWX7l+/8h3W2Pbbbp?=
 =?us-ascii?Q?0NWXAh+Jf2qJnp5E9dW2Is1Cv9gQoKdY3TSnFYWIKfdyoEhTtgjfyT6/5Ojs?=
 =?us-ascii?Q?A0EwGBuWvrXXvl6TdOuCOOApn7JOCsbjv7tYueQONU2onKOJ7Xpvz09yfBij?=
 =?us-ascii?Q?jMPCmVhrpzfDb6FUzxk5USORhCLgpOPEEjHt0fUtmtXUJ8xk0Eo2mx2csSiI?=
 =?us-ascii?Q?qnvKjdqQyLaGeKTv98hg5UP46K6M/JSYfrxim2BROss92VDmDxYQd0a2y6vX?=
 =?us-ascii?Q?tN6FZrMMGZv9cFoEqIFQi5Fde7SSBAccaUElZVRoFmO8PI17bambB8Th3BFq?=
 =?us-ascii?Q?K0KCr5Mblen/IHG/pqcsU6Yd5whOFvbjP8WP+8+3DlWoRWRmEghsR6c5U39C?=
 =?us-ascii?Q?0dek1r46Ue9rIC6CSda6i+f/HxgWe9CxApNg0IU8tQi8M9YUL850Ubrhjef6?=
 =?us-ascii?Q?IaXSw155mAnEi6i91pNGGwa4YWtedethVWlns9anarSIkkFTV4fR7m+MgfB1?=
 =?us-ascii?Q?+raEJAPAbGUBstvCeuz+tK6yz/GjVd7dVxarRNGho7M19tbJYO0ZzwUhc3t8?=
 =?us-ascii?Q?iNAg3r1ehTCED6l61JzcLeOZf05/6AQwpkmonVrQjIzi/SHiRyRrQBFWUa0H?=
 =?us-ascii?Q?IqEqLe7hORa4lLwmiwvNwZDuQlWA+gbS9XZ2V+6UfgwmudyOIwJGcHxuk3F+?=
 =?us-ascii?Q?McMxvRt6RDzfeFS7HgW4AyU38iPN0ci/EZUAsXtriA6G7/mMavKgJv/BaKY3?=
 =?us-ascii?Q?57Um1mrjIO588lMtFNW4Tg/cASr7+PF0EoPzfqEh5m/Udw8lvQrUdVl8Ti20?=
 =?us-ascii?Q?AanrJIwmwA2mkOVHA20yjURWRBTbNdgy4cXw/3zAKr1XFWEZsB+IumG7MXjy?=
 =?us-ascii?Q?yI+yKKGvgLzHTqxes65vQH7sms9RJ6cSMAhv/z+alfsI7l5GFg4+bRhloBSk?=
 =?us-ascii?Q?8IkCkOmdeNJeKaaDX8/E/PuzE+zu4E7Fr2UOGm/YUCfxOmmh/KCmzuG5C8lC?=
 =?us-ascii?Q?JbAVLD96Pwcyob70QrUV3vsDstDagv+SYnqNVzpxOn4QeX9f0p5fpM9ls7dL?=
 =?us-ascii?Q?r8sP62h/BTfR/gTnxk3ySkklJCx6HCpB3Cv63L8K6/18HuxxZUlHnRABCS1l?=
 =?us-ascii?Q?TXQii17/janI7Yp3GPoBAhvOMMlucwP6OHdzlMs4DaVDOfFvV699jbRxbaca?=
 =?us-ascii?Q?/A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pBrticVo4rsu1W6RoMjsuiOdirqmrON5ZtB85X3XiiBYsGKyI6GPRhTnglKC3aMfkkd85txOvGSg9nAj3Wb89PCjarLZ0IgGsh2pKdG2zSL5udQYDnpwhgxS70DKuzAfcOFzYyAQuOjqy4aWk64tEhYkaCBsbf/xO0kh9AtI9eWno86gAP6VcUeCIEef5pkyWu9/F3CbjmTceIst3HZacc1IfINfUP3qOeIhVOJ16xU+fyccmkJrz85vFE9BC260N7xscui1Ygb19D+P0UIJGx187XDf2F2J2MbehQ/K11lt6FlOfd8R/Vcl2uTazIUr15q8X8NLYKp2rOcVzL+2b6sv0H4YpvGgUCPs+Nr8j4R4Sf85JVTyufPcq2SWTHKEvrjbK/3GaybW2y4w7c9dKFR96S0SgOQGL0YDJ12d7S+t+zFVBSnbtFGa69+PZfT7Y0K/FmBYvV0XudDZiw/fmBqPWMh4+XncZNICc4LV6SSvdi24EzJVGZu4Kf1wGIEszQgcrxB0U9r65tFdtF5Co8L1dYe4kySZ2hyV3Cy4XNu2z9meDQSQN0s5oOxQIS+W513Npz4r7FL6QtvYiLoKAw/iSHu76mRWs+h3fh7Cym8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd0aba07-efbc-4b55-b33f-08dda9d3b19e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 17:08:04.0674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /a5wATJ+DK6NHmZRDe6POSbdKW9DpPRwmH9OVAKumHtJL3k3Sj7UhWGnxYfwgJkZd0eqBZzeIZA59WxWzuqynws6au49+Qcy3xZsXo7odNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4149
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_09,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506120131
X-Authority-Analysis: v=2.4 cv=LIpmQIW9 c=1 sm=1 tr=0 ts=684b09be b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=B6ZjmP4sUpVfYxjCxPoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: qbZUBGLhSP099TR1uh9JXPIAGAGkvnP3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDEzMSBTYWx0ZWRfX6D95hyEW4jGC +4bvLpg5wKHmJvBatyQS66TYpMzZUhvSEWvERcigdyZfhF4oadav08OuCm/2kSFPrh5lDazjG80 QDANAoRBtGZjfFr9CmQjrnTm5B7Es2Q3NJ2k/NjJl9eqVJfDhSc9+NdBvVIXPCnlv58PXtXIjBy
 kCckIbBXcx7dgnCx11Whv2L0uADkJy5Ss/fpFV7j6m7UU5OAxseFj99c5iBxRscTp2NZxkgEIv1 ndCV7TjWw+3Um0o14163drpJN9ZjOVidLh12bnOxEEZM862SW8CJR66OnF3yu5FUBEyKZlS61iY rMtmb8gfW8WAvPHHGjeZUKPqrH5XRnCwJOJI8m+0W+1w3vJqK2W2IN7Ib2gADIq6AmbVwc4qnVs
 G5pTQWT7uaInaRTz1x9H0E+5CQHFMNazI3pgjElPCjEICt7U5ZJU4IfmRpFLKjtfIksB4i+k
X-Proofpoint-GUID: qbZUBGLhSP099TR1uh9JXPIAGAGkvnP3

On Thu, Jun 12, 2025 at 07:00:01PM +0200, David Hildenbrand wrote:
> On 12.06.25 18:49, Lorenzo Stoakes wrote:
> > On Wed, Jun 11, 2025 at 02:06:54PM +0200, David Hildenbrand wrote:
> > > Marking PUDs that map a "normal" refcounted folios as special is
> > > against our rules documented for vm_normal_page().
> >
> > Might be worth referring to specifically which rule. I'm guessing it's the
> > general one of special == don't touch (from vm_normal_page() comment):
> >
> > /*
> >   * vm_normal_page -- This function gets the "struct page" associated with a pte.
> >   *
> >   * "Special" mappings do not wish to be associated with a "struct page" (either
> >   * it doesn't exist, or it exists but they don't want to touch it). In this
> >   * case, NULL is returned here. "Normal" mappings do have a struct page.
> >   *
> >   * ...
> >   *
> >   */
>
> Well, yes, the one vm_normal_page() is all about ... ? :)

Lol yes to be fair that is pretty obvious...

>
> >
> > But don't we already violate this E.g.:
> >
> > 		if (vma->vm_ops && vma->vm_ops->find_special_page)
> > 			return vma->vm_ops->find_special_page(vma, addr);
> > > I mean this in itself perhaps means we should update this comment to say
> 'except
> > when file-backed and there is a find_special_page() hook'.
>
> I rather hope we severely break this case such that we can remove that hack.
>
> Read as in: I couldn't care less about this XEN hack, in particular, not
> documenting it.
>
> I was already wondering about hiding it behind a XEN config so not each and
> every sane user of this function has to perform this crappy-hack check.

Yeah, I'm not a fan of generalised hooks if they can be avoided, especially ones
where you pass critical data structures like VMAs.

It means you can, in theory, make no assumptions about what the caller does and
yeah.

To do this for such a stupid edge case is ridiculous.

>
> [...]
>
> > >   	}
> > >
> > > -	entry = pud_mkhuge(pfn_t_pud(pfn, prot));
> > > -	if (pfn_t_devmap(pfn))
> > > -		entry = pud_mkdevmap(entry);
> > > -	else
> > > -		entry = pud_mkspecial(entry);
> > > +	if (fop.is_folio) {
> > > +		entry = folio_mk_pud(fop.folio, vma->vm_page_prot);
> > > +
> > > +		folio_get(fop.folio);
> > > +		folio_add_file_rmap_pud(fop.folio, &fop.folio->page, vma);
> > > +		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PUD_NR);
> >
> > Nit, but might be nice to abstract for PMD/PUD.
>
> Which part exactly? Likely a follow-up if it should be abstracted.

Ah on second thoughts it doesn't matter, because you're using pud variants of
everything such that it wouldn't be worth it.

Disregard this ;)

>
> >
> > > +	} else {
> > > +		entry = pud_mkhuge(pfn_t_pud(fop.pfn, prot));
> >
> > Same incredibly pedantic whitespace comment from previous patch :)
>
> ;)
>
>
> --
> Cheers,
>
> David / dhildenb
>
