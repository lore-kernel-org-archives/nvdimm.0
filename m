Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF37E2C99
	for <nvdimm@lists.linux.dev>; Tue, 30 Nov 2021 23:01:10 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AUM6oG9016593;
	Tue, 30 Nov 2021 23:00:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=O1FqLMoBnO45VyeG3UdPW0QdUq7ymg6frg7vah1flsw=;
 b=r7+UGjjqoXNKF8toxjBVNfh5XR3diWCShl7tv7CIfJvgcLZtBsl1I9ITYOeW8bC0Eg3Z
 A1HtWVq+JIJBZ6FM2GpK1lrRYi0bLLK47WzsvUDOGfSMiWXpSyTe2S3qsQPcusznKTFH
 7+aTnOwyJCb9A3WIhMqhV7kBrSu1PD9DvRQQ1QdOopHiGi7x5pJB4NElT4oJTHObHu2Y
 SRxRldrKb5lG3kuCamScsQRtQUHHomqfS3Da9UuD1q+29qVIq61TTCNwznwWH7cywvfL
 OD3EWz9Y/PkSR0YckIKRUb5pSoxXoEJHdJCbacU/NaxatTqkeRJYNP3iI82WxYzgp+Nj Kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cmu1wm9p8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Nov 2021 23:00:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AUMq1Gm165057;
	Tue, 30 Nov 2021 23:00:56 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
	by userp3030.oracle.com with ESMTP id 3ck9t0gyq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Nov 2021 23:00:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VF2/LV4szRMTWSVyB/haTiGwdVhRCHR4nRO5wGPU2e3hQ4H4VCE2C2oSWZx28BHLDiSgkRHrwPpO+CTJ0q85IRerU87SI3h+AZaPzblb+ip/BZcRzDL1R+kN4fTdIb46Lur/kohJHOHNqkbOzS2oVPWQ9ZumhKFggYx1DCHvV7ht05T2etzRDcuETP1/zs6uazsJYAZBp0KNO/puw56CcSTYsZEOmQ1FaLYTT4EOmzSOA2kKtb0MR9tlg4koLgAqEnEczvxXQiwtrD9SAVKZHdnOD4Trb/iGuKnqRz1+AlVLUI1e5mkLJZwND6Nlk+Fdzhm2I3BgxT5H/e9UkLg28Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O1FqLMoBnO45VyeG3UdPW0QdUq7ymg6frg7vah1flsw=;
 b=QhWFg6Ws+WRqIyoz9BfkGT+ZkEccNt66Q5tq4874cNLZfn9Eg9QgiOG/EqHRYCpCwxp9IF2F71j9QZyDf70A3fNn5DZs65moIqoTfk8oGy+aqsA48Z2GV4iBemv/FKSqqLzFem7cmU+QNmAdsDN7iZvTmg9MLoLooFZdt9NXzikSo9kplyhwXDRUOYk+kunAGLBr0USoPBt+327WYf4xK8O7EIgrIbN/7b2DTojJM2zoHO0HElo8m6kbKDebkZZHYtMyEY2Ly58wKfRs2V5t6hCzxEwLVGJaneGZgwM1zoQYPoKLVKou80JACcLtFJcI4qZo24y92WPSW2Sq9AUZZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1FqLMoBnO45VyeG3UdPW0QdUq7ymg6frg7vah1flsw=;
 b=XFekQDuIAHljpbbLxTupYSs63+ls52cmHxdGxVGWJunZB9m5CZG0txylm0CJ+A9MBdCzV4Of++hSDfBY2IdWQJHMT5CleUA0mEQp0bHknQ5dR/eBzje5MhpAY2oDiuYuDLKt8HTGI72hXi1v1TPTiI14qySEcvhdUvyeghMfH1Q=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BYAPR10MB2440.namprd10.prod.outlook.com (2603:10b6:a02:b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Tue, 30 Nov
 2021 23:00:54 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::418c:dfe4:f3ee:feaa]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::418c:dfe4:f3ee:feaa%7]) with mapi id 15.20.4755.011; Tue, 30 Nov 2021
 23:00:54 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>,
        Linux
 NVDIMM <nvdimm@lists.linux.dev>,
        Luis Chamberlain <mcgrof@suse.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Topic: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Index: 
 AQHXcsuUGdCdj5TLi0qPljMZ83rdmquiLs2AgAISgwCAARWOAIACN9EAgAD6fICABatcAIAPJJmAgAACXwCAACIPAIAABBsAgAAEnACAAAQRgIAABMWAgAABtoCAAAQ3AIAAA0SAgAAEIoCAAAXwAIAADw6AgAAjpgCAABYKgIAAk30AgABlNoCAABYmgIAABQ6AgAEIqwCAPjKpgIABmROAgAAF4YCAAR65gIAAGD6AgAA1W4CAAAkygIAAcDKAgAD6wQCAB768gIAJxS0AgAlY+4A=
