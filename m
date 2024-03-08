Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5D7F4F1
	for <nvdimm@lists.linux.dev>; Fri,  8 Mar 2024 01:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709862183; cv=fail; b=iku3MY7dKUgK6/PDM7J+s/y7VQlGLi4MTs70AdPtPItUebvfBp7I3HDgg/y06keQ6173tRDpFTUaRy5OFLf2E+prBBi41q1iF3qczYgYiZFuttfLPruNcavw4NRXyMzEc9EoSz7uM7vtPkKiW6lWMhZfN1GEZx/Uu6Ek3ZY4fCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709862183; c=relaxed/simple;
	bh=eh2/+/MGcERmksM7XrUOOvXZ6a4VHIOcBPNBKYxcEZE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JKGMkkGHP10/DenMHZPe8uU+ia+hbhg1PQTJs3YfR0vgMbliu+u8ku7y3PehYUDqXb0nVguUn7RJNERcBbBM+WlZ4uuGWMaSB2Wyw3iI7iGfcfGXL3ToZIMXvW0tYJNMHA+GBHZ7EqmJ02F23npcLyIHkNE4LsQLOd6LhFpdb3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y8DST/xX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KekK+D7b; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y8DST/xX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KekK+D7b"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4281JbwX014053;
	Fri, 8 Mar 2024 01:42:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=49KnbJhXWpewOKSgG8aJziYMkmkJ2q4HLrKwPJGlSYI=;
 b=Y8DST/xX7ONZfMurTVkDGGLD6VphW+WVCqGoybjkKfhsxzNWy+f6u4ldkY2M7l+9q4UP
 vibdi52Iag4m9mHI83Qb3WkdiV25cSHnw0yWlDQEHmQClyllK+/wovm/F/PH9AsruVVZ
 ZNCohQ7RDoFhsyUYRKrVkDhcgq0R9gcf2jY+17TNBkrDiTRJXB/F6JoV6RbFNzHsILFO
 lApyCIw+J6PrNt8Jkuklkr9kB4xqmKOlfcVXNM75UrwqGaZyzd1NcgiMJ21RyMfax5mi
 k0Nc1rp1/6hCEI0Q70h2In5kZ2rGawBY29HDC2JCJdj8qc41WE5E+6/sn00t5tXvAeiC vw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wkvnv4u49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 01:42:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42809HF2005346;
	Fri, 8 Mar 2024 01:42:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wp7nun42a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 01:42:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aDFjiv/tlKJ8cNhJDRZ/JzfUe6mlidzEbH5H2l0sNgKPYu3+YnZfSxYD2dpq5RkBWyp/vMvkeoHCFtN7pL84XUmrqZGqC20IyVvByBA6EXUYyc914IO5W4iolj6yGnpiZutroKtbWJ2QF8KeRkAH99MardMRdG2iEhprMDsHtBje38f//ZgRqJvLyqUaMluSQHn8+vAuoIXnv4y3IudpvXSJTpRpETRi6mRsw4ekS2NAgJDFwxKz8m7j0gZSlNb1mHJbr2JlKrSveC+lzFTfkbZ6NMRkq4rk1lPUY6sYP9EZ5/BbYdBktiqgqVMq8BjbFS2lbzXfAlAO0GhX1JGcTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49KnbJhXWpewOKSgG8aJziYMkmkJ2q4HLrKwPJGlSYI=;
 b=OC6hWwxOJW2MfhG0Hyw5AQ9PFh0rzxhjXLx9UhdQKoZr0UK1Gp0pRt3xp3Zg8SpxrcUr0bHzGjY2m/qVdw6E6qFMaLmR3zntRhOPeO+FaXKhB7DzUXNXh+XKE084JAdQZQt8gpS13Yoh0XlTR0tdfCh+Sr2L2LDI56i3/kIYfYsqMEvLaNvwFjW4tyl0Rn754rH7asI1cFQco/hLFDe9KFKHZPRK9lR2d6/aPnNa2nRvLsYpvCCtmfBpcj5c2qAVgamcrI20w0MHTnJTT4RoBfMejkIl3xqD6H3F/Gx809rev8ZVOEMpmpuYjiO43jrhzNyWYjKuAkeDQxMWn4lmmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49KnbJhXWpewOKSgG8aJziYMkmkJ2q4HLrKwPJGlSYI=;
 b=KekK+D7b4mrCbsJ1vuFlpB4cgVVYj9eCCLCK0Jt/slmfZV1Lwnx6slq+Zh9k7DxxaXfRwGNYkyifNVTLeSN05WYH7C0WvhtgjCxavhu2kGuUZQuXKHv9AMIZPVPtgmE9Aw6NngNM+2Vm5T6+vhbrCLLFi2xom1c6iaWwakmEV7s=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by MW4PR10MB6394.namprd10.prod.outlook.com (2603:10b6:303:1eb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.26; Fri, 8 Mar
 2024 01:42:50 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::210e:eea7:3142:6088]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::210e:eea7:3142:6088%5]) with mapi id 15.20.7362.024; Fri, 8 Mar 2024
 01:42:50 +0000
