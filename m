Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4028224CC
	for <nvdimm@lists.linux.dev>; Fri,  8 Mar 2024 01:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709863043; cv=fail; b=DryuFzJ1Yt9AhV+nHrGu7o39VyCS/Fgfo5ROlBoyDmGgoJLYVvvUyConlz91gewcIgFifXzhbIkm+VfTxrT6BApMY6PHzEBXB2rNvykEdx5vo9oZbE4kTnKTn0wlZUBTSjTMznu/zy91/r6g1P1S3kQJxoCfRqdhN6euHlhJmWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709863043; c=relaxed/simple;
	bh=DHDg93OUTSv5T72y9SgDMs/odhUsnaBfN6KU9bFrbPk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NrLyLFvqoogD+kCNr/+XtCUdAdW6FDedeokG+82EufPgR0Zh5jpcBN6miCp7Is9/xZAQZTqC7vsLEUy0Sm0cGqQ/Ks+YKmIibfa3OZ+rIrk4NhUWrItOtSLuza/eng2rqaWIIiTMtmuaYA35vblIzh6uACVM5Fh2sfxFLCxk8cY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PAYs2h0V; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=S+f8B2hP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PAYs2h0V";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="S+f8B2hP"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4281iQHq017674;
	Fri, 8 Mar 2024 01:57:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=KBmHb2yQAARJ7sz3kjQRNobwEDR42qJvDc8T4h3zuLI=;
 b=PAYs2h0V4rCJpdpvwFUD5dPVaBEsa86yJKZHeeqr+JECLZchUAH5S2/yj8oYqq63KddW
 NuqmMDl04kAOvj04aC7ZrwLhbu0Pwe/OCGhjA/eScnHEpGfJJzONssSdQZ78sBJI6483
 jkKgiDpeOBI3efa0A1Pw4UN5iOjcAP2wUuejK9lGUom2agKMx1u32eH7XSEONAuPg02M
 Gu3t2ebCoOmb0sXmnXS1ZbGZu+ObFfIKJfUF29NPLkTngdT7LYhYzMJABVjSKPNKxCHE
 p8T6QJlmqk6ZB9wL3sGAn7lNK9qxT3dyhqqXhCywRSJ1FY0s74LKY0YroyuwmgmZPGsO 9w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wku1cmvp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 01:57:15 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4280eP5l005282;
	Fri, 8 Mar 2024 01:57:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wp7nuncxg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 01:57:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5wcAcRlyFVBi9Nd1Ohp1AwCCPSVPTzOb/BUdkRjaAYkcSaI7jyck6GdZsbyHub+vXGrcnSUUzcC1clEdpED7RMqXJQryP8bvlUU9dp8GzG0oAzhX07BSNEdYHv9qpZWe0wTJ6x0faAQueHzmf359ZfFJLw4fkcywhFAqKm6+1FG867iPuCOBtzBkpnCwTtVhVmmxs5PSIWvdncWo2TXG/3yNllep//WRHemcT/bFlKiTmvqOJifF1VLLtY8ppXRAGQr4f2m4vmDcQD/Oa0YR4hM8+J69c0jplJbuJe9Gclp6S6TL5vfbtqJxWQOFcyik7zAjly30F/pgj7QLNjckQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KBmHb2yQAARJ7sz3kjQRNobwEDR42qJvDc8T4h3zuLI=;
 b=l5YI3DLhBtYrhFGkae17/l2Bavj9h9iQhoM+w0+gjMzrbQuRJS6qe5UJRTWIAApjNsgZ6xn7bdB24JU9igAQeU2OE2i5Ymia6kfUZqzLPvDHv0cIM1L1xd92tVV3d8gmzWXtwev9qPB6kHROTocrW9FF1v4AMYd5I/1gPr5fTJNs9Xk2zZ5DT1aLep8yGOASyaK7O3XwYUsY1+xVujLYG+gydUGdQ1a2Wd/md5vBw2CuYon8sqHa+YpMaon1+K9exp+gGXFRENQWnNCbVPkrm0ckyIzUqy8HSfstQRag1XUEyLILYOQLRR7yYB64rf36HoPRFsLVsqvq29l3LexKnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBmHb2yQAARJ7sz3kjQRNobwEDR42qJvDc8T4h3zuLI=;
 b=S+f8B2hPmE8F+is7lZRkaqjaxkq7NdhTw9rGs6LAIgUWeq3PpqGS3D9rMFhtIEJyZOCS3pCjschgibnFB0lt39sZbzR/bGkPa25HyymG61ljp4wBWJEhVDjowIv6+IS6gAvBheR/5jesz2NmPvxe4g57PC9Pl4oWKtgTNyRTq6g=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BLAPR10MB5043.namprd10.prod.outlook.com (2603:10b6:208:332::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.27; Fri, 8 Mar
 2024 01:57:11 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::210e:eea7:3142:6088]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::210e:eea7:3142:6088%5]) with mapi id 15.20.7362.024; Fri, 8 Mar 2024
 01:57:11 +0000
