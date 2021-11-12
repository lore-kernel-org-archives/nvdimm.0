Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435EA2C85
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 22:35:41 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACLnKXU009534;
	Fri, 12 Nov 2021 22:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=i0A/TXPrlri5nPaqrbeWQdk/wR8cL7Wm8heb+C2Bkhc=;
 b=fvNWqMS51+0ks+qIYurUDx/yWdVyuCQhb2VBCUCFLytvqsdCf0FwqGQ6eKVlwT2jcs9M
 UWhlDDYUPc5Afzr/aIAd7qAkv+s/JTDMTWlNX0f7vhTPKY2CX76o50Yyvj5s+EVh3q++
 CHIwnx638PcHpsXHR4gWAw4FGWFOtBIFDR95GIpTMQxCWbb+dso8T7FP8zZ9FxjNBZH8
 GfkPm+2+EQrH8G39jfGlI65MuI5SFNYkgDw8Aa4bNv6F4V/uX+9ZPEoOdo4RQKjFvpXy
 ncXef48jLEvCgFxwnpaJF+2K5GJa5on++8YPDR94e2pnV1F0ZximjgChj4P4S58BUb/V Cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c9t70avf1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 22:35:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ACMKipj129064;
	Fri, 12 Nov 2021 22:35:36 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
	by aserp3020.oracle.com with ESMTP id 3c5hh8sxeh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 22:35:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ih7wV1JSFK5ZT5sP+coA9lI59WS6HUCHtyUs0VD0d5mI45M5B75IlQ/Ur9Vk0fFeO9QMGjGeSWCWVzfEr1ZmmrXTTISgJ1qGU/9DrtazS/wMVXUGGuXsdRJ8PddYYURl3m+M0u0Ff5NhyNAOmFNcbJohS6NYimGnTgz4DeePXgwRL6BX9oPy9iG9Hk1pFeb02ZcJ5A3Hu5jFWOIGpjmS0C8YZ9ATiam0FALR82/xJqRBn/f8OrADHrG/rByof1paRBJu6VcWZZOM9F+YTf4FlZ/JFOL6auC8c8NYjDq8K4WhIDuljYNDunq7Sz8zJvXdaTy2QbR68VbZmbZZvLD1Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0A/TXPrlri5nPaqrbeWQdk/wR8cL7Wm8heb+C2Bkhc=;
 b=DCjSHZhPNh19pANQQEteO7iYbmWE1GY+1a/t87QxxXZlh8Vww3kQZPsaYJ0MPYa0eIC7lIA8dPynNYl2QlI37SMnydJgN2/5J+f2qkH14NmWAdF4fECO99ZLFIk+ymMcUgZjJR/EEasKODqjnrFDy4Jx+kic9KFlZIPb8AXk+BNSJKRDpoy4RxRiOWGi8L5eo7SwXlh2LfiD6uWvsEajVIUCUxfDElxgoIpIHTI+wJ6n3saFdwBADLsCOKT5La6W3Htyls0lGiLzTGuXszusykJiFrjimtq8M2xlCB+UTayQ3b2meoNqGxTj6UGmkW8UKfbnb1a9JOqD/+GUYuR1hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i0A/TXPrlri5nPaqrbeWQdk/wR8cL7Wm8heb+C2Bkhc=;
 b=H5dMX6Thuyt8ALkuj6AmJ1ULM0Hn7Xbt7/Y3xaJBEiiyxHUw4NG1kqHExlPlHTnbFUxmr9F8Mz7pjTbMb13sedr+ShNKq4pIMNsPWERYoQj2onPQgrixm34A3kt0NSH+q2GJkRNZIpQ/CTKHcAQ7+qy2Gt6ck/iyG3+ihDNoYqk=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by SJ0PR10MB5454.namprd10.prod.outlook.com (2603:10b6:a03:304::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16; Fri, 12 Nov
 2021 22:35:33 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::418c:dfe4:f3ee:feaa]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.019; Fri, 12 Nov 2021
 22:35:33 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>,
        Linux
 NVDIMM <nvdimm@lists.linux.dev>,
        Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Topic: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Index: 
 AQHXcsuUGdCdj5TLi0qPljMZ83rdmquiLs2AgAISgwCAARWOAIACN9EAgAD6fICABatcAIAPJJmAgAACXwCAACIPAIAABBsAgAAEnACAAAQRgIAABMWAgAABtoCAAAQ3AIAAA0SAgAAEIoCAAAXwAIAADw6AgAAjpgCAABYKgIAAk30AgABlNoCAABYmgIAABQ6AgAEIqwCAPjKpgIABmROAgAAF4YCAAR65gIAAGD6AgAA1W4A=
