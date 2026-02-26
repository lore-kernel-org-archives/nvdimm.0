Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012042.outbound.protection.outlook.com [52.101.53.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1604779A8;
	Thu, 26 Feb 2026 21:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772140503; cv=fail; b=DSbPPDV5hUbXBSsGe7qcc9UXtuWK7bDSNTqKQK3Vii4KSI88/KC1dD694023c0ABvKezKh5Zf/iMuTx5kaD+WYTmyF48foFGOszmXxL5W9aASIOU2OIM7dMZ0x3ZM+ajwBamywvfKbIxDnrY1s9WQjkky3ecUlkWjhHBLO5qOL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772140503; c=relaxed/simple;
	bh=lrMTnpX96iV5FU6KOXFyORrRZKJ1djia+Un8EDD6e0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UxR9pzPp0aY0NpvAxgRjS1ry39fTTMox7qiSGFDRBCZgwwg/ikbEPgvF0TcP2IR+E34e6XnHaGV+atDCr1TJOdVAGBfej1DBbXFs1v8x5LVvkOeRJMPuGyAFUFoqxbRVg62zOIbdYI2fSexSTZSW1sxn7RCX3y8XnNOQ2L2NhgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bVEhwNNI; arc=fail smtp.client-ip=52.101.53.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bVEhwNNI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SoXsuVhoDKcaHHtXDgyTDWBYBR7mNt0n3HDbYU7XBvmt/9rOaEEVIT7APVcO100x4LOb0Esh53/n/Gkng8uccgj4BAwEX5uYCqeeNa8D3csRrFoHbP1niDyJbCRPV1OSkAtBW2qFxemgHTrEOyecGQQKyGzK2Q87ezepb2kZvZ5MwO64Zz4QNGmoi8g+JkuA50oHRLtyTShoY19jF1wafRqzcK1cDQZzEMMxXB9L0q9KuOgr1bAJ7mgx0qY1wEjkvFyduBgT9udPvB2bHvBkm6yNaLUP+OXPyBPPGrJIj+RmA4SMZWzaWShj6nLSsiG0YCQRoLRXnYr6ozqoEa5d2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3Gmtf7Td04ChZy3/FFngKnJvaZXnMZrfEPVFmQZ2gk=;
 b=S5N2WzsAZQlJVGxpXShTS64ePwieLoTzWSApN7C43/Ewl4e3aXIhOwlqeAzv1v653jk6TTynEQaNEfqXG6mD0NwqVENs9m480M1i6Q4B7yO/CvYv++Rc6II6SRLSuyDGH/QvBHPPDPmY0awf85vYpOPOl0XKVgT86uhFbM0JLhNPW6SP7rF2wyxRUAzR7J6a7RbCS1blfh53Il02t4KwZj4ttbvPcRRnUWG5VIjKK+e+Y7ghGK7iF9au81hGmimIqxHlVsYbHbzXvZc6+ZXorPc+Ne28xAcUz2OeTmkzOll4VNLRznyWRba4IHonGZL3axhoKjkBCe8KJq70q9+n9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3Gmtf7Td04ChZy3/FFngKnJvaZXnMZrfEPVFmQZ2gk=;
 b=bVEhwNNIrCwp37J3ZqiEAKarc6Ow5M6ockdubJ6FrvucBettQwNr24hWejxpmabM5hFE/inEDw4mSvmEbDIsZWBO2eMrAPu0JU1SErcK0SE8Z7Y9+EW5Hp/ut97utzG8WiECcwrw6XoZ1sVgGJGj4Qq6vxbrdEInkyB5wq0Chq50TE7rFGXHtUMdf3prNgPGJleWDEFMzQme8+1fYOehBvL4LvOlSQgtR2DOSxgHMSGz0aCyONIfCcP0kf2Zz4B6ain4e9HNK8qMdCPuXTlikTNaS2MgiQHlupHSpN9wZPAuB6e4x6iLQKPpiyqZsAZl7CfWdcJppDUTte/sd35hBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4454.namprd12.prod.outlook.com (2603:10b6:208:26c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.15; Thu, 26 Feb
 2026 21:14:53 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.014; Thu, 26 Feb 2026
 21:14:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: Tal Zussman <tz2294@columbia.edu>
Cc: David Howells <dhowells@redhat.com>,
 Marc Dionne <marc.dionne@auristor.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Paulo Alcantara <pc@manguebit.org>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Steve French <sfrench@samba.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>,
 Andreas Gruenbacher <agruenba@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Brendan Jackman <jackmanb@google.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-ext4@vger.kernel.org, netfs@lists.linux.dev, linux-nfs@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, gfs2@lists.linux.dev,
 linux-nilfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 cgroups@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm: Remove stray references to struct pagevec
Date: Thu, 26 Feb 2026 16:14:39 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <75A87D9B-5A04-4679-AF82-56332A786A63@nvidia.com>
In-Reply-To: <20260225-pagevec_cleanup-v2-1-716868cc2d11@columbia.edu>
References: <20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu>
 <20260225-pagevec_cleanup-v2-1-716868cc2d11@columbia.edu>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0087.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4454:EE_
X-MS-Office365-Filtering-Correlation-Id: 778fb806-5f7a-4743-6000-08de757c157f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	oIrjYQCjzHwV66EA/F/RvgiiCGK2SjRSsvoYLeWWsoMYaYN1K6RfFBio3SzGatwPMqyoaF7raYf1lqr6IIN/lp1/0B32swRRcPHJo0PW5aIuWZyzl085KeAu8PyU9RlQygn2Xz3ou1KM/q6M8rlnyjxH0MKVmAeBcEym4ZswzDb1jsTShcKiQdpNRWVI3ge/x6qODNbLOlZHkLY9v8uwcnNcgudpcrr2tOe5gqeyxan+TN8utD86RUCdsLB4YHVrpHzF2uW0SUPEaDUUjafqr48Co1wWmI6Lvzyxht4R7kxnUmdoiVbztgO/UtTI9kWr+OjfQ4Fh8rnExTcNSaCl+w5x2wdWF4w+e3BYfnBfPkbSREbLPlPGa6FOqNJNgltjap0Rr4YvZXHDm9xcGGWN/hP2nfNS39Q6C7LnC1vP4dc/1BBlb+OJY+12XgnF9VGWxJZPpL/VcLqOkCEDBaePzMOHenMMhfOxdrq4ZUKf1JocHY1Y3Dyv5P+y3VMuHd5ctracwU9elS4R5y/HyL4joniVK6eAoDtniJZQ2EQ3SkU0tYMGEdvNsNO4Tx5ofGiJYRhq0Utt/5/ls5T8tqxHeSZVufptD7nU4HpAxNOyE/Em/c2SuwnKzE0nZ74qbUMAhmuQ72t/nZh/6vJqKVqDNzeuwiFXBzVJLpty6wZHK0XZObdU00/c1TYd8v3OUdk6gTno69YSnOWzY3I2otuvY8fOk3TvVz2FV0tT4z3QtSE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+Ks3JtFwKq97fATos9G60W0NtQYFj7BfxB+vcrdvP/c9OM2nh0Z+sVWSA/Vp?=
 =?us-ascii?Q?03eVycCnXnDZ4oreSgHW2zI6PbJR4yEue/hULEy/og9dTWseTDXlWdxmQRFZ?=
 =?us-ascii?Q?AWTJHzzqGdJ9nQQqUbWdkVmTeqqKE+ZYun7ren9+6UU5Fk+/e04J2ATx1gPA?=
 =?us-ascii?Q?2pg6Y4cty3PQ9YugMH77ODTRfJE7nas+r776Bun04Z29AAvAnMVdwYFnAP9F?=
 =?us-ascii?Q?H1K+xu7SCsRvLZZ+++szV+vmcaAD9yf2lmzLn7soVtbjt7vHYSHoW+rCbXa4?=
 =?us-ascii?Q?uHJv/jEuasPJ7dRLFsTu69sb6eisuijQxnsEBvpR/1LGnN4UMPX96fgwBT28?=
 =?us-ascii?Q?uSZ4Mzzuz2v2QQFLtSaL+F4b3Pn49IYStFUPQKey8lNGAE3GmNhLxRKhEtTP?=
 =?us-ascii?Q?9JtlK9Nd7V3pdHe73ryzEM6A0o06bfgfDdGgePyLphlDCIKXBbqHl6uw6d88?=
 =?us-ascii?Q?86+AfYx2MD0kkPoB7gGS4jt9fqHUAip4r0KGDFsdpm8e4sw+fvcr7SEwOvyS?=
 =?us-ascii?Q?qHpCiCFuZ0mVGA03eG5J+UL30gBqe49eaBHOOgR4+8wEijJ/QCOFf7cRHwmE?=
 =?us-ascii?Q?6zc/F5Uju2vPVtraRZK0RcH/IcK4dOO4+BYncRNQmkI0rfnh5yI+vwtTqm1s?=
 =?us-ascii?Q?qyacSJXVlR5+p4/Ba39lZSFgJwhdJDkUzOEkow7R68H+V/dg5vV9fVifo1Ox?=
 =?us-ascii?Q?0L/CZchRHg8ROnLTiAm+9hMqStIY9eewOJ7IRPKQmfvYAffVpjsCtHBXtTI3?=
 =?us-ascii?Q?hk5WXwXUQZMhF4bPxavzskVvnRsNbD2YqSPSleXFj+viloMNloVEAfpFagCM?=
 =?us-ascii?Q?8dpGQw5kU+EjokmBR0qgi0ahcL0ydbNFxpcg6qTPe9zmCoUADAIIocASoBjj?=
 =?us-ascii?Q?1dlf90cNmzxanZ9LXK7aWNNCT4K3WREfdoNsMDcr+/gj116eZgqcF5yjpDFJ?=
 =?us-ascii?Q?G2c35WaP1t2z4nbGJzmyerqHFMFHCv9jk8yVVyuZuZfiyM7JoBtZCvsNi1le?=
 =?us-ascii?Q?aq3krk3HpVIOwO9OOMYASlCLGghJoxyrv3u4sOWrMjRFCmpqQXhSUvMOo0mI?=
 =?us-ascii?Q?Mgg3HC80H9fSfdL6c4dPNZ1/bFXsfkyRnJJOauCKM1FrovmUilDPccCfNEK2?=
 =?us-ascii?Q?wIiYqLrhAv5b+XW2yYnmcEfGn+q5EdSkK5fFFXDOOlRJEoo4rg3mXzuUviw5?=
 =?us-ascii?Q?RqACNu5BFhOA9yMkQ/ESCw1JYPu6JZ2VZB8mB2xA03yuki8XSz97Qc7vF9MB?=
 =?us-ascii?Q?Z7W6zQSyti9CzaNto+PAOuE5cyMUjF5ZgK4d6aY55qzVMxTEvlAdDntTPeX0?=
 =?us-ascii?Q?0qXHIn06MCM0fBgfF3EkcJ/zMYDlq1IqzGu5QsKBZOT1wID6mrDyXNdbvVT4?=
 =?us-ascii?Q?lIlnJYPZGw4tF4krqsq1Lq4wKD6kxH+MEXP4aqWsSzTG7/M/9PU4XJ9Z9VA5?=
 =?us-ascii?Q?zmfXH0fi8fgmpSeKDCU5O1Ewjb4jxxwyCLyZZ3yuMV00IOz0aLspOhCJnT1X?=
 =?us-ascii?Q?EbqM/6uQ3lvdI5rO63AjRFW95Ul8J58x1Fg2hCVZZI+NXYHAPVepUevSlUxH?=
 =?us-ascii?Q?dsnTJ6CP68+UsNFKxi4+aDwV2rCSabNjHAhcKrvGqy6jhnSNzIM2+YqOefZi?=
 =?us-ascii?Q?IbgdSjyGA7JlYQ4iOk5isyPOVP5MVP1X7x/G0TORFHhxb8eTBdG7tJMz4N94?=
 =?us-ascii?Q?obs/99pZ6tsotOkm3Hx4ZgUrrM6JIOpInYV+s00t+mw2+9WKD3/s2DgYH6WF?=
 =?us-ascii?Q?4BCtE5mHcg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 778fb806-5f7a-4743-6000-08de757c157f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 21:14:53.1535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /CVAdwAlPYswiAFQdCqMXX+tLaqoZy5w/VFXl8Qw9Ruo3df9eUUvUFk8Hg/25zE3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4454

On 25 Feb 2026, at 18:44, Tal Zussman wrote:

> struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
> pagevec"). Remove remaining forward declarations and change
> __folio_batch_release()'s declaration to match its definition.
>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  fs/afs/internal.h       | 1 -
>  fs/f2fs/f2fs.h          | 2 --
>  include/linux/pagevec.h | 2 +-
>  include/linux/swap.h    | 2 --
>  4 files changed, 1 insertion(+), 6 deletions(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi
