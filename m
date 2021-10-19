Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B2529CA
	for <nvdimm@lists.linux.dev>; Tue, 19 Oct 2021 15:22:05 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JEG3tI004740;
	Tue, 19 Oct 2021 15:21:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=k3FUUWJUpY4WWUbpRACVAFwltoRFmtWlt3rt/0xhAqU=;
 b=WDZfGiVclEajxS7uqXrXSdC/ULnn/dADtJL3LWR/PYEPA0gM7rSBGdkFDFaR0ABQZ672
 OwurMY7QwkyY1/IK4Z/trfMpP6Nu8Cq7kiK9jmYELqYaIuS88ze23mPixyOsa9aULRWi
 vGVJqxOl15hrospAz9vuWfYq39XzWx8AsBxMveA3BmwxjiE8opn918rWUXQEM7DRNwjn
 vumrzUDT2EQorobLSGHabXcbUA2k7AeXBb/QgGKn+vWHOwzm9DzQMGul9Y+GrtRsFPZZ
 rtnT60PPGfu5mrdZTlzHYqp97OxFLEXOV7fXCQ6X5r4FYERSh5BMVtvNF9xeWfYwTCJb gA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bsqgmk7sf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Oct 2021 15:21:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19JFFXCA012850;
	Tue, 19 Oct 2021 15:20:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by userp3020.oracle.com with ESMTP id 3br8gsjcdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Oct 2021 15:20:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBZqijgIRUyjPKhcozJ1DyJwixjkrIhhqNczSXdzTrhg4APv263D/Ge4G5IFTDMjSpbuD7/qwGiU/ZGzH2GL8W3wn40yT5KaFIbI4w2lIBkcrZU4XiCtSeo4csCnZ6dIz0CnqfzxzVy/IaMQ0f49HadoFao8j5l+pvZdCUZvKIvZZpM1r3XJoWgu+4jRwRUW1DwtBLhqerNj1vY0G9LmLg+bAPiUA49vK993XwbGBz8qicQxxcJel4GdGgxw3oHXDIxTYSHhCaD6aoEC2iicKAh60K975PD+E9GX9SKZVTDEcXanxBnSSQDZtlMBBFdOpUo2jA9xHSUNVKilcKZ7hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k3FUUWJUpY4WWUbpRACVAFwltoRFmtWlt3rt/0xhAqU=;
 b=N5GcVFsJ962wjKdqM/mKzpoG+rGSzDXgcWdb9eRyHp+za905ItjoHPJHOA9b28dCcXgQ7qlhOEaWDhHIe24LOpZ4Fi2g2yNxnjVdIFjXu3uyfDmrgZNDezJnWVJd9O6fvgNsUN79Xv2DHO8+clxMRbabVIQHGT9Lw/D5dvfgpQoljZbO7PhZmj2fMjg8dOv/6rSr+utIXlvNiiVBo/+V59btdrkZbM6MT1v54XL/PpzHH9IiPW8setTc3/jnlUyt6OiPcKEOCeJejEQZBdyVZUUauz3y7dXaNTdH1yspHV20Sae66O752MekEN0OP4uXMUHRRFvjR4Fnp2+sHTjJ/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3FUUWJUpY4WWUbpRACVAFwltoRFmtWlt3rt/0xhAqU=;
 b=QjwAtCa8QMqTfPxmi/Ob+/wVpW+1HO5QgIj9HfvPdBM7IuCWLyctXnNsbwbQcc4YJq9WHIRAscte/QDQTR3kKGLPa3D+QMPdoEJM86aW0dWlAA/fMc1h1+e66RYm8JzSdy878ci1SoAJIj+Aii5ub47yGu4X3CilTH7vFhNFToc=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4045.namprd10.prod.outlook.com (2603:10b6:208:1b7::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Tue, 19 Oct
 2021 15:20:25 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 15:20:25 +0000
Message-ID: <a0001855-4f08-78b7-64ae-80ebbbb04f8d@oracle.com>
Date: Tue, 19 Oct 2021 16:20:16 +0100
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Matthew Wilcox
 <willy@infradead.org>,
        Alex Sierra <alex.sierra@amd.com>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        Linux MM <linux-mm@kvack.org>, Ralph Campbell <rcampbell@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
References: <20210823214708.77979b3f@thinkpad>
 <CAPcyv4jijqrb1O5OOTd5ftQ2Q-5SVwNRM7XMQ+N3MAFxEfvxpA@mail.gmail.com>
 <e250feab-1873-c91d-5ea9-39ac6ef26458@oracle.com>
 <CAPcyv4jYXPWmT2EzroTa7RDz1Z68Qz8Uj4MeheQHPbBXdfS4pA@mail.gmail.com>
 <20210824202449.19d524b5@thinkpad>
 <CAPcyv4iFeVDVPn6uc=aKsyUvkiu3-fK-N16iJVZQ3N8oT00hWA@mail.gmail.com>
 <20211014230439.GA3592864@nvidia.com>
 <5ca908e3-b4ad-dfef-d75f-75073d4165f7@oracle.com>
 <20211018233045.GQ2744544@nvidia.com>
 <CAPcyv4i=Rsv3nNTH9LTc2BwCoMyDU639vdd9kVEzZXvuSY+dWA@mail.gmail.com>
 <20211019142032.GT2744544@nvidia.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211019142032.GT2744544@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0134.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::26) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.162.43] (138.3.204.43) by LO2P265CA0134.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 15:20:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a66a871-33a0-4289-86e2-08d99313f990
