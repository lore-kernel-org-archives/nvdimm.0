Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1BA79D1
	for <nvdimm@lists.linux.dev>; Fri,  8 Mar 2024 00:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709857858; cv=fail; b=dXY1QYWbyoU7UGoaNrh8FPPRRiyeUSivvHD6N0SJDWGnCt5L03BS8gzIq0Yz4+ag52GHak49dRmRAYaGFRVJ8EiPAAwPAnp4toL8iBsNmccEYuv9Al0b1QQ/PkM3ldAvCjMVII3Zd976yq0sOokhmnujkKxrX/o9VgP/qrLNOTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709857858; c=relaxed/simple;
	bh=dZ919CNpPFxM1vtF8tdYuc4ea39OfSyjO6Gy3lIVZJQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u7eKjmrEFFoedGvMzYS9/3u1HV7Q0KyF9VtlKMW/wPoReW3qzdvT/AZ79gl9x3cJPyXcEWQFlKuSk7gHg9Ey9RRe/lupYP3O/HcLdDqEZR3fmE7hBZWXYln4dvShZDba9MPpWgmlvglXZ/9PgxYLqstu6bQu0oGeFYRpJIB0018=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VaieicAg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=se8r1oKq; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VaieicAg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="se8r1oKq"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 427Jho28029434;
	Fri, 8 Mar 2024 00:30:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=kkt+0FPm4IzNIxZHvCiNP5yGJQyBZx4iRJ2bcKNCv6o=;
 b=VaieicAgxLiDS6qicEXpLY4PpYavXe13TfEf4UKsauoGnj+v3ZthHdAMLZu6qKtZ/02j
 XZtnDSOg6+Pnz8zF1q3fyD8BsEzbbpvpAlint9gHOcus81oDLZwBybxu16J2K2Un/Fa8
 jTQh3QW2R3G7MaNSK8VfqSZro1jvliGJuxjb/lJDSlkm2oiXI+z/QOtyHpsuvCoIHMc+
 jbNBCYQuHXKZdyrl4vZjKouCCrn/RSdB4GAlBDSbTUchRAilV6W5MVd+n9j0ZVXCCAtL
 Ar/vKY0Na5y8Wvr9YvZTmXdPZZiRmp3yb+MJNG0wXwpcopGchvvb3ti96cgd5g6HyznO nw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wkthenkux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 00:30:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4280CDu5005403;
	Fri, 8 Mar 2024 00:30:48 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wp7nuka50-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 00:30:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ikx0CS8BM3Aw1o3bWBjzGaA3BF3eZNMsyRoMHsSbU8q4kq078v1Kr9mYs8CuWdv+Djv9Y+cDj12ObMO5S+v7nsBVgpwo3SV4GG5J0VR7QRW5IHOtl8ZnVd+7vCytTvulL4+TJ78rmrHiWs1+J7vlnqTr5A8dcYx4O6r1zRuStU6314+H6Gt3l2gb8VriwrnsrpEScPmYjz3euUMyCjmWrSbTbf9LwXfVijQbst8R8tEmCCELdnGpovyJjXy+7EVK0gUamEc8EF4kIsxoKEEeqvHKVCDPY0Rj0Bx5HQYR86Q06cOxurGq73aAhdle3fJd5cKHnvN/KqRkmLu2Y3OK9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kkt+0FPm4IzNIxZHvCiNP5yGJQyBZx4iRJ2bcKNCv6o=;
 b=FAERBkuaFrZ5e2lZVsXxsm8Z/YbEowZ5bYObfVGkWyOpFBgXPdMKLrcez2sq5xtdRV5RR4OC6P3j+KcgsuRT2+krcSwEJN4BpBn9yI8kKVM9fT6kLIYUw/oAwZTBbvpSuNqBsV145spT7CfaDdTwXdB7gjO8zeNLunKY0VoZIiKfGQPDBxCWZTBsPKuy2UhxpByTRCSldH2AZtQNMQR6PNHIrNsnGwBwuGYB/1mcsntwL6DGdZmGKZGeT0f7t+EfvoIqKvKnw5X7C4ztmmgyrOnVihxdWP4Tk74JE9OFNqbLaZ5xk4MDaboddwC4/9bBymfl+GxQxkSycxRVOHncjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kkt+0FPm4IzNIxZHvCiNP5yGJQyBZx4iRJ2bcKNCv6o=;
 b=se8r1oKqwGgJqSJaFkIasWtuLFkfCSjE7FX9Nu/p5mmmyUAgqem5eV5N7MSBtVkwxuOMeyfyoi/IhDJUFtyCWOng1zmPanZ0LYgbA7GFFcCc466E9rrO9ygdo8TURhPpzpDL1nRj7dNxQ7UDLwWW6rEZDd85VphjZ9b3j8a2aXk=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by DM6PR10MB4169.namprd10.prod.outlook.com (2603:10b6:5:21b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.26; Fri, 8 Mar
 2024 00:30:45 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::210e:eea7:3142:6088]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::210e:eea7:3142:6088%5]) with mapi id 15.20.7362.024; Fri, 8 Mar 2024
 00:30:45 +0000
