Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8BA2C85
	for <nvdimm@lists.linux.dev>; Sat, 13 Nov 2021 05:50:12 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AD4Tx4U014038;
	Sat, 13 Nov 2021 05:50:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Qwt9oWznHeWclZ/kxxol/NwQPEu/t3MTWZTJaM2yvDI=;
 b=c0MZ2C1Vcm0Hff45qHMAmcTJm4evXLchyAPWQDZwBBMA9+zsveJ6axiZhn9PmAXe8llH
 K3x3qdBD3lKfmfC05xNj56TQ1QGjTloSj3SUWSOyWyNdZnPn0EqapSkQRR8pdUL73NMD
 OjXtM0yK3152EyJ4Y2pmKH9CBf+HQBdxZvpdOqDkgEhLtZwC8tM/8wItYDcLl5/bt1Jt
 r3Z3YoR7vBV+I5rBocSU1RT6W+JkwusbpE7mtAEKdzHDq1a2yTcTWMslm01D7BVzrLNf
 pzNI53SrB1Y9K4EzE1tYtRrP+drxO6qiZhv5brZlokrkGAqj1VBIqDGyzFFX+EDCpAzR Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ca3sd8brb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 13 Nov 2021 05:50:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AD5g0cd092812;
	Sat, 13 Nov 2021 05:50:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by userp3030.oracle.com with ESMTP id 3ca2fsfbj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 13 Nov 2021 05:50:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ex1e/YvdBaYb8qrLcW1ao+7igLiJD7NfVssq1h9Gfi2XIfNk2BU0x1Do+PMzGTPAyuaPYEdJQrJNS+yYvBLElEWjD5hpZMoUIZHyICC6LyXOjAv4Sih1aDXAA5ijUPnOv1ZqqjHWHGZP221Bqfgk37U9SXCXpca+YVHKrpxcd+Zwit/z+5Z+O3ofvM8Gfpok6pjVJksybN33YErNeH6fvKbBTDfs3siXeRJrkChkj0A6YWhLZogCmF8gmog7XVFOWWdZ6fGWG/AYM5xG8Fa77nqfUODqKvjxYPcZb5RTxTzfHuSazqImMon7OAUb+HAdIvSgSX+nGjjhTwxh5bGsIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qwt9oWznHeWclZ/kxxol/NwQPEu/t3MTWZTJaM2yvDI=;
 b=CUidpRo+Ybou0ZH8b67tBwXEQaF7KhGO+AfdBIFCrqT56LtE4XRV6xN8Gs+viJVKTePxnZJxgM8azU2X3ORrJineViMIDlXEXbt8X7dj1vCgG2J0H8sdYGySeQdr1+SRY7l7GGcGb7OJ29Qvv3Tl0Iy3Go2lOV7FSJQ4ka9XjqD3xcgXTqjR2THoXCUM8sczskkuztQQf+g1WMSKwfsaCuOGFeHn/Y5kGuHoFdT0545O9ZSPhvH5Li3ng9TbxLEC8tKmiq/Q6PBan7/4ipECp4MjyU0nj141mR0uDVJg0/ZnJG5q60f1GYwh23dHEDtpOD3f8kl2rYF7e/IwRnmDwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qwt9oWznHeWclZ/kxxol/NwQPEu/t3MTWZTJaM2yvDI=;
 b=PybIwyNj2kh84Xv4D0aRzWiItZjZsS7zkaK4h4/ciivewsJtsaKHlgKXyt0Y+vwUFdTdWOYnJ1D/Icm7NKlHrOG3dXSCO2vPFE9OqqL6S+j+GTw1j6gWjokbRAh+692isTxADimJHiYv9jwa4I6/rR24rsp/lE8lfylmrgnOikM=
