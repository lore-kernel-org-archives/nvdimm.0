Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EFE72
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 13:16:33 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FDBZPk022108;
	Thu, 15 Jul 2021 13:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=AqYkpIaoS+rUhV5v9YU/BdKssy1FvU7isE7FDjvR6P0=;
 b=Q9k+L+diiY9I0qgEpZYqwGzh8kccyXqqoegetef0ZGOswpc0mluW9Ui0qNN53KdWNdTb
 U70wSu1quqhEpEkzk/WfrYV7KSr2IJEBb61scacB2jCbpXTeNZxybnFgpIiizza8oJDN
 cfc2I59G4zXL7xQlAPw4HRmWnyeYG2YRaD/qPLhmwOWt0wGZJIwRWa+sWfeiruowH2zF
 9G4J71m6XFApfj86FWZC9LBn+ZNOIqZbcbVFdVKpkGeRJC6QjgEdl5cfaYWBWljj4K6d
 EP46NN9EpP69jBICDK1lk6V3w8BS3LvuPSZ7FXFHg1OiVIUpreQcWUmpxKze4+u6kw98 8w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=AqYkpIaoS+rUhV5v9YU/BdKssy1FvU7isE7FDjvR6P0=;
 b=TGMYiRXCDPfVVmD2gZrY53ntpppV5ZLKa182/Dh2pEij7kFsqfX/R/QkSmQ0EvtPPB7W
 Qmq/KNlDFak5IJGTYcB+rEJbTcgkYtpWmDL9VwFX3bsszXhNRWOgEQNtPkGxlS9MFSUC
 dWYitkcssugYyDxbqnjScp+xcGkveu0POdVb+WsjekYe1iTf1W/uYlZ3mBayLas8S0Bg
 rDcEUakemSKHSb7j650cL9PtbS1QaPgUGEJ9P2UoEPjmQlLUr2+V4xUeqkNv253QUO9v
 gfiL2BLpAIMweH/DWXRn8s9YGVKZT3Ki9sqEyOhiLSjusyFuRdD8BMUJ6+hMD8msYggM Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39t77usd27-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jul 2021 13:16:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16FDAd72145989;
	Thu, 15 Jul 2021 13:16:26 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by userp3030.oracle.com with ESMTP id 39q0patq70-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jul 2021 13:16:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nkyu6FyDXREYrEq+sWBRbYp9D568BZixcCXDcS3OQB8kfLOgVHfoWdNsurynGnbzRb7c5/AG9sRSJ8yL/s08I7F14HSXncEdzoHTbIvtbKrjvSSJx8jZ124/xbqVV40vS/qSmc/nIe6jIdylxH8eYDb6ZNlKjnh8pe5fQ5NLcICiGOqGVEqA+biskpu/Zu4BtTeoW6A01IvwFnNmI6ssnsVMKM4s9orcdx39VZKYrvTy4D3cc0+yFULfslIKUummyTxmzVkbC5V1CBeDscFBqMW7C6L7TuSGb8oAxF908xgfmtjXKsejubVQY4dwHtAfrcEvk8gDzgEDDBL4poRLLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AqYkpIaoS+rUhV5v9YU/BdKssy1FvU7isE7FDjvR6P0=;
 b=HbMSpykGx43pAtz2nlZ8/D2kq01+QAA3eoZntp5+gB8h4npFYbplTZbFQ4pS7w/eEpGCzY0mENCynXQ2sCZPU/st/eENpzxg13VWfwP1OMt/0OBGpKBrFtCRY8fYzvM2VOotAqDRJm/7RhWn6QUSa9T1XdGCs52ona7YMrSOqGZUW+99CCG/ORCHHHiIW0t78QHMwIEeMOgU5uNONsGrx9hnMdcupaVyJ3/bZcG2EMDt8I0C/iQrN7DoqNu9iZG/2hjd+B4qPGEANBFxqaJU/hygnP2r9EXtOVBvF6aJGcBNFZXY+9zFqTcLEGJUTjE+muZ749ak2d2XuT6UV0eGqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AqYkpIaoS+rUhV5v9YU/BdKssy1FvU7isE7FDjvR6P0=;
 b=DGwdfz2U2i1F20lbQJBmXWFfKLZ+5ZFd0297FFN/8l52Qw2YXctuVxSMiHkI7+GIERzisSrjqe0H8g87dlSVwWIGLvq9C96hM0YzXfdtlZVHSlJWaXhK867yMwTnkMihfVkvzhyYtbvSNRfdIBDnWLrB9oTgvH1zQrovuq2Pzls=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4980.namprd10.prod.outlook.com (2603:10b6:208:334::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 13:16:24 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 13:16:24 +0000
Subject: Re: [External] [PATCH v3 07/14] mm/hugetlb_vmemmap: move comment
 block to Documentation/vm
To: Muchun Song <songmuchun@bytedance.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-8-joao.m.martins@oracle.com>
 <CAMZfGtVrv=Eh3PGkgYm+mV_E-mO9_0rVW0LSJsZh0e9Kr9hBFg@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <5f381fb0-d138-c41d-6f6a-479b243ed1b8@oracle.com>
Date: Thu, 15 Jul 2021 14:16:08 +0100
In-Reply-To: <CAMZfGtVrv=Eh3PGkgYm+mV_E-mO9_0rVW0LSJsZh0e9Kr9hBFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0084.apcprd02.prod.outlook.com
 (2603:1096:4:90::24) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by SG2PR02CA0084.apcprd02.prod.outlook.com (2603:1096:4:90::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Thu, 15 Jul 2021 13:16:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23ee928a-5d8e-403f-7feb-08d94792bf07
X-MS-TrafficTypeDiagnostic: BLAPR10MB4980:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB4980B5E211E991E4D87E9FAFBB129@BLAPR10MB4980.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	2R/RgbAEkeHLZt4yWIxm0CFCCuiy2Xj4pSPSQBBYKOWAANrTMQ4pDapBkw71RYky+vqyOlS5MoZqCK1A2VJ7OODx1wx42RKEBSzbbl/1w0spaXPQae7G9jjsXBRRaxXGUfcGKGd8yHn0L0Y+PBwBPst26R/UKMqOqGgy7ZG4TR3W/VFF2YRqQbX2Exmbv5xueHtRSrR99MVW14jMKNTHO/JCvY/dkzK6V2WopzHCUsxHjUlOUtgFis+JY2fTe+fn0CcOdjDgaOpx/L/ND8nGNGaM8c6LAYCfuNpLS5sw2QltoVqK/oh+zr1B/ptV3CFH4zA4tVjh673OKgGSnwtYmVeWa7Qg9i1ZZwjturW1k2OJArCwHvAZiVLh4DUSAPfr7K+IkMJw8q6BmdLdSbsQBXgfChjUU5BHR6QN4BJE72GhlJrwMbYljT1fvjdXx72RuvUcoMx+FCGf25fuhUtodY2O6UNsVO/lseGdnzZEuSK5Y6XSoIuHk4dXlLuvK9hr1TAAmhFUcqGOop07u4EZ/uJseiZA8p1kBBeW9ENMrqJORtLSbK+qafk77agtf6p3EDekM2c7BGi07nBjPNUJvVXBwja1nvjrdVoOW55X+41RCj0Ix5Ig4P/5cGc7nrUInBGlt6ZlZmYOfyz7452ro5Z6hQS5mFf6TVv7+mS1N8zOajafAQcCiaFTIdTumTh2K9hnck0iZnVTQlJMQxpVwQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(396003)(346002)(366004)(86362001)(36756003)(16576012)(956004)(31686004)(316002)(186003)(4744005)(2616005)(5660300002)(7416002)(83380400001)(54906003)(2906002)(38100700002)(4326008)(8936002)(53546011)(6916009)(6486002)(478600001)(66556008)(66476007)(8676002)(66946007)(6666004)(31696002)(26005)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TzJNUlJsV2V1dC9aeXNMMmlnWkdRM3NjOUY2OXdKNEhkQzJOVS8veGl5eW1H?=
 =?utf-8?B?c3I2V3hjbm0yNjUvSUUxdXJlRWNFcnUwSUViU2RueXVJZm00bGVJeVVYYkFT?=
 =?utf-8?B?U1lDa3Q0MFpMQjdoNDl2RXpRUHFnNUc5N3gxU1lRK0E1T2FEUTJpYk1LSlda?=
 =?utf-8?B?aFBvODgyNXhrQnhFejA0M2NvcTdLb3luQjZRS0Q0OW9PTHdKa0FiT0VERXJO?=
 =?utf-8?B?Wi9aWWdIZDNrdFN1bjNlUjFteTE1bGFPOEY5R09hcEdmZkg2NUpYZys0Z2tv?=
 =?utf-8?B?SnVsQ3ByUmlXYTZ6cTdaTFErbE1aUktWc2VrQXMvUkdna2N4dHBOY2VSV1Zj?=
 =?utf-8?B?cG9sc1BZcUhuUmVQdkppMDhGcVhXbkhQQTM2Q0h5c0hpU2NJK3ZDK0ZiMU55?=
 =?utf-8?B?K1J3VDJ0RGpNNzFjbGhrcFBaMGJCOThKNitha2xHanBHR05uNEs2U1dpQzdM?=
 =?utf-8?B?L29mNUhkOHlxelBSVzczSlliQWc3c1VpT2ZTMGxjaUdWRS8wUHNlZXZWbDVu?=
 =?utf-8?B?ZU02TTE4NzlobmlzMGdTTzYvazdwN3RoKzZjeHFtdTB3ZGp4L3Bqc3lLdUNF?=
 =?utf-8?B?WHV2V204NkdnM2tsdnVhQUJNZzR3R2VTeWF3QjQ3ZEF6MmhqSEVRTTJGNXll?=
 =?utf-8?B?Y2VvMWx1Umowdm9JY3ZRQkVVL1BXRjNYWDI1SFlIbllvRVVOaUVZMDRQYjJJ?=
 =?utf-8?B?Wk1kVVpTRnNTdFZzblBzMGRJeXNCcnhyc01xR0hoYXNhOVMxcWtSU2ZxMGpi?=
 =?utf-8?B?MDhpeUlMYmZwOE5WdGZCU1NSMnRFQXJJOXBCcVlHdFMybFIzQ2ZiYmorU0ky?=
 =?utf-8?B?RnZPbGRYaEEvOHRKcDM0VDVsK0tkaGRQMTZRZ2YwWm9WbTVwY3JWN1d2TDR0?=
 =?utf-8?B?WjhpejNScDJDMS9Lc3drMGorS3A1bjVYSmtEdm5kSXVEY0tGOE14VTNOUUNz?=
 =?utf-8?B?NkozTUtCZE8wOW9NVExXNXYzSTFQcmdOSnhuQUFjUHFJUG9NZDlGMzNWRXdP?=
 =?utf-8?B?TmtwQWN1MVAxNUJnb3BpY0tOc3dpeWVDTkpBb0laVm5nOERzNU83eGFEV2h0?=
 =?utf-8?B?eEczWGlrQU9DUWV4WWNxeG4xVmtqVDV0aHQ5T0VWMkd4V3d5RFB0eFlQVkxo?=
 =?utf-8?B?RC9Ta1RjVlVra251TERhVUZKdVFUYzJpSDZLOGtmdGtaSHRKVTJ5bklpd3B4?=
 =?utf-8?B?RVJKTlU4OENKTnNwYVJlYnNPYjkvOU9iZ09nMUJVSHd1UDNlOENCNzhFZ2pi?=
 =?utf-8?B?Qjl3TG9veFhpRSt4TUVXVncra2hYcEtDZjI1NS8yVFNkUFMwRmQxd3Y2SHN1?=
 =?utf-8?B?TTBEd0o0WE9TMkZTNkluK294cThhVFdMalJ3ZWhjQUlGYlRYUGJPUTNkWmJ1?=
 =?utf-8?B?c2t2ZDQ2NWp2ajN0S0tBeEYrSVl5Y2lCVXk1WlJQWGsyQ1ZCb2FEWVFiV1hF?=
 =?utf-8?B?V2NvOS9UbXo0TFYrWWt3TSttVlNlMFNNb0JPNlA5Y24xTFIzUHpJRXlNdUpW?=
 =?utf-8?B?Y283cXBsajl4cnE0L0hFTmtmdUw5WGpJUVBHNllFbmpZajhGcFhQTUo2WGlk?=
 =?utf-8?B?akhLWkplSFpnWGRNZ2h5YjViYkIxdW1qbnJIaEdVZFlnVExmRFBJQXBsMGxS?=
 =?utf-8?B?eW1LREJ6Z3RaU016MG5ERFR6d3FVYU52TFhaVlpBWjBNNWlwQXhHdlVwTm5r?=
 =?utf-8?B?dkxDcDNuejNiU0MyM2lCWm9SaEJRYTZiRkU3ekFDQ0dzSUtLUkllNjcxajQ5?=
 =?utf-8?Q?Xx41cCMViTAztkesezGArA+n3QRa0fugcVdpwXk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23ee928a-5d8e-403f-7feb-08d94792bf07
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 13:16:24.7005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WTeEm5RkvqYChrym2fjj0LwLPgSJUp4+YyXmLcPU68Xlpgzr66H2BViHGg57E/8G63U2w/lTpNmT0RapYVZSCSkB+vaFguVNkS6fC0u+Oxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4980
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107150095
X-Proofpoint-GUID: ad_uhcVcxRrsvf4AKXPIS9UOrDcfIE3q
X-Proofpoint-ORIG-GUID: ad_uhcVcxRrsvf4AKXPIS9UOrDcfIE3q

On 7/15/21 3:47 AM, Muchun Song wrote:
> On Thu, Jul 15, 2021 at 3:36 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> In preparation for device-dax for using hugetlbfs compound page tail
>> deduplication technique, move the comment block explanation into a
>> common place in Documentation/vm.
>>
>> Cc: Muchun Song <songmuchun@bytedance.com>
>> Cc: Mike Kravetz <mike.kravetz@oracle.com>
>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> 
> LGTM.
> 
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> 
Thanks!
