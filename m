Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA022C87
	for <nvdimm@lists.linux.dev>; Sat, 30 Oct 2021 03:55:55 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19U1hnTC018026;
	Sat, 30 Oct 2021 03:54:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=VznywjkuQmertv3SCv0lU9LC8GLW9WDAgcQYkKGWUuM=;
 b=Nwo5NpfKO0V7r26yN9DcMj6byjjTl3febC6IftwRWS39OWwzGex8RCXuoaoLl7CRx9Lu
 P9U9msDWwkcO1JDyTrfaxDeiQ3aJGCmiqe9EfBIr3oyJW3AMrVCgJLZ7ts6ly2Pq6dWq
 x5GsU8sGsHZQczj0lQmDwWu/K/lsVqLNwy213GD5mbmFZw96qQADPZLCbyNu62NoYmdP
 lwpr7UprP8oG3M/K2YssdPTZLu730TUnGN3m8QZNZPlKaVYeM7LjlkFozuxUCtFFWLRH
 frWYOyv2twS55dY7QDpPH3IFGNkbGzh487RNHazdZDjKzAO7FEW2aoeIo6e9FvcZ0dEW pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c0vn284au-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 30 Oct 2021 03:54:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19U3q7wi084236;
	Sat, 30 Oct 2021 03:54:44 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
	by userp3030.oracle.com with ESMTP id 3c0u5snga5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 30 Oct 2021 03:54:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cxXE4hVUrzqf4MzJxT4vcmaF6zm2/2E5Vvx0oZnO4T3ZzK6d3dD6b/vWDlODpXSlou1uo1R/pWkIbKq00ubpKPZAgtCeAGPwLhBVqA99vWTFLHA1W6kW4QGsVAmaciekMX3yM1S7Q/ykJUuFEYYxsKpBj/UIy/sLFBJI2icbKXO/SGJMUEjEE8rv6Xc/WelhluME2d5I1IjpatWIVla45d5zoNvtpfjT7IEkyuHLSCV7WGuc/MX/WlVzsowTyCrDUeSlJHBW0rrdM0B3gkmJpo8mVOl8rMv+/cgAkpmFyGSLv5lgvUBmWpajFqoPQ1uJ1m6IM6GoFQOqtYlDDqnnPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VznywjkuQmertv3SCv0lU9LC8GLW9WDAgcQYkKGWUuM=;
 b=neP+3AIw1POM3A5KRgpLQq+Lb4loldKyUTUc/Z2NYB0eUA+7dogjkS2DnU4CHQNJ3IcFyTu7lK1fuIgLE88hbznDbX1e3UAjNrCjtFUbeg5yntK9/WGpkELLPw/kzbpM8mjrHyaINujgxyVrGdHeybNdrH99OPTsQGyVmDkwWS5XTWbzlGvpOIOKQhEzttzr+01kfnYtxTC/aYP9/M9Q86v5F1AM1+OcgJRgWqtxEYoO80olLCFwGVDGidErrpZv6Jk/nyqtXGe68xI45eCKCVEEdi0QynLXNdM/wOLHd8YbnnRq2by6j4CwIfmUMsfl/BsNqM4Fwj/Cha/6jQV+jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VznywjkuQmertv3SCv0lU9LC8GLW9WDAgcQYkKGWUuM=;
 b=f8v88Yvlgth8zPCOHGtcKLf9h8iL4pxIrJPhAS/33n0VvayeZm+A0ovstOAEbUX8IISe3TlvPfLSZTImam9DCcTsIdp27TZpDapJKK44LGmftRVovfT8bPp2WO4JXc8Vfo7doTPEpFfn1kWW2J5jVti7wFrv1Sz3cDGt72kVfNA=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BYAPR10MB3510.namprd10.prod.outlook.com (2603:10b6:a03:120::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Sat, 30 Oct
 2021 03:54:41 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::401:1df2:3e9a:66c]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::401:1df2:3e9a:66c%5]) with mapi id 15.20.4628.026; Sat, 30 Oct 2021
 03:54:41 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
        Ira Weiny
	<ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        Dave Hansen
	<dave.hansen@linux.intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] dax: Kill DEV_DAX_PMEM_COMPAT
Thread-Topic: [PATCH] dax: Kill DEV_DAX_PMEM_COMPAT
Thread-Index: AQHXzBLspxA6q8Gi+E2UKYkC9Ct1jKvqr2MAgAAX5gCAACRLAA==
Date: Sat, 30 Oct 2021 03:54:41 +0000
Message-ID: <3bd1094f-8e31-6a53-93ba-072a315c335d@oracle.com>
References: 
 <163543595723.2281838.11942022992765100714.stgit@dwillia2-desk3.amr.corp.intel.com>
 <53eaa74c-0cfb-a333-4e57-8f59949b91e9@oracle.com>
 <CAPcyv4j-6tEOZg8pW_pfuftdqqFReD29e-fG0vu=GSP7YxbF2Q@mail.gmail.com>
