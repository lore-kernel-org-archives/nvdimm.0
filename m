Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557ADBA53;
	Mon, 10 Jun 2024 12:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718021146; cv=fail; b=YYmcoV+catGTkOrfGHesBSGOys4sAfdfoNhzSFJ3AxhgzMHmICurc1cZvPMeGdn21v5Ksdd4pRZOGQS4t1W9tMUJyPW32h1i2ZniXQUYOhjC68bVchWPxmzlfq8q0lwoKrHppOrJqxMDpLmHk/MIqv8EuU/a/uHoss2VebuqOWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718021146; c=relaxed/simple;
	bh=zv90egBnEPRvAfZDC0aqD1C4NcKrQ5rz6Ux5a7mWvvs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=bdXPGBbS8KFr/s6UnGIUI0rDF2m+pKyKPsc/xODu+uXM5pjPAQY0FmguyEGfJ6dIUCPvjwJ5G6qi+z2Yh4VoLf9riTqbZn3PGvMH5L7XJL9FpDsghqA7tb+/XJCTj4Gp75ZAW9l79j/UhQo1IzQQcvJC065q371VN7mv17LTn/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HMp7KKQt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=v/rZVDa7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HMp7KKQt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="v/rZVDa7"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4BQ8t030646;
	Mon, 10 Jun 2024 12:05:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=6n90XJfZ9yrWkw
	b/9jwt6W8iELesctCdqJj1oVXv3hw=; b=HMp7KKQtYUMw6NvaCFPQ6XJEMyRaAf
	PkPixknafa3QnNCRWjcoo1w3VOxefsJZZxYYTazJ9919nkBYDi5LADV+kS2OjwKu
	msfvVPcTfbVajIdH8/YDO7dsbKOKK0Qm8DmA9bkDHXXX9iFgHg6IHfe8qEKuinkD
	av6z3GJj1jAGSNTroutWWnbMifsqgaSyrBxmttCmn0ePWpcMNmdwt+vkr1Ne6WdO
	lI8mkwnf6s6Z9rx5oniGSqaV1xX73/wrRmv9e0xzEqxSC2mx4mCnnICgTK0XM96d
	tDAu3yvHKLZeM9b+3kMm3kWVhvmfVRepkYGNOC3cmRCWzlnrsylsirkQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh7fjc56-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 12:05:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45ABJMd5012592;
	Mon, 10 Jun 2024 12:05:29 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ync9v7nsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 12:05:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jv6vBeCbzq5/qx53Wpa016hKtOVdrYQyfXBnQ7tEL3VE+60Gjb+b8+WLASlbzC9et05um75WU+WZpPeyOdhb90NGtBO4j1DH4AXEEFZaFRWbFtwYmnOfp3q91jMkYHISbxVjMARzv0lCTlZFP0D3jjtvDt3J1IuBM1YBNdhZ/eEl0TFqBRwF9Knh8JdoySROYTjq+BvfqrrZXTYvPzNh0ZsgdG+aCZ/rRCTYVHkudmMwGeQz9VEnN4jFG8IBcHa7+bBoB0CJLizeyPCQPnR26IQZ5iQpqjj+nHX5fupcYc86Brd2mUXBRUy3XHlZ6Htl2IXZpw83siYIkEIF1SOUBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6n90XJfZ9yrWkwb/9jwt6W8iELesctCdqJj1oVXv3hw=;
 b=GWDcWue4KbipXX+h7InIzXbpVXUjo2kgnSQklRyiXmT7E8cu8lC4k1CWa02YMetnYAjmGOe/44eZP2q/EaK47O+vPtG8STHNX5rw/EyZgXZZsk0y0aEukVg1H/em6FPcgeEFDqgLFoBAQB4q6cWI+RmFech+nIS/Yr5MoO1815Ar2hg0QJlk9/X3MNFCWXnb4ohi0CP5giK2Pl2OJHHwCuaQHgICen9tg/OMhuRwbMDB7e4pxm6jdI920p3IY7njsEJdFFn3kMbSKy5X+xIol8y+T4ZoUswoD1iiocIJOoVbLx3Zk6So5jVjPaJ7rKWy24XTF9OuogVDlwyt+qVMTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6n90XJfZ9yrWkwb/9jwt6W8iELesctCdqJj1oVXv3hw=;
 b=v/rZVDa74iFBCAFN6vdGh3OGHXkrMPT5rJ980BUdg9ddIBBrIkDax/qxm+eU+vfPML52/L2yti53QAzuDadIPgh6sk04yLii7exlOK/sPEP/Ih76pUsU1G353QMEcX4UUmLiXULeaiY7WhpHOhE++MEww8wsBjC7AUbPWlveqQU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB6106.namprd10.prod.outlook.com (2603:10b6:510:1fa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 12:05:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 12:05:27 +0000
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
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 07/11] block: use kstrtoul in flag_store
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240607055912.3586772-8-hch@lst.de> (Christoph Hellwig's
	message of "Fri, 7 Jun 2024 07:59:01 +0200")
