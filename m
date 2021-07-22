Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B46168
	for <nvdimm@lists.linux.dev>; Thu, 22 Jul 2021 00:38:37 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16M0ZHGM001851;
	Thu, 22 Jul 2021 00:38:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=k4vAmn0MjvMTA3KbhwTeJryU9i5NbSOfjPC0a3mXmDw=;
 b=0opRsktkXEDBcxDNwCL687CQ6iYPhMWGmgjgikI3T8rqql2ZV0RiisP6jWojTHBPHjw7
 IOUfOIlvWr/2knsxHsAVaXA6DG1WmecUXMrjZ/lX7zFq2gPY5C+NCy3s0vsJ76nBMgMV
 hRhISQovfsxcHS9IExmBonrEYBv/1lO4kWHkQVPhaEtEz2BbtjF4n/4+g7rQHfIkXI/h
 sy6xng3ZKpgNrN4VsO9EdaytUt6xiZJZA0j9N5uergiuXy/kI/O4umXoBdNG+0eYg29d
 8E6flsBrEh5+MqElxU2BDPEz9nKfafjDp9QtIlHxCzxkzgNKn7VTGx/k89MTamHRO8Fd HQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=k4vAmn0MjvMTA3KbhwTeJryU9i5NbSOfjPC0a3mXmDw=;
 b=FnvjVHalJJT+sSRvu0cQUhIm3fnfV60KPJ9LcxkwAouie2Eme+UDv0pFBAcXDM9hvjeM
 ynRCtGw66qOwBbKknz6RG1+VuzOCrWWI1mxaWBlLW7beXDdVIKB7esxz830cNAksPeK7
 471BRr8docRQTZ9xnaAW6D9bO025ECvCYaUxSdypsji6IBPOjCiaFTyr5a0ColVMm0vU
 RcsE4Nb1rTRibiKFR372R5kKaHYKoXT6AL7DZwIb0wDAAMuI/4JHtlDxg+IdNJP6oP9S
 4RoZasCnGtlzqAZn9bnQWFftlpvDa2/hoLCrJowfGZeLF/JxatYNoAJGDpRMSbNdbPSZ wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39xc6btbsg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jul 2021 00:38:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16M0aPBf139223;
	Thu, 22 Jul 2021 00:38:22 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
	by userp3020.oracle.com with ESMTP id 39v8yygk8h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jul 2021 00:38:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRTpo+PRY3IOqgipE53rb6znanD2GzNJXw+n6lFjNgRJ/WPvDGwt5HUO3eADrTSMNveSBJf+AYZYgaGCAu6RzSrFYYKolwmZv11ywYPiEY8XTJ4kHgOK0F49fO0tXJf+p7zpBs48nAED5xzHjos9c4v9mLb18nFAg7bvEZ7AtrxDDqWokNX4HXCqJ52RlZXBzmAxszzt0D4YeqzOGSBkF08lxoU1Kdd9lHob/bJloE/ETO+NaJW3ekkWBz97Bdv0tPlq1LwpSbR9CIez+Skh1eaTWPtLs8RmW8jXN9fGugTjJ1zczuljLvCqB3KzZiHWDgCgCdh9O3+VI8WIhc2gGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4vAmn0MjvMTA3KbhwTeJryU9i5NbSOfjPC0a3mXmDw=;
 b=WjhAJRUlyGKCGX9C+wDHBCJbDPlsrtSDMDYuHs5+cyYh1pFFtClWo5TQs2VOoU95XcO+CO7XdFFsE7lD3oBsGavhUSRHgyKlyAognmYrU/85niKZRQgKaIONyFtXFTLnhH7pmAJGDprwe2LmgBeHuxDIsPp7W1jFfxwIV3gv+gwAhJEgwl/S/KAi9wnrMfgJ4+R2RSLFdWIqocCpbh1jE5aye/0Ryv6iTfSF+u74RdSTlbt0gimO1x/igPK7EOGtsX38Tr8aian+0kmOy+HlZmIq3laGpkpzFZeY3Dj72K6CDLJg2L7/cOiuHNZSWfV8IFsVDn8CySzL28Hj0zN0Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4vAmn0MjvMTA3KbhwTeJryU9i5NbSOfjPC0a3mXmDw=;
 b=ND4SyGm1h6r/JbyTfri962y13Me0SaTfnmbylEcibJl5jv2B49GoMQfst2pn3jE8e9XGpDltdRBN9xtWPYM3N3JQjqVT9cufRVrMsQRRXqpd3nXQpeW44lj3d2C9OFVsym8l6CvwljyyVsKJFVkXrRJ8LM5Jogf2W4y7E1Hbcuo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BYAPR10MB3190.namprd10.prod.outlook.com (2603:10b6:a03:14d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Thu, 22 Jul
 2021 00:38:19 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::51f7:787e:80e5:6434]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::51f7:787e:80e5:6434%4]) with mapi id 15.20.4331.034; Thu, 22 Jul 2021
 00:38:19 +0000