Message-ID: <36816706-cdf5-4bd0-9be3-0521e2107f32@oracle.com>
Date: Thu, 7 Mar 2024 17:42:48 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: Barlopass nvdimm as MemoryMode question
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, vishal.l.verma@intel.com,
        nvdimm@lists.linux.dev
Cc: Linux-MM <linux-mm@kvack.org>, Joao Martins <joao.m.martins@oracle.com>,
        Jane Chu <jane.chu@oracle.com>
References: <a639e29f-fa99-4fec-a148-c235e5f90071@oracle.com>
 <65ea2c1a441d_12713294d9@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <a0f62478-94d5-4629-8a81-81d6876beaec@oracle.com>
 <65ea60971700e_1ecd29472@dwillia2-xfh.jf.intel.com.notmuch>
From: Jane Chu <jane.chu@oracle.com>
In-Reply-To: <65ea60971700e_1ecd29472@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0267.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::32) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4429:EE_|MW4PR10MB6394:EE_
X-MS-Office365-Filtering-Correlation-Id: c107d491-dd9a-4327-ec71-08dc3f11107f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	yMh9aRds4HzSojiX5D+d7Rn/WAE35QxQmhAaT5ddJ3qzULyhLxgDJDinSv1VwH33o8QXnmQaQrp9m5Jmq/USrZCWDi/0qSmYCMTeTe9bMwS05PG0AqeFq2cCxpSv5w7ImeA6dm/V1DMiHuWiDbWF0WeMWVRD8604UqZQAAT5qZkT24D2wZzNmeYrafFR8GggvaP6Q5bK/Z1MsoUZXV92+CZbbGhvo8YCtC5eVM5rekfck1CPJ4RWSxbDQV3Ui4KupHyRBnNh49yYuk6wsp/xhfkTmrMD8UMoJqi+dNmTnSwtawkNzfQdb49OFflc/NtNvSYcb8K4sirf0ho+GBoeEGn1zqsCey9Pj6Yii42Iw2s69lH8pvQo3N6ArTszVooH/H15xukPwQnXk0jycXVdKCgHCsUTObBI/+612ze9hguuag5kNI0qPIQT5kyRQPaVoEHyQtBupIfUbSHH5V9M2xIeiD0e0LaaI2a7URG+eD0IJSqzzZ+80cQ4nLBTM5evXX5Bf4sf84G1/rGNGUL+Y6bAqW6mMnGXmM+faCXx7Fh8nnWPtps2FCVc2FjvZ+RQ8cnI2RF90JIqbHmU/b0hyt88lIVXUyYDS1E2wf5RsGQ=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VU9qbmNLRncvcER5M3R4aXlPNFJoZmZzOVRVNXYvV3B2Q3JVMFhZYUc5MEd2?=
 =?utf-8?B?d3c0SFh6WHVLYllqVVRFUDkyOW5UQkYxeWU3Y3VpTy9md0pYckZia1lkQjd6?=
 =?utf-8?B?Vm9Ga2lESkNDV0pTWkw5ZDBBbTNaRVNmQTVlNlhHeEdBd25UUHY2bkNtanpn?=
 =?utf-8?B?cy9pMUU1OEcxYTVxNXlJZndqTUloUlV0d28xQmpkSlkvVEtoQzA2bkNQeHJX?=
 =?utf-8?B?OXNJbGhWdXgzWFBIUFdlR1dkUnBPMzdHVURBb3k0cGt3VFlFaXVIdE1GTVdt?=
 =?utf-8?B?dllMb0p3aHdjd3dpN3NaNnhuUGlBNzcrNW82MDNvditSNlREY3BDSkp2VU14?=
 =?utf-8?B?VURRSjRCZ0U5T0dpaWdmeCt2YkxveEwvNkV2RlViRkJGek42dkdJUm92U2o5?=
 =?utf-8?B?clFuZTBtOURsYk55S1hLM1FRLzl0bS9kZkh5aXJITml3WG9mVUFZRW51K3Z4?=
 =?utf-8?B?QVdkQ29BZTlnYnNlb20wbjIvVktKNXE2Tk5iYjFpNXJEc1hNcWRuQmZOR2or?=
 =?utf-8?B?czhSbEo3UjJLaUc5WnJtOXJBMXErTU1LY0hhd0grNzBsUUFrYjdZTkc4ZkRL?=
 =?utf-8?B?S3BNZnpXU3c4WXB3eTE0Z3FBQ0RjdXVUS0crb0UxbmU5MnVNZ1J4RGQ0eEEv?=
 =?utf-8?B?YXhYZjJqRWdicWVYSTNVdm90d2daV3FkVTMwNnJaUGtXbnYvdkNLaTd1Nlls?=
 =?utf-8?B?ZnoyZ01zT2JoWkYwQjVrWng5YzhOczVJUExtMFV6UEFKR3lZdXBuYlI2YTVT?=
 =?utf-8?B?TzgvRkpFMCtxRE8xR0VnYmlmbDI1QW5oWmhseDhlNWJLMldQajhXanU1VE1I?=
 =?utf-8?B?Y3BiZlhxZ0FyODZKcXJTWEwxYzRobHFaMFlrU29BOU8xcTJ3Zmx2WXNrNWxk?=
 =?utf-8?B?WXBhQU4wMVBMWGc5Z1dzNE5UVzlxTjFsT0k1ODErQ0xBaGxaZEtGYVVDeHlS?=
 =?utf-8?B?V09JenloUS8zR0loaXlGamlSa0Z2ZDlITjBFOHRtYUxxWWNqbHNPSGFVck9N?=
 =?utf-8?B?cVVKUHMzWHVBbkFNRWJJbkdyL3ZNakw0c05EemZacGRGd2hta2hPa05nWHZ4?=
 =?utf-8?B?Y3JjQ2NlZEVDVTVteEU1TjUwTS9ibVgrUGE3aUwrU0ZUQkVqNG9iRjhYcEUy?=
 =?utf-8?B?VncvVy85K093OTlzSDRBTk4wYjVRZWN1cDM1cDE5eWFIUzNPNUJjVjNEWjk3?=
 =?utf-8?B?LytPdHRYOEJyOXZnRHM0c3FidkV3bjJpRVBIaWZYVnA5NGJxUUdITmwvZ2tQ?=
 =?utf-8?B?RTkyZU9RTTJHNHJFODRFVVlYemtsa3dkQVQ4MWwzZWlZdndXd2JoT1h6Nmdq?=
 =?utf-8?B?RG0vdXFYREhlWmUvdkdzWXVBek5KYnZLQWdGMUtwODRSWWVsSFpJL2ZXbi9X?=
 =?utf-8?B?Z1pNeDlDdGpKdi9IUnhLUnZ5di9rYk5wUzZPeW41em1jOUVkdUhmYTlYeTNU?=
 =?utf-8?B?M1BBS1NtTUZKSVlQZmVIazRZa08rYW4wRzhpZ1h2TEFmYitEYjBwNmFvYVlM?=
 =?utf-8?B?VHRpQnRVSWNaZE53NnViRnBPSVhEQlNGOEIrSWladENHL1J0UnlRd20wKzFM?=
 =?utf-8?B?b1EzejJlRk4xV1lLSFFzak43STJEU1QvOXVkN2Q3bTQ1WW56R3hyOWh2bnFD?=
 =?utf-8?B?WXBJTWNnNDJJM25yOWY4ZlNjdzd3NldkaXltb3hNMXNJRG5YQlUvKzRJUzlO?=
 =?utf-8?B?Vmt1ZTA5NHJPTjE1cDJxQk5jZFdCU0xiRzZoUS82bWtBTG1SV2tCLzFtT3Z3?=
 =?utf-8?B?blA3R2h6QlRWSEV4Z29FVjh4eGNuNzZJcklmUHB3TFJmUHYrWHZBVUpyRUND?=
 =?utf-8?B?Y0FYazFJTXcxWXNKS3BaVGhFMTIra05JZGdZS0pPTE9PU05VVkp3RFJJOUoy?=
 =?utf-8?B?YmljOStjVnMyZWkwTXFSVGJYVDhwRXZtMERpdTlGVGgybkZpa2ZUYmhzS0hj?=
 =?utf-8?B?L1IwTW1zdHRGc1pPTktiZ0dvaVJzU3dncjhLeFJkenFoUG5pbjQzSlgwWmpF?=
 =?utf-8?B?aG0wZ2JyeUsyYnZrK3VFRThScjdmOUtWZi9uTUkzaTlQeldGTjc0ZE9lcUVP?=
 =?utf-8?B?dTBjNzdLYUwyRHNURUJ3QnNvTEtscnViTHFPRnlvWTR1V3ZXd0hFMjF3Q2Nm?=
 =?utf-8?Q?W/tqQTZelNNtisMYUX5+pjtH0?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	6GkXAzMsL1iUbYpm1aJlmrOzB54U1Cwuy1V9rtN0IbCfsYmd0NmgDsemqYovOD/w0d0LF+iExYAXqoCR8K0RebPwNSET3AmjwljJwsFic/hHpPIQUrOsy3DtBp0zLRFdzSoBz9vhjJtE4GAVHNgQmSTjbGI1igbFkGFY0O6YZuTUVR4b/ju3om9mPOFfhMpzsnEqMtx/xfAJpITlzsPYa5YmR2XN28hSqSHzku1jFeoLu93OTGy5bxI/vVYRofMzNJ+498XUmJ10h7xkTmuYQ3l9mq//oFya32vD34S0jJq4M6eZHQtEm+MKy21oVem27P1t3wCaua7xBqv1gqW9XI/hb/dZjk8LQ+gQcAwKahAktPLBm8y1xrmX7C8fKhHtnXadRFPZ0wRJMJomRD7pc531aIRchLI6E1oSHDQ9TcK65iLCL326lvaN1s+cAKS03ipd6atChYVrEGpW7h6gBs6i8DCwrslnM/dYQ/ei+QBOOO1RFNvEkXcuPQ8fmucYZDpvry+zbwkUXMvCJLey8YSO/U1XacqkwTrxzCeNYPMGW2LhhBiWGGkRnx3k8CcqZ3D187++9jkE+Z7mj76QABZEOWsrNE74PdIZT4iRePY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c107d491-dd9a-4327-ec71-08dc3f11107f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 01:42:50.4648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WdyzUWlRfMvrszc0wPdJRhD1LudUMabTp+Mu4+Wu+ldIJ8pbdYaONbcjDaqD6Os98cS45bocrXDWdAss3blsKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6394
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-07_18,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403080012
X-Proofpoint-ORIG-GUID: pwn7ocwTfGUGj-BY5ovl-AOWKi5ibHP-
X-Proofpoint-GUID: pwn7ocwTfGUGj-BY5ovl-AOWKi5ibHP-

