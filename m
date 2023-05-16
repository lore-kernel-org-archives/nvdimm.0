Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FF9101D5
	for <nvdimm@lists.linux.dev>; Tue, 16 May 2023 17:58:29 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GG4cna009625;
	Tue, 16 May 2023 17:58:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=rHFUh1dAPE8+42amFu4S7KWEh5LOmfkV3TsT19Iv9dM=;
 b=hFnGcmB5UkxfpJz5ry6KAxyUWt+sSm0hwK2lFdAQs2pgCJXhKRw/P584g6Xi916H9E+6
 vQmMPFP/kj/cLfMX+UmTBHn+cSd0BPtMsLOAb8V2fSP7ynvHRjEgW1frd3Mim8J2foJ5
 bxANqgeGwEKsnwwJV9CLf1IrNu6GoRIamfGadbQ+o0r1W7OVFW1BixLmAktdL7UL9PIc
 4Q0jMsKVC146JmYUcZ6steiGR5JHwko/PKqHvHk9krzRnmL4r+vZBDWYeXksrRGk9m/S
 0qBPw/3PE4ZKCbDV5vPsYME1+NkBJydiEhGq3i3BPQWjGa1LhqfPoLAVjWMJYKKOEoAj 6w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj1523s7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 May 2023 17:58:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34GGq72d040010;
	Tue, 16 May 2023 17:58:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj1045me4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 May 2023 17:58:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUhIUEWo2EvyL/pYiH/07ZBYi3LJqgg91dYDElMbBHqLgwz3O+NxsyLCS9lYyusrcuT7TqQ12ftOMtBCGlY8iqonH/SRMm8Dn2vwLAM3qfhUx3O0wynOhbA6OeIFcjIE/DfQeTvE51MpEYdoX8wvQbna2i3h0K1P1QGKvXmHppbCmVTaFBaPh4wYC6OVkDUYvhMoSv3AFp/aKAfgXEguObSUoHaw0u8e93EOYb9TqrIce4NdU+CBwEP23JGdPhfl0eXCRGctNMFN5XRSSPHZCRxjo1Q5jx2G4yLJWpPnDxZB9Yq3c2LPaFlKB6KxxfZ8HYaxINgLghRcWnNBu2UlpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rHFUh1dAPE8+42amFu4S7KWEh5LOmfkV3TsT19Iv9dM=;
 b=T4iZ1FlE7tZRDeGldERsFDr7gwISx4tojzVne1x2c6MVMhoZRftmLxXR4wtlztr+GgAjaVYqSk/CZ5/l0JHr1RCLEn/oGrFf1a8H8JWPUaX68tw496uHfcIsfbp8wpoXJBxBIFC9XLg40bMw9bZzOZUzqYnvWMP7jqAeQ6E3/Q5KT/cPHhfdBKvq/iKHURQXskocmf1vtAqs0ZTcVaibC08mM8FfAX7ap23u23bTy8qSDI1u1HtMgEK6jd6Ib1LSpfbGs4/J44KJNWe8omuCB6I9fUF0CBwRlADxwfRN2DsDPudRSMANLs48gWXRNiHzchaPvZqPFq+sJ0WOB93+1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHFUh1dAPE8+42amFu4S7KWEh5LOmfkV3TsT19Iv9dM=;
 b=EpZm0QqyeibsK7t5036D9FysWI8USBuh/PQRipAefgVbVEdNY1G4N1YiZhEK8CecJB9Qb5ocL/oelwe8yggv7u1P0yIlf6z4VxKX9Kkb26zck12AyzYJHsbfl3eQJXgRdgn32RCYF5AADb1DHGYMvrEXSOPtdmLvSTmFDpWaMV0=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by MW5PR10MB5667.namprd10.prod.outlook.com (2603:10b6:303:19c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 17:58:12 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::256d:125b:8053:eeb9]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::256d:125b:8053:eeb9%3]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 17:58:12 +0000
Message-ID: <f84335f7-6171-d87d-4bf2-ab3fd01942be@oracle.com>
Date: Tue, 16 May 2023 10:58:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 1/1] pmem: allow user to set QUEUE_FLAG_NOWAIT
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev
References: <20230512104302.8527-1-kch@nvidia.com>
 <20230512104302.8527-2-kch@nvidia.com>
 <7d36645c-892d-33b1-18d9-73be5369a791@oracle.com>
 <6462c60f66188_163ae2948e@dwillia2-xfh.jf.intel.com.notmuch>
