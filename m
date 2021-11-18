Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DBC2C81
	for <nvdimm@lists.linux.dev>; Thu, 18 Nov 2021 19:04:09 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIIZ9Sb020979;
	Thu, 18 Nov 2021 19:04:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=qYOv4tGqNu0mt82zcxHbrC4of5lReHGN6jTvb/SwTuA=;
 b=0gOHN7kuQPWQAddkNp479ESnjcyg4fZCezoXB1lpqYmLMr8h1w8Pgn13Io3T6jn5u6YZ
 kkZA86vhwMWq0OQrjKZbUkF96OblMHeNGl3oNMfZJ+n6kPj5ClzzbK6/QjJtU/mfHBAX
 PxfXFa9lcI5OXgpj93U0W9gwxfrm/wMB5I2bciWma/oy9DE9VuEesOV1Hfhmxvc90vqV
 1SPlDKAdPdvpm+XhfCUptQlo2InXH3mpgDKNao+L0P80PMDSx9DVTfe9af6nHdv8kSLE
 8QOXPoUbfmrGPDVHTA9W5EaFWEum6HIM+E+KFrpKZqrN2rhLnjX4RuWA8Zq8qRBpoTyP oQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cd4qyrvce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Nov 2021 19:04:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AIJ0Mln070384;
	Thu, 18 Nov 2021 19:04:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by userp3030.oracle.com with ESMTP id 3ca2g104bc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Nov 2021 19:04:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MCGRUmi6zrmqMo3L8ui78AZ87guri/avhco8yBJNjmZ8qRKZjXxU1m+g4YCuRmvATdDkp4HkbVbE2cabEmNGCuKbIPda1e1/wrYZlgEhTN2T4gPMaHc7t3LcEiqTWkhHp/5vQ7cFG8dxPoZMp8QAc4Oe11sABuu/DTOrZ0BPZV6nYmJA92SIPwXNCLP27uSY+b4kcUrdUqUTM7C1D1bFMmNwPhAmLEqIOeTFTiT5xarfxakOu4hBkPiDniQLLEU6aMmdY3kaKHLaqGEvc5vTi5X/AfQU+HkuKNi1DvcZN3QIKjo8Xh+JuC1F3clII0Cpj9vz34GV3M7s07MgYr2aXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qYOv4tGqNu0mt82zcxHbrC4of5lReHGN6jTvb/SwTuA=;
 b=oCaiFAuEZcNHEOTKPx1mqeQMDwggQa8qgVa8BH3UCfOS5N1bPCPn+Oul+89M37rEmPn2FV1PSYna+oRK7wTMQjdJTyKrdTu+t0nETZTHUcUj+2eoDqiQs8BUNLQRzN6s1ioE1uZytaUpxB1hVB0tOasDkyuN5A46Ug6O+qZjMnyTgn7b/yAHIz1pjKdGwu3YD3m7LkzWT42pM/hIDZkgxItjBAF2QCuFDm8lFp3bTzKHJbhuBOUNgui9a/rAWfHXmf5ZGunngLnceWdYXRQa5BFWiJ50vW7YvlUFhkKdbRfiQTpvIvvKSs8R2bUE0nB852wiSCg48L2UJFHFxbTGbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYOv4tGqNu0mt82zcxHbrC4of5lReHGN6jTvb/SwTuA=;
 b=G8IJ73h0Uix0QsxzctihOokexzTOCFVjMNfiMb6hWPyPnRc3uoEtPykgUpUQv99pgGVEaEP9JR+JyowWdpaocXmDCsxx6CIBIji/580e62bQOT3ostjeX3bWoKnX22MZAa/wHV4+UFwvB7ayBOsX4+Yh+WWhE6LIQcWkzbqC1bQ=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BYAPR10MB3511.namprd10.prod.outlook.com (2603:10b6:a03:129::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Thu, 18 Nov
 2021 19:03:59 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::418c:dfe4:f3ee:feaa]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::418c:dfe4:f3ee:feaa%7]) with mapi id 15.20.4690.029; Thu, 18 Nov 2021
 19:03:59 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>,
        Linux
 NVDIMM <nvdimm@lists.linux.dev>,
        Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Topic: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Index: 
 AQHXcsuUGdCdj5TLi0qPljMZ83rdmquiLs2AgAISgwCAARWOAIACN9EAgAD6fICABatcAIAPJJmAgAACXwCAACIPAIAABBsAgAAEnACAAAQRgIAABMWAgAABtoCAAAQ3AIAAA0SAgAAEIoCAAAXwAIAADw6AgAAjpgCAABYKgIAAk30AgABlNoCAABYmgIAABQ6AgAEIqwCAPjKpgIABmROAgAAF4YCAAR65gIAAGD6AgAA1W4CAAAkygIAAcDKAgAD6wQCAB768gA==
