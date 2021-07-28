Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6571570
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 20:09:03 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SJmDCG005787;
	Wed, 28 Jul 2021 20:08:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=5RyBnhG3bd2AU+9fyCK43fJmYf4sbaV7mNeW+/B2An4=;
 b=blVg/y9H/tZccF0G5nDTFa954Lo44SzVibnYkHEN4oArKEQ4ZlgMSNbsdE9eRzddR3T3
 PtE57sPsSQ6kTaiCp8PGjS04R71LmLHTOiN4advRlB6w5VHxKuHxLw0WGl98mskdwjY2
 fI+VtJ4McRGKF8bfdyuYlTXeS1wxuqGTsW42iPW1EhNkhpuWgQ8Bus0UDs00LHE0RlZV
 XgI13l+9SubP/K5D6wQhvrz8ab9fSd+KRRy84DZyI1FgmDqYqF/SeLymL5GYrhvh143o
 qJwwXbsasAtJchMJmgPAi3ux8psuEpsd+V4XtoK5CND4fjfEUT4AJ3lCmFqPpBBfmu0q Pw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=5RyBnhG3bd2AU+9fyCK43fJmYf4sbaV7mNeW+/B2An4=;
 b=N2ZdcHQqBQzY4oia8d+mTXAo4v0pYJngcfgJgCTqbKAq2WRU0czBdFSZjjn3yzeynehG
 QBRRiO/7QAo4Aye7h02w60OpMn2S60VtJp+qZo2Hp8mYvhO00r8MCYTgVFYkqSylkoqP
 Bt3462YAI9LFPl/Xr/MfFkafoKp4IwndwofWgfqVpVBR/aQmcsI5rug5r0C0ZX2J76gp
 IljdIUDdibEmDiQe5RNXtIf/D/5V6LdzWw/kinDCyjZFzt1R/dqUBcbgxdtyaeoJQyMi
 zneW5u1YLbkI74dnpaXHzgp0+nRwpiJbTPSDJD2Xz1gXaomfmgfJve6pAjWtMlVK/HED hA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a2356ndw8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 20:08:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16SJkvT3196237;
	Wed, 28 Jul 2021 20:08:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by userp3030.oracle.com with ESMTP id 3a2355xc7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 20:08:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JANet7plvc62qXAHYRj6n1DpuDMeaTCnnDwRcIivOMTOzEtpQn48C+ok89yFTJUfhlSeV+8gV5VvuPcPrX6v1SM3U3eM/aD2fDi2rCl7FQDVRZmV7L7KOZ5XtaeSz0PFFNwsJi9zHvp/Q+vtGGF9iQ+RYrb9WHNwZNukK95EDEo/NTJjjw21VXgQKHFNq0RxRfOmMj3gpyy1ggsMkcA3qF/HLq5++mkePEypaVjoUaxTNzTflgbwB81Z5sqWbEGZ3hOWScJYKcBQgCw2z6NfA3pzQAmxsGrbLNZGXjYvMeCu+GO00zuTQ/gmZqD7qD/gY9Adm0EX8Bf/h2D607BWqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5RyBnhG3bd2AU+9fyCK43fJmYf4sbaV7mNeW+/B2An4=;
 b=nlvZ2iptUcA+JXL3f02sdnTxoNE9kMvsMfWGS5gPObYgo1A0i32vu7pFheS4m84hb1GfdFvoNUSIRRT+jPFb1yPi+Wm4vZDetcOpMMW2062LbE4AqBApd4fNqWSeYWcsTActdhGlmKut0T6OxmVw/a5cc7AL2pUwLkGY2y8kpKH+5+f729E0N7A7KrYGrqjY9IYj6uDKslhYd7fSKOeqYYziVwxWFoZu+NeQsqsD7U3tOcHQ7sJCBWVM0zo3m5k0wecaEv4Ye+LUWCb9pct8D1n0SA4Mae/Pquw4UbkhtqjkcCZDhvP8GxU73xhakwZ3LF2I6JNiEh2vMndqK9vvhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5RyBnhG3bd2AU+9fyCK43fJmYf4sbaV7mNeW+/B2An4=;
 b=A0jroNZDeDKhrRdLx7e1tGc9DHmtZztUiPXbxwjYoxr8kJ8Vwh6AbIUBKO+Syu3s1GuT/vN1CrAGSZgudWEmravjfgtFA3WLq7xxfYYRYwjC9zXO4zw5A+lVSalvAIgkXZPaB86A7rzlXsyZ/7Bd8qgbeUI304AXvvU8dDRn5vw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5379.namprd10.prod.outlook.com (2603:10b6:208:325::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 20:08:47 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4373.020; Wed, 28 Jul 2021
 20:08:47 +0000
Subject: Re: [PATCH v3 14/14] mm/sparse-vmemmap: improve memory savings for
 compound pud geometry
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
 <20210714193542.21857-15-joao.m.martins@oracle.com>
 <CAPcyv4jC9He7tnTnbiracHZ9P9XSWsH4pJMKFip6-nSbsBWyrg@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <eac81d19-1bbc-6441-b9b4-12a8de041053@oracle.com>
Date: Wed, 28 Jul 2021 21:08:40 +0100
In-Reply-To: <CAPcyv4jC9He7tnTnbiracHZ9P9XSWsH4pJMKFip6-nSbsBWyrg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0004.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::9) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO3P123CA0004.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:ba::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 20:08:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bb9579a-d21c-4ee6-99b7-08d952038250
X-MS-TrafficTypeDiagnostic: BLAPR10MB5379:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB537940BCF7D9C6E107AA85DCBBEA9@BLAPR10MB5379.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	t6naUzN7DV2Ww0VTbuRQwhPN51QAzWQO4E0jUriRRXfyteSOhwke1QMnqFgm8F4eWN4uvspAxNSVqGUE4AYEzASqM6USjHMYK1VM+1g8+ZNIjaeRTPtYaxDEP8HfuvUtswByWlb+ovXSTISIBYMor70gnuF5/jVs7wVyGCnCupUaqFzTCJC6ge8rEadrChfkBU1HoGECdeobPz2a3CVq9lpWI/qepWcvUYbbfgETjGoVywdEdUD/yud7zmlwhYRkSyQrBrhxUdhUYUcfB1mj1W+H6a8HpMxdrJm3Rc3e97YHeBvxv0qryz2fFPqxSI4A4D4jq65+OmsuE6Dhkt7EdZPJijjz6NpRhO77Ti2hbo/GPISqyhWEvsS7L8Zr0no9x7e2o1eO0fSS5DtBQSQ5L2AOkTHetQ8xpAiouDCbgpor4H1kM4/LiwK7zgtSTGTOeyhq2eoBV0lC3/oBATI7jO/2vTw9j868a53OCVAupeGoAPba0CUjJ+bK4rRRQ54We/4z4Q/wwFsO2WvrN36muJhTtujiL0lcAl05hEIqArO18lQ2P0Bd6EbpgwLGIzGuJlyNXFAlPU8mn9KFlEGT9ETEIZaEfGrnNQaaxk7yD31h58s+r8xjHeCDTzrn7SCll3cWWZR9O40AQwYxeIXwYQZHsRA63j03opwn/9jMN7bOpiOmzrOgVZSENOa6u7GGOI9/9WXm+beNweZdnCdqVcSWkKZ/QiWP9n0bSUqOrXQ=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(366004)(39860400002)(346002)(31696002)(478600001)(6486002)(31686004)(86362001)(956004)(66556008)(2616005)(38100700002)(8936002)(66476007)(6916009)(36756003)(6666004)(8676002)(30864003)(16576012)(54906003)(316002)(5660300002)(186003)(53546011)(66946007)(26005)(4326008)(83380400001)(2906002)(7416002)(25903002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZDBoTnVhMW5sRzdoNGJEMU81UExlSjc3QXlZRWI5ZUs3V29XakI3NVMwNkNV?=
 =?utf-8?B?cTlETjZyWlVRV3lYTnZNYWNCY0RkczRtOFlTTWszTzhpR3dUT2hIU3VyUll3?=
 =?utf-8?B?Zzc2YWNKOURMK0hFZlp6akVHSFRodEVoS3lVRExTTnd4UVVFNWNjMWxoSEh4?=
 =?utf-8?B?N2FvQUZKVHhmUlJyRXFJT1d0R21rd21LMWowVW40RUFzQjJPdEF2QW1TYVJE?=
 =?utf-8?B?Y3NkMXo2SkdzbG9nL2VSWFMvRWU3eWFlaEJ5dlh3Um52cTlUeEYxdVFFbE5a?=
 =?utf-8?B?YWJ0blVIRW9kUUtMY2s1QmQ1TGIxanBCeDQ1bkcrSnVOMDVtY0tMMDJlN0dy?=
 =?utf-8?B?S2dHY2VHY2RiVHdwVjdWQUJFazJUM0NGUFc0cUpHMUZ3R3Qxc0d2N0xtUEl2?=
 =?utf-8?B?UG0zMHEyTVVuVTNRcWFPV3EwNGw1NzBBZWJiZmpjd3VzZklFY2dYMVVBbzJa?=
 =?utf-8?B?Z2lFUzhKU2l0NXBIRnF2aEIvdVZLdXh0Q2Rsb3d0UzJJY1Qvd0RFeTBMSytY?=
 =?utf-8?B?aVMxQjkwRkpVOHk2UFBZWmtYVGxFNnoxTUcxbDZkNGRFMThObnRrV1NPcXdZ?=
 =?utf-8?B?V0E5bSs4ZmR0OXNuMndMaXZNVUtPVW8rMzJyck1WUE9DNVVqckpQWUVqL3Bl?=
 =?utf-8?B?REdZekcrclJ0d21FTDdOaDJ2L3V5R1VKRGR5S2ZTMnMvY3RCb1cwWUFoanlF?=
 =?utf-8?B?SDRGc3BKOEJtSGZvTDU2YnBhSTRkaTBka0g3YjdKcFgxRkJaelE2bWIxTUZq?=
 =?utf-8?B?R3h5VDhDMGh3a0xBVnB0dW42bW03K3dvdGZDQXo3cVJDUFhPRTJxNGR6QnlY?=
 =?utf-8?B?ajYzaUtpY0RTYUpNVitlalpSWXVsZGE5VTY3dGM5a0NOTVFLT2JLYmc5MXhU?=
 =?utf-8?B?YTY4dldTSnNhM3luZHExMFhsbU5reWxyYzE0MTNSQzBhd1hqL0ZLYzIwTTgv?=
 =?utf-8?B?QlVrclRNRWpGSWt5ZXJaQmdzcDhkYmEvZXdQbzI3UnR4dVUzeHhLUmYrRWZl?=
 =?utf-8?B?VEpKSHJ0K1Rsa2dOajVDeEJZOGlzMmNyVzgzN2JpNS84Tzl5TGkzQi9tQ09H?=
 =?utf-8?B?eUtlamVnNFY0WDFheVVvQ1VRdVhjVXduR1J6MnJwVHlMZFNJOUY2VVgyaE9S?=
 =?utf-8?B?Q09kOUEwTW1EdDJMU2lYaFRsV1IzdGladUZHdmhYRXRzKzdXL3hSZVNtK0Rr?=
 =?utf-8?B?VVRhaXB0bmNSY1BBNWtKZTNaY3FjVWkzd04xaVBlSnQ1SVJEQm1uWkJTaVZh?=
 =?utf-8?B?aUs3SXhFdG1DWDMxMHJVNnpvd2VjU01DaGJGRTduY3BROWZURnRFejAxaUlT?=
 =?utf-8?B?S3RzNndmZVNoalhXYzQ4NDl5ekUvUnl4WklMYW5aUlpVTXFzT1dXSHFwTkRm?=
 =?utf-8?B?c2lVQnlDVTljY0lkcFJLeHE1bHZxcUxtOWtzV1ZkaHR0ZHZtVFlESW9ObVdB?=
 =?utf-8?B?ME9wRlJ6WjdrOXE3aDNBckczdVdsdHdaeHhXa3cxQnJCWFJzMDN2WlZtazkr?=
 =?utf-8?B?R0FhK08zNk44MktQVWlXKzB6TXdSUG5uNS9rMzBUZEFVTlE4ZHdQMGtEOWV1?=
 =?utf-8?B?RXJOeUhTOTE1N3ZCcGM2czE5K1BaaU83bDhvSFFLd1IrbURYYUxOZjRUSWN2?=
 =?utf-8?B?MlJiY2F3TlEyMDlMMzlaTVdIT3Aya3FOZnNvVDRKbVU4S3ZieFNGZDJSZlZ4?=
 =?utf-8?B?MlJwd2R1cTRpb0N3YTUvRnFhV2JDOVpHK0d1Wjk2VUxLV3gzcjhCMkVsbHh0?=
 =?utf-8?Q?aP7cqITAyKguKmQg8gevm3WhybLKwZP/O1O/ySe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bb9579a-d21c-4ee6-99b7-08d952038250
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 20:08:47.6277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JG3BkcMZ1p7gnTUKB1gRhl3dMS+Dt4ZenrQNEinKqtynzA5bCt5JiooW6ytEFCHpKNDMR0/MrJEY9tTpAMu50DnkMX8i6g8bAUt9WWmCGi0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5379
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280113
X-Proofpoint-ORIG-GUID: SK80ivChBDGVxYKD0ngZl7C_WNidGIve
X-Proofpoint-GUID: SK80ivChBDGVxYKD0ngZl7C_WNidGIve



On 7/28/21 9:03 PM, Dan Williams wrote:
> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> Currently, for compound PUD mappings, the implementation consumes 40MB
>> per TB but it can be optimized to 16MB per TB with the approach
>> detailed below.
>>
>> Right now basepages are used to populate the PUD tail pages, and it
>> picks the address of the previous page of the subsection that precedes
>> the memmap being initialized.  This is done when a given memmap
>> address isn't aligned to the pgmap @geometry (which is safe to do because
>> @ranges are guaranteed to be aligned to @geometry).
>>
>> For pagemaps with an align which spans various sections, this means
>> that PMD pages are unnecessarily allocated for reusing the same tail
>> pages.  Effectively, on x86 a PUD can span 8 sections (depending on
>> config), and a page is being  allocated a page for the PMD to reuse
>> the tail vmemmap across the rest of the PTEs. In short effecitvely the
>> PMD cover the tail vmemmap areas all contain the same PFN. So instead
>> of doing this way, populate a new PMD on the second section of the
>> compound page (tail vmemmap PMD), and then the following sections
>> utilize the preceding PMD previously populated which only contain
>> tail pages).
>>
>> After this scheme for an 1GB pagemap aligned area, the first PMD
>> (section) would contain head page and 32767 tail pages, where the
>> second PMD contains the full 32768 tail pages.  The latter page gets
>> its PMD reused across future section mapping of the same pagemap.
>>
>> Besides fewer pagetable entries allocated, keeping parity with
>> hugepages in the directmap (as done by vmemmap_populate_hugepages()),
>> this further increases savings per compound page. Rather than
>> requiring 8 PMD page allocations only need 2 (plus two base pages
>> allocated for head and tail areas for the first PMD). 2M pages still
>> require using base pages, though.
> 
> This looks good to me now, modulo the tail_page helper discussed
> previously. Thanks for the diagram, makes it clearer what's happening.
> 
> I don't see any red flags that would prevent a reviewed-by when you
> send the next spin.
> 
Cool, thanks!

