Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4824C2C9B
	for <nvdimm@lists.linux.dev>; Fri,  5 Nov 2021 12:10:02 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A59xUZC017948;
	Fri, 5 Nov 2021 12:09:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=H22Rnbo39fNjUFVhidfgTZjPtaJBWE1MKsq6fwDJ3Ow=;
 b=wo30eUhkEDy1Jy5YbtlST2tGmv+lFFHUURmJBT4eVFsHmZIq+ptiYS6n7dIHtYRXygur
 JbDMYrJ4bjsUwlrtaggkG9p61C3tUmnauqjXC3UXNKlciVUWeaCkso43wvMbQV2jjP4O
 Wj7ztshBmWA3LBkwJ/u3zqe4dwj+vL+/fTABqsa5CVCKeedamAJmV/6iZGm0AT6gWq18
 NnRzA8gPLWuRY9N0pkpN5QFxoIlGrZNwcNLtsVkD7xuPV8W7ql0OOdPkdoo8IAbew2Y9
 8Tja9GhNGWAVAt9uVjOpXqwKvVoTHTVYlgAeY0HvNBZ8tuyV+nrGWE72/1EjrfDNNbrp 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7e228w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Nov 2021 12:09:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A5C63ib117085;
	Fri, 5 Nov 2021 12:09:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by aserp3020.oracle.com with ESMTP id 3c4t5saj9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Nov 2021 12:09:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TvnhiQ7EEhclHQKyNS5f51TIbKKJHLYxwDpBbka2ktK9ZdEtr63yWspnRcMOytggccq19DUOpH/FDUuAQZJtLho+IuIeYdmsdEtbEAQNVV0mdYwl/5eZQFf+YhJ+Xinozkk2LIgAiR7k2IgjlmEutorq2B36qr0NhzxteRuD71P8YhrtQ/QtJZdhBV2P6ItP7nD8UOEOCpCWveXA6E7sXOW3IIyJaeLn10NuhGdvSHC5wUxxS/Bo+NSLIMamEDt3HjV0it0xP81FvsoGsnkZ5fT5aLIzbAwbR2hvn+vfSc59Ir2k5tUEiry0dzQqA6VrpB6ESJPYBrOzt2fV5GVBQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H22Rnbo39fNjUFVhidfgTZjPtaJBWE1MKsq6fwDJ3Ow=;
 b=XUV0A8VOShsW4rYUnESbFLn5w1By3FW/BbzmwfxHehq7ns0Mxa8U3IOcXE26Kj/uicHgFLhUw0UJyeLiGdlxrR8LJrqLIV8XHVrP9aynJteCHUwmaqpf4LWcUqSwSCg1mxAQKeQ2E/rolGymxkQy63a4EpyCK4U6AO5XRr87UxNmvsXtOhQ0VWFEk//BsiI9KVGJJZr9ryay0cgBLJNcHgLLCIFjsUNcy6N1eCiv/NuuQUMirGbdxwxCKPG6yvkUJdzp8fdhhZuX2zdCe3vH1q6ZhVbHXDPv4WVaktvT0b6No3jG2qvU5w5tAfDS3LGFz0jaJCk0n5NjyDoGBEzK/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H22Rnbo39fNjUFVhidfgTZjPtaJBWE1MKsq6fwDJ3Ow=;
 b=MBsz8SYvyRu47J6uSkmusjjCK2SSEy9xtm8D/t0E5NyyOpwFlg7ZbW1Ic/wrLMALAuN+/ZnGPvw0MrQIKAV2SYq0z2mpwoMiTxBM9CpWCytRX9TZI161xR8A4auHydR7Gl22c2dd2GoeguWHq16kk1sT/BREbPjXZFtvP4Gwk54=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4016.namprd10.prod.outlook.com (2603:10b6:208:180::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Fri, 5 Nov
 2021 12:09:32 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 12:09:31 +0000
Message-ID: <f33c2037-4bee-3564-75c0-c87f99325c02@oracle.com>
Date: Fri, 5 Nov 2021 12:09:19 +0000
Subject: Re: [PATCH v4 06/14] device-dax: ensure dev_dax->pgmap is valid for
 dynamic devices
Content-Language: en-US
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
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <20210827145819.16471-7-joao.m.martins@oracle.com>
 <CAPcyv4hPV9Vur1uvga7S4krQAmKZK5jrBrdOuK1AFHVE8Zk1DA@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CAPcyv4hPV9Vur1uvga7S4krQAmKZK5jrBrdOuK1AFHVE8Zk1DA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0074.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::7) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.160.24] (138.3.204.24) by LO4P123CA0074.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:190::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Fri, 5 Nov 2021 12:09:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e10d4316-d277-4a1d-efdf-08d9a0551fc4
