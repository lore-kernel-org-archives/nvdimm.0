Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F062AE75;
	Fri, 14 Jun 2024 02:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718331533; cv=fail; b=VdK+4lP2lfKn8wTE/9J91pSO36YA9Fg7EOIa+Ob/y6bJu3hPOBSm+4LX07d0r/Q7iLJ3NO4ZiWI9APRjFLRL3RQMZl4SOP0+rFhFpNnYh0PdgewPMBjApvFAlHOnNm1lOi1tGULGzZb5HhHnoqPb88oZYTj8oMFv4V8Phdt3hkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718331533; c=relaxed/simple;
	bh=03j+LLHLrKcQ2rs8Bqs7ONuvugZBJUn1k4YE1AcgrF4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HEmIWfEmck+J6Xw6jxO5EJH3WFmBO0m/sIiPBSAFL2rUZQm6XUxCLMM6rUJNIP2B301E9HINWT2YQ8U2O6BsWWdHn/1M9Dst4w4YFZVCZZSP8ZFy7QMvZDqcWCtt79HP1aRlDcoi1jk9+priiVgno91W1rY+jvFsENeB7nguIHY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UASR/ODv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BP7gC9kl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UASR/ODv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BP7gC9kl"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1fRS7003155;
	Fri, 14 Jun 2024 02:18:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=Y2Bi6Ornf1M4AZ
	EYCfeu4F/bR0++UlYoLiFuYAuDit4=; b=UASR/ODv+OK/NZcVLur1yHMLYLYMy4
	p2VyM3lCcQm0lzhWhDKL526bPsZxiNxQOu9WrWLVKV+cqKoGmz2ZCSjI0+fdkbBB
	tk7dkz7Y58zTe4eRUbmVfJuQH2iRWBPAODufshJEZ4VSoJNeRWA1HLO+6S/Lf6Xu
	bm0vc87pOpi97i7xE6EbtHu5gpZpzJrbKrIfV7LSu2YFY5O1xc1cXvd6BEQBgjud
	y/+i9WA4hrC4DmzmSLAAemLDEooMkuW5kZN7Mn1oigFM1zHqS10pSufYhXywMLbu
	zdW3/3xX4YELRYZU+ffRMJzBFN4DMHSvUNLh5+TffLCXyCNjDKasun+A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymhajatya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 02:18:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45E20Zio027145;
	Fri, 14 Jun 2024 02:18:38 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncdx3hr4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 02:18:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjysD5fD2ZF4KmSmIFY3Kffb3Bwhnghjdi7yMQJX7T3HAtdcIJXN2s+u2SuSkBS+4BhlbesJTkujymxFtlbKowQtSY1Nu1PhOj/CXz//w4zphf9g6F6gNBzff5jf7PZznUq5K7q8flqB4BmViiBPjGetv9oY4lvleG0Q3anMhdcPw7RGmWNNnIMQHc1V6iR9HVDYmTaI4gju7YW7gq3QuXfgC0mo0ISosupDWhjRwqstH7fwhtdomjybRKs5fUgwc/KpjNEa/wJPTOD3aqTJibyN2jxq8MlNw9n9dyg8im72k3cUwU5tALD1o2mqADm6qlgs0wR9M6UMU63V+z0y2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y2Bi6Ornf1M4AZEYCfeu4F/bR0++UlYoLiFuYAuDit4=;
 b=R51xpnigXTZs1MQMOPZRzVDg3S3SJcw1q2vICphKy+EJydInDT4eVnHAoJOzPImahjH5/eFTzFgycpVpDZgkElIFCiUiFIaWiO5JnNsKhO1KAoqDuQcZ83lVlq0qn2shgCsan2gna2r8wX79J8dZNhgNMCh5rUQciCsXNEU06H58I3diFkZpfreouxwc2fh+G3x3vf5bUqJUnX8ggug1tMWhi1ogaxk0/JV0Ci1550cVxBOwcquEL4XpDcZFu5PQ17NLedUoAXTs0M4Gxxjz030xkX2uyuRWLPl2lFT53o1DxjjXoND9EzgwGPUAWJoPtogW7BR4kWQoS1bNAWcIIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2Bi6Ornf1M4AZEYCfeu4F/bR0++UlYoLiFuYAuDit4=;
 b=BP7gC9kl2ypWIbg8G9cgfOG0Sgyx4ROzmEC0DpDbeeDoPnrG8x6MAT4PdgEEzgNxrPMUKsv8F+YqCybha9HymrgkrQP/6r/sRRSsmQl6rdRkZNMl2bUzr6NOBYj0OYpEHy2tZtbWruQp8V08nEBdhqc5uD0tASqfrOiPMwZUH/E=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB4896.namprd10.prod.outlook.com (2603:10b6:5:3a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25; Fri, 14 Jun
 2024 02:18:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 02:18:30 +0000
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
Subject: Re: [PATCH 12/12] block: move integrity information into queue_limits
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240613084839.1044015-13-hch@lst.de> (Christoph Hellwig's
	message of "Thu, 13 Jun 2024 10:48:22 +0200")
Organization: Oracle Corporation
Message-ID: <yq1jzisp8ra.fsf@ca-mkp.ca.oracle.com>
References: <20240613084839.1044015-1-hch@lst.de>
	<20240613084839.1044015-13-hch@lst.de>
Date: Thu, 13 Jun 2024 22:18:28 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0017.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB4896:EE_
X-MS-Office365-Filtering-Correlation-Id: f85e3cb9-6175-4547-429f-08dc8c18489b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|7416009|366011|376009;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?mbTgNrvoLz4JlGAPUAnc2DI/OpiUlMgNO60SjuHu6UiopT+uz2vD+lBMKhpZ?=
 =?us-ascii?Q?39M1Aq/oRwTzORnJdtC/Puhb7YTcP/T6E2qSktHnxOtFjApoVprjEQA3/Avq?=
 =?us-ascii?Q?MsS1NKUSNYxfJJxNLl1mwtUsNBZuF+FloFICaZ4QWb0CymkKoH2N6cCFS/Im?=
 =?us-ascii?Q?QA8dLqGBkqHBm68236A/yyGGxrKIvvfk7pVqlsG0POiuhb2r1GKbN8/7vWg7?=
 =?us-ascii?Q?vwySXf8ZDdg0FLTFd07YGOoocqldm2Wngu56t6i7Bl3p8lf6IO2jMWilSzfo?=
 =?us-ascii?Q?VwJeHx4sU1KxBV9vYz9ORndIIHqc2mwTo9dU6LNgij5bL9kMZYx3l0MxUUSK?=
 =?us-ascii?Q?Lum4WAHAJxgrrf8rVVqa2IkevlmP+o64tRiIK9LyGdsqTts4znNJbRpH0YeY?=
 =?us-ascii?Q?FRGSjANK5AAglFOdlkf48JO7gXV4k+/f5/RYAO6uRPsBWiXn5iWwqorZChhG?=
 =?us-ascii?Q?vmw+Hky0KIx02jKznnQ6sJ5LGKRg2heZFUjal5qRnW94E+sCpCcSY7QSZLMX?=
 =?us-ascii?Q?34PlamsTJuaS3n/c1ZjIEcp+GNHn5Sl11e1+kbMqd0dh75UFT7idxUERVl/K?=
 =?us-ascii?Q?BWIKQSgCfp3QKHFeSi82rluigwnXI0/ujZDe8p3Pn/QVUwOdDxqOMtKbe9Ox?=
 =?us-ascii?Q?RFlM7wCH2Dpb+xhb3eHliMH1MG+KrYpujwxcwcq++wJxnqDzgglNOirzRLNJ?=
 =?us-ascii?Q?d0Eg2/xu5MTYVMahSwavGjl+xkBxkZyQOjnOiRZbviNCZcbCW4qWw3RHDNa6?=
 =?us-ascii?Q?62uUbUrI+Ge3BOHOK5veVzxIr4t3xHrR/6qMamhVCmfCsZQMO4+ZPUchoXNA?=
 =?us-ascii?Q?UgDLUYWzJU/qePyP71jRaUsWqOsJtOvTfg3mCZxtnt4TwBpCwqIKrDV2ayB/?=
 =?us-ascii?Q?qrXUANqXOS6T7mQzJoSejq6cqt3Qe/uNhjn/pEXxwi3mTAwIChDE5Eu4acR1?=
 =?us-ascii?Q?eAivx4oMqHExat8ose4szBGXhUSHHpg8J3uraFF0oNl80Dv1jEfTzRyRdNCu?=
 =?us-ascii?Q?llB9F67f1QzJH6zACY5c2xvMj777cviltZET10oPjb5P+Wcu8X+ABgLHa6I7?=
 =?us-ascii?Q?n6w5TnSja/t+J4OrE21sG1vWwM7nhOxBA2dOBimC9TG1RvB1g4Nvd5epWyMk?=
 =?us-ascii?Q?IGDyBKnSDcnxsrlAwZutnnhJ0To6jAnb5WqzbXzb43eYmfxqhr0FI62sj1vi?=
 =?us-ascii?Q?7UGoc+bPoiwR0IJy7grF+lf0GWkKsVBmUw4FQRshFHMjJKko6CZ4v97lLKUL?=
 =?us-ascii?Q?RA/whiJGmzmB03rCuEcz2K/d8yiAJMJYp1ufcRA6hhUM0dJgn2Y1Z5UT2eE+?=
 =?us-ascii?Q?lJyudubX8QPIYlK03JVKfvK8?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(7416009)(366011)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?4F/1P2l25RVD9zFbGs+7bDxwIn8Hhi7esI4kbDLqpnOyxcfm+Kei5CETdU9j?=
 =?us-ascii?Q?HbwdWrkMb+aw+9G1jDOOShWcHr5pMxraxsN9yKb5tvRVFLUu3lcuO92/zFNJ?=
 =?us-ascii?Q?t7xjR6XMZecDjsgI1DDv38zPFLjqaMRIQkBxQD0ta9/XWn/jOMEh9i08KMWH?=
 =?us-ascii?Q?BbUtMRens0SIFY1doT38GwmmnkRFNWo1sJGA14SVFvfgraNkFUa/q5ujP+H6?=
 =?us-ascii?Q?kepvdoeaakz7QnPOC8oZpGisazeVZs4WBw+eNxfGFb9a4/txoDzaYK+/AUng?=
 =?us-ascii?Q?LUnEZ8btD83Rpnca8BW+3NRiQbDUNRDaJndrZPPyursL7woMfeRiHbxOo8rT?=
 =?us-ascii?Q?LAo8XKtzuP4n88WK9FTvhuJBJ/iERjBzS8kGqvcaP+XZAdhvnFiOpZjuMrhs?=
 =?us-ascii?Q?VHl6hinxhg1a0OpvzGph93yVehtUGv31O5CmOIK6Mn+vetyGiqOEhjEBOPbg?=
 =?us-ascii?Q?b6T3llDXMIaaP+sw91exridneLFZit5HaX3g/d7JBXZCXRGhGqC8146xCMw8?=
 =?us-ascii?Q?NMTzWstrKOUSdsz2wcCbVf/QmpZtiktrSRRPbTR0CStoj+BpIUosg+CijgKC?=
 =?us-ascii?Q?D+87A3jwX+eLU4jGqPZvt5eXKf/Qir53NQWIt74BGzeWtv1eH1x8Nbv1+27/?=
 =?us-ascii?Q?OXCMF+NwVQqXCi8PEqxpZ/9tQXP1KGRyeRIICAB+U9zTvC6yP58PYErZPxIX?=
 =?us-ascii?Q?fXX7QWkh2aSNrJKonqSQ7uZlzF6OdbIYkkGDKtbbZ2BmHl+q/PzD0XUIvCQF?=
 =?us-ascii?Q?TU6Gp3chxhtOl7Ods1HiQ6pxK+fWA4V3GswErVGaBqbOadFGlzl2Ubgh/kiI?=
 =?us-ascii?Q?QrDmcuIknF6AcuUXv0mVg7fE+lsbgHw+BU10Yr/0f8dGy4KEFICRIqOXEpIW?=
 =?us-ascii?Q?OuhPbbK6dYR17W//Qu++t4T0jDQSjf4toM/e/Cwk1kZ0JUm5yVVYRGZHqHMp?=
 =?us-ascii?Q?Ck1kdqwrxXdp4FuPQbs79YEDQh1nr2HzmsbLSLdAWJooNygm8pfm46IyjD4C?=
 =?us-ascii?Q?vZxdKF0a5rKbufFEC8SVLRHD9IutSqubKtuUxnFCOqwNLB8KjP7gA8Sa9VXI?=
 =?us-ascii?Q?kRo1p+HPd1gARzIXqp7nlZE6hDUdhClH6s/e2cNEFVuM/qigdh89s5AaeMY5?=
 =?us-ascii?Q?GQDyVP9NhSRIHNOCvAx6xY2uXOpr9TyeqkRhrmI/JK4tzKG2uKD5O5PBDQ1n?=
 =?us-ascii?Q?xjhP6kmT5hpdZ/wrsad9fg0mMJ7JIcQZMWfU7XLY+YH80c+l7lpKCrh0Au6o?=
 =?us-ascii?Q?Dst99FdvMWA0Ijjjwoy451em6GRmU2yFRbJyGYkjFjg7QOiWarLNn/of3WDY?=
 =?us-ascii?Q?nE1Zt+DNs+Vpo1P+23lvc2d7o8mQ8cxmXufHtFV66SDe6rSvVZtFFkQtUUeR?=
 =?us-ascii?Q?+wTxOu4UQAoAD96+6WYIbKdkoGX/T1PQ/KIchQ1cEq6UqlkOsGcNooLQ+iMl?=
 =?us-ascii?Q?iE85+F923BMQoIbjfLP62nuqTSwDIF3dbCffqGI3GzYN2hYRPDvLLT1OD/LL?=
 =?us-ascii?Q?sf927gUNtkfwrSsWBkpQoDO90JHUdSphgU5w6GpMWtYjvYzRZtsxQgXFEIE8?=
 =?us-ascii?Q?s0YduWOd0BqzeNqBMdw/mrM3iK6ncTdh31vtoK7CJPCTUOst4gZC2sAAEC8K?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	vde3Uuj8F5vkEf0tN7SQGOtKbLm+KHGzxHplxNwf25cbmjS4+UGgSj74pHjsPm0a5VsPceTTwY3SD0gvJurl+z+XqeDo8BzrZgrW34kt47dJxhomBgzrDiSjfgd0t2Jl+PQ1nB60ZJ1np9eHESe1D88FZdtPWZS+kj0aK6W1f6ddk+HrxRB0PQ+sFQwa+JBD5E+2i7P8c2xxW1993n37ZBDeVG4lqVEOfICy6G3U8xgIeCBAKCX19lIF2B5UJ43R1ZquFPsF3sDELD32LSUbatHvBk7nQ0NzGmLvmGsysaSLh89oGNHY/F38WDjgvTOrk43EgDfE/qChYUbL6Gpbtrb3p2FH2tU8gTFrglK25FvQ+hppysVus/XPmNX2db963ke7xzKa46BCYEjX1GWVOl3+kzwhDPj6BDHAZ/em5+2VYIj39yIczCFlJh2mqnsCQUEvkUwwvEOaiUdpUIzDSIt/Hu631OeonDZPY/3TSTQeVcxMUbtF9vP/qG4mInHvNNINsdFhd+uyp7NwXAcY9rdnAglwXFFADpiBHoo3ev8BI7aVzkZl70rHyKda05JHNm6WXvLWTvxhf/ANfzJI3xdk1BLtqU0NgHyI2sm+XjE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f85e3cb9-6175-4547-429f-08dc8c18489b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 02:18:30.7034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: poPDk7um4K4SuXkE/oNgVCUt7u14ZkjzQ0M1D9BIAsqu2d4KMqUvX8r626muT0n2dC5rftS4yPL2wyos6ERzmVF+KrPCoFVrs+QQGehsCtE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4896
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140013
X-Proofpoint-GUID: egk-vAqAPtDrxk6Ks7WswEgN_N3igUc5
X-Proofpoint-ORIG-GUID: egk-vAqAPtDrxk6Ks7WswEgN_N3igUc5


Christoph,

> Move the integrity information into the queue limits so that it can be
> set atomically with other queue limits, and that the sysfs changes to
> the read_verify and write_generate flags are properly synchronized.
> This also allows to provide a more useful helper to stack the
> integrity fields, although it still is separate from the main stacking
> function as not all stackable devices want to inherit the integrity
> settings. Even with that it greatly simplifies the code in md and dm.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