X-MS-TrafficTypeDiagnostic: MN2PR10MB4045:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB404539B345B8F09B06129FCFBBBD9@MN2PR10MB4045.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	IDlMGE8yfNOyB4TrnYb8nz9vHe6oyx6P5zEDE4wXErm4FpxEFMNOkOUd0Vz4yDKh/a54esqkknflSv35fU1eBMT87ODAsuDgUpmHsDHnrFU752EtfARZrfljzgyW3bKH8wUixUsXVh4TzaTk/VZzDY9MmA+PP3yWIOcjxPr9Sl/zVcT/Ay6gPE0oQ+vS5eq5NS97CPbWQayEE/+uFUiGN+fMszAd4MBu+VN1RrPh3+etjd99dAOUMxuve9W8BGBDopPZobLhmmyiMXxZb5P2yivIgYnsbarajQQiTdoSlyENSCyspyZzLNJq9CrNaWqbH3NOEQw2Zn4VWzN4Z3aBPQaBqGZYRpPVhQJl4xverNWqtSCvmLovDOJ57ElGFxYkpbtEu82zGAYnYrEfRfp4FBczcb9rrMrcVExNPthrutSSr/GHAtU55ublf9pqSmHV0WJHeuVSaIHOcR2pL12A6E3iMYL0qjgz7ctEZn1eXqewuMlvl2DmEi+4AgGrI6UiOdwx8md9R45dUatO9ANP3Cs7QZjqa7dAwCRScGGHeVkJPepZywcCY269NvXCZ5Adbmm/a83YDBltetN2+tvcivjMee8zLOo2XZPn8U1glmp3aIxlYIixXlr4ALU32v32VpgHsHYc9Aj5u/eeuU3n68Hu2L4zVgqve1UUhYzFgtXmCplxgEIM8hxj2R22vNj5ftw7FUU8QcvfAcQcur2k7A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(316002)(31686004)(8936002)(5660300002)(66476007)(2906002)(8676002)(508600001)(16576012)(26005)(956004)(2616005)(38100700002)(53546011)(186003)(6486002)(36756003)(83380400001)(31696002)(66556008)(7416002)(4326008)(6916009)(86362001)(6666004)(54906003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?alpBSXNNTDZlb1MyUnNhZEhRdnhnY1hsYWtBL3ArOVUvM2QyVkNpWEFiU0Ur?=
 =?utf-8?B?ZzBTdmo1Szdta0ZLakl5QnBqOE5oNWI1MkVhVEJSdkdMZ1lkSWpJQll3T1Bo?=
 =?utf-8?B?Um1PQlVuc1ExeFIrUlVBLzZuL24vbm95MHhhZUxNVko0enZrTnBoazZDc1Y5?=
 =?utf-8?B?TkVaTHdiR3ppMVRzL3lZMXZPVDhCR3NOeWpKZ0pWdmVXRFJDeU9jYXhUVm1s?=
 =?utf-8?B?NTU5cFZZU01jTnFMNXgzTWhrUjJhUkZWZmsrZFg0TW10WkpqYXpyTVRWTDUz?=
 =?utf-8?B?aXpXUTQvY3c3dXJrZTZPTjgxSmk1dTJITFFCYjI4M3k4OEZzWGFIYi8yM3Vy?=
 =?utf-8?B?WitkOEJEMUFaVnFUcWI2bWtEMDBLQnQ4WTV5UUhhZ2ZzeTVQZlR5VHpraVVr?=
 =?utf-8?B?TVZsZ2o1cnFReHRyRzA4aGk0aXFXN2lNOEZ0T0NvWnpkcCtTRWZySXRTMkIw?=
 =?utf-8?B?Ni9OOVZWd2hEM25LTG00VHhDbTgybk5EUk55V1B0L0FLVHhOK0xGVUphRmFB?=
 =?utf-8?B?QlFCVEJabDl4RXBkeW1mNnBEYkhkZzJjUWNvZnU1UGY5WlI1eXBGTjdZTE5H?=
 =?utf-8?B?YkZ2Ujlydm5TQUNET2tJTDE2Y3ZQY2JiYVlzcGphSzZmL28xUDVQL0UvMXZy?=
 =?utf-8?B?bzVxV3BXZkU4MVE3SERaMy91VzlkMnRuczJuRENWcUJZTGJjYkJqQ093VWlx?=
 =?utf-8?B?MGVZclZFYmZHT2dPQTlyZlJ4QTVCQUh4KzJCQ1FGVWlhSGh3TFN1SWZ5ems2?=
 =?utf-8?B?T29idXQxZ2R3VzUvRm9UTUY0cTRMczlGeWpYMlFMZ2VTcE1OMVQ4VzRhejN4?=
 =?utf-8?B?YnJMM1dOK2k0Q3pFQkVxR3dSL1lLOTJzekEyaS9zRXA2QnFxU1JpWndyQ21v?=
 =?utf-8?B?ZXVKTEZudUc4SnQrMkUzNnBZNW5FV01waUVGdHFpMFJzS28zQ0swMWE5UGpB?=
 =?utf-8?B?YWRDb1BZeGlKNDg0S1hsaGxQWWxJUnE4eVo2MnhuQnVnUXpIbjZlZHNzZ0d6?=
 =?utf-8?B?MjVQdGozem5LUHBLdGxNVHZJcDlJZmk2N2VkK1ZIRWthN2thSnhmV2hNRis0?=
 =?utf-8?B?UXp5c1dtd0tlTnEyS2tXeFJhUFI0VDR5a1pqbUFZRE14UUpaTlhYTFk3TCta?=
 =?utf-8?B?SENaa0w3bm5sWHZSaUo3enliTWdGNndKdW53bGhZNmptODgxVHZiNVI5WEwx?=
 =?utf-8?B?ZTFXU1JlakQzazRhWnFEL0QxeE82bGxUZm4ydHo1V051WWN6SEJVMzZLUFdJ?=
 =?utf-8?B?NVZkRHFaeEZEOEhpSUVCZHlVYzVIYmlENWNEZnRsbE56eTc2M21xWUZ6UEZr?=
 =?utf-8?B?cC9BNmhIamhxQys1SWxVaWE2S2ZIWWxIMXhkeWZyQmhVVFJBRUk1NnVOYzA4?=
 =?utf-8?B?ZWdvU2pFS1ZHamZERVZ0aVFGV3JVNXp5bWlHeGNyRlMvM1JLSEw1U0xqVjFk?=
 =?utf-8?B?a2dtcmZKdm9IbzhQMTQ0REVmMzNIS3pPNkRzVGxjZmRIc1dLRmNOL2JZeVcy?=
 =?utf-8?B?dlE4VHVHVE1haEZORHo3ZHN0cXc5VGlDbFRSRDFDeC9rbWgrRGkza1U4Y1h2?=
 =?utf-8?B?ZXBLdWtYcGpYTWZtb3E2M05raHJpS1Vhb1N1aDhsdGIrcStKdCt0bU5RSXhT?=
 =?utf-8?B?Y0RVdlRmeHkyNCtHOVM1clRvVENHTVIzNnVtSmp1OEV1OXhFcklBUWFuQ2lu?=
 =?utf-8?B?dUpQUFVJL2dLTzlwVWhBV2xyV28vV1BBYkEvMGJ4YU9RZXgwNmIzNW1rcEZp?=
 =?utf-8?Q?lYE7zaw2uDncMC9cFiqZyRrwfQ8TDhPMDHJH2x7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a66a871-33a0-4289-86e2-08d99313f990
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 15:20:25.2536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wQAsI3XNt79S/M0sYTuDP7gkXa2PNIEoOqXZXIq9HfBziWKpEV0tQ6HYosnM1eG5+1QP2PI2iSzA1mWrbG8/O1RiB0RZfvJeX+KStJDivfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4045
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110190092
X-Proofpoint-GUID: -xgAQ9qHhr7YPnpMS2bNkhNwCeOVXqiA
X-Proofpoint-ORIG-GUID: -xgAQ9qHhr7YPnpMS2bNkhNwCeOVXqiA

On 10/19/21 15:20, Jason Gunthorpe wrote:
> On Mon, Oct 18, 2021 at 09:26:24PM -0700, Dan Williams wrote:
>> On Mon, Oct 18, 2021 at 4:31 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>>> On Fri, Oct 15, 2021 at 01:22:41AM +0100, Joao Martins wrote:
>>> I'm not sure the comment is correct anyhow:
>>>
>>>                 /*
>>>                  * Unmap the largest mapping to avoid breaking up
>>>                  * device-dax mappings which are constant size. The
>>>                  * actual size of the mapping being torn down is
>>>                  * communicated in siginfo, see kill_proc()
>>>                  */
>>>                 unmap_mapping_range(page->mapping, start, size, 0);
>>>
>>> Beacuse for non PageAnon unmap_mapping_range() does either
>>> zap_huge_pud(), __split_huge_pmd(), or zap_huge_pmd().
>>>
>>> Despite it's name __split_huge_pmd() does not actually split, it will
>>> call __split_huge_pmd_locked:
>>>
>>>         } else if (!(pmd_devmap(*pmd) || is_pmd_migration_entry(*pmd)))
>>>                 goto out;
>>>         __split_huge_pmd_locked(vma, pmd, range.start, freeze);
>>>
>>> Which does
>>>         if (!vma_is_anonymous(vma)) {
>>>                 old_pmd = pmdp_huge_clear_flush_notify(vma, haddr, pmd);
>>>
>>> Which is a zap, not split.
>>>
>>> So I wonder if there is a reason to use anything other than 4k here
>>> for DAX?
>>>
>>>>       tk->size_shift = page_shift(compound_head(p));
>>>>
>>>> ... as page_shift() would just return PAGE_SHIFT (as compound_order() is 0).
>>>
>>> And what would be so wrong with memory failure doing this as a 4k
>>> page?
>>
>> device-dax does not support misaligned mappings. It makes hard
>> guarantees for applications that can not afford the page table
>> allocation overhead of sub-1GB mappings.
> 
> memory-failure is the wrong layer to enforce this anyhow - if someday
> unmap_mapping_range() did learn to break up the 1GB pages then we'd
> want to put the condition to preserve device-dax mappings there, not
> way up in memory-failure.
> 
> So we can just delete the detection of the page size and rely on the
> zap code to wipe out the entire level, not split it. Which is what we
> have today already.

On a quick note, wrt to @size_shift: memory-failure reflects it back to
userspace as contextual information (::addr_lsb) of the signal, when delivering
the intended SIGBUS(code=BUS_MCEERR_*). So the size needs to be reported
somehow.
