Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E7F2C80
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 20:20:20 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACHhuOX018115;
	Fri, 12 Nov 2021 17:57:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=e79pp5OjPfOBQ1FH0dZ8GL1hwDvQ1/+Zm2dAcoC2Wsg=;
 b=V6dAefX5ScIO/8e/mfh6pziUacWstZktB25/4NBVFy1EIhpGNSk5iC5ZcXJdAYJGoJN+
 CDIc3gZe/1PPbcAuO3KLABp9JPwwpVVq6wqOkyUAvNlGz0TUHfoqVc5tk8BD5q1TOa5r
 BEbpH5oE+jkNdZEIIgqy1BErkJ61Ts19uUpWkF5U8yKkNuVjbo6xnmbYmnDEIQCLbuKX
 CTBvh5BUbEuv+IhEXPHFngRu4yt5YxCnVIwayj7TYnxz4sB1MCExW5tdt8+08Bk9q9/P
 lDX6BCflcNmcb50XBiMfhnGTqNTF1htMYWl8WRkGCpb+274wR0Uk2h8wy3Tec3gybZbE FQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c9qx3t38a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 17:57:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ACHq1g9071221;
	Fri, 12 Nov 2021 17:57:53 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
	by userp3030.oracle.com with ESMTP id 3c842fh22m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Nov 2021 17:57:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2bWr7lUXle1ZytmXQTMpMEJXPQYUQ0GftydwCOBHUEg0Myzc2KnG5SMZJnJ+5QqCEhcxkQz8uSblFieDvDmwiH+NmECWxA+ieNkOou/snyina16fQuv4R+eQiOBchN7D3z83NMcdC3yFPbvUPcjjMeJkSLspD79/BESypxZTGl1OjhPVJKK/Dr5Kz/AcN4cCfbykvzmZct/ToD8lrVzy+v3sbxeOqpQwAuuyIwgyd1sc28pyA4SuOrDV3oWuypQaeSRRq/PzTkc/rQB+FcoAOMTIptV8dFDzM3ayR9FBtxQTin5r/91V5OCmJolQuAwB331bbKAgW28S5aI1UagvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e79pp5OjPfOBQ1FH0dZ8GL1hwDvQ1/+Zm2dAcoC2Wsg=;
 b=geabttoPlHa5CgrLk0ikxngW9XLLQu9ldUUeNigeKtErZ9ELGHILa+8zuZcFXuYtAk+Ioy2VZhJFOVTkL8ys0qQhTxMImmpyKPcFxcy6Sa/c7G0FL789gwj2FjeoHAhVYnupL3X1aHObFLIRV2azKyDMGGEd3gYKcMs44kg0Ev/0wZWq3s+zYNSPOIkWGdFNK1YwwkqpQshOFF8DlYFO9WnrXgdfN9zGiAeT354wT1Kjrw7oXZQ8d4ji06U/EYURXuLvTgk3GotveKcsDK+CQbFgmUCoZzQxBaWnYGni/0WB6yAsiM66SZ1KHF2H+j23BDfL2vabOnwS2aj96HROgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e79pp5OjPfOBQ1FH0dZ8GL1hwDvQ1/+Zm2dAcoC2Wsg=;
 b=Mp5+bRqzoq8QmTFmgomCj4jxNKRXtuv46f9s6ckburSlsRwjEo7TmfY8K7QCQiD3EAl2T3r7UEPJmMsT5KlLYZl5QUdoX/CTrJv484bcdeewUWjiGDoPUDeJUk6pyhkRyuFAc0Nhs1GANpPip+p6kOQDZE6J+0EvdKnqeMRRcTM=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by SJ0PR10MB5891.namprd10.prod.outlook.com (2603:10b6:a03:3ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16; Fri, 12 Nov
 2021 17:57:51 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::418c:dfe4:f3ee:feaa]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.019; Fri, 12 Nov 2021
 17:57:51 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>,
        Linux
 NVDIMM <nvdimm@lists.linux.dev>,
        Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Topic: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Index: 
 AQHXcsuUGdCdj5TLi0qPljMZ83rdmquiLs2AgAISgwCAARWOAIACN9EAgAD6fICABatcAIAPJJmAgAACXwCAACIPAIAABBsAgAAEnACAAAQRgIAABMWAgAABtoCAAAQ3AIAAA0SAgAAEIoCAAAXwAIAADw6AgAAjpgCAABYKgIAAk30AgABlNoCAABYmgIAABQ6AgAEIqwCAPjKpgIABmROAgAAF4YCAAR65gA==