Message-ID: <0660501f-ae9f-48a3-a1c0-f19be8ca5f02@oracle.com>
Date: Thu, 7 Mar 2024 17:57:09 -0800
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
 <36816706-cdf5-4bd0-9be3-0521e2107f32@oracle.com>
From: Jane Chu <jane.chu@oracle.com>
In-Reply-To: <36816706-cdf5-4bd0-9be3-0521e2107f32@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::14) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4429:EE_|BLAPR10MB5043:EE_
X-MS-Office365-Filtering-Correlation-Id: c3a019ed-6fa2-4a1c-7cbf-08dc3f1311e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	AVJAEMRUaU2NwC3+O0TM9+V7F/HW5ypzcpxF0JwFJCOMYnIOb9hHmVhaHu2TUIWaBU6da34NSlDQQtf/E+Q3hRh/pEJGbWAaX32SnVJkaD+HmIerSxk3m+ATvKbyyTWysmQ4Gbx25XfCDGvY6qadYWgU2+9crCXgU6i5Wml4yguQ0c7uOPvBvF6mma+H5Qq2Hw62ITsdbCPU5hMW9msyZFzwgu7BqUfRWlSfqdcGjA2h4VXHy2occdnRyOms+Qy9xMmBPLMza9Wbrd8XldaFy/rO+0DnBQLvtMiZZi4oKRRRwcYMuehnz+0KKLA8kXv4dDQKXmpLNyRWpPsohwWdui5cjqLLbtQs9I+4CGKaS+gcXmC6atte6HDWhMpVX+/9MY8GfWes5fwKtqKyuZqgM2FkC2GlqxClW+du/gI7DY37NIbFh2ekzb3k0UfOZ4hBnnSS5bSm29cPUsmamvCynHM6N/Z0lfJTXa5VjRZHRFPqz1k03iUe3gHgqeAGzSa43cNgoGUzWsNzsuPWjT9dDLgkGYdD4iqPk5Dg8q7rQvVsPb100U8889deTAJVCJJOiTMfPEw5hchysEM/E+Db3GsXxMcLlzfoUI3ywMWUgFE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Mm82VHNOeDI0bDQxcmJ3UXVHNGl2eVNNRlpyQlR2bTJHNERRS0p1dlpRU0ZV?=
 =?utf-8?B?OGU1WjhmaUVUdWlkZkdHaHRoeTNNRi85Rk5iUjgvNXhaMG00V3VTOHZiekEv?=
 =?utf-8?B?Y0lQbXVOUmQrR25YeHovVitBa2VsOC92WWJENFFTVlFseUdJQTNQSWU2WEFM?=
 =?utf-8?B?c21OdC9lTWZVdVBIREZnUmlkbDNzLzJjZmhYdGZqcDh0MDArazFIbFk1UXlO?=
 =?utf-8?B?bFFhREpGY0g1R0RKY3ZDeXcyQUFISGRNZENVTzZMUlRHcFhiZkxCUHEzelFn?=
 =?utf-8?B?dkdVVVAzVzJFemE0b0d2ZlYvZTltcVpyYkhyQUZvS05qREYzcjk2N1Z4WHR2?=
 =?utf-8?B?VUpaKzg5MTdralA4cGlwQk8wVVgxelhmYkJ3UzNvZWFqdXJ6QTBMZTB6c2kr?=
 =?utf-8?B?S1U2ODlKZzdsVzhsUUNtRTNNMXlpcmNXclIrdkV2MEt3d1ZXNnRBM2hDdnJY?=
 =?utf-8?B?M0syQ3p4azlvT2J0bHp2VkczMWZNMytUelk0ejRMNE9EUGo4cUNqSkM1b25m?=
 =?utf-8?B?Mmc1RkJOZEdMYnB1b1AvRVFQeHJyQ2N2Z0VsVjVXSW9QbUlPaVZnN3Z1RUdo?=
 =?utf-8?B?OEgrazFoR2MyN1E3SWJKMUNmc3BQVXZjNFk3TCtwOVNXaXNYWTdubEFIb0sz?=
 =?utf-8?B?c1o0eGt3cllldlU5VkpWWExCL3p5K1IzVS9kRW4vZGJ5K09OaEkvdGVkdDFh?=
 =?utf-8?B?d1BtS0FxZld3VlNRYjc0UGpvRUNOU0hDMEJKY1JWUVFxaG5Kbzd1NTMrVHV6?=
 =?utf-8?B?MGh4eE14U1dtVTlGVVlIU1lGRkY5ekhHRTFoR2VDaXZyK1lNMWQ2ZlpiKzdt?=
 =?utf-8?B?UzV6YWZIZ0pRdnFsbDBRQUpTSGlnL3RJdCtYVkVEcmVyS1dNazZmY0grVGNG?=
 =?utf-8?B?MmoxQVVqa2kzQWM5eXJXdWJwRXlTbzFSK0h2Z0ZldE85SE1yTytjUk95T0Vs?=
 =?utf-8?B?bTFBcm5FeUJpYzJnUVppamZJRThSeU1wMkFOVHE2LzhpN05RbjJiOHFjWnl5?=
 =?utf-8?B?NkFuTWZwZTk4RnB4S0kyWVFXeFRwWno2N0tkRklvQ2M4STFlWEduMHl5M0lw?=
 =?utf-8?B?aUtaNzkxWWY1V3lDK1pzcVNlem90UFk0Vlg2MHNsVkg1UUFzSDhweGNaZ1Fi?=
 =?utf-8?B?MG4rMkNTUGozZzl6ME01ZFBxcUdCb3Z2bG5ESThiMnpYREoxL2R2aWx5LzVG?=
 =?utf-8?B?ZFdsa0d0OHJVdDZHald6N1J1a1p5MDdjNVRjK0NVb1RJUFRRY2pYOVh6VU45?=
 =?utf-8?B?NzRCZkhHMkd4VktyUnV1akIvMnhIYTNYUk5Sc2dGYTlQSkFZZ2FNYm4rcXkx?=
 =?utf-8?B?VU9ZWUJ4cFZUMzRqV041VG5EYy95MWVFM05OU3VSd3FsR1lkeG1JQWpSd3NC?=
 =?utf-8?B?Si82L3ppcnZPbWhtcWs1bFJwZ1VEdlRNYVFSWVVTZnc0dkRlWGJ0c2hzZi9O?=
 =?utf-8?B?MHZScHdzbWZKaUw4WlQyUURSTzdCYlRiVllKekcwTGFrUGtYSWZwMXRoWU0r?=
 =?utf-8?B?Z2F3dTVJa20xcGVwS2dPR0srMklseFMzVU12d1crckhERjZRL0lONGd6eUhm?=
 =?utf-8?B?LzBuVloyKzVYL2J2TGxNc1AwZVJkVVlGU2txcWd6UGtOdHpIRExSRm5Xbk1X?=
 =?utf-8?B?WnpsbmZIOWtGUVNMTVkvK0kvaHZVZFF0aE5Yc2d0dDhQVjI2bEg0eFR5TGhW?=
 =?utf-8?B?WE16V0RLOWQxZHNOYmxOYVU1VTVTaU5sK1VCMXVEdTNja0hXWTZ3OWZGeDhT?=
 =?utf-8?B?UklhZHd1SGNiSm5sY0NxNHFPblpZYkhsNG1tcFIwTmFkL1dFajhrTkZjMUdV?=
 =?utf-8?B?YmM3dkphN0UvblhUeUhmUkhxdUszTXc1bFIwV2tYZGhWeEVxbDErRkpvbDNB?=
 =?utf-8?B?eGdmUzJpbk5pUnBGTTF5VjB0Y2dGTmtCR1NBUWgrNGR5bm9FaUxwNDRSdjlJ?=
 =?utf-8?B?WXMrM1YvejBCbGF1Rzk1VEpOMG12NDA2c1dxaitUai9Qdk1jMnJXRnNGTzlN?=
 =?utf-8?B?Z2RXWFRRdTc5QXhrZUphVW51YkU4bW5BOW1RRU93V0UvRUdoWmNpd3U2MHBW?=
 =?utf-8?B?dXp1dkx3NWRPQ1NsN2d3RnY3VzNaaUlFY2lHVTRYeTRhK0g4VGl4eE5MUTZi?=
 =?utf-8?Q?nC/zKZm1Zkrs733KD/Mk4Smos?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ezHTpZaWWckgFvgZtpMIVHRYsjsaYr0gofIobl+DdDyRfVxY+oymY4js7+/2OTZlVU0YHMr5dqRio46td7TQM9hVfifCNt4rr/1Vo20drKSWovGOrvin+lPdC61/vOCWRx5KUt06rAvtoA0aEy0kegwRKFaxlj+EYYJGrKSEG+jnwuffGMFr4XiBYETo6fqs2WUjDHKW12+ThfPsaa32Yb62fFryD0tQdQxxBEOQVt+PGSfCEKodmXdDLn5MEZZDjjywADj2+fQd/HtMyoKr73hYY7jPTm5w4roygaBYWTT6Xl7CxSqn0KtDqTz3E0fzeAin80iG3ucaPHDp923Mqtfd39G02z255eeLhKzl9B7U9GLy40VGdUBtIHDujI1tLEWWGa924j8QpCTk1+w5CKzlhMbT1yKh4nTCyN1eAexKs/10PVOV37Fo0T4S4k4KKqF4kcatuwgHFJR8+Uf3cijRS37TsP8rdFastvpbzQyQc22btHb0Gzdn77lzHvohxwIw3GXH9EKrHNEilf68OTM3t1bo/tdM+Cg3kIy/X9sqNAJ3za4L5qSsvfqhlNCEtmJOquYnx47nIrESI+YNO71e84ZJ32QiIdOzsYcoOFE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a019ed-6fa2-4a1c-7cbf-08dc3f1311e8
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 01:57:11.8404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FX2SEftxXHXG3gWEI12CPCtl8jgZPBJu8bHiUf/R1lbl95dl8Cxc7zqgqoRSumggBwWCZJRfAP+ZHc9OLfv0YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5043
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-08_01,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403080014
X-Proofpoint-ORIG-GUID: y9bP1I3hms8-VjJaCwOStXpc3SKOIiNa
X-Proofpoint-GUID: y9bP1I3hms8-VjJaCwOStXpc3SKOIiNa

