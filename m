Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418E21EA6E;
	Fri, 14 Jun 2024 02:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718330707; cv=fail; b=KbWfgF7/lVZJ9vHDM40mPL4AM67GPoHmapGGjdmB91HG23TLeX2rMu7kr+tD/xysMojQ5Ltq6Jeq8O39CRWBlVALgNGqHIxLxgjofTWVIME7S140hl1IMcbA35pJrDEn+0nilw6TFvKmd9ZeB6H3oB2WEBUciCmHw1RmKzkvBJA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718330707; c=relaxed/simple;
	bh=qyZpu61OW4dsYIHuZycdor8tzDpmch7hC3Wlu457V/g=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Wjka+9KXTE7esunkosYEeNja8UzdNUsU7YeiQUbai7JX9o5ZMWS5aUystDV7bMz6u/dWQd33v2/ZuQ+cyr4pwp7SX9Jkndlq/U1+ugCoOQudb/eHEayyTVqsAliebdsD1tyipNM0+vZJt+EwTIeV4j0/py0BcXgi7onG04eW9ds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bibRiqQy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=A9Y/vRG2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bibRiqQy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="A9Y/vRG2"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1fVMS006357;
	Fri, 14 Jun 2024 02:04:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=SdQO9Sl+xU4yuy
	46oglqvacjEJGAXKmrhZbQT1FlXHU=; b=bibRiqQyl2EyRT0eXTOvKOLEa8m7HS
	j5ghn5BzLdEpUtcVN98iVn1MGAeAsL4Xo7bu4EeN+26fCers9Q2LH+VaAkKfghlq
	neZ05DW6ceWSbio07UFZtKT7Y1MHxdkQWO+rZ61eHkY8YLmCwtwo3yC0oaOgO/V5
	EXfQ8gNaPTPpJzJ/xJQ5RXS+LE2fGDbzd4ZBE2xfkTqoVds0uCyVcw8iBQDU/d0e
	R26rI7MCv3SMuiMiXMhcafhxF7QhonhIFrg/tK91NWRYpzVgZ9sgF9cNFE8Gom4Y
	Y21UnZS1674GNuGJjjxNPz86hw7SQXS5sKsI8cJkYZWv2a/Xon99wsag==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymhf1jsp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 02:04:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45DNP3Q9014489;
	Fri, 14 Jun 2024 02:04:53 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yncexqwyp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 02:04:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTdvl2vUdXqIZZQBUc65HAUyizERWxBRQLJaNTp+qh88XgVelycHJVnmX04N8jglRB1gTXRB8ystBheTAryhU553zLBjnL2VCKoQLD2TUYcA2fXqYl0RCgFcSSu0fUGqThQRasb9MrmjDx69G9fkhhfqJ0eUH3NohNx9h/WwJTZ+HHRetzGALuEMAlt+SPd8d3TXkSUo35hcwF4asmeMO9SaYce9iAxo5bUHfucuX8NHw5Re1MpjiWzxR7pR5VLjSXfiapTvOK/+BKRDTEp6vxqnqDsPSbWn/Lefcq7uFr05l8mpyDmS+GOCtaJksGV6jHYHqZYQtT0vQ48hyts26w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SdQO9Sl+xU4yuy46oglqvacjEJGAXKmrhZbQT1FlXHU=;
 b=iTa26ExdxaaQy328drFgUp4J5Y4UbilS/6MMdPWvdx64S++pBi/bVN5D0Z0FWZRBZpZJFJK8FtlqfJXK/Gfkt+PCakdM2D3MGxudhN18yT5/zqwYjS5F1rR29Ag9dSJbLZhCJ71obcQ67XqT4L7i8t6IIiBls3duXvzX2txfHpaEIW+SaLchlx/2UyrqFka/FIKcnRxBltP9FVIyXDO03vX6aAtxfkdcBDFgsdty+OiWf9wxzjYGmp2JCR0WFJnb7SYkSeZTnfuKsIsAybtBhRVpSkozSQI2IUaUoMa1XBzY43X5BBM2GXeqNsEVLa/INMMs8Z2mnG6QccbcDX0Ukw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdQO9Sl+xU4yuy46oglqvacjEJGAXKmrhZbQT1FlXHU=;
 b=A9Y/vRG2Nw8g+icVwslzMULZpSxNudIQgucFshkiP4C5KosmZ15zgcs5LWgokKrOk5bBVeT13mzTByjhi9AOL+yIeZmRocHQljcaxweA4DGewifBlNZAeANnESe2sBOmokkdq90X/MTQF3lDdetfKxRr1iyNb0BB1TmzED2JnkY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB4607.namprd10.prod.outlook.com (2603:10b6:a03:2dc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Fri, 14 Jun
 2024 02:04:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 02:04:51 +0000
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
        linux-scsi@vger.kernel.org, Milan Broz
 <gmazyland@gmail.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/12] dm-integrity: use the nop integrity profile
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240613084839.1044015-5-hch@lst.de> (Christoph Hellwig's
	message of "Thu, 13 Jun 2024 10:48:14 +0200")
