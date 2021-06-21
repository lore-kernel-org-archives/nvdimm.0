Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F193E71
	for <nvdimm@lists.linux.dev>; Mon, 21 Jun 2021 13:50:25 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15LDjNKS002388;
	Mon, 21 Jun 2021 13:50:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KvSKx7TuURLRSzNFOWWSXyfFrMIS5xV5Y65MAkl6uWA=;
 b=eFlAyAL+Fa3MM8Mp0k1ab57n10xF1uODinPvvCCtGRJTo7Oz4GLhZ1hCDTnXxEE3yeOL
 SkOwLAo1IrhmH+jCPahK58DjZtpHIT9k3YDh2sIqq7Nfk/MUZwjAWJ9bBZYkGbR+rnna
 Nz0w38JiEIG+We3zI513cf3e4fUnHD1SGYnekL/iHsgkRzmDTud1A6EpQaLXAE4CWu+V
 8lYsHGp6DP5KSh7tIyDYKqmCow8z/STR+nsC7VaA5eUcUVIvfjvL90AbtXPBTO5FpiKz
 xOYotLZoNjvPN2OZcg9Kqu2MmSbBWy+Bp+mPD/yZg2MUt3UfCMYpBnsChYtYkeo2REUh nA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 39ap66gt48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Jun 2021 13:50:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15LDjYxe153495;
	Mon, 21 Jun 2021 13:50:18 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by aserp3030.oracle.com with ESMTP id 3996mby0ys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Jun 2021 13:50:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AlfbySWxc5ILbckMsK3BWWC5ROwHhoJ3SgtPqSsx9ZvLAvjnxGdNowlx0qkf//UTNYhdZvTTdgapvl1LisFX0UBGaSztp1//Fap/OrsyGqn33Zm0z5r5m+c3VU9ObeH0XXE09PFLmBMF0lzFi0P5rzsMmSbAt5OmxFWkSQjNnZRhaf7WipRrELWzGksbVTvdb8oKgkO30ILNNO7bhJUsu1wadJYggEk/DC6j9AH5/Z9hX36RG51Cj6Et70PBQtSWsTkn0Qk5fM4kR2B6/kAGi3gpeNnnWLDekVMqarJkThV/yfX8JGTdq6zFMvJmFebCDa02Q/VTU3jrX74jzyQrwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvSKx7TuURLRSzNFOWWSXyfFrMIS5xV5Y65MAkl6uWA=;
 b=jSxpqPEYZYqIPT3147oKLuVlczpYvlABRNDYDDqLqPQ49ZEVDeU8t1N2R+5CdUr/ypchh+Wo4NsEbYCs9I+HuKXosmsK9dHgWGYC2q/LQwfF5eZIQmNltRXcEgKe+UmcjlmSrjEntJCR7e2vmIcUechZepuT+LGlcq9SeWxTAu+InKO+W86xUx5rSn+41xVJ3ZGydzYu8C3NAkxCDB19y9gziQ1Mn4BQUZ34TIwOsCfhm3qseNMKDrkGqoziOXTYLqwl/l2AyW3iWqxuZU5TC6hgw5wrYTG+wYWiKERqv7EvHkdesDYrzIukXlRphXtVHSwTgroSrGciLo+G2p6DOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvSKx7TuURLRSzNFOWWSXyfFrMIS5xV5Y65MAkl6uWA=;
 b=BTmucGC3bfgNAW/1BC0UnwBmFePNkb2kfCO2JPIkjNLNJocZMvsOinReqElkK0Lpgr29sPG0n5B269OSg6AcS7x3ePriq3wPewzynC79Hp+u944r2HlhfLRB3XhlT8GmeXN2c1rzPMOKNDRdHZzB8r53CgysPUqMINk47G6Wr6Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB3059.namprd10.prod.outlook.com (2603:10b6:208:74::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.22; Mon, 21 Jun
 2021 13:50:15 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d875:3dd7:c053:6582%7]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 13:50:15 +0000
Subject: Re: [PATCH v2 01/14] memory-failure: fetch compound_head after
 pgmap_pfn_valid()
To: =?UTF-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPoyDnm7TkuZ8p?=
 <naoya.horiguchi@nec.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
References: <20210617184507.3662-1-joao.m.martins@oracle.com>
 <20210617184507.3662-2-joao.m.martins@oracle.com>
 <20210620235639.GA2590787@hori.linux.bs1.fc.nec.co.jp>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <c120de3a-84b6-931b-36fe-526e7b9fcdfb@oracle.com>