On 3/7/2024 5:42 PM, Jane Chu wrote:

> On 3/7/2024 4:49 PM, Dan Williams wrote:
>
>> Jane Chu wrote:
>>> Add Joao.
>>>
>>> On 3/7/2024 1:05 PM, Dan Williams wrote:
>>>
>>>> Jane Chu wrote:
>>>>> Hi, Dan and Vishal,
>>>>>
>>>>> What kind of NUMAness is visible to the kernel w.r.t. SysRAM region
>>>>> backed by Barlopass nvdimms configured in MemoryMode by impctl ?
>>>> As always, the NUMA description, is a property of the platform not the
>>>> media type / DIMM. The ACPI HMAT desrcibes the details of a
>>>> memory-side-caches. See "5.2.27.2 Memory Side Cache Overview" in ACPI
>>>> 6.4.
>>> Thanks!  So, compare to dax_kmem which assign a numa node to a newly
>>> converted pmem/SysRAM region,
>> ...to be clear, dax_kmem is not creating a new NUMA node, it is just
>> potentially onlining a proximity domain that was fully described by ACPI
>> SRAT but offline.
>>
>>> w.r.t. pmem in MemoryMode, is there any clue that kernel exposes(or
>>> could expose) to userland about the extra latency such that userland
>>> may treat these memory regions differently?
>> Userland should be able to interrogate the memory_side_cache/ property
>> in NUMA sysfs:
>>
>> https://docs.kernel.org/admin-guide/mm/numaperf.html?#numa-cache
>>
>> Otherwise I believe SRAT and SLIT for that node only reflect the
>> performance of the DDR fronting the PMEM. So if you have a DDR node and
>> DDR+PMEM cache node, they may look the same from the ACPI SLIT
>> perspective, but the ACPI HMAT contains the details of the backing
>> memory. The Linux NUMA performance sysfs interface gets populated by
>> ACPI HMAT.
>
> Thanks Dan.
>
> Please correct me if I'm mistaken:  if I configure some barlowpass 
> nvdimms to MemoryMode and reboot, as those regions of memory is 
> automatically two level with DDR as the front cache, so hmat_init() is 
> expected to create the memory_side_cache/indexN interface, and if I 
> see multiple indexN layers, that would be a sign that pmem in 
> MemoryMode is present, right?
>
> I've yet to grab hold of a system to confirm this, but apparently with 
> only DDR memory, memory_side_cache/ doesn't exist.

On each CPU socket node, we have

| |-memory_side_cache | | |-uevent | | |-power | | |-index1 | | | 
|-uevent | | | |-power | | | |-line_size | | | |-write_policy | | | 
|-size | | | |-indexing

where 'indexing' = 0, means direct-mapped cache?, so is that a clue that 
slower/far-memory is behind the cache?

thanks!

-jane

>
> thanks!
>
> -jane
>
