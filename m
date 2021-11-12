Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFBA168
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 00:30:56 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AC06nuQ015505;
	Fri, 12 Nov 2021 00:30:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=VMjCHBzW8zpY6Ng0UTccGrilQNgKbEZ7VDEri0z5QJ4=;
 b=BgjR3yyxMrg4mIkIAuCzhBK1JbFI+NtJUM544KEkZOvPvH4KV5fUxu/BI//PwHKVri1e
 hYr93BLfI/1rD6/Na+j9vlkBwzVq1x1cPKvyMfWeJuKEgs9Fh/2+LKsANLYwHaSPSOsI
 cuPZ5CpVNZm4pyedcdMXmzgl7rgtQZkeJgVKLB6+zfcfVy+htPcMFcGfxfiFYLMC3nhP
 gIDA4t5JeTzbfwVd+k+n+ouYvNYCEO80yZQKNZwnA5gVSwUuS3pk+BIGeckpEMHO4rWy
 kjIWl2ShFMuc76QGqceyzP8zWF7y1Mr6TJ5ztwYpyHt5mUqWFhTarp+qRobg5yGuRT4O 6w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c7yq7nvxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 00:30:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AC0Fm0v032694;
	Fri, 12 Nov 2021 00:30:36 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
	by userp3030.oracle.com with ESMTP id 3c842edxyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 00:30:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixqIl9JspehNA9SaanaDk0GemgqOWnGLII4RHQD9Zpcq6YLn/VFPrRFV+9tOC1n2OG8G1uTMKzDzZk3Hvmy4WLVM27ucxUxTAiL1Akvrl9VzG76mq0k+Lep2mXoWvaCrIBXETL6/uZrwlgyzdcNJCaz+9w3PqmXEw9RtLgTVYsOvgZOjcly/K5+pk2+1/cPOC53HezQwPGIJS2j+J30G1GM11bv9eBSxXdzSDs5d+z7yYFAdzSN+s84EKit/P8x2kbz6FfcWwkYeNi6AHuUU2vHWccC1eTnqv6G/owuVucd5X9rg2Ttp8UM7kX/JMMw41+aquK074HTQIJFMTGNeFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VMjCHBzW8zpY6Ng0UTccGrilQNgKbEZ7VDEri0z5QJ4=;
 b=JKM+Ktuxv0mJROJsxECWJSYN1kEtNfsxD9aHOxg8qu+03G+wcE4Ude2JhhmRUIaR0dTq2X9tofvyYEg8k1Zu1ip6zst/gNFR7dyn4ayTgv5afYy1hDq0lCVImRVDNaiNx3XikRb359iER6oXiv9nuIWg5/0vw/yiVY/NYxDW6MMS7DoAfWNKZ37ulsjHqivvnyB9F8dObEWTcdPjBwkP+YneDKrUm3lLmRmniVzPend/K+P0dWlGw2dz/hvFUIeMpxazAf2qWEL2K19b9c81XrCQIg5G0kgg3Gxm/Ox+TSEFT+7Oo7o4Yn+F8RecT4kAf2joseH/rp+wCT2YhVA4tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMjCHBzW8zpY6Ng0UTccGrilQNgKbEZ7VDEri0z5QJ4=;
 b=Fu5Z2XgQK5qcTtWIT8zSFra79/W+wgiSsfZQ7MjF9us0aEFZzqX01HfQwE/NUcQvLm+A26G6QCX5wMsCQj6CHz+rEeQzsgqWiBf85OQqU6zsoNeJ76Lhc2bGtXfb/Wm2XfcDPrEHh5IN3KM3CM6rrojKX4jYlZscOVl13rrnicc=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BYAPR10MB3415.namprd10.prod.outlook.com (2603:10b6:a03:15a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Fri, 12 Nov
 2021 00:30:33 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::418c:dfe4:f3ee:feaa]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.019; Fri, 12 Nov 2021
 00:30:33 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Borislav Petkov <bp@alien8.de>, Dan Williams <dan.j.williams@intel.com>
CC: "Luck, Tony" <tony.luck@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>,
        Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Topic: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Index: 
 AQHXcsuUGdCdj5TLi0qPljMZ83rdmquiLs2AgAISgwCAARWOAIACN9EAgAD6fICABatcAIAPJJmAgAACXwCAACIPAIAABBsAgAAEnACAAAQRgIAABMWAgAABtoCAAAQ3AIAAA0SAgAAEIoCAAAXwAIAADw6AgAAjpgCAABYKgIAAk30AgABlNoCAABYmgIAABQ6AgAEIqwCAPjKpgIABmROA
