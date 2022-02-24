Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90A1185D
	for <nvdimm@lists.linux.dev>; Thu, 24 Feb 2022 10:39:56 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21O7iFjJ025415;
	Thu, 24 Feb 2022 10:39:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=oCkZN+LtvltPb4IvVhsgppfBJilX/8iGHflhlPR+VGA=;
 b=ml7hti4iF0Zhr7YJnX0qgcfQcyQE14Yj/2Bk4vF1ioWLbe07bcM17dyuQLU37alG+0JJ
 +R3LNc0YCJInE49geXjwexDvdMER5oe3BtSGDcP+UqMWWHd6gx5PE1DuYCxWjdkpiWHu
 dHM2Lf7ieCRv1qUOCh8KmtCBYEMv7w7jka564GTwGx1vgTOoO/ycLULBj8bG419hwfvZ
 1sErffLp0EDhY5sVQ4pBlbkvS+cPLvGzj6ZVQwJX2p78OpYjPVjNeXuRf9fqdHKCmSXN
 FfBh9RPQFbRqRdqdRIH6zkKxa/vfImi8q5LJJ/Lo6pAvWYF+OgDbhHMdIdkJu9tk9FOg fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ectsx71dk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Feb 2022 10:39:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OAbDpp010656;
	Thu, 24 Feb 2022 10:39:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by aserp3030.oracle.com with ESMTP id 3eapkjwmax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Feb 2022 10:39:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYjwgwAZupmo6vwf/9PpLaOq4NJShOU7h5eP7IlgGUvrXl7Wv4Vys1soPTOO+Xuk672dJyvpdiuztb/7x/YvP/4ID+rRVYCEI6as4dpvwLgEyg/E0EIVmdbeYlsBhE4JTzGu4Od5etJY/4QO70fWtNgIHLLsgJwpzNjmkE63IHHCQtK1e5QhZOuUThIhJLrPteCHsLAha3xpGLy/pVl9cwaHuhgkuIzqA8NuRiuhF4j0/nx15OLEUXrl0rR/r78hKTiRD9uP42lTn6kzId3QTE3WtHwnb9h5XnoR1MLJBv46Ba4u86iQP5zMCFPTClpUvQEx6vJNgxEyGRdpUhqrTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oCkZN+LtvltPb4IvVhsgppfBJilX/8iGHflhlPR+VGA=;
 b=D4y6syXg5nOxdmgBzF+fmnT7zd9O5ku72CgW5VMo/LbLsF8fsbEpFw9ULX9IhCGD+pPwbfgNhDqSQ6kCXWmg0CwH5myxBBIJ6Jvu092GHRo7dUhcFMy634uyE48SpAmGgeg6bmdmHP+t+sBz8yTSxxiJcqkqfFvlZLHE7bcOH7bhZA95BFEomf4oztR9Qg2cXS2o96I6ipzCMZHECO60NZXprZlOwCfC9wTCpBXCh/cg+f6cKWMcX8heq9U/aMhSffYlJ6RgHbkoXyPUdtegj44VlsSg10K7QGg/euxm54WcI7orMcJGAN2ELqlu9Q360H7/dBP4lJnLvjl0DCrWgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCkZN+LtvltPb4IvVhsgppfBJilX/8iGHflhlPR+VGA=;
 b=D5kAA1qwTW3p3OVPxRJjScHlJ2C0inB6NQaVD/N/njxlthUIHbc6j9tJ6WchRxVQjjE0mT701Epu9gFZMOcs23Rt7UJwpZbtYOFJpTnDQpCCLSwTu2RBPmZOvacMAsqWfBhV4ArBj6ffB/8+8x4c8LHdaIbFPItgiYylKClqy74=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SJ0PR10MB4446.namprd10.prod.outlook.com (2603:10b6:a03:2d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 10:39:46 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 10:39:46 +0000
Message-ID: <3498d8cd-47b1-e53b-96e2-9a76f19654c2@oracle.com>
Date: Thu, 24 Feb 2022 10:39:39 +0000
Subject: Re: [PATCH v6 2/5] mm/sparse-vmemmap: refactor core of
 vmemmap_populate_basepages() to helper
Content-Language: en-US
To: Muchun Song <songmuchun@bytedance.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Matthew Wilcox
 <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20220223194807.12070-1-joao.m.martins@oracle.com>
 <20220223194807.12070-3-joao.m.martins@oracle.com>
 <CAMZfGtVD6XyjqrQ4RpDDPOSZCgo1NHXbfjeRwqi2KmUckW-6xA@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CAMZfGtVD6XyjqrQ4RpDDPOSZCgo1NHXbfjeRwqi2KmUckW-6xA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0103.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55420203-0ec9-4973-458e-08d9f781f9ef
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4446:EE_
X-Microsoft-Antispam-PRVS: 
	<SJ0PR10MB44466109DA4DD0CC004927E1BB3D9@SJ0PR10MB4446.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	JAfU1bqUa5faeh0FEMsb6nJBXLlxnUGYKEv5Fk5bM5haCxPSF0dStJRgD4+pmtZ1TOTlAeR2DHgowqBG5hPiyld/e+kDhO/ikL24O8gNsCCPbzMjdivxj/uTEiQjwziLZnXU6LFpSnTg3iNKk6+ELOhpfJ7Quq2pm1izeVwfsTh9EvfbRMlJEkR5qaOjr/sqwXiJ/bEIQTdeBJqoT7s7GrRicfMW3Nv+F8ASPGFJpfI4DFT85DHnShCubh11N7EDoJSgXj/1C8ANODIQnP8DVZzPIPJS1a6O6K2njOd9GigmUuoauX2qlS7LK16TsjTQXoKXo901JRH/2W6nFeqaZvuBnnfy00ks76404VMcjoO5Y6fbI+QnRw+bm4A0Xfcg/H5oBP20iSzONT3vBQApWdB+Jcz5RWz3XE64ZcrBVnKoEVYhgWpfvFRaxfEowO+XDcYVYp12AjDJIlSGe9Ayp4b5GoGlrWLk8C2vwVGTquYYN3oXYFmIlniLbildXltlNxXeKnJCGFXwnA6ChWVtlCmG/ecODsdSFo+NQT5hsysUox4oKk/MdaMeFOZ4A1hEwOL4cOIa0kyP3Gf3WBDOldNi2QyZCZCj1f09XXzz38xaintqkBU1Rct95o63f8UbM8rRx5LPtzfIeeX/fYKGCUDew21ekkVKYgho7WCBCHHyKCSsGTohT8r00wis1pv55hlMt9FQWExcLtdXeK3qCg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(86362001)(508600001)(31686004)(6486002)(6916009)(38100700002)(2616005)(2906002)(54906003)(36756003)(7416002)(6506007)(8936002)(316002)(4744005)(6512007)(5660300002)(53546011)(66946007)(66556008)(66476007)(4326008)(186003)(26005)(6666004)(8676002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SGpRWEN1VkZUYWZYQzNyc051Y2hVbHFNc0UrYW1xVm90eHFTdy9Wd3I5WDZa?=
 =?utf-8?B?d2JESGR0emFxM3BiTzRIZVFWOFpuOWFOd29pZWZydUtnbUp3R0tBTWxNU0I5?=
 =?utf-8?B?TjVzRWNoSEdkNHNaa1diT0J3WWxSWkp2UnpOZnBMVVNpNjQrR1ptSEk5TFVM?=
 =?utf-8?B?M3hTOW9idzJ4Z1JqdnNuSlF3RVRaa3BQbktGSUw5RmFJVEZKUnJWdkFucjdx?=
 =?utf-8?B?bmkrUmltd1RkQkVyV3pJVXpnaVNWczM2K0M5dFJCMDhnOVZSZVNzTyt5clBz?=
 =?utf-8?B?ZjRUMEgvcWFsZlFMQ0x4MW9DTVVqLzkxbWVzOHl6Vkl1a0Z4cmI5TTBEOVJU?=
 =?utf-8?B?WElPZ2Rlbmhrd2FxQndDdEVSTmNac0YrWXprWk1pZjBZblRiUENaZ1JTd28r?=
 =?utf-8?B?YWNlM0V3WlEwU1g1L0thM3JFRHVQQ1I0Ty9IMXlIQ0l6ZlE3WWJOY3U4MUZy?=
 =?utf-8?B?WEhLVFd2cW8xSXhJQTNzV1owMjlYZUs0TXVuS1ZFcWVuUFBKY0hGdHR4M25p?=
 =?utf-8?B?TlpQb1hoKzRSRFFsSlYrUUFpR1hXenJTeWQ3aHVzM2hrZ0RrM1k0NlVnMkpl?=
 =?utf-8?B?UmtpaytScjlEc2t6S0hPSFdkTkVZcVFNSUZpMmxnTXN6eEJSdWZVRzllZEFC?=
 =?utf-8?B?VkVCUWx4Y200YTlrSExHb3U0QSs2cUlGTVRrekcrNG5EZTNCL2c4a1JTKy9G?=
 =?utf-8?B?cGR2b1p6ZWU3dWFlVXVvVEtwaHNiWkUxZFBhdHQ2WHdwQkJ3Mk9nVEQ2elY0?=
 =?utf-8?B?WVBGMDdlVEZWR2ZwV1RlVFd4enFVYzhFcmgySWplb3R3K1g1WFI1WVgxakVI?=
 =?utf-8?B?dlo4UXBaWVdMUStCbUhvbHN0dG9zVW9tMXFtOC9sLy9wTC9BTGt3TDBaT21H?=
 =?utf-8?B?blArb283d1Z4YWZmYmlEQXJEeXVINUlLK0QvVVROYU9uWVdHWkZyQjFzdWFi?=
 =?utf-8?B?anJCNU5jTGtlZ0lHSVJuWHBRSTIxYlYxVWhNUVpWem9aVmZPc0tVZThOT3FZ?=
 =?utf-8?B?VlFuR2JtSm9GR1VVR1ZRYmU1WEo0bHNxU3dwUk8xbmUxYTMydGU3S01INVVu?=
 =?utf-8?B?Mm9WUUpXejVDYlNkSXdZRFluZ2dhdkI1aDVxc29uVmZNbmFMV3hyelorcVp2?=
 =?utf-8?B?SjhreUVxa1VXZVV4MHBIYnhWL251bFZaaWhyQ2xBNWFJUnVBZHNtR0dkbEFk?=
 =?utf-8?B?bzI0MHB0cnJtSTdibFVGa3FhVzQ5SGkreXE0RjY0SnZGU1g0VWFROTNiYngw?=
 =?utf-8?B?UjE3Mk8xcTduR0ljN3ppRU1LcTc2eVdvS1IvOEE0dnhkdDB0V0Zzbm1pM2Uv?=
 =?utf-8?B?Yzc3MmU4QXAwOVd2Y1o2VVN3dTk1MGp3UlRST0JYbG1MWUwrWHE4Q0toa3Nj?=
 =?utf-8?B?VGd2YlRFdkdZSWpXWlZ2TFlCK1g5QmMyOWV1a0JaLzlFRUViY0pMaG16WVRB?=
 =?utf-8?B?aGw3UW1IYmFMVDFLSVhiTkcxNVJ6QU9sQTJkZ1FNREl6TlRkRGdtWUhyN0RM?=
 =?utf-8?B?RCt1TUMxcUVQbkNybkdLK0FpcmZJT2FZMHdzOW9TWm1TVU1md2FFWVY2MC9w?=
 =?utf-8?B?Ry96bDZFdjYzRy9BQzkvVHRIY1EvejJFVHJMNUtmckxvcmdlbisyQy9OSGRh?=
 =?utf-8?B?dW5GMG8xL0JxemtUVkg5Qm5ZVUd4L21mZmN3ak5QWFRGY1BGakdiKy9GNkVZ?=
 =?utf-8?B?UmZJejZVTklIZmxGMU85a1R1eXFDOTZnM29YWXJTNytMK1NjUWZiTnBLU3BM?=
 =?utf-8?B?bVFIeE1IMmZEc09QZlBzZ3JMTFhTUHR5ZDRUUktiaGN5VnhVRitZVDVYZTg2?=
 =?utf-8?B?S1hKdkVwS0VzYWFnQTNtTEtBc0Z2RGRaYWVrR2R5SVZTSmVKSk1SVXk2MGRu?=
 =?utf-8?B?S0pRclhuY0dDb25qQlBWU0RTT0ZNZmova0c4YmUrcFlhOTBueVJIbUpQUkxR?=
 =?utf-8?B?NzlvaElTYVk2QWtDTVplNUgyV25DdXpIaHc4Mm96R0pTam1tUldpYXBSc1Nt?=
 =?utf-8?B?eWduUDR0TVZhdWNCcTB2cnhiWUpWTUtocUpNaHh6VHduU0l5RWNVWEFYTlBO?=
 =?utf-8?B?SldRaWgrUWZOUkYwb24xWnJaRkZpbzVKUm02NTE3QUxTa01vQnFHQm1RS1hr?=
 =?utf-8?B?d0U2R0oycU1LUUxicFhqY3dHbDNsc250MitZUGFMdVlhU1hjK0E3S1dxT3pm?=
 =?utf-8?B?eFRFa1pJaEpVTDVZVVNUSVpKcmdsNzZST05hRFp6ajJpRjJIazdhZ2FFM3FX?=
 =?utf-8?Q?hcAMzFZzvlZpcfDepunopGxXAV9O/32/RvykL4542w=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55420203-0ec9-4973-458e-08d9f781f9ef
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 10:39:46.7404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3V25cEJQd2LxDSVrTCIl0U3TpkaPKv8zghyYFxZC+N3ZXh1U8EfxxytPeFO1TM5p0kepm29nqDB9XyN1525iZKZQUu6XtZA+ndVIMaUKXuY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4446
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240062
X-Proofpoint-ORIG-GUID: z5bSc3er1I9IwVaMO3WiwifFJHD-VdjD
X-Proofpoint-GUID: z5bSc3er1I9IwVaMO3WiwifFJHD-VdjD

On 2/24/22 03:10, Muchun Song wrote:
> On Thu, Feb 24, 2022 at 3:48 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> In preparation for describing a memmap with compound pages, move the
>> actual pte population logic into a separate function
>> vmemmap_populate_address() and have vmemmap_populate_basepages() walk
>> through all base pages it needs to populate.
>>
>> While doing that, change the helper to use a pte_t* as return value,
>> rather than an hardcoded errno of 0 or -ENOMEM.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> 
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>

I've added this one too, thanks for the thorough review!

