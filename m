Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9936D73509;
	Wed, 28 Feb 2024 20:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709151475; cv=fail; b=VBClI1+yU7eQYxVi0+6HpLH3UTHu90RAY0xVFy5aSGJ3saNy+E3RGSzS+6Rs0o3paHqQEOnIkwrZZbiSGud/rCRHztw886TlzZwlLkX4cHIcsaKu8hoN4UyrJvRxzeIEAdzmj1fOKJczDcaBxR7xTIQRa6MS9vrElzq62fZ3QFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709151475; c=relaxed/simple;
	bh=ymj8tsjy8Jso4peaEdteZjg5Lh1FW4ZDk/yOBdGqf78=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r/VmOnjcvRanFLUE2gH2AB4dUP+e6NfhRdB8vQrEy//vbrRwFUh4jcLkJfjFHWpySBR57x1ZOed1kYeQxhmrsw/nokUsd1elD528SDd08tT5gpTrueWZVqCqquKGKPt8gvoN1PPj9nAOzjOE3gRT5AeW0NTDyDWFHFqlyC11QxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LiepST7D; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=E6OZSZFU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LiepST7D";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="E6OZSZFU"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41SK9TZi017619;
	Wed, 28 Feb 2024 20:17:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Cm/ME/xvbqXn2WbMRTFQhFUxTWC+ULDdRjv3LVVtisQ=;
 b=LiepST7D3m9+boLriGjpQY/k4eRFiGIrT40rsaTGbWvxCDknpal2bh+RwADscOZ8TVxm
 HU+lnv52x8pAl+9ZWAJ3C/R8Kdf9Xb79BpGPiw/WO86A1OQxRBGJQ+8v3iC5dk8cjcVR
 K9UHO2sLX6eaKX9+um6Q/7udS9nfheux2txpN4pmSPYzTUwoTobGCTWKq+ojA/m8aBlZ
 aDnxavix0tXeiwZOrLSuNpMzV/qseOmyO7k2Zsb+Hz07fXpFX4QK1yrD6UXQq2jTTVU8
 pV/dexS+hY5ZtlnU+ajzSZM1ii9jaH10mZ2GvkwPUl3Kp/Bc4WCc3WJHOgN0iu136Lwo Aw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf8gdkkq2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Feb 2024 20:17:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41SJns4S009836;
	Wed, 28 Feb 2024 20:17:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w9df1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Feb 2024 20:17:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOKAH7+M1thr9krHJy08Jb9Rk+/v35Nu/5ciqFSxZnwEtIgAiCZaRm8wCpb8iFyo1J+FzvZZbgKqltKXmLvjRDvkIGDbq3vJNCq56LVmD8acik/2hP7qsMyZP3UKm8wv4ulY4dlC2bH0ZLD6/Mhms2WTlwC9NBNYU2nEsDyMcnSBr67jf+CKusBvLJOs4M+1jteS5GNVAtkfIvr2Wh658DU37oEWM7AEbXNu9Psf1VITLpucufI5P7IXScQ7fOyiU1nKgf5j5bhWn8YBqH7p0mqTFAjORyzV23WJZyJXH+37ZMFto2xUd0M+dc2ueeWpVc2SmNbA88tebX/92HNmvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cm/ME/xvbqXn2WbMRTFQhFUxTWC+ULDdRjv3LVVtisQ=;
 b=Kso4nSvP26XZDE+l+OJ70HmmUZoZxISLbIX7j1QT54vnAdU3nwONIRIXgYJqxgXPXKxbI2b3kV2IiFgM9ENbd8FCOrWaGMzpOwgLyroXeyEowrhH6yn7hYobsAcDA+ve9A/SailQCvv5gTTc+Ooa++XUU8yhvM+qKMFd/ohu8K+DoN0W8Z8nxL1ERv5TBpS6yxdjibtWutRkrkYlf54GKBWK2D+y+FznL85ICcu+nmT7wCViPnr4IoxPdRO7laLEpJM9SopXo/DglkxUL4Wr4SqXCbMzgbJqFAbx0wKmnCY/VRoqwtIqH5zAdY3AUWpUtK/eW2CADpic4VfCnPOaHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cm/ME/xvbqXn2WbMRTFQhFUxTWC+ULDdRjv3LVVtisQ=;
 b=E6OZSZFUjU9N2wbRezr9XAYVj17TYF+xmvvnfP7nxnnlVNarUwn/d+nmzJcGIhHBeKdlUJs586/HseRt+0QUaqR9CJiIkMqIE2YgT1KFxVkt5ZaD+ak/Y0BstP5A7CxyGkjZpbgRDB3GYnqEWbUt3raw1JWGWkIANazznflAGxA=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by CH0PR10MB5017.namprd10.prod.outlook.com (2603:10b6:610:c3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Wed, 28 Feb
 2024 20:17:44 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::210e:eea7:3142:6088]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::210e:eea7:3142:6088%5]) with mapi id 15.20.7316.039; Wed, 28 Feb 2024
 20:17:44 +0000
