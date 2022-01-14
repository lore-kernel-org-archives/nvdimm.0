Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D8A2C80
	for <nvdimm@lists.linux.dev>; Fri, 14 Jan 2022 22:30:59 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20ELG6tj022235;
	Fri, 14 Jan 2022 22:30:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=fTDBYiH+X2SBIx5D4DeZeVoiA5NBGcTy4qWcoiMMlTA=;
 b=Em/7I7iuS0D+ZKkSj08CSOpgPppqPorma4h5z7a+jf/aHLUS18ju3xB9I0BUb/OGO+s7
 26Vn44x43hmk0TaxbeiUszhaSaL5gLQxe7MtsNIm79vfs2O6DMH5nDa8h3oEarGXaGvy
 eIZML4otF1iFHe/mU7nCNSK314XncdQDHnx5hy67d7j25OPggqpeFR5ZG1y+JPlUo9jD
 akinY4ZAeEWdrNVVO4YHrZlnNOju85Cv6xGYFLlDEM6QhowB3T1P1+HTKC1FfQvOmXSM
 vsx2STq4BqaIL2FT3vCUEMLvul3jqthjFhMwZ1X8fmaf1stAQiNT4T/tnhoQq8/AxBww 9Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3djgv6d97s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jan 2022 22:30:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20EMQhdv037344;
	Fri, 14 Jan 2022 22:30:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by aserp3030.oracle.com with ESMTP id 3dkbcspces-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jan 2022 22:30:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myPaLOH7IC/AZu8SK5/XbsNuxsDSsDpkHmQUFF5Rj+RSvHIggPilpBtDKDLKl+I4DnqrPE+gR8u1GrwbBjGstFz/ehkr3xBhU5ZNyziaDtw8OiGPJjkT7/JvOzHSMwKlbpvREuH9Ln91fM6Iy9z30FGcjYLD7FfzrrmNw9eSQ0jAa6WixJiuDuel0pdnxDa+QaAP49CDEHilxT/xF69Lilrs7MuEqFJ6gQ/3RoGhr+1gIBAI8xzLrlUD8jmcP8FFdcFj2VS5lUb1TlWB437nRrIdT310pYr4buCvHlyk8llpnSShBMTuUdM5SqqZEbzZDblua2zpu6cYb1ppviAT9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTDBYiH+X2SBIx5D4DeZeVoiA5NBGcTy4qWcoiMMlTA=;
 b=HXizuUYuB5SBsieTvV4/Dj8w/PPhQu6Zh+tbuWOeG+yHXe66i+7Lfv/d1/j2NexkGAXNbjHff066tp6FaamWpn9OGdDxTlf5+wC4QFlJ+NtJul6KCug2m/0Rr27KSjxhNTxqp7vozvPS5lK+4I4xNGw6AfzwaCCGJeVgwues5cX3Y2HnSmwp3Kz9qbkfp2qweoUXG0K65Y2i7Y3/H0Z6NPM+3uKEZ73qsoq00ZDkR5LFtJsXhr7j/ZPVPYAGUTZdvimGA+xDt26VX55VWfbD8vqNVw7S2xr6dFR57lviVpGps9NTOgsDO+hlff0PaJHVDiZ7OmXEijnLPYT4sdRYrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTDBYiH+X2SBIx5D4DeZeVoiA5NBGcTy4qWcoiMMlTA=;
 b=TwHoCkba38LKR2KiHXNlrq7BVOHdOSNFe4UGUQpiCQD6GPrJ7/LnqNOXGboJl1WOXoEyrZ3GgY6y76dyC8bNyaLsMOm/+Ay7Tq+u5BnqJuYuvWlQEJnY5+o0GjiSDVRbtfDWQxt7yW074OpaBBrbs85P0p1/Kl08z7WX9+7tQMg=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BN6PR1001MB2099.namprd10.prod.outlook.com (2603:10b6:405:2c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 14 Jan
 2022 22:30:38 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::6814:f6c:b361:7071]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::6814:f6c:b361:7071%8]) with mapi id 15.20.4888.012; Fri, 14 Jan 2022
 22:30:38 +0000
From: Jane Chu <jane.chu@oracle.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "msuchanek@suse.de"
	<msuchanek@suse.de>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
        "breno.leitao@gmail.com"
	<breno.leitao@gmail.com>,
        "vaibhav@linux.ibm.com" <vaibhav@linux.ibm.com>,
        "kilobyte@angband.pl" <kilobyte@angband.pl>
