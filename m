Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8332CA6
	for <nvdimm@lists.linux.dev>; Thu,  2 Dec 2021 20:45:07 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KOd3v015238;
	Thu, 2 Dec 2021 20:44:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=YwRxSJdxis6MrERDUkUw4odhdlwH61VTQ2QCCEmIjPM=;
 b=UbdidR0pElNNT5PVqYXYnmtHg0C3JMQ1/KZPK3ZvObIOYztQZP2XiZ8qzJPvA78J0mP1
 sk9zH0g7LGeT9+m3PV5/FejGot22iIrPTSChBRrP8/PJGQh1WfKL6WqY3IoM5ZC5emmN
 Y7EXHfRkEs4dUcLXxmokHjJzPIlqW+3EoHQQ18qYm0H37bhquvmFdLape721lbHD4B51
 gMee7/eipAvld0Yl5M4LarVtnctTCYeCK3QR0iwbgWDO7D0cglUzxTF5YSH9n+GIFCba
 OXLx92+aQI2pbJuHRurf4zthuLnOYHAqwdT93QM0xEHB2qxDuG9h4k+8xccGzK6r60g0 Sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cp7t1twvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:44:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KeYlQ048465;
	Thu, 2 Dec 2021 20:44:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
	by userp3020.oracle.com with ESMTP id 3cke4uwyhe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Dec 2021 20:44:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8ZsC5e4F3SBojbUnST8fvkjOiIZ7XeDwQStxM4ozjy3b8jO1BWDVesUjhMh6MhZZrJu3wOMnEsefWQpw+n4Xeapgp8DbNa7wjMuiHuK9P2UtNVoLKYZx7H15cxxk+lp2R5uWcHUaW0JWbLtl2zTikOgXPexWHFn1a61G9s7ZK6N9GbzAPiLlH9aFfuANMUdAn9y6993dkhJbUq+G7NmssNGu/+qmf9/JmErALf8ZeZoTb143wxf/vzVZmOlsUiTqsgXlmtNkLzBpo3hXTAPl6ZbFdazPihx69EB23yucmjoLQUgNJkt14UCq7lBp6Cd5DvFkcphZ0kRRn6/2ChTLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YwRxSJdxis6MrERDUkUw4odhdlwH61VTQ2QCCEmIjPM=;
 b=SSM2PFwhgE+Ddf8uA94gRu7Hqb8FDt0VPboF4g/D+T7IhCYf1DbGm73mR+CHsmNWlQY+R8SvltywPcZ3fgp18vFLaJ/Q4i78AJiqWrPsgUnoOIMox2LfmKo80u3MkFoaFlIMZWCwnsuClKxaBljott5lVv5ryu3Gv+WP9O9C+IvfUb+RKn3X6F2SS6FQqFPnxlJrzQBOZZ8sCKju8NjuYfpvKnpIdLmVQ3tZT0W9K6Da2r3BMw/ZZBeQn3wc5vyru67i6Pk6w5qKdavQQl/awPVBuHqb0c7SN5fY5Suehw6qw1VWuPiTEkuJs8Yf/XoZDxr6QT1vWNPApVQnl8VXMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwRxSJdxis6MrERDUkUw4odhdlwH61VTQ2QCCEmIjPM=;
 b=wrOsB5Oy+w0L8HcHV2LDGlLM/hcyf18JQtZDcb7b31zJgL7LZdS5n04pLK9Vz7zMBlOAY1Kjssxbpn3tOe+fqQNlK2bWZsPA8LjtjuT7AfzDqUK0/YkFUtKyxNuO/Rd+O7SkYTG+qOlhVjBdeaPD6mssrtV0Xb2Vr2RKxryrozA=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4303.namprd10.prod.outlook.com (2603:10b6:208:1d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.28; Thu, 2 Dec
 2021 20:44:38 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::693f:564:30a5:2b09%5]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 20:44:38 +0000