Date: Fri, 12 Nov 2021 17:57:51 +0000
Message-ID: <f80d03c6-e650-49df-81d1-309dd138de8f@oracle.com>
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
In-Reply-To: 
 <CAPcyv4imjWNuwsQKhWinq+vtuSgXAznhLXVfsy69Dq7q7eiXbA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4b8286c-8fdb-4397-f4fe-08d9a605f1d9
x-ms-traffictypediagnostic: SJ0PR10MB5891:
x-microsoft-antispam-prvs: 
 <SJ0PR10MB58913E8790BA71114E694A4CF3959@SJ0PR10MB5891.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 ZOT7rmdODSVNWVIqt9bBz9vHb1+Gm4YOpiCpLbw8K/faK5O4oWwtkdhqluttrxoKKLhmb2tvXO7mVEj0oCKsSNS5HovTxr/g2JJqf5q+jhea0Tj0U9qbbQT2cyf8KJr+hMsE2Rblz+zypAdkklTbIhQRiKq5uElPbL1aZeawJVWcejVLNichnvx+yoCrMHXGDpf/id4RqM2ZAFRYj7npfVb3ic/V9vG7kJewmdLrvt4BbEMuiYgO1lX+xInrXho/ySOFysiz2NsJ/PmIwTYt6fJ58hOOeubn4NyGSB+UxmC4ao1/dfjLmR1J/1Q+xWHMOt68oahn1e8cy9dCkkYRgFptsoEfO6I0fBUCTNdF8djCwe+zkWHByo1sVTlHmRKtxxhRNt4viZCiNcnS6IRLPNLaTpXicE1hw9mwc7O1pwYJi6wuOWwBmvL4u68mJ42vCb2to87yVGIavQMZ1172wlf3/poWpG6kvI40s4kdnMbx5A/TbtC3hHkjEUOOwBCXgfUsc2rKo26NIHsmTH/Hf31FazHQbA3hXKfBmZ74PToyaZvDywzlK0DqdQsv+L3IubuwfwbeEyAfpkZYC8hDRC0hMqNzXvdWOV8jDJY5Qm4NXj0m3e3dcp0KxnnAgqGJVE5cyJFUll6/MZRofwMj8Gsy76JOXd1gJc7pkiJFcXaH1kAziAhUPTro9khtIs0YigKNg0jD01zWMBTTWEpZu3jz/296PzmlWlf8ZszJZkpAgtZRa9ULb1a5XEitwhpEMKuwZH5kWzz8n8NMIpB8Tw==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(508600001)(316002)(5660300002)(6512007)(6486002)(66556008)(64756008)(2616005)(66946007)(26005)(76116006)(6916009)(2906002)(4744005)(36756003)(86362001)(66476007)(54906003)(6506007)(122000001)(66446008)(186003)(8676002)(4326008)(38100700002)(8936002)(53546011)(38070700005)(31696002)(83380400001)(71200400001)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?NlFwUzh4djlnSy9DVDFtK0lmM3drUlN1c2NhR1VYTTFzQUVORzBwZ0FtS2V1?=
 =?utf-8?B?YzBaRzdkK1ROTVpqenBSUXA5WGZ6bTVQOHh1Yy9QdlZjRXNJYW5RK1JoSW9k?=
 =?utf-8?B?SjBkSjVvM2JLbjlhNzk1bUU3M1dYV3JmU0N0RnB3UitaSTduY0pFSTVKOVgw?=
 =?utf-8?B?aFUrOVJBbnVSWmlublJVdGM2WXBKbkJxaGFZZDZSandvT0E1ZHV1VmJCR1BV?=
 =?utf-8?B?QUF5b0JsVXYvd25VbGFqbUdHUTlDSXAxNHFjNzNYcm50bmlPTE1CT0dVaTJN?=
 =?utf-8?B?THRURXMyWkk3bHVVRzJaZEN5bmxCanBydHAyZjhiWVljZnpMTHQxcXNQZ09Q?=
 =?utf-8?B?ZWQvOG1nQlZmMHBsTUJnRkI0d1VBZ29aODRqRUpKKzE4eGl3UitpaGhHQ1hW?=
 =?utf-8?B?cWNTamxBU2ZRdUFCY1Jlcjl6Q3FJTHJ5QlZHRW45WUh6UFM3NlhZNjJtUDJj?=
 =?utf-8?B?cmhwbERlb1c3alRDM0Vsei9aQXFZUkhRMXQ3TjlaV3ZUZGZ6SG1BcmJOZ2M5?=
 =?utf-8?B?UUlFdVNMd2FiRDhETFJDTWg3c01VZ2piNHlVVGZEVExRMm5VQXRRYmZFZ0Rv?=
 =?utf-8?B?VHFERVd4YTl6VGJPZkdhdHRBOGU3aUE5UHZ0ekRMOHlMNWJJYUtKcnRod2NF?=
 =?utf-8?B?dTE3WkN1aWl5cnI0dE1lRlVHYU1Nd3YrSzArTDIreldnMlh2THR2WDNUM200?=
 =?utf-8?B?dGJ5ay9EcktQb3BBc3lvMHh1cU1DUnA1cjVhRlFwQVBoUDQ0TlYrN0RCRTh1?=
 =?utf-8?B?TjFNN05yWWNNbFlBRC9hTWFLcjVScWFXS0hEL1dwWjJPbG1YZmNsY3lTSnZO?=
 =?utf-8?B?VVNZdFhqbzc5dlFHSEtvQWVwb0M1clRoMDFGUEQwYTlzN2R5QTBzV2E2VHd2?=
 =?utf-8?B?THlrb1Q3ZFpqenhhSHhjLzdncElZcnVZaWVMdFRLU3o3S0cyK1lXOC9ienU1?=
 =?utf-8?B?MktqVm1UNysyeTlzZy80TE9rbW1lcm5CQzJVYUxDVTRnTFV2bUZlTTlLbFdT?=
 =?utf-8?B?MHY3OE5HRC95eWhQaENza0FxUElIejZDOFhMZS9Rbm95czlXU2NBajB1S1h1?=
 =?utf-8?B?TlJlSkhORDhNZzNuaGNPOWdiajhISldobVpFK2lJZHUwRGJaWkR0d2kxZGZp?=
 =?utf-8?B?R1dkWkphUGpOR2Q3RmJ4T25Pb1FIZWVkRyt1QjMvcVVpcDMrcVBUZjFXbEtP?=
 =?utf-8?B?SStlVTZvTzJsQWtXMVJ3NjBjNFhkeEtEc0IxYWdYWWVhSEUvTnlMY2FSdlVL?=
 =?utf-8?B?RiswTXcxVFV1eGtkeFdQbWNvanNTbW5nRDJndk0yMlYvV29XWWM2WTJkaEFG?=
 =?utf-8?B?TDVndDZpSUxMOGc0V01tcitZRWFYWjdabnpQSS9jN2NyTmZlZkZxMzZTT3M0?=
 =?utf-8?B?L1p2dE01NU5qQnVMbGdSQUNyc2ZuRmFWSzZxZjdJaGlxcm1odFJ3NkpKTVpI?=
 =?utf-8?B?L25VdFJXVWtxOENBblhzekVJaDUyOEE0b2VmS1RFODloYVREMUFjM0R0RXBX?=
 =?utf-8?B?QnRxQnhTMnFUR2xjV09rbE04VmwzVTBmUko1cVluSUI4NG5qSnFOSFRJcmt5?=
 =?utf-8?B?UitDbE5zbEpUV25rcmpWMk5mSFB1SHNvMlFFaFFoNUhPL3RRR0hqYlVKZ201?=
 =?utf-8?B?bnNNRXlPTnFiL0svZGJ2aDhtSmVXWkdCVTI0cTVSMlhRN01qdHhXak5tNmNB?=
 =?utf-8?B?ZGtZazNMU2RaWEJxQnF3NGpPZE9BaTgwSGFEaVBRZXNFVEFXVEhHb3N6Z252?=
 =?utf-8?B?QWV1ZG1CUlpkY1NhMlFHSTladE92U2RFR3dCREluenlTMWh2M21HdXJaNEF5?=
 =?utf-8?B?Mk85NVhVbXVHL3JDSW9samV5dWtpSlZmR1FRNUR3aDMwNnpQRVhRbjhTR1dG?=
 =?utf-8?B?NWc3bm45bFh0NVVBY2tDcDRBK01sRDU1cG1STEsxcGlTcTg5d25WR0svTkpB?=
 =?utf-8?B?SUp0cmpjZjJrd3pscVB0WU1GelNhTUZYYmJITTNCcGE3ajFLdi8rTm1UZ0Nz?=
 =?utf-8?B?NVRTc3hCekRienNFeDZva1JzdlBTTi9iN3puaytaV1NBOGVVU2xzNDhPRkYz?=
 =?utf-8?B?NEl5SnlMSnFXbGlBWWxNZzNvQ1pVM1RkeW9XTDdmVHRuY1R6VEFiM1NPNUpt?=
 =?utf-8?B?OGNuOVNHQnFvU3FISHJXK2MxcjF5R2s0bE9LUTNaY1phY0w5ZWh1dXhmeDFp?=
 =?utf-8?B?R2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4CD5003BBEF3E14F8BBAB13DF2ECF3D9@namprd10.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b8286c-8fdb-4397-f4fe-08d9a605f1d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 17:57:51.1619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LT88I5MUsK0U3Sgc/pNPF6PTXj2lsZxIU6Ptw62yc1b2BVATdLMG3ycDr5cldijJDZ0ZuV+ktfoji+S/vlaG6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5891
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10166 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111120098
X-Proofpoint-ORIG-GUID: xKxwwwatA_0BD6ZEMuhxivc2TbcweXM2
X-Proofpoint-GUID: xKxwwwatA_0BD6ZEMuhxivc2TbcweXM2