Organization: Oracle Corporation
Message-ID: <yq1h6e12ebk.fsf@ca-mkp.ca.oracle.com>
References: <20240607055912.3586772-1-hch@lst.de>
	<20240607055912.3586772-8-hch@lst.de>
Date: Mon, 10 Jun 2024 08:05:24 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0052.namprd17.prod.outlook.com
 (2603:10b6:a03:167::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB6106:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ceb28b6-6bf1-4401-7831-08dc89459db9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?pFG5tz1MOLMrg8aNLkuGG9Rb4uqouw8s+yPluS+t5UMIVIeTdvsD3atgSnyJ?=
 =?us-ascii?Q?RER86gVr95i8f01+tCqwAd2ser2cjy0oOgjFWOZR9iUvw34Sr+c1WIgQLzZt?=
 =?us-ascii?Q?Ln93QMIxxrcobL9rruymC3BTQZ51S+NX9+eR4f6aUkUuUIW03oPUiirYEkq8?=
 =?us-ascii?Q?K7FeMQadB19azsLIJz6nUKMbF6EoXnqZCl+/7N78h9yYN6DmQ8+XD1tXO/Kx?=
 =?us-ascii?Q?LyBDa3F7Nsvyq5oemDkb8GkRVOY13cHm3PkL7cPWYFmArBisGeOKmbOn5eoF?=
 =?us-ascii?Q?/N38Q5fuUsg/ku7VzJvO8eKQaO5/AQeBz4Ts2nTgdHilsT4/L6WWU4HeRS1i?=
 =?us-ascii?Q?1eT/PET3zDIcfid4bWPjCJ9GeEwv2cYQzXVEgKQ3GTTAQoo8u1UH1yZ5qT7W?=
 =?us-ascii?Q?COuOXciQYx9Z3q7dqleYGuCCmcdXyUspaOZ5K7WU7WkwG8xommiAO+5Huz+s?=
 =?us-ascii?Q?eVfxrXXODJKRjcPrQtTcJiTp5vRPvaG5nADJXLWVwjD9hR8sg9MJYlb5g0nU?=
 =?us-ascii?Q?bXJsVfnYPH5eNHARm28DoFACTh8LQ1ZVS0GKu2uMYhWHy85pXLjQ/TebJqik?=
 =?us-ascii?Q?SV9byX8MSLqieBzeDW9+LM0+2NkD+l6KohZIdttcifaOHFV3lHqILsfkuv2U?=
 =?us-ascii?Q?0zeXfvjGG+qsuFtuyd2u7xF93RC3FbHlNBwYzwMjGFrFdHXZ2G6vaE8IWEc2?=
 =?us-ascii?Q?TJuLMcxUBgxK0cLeFMHHBJzzz3qe45hNNd+2gAByrYSfBA4TMS+cgmVWmVIG?=
 =?us-ascii?Q?mAZY8heT9nsvd+QPS1prLiC17gLMVtBxanFxzjXVCssU+kQ+L/bmA56hUyOr?=
 =?us-ascii?Q?oQ7rjXxk3Ph36omWSytW3d6o8KLqrshrkfi20DJO/zrYPyOV+ZAtvYEw3Ti7?=
 =?us-ascii?Q?rc6DI8kmUIVxvttLmeIoekdzH59IAUHbnEUBraVsVc4+fL682uMCMpMDg++p?=
 =?us-ascii?Q?JsWcWtAPhTV7ocGC/Z94rUbkvWp83caLOa+5HDy+ujcIZBw38vu3oktVofsw?=
 =?us-ascii?Q?L2pbNfyb6qYu9PV0i3l2ryeLUQfo39UPzFajDgauCXYLA2GcR4JbFD2cxkJ1?=
 =?us-ascii?Q?Br1t/imkCaIagtHeEa95j7sjb33oSBd9+jRf8a3nfA73/F12vgU5oSfDYe+G?=
 =?us-ascii?Q?/bwKpzQdKyMFf+5/QLdDQoXkUDLGYm6yw6iWnjBiDSsf3bOv7XvOtDzmnEWO?=
 =?us-ascii?Q?lzrYV5CWi4aygJRZTzzGMka0dvPFhmXIeh+WCOhQXvW/WBpwndUzNgcBcTfl?=
 =?us-ascii?Q?o9+o4EHQTHo2zZ1MIwzW3o7tiaKhPXPtqY2qlJUxA8GtMrRQQvDMzgKWlvyl?=
 =?us-ascii?Q?P+FzaIl3b3PXcC/LDIf0FxoM?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?VSnJX/M8Rw8QjvuKhDjBxWp9zwnTbJbvxPgFPDUcFWmHPJtgnae4Q3JP34nr?=
 =?us-ascii?Q?RqqUmL0t49H8r5VMDET8aveA+pJl/m93NruY+1vxl2ONawcFecsK8olFiyrf?=
 =?us-ascii?Q?orIXIeO2RUjKASuQqWFOa1k3b3omtZ+nKQeVXnIivrIbPku4b5bIg14h8Gjr?=
 =?us-ascii?Q?gdQ0AwZgSb6nk6NdLjzTy+ET8KWB61s1tfQbvQBntlgt67lZeKqgzkTu8q4k?=
 =?us-ascii?Q?KITbLy6xtR4vbjcnCTn1LczuySjFmyP3zQ+/FIrXBM53C6IIUMhqXIASz74q?=
 =?us-ascii?Q?ajmIowTSvmadw9bQ5AdL2jIXpkaABPbg1mpy+YSyLnIrSCV3bJyRyYdvu7Id?=
 =?us-ascii?Q?ITiiWQKiSyRSMeu3hYnghM6DuMxtvDvWamvO8+1r3ORfeKeGhTwuPuYvUtkE?=
 =?us-ascii?Q?3FsKhNL78hWuP/YUUNFqikqTFInyDCzyLJsJ0fQmCT8FaFSmPRgHsK2pKsRN?=
 =?us-ascii?Q?9V7Jq+6BBUsYlETP0J8EPutZLK7WsheFDE3odTVM+Of1rWhd7GyBzPz0RkeQ?=
 =?us-ascii?Q?AmbocKwGq2bOdHBQyhNXEKHSdp70ebrjT9udCCNB4hpLQeSAVxD8/l6e4BIK?=
 =?us-ascii?Q?+oKVpqpakHp9dfk6bBrYCrP0R+c8Kd0YrrKqykK+am8lHlsqL5XSOCNzZcnY?=
 =?us-ascii?Q?nM4L9NkRA94E5TNxEg0SHFj/fMfFQFifpB4zTg9XlcPeKyuXWajQDF0eJR/i?=
 =?us-ascii?Q?mNUPSRRbrn7I6/E05lSWqgF4To9c1W3KIZuQs+tByscm5PupQ3ARAadAbaJc?=
 =?us-ascii?Q?6s1uDt0wQni7JQLimXvRFiLsHWCiW9TqYnX1vJSaCdv32wZP5RCJrT0PuIgm?=
 =?us-ascii?Q?iT7BiCPGW7uV7IOCrNpNiXBN2H4m29LK1fXLKFpy1+h9xHolgoPNZVfPUd8H?=
 =?us-ascii?Q?x6V7PP4+7KbKCSrgzwhx5vomDtYIpAgvKC1kuuF+qBw1n3h8Vs0DkBric1TX?=
 =?us-ascii?Q?6LmJYyRwaP+YSo+G3kJk2HOWqtd1pEDlEeMu/6q3POw1JDpe9yw0ZX64hWe9?=
 =?us-ascii?Q?01Btd7I8loQNZB/+sZw5wlDTDyK+UiaiCviDoAQU/E6hkIcz5BqHAW1xR0fq?=
 =?us-ascii?Q?Zdw+IPzyBuXx/WbfUAD00s0C2HWKgHxETkGMdaFO4K3Q/5kNM+AP3rQT1DFd?=
 =?us-ascii?Q?U6OrRe6JJrL+VyQzmgNJSjtIGxdqWbpcb+lV/D1/l+SceBY/IPfsCQlGRWGx?=
 =?us-ascii?Q?CIDVTkQUi4k8iWqHUdeXfNQsDinlnrH2s4aGbvlsFxjVWAkIHhELgxQP9kOf?=
 =?us-ascii?Q?LLMeINUh+rkPvE47GxQuTMBzwcyG+06YemkuNWoQ2c+ddZc2mO2tsld41BVJ?=
 =?us-ascii?Q?NaThmY0YqYpTdW6/oEvDCsGvIS29h2hw7kkDgMUYuLY9C18+kA0P0QqOhObg?=
 =?us-ascii?Q?IdcmEKOoXAi5FAPoDoreXmhY4B1sWEm2Vijwg7Io3HWP4EAZy0mn/C57xlCB?=
 =?us-ascii?Q?+p4pTCMsVJOS2sb1r6Sc+kNI4YCFd+1UKnnmIRY66YUBohFv29ryqL9g1fo/?=
 =?us-ascii?Q?bfy2gi91vtb7Tv3Sa9KD2O4Jy467QT2G9yKWMuQoYDKmbFj7TyRvP6sjSXVT?=
 =?us-ascii?Q?ZQL4XE10l6XnRhmE12VGc4khoSjdL3QwFb4lesqxVT5oDiJeqB3JhsQk5GW/?=
 =?us-ascii?Q?Qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	VXnipX5qfy4Ceal+vfd+WEUZWWz/qn58Q5HAh2JH6bqovuOzb2azhbbSSA+/oLtNfliGIv79k+ZZTp9wGbZDMEgxl1ys8ytK/AyIkz7EQTsrWBFj/Q6sXYTgoNXfqlDUlP6mrj109yMrOdM23n06mN4uinZwNgKyTEgIdG7CMvq150oEPMxQDLn362jhRLTC7i3rIYb+wyxV4Z+rvEOylF2jwPYBUAopXhSpOLTHsrrn6Numlv/zHrs1gws23gxVXQrDo42fVpZ/hYeWjVra2RscgB6HasfiMSpQoo0e8bM+ACSHTwh+lwKKk735NkD+qwGw1ILAkWUC84sqvdU1Y2uYkHuWBYZHkzkZFgx8oisD/LHpbjw3nR1P+KsX8UoinWBAI3ey968aMkyOQ9m9yekAP5vmsPCLXxEdZLjHgFjQ5taDNEura23PyTIfBJtRI70xZbtUI5LVn9PT4K3RFRIixN6wTymw6yGTJVEIgYjqLjellptEApbTArCwWxkBwp8mlxaBcYFVGjwZk+GOZ/lEgIXhbp3H1v3vyRxQ0FOV6NhO+6u+xS0PcqPHae5X7Nh3fkBNpUuoLLgg39K6bQuEMK58iKj0aHe/BRV+nZs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ceb28b6-6bf1-4401-7831-08dc89459db9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 12:05:27.2816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jx08NwM8QOifK2WwJ95iiqK0FUO0vjMNijdA9MoSiz3rieo+lMBMXhDgHeHPHazXoDwfZmhrKtMJo4M2JQOwxDsp2BCkb2/gN/3o2SsodLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6106
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406100092
X-Proofpoint-GUID: c8C9H2ILHCWuT8_v6O5ClMPekazmFGxc
X-Proofpoint-ORIG-GUID: c8C9H2ILHCWuT8_v6O5ClMPekazmFGxc


Christoph,

> Use the text to integer helper that has error handling and doesn't modify
> the input pointer.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