Date: Tue, 30 Nov 2021 23:00:53 +0000
Message-ID: <1d34f45c-2b6a-1f4d-71ff-715885f8f41a@oracle.com>
References: 
 <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
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
 <b51fb3d6-6d39-c450-e0a1-94a1645a22ec@oracle.com>
 <CAPcyv4g4mEVDcUw2Ph0oMH1=ZQgCbnLx+ZdgoavyOQt+9q6aVw@mail.gmail.com>
In-Reply-To: 
 <CAPcyv4g4mEVDcUw2Ph0oMH1=ZQgCbnLx+ZdgoavyOQt+9q6aVw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0effcf22-1f3c-4596-7ddf-08d9b455433b
x-ms-traffictypediagnostic: BYAPR10MB2440:
x-microsoft-antispam-prvs: 
 <BYAPR10MB244051113B427257F60A5FE8F3679@BYAPR10MB2440.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 g1cnBN7XYQTjGn/9k1h2LgdxxyQekYlcyK0rcKlw+FL4c5baln4Gxh+RY/OXr6VwZgbjKzqDkYVuVgylLAp4bnOu9hJqBdY9LZWfII0wgGNHDBWeN9jSfbhqhHBI/BGLBHFgbbeLzKtHKLJizwF8OTR+b+wR6mDCm8tmBrALH0SdCbQhB1WobtPVrBAMIJRawIeLqHoYYp1dE6BPKmlwDPB0cFov26mIfqHZqDOUcZ3d1vgqVLPcdI8wIcXo+8tFVOcGlZ575wsncgAesUq4MMdUuTd8AhtuhzZbWa+ZoqFDdWZ0owUwyDly7oAysS3STkn4qOqtPRmUn5WRt8WrEK4QwYB56SIQTh8YKMKzE2CJuHjhGcr0By9euD1Z/sNtOOp8VA5uvyQbD4WhxzeJ8cN58uz5THMCc+I3VGGRVaYf/eSBmo3aWl3NQQaYdYXEwzMNo1pR+qO3Lfjc1Cj0nl5kad10cuMmqXd6s+iwxNlkgUCj2ALMTU2eIz+TjWCTHG9nzyZ2xRS177ujzdekIVQd5ScyX9tywM4/Y7VL/s4JRs32RrVn/b6202M1zfhN62a0a6dX/h8saB7RQhuDJl+/x5ChVnhU0FO+1V57hhlou8H1xs8Of8KHo2VaSP0kY+1uTuy9VgVhR5c8O9Cbwz7fpmFLl3D5C+qXifF5F37hzrEmXQsWplx3ol9ZOKe78RnzWH4pZ8S0+s/Y1Df9KLpoCoqPrfAFBH5y1DHcVMy5511t0MKeoCjH035OfQYmivy8Yao/klzgF1jDE/ByjQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(2906002)(8676002)(186003)(54906003)(4326008)(38070700005)(31686004)(31696002)(71200400001)(6512007)(44832011)(5660300002)(508600001)(122000001)(53546011)(83380400001)(64756008)(76116006)(8936002)(66556008)(66446008)(66476007)(6916009)(66946007)(86362001)(6486002)(38100700002)(36756003)(2616005)(316002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?VEhjSW5FSkNxbnF6U3B1VVJWK0thVzZuVXB6TDg0T1dlU2grS0ZrdzJrRm5U?=
 =?utf-8?B?elUrZ2ROQUlDdWRCZWczS05XdmdyczJBQ1hGbjZuVVEraHlnMGczQ2pFUzZF?=
 =?utf-8?B?UjZ3RUZqWjljbXJxSjNIZ3NxSVgxaW9wN09SK1J5YVZnT3M1aG5MQ3ZTK0NH?=
 =?utf-8?B?UUk0MFd3Y3BPV24yS2pJcHU5TzE5YmtxS21yT251ZGJuZDFDUnJpUVNMMDl5?=
 =?utf-8?B?N01pRi9SWjBIZzY4QWczWXFsRno5VHZwbHVQOVUwRG9MU0IrT3hVM0JVY3JC?=
 =?utf-8?B?YlViZnQ3NXVBSW4xdlNNeiswUWV3Q0VmeGpwTTF4ZlRGYzhaZ0NVT2xiWUxp?=
 =?utf-8?B?cUpiV0lncXJ2c2RIWkNkbDZHaGFodWhPUTQvdy9Xc082dzF2dkdBMVhPeHR3?=
 =?utf-8?B?MmszVTkwYmVjS2tYRnBmL002SUlOanp1YWRVNDFkL1dzNjlpRTQvT1FTYkdn?=
 =?utf-8?B?bDIzOWRvUU8zdjhjS21hSWpqanlUbkx1cUVHUzJ1eXJIenlaVHRZZU1vOVQr?=
 =?utf-8?B?ZGl1RkdWbFZQRGVEdXI4Z3NzZmVBQUg2M0dIZEV3SUNtT2ViNGExRU9FeS9m?=
 =?utf-8?B?VGNmTlVJeVBBZElpQThEVUpoUHV3eUVZdnRPNDBidzExTnloSGxPcGR3SHZK?=
 =?utf-8?B?OE0zSGNIYkZVOFJKenBrMEtyTTlRVGxPbmxCYXdQS3hIRkJDWDhKZTZlNjdY?=
 =?utf-8?B?L3lEcURmQkZjYzh5SjJpTkRja3FROEhra0dkbHliaUE4bmdqNzZsaHZEMGlF?=
 =?utf-8?B?am55UFlRVjZpWTJGazRWdzhiUm42UEZYUkNNbVR5M0dLNm5NN0Y4Q1pjT2dj?=
 =?utf-8?B?RS83R3lzNXVUemZWL3d4VHFrRjZHRWUvOFMvOStrb0RkZUg5cU1LZitXRzEz?=
 =?utf-8?B?NHlXdnl1WG85THB4WUdEckxNSU9MZE9jaVM2MzVISjdpeUxGejNXdWJiR3NR?=
 =?utf-8?B?RGYwN1NrUnVqY0xCQ003WDA2TlhMQy8yc3NiZ3Q4eGJSc3lCekFjYktCdHVm?=
 =?utf-8?B?THZDbzBXbGt2SHhtSkRRWmlZcmJHVWNLTFJ0cHJObE5rNGdZSlhBQzRiM281?=
 =?utf-8?B?MmVaU3pLSnU1Mk5KT0pJcmlaRzZIUUdTSThNL2oraW85SFpyWHF1R1VRc3pG?=
 =?utf-8?B?S0liMldFYWRHT005dmdtZGFsZWF2aXBMSmtvaldDVWt4Q2kyK2NMK2tlUFIz?=
 =?utf-8?B?UjZNcEl5dzB3MzFZV0hXYVVxa2oyK2p6L05aTlVJVmhyN05DVUYvWFhJMThq?=
 =?utf-8?B?V0JOUUdVUFZCMXlVQXorSFBHa0ZFc2h5bFJ0RTdNTmlabFE3b0NYdTNvaDBF?=
 =?utf-8?B?UUNua0ZPTU1FL0hKWDA2SkxmUStuZlZPSW5nK25xd1Q0OVRXUzVCb3MrdnBp?=
 =?utf-8?B?Nk5PUGdjMm5wd0I2V0M0dDU1UDZxUjhFNFMzUnd1MjkvcjZEODRaU3VOb0cw?=
 =?utf-8?B?YXVDU05sdFkrRkNySUpKU05TTG9mY1pCcVFrZzFzREFURlVNQUdlZW52U1dj?=
 =?utf-8?B?ZElaU21vRUhMNlhSQy8vejc4cUFHVVkvVUx0ejI2dnBHNVRSS24wcTJNc3hN?=
 =?utf-8?B?eGh1bXgvc1RtbWZNL2xyNVNFTVFidEU1eHZGUGRnRjk3SEcxQmV2UnQ5VGNV?=
 =?utf-8?B?eHBDbGRiWHJqNVJFSkN6ajhPbHMrdjY1aXJmdzlJMmUrMWkzczBNY3lLTzJa?=
 =?utf-8?B?bW04L0V2d0dMR0NqUFNFUjhtVEJaSlgvMkRkcUU3TVJOK2lLbHV0ck9rRHZU?=
 =?utf-8?B?L2NESjVpVE1CQjE5cG5EY21USXRXbDJ6TzhZdG9zcjVpaEVieDQ5TUpJVXgx?=
 =?utf-8?B?WHdncHgzMGVQSnRvSklUUjN1NktaSVRkVlNzVXg2L0dMd2FxN0I5eTQxRmwz?=
 =?utf-8?B?eXF0cHJUV0J1ZVdISjdUVDRDUkw4TnNHQ0NsMTg1MHo1TWE5ZEdmQVpBNkFG?=
 =?utf-8?B?cnZRTEpuMFdPQ0IraUZaSFAzN2RxdnFLTjNoOE9vYmZBRWd5UGVDR2dCaHg0?=
 =?utf-8?B?RmpFRUNjQUx3MkI3OWN5ODBZZEcvY2huV2pkR2ttWU1CQi9VK3JybzhRQ0xS?=
 =?utf-8?B?WkhRYlhTVHZnWGd4enV3MmdmRFdnTjd4b3d4L2hIMURrZUYyODJTVjh6L3VT?=
 =?utf-8?B?cXdTT3NzUGNnV2hrbDJLcTNoaXpmZEZuOTk1ZDhDZk5rZmpKWkpqUGp5L3d6?=
 =?utf-8?B?bHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73B2BC9618ED2F448792759D7FEF31A4@namprd10.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0effcf22-1f3c-4596-7ddf-08d9b455433b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 23:00:54.1095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S0qK3k6VnkRyZbq9pgcqRIkApjU2/hdSNXeSEIYuS06CpFpvshX3KZILMwBOoHsYf7KwgdDLsC/8s3WIDaYtLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2440
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10184 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111300112
X-Proofpoint-GUID: rjUGkXbkmvko1uEldAfcEnYGlfdQSveq
X-Proofpoint-ORIG-GUID: rjUGkXbkmvko1uEldAfcEnYGlfdQSveq

T24gMTEvMjQvMjAyMSA0OjE2IFBNLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+IE9uIFRodSwgTm92
IDE4LCAyMDIxIGF0IDExOjA0IEFNIEphbmUgQ2h1IDxqYW5lLmNodUBvcmFjbGUuY29tPiB3cm90
ZToNCj4+DQo+PiBPbiAxMS8xMy8yMDIxIDEyOjQ3IFBNLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
PiA8c25pcD4NCjxzbmlwPg0KPj4NCj4+IFRoYW5rcyBEYW4gZm9yIHRha2luZyB0aGUgdGltZSBl
bGFib3JhdGluZyBzbyBtdWNoIGRldGFpbHMhDQo+Pg0KPj4gQWZ0ZXIgc29tZSBhbW91bnQgb2Yg
ZGlnZ2luZywgSSBoYXZlIGEgZmVlbCB0aGF0IHdlIG5lZWQgdG8gdGFrZQ0KPj4gZGF4IGVycm9y
IGhhbmRsaW5nIGluIHBoYXNlcy4NCj4+DQo+PiBQaGFzZS0xOiB0aGUgc2ltcGxlc3QgZGF4X3Jl
Y292ZXJ5X3dyaXRlIG9uIHBhZ2UgZ3JhbnVsYXJpdHksIGFsb25nDQo+PiAgICAgICAgICAgIHdp
dGggZml4IHRvIHNldCBwb2lzb25lZCBwYWdlIHRvICdOUCcsIHNlcmlhbGl6ZQ0KPj4gICAgICAg
ICAgICBkYXhfcmVjb3Zlcnlfd3JpdGUgdGhyZWFkcy4NCj4gDQo+IFlvdSBtZWFuIHNwZWNpYWwg
Y2FzZSBQQUdFX1NJWkUgb3ZlcndyaXRlcyB3aGVuIGRheF9kaXJlY3RfYWNjZXNzKCkNCj4gZmFp
bHMsIGJ1dCBsZWF2ZSBvdXQgdGhlIHN1Yi1wYWdlIGVycm9yIGhhbmRsaW5nIGFuZA0KPiByZWFk
LWFyb3VuZC1wb2lzb24gc3VwcG9ydD8NCg0KWWVzLg0KPiANCj4gVGhhdCBtYWtlcyBzZW5zZSB0
byBtZS4gSW5jcmVtZW50YWwgaXMgZ29vZC4NCg0KVGhhbmtzIQ0KPiANCj4+IFBoYXNlLTI6IHBy
b3ZpZGUgZGF4X3JlY292ZXJ5X3JlYWQgc3VwcG9ydCBhbmQgaGVuY2Ugc2hyaW5rIHRoZSBlcnJv
cg0KPj4gICAgICAgICAgICByZWNvdmVyeSBncmFudWxhcml0eS4gIEFzIGlvcmVtYXAgcmV0dXJu
cyBfX2lvbWVtIHBvaW50ZXINCj4+ICAgICAgICAgICAgdGhhdCBpcyBvbmx5IGFsbG93ZWQgdG8g
YmUgcmVmZXJlbmNlZCB3aXRoIGhlbHBlcnMgbGlrZQ0KPj4gICAgICAgICAgICByZWFkbCgpIHdo
aWNoIGRvIG5vdCBoYXZlIGEgbWNfc2FmZSB2YXJpYW50LCBhbmQgSSdtDQo+PiAgICAgICAgICAg
IG5vdCBzdXJlIHdoZXRoZXIgdGhlcmUgc2hvdWxkIGJlLiAgQWxzbyB0aGUgc3luY2hyb25pemF0
aW9uDQo+PiAgICAgICAgICAgIGJldHdlZW4gZGF4X3JlY292ZXJ5X3JlYWQgYW5kIGRheF9yZWNv
dmVyeV93cml0ZSB0aHJlYWRzLg0KPiANCj4gWW91IGNhbiBqdXN0IHVzZSBtZW1yZW1hcCgpIGxp
a2UgdGhlIGRyaXZlciBkb2VzIHRvIGRyb3AgdGhlIGlvbWVtIGFubm90YXRpb24uDQoNCk9rYXks
IHdpbGwgaW52ZXN0aWdhdGUgaW4gcGhhc2UgMi4NCg0KPiANCj4+IFBoYXNlLTM6IHRoZSBoeXBl
cnZpc29yIGVycm9yLXJlY29yZCBrZWVwaW5nIGlzc3VlLCBzdXBwb3NlIHRoZXJlIGlzDQo+PiAg
ICAgICAgICAgIGFuIGlzc3VlLCBJJ2xsIG5lZWQgdG8gZmlndXJlIG91dCBob3cgdG8gc2V0dXAg
YSB0ZXN0IGNhc2UuDQo+PiBQaGFzZS00OiB0aGUgaG93LXRvLW1pdGlnYXRlLU1PVkRJUjY0Qi1m
YWxzZS1hbGFybSBpc3N1ZS4NCj4gDQo+IE15IGV4cGVjdGF0aW9uIGlzIHRoYXQgQ1hMIHN1cHBv
cnRzIE1PVkRJUjY0QiBlcnJvciBjbGVhcmluZyB3aXRob3V0DQo+IG5lZWRpbmcgdG8gc2VuZCB0
aGUgQ2xlYXIgUG9pc29uIGNvbW1hbmQuIEkgdGhpbmsgdGhpcyBjYW4gYmUgcGhhc2UzLA0KPiBw
aGFzZTQgaXMgdGhlIG1vcmUgZGlmZmljdWx0IHF1ZXN0aW9uIGFib3V0IGhvdyAvIGlmIHRvIGNv
b3JkaW5hdGUNCj4gd2l0aCBWTU0gcG9pc29uIHRyYWNraW5nLiBSaWdodCBub3cgSSBkb24ndCBz
ZWUgYSBjaG9pY2UgYnV0IHRvIG1ha2UNCj4gaXQgcGFyYXZpcnR1YWxpemVkLg0KPiANCj4+DQo+
PiBSaWdodCBub3csIGl0IHNlZW1zIHRvIG1lIHByb3ZpZGluZyBQaGFzZS0xIHNvbHV0aW9uIGlz
IHVyZ2VudCwgdG8gZ2l2ZQ0KPj4gc29tZXRoaW5nIHRoYXQgY3VzdG9tZXJzIGNhbiByZWx5IG9u
Lg0KPj4NCj4+IEhvdyBkb2VzIHRoaXMgc291bmQgdG8geW91Pw0KPiANCj4gU291bmRzIGdvb2Qu
DQo+IA0KDQpUaGFua3MhDQotamFuZQ0K
