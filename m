Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788DF70
	for <nvdimm@lists.linux.dev>; Thu, 22 Jul 2021 10:54:15 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MAkuNH016517;
	Thu, 22 Jul 2021 10:53:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=kE+IdMuRKKjPoPdAxwXltiDmfHo8OFHABf3OOPsrcfM=;
 b=TuAsN/yun+pBdSqlgfRW0Lu2h+4TgcQBTMBQPGBMB3BNTRLTT0CzrdyxOjuGaYXJ1BDl
 vR+GdzzWipABRScvIQVXb0WEsRNsC21s9f7opf89+ev166MNgZUl/EziWF3lraQZMaD6
 Bv55HsFfJrIqAjHOSMsQQFUYi/uBCMoRLhkgH5J3kwXd807uNaqPf2Z9byPFet/V/uW+
 7dzpSTyZYLQL3X26DKVN2OxEO+ghC3/GBxWRHq5QfUzlrpVBxXayfiZYhss5piVUfjNU
 3PSXTfSSnNUhZ/7rtU2zRdENU8zRbS8PBEaph/4vMgxT4COwqfBNmbena7JPIWrUguTn rg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=kE+IdMuRKKjPoPdAxwXltiDmfHo8OFHABf3OOPsrcfM=;
 b=YL8tX8kVGI2c1sYlT6gfyXItL7r8kfeJNvAtKiUFwY+sj3K/GDHgDTRYcm5z7w1l6UB1
 9IiAq+jPBRwsxODRtlWEhBpS32Djf5JDpUd9nEULwoLDUK/0jfKaZaI+YmGTKivxUIC6
 SVBzTzpX9io0eGlXbACG1UV0HuO2PpKXqCbNuas003YlD4Vu0dp766umJbtP3+5CwPV4
 G6xtOJeH0bshUfdCJsHh6AhZWyXRQHVmFpwSlMCHhgWjkPC3FMabt7RgEccLxcgeF/Rn
 64Zjc+IYhsqaH07y6MUmY4hPUHUeocy1k1KEnb/1MkCfBRVtif+XGPcYhno7tt+CpKG+ iA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39y04drrvs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jul 2021 10:53:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16MAoT9T037087;
	Thu, 22 Jul 2021 10:53:56 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
	by userp3020.oracle.com with ESMTP id 39v900bm8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jul 2021 10:53:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lStgV7CMsAEKLqIai2O0Tr2PI+ge6bhZPpz4MoTar1SkfN9Pk0eMt4QLlwIv/jU6teKcRi205eXIqQMEWEwuC3tzR9dyUeo1Wm+r+mdG+kcQou0LUXq6haB8hrN9c4z+dZ1MhHyEALd/VrbZPv/X5O27eidZN2hVIOQ/dVH7E5RmwGcd4sZjzDP3aO8m8TJOYvjn5S0dw+F2Q0Tn1bkdgbnfiHnNQa+Ieau84ZuKT7ta2g06fpgZopwAeFQFDzgj95rc7rKy4N8F4CRPWF8jJ/pgBNk6gwJ+gGkuAIV3zGDE7HS0PvCBJxpdLbxxCx5ym0yy0fVoTf/rId5sJK+lPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kE+IdMuRKKjPoPdAxwXltiDmfHo8OFHABf3OOPsrcfM=;
 b=loWxUx7dt7RNjOm/cBD8O6FRnRtSR+9FgyUYOe7qExtz4cz+k4fVZaTdBWKXBJ7jERUN4nfv2OKG7+K0aIazDE8eOLXjXhxhq/qM1oVqW1huDjsPTuJOtosw8t/vPU4O7XTA7XDhMAsS0si81Ad/flMJ6eQsBUh3LypYxUKIyT9GrHEwzlvMZyKDu30Y8EaPoDXdObs5PoXXDarg5BtpavjZc1KP/sFSDTHy83Qico+GZ9Tguo4hyjBb7l74S7kCSH2+Z9Sm61ldFhIiGsaY2Wh7NOw6BQzkFE110+cmQmToEcZS2C2FArCH7L/51i4hIpvtIBsXi3h546zMvmQnlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kE+IdMuRKKjPoPdAxwXltiDmfHo8OFHABf3OOPsrcfM=;
 b=ddJC+Xn6eogql1FkvV1HtFxF5RtrJVj610QmN8O8rn7ahHl7pxH65hkOx1vjuUua/AkDBSvyM8E32UE4fdh2lCO52kV4jL+sXDmA0VwCV7q3bZqOtH10blnr7DSePUm5F5TkTRRUqgFDQAPAIjAMIRSVpVX1FOoN9C7rDxy5+0Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4351.namprd10.prod.outlook.com (2603:10b6:208:1d7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Thu, 22 Jul
 2021 10:53:54 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 10:53:54 +0000
Subject: Re: [PATCH v3 00/14] mm, sparse-vmemmap: Introduce compound pagemaps
To: Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714144830.29f9584878b04903079ef7eb@linux-foundation.org>
 <YPjW7tu1NU0iRaH9@casper.infradead.org>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <5642c8c3-cf13-33dc-c617-9d1becfba1b1@oracle.com>
Date: Thu, 22 Jul 2021 11:53:47 +0100
In-Reply-To: <YPjW7tu1NU0iRaH9@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0363.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::8) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.85] (94.63.165.137) by LO4P123CA0363.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18e::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Thu, 22 Jul 2021 10:53:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 918b76c3-02fe-4e56-28c3-08d94cfeff4d
X-MS-TrafficTypeDiagnostic: MN2PR10MB4351:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB435121494BAE1E249DA85B32BBE49@MN2PR10MB4351.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	MB3KXIJrsjoIZRaFtpreqg3bckStTElH72s27IQoEb3eTtKVwZ78I8pdqhTC95lane0+GsvkRXzlWbt+ad231hic52UCJ9HQYjyo1Eb1sjxqvZgEUG5wg6EVi70gFYiAEOxTLJHRpRHISnDfNJVCchDwJC9tY26rTEYX72R9sqwrdgRMlKSCk8l+8TWdoqH5yxDnBVaBvq3UGkKi4O93Sd3biz/e8NbUUyQF3zMxF2dn4iKlVFTk5aXhlkG2q5avbkQSNHUjjaeebl8vcx4mfMY6Sra2gLycf7RMxaZ/58GnTZpEPr5jp2TsP74S7QlHZY6277ACJveWaMjwLKKeKkW7MegMCprKHwUe+NJ0TjYBWfM+b1LYrx87JgyGUGukeJHB31eY2cVE99w64JbLlrrr1heUroPfe0eT6BwjUTj6MKrvu9k4nLDMMFH1juCbGxHDtG7R5GkPy0UXHRYHXao06BeBrrRA6l44FWlErOojnaezcaOlGP7quDts2Y5U4xLNOTNVn1ESKjruAjm2na8y9UHjwRK2OF8Yq2rnnGlm1Zn9Vkn5GJqTKt0LU+XJ1ScSgAWggL00U2DLKLpyufuPo9eCTojeZ8mDGj2TuAnk0Symy2trF1ewefSaaMBJYc4ceLto8xbrtTOhVBAdFaJbBd7c8c+fcsQ8Z4ON8F5jaR7001UoPITmWfcjm6z0Gs0lVFku0K9QwHGD04MF+5aeJfaqxjv/wBwJmWl8aQSG0ymXVdRccrs4h51IkvEWrk4rxkGTt1hKiopYNLuQQ/a09sJ823pojN3X30mYJH+eeatlIjJ9gHGBTb3Fquf8tX9aRiflERlFBra/XIWDRw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(5660300002)(6666004)(2616005)(66946007)(186003)(316002)(508600001)(86362001)(16576012)(31696002)(6486002)(66556008)(110136005)(53546011)(8676002)(956004)(966005)(8936002)(2906002)(4326008)(66476007)(36756003)(26005)(7416002)(54906003)(38100700002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?b2NnQUpEQXF0UmQxWmJQSnFERTNmUklsSVdXRmxLWk01Wm9RWWx0MEFGZGV4?=
 =?utf-8?B?LzJKcjBEV0NaSkUrTnd4bm1HSklmQTlhYXJDY2VqVWQvK2dKUDBFVVVEdmFT?=
 =?utf-8?B?emhGK2FDVzZaajJGckJCU1cwK3dCMWt3YmRjVlZLaFQ3czc1dlZ4Y2Y0M085?=
 =?utf-8?B?aWovSWdiY2E0bFdKdGNVT3hQZHNkR3REMjBmVVlTK1FFN3E5dW82bEtQVUNm?=
 =?utf-8?B?Z0l6ZHU2SnRWNWFSNFBNb096R0pPckFqUzdDUStRU3ZKYXdsT2l6TWZjNkY1?=
 =?utf-8?B?Ty9MSkxEamlkbDhxZUJ5SlgxbGtCcS9TU0I1WVQxeitHRCtvekNWdHo1VnRG?=
 =?utf-8?B?bVdYNXJlS1IrMkpXZUtJdEUwdnZiZU0rQldEMTZkTDl2V21qMEY3dzRSRGRL?=
 =?utf-8?B?MmRHWWpKNGlueE4vdndlMHU4RW4vdndGMnFPTWZvMGN2MVpJZi90UlZrazJW?=
 =?utf-8?B?dHhaRVdRRHNxalRsclg1ZUtIMTJrdUZyc2RRT3JFMkhQc0VmSHRlOWMrT0JM?=
 =?utf-8?B?ZHhvS2RBSzNsemU0S0xtMXc0K1llTmUrbXBSVXJoOUdJRWFYS1BqY0N5QVJy?=
 =?utf-8?B?ZW12NytFMldUZFFSUFFvWnBqWEVwZWUwSHVmRDFVRVkvNFNqRk1RdWdlbjBl?=
 =?utf-8?B?bjQ0OHluU0JORCtsa1Ryb09HSE9rSndpM0V3RFhEUUhmclFVZkd3aFZMWDA2?=
 =?utf-8?B?TXlSaUF6T1JWRnRVVHNBdzh2UGdBVXF2YllUcHc3L3Vmbzl0ZXpoNG4zM01R?=
 =?utf-8?B?aDhxaEg2Vm1YY2dERXNjT3VKSWpqUXc2ZWcvMVFtV1F5cGJuWWNBNlIwTUEr?=
 =?utf-8?B?YzFoeWZkTHo0RWdxeWtoZmlTVzdNa2VzWWRNK2hUcjJUQXEwL2FIREpWWW1W?=
 =?utf-8?B?cVhuajE0bVIvek9sRTMvUUZwYXI1eHF5TEQrenJMYU9zOGxXL1lTd2Vlc0pm?=
 =?utf-8?B?Yy9BT3RyQmdma2RtVzlsVkpxS015b0JwbTFod1R5MHpBTmtXV25PMWN4aWpn?=
 =?utf-8?B?SEwwa3dtVDA4YWxnb2ozWWQ5Z245WkkxWlNvZXZ2Ujg4NmhCNWh6V3gwSmho?=
 =?utf-8?B?dTVjRGg4WHRhczVSY0toODhxYkUrSVJkTVM3V2RqRjhibk5aSTRkYzc2dFV5?=
 =?utf-8?B?YjJFencrTVpmcFNiVFFEeTBNQld6VGpSQWVRTkVQRmVCNTRMWGpoVGpJZlow?=
 =?utf-8?B?RjRLaXl6THNyN0s5VWJGbmpzM09QMU1TN0ZUQU14V0ptZUlGdk1ET2hVQzFK?=
 =?utf-8?B?RjdOOWdsbGhnYzdkTURmV25qY3BkMXNaSGRjdXFsb3FSWkVTRkpPVm04OTcv?=
 =?utf-8?B?YmtDbzl5K1B3WGVaU05mWE56bWdMUlIxdGN6RE5EdlNvaC9QQnRCbzVGMU9j?=
 =?utf-8?B?MnFLZnQzM1habGJMUmlhelNBakhibmxJUTFGQlpFZDMrK0dmQ05nbDNLN2hn?=
 =?utf-8?B?eVRDSTY5Qld5N2g2TUpSMlR0cUtTaXJwSHRSYVY2TkRzM01DUCtTZ0R0MDNk?=
 =?utf-8?B?Z3BLY1ZRZ3h6Z3NWTkxoTnAvQWU1cGFIbzA4WXpQQTE1UVM5YnBqU0NJK3hv?=
 =?utf-8?B?UTFFUnFsYnZacld3SFZidHJzSFg0eUk5blRPVFR3WXBwY2FNWVVnKzV5Y2Rm?=
 =?utf-8?B?MGxyK1UrcFR4Vm1WVkZ0WDE1K2g1SVVlZStsZmQ3RTNUdDZxN1dlY1pGWDAx?=
 =?utf-8?B?Yks1aWNkdEcxUmY3Wko0K2JmR0FGYjBweHp3YnpQcGlaZG5vMEZRbmI3dTFS?=
 =?utf-8?Q?NM6R4NO20xAWybv6Vj1TckKZ0a/JbCcfn4101Ik?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 918b76c3-02fe-4e56-28c3-08d94cfeff4d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 10:53:53.9969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yC45cSW4lOxIr/PC6ZReoMMhCKi/YgLd4shDUVPUgomc5TPAH8fwyhxcCeAXTa3KHGWSEZmQf2bbMnxq97CzoKO5k0hFhXfTwtkjkZ5KGkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4351
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10052 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107220071
X-Proofpoint-GUID: fA7vVeJbHSpexmmJcDKzfk3ncSY2aF8x
X-Proofpoint-ORIG-GUID: fA7vVeJbHSpexmmJcDKzfk3ncSY2aF8x

On 7/22/21 3:24 AM, Matthew Wilcox wrote:
> On Wed, Jul 14, 2021 at 02:48:30PM -0700, Andrew Morton wrote:
>> On Wed, 14 Jul 2021 20:35:28 +0100 Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>>> This series, attempts at minimizing 'struct page' overhead by
>>> pursuing a similar approach as Muchun Song series "Free some vmemmap
>>> pages of hugetlb page"[0] but applied to devmap/ZONE_DEVICE which is now
>>> in mmotm. 
>>>
>>> [0] https://lore.kernel.org/linux-mm/20210308102807.59745-1-songmuchun@bytedance.com/
>>
>> [0] is now in mainline.
>>
>> This patch series looks like it'll clash significantly with the folio
>> work and it is pretty thinly reviewed, so I think I'll take a pass for
>> now.  Matthew, thoughts?
> 
> I had a look through it, and I don't see anything that looks like it'll
> clash with the folio patches.  

FWIW, I had tried this last week, and this series applies cleanly on top of your 130+
patch series for Folios.


> The folio work really touches the page
> cache for now, and this seems mostly to touch the devmap paths.
> 
/me nods -- it really is about devmap infra for usage in device-dax for persistent memory.

Perhaps I should do s/pagemaps/devmap/ throughout the series to avoid confusion.

> It would be nice to convert the devmap code to folios too, but that
> can wait.  The mess with page refcounts needs to be sorted out first.
> 
I suppose you refer to fixing the current zone-device elevated page ref count?

https://lore.kernel.org/linux-mm/20210717192135.9030-3-alex.sierra@amd.com/