>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  Documentation/vm/vmemmap_dedup.rst | 109 +++++++++++++++++++++++++++++
>>  include/linux/mm.h                 |   3 +-
>>  mm/sparse-vmemmap.c                |  74 +++++++++++++++++---
>>  3 files changed, 174 insertions(+), 12 deletions(-)
>>
>> diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
>> index 42830a667c2a..96d9f5f0a497 100644
>> --- a/Documentation/vm/vmemmap_dedup.rst
>> +++ b/Documentation/vm/vmemmap_dedup.rst
>> @@ -189,3 +189,112 @@ at a later stage when we populate the sections.
>>  It only use 3 page structs for storing all information as opposed
>>  to 4 on HugeTLB pages. This does not affect memory savings between both.
>>
>> +Additionally, it further extends the tail page deduplication with 1GB
>> +device-dax compound pages.
>> +
>> +E.g.: A 1G device-dax page on x86_64 consists in 4096 page frames, split
>> +across 8 PMD page frames, with the first PMD having 2 PTE page frames.
>> +In total this represents a total of 40960 bytes per 1GB page.
>> +
>> +Here is how things look after the previously described tail page deduplication
>> +technique.
>> +
>> +   device-dax      page frames   struct pages(4096 pages)     page frame(2 pages)
>> + +-----------+ -> +----------+ --> +-----------+   mapping to   +-------------+
>> + |           |    |    0     |     |     0     | -------------> |      0      |
>> + |           |    +----------+     +-----------+                +-------------+
>> + |           |                     |     1     | -------------> |      1      |
>> + |           |                     +-----------+                +-------------+
>> + |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^ ^
>> + |           |                     +-----------+                   | | | | | |
>> + |           |                     |     3     | ------------------+ | | | | |
>> + |           |                     +-----------+                     | | | | |
>> + |           |                     |     4     | --------------------+ | | | |
>> + |   PMD 0   |                     +-----------+                       | | | |
>> + |           |                     |     5     | ----------------------+ | | |
>> + |           |                     +-----------+                         | | |
>> + |           |                     |     ..    | ------------------------+ | |
>> + |           |                     +-----------+                           | |
>> + |           |                     |     511   | --------------------------+ |
>> + |           |                     +-----------+                             |
>> + |           |                                                               |
>> + |           |                                                               |
>> + |           |                                                               |
>> + +-----------+     page frames                                               |
>> + +-----------+ -> +----------+ --> +-----------+    mapping to               |
>> + |           |    |  1 .. 7  |     |    512    | ----------------------------+
>> + |           |    +----------+     +-----------+                             |
>> + |           |                     |    ..     | ----------------------------+
>> + |           |                     +-----------+                             |
>> + |           |                     |    ..     | ----------------------------+
>> + |           |                     +-----------+                             |
>> + |           |                     |    ..     | ----------------------------+
>> + |           |                     +-----------+                             |
>> + |           |                     |    ..     | ----------------------------+
>> + |    PMD    |                     +-----------+                             |
>> + |  1 .. 7   |                     |    ..     | ----------------------------+
>> + |           |                     +-----------+                             |
>> + |           |                     |    ..     | ----------------------------+
>> + |           |                     +-----------+                             |
>> + |           |                     |    4095   | ----------------------------+
>> + +-----------+                     +-----------+
>> +
>> +Page frames of PMD 1 through 7 are allocated and mapped to the same PTE page frame
>> +that contains stores tail pages. As we can see in the diagram, PMDs 1 through 7
>> +all look like the same. Therefore we can map PMD 2 through 7 to PMD 1 page frame.
>> +This allows to free 6 vmemmap pages per 1GB page, decreasing the overhead per
>> +1GB page from 40960 bytes to 16384 bytes.
>> +
>> +Here is how things look after PMD tail page deduplication.
>> +
>> +   device-dax      page frames   struct pages(4096 pages)     page frame(2 pages)
>> + +-----------+ -> +----------+ --> +-----------+   mapping to   +-------------+
>> + |           |    |    0     |     |     0     | -------------> |      0      |
>> + |           |    +----------+     +-----------+                +-------------+
>> + |           |                     |     1     | -------------> |      1      |
>> + |           |                     +-----------+                +-------------+
>> + |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^ ^
>> + |           |                     +-----------+                   | | | | | |
>> + |           |                     |     3     | ------------------+ | | | | |
>> + |           |                     +-----------+                     | | | | |
>> + |           |                     |     4     | --------------------+ | | | |
>> + |   PMD 0   |                     +-----------+                       | | | |
>> + |           |                     |     5     | ----------------------+ | | |
>> + |           |                     +-----------+                         | | |
>> + |           |                     |     ..    | ------------------------+ | |
>> + |           |                     +-----------+                           | |
>> + |           |                     |     511   | --------------------------+ |
>> + |           |                     +-----------+                             |
>> + |           |                                                               |
>> + |           |                                                               |
>> + |           |                                                               |
>> + +-----------+     page frames                                               |
>> + +-----------+ -> +----------+ --> +-----------+    mapping to               |
>> + |           |    |    1     |     |    512    | ----------------------------+
>> + |           |    +----------+     +-----------+                             |
>> + |           |     ^ ^ ^ ^ ^ ^     |    ..     | ----------------------------+
>> + |           |     | | | | | |     +-----------+                             |
>> + |           |     | | | | | |     |    ..     | ----------------------------+
>> + |           |     | | | | | |     +-----------+                             |
>> + |           |     | | | | | |     |    ..     | ----------------------------+
>> + |           |     | | | | | |     +-----------+                             |
>> + |           |     | | | | | |     |    ..     | ----------------------------+
>> + |   PMD 1   |     | | | | | |     +-----------+                             |
>> + |           |     | | | | | |     |    ..     | ----------------------------+
>> + |           |     | | | | | |     +-----------+                             |
>> + |           |     | | | | | |     |    ..     | ----------------------------+
>> + |           |     | | | | | |     +-----------+                             |
>> + |           |     | | | | | |     |    4095   | ----------------------------+
>> + +-----------+     | | | | | |     +-----------+
>> + |   PMD 2   | ----+ | | | | |
>> + +-----------+       | | | | |
>> + |   PMD 3   | ------+ | | | |
>> + +-----------+         | | | |
>> + |   PMD 4   | --------+ | | |
>> + +-----------+           | | |
>> + |   PMD 5   | ----------+ | |
>> + +-----------+             | |
>> + |   PMD 6   | ------------+ |
>> + +-----------+               |
>> + |   PMD 7   | --------------+
>> + +-----------+
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 5e3e153ddd3d..e9dc3e2de7be 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3088,7 +3088,8 @@ struct page * __populate_section_memmap(unsigned long pfn,
>>  pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
>>  p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
>>  pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
>> -pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
>> +pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node,
>> +                           struct page *block);
>>  pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
>>                             struct vmem_altmap *altmap, struct page *block);
>>  void *vmemmap_alloc_block(unsigned long size, int node);
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index a8de6c472999..68041ca9a797 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -537,13 +537,22 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
>>         return p;
>>  }
>>
>> -pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
>> +pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node,
>> +                                      struct page *block)
>>  {
>>         pmd_t *pmd = pmd_offset(pud, addr);
>>         if (pmd_none(*pmd)) {
>> -               void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
>> -               if (!p)
>> -                       return NULL;
>> +               void *p;
>> +
>> +               if (!block) {
>> +                       p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
>> +                       if (!p)
>> +                               return NULL;
>> +               } else {
>> +                       /* See comment in vmemmap_pte_populate(). */
>> +                       get_page(block);
>> +                       p = page_to_virt(block);
>> +               }
>>                 pmd_populate_kernel(&init_mm, pmd, p);
>>         }
>>         return pmd;
>> @@ -585,15 +594,14 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
>>         return pgd;
>>  }
>>
>> -static int __meminit vmemmap_populate_address(unsigned long addr, int node,
>> -                                             struct vmem_altmap *altmap,
>> -                                             struct page *reuse, struct page **page)
>> +static int __meminit vmemmap_populate_pmd_address(unsigned long addr, int node,
>> +                                                 struct vmem_altmap *altmap,
>> +                                                 struct page *reuse, pmd_t **ptr)
>>  {
>>         pgd_t *pgd;
>>         p4d_t *p4d;
>>         pud_t *pud;
>>         pmd_t *pmd;
>> -       pte_t *pte;
>>
>>         pgd = vmemmap_pgd_populate(addr, node);
>>         if (!pgd)
>> @@ -604,9 +612,24 @@ static int __meminit vmemmap_populate_address(unsigned long addr, int node,
>>         pud = vmemmap_pud_populate(p4d, addr, node);
>>         if (!pud)
>>                 return -ENOMEM;
>> -       pmd = vmemmap_pmd_populate(pud, addr, node);
>> +       pmd = vmemmap_pmd_populate(pud, addr, node, reuse);
>>         if (!pmd)
>>                 return -ENOMEM;
>> +       if (ptr)
>> +               *ptr = pmd;
>> +       return 0;
>> +}
>> +
>> +static int __meminit vmemmap_populate_address(unsigned long addr, int node,
>> +                                             struct vmem_altmap *altmap,
>> +                                             struct page *reuse, struct page **page)
>> +{
>> +       pmd_t *pmd;
>> +       pte_t *pte;
>> +
>> +       if (vmemmap_populate_pmd_address(addr, node, altmap, NULL, &pmd))
>> +               return -ENOMEM;
>> +
>>         pte = vmemmap_pte_populate(pmd, addr, node, altmap, reuse);
>>         if (!pte)
>>                 return -ENOMEM;
>> @@ -650,6 +673,20 @@ static inline int __meminit vmemmap_populate_page(unsigned long addr, int node,
>>         return vmemmap_populate_address(addr, node, NULL, NULL, page);
>>  }
>>
>> +static int __meminit vmemmap_populate_pmd_range(unsigned long start,
>> +                                               unsigned long end,
>> +                                               int node, struct page *page)
>> +{
>> +       unsigned long addr = start;
>> +
>> +       for (; addr < end; addr += PMD_SIZE) {
>> +               if (vmemmap_populate_pmd_address(addr, node, NULL, page, NULL))
>> +                       return -ENOMEM;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>>  static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>>                                                      unsigned long start,
>>                                                      unsigned long end, int node,
>> @@ -670,6 +707,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>>         offset = PFN_PHYS(start_pfn) - pgmap->ranges[pgmap->nr_range].start;
>>         if (!IS_ALIGNED(offset, pgmap_geometry(pgmap)) &&
>>             pgmap_geometry(pgmap) > SUBSECTION_SIZE) {
>> +               pmd_t *pmdp;
>>                 pte_t *ptep;
>>
>>                 addr = start - PAGE_SIZE;
>> @@ -681,11 +719,25 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>>                  * the previous struct pages are mapped when trying to lookup
>>                  * the last tail page.
>>                  */
>> -               ptep = pte_offset_kernel(pmd_off_k(addr), addr);
>> -               if (!ptep)
>> +               pmdp = pmd_off_k(addr);
>> +               if (!pmdp)
>> +                       return -ENOMEM;
>> +
>> +               /*
>> +                * Reuse the tail pages vmemmap pmd page
>> +                * See layout diagram in Documentation/vm/vmemmap_dedup.rst
>> +                */
>> +               if (offset % pgmap_geometry(pgmap) > PFN_PHYS(PAGES_PER_SECTION))
>> +                       return vmemmap_populate_pmd_range(start, end, node,
>> +                                                         pmd_page(*pmdp));
>> +
>> +               /* See comment above when pmd_off_k() is called. */
>> +               ptep = pte_offset_kernel(pmdp, addr);
>> +               if (pte_none(*ptep))
>>                         return -ENOMEM;
>>
>>                 /*
>> +                * Populate the tail pages vmemmap pmd page.
>>                  * Reuse the page that was populated in the prior iteration
>>                  * with just tail struct pages.
>>                  */
>> --
>> 2.17.1
>>
