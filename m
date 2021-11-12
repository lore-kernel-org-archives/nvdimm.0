Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F362C85
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 22:50:11 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACLn9Sp010525;
	Fri, 12 Nov 2021 22:50:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=2YGhqSFbfnCdBHxhslYow1iwXTKt9mTFXu5D+QX5ls0=;
 b=k6mrciQ7CBCOi1RinqYsRXWAD4QcQUZzK/0NdtsGnlvxONlFrR0vxiIllBKhIuAdg6gg
 /tQ9BE/8xgV0F+QKPGxqoD5RnaVAzYYsAkKmJ01bU1DwyKF391UGzKuz74Ea9Tt1D0b3
 vlx622okza7xA/CtWKHd1/U1QEUIzeD1IywHSmJ88RD4rP3509JdJSWv+K127uzYtqug
 IOoFoKpgtFPpIOWmC+5kBboUipkwhJU/JzCyrk+rWNVkLh11yAylpVUegAoKDPuWOZw5
 nklJMIExAD5HGLsyL95RFJLF7BdXtNVTcBxFZJ+tSNVluKCeQkjof5cGn86Tx8k78mrh uA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c9qmmbk6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 22:50:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ACMMF2h051123;
	Fri, 12 Nov 2021 22:50:03 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by userp3030.oracle.com with ESMTP id 3c842fv1ht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 22:50:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLK6J9Q4ijSyEGEjNXZ2cHcrRGhxbBD+c09r8ljh+G7dwyktmCzd1ZfspLwQLoa9WsSr7OdwAh6clymD/LBW4xSanaqlHqQwR04E21N3+7x2X41niugWfdcEW4yvtXfCa0KOWbgaCTmDhh5SqQQhZer5vpAEUU7nFe3kYLo4jvP06mkr9ryEmoovrJM99hkjSXn0wPN5M0q6NdZr9Dyq1tnDAB77hoJz+RrjucdXJJceyLZeeWtAoBN44e1vYaceoJYr+9GADjf2nQLvqbF/zHs/tqESgjebzNrdAuChX/0mEMVuBzaqUABBG/YZs39eljNeG1WD453dHqvqMUwxcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2YGhqSFbfnCdBHxhslYow1iwXTKt9mTFXu5D+QX5ls0=;
 b=Zq/sREWSVCYv77CFmGRO80oFId6/+3PVCPkiLAEDEgTHzRx67hJinGZkH5KH0dX3l2WlDgimFXPuPliaRGJ9yKBiqdfPc2v3gOOb3H/9wCoZ3g7Ha2KUiMKW/9IELbaMF6IjSX5p2APEAGeWrN334b1g9a05Yk5m5yo1O4OSkv2KFST3oNU5OkuAym6LRB2FgGee1kLCbyGVX7kympIJLJyP4WCQjCC469Z2nNJzme8QYo3VTBrzPyAOg6t/uppjSL3VV9S/HPrsX3I6f+JY0LBqwf7gGOTTGskGH/YUWzXPAeyBrNV7HNyUyZLoMoT9PrdbiLiRFaVASbNDed8ebA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2YGhqSFbfnCdBHxhslYow1iwXTKt9mTFXu5D+QX5ls0=;
 b=OzRTE1RbJqLHdBYLtmzJDkZHAixvvv55IVJM6Raf78pshTlLD7zblp5JcsrLm0L/nSf79wPFecmXmfddltc6UARcmeZaXHAQw3vrQaL9wo71vHZZmmTygI5mjWUvfvrPJwATyPAt1TCrFoLrAVC4kmzpWqUe4p17oVyo6ATDCi0=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BYAPR10MB2485.namprd10.prod.outlook.com (2603:10b6:a02:b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Fri, 12 Nov
 2021 22:50:00 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::418c:dfe4:f3ee:feaa]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.019; Fri, 12 Nov 2021
 22:50:00 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>,
        Linux
 NVDIMM <nvdimm@lists.linux.dev>,
        Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Topic: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Index: 
 AQHXcsuUGdCdj5TLi0qPljMZ83rdmquiLs2AgAISgwCAARWOAIACN9EAgAD6fICABatcAIAPJJmAgAACXwCAACIPAIAABBsAgAAEnACAAAQRgIAABMWAgAABtoCAAAQ3AIAAA0SAgAAEIoCAAAXwAIAADw6AgAAjpgCAABYKgIAAk30AgABlNoCAABYmgIAABQ6AgAEIqwCAPjKpgIABmROAgAAF4YCAAR65gIAAGD6AgAA1W4CAAAQKAA==