X-MS-TrafficTypeDiagnostic: MN2PR10MB4016:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4016C25CD2E237F0CB016709BB8E9@MN2PR10MB4016.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Ghit1jlviXQFUeeovn5EI/lUwwRqHES8k89ETdbjkNfCZlf03guD19VEB+YGyXd0Lm/9hevvOLQHvBBbBeAmidZj4wDpPK8k80XEULwrfTDreAgww78kKFzGPRwTD3u+w9IbJqIGKWBv5T+x3S0XQ2BFV0jjeZcgpEY+GLTeOWHZle+f/7iaY+rPnp3KqTpD9Spgi0dKcnY90cnWdWvimeQEUl7qxNL6hIKkVxVLIXeHrwU/3gtA+K7JfEuGCX7RQCY5GEK1iGJ+n2/UE0Nf3XBPZzSgRx9yeUojTjUdJWXKH93LrKCqUzaRdOhh4JBXnkwpPFFa69zhX8Q+ryqdfFFzizPHjbO+Xsta9QxWfcMBBkwyGuT5g4lOl9EN5YNokQ8M9Zr2mtJF1UaluaFVXvXA9EaNLZFkLU3d6RrNoUlMjuk6oHwNv5zJtJwazTsonJjjsUk53zpZv4oNM6w1rlsOrynV3br9xwl9akGN6B90Zm/8UH+7kxIpuyTdl/8tEUjeBUgmqWKBy25jTANy8nSZPZ42mxmPhXbwR/XzhRePHMdYlBSFn7aauCPDrKtFgqvfaZo3pyfJrjYCMUZEtrHSuJICewXt6DdXRyHtCBKVXnuUmyuAvdmbpFeYBgf5iVLff1dEIeo+iIiPkvM2CpkLXsp/A30kXFTEH2VMXVhpLtKtJangveM6SWFPyggd5/gV7dvU15kb24M+aufrDA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(38100700002)(508600001)(83380400001)(4326008)(36756003)(8936002)(7416002)(66556008)(2616005)(956004)(53546011)(31696002)(66946007)(54906003)(86362001)(66476007)(8676002)(6486002)(186003)(31686004)(6666004)(316002)(16576012)(5660300002)(2906002)(6916009)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?b0cxVml0aWpGZngvYS9VWEc4emg2M0dVNXE0Ti9xcWNyRXUreDZ1Si96QWJ6?=
 =?utf-8?B?U09qSjk2aVhqWldlYW9mOW10MUV4SWRZWS9UK01oUERUTTBxanBpRllCOVRN?=
 =?utf-8?B?VjlNOWx0dk53U3Rud2srcit5azdVZTJ1UGR3cVp3U3RKbVc0YWIxelZPR2hn?=
 =?utf-8?B?aHdMbEhKaU9pYUtOc0JPVFdwTlVDTUd5VXRtVi8wNzJzTnMrS0FTV2hpcHFz?=
 =?utf-8?B?K3lUcDZGRElEUG1ocmp6NjI5SFpvVkU1Q1F1S3praisyTncrODBMSlJPQ2ti?=
 =?utf-8?B?VEJjRG92alFKMVZIN2JHN3Jtc3hIbkZCMVVlalFPM3dOaTU3NVhJQjRiVWpU?=
 =?utf-8?B?em54MXZ1OGJrK0dzcC8vOGpCUFUvLzNINDB3eUtEb2RaOTZzNmNpWURjNzFL?=
 =?utf-8?B?ZndvRU5qektEYlRSYUgzQzc2MXJNSkNPNmVtb1kzejJBZmg2UC8zaTl4KzQw?=
 =?utf-8?B?RUVQcU5CM3pzUkZCc1pGbWdMcEJVeWRSSVd1cCsvZXhnbHJqYjU3UWRzSUFD?=
 =?utf-8?B?UFpSYm11ODdRaG1sb0FnNjRraUpxdExZcjNWaTFja2RRN09DeDloTkd5dkhu?=
 =?utf-8?B?NWhPYzZUNTVscVQ3clV6UTNNdGFhcmhtYmVYYVN1NVNWMkRIbjErZnI0OEUy?=
 =?utf-8?B?Tm1TM1IyTW96aHk5cld1UFA2czZMT1BvNXNSMWZxRi9wSnpkYXNia1ZMT3Y0?=
 =?utf-8?B?YURyNmxrSDVURlNmbHZ4Z3U4ekNVVmd2OXdhNFZhbkY0ZVMxcUVjell2TnFO?=
 =?utf-8?B?eURpMEZsWTBhNm1jUzd4YVY4TEVaNHVoNnFtdE91TnpiTzdxUUdQTXJocnNN?=
 =?utf-8?B?TnJUOWcwQmlaQStNcU5RbDBBNUx1K0JrWmZ2eUl0NHZQODNuR04vZ1kyZXd0?=
 =?utf-8?B?NFZXLzg4aFdJTnFYdmltK3Y0L0xiSHJ1b3pZSVhsN1BvYVZzeTM1bS9tMGFX?=
 =?utf-8?B?T01kd2IrYjF2N2lGNFlrd01KeWR0U0FrTXh6K2g0VFNkbzFHOWFuVGVLT2Fm?=
 =?utf-8?B?TER4eFpnelE1L2VkWnFST0NNWHlGaHVBell4Q0xWTElFeE1IMTZOcGhXd3hi?=
 =?utf-8?B?dGd2QzU1Ky9LVUEwSE4zcFRscWl0alZzRHQ0Vk5UQXdzcE1nZHhiQlFKZVUr?=
 =?utf-8?B?bE13WjVKbmZvcmtuSFF4RFBGcDVjUHYveWROUHE3TlI4KzVHaVJhdXdjVngz?=
 =?utf-8?B?TENOTGtCRlRTTzhmdzgvQUVLSzQ2QjhGNXhwMStwUCs0WGx6YisrSjFZK2k5?=
 =?utf-8?B?RVRoYVJqS2xHUGVRcHMyZFR0dFd4T0sxNFo5TExpaDZRamZLc0dIUDU5N3Zi?=
 =?utf-8?B?dkpxTURhMUNOcjdVTXZjMkdvSnNmU0xDdHlaYk1OWlhWdHdNY3czZmpzNW1x?=
 =?utf-8?B?Sk9NS25DZ29xNjFZNWErTnkyUkRvUldONFZkMkVaQXpjckRiOVR6cHRYeTF0?=
 =?utf-8?B?V0duZFRDdXZzc1pJYmhmYWlXODliMHNuUGJ1T09qb1BOWHdHMXNEM1hScXgw?=
 =?utf-8?B?QS9wMncrYTNZREdzMEFrMm56NUx2VHJpNGdCVGVNSDVIU2tzaTlUcjQzbGpm?=
 =?utf-8?B?VFRxd3lzMlc0NDd6K2xJVWhxOUgyYklKN2dEN3EySFpLc2Y4V3pZT1B4QmtY?=
 =?utf-8?B?end0bXBtYk5tRURBM0VCVEVzQU9IY0ZiM1Mwdktabk5rTm5YdWNDakpFQVRm?=
 =?utf-8?B?OHBJc3hsbXUyVktQQmZJMXUrTHdHbitvay9OTklmbUxiWmowcDlRcnpWRW04?=
 =?utf-8?B?N3h3aTF4UnhWN2wwdzN2dDN0dUxTVlpQS1N4cGdMWU5OaDBFdVdYYTlBL09i?=
 =?utf-8?B?RTdrejRwMzJXbHVsZzNsdXRTMHF4WSs3N015NEVPQldjUXRrekdmRjlzTXZl?=
 =?utf-8?B?TG1XbWtMcVUycS9FdTl5aEE5M0doZUhRc3dCdnN4MHp6OXhXck10akR0RU5I?=
 =?utf-8?B?K0FiLzA3ZjRzM1FFTVBseURDNGZ5R1B6NlMzTFh3ODc2M0V2L3pUVHhBYitZ?=
 =?utf-8?B?UmgwUnFsOG5nelRMTWpOS2tBaW9jWUU5Y1R4MXltaHcwbXF5L1Y3Nk0zMTgw?=
 =?utf-8?B?ZHNzYVZnbnA2MkpvV2srNld2ZkRrb2M4WllTM284K0Faek1PN1NDVlN6VDVh?=
 =?utf-8?B?VjBqLzlmUlZNV1B2LzNCaTBLRlJVT3A0S0NEeHJPei9Ib1oyc2dUbFZsZ1lT?=
 =?utf-8?B?V1dERGlNeDFucmh3RnZXTE1HS0NwSjQxZ2tQZDYrZDdLT2NqWlNHY3hzVG1u?=
 =?utf-8?B?cnJIQ2VMbTRnN3Nwb3dCZzFDY0pnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e10d4316-d277-4a1d-efdf-08d9a0551fc4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 12:09:31.7958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HyVj6XfUFmlc6/jCD0NIFuKaC+07VUJrT/6vSBFn/UFpLde45Hgf4Ua2b0PANL8UWkAKoTHANWnW8MNQ1lCRdgLhMafFOYxp5XSaLDNcgPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4016
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050071
X-Proofpoint-GUID: EpC4SHTLaT5VAhRcyJxzMV99sUWJ1Dnw
X-Proofpoint-ORIG-GUID: EpC4SHTLaT5VAhRcyJxzMV99sUWJ1Dnw

