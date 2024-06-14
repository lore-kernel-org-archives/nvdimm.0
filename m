Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6561EA6E;
	Fri, 14 Jun 2024 02:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718331097; cv=fail; b=Me+fMMedaUfHnHp6MSnZoN/cVdtm9p3ZgGPonl7hajpijePmGWtHknslq2FDqaQd9HpuLmN7sWfVtvGiTMUNavBC982Rqr5GKFh5ilMMF6pvrmh8EHC8mr2aWSt9kn1dzAzsIObTi6Nt+T0aSgkZD8fbXtZSvptWm+ksOydaBYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718331097; c=relaxed/simple;
	bh=3h2kj+byNLPZqX8QudEw/Vfo6HFgqVWN0nz5OqPh+/M=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=rv/vo/WLrWcGCEI4FC/SNSnzD+kkH8izDMImfBlOmgiq1wRyP+5eqH2ZM92ondv5mTuUFzEc9PFvXRI+76LYboThOm4BfQ1WFiWlzAt7iBTogh/fVRy9pBWuHS+soajfQIwpyzjpNznt7QIO8XQaW0wz2l5RHQ4kY3RyTzVSj+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WWtW0ugh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BLqqRdCK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WWtW0ugh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BLqqRdCK"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1fpEd029945;
	Fri, 14 Jun 2024 02:11:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=u2HYoo4c5IMwni
	CtRg581OKSOAtn21gaMwK13oHJkz0=; b=WWtW0ughp90LpNDBSlZxLPnxLOdthh
	oXf4uJLr+rKSMP5X5kTKXjwWGNVYOar/mIcBQEitj2gFS4YWoDTfTNpU5N2jSRuz
	4o4lkxWRdUS7IcKxTLKD2hSRzAlZdiQe64ozfJhh8tmcjZDXduNm2hV9M2OjI/8k
	FB9Mtu7dnesv5x3cY4z/aNEuZh96arJoPWHNH7PMbmTJD+RtA1OLa5bdld7SCQp6
	6Uf7jn4yY58WQJ7sNE5uPaJh366db05XtHtcGEzyjknRygtX7WDU1e9gRlBOam8/
	MdlQhMRozI1sUYkJ1iAGMiDUGMqcNZJbffun4RsQdUTb9oUqOdED5Q+A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh3pap3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 02:11:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45E28wei027135;
	Fri, 14 Jun 2024 02:11:20 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncdx3bu6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 02:11:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1E+VJdZS5EPWjFpfrnGuLRzxDn7uLKpFsSxEZOxQXHg/dj0U/GZx5X6eQJdEmK6ji0ecvelj+Qz71O+4rqC6mDcIlHrUENbmvcVLCgRQC+huQ+TZtzSw3uZOAhpHWAnxVVu9vBpSWieYTHptWg+BGf3zqNWsKE28GNc4mu84Qj1YXwdnBYuJX4FjsQV64NxpcDZRm1FN0BoyG6XAiFaQaGcsWyMISkCy+jBT8lBxSUjeC5VbwUvB40WALaw7Bm/Xmq1avtpaIP2iX/W9o9E3Ku0eTlsKcNgcYO7ypaNoF26aGcev/hGyTqUKRCVrenC9Vcb8ElP7b30TuH4buwePg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2HYoo4c5IMwniCtRg581OKSOAtn21gaMwK13oHJkz0=;
 b=nLMJGL2fBAvAc6mFNozp/Q7YR1iBtqyra4eZC17XrlIdHNa4/P23Wp/3qq7dpEhabX8hOA3UO050haL4oysuml57LwVuw4/ogbMcoxL8oS940+4Q/ZfN3gMWujbupfAwgj0T4l+5douF00uHI8mf70WUB/xZIONZkSk7XWHcbSubK2r44aHFD/rD0cZpsryZusKqnRr1ktcgL/d8Ln4uefyMG0qHG6nnYjX54l2gNGIGyHhFkN1OkSLoCilXahu8b/osPfczaH8PMOgJhWHujdgFomUgqVVp3c2U6zcHnqRSMIL3tvIFmcKR/fbzQp9fyZrOuTVWFo4nSerUfSnIIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2HYoo4c5IMwniCtRg581OKSOAtn21gaMwK13oHJkz0=;
 b=BLqqRdCK2YFJhvjFx/tD0Ils4pyDhQZfGvUxGjlGcLl59HAI793rCbZDoJPWyPOzge31iVCz7XRHuGn9BeDCWkwdG4gAfJMqEPJJoDhMh0Orj8h8IQeieQKfaowQlbIXNLeBiEnug/WegJsKmBjJ8JjCmNbmucQ4a0Y7rIJ9tBk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB4896.namprd10.prod.outlook.com (2603:10b6:5:3a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25; Fri, 14 Jun
 2024 02:11:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 02:11:17 +0000
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
        linux-scsi@vger.kernel.org, Kanchan
 Joshi <joshi.k@samsung.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/12] block: remove the blk_integrity_profile structure
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240613084839.1044015-6-hch@lst.de> (Christoph Hellwig's
	message of "Thu, 13 Jun 2024 10:48:15 +0200")