Message-ID: <a0f62478-94d5-4629-8a81-81d6876beaec@oracle.com>
Date: Thu, 7 Mar 2024 16:30:42 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: Barlopass nvdimm as MemoryMode question
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, vishal.l.verma@intel.com,
        nvdimm@lists.linux.dev
Cc: Linux-MM <linux-mm@kvack.org>, Joao Martins <joao.m.martins@oracle.com>
References: <a639e29f-fa99-4fec-a148-c235e5f90071@oracle.com>
 <65ea2c1a441d_12713294d9@dwillia2-mobl3.amr.corp.intel.com.notmuch>
From: Jane Chu <jane.chu@oracle.com>
In-Reply-To: <65ea2c1a441d_12713294d9@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CYZPR20CA0022.namprd20.prod.outlook.com
 (2603:10b6:930:a2::21) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4429:EE_|DM6PR10MB4169:EE_
X-MS-Office365-Filtering-Correlation-Id: e0e2a680-2ab3-4521-a7e8-08dc3f06fe4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	s7FDMKzy8HPP6rBp1qkwOBChHJzZnOynQa+l0+Bji9v/PrB11kBJyOtDfxNAoTdG3CCjqJPY1lMaRRKeET+49R91WLKcN7Qt4hE/La6k6blsgy1nI3yKvlCdFAnmZXXTzz1kPIDVxGl69R6uM9d4YBhA5d1j8b7sSrbJenCa/C34aPVwjsoZrneO4uZWK1XNPdXc+Gu+dkUEER8/S99OYuKHnh/LfqHe4b29N7HQPkXcpsNYtDtqrjxOzT8HxppiAsMZecdwnLGNkrg+UsCmWymki8cTwS02ze2eTfxJS2dzso45C0cWZvUMiHO4f9PXPM2rQxVlg4OruiBUgizMDrT150mDytyeLAbM6qosdRcWzBsr26fG5O7dV++e9QN3rFRUS49KhIbmbizmyV5yhMYnh9qGBzwk/OPSgkxBOKe6Dz9FlBP38Z61OVb4PkBkG7+wghTHh+d0NFBQSolbc+IuvWocd1pao4sV1W+j36UfawxfhZ6YmGxleInwdaij+3DI0uTe1/GARYXpcKe/HSvb8AlkvnSkicGhDLy+/A/XrLw+eue1pFfOPxd4z+8sPwObtXLkD6RRG8r/mhvG+4mtX1A4KtNecDhPX8zqCbMRz/ry6i37K35BsCkwQqI6s5pWYT5O5f8j/Wnu8EKTUUVlR7DWS/hVOmaKEEQlydE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?T1I5ZUhtbnUvSmZSSFJBTGdxQUVBRGdrZ1dnT1FpUTFmM1NUU3c0NHBudFhU?=
 =?utf-8?B?TXhJemRncWkrSk9VeGhLbVdrN2NvMWtIaFI4VUcycW9HckNST0t0ak0rVjdl?=
 =?utf-8?B?bU82Umx2UUFXYjFvV04zOVo2ZkZabER4VFYvMXkyTzF0NFdtcHN0R0NoY2Mv?=
 =?utf-8?B?VUlXQmliQWFxdmg1M0xJTzlwZGxKUk1vSlZDcDBCd3hjM0xiTTN5dEFldGhZ?=
 =?utf-8?B?VFdRMURsR25Xd1BKRUp5R1JOdjNuOE4zNjljL0VhT0d5WmIvNjMyNmdOTE43?=
 =?utf-8?B?OENhNk9qbEF4MzQ5UTY0enpFOVUyU3liQzd3VnAySDNzcyttM1FwVk5RMW9M?=
 =?utf-8?B?NC8vWUtDclRxY1JwaklnVks3ZnRNeE0vNWhXMGlhQlBHbVZrL0tFd3NqVVlC?=
 =?utf-8?B?V0VGTUdxelNVR0dKdjdlY09SVGp1VjIyRFJDdEFDUVpGdW82NEc1NU5SdnU1?=
 =?utf-8?B?VjlwdFZIWkRFZnY4dmpxcUxGdk9mZlBEeEJMNkVlN3JrVlc5NGxKVFoyTWM2?=
 =?utf-8?B?NTJ2czlPOExMZ0VHYVZQQlVBcFBwVzdkbk96bEJIQ1FLS0wrUmpsZVk5Z2ND?=
 =?utf-8?B?SklmOC9lRVJLODZvd0ZoM1lGREtkRlFHSC9wVnZ2dHV1b0E3Y2ZoTFNFNHM1?=
 =?utf-8?B?TUFuNVRoTzhRNzR6czhBVVczaUtPZnlYRmk2YWNqak14anJvemxySzJUczVw?=
 =?utf-8?B?dUFVN2Y2WGcwbTQ0QWFaNlhKZGM5aTA0MXhQdC9TZ0hyOGZuZGtwNUMwNjJm?=
 =?utf-8?B?VEpBdzhnQU5SWndaa2hVME9SaENNRzNhT1lNSjZwUU1UQlgxOSs0M3pCS0RD?=
 =?utf-8?B?YisxalpGTlhxNkY4RmQ5WFJmamFqZTI5a2FTSStmbkNWNDBRZEROZEVlNVhF?=
 =?utf-8?B?SzhVVHJNQ0JHZVlMeTA0SHNHSVo4andjSXBFTzgyMU8zMngvZ2d0dkVZdGxp?=
 =?utf-8?B?MkJZVHZBeE1tWGJJOTh2b1dHTW16QVRvZm9DajB1cUFNMStxczhKUmlpamV1?=
 =?utf-8?B?YVB4RUFtWldDa05MdTZuTTdsYVI0OEp0RjZGTGxrU1VuWEJ3Smo1NGlRNzNa?=
 =?utf-8?B?enRxdUw0V2F6SWxROG4vRE45WXRaNHY0NXR1RXZmTUl0b1FtOXpOdWU3OEpH?=
 =?utf-8?B?ZEM1UDBCZk95eWNPT3JDU2V5eFFEajFhMEVOWWN5aVd0dHJKRVNYWXZMMXVG?=
 =?utf-8?B?TjlmUE9xYklZMnBKWlNFYUNjMlo5SVFnZWFGcW50QkdncDIvdHI1QWtwanVT?=
 =?utf-8?B?dGdHTVlQendZV2h2MnFkSzNhYVNnY1pqMHlwM1pqajBQRTdESS9IQXZoTVBL?=
 =?utf-8?B?NmppMU1oaGFnMEhrRTAxWUpVemtSc25PNkJCN3pxbGVoMVN1SzBzdmJHMFhP?=
 =?utf-8?B?UmlKRnBvSHE2TmNxRlRSS1hxYlBWa21BeVVxdk55ZkpaNitYelRSU3VtNEFa?=
 =?utf-8?B?aTRibjAvL1Z2ZGlWYVZKVTZ1Z3NZNU9nZHpvZUsvRm5PK09VOHhFaGZrdS9a?=
 =?utf-8?B?UG9LWlI5ZzZMMHR3ZlZQSGxKN21ndFpFbTdpWUZqcXRQdEtkOHFWbzU3NTVD?=
 =?utf-8?B?MmhTR1NpaTE1czRZbmlSRi9IczdhY1Q1dmdFbHl2clBrM2t0YmZudHY1VHdk?=
 =?utf-8?B?M0JwdWhmRHdBWkdmQm9GeDhVNFA4Zit5d25kWk1XYW5tOEtxU0g0cU9wMWc1?=
 =?utf-8?B?QlE2WityeEp5cHJQNndmbWdHZisxaXJzdFQ1ZDFEMVl1OEFGY0pxTlk3dzJk?=
 =?utf-8?B?L0ptQUlxdm9DbDg0QnlLNU92R0ltTWtVNDlBcW9wbkRQdkhlcU04cUh4WE9w?=
 =?utf-8?B?ZjlReUtvcXR5UVNpaHQ3NGd0L3VXYk1zb2N3bmxSdDV6a09PandvT2NqNlZJ?=
 =?utf-8?B?K3c2dkROMGpaRko1YzBaSHBGbHlmdmNPT3hLbHlqMlJLYVlUTDltdlpNNWJy?=
 =?utf-8?B?d3BZT3ArMW1ZNXNmQy9tWEJJNlN6a0pGZGs2OHlIektNdlgwUkZXYmphTFY2?=
 =?utf-8?B?SEs4WVJJekdhTHNoR29EQVhaNy91dEhwNlVrdjZDYmEwSmV4ZEZBWkVpY2JD?=
 =?utf-8?B?R1BpbFFoWnVrVHd1SU9XMHlxY2l1WXJqR0FkVWdhT0NqMEU3ZnBad2VONWUw?=
 =?utf-8?Q?4aJuq/wbVASiPLa59HC89cYSY?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	pwblCRHPy6t5u+KTQ3fFPpWycoO9+SuBO6e4OXIa25gfB8ADRdLEJntV8pW2jOoTQp1SqRLaBR3sYoeOLerzEe1W536zpNlZjef+O+7L/Vc9YGo9QMYUEKySPDqQ9tY7ml8rU/F04FxJOrKwy1tfR23Pm6pIukVqw6LM+UHN/+JkBvA0vy8U97wFh4rvB8tvt3nI2cEp1DLzc/b7FIPCw6JR6YBW+bZNbUGJd2prqfScWdZ+0g9J0tlUZOHt0+KMvLsiaoSuPeTXty9vI9YQwI6cJsSmdrnr2w2cx/foiMhwxUo13La1z+u5KZeHEXDHjWiC+X9RjF4ijvs51Vo1QQDJUa7yMX13StXByKTFzWDtDmm423AvzL0+XQBk0X04EBQuTnMdVTafQQRr8v7Wx3jyzJmW+qTGUd0cFj3J+EZqPytlPDCRPdpvLPBuWq7h6qhxlO2xvXxDQg8u73fRes+ymVgvIj7dEQQ9QiEmgae/w1A6MIz7J1uIDtoNWG1EXN+UJ8mPgrJYxMBtHCEnJ+IVyKySy0MDMClgvo3eAUn5vu8ndxbgKfWRacLIqQmXlbKZKWdN70TY4vdd7tmKaJfzFDOcGWhntX9wZWhTv8A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0e2a680-2ab3-4521-a7e8-08dc3f06fe4d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 00:30:44.9914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TZBGYTSn6wdTODP588hVASOJVFcrQVDC184UK9IV12/SS6lbnMPIsCl69VQ8I8foeJNm9sEOOk9IVFXpvGFC8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4169
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-07_18,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403080002
X-Proofpoint-ORIG-GUID: z2Kwo-H6Ncgh0FFjnZKu91AH6Umj9gyC
X-Proofpoint-GUID: z2Kwo-H6Ncgh0FFjnZKu91AH6Umj9gyC

Add Joao.

On 3/7/2024 1:05 PM, Dan Williams wrote:

> Jane Chu wrote:
>> Hi, Dan and Vishal,
>>
>> What kind of NUMAness is visible to the kernel w.r.t. SysRAM region
>> backed by Barlopass nvdimms configured in MemoryMode by impctl ?
> As always, the NUMA description, is a property of the platform not the
> media type / DIMM. The ACPI HMAT desrcibes the details of a
> memory-side-caches. See "5.2.27.2 Memory Side Cache Overview" in ACPI
> 6.4.

Thanks!  So, compare to dax_kmem which assign a numa node to a newly 
converted pmem/SysRAM region,  w.r.t. pmem in MemoryMode, is there any 
clue that kernel exposes(or could expose) to userland about the extra 
latency such that userland may treat these memory regions differently?

thanks,

-jane