On 11/5/21 00:31, Dan Williams wrote:
> On Fri, Aug 27, 2021 at 7:59 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> Right now, only static dax regions have a valid @pgmap pointer in its
>> struct dev_dax. Dynamic dax case however, do not.
>>
>> In preparation for device-dax compound devmap support, make sure that
>> dev_dax pgmap field is set after it has been allocated and initialized.
>>
>> dynamic dax device have the @pgmap is allocated at probe() and it's
>> managed by devm (contrast to static dax region which a pgmap is provided
>> and dax core kfrees it). So in addition to ensure a valid @pgmap, clear
>> the pgmap when the dynamic dax device is released to avoid the same
>> pgmap ranges to be re-requested across multiple region device reconfigs.
>>
>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  drivers/dax/bus.c    | 8 ++++++++
>>  drivers/dax/device.c | 2 ++
>>  2 files changed, 10 insertions(+)
>>
>> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
>> index 6cc4da4c713d..49dbff9ba609 100644
>> --- a/drivers/dax/bus.c
>> +++ b/drivers/dax/bus.c
>> @@ -363,6 +363,14 @@ void kill_dev_dax(struct dev_dax *dev_dax)
>>
>>         kill_dax(dax_dev);
>>         unmap_mapping_range(inode->i_mapping, 0, 0, 1);
>> +
>> +       /*
>> +        * Dynamic dax region have the pgmap allocated via dev_kzalloc()
>> +        * and thus freed by devm. Clear the pgmap to not have stale pgmap
>> +        * ranges on probe() from previous reconfigurations of region devices.
>> +        */
>> +       if (!is_static(dev_dax->region))
>> +               dev_dax->pgmap = NULL;
>>  }
>>  EXPORT_SYMBOL_GPL(kill_dev_dax);
>>
>> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
>> index 0b82159b3564..6e348b5f9d45 100644
>> --- a/drivers/dax/device.c
>> +++ b/drivers/dax/device.c
>> @@ -426,6 +426,8 @@ int dev_dax_probe(struct dev_dax *dev_dax)
>>         }
>>
>>         pgmap->type = MEMORY_DEVICE_GENERIC;
>> +       dev_dax->pgmap = pgmap;
> 
> So I think I'd rather see a bigger patch that replaces some of the
> implicit dev_dax->pgmap == NULL checks with explicit is_static()
> checks. Something like the following only compile and boot tested...
> Note the struct_size() change probably wants to be its own cleanup,
> and the EXPORT_SYMBOL_NS_GPL(..., DAX) probably wants to be its own
> patch converting over the entirety of drivers/dax/. Thoughts?
> 
It's a good idea. Certainly the implicit pgmap == NULL made it harder
than the necessary to find where the problem was. So turning those checks
into explicit checks that differentiate static vs dynamic dax will help