Date: Fri, 12 Nov 2021 22:35:33 +0000
Message-ID: <a3c07537-f623-17fb-d2b7-45500093c337@oracle.com>
References: 
 <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
 <YVYqJZhBiTMXezZJ@zn.tnic>
 <CAPcyv4heNPRqA-2SMsMVc4w7xGo=xgu05yD2nsVbCwGELa-0hQ@mail.gmail.com>
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
In-Reply-To: 
 <CAPcyv4hPRyPtAJoDdOn+UnJQYgQW7XQTnMveKu9YdYXxekUg8A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 348fdb10-e843-4b8d-07df-08d9a62cbd81
x-ms-traffictypediagnostic: SJ0PR10MB5454:
x-microsoft-antispam-prvs: 
 <SJ0PR10MB545452A19D14EEBB1007ED2DF3959@SJ0PR10MB5454.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 MIKVlXVvtAFgfCRj3UKprKZWs4A8MGMBlUIi6ShZAhmBpiBtlJKtQkV683V6bnLmROhqyozawU7hhL7MpGoKfxciIyTFa86miL0fe0V20oecKASOc0Ac7ojZBCCfYuz3np/p0EiyYMnzZ3FPYPjAnXqNQEUk84kOtL9SS7rpabQ7YNbg0jv8FJrzEdLGlo/bHg5BsAc07wBMorEU+5EUSBqNVP/XnMj7n9es2KJXMV6rfXJo8GDH8kgpWS1fF5Jjo5aj5BuD0V2nimEaTDtTplaw0kL+6qADSp1gxlwPhFw3VkMusXVYQrUdr6dIp2pVhpYCPrCsgnjfbAwRHHB86IZTP31DyRvTXspQ0YDEsePTIWKYjaCfIYDSiH92Yjzw/tKnML+1YgDxkd4msaOpOOCry09+mH3kWya4kB7OSnyhDYt2ILU9KXq3t1U4IN/r2a49ZTby7airL7ok3ztvmjCNkELrjJSVNC0wz9yi0ph/4l2LRFrHu5Z4iLJ5gY1P9kGRfx7DbE3LIXSLuNNtq1GLZZNUi5SwXHU15t/EBlWgsAb9KlIMAslz9eZsAm4xD4KnCywJQWNsdRWHGAPJhjY+GzQyzoPZYtpqXGkBU4ZPTH1Dq0cJaBpW4yBV9TqiXceu/fptIODlP+8d5FsPX5TyN3Yhgyu9IbM505xKG07hv4cgRp5VwnOH9ikV0ktrXMxjmhUr5Kc9k5bpu6RSBGJG6URlKKrYvqTw9Lq5PNFQdf5grjTHc8emPcFws6qts87bCEBVQBKctd/zIns2DQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(26005)(6512007)(31686004)(66556008)(53546011)(36756003)(76116006)(186003)(6506007)(38070700005)(8936002)(316002)(83380400001)(38100700002)(86362001)(4326008)(54906003)(66946007)(122000001)(8676002)(66476007)(71200400001)(5660300002)(2906002)(6916009)(2616005)(66446008)(508600001)(64756008)(44832011)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?RkRiZjJlcERhNkI5M2tlK200NlBvclVxeC90NmRsU29udUh0SUtBWlE2R25D?=
 =?utf-8?B?NUxzSzlYeUxidWRTY0dNbHMvcHdTNVNpWTluM05rMzAxS3prRFpVQWNlZEw0?=
 =?utf-8?B?ckZVUzVmTFVXd2d3UmtTNlFtRHhpN200UFVNUVdOdUVlOG1UakZYRGFPWGJ1?=
 =?utf-8?B?bHE4YkJHSjdDdWwzVVlTc3UxQ1pTalJ0c21SWlV4VTRxS2dyY1I0T1E0elll?=
 =?utf-8?B?a3N1UWJIVnVWdGdJcGVZbEdOaUJVTUJsNzU3R3B0SlMwM3JFN0grcitwNC9k?=
 =?utf-8?B?T3hrQmlHQ3MvaFJNdHRybnhsUXlHQzByYTJRR2JEUStRcUVwMG5uWDg0Tm0r?=
 =?utf-8?B?dDdWcHdaNWVTZFZZZEYzL0pramtUNnE0UEFIemt0SHloOVMweXlXaGNiU0Js?=
 =?utf-8?B?YjEzOFlOcDAzK3RhNkc0ZDIwVEFxekRQck1JS2dzMExNTWxEa2pjMXBZOFln?=
 =?utf-8?B?YTBISEk1QnZicE1neXRjU1RQWEo0NWoyTHZpZ011QTJJZzlJUWJUbFJjRjVz?=
 =?utf-8?B?ZXBtYk9hbWlsSTluK0g0WVhRNGRwcXllWmE3TmdJK1JiV1V5bEY3dDY3eGxD?=
 =?utf-8?B?bFJTSmZpQi95ZUVPTG5hNmtHOU9hbjBFSmJsdlRPdklRd2I5ajZnZkNZSEIz?=
 =?utf-8?B?MjZ5UTNlV2hhb1RmVTJNVlNYYzB4YWtPa1hqRXNRT1NzWHl0aGF1VVFFSmww?=
 =?utf-8?B?MHh3MmF6TW9RM0RIT0hyOGlWZnV3Sy9ldE9lTWEzWUJTM1RRdjJ3QzJ3cUhQ?=
 =?utf-8?B?VGRyL3NwVG42QXVLTnpuZzNaeTMrd3VyaWp0Q3FqRi9VMm1Hb1d1RVEzQnls?=
 =?utf-8?B?YTlucUQ2ZzRNRHFzSkcySHp1VW9WaHo0eHhSUTExRkUvamlicnFTWDBOOHZy?=
 =?utf-8?B?L3dJOHRUUlBlRXZheEpwYnc4N0tnWDYyT0pqY0VLK2VweE42SmJBL1lIS2pj?=
 =?utf-8?B?MDE0S1NzNnVmM21WdUR2aHR0NERQQ1l5RGdkdE9hQWczcFJTQzA3QklKTm9u?=
 =?utf-8?B?U2YwQjdTTi9DZ3FMRGw2MkFldGhLeTdKWm1FczVEdFdHcTUvcGd3L2dONkFQ?=
 =?utf-8?B?VXB3UUgyRzB0UXV4bllrTWNxRjlJeU1sZ1piOS9BTG1kT09UNmxNVmZzcGpD?=
 =?utf-8?B?bFc3bHd1Z0dzSEtpWnBGTTUvMHc0cDUzOG9SQU12YXhuMkxvTU41elVjV0xJ?=
 =?utf-8?B?K2NVQkZEbGc3ZndnbWowU2IzekNzZVIwbGlkLzhSVE5hOGg1S0R1NDhjekVT?=
 =?utf-8?B?a0JLclVKYUtINXJrVXVDSXYvNE9GRmViWFp6TTJaaGhDT1F2eEZyZlF3ODlE?=
 =?utf-8?B?aGNCZU9POWZyWDl0Q1VPbGsvSFZMSFVKKzJLTHBqdmE1dDRkVDVkK3p6TnJG?=
 =?utf-8?B?Snhhc1Y4SldxM21ZcmNRd2xEL2tZQjBhVEVPbG94Z1hMcUVzemorOUs0WUs1?=
 =?utf-8?B?OHQvakpSWjFDRlYwOHYrZ1RES2d1SFZHandXZENGUkU0aDR0Y213SHdjUzFq?=
 =?utf-8?B?WFZhcnVhR0IxTXNNTXBPSXVwekN0NHpMWERBb0JnaUdYOExXbWVUQUFXYVVH?=
 =?utf-8?B?WHFGRCsyRDBoTDR0dVl4dDV0TmE0VnBJOTRFay82QllObGJ4QmN0TDlJbmRv?=
 =?utf-8?B?Ui9taXlWdDBBYTlpT0ovaC9HRWhCTDFtd0xPUkxOaU5aYjJEVXdac0ozUVFm?=
 =?utf-8?B?WWxGL0NxSkpnWDZDZXJFZVRJSzNoSVNmMkFva0thKzhXUTlyc2NJOU1mYUpq?=
 =?utf-8?B?aEJXU3FoTDQrTVN6bTdjQXBad0djaUdWc1pXaXZyYWZMdVlmSUhybFh3dnVn?=
 =?utf-8?B?bjZYR2FWblptVVFrb1ZFUUptdlptNFNjU0hpZUVQU1ZuNVE5TnhSRFZZeUJR?=
 =?utf-8?B?UEQ5cERDTHRoMENlVjVBTUhPbXcyN0dOVk9MZmZhTGN1RTg3WFdBZ1FhUkUw?=
 =?utf-8?B?QWZ1QUwwZVI4NFlUVjZLbEZ1Smp2L3NjMGpVU3BXQS9KRkhLMXp3OUphWk5i?=
 =?utf-8?B?Y3FJb2RoeFBjTkFoMjd6ZHVqellvV2t5TzJTZGpGQlFaR28yU0FJRVFDRmEw?=
 =?utf-8?B?S1dPSHhNczRYN1JtK0ZIZ2NnZStGRXI3Y05hekdoM1VtK0h2bWt5cXJBaFFk?=
 =?utf-8?B?aWFjNXo1Z3RiZ2w4SDM4OXA2UDJuQlI2cUY4R21DdEt5WnRyUGkxREdTYmRD?=
 =?utf-8?B?cXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D22FE6401083294094E99652193AC864@namprd10.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 348fdb10-e843-4b8d-07df-08d9a62cbd81
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 22:35:33.6194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qT98uLGCdvgqvbcVUNGwzYqnnKvlODLTynNj4xpdIjbOPQjx0WDPGPzmVIA4KsMozlYXZQIfYzQ2e9f7Mm16aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5454
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10166 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111120113
X-Proofpoint-GUID: sKh_2H-_3pb7mIGjlMxXfz-yxs9W6OE7
X-Proofpoint-ORIG-GUID: sKh_2H-_3pb7mIGjlMxXfz-yxs9W6OE7