Date: Thu, 18 Nov 2021 19:03:59 +0000
Message-ID: <b51fb3d6-6d39-c450-e0a1-94a1645a22ec@oracle.com>
References: 
 <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
 <YVY7wY/mhMiRLATk@zn.tnic> <ba3b12bf-c71e-7422-e205-258e96f29be5@oracle.com>
 <CAPcyv4j9KH+Y4hperuCwBMLOSPHKfbbku_T8uFNoqiNYrvfRdA@mail.gmail.com>
 <YVbn3ohRhYkTNdEK@zn.tnic>
 <CAPcyv4i4r5-0i3gpZxwP7ojndqbrSmebtDcGbo8JR346B-2NpQ@mail.gmail.com>
 <YVdPWcggek5ykbft@zn.tnic>
 <CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com>
 <YVgxnPWX2xCcbv19@zn.tnic> <48c47c52-499a-8721-350a-5ac55a9a70de@oracle.com>
 <7ae58b24-ad48-7afa-c023-23ccf28e3994@oracle.com>
 <CAPcyv4imjWNuwsQKhWinq+vtuSgXAznhLXVfsy69Dq7q7eiXbA@mail.gmail.com>
 <f80d03c6-e650-49df-81d1-309dd138de8f@oracle.com>
 <CAPcyv4hPRyPtAJoDdOn+UnJQYgQW7XQTnMveKu9YdYXxekUg8A@mail.gmail.com>
 <a3c07537-f623-17fb-d2b7-45500093c337@oracle.com>
 <CAPcyv4iF0bQx0J0qrXVdCfRcS4QWaCyR1-DuXaoe59ofzH-FEw@mail.gmail.com>
 <1b1600b0-b50b-3e35-3609-9503b8b960b8@oracle.com>
 <CAPcyv4jBHnYtqoxoJY1NGNE1DXOv3bAg0gBzjZ=eOvarVXDRbA@mail.gmail.com>
In-Reply-To: 
 <CAPcyv4jBHnYtqoxoJY1NGNE1DXOv3bAg0gBzjZ=eOvarVXDRbA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3fc7be4-5197-4818-9ca3-08d9aac62db5