With respect to this series converting those pgmap == NULL is going to need
to made me export the symbol (provided dax core and dax device can be built
as modules). So I don't know how this can be a patch converting entirety of
dax. Perhaps you mean that I would just EXPORT_SYMBOL() and then a bigger
patch introduces the MODULE_NS_IMPORT() And EXPORT_SYMBOL_NS*() separately.

The struct_size, yeah, should be a separate patch much like commit 7d18dd75a8af
("device-dax/kmem: use struct_size()").

minor comment below on your snippet.

> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 6cc4da4c713d..67ab7e05b340 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -134,6 +134,12 @@ static bool is_static(struct dax_region *dax_region)
>         return (dax_region->res.flags & IORESOURCE_DAX_STATIC) != 0;
>  }
> 
> +bool static_dev_dax(struct dev_dax *dev_dax)
> +{
> +       return is_static(dev_dax->region);
> +}
> +EXPORT_SYMBOL_NS_GPL(static_dev_dax, DAX);
> +
>  static u64 dev_dax_size(struct dev_dax *dev_dax)
>  {
>         u64 size = 0;
> @@ -363,6 +369,8 @@ void kill_dev_dax(struct dev_dax *dev_dax)
> 
>         kill_dax(dax_dev);
>         unmap_mapping_range(inode->i_mapping, 0, 0, 1);
> +       if (static_dev_dax(dev_dax))
> +               dev_dax->pgmap = NULL;
>  }

