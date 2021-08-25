Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C8A3FC2
	for <nvdimm@lists.linux.dev>; Wed, 25 Aug 2021 19:11:17 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17PIOAa1006325;
	Wed, 25 Aug 2021 19:10:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=uRwyz35lW3wZl6ehu6So6y6mnKhsSFRxSvAd9n24rQQ=;
 b=C+zeiD1q7MUva58ObUsYp77iXe1I757ddpEdYXbqoFR3JBSHyd41V+PdjUucdCso6hms
 ruu/ZgbEGDHc/aRZoq5OC/OxM8KBj2zeWCm1fM8d5EHdJC77kbMGOjyXrdhFzYkf6I6p
 NahhEKg4GTFpSR7p9HIeu2I40po63U469DmXxe9L7yJUQQZUvD0cf/3USQMy7i2ItGPz
 kwmEa7RLXYl0oBJUItLZnNQaDZhKI2uXxml4yRU1Z3AAqUSvT4EkBx2BHPUiw8secGI9
 tjrBzye/39VDmdCbINr2VYfPrndyhHxxTKdr0KfcAzVV/Kh9EyjSEPUr6W4dzUCRwxmV Hw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=uRwyz35lW3wZl6ehu6So6y6mnKhsSFRxSvAd9n24rQQ=;
 b=YH6kw29wZe5cAXwjnage2y/GOXVU/ZdMcb1wnBlAAuK2E34Ta6LBb9xnRxVnlfGzFmQZ
 RcVf1G3ZrfT9L4u8CKxpm+mtruRfkebImegLXRDuov01APZXOWRVDD2mdAGCPuxD++Gr
 n1Oi7iwYdno5RV8+RJDOcIsxUSIsUMJ6uVBqOlbJqzy7Lr2MYyjLNy/+utlRrMaLWkDT
 UcwGtZFdUhvR2Am2De6I5gg2cWTVD6lEim8FjgXnWn5/ptVn/I6CnznpMrB/lRQPk8uT
 yKP3CsPQuY55pJsbXZ/ILHGOSC9NL/Sqk0K9ls641fIgIV7ZOp9pXD9wbI8VMXlaDCEF gQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3amwmvceam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Aug 2021 19:10:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17PJ1PuZ054634;
	Wed, 25 Aug 2021 19:10:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
	by aserp3030.oracle.com with ESMTP id 3ajqhh7hjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Aug 2021 19:10:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKUE18YSovfsTSzVx/Yq5Xo/i8Yr/XEP9sESRrpbq2h2AlQbcJnzRcy+rm7NPmo//ynHj8JtqHHXkLXFXSW+tPDpC04YtxlCIOZR8uVSg0EqJJJ1FosvFaOUaYY2nwK/5RNyj2jlvkGzMfc12wwxDp0j/hOhP3x0d5Mnf0wWVagwFbrJQzOx7WdT1b5XYPYZ2A8VWpklNyeqSJCMcAPWx9H5SJogRGHUqMatnlJVEhtE5sXkkoIlyRHexeEDK3P/Hoq9Eia4JxFlB7FK3EMtTQiDzjnLomK27TA7auaJ42sS3/r7dze/vKLMaNzmdj29WOK8OTl/Oj9CK3DYcfLpqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRwyz35lW3wZl6ehu6So6y6mnKhsSFRxSvAd9n24rQQ=;
 b=cfwe7p5hDiu9+6WZSk9XIktnRnIhwGOzAzHSxBzZS8hvx+O8qsVNEP6bVthIFeQMQxhIo0Ej07m07qUSwr83CAeSq772PKoKWpwatqHH2CVifvIEcC0tyfM5eU2DbzpadeWTwY4ph53ttHULodHsuYqCismpWVRNqOe29lOZO/Sz7vLPdITo6D9ojcqSZOKqc5H8GEy774iE0+xGh5tuzwU3PNz64RdHWPZfeM1TWnxLYsT21gOgvROCDlAi5VIdYN/KXU5W9kOaZzL0zvphanvjmVXac4a4WqnRus/EXvpoJ+RdmtybbXIC1FcfuJgILiMgzxj3V0C7Zm+1BTRFIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRwyz35lW3wZl6ehu6So6y6mnKhsSFRxSvAd9n24rQQ=;
 b=K0wKx3LDXS+HV44mUUSqWuI+To6WSQiw8Fr1TyGyVf+5jVTHiX438fbhDS8tnptr7K4FqCby3GrKk9OUOewyaVDWr5y/1qOzLlKI4kAYQSQv0vvFUy2gpe8ghczHRmGdsPKhKp2Drp3jUNyQYr1+Y79AiNyEym58d9JUHBXFg88=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DS7PR10MB4846.namprd10.prod.outlook.com (2603:10b6:5:38c::24)
 by DM5PR10MB1852.namprd10.prod.outlook.com (2603:10b6:3:10c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 25 Aug
 2021 19:10:46 +0000
Received: from DS7PR10MB4846.namprd10.prod.outlook.com
 ([fe80::97c:b35c:49ea:13f3]) by DS7PR10MB4846.namprd10.prod.outlook.com
 ([fe80::97c:b35c:49ea:13f3%8]) with mapi id 15.20.4436.024; Wed, 25 Aug 2021
 19:10:46 +0000
Subject: Re: [PATCH v3 13/14] mm/gup: grab head page refcount once for group
 of subpages
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi
 <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-14-joao.m.martins@oracle.com>
 <CAPcyv4i_BbQn6WkgeNq5kLeQcMu=w4GBdrBZ=YbuYnGC5-Dbiw@mail.gmail.com>
 <861f03ee-f8c8-cc89-3fc2-884c062fea11@oracle.com>
 <CAPcyv4gkxysWT60P_A+Q18K=Zc9i5P6u69tD5g9_aLV=TW1gpA@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <21939df3-9376-25f2-bf94-acb55ef49307@oracle.com>
Date: Wed, 25 Aug 2021 20:10:39 +0100
In-Reply-To: <CAPcyv4gkxysWT60P_A+Q18K=Zc9i5P6u69tD5g9_aLV=TW1gpA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0458.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::13) To DS7PR10MB4846.namprd10.prod.outlook.com
 (2603:10b6:5:38c::24)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.175.179.129] (138.3.204.1) by LO4P123CA0458.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1aa::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 19:10:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c671331d-e7e0-43cc-5b64-08d967fc0b1d