From: Joao Martins <joao.m.martins@oracle.com>
To: linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v7 00/11] mm, device-dax: Introduce compound pages in devmap
Date: Thu,  2 Dec 2021 20:44:11 +0000
Message-Id: <20211202204422.26777-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::29) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from paddy.uk.oracle.com (138.3.204.24) by AM0PR10CA0049.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4755.16 via Frontend Transport; Thu, 2 Dec 2021 20:44:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6dc5e78e-766c-40c4-d25e-08d9b5d48e88
X-MS-TrafficTypeDiagnostic: MN2PR10MB4303:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4303CC962A2BBB47F4DC8BB8BB699@MN2PR10MB4303.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	+8t0q9eiqfiwNPnrCvzdcJytMYWn8HT50+W3VUSn/tw4XDX++BE2PvhXtv9z9iJVif65fqQzVA9u8V9ng9gPOxTP0rf8D5TIQwrYR/rwuHIdrdjI657yWkKhBwQ1HV44fPZ+ofUz/lwBghow9x+cQqVt3Aop294RRStdsrixXfZsQ9L3ipjPJOmkDycHMo+22bd+IwzqbHxeu7Vfqj1xOPNheark+nhzihuCihefbb5dz55MvTW4RJ3MtCZ3ITtP8MgMlriPXCO82jaNHRWbQh45P/AFq6/vnPiez2IjiWD15nTHYtG8OyU01G7gR8HAf3o6/EJU2hoY7hTcmCkkPBa/cFYVREt0jM18BIdbOA7gdPR+9B30vHKhRUpmTG232V5B5DtEt3Kr+LIkEV/3GjGbaP8V4mftXcwzKg4KdJA70jtTi2Dh3YISJ9Y4zSStc4ETTPnEQTPG7mqSrJxrgWBRgCqgclzpqoIZs+LH+K2jQpNswakUvAwhDuiHxtkPJf90LMIAzh6NvhACa2eXLT4Nwwm/1QTKRiqxclCPzCU7Wls8eALWDCeDwXJTK+8agM2hpTDqwjSOnkA9TSQ2qnLRF7OCH+nG4dBe3hBgwPbczFQGirp9FLtNujOMkjGuvSiM6tRUGCLvcF4y/UNobueYOgFh8Kni899vUtIV+KvUEw30F1Wvh583S4clYX/rjgJE6oJeaZTnG9HnceyNMVcyrcWKDX0iZKJ/qPDfac3/PnZoW20G6XJbgcyyZZpDfSxI+2yiz4diC7hSO+IzPNgmu5H7ZGpOrL6Ug4my/STFHeVrTIWVv3nK3AspZ3K/rc702U6oLC0AYpBrKhxBVQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(966005)(6666004)(316002)(30864003)(1076003)(8676002)(103116003)(66946007)(66476007)(83380400001)(66556008)(26005)(8936002)(54906003)(956004)(4326008)(186003)(107886003)(2616005)(508600001)(7696005)(5660300002)(52116002)(6486002)(86362001)(38350700002)(38100700002)(36756003)(7416002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?JAbk0JIOwnTdck4JJ0yF7DhuzlAi4SFJC4TWb+2zA2F/lKWF6hsSfXTlySoM?=
 =?us-ascii?Q?uHK0W1KvYndW4ORdbXPkYID99jeOwM4IM5u0Z54BFPLTxkXCkgqpzTSxSWMk?=
 =?us-ascii?Q?2YxRzZlH982Dael+RChUtBjPVKROR24hBxuZRYnxPmnJXlv6T6QlUJhAIRKO?=
 =?us-ascii?Q?aNvHdJwiCI69sU8urCKH22M/hbMnAnUTZZn/JQ+bPtT3UJf8OLiFWJ9W2YWl?=
 =?us-ascii?Q?R9eukWqCPDjpKYaD2afnczaSw5VfA5Gwi3gWyBxzDemxAnM9sVPBsqjgQvYx?=
 =?us-ascii?Q?fuygPKBLHoGejhV+Ce62QGaFeyf0TRXAZYaAMrDIuixLrJwuC5hT/VEd6oqs?=
 =?us-ascii?Q?dJsjyTnI8VRMbCfyznLb8EotS50AQRPzo4pu4aeRrOGxqoN4JWvPCODmqPpE?=
 =?us-ascii?Q?wAkPoMP9ZsYm9TpeNdjfiPuEIaeZJpekj+ebGqjNIGckyqU3YVtcBG2F/Jow?=
 =?us-ascii?Q?JwaOFef0FyldN6thGFujJD1sLhXEh5DAClDLUjTItQF9Wwj4WXTShfZoeSE9?=
 =?us-ascii?Q?fJu2ixjd5Z9fnRiIpWdUM4PBq9W4H5+sMRBhBsNBwKlNVTbUccsp0xbNAvky?=
 =?us-ascii?Q?d2t0+sL+0V5l83+EF+dszb0ju8CrzDvoo7glt/brPNZFEtlbVvugd40CkVJC?=
 =?us-ascii?Q?II8D35sCS1Nsi7j+KeU1APVs3eyerQ6jZu4Z4U+uDV4Ise0bSa0bORdqJb/V?=
 =?us-ascii?Q?bslJCBBqL1scg1fKI+bnyeXkGzPqplRSlibXixeKaNoPogNlIiO3vJDeqj57?=
 =?us-ascii?Q?mOQICgtlXCGzoOup3GPHSpjH3mgQgwIKDOh3P6NHvc0eQeVIZP12A3Rt9Suj?=
 =?us-ascii?Q?YiDof76f0flZmPw0hBOBg4KZxeb3MWhbymng4SsEACVvTUOhdwC1EdJ9nEZc?=
 =?us-ascii?Q?auXDwQG4MQsjjwYkEDs1C/FCHuK+TuUEnWET00bjh0pfvrWZh4Wdph5wzQAT?=
 =?us-ascii?Q?XYveQxzh0g13C+uuOkgu/9h9wpyAsckRfahY9MHSlshksIswBaLTqMKJnb6Y?=
 =?us-ascii?Q?rawYc7Kpzqec08dn47HDPJOoq21wuTNqQNyYPF5ny3Vj883UbJbEQWoj3OpF?=
 =?us-ascii?Q?13RVQZW0SVsxWBH4roTInigKQ8Yu0m2X54Q38st64aqVC8NfbXIDThGBqbZT?=
 =?us-ascii?Q?X1WFZQ+85j+wRxTloBQIhOKVVSKCheTcGGssUz0fGMXG2ndWHyCuuTlMiOJv?=
 =?us-ascii?Q?HUIKI5+ma6WN8va+kNbkCbohm2bC6wf9vJWSR8R2byIOvGKITZ/lF37WNwnt?=
 =?us-ascii?Q?RH2eNarjxxNO/a8d3NaVnNs9FvPWuRVghaRCYznb23Zh5uCHWF9RRkC0l4xJ?=
 =?us-ascii?Q?eU3xvcp++l+IfZ/Dpq4bIXwaFta/JVDz4eZZqgGLaB43n4jBbLmJoY6qzEkS?=
 =?us-ascii?Q?xYD24e69IDN6xD7ooL1bjHzp/VnpcoqYQZkZgcmCrgpXoYnT7/awZ7Qvw6II?=
 =?us-ascii?Q?UyoqCePDRKZVnGBJYATPUV/EPg+3/w6cXgdabVe5ZA1T9E7rz/2pRwgJ9FRu?=
 =?us-ascii?Q?VVyh7SAYHRcd3MbS6Gjk0VFrq53fsfKHHM5ENLxBams0xd8/SGvQ3dopRJh1?=
 =?us-ascii?Q?YR+/pQTXdJzYZ5FAbv3O50cdC1HUfhoq9Iis0dHM1uZZPYaY/EQhXWbmFxLv?=
 =?us-ascii?Q?zknHZ1JuEA/XUwhNLMckoMn6hy9HuWgUJdKdAQ4vKf/d0hxSHBWrZWKrBAcn?=
 =?us-ascii?Q?G+e22w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc5e78e-766c-40c4-d25e-08d9b5d48e88
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 20:44:38.7580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nR4Rz6kUGQVKIbRGG8SF0A9U93I7Au+Ya0Zbfw3w0EnBTsZdp1uyONO+79nApQxTRa1UFL9IsjkpTNx33HyZ52y6UvHkwdRo9yzVhXF9rbY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4303
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112020131
X-Proofpoint-ORIG-GUID: rTpGP-MWRoptgNNA7Tn674FyG2xsBTzE
X-Proofpoint-GUID: rTpGP-MWRoptgNNA7Tn674FyG2xsBTzE

Changes since v6[10]:

* Patch 4, Wrap commit message to 73 characters max (Christoph Hellwig)
* Patch 4, Move pfn_next() in for_each_device_pfn() to new line (Christoph Hellwig)
* Patch 4, Move pfn range computation to a pfn_len() helper. (Christoph Hellwig) 
* Patch 9, Remove @fault_size as it's no longer used (also reported by kbuild robot).
* New Patch 10, remove unneeded @pfn output parameter from dev_dax_huge_fault()
(Christoph Helwig) -- this is done in a new patch
"device-dax: remove pfn from __dev_dax_{pte,pmd,pud}_fault()"

Series is meant to replace what's merged in mmotm/linux-next. Only patch 4 has
changed  but I added a new cleanup patch suggested by Christoph which is what
prompted to send the entire series.  This was based on linux-next tag
next-20211124 (commit 4b74e088fef6) same as to be replaced v6. 

Let me know if there's another preferred way of doing this (e.g. send patch 10
separate as a follow up and just picking up this series patch 4 as mmotm
already has patch 9 fix)).