Date: Fri, 12 Nov 2021 00:30:33 +0000
Message-ID: <7ae58b24-ad48-7afa-c023-23ccf28e3994@oracle.com>
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
In-Reply-To: <48c47c52-499a-8721-350a-5ac55a9a70de@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
authentication-results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff334965-e44c-4fa5-8c92-08d9a573a3d8
x-ms-traffictypediagnostic: BYAPR10MB3415:
x-microsoft-antispam-prvs: 
 <BYAPR10MB34154196753DC9C32622EF37F3959@BYAPR10MB3415.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 x0E5bazlWFVgVyWqJDIImF0pz0rFsEket4bAtLje8YLn+k2sOeXYmbZeu8cHURZ1d9mXXgB0GF8FhSzjr93Ot589C5ScDxa5NSliDwXIYlH9GMZCYIAfOMhT4VoOBD31qnimoRPaJc9xqdNlf6ea9W3GDvIv9kWau8PfTxomcZn7VECAKCaA21szOJqr44nsK/72cMx6unS4yyhlJOrDXH0Lw2O7hHMUBmEpeqpxVSYzn7WwARKno6KM85Ivq9KSpX79KZUiNr1ypp6e+fdCFAq2/fyAnx/B2dN+Vnr+WUl7bWcQLt/3pZEOnrRMShJpvgoQBAnz7UMfm2jtqVZ2/LmH2nYHesYLlin8k9DYKeKzSXasT6vaDj2kzvuqUvMu0idjA/V9Hz1JmyzzlRHshLBhwu+rzH72aAXEyP5G2V1/dm6aNH9qm20guFyCH8AJpYzJDsk7Ll1trU3CkVgBbMP3d16EGo+s+8WJFBMMKCSJTN0EdJi4dxWlTjjx0pD7atPNCrHHJ91Ktr5XPlrBHhfFrlSVjVkecA6+uFtxyox12vsClYMuu4Ef02ru0oWSLSLNH1JhjNzzeqz9OZcuS4tgEQHk0F9WFkzgvmEaIGR3DWGjHzaW/UsSm95wIC/JEcSL0njc9uvPwdlpGLTNDnbUi2dzhOo9MpWO6MGLU0c+zmSH7JJWhmbRY+I6Wakclc1/2KdrMliL+QvCPy4FzNNL4Oe8uF3m6IwHD9Xe9a1ihWVDqCZ7qycldej0DIg3dQ1BlYWbhmKNXHbL3v3EmA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(186003)(4326008)(64756008)(8676002)(71200400001)(8936002)(38100700002)(53546011)(31686004)(26005)(38070700005)(122000001)(36756003)(6506007)(5660300002)(83380400001)(316002)(508600001)(6512007)(31696002)(6486002)(54906003)(66446008)(66476007)(66556008)(86362001)(2616005)(76116006)(110136005)(2906002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?Y0VHK0hiR1lJWnpFb1Vkc01VNFlVSjMvVW1EK2RCNkdoYi8yRDIxS0RxRmE4?=
 =?utf-8?B?bE8yUFFqRDBHTEFNNWwvRXNyR2F6dEl0Y1g5MkxDNzNDVXM4TTZNei9XL3Fk?=
 =?utf-8?B?ajBOV2loU0RPcG8rOVZSNHhaeEVHTjUyY2RSTFBwVkpMckdIUmtFSmEvOUxr?=
 =?utf-8?B?YndzQmJOdVRLbG5CWDZvayt0bFp0NDBZTWMzTUE1M3o4OHQ3ekV5MXVVNjdq?=
 =?utf-8?B?bFVtb0dBM056dXZDR3I1YmpzSWR5TU5ZNVVmZmo1QlRBRHBWa0FFQ2NOWlNM?=
 =?utf-8?B?UXhXKzZnRllFUTBFb2VobnFtMTFRVWtua1FsU0tWNkd6czllVWs4STQ3SUI3?=
 =?utf-8?B?cEdrSllJNkhYTDAwQ0FvSDFhZi96SUM4OWVVRFNlZ2FDSC9qYThxR2EzWFZn?=
 =?utf-8?B?RmdVVDM4ZHFkRDhaUGNmUGwrS0VxMVN5UEIydFk2TXhxeEo1Qm5VbUhPWHlu?=
 =?utf-8?B?ZlJIejNuci9NVkVGTFBCTjdINTkxVmxaWUc0anVvUG4zWEJRbVh5cFlFM2pj?=
 =?utf-8?B?ZXovM2NtUXBsdkt2OUZXTzVJcU9SZHY3VTIxQW1VVThpRFUxTUxwQVRhY2w1?=
 =?utf-8?B?bDEzSkZMVkF2QW41cWMvbng4VC8xQ2NpWC9QSTY4YlFKZVZMaVlBNzlQZjZS?=
 =?utf-8?B?SnN6UkkyWHI0QnZCTEdOMmpuem45NGpIeU50RThKOHFnT01STENwRVhvRk9n?=
 =?utf-8?B?Ri9zK2ptYkNRaFd3UURtZlQvWTNGWGVSNkxVZUNZMklmMHBObEdFVkpvT1pt?=
 =?utf-8?B?SWZ4VGI1OTJQZHRCbUpOUHhxeFlOT0VVNmhzbXBrZ2Z5ellBblJGNXp6Vlhk?=
 =?utf-8?B?T3NUT2Vmd002OW9QTFN0dFZPQk1RS2VWb2FSSDJLdHNJMXNZYzdWR3lrdW1C?=
 =?utf-8?B?MnlnMFgza1A5bmtmYnZ2bW9KeHlNY3dsWGVkaHEwSUtBc0NJTHFlZVoxYVlP?=
 =?utf-8?B?cE52NUFhL1NUVzcrYkNoRGM5MnBwRTVZTGhTUUJQZkgxdCtWWjJ0ekxjRmZO?=
 =?utf-8?B?MkZPTjQvMXZDYS9Nb1FQeEpDcER2MzlwTUJVemU0MGp5NjltNUszM3RuZTNn?=
 =?utf-8?B?blZYUG9GWG9mR0tLZmkwTGUxRktVRHZGL2tuc3dpelUxdlhxTWJ2ODVZNWRx?=
 =?utf-8?B?eklLVDR0clpzUTAxUjF0TnlyYlhsWlBrdHRwcktKQUEyOGJJWUw0VW1MWlJh?=
 =?utf-8?B?NVp3elo5bG1NeWdhbU01ZWtMZ1doYXVkVHpmdmxCWlJ3THBIRkYvWXFrV0JX?=
 =?utf-8?B?N3lnUHRudFhweWthK3Jaamg0NGF5RkltbzZRUU10dm5RUmo4azRSOG9PenZY?=
 =?utf-8?B?UWRwK2RNN3UvMG1Ob0xxM2l1OVNxZm1wTVFUZFF3WXNHNFVPU0lNanhpQ0JD?=
 =?utf-8?B?c09qWDYyNFJGTERrZkdlcWRnRmRVYzRtanJnelJ6bXg1eTdDUmNGY1NKM2Fw?=
 =?utf-8?B?eXdzNXJRdm9xckhDZ0k3RVFYeVpVZm5hSU5kWnhhMGVuN2hGenYzc3B5blJw?=
 =?utf-8?B?MUpCeE0yeEg4NE5DZHJZS050ZFVDWVNUSWpBSzJ1T016ekVySjV2WDEvWUNW?=
 =?utf-8?B?MFdMSEFZdktDTmk2ZWZSQ0R3VTJDRk4wK1FwQzUrRnQ5NG4wWmZJRDB3enN5?=
 =?utf-8?B?RXNOR3ZmT3kraHZMN0RMMnZYNDFUdXVPWWhCQXp1NGpUY1VpVTFCQ1ErMDRY?=
 =?utf-8?B?UWFKRVA4UTBhc000L2FwSWY5d0s3OWFKamxiM0E4SHdSUGhqN3AwcVk3R2Nh?=
 =?utf-8?B?K09PTjZJeVJEczFKUldFNk9OekJXZElrdXpjSTAyTm9UM2hNYUxENmRyMVZv?=
 =?utf-8?B?dFNZakcvZUhJcjJmWUxHSDUzNk5LS1kwRy9yME1tWmF2M2QvcVlSUW1GcXBu?=
 =?utf-8?B?VVU1WHJOYTlUVEtvWHloODM3VXlibGFjSG5UdnBqbzJkc0o5WTVOaE5FcWdZ?=
 =?utf-8?B?Sll2eFdLOCtuV1RwSnBkMnJibDd1dEM3YWtybmpxd29tWlNMQnhMeENtd0cx?=
 =?utf-8?B?UVFuZG0yN3BWcGZQS0l1L250bmVPTC9sTGZsVDBPbm00Y1UrTlptenZYcyti?=
 =?utf-8?B?dXdIa05ZTU1DT3dFZFhjaFhHdmtPelBFZllJOER5ZXdsanFObHVmbnJCZ2E3?=
 =?utf-8?B?dWlqWmdSZEF1N0pFN1hFS3doL0QzRG85MXVxU01xRDFtVjZuSXVlUUVUNXlD?=
 =?utf-8?B?b2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D09257C10950EC499BF930062C984E7E@namprd10.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ff334965-e44c-4fa5-8c92-08d9a573a3d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 00:30:33.7081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f6e/JAib1BwcPtpZYkQM5aiP5oFlfLAQ7F46VHZnH1/e98qovp0ml8x5F5wq4pzwju2YG7ffGe6FejFhMnaTiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3415
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111120000
X-Proofpoint-GUID: 3Zi99tP5zi3Exavu_VBCDcaS1BwdrqOo
X-Proofpoint-ORIG-GUID: 3Zi99tP5zi3Exavu_VBCDcaS1BwdrqOo

SnVzdCBhIHF1aWNrIHVwZGF0ZSAtDQoNCkkgbWFuYWdlZCB0byB0ZXN0IHRoZSAnTlAnIGFuZCAn
VUMnIGVmZmVjdCBvbiBhIHBtZW0gZGF4IGZpbGUuDQpUaGUgcmVzdWx0IGlzLCBhcyBleHBlY3Rl
ZCwgYm90aCBzZXR0aW5nICdOUCcgYW5kICdVQycgd29ya3MNCndlbGwgaW4gcHJldmVudGluZyB0
aGUgcHJlZmV0Y2hlciBmcm9tIGFjY2Vzc2luZyB0aGUgcG9pc29uZWQNCnBtZW0gcGFnZS4NCg0K
SSBpbmplY3RlZCBiYWNrLXRvLWJhY2sgcG9pc29ucyB0byB0aGUgM3JkIGJsb2NrKDUxMkIpIG9m
DQp0aGUgM3JkIHBhZ2UgaW4gbXkgZGF4IGZpbGUuICBXaXRoICdOUCcsIHRoZSAnbWNfc2FmZSBy
ZWFkJw0Kc3RvcHMgIGFmdGVyIHJlYWRpbmcgdGhlIDFzdCBhbmQgMm5kIHBhZ2VzLCB3aXRoICdV
QycsDQp0aGUgJ21jX3NhZmUgcmVhZCcgd2FzIGFibGUgdG8gcmVhZCBbMiBwYWdlcyArIDIgYmxv
Y2tzXSBvbg0KbXkgdGVzdCBtYWNoaW5lLg0KDQp0aGFua3MsDQotamFuZQ0KDQoNCk9uIDExLzEw
LzIwMjEgNDowNiBQTSwgSmFuZSBDaHUgd3JvdGU6DQo+IEhpLCBBbGwsDQo+IA0KPiBTaW5jZSBJ
IHZvbHVudGVlcmVkIHRvIGFkZCBhIHBhdGNoIGluIG15IHNlcmllcyB0byBjYXB0dXJlZCB0aGUN
Cj4gaWRlYSBkaXNjdXNzZWQgaGVyZSBhYm91dCB3aGF0IHNldF9tY2Vfbm9zcGVjKCkgc2hvdWxk
IGRvLCBJIHdlbnQNCj4gYmFjayByZXJlYWQgdGhlIGRpc2N1c3Npb24uDQo+IA0KPiBUaGUgY29u
Y2x1c2lvbiBvZiB0aGUgZGlzY3Vzc2lvbiBpcyB0aGF0IHNldF9tY2Vfbm9zcGVjKCkgc2hvdWxk
DQo+IGFsd2F5cyBkbyBzZXRfbWVtb3J5X25wKCksIHJlZ2FyZGxlc3MgJ3dob2xlX3BhZ2UnLCBv
cg0KPiBEUkFNIHZzIFBNRU0gd2hpY2ggdGhlIGNvZGUgY2Fubm90IHRlbGwgYW55IHdheS4NCj4g
DQo+IEknZCBsaWtlIHRvIHZvaWNlIGNvbmNlcm4gYWJvdXQgdGhlIHJpc2sgdGhhdCBEYW4gcmFp
c2VkIGFib3V0DQo+IHRoaXMgY2hhbmdlIG9mIGJlaGF2aW9yIHRvIHBtZW0gdXNlcnMuICBZZXMs
IGluIHRoZW9yeSwgaXQncyBhbGwNCj4gZHJpdmVyJ3MgcHJvYmxlbSwgbGV0IHRoZSBkcml2ZXIg
ZGVhbCB3aXRoIGl0LiBCdXQgaW4gcmVhbGl0eSwNCj4gdGhhdCB0cmFuc2xhdGVzIHRvIG1hbnkg
dW5oYXBweSBjdXN0b21lcnMgd2hlbiB0aGVpcg0KPiBtaXNzaW9uLWNyaXRpY2FsIGFwcGxpY2F0
aW9ucyBjcmFzaCBhbmQgdGhpbmdzIGRvbid0IGdldCBmaXhlZA0KPiB0aGUgbmV4dCBkYXkuDQo+
IA0KPiBJcyB0aGUgcmlzayB1bmF2b2lkYWJsZT8gSWYgSSdtIG5vdCBtaXN0YWtlbiwgSSB0aG91
Z2h0IHRoZQ0KPiBjZW50cmFsIHBvaW50IG9mIHRoZSBkaXNjdXNzaW9uIHdhcyBhYm91dCBjbGFy
aXR5L3NpbXBsaWNpdHkNCj4gcmF0aGVyIHRoYW4gY29ycmVjdG5lc3MuICBIb3cgYWJvdXQgd2Ug
YWRkcmVzcyB0aGF0IHdpdGhvdXQNCj4gcmFpc2luZyByaXNrIHRvIGV4aXN0aW5nIGN1c3RvbWVy
cz8gIEhlcmUgaXMgbXkgcHJvcG9zZWQNCj4gd29yZGluZyB3aXRoIHRoZSBmaXggRGFuIHNlbnQg
ZWFybGllci4NCj4gDQo+ICAgICAvKg0KPiAgICAgICogc2V0X21lbW9yeV9ub3NwZWMgLSBtYWtl
IG1lbW9yeSB0eXBlIG1hcmtpbmcgaW4gb3JkZXIgdG8gcHJldmVudA0KPiAgICAgICogc3BlY3Vs
YXRpdmUgYWNjZXNzIHRvIHBvaXNvbmVkIHBhZ2UuDQo+ICAgICAgKg0KPiAgICAgICogQHBmbiAt
IHBmbiBvZiBhIHBhZ2UgdGhhdCBpcyBlaXRoZXIgcG9pc29uZWQgaW4gdGhlIHdob2xlLCBvcg0K
PiBwYXJ0aWFsbHkNCj4gICAgICAqICAgICAgIHBvaXNvbmVkLA0KPiAgICAgICogQHdob2xlX3Bh
Z2UgLSBpbmRpY2F0ZXMgd2hldGhlciB0aGUgZW50aXJlIHBhZ2UgaXMgcG9pc29uZWQgb3Igb25s
eQ0KPiAgICAgICogICAgICAgcGFydCBvZiB0aGUgcGFnZSBpcyBwb2lzb25lZCBhY2NvZGluZyB0
byB0aGUgTVNpX01JU0MgcmVnaXN0ZXIuDQo+ICAgICAgKg0KPiAgICAgICogVGhlIHBhZ2UgbWln
aHQgYmUgYSBEUkFNIG9yIGEgUE1FTSBwYWdlIHdoaWNoIHRoZSBjb2RlIGNhbm5vdCB0ZWxsLg0K
PiAgICAgICogVGhlIHBhZ2UgbWlnaHQgaGF2ZSBhbHJlYWR5IGJlZW4gdW5tYXBwZWQgKHdoZW4g
J3dob2xlX3BhZ2UnKSBpcyB0cnVlDQo+ICAgICAgKiBhbmQgbWF5IG5vdCBiZSBhY2Nlc3NlZCBp
biBhbnkgY2FzZSAoZS5nLiBndWVzdCBwYWdlKS4NCj4gICAgICAqDQo+ICAgICAgKiBUaGUgcGFn
ZSBtaWdodCBiZSBwYXJ0aWFsbHkgcG9pc29uZWQgYW5kIGhlbmNlIHRoZSBub24tcG9pc29uZWQN
Cj4gICAgICAqIGNhY2hlbGluZXMgY291bGQgYmUgc2FmZWx5IGFjY2Vzc2VkIF9pbiB0aGVvcnlf
LCBhbHRob3VnaCBwcmFjdGljYWxseSwNCj4gICAgICAqIHdoZW4gYSBEUkFNIHBhZ2UgaXMgbWFy
a2VkIFBhZ2VIV1BvaXNvbiwgdGhlIG1tLXN1YnN5c3RlbSBwcmV2ZW50cw0KPiAgICAgICogaXQg
ZnJvbSBiZWluZyBhY2Nlc3NlZCwgYnV0IHdoZW4gYSBQTUVNIHBhZ2UgaXMgbWFya2VkIFBhZ2VI
V1BvaXNvbiwNCj4gICAgICAqIGl0IGNvdWxkIHByYWN0aWNhbGx5IGJlIGFjY2Vzc2VkIGFzIGl0
IGlzIG5vdCBlbnRpcmVseSB1bmRlciB0aGUNCj4gICAgICAqIG1tLXN1YnN5c3RlbSBtYW5hZ2Vt
ZW50Lg0KPiAgICAgICoNCj4gICAgICAqIFNldHRpbmcgbWVtX3R5cGUgb2YgdGhlIHBhZ2UgdG8g
ZWl0aGVyICdOUCcgb3IgJ1VDJyBwcmV2ZW50cyB0aGUNCj4gICAgICAqIHByZWZldGNoZXIgZnJv
bSBhY2Nlc3NpbmcgdGhlIHBhZ2UsIGhlbmVjIHRoZSByZXN0IG9mIHRoZSBkZWNpc2lvbg0KPiAg
ICAgICogaXMgYmFzZWQgb24gbWluaW1pemluZyB0aGUgcmlzayBhbmQgbWF4aW1pemluZyB0aGUg
ZmxleGliaWxpdHksDQo+IHRoYXQgaXMsDQo+ICAgICAgKiBpbiBjYXNlIG9mICd3aG9sZV9wYWdl
Jywgc2V0IG1lbV90eXBlIHRvICdOUCcsIGJ1dCBmb3IgcGFydGlhbCBwYWdlDQo+ICAgICAgKiBw
b2lzb25pbmcsIHNldCBtZW1fdHlwZSB0byAnVUMnLCByZWdhcmRsZXNzIHRoZSBwYWdlIGlzIERS
QU0gb3IgUE1FTS4NCj4gICAgICAqLw0KPiBzdGF0aWMgaW5saW5lIGludCBzZXRfbWNlX25vc3Bl
Yyh1bnNpZ25lZCBsb25nIHBmbiwgYm9vbCB3aG9sZV9wYWdlKQ0KPiA8c25pcD4NCj4gICAgICAg
ICAgIGlmICh3aG9sZV9wYWdlKQ0KPiAgICAgICAgICAgICAgICAgICByYyA9IHNldF9tZW1vcnlf
bnAoZGVjb3lfYWRkciwgMSk7DQo+ICAgICAgICAgICBlbHNlIHsNCj4gICAgICAgICAgICAgICAg
ICByYyA9IF9zZXRfbWVtb3J5X3VjKGRlY295X2FkZHIsIDEpOw0KPiAgICAgICAgICAgfQ0KPiA8
c25pcD4NCj4gDQo+IENvbW1lbnRzPyBTdWdnZXN0aW9ucz8NCj4gDQo+IHRoYW5rcywNCj4gLWph
bmUNCj4gDQo+IA0KPiANCj4gDQo+IE9uIDEwLzIvMjAyMSAzOjE3IEFNLCBCb3Jpc2xhdiBQZXRr
b3Ygd3JvdGU6DQo+PiBPbiBGcmksIE9jdCAwMSwgMjAyMSBhdCAxMToyOTo0M0FNIC0wNzAwLCBE
YW4gV2lsbGlhbXMgd3JvdGU6DQo+Pj4gTXkgcmVhZCBpcyB0aGF0IHRoZSBndWVzdCBnZXRzIHZp
cnR1YWwgI01DIG9uIGFuIGFjY2VzcyB0byB0aGF0IHBhZ2UuDQo+Pj4gV2hlbiB0aGUgZ3Vlc3Qg
dHJpZXMgdG8gZG8gc2V0X21lbW9yeV91YygpIGFuZCBpbnN0cnVjdHMgY3BhX2ZsdXNoKCkNCj4+
PiB0byBkbyBjbGVhbiBjYWNoZXMgdGhhdCByZXN1bHRzIGluIHRha2luZyBhbm90aGVyIGZhdWx0
IC8gZXhjZXB0aW9uDQo+Pj4gcGVyaGFwcyBiZWNhdXNlIHRoZSBWTU0gdW5tYXBwZWQgdGhlIHBh
Z2UgZnJvbSB0aGUgZ3Vlc3Q/IElmIHRoZSBndWVzdA0KPj4+IGhhZCBmbGlwcGVkIHRoZSBwYWdl
IHRvIE5QIHRoZW4gY3BhX2ZsdXNoKCkgc2F5cyAib2gsIG5vIGNhY2hpbmcNCj4+PiBjaGFuZ2Us
IHNraXAgdGhlIGNsZmx1c2goKSBsb29wIi4NCj4+DQo+PiAuLi4gYW5kIHRoZSBDTEZMVVNIIGlz
IHRoZSBpbnNuIHdoaWNoIGNhdXNlZCB0aGUgc2Vjb25kIE1DRSBiZWNhdXNlIGl0DQo+PiAiYXBw
ZWFyZWQgdGhhdCB0aGUgZ3Vlc3Qgd2FzIGFjY2Vzc2luZyB0aGUgYmFkIHBhZ2UuIg0KPj4NCj4+
IFV1ZiwgdGhhdCBjb3VsZCBiZS4gTmFzdHkuDQo+Pg0KPj4+IFllYWgsIEkgdGhvdWdodCBVQyB3
b3VsZCBtYWtlIHRoZSBQTUVNIGRyaXZlcidzIGxpZmUgZWFzaWVyLCBidXQgaWYgaXQNCj4+PiBo
YXMgdG8gY29udGVuZCB3aXRoIGFuIE5QIGNhc2UgYXQgYWxsLCBtaWdodCBhcyB3ZWxsIG1ha2Ug
aXQgaGFuZGxlDQo+Pj4gdGhhdCBjYXNlIGFsbCB0aGUgdGltZS4NCj4+Pg0KPj4+IFNhZmUgdG8g
c2F5IHRoaXMgcGF0Y2ggb2YgbWluZSBpcyB3b2VmdWxseSBpbnN1ZmZpY2llbnQgYW5kIEkgbmVl
ZCB0bw0KPj4+IGdvIGxvb2sgYXQgaG93IHRvIG1ha2UgdGhlIGd1YXJhbnRlZXMgbmVlZGVkIGJ5
IHRoZSBQTUVNIGRyaXZlciBzbyBpdA0KPj4+IGNhbiBoYW5kbGUgTlAgYW5kIHNldCB1cCBhbGlh
cyBtYXBzLg0KPj4+DQo+Pj4gVGhpcyB3YXMgYSB1c2VmdWwgZGlzY3Vzc2lvbi4NCj4+DQo+PiBP
aCB5ZWFoLCB0aGFua3MgZm9yIHRha2luZyB0aGUgdGltZSENCj4+DQo+Pj4gSXQgcHJvdmVzIHRo
YXQgbXkgY29tbWl0Og0KPj4+DQo+Pj4gMjg0Y2U0MDExYmE2IHg4Ni9tZW1vcnlfZmFpbHVyZTog
SW50cm9kdWNlIHtzZXQsIGNsZWFyfV9tY2Vfbm9zcGVjKCkNCj4+Pg0KPj4+IC4uLndhcyBicm9r
ZW4gZnJvbSB0aGUgb3V0c2V0Lg0KPj4NCj4+IFdlbGwsIHRoZSBwcm9ibGVtIHdpdGggaHcgZXJy
b3JzIGlzIHRoYXQgaXQgaXMgYWx3YXlzIHZlcnkgaGFyZCB0byB0ZXN0DQo+PiB0aGUgY29kZS4g
QnV0IEkgaGVhciBpbmplY3Rpb24gd29ya3Mgbm93IHNvby4uLiA6LSkNCj4+DQo+PiBUaHguDQo+
Pg0KPiANCg0K