X-MS-TrafficTypeDiagnostic: DM5PR10MB1852:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<DM5PR10MB1852FCEAB5934FAB5BC1F4C2BBC69@DM5PR10MB1852.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	8MZchYlTxNikxXziUw+FtokP0bh5xCKWsm7AUWB23EEviVSKnjpQAjG5n5/53pPveXBdzqiN4kHiSdbPgHVJvkiOiYsVyJHrR4Ll9cC4oymWdFZZNqo9Cy/Au/5ttFh++6ilAjTgJKk+k2/yn0DTPOwpzoxQTIyZz+AVje7RdEcDAZcDs8sbbc91Fsg+0bmKkTqDNXoU+oib0t6/0ZMqNYpcr9MKDXr4g7aM5wd3m1tX0PoJCr0DLNCqtau2DEiSjmN+lMEOTqxNApVveGgpmyOU7gAiBlVmpDN/JRHEZC02XreEyw4XoLY500m+HrFMaBVDEggjWUl4a7RgRGuQXOiTNj5gWednWLP1qMNFSPLe8SbBC2ojdfyC+y/qBkJHAEsdzl08XoZ8fB92OM7176LNNojviczvnBpeM6nnCe1F0gIUf1CXse/SVLqBKyDOmNUTRX9ZZ2IG0rHcjQLkEfO95VZ4nmS2rNSncChyZxJdO2o1S0MGJR5tRoCfS3z3J2c1BDFAhX8IyQ6i/h+Ky5vXvM5K8ndIz7c8IVbgUXI60P4S2qR6eqiknG8soiYkseDHW33r377oL+54sPH+zl/LHz0N0X2xF/3km1rBZ5/Vxwacc/esswyOS5U6mRZsFKGsMo1gKsGR6DrznW3TxwuHglpn9kQdzsiBoS3ZUHfL6/vRmh8IksuCxgCx5TySBFqDp8uB+OrXZ2/irvWtNw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4846.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(39860400002)(136003)(376002)(6486002)(2616005)(956004)(8936002)(5660300002)(54906003)(8676002)(38100700002)(36756003)(66946007)(83380400001)(31686004)(66556008)(66476007)(2906002)(53546011)(316002)(186003)(16576012)(31696002)(6916009)(26005)(6666004)(7416002)(4326008)(478600001)(86362001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?M0NBMWhUbk52ZUV0T0dZT1lDbXF5cENic1VKN2M3TnUzVGJkS0ZCeXhxM2c0?=
 =?utf-8?B?akRRQmhEcUVVVmhaOXl1ZmR6SFlrMllWUkl1QldWUkw0VUpPS2d1SUk2ekpC?=
 =?utf-8?B?RW5rT0IwYnZWL3kyVy9oZFpFVEhYWmFlYnhNSk5ORDN3TlYzTWgrM3VnQ2ps?=
 =?utf-8?B?K1JrWitON1RyTkZFdWRoeVFSNkUydHBDRUJpWWFoU1pSOVZFcWs0aFE2eW9U?=
 =?utf-8?B?N1AxeUp3c0FoRzZsTVRyTjZlN0drLzh1aS84RmFiMU82dEhqRHJXTG1RcTVw?=
 =?utf-8?B?TnFYcDhIVWsxMlVkUHFGaHY2clBQQU90WmtJclJtR0Q0R2FJY3VnVVR2ai9M?=
 =?utf-8?B?MlN3aDU0T2VrMU9tYjNselIxV3lMMloxeWRzQlVMWHRpbW9FK2xvZGFoQzM1?=
 =?utf-8?B?VWh3d2tFU0EycVNhRW9QWFYrTWM3K0p0L3ZOZVA3L0RKUGVwMW5hVHB1N3hB?=
 =?utf-8?B?d05oRDl0b1lMN3lpNmR6SVpxeVV0dXdDRFREMmcvYi91SlpZL296b0Y0OGpZ?=
 =?utf-8?B?THd1dHUyRi9oaE13NHNKcTdOUEZ4TVRYMEdiYVZ5OEQzaVJQTHU4dnRCN1hv?=
 =?utf-8?B?M2hYbk8ranJ6R1Brc25OYzVjVnQ0cnQ3cTZUcjk0QjdjeTBnY0NNdHExS0h3?=
 =?utf-8?B?dExScXdMK21RczZFSkpIRTlTbEFzbjB4ZngwNmI3MXVyK28zNnBTNURQY3No?=
 =?utf-8?B?dlc2MFhyTDYwdFRhcE1ZSkxIQ1Blam9GZWtSd3FwcFZMZTI4Z2tFQ2thdmRF?=
 =?utf-8?B?TE5pT1JhelBjQXZ6UkJOWnQrWm1jbnZBdGQ3N1hlVlM4bnNNQ1FlbWE5L2ZV?=
 =?utf-8?B?RzNJbk5tSnVTb25uVFNISTVPVUx2cjhUMjF4a1c3bnYxN2JDRGxhb2swR3dT?=
 =?utf-8?B?RlhLdlJqb0FIclJVdnVnR24yMlRialBPcVkvaU5CR1MzMnp3MlEzMzBab09M?=
 =?utf-8?B?dW9udUdyU0hyTmw1ektydXRBKzdia2xlZkZKbFdwM3I1c3lJU0hMK2tiUVBq?=
 =?utf-8?B?d0hydmVZWFlHSkFSbVN4TDJmc20rL2l2RmJNMjNGcHMwZ3h3eEZ5N3BUYnpT?=
 =?utf-8?B?N1pkd0I4T0R6TTZYODNxL3luODUrOER1VlZOQzNmWmkrZ1QwU0wxOTYyUVFN?=
 =?utf-8?B?Y0x2c0xvYWkrQlFQdnhLU2VvZCtobVVQSDlqQ21qUFB1SVBuQkdRQm9ST2hv?=
 =?utf-8?B?dGw5cnNJdHo1NG8wdmI3Ymd6VUgzSnJTMW9nVGdPWDg5YmRoUCtvVFZGeTFK?=
 =?utf-8?B?cU40S0hpckV6RXIyaWIrb05GR0JvalRDMGw0NFBMcXpLTGxVNHRtbkRscVN3?=
 =?utf-8?B?MlNNeU9TRVZ2aGk0MmEvVGhocFNmRmNUZGs5eGVwbjdBUjVpNElMWE1CbWtn?=
 =?utf-8?B?aEgrbXh3L3o0c0czRHlRZUc3N1BWamhkU250aEluNUMvQ0xrS25EYmZvaHFt?=
 =?utf-8?B?S1ZlblB2TWR1a3ZFNktBM0tpbU5wVWZqZ1M2WUZGci9wWTlyZVhTcERGMlk1?=
 =?utf-8?B?NWFRTk5qNnZvdk53L1FnSGxoclRtZ1paTW4vUWpxaVgxSHlHQWJldUxuNkU2?=
 =?utf-8?B?czg1aDJSYVlqYk9UN0R2Y1NUTEVHV1Y3QS9WOWRLdDRWQUEzQ3Z5b2hyUmx1?=
 =?utf-8?B?a0NwWnZXRGttejRJQ0YyZHA0aUJZWTlmTnhQVTJPTkZzU2Jvc2E1Z0tpVWZC?=
 =?utf-8?B?WUU3LzkxQ1VUZGdwbEZrOXBQQURiZDBUdWhjbXpsUmxYczZUOWpyK0w4Wkl2?=
 =?utf-8?Q?Uz8DBIr8cQl4OdFHLWJCL8hXPufGfO0MO9wqv+X?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c671331d-e7e0-43cc-5b64-08d967fc0b1d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4846.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 19:10:46.8416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2xevYYffpx5ob4ap5HL6RosYKmoL7tOeBBV5JMVmne85hatyQ1Cz5QiOYfvrTgbFrrepKbAYDx4NAij6cnHvdCPi+6TJ/h933Q27RI9rN9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1852
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108250112
X-Proofpoint-GUID: TVheedWHdyZ9w5IwJ5nViXvHI2WQN8ex
X-Proofpoint-ORIG-GUID: TVheedWHdyZ9w5IwJ5nViXvHI2WQN8ex

On 7/28/21 9:23 PM, Dan Williams wrote:
> On Wed, Jul 28, 2021 at 1:08 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>> On 7/28/21 8:55 PM, Dan Williams wrote:
>>> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>>
>>>> Use try_grab_compound_head() for device-dax GUP when configured with a
>>>> compound pagemap.
>>>>
>>>> Rather than incrementing the refcount for each page, do one atomic
>>>> addition for all the pages to be pinned.
>>>>
>>>> Performance measured by gup_benchmark improves considerably
>>>> get_user_pages_fast() and pin_user_pages_fast() with NVDIMMs:
>>>>
>>>>  $ gup_test -f /dev/dax1.0 -m 16384 -r 10 -S [-u,-a] -n 512 -w
>>>> (get_user_pages_fast 2M pages) ~59 ms -> ~6.1 ms
>>>> (pin_user_pages_fast 2M pages) ~87 ms -> ~6.2 ms
>>>> [altmap]
>>>> (get_user_pages_fast 2M pages) ~494 ms -> ~9 ms
>>>> (pin_user_pages_fast 2M pages) ~494 ms -> ~10 ms
>>>>
>>>>  $ gup_test -f /dev/dax1.0 -m 129022 -r 10 -S [-u,-a] -n 512 -w
>>>> (get_user_pages_fast 2M pages) ~492 ms -> ~49 ms
>>>> (pin_user_pages_fast 2M pages) ~493 ms -> ~50 ms
>>>> [altmap with -m 127004]
>>>> (get_user_pages_fast 2M pages) ~3.91 sec -> ~70 ms
>>>> (pin_user_pages_fast 2M pages) ~3.97 sec -> ~74 ms
>>>>
>>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>>> ---
>>>>  mm/gup.c | 53 +++++++++++++++++++++++++++++++++--------------------
>>>>  1 file changed, 33 insertions(+), 20 deletions(-)
>>>>
>>>> diff --git a/mm/gup.c b/mm/gup.c
>>>> index 42b8b1fa6521..9baaa1c0b7f3 100644
>>>> --- a/mm/gup.c
>>>> +++ b/mm/gup.c
>>>> @@ -2234,31 +2234,55 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
>>>>  }
>>>>  #endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
>>>>
>>>> +
>>>> +static int record_subpages(struct page *page, unsigned long addr,
>>>> +                          unsigned long end, struct page **pages)
>>>> +{
>>>> +       int nr;
>>>> +
>>>> +       for (nr = 0; addr != end; addr += PAGE_SIZE)
>>>> +               pages[nr++] = page++;
>>>> +
>>>> +       return nr;
>>>> +}
>>>> +
>>>>  #if defined(CONFIG_ARCH_HAS_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
>>>>  static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>>>>                              unsigned long end, unsigned int flags,
>>>>                              struct page **pages, int *nr)
>>>>  {
>>>> -       int nr_start = *nr;
>>>> +       int refs, nr_start = *nr;
>>>>         struct dev_pagemap *pgmap = NULL;
>>>>
>>>>         do {
>>>> -               struct page *page = pfn_to_page(pfn);
>>>> +               struct page *pinned_head, *head, *page = pfn_to_page(pfn);
>>>> +               unsigned long next;
>>>>
>>>>                 pgmap = get_dev_pagemap(pfn, pgmap);
>>>>                 if (unlikely(!pgmap)) {
>>>>                         undo_dev_pagemap(nr, nr_start, flags, pages);
>>>>                         return 0;
>>>>                 }
>>>> -               SetPageReferenced(page);
>>>> -               pages[*nr] = page;
>>>> -               if (unlikely(!try_grab_page(page, flags))) {
>>>> -                       undo_dev_pagemap(nr, nr_start, flags, pages);
>>>> +
>>>> +               head = compound_head(page);
>>>> +               /* @end is assumed to be limited at most one compound page */
>>>> +               next = PageCompound(head) ? end : addr + PAGE_SIZE;
>>>
>>> Please no ternary operator for this check, but otherwise this patch
>>> looks good to me.
>>>
>> OK. I take that you prefer this instead:
>>
>> unsigned long next = addr + PAGE_SIZE;
>>
>> [...]
>>
>> /* @end is assumed to be limited at most one compound page */
>> if (PageCompound(head))
>>         next = end;
> 
> Yup.
> 
In addition to abiove, I'll be remove @pinned_head variable and retain the
current style that was with try_grab_page() while retaining the unlikely
that was there before. I'm assuming I can retain the Reviewed-by tag, but let
me know of otherwise (diff below).

diff --git a/mm/gup.c b/mm/gup.c
index ca64bc0b339e..398bee74105a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2256,7 +2256,7 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
        int ret = 1;

        do {
-               struct page *pinned_head, *head, *page = pfn_to_page(pfn);
+               struct page *head, *page = pfn_to_page(pfn);
                unsigned long next = addr + PAGE_SIZE;

                pgmap = get_dev_pagemap(pfn, pgmap);
@@ -2273,8 +2273,7 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
                refs = record_subpages(page, addr, next, pages + *nr);

                SetPageReferenced(head);
-               pinned_head = try_grab_compound_head(head, refs, flags);
-               if (unlikely(!pinned_head)) {
+               if (unlikely(!try_grab_compound_head(head, refs, flags))) {
                        if (PageCompound(head))
                                ClearPageReferenced(head);
                        else