Organization: Oracle Corporation
Message-ID: <yq1v82cp93d.fsf@ca-mkp.ca.oracle.com>
References: <20240613084839.1044015-1-hch@lst.de>
	<20240613084839.1044015-6-hch@lst.de>
Date: Thu, 13 Jun 2024 22:11:15 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0044.namprd02.prod.outlook.com
 (2603:10b6:207:3d::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB4896:EE_
X-MS-Office365-Filtering-Correlation-Id: fca607fe-00e4-4dce-d8d0-08dc8c174699
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|7416009|366011|376009;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?uOiUH9P7aKnwuO+Gqa1eSjsLrgUgPxqfU2L7zXUlFw/+XsPzFgYLyrfzIiuR?=
 =?us-ascii?Q?BTXuQy72eX+tIovja6U4hQlruDyfjeTcPIbrG5/GDRx6AAzcqAmf5Vto9k6u?=
 =?us-ascii?Q?JY88XLa7RpxSAN8bkaVQFHjkhGPAyraVLXQ/0kdzpF/7GDEpMg7902vfRnI+?=
 =?us-ascii?Q?qk6J5IesAt48B34oBQtl1awRZNyOOA0KgKxk1X2gPLaSwXxx2y3gxhON0EIq?=
 =?us-ascii?Q?Eat7JC+MOuYmw3iwjLDKPsK14CiaROurfB4icqba8hPJUxWODWWoz3dcvgBz?=
 =?us-ascii?Q?HVG9voJcIWLZ9rYwqETTCdBcO2CfksyQYCXtX2r8mmbtGfHaeOLpJnmwT91q?=
 =?us-ascii?Q?YuwfzKT7TqHk+pm1mmLhKR74nj3eR0Eln0TDGo5KSHALS9WoXZEHK7FLl1MH?=
 =?us-ascii?Q?EWfboaAQMKfil9XEdD6tX6RFZ+EmNhUDtsApZLFfl/yJMHHAe3/igqtGz48U?=
 =?us-ascii?Q?6VbzXDGQq36MHQdrSGLbduV4o0c3T/w7FZm3dLjQrl8sWozG0XXDV0UbIrCT?=
 =?us-ascii?Q?hs7tE0zDUvMf8rZbo9eXQmKUOR8/bN4yButTdIHDhMhc3HqiBhqE7rtE9e4U?=
 =?us-ascii?Q?wdmKD2YmuagiWB6HIyyQNxRg2VpUw1JMvJmqzEJOGlNHLfb0cE9qOUH8/BiW?=
 =?us-ascii?Q?TpcsiROpB1UQ0lbFPjM37unFidRqWDaWqFpU/QxAoongp+0ioRwdOCE2S6Vr?=
 =?us-ascii?Q?+pBAZhUwTwk7+D8yPNctxP34p+5hOi16Whzcp6wk16QkJVu7WEQv3Hg+NSjy?=
 =?us-ascii?Q?mk1dzKKsBzP4TegG9qw4+6ExYF3b7qwgynVfcdD31gt2o4H9cIQfjwBGpgqb?=
 =?us-ascii?Q?Y2fqOq8wCANJIZrKwqly2GceLtNlOAjU/ofl220iCfByZnmHRl69IuHHFOX+?=
 =?us-ascii?Q?7V9p67woH0U48l5LrkUAKdXnRpg1ykVY74bhZFaHV+DxZaF01YEh/gcRMY9U?=
 =?us-ascii?Q?jDbRKFMJF7cHTKbMmAGqP38y8anCx6kjWdSRq/1xyihxtC5XoMqjVE/KdM9L?=
 =?us-ascii?Q?sllX2SlS/Al7oQ94XgY7ewq+B6NRHF8hAfaxE/jvNjsGk7xUS1xppF+G1k5p?=
 =?us-ascii?Q?ZXhQTELU8ZuaLQZuNO6Iol7kJI9bWbcxTACG8/wtISeeQo1PB9BVOeqdK3SU?=
 =?us-ascii?Q?aSAjZT6qTRY4fG2QMlIW/hBLvak8DHPsEvEv4IhBE1n6eeMp9yyjLVGZzJi9?=
 =?us-ascii?Q?dYnLXYyd2jBNsN5ybIcbK+wV+UAZ2FV7XMJlYb27TdvE7TZjp3TnrV4m+o70?=
 =?us-ascii?Q?x/TGisPw8vZrVCFr0KYeLkHeaKbZ1cvUVON3yZWiMaQ5iO3g71Mqe+QWJPYt?=
 =?us-ascii?Q?L9Lb+yT0W54UMUe0xVsk+nfr?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(7416009)(366011)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?k5bqt/yMx1kZqYrdgBWXwT1V+yGvqATQZPfmB1oySBK3bIpbL/wR5qm2KfFW?=
 =?us-ascii?Q?rE4330nFMWiVv/OnDZMAbcCvdleDMDsAOvnYVrxtxSURYU3O7YoNcYk6LjLe?=
 =?us-ascii?Q?f37jKLX18KJJKBQ/EXD9nk0/1/mb6NuMmV16Euc9tcwn/BTP3jRf2NsXiLSt?=
 =?us-ascii?Q?+HiBa3XNZGRr4v6TGE5nf5ta6Xd/O3f1utCrJCTjYDDh2i74IWQU4UIDSAE4?=
 =?us-ascii?Q?+m/o7/7hJVcPkDZmPRXmhe4Se3WC1jdNe0ALozocgnbRvm5IANYiHqOPMh5I?=
 =?us-ascii?Q?UMWWMWg/s9IDhdhBHYvWJZaHt9F8Y42jf8o8gQdUv2TPwIuNxLyYK9eCpdYd?=
 =?us-ascii?Q?4TT1Jp7JBbFRvIi4bLweP+x37InGUdgVNo4iKC8UH1JGCeWBBeQTr/w3KFcM?=
 =?us-ascii?Q?e+i9RBnRHzTt9V7otovGWnwjLX6bA2/e+Turi5eheiN20hbf71qee8H22ryq?=
 =?us-ascii?Q?+wkwhOac+QIBFQhBS10JnTQPB2QxrSsvPOjAH/4nlMxw1Rat5BADT8Orjdq7?=
 =?us-ascii?Q?EjYYQcUbYcsu7KNOB7xf3a7aB9ZkBiOEIFOVXTLUopmOxLTYb12aoTWiV1qw?=
 =?us-ascii?Q?cQ8YxivH2RRc/VBzMn64DvQYDU8JUvNzcaoBMZ2OIPwVuwwN41/0oLmKdsZf?=
 =?us-ascii?Q?XhdoUz7aYx0SvYWHCmKZUyGWAvmDeJkyQvDjTo7ekDBgjZcSwpiLvkaT2UAg?=
 =?us-ascii?Q?ynqCEBlfg+fd0KtIXHu06PztpNix88ebGCAIGRYVeRfmXNz/q0OUAMvEgPTr?=
 =?us-ascii?Q?oyiayFa58ANG7PsqolziA4OgQP1k6NJcsfIJHZQG11NBcxYiVr2jd3+noy74?=
 =?us-ascii?Q?MO6JULilTWc6lWykYUtE/XwwJJojSGc44vbgJvKqRbl6afpUcXbIMZ2eHCOd?=
 =?us-ascii?Q?EJZknW0OwrRxTD2EHHtWTbQnqFtBNf0/eVMo6A7KLgmr69gpMoIinx3Qk4OH?=
 =?us-ascii?Q?siVAeWMQg4mtnAO0kGzyXSX8ag4HEEgMbrzlWUSzvHVJK1yQPUq439vxEAWT?=
 =?us-ascii?Q?Fa0BKugoSb7xjk5ZX0BykcrVpNs8R/CSG8TPm+/eZOtex/s5QLSW5/YntoJI?=
 =?us-ascii?Q?IW+3js7w++gKaUQ1mSpUVSCAFR95QThqNr86dxU3ddflxuZUkn9H0VjrOxpx?=
 =?us-ascii?Q?OgzO/J8Z1HPZhQWo/fCExV4Q1dCG4c2vEGfznhq8kH/HBQoX2AhZ/2hi29k+?=
 =?us-ascii?Q?5D6CjLBXOzUPZ/+SMPTkAPeoJJesD/wyHhcXGd3CFKHksh/Pggy7JpQdBrQD?=
 =?us-ascii?Q?XUPqwLEncIb2k0zeIK0nKb3GDLqL6XPmYs+sD6Etdo1qhk5FuwL7aYhMIsYg?=
 =?us-ascii?Q?tlg+UjT7+0gsgoDEKiGx3Rf0toq5bUvEePlmBrZW9TdgQn6KrJ50KRc82L4R?=
 =?us-ascii?Q?kZW1IrE2lCOAD9XwlGpcDoZz362szXHDEt+kLO0m2xUvIeJbqDUE+zVQMpqC?=
 =?us-ascii?Q?gg6cyGWMa5pTJaMQU16H94leN0gm+vqZeuWHygFhl+l1TBiYhNyQy4IW9NhM?=
 =?us-ascii?Q?I+x0AijZGxbR5owrYcaNgrl4zVVhkRfJmlAnye8I/1uLJqusi6ROxNZXqmxK?=
 =?us-ascii?Q?WiVGVeW7UvIQaVITBI6dwb63icO7kaDb+NFlNCwEcOlOVyJhR4iFh9Tmlc41?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	2HAX79utEtss9kZ09YDX17WlkISuaVbutkIhT1VTu3edLZgRsLrgQn1YioRpoG0K4m3/tdMRDHS6WDBtUOdAoFX4FdJC0vUyR7V40ic4VCpz9/hWmb4ZsivilpMyWgonJ3GVjH5Sl6JxZ4wWiah5P3V+2OUlyJwUIuYjBtIJXR83XWNk1P28Ocg/THSUzynDC8tiKrt78H9xO5LFxkxh3zr70VYkDioN9hsNTIDhEYArgS79BC8S+v7kX+yhlvMlwl0Q6sX1+e+gVI+p7srAycHG2id5iPtiTQdJqdBqkOiytwjO9N8YI8FnbuEIjL/DVTpk/pbh2LsgdVxB07yAfr6LcP5O/U1WHrveTlyCvt/8IfZlD8j0okSzorwVwjkZscnqCQSyz/J9/uozLWq12SY8PVEuOJJf4XX0Qedc+2BjT6dmJAaQ9dxV2elcAKel2mnrOHIiAlnNi93J/pm9pbQlHojP6aCZKWDMDd7ME/2qcbG7pyKcwr9lvlAgqhoR8wGs2YUiAO1dEYzZu1oGKx+4d38Hbr0LiEpbrQvpYtIpTcCjNTaC0n0sGHXKT2NT/lvaXVwBD0eGx8ELUIaRNgTETIDB4dV/6YPHgIoPI2M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fca607fe-00e4-4dce-d8d0-08dc8c174699
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 02:11:17.7842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AGaNKgnqSDVzFHkPSfQ69HjKu2VPmhaGNJoU8xvP+CG46DXxlNNPjzqMDJWTEiOLvIU4+J0OLIqMZZiUFqBOIJKGXSalEWrrfM41HExcTvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4896
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140012
X-Proofpoint-GUID: AYF9tb7p-hbSwIwafscZyZmDy7-ROEQv
X-Proofpoint-ORIG-GUID: AYF9tb7p-hbSwIwafscZyZmDy7-ROEQv


Christoph,

> Block layer integrity configuration is a bit complex right now, as it
> indirects through operation vectors for a simple two-dimensional
> configuration:
>
>  a) the checksum type of none, ip checksum, crc, crc64
>  b) the presence or absence of a reference tag
>
> Remove the integrity profile, and instead add a separate csum_type flag
> which replaces the existing ip-checksum field and a new flag that
> indicates the presence of the reference tag.
>
> This removes up to two layers of indirect calls, remove the need to
> offload the no-op verification of non-PI metadata to a workqueue and
> generally simplifies the code. The downside is that block/t10-pi.c now
> has to be built into the kernel when CONFIG_BLK_DEV_INTEGRITY is
> supported.  Given that both nvme and SCSI require t10-pi.ko, it is loaded
> for all usual configurations that enabled CONFIG_BLK_DEV_INTEGRITY
> already, though.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