Message-ID: <353efab5-ee59-4bb7-abc1-b602db3306c6@oracle.com>
Date: Wed, 28 Feb 2024 12:17:42 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: Question about forcing 'disable-memdev'
Content-Language: en-US
To: Dave Jiang <dave.jiang@intel.com>,
        =?UTF-8?B?Q2FvLCBRdWFucXVhbi/mm7kg?=
 =?UTF-8?B?5YWo5YWo?= <caoqq@fujitsu.com>,
        linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
References: <3788c116-50aa-ae97-adca-af6559f5c59a@fujitsu.com>
 <dd61a8f2-ef80-46cc-8033-b3a4b987b3f4@intel.com>
 <ebe3f86f-d3f9-414d-9749-7d41ac7d3404@oracle.com>
 <86f8f0a0-3619-4905-a6e8-9fd871ec0a39@intel.com>
From: Jane Chu <jane.chu@oracle.com>
In-Reply-To: <86f8f0a0-3619-4905-a6e8-9fd871ec0a39@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4429:EE_|CH0PR10MB5017:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f1fa971-13ac-4b73-a973-08dc389a5297
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	MStJs2KPbvyK7xc/NjXCx7zcAFiOfybWHn3nUvpejamSx4dDx/cAkg91oV7Iu71ekefrDfktB3TL5vyWk2gB0SROGTpO8u6Umo632UZH6/XWHPCLqdBYdTiMzw8KXQoin4Vu+BNuJEQId/IgwslJIaVKA9EbHDMa5ya5em0E2S73PF5e7PLWSy07keahYpq0jU7L/ZEFb86OpxVRAAVF8WMOxFBoBM5UiFDA55FM+W2mQoV98gW+N3QSQKlbpG8eyEtomh5CpvDGXKCE9wF4sZz/8mGRdcHN3vERfJFu6L05FD1Da2Gmkfoy5rG4nLHoIZh7t8t6183/BFuNdym/7A8cbKfR4sEFwDKVd33kevVdm7qzTITrWkzs9m/jjl7I+Jk2LEeX8PyiaTbiuG9pLK4SqfMvHXY2rTebXXzdC9cBS0JL2VG+FG2ij4mAPKczuJ4NWqJXjeoMO590foom5O1KhP3ruZxk42js77dP7BGbALzJPz//4IXGP4KstanW45v9r6bl83mXZ6QTygBOrFv0Y+Ae/zQWxdqhZ+P79a0phaAR9yiaRu05q/yi9cvIsG1V7T+XtrT2MUUmr6qrKQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TUFoM2VCbEUrRDVocW5OSUY1OXc1YVdBRGh0aGxrQWNqVUVoYTB5QjFCRDBV?=
 =?utf-8?B?RXF5d2g2OE80WUw1ZkZiai9sVmppWVNOK1Q5VFAxZVNRQ2dnejhYL1ZETXVD?=
 =?utf-8?B?dDh0YS9QaVp3QVFzSDk4MmQwNEdxdWpEOGI4NmowWXhXc3ByVFhKS1oxcnpM?=
 =?utf-8?B?VGlBWFZ1MXJrR2VrYU9sTWs4bk5vN1FBS29JcWVoTGlGWGd1M0V3SmI0a3lj?=
 =?utf-8?B?ZnpSWlVFS2ZTZjFTV2ZYOEl5Z0l1N0R3OWk4UTdOcEdkaXpoaExtc3pjNC9Z?=
 =?utf-8?B?aWtpemlsaFNqZ3dIQUdVWlhSS2pZYkkvNDd0ZnVoTk92aU45L1pTWTYya2hB?=
 =?utf-8?B?WWxwekVDR1B2L0NLQXBnN0R2cnQyd01PdWMxRUtGZzJzTFhLSHRxNHFldlNS?=
 =?utf-8?B?S1RCYVJTeFBDWmNDNVBDem1Jb0J1SEpLL1UxUWdmUThybXQya2c2Qkl1b0d2?=
 =?utf-8?B?bFJpMFA3SVpSYzNsV2RRMTNXajZ5ZWtQcU9ocGdhSFhMaTIxbVhNWFE2bjZ3?=
 =?utf-8?B?TWgxdVBvZVVaMkliM3o1dC9wWDFrZEFORlZXaUtzMy9IK2JjaDgyRnRFZWhm?=
 =?utf-8?B?VE1KNFdXZ1FxZ1lGWjhleElpRUJyakQwd1BZYnFHN3I0a0xGWE1VN2NRdkhl?=
 =?utf-8?B?YUVvYk01RlowZVlwOXZTU3RHNWh0MXRCbnRkMFFxckt2VjlCRkpqV0JpckJ0?=
 =?utf-8?B?eG1Hd3dxVmlYNU9BTnloblBGc3ZidU5uTFdTNXpkR0Q1dzJFLzA1c1dIZkZR?=
 =?utf-8?B?TW8yVGFNcHRFZFVUNUdkOXJ6RWcvZDdib1JxOFJmU2dYbFhYSXV5Z0Vyc25F?=
 =?utf-8?B?OG4rd3ZpTVkwc0NFNjRIdmVXS2RMZXd6WnBlMWdVWFBMQ0F0SWZ6SVd1ZzRO?=
 =?utf-8?B?UHZrMGU1Mzg0VktTa3Q0Zmo3MTcxWlZqZHpoVnNXMmpTWVdYNWM5UUtjZVpq?=
 =?utf-8?B?VnBzbUQvc0JSTDlVTzBrNnlyZXpYdWZ4TE9xTXNPU0swd0M4YXZrOTE2T3Zt?=
 =?utf-8?B?SFpVVGpSY3JLaXlNR1J6RzgvQUtoeFlwRDYwR21HSVJuUzVSM1FIM2xCVGpU?=
 =?utf-8?B?VDB6bGlJR2VtSmZvTC9icFNFL1I0djNIdDIvWXZwWWwvbU9HN3laQnN5YzBL?=
 =?utf-8?B?dFlUQlVnbTlnRnBWZldHemdXS3RtYXIxck5jOHFDS2FsZDRIeWVncFkvNjNx?=
 =?utf-8?B?S2ZmMEQvWHJPWW1wemg0NWt6ajFLR1Q5WXN3V3NnQ2c3VlRJaktpczhUWFVo?=
 =?utf-8?B?WHloQkZobWdEUWp3aEQ1L3dSVUZucXR3TklZeGlXckJIQ0tiTVJ4NllWWUxL?=
 =?utf-8?B?MjEza2NvYWhaWVN0Rll5Z25NL2J0RXJEcDJkUXhYaVlRVE5pa2VsNnlzK1F6?=
 =?utf-8?B?U21Lc0tkbEp6R0cxNDlOdUp5UGUzdjdzdFdaeFhIM2xNNHliK0t5aDhjSHpU?=
 =?utf-8?B?RXRPSmZndDhRQTJPWTkwbHdSWVA1Z1MyejhJcWVTclRzTmFNOHd0dmVJcDlW?=
 =?utf-8?B?WktBVzg3MGx1LzVCR2dCYWhrZytaTE5rT3h0d3p1VzJ3andMZ1lUOFZIVWl6?=
 =?utf-8?B?cURYNVhxTnlFdDdGTXExYkdpY2VxUjc4MWg2dXJKUDlIbUNxdGtFSkF6Y2Nu?=
 =?utf-8?B?d29YUHkvamNoQjg5OWcyajdXZmhHQWVVcXlTN3ZTbW9IYnNCSVBjc21nYjlY?=
 =?utf-8?B?V1pGUmtDcmRvTzI2b1BGdjZ2ZDNHSGU5a1hLVEpyWC9TRW9ZY0Y5YkVseUNH?=
 =?utf-8?B?c2xUejkvczAzcnlkOUFVUTJlTUYwN29hdjF3em5aaExCUFI0R1dPZ0l0cDFL?=
 =?utf-8?B?VURtMXZ1T3Nna2h4SU8zVjh5T2hrbE9mMVBHME1wOVlxdUVhd1g5bzNFeFBM?=
 =?utf-8?B?cFdqZ01vc2ZlTm5QUmZCZnEyR0xFZmFna3pkdUh2Ty9qZzYvQ3ZmZXd4Q2xT?=
 =?utf-8?B?VXBSTzR1eWhtTmM3WUpHKy9zSURqTWhYdU9nWWpnS2xleGxXbTIzMW1rTDhh?=
 =?utf-8?B?Nlo5VmpBakFHUnFnMlpkV01BL3VsOHVrdHZmMlMySjliZ1czT1hkdmhzekZ3?=
 =?utf-8?B?UUE0TnZXODh1dTFsTUR5MExwa2xRTndkc0RMNWdJWTdWSHFvZUdZaUo5WXgv?=
 =?utf-8?Q?5oslP6umnSW9wy6T5+i1Xs3w0?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	z3ZUjou+a4GmLK3CrjEZ3nfmCIkQk68ISS4cHjixNi1NpGDS0TG0vcSfqWXDzf/LpqXPYGZayEWXU9oHTuvSwse0uQ+nRygILAEwNQBTReQvjqhkow+jRqmlR/gcTC+WSsMkLhI/FkHBCUtZxGycWKOuGLyMCE1MeEGowcrTKRU3MO+//upRcmZfopJeQR6hZ5ejSzpyklmIPOFn0ICPJTC8oWkWF4+UEYG8WVOq9Uxhrle/bKuTVNoyNMgrvLr6BTEbz+4xRoeTCb9ybhSjA1+mXMGzVVodhaaBXbWdmU2aJH+mq8eH+OCAZiysoXrzz0I6efNeuNjT1sIoRr+MXvdvoqckTlaAw0bhHK0fe0pAPaG/wJ6l3/oc2NOn/j10clw5/wdbUItK6JIlpVisfUMioEg/fZfR/q78hH5NGNiVgwtQH9lth2tOniSNZdkEiJ+nSX5WTxrcgXZPj611ane9dYNlzsh+pxe8rreVADY1Szfvv1qVENXG7xjr0wkPZdOw3JnfFnnxAJ6R3E7Mo/m74dMT4vZKo4NVfDXZtuqMqkNAsCl5nwdepmQNHIwxB5F1lYCZ6GzExyaS11v+Crg8D3rL5N057p1ELk28ibg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f1fa971-13ac-4b73-a973-08dc389a5297
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2024 20:17:44.2806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m8v1fDwFNVYKRCd1Su9VucrTmgimUe0dEtt0TyQVAJ5OHcRRCOKJIiilpGUg0DWAV/pD094ouchqFs0RvH+pgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5017
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-28_08,2024-02-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402280160
X-Proofpoint-ORIG-GUID: UWyCF5nk4DZo1nHuJdP-icEvWe5YvGAq
X-Proofpoint-GUID: UWyCF5nk4DZo1nHuJdP-icEvWe5YvGAq

