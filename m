Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD4E68
	for <nvdimm@lists.linux.dev>; Mon, 15 Nov 2021 11:00:39 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFAEDw9001661;
	Mon, 15 Nov 2021 11:00:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=WV4BTkfamWlMCJqVzCebM595rwbCSKi2qu2jQw8Y9zI=;
 b=ATVDfuwvKfrAjiCbgILanaVFMowdfv1PWRh1NKcJnZqwSDOOD+vZCmUGI803C1wkLMIH
 +M3U5eiXx9boQHAcpeQT23lqt3aGKZUVCS4rfforfJTRD1UVeksRh3GpDgz3TjVS7EbW
 4Buys4LFeSFHEl0yJ7prBh2intsUgHQVw5bP2UvCPqOcmpCQrtlVcIWyIgC3DHu1x539
 im/a6Eru9G6IuoZdPI0aQxheeEdssWhN2xe9++1rsDGTOL0bklIqRk+JYrHEbfaFVXnM
 PbV5ucSNHKL3nOu3n718Zm0cSuc3Sq8c79lJbvjmQrSGieJIZ/69aoFagZH5rW3HSGX3 4Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cbhv7sdqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Nov 2021 11:00:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AFAuLIY015423;
	Mon, 15 Nov 2021 11:00:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
	by aserp3030.oracle.com with ESMTP id 3ca3de7amh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Nov 2021 11:00:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNbgtixxuOAgenbz+up0WyJDJzJSVDGiXL1kn0G9WP7UQa6t5dVz5Zsh6fotCUNolMbt9BQ/53Yoyev26qprD/PYxwBAK89YSIMBAqYIsZUOQv8huQ8U4OWqFGcUX8WSsIjEFAiZZUBwuYiFuK7hCeTn/n9lhDHa4P3hWNl03QFv4xlNeN787Tyzam5uHAsqOx0wqPs9VlUiIPRoWQ9rCz+X3r0wloEn0P+l9KEk8fOvY0La4Amr55a2p7y3BmTnUlu5w93LOZESMj4jOuQyImgTx8XaPPpm5vw3GORdtAc0D29DQl0sJJrViYizrTn8SkTOeknPvWEtShESNprsfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WV4BTkfamWlMCJqVzCebM595rwbCSKi2qu2jQw8Y9zI=;
 b=WIuPkpnfpKap+LxlruAIBHlubr1kXPAYlD2WE75sEkKpc0NVsGCferkWaPAiW1X0MjcHt6+GCn2baHz45Kj/PO9OX12OkADe0MhkA1FopQ09WRjh5mXAdwhOBjrENZFagdbPGLF/Q1YhaiQMGcHzF354hufxSdFB1SXMyNQU5YzYb8zRwYKpGhB9vGLf8rVvsE3oyYWwgp2Qtr87mjblUepuqeIzeIwAmAXFnThRoqQV0dQQ8XxxtZt1bxWJscP8ASMFK+eTKpjogsphQZNK9Io8S2gyVcjFd++uxbDmEkhzjTRXXUxaMU+ViGAUiSl3Sx7S8F3A/NkjdEzbL8XUNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WV4BTkfamWlMCJqVzCebM595rwbCSKi2qu2jQw8Y9zI=;
 b=HaHnCrsSJw/uicLfkZd4xAqGjTchzbgzaALo0VSN4NutNX6yvGSkVPVe5btDnndosgAA3n/FIvEt7293rSRmIZ7qPdllkK10NevL2PrkRTh1ijkt+9HOe0SXAc/9HWt0VcL/zbIsUJUdsl1za31mU2mZAF2yglpKuqbcN5eYU7c=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5106.namprd10.prod.outlook.com (2603:10b6:208:30c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.20; Mon, 15 Nov
 2021 11:00:17 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 11:00:17 +0000
Message-ID: <9acd8dc6-cab5-de72-e79e-f99a36f3c8c2@oracle.com>
Date: Mon, 15 Nov 2021 12:00:09 +0100
Subject: Re: [PATCH v5 0/8] mm, dax: Introduce compound pages in devmap
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
References: <20211112150824.11028-1-joao.m.martins@oracle.com>
 <20211112154013.GE876299@ziepe.ca>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211112154013.GE876299@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0332.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::13) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.31.208] (138.3.203.16) by LO4P123CA0332.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 11:00:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 772af68c-a2a4-4250-9163-08d9a8271b45
