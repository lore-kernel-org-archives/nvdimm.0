Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07852C9C
	for <nvdimm@lists.linux.dev>; Tue, 21 Dec 2021 12:54:41 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BLCdx90008248;
	Tue, 21 Dec 2021 12:54:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=9jql418Ayg2thiHbmao6Ju13ZForeMUggSGSd68EkAc=;
 b=g9lhqfSsvisevJWLVOOQDMCPW4L0NxYN8JPV4TeEFeCqEXvWroJaUHCfCs9MGV7ncy7G
 6HdxmmOGDVjM/LmXQIeetT8KMEA3uwTfomNQvVV49mkieyTAN/CcEqHcI08i4hqMJpxd
 o2S8ZK/LTdmtTUERGhVXXxaaiPKnXg10td5/4TSwFXHoMjqwPSocSoNn0KrQJH3NFk7w
 DM0dxFxUY/nnw6t2NcBteVdqu+AVUODrMoJmWOe7/7W1CjA07q/YURS9hxfBJRRTdX8h
 V6pgDDumJZLTRWZx7DuzufubXCZOZIBHK7NiFa6iNTpEm39vhhu2xw7rwxe2hxZl7thY CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3d3f4mr0yw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Dec 2021 12:54:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BLCkwVk074920;
	Tue, 21 Dec 2021 12:54:29 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
	by userp3030.oracle.com with ESMTP id 3d14rvemqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Dec 2021 12:54:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bfhj4zTZYdnbD2fW28ayQkP3ENKaW6MS94DxwCfXmroolGiBiWhEHCjcT4uroN+0GUVQ6veeZ2ZPieuBMviuzaofODy3VPtPggAlEA/t45XDOb/CvP/pr7WC0tcH/rfAXAxFOi+CB4VvO/pGcWzXWh5QiOYqyXaTg9HBOw6jVt1PCkVRGaHwF+K7FViMO/mj0hqXXbQeIM3peiZ/nQMCPTRvIO2eFqDkoz9DYEJIINP9ey60RnAfo6V5rNaSHpIaDehYNqHS07a41v2pKIIWydofB20gTR9aFBUBFDK5+F4xeTb8j88pZ6cejjZxLh9HDPlaFr4bHVrjp9jjth+7rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jql418Ayg2thiHbmao6Ju13ZForeMUggSGSd68EkAc=;
 b=X2dQa1L+z4DWB/IKbxXVQMQOlQw2x8ppaVtUwBLfoEXOtTpO7J3J7zs9foFuqxwuaCk2c4HwgmU4drkkLxp7QXlu8nCerVjQ5zG+roFIsOQvcLZmNqyZOfDiKuImOKfmmWxzBZIP8CC2d0zIpbtnLJst9rOuhfmy3MTB/T0fDztPn1uNrOE7E1BtkZWjqS3TBFRSQ9yP/6PA7cxETxutjDc706il/fh12T2hmtLi60oITBak/oGn583IOnI2a2YsXegQ6JvJ1g9U+B9JU/G2w2l9M7R7el3OkvZI4ZN9kueC2k+vGub4uVpDHdG56vINS33JJFK6iH+3ZrH+aG0euw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jql418Ayg2thiHbmao6Ju13ZForeMUggSGSd68EkAc=;
 b=fZc4DmlLwopF1ykipx3cSjnIQa23dP61659BzK2OA8OwgsZTy23ZWIW4a9CICC9A1JoDcPOJqNmmFmBpVtVuBD2vr8cVl/Ak4WaPvhEcHf0ShQ4iV0REexNKglcLQgz7/OWgiSa+3j45BWTSTt81NXnJF6BZZA9U8K+jgUnezus=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4206.namprd10.prod.outlook.com (2603:10b6:208:1df::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Tue, 21 Dec
 2021 12:54:26 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09%7]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 12:54:26 +0000