On 2/27/2024 12:28 PM, Dave Jiang wrote:

>
> On 2/27/24 1:24 PM, Jane Chu wrote:
>> On 2/27/2024 8:40 AM, Dave Jiang wrote:
>>
>>> On 2/26/24 10:32 PM, Cao, Quanquan/曹 全全 wrote:
>>>> Hi, Dave
>>>>
>>>> On the basis of this patch, I conducted some tests and encountered unexpected errors. I would like to inquire whether the design here is reasonable? Below are the steps of my testing:
>>>>
>>>> Link: https://lore.kernel.org/linux-cxl/170138109724.2882696.123294980050048623.stgit@djiang5-mobl3/
>>>>
>>>>
>>>> Problem description: after creating a region, directly forcing 'disable-memdev' and then consuming memory leads to a kernel panic.
>>> If you are forcing memory disable when the memory cannot be offlined, then this behavior is expected. You are ripping the memory away from underneath kernel mm. The reason the check was added is to prevent the users from doing exactly that.
>> Since user is doing the illegal thing, shouldn't that lead to SIGBUS or SIGKILL ?
> The behavior is unpredictable once the CXL memory is ripped away. If the memory only backed user memory then you may see SIGBUS. But if the memory backed kernel data then kernel OOPs is not out of question.

