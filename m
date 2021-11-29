Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951E22C85
	for <nvdimm@lists.linux.dev>; Mon, 29 Nov 2021 15:50:30 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATEswUt010312;
	Mon, 29 Nov 2021 15:50:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Kds29p0BHY48SCxanRcXUsbDaP3/sIyjXD9jABnfgUA=;
 b=xs6DfvXvk3Uyg5U9BFU5lheVueEz9t+uwY1Op13LkJ0kbp0eT5gEn0YvVzTBZPE77Y3i
 Em+3fVmDQVY94dVWgV/vxVf3/hXWxmK9/OjFxivNP78gdqHrMImJ0XERWBMU7P5KK7nj
 Wz9u0lnuitfxtjRgGzg7vyvmr61NALuPV4nZ1oy2zCLOcNUPq7gpM46kyUhQ6tgLzFDo
 ycoJzt5w5GGjTkUwF8oepdximqhpYKjT07Fw/HgRSL5UnTLnrpXw5vF+mbZbU/n78mGS
 RSx17Zut0OAR0SJqqTuZkqA/CezK5v44/F/b5kfXHLpwX3OYE1w89gtPYCzCifdgsmnk vA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cmuc9j749-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Nov 2021 15:50:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ATFg10W144381;
	Mon, 29 Nov 2021 15:49:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
	by userp3020.oracle.com with ESMTP id 3cke4mjqhb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Nov 2021 15:49:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYTxOLMSYaIkdrbzn2ng8gkKBetmW641v7b9H4a6szBqcyTWSLo8BPLjF3J/bNPePGh697daW9mwbC1fxfbNhAy9S3Da20KSwCc/8JM62JVu84cVogoi0y1seremS6VTLx9SsuWkEbR4mXJJkfqHkbKkcAk+B2W6rcYGyycgRGLbrTqcC66/o60Tx0Fw8zAD3HVRI4gf+CnDAaaVwIU5oYV23CyFpubanbq77PI24WoxxtIxQfJ0NTEi5mLjJDL2E/1OaiWUOl0Kar9zmkjCUTOkvJ1v/TyY5JLzIoFo3LFOPjnQpjbk/gBF2cchDiZxXgRoat6Hydn/FrtIaroASA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kds29p0BHY48SCxanRcXUsbDaP3/sIyjXD9jABnfgUA=;
 b=Bm4zaNHn7KPBvvfE9s8Cf0RQs3KxwJ0O3PQariaNXE6bohfSnpK10og7fJVLitVTTuXn6gprxge4v24nzCGgTsptLfMK9AnDmbA7ijubk5iwl003r0ltj//2i2Q4V3l8hm8+u/TROXCV+93y0Ajn6N79aYvOCkzIW6C7hLvnqmOew18oo6GmyK1C8USL9WOa6DwrrK/HjcH52I2G10/DlhvhXjrnuD4YPstxI/8zVPXNJbaYVLw5aasBIDZEmf5Ku1KX21b45/UvLq/b03E2XIy8NwhLBI/1CXUhrye0JRulEIyIyww73O6PXJHup6NKM7fG5kimnI9rlDV6kH7RUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kds29p0BHY48SCxanRcXUsbDaP3/sIyjXD9jABnfgUA=;
 b=Gem5SitDLvzDKWIhAlZC9C+AK3X370D71CeapFKMRgCa3eKgDxI9isPVaxbgM+Wm7wrUkf4QZBO+jCDqU2IztLO5gTCVfzZRUoKQ9iiOqlqRfm3cwpcpa/ecqH6bx1skPwFZZ207ZJMs5VK1HHA6WXak8y/DZBUe1Xyyl0qPUwk=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4820.namprd10.prod.outlook.com (2603:10b6:208:30c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Mon, 29 Nov
 2021 15:49:56 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%7]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 15:49:56 +0000