Subject: Re: [ndctl PATCH v3 00/16] ndctl: Meson support
Thread-Topic: [ndctl PATCH v3 00/16] ndctl: Meson support
Thread-Index: AQHYAnupW4bqmBYGAk6o92OSNmBNjKxiu8KAgABr/AA=
Date: Fri, 14 Jan 2022 22:30:38 +0000
Message-ID: <c6be7804-419e-d547-062d-6b852494bceb@oracle.com>
References: 
 <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
 <d4a57facb2b778867e3bbe8564f03868b58e2f72.camel@intel.com>
In-Reply-To: <d4a57facb2b778867e3bbe8564f03868b58e2f72.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2aa5db6e-1a13-4568-4b44-08d9d7ad7dbe
x-ms-traffictypediagnostic: BN6PR1001MB2099:EE_
x-microsoft-antispam-prvs: 
 <BN6PR1001MB2099E4DB5FC4F981AAA75B08F3549@BN6PR1001MB2099.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 vup6Jgr0PPnUsrG58QebQlRqEHwCvxwgYBBWVg3Ho1qAdVzSXaD8EfMVaYvE53ISoPjQ+u2ZH4pwgS5I2zXauga3h4KEiFIrGdjzx0dOMH5TbikWxV7Tkg8x0KTQoCOqzys6oxyB1T7d3dnuTnbCkEpJ6Tg4HsYbdmrOZlhReldwWn1jRA7Vvdn/VHEKK44IQIWyALmkYGThbQDfd3hVTz/HPhF414BSp0gV0melUstyy8dBWB8Tqv4sWsjTXeGaqLjAgcV49XJLKNWBlbRCwPhGYCUs2yZSmsEUX8ZPIhZrGocK8MIHD3hiKVbBKC6bogfMSo/G3wd6Ii1bHg+KhPB12GozzkgBlpOigVma2/qyPg/OvBMLvrWGYhvrJD8QW9s49QWR6OK7FtPxPj+Zvk9DGYfsLfeoW0qKvjUvu+VrQ9Zm6RKKPPqfEdGu2Mmmcfky0CzX1YLCdiFWtPYHcs5/rlCPYUadJwTUKuIeFHxrpnWQxrhI0CRc7n/JYSN6NOkUjJQB9CsZhHnAWJn+pGTbSAMdKYGIONYIECQgxZBMtUTn7Up+DA5GIZcMt4teSMLZefOTVQX664AMtz99jWjR0iF2x+rA8ivNCHU9iaXcMZ4LHEckHpbfazRpUcnylBkzrNZLY71nZwAhXj/BqQ+kadJTiSLPYAQp/XYtXqadM5aCv+5ld14ofcVO8k+LHuq4y4D0EQrEYLpLDJ3EmP5h34i4xMqqIkJSiFqlpGxgM2KN4naNGn6jDX7QWEs81XmSv1ZuF7lvdsU76+Ag9uDahLkfP74pLmz4gN8qE/J+QV1zJ8U56E2WN/hrGRoNnMajtUGg5yIorSuvFWCVr9wwHIxLpYTs2rt9tTNYfJY=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(31686004)(31696002)(110136005)(8676002)(508600001)(54906003)(122000001)(44832011)(38100700002)(5660300002)(4326008)(966005)(2616005)(316002)(6512007)(2906002)(36756003)(66446008)(86362001)(38070700005)(6506007)(53546011)(66946007)(66476007)(66556008)(64756008)(6486002)(83380400001)(71200400001)(76116006)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?bFpDMXR3bkd6MWlZN3JsdUdqVWR6VUFpL3k2L2d5OVBtODR4dnlqeU1uOHdk?=
 =?utf-8?B?UFFRVnp6SldwazVndEE2ZGZwdmkwZWg4R3Q1eXRYckZIeFJtMXdyeEhveVdT?=
 =?utf-8?B?YmJwNXl1VGVuMUorb2Z3eDZ0ajc4cHJkb2x2ZTdZMjdhWXdsSm5KV2xrSDNM?=
 =?utf-8?B?T1dMUGpna1kwZDFVaVJHblhRaG9ZR0JZeEEzVFZjNHRmeFBaeTZLSXVkVUJC?=
 =?utf-8?B?NisyNlQ0M05abmJSK2FSUmdtSTVTeFUzZ05sUU16c3JEQURLb0c3SjZBbXhm?=
 =?utf-8?B?ZHZ0ZkQ4VTZ0YkF5SGducHdHbmhDV01BbDhEVXU5UVkveTM1R0VrLzQ5YXRS?=
 =?utf-8?B?bEZMSWpmTTAvS2hTeGV4azkyTGV1VEpReUtqYUJhQ1RwTlRKRVFpTHhHTjEz?=
 =?utf-8?B?YUdoR0psZTBuT1g5STJFTy95U2psRTJheHVlc29WdGtOVGR3Z2VnWjFlN0Rv?=
 =?utf-8?B?anFlbDVvYTVObGlMMnhGT2Z2TjJ6S3RLWEo4amtyTktQdDF3SXhUc0dOVVNm?=
 =?utf-8?B?VXNMNWwzVXF2Mnc4bXVWWTk0SGU1cTRtWld1WVJzMzcxd1RyRmlVS0ZPSkt1?=
 =?utf-8?B?Z1FBTlV2bG5hVWFSR0pjSFZOQTZPbnBrWUw0c3hwUVdYWmNVaUd1QjFIOXNB?=
 =?utf-8?B?MEluek9jWXNXeXpkRUp2TkpHZEIxMXFSKzlHRDF2QkdvSnpPa0NZb1M4QkVo?=
 =?utf-8?B?RWM2UmYzMDIxSVdkMHMyUWREemdoMGdESWh6WVpvRVNPZWhCZEZ1SXMySlJC?=
 =?utf-8?B?WktPclZSWDdmeFFZTTVBclRXWHV6dmpheFFSWHp2T3A4Ky9sM0NoR1daa05w?=
 =?utf-8?B?Qk9zZ1ZvVTZqeUJRRys1RFcyb09MUDE4SHdzSHJYTGVFS0tqTHZsZzI5N2ta?=
 =?utf-8?B?VHVvUEtmUFU0eDhEV0cvV3RvM1JhZG15MzNUSW5rUnJiV3pQTVVicEt6b1pV?=
 =?utf-8?B?QmVuUTM4ZzQ4Y1NSK21iNHY5QWN6YUhxZnhId2RvYmhJWlBuajZ1SldNZnRG?=
 =?utf-8?B?MFh5MzlUa3BOQTJFU2xGWW93azRWOFowMmlDbVhiNlZiTFRsZ05EeGFGREU1?=
 =?utf-8?B?YmVjTXZFTmtMZFZHRTVqSjFrUk82eTB6YUN4bllUalZ4ZDdDazR0ZElTNGdl?=
 =?utf-8?B?VWtOejJIS3YzL2VxbU5kWTc2Q21OV3pXc2xjaWtFbzRQZ1Zad2lXbjU4ZTB4?=
 =?utf-8?B?Ylp1d053NmQzNmllMUhWaEQyYUJRbzM3bmlCOXB1UHZFSDdvTlVBb3l3MVhT?=
 =?utf-8?B?NVFNNytLRktnS3YzOUVDQmt5Y3FuUXlmOU5Fakd2N1FtODZrUWtsYlpuUlg4?=
 =?utf-8?B?OTVIcW5hL2d2eFo5R21tdTBBaEdNeUVHV1ViRmExRHpZbXRueWZtOHRZQzV6?=
 =?utf-8?B?ZzhFbGtTV3hxbTkvUklPOEVTTXRPSnY5MFR1WEUyL0NjQ3lPVUY2c01iTGhJ?=
 =?utf-8?B?L3d4QWg1VkN2K0JaTVVuNkE1eG8vdXFOakF0SDlEZDBHbFhsZHBtYisyTW0y?=
 =?utf-8?B?bk12VUV5bHRWQXdOVGZ4Z3RBUnM5VWFyR2czRHVRMG42ME5scDQxK3orcWJy?=
 =?utf-8?B?ZjhHbmMzMzJsemZRVHJkYUdpT0N1dU1sUVpHVXlDQ0JpL3czbzRsL3EyQys4?=
 =?utf-8?B?azZpQm5zQzRrdnVJVWhZNm54eXNBVEVOZWNKZE5wVHJZRXNRUmtRVGRLYzE4?=
 =?utf-8?B?YW9jWXpyM1V5emFlMGh0TDZwaFMvYkZIY2RubWdNQ2ZvMEJuMG9VclJSSXM1?=
 =?utf-8?B?N1dKVmZSb0E0SW1reGhqcWdrQVRrNU9UNFFOemc0VVd0Vjh3d0Mvc1FCdlRJ?=
 =?utf-8?B?cUJ2eFpsY1lqU203dmo4dVBNUEdYa0JycmZTdlFxcmhHaXhJcWNKTnZJSzUv?=
 =?utf-8?B?VEhnY2FVQ1hpM3Z4Y2dqL3Z3S2hsZ2R0S0xGQ3VwS1c1UW41YmhXaTBTTFpN?=
 =?utf-8?B?MGNyQXBaYU9XYWV3UVc3RUJubnJoenJYTmhvdERpdjVWMmJjVng1WDBqNDd0?=
 =?utf-8?B?VmRzc3VEbnZSRDlGNGpQVGFXSGRmTHphVi9IdUIwQW1YSnZzS0hyc2VyOVdK?=
 =?utf-8?B?dDlqNDlZMTdlZVRrYWNaTmpnTVVuR2tIeUZrWUpnU0F1bGJtcTc5R0dSbWZk?=
 =?utf-8?B?NkU5Q2oxU1NrU2lNL0xaU1EvbVp1NGcvN2xYL29vOXkva2NySU92RC9abG4w?=
 =?utf-8?Q?yhYKcpYiAkWIqVEbtL5u8c300o2yQW+spTO02cTLuV5m?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <786666D61E940841B90C1CD6B618EC48@namprd10.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa5db6e-1a13-4568-4b44-08d9d7ad7dbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2022 22:30:38.7119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CM6bHoB8FUHW3ONm2JWB8CFJY7Z7PsIwJx6hO48uq5pUEvReYh0PdeB58zzWZcx/zpGWPJP3tcfGuY7hlsMG/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2099
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10227 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201140125
X-Proofpoint-ORIG-GUID: F1WWdxJ6GKiE6Ooe6ZwofWCmZlB_npBk
X-Proofpoint-GUID: F1WWdxJ6GKiE6Ooe6ZwofWCmZlB_npBk