X-MS-TrafficTypeDiagnostic: BLAPR10MB5106:
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5106E960D8006D47FD22DB61BB989@BLAPR10MB5106.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	5zUwWLA+WvXNoZ1590iL/pAW2GaY/o7XDhx7XppsVrOD+qqNCfMuVzbmXyM5SowUQMYYWXS6etydKYXJifIgRBxFtoQymMEvtDyQCMco8qhpYA1WwWE87pgSCW+honw3wCSI34E2ltcHKPUTPrabNPr3n6Yp/DzG7gzHdMAVW8ZyXXUlU449IGfVdnvyHfk4RZu9tBERv30EUxuAjIx5Yqx8zCbf/T33+dsy4nsaWmRh9NMBtZXF4bb61iSaxVvEjzfAiTEb26ljyCG7NNoT7uu6+X/RI/R4MiZ0utcRgSJ4Nvs11FLWyb0oIe6V5NC3lNvfBTHCZNdNv5OSKO0ATUTm4JBiUDE04iNztX+y6JY+dte7zQUHO54JWV+Ha8Hxpn4EEWYxquL6nwMSnxJfq6wtHaPrGWrpt+FABlBr8Bf1yOHD0JGsXwufS+2HLneBHeqQptFz5aaxvrvzayDUGEAiiU+EGlP8X2eiv0h7YGuHfh7Sz3GFppNQS7zilofJN5XMgHAjqsYFEikxhqXJE15r7ue7BwFHbJeGvWkJqcWeed7jm2TH+O8MVy2hGcsQa3kQl2Pw0Nc2nr8xIo67bAGuC1+iIBAS9jRSmnIwnJjkaUjgX3Le1+86JgWahZA2g/pFKuSlo4kJFjnBu+lImD3WtU9MwHztRSGsdhO9MD5mQ5nxAM+R+CcSJIR9EMtIYJ+IPH11rHnItZXjQol83A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(6486002)(16576012)(316002)(186003)(508600001)(66476007)(66556008)(26005)(4744005)(2616005)(956004)(2906002)(53546011)(36756003)(6666004)(4326008)(6916009)(38100700002)(8936002)(83380400001)(31686004)(31696002)(8676002)(7416002)(5660300002)(66946007)(86362001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OVVxQVVFam9hRTZqZXZLdWhMdE5wRTc1SnZ2Z2lUNHM4WmFiUVp0Q2Q3Z05h?=
 =?utf-8?B?ejZvMy9kdHZmcjJxZjMrVnJ0RVY4OVVBWDk5eldlNEg3cDR1YjV0MHhVZ0tU?=
 =?utf-8?B?SkdsQ3ErWEFUVlR0SU9Rei9xSjUrbWNPa2NYeFluL3ZSdUtvWGQ2VHZWejE3?=
 =?utf-8?B?Rzh1OTlTZjZxQ3FCNXlFcmMxa2Fqc24vZU5ON0JaUjAySGFWUnAxWkt1d1F0?=
 =?utf-8?B?bUgyRUVGOHg5aFRzY3pSejlnWXBXbGY1TlY3WVFZY0h2UElGRTNkSWpVekUv?=
 =?utf-8?B?eXNNSEh2R2I1SFNTYjJZbXorTENmem8raWcvU2lLMWhYMzEzUDVEdjZic282?=
 =?utf-8?B?bWVRQVhaQTRoSE5wR0tCdXRjU3pzZmVHVkhQQndiVkRaZHJSUlloU0hwOHZI?=
 =?utf-8?B?emw1bThJb2ZwbnhGWlhXLytDVU8vQTVPM083b0d1YW8zdVVtQ1BaRk9Bb3A4?=
 =?utf-8?B?ZWhtNitoMlhMUmNzZnloQnFTcExCVVdlTmNZa2JNQTlVL2N4M0UwWVkvR1hW?=
 =?utf-8?B?N25hMXpUWCs0MisrUTNMRlpoeTJkOEpteDhkTmhUUWRXdVRUT2s4c0RGNFds?=
 =?utf-8?B?M0tpWTFTaGEyTEdCQThKU2hQbStZRFdoWTVMRmNVTUc5YjdnZVNTS0puSUJD?=
 =?utf-8?B?RC8wMmM0em01d2ZIOXpjTU9JeHhrZ2t0MC96Mml5NS9rZGg4WlExN2JyOUtM?=
 =?utf-8?B?c3VBbjREOTNYdXovQzlLRzg1VWU5Vk9TYTk4anRMVFNCSkxrTStiY3ZmbkV4?=
 =?utf-8?B?MkJRalIydTNXcUpWeTNqSnUrdHV0dmRIdGJVU3RmNXhiSTNDVUlnREFRVmZO?=
 =?utf-8?B?S0ZXQlVaUk1XM1ZlTng3U3MwQ3FxaVNJWnJqRkRDWEo4WXhIb0RiaWZXNktG?=
 =?utf-8?B?RWpGY3VGRG5ZdlB2QkV5eGZlNUpOcTFJUVFlSUNPeUh6M0o4ZlFUdFl0M0wy?=
 =?utf-8?B?QUZDNEozSVVIOXkzUzVLUkRFanYxYmt0QWx5MkV6YlFrWjF3a3ZjaEtiVGRZ?=
 =?utf-8?B?cVZTRktPNDlrNkV3V0ExeFpQamk5aFoyRStLQlBLNElJdnJTZ0duNFJnRGxJ?=
 =?utf-8?B?algvWWx3ZjRRMlNwY2NidWJoYmhwUjlrYk9WT21lSG0rYmRHUHk5Y1ZuUHJW?=
 =?utf-8?B?bWNWSUpOdWFJR3MvR0JnUzFDZDFONVltWGRneFgxeWZTZ05vQkwyaUhRWWRW?=
 =?utf-8?B?YlVuK3pUcW45d0JPRWE0UGk2L09DVUZCRUh4VHVBZXpGSkMvcmdpRVpNV2tE?=
 =?utf-8?B?TjJwcmFtN1l0OHVlNm5lNGV6TTJkYWtYdUt6NWY3NXBUR2VHbUJ6cE5ENkNO?=
 =?utf-8?B?Tkg4T2JENGMrQWFzb0JVUUljTFpYK3RSdmU0cHNQYzN6aDdBMnhiV0d3TDBC?=
 =?utf-8?B?dVVuVmprMmtaU3VNZDlSVSs4SnFFTmNYb0dGcXBoeU1WNGE1bkhMMmdUMWlR?=
 =?utf-8?B?Ky82Z1FNdXplNmk3cFJoMm1VQnBQRWVoakFlcWh3dTd5OGhyNUpVekZUSEZP?=
 =?utf-8?B?K29kZUQ1Mkp4SjRsUldDUWljQStoTWtRWSt0V25CZzVsWFR3L1gxYU8wN2Jq?=
 =?utf-8?B?Q24wUUVWMnVwWDZ1VFcyaVBmSkh0MlhZNi9XdXlMRkI4TnBGeFBUdG43QVl2?=
 =?utf-8?B?eXJnK3VqcVpqbE9HVkxHOW13dE1qWUJqM1hPQXNsd3FPZTRka2dsUmxXN1Fy?=
 =?utf-8?B?NXRBVk9YNTdqL1o3YnIvL2NoTHY2NWordlVpSitNU2R1OUNMUDZNaUpDSHZX?=
 =?utf-8?B?MzFZdzNNa1BMeE9tNk41bTZOWVo0dDVlUHZXdTZJQ3ArdHV1SzJSeUZvZXlI?=
 =?utf-8?B?dFEreGFsQnQyT013bmVzVjRGZTVRRVVkZDA4WFY1K2FvWjY0dkZtK1pacElY?=
 =?utf-8?B?WVdqV3R1c1Bvb1FkT0xJTVVDK3ZmOTZEL2pjam9rVkZNV3lmR0pLSXp4K2Ju?=
 =?utf-8?B?V3JQR2xicmZ6WDRCY2ZzNkdQbkRIUUU2bURUcFlhTE1UcXN5NnZ2ZDJaci9G?=
 =?utf-8?B?RmFtOHV3ZUxrdXhkendnOXAzcDZTWWJuditZMVU0ZVhpV3RWcjBGT3ozeDRE?=
 =?utf-8?B?Y0hYa1ZqSVA3RU9XclY0NVFPSkxnR0tVbzJ6ZlNVaVpSNGxpRkJDTWhsdkRt?=
 =?utf-8?B?OWlrUHNqU0xyaUw2VlVNYXJLSGZjNGRlM0VsdkNLbm9BdVFDUEIyZitpSTg2?=
 =?utf-8?B?eE15azAyUG9KbTRWQ3REalA3YUY2d01oZ3l5NUhYR1dqNkRhdktyN29XNHJ5?=
 =?utf-8?B?Y25LV29zY3Rkb3ZrenVUTlBZRVdnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 772af68c-a2a4-4250-9163-08d9a8271b45
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 11:00:16.9587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B2z0jgbsaTe/UVkCPWyZs8sFrSYWaHCUrtTZsk1DqenQ/pbWr4meu/i0WyrlqgfhbVPo6QRpxV87WBnJwO28lEDgqMbzsggv/an7Xliyu40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5106
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10168 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111150060
X-Proofpoint-GUID: E6rAlVcPkQsIX3H-SqqP8z7YQNblbJcS
X-Proofpoint-ORIG-GUID: E6rAlVcPkQsIX3H-SqqP8z7YQNblbJcS

On 11/12/21 16:40, Jason Gunthorpe wrote:
> On Fri, Nov 12, 2021 at 04:08:16PM +0100, Joao Martins wrote:
> 
>> This series converts device-dax to use compound pages, and moves away from the
>> 'struct page per basepage on PMD/PUD' that is done today. Doing so, unlocks a
>> few noticeable improvements on unpin_user_pages() and makes device-dax+altmap case
>> 4x times faster in pinning (numbers below and in last patch).
> 
> I like it - aside from performance this series is important to clean
> up the ZONE_DEVICE refcounting mess as it means that only fsdax will
> be installing tail pages as PMD entries.
> 
Yes, indeed. I should have emphasized that more in the cover letter.

Will fix for v6 (if there's a new respin).

> Thanks,
> Jason
> 
