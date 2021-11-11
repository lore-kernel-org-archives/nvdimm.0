Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093AE2C81
	for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 00:06:55 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AAMxQcp014401;
	Thu, 11 Nov 2021 00:06:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8pJN2SkKqo+uEhSU4VUNKL5xG6HNkxNcxi4Y5oPJnn8=;
 b=WVePO1p055uB80nnBdZBEEsCLYClodT/06mbHjhfpVptwBPciEsfdp8H11Bh5D6KWbHv
 lN3OqFzlHgTmDr7Tgu67wtOTjWJP8Z4EGImcSodICoBq97qgVjZx9PHAAF1jXbmuiF4k
 qjCC+9GaIXlRFHYhGO0JI14bHLvwz1LLdWjcQMc6B5apk01ZvRY188oKA9Lamn0s+epC
 PsfroMknH6H7rBcJYbJJcqW8tlkbN9MSBJLhEz5VdILgMty3XGmLVg3H0z7JxC+54Cky
 gYXIeRga2B5vhPUsB7EAFynv3zCBO5O/w+BzQxQcLQe91J/FJ7V4ko/t3nMyW2owMvBa aA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c85nsf8df-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Nov 2021 00:06:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AB05TnY196442;
	Thu, 11 Nov 2021 00:06:28 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
	by userp3030.oracle.com with ESMTP id 3c842d274p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Nov 2021 00:06:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHpIb3xPVIDMlE6j9j7R2f5YxsJ4uEcq7nwmD/6rS5f0SQLLbrshoyAMnL3vuBpko1srO0hdtQEZeHW3eGHy/LP5xkWId8nKaQu2/EFhGGePp0Tw7ORvAITvI0g65knKdfAd5oz2iR5YFKUdII2iP6nww84VLfy2/EvOb93gMS/nmRcYs7p45UQKNXLKzj0Be/ucbkgqUxsPbgo9E/MthVIeNWWBgsynaeJDr2ItRHNSmVhQEMX2xQt0RcTheqYnhDmKvxJeZuNEL84J87l2WaDKraFVJG9UklHRAbhzttek2JHcH3cUyZfVAboxXfMwX0PuowyRyslaTe5K2u57IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8pJN2SkKqo+uEhSU4VUNKL5xG6HNkxNcxi4Y5oPJnn8=;
 b=i0IVwOGW6Ai5AHH/U+NLnP4hWC89sC2axI69+znw8bh0yzO66b3KkPYaDzjUcyIllN2nH5qwkBvUjC8xmt5zX6fzIPRRhuMqrD7UvQWpLGkeMUqU6y4jgy4OmzHqrX4Cr+A1AGKEMzCMcHDhA75Qubqf4CGcUnx3RZiX6VfR4eB8UgjXtSMRLVuM3LQmgmOJU9c7g8eL3TuRMqDXF8wq/BCLVjPPUsfKuI0xsPGh68h33oZcw9AsH0a+SosdKOj3YwfzB1BevuBL7hgU4xerM2X4VyybitqVA7p5FXxdBtjMwGUVVi0u7CVfBAEJ4Ldp/l8R4YdcrPAdkHG0QdGyQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pJN2SkKqo+uEhSU4VUNKL5xG6HNkxNcxi4Y5oPJnn8=;
 b=D+nDjvu0WRkN2EsXsM/CLUqYp7aT1ivja377cjL0IMPwBeXtt+jVk5K729tSmw5ssLwjIe75ex7x3744o6aEIC4JuL867CR3ict/hdRbVmbG5RhVjP1OXDRMZ3YBTqIc83pmhPf+k9j3PowCdgDXS1MAgU3POQ7ajj4G9riUERo=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BYAPR10MB2693.namprd10.prod.outlook.com (2603:10b6:a02:b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 11 Nov
 2021 00:06:26 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::418c:dfe4:f3ee:feaa]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 00:06:26 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Borislav Petkov <bp@alien8.de>, Dan Williams <dan.j.williams@intel.com>
