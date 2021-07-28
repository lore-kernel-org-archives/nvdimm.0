Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1735870
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 20:04:58 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SJmmb6010983;
	Wed, 28 Jul 2021 20:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=UnoC39PATVVrMq4hyZ27zMxotu68NGjvRKl8iat0s2o=;
 b=yf+SWt4AU7WdBrrK0ifJO5dq/+gxii9t6YC/WhuLBI5EDCCZBtBPDe7guUwGd28YNj6I
 77ANyXkqbAjbyL2dgTV1Vb/AsNRamoX7kVjfSmAsjTmkejdMjIqpvd6WcrVbBdr5+/jM
 pkz1JQf6f0jATYIt9K2N1VY96+nl2pcDk6hV5QAOQFWw2m8dKBv4x6klf/0VYB38CVcz
 M7eDCB2KV0Qd3rOpPgnyDkUd75kuz43tjDuu4mjIyv6r9e2qM9+rDctdXaPuilm6JHN5
 POgvvIS2e9+U/38n1S5s76cSU8+wbpy5ZjbCmDeJD0a7sG3KOjuNvktrHN4qhyE6gvLB 7w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=UnoC39PATVVrMq4hyZ27zMxotu68NGjvRKl8iat0s2o=;
 b=xwilD/7hO83CCq4VMNcNba2isZu4zwZ4RZRpnEHDLOzbwiH9+CeQd6pKSxD56U5nQEIc
 cLCgtA34ZzWm/81ZiyliDGsB+P/L1LzvFSJopepVy+S8GxDo8CKVCZBd93tRETg7teio
 7Xw/7n2ZtE2sISvVEI0YQzh8V82UGMK3sb8aeP+iCN2YI8ZI+zU2MMtHnwDHHoJkxIzc
 o0HnuID6ZSRkSpb5ukba78Fw+0lv8Ch42CfSuWdatdo52kf+4SMoyAJWvDI7MYtE6Jyx
 sVnow3uTdX/Tj2ZB29auJYc447goK8Fh/4icaLMZ3pKKBCNfS5BXPP7besQ3Aizg5W99 KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a2353dfhm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 20:04:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16SJkolk013049;
	Wed, 28 Jul 2021 20:04:43 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
	by userp3020.oracle.com with ESMTP id 3a234ydukq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 20:04:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lv7B2MlkQvNY6RZPnNr9nlp3xLXxDWW4xb9L0Lk73r6rfaY78d//yVVjd2D41govteYExJxlRS9CkOMEApkpf6oB4bcJBbszupH6V83JQrVInDcl6lYcwbVT1/b2SpS5D2ETSJtSemDjxMmi1MDt6YfwILfkt+abCplcPO1pHyuy6tiztfNS5jKJdygoLbxtvq3gqjp8RDB5v52xXAncFF6atC0cUZjwsbJfLsCM/bjGnEGanVn8H6hmddGARbwGDVEAprkKzi+AZWU8ftnrAnX8bw95ltxi3vnvOdCpYDllmF2LusoaE/YxUHKaU9iba83Acjv27Frn2w8g6k/LDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UnoC39PATVVrMq4hyZ27zMxotu68NGjvRKl8iat0s2o=;
 b=QcU37wI/mXJh6sJNuCjtvfy4Y8w9mqJL5kVLfEQqiuLrmRoJ8nBmRHgoycMBVCapgUQjGGGBJBASVaI7rkQsQaMwE1sHC55UsU7F2UCtRwUwCAX1T8WmqsepygIR29e6sk6g8A2SpeiEuIoQX4XPxyYh6dpZaAW8h9ZsQ60I7Nf9u71mPxxfvlkju8tJIZQdwUL50roObRivxoB9LQ/UrIQ2GMAFuS240LA2XJGk8AQvaFz/WAHkeMHV+XaQobOoCiyR8LaPJ1/BjufQfeFBMV5RU0S8CSScznvDyVIZM+1SQuTiKf7SB4Jv1U8yQDy0OYbngi1Yoc7EfdLSbIR4hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UnoC39PATVVrMq4hyZ27zMxotu68NGjvRKl8iat0s2o=;
 b=dQO0NuglU2Z9THQfMfG0BjWjXDk5GWlDr/4NsyWBPe9STDgLfamIU5P7Hm6yuB5NZKFf2592SSKOM/1zxBE5hJa9Hi/VEvstgSJp3uqwDm/sZBJ+TWjRiSqqNCq2KI00r3KbQ3OSCtpMJHRLc6cyOpb9RRdR0MqXUXybLXHt9OE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4285.namprd10.prod.outlook.com (2603:10b6:208:198::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 20:04:41 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4373.020; Wed, 28 Jul 2021
 20:04:41 +0000
Subject: Re: [PATCH v3 08/14] mm/sparse-vmemmap: populate compound pagemaps
From: Joao Martins <joao.m.martins@oracle.com>
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
 <20210714193542.21857-9-joao.m.martins@oracle.com>
 <CAPcyv4jPWSeP3jOKiEy0ko4Yy5SgAFmuD64ABgv=cRxHaQM7ew@mail.gmail.com>
 <131e77ec-6de4-8401-e7b0-7ff12abac04c@oracle.com>
 <CAPcyv4jR9atodmLqk4O+RdbM9DJDvoQvAZqH03UAgAKB71Fcdg@mail.gmail.com>
 <d7f1e0b9-bf57-b30e-84d5-cd0e5cdadaaf@oracle.com>
Message-ID: <408ee1c4-4b38-46a0-1536-79e8021d671d@oracle.com>
Date: Wed, 28 Jul 2021 21:04:34 +0100
In-Reply-To: <d7f1e0b9-bf57-b30e-84d5-cd0e5cdadaaf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0042.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::11) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO4P123CA0042.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:152::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 20:04:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 017e934b-addb-4abe-fe6e-08d95202ef8d
X-MS-TrafficTypeDiagnostic: MN2PR10MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4285A839AB0D0D0A3BAFF6A0BBEA9@MN2PR10MB4285.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	QblWNdxqhwQqZqPUZM1dPsfpzNDn74OJWLy4P0crtkOXRLT38sQEEj2hJ21myQ1JAnYY+FLtbFTLO/MS+llY0v0gN9Oj0BD/ulzrTkk3rmPbgi8egbKVyrtKemWEXg0G1Bd8eXvpKJJUd/bTrr6JeLASi6bfZDY3ICFd97FgmiMdNj8Ts1Fej6+yMhKB7k3mT9udpOfQvoIpSTOpKoQaF7fQ4zkmtI77q2k2wn43CV06CpKxXgA/PxGlEkpFJQHWRGX2CP990MLsYomP7uaWz5ef09XuvxQeRbzgfvi/c8ZW+bssoYf89SM+lzo7Zbagy3CcinqDiRdrrPiX/tMiR924qILvsQwBq0sHT5VaN1Aea6EvYe0JNHAqu2wP4n/4A4Qx2Jq08blOgIuHcW67wLTlfVkZYX9Jt/6lOjDz8ywAScSeAQNfCdImM/u7yBw8ALflAkLENUI5Zlm3z5+/w5SBJk2KOh+gWRA6fW33AKfGfbAMgqsjXMVk37n20IdXlg96W5BchsCC2ckFFRfCh/w0JPz8A0DsCeLIowjBk38kzwYtLEelk8qyRLKgdEa54phYximWOZq+HoByoBpn3WhyrX28kCfOjU+CDXHvcEt+POAJ0sS2xiUja7LkrAXwjG2pU6Paa2FvU7TknRGPCTO45SmX4l0mAKPyobf1F4k6/h9DNiqoQ/DA/Z9d199KLfKAelbJ3/1iKWC5x0MSdg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(396003)(376002)(346002)(478600001)(26005)(2616005)(66946007)(38100700002)(66556008)(66476007)(186003)(956004)(53546011)(7416002)(31686004)(6916009)(8936002)(31696002)(8676002)(54906003)(83380400001)(4326008)(6666004)(86362001)(5660300002)(16576012)(316002)(2906002)(6486002)(36756003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VWNnenhrWmthVWZRR1h6UGJjRW9qck1NaVRXRGRiQVdDcUE5RWRqQlBOTlZ4?=
 =?utf-8?B?Sy9EMkhoVlk0dmc4T1RmeU5kdFpQZHlRRlBoWW9jZ2JEWm9yK2d4dHVVWkNE?=
 =?utf-8?B?MjlienZKejJnaEo0dldRRzN5U1NqS0JOR0Z1QWtUL2FHd1RwMUp0S0hkdmlK?=
 =?utf-8?B?R1VzZTJWVFEwNUJOUVZISkRuUzh6YU4yRGRPVUxvd283UE9JYlJYZzE0V2c4?=
 =?utf-8?B?RWluNTZYcWoxa2Z4cGhPb3Q0WWFDdGlHMnRtZEhjaGlsK2lWcUtRN2ZBWEhP?=
 =?utf-8?B?ZElPWGdoL3V4dVllSi9TL1pQQ1ljcjZ4aXE5OURndmNzRkc0M1R0S3ZyVng4?=
 =?utf-8?B?Wk4xMlJuUTVMT1luMDN4cHBKMFUya1JNVGJPV0djeTZMV0FKcFlCcnJuRTFD?=
 =?utf-8?B?VituSEdYRzRKZUhvcXJSK2g2U0VvcW85cmV6WXVybm5QNXZsVE9JRlBld1hQ?=
 =?utf-8?B?VG9LTEJuQ01oTGNoOWliV090WVZnR3A4bVVEVDY3cVI4NUZCME5qMEdCdi9p?=
 =?utf-8?B?SmR4NXJuSDh0WWFzc3pHRTE3R08vZ1NGTWplcjVhTDhGYlBFMmZrdXFkS2Yr?=
 =?utf-8?B?RjM4NHdENDg3TXVFMHdaaEtXMFdTeTZuSHc2MjR0aGxDeHJJN05vM29XMndD?=
 =?utf-8?B?YXZwMWtDdHNUeGZVT214QkZYeVdMY0huY3BrbWpZQTVCZlFlTlVxb2dyRUww?=
 =?utf-8?B?OGtkTzNSM0RZNFpTSWpSVFc5dzZicGJQcW9iblc3ektCd2ltRUVyWTg1YXMw?=
 =?utf-8?B?OEkxZm9rTDdXN0c1UHRKTW93UVJLMEJncHFzZlFBKzczRnE3Um5WMjVBajdK?=
 =?utf-8?B?MlNpYzljZk9XdCswY0hDZVNFSkNqb2RNUWpZZjNFQlZncWhIZzFSQ0NtcFBO?=
 =?utf-8?B?eHhuWDlUN2VXNkFwQXY3MjVZYjVZUHl3RkdrYW15clAvWUhVV3JGQmszWXpH?=
 =?utf-8?B?N2FEQ05JeUJmMkJ4N3A5OXhvWnh5WjFzMm1zMDRyKzJMOW5sWDZleGFFdlZC?=
 =?utf-8?B?SU0xTVByUW5iWUkvN3g1Q1JSOGE2NWNBR3NXeldQRUtZWHZJbVpla2NTRUN2?=
 =?utf-8?B?Z2tIRmxZZDljbHh5aThxeXkrbmpyT3NidGpGWGE3clg4d21kZG5JNEJNQjRF?=
 =?utf-8?B?VVVDcG42V09QdU1CWkppcHhtdVEvWExXeVkvVUZvanhWSExRajBqaGtRS2hM?=
 =?utf-8?B?bUhoUDNXZzNsRC9JOVdGQ1JHVGxqUWJXN3JuVEFKcHZxU0JlNkpXMS8rUFcr?=
 =?utf-8?B?ZVRNSHlFOTdwd1FrTlp6VkhrVWN3SlZNMUJXZEllTzQrTnJGM1hPdFVwaVAz?=
 =?utf-8?B?bmZXYTFYVWlnUlN1ZEcyN0tOTmFsOHNING5LZVcvQzl1TDM4MkdxVSt0SjUz?=
 =?utf-8?B?bFZDTTNlYUtTcXdWdVNBRUEyVEVBZU9OS1IyQytsUnErbjk1aXNmTEExRUQ5?=
 =?utf-8?B?RHk2M0hvTWYva0xGcmxLUzYvQnhZOTFOcStwMmI0RDdrWkFNaE8yUFdxbWh1?=
 =?utf-8?B?SWhMVlppaVlGVnFZK1k1U09hajVJK2pRc2J3TWxnT0hpK2xCa3MzV0trRGNI?=
 =?utf-8?B?bnFWTHZRTXVKc3BxNGgwb3ZFeXhZQ1V0UVYrTE1reHJTQVkxR0poWGNTUWtl?=
 =?utf-8?B?aXp1MTJJWFNBNFBuUEx6SnNpUVduYjYrZ0VvTEVZNlM2UEdKWE5kU2NvSnNj?=
 =?utf-8?B?a1EyVTRYR2xyek1IMy94a2NCdHV2UjI3bkZrZlk0TlFSL1ZuUnBKNXBSckxp?=
 =?utf-8?Q?Vdk8cJGBqZAj9c1sG6ef7O/SWLl8QoX2lA1CxEk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 017e934b-addb-4abe-fe6e-08d95202ef8d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 20:04:41.4149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wNDs2jwUPJl/j0+/cyjeCAgHfAS6Cp73z3CWYl6n3GsYQ3SZQyFh2dy6ldCwVPpveghes37ZQHXG2K1E9Y7Xm1nEXiUn1XPufPb5li7ioEw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4285
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280113
X-Proofpoint-GUID: W4KVn_cgZA0312sKjp6L4KXk_2oqEvF1
X-Proofpoint-ORIG-GUID: W4KVn_cgZA0312sKjp6L4KXk_2oqEvF1



On 7/28/21 7:54 PM, Joao Martins wrote:
> 
> 
> On 7/28/21 7:03 PM, Dan Williams wrote:
>> On Wed, Jul 28, 2021 at 8:36 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>> [..]
>>> +/*
>>> + * For compound pages bigger than section size (e.g. x86 1G compound
>>> + * pages with 2M subsection size) fill the rest of sections as tail
>>> + * pages.
>>> + *
>>> + * Note that memremap_pages() resets @nr_range value and will increment
>>> + * it after each range successful onlining. Thus the value or @nr_range
>>> + * at section memmap populate corresponds to the in-progress range
>>> + * being onlined here.
>>> + */
>>> +static bool compound_section_index(unsigned long start_pfn,
>>
>> Oh, I was thinking this would return the actual Nth index number for
>> the section within the compound page. 
>> A bool is ok too, but then the
>> function name would be something like:
>>
>> reuse_compound_section()
>>
>> ...right?
>>
> Yes.
> 
Additionally, I am shifting calculations to be PFN based to avoid needless conversions of
@geometry to bytes. So from this:

+static bool __meminit compound_section_index(unsigned long start_pfn,
+                                            struct dev_pagemap *pgmap)
+{
+       unsigned long geometry_size = pgmap_geometry(pgmap) << PAGE_SHIFT;
+       unsigned long offset = PFN_PHYS(start_pfn) -
+               pgmap->ranges[pgmap->nr_range].start;
+
+       return !IS_ALIGNED(offset, geometry_size) &&
+               geometry_size > SUBSECTION_SIZE;
+}

To this:

+static bool __meminit reuse_compound_section(unsigned long start_pfn,
+                                            struct dev_pagemap *pgmap)
+{
+       unsigned long geometry = pgmap_geometry(pgmap);
+       unsigned long offset = start_pfn -
+               PHYS_PFN(pgmap->ranges[pgmap->nr_range].start);
+
+       return !IS_ALIGNED(offset, geometry) && geometry > PAGES_PER_SUBSECTION;
+}