Received: from CO1PR10MB4418.namprd10.prod.outlook.com (2603:10b6:303:9c::17)
 by MWHPR10MB1807.namprd10.prod.outlook.com (2603:10b6:300:109::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.19; Sat, 13 Nov
 2021 05:50:02 +0000
Received: from CO1PR10MB4418.namprd10.prod.outlook.com
 ([fe80::f12e:1d7a:66a3:3b1b]) by CO1PR10MB4418.namprd10.prod.outlook.com
 ([fe80::f12e:1d7a:66a3:3b1b%5]) with mapi id 15.20.4690.026; Sat, 13 Nov 2021
 05:50:01 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>,
        Linux
 NVDIMM <nvdimm@lists.linux.dev>,
        Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Topic: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Index: 
 AQHXcsuUGdCdj5TLi0qPljMZ83rdmquiLs2AgAISgwCAARWOAIACN9EAgAD6fICABatcAIAPJJmAgAACXwCAACIPAIAABBsAgAAEnACAAAQRgIAABMWAgAABtoCAAAQ3AIAAA0SAgAAEIoCAAAXwAIAADw6AgAAjpgCAABYKgIAAk30AgABlNoCAABYmgIAABQ6AgAEIqwCAPjKpgIABmROAgAAF4YCAAR65gIAAGD6AgAA1W4CAAAkygIAAcDKA
Date: Sat, 13 Nov 2021 05:50:01 +0000
Message-ID: <1b1600b0-b50b-3e35-3609-9503b8b960b8@oracle.com>
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
 <CAPcyv4iF0bQx0J0qrXVdCfRcS4QWaCyR1-DuXaoe59ofzH-FEw@mail.gmail.com>
In-Reply-To: 
 <CAPcyv4iF0bQx0J0qrXVdCfRcS4QWaCyR1-DuXaoe59ofzH-FEw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a760b8a1-12ac-4b91-9a71-08d9a6696f5c
x-ms-traffictypediagnostic: MWHPR10MB1807:
x-microsoft-antispam-prvs: 
 <MWHPR10MB18079C25F2C4BF352D67F2ADF3969@MWHPR10MB1807.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 TglROMUsQnzUsNMpWuIfoBR8yLVQT6Fr13/c3ksKVby/is4WDbkVrORJjARmCeDuCdUxlrqZ9mJg4E8UZ/6XbqOqffbT33GeRP8Jff6p9GLlCbmQhX0+jxbWZOghVAFGablV4SICInXQvWxwIEE5Hi8D3Bi2R5zFD+YT84FTAMv/3F+y6Qf9n+PCXb2TeSq04JYbR+f8qY6M5d6DJck/Ywv7sINqSVze9rQ6M/RFlnJFjsmFLVQLHQ92ih7V/RzGlz83gCpy/n7qCQDXP5YJ39RVF3nbKHzWPmmNcYlLqM53+N4YrhCh089sC/95GbRuZgnrUXO1rfZ4OSoimGMR0ovDbzvix+HrvvTIl9cOMF+SoL48ZXnM41H5kFue8s9/EGtALxa9ziiCYj3lv1kBWqhwps3ViaImESGS1oY7XKnnuGN9HsWXYUOx+gkE27K7FW4iH5aazYCRvfjXlmN1yoZmNIcGgDM8VTsXRuF7VU3v8J/cDytkq1yIyx5FtQDH7l8q3CfhvZhdY5+d+5PK3l09VtI+gWuV6q2vBiQDv/DP1qvILJBjcyseA9Xpi0iZwd0kpNxiXdikrD7ZGYDC5EMBqMyfEZiqiuH0i4PBoLF9JXVCMhoWh1+qIu6hie5Lah4iW0cilJH2c5AmvRQZJ3ClqF2qYW5HDDl8mL+y08fmDS7DYsz16iYbdy4t3AQ9iiv0bIPyrYSfV3gmPYUudON9PF24HUr+iemoxl4oy2s2z/S/ckWK15rNFroqb+zUJICF0Njwe615SP8VBXeHbQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4418.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(6486002)(86362001)(36756003)(38100700002)(38070700005)(316002)(122000001)(4326008)(8676002)(6512007)(6916009)(31696002)(26005)(31686004)(2616005)(5660300002)(54906003)(508600001)(76116006)(66446008)(66556008)(64756008)(66476007)(66946007)(44832011)(6506007)(53546011)(8936002)(83380400001)(2906002)(71200400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?aEZuRUEwTFZUVC9MeTZmS0JRRVR6RzZZV25iQ0FreWN1aUJUdWZRSkdlenB0?=
 =?utf-8?B?NjhnMFJaYm95YmZPN1EyM3VBRXlwYkYvSHZTSVR5M1JqRXE0RHVIV0Zsck0x?=
 =?utf-8?B?TFNKbzA1NEd1WDZMWVBvM09LNHc1ak5TSmxXd2c5SmwwaDBMUlI5aDR0Mkxh?=
 =?utf-8?B?YkxEQVgxS0pFUlV1dnR6ZmdwQVRnUnhwRHg4MU9SMWsxUXpUV3ZpR3VxWk1y?=
 =?utf-8?B?ZkphOXZ1T1A3MllYNndOb3pVUXM1ZmVZbzg1bmlUVitJcStZY0JZN3BCNjVp?=
 =?utf-8?B?ZllhVUptR0dNSWhJSVhmclVrdURpeGN6VVcwZWpYREx5OUVQeG9XcW9pakxn?=
 =?utf-8?B?RThIYjEwWFdIeG5jSXdlem1LL0d3TFRiMFdPWDJnenIweW04RG5ydlVHRCsv?=
 =?utf-8?B?YTZ5QVI4bWpPTDZRdStuU0hiVlg1SUJCOEp5N3RUa3pxSWs0TndJbitYUmc3?=
 =?utf-8?B?dXpkaFp1N211Y3lyMkp5UlExV3drNEl0Z3l0NDEwWjlxcElXV3piOVJlY1lT?=
 =?utf-8?B?MXkwQTNBVG9QaHFaZjRUaWxIZU51RkovU1JlTTNMUE03NU13M1ByMEhnZE15?=
 =?utf-8?B?SFNLdU1DSzZ6TVJkVnFWR29JMUlra0tMZmtpZ2NnZ09TUW11S0k1WXUzRDVG?=
 =?utf-8?B?TUJaWDl2eFRobHlEZDRyekVDMDNMcjNNZllkMmN3c0NuOU5zWGs0ZU5zR2VK?=
 =?utf-8?B?N0FkNjl6V2JVY2JZYWRrd2hVY1R4UU01c2ZVYjhzSFJ5cW9LN052SDF1MnVM?=
 =?utf-8?B?UFg0Vkp6L2lxSlJ6d0hvYWpnZXUxQ0w2YUNvUkNNaXhCNHV5WTRiSzZNaVhB?=
 =?utf-8?B?TW9CdDVYakswbWJzMU9TYU1UaDJ3ck1GOTE1VnE1Wjd3SWZhVk9CbHA3dDZF?=
 =?utf-8?B?bGJabUZtMjA2L2pvSDZvakRleGNqK0x0eHlYZTd0N003QmRnaW9PbmtPTWY0?=
 =?utf-8?B?cFdBd3l5dFFZek1EL1ViVzhOdzcrb2JyVDdGRDB5Y0RxQ0ZKUlBEc1lEL3Y5?=
 =?utf-8?B?Uit6Q1VoVGcyblMzZEpqTjBRUEV1NldxVGJFM0tuK0s0Ni9BVWdSK1pmaFo5?=
 =?utf-8?B?RSszbWcyQytXdVRsYkNIREF2dzFXdFpLYUdsejlyaHYxa0VsQlN1ZUZkSDhL?=
 =?utf-8?B?UGNtbUNuVURZYTFRamJoSzVUSWJNLzNFYnV0Y3VPOVFqSUk0SFl3bE9YaSti?=
 =?utf-8?B?VTRjenhCQkd3SFp1UHRNdFdtUmpldzdqWWNXV090bHpVaE0vdHhHYWJBcmdk?=
 =?utf-8?B?QzVVYWVtM1E4YlRqWFZITzBiMU9qQmluVnNJOExwS2puamRCZ1dZVjcydkdy?=
 =?utf-8?B?MzVmaEFWK0d3NytaZk1ETFBsZitEVWlWQkRKUDk0QnhmOWdsNzZsUmFyRW5X?=
 =?utf-8?B?RW5aSmJlRU9ROUVCd1RvYkhCbnAvZGd1cStsMjR2VlY4UFpGdWZIbW1pVDFw?=
 =?utf-8?B?WnRIS2QyQkZwSkVoMHdQUklRNTRnM2Z6WnAxaUVjY3hBcFJEWk1nYlRTQWhy?=
 =?utf-8?B?YTRPeWE1VkJEMFRkQ25wNER6dk1TWmdTS1ZpbEFTdTBZY2pubmZUOUhqYTlY?=
 =?utf-8?B?RW5TNW5KTWlBWFNSRmhrbTRrOXoxYTRNTzVlQU1TeUd4MEJnanpDR3ROWmNY?=
 =?utf-8?B?bFlzNDFVZVU3RTZ4aG1UbVU3cUdJUTF1VXZsZGw4dDFIUW5QT0F2b2plZ05J?=
 =?utf-8?B?MG5GTHpOdDgxalVqTkF4azNtOFhUczBJQXNJN1JiODNsMDVmWnpORTBuUmZu?=
 =?utf-8?B?enQyVE5qT2xkY01zN2srRXpLVnphcHM0SmhzcXZnbXJSU0RoeFVGS01wZ2dt?=
 =?utf-8?B?aE9PMkUwbTVLYXhQbjZRNndDUWQ4emtwbVlFb3ZGSzNacDZhK0dHQSt2ZGp3?=
 =?utf-8?B?R0ErYm1Oa3VJUFFpTUxyZ1hqSW9nb0dRN0tiRU5qOUdmbmlmMGNHUUo4ODZa?=
 =?utf-8?B?ZVgySEkvbWVrYXc1QW5ZR0xYb2ZxSDhvbUxuS0I3UnlDSVAvbmxCRzVhcTVY?=
 =?utf-8?B?YWNCaVJzalJXZlJWY0d2bDErYUVLMHlFTnUzaDdjQnRUMU9VOVcrZVkvMlRO?=
 =?utf-8?B?dW9uNzlQRFlaVTBlZlkyR05pSUo1aXlCb3VjallhWXJNdXN6QjU2TUJkNHlM?=
 =?utf-8?B?b1gvOFAvS0dFakp0YUQ5azA4MzYyYTBobVdDcHZUeUFkdFcwVXNwTzU1OFRs?=
 =?utf-8?B?RkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0F621EEDD211046B796B2377BCB5F70@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4418.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a760b8a1-12ac-4b91-9a71-08d9a6696f5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2021 05:50:01.8966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L1fL/lZodkDgPV56OSSJU3cGMXAI8CJ1Y66q8zyxGyc52GAKBh5piEgm1PggOLowhcCpQwwB8eW8/0KFrl7rzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1807
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10166 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111130028
X-Proofpoint-GUID: ec6dNm8F7QaliE_9YEYJ99yup4AxCOkz
X-Proofpoint-ORIG-GUID: ec6dNm8F7QaliE_9YEYJ99yup4AxCOkz

T24gMTEvMTIvMjAyMSAzOjA4IFBNLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+IE9uIEZyaSwgTm92
IDEyLCAyMDIxIGF0IDI6MzUgUE0gSmFuZSBDaHUgPGphbmUuY2h1QG9yYWNsZS5jb20+IHdyb3Rl
Og0KPj4NCj4+IE9uIDExLzEyLzIwMjEgMTE6MjQgQU0sIERhbiBXaWxsaWFtcyB3cm90ZToNCj4+
PiBPbiBGcmksIE5vdiAxMiwgMjAyMSBhdCA5OjU4IEFNIEphbmUgQ2h1IDxqYW5lLmNodUBvcmFj
bGUuY29tPiB3cm90ZToNCj4+Pj4NCj4+Pj4gT24gMTEvMTEvMjAyMSA0OjUxIFBNLCBEYW4gV2ls
bGlhbXMgd3JvdGU6DQo+Pj4+PiBPbiBUaHUsIE5vdiAxMSwgMjAyMSBhdCA0OjMwIFBNIEphbmUg
Q2h1IDxqYW5lLmNodUBvcmFjbGUuY29tPiB3cm90ZToNCj4+Pj4+Pg0KPj4+Pj4+IEp1c3QgYSBx
dWljayB1cGRhdGUgLQ0KPj4+Pj4+DQo+Pj4+Pj4gSSBtYW5hZ2VkIHRvIHRlc3QgdGhlICdOUCcg
YW5kICdVQycgZWZmZWN0IG9uIGEgcG1lbSBkYXggZmlsZS4NCj4+Pj4+PiBUaGUgcmVzdWx0IGlz
LCBhcyBleHBlY3RlZCwgYm90aCBzZXR0aW5nICdOUCcgYW5kICdVQycgd29ya3MNCj4+Pj4+PiB3
ZWxsIGluIHByZXZlbnRpbmcgdGhlIHByZWZldGNoZXIgZnJvbSBhY2Nlc3NpbmcgdGhlIHBvaXNv
bmVkDQo+Pj4+Pj4gcG1lbSBwYWdlLg0KPj4+Pj4+DQo+Pj4+Pj4gSSBpbmplY3RlZCBiYWNrLXRv
LWJhY2sgcG9pc29ucyB0byB0aGUgM3JkIGJsb2NrKDUxMkIpIG9mDQo+Pj4+Pj4gdGhlIDNyZCBw
YWdlIGluIG15IGRheCBmaWxlLiAgV2l0aCAnTlAnLCB0aGUgJ21jX3NhZmUgcmVhZCcNCj4+Pj4+
PiBzdG9wcyAgYWZ0ZXIgcmVhZGluZyB0aGUgMXN0IGFuZCAybmQgcGFnZXMsIHdpdGggJ1VDJywN
Cj4+Pj4+PiB0aGUgJ21jX3NhZmUgcmVhZCcgd2FzIGFibGUgdG8gcmVhZCBbMiBwYWdlcyArIDIg
YmxvY2tzXSBvbg0KPj4+Pj4+IG15IHRlc3QgbWFjaGluZS4NCj4+Pj4+DQo+Pj4+PiBNeSBleHBl
Y3RhdGlvbiBpcyB0aGF0IGRheF9kaXJlY3RfYWNjZXNzKCkgLyBkYXhfcmVjb3ZlcnlfcmVhZCgp
IGhhcw0KPj4+Pj4gaW5zdGFsbGVkIGEgdGVtcG9yYXJ5IFVDIGFsaWFzIGZvciB0aGUgcGZuLCBv
ciBoYXMgdGVtcG9yYXJpbHkgZmxpcHBlZA0KPj4+Pj4gTlAgdG8gVUMuIE91dHNpZGUgb2YgZGF4
X3JlY292ZXJ5X3JlYWQoKSB0aGUgcGFnZSB3aWxsIGFsd2F5cyBiZSBOUC4NCj4+Pj4+DQo+Pj4+
DQo+Pj4+IE9rYXkuICBDb3VsZCB3ZSBvbmx5IGZsaXAgdGhlIG1lbXR5cGUgd2l0aGluIGRheF9y
ZWNvdmVyeV9yZWFkLCBhbmQNCj4+Pj4gbm90IHdpdGhpbiBkYXhfZGlyZWN0X2FjY2Vzcz8gIGRh
eF9kaXJlY3RfYWNjZXNzIGRvZXMgbm90IG5lZWQgdG8NCj4+Pj4gYWNjZXNzIHRoZSBwYWdlLg0K
Pj4+DQo+Pj4gVHJ1ZSwgZGF4X2RpcmVjdF9hY2Nlc3MoKSBkb2VzIG5vdCBuZWVkIHRvIGRvIHRo
ZSBwYWdlIHBlcm1pc3Npb24NCj4+PiBjaGFuZ2UsIGl0IGp1c3QgbmVlZHMgdG8gaW5kaWNhdGUg
aWYgZGF4X3JlY292ZXJ5X3tyZWFkLHdyaXRlfSgpIG1heQ0KPj4+IGJlIGF0dGVtcHRlZC4gSSB3
YXMgdGhpbmtpbmcgdGhhdCB0aGUgREFYIHBhZ2VzIG9ubHkgZmxvYXQgYmV0d2VlbiBOUA0KPj4+
IGFuZCBXQiBkZXBlbmRpbmcgb24gd2hldGhlciBwb2lzb24gaXMgcHJlc2VudCBpbiB0aGUgcGFn
ZS4gSWYNCj4+PiBkYXhfcmVjb3ZlcnlfcmVhZCgpIHdhbnRzIHRvIGRvIFVDIHJlYWRzIGFyb3Vu
ZCB0aGUgcG9pc29uIGl0IGNhbiB1c2UNCj4+PiBpb3JlbWFwKCkgb3Igdm1hcCgpIHRvIGNyZWF0
ZSBhIHRlbXBvcmFyeSBVQyBhbGlhcy4gVGhlIHRlbXBvcmFyeSBVQw0KPj4+IGFsaWFzIGlzIG9u
bHkgcG9zc2libGUgaWYgdGhlcmUgbWlnaHQgYmUgbm9uLWNsb2JiZXJlZCBkYXRhIHJlbWFpbmlu
Zw0KPj4+IGluIHRoZSBwYWdlLiBJLmUuIHRoZSBjdXJyZW50ICJ3aG9sZV9wYWdlKCkiIGRldGVy
bWluYXRpb24gaW4NCj4+PiB1Y19kZWNvZGVfbm90aWZpZXIoKSBuZWVkcyB0byBiZSBwbHVtYmVk
IGludG8gdGhlIFBNRU0gZHJpdmVyIHNvIHRoYXQNCj4+PiBpdCBjYW4gY29vcGVyYXRlIHdpdGgg
YSB2aXJ0dWFsaXplZCBlbnZpcm9ubWVudCB0aGF0IGluamVjdHMgdmlydHVhbA0KPj4+ICNNQyBh
dCBwYWdlIGdyYW51bGFyaXR5LiBJLmUuIG5maXRfaGFuZGxlX21jZSgpIGlzIGJyb2tlbiBpbiB0
aGF0IGl0DQo+Pj4gb25seSBhc3N1bWVzIGEgc2luZ2xlIGNhY2hlbGluZSBhcm91bmQgdGhlIGZh
aWx1cmUgYWRkcmVzcyBpcw0KPj4+IHBvaXNvbmVkLCBpdCBuZWVkcyB0aGF0IHNhbWUgd2hvbGVf
cGFnZSgpIGxvZ2ljLg0KPj4+DQo+Pg0KPj4gSSdsbCBoYXZlIHRvIHRha2Ugc29tZSB0aW1lIHRv
IGRpZ2VzdCB3aGF0IHlvdSBwcm9wb3NlZCwgYnV0IGFsYXMsIHdoeQ0KPj4gY291bGRuJ3Qgd2Ug
bGV0IHRoZSBjb3JyZWN0IGRlY2lzaW9uIChhYm91dCBOUCB2cyBVQykgYmVpbmcgbWFkZSB3aGVu
DQo+PiB0aGUgJ3dob2xlX3BhZ2UnIHRlc3QgaGFzIGFjY2VzcyB0byB0aGUgTVNpX01JU0MgcmVn
aXN0ZXIsIGluc3RlYWQgb2YNCj4+IGhhdmluZyB0byByaXNrIG1pc3Rha2VubHkgY2hhbmdlIE5Q
LT5VQyBpbiBkYXhfcmVjb3ZlcnlfcmVhZCgpIGFuZA0KPj4gcmlzayB0byByZXBlYXQgdGhlIGJ1
ZyB0aGF0IFRvbnkgaGFzIGZpeGVkPyAgSSBtZWFuIGEgUE1FTSBwYWdlIG1pZ2h0DQo+PiBiZSBs
ZWdpdGltYXRlbHkgbm90LWFjY2Vzc2libGUgZHVlIHRvIGl0IG1pZ2h0IGhhdmUgYmVlbiB1bm1h
cHBlZCBieQ0KPj4gdGhlIGhvc3QsIGJ1dCBkYXhfcmVjb3ZlcnlfcmVhZCgpIGhhcyBubyB3YXkg
dG8ga25vdywgcmlnaHQ/DQo+IA0KPiBJdCBzaG91bGQga25vdyBiZWNhdXNlIHRoZSBNQ0UgdGhh
dCB1bm1hcHBlZCB0aGUgcGFnZSB3aWxsIGhhdmUNCj4gY29tbXVuaWNhdGVkIGEgIndob2xlX3Bh
Z2UoKSIgTUNFLiBXaGVuIGRheF9yZWNvdmVyeV9yZWFkKCkgZ29lcyB0bw0KPiBjb25zdWx0IHRo
ZSBiYWRibG9ja3MgbGlzdCB0byB0cnkgdG8gcmVhZCB0aGUgcmVtYWluaW5nIGdvb2QgZGF0YSBp
dA0KPiB3aWxsIHNlZSB0aGF0IGV2ZXJ5IHNpbmdsZSBjYWNoZWxpbmUgaXMgY292ZXJlZCBieSBi
YWRibG9ja3MsIHNvDQo+IG5vdGhpbmcgdG8gcmVhZCwgYW5kIG5vIG5lZWQgdG8gZXN0YWJsaXNo
IHRoZSBVQyBtYXBwaW5nLiBTbyB0aGUgdGhlDQo+ICJUb255IGZpeCIgd2FzIGluY29tcGxldGUg
aW4gcmV0cm9zcGVjdC4gSXQgbmVnbGVjdGVkIHRvIHVwZGF0ZSB0aGUNCj4gTlZESU1NIGJhZGJs
b2NrcyB0cmFja2luZyBmb3IgdGhlIHdob2xlIHBhZ2UgY2FzZS4NCg0KU28gdGhlIGNhbGwgaW4g
bmZpdF9oYW5kbGVfbWNlKCk6DQogICBudmRpbW1fYnVzX2FkZF9iYWRyYW5nZShhY3BpX2Rlc2Mt
Pm52ZGltbV9idXMsDQogICAgICAgICAgICAgICAgIEFMSUdOKG1jZS0+YWRkciwgTDFfQ0FDSEVf
QllURVMpLA0KICAgICAgICAgICAgICAgICBMMV9DQUNIRV9CWVRFUyk7DQpzaG91bGQgYmUgcmVw
bGFjZWQgYnkNCiAgIG52ZGltbV9idXNfYWRkX2JhZHJhbmdlKGFjcGlfZGVzYy0+bnZkaW1tX2J1
cywNCiAgICAgICAgICAgICAgICAgQUxJR04obWNlLT5hZGRyLCBMMV9DQUNIRV9CWVRFUyksDQog
ICAgICAgICAgICAgICAgICgxIDw8IE1DSV9NSVNDX0FERFJfTFNCKG0tPm1pc2MpKSk7DQpyaWdo
dD8NCg0KQW5kIHdoZW4gZGF4X3JlY292ZXJ5X3JlYWQoKSBjYWxscw0KICAgYmFkYmxvY2tzX2No
ZWNrKGJiLCBzZWN0b3IsIGxlbiAvIDUxMiwgJmZpcnN0X2JhZCwgJm51bV9iYWQpDQppdCBzaG91
bGQgYWx3YXlzLCBpbiBjYXNlIG9mICdOUCcsIGRpc2NvdmVyIHRoYXQgJ2ZpcnN0X2JhZCcNCmlz
IHRoZSBmaXJzdCBzZWN0b3IgaW4gdGhlIHBvaXNvbmVkIHBhZ2UsICBoZW5jZSBubyBuZWVkDQp0
byBzd2l0Y2ggdG8gJ1VDJywgcmlnaHQ/DQoNCkluIGNhc2UgdGhlICdmaXJzdF9iYWQnIGlzIGlu
IHRoZSBtaWRkbGUgb2YgdGhlIHBvaXNvbmVkIHBhZ2UsDQp0aGF0IGlzLCBkYXhfcmVjb3Zlcl9y
ZWFkKCkgY291bGQgcG90ZW50aWFsbHkgcmVhZCBzb21lIGNsZWFuDQpzZWN0b3JzLCBpcyB0aGVy
ZSBwcm9ibGVtIHRvDQogICBjYWxsIF9zZXRfbWVtb3J5X1VDKHBmbiwgMSksDQogICBkbyB0aGUg
bWNfc2FmZSByZWFkLA0KICAgYW5kIHRoZW4gY2FsbCBzZXRfbWVtb3J5X05QKHBmbiwgMSkNCj8N
CldoeSBkbyB3ZSBuZWVkIHRvIGNhbGwgaW9yZW1hcCgpIG9yIHZtYXAoKT8NCg0KPiANCj4+IFRo
ZSB3aG9sZSBVQyA8PiBOUCBhcmd1bWVudHMgdG8gbWUgc2VlbXMgdG8gYmUgYQ0KPj4gICAgIlVD
IGJlaW5nIGhhcm1sZXNzL3dvcmthYmxlIHNvbHV0aW9uIHRvIERSQU0gYW5kIFBNRU0iICB2ZXJz
dXMNCj4+ICAgICJOUCBiZWluZyBzaW1wbGVyIHJlZ2FyZGxlc3Mgd2hhdCByaXNrIGl0IGJyaW5n
cyB0byBQTUVNIi4NCj4+IFRvIHVzLCBQTUVNIGlzIG5vdCBqdXN0IGFub3RoZXIgZHJpdmVyLCBp
dCBpcyB0cmVhdGVkIGFzIG1lbW9yeSBieSBvdXINCj4+IGN1c3RvbWVyLCBzbyB3aHk/DQo+IA0K
PiBJdCdzIHJlYWxseSBub3QgYSBxdWVzdGlvbiBvZiBVQyB2cyBOUCwgaXQncyBhIHF1ZXN0aW9u
IG9mIGFjY3VyYXRlbHkNCj4gdHJhY2tpbmcgaG93IG1hbnkgY2FjaGVsaW5lcyBhcmUgY2xvYmJl
cmVkIGluIGFuIE1DRSBldmVudCBzbyB0aGF0DQo+IGh5cGVydmlzb3JzIGNhbiBwdW5jaCBvdXQg
ZW50aXJlIHBhZ2VzIGZyb20gYW55IGZ1dHVyZSBndWVzdCBhY2Nlc3MuDQo+IFRoaXMgYWxzbyBy
YWlzZXMgYW5vdGhlciBwcm9ibGVtIGluIG15IG1pbmQsIGhvdyBkb2VzIHRoZSBoeXBlcnZpc29y
DQo+IGxlYXJuIHRoYXQgdGhlIHBvaXNvbiB3YXMgcmVwYWlyZWQ/IA0KDQpHb29kIHF1ZXN0aW9u
IQ0KDQpQcmVzdW1hYmx5IHRoZSAiVG9ueSBmaXgiIHdhcyBmb3INCj4gYSBjYXNlIHdoZXJlIHRo
ZSBndWVzdCB0aG91Z2h0IHRoZSBwYWdlIHdhcyBzdGlsbCBhY2Nlc3NpYmxlLCBidXQgdGhlDQo+
IGh5cGVydmlzb3Igd2FudGVkIHRoZSB3aG9sZSB0aGluZyB0cmVhdGVkIGFzIHBvaXNvbi4gSXQg
bWF5IGJlIHRoZQ0KPiBjYXNlIHRoYXQgd2UncmUgbWlzc2luZyBhIG1lY2hhbmlzbSB0byBhc2sg
dGhlIGh5cGVydmlzb3IgdG8gY29uc2lkZXINCj4gdGhhdCB0aGUgZ3Vlc3QgaGFzIGNsZWFyZWQg
dGhlIHBvaXNvbi4gQXQgbGVhc3QgZm9yIFBNRU0gZGVzY3JpYmVkIGJ5DQo+IEFDUEkgdGhlIGV4
aXN0aW5nIENsZWFyRXJyb3IgRFNNIGluIHRoZSBndWVzdCBjb3VsZCBiZSB0cmFwcGVkIGJ5IHRo
ZQ0KPiBoeXBlcnZpc29yIHRvIGhhbmRsZSB0aGlzIGNhc2UsIA0KDQpJIGRpZG4ndCBldmVuIGtu
b3cgdGhhdCBndWVzdCBjb3VsZCBjbGVhciBwb2lzb24gYnkgdHJhcHBpbmcgaHlwZXJ2aXNvcg0K
d2l0aCB0aGUgQ2xlYXJFcnJvciBEU00gbWV0aG9kLCBJIHRob3VnaHQgZ3Vlc3QgaXNuJ3QgcHJp
dmlsZWdlZCB3aXRoDQp0aGF0LiBXb3VsZCB5b3UgbWluZCB0byBlbGFib3JhdGUgYWJvdXQgdGhl
IG1lY2hhbmlzbSBhbmQgbWF5YmUgcG9pbnQNCm91dCB0aGUgY29kZSwgYW5kIHBlcmhhcHMgaWYg
eW91IGhhdmUgdGVzdCBjYXNlIHRvIHNoYXJlPw0KDQpidXQgSSdtIG5vdCBzdXJlIHdoYXQgdG8g
ZG8gYWJvdXQNCj4gZ3Vlc3RzIHRoYXQgbGF0ZXIgd2FudCB0byB1c2UgTU9WRElSNjRCIHRvIGNs
ZWFyIGVycm9ycy4NCj4gDQoNClllYWgsIHBlcmhhcHMgdGhlcmUgaXMgbm8gd2F5IHRvIHByZXZl
bnQgZ3Vlc3QgZnJvbSBhY2NpZGVudGFsbHkNCmNsZWFyIGVycm9yIHZpYSBNT1ZESVI2NEIsIGdp
dmVuIHNvbWUgYXBwbGljYXRpb24gcmVseSBvbiBNT1ZESVI2NEINCmZvciBmYXN0IGRhdGEgbW92
ZW1lbnQgKHN0cmFpZ2h0IHRvIHRoZSBtZWRpYSkuIEkgZ3Vlc3MgaW4gdGhhdCBjYXNlLA0KdGhl
IGNvbnNlcXVlbmNlIGlzIGZhbHNlIGFsYXJtLCBub3RoaW5nIGRpc2FzdHJvdXMsIHJpZ2h0Pw0K
DQpIb3cgYWJvdXQgYWxsb3dpbmcgdGhlIHBvdGVudGlhbCBiYWQtYmxvY2sgYm9va2tlZXBpbmcg
Z2FwLCBhbmQNCm1hbmFnZSB0byBjbG9zZSB0aGUgZ2FwIGF0IGNlcnRhaW4gY2hlY2twb2ludHM/
IEkgZ3Vlc3Mgb25lIG9mDQp0aGUgY2hlY2twb2ludHMgbWlnaHQgYmUgd2hlbiBwYWdlIGZhdWx0
IGRpc2NvdmVycyBhIHBvaXNvbmVkDQpwYWdlPw0KDQp0aGFua3MhDQotamFuZQ0KDQoNCg==