In-Reply-To: 
 <CAPcyv4j-6tEOZg8pW_pfuftdqqFReD29e-fG0vu=GSP7YxbF2Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0534b775-0639-4cf5-967c-08d99b590093
x-ms-traffictypediagnostic: BYAPR10MB3510:
x-microsoft-antispam-prvs: 
 <BYAPR10MB35105696B4B642234FA365EFF3889@BYAPR10MB3510.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 jS8L1YjZoF29ALDnK8ZoErmJV2hhjRVxMIpU9ttg+CcIRlZkqk7eSN7dWqrWb9QsGWK0EpVpQ0WlAZa6zev7WwebWELi++MeD8PofIuAxGgpjeqMJw0j/sbxDAd7DHgqX7KaAO3Ear+iiqm0fSQ8EcJc18pEdYmI8ig5fqyySIiXG9QhCzO7ypPwdIZ2liiB1oEyIvpEQAqsZ62yXnY3ceLW3PRDVgPvkb1fq38kw+zhKkXTLa0YUYcMbSVIJB2465t1zfqrrIyi+gFHUyqLyPX0Zs4caXv3jgGL1seXsLJaadxdP9w5zSvgz1FevWKEWGls1RqeyfcZWH+T9HHLzcNoKRz2M4xqXj3I4ODIS335SZo7MKrLmQ0W5Togb695iSCoUt2HgX0reX1tH/vRxPDG9sEEEn8mkxUn/r43NdGU7Pty00uJi91t+eIO6dhIDh5gWW+Y67+uA50eol3Aw8HcCwlP22EMqWZvqstp2PiKR+4PwuZC6X3N2KF26+8oij64/LlFugKnJIq5CBNN9T5syZul8p4mOUa5G//w/69NPmpMapLMjl26uEjhC/OsnQxxh+jZqEjO+3SqnQkunl9La28Hn1fr/hl4nnBda/HeHYeSlfkK+ORRLcuErWL+8BhSBjEWSJqkkcgNDEY6Fa9aMSCn36hfKT24GMk6YwDVSFiER9DXmmQaVcw5NWF1Y8Emb/HW5grmRqrgymxatMHXNTqDE+4M1JmmL56Mvru542Vy3cKGQngMP5jgPqMpcANRaeMoOMMU8kgxDsd4/RJ6DmzRkr/109c8Fb7A9u4CVBUjHHA3R3m3DmXp2UhU/w3ddb1UTWgFFqZLnVmI9T6sOemf0U7pt35Cpu5EgIg=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(64756008)(66476007)(66446008)(5660300002)(66556008)(66946007)(54906003)(6486002)(76116006)(6512007)(8936002)(83380400001)(4326008)(31696002)(508600001)(966005)(6506007)(38070700005)(38100700002)(26005)(186003)(53546011)(8676002)(122000001)(71200400001)(31686004)(36756003)(6916009)(316002)(44832011)(2616005)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?NFEyNmpCdFV1WmhQRW9odWU4OENLVUJnY1NmdGpGTHl6aFUwMUh3emRjQWh1?=
 =?utf-8?B?L2NIcFFOWTFwNkZBYng0bDJad1dmM1FWc3J4amVwcTRUUVYydEkrcUlHR2Qz?=
 =?utf-8?B?VGpUQ1dOelI5SmZOYko5eWpxMm1HMTFnSDd3MmRqVVcrdG9hYUVBTmp1elR2?=
 =?utf-8?B?YXNva0FVaTVZSXRTTm1ZaFAyR2NhV3JsMnBtaHNjWWdGdVRwbld2QkJUQUd6?=
 =?utf-8?B?K2dSWm51ME1yeW8weUgxcXJZYWxjVTdYcGw3ZEczczdISXhZZTlhdTdtMmlj?=
 =?utf-8?B?bGZvRis1L1RjVi9ac1RVSEwvUk9WMkhYOWFSRHlnellkUUFhencwQU4ySkhF?=
 =?utf-8?B?eVppTHBsc1dmQlFjc2JHK2lLd2F4L2JOcC9meXNjRXRXUzJLbjdlNnpYREw5?=
 =?utf-8?B?NWIyNlloazExNXdrMksxa1Y4YVB0TlhjQjRjbG9ZcDJjOHAvbXRieG9idWNX?=
 =?utf-8?B?aE1NRVZwZm8wTjFtK0dLdExWamtYUnVVeGY4MlkwZnZPdFhOTDFwM3BnOUVR?=
 =?utf-8?B?ZU1KSnAwZXVQeVVXL3hBSko1Rm16dW1pQW9hT0lXZzlETWZvUUdWYm1CSUF3?=
 =?utf-8?B?S3V0N0dkeWphZHdYQTZtQUw2dnlBVzFHL1AvUlI1WUxCWGVzYVFaS3d0N0Vm?=
 =?utf-8?B?d1JmOWtvUVg4Mm5LM1ErYnE3NmY5YzF2SVc2dU55M3lVNUxOVExhRzRMSTNR?=
 =?utf-8?B?RUU1eHVRNzdSazhFWjVLL2g4NDNrL01VNEw4Slg2ejR3UDNESlNwNTNsTmx4?=
 =?utf-8?B?TkZCdHN6ZXpCU2l5ZEVRbXdlVGd0NEhzTVdSbUhFS0lRZ2NkMzZXVlo0YXQr?=
 =?utf-8?B?TjBGRFhLVHEyR1FqcW05WVVOeXpKOTQwTURUZzQwcklFVkRpWC9JVFVKNTVL?=
 =?utf-8?B?bTBWYVNXR3lOZHpOL1JWZ2V0K3FNWWIzQkY3cWQySGhPR1FrZXY4cTd5bTMz?=
 =?utf-8?B?YnZPMHlEVUQvcElpM2NqYUdqNDdjQkFaMnlHd0diRmxid21RQnBLb29GaHZB?=
 =?utf-8?B?V3lZWTVDOWsybTlqOUd6VS9RTmUrcndEcWRTRmp0d202M3o4dmNOcUI1cUY2?=
 =?utf-8?B?dk5Udk1SZ3ZWd2Rpd2FZc2JaL2hLd1ppVnFTTi9KczA4Z3k0ejR5cHp4M2tm?=
 =?utf-8?B?R2h6R0paVmVPUWxNWmFzblZpVnQvdEpoMVhmUTRNWHlDaE01UWNSNVArSkZt?=
 =?utf-8?B?ekU3aXdwd1Z6KzRjZmt3enNrS2l6K1kxcGlOOEQ5UlBub3h3RlcxUENYOURF?=
 =?utf-8?B?RWk1c3FxWjliTk9rbnh4amZlMmJHRHVhamNkVlpmVHdSZ2s1TWhwWHM2U1hH?=
 =?utf-8?B?TVBUZC96ejl4alQ1MVk2Q2k0SVNITnV3dUpOK3BGRTVYTVZCOGtSb1NYZUFX?=
 =?utf-8?B?K2QzakxmNnVEMVVsWTVwd2U0WU9PVDZBQTIrT1E2U0srbUd0WC9BV2loSndU?=
 =?utf-8?B?N0ZQaXdndXIxcXF5bVFVc2hVdGZkc25NNi9LRnMwb29QVXRUQWl1dWFrV1Qy?=
 =?utf-8?B?SnhpcXBMS0dFdG5VMm1uNStMVkxkaDVDYmZWQ3RDcjZNb0VteTVBNmk5MmdG?=
 =?utf-8?B?c05JblVtWVZpQXQ2cnN6UFZlVUVNUUZaN2RiczRGdzlLbERLNXBkVm1JOWpt?=
 =?utf-8?B?QVd3WDlraTUyZmwyWHc1RmhjUTNqS0d0YWVOTzJFUG9WVjJUTmxBdzQ0bEI3?=
 =?utf-8?B?U09HOWVTK253d25yVVIxUU4vcWxVU3NQOTgyWkNrK3BmaTZpUkJ3dFQreTl6?=
 =?utf-8?B?K0V3c2RrUDdKUjE4YkFIblpCRFZYSmFZZFcyQUlHTitqb292am5qQS9hMGVD?=
 =?utf-8?B?eTFkNDFQUXVlcEdnREVZOHAyb0g0bzdIY2dtM2NrOHZlbStNVDZIajl6Y2VW?=
 =?utf-8?B?TENMRzlMYTNHYWtRL25hSUZCQ1p3d3dPTUNHY25BK0ZTSjJRWWdCRVdaS2sr?=
 =?utf-8?B?U0lobkJHV3owTHVGajBMdHFkaUNabEZxaFZaaEZjSXBqcDBTOW85TWJkTXZL?=
 =?utf-8?B?WDFsZ0xwbC9odzNjV3J2N3JuWkxWRTkybmhGa3FHZ1pLb3llZzllSHorTzNq?=
 =?utf-8?B?ZjNyLzd5c3lDaGZGUnBpNjVDQ3RaOUdhU3RZbXhXRy96a09FdE44ZTdRN0NN?=
 =?utf-8?B?NzBYeEh6YlVTenI5QW4zcTRMYmo2TDhkMDg0OVJuVlpHbnVVZ3RJWUdEMkN5?=
 =?utf-8?B?ZXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9996C905C8607D459E0D07871F488910@namprd10.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0534b775-0639-4cf5-967c-08d99b590093
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2021 03:54:41.2448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OW96JtXJUEQ6Os69Bx8jEMGn7R7tOhH/5HyWUc8mx1pPUoot3iIxy7/KCZce0xmylAlzZqHYDQLPUwrJuLSCbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3510
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10152 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110300017
X-Proofpoint-GUID: Wfe2PoVCMuCbCw-i6pIClOrjT87KLbdz
X-Proofpoint-ORIG-GUID: Wfe2PoVCMuCbCw-i6pIClOrjT87KLbdz