T24gMTEvMTEvMjAyMSA0OjUxIFBNLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+IE9uIFRodSwgTm92
IDExLCAyMDIxIGF0IDQ6MzAgUE0gSmFuZSBDaHUgPGphbmUuY2h1QG9yYWNsZS5jb20+IHdyb3Rl
Og0KPj4NCj4+IEp1c3QgYSBxdWljayB1cGRhdGUgLQ0KPj4NCj4+IEkgbWFuYWdlZCB0byB0ZXN0
IHRoZSAnTlAnIGFuZCAnVUMnIGVmZmVjdCBvbiBhIHBtZW0gZGF4IGZpbGUuDQo+PiBUaGUgcmVz
dWx0IGlzLCBhcyBleHBlY3RlZCwgYm90aCBzZXR0aW5nICdOUCcgYW5kICdVQycgd29ya3MNCj4+
IHdlbGwgaW4gcHJldmVudGluZyB0aGUgcHJlZmV0Y2hlciBmcm9tIGFjY2Vzc2luZyB0aGUgcG9p
c29uZWQNCj4+IHBtZW0gcGFnZS4NCj4+DQo+PiBJIGluamVjdGVkIGJhY2stdG8tYmFjayBwb2lz
b25zIHRvIHRoZSAzcmQgYmxvY2soNTEyQikgb2YNCj4+IHRoZSAzcmQgcGFnZSBpbiBteSBkYXgg
ZmlsZS4gIFdpdGggJ05QJywgdGhlICdtY19zYWZlIHJlYWQnDQo+PiBzdG9wcyAgYWZ0ZXIgcmVh
ZGluZyB0aGUgMXN0IGFuZCAybmQgcGFnZXMsIHdpdGggJ1VDJywNCj4+IHRoZSAnbWNfc2FmZSBy
ZWFkJyB3YXMgYWJsZSB0byByZWFkIFsyIHBhZ2VzICsgMiBibG9ja3NdIG9uDQo+PiBteSB0ZXN0
IG1hY2hpbmUuDQo+IA0KPiBNeSBleHBlY3RhdGlvbiBpcyB0aGF0IGRheF9kaXJlY3RfYWNjZXNz
KCkgLyBkYXhfcmVjb3ZlcnlfcmVhZCgpIGhhcw0KPiBpbnN0YWxsZWQgYSB0ZW1wb3JhcnkgVUMg
YWxpYXMgZm9yIHRoZSBwZm4sIG9yIGhhcyB0ZW1wb3JhcmlseSBmbGlwcGVkDQo+IE5QIHRvIFVD
LiBPdXRzaWRlIG9mIGRheF9yZWNvdmVyeV9yZWFkKCkgdGhlIHBhZ2Ugd2lsbCBhbHdheXMgYmUg
TlAuDQo+IA0KDQpPa2F5LiAgQ291bGQgd2Ugb25seSBmbGlwIHRoZSBtZW10eXBlIHdpdGhpbiBk
YXhfcmVjb3ZlcnlfcmVhZCwgYW5kDQpub3Qgd2l0aGluIGRheF9kaXJlY3RfYWNjZXNzPyAgZGF4
X2RpcmVjdF9hY2Nlc3MgZG9lcyBub3QgbmVlZCB0bw0KYWNjZXNzIHRoZSBwYWdlLg0KDQp0aGFu
a3MsDQotamFuZQ0K