Date: Mon, 21 Jun 2021 14:50:07 +0100
In-Reply-To: <20210620235639.GA2590787@hori.linux.bs1.fc.nec.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [94.61.1.144]
X-ClientProxiedBy: LO4P123CA0472.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::9) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO4P123CA0472.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a8::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Mon, 21 Jun 2021 13:50:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31ab30c7-6c2a-42e1-2caa-08d934bb7f32
X-MS-TrafficTypeDiagnostic: BL0PR10MB3059:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB3059C078133D368B7FE236C7BB0A9@BL0PR10MB3059.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ZLgO8vwpyHUS+hyTYhiVHZh/pEMyJ7lCMRoB1CmJWxKoGZNUAbjhsVOndgDx3lZUgEDkA9s0gY1BExkc/f3duF3SXlJ8EiY220khcd+Vhw1NRiBp+4NyjAzghvOvaHcAh0Sraq5DAyBfBa7fWmLRG/bFsbEyjq8eVz7794VLs7L+lAbphytXAx1POv3zkWLByfRoQqZE64rMhDrF3AXHzL4p1Ny2KB9AqyTiNkl1wv/FrTijBXhHMnnlpNizYQxM1Vl23Sn+xi79+GE3UkdenjUpf+o7sGQU/Y4Jy2hvURnMjCFoifs4wAuzYVNXCwmJcO6TogX34f1fLLQkusFVWyq/Dpfo/PFXdN51QSbVxRW3/eac73xcUMWPvZ6zpErzAQN48CBi5woHj+nCIy1Oliu84lOmKtAbZDNDOghfPmIJkQjkWmQ9AgweVHVODNwMbCnCAHYq7i+7HTnNMHjNet1OKByKZZJ1GQfitrM4NnXeEg5vcQfAt+ynrT8PIetVO3u3q84M9boSAaZ7bePRUrqMpT9eBKySX+oRxEVi7c0vPtxNkdqunJnsh1tEBtbnXB++o8hExxlLlNgVrfiVIQmxx2qfaLrsVIj2nBqWFc5NULKn6pNqG9SmFPayua1PMk9aXXMbz4Z3JNH4ARs5BLM8wZZrIAuf81Qq84lZ+IE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(136003)(376002)(396003)(4744005)(54906003)(6916009)(6486002)(38100700002)(66476007)(316002)(66556008)(66946007)(16576012)(8936002)(186003)(6666004)(7416002)(36756003)(956004)(16526019)(86362001)(83380400001)(53546011)(26005)(478600001)(5660300002)(4326008)(31686004)(31696002)(2906002)(2616005)(8676002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NlluWjBXcTljTUx5L0hFOWZTVXZBbDhCd05LajJBSjlPd2hrRjNId2Y3WU5M?=
 =?utf-8?B?bXJnMy93ejBtQjhEdFdFbllSRE9YTU90NFUzSEl6d2p4blQ3QlFzZlN2ZlR5?=
 =?utf-8?B?VDRQam9FZ2J1NHpzblNDVjVGcS9vMDE2WEFIR3ZONElLazVVRWJqRTBaV1hy?=
 =?utf-8?B?clkzUHpvYVllYWh5elhySmVwbTZIQzdlcFJKQkRQTTgxd0pxZGlLTDlLaXJq?=
 =?utf-8?B?anVITXdNdDM2OWg3Vmw1V0ZSZU9sZUM1Ny9KYTIzZENRcU43bTY3Skg0cCtn?=
 =?utf-8?B?dlVCbEdQd0hRNGk1MDdNb2Zmdm92QmRvY2hqMXlJUUQ4YkdKd1B3dXRLWU16?=
 =?utf-8?B?RTZBTnlscEpTZDV4dXo5Y0t4dUs2NlFsd2hodDZDY2l0TVNhME1lKzZSZ24x?=
 =?utf-8?B?cWtFZGM5WFM4N2pHM2sxR2l0UmdONFpLd1gwbnFDa3ZNdHcvOGdWVnZ3Qlk5?=
 =?utf-8?B?VmxDWStNcW1pWTVPNGdxZXZUakNsUHZSQ2hMR285bWEybXFZYUlnME1qeEY0?=
 =?utf-8?B?OVowVlFya1pYMmlQSE1xdmFWSElJbnJvWkxRa0V4ZjJsVzlIbGJVNkRMeDV2?=
 =?utf-8?B?bis4YjlGWFphRE95TUx1MHNuSnZ5YktERy80NlBKbkRxcVFZWmxLNnpsMkhw?=
 =?utf-8?B?ZVA2STdTZlBZRjV5S2Q4R1FXTlhlb2owbHh4dlFEU3VINlc0bVVLby9RcXU4?=
 =?utf-8?B?ZDVFQlQwVGlRaFVlZmlrWEllN2xhQks0T1RBNkZpK09JWEs1RFA0bmtxWVBs?=
 =?utf-8?B?VmJpSUEyWFozUFBMU3VOUVR6VmhJaENDd3VMRkhzTk44alJPZXdnYlN6aXhw?=
 =?utf-8?B?WDFkNi8xRVlYV2Y1M2JpdWRSSEJ2SU5mclVJWDdNOVNlUDVxejh0UThVRXBr?=
 =?utf-8?B?UmlrZ0F6NGw3c0xleVNNVkhrWG9BMXc3NjB2eWhTSTRZSy9iWDZDZUUreDV0?=
 =?utf-8?B?RFYzTFFNZmpENDN4cXBCbmxlUlVldXpyV05mT1BkMUgyM2pFOVdlWXY2Y2xS?=
 =?utf-8?B?MHYxbEhkRVZteFNVdHV5cndSYVd6RmprUVlIeWYyUlI1QWhFTXpYd0FEQUNE?=
 =?utf-8?B?bXlXK0NoZ1loWEQvR3o0Ni9SOHdLTzhHVUhxU1NIMEh1d1RNZlpERTJlVjNK?=
 =?utf-8?B?VW84WlZTVHNxdlpmZ0JLbkY0MXpBSVArU2xnVVIrYVZycWV0STRaS3ZqQ0ZK?=
 =?utf-8?B?Y2RFREpwNXZiOUVzbW53QVkzbmtoRk0rQ2hhdkNQWWZ1VkJJRi9kSFZjM3o0?=
 =?utf-8?B?NmVBNWo2dVZaUFREcmJJekdFU285azJ1cFlUZTBTc3RJL3NDMXVxRVRGaks2?=
 =?utf-8?B?YkJxam1MWFR6VnJkWUlJdk0yaElib21GV3JOUGZBQ0srck9hQjlOaFlpRDNO?=
 =?utf-8?B?QWF2czRIanNla1BDdVQrYThWVlF1Rmo3N2NJTG9scThvQnJqRTBiSEVTWEc5?=
 =?utf-8?B?NnNBUTh4MkVscldzRnU0a0gydjNvei92T2Q4RzY3MEpvcmwzWWxIZUpDK2xT?=
 =?utf-8?B?am05a1dqcnhkdjRDVnJzYjJCOXp3VHNkbm9xZG5zSjZFMVM2WEVQR2h4cEI4?=
 =?utf-8?B?QlIwMVJSV2Q4aEhLd0c1eTQ1UGJiTllQMTBtbEhUai9CcmNUTlJyR3kyUGtp?=
 =?utf-8?B?bkx6dEdDOUh3TmtXbnhPWVpScWpLZGR2eEtOajVERWVrdmhxRlh0RDM2alRu?=
 =?utf-8?B?cG1IK0d1RWs2Z3BtZS9NU09Sa1M3cHJncGh2Tis4bEk3TVFHZ21oQXFrcDdJ?=
 =?utf-8?Q?+bw+YblnM1uEVj7bH8mXIwGZru1oOlyZisSAk+d?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ab30c7-6c2a-42e1-2caa-08d934bb7f32
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2021 13:50:15.1749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NqqopT/APFNz2iY9svjlLkp10xcYilDEY4/Dbt3bFcpCgVNdEczz/8qRtKdV/92T55FWUXXCTY2ZMlLtOis6a61oP/teWFjlv4et8WAY4us=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3059
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10021 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106210082
X-Proofpoint-ORIG-GUID: nh9NBhUNHgu9cPFxdxF9xILbwZ9zcRTv
X-Proofpoint-GUID: nh9NBhUNHgu9cPFxdxF9xILbwZ9zcRTv

On 6/21/21 12:56 AM, HORIGUCHI NAOYA(堀口 直也) wrote:
> On Thu, Jun 17, 2021 at 07:44:54PM +0100, Joao Martins wrote:
>> memory_failure_dev_pagemap() at the moment assumes base pages (e.g.
>> dax_lock_page()).  For pagemap with compound pages fetch the
>> compound_head in case a tail page memory failure is being handled.
>>
>> Currently this is a nop, but in the advent of compound pages in
>> dev_pagemap it allows memory_failure_dev_pagemap() to keep working.
>>
>> Reported-by: Jane Chu <jane.chu@oracle.com>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> 
> Looks good to me.
> 
> Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> 
Thanks!