x-ms-traffictypediagnostic: BYAPR10MB3511:
x-microsoft-antispam-prvs: 
 <BYAPR10MB3511EE4532A4816B84F60197F39B9@BYAPR10MB3511.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 qmqueWE8EFimR4DxiZqWAfZkJvge7cL5aHg6VYZGPk9J86KgJdtpgSQzZAz0SnUph32srJM/pBNuMHuS3oIeqsOJwsS+R3DvgzDyOHfM1uYkzJ06qSxTWVVbhIWRqo+v3ew4ySf6Zh+q1xc43NeyoRz7mwB1KCft1q3wLIXcNOBpO/Xs99Vpc2HsHKRCa9rpIgJsTu4m209wqvhX4bTEM9XUHFpZVIcrPqtZV5seqdywYCeGjxLqAHgmD/JH8YOnGmzcgEFGq++N6KBa9ElKG0X/s3JkkD8fPvdsQ7+NOef4D/guc4XDzNwqfBbj6T9wDCUw3lZ4Afc3p/rpFf7ABkcrwwL1ZKeo91uduemOJ3+JVzQ0c1oK6/fG/F+9SA4VluDnAenKmT8Rlz1pmEE5pbv5V3QR1Kzc8t2DMnN1WE4PEeW7BphUU69FqqX4Usr5zoXUneTUsnZkfxcy/EnngkS19VMOXrNlb97I/NjwEq2sdcSW8ynTTai6bnXab4LumP7NfEuTDqvO5L2F9KD4dzrzUUROyDBDFkVugjSgLa+splgKRzGF58dHMXW0VjoTktMjpQtlgabXcoGCS8Eb0kGssOn+McM+3vX2ebn0oSQ4DAcMy0lGuiDZGdsXYI8MAUuogotw0QMV/FB0pRQCTHoUEPVtUcR1dFT6Su/8BeuuY4xYd+zQ1ehHdYWS/KY2DLcvsL6DzX4C5qIaluw69k7l+xJ9W5+GlJAymXIhg/D/F+nh6KCxEhD8cPdvX7sMJDvIxCf9KC0ig6n/EKtOjA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(4326008)(66556008)(66446008)(316002)(2906002)(8676002)(66476007)(38100700002)(8936002)(508600001)(66946007)(54906003)(64756008)(91956017)(38070700005)(31696002)(44832011)(31686004)(76116006)(6512007)(5660300002)(83380400001)(86362001)(71200400001)(186003)(6916009)(53546011)(26005)(36756003)(122000001)(6486002)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?RVhObGpvWlA1MFVSaUhZNjZJVGt3SmMzN1Y2TDd2eUZNZGlURjFBRDZnbktF?=
 =?utf-8?B?YW5DTDUydDdQUjBSL0NlWjMxSDJIRXlkck54bFRoLzNkY2NZblB2eDFEMlZo?=
 =?utf-8?B?WnJPZ0U1dGU5UlV3TndnVWlXU1UxeldZTDh3RDZ6dDRiMlpyS2tYdGFnS1lK?=
 =?utf-8?B?eWdac0JOU3YzZjA1SGQ2TEY4cHN5K0pkQVhIbUhXSWJmVEMyQys4VFp1VHdM?=
 =?utf-8?B?SXY3WUJjQmtFdGZ2RlphZkZWVkhIQzZ3S3RPUTR0cTZocTQvN21PMHVicE05?=
 =?utf-8?B?Z2JUMTNaVlEyM3ZjZ3VSK3EwMHI1RWYxektGZTJ5OFBJaGlYSWtEK2s2VjNi?=
 =?utf-8?B?RE5uTHRYam9ZL1RXeWI3NXI5R0E4UmMzR0ovUlpuSFo4THRkc2EzaFRBWHBX?=
 =?utf-8?B?Y3J4UzRzRmZZVU83V2VGOTRVZHVwaVM3OEdhc0ZPL3JtNGQ0T3owQ0hlK3Vq?=
 =?utf-8?B?dStOWWt6Uk9JTWVuTjVoZUg4bWNHM2pzbFl4c1o3WXFWck5CT09BaTVTWjJz?=
 =?utf-8?B?OXpwd2VUeGhNaU1RQjY3L2pURDBybWRrVy9nVFpCZFZ1NTZPU2hjTDdJbC9u?=
 =?utf-8?B?Ri8wT3N2ZHNCc2pmcWRBaW9WdG9xSXIvMTRzV2JhQmpLS1k1VWkwd0c2Z0cw?=
 =?utf-8?B?bmVZTGRIWURySVJxOTVOejRVQ2E5ZHg3RUpTNElFano3cnA1TG9yZ1RsMmNl?=
 =?utf-8?B?ZFkvb09QOTlqLzBwTy9oVXVPR2NROUxrRTlSUkM2WUpSMGNDRFlPOW1maUs2?=
 =?utf-8?B?K3FsTWkrZ01CdWl5SmFJK2hjR290Vk0wVlN4NHdzTXgwallyajN1QTVNKzEr?=
 =?utf-8?B?YlFIa2pTeEpBTE5tWU03NE5RbTVCWWtxRXk1R1I1KzN6b2RsOUNWdWZqVVZt?=
 =?utf-8?B?MWlidXI1RkdyZC9lVkI0ME1VT3RLUlJwMWNpbktRYlo1NGFwb2ptQjY4S2hw?=
 =?utf-8?B?WUVLazdzYUZzVzh6MWZWQURHUGhaMUJpcFR2ejNSOWkwQitqNEZWa2krdHBi?=
 =?utf-8?B?TXZwZ2NyUGR1NnZmQURiQXM5aDRMeTNpR2hiQlJpVzJ4d3VxYXMxUWhIQkZV?=
 =?utf-8?B?aTZoT2F0WVYwVmFUTlI2MUZReG4yNE5CM21aUXdrUUhGMXNyalA4TDFSaEhN?=
 =?utf-8?B?enlWeUdGaDQzU0NweHh5Qmh1aDlnNThUKzVIVEwwWG5hODNsY0w1V3FvZFFS?=
 =?utf-8?B?T1VGM0MwakIyWEl2SDhYSmtBZU90eWJzM3Q5aTNaNFlpSGx5UldjU0k4eTFi?=
 =?utf-8?B?a0Y5eGZ3QTFBM2lOMWFId2Q2RXNOTlNFMndZV3VqYy8zbHpScXYyUTJuWEM2?=
 =?utf-8?B?Ymx6U21RNkEvQmcwQlV3Z2hQZWhnSkR6aElGWkpHWlRTRVk0aXFKeVRWQVk3?=
 =?utf-8?B?QkVzUGpaSHMxMmloRlBMWjF6dHg4eUhqajVvS1NvWnFJbjQ2SERGek84YzJM?=
 =?utf-8?B?ekpCUnZVL1k1RjhQdVZHSUhtc29IdCtKK01iVW8zbDI4QVAyd1JldG9HbjNu?=
 =?utf-8?B?VEltNlIvY2kxckJZdWErSTltY0VxMWo1Q0JFbk8xcmVsR2pTWUJ1bHNRd0RC?=
 =?utf-8?B?eHRoRW02QllxUjBOVEE3V0tFQUljcmk5Z1BHTStkS252V3NHQ3RhOHZ0TENR?=
 =?utf-8?B?QUZ3cXUyaWxYSStJc3l4OHVLMnZLcmlWZDlOdzZ6bmRpZ2dLaHJhQ09aclJ6?=
 =?utf-8?B?dzhlOWIvZFhDK3NNZi9aS2l3a2QxbHJtUTJRa2pjUXNERGFNRUNkQ3g4RXFV?=
 =?utf-8?B?Z3VnNTdha2x0ajBEemhiVlpVeXBxRlgzQWVscnFTZnd0eDBiblF3cENxTmZP?=
 =?utf-8?B?WmdGaDJEQTFaWTZmdXVTOHU3NVpHOUhDckxoSi9aOHIxS21ZaldYMXloUWVv?=
 =?utf-8?B?QjZmN1NDY3hqZml4R1pHZ1hob3FTejdsYmhkKzRwbGNOUVJzRVN4WFM5dGNk?=
 =?utf-8?B?V0hjU01DaFUyUU12bm94TmNQa0xSYi9aNzVlelJHc3JBYjRBTFRHRjgrSzVI?=
 =?utf-8?B?SUlFejB4Zi9XemJyMk5nRFBVUjlsYkZCbHF1Zm5tZEN1dk5YcFEvcFRSN1RK?=
 =?utf-8?B?b3dkdHVFUWxXbXZwY3dXUzI0eFZ3YTZyN0lSSk1XWm1pVGkxemhWek1vdVA0?=
 =?utf-8?B?UVRSam9BbDBZU3pmVDJNVTNqSVhuUHlNeWVsK3lTMEc5TG4vRGRxZ1gzVkFY?=
 =?utf-8?B?NVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BEF8F47BDFA5BD4286F3E14D6C2E2434@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3fc7be4-5197-4818-9ca3-08d9aac62db5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 19:03:59.5982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jYcxbWVDiZbKB1w3xkpPfbu5aloAFxwhPW1BNmTJtg0T0wQWLpkDcAWn24wkxD3QSecKmdg+1NPCobtDRgE0iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3511
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111180101
X-Proofpoint-ORIG-GUID: JHCZlCMN9QZbibj-HiAFi6PajghYTxdl
X-Proofpoint-GUID: JHCZlCMN9QZbibj-HiAFi6PajghYTxdl

