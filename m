Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F017D7BB13;
	Mon, 10 Jun 2024 12:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718022016; cv=fail; b=J1Ub/hItomUBPwBBpwHETk+Pj2vAXdvmRfG1WNdKbvq0PFONH8WpP4ZaT1sFsm/ej8s0ALS5YbgOvuTv1QR8iV9u8zijpy6aUC7OE4iMiMMEpo6evFDCzDn5vEfivO6yJIQyDjWKEpt3fokKjzGdFxvYID/lC83RD1LUNvfHUBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718022016; c=relaxed/simple;
	bh=sR4ElA7ZpBvnurunt7vATtL9PJmf3BsRMAPi62xySvI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=pdtcBxj02yvzB4/HLzxI77rdX1g+y9XHrjsfA3CVLDcDvY6mrSURIvJM9qouwMpgghI3+ArtH17jpouC4aeYbzcZEWsegMB7Pv5pXNbswIOL2b0jXUHLCa7gjo+CSJudWzSGalyvzCo7LPjcHOjafQby9VMvMyXKDowatSdI+BQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dXB1KhBt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pMp94T3g; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dXB1KhBt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pMp94T3g"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4BUsY011442;
	Mon, 10 Jun 2024 12:19:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=3IKAKk5h4APIDz
	DWyrjtPcmm2edAbeibWhNbshzj2gk=; b=dXB1KhBtfBlNwUF7yJaPSjUxhQ5TDp
	4M9tm8yNHXemeOEwZFj0n0+WZYZ06YcwwNNmZMl5GnJDI+OxRT50rJZY9W4jayq5
	WcRjDVx3uUw10GIadkroBjnKWT0EPHZ4Nea6HOmxepDLJKKRuW39BvxUmdeGivBZ
	6KGN8u0OCZx9MdjxR+oBNdGu03m31B0pUhTTRrqTSNORZMuS65T8xY3Q7xewZk0i
	h+IkScaEvziL5jPeje+q7Pqwp8AlxBd28+qQt7KwzoLQqmtUyG/HKKO89nXEFHoe
	OYGvmldouhmQYbLajfinHPnrkWyK5puDyE/sdonN2aRvTv4YEXFBSUHA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh3p2dq8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 12:19:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45ABvZd1027079;
	Mon, 10 Jun 2024 12:19:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncdrpr3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 12:19:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTmg5UJ2uUHcSwfj5IEACFVqRBCYE6HPgPB6Pl0f/2dkKDoan4w3lEUQSc5nF7Bsf8sWylYKHwsQdpmsxnaQLzScDLgLsbv+yUo75I1/WrZTeFeJqJqdvKX7FbZu5THw8NMGFLq/zWNvTYY5nGxEoLJWWR+FsEju24eZVLX9ZdVa+IoXtfh1InZnX5GEoFguVgRUZADl+6Wa/UFcDleS9qv2sL5WVXV+YZM/gT1CEOFSjFWvciYYaKZcs+4iWEkUnubDjpCPCL+GJqoxFh8JOvdsrQqL9NCnAeHcnYLKduFG1tgKzIEEmehX5Wlh+/WujoQXWDF+//F/UxBWYBAq1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3IKAKk5h4APIDzDWyrjtPcmm2edAbeibWhNbshzj2gk=;
 b=aq3iDL3Bp29148FVFWQIxAM2kx5nv+LcdKMAr27aTvIzjf7ohypM1v2NlJ97HwG2BBGx6Va1cIvLkANRFoTHVSH+MH7zVg+pV9145Qwsg+kHEepl8AV/mUv9SizX2PVxn7I6O9PhBu7Yh5P5rjLsSOILM3443zxwE4mtxdHIJ+dFsbTEDIBn4u5F4Jy1m2l7+gQEvgU04m8PB3Bep55XXze8mw8lR8ExBOU8n6Ob7CC4TPr3bBdgsEaneGKUe/0zGIkxEN4QoWnRLSk4bVdQjKiAz/UquzIBLzSC12a3/0HPK3l5lYJvTs7xJ8bPDZHehn1C2YFWIMDpG7593MCnkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3IKAKk5h4APIDzDWyrjtPcmm2edAbeibWhNbshzj2gk=;
 b=pMp94T3g5dPqwjVcNWoPUl0S2biYGkWHumS1oB+NT1MAwF57pftH6AZcBKKbxqHuR9ewciiPT6AwRAJu1hhvxo03TCuyg7uRz+nQLZkzaGJAxGHkjmzLZGHsCXFdclk38jywFmJMsV36I+XTHpEoEO4qjskeM9miFa6MSkgo5gY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB7362.namprd10.prod.outlook.com (2603:10b6:8:f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 12:19:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 12:19:36 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe
 <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka
 <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
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
In-Reply-To: <20240610115732.GA19790@lst.de> (Christoph Hellwig's message of
	"Mon, 10 Jun 2024 13:57:32 +0200")
Organization: Oracle Corporation
Message-ID: <yq1bk492dv3.fsf@ca-mkp.ca.oracle.com>
References: <20240607055912.3586772-1-hch@lst.de>
	<20240607055912.3586772-4-hch@lst.de>
	<yq1frtl3tmw.fsf@ca-mkp.ca.oracle.com> <20240610115732.GA19790@lst.de>
Date: Mon, 10 Jun 2024 08:19:33 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:a03:74::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB7362:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c38dfa1-0a4a-4bf5-ffe1-08dc894797dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?XZZveQ04aWMYPwjWLMnzTZCko+P6lrDLaKm5y9IRpeIpNRl0uRO6LY+dYxD1?=
 =?us-ascii?Q?K4NV8XuU0gxY3YhqZaubsTqpc3+rFJk9rSYNUFAU1g/JE1vWp2ODeCAcsgAO?=
 =?us-ascii?Q?ftHw6u2KsWSDAFCcagGDu4Jg7EVx5RDaqn2d0jZdADEvGZ4lC7E0PAbVXOr4?=
 =?us-ascii?Q?GQkDqKMVdjUkijJ5n/EIVvuE8sCi4gmBM8/VlvDROSstuVH2ASI2lsiP4bZ+?=
 =?us-ascii?Q?SrAoyp5Dx0s9OTrPsD89wcJsA8R0JsHqGRCnibPW4BuMi+NSk4d5N2pFhrp1?=
 =?us-ascii?Q?lW0twC2fw/nb+TrtedQFoS5ANL4ViLDPbgmXSJPyS3Z+ZoOfKP8UwrKdJfai?=
 =?us-ascii?Q?mPrGYfYD37tnqVDcjzuQJP2wo2Y0yJd+LkPuRFrZiEabza2w/9E41JNkKEBv?=
 =?us-ascii?Q?hdGPQe/ws8I5LALkghQ+NU5i++A4yx7MeafYH1JNb7y3xzK5cXGfYn50TJc6?=
 =?us-ascii?Q?phCX85MOz+auI1fqlB4BgdM7dJEb+Y4EtPWjrF5ybG2wzXDNCAgxJpq6W6le?=
 =?us-ascii?Q?Sql8QtDEWbkwhSJUqDVVpB6LSTylE8RhAzlpPwgVQ4TjdV6vDg4bauTd16YV?=
 =?us-ascii?Q?ewi4MNMhuQMSJfMv+10/lgKumwNYswvUJLPEiJ/nnTXqxZo0k6itY2XM4nXF?=
 =?us-ascii?Q?8h/AqXuMcjw/hj2owJgNlAZ04KVBs2Vw8mfVn7Pf4IomBei1YZ6YMnSAfI+K?=
 =?us-ascii?Q?3t0/Ws+w5HYr946qPowJruuHGB69lgWZwkd/ZrdliwtSHr5El8sJJZE/AsyS?=
 =?us-ascii?Q?CBoHnok+10ao0ojGgG/Nw+3PmkFpGXueWTLqJhJn9wqjHRcU4FvLj4wlVo7J?=
 =?us-ascii?Q?uI4AEDJ24pSv4XiA449FeE0Uc8smoXKar90v8KdIn7gFF8HLnz027hYFE6uD?=
 =?us-ascii?Q?CUy8UU9nSwwCwKnbPNqahTLsQ2wqk7p/6r9SuuLb7nC0e2hns73Hj5qGF74M?=
 =?us-ascii?Q?BmwdkyChV+j0CY9lIlm3UxMpDaUV8yXrCjT8uwtuKTS8Y4saCzGOW1ult5br?=
 =?us-ascii?Q?g7nwF1qdsd7mmNDW3PPUkT9ot0VXsPuDfD0csF4eVeCCQamB7QiOP78Sr/4F?=
 =?us-ascii?Q?ZopSt1Cwv90i3jcZEN54qKI0vBmviPsIMzqCFNxelKmFYw5pE54z3xC+/bto?=
 =?us-ascii?Q?St8icXnb2hpe4qrAyiiO9ouDa9rPkwxXYdbF6cciXdOtGDgmVn0HNGLRwheo?=
 =?us-ascii?Q?MlNaxkTgBLU5OfQkMaXdsz3bRwlA1HnqnnFkRObHmbnpqoyJ12Ix7iHIPuy1?=
 =?us-ascii?Q?YVFL66/u9rzx/bwsaTLP2cr5kkzHmyJWAu7hCkWNgogUrc8+VfPe5nkV4kGN?=
 =?us-ascii?Q?H3zww3H/EvsWYi7bLTbaueYX?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?v+FPtNSkPuIS9rhHvhJbzR/tnxH6qPp8eZwnxd3gjKyM8eGDp3KWkiBVDFOJ?=
 =?us-ascii?Q?KjcSF4PXBLa1ZmaOy8k7chCbWJm0SsgrKUP7bG5amF0DZWJQyDpvaQNLJk15?=
 =?us-ascii?Q?ASAt8ge7a+Uwu0u+aKqPOSntCXIQsuWk4NNhF4+Y2KzhoEVfOA7bUSbfwMuJ?=
 =?us-ascii?Q?ub20FTNbPLCmcStHkgZ4SMFranuRa8fNdv4WwkHepYFAve+sa47k0GkgQP7I?=
 =?us-ascii?Q?ZOQxOsTQsVQtYnk3Ao54/SNh8RZaTtKkEVN9q3IJDkGZvMysOiweI+iXwJOE?=
 =?us-ascii?Q?v9yAZ2cLhZsgjekqvg4y55dA8oIR9L6fS1j2ysZmtJBIZyb+144Q7pf/1uYJ?=
 =?us-ascii?Q?ySbmzok1gclCyHZfFRelmx2Y5dO69eFrlqZc759C7gtnxwVFAlJI/vfzNTVU?=
 =?us-ascii?Q?rdAgLtvl9rUWkdhlEcMDTbpnCdPvkNjtBJ/C8UcwUwqlv5l56t2ZTUAJm1ha?=
 =?us-ascii?Q?hc8H4llfjSaxQuc56xK6zj63Df9E0HKmEKPk/A0rxFyDQ0iG1oyYwlD/GidI?=
 =?us-ascii?Q?kCwZHPIfw81BNey1o7rAFdn6nijFDq+noeMgmdy215i6zhu6tmfEJUJSR8ZQ?=
 =?us-ascii?Q?qg3NUcEuZZr8hBeaeXknVD6Fv2Dwsm+btqvLw660keKkP29v+lF6ne2xK/gF?=
 =?us-ascii?Q?UknkaZ5D3uvIw7tZa4rT6poSHC22ipoai5vQX5c7QaRMq/vfHr4dQuwdI+54?=
 =?us-ascii?Q?gxvsqF8C29jQrOnRQt0WLXSWCPAIO/6VqojnY0Zsb1X/h3EAC7aN/Xyxj8os?=
 =?us-ascii?Q?zCuP5BwdJAmDIqMbo2Sn4WvBWnefDtIH5fw/Uj3qzp/YZvmppwP+rOZyNXUB?=
 =?us-ascii?Q?sSR3P8fVGoAA60T3DYxaKSQ0AZoDLKIMQjTNNPijGY6PQFb+naM57U2RN7/b?=
 =?us-ascii?Q?nHv3cj+4LfLMw5S2w+QpGHXgASUwtZcXvIHdZoNrUuyS2LyV30TZRzuNfRzM?=
 =?us-ascii?Q?VUY39V2NTWl+9XAdwwd1TmoWiyDv/vvJzht133On7O0x/2ehRfqNOGUFu60J?=
 =?us-ascii?Q?B6znwc85QKjrx0DBNUMi8KPYenlUk/wrj97eTCOKmer3ng+Ab1LumKtrAJUQ?=
 =?us-ascii?Q?+2rknaZ+mdB3tpBbfKWSeMDBFLO9UquNTSWoYkyazXuWYzgzfHuiw0IUzznl?=
 =?us-ascii?Q?A6A8VOaW1Iux2PexDy3OEssVmA9vKDEWF3knaDGJ8Ppo51IdGrzroo45k5mW?=
 =?us-ascii?Q?khuZk9QMpVr79CSs6pK8KnojGi6svclnwoOuJnQJMTOqx3gtrswxfQc525dz?=
 =?us-ascii?Q?CgKcdiJvFM0umNC3hx2sk1A3aK7iCVASWriFj1BOR9ofCmn36+AvWhlYTuSj?=
 =?us-ascii?Q?dXFCRPEcMrsnOdV4fnmWbpsvwT0m1Oz9JDPTXz+Lg6dShlXJsuB4i9wfnUrV?=
 =?us-ascii?Q?aM4c2fqSUxq/JILLK3C0+v7etPNvRonY/tejmir7JDTuSrdqT/zLF5JHsQYf?=
 =?us-ascii?Q?vAEsVIp/sAXXek8RFy3CDxnegPaelKktATkJkgMfNDiHnSe8VaiwS5MDGIUs?=
 =?us-ascii?Q?axzT7ZyxOAvLxGO1APqQnCMbnDwviHVRU8A5Ge387Fpqz5YwOot+CU4/ZIPD?=
 =?us-ascii?Q?aWp42Js5KnI+eN8H73vcpC0JpI7gf/s9Lt8NcPEPPqsP9SxrZ2CKR3JuQ2fr?=
 =?us-ascii?Q?Kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	zfgnGEo+Pj3LxSuz2qHXcHCTYIdPF9nGr/Pks1v/ZTajNXTpGbUzrF1bZgzxh70BYujim6kDr3NAuWwBDcvRnq94sG70BL1u8H7SsfiR+9sm0iVdofXLJJkG+IbkHB3fcWglceLYsvUCnnn7x42QAtwmsZ8iFB4A011NNhDQJxfu5Hba39gTlUvG2LmXh7D2Ox0k0UXeb3VqAWFjEAkkNypFZCLXMW4I6pWHwOTedLTJv9rJOzetSB3x42XOB7pSWBJ4KyZI+5fxFRB05So3fXxEzUzQmjc8olkkUxal/m2lRQz4oDsW+hD6SiYqaFlu8FnAxcUKnLzObHKExJ07nnHk+qXdniYkhvr8PL4sooLsVwJzyL0ygdlWJz72O7ZA+1UCCJW+WlPDSwHjFXV8+zVG+iK684xwODZP9TfO2eYn+8uIFjjT/i5NnTR6cbgQb6ofkvMjOj5omXZcdN1bqcrT6e2TVXyE8D3lx8XwY5iwB2Anz3hjIzt8IJwwClZHHbYYmamlsGo5WglOK17hUYqJaGjgVpI7KBOrDXsZCQ3xeR/9QLf+XK1PJ2Z1yaEIef/BuvJQThIoReOoM0BER3R3VRmDk0ndpwlVj8h5YxI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c38dfa1-0a4a-4bf5-ffe1-08dc894797dc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 12:19:36.4146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TJWGyvnMKXYYzlFnO3s9vA87StHEcHFNwxyd3nCQ4Mho+29lBo4MtjsFG912MOE5SfpumhmN8mZWvWs49ZWUsgTidvzzuMnlue3DQ1FsGTo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7362
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=971 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406100093
X-Proofpoint-GUID: -i9HoVB0SuE9ZE21swnOE7sRQkEC5gYi
X-Proofpoint-ORIG-GUID: -i9HoVB0SuE9ZE21swnOE7sRQkEC5gYi


Christoph,

>> This removes the ability to submit an individual I/O using a CRC
>> instead of the IP checksum. There are cases which can't be expressed
>> when the controller is operating in IP checksum mode.
>
> Huh, how?

On the wire between controller and target there's only CRC. If I want to
write a "bad" CRC to disk, I have switch the controller to CRC mode. The
controller can't convert a "bad" IP checksum to a "bad" CRC. The PI test
tooling relies heavily on being able to write "bad" things to disk and
read them back to validate that we detect the error.

-- 
Martin K. Petersen	Oracle Linux Engineering
