Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF76518A6AD
	for <nvdimm@lists.linux.dev>; Wed, 11 Jun 2025 02:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749609548; cv=fail; b=hVVFQsYjYnmtGn2tYcjXxWfWCN0H0nGpORKkzMC44RcgIHf1qQSqn1tddNpy7CdwsybXOkuPu6KWCmJc3OBmhzmGpM/nXl6MllX4pT708me07swTVrZQaFTV2OBZFt25oP9YWUEKRj4xitPqsvwrEla27LRdw2BstMvGVkQGjfY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749609548; c=relaxed/simple;
	bh=kcdXB77zYyUf2N7/EXizdXINbgAm00UZdmZppWxijQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gNyU0JtI0X/sKTA8OKy9YClDCxcf1dIK+yh7gJ4uHebsMmwQyTMNpcYDRy7yjuW0IB3Q+DW2H6sF9bjDnEBw6ssNM4cGQGycq/gFjigbcbPe/F03HwM4FpyllMNB7UsDv78dcuBvWMTlUeL5x1DbDGNqKpMO5k7q1FuTxusl4cE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=fail (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=U1oXn4Vc reason="signature verification failed"; arc=fail smtp.client-ip=40.107.94.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U1oXn4Vc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GSliVo32wvKNrYIpEuVL+WCSEioaX5E3ZrUyfq4ZWE17eQOJxhJu9vYyW61FqpVN8DlT0/85H8dmqKRJX8Wj0f1tiqOYA2HT9SZzXnJI+/RG5ibT555A6KhDme0HlpNKFL1QBIabuMXtIPOE6N2vEtTxtLnhi/UeT6SlsexYxNZvI/ln0fzFeTb9sm1wTiSVWjbAAM8er5vy24MMkCp4eAoskZgJlRWA8L6/I5qdte1k+dPkxAYRKzAoKO6dhwjmvZI37YLinUFB81lcNZOzzs52HJ15cWgQFxoalgZLR1w+IYgIdYLk6G5Bl0ugivikrpY3Oirki5rXmdowR0d4WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oj0SmrTyib1wO+frHrCNzdND8ftSP+S+tcInWuXGx3M=;
 b=thYWaMPip6FV/BJvV1FgNQczAOObGSwHz9nqSOTf0al+hZu3MPP7jo+b+0xKEpGKQ1rGYZgs11JKeTyyqy/OwoX1dncong57a7uo9IIwSjOunRGtvgcKsw215YAE4fgPZpqnqAdZ/w44V8KFWh5TK+py2Yo8gLlcgfgBMGXvPgOZ5ewxhUWpmBCOp2mFHAlnuRWIXTL/UXZafkEfLEmg9stS68+bHUcA7nUgcy5vXukPqbO+EGyJES2XyK529VXCe70qwUspOB/WLhCmQWzpF2qTfYo4gnb4P4jXVs3Cgh8WxnW26Fk6PgV7VWQwU00gX7sChff5+KTJBB/s214cJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oj0SmrTyib1wO+frHrCNzdND8ftSP+S+tcInWuXGx3M=;
 b=U1oXn4Vcf/O5HwvCW7mx2vEycEkBFlt99BMYjuAg6hUEmnezYprfrL99hbYtddBiOlAKzNK34KT3kB4GKfX1cED9/UM4nFFqjX85ldGoHqkmgl+Y5xUpTH5f3p4aM8qTN0T/ws9+qqCdPUj4H2DxCYSIwS6nPDRuw0QpLNndD6E6FUQX9U+G64Z6sShoqKGH9l6IDVPmQFw+d/CbpmUDRGUF0L/XbbKOgTFItUzeJVXMbB6jZlV4zD4zTe+CKsv4qxHKuHyLdqZsKOKAlcRbEmyGHFb5cdotzF7l3dN7NTLzXI2lzf5Hmbjj7Fy7Msa2PaaOzkgDxM/+2tabJKHOoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB7723.namprd12.prod.outlook.com (2603:10b6:208:431::10)
 by CY3PR12MB9608.namprd12.prod.outlook.com (2603:10b6:930:102::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.33; Wed, 11 Jun
 2025 02:39:02 +0000
Received: from IA0PR12MB7723.namprd12.prod.outlook.com
 ([fe80::ef74:9335:2c5b:2bc7]) by IA0PR12MB7723.namprd12.prod.outlook.com
 ([fe80::ef74:9335:2c5b:2bc7%5]) with mapi id 15.20.8792.034; Wed, 11 Jun 2025
 02:39:01 +0000
Date: Wed, 11 Jun 2025 12:38:55 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, David Hildenbrand <david@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>, gerald.schaefer@linux.ibm.com, 
	dan.j.williams@intel.com, jgg@ziepe.ca, willy@infradead.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, jhubbard@nvidia.com, zhang.lyra@gmail.com, debug@rivosinc.com, 
	bjorn@kernel.org, balbirs@nvidia.com, lorenzo.stoakes@oracle.com, John@groves.net
Subject: Re: [PATCH] mm: Remove PFN_MAP, PFN_SPECIAL, PFN_SG_CHAIN and
 PFN_SG_LAST
Message-ID: <hczxxu3txopjnucjrttpcqtkkfnzrqh6sr4v54dfmjbvf2zcfs@ocv6gqddyavn>
References: <20250604032145.463934-1-apopple@nvidia.com>
 <CGME20250610161811eucas1p18de4ba7b320b6d6ff7da44786b350b6e@eucas1p1.samsung.com>
 <957c0d9d-2c37-4d5f-a8b8-8bf90cd0aedb@samsung.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <957c0d9d-2c37-4d5f-a8b8-8bf90cd0aedb@samsung.com>
X-ClientProxiedBy: SY8P300CA0006.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:29d::16) To IA0PR12MB7723.namprd12.prod.outlook.com
 (2603:10b6:208:431::10)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB7723:EE_|CY3PR12MB9608:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f7e44cb-0935-4cc5-a62f-08dda8911f5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?Ptezm1iXrYRPU44h2+pHrbb1niLPEqo11R244guNbMPRYBO2wHjxv8zING?=
 =?iso-8859-1?Q?sdheVCHHvAL/iwsGs6sekknpkSaTw3Q0VFMkyCC1KeDBTDh9U/qdJpoDyO?=
 =?iso-8859-1?Q?gZwwtCb6wRvQ4D6vpSW8UICc3B4oplE1+OtecTJt1g6Lj9vb5thoJu7e6N?=
 =?iso-8859-1?Q?rQdjol2cGroUl9tUXoy5nDLStmM/pryWakjz1XcKsBH7QL36nriuj9QqgY?=
 =?iso-8859-1?Q?FTJg0lMKspe0+ad7bPXNrSw7jBEInxLMmSbbUGjbqG4G+esuoB8ccdziKn?=
 =?iso-8859-1?Q?lexGWGnBGAtTHgmup4avUKq6dM+p9yl3CEoiW3CCdkxtpRi6nHyq5iTytI?=
 =?iso-8859-1?Q?lzxzptUcc1fifKrezOjoAEHDW4bxjzOEzviBJbXe7T7VrqP3v4grl/GXn0?=
 =?iso-8859-1?Q?Gx8w5EtIYMLzpq0hYKrrBrNiq9LLT9mWP0zmG2xyDslCk483wU0jvGXIam?=
 =?iso-8859-1?Q?KI2/CdnlB+znmC6qGltVicbNvRij7P83a9IPhWKrqHpbxtLtsucDyqCvaq?=
 =?iso-8859-1?Q?lIDmeLn2QGiQBlDWwkV+uT4btB4C9uE/6H85S0DK5QazdOstnCs9Q2Ek3Z?=
 =?iso-8859-1?Q?9fdT1gOwi0wY9Hmq3BPhvmSfG3Mu95CXVGAVpTNabdhIMMcHHTJ2ENDyJo?=
 =?iso-8859-1?Q?LViDBxxf8q1zd9H4O+7wlTWYywFl/g59tS6qi0FNU/X765gv7md6hKO9ul?=
 =?iso-8859-1?Q?o+ddjUXowdIvK8h1eWON93o40q58zOOc3HMey6eDGgEFl2u8X9CKd47A/5?=
 =?iso-8859-1?Q?NR0mr90hXmV0M7BFuARWvq74SCh+nxN6Hb8vSoa9Z6e719yYvYznVI7UHX?=
 =?iso-8859-1?Q?Swz69hAnLkTiy0CRt66jFeHh3yM0VqdgMP9dqkKxu9xN7jHyWrFeJLdyS0?=
 =?iso-8859-1?Q?u/XjrqO+0Li1XTonBv/vucNNd/tWslQtTMt/Bnto1mOAbUbSJpgi4ciDZ0?=
 =?iso-8859-1?Q?iEKQUDPICThen5AJ6iYRioTsX2YirAFUV0F+6+U6vr8CR+5rq3Decnq462?=
 =?iso-8859-1?Q?5WyAUUimuPgPjZiZDUHGa35+RO1dXliwlLPqwcP0T1f2u8SLmAviXVqGMn?=
 =?iso-8859-1?Q?0kTiCinlIiMc9PUfaj/W1qDC+88zRXs6OZkoMOndbpqOQZNSDV04p4WcTY?=
 =?iso-8859-1?Q?wLUk5OJsru5XAV3oxgXlIHjMT7sEQfFgnwBnpBgPbxCOmnkp13/jkZQ8yz?=
 =?iso-8859-1?Q?Io3qr5hfhxSkN0JauH3v+PNmEimYsY62b+lhz6UB4m251hB9q35nOAqqRA?=
 =?iso-8859-1?Q?Ipl0sht2sSB+e9n57yT1uNtnuzTNa5UGnUZuup5dyu8fl8Z8L2AfWrZcIk?=
 =?iso-8859-1?Q?D3taDXPlAWbRFC7CXUclzSvdns/9jPC+1sWaSrOdLA6yJcZW/JjFtB1BmQ?=
 =?iso-8859-1?Q?7ink2VjAvm7uNEjB8+APzwAFZtL9rOnLZopHYnEdXT6LkqO12YXNfjSom5?=
 =?iso-8859-1?Q?tNGDjqyhNCmNtEI3cn5E4uQ4XCeYBW4pzxnuo1tvTqO1iI9hdlSxFOnfIB?=
 =?iso-8859-1?Q?8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB7723.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?IufG/6o+DijM36v+2hd0xHEhvNpHYS7a7m55YGcNb2ls8rRI2gcLhtZj7h?=
 =?iso-8859-1?Q?/dRsrWdXxy+YTGmI3Km7EsNhdrIHqhM8xq81rldoNZnm6rVFguSJ63V0CG?=
 =?iso-8859-1?Q?XqtQyqsvNnE677+Wy53txBREInrH+QPuyoqYwkwkalt4R4tJdsr68RXwuK?=
 =?iso-8859-1?Q?W5Adh964ZFKBk9riY2L8A44ivIjRrz7aXVi74CyZ4v9mmGb5z9qEasUcQE?=
 =?iso-8859-1?Q?awZD2kT3Jo5D7SG7MW+0aZBRKVntuOqXG+1JSuRXMGV05DgJUo130YJulI?=
 =?iso-8859-1?Q?2t8JoN2IdrNlB1fkw4x4ZAqWCz6NNI8eTEQce4QMRzorB0h8NcKRbLw7ch?=
 =?iso-8859-1?Q?OlDE8EW7lck/tYO2LRAUa6lGxpy+7P822HA+uG7QJwdeMBmDn9gO6TrCfz?=
 =?iso-8859-1?Q?YgQrWoI0mJ7/ASCCskv9yHhaT0L8i/sCCC+Gh3sq7nrqt7VSH/ZlqabWhk?=
 =?iso-8859-1?Q?lxlkgLhNP1eevk0MRJTWqQy7Y3hx2MpEDs8CsO2qGNiZ/iKI5zzMcRsFV5?=
 =?iso-8859-1?Q?qu3doyNmyqs8s3c8PdlPPNIMNvAz1qnnVuOGnLI9idsyIXzQ+xlWYI9nTf?=
 =?iso-8859-1?Q?DOVCMtbSm5XVCFu1seRIlgGKGFo1xw/8f1HKTyCEJBtBg2hGIq/DNbS0pr?=
 =?iso-8859-1?Q?rmsvI4K9UJCxNB07wNNnEEDViOBV2DxfVzvDIY8xo3z0SqdvYnPXS0MwZj?=
 =?iso-8859-1?Q?LTknptcvVOJGCeGRwelitsq0qcpdJ2wxxoyZIjqA9ezj9Hq8XNMxnJnC9a?=
 =?iso-8859-1?Q?qA6a5qxaWmfVFMsQkQ9yZpxFHgGKRmKihJwCv/yNOJ6DfhlckTXCkpfshL?=
 =?iso-8859-1?Q?fzgw6P0N58XjjHeRK9z19wqJ33E5ifO3Lkjc4u1E9Rty7HBzS3DLXZ+e7P?=
 =?iso-8859-1?Q?jWbgQXrzuCsMYu4ucbc5AoalOEcqnF7vAbVWGElS24FuWktNViqgyYmCBL?=
 =?iso-8859-1?Q?vfLgijtJqGdRq3+d2tfHj3lxW+sgCz7ITOolwhOwNoS4mrp5ZqRVRmxaYi?=
 =?iso-8859-1?Q?aEm+hh9sI7nEjtnGcvCmntPIa9nu3xNtfYgVOeXSQnDdZus37lDpho/Sz3?=
 =?iso-8859-1?Q?ErufxHuAeLrgeaChp3E2hr8AjQM2FigqR0vBgT7JML88HcZUnF62vAGlA7?=
 =?iso-8859-1?Q?D8NXcL4Rrk2lwwD4YQJhpYrqYMfv59Wp695sQI9uFBPgmMDTMEgYBQA2nw?=
 =?iso-8859-1?Q?SjGBziLJyeLLOKVjh427BGiL2q9QHbP2Z50wzfLVC5vjW7LGTfV1XNw1dh?=
 =?iso-8859-1?Q?yt60pkIEfJFb6vUEWghOPlxa7XTZ9SFevBs9Pbdg20hWftwJ0hlB/1kom1?=
 =?iso-8859-1?Q?SACxBiSgyxst1ed/CLZj5gWCYTar2aOU1G14c0+5i0SGhojoI7MVoXqgeV?=
 =?iso-8859-1?Q?BcZkpVklU6XDxnM9+e23iM0StRj1CAIUIQHAllPQ1kg2M/Qf5WmeLCJHll?=
 =?iso-8859-1?Q?r9c8Fjq4x7sVCXC2se5WctpV99fdKcrHmjpNb4xRWUq46LNXvjnNTBBY4k?=
 =?iso-8859-1?Q?AalTeoFdGlBdSsec0ZNU3b15ybp6QF0l6Nin1TQxYic//sbk5d2q/Z9ft8?=
 =?iso-8859-1?Q?E8UXBJu6S6OpP7nSSKwZTOZfHjSjJyXQoOVc8V1vgt+w02kTlT0f4Ber2E?=
 =?iso-8859-1?Q?UJDIWnhAsq3Qw73eDX7LZyXaXoJKPKk6ki?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f7e44cb-0935-4cc5-a62f-08dda8911f5d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB7723.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 02:39:01.1961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KJfEcblARdsaHVPFhQAPmYwORGLdoBi0EPQ6gweaDGl61PfEKGmd8lHU4/mI/25ShDaVidH224IPFM0T0jqWXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9608

On Tue, Jun 10, 2025 at 06:18:09PM +0200, Marek Szyprowski wrote:
> Dear All,
> 
> On 04.06.2025 05:21, Alistair Popple wrote:
> > The PFN_MAP flag is no longer used for anything, so remove it.
> > The PFN_SG_CHAIN and PFN_SG_LAST flags never appear to have been
> > used so also remove them. The last user of PFN_SPECIAL was removed
> > by 653d7825c149 ("dcssblk: mark DAX broken, remove FS_DAX_LIMITED
> > support").
> >
> > Signed-off-by: Alistair Popple <apopple@nvidia.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: gerald.schaefer@linux.ibm.com
> > Cc: dan.j.williams@intel.com
> > Cc: jgg@ziepe.ca
> > Cc: willy@infradead.org
> > Cc: david@redhat.com
> > Cc: linux-kernel@vger.kernel.org
> > Cc: nvdimm@lists.linux.dev
> > Cc: jhubbard@nvidia.com
> > Cc: hch@lst.de
> > Cc: zhang.lyra@gmail.com
> > Cc: debug@rivosinc.com
> > Cc: bjorn@kernel.org
> > Cc: balbirs@nvidia.com
> > Cc: lorenzo.stoakes@oracle.com
> > Cc: John@Groves.net
> >
> > ---
> >
> > Splitting this off from the rest of my series[1] as a separate clean-up
> > for consideration for the v6.16 merge window as suggested by Christoph.
> >
> > [1] - https://lore.kernel.org/linux-mm/cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com/
> > ---
> >   include/linux/pfn_t.h             | 31 +++----------------------------
> >   mm/memory.c                       |  2 --
> >   tools/testing/nvdimm/test/iomap.c |  4 ----
> >   3 files changed, 3 insertions(+), 34 deletions(-)
> 
> This patch landed in today's linux-next as commit 28be5676b4a3 ("mm: 
> remove PFN_MAP, PFN_SPECIAL, PFN_SG_CHAIN and PFN_SG_LAST"). In my tests 
> I've noticed that it breaks operation of all RISC-V 64bit boards on my 
> test farm (VisionFive2, BananaPiF3 as well as QEMU's Virt machine). I've 
> isolated the changes responsible for this issue, see the inline comments 
> in the patch below. Here is an example of the issues observed in the 
> logs from those machines:

Thanks for the report. I'm really confused by this because this change should
just be removal of dead code - nothing sets any of the removed PFN_* flags
AFAICT.

I don't have access to any RISC-V hardwdare but you say this reproduces under
qemu - what do you run on the system to cause the error? Is it just a simple
boot and load a module or are you running selftests or something else?

Also if possible it would be good to know if you still see the issue
after applying the full series (https://lore.kernel.org/linux-mm/
cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvi
dia.com/).

> BUG: Bad page map in process modprobe  pte:20682653 pmd:20f23c01
> page: refcount:1 mapcount:-1 mapping:0000000000000000 index:0x0 pfn:0x81a09
> flags: 0x2004(referenced|reserved|zone=0)
> raw: 0000000000002004 ff1c000000068248 ff1c000000068248 0000000000000000
> raw: 0000000000000000 0000000000000000 00000001fffffffe 0000000000000000
> page dumped because: bad pte
> addr:00007fff84619000 vm_flags:04044411 anon_vma:0000000000000000 
> mapping:0000000000000000 index:0
> file:(null) fault:special_mapping_fault mmap:0x0 mmap_prepare: 0x0 
> read_folio:0x0
> CPU: 1 UID: 0 PID: 58 Comm: modprobe Not tainted 
> 6.16.0-rc1-next-20250610+ #15719 NONE
> Hardware name: riscv-virtio,qemu (DT)
> Call Trace:
> [<ffffffff80016152>] dump_backtrace+0x1c/0x24
> [<ffffffff8000147a>] show_stack+0x28/0x34
> [<ffffffff8000f61e>] dump_stack_lvl+0x5e/0x86
> [<ffffffff8000f65a>] dump_stack+0x14/0x1c
> [<ffffffff80234b7e>] print_bad_pte+0x1b4/0x1ee
> [<ffffffff8023854a>] unmap_page_range+0x4da/0xf74
> [<ffffffff80239042>] unmap_single_vma.constprop.0+0x5e/0x90
> [<ffffffff8023913a>] unmap_vmas+0xc6/0x1c4
> [<ffffffff80244a70>] exit_mmap+0xb6/0x418
> [<ffffffff80021dc4>] mmput+0x56/0xf2
> [<ffffffff8002b84e>] do_exit+0x182/0x80e
> [<ffffffff8002c02a>] do_group_exit+0x24/0x70
> [<ffffffff8002c092>] pid_child_should_wake+0x0/0x54
> [<ffffffff80b66112>] do_trap_ecall_u+0x29c/0x4cc
> [<ffffffff80b747e6>] handle_exception+0x146/0x152
> Disabling lock debugging due to kernel taint
> 
> 
> > diff --git a/include/linux/pfn_t.h b/include/linux/pfn_t.h
> > index 2d9148221e9a..46afa12eb33b 100644
> > --- a/include/linux/pfn_t.h
> > +++ b/include/linux/pfn_t.h
> > @@ -5,26 +5,13 @@
> >   
> >   /*
> >    * PFN_FLAGS_MASK - mask of all the possible valid pfn_t flags
> > - * PFN_SG_CHAIN - pfn is a pointer to the next scatterlist entry
> > - * PFN_SG_LAST - pfn references a page and is the last scatterlist entry
> >    * PFN_DEV - pfn is not covered by system memmap by default
> > - * PFN_MAP - pfn has a dynamic page mapping established by a device driver
> > - * PFN_SPECIAL - for CONFIG_FS_DAX_LIMITED builds to allow XIP, but not
> > - *		 get_user_pages
> >    */
> >   #define PFN_FLAGS_MASK (((u64) (~PAGE_MASK)) << (BITS_PER_LONG_LONG - PAGE_SHIFT))
> > -#define PFN_SG_CHAIN (1ULL << (BITS_PER_LONG_LONG - 1))
> > -#define PFN_SG_LAST (1ULL << (BITS_PER_LONG_LONG - 2))
> >   #define PFN_DEV (1ULL << (BITS_PER_LONG_LONG - 3))
> > -#define PFN_MAP (1ULL << (BITS_PER_LONG_LONG - 4))
> > -#define PFN_SPECIAL (1ULL << (BITS_PER_LONG_LONG - 5))
> >   
> >   #define PFN_FLAGS_TRACE \
> > -	{ PFN_SPECIAL,	"SPECIAL" }, \
> > -	{ PFN_SG_CHAIN,	"SG_CHAIN" }, \
> > -	{ PFN_SG_LAST,	"SG_LAST" }, \
> > -	{ PFN_DEV,	"DEV" }, \
> > -	{ PFN_MAP,	"MAP" }
> > +	{ PFN_DEV,	"DEV" }
> >   
> >   static inline pfn_t __pfn_to_pfn_t(unsigned long pfn, u64 flags)
> >   {
> > @@ -46,7 +33,7 @@ static inline pfn_t phys_to_pfn_t(phys_addr_t addr, u64 flags)
> >   
> >   static inline bool pfn_t_has_page(pfn_t pfn)
> >   {
> > -	return (pfn.val & PFN_MAP) == PFN_MAP || (pfn.val & PFN_DEV) == 0;
> > +	return (pfn.val & PFN_DEV) == 0;
> >   }
> >   
> >   static inline unsigned long pfn_t_to_pfn(pfn_t pfn)
> > @@ -100,7 +87,7 @@ static inline pud_t pfn_t_pud(pfn_t pfn, pgprot_t pgprot)
> >   #ifdef CONFIG_ARCH_HAS_PTE_DEVMAP
> >   static inline bool pfn_t_devmap(pfn_t pfn)
> >   {
> > -	const u64 flags = PFN_DEV|PFN_MAP;
> > +	const u64 flags = PFN_DEV;
> >   
> >   	return (pfn.val & flags) == flags;
> >   }
> 
> The above change causes the stability issues on RISC-V based boards. To 
> get them working again with today's linux-next I had to apply the 
> following change:
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 6ff7dd305639..f502860f2a76 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -46,7 +46,6 @@ config RISCV
>          select ARCH_HAS_PREEMPT_LAZY
>          select ARCH_HAS_PREPARE_SYNC_CORE_CMD
>          select ARCH_HAS_PTDUMP if MMU
> -       select ARCH_HAS_PTE_DEVMAP if 64BIT && MMU
>          select ARCH_HAS_PTE_SPECIAL
>          select ARCH_HAS_SET_DIRECT_MAP if MMU
>          select ARCH_HAS_SET_MEMORY if MMU
> 
> I'm not sure if this is really the desired solution and frankly speaking 
> I don't understand the code behind the 'devmap' related bits. I can help 
> testing other patches that will fix this issue properly.
> 
> 
> > @@ -116,16 +103,4 @@ pmd_t pmd_mkdevmap(pmd_t pmd);
> >   pud_t pud_mkdevmap(pud_t pud);
> >   #endif
> >   #endif /* CONFIG_ARCH_HAS_PTE_DEVMAP */
> > -
> > -#ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
> > -static inline bool pfn_t_special(pfn_t pfn)
> > -{
> > -	return (pfn.val & PFN_SPECIAL) == PFN_SPECIAL;
> > -}
> > -#else
> > -static inline bool pfn_t_special(pfn_t pfn)
> > -{
> > -	return false;
> > -}
> > -#endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
> >   #endif /* _LINUX_PFN_T_H_ */
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 49199410805c..cc85f814bc1c 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -2569,8 +2569,6 @@ static bool vm_mixed_ok(struct vm_area_struct *vma, pfn_t pfn, bool mkwrite)
> >   		return true;
> >   	if (pfn_t_devmap(pfn))
> >   		return true;
> > -	if (pfn_t_special(pfn))
> > -		return true;
> >   	if (is_zero_pfn(pfn_t_to_pfn(pfn)))
> >   		return true;
> >   	return false;
> > diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
> > index e4313726fae3..ddceb04b4a9a 100644
> > --- a/tools/testing/nvdimm/test/iomap.c
> > +++ b/tools/testing/nvdimm/test/iomap.c
> > @@ -137,10 +137,6 @@ EXPORT_SYMBOL_GPL(__wrap_devm_memremap_pages);
> >   
> >   pfn_t __wrap_phys_to_pfn_t(phys_addr_t addr, unsigned long flags)
> >   {
> > -	struct nfit_test_resource *nfit_res = get_nfit_res(addr);
> > -
> > -	if (nfit_res)
> > -		flags &= ~PFN_MAP;
> >           return phys_to_pfn_t(addr, flags);
> >   }
> >   EXPORT_SYMBOL(__wrap_phys_to_pfn_t);
> 
> Best regards
> -- 
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
> 