T24gMTEvMTMvMjAyMSAxMjo0NyBQTSwgRGFuIFdpbGxpYW1zIHdyb3RlOg0KPHNuaXA+DQo+Pj4g
SXQgc2hvdWxkIGtub3cgYmVjYXVzZSB0aGUgTUNFIHRoYXQgdW5tYXBwZWQgdGhlIHBhZ2Ugd2ls
bCBoYXZlDQo+Pj4gY29tbXVuaWNhdGVkIGEgIndob2xlX3BhZ2UoKSIgTUNFLiBXaGVuIGRheF9y
ZWNvdmVyeV9yZWFkKCkgZ29lcyB0bw0KPj4+IGNvbnN1bHQgdGhlIGJhZGJsb2NrcyBsaXN0IHRv
IHRyeSB0byByZWFkIHRoZSByZW1haW5pbmcgZ29vZCBkYXRhIGl0DQo+Pj4gd2lsbCBzZWUgdGhh
dCBldmVyeSBzaW5nbGUgY2FjaGVsaW5lIGlzIGNvdmVyZWQgYnkgYmFkYmxvY2tzLCBzbw0KPj4+
IG5vdGhpbmcgdG8gcmVhZCwgYW5kIG5vIG5lZWQgdG8gZXN0YWJsaXNoIHRoZSBVQyBtYXBwaW5n
LiBTbyB0aGUgdGhlDQo+Pj4gIlRvbnkgZml4IiB3YXMgaW5jb21wbGV0ZSBpbiByZXRyb3NwZWN0
LiBJdCBuZWdsZWN0ZWQgdG8gdXBkYXRlIHRoZQ0KPj4+IE5WRElNTSBiYWRibG9ja3MgdHJhY2tp
bmcgZm9yIHRoZSB3aG9sZSBwYWdlIGNhc2UuDQo+Pg0KPj4gU28gdGhlIGNhbGwgaW4gbmZpdF9o
YW5kbGVfbWNlKCk6DQo+PiAgICAgbnZkaW1tX2J1c19hZGRfYmFkcmFuZ2UoYWNwaV9kZXNjLT5u
dmRpbW1fYnVzLA0KPj4gICAgICAgICAgICAgICAgICAgQUxJR04obWNlLT5hZGRyLCBMMV9DQUNI
RV9CWVRFUyksDQo+PiAgICAgICAgICAgICAgICAgICBMMV9DQUNIRV9CWVRFUyk7DQo+PiBzaG91
bGQgYmUgcmVwbGFjZWQgYnkNCj4+ICAgICBudmRpbW1fYnVzX2FkZF9iYWRyYW5nZShhY3BpX2Rl
c2MtPm52ZGltbV9idXMsDQo+PiAgICAgICAgICAgICAgICAgICBBTElHTihtY2UtPmFkZHIsIEwx
X0NBQ0hFX0JZVEVTKSwNCj4+ICAgICAgICAgICAgICAgICAgICgxIDw8IE1DSV9NSVNDX0FERFJf
TFNCKG0tPm1pc2MpKSk7DQo+PiByaWdodD8NCj4gDQo+IFllcy4NCj4gDQo+Pg0KPj4gQW5kIHdo
ZW4gZGF4X3JlY292ZXJ5X3JlYWQoKSBjYWxscw0KPj4gICAgIGJhZGJsb2Nrc19jaGVjayhiYiwg
c2VjdG9yLCBsZW4gLyA1MTIsICZmaXJzdF9iYWQsICZudW1fYmFkKQ0KPj4gaXQgc2hvdWxkIGFs
d2F5cywgaW4gY2FzZSBvZiAnTlAnLCBkaXNjb3ZlciB0aGF0ICdmaXJzdF9iYWQnDQo+PiBpcyB0
aGUgZmlyc3Qgc2VjdG9yIGluIHRoZSBwb2lzb25lZCBwYWdlLCAgaGVuY2Ugbm8gbmVlZA0KPj4g
dG8gc3dpdGNoIHRvICdVQycsIHJpZ2h0Pw0KPiANCj4gWWVzLg0KPiANCj4+DQo+PiBJbiBjYXNl
IHRoZSAnZmlyc3RfYmFkJyBpcyBpbiB0aGUgbWlkZGxlIG9mIHRoZSBwb2lzb25lZCBwYWdlLA0K
Pj4gdGhhdCBpcywgZGF4X3JlY292ZXJfcmVhZCgpIGNvdWxkIHBvdGVudGlhbGx5IHJlYWQgc29t
ZSBjbGVhbg0KPj4gc2VjdG9ycywgaXMgdGhlcmUgcHJvYmxlbSB0bw0KPj4gICAgIGNhbGwgX3Nl
dF9tZW1vcnlfVUMocGZuLCAxKSwNCj4+ICAgICBkbyB0aGUgbWNfc2FmZSByZWFkLA0KPj4gICAg
IGFuZCB0aGVuIGNhbGwgc2V0X21lbW9yeV9OUChwZm4sIDEpDQo+PiA/DQo+PiBXaHkgZG8gd2Ug
bmVlZCB0byBjYWxsIGlvcmVtYXAoKSBvciB2bWFwKCk/DQo+IA0KPiBJJ20gd29ycmllZCBhYm91
dCBjb25jdXJyZW50IG9wZXJhdGlvbnMgYW5kIGVuYWJsaW5nIGFjY2VzcyB0byB0aHJlYWRzDQo+
IG91dHNpZGUgb2YgdGhlIG9uZSBjdXJyZW50bHkgaW4gZGF4X3JlY292ZXJ5X3JlYWQoKS4gSWYg
YSBsb2NhbCB2bWFwKCkNCj4gLyBpb3JlbWFwKCkgaXMgdXNlZCBpdCBlZmZlY3RpdmVseSBtYWtl
cyB0aGUgYWNjZXNzIHRocmVhZCBsb2NhbC4NCj4gVGhlcmUgbWlnaHQgc3RpbGwgbmVlZCB0byBi
ZSBhbiByd3NlbSB0byBhbGxvdyBkYXhfcmVjb3Zlcnlfd3JpdGUoKSB0bw0KPiBmaXh1cCB0aGUg
cGZuIGFjY2VzcyBhbmQgc3luY3Job25pemUgd2l0aCBkYXhfcmVjb3ZlcnlfcmVhZCgpDQo+IG9w
ZXJhdGlvbnMuDQo+IA0KDQo8c25pcD4NCj4+IEkgZGlkbid0IGV2ZW4ga25vdyB0aGF0IGd1ZXN0
IGNvdWxkIGNsZWFyIHBvaXNvbiBieSB0cmFwcGluZyBoeXBlcnZpc29yDQo+PiB3aXRoIHRoZSBD
bGVhckVycm9yIERTTSBtZXRob2QsDQo+IA0KPiBUaGUgZ3Vlc3QgY2FuIGNhbGwgdGhlIENsZWFy
IEVycm9yIERTTSBpZiB0aGUgdmlydHVhbCBCSU9TIHByb3ZpZGVzDQo+IGl0LiBXaGV0aGVyIHRo
YXQgYWN0dWFsbHkgY2xlYXJzIGVycm9ycyBvciBub3QgaXMgdXAgdG8gdGhlDQo+IGh5cGVydmlz
b3IuDQo+IA0KPj4gSSB0aG91Z2h0IGd1ZXN0IGlzbid0IHByaXZpbGVnZWQgd2l0aCB0aGF0Lg0K
PiANCj4gVGhlIGd1ZXN0IGRvZXMgbm90IGhhdmUgYWNjZXNzIHRvIHRoZSBiYXJlIG1ldGFsIERT
TSBwYXRoLCBidXQgdGhlDQo+IGh5cGVydmlzb3IgY2FuIGNlcnRhaW5seSBvZmZlciB0cmFuc2xh
dGlvbiBzZXJ2aWNlIGZvciB0aGF0IG9wZXJhdGlvbi4NCj4gDQo+PiBXb3VsZCB5b3UgbWluZCB0
byBlbGFib3JhdGUgYWJvdXQgdGhlIG1lY2hhbmlzbSBhbmQgbWF5YmUgcG9pbnQNCj4+IG91dCB0
aGUgY29kZSwgYW5kIHBlcmhhcHMgaWYgeW91IGhhdmUgdGVzdCBjYXNlIHRvIHNoYXJlPw0KPiAN
Cj4gSSBkb24ndCBoYXZlIGEgdGVzdCBjYXNlIGJlY2F1c2UgdW50aWwgVG9ueSdzIGZpeCBJIGRp
ZCBub3QgcmVhbGl6ZQ0KPiB0aGF0IGEgdmlydHVhbCAjTUMgd291bGQgYWxsb3cgdGhlIGd1ZXN0
IHRvIGxlYXJuIG9mIHBvaXNvbmVkDQo+IGxvY2F0aW9ucyB3aXRob3V0IG5lY2Vzc2FyaWx5IGFs
bG93aW5nIHRoZSBndWVzdCB0byB0cmlnZ2VyIGFjdHVhbA0KPiBwb2lzb24gY29uc3VtcHRpb24u
DQo+IA0KPiBJbiBvdGhlciB3b3JkcyBJIHdhcyBvcGVyYXRpbmcgdW5kZXIgdGhlIGFzc3VtcHRp
b24gdGhhdCB0ZWxsaW5nDQo+IGd1ZXN0cyB3aGVyZSBwb2lzb24gaXMgbG9jYXRlZCBpcyBwb3Rl
bnRpYWxseSBoYW5kaW5nIHRoZSBndWVzdCBhIHdheQ0KPiB0byBEb1MgdGhlIFZNTS4gSG93ZXZl
ciwgVG9ueSdzIGZpeCBzaG93cyB0aGF0IHdoZW4gdGhlIGh5cGVydmlzb3INCj4gdW5tYXBzIHRo
ZSBndWVzdCBwaHlzaWNhbCBwYWdlIGl0IGNhbiBwcmV2ZW50IHRoZSBndWVzdCBmcm9tIGFjY2Vz
c2luZw0KPiBpdCBhZ2Fpbi4gU28gaXQgZm9sbG93cyB0aGF0IGl0IHNob3VsZCBiZSBvayB0byBp
bmplY3QgdmlydHVhbCAjTUMgdG8NCj4gdGhlIGd1ZXN0LCBhbmQgdW5tYXAgdGhlIGd1ZXN0IHBo
eXNpY2FsIHJhbmdlLCBidXQgbGF0ZXIgYWxsb3cgdGhhdA0KPiBndWVzdCBwaHlzaWNhbCByYW5n
ZSB0byBiZSByZXBhaXJlZCBpZiB0aGUgZ3Vlc3QgYXNrcyB0aGUgaHlwZXJ2aXNvcg0KPiB0byBy
ZXBhaXIgdGhlIHBhZ2UuDQo+IA0KPiBUb255LCBkb2VzIHRoaXMgbWF0Y2ggeW91ciB1bmRlcnN0
YW5kaW5nPw0KPiANCj4+DQo+PiBidXQgSSdtIG5vdCBzdXJlIHdoYXQgdG8gZG8gYWJvdXQNCj4+
PiBndWVzdHMgdGhhdCBsYXRlciB3YW50IHRvIHVzZSBNT1ZESVI2NEIgdG8gY2xlYXIgZXJyb3Jz
Lg0KPj4+DQo+Pg0KPj4gWWVhaCwgcGVyaGFwcyB0aGVyZSBpcyBubyB3YXkgdG8gcHJldmVudCBn
dWVzdCBmcm9tIGFjY2lkZW50YWxseQ0KPj4gY2xlYXIgZXJyb3IgdmlhIE1PVkRJUjY0QiwgZ2l2
ZW4gc29tZSBhcHBsaWNhdGlvbiByZWx5IG9uIE1PVkRJUjY0Qg0KPj4gZm9yIGZhc3QgZGF0YSBt
b3ZlbWVudCAoc3RyYWlnaHQgdG8gdGhlIG1lZGlhKS4gSSBndWVzcyBpbiB0aGF0IGNhc2UsDQo+
PiB0aGUgY29uc2VxdWVuY2UgaXMgZmFsc2UgYWxhcm0sIG5vdGhpbmcgZGlzYXN0cm91cywgcmln
aHQ/DQo+IA0KPiBZb3UnbGwganVzdCBjb250aW51ZSB0byBnZXQgZmFsc2UgcG9zaXRpdmUgZmFp
bHVyZXMgYmVjYXVzZSB0aGUgZXJyb3INCj4gdHJhY2tpbmcgd2lsbCBiZSBvdXQtb2Ytc3luYyB3
aXRoIHJlYWxpdHkuDQo+IA0KPj4gSG93IGFib3V0IGFsbG93aW5nIHRoZSBwb3RlbnRpYWwgYmFk
LWJsb2NrIGJvb2trZWVwaW5nIGdhcCwgYW5kDQo+PiBtYW5hZ2UgdG8gY2xvc2UgdGhlIGdhcCBh
dCBjZXJ0YWluIGNoZWNrcG9pbnRzPyBJIGd1ZXNzIG9uZSBvZg0KPj4gdGhlIGNoZWNrcG9pbnRz
IG1pZ2h0IGJlIHdoZW4gcGFnZSBmYXVsdCBkaXNjb3ZlcnMgYSBwb2lzb25lZA0KPj4gcGFnZT8N
Cj4gDQo+IE5vdCBzdXJlIGhvdyB0aGF0IHdvdWxkIHdvcmsuLi4gaXQncyBhbHJlYWR5IHRoZSBj
YXNlIHRoYXQgbmV3IGVycm9yDQo+IGVudHJpZXMgYXJlIGFwcGVuZGVkIHRvIHRoZSBsaXN0IGF0
ICNNQyB0aW1lLCB0aGUgcHJvYmxlbSBpcyBrbm93aW5nDQo+IHdoZW4gdG8gY2xlYXIgdGhvc2Ug
c3RhbGUgZW50cmllcy4gSSBzdGlsbCB0aGluayB0aGF0IG5lZWRzIHRvIGJlIGF0DQo+IGRheF9y
ZWNvdmVyeV93cml0ZSgpIHRpbWUuDQo+IA0KDQpUaGFua3MgRGFuIGZvciB0YWtpbmcgdGhlIHRp
bWUgZWxhYm9yYXRpbmcgc28gbXVjaCBkZXRhaWxzIQ0KDQpBZnRlciBzb21lIGFtb3VudCBvZiBk
aWdnaW5nLCBJIGhhdmUgYSBmZWVsIHRoYXQgd2UgbmVlZCB0byB0YWtlDQpkYXggZXJyb3IgaGFu
ZGxpbmcgaW4gcGhhc2VzLg0KDQpQaGFzZS0xOiB0aGUgc2ltcGxlc3QgZGF4X3JlY292ZXJ5X3dy
aXRlIG9uIHBhZ2UgZ3JhbnVsYXJpdHksIGFsb25nDQogICAgICAgICAgd2l0aCBmaXggdG8gc2V0
IHBvaXNvbmVkIHBhZ2UgdG8gJ05QJywgc2VyaWFsaXplDQogICAgICAgICAgZGF4X3JlY292ZXJ5
X3dyaXRlIHRocmVhZHMuDQpQaGFzZS0yOiBwcm92aWRlIGRheF9yZWNvdmVyeV9yZWFkIHN1cHBv
cnQgYW5kIGhlbmNlIHNocmluayB0aGUgZXJyb3INCiAgICAgICAgICByZWNvdmVyeSBncmFudWxh
cml0eS4gIEFzIGlvcmVtYXAgcmV0dXJucyBfX2lvbWVtIHBvaW50ZXINCiAgICAgICAgICB0aGF0
IGlzIG9ubHkgYWxsb3dlZCB0byBiZSByZWZlcmVuY2VkIHdpdGggaGVscGVycyBsaWtlDQogICAg
ICAgICAgcmVhZGwoKSB3aGljaCBkbyBub3QgaGF2ZSBhIG1jX3NhZmUgdmFyaWFudCwgYW5kIEkn
bQ0KICAgICAgICAgIG5vdCBzdXJlIHdoZXRoZXIgdGhlcmUgc2hvdWxkIGJlLiAgQWxzbyB0aGUg
c3luY2hyb25pemF0aW9uDQogICAgICAgICAgYmV0d2VlbiBkYXhfcmVjb3ZlcnlfcmVhZCBhbmQg
ZGF4X3JlY292ZXJ5X3dyaXRlIHRocmVhZHMuDQpQaGFzZS0zOiB0aGUgaHlwZXJ2aXNvciBlcnJv
ci1yZWNvcmQga2VlcGluZyBpc3N1ZSwgc3VwcG9zZSB0aGVyZSBpcw0KICAgICAgICAgIGFuIGlz
c3VlLCBJJ2xsIG5lZWQgdG8gZmlndXJlIG91dCBob3cgdG8gc2V0dXAgYSB0ZXN0IGNhc2UuDQpQ
aGFzZS00OiB0aGUgaG93LXRvLW1pdGlnYXRlLU1PVkRJUjY0Qi1mYWxzZS1hbGFybSBpc3N1ZS4N
Cg0KUmlnaHQgbm93LCBpdCBzZWVtcyB0byBtZSBwcm92aWRpbmcgUGhhc2UtMSBzb2x1dGlvbiBp
cyB1cmdlbnQsIHRvIGdpdmUNCnNvbWV0aGluZyB0aGF0IGN1c3RvbWVycyBjYW4gcmVseSBvbi4N
Cg0KSG93IGRvZXMgdGhpcyBzb3VuZCB0byB5b3U/DQoNCnRoYW5rcywNCi1qYW5lDQoNCg0KDQoN
Cg0K