Message-ID: <6ec4f7a1-c597-4830-4ea7-216ca87d5247@oracle.com>
Date: Tue, 21 Dec 2021 12:54:20 +0000
Subject: Re: [ndctl PATCH v3 01/11] ndctl, util: add parse-configs helper
Content-Language: en-US
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, QI Fuli
 <qi.fuli@jp.fujitsu.com>,
        fenghua.hu@intel.com, QI Fuli
 <qi.fuli@fujitsu.com>,
        nvdimm@lists.linux.dev
References: <20211210223440.3946603-1-vishal.l.verma@intel.com>
 <20211210223440.3946603-2-vishal.l.verma@intel.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211210223440.3946603-2-vishal.l.verma@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0079.eurprd02.prod.outlook.com
 (2603:10a6:208:154::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66cf3ecf-f743-4b70-5bf6-08d9c4810527
X-MS-TrafficTypeDiagnostic: MN2PR10MB4206:EE_
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4206A5A5ABF141AC429DD8EBBB7C9@MN2PR10MB4206.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ayQzaUoe8h4BSxfYyncvJF4HEm0J8yk9u1xCODUkLkbfvzbz6HjgCli15apIgaJ/rJHWKdek9T75lTzds7E264ufIPRfBrmsUNy1nH/7G2MNgo56JvBjncE9/yJ1+PZczBThXPvlJKV18yG44Ay2HuZG+NZYbP1EOTFPXme/nxLm6st4vbDzuM9hBxbAprYQgdpG9S5XXl0UYG4IcSKxyHTGTK3YAKzt/hhGJc+HB48D0ExFnZN7SNQ3NacJ7MGgrisHuV+b/92/LB6V0DIvl1aMryHU7m9qyGwvEiEnAxxZfoY3cQr/OnLe5WNy3YacrNO/P9B0TQIealqxLAoZHaHqMb+b8S3lET3/MxHSPvzWtrUeEbiwe1qOiCgnNEt++/OdbQuYXKWnosUdw6VszdsTUoOJWc8D9c+Mz5B48MXbZ4EI0yK7nX0SGjtIczsU7aRcGs7J0WlAUAK8QjaZS3U++rGpJtRVxAlXmyzlBh4ssbM/XrE5L0/sFkCKwdfmjbTYdQjxfpaab9kT4DQRYvH6NnNRP/psiNvTlb2W8GnMonvm2ybHOtuith0IdBSP37dh2Zu+GWeQfEFRxJNoSBEbH9ftaR+Qr/4E/dWe0ocA2vv2TuvL5SWDbk9UGkwG5h3RxP3+J/Xj6MnuT7NbwKbkyzNoQfeq7bA0wiS7ayHNRSI/W01Y+RNwPSGQ9U+ybEIV7BX+X/6F4/kWSflSWQhG37tlrxdKv8nh1CtoNprk/xcePv8x6tMwlsNsuznl6oSPdyAHIqS42MopNV1aZl6hgSDDk/Ku9hPFoOZKUWvPMmV+bFpajAmktIQwEjMzn8Q4G2A0e0azt24JWBkXGQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(83380400001)(2906002)(38100700002)(6916009)(54906003)(66556008)(4744005)(36756003)(26005)(6512007)(66476007)(8936002)(508600001)(2616005)(186003)(31696002)(8676002)(6506007)(53546011)(31686004)(6666004)(316002)(966005)(6486002)(66946007)(4326008)(5660300002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?eGxaMk45QXJCMjRyMGdrTzA4cjZUUmU3TDl3aWVjOSs5NitVUWx4N0FSSnBp?=
 =?utf-8?B?L2kwZDhRWE1xcG1MTnl2YjRtR1hPUXQ5bCtYZ0Z6Qmxad3pqR2tVUmhLaE5V?=
 =?utf-8?B?V2VCNnRpRzdydHhReGhjK3pEaUViUkRFUlpHR3krUTIrYlhmVUdXb3RBb2Rw?=
 =?utf-8?B?TW5SOHhvRCtrSVFPY2hFcStsRURPRDVPTittVFlIMnJPLzd6d09CcjZhR2dZ?=
 =?utf-8?B?Q3pkWHE4NGtCeDcrRFRmTUtCT2JsanlWN1VnTnc2Ry96L09MS3htZGRoSFp3?=
 =?utf-8?B?R1IrTmVCdjVaVzBmV3VEM1RTcVVvcUNmbTFpcVFteXAxbXZjL21YWCtsYTRW?=
 =?utf-8?B?Y01TejBKVEMyRUJhVUpiek5TWmVFR0tpYTJtMCszZmpHaWFPYWpCYmxCcUVl?=
 =?utf-8?B?aEorU2UxWUNUNXZpeXFURDRFSFI5WVBFaGszc0FnSTdBLzlJMEo2QmRXT0Iy?=
 =?utf-8?B?Q3U3YmN3TTNEbU5KQU0xVXE4aDJaOWhVOWdtajd1VkkzUFBaMmpEcWZWMFVQ?=
 =?utf-8?B?NW5Xb2NmZFVwTTAyOFZNdFp3T3NrcjU3RE1hYnFwWW8zaWZGdUtRSUh6QVQx?=
 =?utf-8?B?T2p5VlpJYU1ad0pHemQ0SVZvMnI0eStJSDRoNjA1T2tWbzNGWW43VGRnWlNZ?=
 =?utf-8?B?TUdtRm9ObGV6Y0ZuTE5lZXpHQTJEWkRuYWxsczFNZmVaSzlVWVp4UURDZXdW?=
 =?utf-8?B?OExaMWVaSFJ6NUMwVFdlY2Q3N0l0S0xFRXlwK2JhVHNTZEdhVjhMUEFndnNP?=
 =?utf-8?B?V3NVRFVEM1BDQzRrM09kOFlEVzNFRjZNOWNBaHB2Z3NobFdMWWk4QXh1b2FN?=
 =?utf-8?B?L1Z6d2pLdzV1MDFldHE1MTFmNXhYVzBOb00xS01Zdkw1VWYyUWpBOTlnYnRB?=
 =?utf-8?B?dnluM0Q2ejBJUHh2V1NVMjRzQk1TclNRSjBudDhRb3hxZEdzRFZkWWdPY1Zh?=
 =?utf-8?B?R2YzYXJFUDRmRUVkZVVkMWtlOHBxL2FoZVlnanRoQ2hWcS84MVRDNnJDTFF3?=
 =?utf-8?B?VHQ5Q2hPdktzc1RwM1QxM21VVnduZmZtY0puMzhKWUUxNm5qUmhtUXRLRVpi?=
 =?utf-8?B?UGltendUQzZwWHFzTGl1M1dFUGNUTTlQZ3IzNFFDeCtmVHY0UEhYblZXaEEv?=
 =?utf-8?B?TWFvaDNQcjE3SWpkb1kyYVdIT2dMeGNYOGZwRDlrY04veDYwcnJCRzVxL0x4?=
 =?utf-8?B?RjVkaHJFMjdYdngycS9Uenp3NkNvR1ljdFV5M1ZsMGlsOHFuVnEyYWQvZDRY?=
 =?utf-8?B?cmZnZEtqdEEvM0tuazdUMThleWZIWUd6OWhvTyt0aFVYMUwrZm8zT09qWDdr?=
 =?utf-8?B?bFZxbDExVjQvc2thRmdLbTZ2M01YTmFXWTk4ZmU0blJ1STdvVm15b2dEOXVO?=
 =?utf-8?B?NTMxdHA5eWxjeVFnYUtMRkxPeUVzUGt5QnZuelVxVUNnVDI1MDRhWU1zUld6?=
 =?utf-8?B?bm1CVzlEcFhSYmlQSWJjUVg5a2lROVJjd3J1aEloRzRHSTZ0UmU2MlhwV3kz?=
 =?utf-8?B?Vy9VYVEwcEtKNGd0blEzdnBxV0taeVBBSU1jWlM2TWUweENMTDJ3amU2b2Qw?=
 =?utf-8?B?YTVDUmNmZU8yYmlsZEh0UDBpSTh3dU1GRU5teWtJZmFmTjBNU0ZQY3BZaE4y?=
 =?utf-8?B?WVJxclBSb3lsL1ZtUzZFWCtHSHZYakh0ekQzb25QUVpuYUdZckIyYXYrVVR4?=
 =?utf-8?B?dnlkdTV6a2dKR3haMm11TXpTSlNnbFlhMGtMalVibmFZYUFNZmV3enZMdzFL?=
 =?utf-8?B?MGlpZDhWVnBrbzR1S1pQTkJMYUttZEJ3Q0RyNno2d0hYTFU2THRHa2FMUHNI?=
 =?utf-8?B?SUZGZ1lOZWc3Zmw2NXFMV2s1TTBjR2MvQnhtSlBOSjlsajZQMUZGOUVXd0FX?=
 =?utf-8?B?TjVFNndoU1IxKzV3bkx3NEZiU0syTjd5aGRVdUxiTURkRzhIbndiUGZwZndm?=
 =?utf-8?B?bjJuWExnVnlhSmVXOHo4NGhkY0Vxa3FJa2JzQ3hSNDZtL25UNlVhazFlNFRD?=
 =?utf-8?B?blJGaGpscUFMTVBXR1d0Z2s3MVVUV202UUxFQy90alczazIyMFZpQUpONyto?=
 =?utf-8?B?ZVZBeERtcXZSZEV0R1llenQrakllWFMrekdPNUZjWElTREw3SWFSRTBKWklZ?=
 =?utf-8?B?MmNYQnhzREk5anVVV09NVVd1Q1BzWWJVRG90eUw4UHFrWkc4NWVNdTJsTk5Y?=
 =?utf-8?B?aENOb3VMcjVsLzc3bGlFQWpwOHFUb1VyZzNJM3NvSCtxU3ZLOFdtL2JrQlVp?=
 =?utf-8?B?WXhFRXk0UzJreEZsOEdGR09Cc1NBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66cf3ecf-f743-4b70-5bf6-08d9c4810527
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 12:54:26.8750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CpzzSKtO/O1nvEvT7TV+gSyfUtrLz8E/5jGxYjymEvbqZiuiwjMhU47T+zi+3sHh0Yw7E3GEKu3ojUyxtBJJJnGeIxzA1Kxmej7ctZ5nkHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4206
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10204 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112210058
X-Proofpoint-ORIG-GUID: ryeuZR4WSnuBrdv23F9oVhOUWzEe0eCg
X-Proofpoint-GUID: ryeuZR4WSnuBrdv23F9oVhOUWzEe0eCg

On 12/10/21 22:34, Vishal Verma wrote:
> diff --git a/util/parse-configs.c b/util/parse-configs.c
> new file mode 100644
> index 0000000..61352d8
> --- /dev/null
> +++ b/util/parse-configs.c
> @@ -0,0 +1,105 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2021, FUJITSU LIMITED. ALL rights reserved.
> +
> +#include <dirent.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <iniparser/iniparser.h>

Older builds[0] of iniparser-devel don't ship {/usr/include}/iniparser/iniparser.h
but rather {/usr/include}/iniparser.h . The new version[1] still creates a symlink to the
older path, so changing the include to be:

	#include <iniparser.h>

Should work on all distros.

[0] https://centos.pkgs.org/7/centos-x86_64/iniparser-devel-3.1-5.el7.x86_64.rpm.html
[1] https://centos.pkgs.org/8/epel-x86_64/iniparser-devel-4.1-5.el8.x86_64.rpm.html