Message-ID: <b8056071-d0fe-b8ef-5fe3-85ab639f4bf7@oracle.com>
Date: Mon, 29 Nov 2021 15:49:46 +0000
Subject: Re: [PATCH v6 09/10] device-dax: set mapping prior to
 vmf_insert_pfn{,_pmd,pud}()
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org
References: <20211124191005.20783-1-joao.m.martins@oracle.com>
 <20211124191005.20783-10-joao.m.martins@oracle.com>
 <0439eb48-1688-a4f4-5feb-8eb2680d652f@oracle.com>
 <96b53b3c-5c18-5f93-c595-a7d509d58f92@oracle.com>
 <20211129073235.GA23843@lst.de>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211129073235.GA23843@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P123CA0093.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::8) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.187.247] (138.3.204.55) by LO2P123CA0093.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:139::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21 via Frontend Transport; Mon, 29 Nov 2021 15:49:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2d4a32b-7791-4863-edeb-08d9b34fe431
X-MS-TrafficTypeDiagnostic: BLAPR10MB4820:
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB48202778C8679DA0773AA0A1BB669@BLAPR10MB4820.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	trkLY+YFZZLcdIjJoTAflOBierrkq1kTyFum7KUHuk1kT9Zl3VGHv0CzmbepxcERXeOp5IhNUh1B67Whovczmck1bN8QI/81U/mlMQs4ifc9uNIR6/8S+ziKPcoRP9WEaWe4Wsaq0yS4PBdKszBt8S0w8FdMvNjmxRrFFGjfHcTYE2YHs8lgHH5caDkVSXeC9BUAwa9bE2FzQLzf+SjBmPSt1VV+EYjUEUwquRfe+Ah6JgGPpnmCkhuoJ79zgMXbEJ/jEmUwOUSIm/tMMVzteXc8uz6f5zfuzdboqElJvQfIxyr/06L/BXUk4xd9c9iSDQv/VrXAlF/t1W02H/AH807naH57tr3znh762kMIFNGUL1n8B3P9teUd61glOIg01HpuJqX8Lzxfo/Yg49mRAkbvs93oec6Z0sZ999QK4GovjUu+sjVzyGmVb/UVV7e7MGqSmGGmsPOA+1BD9KZrSVcOIJj576NfemSJf2A3rTzEGTvtYztQVfOVVIdGkhMiBRjTd0VcqSlLBHGiSb57X7PAwFCSNKoqDA1TIX8uLsW2OcPgont+qtuuUenpVtEPvRuqY3ocmD9TNdEKKHobRCbGOUou3UAolLNfCLwN1ZltanvGsYaz24qxqfaPVHZj1r5zupZkCfPeQowOVF70srge4LWhUfhtSLgAAzxOPBuXNInx6aW0p7txMaUai91FdNbzpvzXfeQNld4CEYRG1Q==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(36756003)(66946007)(2906002)(8936002)(16576012)(316002)(66476007)(66556008)(186003)(38100700002)(508600001)(5660300002)(7416002)(4326008)(8676002)(26005)(2616005)(6916009)(6486002)(31686004)(54906003)(6666004)(83380400001)(53546011)(86362001)(956004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?STNLa1dJT0dmdUYvZWtadmNpUVQzTS9BYmFhditscEl0UDFWWWxGZHlOWi9u?=
 =?utf-8?B?ZkxNYjUvOFJRNXh3U0M0RElxUEIwaXVOOFNMUXBoV0lTaW1WYW55V000QmFz?=
 =?utf-8?B?NXR0UWJVdnd2SUFJWHB1c2QvYWZRMnhpNmJyR1QyeVRkUWxVUDRrczdMWTFV?=
 =?utf-8?B?S2kyT1dUOVhUY1BMTk5vbEJpQ3JmQWVGZFE1Skd1bERNMW53d2NqWE1LT2d0?=
 =?utf-8?B?TWZQSzlOWU1zcFJjcVZnalZqTzBYc1NFKy9zQWUzRlpNNnBGRU5LTTRFS0pn?=
 =?utf-8?B?MFY2NGdQR3JPMWtsd3htTmRpWlIvTHJWOWVod3JhNUpibzVYbXFFVUpnbUJl?=
 =?utf-8?B?YWNzaVZEb0RpQ2dUNEFuVW1hblNRcFZHOWFOZ0JXODFvYnpQT25XdG9FK3JS?=
 =?utf-8?B?aXNkd3htWnZWUDJSZXRpV0xoTEJhajExUWk0RXFJZnRYbld4Y2pYL2czaHpI?=
 =?utf-8?B?SDQwa040S0dZSzhiUkVmQS9QVVJqREsrbVB2Zk83L2VhWEVtdlJWMGp3Q0F1?=
 =?utf-8?B?dmNFRVRYaHJrekdSa2dQd2x3SmIvck5BaFc2Nk00K1F2TTFCR2xZdDY4OVFV?=
 =?utf-8?B?cUJza056aGNWcFBWT0dmUDA0Zmd3a25nOENrWVBRMGZFSEVITjNUaEV3NHYv?=
 =?utf-8?B?b0w2NDhLNm45YXZ0czRjZC9mOEliTEZ2OWhzVUxoOHJjTGRFNHJZeXZvQjBJ?=
 =?utf-8?B?ZDVNejd6ZkVYbWh5a3pQK3k1MWJCUGozdUgrTFl0UHgwbXZKK1JtY1V2RkRp?=
 =?utf-8?B?Ry9GaVI4ckcxOWdtWnpoMXVCNVdqeGlKYWJHeTZsYk8xbVpJZVU4TzJHL3VK?=
 =?utf-8?B?ODdTMkJIdExVS1dxUDhpVGZZWVZMY2IzR1REa2pKQ0FxeTZDQmQ5bmJFUGJn?=
 =?utf-8?B?dndCbGFlb2NhVk9MNGRYMWF4MlZNdVFCWUx4QW5MUzZwa1VvcEl1NG5kNHhL?=
 =?utf-8?B?eGhQN1U2MnlFN09RSWo3RXg5VFVMMy9CeElCNUh6UEVlSDNJU0piQXJuYjQv?=
 =?utf-8?B?Y0srSTcwRU1sbGdFNWFjZlhJLzF2T1dCUWJyeFhWNVNXUzBEdWJVNDdXNUd4?=
 =?utf-8?B?RXpYbU04Mkx0ZlhuU2ZkcFRoNWFiVGtDWEZDR3hIU3VwZWYvL2ZFRjhmMUw0?=
 =?utf-8?B?UkpxZHcrZE1ZSUpiV25KdGlnekUybG5CckNuTzE1YjA2TXM1eXIzYmRVWUUw?=
 =?utf-8?B?V0lyZ1NGTXZGV3ZSakVlNTUrN2pZaFFVSDBjeWsrbVIzdEc3OGhzSHJHRmZ4?=
 =?utf-8?B?bFcydHczbStzbm5jL242ZkcwYVM2Z0ltNXF2SGYxWGxUeDBaVWEwYmdOeGMr?=
 =?utf-8?B?OFhubUlKQ1dNMjNvc2FJVTh5MmNnRVgwN1dHRUVkcWFMUDlnRjVtbVl6b0ZK?=
 =?utf-8?B?MTg0S1UxUjg2K05wb2YreExLVjJrN093N2tIREJDQmlSbjgxVDRGKy9QV1VD?=
 =?utf-8?B?Q0QyZEI2SnpSaEtEQnFReDB2eW1FbE5ReXBiQXRwRGwxa0tQb044dFVZRzlD?=
 =?utf-8?B?RnQ3TkZmTHdxdEZ6U0l2RklhMVY2OTEwbytsWm1JblNLWG5EdDNJci9RWU1p?=
 =?utf-8?B?MGROTmErMG5MWEEvRnh4T1ZhaHI2NHlQZ21TY3RGTW9obG5RRGc4QWpKQVNJ?=
 =?utf-8?B?YnVQNTlnYlFOSEZBZ3U5SDcrLzFJeWd0bTNHUWZWUXdxdFZocE50RnJCYnFO?=
 =?utf-8?B?YzBJNnF3cEtJNnl1KzZDVnJPTVdmSEErSHczTWJRcTVwNVVQQzVPcUl1OXlO?=
 =?utf-8?B?M2sraTFQU3M5TVYrbTA4anpYOHh5THRFcG5CYUl3d043M1R1d2dVV3RHYTFt?=
 =?utf-8?B?LzNKSCtXLzZrWXZVR0tVazI1VFNWTHlFdkNSMFFHSStWNGFXcG1vaUY1RWND?=
 =?utf-8?B?TW0rRFdtQ25VcVhJVkZzYTROYzNkdFRWa2hSWURtTkUzeDEzdWR1Y3JsOHE4?=
 =?utf-8?B?TjlGazlTNE04Q1FibVZmYnZRRk9pTndPdHpRWG5PcWFGbWZOYW1ScDFOT0Qr?=
 =?utf-8?B?Q1VhT0k2d3NreXM4a1JpNTZnYnpOVHhqZ1duTWd4a3BrYU5jK0Z0V29VYmM1?=
 =?utf-8?B?Ri9oWDJDVk1wcGdnTkdDK0FibmpYOG9mcVNTMXUrVGg3V3dPc2RSWGxaZWZu?=
 =?utf-8?B?SUtFNFRBbmp2S21SS2hIRXNZZkpabG50SW0zUkV1WmtSZUtaRGFIbU92TXht?=
 =?utf-8?B?RE0xelhxcW9NcDdsL0k4SHh1TEZRajZCdnVqZDRGdERXbkxmTzluNCttTG5E?=
 =?utf-8?B?a0JWenMzeXp6a1FpRm8yYXJndER3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2d4a32b-7791-4863-edeb-08d9b34fe431
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 15:49:56.5067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b4wBxJoC+tBEcyHjEW8V76/RWNUobYJnbZlONGcsbFQ/F/uP9Tbkk2LIoG++YwbWLnawtIAXHvzz5eSu1P6c19iuGfAqXkv/rEyqn5zH57U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4820
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10183 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290078
X-Proofpoint-GUID: TDBIF3P6oG7qIyRk7gvx1dXrdqtTPLYA
X-Proofpoint-ORIG-GUID: TDBIF3P6oG7qIyRk7gvx1dXrdqtTPLYA

On 11/29/21 07:32, Christoph Hellwig wrote:
> On Fri, Nov 26, 2021 at 06:39:39PM +0000, Joao Martins wrote:
>> @@ -230,23 +235,18 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
>>  	id = dax_read_lock();
>>  	switch (pe_size) {
>>  	case PE_SIZE_PTE:
>> -		fault_size = PAGE_SIZE;
>>  		rc = __dev_dax_pte_fault(dev_dax, vmf, &pfn);
>>  		break;
>>  	case PE_SIZE_PMD:
>> -		fault_size = PMD_SIZE;
>>  		rc = __dev_dax_pmd_fault(dev_dax, vmf, &pfn);
>>  		break;
>>  	case PE_SIZE_PUD:
>> -		fault_size = PUD_SIZE;
>>  		rc = __dev_dax_pud_fault(dev_dax, vmf, &pfn);
>>  		break;
>>  	default:
>>  		rc = VM_FAULT_SIGBUS;
>>  	}
>>
>>  	dax_read_unlock(id);
> 
> I wonder if if would make sense to move dax_read_lock / dax_read_unlock
> іnto the individul helpers as well now.  That way you could directly
> return from the switch. 

Hmmm -- if by individual helpers moving to __dev_dax_{pte,pmd,pud}_fault()
it would be slightly less straighforward. Unless you might mean to move
to check_vma() (around the dax_alive() check) and that might actually
remove the opencoding of dax_read_lock in dax_mmap() even.

I would rather prefer that this cleanup around dax_read_{un,}lock is
a separate patch separate to this series, unless you feel strongly that
it needs to be part of this set.

> Aso it seems like pfn is only an input
> parameter now and doesn't need to be passed by reference.
> 
It's actually just an output parameter (that dax_set_mapping would then use).

The fault handlers in device-dax use vmf->address to calculate pfn that they
insert in the page table entry. After this patch we can actually just remove
@pfn argument.

	Joao