SGksDQoNClNob3VsZCB0aGUgUkVBRE1FLm1kIGZpbGUgZ2V0IHVwZGF0ZWQgYWNjb3JkaW5nbHk/
DQoNCnRoYW5rcyENCi1qYW5lDQoNCk9uIDEvMTQvMjAyMiA4OjA0IEFNLCBWZXJtYSwgVmlzaGFs
IEwgd3JvdGU6DQo+IE9uIFdlZCwgMjAyMi0wMS0wNSBhdCAxMzozMSAtMDgwMCwgRGFuIFdpbGxp
YW1zIHdyb3RlOg0KPj4gQ2hhbmdlcyBzaW5jZSB2MiBbMV06DQo+Pg0KPj4gLSBSZWJhc2Ugb24g
djcyDQo+PiAgICAtIEFkZCBNZXNvbiBzdXBwb3J0IGZvciB0aGUgbmV3IGNvbmZpZyBmaWxlIGRp
cmVjdG9yeSBkZWZpbml0aW9ucy4NCj4+ICAgIC0gQWRkIE1lc29uIHN1cHBvcnQgZm9yIGxhbmRp
bmcgdGhlIGRheGN0bCB1ZGV2IHJ1bGUNCj4+ICAgICAgZGF4ZGV2LXJlY29uZmlndXJlIHNlcnZp
Y2UgaW4gdGhlIHJpZ2h0IGRpcmVjdG9yaWVzDQo+PiAtIEluY2x1ZGUgdGhlIGRlcHJlY2F0aW9u
IG9mIEJMSyBBcGVydHVyZSB0ZXN0IGluZnJhc3RydWN0dXJlDQo+PiAtIEluY2x1ZGUgYSBtaXNj
ZWxsYW5lb3VzIGRvYyBjbGFyaWZpY2F0aW9uIGZvciAnbmRjdGwgdXBkYXRlLWZpcm13YXJlJw0K
Pj4gLSBGaXggdGhlIHRlc3RzIHN1cHBvcnQgZm9yIG1vdmluZyB0aGUgYnVpbGQgZGlyZWN0b3J5
IG91dC1vZi1saW5lDQo+PiAtIEluY2x1ZGUgYSBmaXggZm9yIHRoZSBkZXByZWN0YXRpb24gb2Yg
dGhlIGRheF9wbWVtX2NvbXBhdCBtb2R1bGUNCj4+ICAgIHBlbmRpbmcgaW4gdGhlIGxpYm52ZGlt
bS1mb3ItbmV4dCB0cmVlLg0KPj4NCj4+IFsxXTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8x
NjMwNjE1Mzc4NjkuMTk0Mzk1Ny44NDkxODI5ODgxMjE1MjU1ODE1LnN0Z2l0QGR3aWxsaWEyLWRl
c2szLmFtci5jb3JwLmludGVsLmNvbQ0KPj4NCj4+IC0tLQ0KPj4NCj4+IEFzIG1lbnRpb25lZCBp
biBwYXRjaCAxNCB0aGUgbW90aXZpYXRpb24gZm9yIGNvbnZlcnRpbmcgdG8gTWVzb24gaXMNCj4+
IHByaW1hcmlseSBkcml2ZW4gYnkgc3BlZWQgKGFuIG9yZGVyIG9mIG1hZ25pdHVkZSBpbiBzb21l
IHNjZW5hcmlvcyksIGJ1dA0KPj4gTWVzb24gYWxzbyBpbmNsdWRlcyBiZXR0ZXIgdGVzdCBhbmQg
ZGVidWctYnVpbGQgc3VwcG9ydC4gVGhlIGJ1aWxkDQo+PiBsYW5ndWFnZSBpcyBlYXNpZXIgdG8g
cmVhZCwgd3JpdGUsIGFuZCBkZWJ1Zy4gTWVzb24gaXMgYWxsIGFyb3VuZCBiZXR0ZXINCj4+IHN1
aXRlZCB0byB0aGUgbmV4dCBwaGFzZSBvZiB0aGUgbmRjdGwgcHJvamVjdCB0aGF0IHdpbGwgaW5j
bHVkZSBhbGwNCj4+IHRoaW5ncyAiZGV2aWNlIG1lbW9yeSIgcmVsYXRlZCAobmRjdGwsIGRheGN0
bCwgYW5kIGN4bCkuDQo+Pg0KPj4gSW4gb3JkZXIgdG8gc2ltcGxpZnkgdGhlIGNvbnZlcnNpb24g
dGhlIG9sZCBCTEstYXBlcnR1cmUgdGVzdA0KPj4gaW5mcmFzdHJ1Y3R1cmUgaXMgamV0dGlzb25l
ZCBhbmQgaXQgd2lsbCBhbHNvIGJlIHJlbW92ZWQgdXBzdHJlYW0uIFNvbWUNCj4+IG90aGVyIHJl
ZmFjdG9yaW5ncyBhbmQgZml4dXBzIGFyZSBpbmNsdWRlZCBhcyB3ZWxsIHRvIGJldHRlciBvcmdh
bml6ZQ0KPj4gdGhlIHV0aWx0eSBpbmZyYXN0cnVjdHVyZSBiZXR3ZWVuIHRydWx5IGNvbW1vbiBh
bmQgc3ViLXRvb2wgc3BlY2lmaWMuDQo+Pg0KPj4gVmlzaGFsLA0KPj4NCj4+IEluIHByZXBhcmF0
aW9uIGZvciBuZGN0bC12NzMgcGxlYXNlIGNvbnNpZGVyIHB1bGxpbmcgaW4gdGhpcyBzZXJpZXMN
Cj4+IGVhcmx5IG1haW5seSBmb3IgbXkgb3duIHNhbml0eSBvZiBub3QgbmVlZGluZyB0byBmb3J3
YXJkIHBvcnQgbW9yZQ0KPj4gdXBkYXRlcyB0byB0aGUgYXV0b3Rvb2xzIGluZnJhc3RydWN0dXJl
Lg0KPj4NCj4gSGkgRGFuLA0KPiANCj4gVGhlc2UgbG9vayBncmVhdCwgdGhhbmtzIGEgbG90IGZv
ciB0aGlzIHdvcmssIGl0IGlzIGFuIGF3ZXNvbWUgd29ya2Zsb3cNCj4gaW1wcm92ZW1lbnQhICBJ
J3ZlIG1lcmdlZCBpdCBpbnRvIHBlbmRpbmcsIGFuZCB3aWxsIGFsc28gbWVyZ2UgdG8NCj4gbWFz
dGVyIHNob3J0bHkgdG8gZW5jb3VyYWdlIGFsbCBuZXcgc3VibWlzc2lvbnMgdG8gYmUgYmFzZWQg
b24gdGhpcy4NCj4gDQo+IEFsc28gQ0MnaW5nIGEgZmV3IGRpc3RybyBtYWludGFpbmVycyAtIHRo
aXMgd2lsbCBiZSBhIGNoYW5nZSB0bw0KPiBwYWNrYWdpbmcgc3BlY3MgZXRjLiB0aGF0IGFyZSBt
YWludGFpbmVkIG91dHNpZGUgb2YgdGhlIG5kY3RsIHJlcG8uDQo+IFRoaXMgY2hhbmdlIGNhbiBi
ZSBleHBlY3RlZCB0byBsYW5kIGluIHRoZSB2NzMgcmVsZWFzZSwgd2hpY2ggc2hvdWxkIGJlDQo+
IGluIHRoZSBuZXh0IDItNCB3ZWVrcy4NCj4gDQo+IFRoYW5rcywNCj4gVmlzaGFsDQoNCg==