---

This series converts device-dax to use compound pages, and moves away from the
'struct page per basepage on PMD/PUD' that is done today. Doing so, 1) unlocks
a few noticeable improvements on unpin_user_pages() and makes device-dax+altmap
case 4x times faster in pinning (numbers below and in last patch) 2) as
mentioned in various other threads it's one important step towards cleaning up
ZONE_DEVICE refcounting.

I've split the compound pages on devmap part from the rest based on recent
discussions on devmap pending and future work planned[5][6]. There is consensus
that device-dax should be using compound pages to represent its PMD/PUDs just
like HugeTLB and THP, and that leads to less specialization of the dax parts.
I will pursue the rest of the work in parallel once this part is merged,
particular the GUP-{slow,fast} improvements [7] and the tail struct page
deduplication memory savings part[8].

To summarize what the series does:

Patch 1: Prepare hwpoisoning to work with dax compound pages.

Patches 2-3: Split the current utility function of prep_compound_page()
into head and tail and use those two helpers where appropriate to take
advantage of caches being warm after __init_single_page(). This is used
when initializing zone device when we bring up device-dax namespaces.

Patches 4-10: Add devmap support for compound pages in device-dax.
memmap_init_zone_device() initialize its metadata as compound pages, and it
introduces a new devmap property known as vmemmap_shift which
outlines how the vmemmap is structured (defaults to base pages as done today).
The property describe the page order of the metadata essentially.
While at it do a few cleanups in device-dax in patches 5-9.
Finally enable device-dax usage of devmap @vmemmap_shift to a value
based on its own @align property. @vmemmap_shift returns 0 by default (which
is today's case of base pages in devmap, like fsdax or the others) and the
usage of compound devmap is optional. Starting with device-dax (*not* fsdax) we
enable it by default. There are a few pinning improvements particular on the
unpinning case and altmap, as well as unpin_user_page_range_dirty_lock() being
just as effective as THP/hugetlb[0] pages.

    $ gup_test -f /dev/dax1.0 -m 16384 -r 10 -S -a -n 512 -w
    (pin_user_pages_fast 2M pages) put:~71 ms -> put:~22 ms
    [altmap]
    (pin_user_pages_fast 2M pages) get:~524ms put:~525 ms -> get: ~127ms put:~71ms
    
     $ gup_test -f /dev/dax1.0 -m 129022 -r 10 -S -a -n 512 -w
    (pin_user_pages_fast 2M pages) put:~513 ms -> put:~188 ms
    [altmap with -m 127004]
    (pin_user_pages_fast 2M pages) get:~4.1 secs put:~4.12 secs -> get:~1sec put:~563ms

Tested on x86 with 1Tb+ of pmem (alongside registering it with RDMA with and
without altmap), alongside gup_test selftests with dynamic dax regions and
static dax regions. Coupled with ndctl unit tests for dynamic dax devices
that exercise all of this. Note, for dynamic dax regions I had to revert
commit 8aa83e6395 ("x86/setup: Call early_reserve_memory() earlier"), it
is a known issue that this commit broke efi_fake_mem=.

Patches apply on top of linux-next tag next-20211124 (commit 4b74e088fef6).

Thanks for all the review so far.

As always, Comments and suggestions very much appreciated!

Older Changelog,

v5[9] -> v6[10]:

* Keep @dev on the previous line to improve readability on 
patch 5 (Christoph Hellwig)
* Document is_static() function to clarify what are static and
dynamic dax regions in patch 7 (Christoph Hellwig)
* Deduce @f_mapping and @pgmap from vmf->vma->vm_file to reduce
the number of arguments of set_{page,compound}_mapping() in last
patch (Christoph Hellwig)
* Factor out @mapping initialization to a separate helper ([new] patch 8)
and rename set_page_mapping() to dax_set_mapping() in the process.
* Remove set_compound_mapping() and instead adjust dax_set_mapping()
to handle @vmemmap_shift case on the last patch. This greatly
simplifies the last patch, and addresses a similar comment by Christoph
on having an earlier return. No functional change on the changes
to dax_set_mapping compared to its earlier version so I retained
Dan's Rb on last patch.
* Initialize the mapping prior to inserting the PTE/PMD/PUD as opposed
to after the fact. ([new] patch 9, Jason Gunthorpe)

Patches 8 and 9 are new (small cleanups) in v6.
Patches 6 - 9 are the ones missing Rb tags.

v4[4] -> v5[9]:

* Remove patches 8-14 as they will go in 2 separate (parallel) series;
* Rename @geometry to @vmemmap_shift (Christoph Hellwig)
* Make @vmemmap_shift an order rather than nr of pages (Christoph Hellwig)
* Consequently remove helper pgmap_geometry_order() as it's no longer
needed, in place of accessing directly the structure member [Patch 4 and 8]
* Rename pgmap_geometry() to pgmap_vmemmap_nr() in patches 4 and 8;
* Remove usage of pgmap_geometry() in favour for testing
  @vmemmap_shift for non-zero directly directly in patch 8;
* Patch 5 is new for using `struct_size()` (Dan Williams)
* Add a 'static_dev_dax()' helper for testing pgmap == NULL handling
for dynamic dax devices.
* Expand patch 6 to be explicitly on those !pgmap cases, and replace
those with static_dev_dax().
* Add performance numbers on patch 8 on gup/pin_user_pages() numbers with
this series.
* Massage commit description to remove mentions of @geometry.
* Add Dan's Reviewed-by on patch 8 (Dan Williams)

v3[3] -> v4[4]:

 * Collect Dan's Reviewed-by on patches 1-5,8,9,11
 * Collect Muchun Reviewed-by on patch 1,2,11
 * Reorder patches to first introduce compound pages in ZONE_DEVICE with
 device-dax (for pmem) as first user (patches 1-8) followed by implementing
 the sparse-vmemmap changes for minimize struct page overhead for devmap (patches 9-14)
 * Eliminate remnant @align references to use @geometry (Dan)
 * Convert mentions of 'compound pagemap' to 'compound devmap' throughout
   the series to avoid confusions of this work conflicting/referring to
   anything Folio or pagemap related.
 * Delete pgmap_pfn_geometry() on patch 4
   and rework other patches to use pgmap_geometry() instead (Dan)
 * Convert @geometry to be a number of pages rather than page size in patch 4 (Dan)
 * Make pgmap_geometry() more readable (Christoph)
 * Simplify pgmap refcount pfn computation in memremap_pages() (Christoph)
 * Rework memmap_init_compound() in patch 4 to use the same style as
 memmap_init_zone_device i.e. iterating over PFNs, rather than struct pages (Dan)
 * Add comment on devmap prep_compound_head callsite explaining why it needs
 to be used after first+second tail pages have been initialized (Dan, Jane)
 * Initialize tail page refcount to zero in patch 4
 * Make sure pfn_next() iterate over compound pages (rather than base page) in
 patch 4 to tackle the zone_device elevated page refcount.
 [ Note these last two bullet points above are unneeded once this patch is merged:
   https://lore.kernel.org/linux-mm/20210825034828.12927-3-alex.sierra@amd.com/ ]
 * Remove usage of ternary operator when computing @end in gup_device_huge() in patch 8 (Dan)
 * Remove pinned_head variable in patch 8
 * Remove put_dev_pagemap() need for compound case as that is now fixed for the general case
 in patch 8
 * Switch to PageHead() instead of PageCompound() as we only work with either base pages
 or head pages in patch 8 (Matthew)
 * Fix kdoc of @altmap and improve kdoc for @pgmap in patch 9 (Dan)
 * Fix up missing return in vmemmap_populate_address() in patch 10
 * Change error handling style in all patches (Dan)
 * Change title of vmemmap_dedup.rst to be more representative of the purpose in patch 12 (Dan)
 * Move some of the section and subsection tail page reuse code into helpers
 reuse_compound_section() and compound_section_tail_page() for readability in patch 12 (Dan)
 * Commit description fixes for clearity in various patches (Dan)
 * Add pgmap_geometry_order() helper and
   drop unneeded geometry_size, order variables in patch 12
 * Drop unneeded byte based computation to be PFN in patch 12
 * Handle the dynamic dax region properly when ensuring a stable dev_dax->pgmap in patch 6.
 * Add a compound_nr_pages() helper and use it in memmap_init_zone_device to calculate
 the number of unique struct pages to initialize depending on @altmap existence in patch 13 (Dan)
 * Add compound_section_tail_huge_page() for the tail page PMD reuse in patch 14 (Dan)
 * Reword cover letter.

v2 -> v3[3]:
 * Collect Mike's Ack on patch 2 (Mike)
 * Collect Naoya's Reviewed-by on patch 1 (Naoya)
 * Rename compound_pagemaps.rst doc page (and its mentions) to vmemmap_dedup.rst (Mike, Muchun)
 * Rebased to next-20210714

v1[1] -> v2[2]:

 (New patches 7, 10, 11)
 * Remove occurences of 'we' in the commit descriptions (now for real) [Dan]
 * Add comment on top of compound_head() for fsdax (Patch 1) [Dan]
 * Massage commit descriptions of cleanup/refactor patches to reflect [Dan]
 that it's in preparation for bigger infra in sparse-vmemmap. (Patch 2,3,5) [Dan]
 * Greatly improve all commit messages in terms of grammar/wording and clearity. [Dan]
 * Rename variable/helpers from dev_pagemap::align to @geometry, reflecting
 tht it's not the same thing as dev_dax->align, Patch 4 [Dan]
 * Move compound page init logic into separate memmap_init_compound() helper, Patch 4 [Dan]
 * Simplify patch 9 as a result of having compound initialization differently [Dan]
 * Rename @pfn_align variable in memmap_init_zone_device to @pfns_per_compound [Dan]
 * Rename Subject of patch 6 [Dan]
 * Move hugetlb_vmemmap.c comment block to Documentation/vm Patch 7 [Dan]
 * Add some type-safety to @block and use 'struct page *' rather than
 void, Patch 8 [Dan]
 * Add some comments to less obvious parts on 1G compound page case, Patch 8 [Dan]
 * Remove vmemmap lookup function in place of
 pmd_off_k() + pte_offset_kernel() given some guarantees on section onlining
 serialization, Patch 8
 * Add a comment to get_page() mentioning where/how it is, Patch 8 freed [Dan]
 * Add docs about device-dax usage of tail dedup technique in newly added
 compound_pagemaps.rst doc entry.
 * Add cleanup patch for device-dax for ensuring dev_dax::pgmap is always set [Dan]
 * Add cleanup patch for device-dax for using ALIGN() [Dan]
 * Store pinned head in separate @pinned_head variable and fix error case, patch 13 [Dan]
 * Add comment on difference of @next value for PageCompound(), patch 13 [Dan]
 * Move PUD compound page to be last patch [Dan]
 * Add vmemmap layout for PUD compound geometry in compound_pagemaps.rst doc, patch 14 [Dan]
 * Rebased to next-20210617 

 RFC[0] -> v1:
 (New patches 1-3, 5-8 but the diffstat isn't that different)
 * Fix hwpoisoning of devmap pages reported by Jane (Patch 1 is new in v1)
 * Fix/Massage commit messages to be more clear and remove the 'we' occurences (Dan, John, Matthew)
 * Use pfn_align to be clear it's nr of pages for @align value (John, Dan)
 * Add two helpers pgmap_align() and pgmap_pfn_align() as accessors of pgmap->align;
 * Remove the gup_device_compound_huge special path and have the same code
   work both ways while special casing when devmap page is compound (Jason, John)
 * Avoid usage of vmemmap_populate_basepages() and introduce a first class
   loop that doesn't care about passing an altmap for memmap reuse. (Dan)
 * Completely rework the vmemmap_populate_compound() to avoid the sparse_add_section
   hack into passing block across sparse_add_section calls. It's a lot easier to
   follow and more explicit in what it does.
 * Replace the vmemmap refactoring with adding a @pgmap argument and moving
   parts of the vmemmap_populate_base_pages(). (Patch 5 and 6 are new as a result)
 * Add PMD tail page vmemmap area reuse for 1GB pages. (Patch 8 is new)
 * Improve memmap_init_zone_device() to initialize compound pages when
   struct pages are cache warm. That lead to a even further speed up further
   from RFC series from 190ms -> 80-120ms. Patches 2 and 3 are the new ones
   as a result (Dan)
 * Remove PGMAP_COMPOUND and use @align as the property to detect whether
   or not to reuse vmemmap areas (Dan)

[0] https://lore.kernel.org/linux-mm/20201208172901.17384-1-joao.m.martins@oracle.com/
[1] https://lore.kernel.org/linux-mm/20210325230938.30752-1-joao.m.martins@oracle.com/
[2] https://lore.kernel.org/linux-mm/20210617184507.3662-1-joao.m.martins@oracle.com/
[3] https://lore.kernel.org/linux-mm/20210714193542.21857-1-joao.m.martins@oracle.com/
[4] https://lore.kernel.org/linux-mm/20210827145819.16471-1-joao.m.martins@oracle.com/
[5] https://lore.kernel.org/linux-mm/20211018182559.GC3686969@ziepe.ca/
[6] https://lore.kernel.org/linux-mm/499043a0-b3d8-7a42-4aee-84b81f5b633f@oracle.com/
[7] https://lore.kernel.org/linux-mm/20210827145819.16471-9-joao.m.martins@oracle.com/
[8] https://lore.kernel.org/linux-mm/20210827145819.16471-13-joao.m.martins@oracle.com/
[9] https://lore.kernel.org/linux-mm/20211112150824.11028-1-joao.m.martins@oracle.com/
[10] https://lore.kernel.org/linux-mm/20211124191005.20783-1-joao.m.martins@oracle.com/

Joao Martins (11):
  memory-failure: fetch compound_head after pgmap_pfn_valid()
  mm/page_alloc: split prep_compound_page into head and tail subparts
  mm/page_alloc: refactor memmap_init_zone_device() page init
  mm/memremap: add ZONE_DEVICE support for compound pages
  device-dax: use ALIGN() for determining pgoff
  device-dax: use struct_size()
  device-dax: ensure dev_dax->pgmap is valid for dynamic devices
  device-dax: factor out page mapping initialization
  device-dax: set mapping prior to vmf_insert_pfn{,_pmd,pud}()
  device-dax: remove pfn from __dev_dax_{pte,pmd,pud}_fault()
  device-dax: compound devmap support

 drivers/dax/bus.c        |  32 +++++++++
 drivers/dax/bus.h        |   1 +
 drivers/dax/device.c     | 124 +++++++++++++++++++++--------------
 include/linux/memremap.h |  11 ++++
 mm/memory-failure.c      |   6 ++
 mm/memremap.c            |  18 +++--
 mm/page_alloc.c          | 138 +++++++++++++++++++++++++++------------
 7 files changed, 233 insertions(+), 97 deletions(-)

-- 
2.17.2