T24gMTEvMTIvMjAyMSAxMToyNCBBTSwgRGFuIFdpbGxpYW1zIHdyb3RlOg0KPiBPbiBGcmksIE5v
diAxMiwgMjAyMSBhdCA5OjU4IEFNIEphbmUgQ2h1IDxqYW5lLmNodUBvcmFjbGUuY29tPiB3cm90
ZToNCj4+DQo+PiBPbiAxMS8xMS8yMDIxIDQ6NTEgUE0sIERhbiBXaWxsaWFtcyB3cm90ZToNCj4+
PiBPbiBUaHUsIE5vdiAxMSwgMjAyMSBhdCA0OjMwIFBNIEphbmUgQ2h1IDxqYW5lLmNodUBvcmFj
bGUuY29tPiB3cm90ZToNCj4+Pj4NCj4+Pj4gSnVzdCBhIHF1aWNrIHVwZGF0ZSAtDQo+Pj4+DQo+
Pj4+IEkgbWFuYWdlZCB0byB0ZXN0IHRoZSAnTlAnIGFuZCAnVUMnIGVmZmVjdCBvbiBhIHBtZW0g
ZGF4IGZpbGUuDQo+Pj4+IFRoZSByZXN1bHQgaXMsIGFzIGV4cGVjdGVkLCBib3RoIHNldHRpbmcg
J05QJyBhbmQgJ1VDJyB3b3Jrcw0KPj4+PiB3ZWxsIGluIHByZXZlbnRpbmcgdGhlIHByZWZldGNo
ZXIgZnJvbSBhY2Nlc3NpbmcgdGhlIHBvaXNvbmVkDQo+Pj4+IHBtZW0gcGFnZS4NCj4+Pj4NCj4+
Pj4gSSBpbmplY3RlZCBiYWNrLXRvLWJhY2sgcG9pc29ucyB0byB0aGUgM3JkIGJsb2NrKDUxMkIp
IG9mDQo+Pj4+IHRoZSAzcmQgcGFnZSBpbiBteSBkYXggZmlsZS4gIFdpdGggJ05QJywgdGhlICdt
Y19zYWZlIHJlYWQnDQo+Pj4+IHN0b3BzICBhZnRlciByZWFkaW5nIHRoZSAxc3QgYW5kIDJuZCBw
YWdlcywgd2l0aCAnVUMnLA0KPj4+PiB0aGUgJ21jX3NhZmUgcmVhZCcgd2FzIGFibGUgdG8gcmVh
ZCBbMiBwYWdlcyArIDIgYmxvY2tzXSBvbg0KPj4+PiBteSB0ZXN0IG1hY2hpbmUuDQo+Pj4NCj4+
PiBNeSBleHBlY3RhdGlvbiBpcyB0aGF0IGRheF9kaXJlY3RfYWNjZXNzKCkgLyBkYXhfcmVjb3Zl
cnlfcmVhZCgpIGhhcw0KPj4+IGluc3RhbGxlZCBhIHRlbXBvcmFyeSBVQyBhbGlhcyBmb3IgdGhl
IHBmbiwgb3IgaGFzIHRlbXBvcmFyaWx5IGZsaXBwZWQNCj4+PiBOUCB0byBVQy4gT3V0c2lkZSBv
ZiBkYXhfcmVjb3ZlcnlfcmVhZCgpIHRoZSBwYWdlIHdpbGwgYWx3YXlzIGJlIE5QLg0KPj4+DQo+
Pg0KPj4gT2theS4gIENvdWxkIHdlIG9ubHkgZmxpcCB0aGUgbWVtdHlwZSB3aXRoaW4gZGF4X3Jl
Y292ZXJ5X3JlYWQsIGFuZA0KPj4gbm90IHdpdGhpbiBkYXhfZGlyZWN0X2FjY2Vzcz8gIGRheF9k
aXJlY3RfYWNjZXNzIGRvZXMgbm90IG5lZWQgdG8NCj4+IGFjY2VzcyB0aGUgcGFnZS4NCj4gDQo+
IFRydWUsIGRheF9kaXJlY3RfYWNjZXNzKCkgZG9lcyBub3QgbmVlZCB0byBkbyB0aGUgcGFnZSBw
ZXJtaXNzaW9uDQo+IGNoYW5nZSwgaXQganVzdCBuZWVkcyB0byBpbmRpY2F0ZSBpZiBkYXhfcmVj
b3Zlcnlfe3JlYWQsd3JpdGV9KCkgbWF5DQo+IGJlIGF0dGVtcHRlZC4gSSB3YXMgdGhpbmtpbmcg
dGhhdCB0aGUgREFYIHBhZ2VzIG9ubHkgZmxvYXQgYmV0d2VlbiBOUA0KPiBhbmQgV0IgZGVwZW5k
aW5nIG9uIHdoZXRoZXIgcG9pc29uIGlzIHByZXNlbnQgaW4gdGhlIHBhZ2UuIElmDQo+IGRheF9y
ZWNvdmVyeV9yZWFkKCkgd2FudHMgdG8gZG8gVUMgcmVhZHMgYXJvdW5kIHRoZSBwb2lzb24gaXQg
Y2FuIHVzZQ0KPiBpb3JlbWFwKCkgb3Igdm1hcCgpIHRvIGNyZWF0ZSBhIHRlbXBvcmFyeSBVQyBh
bGlhcy4gVGhlIHRlbXBvcmFyeSBVQw0KPiBhbGlhcyBpcyBvbmx5IHBvc3NpYmxlIGlmIHRoZXJl
IG1pZ2h0IGJlIG5vbi1jbG9iYmVyZWQgZGF0YSByZW1haW5pbmcNCj4gaW4gdGhlIHBhZ2UuIEku
ZS4gdGhlIGN1cnJlbnQgIndob2xlX3BhZ2UoKSIgZGV0ZXJtaW5hdGlvbiBpbg0KPiB1Y19kZWNv
ZGVfbm90aWZpZXIoKSBuZWVkcyB0byBiZSBwbHVtYmVkIGludG8gdGhlIFBNRU0gZHJpdmVyIHNv
IHRoYXQNCj4gaXQgY2FuIGNvb3BlcmF0ZSB3aXRoIGEgdmlydHVhbGl6ZWQgZW52aXJvbm1lbnQg
dGhhdCBpbmplY3RzIHZpcnR1YWwNCj4gI01DIGF0IHBhZ2UgZ3JhbnVsYXJpdHkuIEkuZS4gbmZp
dF9oYW5kbGVfbWNlKCkgaXMgYnJva2VuIGluIHRoYXQgaXQNCj4gb25seSBhc3N1bWVzIGEgc2lu
Z2xlIGNhY2hlbGluZSBhcm91bmQgdGhlIGZhaWx1cmUgYWRkcmVzcyBpcw0KPiBwb2lzb25lZCwg
aXQgbmVlZHMgdGhhdCBzYW1lIHdob2xlX3BhZ2UoKSBsb2dpYy4NCj4gDQoNCkknbGwgaGF2ZSB0
byB0YWtlIHNvbWUgdGltZSB0byBkaWdlc3Qgd2hhdCB5b3UgcHJvcG9zZWQsIGJ1dCBhbGFzLCB3
aHkNCmNvdWxkbid0IHdlIGxldCB0aGUgY29ycmVjdCBkZWNpc2lvbiAoYWJvdXQgTlAgdnMgVUMp
IGJlaW5nIG1hZGUgd2hlbg0KdGhlICd3aG9sZV9wYWdlJyB0ZXN0IGhhcyBhY2Nlc3MgdG8gdGhl
IE1TaV9NSVNDIHJlZ2lzdGVyLCBpbnN0ZWFkIG9mDQpoYXZpbmcgdG8gcmlzayBtaXN0YWtlbmx5
IGNoYW5nZSBOUC0+VUMgaW4gZGF4X3JlY292ZXJ5X3JlYWQoKSBhbmQNCnJpc2sgdG8gcmVwZWF0
IHRoZSBidWcgdGhhdCBUb255IGhhcyBmaXhlZD8gIEkgbWVhbiBhIFBNRU0gcGFnZSBtaWdodA0K
YmUgbGVnaXRpbWF0ZWx5IG5vdC1hY2Nlc3NpYmxlIGR1ZSB0byBpdCBtaWdodCBoYXZlIGJlZW4g
dW5tYXBwZWQgYnkNCnRoZSBob3N0LCBidXQgZGF4X3JlY292ZXJ5X3JlYWQoKSBoYXMgbm8gd2F5
IHRvIGtub3csIHJpZ2h0Pw0KDQpUaGUgd2hvbGUgVUMgPD4gTlAgYXJndW1lbnRzIHRvIG1lIHNl
ZW1zIHRvIGJlIGENCiAgIlVDIGJlaW5nIGhhcm1sZXNzL3dvcmthYmxlIHNvbHV0aW9uIHRvIERS
QU0gYW5kIFBNRU0iICB2ZXJzdXMNCiAgIk5QIGJlaW5nIHNpbXBsZXIgcmVnYXJkbGVzcyB3aGF0
IHJpc2sgaXQgYnJpbmdzIHRvIFBNRU0iLg0KVG8gdXMsIFBNRU0gaXMgbm90IGp1c3QgYW5vdGhl
ciBkcml2ZXIsIGl0IGlzIHRyZWF0ZWQgYXMgbWVtb3J5IGJ5IG91cg0KY3VzdG9tZXIsIHNvIHdo
eT8NCg0KdGhhbmtzIQ0KLWphbmUNCg0KDQoNCg==