Subject: Re: [PATCH v3 04/14] mm/memremap: add ZONE_DEVICE support for
 compound pages
To: Joao Martins <joao.m.martins@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi
 <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-5-joao.m.martins@oracle.com>
 <CAPcyv4jwd_dzTH1H+cbiKqfK5=Xaa9JY=EVKHhPbjicVZA-URQ@mail.gmail.com>
 <d73793a8-7540-c473-0e30-0880341c2baf@oracle.com>
From: Jane Chu <jane.chu@oracle.com>
Organization: Oracle Corporation
Message-ID: <edf0358d-7ef6-d18e-a45d-f36449b116f5@oracle.com>
Date: Wed, 21 Jul 2021 17:38:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <d73793a8-7540-c473-0e30-0880341c2baf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR08CA0025.namprd08.prod.outlook.com
 (2603:10b6:208:239::30) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.70] (108.226.113.12) by MN2PR08CA0025.namprd08.prod.outlook.com (2603:10b6:208:239::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Thu, 22 Jul 2021 00:38:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07217991-6240-40ff-2578-08d94ca90069
X-MS-TrafficTypeDiagnostic: BYAPR10MB3190:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BYAPR10MB31907679959100F2078A38FBF3E49@BYAPR10MB3190.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	rtA1k5ARzjSzIkLLn/wZJF9Xx6WF7g7GEi52KaSTvpgFYB6b45wUQ8cCFqVIg6DboQ+X2nbypQl9gaFjRiNjTFrQMpku53UE0VW9oBBwMyqL7iidI8bbl4O8QKbq36Q6DV7ZEowV6HHcstPzEQdGXpq3RWueYaJYQkHT4e3G/bhcGDW1Z6I3kY5Q9BQ5Cm1BobrgVlOhFikJnZsyGaiE0RC+2zqaVkNJQE1hjUvspZe7RXYH7D/Fzu5CI2IiNJHBftB/XCjq6QUFJrYKwMfI61g5PbuvdCRRPMYj4WfCJgN2aNqPcMnqACMrN2dWe3aL/UOy//Blfz4/bVofHjdgGYjDFbsvFq3fbVA/+7W5t66OwBdPTvXEzuO3TFGFWsHP4/CRkVEQ3WAabYldYOauVnUSc8xu9oxPHVaQYQOvE4mKVewgiU7oa7xjUtpAWczS7Oe8gaZ9lLHpPHsTUJdNkf7z0+KCtSZSPMuvkdH0Ix61gdwpNMJALTVUdnH+LZSoNOS4iPARTTv0sao1FPgkkg//PdKqXI4gDeAi45iJWYIdM/1QbRO8nnd/6lHjNKHpcbWLkg98SWEH06XzKCy2vvClV1GQxKPyD7xM3pSGHIq0RwCrQDqtNfrd7KE95XQ6tPowDHVt+s7eFA5hwHh8lbhB51xA2TFnnxz8R7kxrNIBI4fQFqwoXuFptChHX8TWbDiGx2PYntiP3hz+AiiXASI3C9EP0OWnNuAvlDqtpY8=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(4326008)(36756003)(16576012)(8936002)(2906002)(6486002)(5660300002)(31686004)(2616005)(44832011)(956004)(66946007)(54906003)(53546011)(110136005)(316002)(26005)(8676002)(31696002)(478600001)(36916002)(86362001)(83380400001)(6666004)(38100700002)(66556008)(66476007)(7416002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?d3hHU2ZKVFhGaXd0ZW1FeHlUTVc3UHNqSG9aalhlZDFEVnVnamxZWWpJMkVa?=
 =?utf-8?B?NEFmWVFhc0dPU3RzS3dWdW1ESTZSS3R1Z2hOampXcVEyL2V0YUNMR0JSbHht?=
 =?utf-8?B?VjNma1B4YjlKTTlhQVhYdUNLdXpJM3oxSVQ0UEFUWjdaNkhRUjRDZXA0Zmg5?=
 =?utf-8?B?WG9vSEZDdi82MzNkV1dmOGluMW0vMWFqaENuL1JXVkdIa2p6eXkyakErSmVK?=
 =?utf-8?B?MlRHMExuRnQzWHhMZnBHM3NTcXdBd1diSExUcVVObDdHdnRPTmNzOG1qSU9U?=
 =?utf-8?B?NUZRUGpDSEl2d0xXSXpJc3hmUzluNDRYTVU3YzV1SHpKdFVIVi9YdFUrUmIw?=
 =?utf-8?B?d0R6UEw5ZXBTZnI2VVd5bkFJeG8zdm9aaHBzNTZ2QkR4dXA3S2VtaE5pZmto?=
 =?utf-8?B?K05SVWR3akZYMUdUNHJaQlFDdDVaR2NmQnhyd21yVlVjc216Tnpja0tTU2o5?=
 =?utf-8?B?U2hXbWFkYm5HTmNBWitlTmx2NlpUbFBZVUZpL21ocm0xdWpNTCtCVUx0MDVW?=
 =?utf-8?B?ZzY4cllvUUNNVlZXS0pwcDNoQ3ZKYUJlcEx3MVJJODFzcW9LenNCcU9IRUJK?=
 =?utf-8?B?b3EyTUlmSDE0a1ZMSm9YT2prYlpjVFZZUTdWMVRVak9KVkJ6eldQUERHSTVp?=
 =?utf-8?B?NGp2a21QVmsvVDV3SEFVN0pUTDFBdE9jT1NObkN6c3FBLy9wRmxraG1pdGoz?=
 =?utf-8?B?Y1lDUmR3NWEwM2tGSUxsWFJJV0VFdWpZR3NCa25DS0xjWEhaa29LNXJUMnp1?=
 =?utf-8?B?UUFMWFpXNmxVY1lzdno0WmpFNjB5M1QwdlZURExkZ2tkR2FvZDhKY21lMTdY?=
 =?utf-8?B?OER3Y0p4SGVGRVVkYkVoSzRNN2U0ZFlVUVNuVC9BQ1VHMlI3MVdyd2hyZVlM?=
 =?utf-8?B?TWtCVkdEblcwcERPTkFYTjRBZFBkZEt6bHdLRHZuVVB1WnFVR0g1Q3ZoSFJt?=
 =?utf-8?B?Y3hnT3BiWFgxM3RVTHlqSlI1ZUxhZWROSE1sa20zY3FTeXZEWWRCcXk2anJI?=
 =?utf-8?B?blhMemFpdllWTENXL1A2cjVIeWhwSzQwWEVJZUc4NlRtTDJIVmt4MTJaTVFl?=
 =?utf-8?B?WDRnRWgvUmFGaFJQOE9zb3pEYTExRDFYT0k3V1ptWUhUU2o4cjlqdS9QNE1W?=
 =?utf-8?B?OHdNaW9mQ0tHbjNveHlIM1pkcnFqYmlHRld0LzdJMm5lREFqM0puVzg1Z1J0?=
 =?utf-8?B?b3N2S1Zwa2xhUFBaZDE1M3RjNks0NFJwM1RBWGVTNTVzOWUyTEJ0R2RrRVZK?=
 =?utf-8?B?cEV0Uk9CZ2Z2WmRwMnIwN0JLb1JNc2hLS3ZKM290K01kL3pxK0owVjlMbk5F?=
 =?utf-8?B?d3JmalV0dHJWZHd5MDFhSGFpZ3FPMWhWTkJCUTQ0NjJOYVVKalZubDI2eEdy?=
 =?utf-8?B?dW90QTdpWVNFUTkvRnpLNDNsVS9CMzMyMys5QzVUR1pNZVNMdWJlSXAxTlBN?=
 =?utf-8?B?NTcra0syaVhza3NtZ1Zia1RuZ2tWR2lWMzY5UFRqWmt1MHhZcnN5UXIwNUo1?=
 =?utf-8?B?L3lzRk1lQUp4YVEvbzRWYmJJb09yakVBZ09RQW81N3hUMzBCTUQwQWZpWUx1?=
 =?utf-8?B?d1ZHRWY3UWNRQ3FRSXJjU3czeEFndlgwUEpWemQ4azRhWjNhWnNvVVNES2dq?=
 =?utf-8?B?Y1dodHJXMzN6WU5JRUVqVDFsaVVZejc1dThqeHJvTE1wVmNLUkR6VTVCSG1p?=
 =?utf-8?B?NTdBU0F4ck93Nmx3WGd3dG5nTS93Y21SRHhtL1ZwQXU0aWhiTU9kcTZ2cXE0?=
 =?utf-8?Q?UNr5nsmIgdwOoEMgOosSj0kRo4iPC4gg6WYDX06?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07217991-6240-40ff-2578-08d94ca90069
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 00:38:19.5057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Agpdh0UHnv2SekeR1BfTQvrabH4qsqj3p4IRg3uQ0uusdnoz+E/rBXPC+fwVXN4kvBBJp543hQR3mw3VuI59MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3190
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10052 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107220001
X-Proofpoint-GUID: lSJoKGhM6zn6oVPR3tBoHph26WRp1lRz
X-Proofpoint-ORIG-GUID: lSJoKGhM6zn6oVPR3tBoHph26WRp1lRz


On 7/15/2021 5:52 AM, Joao Martins wrote:
>>> +               __init_zone_device_page(page + i, pfn + i, zone_idx,
>>> +                                       nid, pgmap);
>>> +               prep_compound_tail(page, i);
>>> +
>>> +               /*
>>> +                * The first and second tail pages need to
>>> +                * initialized first, hence the head page is
>>> +                * prepared last.
>> I'd change this comment to say why rather than restate what can be
>> gleaned from the code. It's actually not clear to me why this order is
>> necessary.
>>
> So the first tail page stores mapcount_ptr and compound order, and the
> second tail page stores pincount_ptr. prep_compound_head() does this:
> 
> 	set_compound_order(page, order);
> 	atomic_set(compound_mapcount_ptr(page), -1);
> 	if (hpage_pincount_available(page))
> 		atomic_set(compound_pincount_ptr(page), 0);
> 
> So we need those tail pages initialized first prior to initializing the head.
> 
> I can expand the comment above to make it clear why we need first and second tail pages.
> 

Perhaps just say
   The reason prep_compound_head() is called after the 1st and 2nd tail
   pages have been initialized is: so it overwrites some of the tail page
   fields setup by __init_zone_device_page(), rather than the other way 
around.
?

thanks,
-jane