Here you probably meant !static_dev_dax() per my patch.

>  EXPORT_SYMBOL_GPL(kill_dev_dax);
> 
> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
> index 1e946ad7780a..4acdfee7dd59 100644
> --- a/drivers/dax/bus.h
> +++ b/drivers/dax/bus.h
> @@ -48,6 +48,7 @@ int __dax_driver_register(struct dax_device_driver *dax_drv,
>         __dax_driver_register(driver, THIS_MODULE, KBUILD_MODNAME)
>  void dax_driver_unregister(struct dax_device_driver *dax_drv);
>  void kill_dev_dax(struct dev_dax *dev_dax);
> +bool static_dev_dax(struct dev_dax *dev_dax);
> 
>  #if IS_ENABLED(CONFIG_DEV_DAX_PMEM_COMPAT)
>  int dev_dax_probe(struct dev_dax *dev_dax);
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index dd8222a42808..87507aff2b10 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -398,31 +398,43 @@ int dev_dax_probe(struct dev_dax *dev_dax)
>         void *addr;
>         int rc, i;
> 
> -       pgmap = dev_dax->pgmap;
> -       if (dev_WARN_ONCE(dev, pgmap && dev_dax->nr_range > 1,
> -                       "static pgmap / multi-range device conflict\n"))
> +       if (static_dev_dax(dev_dax) && dev_dax->nr_range > 1) {
> +               dev_warn(dev, "static pgmap / multi-range device conflict\n");
>                 return -EINVAL;
> +       }
> 
> -       if (!pgmap) {
> -               pgmap = devm_kzalloc(dev, sizeof(*pgmap) + sizeof(struct range)
> -                               * (dev_dax->nr_range - 1), GFP_KERNEL);
> +       if (static_dev_dax(dev_dax)) {
> +               pgmap = dev_dax->pgmap;
> +       } else {
> +               if (dev_dax->pgmap) {
> +                       dev_warn(dev,
> +                                "dynamic-dax with pre-populated page map!?\n");
> +                       return -EINVAL;
> +               }
> +               pgmap = devm_kzalloc(
> +                       dev, struct_size(pgmap, ranges, dev_dax->nr_range - 1),
> +                       GFP_KERNEL);
>                 if (!pgmap)
>                         return -ENOMEM;
>                 pgmap->nr_range = dev_dax->nr_range;
> +               dev_dax->pgmap = pgmap;
> +               for (i = 0; i < dev_dax->nr_range; i++) {
> +                       struct range *range = &dev_dax->ranges[i].range;
> +
> +                       pgmap->ranges[i] = *range;
> +               }
>         }
> 
This code move is probably not needed unless your point is to have a more clear
separation on what's initialization versus the mem region request (that's
applicable to both dynamic and static).

>         for (i = 0; i < dev_dax->nr_range; i++) {
>                 struct range *range = &dev_dax->ranges[i].range;
> 
> -               if (!devm_request_mem_region(dev, range->start,
> -                                       range_len(range), dev_name(dev))) {
> -                       dev_warn(dev, "mapping%d: %#llx-%#llx could
> not reserve range\n",
> -                                       i, range->start, range->end);
> -                       return -EBUSY;
> -               }
> -               /* don't update the range for static pgmap */
> -               if (!dev_dax->pgmap)
> -                       pgmap->ranges[i] = *range;
> +               if (devm_request_mem_region(dev, range->start, range_len(range),
> +                                           dev_name(dev)))
> +                       continue;
> +               dev_warn(dev,
> +                        "mapping%d: %#llx-%#llx could not reserve range\n", i,
> +                        range->start, range->end);
> +               return -EBUSY;
>         }
> 
>         pgmap->type = MEMORY_DEVICE_GENERIC;
> @@ -473,3 +485,4 @@ MODULE_LICENSE("GPL v2");
>  module_init(dax_init);
>  module_exit(dax_exit);
>  MODULE_ALIAS_DAX_DEVICE(0);
> +MODULE_IMPORT_NS(DAX);