T24gMTAvMjkvMjAyMSA2OjQ0IFBNLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+IE9uIEZyaSwgT2N0
IDI5LCAyMDIxIGF0IDU6MTkgUE0gSmFuZSBDaHUgPGphbmUuY2h1QG9yYWNsZS5jb20+IHdyb3Rl
Og0KPj4NCj4+IEhpLCBEYW4sDQo+Pg0KPj4gSSB0aGluayB3ZSdyZSBzdGlsbCB1c2luZyBfQ09N
UEFULCBidXQgbGlrZWx5IGRvbid0IG5lZWQgdG8uDQo+IA0KPiBVZ2gsIHJlYWxseT8gSSBob3Bl
IG5vdCwgdGhhdCB3b3VsZCBiZSB1bmZvcnR1bmF0ZS4gUGVyaGFwcyBhcmUgeW91DQo+IHVzaW5n
IGxpYm5kY3RsIC8gbGliZGF4Y3RsIHJhdGhlciB0aGFuIGdvaW5nIHRvIC9zeXMvY2xhc3MvZGF4
DQo+IGRpcmVjdGx5PyBUaG9zZSBoYXZlIHNoaXBwZWQgYmFja3dhcmRzIGNvbXBhdGliaWxpdHkg
Zm9yIGEgd2hpbGUgbm93LA0KPiBzbyBhcHBsaWNhdGlvbnMgdXNpbmcgdGhvc2UgbGlicmFyaWVz
IHNob3VsZCBub3Qgbm90aWNlIHRoZSBzd2l0Y2ggdG8NCj4gdGhlIC9zeXMvYnVzL2RheCBBQkku
IFRoZSBvbmx5IG90aGVyIG9wZW4gc291cmNlIGFwcGxpY2F0aW9uIEkgY291bGQNCj4gZmluZCB0
aGF0IGhhZCAvc3lzL2NsYXNzL2RheCBkZXBlbmRlbmNpZXMgd2FzIGZpbywgYnV0IEkgZml4ZWQg
dGhhdCB1cA0KPiB5ZWFycyBhZ28gYXMgd2VsbC4NCg0KWXVwLCB3ZSB1c2UgbGlibmRjdGwgLyBs
aWJkYXhjdGwsIHNvIHRoZSByZW1vdmFsIGxpa2VseSBpcyBva2F5Lg0KPiANCj4gICA+IFdoYXQg
aXMgeW91ciBwYXRjaCBiYXNlZCBvbj8NCj4gDQo+IFRoaXMgaXMgYmFzZWQgb24gYSBicmFuY2gg
SSBoYXZlIHdpdGggQ2hyaXN0b3BoJ3MgcmVjZW50IGRheCByZXdvcmtzLg0KPiBJIGhhdmUgYSB0
ZXN0IG1lcmdlIG9mIHRoYXQgcHVzaGVkIG91dCBvbiBteSBsaWJudmRpbW0tcGVuZGluZyBicmFu
Y2gNCj4gaWYgeW91IHdhbnQgdG8gZ2l2ZSBpdCBhIHRyeS4NCj4gDQo+IGh0dHBzOi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RqYncvbnZkaW1tLmdpdC9sb2cvP2g9
bGlibnZkaW1tLXBlbmRpbmcNCj4gDQoNCkdvdCBpdCwgdGhhbmtzIQ0KDQotamFuZQ0K