Date: Fri, 12 Nov 2021 22:50:00 +0000
Message-ID: <083bb1b5-678e-2af5-fef0-449ecfc17de5@oracle.com>
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
 <a3c07537-f623-17fb-d2b7-45500093c337@oracle.com>
In-Reply-To: <a3c07537-f623-17fb-d2b7-45500093c337@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96bb0a55-0b31-4118-417e-08d9a62ec250
x-ms-traffictypediagnostic: BYAPR10MB2485:
x-microsoft-antispam-prvs: 
 <BYAPR10MB2485733DD257741794436E34F3959@BYAPR10MB2485.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 ++AGRebZzlFw5bk4oF5+ujRWZXffieG5m3rYHTXV7l0BjLDMnIwQwViTy2fLYn2hm+BMtwhgGy1CIpfNQx8uMFfGHOUgt/fF5oxx9Y6Up7iRMzuuFu0XXIJRAWZrDNrWEv2H7vTfvLsKjgADQWYZKCxC7jMolbwfnaLaMwpQezcG9jeCFnfgBt19z0fSJE7SVHe/590bi2G+J59GyKM/qesJKfeSiJrCZMLxCVH1pw47AKWcMKV5k45roWPIEsRcHmslSd1V4+ahsn320uWsCRsRpc7199qS70KkJaFR5GDbLzjgc1SUy7OiyZxJOnPrj00qKtGfAhiMK/Zk8q46AGfho+a7FPHv3/nMr4lmWs2uxDj+RaRD8j6IldanF/5JWX0IXnwW0S4bhwW9GJQTOahDVFvk7FB4XyU5/ZkJP7hm542nJJCrxQpJ72mwqSDBtbvUaQmYmDucv4hAzFKnUCNY0XwSMmP1B47vqznlZxbcUp8vV1wuvnGkkfi3ean9vt3Cl0zoegMBzceYO2wITeds+CvFl7KkqXKA3yV4AbzgxogE2axXnVAsu6EvSDOhRblulWdsN/nX39FVGo39v3i5Y6gRBbkAhY1XnPw/2Gd4blE6sZUegl9d7qWlc3cv1XV3R21JJaq1GTsuZ6PaByfEZnXsWt78awJ8sD/wPXGuIdekMiwIzRRCur0uAqviNpuLm0noIF4Vh6aS84yHYFjAghD5PtLWxlSGpBemqbeUQX57Lh2dWR9ObWkGeoJs4V6GXUyFPsKwuCUFt5rB2w==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(36756003)(66946007)(6506007)(38100700002)(6916009)(86362001)(4326008)(508600001)(31696002)(6486002)(316002)(31686004)(83380400001)(6512007)(122000001)(76116006)(71200400001)(2616005)(8676002)(2906002)(26005)(186003)(44832011)(54906003)(66446008)(66556008)(5660300002)(8936002)(38070700005)(66476007)(64756008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?VlJ0STdrM0V5Yml1dXFvZEFIWUg1andvbFd2NkY1OC9aVEJXTWxUUkFpd3pJ?=
 =?utf-8?B?OTBJZnF4QzdwT0t3bkwvN0hpcE5Bb3J0NWUrV2JHSlNlSG9HZVZjSm1Ka1ZT?=
 =?utf-8?B?Y0xndzJZRGtIcjNJUWZzdzZkMm94amt6MGhlcDh5clVUUGFseW04Um1YZDht?=
 =?utf-8?B?dUI4TURDVnVGL2llK1libmJ3RUpKelV0eDY0WHZjZmt2WXlRZVN0YThVOWJo?=
 =?utf-8?B?MzRKQ3hDbTh3ZVZZYUU4aFpzcHRpUHJLZmszcENmN1hKN1JTVW5SZDM4Q2pi?=
 =?utf-8?B?T3JCeVJCL0loZURLQTVka09DZW80V0JNcHBUemRBUFZGWTEySGlTOHVIQWs0?=
 =?utf-8?B?emR2Z3RrSlJ3RG5ER1B6NUhrcWx4a2NnbENqdmdsN0VIWlRkZ2U3a3VaMWlu?=
 =?utf-8?B?YnNhKytqZ1Zqckt2Q1IveThHQmJOQkNoaXBDMDF2TFBWZHZ2ejJBVGxFVGo2?=
 =?utf-8?B?L1lRNXBIR3ZYWkZzanhVakhUQlZrYk5lOXJyTEkyOFVCbmsyaHdZbDhhSEtM?=
 =?utf-8?B?N1d6MXpIWVpxcGlhT0hLaFBWeXpnMXl6di9IYnVPNjRXUHpBUkNuQm9iL1lF?=
 =?utf-8?B?RHZLSHlWR1RxalN3eTRLWWZTTldKb2lDSVl6QWJ1cEJNVEFkZCs4Q2VYUkhY?=
 =?utf-8?B?SFJ5SjJhcXNBNmpPRm0vcW1lRDFtTVlQUy9XU1c0ZVJTTzNEZHU2SDRlbjJa?=
 =?utf-8?B?eDNFNnlZQlFPVVFlWGNSU3R4MzJRbUh5cHlZU3hpQnEvWUxXWThGZ0MrMkRv?=
 =?utf-8?B?Z0RsVVN6YlVxd3VVYk9TbWEwdjl1MVVYdnlBV1lNNEEydHVOV3g0WmpPQjFI?=
 =?utf-8?B?MHN6WVFydmNVQm9oeVN5V1JZdWx5cEQ5bFBmNnMrMUF1cFA2QkNoakRIMkpU?=
 =?utf-8?B?TnBUYUZybmF3VlJOUll4bXROeE00NlpKZXVBblpESjJVazZ2NWs2NFZuQXVq?=
 =?utf-8?B?M2ZiVGVuUmxkL2pwSlNtZjkzUEphZFRDWDBwemdKM1JtYzlTSFJmQTFOZStI?=
 =?utf-8?B?Q1Z3SUduZXpDM0pFbkx2UWpzTkt0TzJIOUxFUkdKWDVzdkhTMFFxY0Uydzh3?=
 =?utf-8?B?QW5rTzc4MGtSNzl5Vm1mOENPaTlwVXAzUkFKcldrRngvdmxXZGxpWk1sZnVW?=
 =?utf-8?B?cWtXU2NVbHZxdjBxTVFSQ1l4bGJQY0l0aHJyRktiZzNITmk4cmtkTUdVaEJa?=
 =?utf-8?B?QjVhWXA4RjNtR1J1YkU0eGNxYkswN3RmcjNicER3bTFTQTlrdTVBSzFrMTVo?=
 =?utf-8?B?Y0ZVS3dHdWpCTEFCLzZkaHZ6dnFCL3Vmc1ZUYlFieDFlbCtIQjgxdmVDWDZW?=
 =?utf-8?B?TkRkYUZBYWw4b1VUeW1LSmYzKy9vcVpGRXpYbkFMM1dvdzZTSzk1cmk0QmtD?=
 =?utf-8?B?M3ZMaVlCV0huSXlpNVd3NFpSRmJGY2phazZOVWRPeWhRRi9BWEN1NG9Gd3Qr?=
 =?utf-8?B?NXN3UzB4ZCtzK0xxTWFmQkhpVHJYQXpHbDRCRFZpRFNNRnErU3J1NzFWaEtK?=
 =?utf-8?B?RXlPTlRhWXEvempVYUs4V2VYVXMzb2VZd3FDaytWMjYwZnE0U2tOVm9TTjhD?=
 =?utf-8?B?OUczMXNuZE56M3pGR2hydzRqQ2NmK1BPWVpWQmpuQWFQVTFTN1Fjc2c0Wjkz?=
 =?utf-8?B?U1J5b1lYc2VDTzdzVW9VNjdqNjBXK3Y1Q1preGV5cjRkZHVRY0JKNzNOZmZ5?=
 =?utf-8?B?VlhBdGFLRDhUT1BYOS92YTRTdDNtVlMrZlZoQnFrcnhFVnBNTEViTkdMLzQ5?=
 =?utf-8?B?TnRqejczWk4vbVVFRUNhVFN5dUFjMDBGdG90MzVxbDQvZTVXOUpkaVhPZy8y?=
 =?utf-8?B?cmhyL2xEaGs1NlVkMUYxNnI4WWhuU1A5YjR0bmZzRksxRzBWTlNrdWUvZUg5?=
 =?utf-8?B?ajA2azlXSVk0UUxXeVJxbTB3YnYvS0NtUkdHdW93QW9mV1VBRGlad2o1TkN4?=
 =?utf-8?B?K1k4VGt6LzRNSDJDTng5VVROazBZbWswNUpWVzA3cWwzamtKaDdKdGRBQi9M?=
 =?utf-8?B?R0FQMGFBMXVpM3ZZT1QvRVZaQWVZTXZKUFJaRi9zc2lERlNvRHhjeGVVNlB1?=
 =?utf-8?B?OEtSMjAvL2xOWVp5UHR2MUlzR3ZDck4wUGFhaFJxVUJjVm1WcERDVWNpaEpJ?=
 =?utf-8?B?VVU5OXBsanhYQVkvR1A1OXN2Y25RK0JDdEc0eS8vaHF4Rkd6dEh1RFZHT0hY?=
 =?utf-8?B?VGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <885CF5F2794B904DB0AAB035A51BF3E3@namprd10.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 96bb0a55-0b31-4118-417e-08d9a62ec250
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 22:50:00.6549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g4DEgAWyP60Or7VxysnZXc7n6gJKKVVq04gxmOFQ/oC80tJ4Jpw341QY/nniHa8xkvuFl121kyyTQLC+2s44rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2485
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10166 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111120113
X-Proofpoint-GUID: Kp6Uqe8QxyhUPiarTocvdodtGlcBuoqt
X-Proofpoint-ORIG-GUID: Kp6Uqe8QxyhUPiarTocvdodtGlcBuoqt

T24gMTEvMTIvMjAyMSAyOjM1IFBNLCBKYW5lIENodSB3cm90ZToNCj4gT24gMTEvMTIvMjAyMSAx
MToyNCBBTSwgRGFuIFdpbGxpYW1zIHdyb3RlOg0KPj4gT24gRnJpLCBOb3YgMTIsIDIwMjEgYXQg
OTo1OCBBTSBKYW5lIENodSA8amFuZS5jaHVAb3JhY2xlLmNvbT4gd3JvdGU6DQo+Pj4NCj4+PiBP
biAxMS8xMS8yMDIxIDQ6NTEgUE0sIERhbiBXaWxsaWFtcyB3cm90ZToNCj4+Pj4gT24gVGh1LCBO
b3YgMTEsIDIwMjEgYXQgNDozMCBQTSBKYW5lIENodSA8amFuZS5jaHVAb3JhY2xlLmNvbT4gd3Jv
dGU6DQo+Pj4+Pg0KPj4+Pj4gSnVzdCBhIHF1aWNrIHVwZGF0ZSAtDQo+Pj4+Pg0KPj4+Pj4gSSBt
YW5hZ2VkIHRvIHRlc3QgdGhlICdOUCcgYW5kICdVQycgZWZmZWN0IG9uIGEgcG1lbSBkYXggZmls
ZS4NCj4+Pj4+IFRoZSByZXN1bHQgaXMsIGFzIGV4cGVjdGVkLCBib3RoIHNldHRpbmcgJ05QJyBh
bmQgJ1VDJyB3b3Jrcw0KPj4+Pj4gd2VsbCBpbiBwcmV2ZW50aW5nIHRoZSBwcmVmZXRjaGVyIGZy
b20gYWNjZXNzaW5nIHRoZSBwb2lzb25lZA0KPj4+Pj4gcG1lbSBwYWdlLg0KPj4+Pj4NCj4+Pj4+
IEkgaW5qZWN0ZWQgYmFjay10by1iYWNrIHBvaXNvbnMgdG8gdGhlIDNyZCBibG9jayg1MTJCKSBv
Zg0KPj4+Pj4gdGhlIDNyZCBwYWdlIGluIG15IGRheCBmaWxlLiAgV2l0aCAnTlAnLCB0aGUgJ21j
X3NhZmUgcmVhZCcNCj4+Pj4+IHN0b3BzICBhZnRlciByZWFkaW5nIHRoZSAxc3QgYW5kIDJuZCBw
YWdlcywgd2l0aCAnVUMnLA0KPj4+Pj4gdGhlICdtY19zYWZlIHJlYWQnIHdhcyBhYmxlIHRvIHJl
YWQgWzIgcGFnZXMgKyAyIGJsb2Nrc10gb24NCj4+Pj4+IG15IHRlc3QgbWFjaGluZS4NCj4+Pj4N
Cj4+Pj4gTXkgZXhwZWN0YXRpb24gaXMgdGhhdCBkYXhfZGlyZWN0X2FjY2VzcygpIC8gZGF4X3Jl
Y292ZXJ5X3JlYWQoKSBoYXMNCj4+Pj4gaW5zdGFsbGVkIGEgdGVtcG9yYXJ5IFVDIGFsaWFzIGZv
ciB0aGUgcGZuLCBvciBoYXMgdGVtcG9yYXJpbHkgZmxpcHBlZA0KPj4+PiBOUCB0byBVQy4gT3V0
c2lkZSBvZiBkYXhfcmVjb3ZlcnlfcmVhZCgpIHRoZSBwYWdlIHdpbGwgYWx3YXlzIGJlIE5QLg0K
Pj4+Pg0KPj4+DQo+Pj4gT2theS4gIENvdWxkIHdlIG9ubHkgZmxpcCB0aGUgbWVtdHlwZSB3aXRo
aW4gZGF4X3JlY292ZXJ5X3JlYWQsIGFuZA0KPj4+IG5vdCB3aXRoaW4gZGF4X2RpcmVjdF9hY2Nl
c3M/ICBkYXhfZGlyZWN0X2FjY2VzcyBkb2VzIG5vdCBuZWVkIHRvDQo+Pj4gYWNjZXNzIHRoZSBw
YWdlLg0KPj4NCj4+IFRydWUsIGRheF9kaXJlY3RfYWNjZXNzKCkgZG9lcyBub3QgbmVlZCB0byBk
byB0aGUgcGFnZSBwZXJtaXNzaW9uDQo+PiBjaGFuZ2UsIGl0IGp1c3QgbmVlZHMgdG8gaW5kaWNh
dGUgaWYgZGF4X3JlY292ZXJ5X3tyZWFkLHdyaXRlfSgpIG1heQ0KPj4gYmUgYXR0ZW1wdGVkLiBJ
IHdhcyB0aGlua2luZyB0aGF0IHRoZSBEQVggcGFnZXMgb25seSBmbG9hdCBiZXR3ZWVuIE5QDQo+
PiBhbmQgV0IgZGVwZW5kaW5nIG9uIHdoZXRoZXIgcG9pc29uIGlzIHByZXNlbnQgaW4gdGhlIHBh
Z2UuIElmDQo+PiBkYXhfcmVjb3ZlcnlfcmVhZCgpIHdhbnRzIHRvIGRvIFVDIHJlYWRzIGFyb3Vu
ZCB0aGUgcG9pc29uIGl0IGNhbiB1c2UNCj4+IGlvcmVtYXAoKSBvciB2bWFwKCkgdG8gY3JlYXRl
IGEgdGVtcG9yYXJ5IFVDIGFsaWFzLiBUaGUgdGVtcG9yYXJ5IFVDDQo+PiBhbGlhcyBpcyBvbmx5
IHBvc3NpYmxlIGlmIHRoZXJlIG1pZ2h0IGJlIG5vbi1jbG9iYmVyZWQgZGF0YSByZW1haW5pbmcN
Cj4+IGluIHRoZSBwYWdlLiBJLmUuIHRoZSBjdXJyZW50ICJ3aG9sZV9wYWdlKCkiIGRldGVybWlu
YXRpb24gaW4NCj4+IHVjX2RlY29kZV9ub3RpZmllcigpIG5lZWRzIHRvIGJlIHBsdW1iZWQgaW50
byB0aGUgUE1FTSBkcml2ZXIgc28gdGhhdA0KPj4gaXQgY2FuIGNvb3BlcmF0ZSB3aXRoIGEgdmly
dHVhbGl6ZWQgZW52aXJvbm1lbnQgdGhhdCBpbmplY3RzIHZpcnR1YWwNCj4+ICNNQyBhdCBwYWdl
IGdyYW51bGFyaXR5LiBJLmUuIG5maXRfaGFuZGxlX21jZSgpIGlzIGJyb2tlbiBpbiB0aGF0IGl0
DQo+PiBvbmx5IGFzc3VtZXMgYSBzaW5nbGUgY2FjaGVsaW5lIGFyb3VuZCB0aGUgZmFpbHVyZSBh
ZGRyZXNzIGlzDQo+PiBwb2lzb25lZCwgaXQgbmVlZHMgdGhhdCBzYW1lIHdob2xlX3BhZ2UoKSBs
b2dpYy4NCj4+DQo+IA0KPiBJJ2xsIGhhdmUgdG8gdGFrZSBzb21lIHRpbWUgdG8gZGlnZXN0IHdo
YXQgeW91IHByb3Bvc2VkLCBidXQgYWxhcywgd2h5DQo+IGNvdWxkbid0IHdlIGxldCB0aGUgY29y
cmVjdCBkZWNpc2lvbiAoYWJvdXQgTlAgdnMgVUMpIGJlaW5nIG1hZGUgd2hlbg0KPiB0aGUgJ3do
b2xlX3BhZ2UnIHRlc3QgaGFzIGFjY2VzcyB0byB0aGUgTVNpX01JU0MgcmVnaXN0ZXIsIGluc3Rl
YWQgb2YNCj4gaGF2aW5nIHRvIHJpc2sgbWlzdGFrZW5seSBjaGFuZ2UgTlAtPlVDIGluIGRheF9y
ZWNvdmVyeV9yZWFkKCkgYW5kDQo+IHJpc2sgdG8gcmVwZWF0IHRoZSBidWcgdGhhdCBUb255IGhh
cyBmaXhlZD8gIEkgbWVhbiBhIFBNRU0gcGFnZSBtaWdodA0KPiBiZSBsZWdpdGltYXRlbHkgbm90
LWFjY2Vzc2libGUgZHVlIHRvIGl0IG1pZ2h0IGhhdmUgYmVlbiB1bm1hcHBlZCBieQ0KPiB0aGUg
aG9zdCwgYnV0IGRheF9yZWNvdmVyeV9yZWFkKCkgaGFzIG5vIHdheSB0byBrbm93LCByaWdodD8N
Cj4gDQo+IFRoZSB3aG9sZSBVQyA8PiBOUCBhcmd1bWVudHMgdG8gbWUgc2VlbXMgdG8gYmUgYQ0K
PiAgICAiVUMgYmVpbmcgaGFybWxlc3Mvd29ya2FibGUgc29sdXRpb24gdG8gRFJBTSBhbmQgUE1F
TSIgIHZlcnN1cw0KPiAgICAiTlAgYmVpbmcgc2ltcGxlciByZWdhcmRsZXNzIHdoYXQgcmlzayBp
dCBicmluZ3MgdG8gUE1FTSIuDQoNClRoYXQgd2Fzbid0IGNsZWFyLCBsZXQgbWUgdHJ5IGFnYWlu
IC0NCg0KInJlamVjdCB0aGUgaWYtd2hvbGVfcGFnZS10aGVuLXNldC1OUC1vdGhlcndpc2Utc2V0
LVVDIHNvbHV0aW9uDQogIG9uIHRoZSBncm91bmQgb2YgRFJBTSBjYW4ndCBiZW5lZml0IGZyb20g
VUMgc2luY2UgdG8gRFJBTSB0aGUgVUMgZWZmZWN0DQogIGlzIHByYWN0aWNhbGx5IHRoZSBzYW1l
IGFzIHRoZSBOUCBlZmZlY3QsIGJ1dCBoYXJtbGVzcyBhbnl3YXkiDQoNCnZlcnN1cw0KDQoiYWNj
ZXB0IHNldC1OUC1hbHdheXMgcmVnYXJkbGVzcyB3aGF0ZXZlciByaXNrIGl0IGJyaW5ncyB0byBQ
TUVNIg0KDQo+IFRvIHVzLCBQTUVNIGlzIG5vdCBqdXN0IGFub3RoZXIgZHJpdmVyLCBpdCBpcyB0
cmVhdGVkIGFzIG1lbW9yeSBieSBvdXINCj4gY3VzdG9tZXIsIHNvIHdoeT8NCj4gDQo+IHRoYW5r
cyENCj4gLWphbmUNCj4gDQo+IA0KPiANCnRoYW5rcywNCi1qYW5lDQoNCg==