Make sense, thanks for the clarification.

-jane

>
>> thanks,
>>
>> -jane
>>
>>>> Test environment:
>>>> KERNEL    6.8.0-rc1
>>>> QEMU    8.2.0-rc4
>>>>
>>>> Test steps：
>>>>         step1: set memory auto_online to movable zones.
>>>>              echo online_movable > /sys/devices/system/memory/auto_online_blocks
>>>>         step2: create region
>>>>              cxl create-region -t ram -d decoder0.0 -m mem0
>>>>         step3: disable memdev
>>>>              cxl disable-memdev mem0 -f
>>>>         step4: consum CXL memory
>>>>              ./consumemem   <------kernel panic
>>>>
>>>> numactl node status:
>>>>         step1: numactl -H
>>>>
>>>>       available: 2 nodes (0-1)
>>>>       node 0 cpus: 0 1
>>>>       node 0 size: 968 MB
>>>>       node 0 free: 664 MB
>>>>       node 1 cpus: 2 3
>>>>       node 1 size: 683 MB
>>>>       node 1 free: 333 MB
>>>>       node distances:
>>>>       node   0   1
>>>>         0:  10  20
>>>>
>>>>       step2: numactl -H
>>>>
>>>>       available: 3 nodes (0-2)
>>>>       node 0 cpus: 0 1
>>>>       node 0 size: 968 MB
>>>>       node 0 free: 677 MB
>>>>       node 1 cpus: 2 3
>>>>       node 1 size: 683 MB
>>>>       node 1 free: 333 MB
>>>>       node 2 cpus:
>>>>       node 2 size: 256 MB
>>>>       node 2 free: 256 MB
>>>>       node distances:
>>>>       node   0   1   2
>>>>         0:  10  20  20
>>>>         1:  20  10  20
>>>>         2:  20  20  10
>>>>
>>>>       step3: numactl -H
>>>>
>>>>       available: 3 nodes (0-2)
>>>>       node 0 cpus: 0 1
>>>>       node 0 size: 968 MB
>>>>       node 0 free: 686 MB
>>>>       node 1 cpus: 2 3
>>>>       node 1 size: 683 MB
>>>>       node 1 free: 336 MB
>>>>       node 2 cpus:
>>>>       node 2 size: 256 MB
>>>>       node 2 free: 256 MB
>>>>       node distances:
>>>>       node   0   1   2
>>>>         0:  10  20  20
>>>>         1:  20  10  20
>>>>         2:  20  20  10
