Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A791016EC13;
	Wed, 12 Jun 2024 17:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718213331; cv=fail; b=AVLneWVZ+G1qPshyl5AtLZ7wwKpYhvW3JRM80YrWqO3fAbKHpEkD08HbouDDCbC8J8JpDvis3RUldfsEcQ9KUlkbQBL6WxrOpGNoNwT//3mY8tSazpmHklyT909SLn0wDT6RkIaornXDNvOEyM7xIHEpYXzQDGEcKl6NNxA2uv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718213331; c=relaxed/simple;
	bh=t21RK6v6AuyrLTx523Ul6b4U86mUgd60SZXJOfdbGxY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=JefpZgBGzPKqV53Ip1FWnbk4NRqXlS6w/5lW3g/TR2SP0fAMYGJpaMHt2FgFA2uvyYYDMpvKhGjfFbvSu11ChPvxMT/4v0j122z2h+kAXiSAl3dA/hcnmPSf3nEamVZxf+LpAz1wTk5pTgN1E8tEUDBVbzZhcB4XLlV6bTvo+IU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hyq9AGwf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MTinflWP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hyq9AGwf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MTinflWP"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45CFd5Xe013646;
	Wed, 12 Jun 2024 17:28:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=QWBcjwmzUXYbsP
	znrAXcccDyvPJ/f5wa37FJBA/2Z+Y=; b=hyq9AGwfF3fSqpwkl6DcmCIwuT6hZX
	cNgK5M8DamNq/k7kzuM2DPgwc/IX+HaNAN+nWmDPO9F0o3sHH4uWvj6pxO9SiejW
	gwtGHVXIFAiuH7ATZZwyDfaJk2xj3ngV+ru1KkbGLXaR0kLlrT29XMUT4mLf9wt7
	reldHF/M0WSXj/LbDAYSNOEGRhxS69T9Uh2sEGwOTHb3AOGCqoTfqo2n3Jm6ifJS
	FKqc+Eii+vQx5kRvu/x2V/ZGJJRKnVmwczIqRF6GNXwZR3m21KnEu5ugKbVzjTVP
	rjlkuRPLtk1rZciQRx2iBKcOTQ9YWUYGHA/Bw6x1icOqg4irWCrpMFOw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh7fqmth-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 17:28:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45CHPNtV020099;
	Wed, 12 Jun 2024 17:28:17 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ync9012dt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 17:28:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WimxnpDWcaenaqmXBBJHDZRHrPWfZm2fxqTO+gOziPE3kGlm0q4BIxkx0SOM1JmYGz1PVGVkS7H2JGecHTfFWgnvn0dnOHHien3CWMtBN372N2/1SQxY5iMkWuPFC20x8N3qHVce1QVfmU9X6tTuaBaswt9t9D6BAUbhHc4IP5lLeJ2PVTgLXngZPfkHnoXaTKGX7JP28kU74LRGsew8m5B5ZQa8v0E8dG92a2oS/SmkoI3HxTxsOB4NE0dw+l1Cm+rwgPZPP4LK96S8TWku5Jq6vxsyVZX3xKspNUZS4yxkZl4K5AJVfARByQsfabvDDx0lFJh/VQ9E6Lx8SGv+Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QWBcjwmzUXYbsPznrAXcccDyvPJ/f5wa37FJBA/2Z+Y=;
 b=SaIq4dGcLwXI1hLr3oue4ApFnqQdERQ69jdb9RHCb7qJCzToyVwny91jv8VXAeYcvdVed0ht7O5kmNTh0E/2MNQ0rYXirVmUSHVs/k1pbbnsDE/5DkdptzB3o3alAnw3IYmZXyDgzJSLGEvrYreiSP/HFIQAZENINydOoymzk6VNP69LGSdnXIrSoC2FIkCXt9DAqeEqSOByyjRI5gt8nV8n9/EqS6yJ6Vf+0/D9oIjLXDWEMh3FetJr/nO61OmaQzTw6tWSIcZNHRUFuJcz/VR3mGg+VjXnYjcFWJ/ARc9fluN+jMsQE3+Cl83jwQOzQ+B5YTsNLGXho3nbId8OCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QWBcjwmzUXYbsPznrAXcccDyvPJ/f5wa37FJBA/2Z+Y=;
 b=MTinflWPG/GPCaeWv0V0bAJAGrUnk2W1mPNxxNmLGZZCVg/rNXo0aqvS8rh2FpwPoTWF1voVkEDfwm2xBxZXV2Hn09qhptaTAiohxIcmmnrgP/8uoqgJ7eeP990PA9WD7PWya8JAg/qYNKRZBLKoBYF9biuVWxnkVYw9JJwNr9Q=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB4435.namprd10.prod.outlook.com (2603:10b6:303:6c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Wed, 12 Jun
 2024 17:27:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7677.019; Wed, 12 Jun 2024
 17:27:49 +0000
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
In-Reply-To: <20240612035122.GA25733@lst.de> (Christoph Hellwig's message of
	"Wed, 12 Jun 2024 05:51:22 +0200")
Organization: Oracle Corporation
Message-ID: <yq1tthyw1jr.fsf@ca-mkp.ca.oracle.com>
References: <20240607055912.3586772-1-hch@lst.de>
	<20240607055912.3586772-4-hch@lst.de>
	<yq1frtl3tmw.fsf@ca-mkp.ca.oracle.com> <20240610115732.GA19790@lst.de>
	<yq1bk492dv3.fsf@ca-mkp.ca.oracle.com> <20240610122423.GB21513@lst.de>
	<yq1zfrrz2hj.fsf@ca-mkp.ca.oracle.com> <20240612035122.GA25733@lst.de>
Date: Wed, 12 Jun 2024 13:27:47 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0047.namprd19.prod.outlook.com
 (2603:10b6:208:19b::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CO1PR10MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a8732c9-9d4a-4bc7-aee9-08dc8b04fb69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230034|376008|1800799018|366010|7416008;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?werPUtekoHpFPk2LEunWG2uaLsuhft8ye5kcot5+NkfCzHDnqMOZRI91Sf5V?=
 =?us-ascii?Q?jnxrsWommghWc1CEIAvqNdrUhlqlZZuIQDFh3ncIw3xdir/QeDcalnf/38MN?=
 =?us-ascii?Q?yaz621DK9jzVhXnaWs1c0/FmD8+TzBgWS5uEo/rBH61U0vMxByUY/2oZb1LU?=
 =?us-ascii?Q?OMVsN1z2hAx2VsFwzRNHC+D5tjp3hR9bz80hBcABcNVBKXcSL4ZuqQtbo9P2?=
 =?us-ascii?Q?Blw/JzkCzGOs7sRJeJ0yi+APTSe4Ou+A91g7yH0Vvb4C7bJq6NWnaixUdqy9?=
 =?us-ascii?Q?CzyHtaTOoTldYpHJ5Z+z9jz2QXjWvoaYGCroSiT0FtpxftDSyv7+BNkN4BhD?=
 =?us-ascii?Q?HQKvgOI0/GiBUgnfuLvTiJ/eiMW7iOruGAOJE2BySSRfWDEdGEaAG7gy+dRo?=
 =?us-ascii?Q?rTWQ2yph1goK0W4ZAHHHDyyiPhFgwCE19y88AD906EQ4SnKlQ2KcyTkM+7tU?=
 =?us-ascii?Q?7XsqFwTaGCiwUsfcNex7k2xjmifJXvmoacxNWhAJbrU113OQvGlaXQdQVs5D?=
 =?us-ascii?Q?F4hOyxfAVTNk6ZyEFb4ujiO5Jb9FDZtzacofgf0ajPKY5LhzQZJ94oszkvlH?=
 =?us-ascii?Q?t7Nd06XCK4pI0mccNWJN5QG5DmBRK0TB736DfUXxy6ZMF5lYkqyqkheFJN5S?=
 =?us-ascii?Q?HNsBaw03sNcEUOEmSEVSu7HYNfUVdCTP9bltxi9OEQvaxHP1KgjhDSLCEwxK?=
 =?us-ascii?Q?GfCiCjmvUEukEhw2vBFJI0gvZ1ahSREwkTaQiubTCuqw15iCCt2mEFOJSW8v?=
 =?us-ascii?Q?DPLna+ixnr7/Zu8ZcpnI+TFRhqfb/qIXsPB0AoCztmyi5e4vQRXosL7A4n5X?=
 =?us-ascii?Q?EWNx9gdfTe80gnGGB6mztZxQzy87WwzzIivkxAMDt27z2cIrP/293r/k8gMT?=
 =?us-ascii?Q?7G7v/yKW+M1vSFKe+ZOc3msc+v0m/tOter0lYyeJ1+YhGBggyieuVrVcWez5?=
 =?us-ascii?Q?s63YUgh9ofDfetXRRlBqRDOKqOOFDcLmyv/39B9ypYNCk9KDD01U4ZsTWF+c?=
 =?us-ascii?Q?p5Tzrn2sG0b2GHxldTkz8chI+xHIk3sM1Ry/D8eClulYW59O85n+bNnYT6/o?=
 =?us-ascii?Q?DyItkZHtqiGNZZx+o4fgz55eTiAjeh4c+9FeMX3mW94uXZaVg5T4Im2R00jZ?=
 =?us-ascii?Q?qNwLbx5O8nxqrBdqdS8DUNbCk9tVoI4ctN4cIUghas+/GQWnl3EVIRJYgnMv?=
 =?us-ascii?Q?LOl2mXVNpb4nnr2voo1vijfZQSWPwnMA+wnb9IOPSfbKAmj3oseGL88PtkvN?=
 =?us-ascii?Q?K9Rz8N1KxoGsP3gCHk4Bh63cRb9WKRMs8d8VMps4WIv4PSt1IalnsKGhxKOJ?=
 =?us-ascii?Q?mfs=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230034)(376008)(1800799018)(366010)(7416008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?j5M/G8zwB+4CwutuxRFElKJYrPs9ykkR3NCOMOnNHw8dG7eKflCk6vhXoteR?=
 =?us-ascii?Q?AmzYOYfVW+yrjGw9Qqr8qDJyrf8OBVSpFVdCj4lrZ58/TatlLgugHynYsNMX?=
 =?us-ascii?Q?EJdVCWvjlr2Pmv1BCttWWNordmUZAoX823pgKWdW8t6jZxwPu/IJEt70eSsx?=
 =?us-ascii?Q?Bu05RSq7GdKmKiv7SYs0GL3uFBoOCoRuFhzKvi5a3288DqWLQGKDHjr2DhQN?=
 =?us-ascii?Q?y3HBWx0ryoGQ+UGYJ5f1fM2wP0MM8XT4U3ixSpzFEq0Eh4JB1INPzKoD/dD5?=
 =?us-ascii?Q?Guo08SpqdT/3qXYN56BFM9OWH77dkBLZzYvajLZy7KgJWqD0z93J+Oa4vq3y?=
 =?us-ascii?Q?qXQWinqYkTMJdrV2y3KOdwhpcvbulatV/vBAl8XKYD2OHP33vNWadAz5MoH2?=
 =?us-ascii?Q?cEskfuvNXMUKKHt83ayFzE3kQTwSlnFslY6AcwWW5alstvzEHlvTHrjDd2Zd?=
 =?us-ascii?Q?l1Gk2T3Qa6iXyNBxUrVbsrev5sqVowRplrNYXOPh0E9M0/6soO+CBZVe4f/d?=
 =?us-ascii?Q?MyoBa+CkQtpGZRqx1boVqyRJc1Zh/n79ovbJOR0k9euQ9SUeSFWhxUvpNFmx?=
 =?us-ascii?Q?l4XVq7QQLQjcV+qrdnWP4lcEmw+G1V9ttuiK6Lf08bziAfIchwxd7lrwdRoe?=
 =?us-ascii?Q?f9moqRTerm/oGEcfttA6EKJcLTOg3QLQez2Gry0XSlvb+kJGAL4DlNlEl0EK?=
 =?us-ascii?Q?YglgpR2hAUbZXT6Cbd0VwdFoQaHSpDWxl9BWTfb96melZ/hENNH0PRxzjIls?=
 =?us-ascii?Q?BqoXzIwp/vZcT0vocN7OP2mWPTSTVt9WTOnPMboBIn4q0GjmFTL7KNSliSB7?=
 =?us-ascii?Q?ZaR43Rm0pEP+UA7vIx1EjH3tPSl6++OXNIXb4fzYfJEeR9bOPSWgfB0C2FqD?=
 =?us-ascii?Q?Q9T7QygM/JrLviGcTxDCVTMj7fXiHiaXLvDmeizTb3SUvmLviZuEQnldg+ju?=
 =?us-ascii?Q?NXZtwZMs5DWFSt7cnEcdEo+FPaOHnn6Spewmjq6ujK3IzD2C51rQUvmtKdfN?=
 =?us-ascii?Q?Ecv4irCOjysCowqD316u1MJVyABirE4wZVTRPyQ5Ggl1VZEqzmTmNeyGlkor?=
 =?us-ascii?Q?YyxMARszU9q0q/fdplcZejdl2801tIZGiTguvhoHwF4K1EeLEf0qo0n+VQAW?=
 =?us-ascii?Q?qZOA1iEXJTFZVv3rUTXYAsTg7dXIzhG5axl+TOGeanafSVZAS73LqlIlS4xl?=
 =?us-ascii?Q?YejWhaOgmZ7684HIS3NGBY1XCO/4Gye/LE+chu/dfsOjWf/6+Z3gbf+1UNb+?=
 =?us-ascii?Q?3Lz1jnHiK9UG4FYL8jwPy5t16Tdc9bO0j5BNtVbd0Tq0e7SrfNPj5z8mr81q?=
 =?us-ascii?Q?6xNoyXcEQ5I2rJsNPsm8z4TnEJWIeMXdbhdj9LvYrIMywN3uJbmXiQ3bbN1O?=
 =?us-ascii?Q?rXEbqSAd7Kc7lNnCZO8liv9DQ/QcLkfAtRWgCIZcZr8OUoq57X8htuKHzHgA?=
 =?us-ascii?Q?k8xZ1ohShIPzMKoEyHbKDF5xod4eLk4hWJ/9C9L7KW1jOaQaZKjduxQszBSG?=
 =?us-ascii?Q?hg3RVkxcK2sFDeRf2dUBxyHHyk3OQcAzhYUC/jPTMT9j9q+DLWCA7c2eQhgM?=
 =?us-ascii?Q?2snf0wDYfB7uxskzIvu6jn2O5ZtKej2FP5ISvSK1uOwpYF8uZuaY0iU3Jl2E?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	MHPoAFbZI6SzVsxr0J/s3aoxuHzD0YV0R1+em7v/hm6lzTzy8tvQ3rLnLos2IPr3S/BRBCMvJ7AUT7B+/NTijHMIrpzNoWuntN/v+oxavYbSrmtoMCqBcZHyTCfTMdWfsT2mBhJkVw4QYTji2uZQjzcGcb8OSMYV1y4+G53/O6H4t2mbc0QzBIXVdiBbGOtNdJdGLmwPgnU2154xR7cNtslMnGMVoUOMsHdDZ8U57kQNUEaXN8IN0+0lhTSttwVOg0JtKxfp67gzhCz/BTcdJpwOPhJIHNVQkuFDNy1it85WI9tXYicbQm4s2laM3zwrJ8AXKRntrbtvul2gDoiSm1kBOlgUa+VWAuhRnhPfBWaPfjVDvS4lwk6+YR/eQWQLbfbc3bXRYra6teEuOUt9Mkwm7peu4+iZRHBSdE9/IEdh9mumUYY5YsFqY9kaw+1UAdqoJgjb5XJ0xP6mskwl5yHjo45/BfHS69SqCalLmD9Hj3YWmJNoDSoFpitFPscQkVN0iY97vMv1KaAO1cU85V1pyoIgOyvmGUkfXEBCO6ltEstAlT5dk6MhfurANGRH7rIIHpaDlcURvhhKNjeybtnJmQt4NgCPsPIk7iU2jnc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a8732c9-9d4a-4bc7-aee9-08dc8b04fb69
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2024 17:27:49.5454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rSm48l/TL0qruVrmeiKWUe/HRUj5ehQo/HeGk62NCzXiGXddtcs0fif5yhlsllXXTH87WIGQ3DggoVs6g4kDTYJucxZxeniklA4b9ku9/8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4435
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-12_08,2024-06-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406120126
X-Proofpoint-GUID: _sbNR24V5tQM433MsKag-tRPmrBEMBrT
X-Proofpoint-ORIG-GUID: _sbNR24V5tQM433MsKag-tRPmrBEMBrT


Christoph,

>> > Note that unlike the NOCHECK flag which I just cleaned up because they
>> > were unused, this one actually does get in the way of the architecture
>> > of the whole series :( We could add a per-bip csum_type but it would
>> > feel really weird.
>> 
>> Why would it feel weird? That's how it currently works.
>
> Because there's no way to have it set to anything but the per-queue
> one.

That's what the io_uring passthrough changes enable.

Note that the IP checksum is an optional performance feature. A SCSI
controller supporting IP-to-CRC conversion does not imply that all
submitted metadata must use IP checksum format.

The T10 CRC used to be painfully slow to calculate prior to processors
growing support for pclmulqdq or similar. Hence the optional IP
checksum. But on a modern CPU, the T10 CRC can often be calculated fast
enough that it is less of a performance impediment.

The interface was explicitly designed so that the entity which creates
the metadata decides which checksum it wants to use. And then it uses
the bip flag to communicate that to the HBA. The patch which allowed the
user to set the desired guard tag format for block layer-owned PI fell
by the wayside, apparently. Possibly lost track because the T10 CRC
hardware offload changes took a while to land.

Note that I would personally love to get rid of the IP checksum
altogether but I think it's too soon to make it obsolete. Still a lot of
SCSI stuff out there which runs in IP checksum mode. And it is still a
bit faster than CRC for many workloads. And as long as it is in use, we
need the ability to support it and qualify it.

All I'm asking is that we retain the ability to disable checking at the
controller level and at the target level. And that the optional IP
checksum can be selected on a per-I/O basis. IOW, please just retain the
three existing bip flags. Happy to look into what polarity-reversal
would look like but I don't think that should hold up your series.

>> The qualification tool issues a flurry of commands injecting errors at
>> various places in the stack to identify that the right entity (block
>> layer, controller, storage device) catch a bad checksum, reference tag,
>> etc.
>
> How does it do that?  There's no actualy way to make it mismatch.

Through a custom passthrough driver that we want to get rid of and
replace with the io_uring interface series.

-- 
Martin K. Petersen	Oracle Linux Engineering