From: Jane Chu <jane.chu@oracle.com>
In-Reply-To: <6462c60f66188_163ae2948e@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0034.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::47) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4429:EE_|MW5PR10MB5667:EE_
X-MS-Office365-Filtering-Correlation-Id: 755bedda-f579-402b-1079-08db56371db3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	NNvOyQj3MEbHAfX5UB/kr9jt2hQ3IxiTBG14+rqbkiyb3Sp5qwSYkxQjtQBuac8lbJRgFzsYn9yxeqkT35EMunFQ+H1ndFBsl1nEhCyDuXb1nv2Qa3WdqtEUWdlZgncv7HukM/Milx05+UPu+oXAMzF/c3PcxAENBtAfadv/jJhVHzbx5VVugwXJV5nIZnfwycljwivv/5sQH1BNSpgfDYGTFpafM34yfEt1nNkI0WHfTBh8TYWMTDg3DkKPUbT6irN6hEmVXJMkVNB/BZLahjViWR9848fGGISYrs5w1h8/jGU5K3vkd7cT0zL05Lj9dI/VppXCEqkOe1JU6R4cM7MwKkxdosxJrcjTloMSv/jeEgLuOBtoTxNle1ffLss6n/Dsyf8eI11RdmI8WCLDhU7i11esBCRpfCk6IC8jKbI/8y8e06QSq0Xb6bzhVeu0ro0/xqgSJP7kQGJC1OSLC4rv+KRih9JhJJCa/AvC573TxBflctukZO6G1SWRNO+JZwp66lJCf4/sniXoA0BdI6c3TojuW/eBEUz8qqtxduKzvveWFXzQLGqscZBhN+5OenECxeUerIevLz3QaLu1i/VSsBKJCxmhav7KAMefX3EQhO5WIlQOqDPnr94kjaGyx1DrTh7l9kTo29JxmM0Acg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(376002)(366004)(39860400002)(451199021)(86362001)(31696002)(36756003)(6486002)(110136005)(316002)(66556008)(66476007)(4326008)(66946007)(478600001)(5660300002)(44832011)(8676002)(41300700001)(8936002)(2906002)(4744005)(38100700002)(2616005)(6506007)(6512007)(26005)(53546011)(186003)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WTc5S2Nzbjg1VVNOOStVV21VdW0yWjV4ZTl1WXU5QXZEZ2FhcW5GUnl3WHd2?=
 =?utf-8?B?aFZ1U2V0eEp2azdZc0xMODJscUNqWVZPdDB1bGdmNDNISnZoeTJuR1kzejNH?=
 =?utf-8?B?Rnc1UnR0U24xVEZPazdLeHcwbGZ5ZXNHY3NDS3U2Z09JcnduUGNHdmRDRkl0?=
 =?utf-8?B?MlJ1UHhITDZJNlk5ZElNcmg4c2lMd3FZRGc2V0o3eVJjZEJzaXF5MmdvMnhn?=
 =?utf-8?B?NCtzdlorMGlLeVJaZXcwVm4xelBSdVp2MFlROWhBVXQ2VkdJTitIcFdOQVpB?=
 =?utf-8?B?Q0lneW9kUkJ1YTZxWVh5aEt3cXFIdmVwL25acUVUamU1c25vWUpLOFJyQlZE?=
 =?utf-8?B?dnIycmQ2NWk2R3dubktCb0VQbEFKRTRBSnFLRHdGajBES3AramRmalBlbmJK?=
 =?utf-8?B?SVNqYTZwei9vTjU4dk9sblhvOHp5M3A4a1VaelgzTmFDZW1HeThVZElaSStq?=
 =?utf-8?B?aExURGFsVjVtVjlHemlyZE12VVdtU09xdStiRy91WXpDYXgyQmZENkRBUFFR?=
 =?utf-8?B?QVREazc4T1pIcjNnN3R3OTU4Qmd2QnpaeUR3bXlkQVBnK3VXcUFPc3ZyaEtC?=
 =?utf-8?B?RVBRaUt2ck9lUm9JeTV1SWJWZnlMcm9WSUx0bzAveWdockt5Q1BrcDBYVTJC?=
 =?utf-8?B?czFxUzdlR28zTTVKVU5ubU10SlFjU1lqbzRLZGgzelRWcWlLRVE1cGJWdlpj?=
 =?utf-8?B?anJSa0UyOWxERld6L0EwQXJlakZVSkdWVktucHVRZW1oQ1NxTWRuVnJFRkFw?=
 =?utf-8?B?VVBJZFdaUjU5WHFtZDVYWG5JKzdhY3NWNEZZeURGTURpTUNaYk5QY0E5Wi9M?=
 =?utf-8?B?UlBHZkNrcjdwRHFaTmN5OEhBdXNYVW8vNGNacmJJYUczYlY4Wk9zZDJSSnFh?=
 =?utf-8?B?Wkh2eFNSYU5jM3NpZHQ4Zk9qMHlGV1RtTkJRdWM1a2R1SG9yMldZaEE0NDhC?=
 =?utf-8?B?WlZwZmowRU8yTWJ0K09uRUc4QmI2ckFDK2htSE11QjNuTU4va0E3UmFQUmk2?=
 =?utf-8?B?Mkw1MmJCeUhrS0d3U1JDOFlVcWxwenRrcWIwcm9SZVNycENQc3hxV1VWVXhI?=
 =?utf-8?B?RFI5NFQ4QURRYUdKR3NLMCtrNUJvM1hEUU91a2NOQlplaHh1QWtGVDlyQnBY?=
 =?utf-8?B?NWhpSUF1aW5RYW0wUUo3ck1OR09LQzc5TU5tUjN0Z3E5QzZIQ0lhbTcyVkdQ?=
 =?utf-8?B?b3loVDgxTmIvb2I1QVBkNzlFWWtjRk0rRXpFUGVObTViTEhseVlVMlVTS2dz?=
 =?utf-8?B?SkQzMVFUUyswUDNsMFhmTVNsRlZUR0tqcTduRTMyM0Zubi9vZ0YzYm5xNDhG?=
 =?utf-8?B?eVlxL0VlaHpiOElNMW1nTWhtTElZRGdsRXFyWVhtdG5LOFJnbElXcDFwaWFx?=
 =?utf-8?B?RHVqbVI4cnZuVTRWandIOWdwclVWL0lxdDN3YUg1WmRrQlo0WStWQ1lQOEtw?=
 =?utf-8?B?dzhvSkkzc0tFaWF2Qmp6VnB0eTRwY0RsTUFldFJiV20yU1A1QUxHWXFyTEVG?=
 =?utf-8?B?UjdENkR6VUlaRWtVaEVSTW02YlFuZ3M1bk92N2QyNEZ2YnA5ZFg4bEh5N0JT?=
 =?utf-8?B?dzBYbU1KK1E3bzUveWFiNTJ5ZjBGNTlTV1RwbDR5MngrUW5uYnBmUkt5a1U5?=
 =?utf-8?B?UHR5ODJnbEE3bDl2L1IyVHplVG0yejBDa2o4VVZhL0dOVUlJS2hPK3ZsTW92?=
 =?utf-8?B?bVVWQnVoUnJEaHdlYVFtVzZLTmtYWERJdDhQRlJsNnQ1Qlg5YnhOQ1NCMUJE?=
 =?utf-8?B?ZlJ2c0IxcXo2OCtJSGdUWjB0eDRnK2ZxRmExM1E5cDJCNTNTSHVGeUppQ1VF?=
 =?utf-8?B?TmVMT2JocE4wazhkQnZaNmFqUjBkUDFOdnNaY1Rpb3lQQ2dWZjNKeEdYOGNR?=
 =?utf-8?B?YnhRamVSLzEwWjdPQ0hsY08zYTlyTnJGUHJzQ3VhUkdmc1l5blpmcTNOVklk?=
 =?utf-8?B?aWJjRmNTaUk2bUsvVG5ySWZSSWl4MXhnd3k0VjRqR0RnTzNOVWZCckRuMXVk?=
 =?utf-8?B?ekYvWmZMU1lqRE5aSzZvMUNFQ3V2dHJaV2EzOXZTamQ1bTV2cGlldUx6QlFI?=
 =?utf-8?B?b29NR09CZW40K0gwaGt0MUlqS1NHd2czK1RQRnZ1M3lWR2FMQW04ZGRPb01s?=
 =?utf-8?Q?IYFmJcwXWagY3O/vvGZyRRoep?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	IR8p6N+trDn3AFz1efq1akHCxX+J4qUOd96OYJZJfMDOFndIYa63aftaap6069A7SbxzssjBcK6dE52Q8uFvoFWBOBtD9XpxHOtyfjfnJDPkIbtrmAemo0ROIg3eQA8RaUthqwY/8i14o7+mUb7diuQHSN3r+iXjyTPzB6oDHqADPvjAd+I+g9CbPjceJAn0wRZpK7HOJb7jFbNeFzd+SmmZiuk4/jcXODCzfD7y1eFqrQ+6VH3zGa3EI7kk2XKgCxCGo2j/mGrV9GmtHSCe8C9rYKPJ65N4tJsMN7YjGyReVTgmRe/3dNuaka6K+5M8sZCYgb2Q9uhi9helCOVlKQUpd56LsJQN4G43dKl6wQMluwOKHKXdTbEpJFDFAMkXagX7qw0o8hUKVvN2IpjeP+NI1Ph5LDgdpBkSNXv8TLuWx4CkrNtzbMOdnhI9S4NulyZrGiDhhJLVePzkLJrW7EhM81ps2Mt3xig8zZ+NOU9hzOyRkIIsQBOaDPVMmSztC95tjQZ6y96fyHn3lo0NsLhrtXVhAJ7Gfo2H4XCdMl8ZmgI2+m+TZuquzveC1Mu31/z3Zeyxi3eEWZGz3zcm7tGxAWr0LTbBBa4i2R3F1GTXZMMGW44eppqoWZPod2egnPjOLhMpYO/soB+UJk7nPoBtsEREyZLD6OTeL4zfYxgAcbEIMuarMg6mtggR3/bTlYXvm4gFtkCVmTSwBGUvQ+ehKGOFNiR+NdWe1HJRQ9A6PlcHdI2IVOKU53gGnrtXEbk5RCG8jj6/msjbo5plb5ecmhVSw/fGsi0h15VEW//15yZfszVCOvkheAzu1XWb
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 755bedda-f579-402b-1079-08db56371db3
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 17:58:12.6079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hC+NVVijIQWrNHohHq4HG2VG+jllUn9s+rSPaL+kPLiI9w2fPkmB4NKthsOpYgUP6SxOibolhU03f5nueTHtKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5667
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_10,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305160150
X-Proofpoint-GUID: Vq4Hxgqtwgr0-wm6JBs3snB98S5s52py
X-Proofpoint-ORIG-GUID: Vq4Hxgqtwgr0-wm6JBs3snB98S5s52py

On 5/15/2023 4:53 PM, Dan Williams wrote:
> Jane Chu wrote:
>> Hi,
>>
>> Does it make sense to mark this patch a candidate for stable branch?
> 
> These numbers:
> 
>> * linux-block (for-next) # grep slat  pmem*fio | column -t
>> nowait-off-1.fio:  slat  (nsec):  min=431,   max=50423k,  avg=9424.06
>> nowait-off-2.fio:  slat  (nsec):  min=420,   max=35992k,  avg=9193.94
>> nowait-off-3.fio:  slat  (nsec):  min=430,   max=40737k,  avg=9244.24
>>
>> nowait-on-1.fio:   slat  (nsec):  min=1232,  max=40098k,  avg=7518.60
>> nowait-on-2.fio:   slat  (nsec):  min=1303,  max=52107k,  avg=7423.37
>> nowait-on-3.fio:   slat  (nsec):  min=1123,  max=40193k,  avg=7409.08
> 
> Show there is a potential for a regression for min latency. So I would
> like to see this patch upstream and shipping for a while before flagging
> it for backport.

Good point, sorry I missed noticing that.

I'm curious at why the submission latency is ~3 times long with 
QUEUE_FLAG_NOWAIT.

thanks,
-jane