CC: "Luck, Tony" <tony.luck@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>,
        Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Topic: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Index: 
 AQHXcsuUGdCdj5TLi0qPljMZ83rdmquiLs2AgAISgwCAARWOAIACN9EAgAD6fICABatcAIAPJJmAgAACXwCAACIPAIAABBsAgAAEnACAAAQRgIAABMWAgAABtoCAAAQ3AIAAA0SAgAAEIoCAAAXwAIAADw6AgAAjpgCAABYKgIAAk30AgABlNoCAABYmgIAABQ6AgAEIqwCAPjKpgA==
Date: Thu, 11 Nov 2021 00:06:26 +0000
Message-ID: <48c47c52-499a-8721-350a-5ac55a9a70de@oracle.com>
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
 <YVgxnPWX2xCcbv19@zn.tnic>
In-Reply-To: <YVgxnPWX2xCcbv19@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
authentication-results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7923ce3-2440-4eb0-f4a6-08d9a4a71ab8
x-ms-traffictypediagnostic: BYAPR10MB2693:
x-microsoft-antispam-prvs: 
 <BYAPR10MB269356FFDBB22B827B3642B0F3949@BYAPR10MB2693.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 x0LY7EQt02yN5WJHH93WBothr+jJCPVG5yZx9PIcLqHkOy2HNtuaL1EYFBjyBHNZjfNCHdI4ZXqyQJaKtItqCmw9HMznxr8sE+u3lrZIPcknKmyOrJ7rQ5YvpAic1o9eVbhwzDr/ePKNBrnYi4vIOvuz/c89Cy5rrOc4vFUe6wGCjNgtlyn62KX6IQn7OdTYE3hy1jg2zVpOOxuYSP+mRjPpRuWSdpwBzV+umKpRdYp93xs879GU1w1AeaMOubCeleB7pFXz2yOSeL7HfhYwOILgmnKFGPYtd9bdinP36vt0C5mpIU1mBzezVyalOW3Q4E36nKa50UFCvPjQidulM7rt05S+awRXzuyCwJhm7yJdgSmX6MBhX3jeDfgyTEVprp4DacTRf/Dc0pdRRsgiST8xdZDFD7t6IJJDmXlLGWI8H75z1mGEGY6HIL4k6eLM6igqzl0oVClGRZicPvJkYdcn37hmZZarTxRAwD9uuPS8O67j7dfkKu2iTnlaDNakP/tSiAcIOajkSjRb3jaiNI7Ibxzb1ACSYEcGdu0JaSHgFKV6mA4pBuYZ7B9f7uXV1UM/M2MrmrkoofUOdPtz+j+tW7qtFr/Vdel0fd60DkSiRg4h3wnHsPaEh98MAvWYbqnbYkEgnb6jcH0DuEQ96M+nINx5+JDTWvIRSMZ62seUTU5IopIcW4nz1VH6s8Ln0VL51GHI1pXtK5ZaKcMWn0q5oOBH5+pJKxDffGkVP7rJZxM29NFFQTbDQHK7ugiLtbsNRQCgxEF77l1bjwgwNA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(64756008)(86362001)(66446008)(66556008)(66476007)(54906003)(8676002)(508600001)(6512007)(31686004)(6486002)(316002)(122000001)(4326008)(66946007)(2906002)(38100700002)(36756003)(38070700005)(8936002)(186003)(110136005)(76116006)(26005)(5660300002)(2616005)(44832011)(53546011)(6506007)(71200400001)(31696002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?UW84NkZLQSsxcWt3QXBMcjh2SVRQWmgrbUN5R1YzK1cyV3RpdlVtRXBpS3gv?=
 =?utf-8?B?dmFGTW50Nkg2d1BqNWxyT21XOG5kQWJuekJlZ25yNnFRRDI0SHBTNFFvckli?=
 =?utf-8?B?b1dZR2dzQXFpVzBZV2hOQWdWa202M0FjVE1SdjFoWGdoKzBrMnpGcFV5ZWpy?=
 =?utf-8?B?OXZRUS84L2RFMzUyd3BudGM1REYyVVoxNkxWR3I2cURRVjRLV0x4TG45Mk9I?=
 =?utf-8?B?aXhXQlFOWE5IVk13SGpSYXdaV1JNd0xzNFJoOGdack5BZU1vRk5FRVBxRG1C?=
 =?utf-8?B?YzFhUVQ0YnNLUlRtdVlPV1BIUnE2STZCYmhWd3p1ekhLT0dCWE5aaUNsOThN?=
 =?utf-8?B?Y2tacEtjeDR4TGQ3SytnbWN3OHg2cGEwbTZ3OG4zTEJ3K1crTGd3MlpvUlQ0?=
 =?utf-8?B?V0xIWURkeENhdjhKWllPMjN5QkVPVmFTMTMrSFI3bGI3RGRsQ0Z6eGlmenRI?=
 =?utf-8?B?bXI4MG9CTXJBSDIwZ2RITDMxVkJNNVZyTytpTkpObXp5WlgvRUh0OFhhTkpy?=
 =?utf-8?B?d3lxZkZQT21pNzRUTk1SUndOYnVhNmxrNXVtUU0xZi9lMitOQzB5TDRnS1Fs?=
 =?utf-8?B?ZjFuNjljWUIrUUdzazhBSHJtdmVsbk1BTmsrNFB3Ky9NYjR0bFp5bXdQcHpu?=
 =?utf-8?B?cDI0aEU4aEM1eE5yOEZFYTQ2VUhoTHQvcUxwMWJWT21YOVNWSHI4WllRYURi?=
 =?utf-8?B?SnAycVZ5cE1WczFsSVJHRG5oYk16WWd4bGl6WjJUaElFak54SEdVZ291cXI1?=
 =?utf-8?B?UFE2OXlUdU9pZDBrdXU1eFdubWNoZGNTcHNiMUVpY1ZKZHpvRzRFU05mS2ZF?=
 =?utf-8?B?L0QvMXNCUnQxUXNKeDhmYnh5WEpyVloxU1RQQVJ4MWFqZEc1MUMva2Z4cVQ1?=
 =?utf-8?B?TDNUWDF2S1I0eVlGdnlaTlAzMWg1eHBUVUhCRGFoVDcwTnhyNWE2N1VZTW41?=
 =?utf-8?B?eHd4dU0raVFrQU1teEF6TWNkeThNMHJ6d3I3NHRxdEcxdFVkQUVnaDVQMkJS?=
 =?utf-8?B?NVZJakVIdThvMGxLSjR0Yklmd3o4ZE1Ha290RmlHMUxUZGV0bFZaNEZsU1dG?=
 =?utf-8?B?aWg5UktuQTQrR2h2Y1FMTUt4Y1RjbzhQSzZNL1RYalhIS0ZHYjdCR045VHZ2?=
 =?utf-8?B?cTF5Vk4xNmRmRUFqVUFXM05sOGZwTm9NbXliZ254MXB4TElMRzZ2UUVxMHQ2?=
 =?utf-8?B?aXZTWnliVGtsbGw5N0s4ZUJoMVo0aVRyNTJubkt0NE4yWW1iRC84R2VWV1NG?=
 =?utf-8?B?ZDlvQWRYaC9wRHhyUEFDSldyVnJ0bzZOTnRuNTBIOHNqYzdZS3B3NjVKM2tN?=
 =?utf-8?B?a3d6WHdyN3N1YStlMHlZaURBb1RtOWtramV2YThYTUtnaFVEVWUrbjJIcXo4?=
 =?utf-8?B?N2ZHNXZHYWp4alhTa0dCSG1mcXYzU0JaR0ZJZHFjblpZNFM5ZFZoYndURjJH?=
 =?utf-8?B?Q2ZPNS9SQ240YjlJYkhrOEVzSzhuc0hMUkdKODBhamFic3h3WHF5U3I5a0VG?=
 =?utf-8?B?Mi9DUDN4VkFoSTV1MFIwdzVjSDA1SlMva0I5SUg5aDc0SWZVckYyMy9mK2NL?=
 =?utf-8?B?YXhUbENaaUhJYWhlRXM4SGJkREx6N0FSVFF5L1liemEzenFROHRuYkQrbURo?=
 =?utf-8?B?NUxpL2pPTEtuZGllZ29tZGxqT1hOMTI3QmFlRkk5U2srVlpkcGlXRERXSnZK?=
 =?utf-8?B?MlZxZVVPd0xsMzZjUVA1b3NCZVFBb3JYLzl4K0tyNUllM0tlOGhaR2ZEL0ox?=
 =?utf-8?B?NDl1cy9qZ3NqOC9mTDYxZnFQOFMveThXTlduVnN1ZFM4VlZMcU51QU1zczlz?=
 =?utf-8?B?ekxldWFIWG5VR08yR2V6Zm9MWkEvQnRqZUxXY2kwRERpK0gxaDQ0ZnlJRzVN?=
 =?utf-8?B?d08yblRpZGw3KzZWa04ya2NzVUtFTm8xNlhUa2FYOVpBL1FFUmxqZnZkU04r?=
 =?utf-8?B?bWdhRjBXOGQ2d0dSVG1IWFFraEQ5bjRxWHZUNnhqRlZtUkRUNWdQUWtTbkF0?=
 =?utf-8?B?N1ppZ3IyMHdqZlRkTmJnQ1F1d3NZTGFEWnRLVnpCNFpNUGVYaDJ5bVVpL2Jn?=
 =?utf-8?B?cHhRU2E3b1l0bWdlaUpyRi96aGlHQTdIUkFBRHUwSlVhV0s0dWdJaEp2bDc4?=
 =?utf-8?B?dmJLT045OENQRVFReURacmNKYUMvSVpCU3lhWlc5VmRPcEt1VXZxN09UZFdm?=
 =?utf-8?B?eVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62750D965BD97549A5C68115C378A668@namprd10.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f7923ce3-2440-4eb0-f4a6-08d9a4a71ab8
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 00:06:26.3632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XMbUXS3vQHgp4UJwPYLUs9glB0aacZCYMoQgil5oG/XiYCQq+OhC0Aa4NEDxAi5Fm80C2k30OHZMjeCO3pz24g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2693
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111100116
X-Proofpoint-GUID: 1wvyTeB9cU69NHQjrktQuheIxqiaktYm
X-Proofpoint-ORIG-GUID: 1wvyTeB9cU69NHQjrktQuheIxqiaktYm

SGksIEFsbCwNCg0KU2luY2UgSSB2b2x1bnRlZXJlZCB0byBhZGQgYSBwYXRjaCBpbiBteSBzZXJp
ZXMgdG8gY2FwdHVyZWQgdGhlDQppZGVhIGRpc2N1c3NlZCBoZXJlIGFib3V0IHdoYXQgc2V0X21j
ZV9ub3NwZWMoKSBzaG91bGQgZG8sIEkgd2VudA0KYmFjayByZXJlYWQgdGhlIGRpc2N1c3Npb24u
DQoNClRoZSBjb25jbHVzaW9uIG9mIHRoZSBkaXNjdXNzaW9uIGlzIHRoYXQgc2V0X21jZV9ub3Nw
ZWMoKSBzaG91bGQNCmFsd2F5cyBkbyBzZXRfbWVtb3J5X25wKCksIHJlZ2FyZGxlc3MgJ3dob2xl
X3BhZ2UnLCBvcg0KRFJBTSB2cyBQTUVNIHdoaWNoIHRoZSBjb2RlIGNhbm5vdCB0ZWxsIGFueSB3
YXkuDQoNCkknZCBsaWtlIHRvIHZvaWNlIGNvbmNlcm4gYWJvdXQgdGhlIHJpc2sgdGhhdCBEYW4g
cmFpc2VkIGFib3V0DQp0aGlzIGNoYW5nZSBvZiBiZWhhdmlvciB0byBwbWVtIHVzZXJzLiAgWWVz
LCBpbiB0aGVvcnksIGl0J3MgYWxsDQpkcml2ZXIncyBwcm9ibGVtLCBsZXQgdGhlIGRyaXZlciBk
ZWFsIHdpdGggaXQuIEJ1dCBpbiByZWFsaXR5LA0KdGhhdCB0cmFuc2xhdGVzIHRvIG1hbnkgdW5o
YXBweSBjdXN0b21lcnMgd2hlbiB0aGVpcg0KbWlzc2lvbi1jcml0aWNhbCBhcHBsaWNhdGlvbnMg
Y3Jhc2ggYW5kIHRoaW5ncyBkb24ndCBnZXQgZml4ZWQNCnRoZSBuZXh0IGRheS4NCg0KSXMgdGhl
IHJpc2sgdW5hdm9pZGFibGU/IElmIEknbSBub3QgbWlzdGFrZW4sIEkgdGhvdWdodCB0aGUNCmNl
bnRyYWwgcG9pbnQgb2YgdGhlIGRpc2N1c3Npb24gd2FzIGFib3V0IGNsYXJpdHkvc2ltcGxpY2l0
eQ0KcmF0aGVyIHRoYW4gY29ycmVjdG5lc3MuICBIb3cgYWJvdXQgd2UgYWRkcmVzcyB0aGF0IHdp
dGhvdXQNCnJhaXNpbmcgcmlzayB0byBleGlzdGluZyBjdXN0b21lcnM/ICBIZXJlIGlzIG15IHBy
b3Bvc2VkDQp3b3JkaW5nIHdpdGggdGhlIGZpeCBEYW4gc2VudCBlYXJsaWVyLg0KDQogICAvKg0K
ICAgICogc2V0X21lbW9yeV9ub3NwZWMgLSBtYWtlIG1lbW9yeSB0eXBlIG1hcmtpbmcgaW4gb3Jk
ZXIgdG8gcHJldmVudA0KICAgICogc3BlY3VsYXRpdmUgYWNjZXNzIHRvIHBvaXNvbmVkIHBhZ2Uu
DQogICAgKg0KICAgICogQHBmbiAtIHBmbiBvZiBhIHBhZ2UgdGhhdCBpcyBlaXRoZXIgcG9pc29u
ZWQgaW4gdGhlIHdob2xlLCBvciANCnBhcnRpYWxseQ0KICAgICogICAgICAgcG9pc29uZWQsDQog
ICAgKiBAd2hvbGVfcGFnZSAtIGluZGljYXRlcyB3aGV0aGVyIHRoZSBlbnRpcmUgcGFnZSBpcyBw
b2lzb25lZCBvciBvbmx5DQogICAgKiAgICAgICBwYXJ0IG9mIHRoZSBwYWdlIGlzIHBvaXNvbmVk
IGFjY29kaW5nIHRvIHRoZSBNU2lfTUlTQyByZWdpc3Rlci4NCiAgICAqDQogICAgKiBUaGUgcGFn
ZSBtaWdodCBiZSBhIERSQU0gb3IgYSBQTUVNIHBhZ2Ugd2hpY2ggdGhlIGNvZGUgY2Fubm90IHRl
bGwuDQogICAgKiBUaGUgcGFnZSBtaWdodCBoYXZlIGFscmVhZHkgYmVlbiB1bm1hcHBlZCAod2hl
biAnd2hvbGVfcGFnZScpIGlzIHRydWUNCiAgICAqIGFuZCBtYXkgbm90IGJlIGFjY2Vzc2VkIGlu
IGFueSBjYXNlIChlLmcuIGd1ZXN0IHBhZ2UpLg0KICAgICoNCiAgICAqIFRoZSBwYWdlIG1pZ2h0
IGJlIHBhcnRpYWxseSBwb2lzb25lZCBhbmQgaGVuY2UgdGhlIG5vbi1wb2lzb25lZA0KICAgICog
Y2FjaGVsaW5lcyBjb3VsZCBiZSBzYWZlbHkgYWNjZXNzZWQgX2luIHRoZW9yeV8sIGFsdGhvdWdo
IHByYWN0aWNhbGx5LA0KICAgICogd2hlbiBhIERSQU0gcGFnZSBpcyBtYXJrZWQgUGFnZUhXUG9p
c29uLCB0aGUgbW0tc3Vic3lzdGVtIHByZXZlbnRzDQogICAgKiBpdCBmcm9tIGJlaW5nIGFjY2Vz
c2VkLCBidXQgd2hlbiBhIFBNRU0gcGFnZSBpcyBtYXJrZWQgUGFnZUhXUG9pc29uLA0KICAgICog
aXQgY291bGQgcHJhY3RpY2FsbHkgYmUgYWNjZXNzZWQgYXMgaXQgaXMgbm90IGVudGlyZWx5IHVu
ZGVyIHRoZQ0KICAgICogbW0tc3Vic3lzdGVtIG1hbmFnZW1lbnQuDQogICAgKg0KICAgICogU2V0
dGluZyBtZW1fdHlwZSBvZiB0aGUgcGFnZSB0byBlaXRoZXIgJ05QJyBvciAnVUMnIHByZXZlbnRz
IHRoZQ0KICAgICogcHJlZmV0Y2hlciBmcm9tIGFjY2Vzc2luZyB0aGUgcGFnZSwgaGVuZWMgdGhl
IHJlc3Qgb2YgdGhlIGRlY2lzaW9uDQogICAgKiBpcyBiYXNlZCBvbiBtaW5pbWl6aW5nIHRoZSBy
aXNrIGFuZCBtYXhpbWl6aW5nIHRoZSBmbGV4aWJpbGl0eSwgDQp0aGF0IGlzLA0KICAgICogaW4g
Y2FzZSBvZiAnd2hvbGVfcGFnZScsIHNldCBtZW1fdHlwZSB0byAnTlAnLCBidXQgZm9yIHBhcnRp
YWwgcGFnZQ0KICAgICogcG9pc29uaW5nLCBzZXQgbWVtX3R5cGUgdG8gJ1VDJywgcmVnYXJkbGVz
cyB0aGUgcGFnZSBpcyBEUkFNIG9yIFBNRU0uDQogICAgKi8NCnN0YXRpYyBpbmxpbmUgaW50IHNl
dF9tY2Vfbm9zcGVjKHVuc2lnbmVkIGxvbmcgcGZuLCBib29sIHdob2xlX3BhZ2UpDQo8c25pcD4N
CiAgICAgICAgIGlmICh3aG9sZV9wYWdlKQ0KICAgICAgICAgICAgICAgICByYyA9IHNldF9tZW1v
cnlfbnAoZGVjb3lfYWRkciwgMSk7DQogICAgICAgICBlbHNlIHsNCiAgICAgICAgICAgICAgICBy
YyA9IF9zZXRfbWVtb3J5X3VjKGRlY295X2FkZHIsIDEpOw0KICAgICAgICAgfQ0KPHNuaXA+DQoN
CkNvbW1lbnRzPyBTdWdnZXN0aW9ucz8NCg0KdGhhbmtzLA0KLWphbmUNCg0KDQoNCg0KT24gMTAv
Mi8yMDIxIDM6MTcgQU0sIEJvcmlzbGF2IFBldGtvdiB3cm90ZToNCj4gT24gRnJpLCBPY3QgMDEs
IDIwMjEgYXQgMTE6Mjk6NDNBTSAtMDcwMCwgRGFuIFdpbGxpYW1zIHdyb3RlOg0KPj4gTXkgcmVh
ZCBpcyB0aGF0IHRoZSBndWVzdCBnZXRzIHZpcnR1YWwgI01DIG9uIGFuIGFjY2VzcyB0byB0aGF0
IHBhZ2UuDQo+PiBXaGVuIHRoZSBndWVzdCB0cmllcyB0byBkbyBzZXRfbWVtb3J5X3VjKCkgYW5k
IGluc3RydWN0cyBjcGFfZmx1c2goKQ0KPj4gdG8gZG8gY2xlYW4gY2FjaGVzIHRoYXQgcmVzdWx0
cyBpbiB0YWtpbmcgYW5vdGhlciBmYXVsdCAvIGV4Y2VwdGlvbg0KPj4gcGVyaGFwcyBiZWNhdXNl
IHRoZSBWTU0gdW5tYXBwZWQgdGhlIHBhZ2UgZnJvbSB0aGUgZ3Vlc3Q/IElmIHRoZSBndWVzdA0K
Pj4gaGFkIGZsaXBwZWQgdGhlIHBhZ2UgdG8gTlAgdGhlbiBjcGFfZmx1c2goKSBzYXlzICJvaCwg
bm8gY2FjaGluZw0KPj4gY2hhbmdlLCBza2lwIHRoZSBjbGZsdXNoKCkgbG9vcCIuDQo+IA0KPiAu
Li4gYW5kIHRoZSBDTEZMVVNIIGlzIHRoZSBpbnNuIHdoaWNoIGNhdXNlZCB0aGUgc2Vjb25kIE1D
RSBiZWNhdXNlIGl0DQo+ICJhcHBlYXJlZCB0aGF0IHRoZSBndWVzdCB3YXMgYWNjZXNzaW5nIHRo
ZSBiYWQgcGFnZS4iDQo+IA0KPiBVdWYsIHRoYXQgY291bGQgYmUuIE5hc3R5Lg0KPiANCj4+IFll
YWgsIEkgdGhvdWdodCBVQyB3b3VsZCBtYWtlIHRoZSBQTUVNIGRyaXZlcidzIGxpZmUgZWFzaWVy
LCBidXQgaWYgaXQNCj4+IGhhcyB0byBjb250ZW5kIHdpdGggYW4gTlAgY2FzZSBhdCBhbGwsIG1p
Z2h0IGFzIHdlbGwgbWFrZSBpdCBoYW5kbGUNCj4+IHRoYXQgY2FzZSBhbGwgdGhlIHRpbWUuDQo+
Pg0KPj4gU2FmZSB0byBzYXkgdGhpcyBwYXRjaCBvZiBtaW5lIGlzIHdvZWZ1bGx5IGluc3VmZmlj
aWVudCBhbmQgSSBuZWVkIHRvDQo+PiBnbyBsb29rIGF0IGhvdyB0byBtYWtlIHRoZSBndWFyYW50
ZWVzIG5lZWRlZCBieSB0aGUgUE1FTSBkcml2ZXIgc28gaXQNCj4+IGNhbiBoYW5kbGUgTlAgYW5k
IHNldCB1cCBhbGlhcyBtYXBzLg0KPj4NCj4+IFRoaXMgd2FzIGEgdXNlZnVsIGRpc2N1c3Npb24u
DQo+IA0KPiBPaCB5ZWFoLCB0aGFua3MgZm9yIHRha2luZyB0aGUgdGltZSENCj4gDQo+PiBJdCBw
cm92ZXMgdGhhdCBteSBjb21taXQ6DQo+Pg0KPj4gMjg0Y2U0MDExYmE2IHg4Ni9tZW1vcnlfZmFp
bHVyZTogSW50cm9kdWNlIHtzZXQsIGNsZWFyfV9tY2Vfbm9zcGVjKCkNCj4+DQo+PiAuLi53YXMg
YnJva2VuIGZyb20gdGhlIG91dHNldC4NCj4gDQo+IFdlbGwsIHRoZSBwcm9ibGVtIHdpdGggaHcg
ZXJyb3JzIGlzIHRoYXQgaXQgaXMgYWx3YXlzIHZlcnkgaGFyZCB0byB0ZXN0DQo+IHRoZSBjb2Rl
LiBCdXQgSSBoZWFyIGluamVjdGlvbiB3b3JrcyBub3cgc29vLi4uIDotKQ0KPiANCj4gVGh4Lg0K
PiANCg0K
