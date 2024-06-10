Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CC2BA53;
	Mon, 10 Jun 2024 12:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718021124; cv=fail; b=C6+G2YWQxOhc6Kq+ygqngf9edZGqpvOQ3v5u6PnCot9UsyR6i5zJLVRgRlKccKbmlZ4p3FYmwRf5PzbKOe6qkBeCP49oyvUZ2Z34y3PbClL6XqZpSg7tIXMg6cATEmAOVAv0EVLZWF3ZISKw7p0MhkI4uZJ+P8uq3iZztBzopZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718021124; c=relaxed/simple;
	bh=zxg5TzEuUZLnvJKkMCVCVkJLzekdgXqLOu5zbWi9L7I=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=srvAWIyC0fBChl1mmIDesN9lerT+TBQQbWHgAP61kZ1IV5Df+VjYZPp8ErfuV8sTVa+Zt6AWp9WZ245v+evj5f7TU7rx2E6i2IPXNAW4YeRNa6zIQIKjFrhtjBJ9gMBWV6bPqEbdo8fMdZIcOWlmy9lvxBwwyXesLrrDfTYqZEM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WtaK+eqa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jCvJY82k; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WtaK+eqa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jCvJY82k"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4BOuj025181;
	Mon, 10 Jun 2024 12:05:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=sy/smGEWQMkydQ
	+SjW8yDT/G9SHeiMd+Md+FtJQbnqM=; b=WtaK+eqa93qHq3HuetqJNTDKURzfIy
	Dt3HpkTK4tWaBcAFcsA+PFRXxVV6eWWDWcbFLY3Q8NbDYlXOPrs3KCBwg7g9NYuM
	5Tsauxk/Z5kX75Eh7FOeVBoSQ/CmBjpqFYRONj2/NMHCvQVlrG/SrzboJfL6abka
	Kl+MQVO+ddxkUoTi81D2CBF5k+eifUetw7SjYhCoZD3VKPTsDjT7GEhHBH5vvFH1
	bmIVTRD16wQ9sT+6qKmU6LLH6xiAGZs+t9o5wz8cnMN3RmtCRaJQNyQJ023nyVCs
	4mwf8SDSNV+7KEXDXz4WF7jC0+cO5r7knlds4ZR9enmPFa88P/RRzDOQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh1gae83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 12:05:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45ABR8dm014361;
	Mon, 10 Jun 2024 12:05:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yncesdq83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 12:05:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U3S4rUVEB3t9SvS0nCfi5+ygcwIbpxs17DbM8cgflcAqHnyLWBk51M1UJCGeprIqQbpezuELMUloiu7MkP238btjAbF4bO4/3IjerHrd7CVCO+IbO7aiXI2EorHERxRsurNV3mklwsiOj+iYMbkc46DBG0GiixY2A+fScNUqPL6/jsuoGqMaLdRO0o/7OcMvHxpJ8rOV0NF5rWJXXBnZm3llUib7m7l5BQG/XdbPR/ynUJdoLyuOeQ5Zn/LwDMyAvGDc5xnZs5GhPVzpED4H3FpxY6Z+zttqYPEgc42OJMHJdxWGcLI8PYRpWjMmG5blLhbAXF5QaH7XinJcIcKhPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sy/smGEWQMkydQ+SjW8yDT/G9SHeiMd+Md+FtJQbnqM=;
 b=P5z0U+1L8BnVVnYVDaAmMJ3LmnUIcQpqhc5IrD5UNOZF10hQ9bVHytC4RO6CvHcuJv0uhSrCzFSKMrJ+n4XO2amjXTbSsuMye78IlH+PkYAxF5R67R20csGY411ACqjTIO8yMDRxp8wd7nMtXZORjTfm4FxO4F4F3XAPii3JO2I5eb1yjKGTq6h0/aW1t9dNrAdmcq/QGFYyiIiLuZ8JgVflvbu7w6Jmrf5Rj+S4iGNvaFMJ2Z55cdZtKy8rgcrAynPruACDTG3WrakDRpFj1g7bX9F1Yz+Vg4KXtQDRXUxKwoY8IppZoa+J1cvAnDcEQYjm8u7I3G6MR8fBYGPz+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sy/smGEWQMkydQ+SjW8yDT/G9SHeiMd+Md+FtJQbnqM=;
 b=jCvJY82kp1zsNg9jO2uGzEGvgsujQO4L2A3DKvUTlW/6vGKyvMEUZaZzcoq7wH+N/wVoFNVA1w+nrDBXzqOLiQHqR6PvGyp6U3qjrJLMAaEGL5yk5vYHo593c+yKYd4aGIQgGuaTj7rnYFd+jkEBooZ1iBe83qfIzdKTXfK/YvQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB6106.namprd10.prod.outlook.com (2603:10b6:510:1fa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 12:04:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 12:04:58 +0000
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
Subject: Re: [PATCH 08/11] block: don't require stable pages for non-PI
 metadata
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240607055912.3586772-9-hch@lst.de> (Christoph Hellwig's
	message of "Fri, 7 Jun 2024 07:59:02 +0200")
Organization: Oracle Corporation
Message-ID: <yq1msnt2ecd.fsf@ca-mkp.ca.oracle.com>
References: <20240607055912.3586772-1-hch@lst.de>
	<20240607055912.3586772-9-hch@lst.de>
Date: Mon, 10 Jun 2024 08:04:55 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0022.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB6106:EE_
X-MS-Office365-Filtering-Correlation-Id: a8195bd3-94d7-45cc-64d5-08dc89458c8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?eNimogq6Mq+5r+cU/nhpwAiI15N2yEXrTOR/sTz8Q10W/NtghJO0AZPG/BXk?=
 =?us-ascii?Q?FMd0JXA18orYneBI1lKtjLJMj7QEZ7MJp8aoUuX/H4xpvdb7Ii2f1sBuaGAf?=
 =?us-ascii?Q?GS/osRq/gwvtO1CZhN5M9SVRd5eeM55zAz2bc1YCUofXe1Gb/D70oi1ousfA?=
 =?us-ascii?Q?lldEWBZ4h5bHxANJrFStXrl46JbC54WVzahG7Qkbeztq9c0e2ZwcGqkJ5ADw?=
 =?us-ascii?Q?d46W6iJkKA+ktLRLIgGAdFfZZQ1mwBc+7Qp6xpizSwqD6rtOY2fG5OF1vxm2?=
 =?us-ascii?Q?pDeOO+YoeUwYthkGCqzmxnfPOqRKqwTIgEinYuky07usYqX/gxpNCe/kPAOl?=
 =?us-ascii?Q?itD1tAoCPJcaUkM83anuHF8DmClsgOLiCzrdy0mKuSgUeHYi+DPkpTkHALpz?=
 =?us-ascii?Q?tEZIBLGLOdWqH+JLVCTmb4dSZk4nTMGwNEL3vC7BtCoaP2XrL39mEQX8K3km?=
 =?us-ascii?Q?yAZdlF3zJby65YacT9nPx11ao4yOB5K5EbkxIa4sLNmsCgcWoxWQdORT84uM?=
 =?us-ascii?Q?PLe40kQKYVJ6X4tCZLPNvAvhhnHM68acSwefN0qZYOU62RPf320s3LDSV0zv?=
 =?us-ascii?Q?2r+tJ7zbGqV3A6Tik+8fcBUBq/wIJo7qSK+upuXnVsb3GJJ6HGF9vEnE8LZr?=
 =?us-ascii?Q?DcipAwbzWVSsmYNK9nBw0bbrnhA+gMpR5nRwjIr4EXxNyrs27rtAS6iTU2Bc?=
 =?us-ascii?Q?UBFr1u2WRV/BEF01Fqwvmwl1e9b3ezesBnAT1SQ2B8Evu2qaiA/3Kb/AyU2Z?=
 =?us-ascii?Q?+V+jWjy55yeg4xj+p3oZoqcAlL/lTw8yYmBNVbNHq370F/WSsKLkwi1IPmAV?=
 =?us-ascii?Q?4WGd7sOo4B2fIVoSKsZFok8VGwcyjEeu3nWUY4DiFUeg4WZ031g8ybfzUE8d?=
 =?us-ascii?Q?6Ms9DvwnC4iJexDhZvhbTKHV+DVzUVJ7iAPQar7gKmBOtlPf5xC+CilmZ1Nc?=
 =?us-ascii?Q?5L8jr+bhn/GSOH31Lvin9miH4kw6V52VALbrNW1EWxERTtdmE2OQ+vl5BdS/?=
 =?us-ascii?Q?PlS1ipNISRaVQFCA45PTyqo0yRd0ab7zyYdsiJJAnHew7m/CRq2BJjug83cP?=
 =?us-ascii?Q?n1HhK2Ha9mLUlpriCckbVKZOpTOlkM3nbm+DU0hdZ0677vIFHL7wvmTBqlB6?=
 =?us-ascii?Q?8Gg3yI1cxwmazfdFKSuspBNLgXEB5XFL27LuUhBKtgUO28m0MPJ6VuIlspFG?=
 =?us-ascii?Q?melnVHeh+GLaGQQOiiccGrEPRhiCSZJPpXMtNJD850hI0dTFSMl+4U8poAxx?=
 =?us-ascii?Q?aE9P7Ty5Kh6yNq5MC0vt8amU7AqpKEuBwz0NueEDstAGv7VsZVSmh4c9tOJB?=
 =?us-ascii?Q?iMpgf31jvAvoMayFI91CeacY?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?nhJlDlPsrqRa1c2TxNgQT8HjHMlpwwmrxcQHa+3XLOwJquYqi/afxLy6MEKM?=
 =?us-ascii?Q?4qwqA3jvbzCdKMrzos7JGjvLa//SQo9TzSbHblICf76raBCgb2QdOANNhA4Q?=
 =?us-ascii?Q?X4XIsWrxcR8/9EpQ5oyHPAzVWqembvUz4hKXmai/4XAJu2WzXM7qBIufjfHi?=
 =?us-ascii?Q?b0r5IfI9TgnoVVqOVdBs0c7gD5EiWmXBWyVzSHYdUxJm3VesYS4Ae1cDd+I5?=
 =?us-ascii?Q?iHPHUthVHdH767AlqFFGqEHjCPTSWi6oFUcNMN36R/eGER6zGyobiNw6d5fl?=
 =?us-ascii?Q?CvBnNaZxsr1dZJKY/dflxfnS6HIAw9AZucksN6NJJ1vfP47CImhFe4BkFeWu?=
 =?us-ascii?Q?MKZ/HRzGhPuQrF2HhPWYZAJc4Gv2b+1vkZkfKWG8JtdFvoia71oyBm6Sezli?=
 =?us-ascii?Q?ZIxRRXv5kQrPTcbD/DP+nVRQ8Tz7HBv2uGrmjENevuWjjxNO9DWge6vsSg1B?=
 =?us-ascii?Q?G1rQWtRGpbZd5YEZBZBPjfvgaQiXmi+IJZTvkbjVEIA29qv+S5f9D8RPm4aG?=
 =?us-ascii?Q?d9pr4mFIr091YKMK/EiXoT+Kuz0x2lMQug+ToDcf0YgdqaTvIZJL/3+72mHV?=
 =?us-ascii?Q?Y2tTuR9LXG1IORcQiwCrUaki+364oseKha4b+oUp2msIABR2K49gQV7++aA5?=
 =?us-ascii?Q?bxrTJ03M7WHmHOxbJ3N2ZOOYV5KVWZKjK9ftX7y+GVaaG9Wmh0rJZSZbC0JY?=
 =?us-ascii?Q?Z1hsI8G5dPoEEtvtiLvKdDD6G1TlKsyTlKI0OHwEvhiLX+YHSnQ/dRzHPrlk?=
 =?us-ascii?Q?tseC5/95VkqRuJU69h0JIUnlukpKOFc/LG8hFufzR9CHZ6GrpF/jVotti2bT?=
 =?us-ascii?Q?p0DSz+1+XNQmLw2AsU6IPAoTZSfrc7Uync4/ybGY42OUUc9YmpcMok6DeWuk?=
 =?us-ascii?Q?69/ob6n8pdz4p5UuMpg7+8NQ9CbSwx2/7T6/qEr/uRR5fS7ZbHAgEtgwRWtt?=
 =?us-ascii?Q?xfA9YRcIe2oqN5RQ3OYIrg/5XQk/vBfbq8uVOLIANCMKHwju7X515WnLhFOi?=
 =?us-ascii?Q?+TGmGSAPf9lzMEMyYwda4pxKPUDlbTguDJ1K+/WS8ieMfKRr3plP+vx3xhhz?=
 =?us-ascii?Q?bvctOQGabvkLY7+rC6hhiUEJeKfV3IwWV1MREPJFsAOTaaOIvDZLZDyfUktR?=
 =?us-ascii?Q?poydhRISf8KQzzQrgsxXxdz6FNr6kRaxRgKHV/NeIB4RnoYzUgwsYptFmDZB?=
 =?us-ascii?Q?v8cBNYI+b06Kl4Bl6NN5FedI4gR82sPTUcj2H0HAkHU/SP3mz5titvMkIJNt?=
 =?us-ascii?Q?t5+lCQ53kJzcH83O6gxNiJywfgVaWYb0pFP6rOGbUu4rE7CKqrm+Ylu7Rzol?=
 =?us-ascii?Q?gVr2clGwfp0Yz93FgKI/8aPoyNDnjtpKJFGuTMLkRozLN5/MuNbVrRO58e8J?=
 =?us-ascii?Q?o8PMojC6UZtehxHID+ER2h5TjZHXYvVv3huALO8szVHCi5DyCzeFAsZe+0JI?=
 =?us-ascii?Q?Y8cFQNI0jlNOPWhLLjZCBTOzl4ifwGP+92/brvKEW0A9rQamY787EvS2kemT?=
 =?us-ascii?Q?BcpH78YEHNvG/79pCJU9QunbQhVnEMh1klbh/ObAI0RmcoY6643Z232/n9sz?=
 =?us-ascii?Q?2aqvFgs/qbZG7n+tKICZSIayDK0u51fPnfxm8Z2wDftgyd2gwVUZ2h9ccMEj?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	n6Ek+1n86mE9DLMrHCoHXKbutjMI0veymP/Vk7yAthVSXzMVA5z7JSwgCdACrcYr/ha1IFN/FT4KfBv7ABhiwAX8+HeYTHh/1X76ehHNBX6K+YQETLnDNbVBGx0qFqcgX1XicSxh+jKBdUnHR58JdvG/BtEeOeYEtNKw2t3H1cMQsIEcGpuO8AKkSTewHuL+hXX4nd4jqqHeg8TpG0oNHrIWQS0QQYmH0b2G50bHqEsCJtYSobrPau02Hi4alMSeXY5nDU2NC+ksdKWPwQJsdO+ulSxSFg6g7QquVXAfuFgV3o+5RgLZhjWgkwHaLJ+278XFGQbOIWwO+Dvm/g8UfQn7VpakcBEP0Ffc8pVXQj/hooz/kcvH4Q5RF6jAnnKirjpo+7Wm830DsH4dvnOZ7YVnZ0U83GvJL1yk5NDynMuGviH0QM2gDZPuMeLmAUbioSRypRV1sLKb9ZWaOsa3FzlExxJtYbXJiqzA7dDQOMh/z+uAbVc3tK0polTYGMGbj8WQDd5Odbgi/D0uP2WTXC1+mYCkZPXEkyLQMlSYbndsZliGhjUGjWLpBFwDlXsdgFtNfpauvDYfE7I1EYLcbk0AhSo/e3iCk8gR8siBgIg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8195bd3-94d7-45cc-64d5-08dc89458c8f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 12:04:58.4693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x5B/2fILaElBbiUKQ/+ZmD5eHNhhvH7HRWp6B6PCRwyVBakyrdIAWI82vvGVOHSojRXBxukUBretWZa6F5IXC/I0PWtrTXRn5mxRiGcKNSY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6106
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406100092
X-Proofpoint-ORIG-GUID: St87rU6DIPFRtDwHrEnq0r8goS0uaZTi
X-Proofpoint-GUID: St87rU6DIPFRtDwHrEnq0r8goS0uaZTi


Christoph,

> Non-PI metadata doesn't contain checksums and thus doesn't require
> stable pages.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