Organization: Oracle Corporation
Message-ID: <yq11q50qnyf.fsf@ca-mkp.ca.oracle.com>
References: <20240613084839.1044015-1-hch@lst.de>
	<20240613084839.1044015-5-hch@lst.de>
Date: Thu, 13 Jun 2024 22:04:48 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0045.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB4607:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f807ab6-05d3-401e-eeb4-08dc8c166026
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|366011|7416009|376009;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?2A2Nf+1rp85ldEvUFG7puoECuqXiPJfQdpBJLYc/ArrzJ1CKkvBwmNGRLs1Q?=
 =?us-ascii?Q?LL1b+3adOdz1/ChcAEzJhHxcXTzfVE8B0j5Rt+QhVhRslUVlTuLu4HBgZs9+?=
 =?us-ascii?Q?M49sskCVqxgmH/kEfoyibVSaJXd/jiISw7ZY1rceJlZT7e4Q4KzeDvUg3TtE?=
 =?us-ascii?Q?xcITkliXGVH7J4/kqrqrBnTG8wJ28/PW8wBSMhspWLTbWCHjyT10tKNY0JTh?=
 =?us-ascii?Q?KUC1Pi7bY3hvtuozsF8Vtc+i9/CTx80rtA9tXTz+biBxKxVkfywuDcoKNi/O?=
 =?us-ascii?Q?/bcDJfmlUgGk8fbmjFTzTN2bDvgewrCcCYzi5U4l1a9k55lvOJT9KPynSu0F?=
 =?us-ascii?Q?bxpjzVUpSYF8vyK79bne7WIDqB9KkYCg52axzBILw3WxRRrapbp6If0J1K+7?=
 =?us-ascii?Q?W15KUdA1oOQAALttulmE9bvI8qLhaLBYK1U8A3gN7tl3QAM/qCbphInZ7+zX?=
 =?us-ascii?Q?lmj/T1R64GMyJAuIE9WIlIgx10rokqv1IU5NjSMdIE/vYElJqSMlwdf2Swa8?=
 =?us-ascii?Q?BDajC1b8xPfe5te1raMD8VqMkRd+ofDH3heamzqsSXeWk4wXHx1erkefFuH6?=
 =?us-ascii?Q?lpqs4kxbT1W94i47jZ4jgCOHQpcyAv51Vq7215BHBr+5HxZrXnod+uf3O8hA?=
 =?us-ascii?Q?xyNvY4i8rX3DS8wrG518g7e9dhS3i47mkbnRuSK4zEqic82r4WmRvdOQqxDd?=
 =?us-ascii?Q?sxtKlGqeS7sdJe2jsG92hx32ptEJT0Zuinjjl7imw6onbfIOIQfxu0C98+18?=
 =?us-ascii?Q?6lYIp3Jb0S5qgx8WiHhTnw5sqRUirG+8p+K/tZ/gjYP0VvFqhtFXsuFwm23N?=
 =?us-ascii?Q?zlCDrEMK3tkqAdVjlsbDVVIGyNEF85pSUJa4Kkxt3AZxWhz0rs7J2Fd/RvrE?=
 =?us-ascii?Q?UBuQHGmztdbBCjdlZUOgB+ZxLiHMj9HPCxttnAjI/iXYGuAvI3973icbaztJ?=
 =?us-ascii?Q?Gw938MhIgqhlxbqdg3IT5A4PrH8cmThOEZUhb2szvgHQyGqmhbpMZiSx1+G6?=
 =?us-ascii?Q?3gRRLNQFHpTFYN7IGHp6QJky4mMbg2BEAY9EgfWkIrChsloV8eHxpmq7OwZD?=
 =?us-ascii?Q?iCa+Eqb3jorZJdclcjVtjSRbAwvB3OBj9z3PUPR2y/zZTh63AwsllP8spPTJ?=
 =?us-ascii?Q?udwdHYyD1gvBfm0yhrzg79UUhZlrv+sPt8VEfSbScMyHviD2ZobITAIXDMk2?=
 =?us-ascii?Q?kYDtzmtxnD+j1gFj76273lVVI6mJBLpMfEj1FJbpab06FBt5fR6vLK53Y8qA?=
 =?us-ascii?Q?/VyPNRoIy9uYX67uk5s/NwjvANamBEPARlfvYKIEFe1p5NviXLa7BuoK2VVg?=
 =?us-ascii?Q?IXX6gJeWe6IvsXguHpPUYk53?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(7416009)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?jrz4Dhf5kkfD6FsISgxoftBXvEIXM0dUSKnY3Ew4YHXYq/tyUQA1fLk8H53b?=
 =?us-ascii?Q?TJFIeFBXJq0gtRKFDeL1EXsms4k42T8Ikx0V19FaT3c/McGFT21oKjX9yMK4?=
 =?us-ascii?Q?MfKErA6453qy6GZT5G7nx18lejXzJGXyNCkJc91+5ulbJipPqjQ4LWpgSAUk?=
 =?us-ascii?Q?ovMMKrcnQP1qXeuUbyU0uWXqOUeEQ9AZ7ctdNQ8EJsUvDa9QAQtfJPdIB8Pe?=
 =?us-ascii?Q?MpfT8ZOUplFGb1v32Nu7yFUtiWe8SiPc8B3gBWhJWbZX0TIOR72cl1xgTTaP?=
 =?us-ascii?Q?Y7O6bxWQcCSAWUBBmOTsKP8kwqXZ9QTLM+1SBiKvGJkr36SpLxOFp/iBxA7F?=
 =?us-ascii?Q?IEXuqC/vFXBww9xR8U/mr16DbOY9yigcSsKW8vHXXAvjK+F915WRP3TvXXfL?=
 =?us-ascii?Q?OO11DOy2QxfiMMxy8kOm0P9CdSlzQ/3PJJaJjOsh+hNVXYbHb/AEpfY880Jz?=
 =?us-ascii?Q?W+uM8jykkC6O1Zf5Z7nvJHTqy5Rox60JGlizhjr1jZiesNtKAJ/tVIgD3D3l?=
 =?us-ascii?Q?3EEKdDzEhMjRKo2249ZP9DI1EtnIHL5ZiHB0dvWUseSbbBc5fZdhhIsfrD11?=
 =?us-ascii?Q?JgDNEdLo9MWBkLCiVjiIXH926h9/N/CwBoNIxCdx73iGf/41zwUfcknUeAcW?=
 =?us-ascii?Q?o+xGMMhlaK+v2xKopnpNKTtEHR8iSC+bLz/KSgw5rzF77qybh1IKtHXwLXsF?=
 =?us-ascii?Q?cXGO+gK9tzCyeKkJHNQ5d7dWO+TvSBYt8KttYLiflKHTZhpg9l0LhBQXb2NO?=
 =?us-ascii?Q?fNTRWnzvKbPGMTklPhHli0TOiN6u68vdDBKAwjBKaE3kUbDYprMpmGU/RzbM?=
 =?us-ascii?Q?6SCLf77t9KzXX0cz7WbC7f2GyeILngVL5a0mzz/VVSo/ULArF7Ffqguvvjri?=
 =?us-ascii?Q?E+4KZKq2rR/pRi0qXs5CsmBuBg8+/p2+S+KwRkYQ6T+XInh7N/m61bmv+goK?=
 =?us-ascii?Q?hBr9fBrBZBPLpKs+MvF/wEkxMnOUL3akRhv8QKDWKlZZa1qB8b4MgszEpRdf?=
 =?us-ascii?Q?URAivC0Rc0ljsAJp0VxOcVy2KAN2YNePROiyjHpSQVzFxcJRj+7BIaI7gQxn?=
 =?us-ascii?Q?Uw3H1LnXi0Jj/7RVProOwc29eVdFnOMvbVpkd/hOY3vhKvVxKM8zBH4oD0UN?=
 =?us-ascii?Q?U77t2yoeLVnL7XtGrTz7DLOTQTWoKyGbhVWSBTOJacwb5G1orL1kEc/F6BHN?=
 =?us-ascii?Q?UKi9x7FKS5LwRlryXWZFRd0WBjilJWS587kt9VuGzu8S1mbhmUgVBAjN84rg?=
 =?us-ascii?Q?lsw9VE94w8sqDVnrny+DXpDHtciIVuPhJZi5+u9OQXlLUjZGB6HJETaVcvlU?=
 =?us-ascii?Q?SeFWcsJtotNpMPc5QjqZg8j29gboH/F7uoBxRrDlUyNUytsgq0WhCPmDlMFZ?=
 =?us-ascii?Q?F3sHL7dskO9VdO+NjLPKtN6niegbSQxfBW0np81Ayfh+2DvgOTJW0qHm2HP5?=
 =?us-ascii?Q?ytkGtwI1YdOMf+f5fW5omqIqZeDigvzpY+T5w9AYrgrZaL7Ye5mDExyLG0RQ?=
 =?us-ascii?Q?BBNdrpUfgy+EPL2Zl1/Ma5vVFnG3I2PxHQs02zpwAa9dwbsMfjveeh3cLIHB?=
 =?us-ascii?Q?A1NwGDytN0ZddmAU1F0ryiW7znXL6ndritSIgtXKMdYwo/m11tuI9NvZS6Dc?=
 =?us-ascii?Q?mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	nm1JS0ypWRhfYYmXighv91AuNULpSbtFjty5FkUtKbaVZ7icA0lzaSIqI7KCBVSgAhipkgsS7U18Imu0ramBDyiwCNL49pzFw41VYdBI+fNpg58PFupNJGkD46mjuyAAKQMrEXHUcjOOjVNCXaHOQ5lm8HIJeiCWJdrid7sm5X1HkWyBZdgbAKN+j5651jErkwfYkqvWXRe7m5B5PEWti4ZvMgCu4rK+NSTew3WyruQ7ax+XRf9b3u6+rs4CEuEWrwBtXdSL2SgJfip2pHHB1O019+O2GcKIQyZcrAaYAZPiONaY8BE9xB8itbC7cVyZrDH+v1+8mDyvKl9DL+Mfb5C0BAbilDbDQvx4hIQwlM9IbJx0Fp8XKSKpbzX/dZmtHY6j9WiDkjEmiBvHxoX6F/ss3z+O9lE1QS6b1fdqbGr4Az4IDflnbNEbVCZosn4dyR+RM8CSabK3nAU/4Jdw2SHjmJpV/P8+u9wVDwTgHyLHTmVUkNrJ3TD3hekz+OdEZScXcBXIXeQWcyU/D6qDcneeaw535ocifcBvhkw9b4QL5hdZnX7M561/BnsQ3Q/j/WrQvz+dQOpPWAPNxXjCOIgaqLazzHkkUIXs+Hm1ZSs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f807ab6-05d3-401e-eeb4-08dc8c166026
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 02:04:51.0973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BwzJplOxUe3QsCZuAW64mcUp2Uhc8YZbCtF25zUdUYUYY7kzqvi3QqNtmZlfIn/FK+b8RTVWGCOaDL7GoINwlNE4uOOStZM3/ncP726/gGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4607
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140011
X-Proofpoint-ORIG-GUID: mJP1ZHcJzeEN08_Zi7OohEG9sPliUoMO
X-Proofpoint-GUID: mJP1ZHcJzeEN08_Zi7OohEG9sPliUoMO


Christoph,

> Use the block layer built-in nop profile instead of duplicating it.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
