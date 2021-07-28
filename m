Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBF870
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 18:54:18 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SIolIA002496;
	Wed, 28 Jul 2021 18:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=u94fyDQ/F5weA+boe3zisgYbHJ5P/a9quIzPebrQMQo=;
 b=JdJGDqavUkPwVsQYYt+gzm8RXs1+5XxQDHzHnvY77Ki3qfDVDWaelodE+yU/8nHdcQue
 VtWAYd6vobVTFyGn/mgJJD91lZszY1fuIPLVGFhmxA0PNJaay77V++qfnlBKBeDNgyVc
 do5R6D5NupBeVFli/LUCIrLwqiPO364W7dv8YciX36uus8Qlwz9zBAkscXgWb/Xpb9+L
 siAw2ufo5vr3a5g3/Vo3fPEdwzyCO/uq0kxwueOkHFPmKn8Dx9cKb/ZOWDLP10ZFkTZn
 +lE+aLO7RowaWiq8xVAw15UiLmd8uYTlNMrICZ9ZwfVyc8OEMQpDSlGgD3MMkh07KGG2 aQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=u94fyDQ/F5weA+boe3zisgYbHJ5P/a9quIzPebrQMQo=;
 b=jArOsJ+z5BbofcZifob0YEKsTI9j9CMj/4pZRMCdfNzMqTTSCp3J/spfcwX+PzR4LzSj
 8dWNU/QFAeR9aomMNbK+/g0n13GXwVzqOzUnDFOlOMXJh9OBzgewtWkWwhYd9E6pqPKa
 zbU4bu5kII4ss+2abAVI8fhirM+FAfKX2ck23cHTb9XBnUpzdmDKkWCV3sTRv5WOKhs/
 vFakeNziR8O7tWkQjmaLDE0h8PcP/Al214Ta6b6qiAH6gdlPanLrZujMNaWmE6miPVX8
 CEVOCwW6kXqSHTsJSKz6eg8+IavzfwH/eb9WIEiOUPIZEo/5BhGs/9bVjNrfu61V1nHf Fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a2353daqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 18:54:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16SIipYE010348;
	Wed, 28 Jul 2021 18:54:10 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
	by userp3020.oracle.com with ESMTP id 3a234ya40q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 18:54:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ik6eZGdbZHchzzWGMzH+DOC3y4H7fx1qDMGlNStQeJPa2I+aVLvSnXCDsUNvLiy+NI+WRUGzCzelF7uZ3HUHHkkxRwbAt8iYugrwNrLvl0Yni9PdrQkpl3KW/WwHGi7WB1gNkGCrenXsD3qJvf7qsD2JtP1MMG9TEwbRQTGnWpEmz4ENzA0Y2QDuwiXgbg4GKGsLzF7Ie7xO3BmsaV9AvoiWE0lgNhvSJjXF90IZNlGRJUaoqkFI/41lYoKSJpV17hS4SIjTx9vAu8PIXa4z9i18M8XAulDXPMmztaj637CnkbbOTDS8iUvociIl9nD+QRnZcLgIyjkRyeoIVF7vfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u94fyDQ/F5weA+boe3zisgYbHJ5P/a9quIzPebrQMQo=;
 b=K/JoXlyTxoN1pZ/RI0qtKsCtBS1aGCfYVn3xzK8bFMy6HA9aXGojvtap2/iLGrqvlCkSijmOI8NJOiH3O0eNc/VdykmGyYFBPU1/6ZLh9f1IigqM3vztbyufGszCvEkJHBqcZoDrEsBzwzc0UnCGOWDr8I31HrFH7WKQXUR38xvPnqPa/mvPIIerge4hkM9LTcOIZp4DfgI1YQN5Ic4tKHhdObL0EDPkNMIx4iVwR8j7/U3vexCjVMKqw917RrI2NRPTXYGg5yS+AzHYEo2FW90ZzxgbPajAT/k9xWJLCY1bX/bsBCPJ7BOKgwwtTXZAQkkv0bdxUNRXAxyGyYM8oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u94fyDQ/F5weA+boe3zisgYbHJ5P/a9quIzPebrQMQo=;
 b=HmFLpdcDuH+znRqsAUqkwiHTNembFbO3fW85h3QHWz0GlQ6QhBT2jx51V5A5BP0od0INCLF1kK33RPGlKWV9pzYtC75g/NI9u2Yt9v5+8x2g19tnCv9aIGRrb1AoBdC9d/lqUhQSqu2y/qxfTo9faFKcg0+HZQYaCdSKOdyI5pQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5138.namprd10.prod.outlook.com (2603:10b6:208:322::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Wed, 28 Jul
 2021 18:54:08 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4373.020; Wed, 28 Jul 2021
 18:54:08 +0000
Subject: Re: [PATCH v3 08/14] mm/sparse-vmemmap: populate compound pagemaps
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
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <d7f1e0b9-bf57-b30e-84d5-cd0e5cdadaaf@oracle.com>
Date: Wed, 28 Jul 2021 19:54:00 +0100
In-Reply-To: <CAPcyv4jR9atodmLqk4O+RdbM9DJDvoQvAZqH03UAgAKB71Fcdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0174.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::17) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO4P123CA0174.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18a::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 18:54:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a108e6d9-b216-4f27-9076-08d951f9147e
X-MS-TrafficTypeDiagnostic: BLAPR10MB5138:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5138C3CEEACABE53595DA85CBBEA9@BLAPR10MB5138.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	fLVVGl+UuRa87fU/DNj04uUxvANgqw/Sb274q3hEGck0l+xlN1ZjjUKTSxfZtWfmbrIUeg9QXluhUUX7zp+uR7SWS0Xe+SCYuj05uo7AgSxiPfEaaeyCUd+LwSuPzXa+Vahqi3mYAoLD2LKU9wD0iFL4oe/uu75s4S3kDJ3nXcLDzdfwMBY9qF6U77rnqyfWGcc9yJt5T3nGNqaESUQL6asS8x+X5Np68Gf5vu3lHq+MmTdKbGOCTw1BJqLkYab2+CdL26STTq1n9/aWjJvsRwUTyNPUEOto+ZCZIPUsCkZFQqZPQdIsFzixtjU63Pl/bA3s40DX9YLgaHWTuZnvrPSWugVy4Buy3UeWMvLRifF+yEGQQL0Nw5Xuf8PZ4GpE3WggH9P7sIQqeZws0MYIJT6b1mTGzUHEyU/IYPpVAXLhyN0zIM74ZIoxMc7uJdP1Jf9IdWI+AEEJ0hYj293pOmPO1k0fvV28S7DIB9TOusMo9XhB4SXuhQYBpmbocpPOWVd+54rEKgrtpNEOZ4jMB7WpRjRcdVNFYzf6TOYaGV/tAGwaWO1I8H8yjJyOIX1j3IFu81vTNXB6o/xaKz2Ny8RfX4VsvBFOkcLAjXFqojv1lcyI7KmjDv76hQB4BiXYrAsK9FUtyNUI+mkympqULjPZLmbUM1syR2Zymy6QV+dHRjmMBuLLGFj/VPtQMc+xCIzBbKdBefmdh2udzjZyeg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(39860400002)(346002)(86362001)(2906002)(956004)(2616005)(8936002)(83380400001)(6916009)(478600001)(31696002)(16576012)(6666004)(31686004)(5660300002)(8676002)(66946007)(54906003)(66476007)(26005)(6486002)(66556008)(53546011)(316002)(38100700002)(7416002)(36756003)(4326008)(186003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bkFtbkFJNE96OTZNSU5Ram16emsvVndZQ1YvaUk5aU9SU0NuWlFUeTJwUnpM?=
 =?utf-8?B?ckNYNG0xSkdHck9zNWxROVNTTEVBcVk3dkZoekR3N1ByOGJ6TEh2clM1ZW5t?=
 =?utf-8?B?b05yQTRSV3pEMFpjc01EczNrNnR6SEZnaGxBM1g2ZHFiVmI4QTcrVGZ5UWE2?=
 =?utf-8?B?L09KVXBIREp4NnJOd3FKYUR4bHpYaWNBVUt6WndxRDBmTmdoV3hmNkZZemxh?=
 =?utf-8?B?YlNrS2NUdHNwZkNBK1dJYnQ2UlZEWGZRejlFNmdESWlwYmNNUFBGN3ZwTlFV?=
 =?utf-8?B?dXNjdHFLNlUxTWZPenFUQ3ZuWVVPUGxCVE13RVdheDFmZzhkV0VtaEZBQ3FG?=
 =?utf-8?B?c2lTWFZSWTdFMkt1TzYzVlRmR3hNSjVTbnYxTTZ5RUFOOExnZXJmbGpndGly?=
 =?utf-8?B?bStBbzZXREFraDhYQ2Z6TmtjNE0wRnlMcGEyR3FZQy96dWxRRTFDTnR2NHhE?=
 =?utf-8?B?bmRWNDJQeE5oTjJqcDlPcnFqei9ZRDRkcDlaMERleWkvODlFSkdvSEY0Y28r?=
 =?utf-8?B?SnZBK1Jkb0dzUHQvZHpzM1RwTHF1N0xQNlREZUNEdUtYS0ZhTmtFSy9lMGhm?=
 =?utf-8?B?dzYrNkg3RkZTYkQ0Z1EyOVhXcExzdWR2OVZuVGxNVGx0VW5pMldUMnl5c2ww?=
 =?utf-8?B?aXZoQk5zSms3T3NjcmdJNzRUb1NqeitsdElCM0tOekJDZDB1YXVTR0QvaklC?=
 =?utf-8?B?ZUZQQzh6cTJndUY4RHM1ZzVkOE5BTHVUVFI3T3dnbjlQMit1bzM0ZURJT3F5?=
 =?utf-8?B?cUtqOXBQNW9Bd3IvQTIvdDFuV3VoSmIzWW5lNjdOd0RVSWRYK0FFdXkvT2xs?=
 =?utf-8?B?aHJjYi9reFhKSmd3L2pSVGRTdTRNNkZLaGRDaHpKclFLL2Z4akRMSmk1WFB6?=
 =?utf-8?B?d1JLSmgyNlNRcVVHZk5wRVVHcFBLZE5ha0hmNU5RVjQycmRDbXN3UklBeG1w?=
 =?utf-8?B?OGNacUdyTml0WFlOYVFnSmlWeVV5UCt2RllNY2dLeEFHVGx1Wk9LQ09CS1pl?=
 =?utf-8?B?VTcyLzY4Y0FiY21uMHVMRUdzTmJiUUlvOGJzc3lTWUpXamR3WmlsQmltdWkz?=
 =?utf-8?B?L3FkWk91UEFxMFhDbjZPaEFuVHAwUTRJS3l4QnpuVk9sV0ZxMWhJYkZNQW84?=
 =?utf-8?B?ZWgzMnJvMFIxZUZuaUVoL3VxTGhtamlLRldNOEtyWVlYRkdOVng5a3VOREIw?=
 =?utf-8?B?eVIyV1VYUTBZb3REeTZaWGlXaXYrRitXOTRtSzQrY3NhLzVsWlFid0ZQN1ZV?=
 =?utf-8?B?ZlpqZTlSMm9kS3pkZ3lGSzZaeDAwNk04UmdBTTNRVngzNmtJY29lbFU0N3R3?=
 =?utf-8?B?bWdWQmdLWGpSdlU0U1NPVlJvaldUV1l3ano5VWVyTmFINXltclZIampBdkd1?=
 =?utf-8?B?ZDN5QmM1Q2xUeDVhV1hKdTZUT2d2TzhtcFVYdFlJUVdNNnhKNzkzdFhvcW9L?=
 =?utf-8?B?Q3hUWnpyaUhyYWtqanVlTExsNzV4U3pLdGJ5R01YTkR3TjZmRjYrcFVtQVhI?=
 =?utf-8?B?cCtud2NGa0tPT0xORjgybDFnVCtGdEI4Mlpwb1Baa2FtSmV0QXpVMHppVGJU?=
 =?utf-8?B?cElEUWtzRTA3d1FZRmVlMm9sVHlWelorNmcrZGNkajNWMklJYzlJMHg0Vk15?=
 =?utf-8?B?b2JRTlRKUjY3SEl1anJCQjBMdlFoVHhaRlNSS00xSll2ZTJ3bzNtdjNqelNL?=
 =?utf-8?B?U2tNOVZjRUh5VG16b0loSFluZHhrZlFISkFMcDkwcGVXM2tRWFhBZ2RQT2Er?=
 =?utf-8?Q?MJ5m0ESTyYE/HfCVWrfifAtHhXplR+jKgmTNbMg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a108e6d9-b216-4f27-9076-08d951f9147e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 18:54:08.3634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sAZ7k6cG8ZK2DLRKlbZvE+LV1lZDEVAA/VI2EozxqLBrMpsjOaxMbLJ0E0HmlD1ZU1mx/3EigKegEtFryd1OIVCS8p+VLtcM+bp92hxRDqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5138
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280107
X-Proofpoint-GUID: ZgGeGl90Sjm87-rc8MOUyNvCzyXPSNQg
X-Proofpoint-ORIG-GUID: ZgGeGl90Sjm87-rc8MOUyNvCzyXPSNQg



On 7/28/21 7:03 PM, Dan Williams wrote:
> On Wed, Jul 28, 2021 at 8:36 AM Joao Martins <joao.m.martins@oracle.com> wrote:
> [..]
>> +/*
>> + * For compound pages bigger than section size (e.g. x86 1G compound
>> + * pages with 2M subsection size) fill the rest of sections as tail
>> + * pages.
>> + *
>> + * Note that memremap_pages() resets @nr_range value and will increment
>> + * it after each range successful onlining. Thus the value or @nr_range
>> + * at section memmap populate corresponds to the in-progress range
>> + * being onlined here.
>> + */
>> +static bool compound_section_index(unsigned long start_pfn,
> 
> Oh, I was thinking this would return the actual Nth index number for
> the section within the compound page. 
> A bool is ok too, but then the
> function name would be something like:
> 
> reuse_compound_section()
> 
> ...right?
> 
Yes.

> 
> [..]
>> [...] And here's compound_section_tail_huge_page() (for the last patch in the series):
>>
>>
>> @@ -690,6 +727,33 @@ static struct page * __meminit compound_section_tail_page(unsigned
>> long addr)
>>         return pte_page(*ptep);
>>  }
>>
>> +static struct page * __meminit compound_section_tail_huge_page(unsigned long addr,
>> +                               unsigned long offset, struct dev_pagemap *pgmap)
>> +{
>> +       unsigned long geometry_size = pgmap_geometry(pgmap) << PAGE_SHIFT;
>> +       pmd_t *pmdp;
>> +
>> +       addr -= PAGE_SIZE;
>> +
>> +       /*
>> +        * Assuming sections are populated sequentially, the previous section's
>> +        * page data can be reused.
>> +        */
>> +       pmdp = pmd_off_k(addr);
>> +       if (!pmdp)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       /*
>> +        * Reuse the tail pages vmemmap pmd page
>> +        * See layout diagram in Documentation/vm/vmemmap_dedup.rst
>> +        */
>> +       if (offset % geometry_size > PFN_PHYS(PAGES_PER_SECTION))
>> +               return pmd_page(*pmdp);
>> +
Maybe I can drop the geometry_size and just do here:

if (PHYS_PFN(offset) % pgmap_geometry(pgmap) > PAGES_PER_SECTION)

and thus drop the geometry_size variable.

>> +       /* No reusable PMD fallback to PTE tail page*/
>> +       return NULL;
>> +}
>> +
>>  static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>>                                                      unsigned long start,
>>                                                      unsigned long end, int node,
>> @@ -697,14 +761,22 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long
>> start_pfn,
>>  {
>>         unsigned long offset, size, addr;
>>
>> -       if (compound_section_index(start_pfn, pgmap)) {
>> -               struct page *page;
>> +       if (compound_section_index(start_pfn, pgmap, &offset)) {
>> +               struct page *page, *hpage;
>> +
>> +               hpage = compound_section_tail_huge_page(addr, offset);
>> +               if (IS_ERR(hpage))
>> +                       return -ENOMEM;
>> +               else if (hpage)
> 
> No need for "else" after return... other than that these helpers and
> this arrangement looks good to me.
> 
OK.