On 3/7/2024 4:49 PM, Dan Williams wrote:

> Jane Chu wrote:
>> Add Joao.
>>
>> On 3/7/2024 1:05 PM, Dan Williams wrote:
>>
>>> Jane Chu wrote:
>>>> Hi, Dan and Vishal,
>>>>
>>>> What kind of NUMAness is visible to the kernel w.r.t. SysRAM region
>>>> backed by Barlopass nvdimms configured in MemoryMode by impctl ?
>>> As always, the NUMA description, is a property of the platform not the
>>> media type / DIMM. The ACPI HMAT desrcibes the details of a
>>> memory-side-caches. See "5.2.27.2 Memory Side Cache Overview" in ACPI
>>> 6.4.
>> Thanks!  So, compare to dax_kmem which assign a numa node to a newly
>> converted pmem/SysRAM region,
> ...to be clear, dax_kmem is not creating a new NUMA node, it is just
> potentially onlining a proximity domain that was fully described by ACPI
> SRAT but offline.
>
>> w.r.t. pmem in MemoryMode, is there any clue that kernel exposes(or
>> could expose) to userland about the extra latency such that userland
>> may treat these memory regions differently?
> Userland should be able to interrogate the memory_side_cache/ property
> in NUMA sysfs:
>
> https://docs.kernel.org/admin-guide/mm/numaperf.html?#numa-cache
>
> Otherwise I believe SRAT and SLIT for that node only reflect the
> performance of the DDR fronting the PMEM. So if you have a DDR node and
> DDR+PMEM cache node, they may look the same from the ACPI SLIT
> perspective, but the ACPI HMAT contains the details of the backing
> memory. The Linux NUMA performance sysfs interface gets populated by
> ACPI HMAT.

Thanks Dan.

Please correct me if I'm mistaken:  if I configure some barlowpass 
nvdimms to MemoryMode and reboot, as those regions of memory is 
automatically two level with DDR as the front cache, so hmat_init() is 
expected to create the memory_side_cache/indexN interface, and if I see 
multiple indexN layers, that would be a sign that pmem in MemoryMode is 
present, right?

I've yet to grab hold of a system to confirm this, but apparently with 
only DDR memory, memory_side_cache/ doesn't exist.

thanks!

-jane

