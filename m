Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EAD2FAF
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 07:13:23 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17R6IqfN025614;
	Fri, 27 Aug 2021 07:13:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=b6AKiwb9yx8Pxd6i+oIijwlL+KA2t2ZkrXjcJMoJK98=;
 b=B9vH71rJ5NAJbgtaxi3vqSI8mvpFwob9fx6qddW72zYfRPnkZNj/giVZOE3dwhMWibbv
 6/5YDZB/44ETLPF5MBJ/6Wa+rFq0nphJzTJXlhDmOeQHM23NU+Fu2z2pUpu6O9Q3IaG8
 6J4xmCHrJlmQAbSEurEwjbmXb/4MKEBpP7WqmflXHXdd6W0eukLIJmPQBjFwGeThIvWC
 0oGAHUXUsFYI1gMjyjnnRt7KmCsHlpzvzQI2X+jtdaHkYFRlay4TtA6RsOQ6yVTEy0aJ
 jO75IVcc5kZigPkiuDXjDCqropa/DZr4O91Sa8tsSAQXIdqNianoLMdL0KWeuerYtN9y cA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=b6AKiwb9yx8Pxd6i+oIijwlL+KA2t2ZkrXjcJMoJK98=;
 b=0FOBEsm20yk1M7vwOjIb885kArk1T9zuEm9ih9o443EMyOrdmh1wtbh4f0qLtsDPwxp0
 eJs6/Spvr8NBlPQkMFD45AJRGA5a5sboVnZ2def4C03exkWR61qC9Xtzo0izxWb2GR5I
 OuBHO6jgPDvw78TPHTF7DsjqQM6+xQwylUDlj6+hb3Ao21NLi7q/5Y7xMxCWtr7qzK7U
 KXvuQSup4J4OFdUU/6+JmF4dJ9etWl/IUGcOu5+FmC0NZZoc5j4cihj7dnkQyme8telt
 azhs/xJavPUnvRWErXd53MRJbEPZiu8zxNkHzrhcmW6cVyC7hfmYdWGuFyxVe7VhP1GQ EQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap3eatykf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 07:13:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17R7BaQU082504;
	Fri, 27 Aug 2021 07:13:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
	by userp3020.oracle.com with ESMTP id 3akb91m069-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 07:13:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1FYCml+98ssQ2cS9YUzdxcOyqnlMkJPFfdS1QyUx/5TtxJQohRM94LLyPZaz8yK7bYpHh1fTe03ejVycayvEI38g17qFkK3K6TZnd+2MI5bccMlTctYY3Y9rGJy/+/I0DRKAMGjjeYqLWDImUypmg9BVVupNjEI4jVLPn1a9v1aY1VlYVvnPC+smljzoQUvuukbyVIGEgxKPwGLVlUIES49KcJtkqEMgMgiFO5bKjVl4XWnIfXgAbyaeHgyi4TKJ3AeRE4U2YHBy2FRpBFAGEEVMrOJDN2R3ut/CSwIRW4t2gKdT/4/NV4FBueXrKmD5LQNG4aMju+v9lzNMaFqWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b6AKiwb9yx8Pxd6i+oIijwlL+KA2t2ZkrXjcJMoJK98=;
 b=IK6j4srVE7L4XH73nZe8d+J+2y4WBbvvqZuTgfXrkovp3LS94MQwkRb1Vpg4+MEJjnPmyiqb/lpaoZTs2W9n3GYL73hFk+FAwPxNS7w8K0qVGaoAkYoKjT83hyLUUtP41ZoqvrQj+uSFgF7MlLWc/4CPug1PJjNJLu3OjY0WI7A55kzTfN0RQXXkFymoZoj7hVurcXKl4skmp8fPALMTXKWoylFk5PGljUqxuDK+b8h/9/ffSN6MZLxNS0WYBzH1S31+iT2NmS9IOk+3bfNRajsB5Qvgu/b0Gxi/CMvtx4a9EQRU+y1WPDl+/+Q64E8m3cLInQD+oIMk2mCBc/lXaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b6AKiwb9yx8Pxd6i+oIijwlL+KA2t2ZkrXjcJMoJK98=;
 b=DzPSpkO8UfMolWDBywnXX47VIl6Lt8EaaD0F1XlbKoXttGbLzLa4+KpEQNq29flgQ/D3EVQbGW092R2cnrmlyflq9565C7k2TQId1Kr/I3g5V6Qbpc23daklhXDsNRFhnBqN9vVxnbsiL/Q7yFFZfcckqZkQkKZhnSTjVG38YNs=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4418.namprd10.prod.outlook.com (2603:10b6:303:9c::17)
 by MWHPR10MB1934.namprd10.prod.outlook.com (2603:10b6:300:113::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20; Fri, 27 Aug
 2021 07:13:05 +0000
Received: from CO1PR10MB4418.namprd10.prod.outlook.com
 ([fe80::8095:f03a:e87a:eeda]) by CO1PR10MB4418.namprd10.prod.outlook.com
 ([fe80::8095:f03a:e87a:eeda%6]) with mapi id 15.20.4457.023; Fri, 27 Aug 2021
 07:13:05 +0000
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Dan Williams <dan.j.williams@intel.com>,
        Linux NVDIMM <nvdimm@lists.linux.dev>
Cc: Luis Chamberlain <mcgrof@suse.com>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>
References: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4jvamMXn_rWhqQZruSU6fqeNt+-LHmYb00=sZjOQOL42Q@mail.gmail.com>
From: Jane Chu <jane.chu@oracle.com>
Organization: Oracle Corporation
Message-ID: <c270aa05-f624-e145-d02b-259a664e9a2e@oracle.com>
Date: Fri, 27 Aug 2021 00:12:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <CAPcyv4jvamMXn_rWhqQZruSU6fqeNt+-LHmYb00=sZjOQOL42Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0227.namprd04.prod.outlook.com
 (2603:10b6:806:127::22) To CO1PR10MB4418.namprd10.prod.outlook.com
 (2603:10b6:303:9c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.39.228.40] (138.3.201.40) by SN7PR04CA0227.namprd04.prod.outlook.com (2603:10b6:806:127::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 07:13:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e55c53ae-6706-41d5-6a21-08d9692a1d0b
X-MS-TrafficTypeDiagnostic: MWHPR10MB1934:
X-Microsoft-Antispam-PRVS: 
	<MWHPR10MB1934886FCA56C02A7C942FF6F3C89@MWHPR10MB1934.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	mBtqpsv/egmxE6ClInWflq9jrzFUEcrOCtd7taGmXK/ahrM9mNKLZaCpv1tux/+3fOYsdDqu9a3ce+wia/5Y1KYQlmGNixwX4YN8VATIiguEZiPQ+r+5C8cfZF0r1iODAOwIkKrGCVXPVAJSLwNiSKgM+nlpe4+M+qkrXThZi8A8v0nnVQh5Sw87E8JrQkOecFonnEILWd1Ifc9+72+35YqnpsOrBQvBTI3zISKJpK5LAuuACT4rlHT1K+ehIEKGXzp4ctU4WN+9AvmVM4zZJOp3abMXnxrDTpj9PWC6QL+3okr1obi0YrH/QRhbz92SR/PlVY4iSy5sIWOp01GTImDydVjUpBZr8yw6Kpybh+1icFnxx/gw5VTjnIjMJd6x0cV9boODWn/LqNlf8gPPN9IHdnlQdmz+l+X8nVTpfROlJcXAuF6LY2tK4Tzy/gMJ0sAgwlDXY/C+IHAYZrRH7ch1dBgXISrVJQNcmN3cIj3QIekPF9fhNbJZgiHJmLNv9vYdknFBW+1MScMyJWGVbWVUH0GYGDnPm0DdDkrbkfjvNwb8LA2Kbxww5ipqtDPczHfW8Rv9mRMDnlWZmYtC53u3N5fqj2BUgrRXhps3r65lRXQZ0Lu576UIR3WTUUA7GY3j0JRQSiBYceZRHy6zWXWxNVAZ3SpGPCty8FAN/21Lc2nM6n1Pph8lft1o+2NlPMa+hZatNSEq7kbgic6LcX2Js/zk+a0luql5ZuTpahsFAv/e/DR7Kpd+1pXpdV5pNp6vBKPpeClHZxXDHPJIz1+nnuTAX0zMASyHM+b2fFAopd8LYGBsGRreWzazFIh4
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4418.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(26005)(31686004)(186003)(316002)(110136005)(53546011)(38100700002)(4326008)(8676002)(2616005)(5660300002)(956004)(508600001)(83380400001)(54906003)(36756003)(6486002)(6666004)(2906002)(66946007)(66476007)(36916002)(66556008)(44832011)(31696002)(16576012)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?d3Fpbmp1SWhTMjJpV0xuZHBWSEhmUUpIcEV0bG5XbDB1QjdReUxGMWhtQmJP?=
 =?utf-8?B?RFpNR1RhTzRQbDFOMENWN0I1M3Q1NTB5UStQTkZ3NmhaZSt6VUVGdWxpV1Bo?=
 =?utf-8?B?R25IWUdxaWVTZVB1UWthRFplTjBIZ3dNSCtTU1BXczhNRW5xOCtxclJ1WVI3?=
 =?utf-8?B?T0hFQ3F6R3JxYmtxNXFHMzdYWFY0WDhoMlowbTVva3VoWmF3NDRpTzBvbVlx?=
 =?utf-8?B?cysyYnFKWXExcU1Qbk1pK0xGVUs1NnNBcVA3NU5CNml0Tk01OEpTUWJsZGZn?=
 =?utf-8?B?cUlRYzdRdHREQW5xcGloRXR3VVMzaEJaWlRxUUV6NTB0ZG0yQkdjYzUzTGEr?=
 =?utf-8?B?ekFPSTgzUGFUR24ra1lxTmV4QVJPSGxtRjMyR2VaZmx5T0svLzN6R2N4OHJp?=
 =?utf-8?B?TVlNTHNVeU4vc29ZM2I4S0NSeDFTajFFSmRSOEMrT0hyMXZhSU5KU09PT0Nr?=
 =?utf-8?B?dWtnVVlyK2pJSVgyOC9Ldk91LzZpNTd5bGdNYXpsVFRzeDhVODN5Uno1OWwy?=
 =?utf-8?B?TVU2NVVJRXVuVXZERnp0ME9zK2ljczJHNTgwdHlHcmRla0dyZXlPL21rODNu?=
 =?utf-8?B?dHZEamhrNFNaMVZqdjNtbGU3b0VjTU9FK2lyT2xoUWsvYi9wcDUyZXNubXBK?=
 =?utf-8?B?Z1R0WHNJdkZqSXQzb3pmcGhLUTFBUFpWTGZUNmNEUzBQSzBUK0p5ZkgzYWRX?=
 =?utf-8?B?R1lLZ2lvSmxYcmJ3Z2cxekQ2clE0SlBEL1MyTENPaUloVFFqc0l1S2dsdVJh?=
 =?utf-8?B?dHB4bEY0YzAxWU1OVHRkd0EyNTRhVFhMdnFrTkNrTWRQbWVEdmpTckpZend1?=
 =?utf-8?B?RVFYRHVuaU04cFpuVzkxYWdyZDJxVlJvRzVOc0lGWlloL2RZeUI3YVZUazZ5?=
 =?utf-8?B?Tkc3OVNtTm9uMWlCbmJYQzdBc1pDOXhpU2s3ZktRZlRrUHR4UU9rSitmaGxL?=
 =?utf-8?B?cnBPUUhSbTQxdjBxajM0SWlMTTdCckRDZHZxTEw1dThLVENXazJGTllBQThC?=
 =?utf-8?B?ZnFYakt6RFpNajNPWVFZbjFRWjVHcFFjaCtpbEJ3a0VQN1FTTDZidlV1WXQw?=
 =?utf-8?B?WlFPT1hUemRrZUZNVVYvSUJmRTF2V1p3UVByM1czQTcvWEw0eHY1cFhSS3Jl?=
 =?utf-8?B?UkNaTTd4V0ZORDc0bGd1OC82SVVuSVN6eFh3Um4xQlVOM2pSckNJS1VNSDFk?=
 =?utf-8?B?ZDErcVZtY1BURFBvbEtMZkIyZUxmRVlkanpHMDJYQkI4MGFNdmhINTBzNCtC?=
 =?utf-8?B?UCtzRjVCdEo3d0UzZSt0bG5mUktJUzJOWmhIQUowaUVMRGE2NERyNWRKQlZK?=
 =?utf-8?B?N3R6bFgwTXlmV1lpYnVrZWxGWk9UenJMb2IrRzlmNlp1UC9GR0JJSTNZd0ZI?=
 =?utf-8?B?K1grUUJoSFFuaktqMmhXM1pLVW90bUJtMHpMUjNYSGpuN1hGNUw4Q05TSTdh?=
 =?utf-8?B?d2ZVM1VzN1ZnYTFuNjhZVkZ4eml3M1p1S0JONUdlcVRMQUk5WlFoQVNSaG5m?=
 =?utf-8?B?cm9IM2ZyUnpoeW8vOElCcTJNMVB0SStqL2tleFdxdEplY0dSc3U0MzNOQ2My?=
 =?utf-8?B?a0dpZ2p5REJWeHJDTEJiOCtSTS91MFlrOHBIWWFaVnR3MGJVU0g2MnU3WlE0?=
 =?utf-8?B?cXRLUDdOSlBudmttQkRWNTFjcmhhUUxGUGY3NW5DL3hHNWxlUUhlNmx2Y2Fh?=
 =?utf-8?B?bFdoSmFMbVZjZ0VoVFNhc0FoYThtNUwveUV1QmhDVDRIaUJiWWpSU2lmNTFZ?=
 =?utf-8?Q?3nw22jHHBOCMHQhxig2LT1ks/6XidJ2cEp4Yjjo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e55c53ae-6706-41d5-6a21-08d9692a1d0b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4418.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 07:13:04.9701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JR014ReL5R9DGCzFhkZzp22lNJZBz5F6oAVLfIlSq0Yi+0pUz4K15Eb44W0O64UJg7WWz/nj1RRGIy8sRDh4Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1934
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10088 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270047
X-Proofpoint-ORIG-GUID: _zxSfBqm0D1YrT8ygHbwBBiKf8sI8JGp
X-Proofpoint-GUID: _zxSfBqm0D1YrT8ygHbwBBiKf8sI8JGp

Hi, Dan,

On 8/26/2021 12:08 PM, Dan Williams wrote:
> On Tue, Jul 6, 2021 at 6:01 PM Dan Williams<dan.j.williams@intel.com>  wrote:
>> When poison is discovered and triggers memory_failure() the physical
>> page is unmapped from all process address space. However, it is not
>> unmapped from kernel address space. Unlike a typical memory page that
>> can be retired from use in the page allocator and marked 'not present',
>> pmem needs to remain accessible given it can not be physically remapped
>> or retired. set_memory_uc() tries to maintain consistent nominal memtype
>> mappings for a given pfn, but memory_failure() is an exceptional
>> condition.
>>
>> For the same reason that set_memory_np() bypasses memtype checks
>> because they do not apply in the memory failure case, memtype validation
>> is not applicable for marking the pmem pfn uncacheable. Use
>> _set_memory_uc().
>>
>> Reported-by: Jane Chu<jane.chu@oracle.com>
>> Fixes: 284ce4011ba6 ("x86/memory_failure: Introduce {set,clear}_mce_nospec()")
>> Cc: Luis Chamberlain<mcgrof@suse.com>
>> Cc: Borislav Petkov<bp@alien8.de>
>> Cc: Tony Luck<tony.luck@intel.com>
>> Signed-off-by: Dan Williams<dan.j.williams@intel.com>
>> ---
>> Jane, can you give this a try and see if it cleans up the error you are
>> seeing?
>>
>> Thanks for the help.
> Jane, does this resolve the failure you reported [1]?
> 
> [1]:https://lore.kernel.org/r/327f9156-9b28-d20e-2850-21c125ece8c7@oracle.com
> 

Sorry for taking so long.  With the patch applied, the dmesg is displaying
[ 2111.282759] Memory failure: 0x1850600: recovery action for dax page: 
Recovered
[ 2112.415412] x86/PAT: fsdax_poison_v1:3214 freeing invalid memtype 
[mem 0x1850600000-0x1850600fff]

instead of the problematic

[10683.426147] x86/PAT: fsdax_poison_v1:5018 conflicting memory types 
1850600000-1850601000  uncached-minus<->write-back

Please feel free to add Tested-by: Jane Chu<jane.chu@oracle.com>

Thanks for the fix!

-jane





