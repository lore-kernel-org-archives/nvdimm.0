Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010043.outbound.protection.outlook.com [52.101.46.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2C637B030;
	Tue, 11 Aug 2026 08:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786435408; cv=fail; b=Q6DM7vCeHwIW4qQK3z7X5KmzkAOI3oWYhYj8QmBKAcekrH4SvMuxenoDeueKJFnNE9LZqRxuCjWLvGAHMCjWCbGQWUBUW+Ob/qvpZVMCONJtq37wUY+MmC/A5BQNnEvq5huVC2qv9jK204Naw+nLhmun95220xYxpK+Wal2WMTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786435408; c=relaxed/simple;
	bh=R7jlpI9MAT6rgz8i16jVjZuhAaYhbnRO8+s9iI/3BMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uhytNffoII8xqyhZa87/fK3BsVf5H1nYTLctcMCvjZ83CUgQGM9TepFbvrabWyoOqmPbrjMADLyuxGumxp0VmOhiXcz9HSs377z/9H4eR7IAXAVf/OIo0XlElrn5UmaEKO4IBCJadkycB1pQFByeUpfB2Jw4hBgqOA0hBOetV0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nQLSPYi7; arc=fail smtp.client-ip=52.101.46.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nQLSPYi7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P9yJz8P1ZhXWmNm8KU2gCqVXUm6hY6u+ZhzCy6DpF17W6V3XClQyDq9oHPX+XT/owTixdlu4rdom6BVHp5721v6i/jR28A8seHircm0d1LLaBRDMMoYAfiDU2Izv3ePdba5y75QzneIQ68Gb8f8lGv4b6/9F3u9EKG/PVGfJwHehHluIX3ACSTOD+KSEp+uS8UZOWMzO/h4IjmxsufaZ97ggCp6R6G9OK9FZw64ESBgcpIrb/eHmykaoe65GX2eJZWhLDN0VS0pE+L3j7CnMNw+PLCaA5pmHCBpqHQyDgf7FAsai9s2J0VOQPt/STIBDnvLUhfchr557RMzx5kxK1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASpqqGgRX2bVwffDWm5myZxyGJrhEha7wW24dKD3wqk=;
 b=ss+G1FZKkqS511ZUe0FrjC0qSJFru0agsykxs7b5NZAaC/DBPnZeQ9bGqmp15FRjg3Ew+KoCR9PVHtdYVmQAzC7Bi27lEJ0AqtDPh7rRzk8feCGtdDmnDlnLOglj4V1ZiR2kxcj4L6WclnYYaFXRZrShYIU+ok3Vt3J31vSK+uul5xV6UwjK2CP2HK8TtNrVtOXwpRtHwLcAGEHtcdxtKD294oE+5ntdIT7OjLZ81VbzLj1zs3OD3HhEJtGk9En1wYu94V2EzMuCP1scJzBmiReAueWb4HA+vE7WKynHqtS6yspfwAoBzOoZH7+6pjZQf6z5tNf0+zCgyHwaZIbiyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASpqqGgRX2bVwffDWm5myZxyGJrhEha7wW24dKD3wqk=;
 b=nQLSPYi7y6qE3ETsJ3rP3XDzjRy88GBFixeQ1HrSW4Nsf5Y6CtYOLVtnuwqGpzWOObSfYBlaf7gTjA8ovECk7xbF2FNeNjgxxV+W2/g1CwEkdk2ZYv77LA4xqCaHWQ3bNiUzHc5Bx7WIPJK+VIGncoct44N3eCv2HMJuOmfMhiew79Iy/Hnq/jnsxf8srjYO+nbe98iM2J2OVZAo1f9es4jMX6S30ERidByP6yNl0a0+n8puY02dQfHHY36N9oW3xSmlo9Occt2qEKdoa69HMpYk0cen8KMxitxiLbOFN5abFfJ1RJ+e88oBVSWJYReAdDYDQSot4ZE2SedblHwBww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 08:03:13 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 08:03:13 +0000
Date: Tue, 11 Aug 2026 16:03:09 +0800
From: Richard Cheng <icheng@nvidia.com>
To: John Groves <john@jagalactic.com>
Cc: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <jic23@kernel.org>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Ira Weiny <iweiny@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Haren Myneni <haren@linux.ibm.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Ethan Nelson-Moore <enelsonmoore@gmail.com>, Gabriel Whigham <gabewhigham@gmail.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH v13 07/12] famfs: MAP_CREATE ioctl and fmap ingest (ABI
 44)
Message-ID: <anrUDcyctLFe8dZL@MWDK4CY14F>
References: <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com>
 <20260810202510.96332-1-john@jagalactic.com>
 <0100019fed59de28-dde6a382-affe-4bc6-a91d-d4054a7c61a5-000000@email.amazonses.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019fed59de28-dde6a382-affe-4bc6-a91d-d4054a7c61a5-000000@email.amazonses.com>
X-ClientProxiedBy: TPYP295CA0031.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:7::9)
 To BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|DS7PR12MB6263:EE_
X-MS-Office365-Filtering-Correlation-Id: b9e90077-d040-4819-b25d-08def77efde1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|6133799003|18002099003|22082099003|4143699003|11063799006|56012099006|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	dD4LXn/MFWnE0o+YOJUc3WYTUENf/oi0sP/Uh+1bdYRm7gZhrmddJfnvL+Flruqyj6/RkvdpSpri7Qglo9IgrGQ1fdNinzMApYGb6ENGj8tzZ1Wrpq8WJhb27LhH1pvqmp6KTN4eNNAXwS2nNhEw2skTvxMlUu0Lm1J09eiAa88Pl99s/0kVWrSW55/m1dts0OygwfXX/SCOjvHic90pQPAwLdYYkhFXsoT3v4soCkNNy63uUtiGkYfFtEVNGV4lgIXOBFD+7yv0k8ZtTB2NkAp+hAyNW7lnfSuJZ8eKDraC2FsG0saJhkR8BKgmEBAxMsjM1kh3dIDPZECjh5+eGqqVg5Zjy3kS44iimK+0ghgGuvZzR9KmR+xuvZKrPvxMNP1IGUwKaWEgtpkZSiuRfgMF/HNqSPXwn34x6vsLaM8zHerCZrjFRE9b3Y5O5eoz3VM+zB5nVsG8SGquQ0MUTZqpfM0zfNbEMtg0zyhOuEVRtgX+yiKVTzCV/qZCf/ZcRf7XU3av2pTmjnVs8+WTRgleajnq/cviHcSqz6Jke4EFEZfq2a/sMq2hBl+oNejaavNkrfLA1hZHI/H10/VYV1M6qnwueKrO2SWNhK7T2xolv9NhRTWiPVpsugG5YPYO78dRqGrq22I/6TaeHX8i1B7TlSHWq0ZTbdOhyNeju4M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9Jckj2SeDfURzU+JDiMl6DDHgTb/RnBgZ2TwABge+SXR6gx3tKzDgmFAPhWu?=
 =?us-ascii?Q?o6whttIlIzIgWPjTCxv+u++OkBP4+9jF4Oi9iOvygoL3HlWOsE4+JwkbC0bn?=
 =?us-ascii?Q?dcK2x2gae3cqT7U54Wd/6EAn2A4AywsstfRx90kB//sdQWq4cGJ4e0O3HsI5?=
 =?us-ascii?Q?0gsTjidcxdrSDY7H2hCg+Ti+xtquo9ZtDQhCeZke3OOvf0sAn2rbEF0ivKvK?=
 =?us-ascii?Q?AQ8Qt4PGaD3FWgeVq+jmwtEXpCfWUmNLoHG1PXmyMum5wB7h2EBYjdFCnCd/?=
 =?us-ascii?Q?ySj33jpzZYCRZmKToLPVLd0MowY/ZWO+VJQ2eaQwqkW2Lyk6pSDnUbSfQNT2?=
 =?us-ascii?Q?9qDgG4BCPyUByf1rjYgKI6cKcjHB0w3t3LeESM72ugkcfeJcn5Xq1h84wz3x?=
 =?us-ascii?Q?dWMSZ5nOwOsev2tZEYc2bvYWQipeF5dhgDxr5UaZ2/Tpj+0JiHH6VokSJsdW?=
 =?us-ascii?Q?Psycdtas82Q2SHGv5Y/UmJ6ub1hFl/y2bx+6AyYLgMNg2XFSQPhZsWF7k/Cz?=
 =?us-ascii?Q?ylbGU9s+Zh2NWB8ly2utehJiJootJjW6Mz7nE6iPsDuvyH2SSwGWqp1AWHGN?=
 =?us-ascii?Q?UpJxqgJzbIDcI7W6+0TILwEQBcNo2PFBV+FognoWTUveMv4OYWoKVqdCaTpw?=
 =?us-ascii?Q?zqjwjnNJAvLemZ5/8jPpWVyzOyw0EVNCVjSQBTiolpACq9agXJt8Ot29Aumm?=
 =?us-ascii?Q?8TSJdlknLdun8mYb7rc2+vg4Bj3Y2EVhoBX9NYlLWUF0a6ivvza1disz5qX8?=
 =?us-ascii?Q?oMXFQiAbQPtBQbPB9RBIqWhnpX+4nEd4IpfphFNU9BpnTC9NXO+d0/ZlPDrg?=
 =?us-ascii?Q?Z5LDge9/G+bLv+zc0ZADS9bHJ2IPSSrCA98ACrKeqXdHL2bfyIKWODFdpFpL?=
 =?us-ascii?Q?oSPoXi2EG0P1ODEJBgditotBPafEUMPoZ231oxHwZQXgMAUKrsyhb1dRkCgw?=
 =?us-ascii?Q?nDxUd1JiDs+p1VdebKdJtnwCnmvTu+yS/5+S1oHNVrVPRZgKwXPNSNMXUPMO?=
 =?us-ascii?Q?L1up8k8VpGoV0KocYlP9dHZjwya2JmQ5mgVkF45ntPctc19IRJvQ6e5kZoOG?=
 =?us-ascii?Q?X6jltKaGTHCRIKN/5jdlrZ6vlhjNrp9a5ty72e8SQB+zsvQcb5hxC50qycng?=
 =?us-ascii?Q?V7ltEI/3no/NofRZkTxE9YSzqLrXvUFq9p70ICYsERH7rBxDwJpd4wNjk/X6?=
 =?us-ascii?Q?EpYKbpUZPH95o+wkgrNwJvFzemkmaWj+2bdpMbD81yWfs3J1PT0PgYi0EZAA?=
 =?us-ascii?Q?tYbj8JaiVivQ9GvHy5W2TF0EFnx4DoxRzyWZEIEqCGJrAbqh3cHcIsSA8JjR?=
 =?us-ascii?Q?K0H0cQ4yFEb2QA4mBuMaZKCJ0U1v9Soz7T7so1GkXZbMcBNU1HuB+srOvpzi?=
 =?us-ascii?Q?4XXKivTxs5DjdwRmG2+HL9cJcdNz9XrYUC3wJ5uYEui4tXPEl7OO8nY4byAY?=
 =?us-ascii?Q?K4+x++AX3JgaxqrbREjQ9lOSB2TV7NZjxgy3u3+IGCogWf4tUiy5cOQI9wYb?=
 =?us-ascii?Q?1szRtChn+j8js1DA6uBKIZf+h36JG5tNmlYRFXnHeXFff5SYjdaWUqX5sudE?=
 =?us-ascii?Q?H+pCg7D3XAWxbRV7068ltD/xmC+25QQICH6KwFeYVTEqYMHhpjLbgud+tb7r?=
 =?us-ascii?Q?IgPEz71wurcsz52b9R6m0VeM81NGCzBVbpHgLQ3HyxTiW6y+3MwrKaw3ymEH?=
 =?us-ascii?Q?OKP0Ya3gsy0nTNuiWxDo1zJ8d793v7p0UwTw6mfdnPGeBa3p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9e90077-d040-4819-b25d-08def77efde1
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 08:03:13.2434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oGBforKxQaKLdb1KMGf6pP5A+FT2xYRUqpZ7QiDnpX38a9w7ceQ1t4Y77KzhC5/LHyUtnUMAATqnGcAs0mt08g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6263

On Mon, Aug 10, 2026 at 08:25:17PM +0800, John Groves wrote:
> From: John Groves <john@groves.net>
>

Hi John,

I have some questions below.
 
> Add the famfs file ioctl handler (FAMFSIOC_NOP, FAMFSIOC_MAP_CREATE) and
> the KABI-44 self-describing fmap message: the wire ABI in famfs_ioctl.h
> (famfs_ioc_fmap_header plus the simple and interleaved extent structs), the
> in-core famfs_file_meta, and famfs_file_init_dax(), which copies the
> message in, parses both the simple-extent and interleaved (striped) wire
> forms into inode->i_private, and sets S_DAX.
> 
> Resolving those mappings to dax-device offsets (iomap_begin) is added in
> the following commit; the read/write/fault paths keep their NULL iomap_ops
> stub until then.
> 
> Famfs now accepts extent and chunk alignment at either PMD or PTE. PMD
> is the normal case, and it guarantees PMD faults - which is right for
> large files, which are the original use case. But there are also active
> use cases that use zillions of small files, and those need PTE support
> to avoid big space amplification.
> 
> Also add famfs ioctls to ioctl-number.rst
> 
> Signed-off-by: John Groves <john@groves.net>
> ---
> v13:
>  - Renamed the read-only module parameter famfs_kabi_version -> kabi_version;
>    it already lives under /sys/module/famfs/parameters/, so the famfs_ prefix
>    was redundant. New path: /sys/module/famfs/parameters/kabi_version (same
>    for =y and =m).
>  - Dropped the proposed GET_GEOMETRY ioctl (Darrick suggested turning the NOP
>    ioctl into one reporting the abi version and page/pmd sizes). The abi
>    version and supported allocation units are module-wide and needed before
>    mount, where an ioctl cannot reach; they are exposed as read-only module
>    parameters instead (kabi_version already is; alloc-unit reporting will
>    follow when sub-PMD support lands). FAMFSIOC_NOP is retained as the
>    "is this famfs?" probe (Darrick).
>  - Accept 4 KiB extent alignment, not only 2 MiB. Extent offset and length
>    (simple extents and interleaved strips) must now be PAGE_SIZE-aligned
>    instead of PMD_SIZE-aligned -- page alignment is a superset, so 2 MiB
>    fmaps still pass, and a 4 KiB-granular fmap is now accepted and maps as
>    PTEs (the fault path already falls back PMD -> PTE, while 2 MiB-aligned
>    extents still get huge pages). The interleaved striping chunk_size must be
>    exactly one supported allocation unit -- PAGE_SIZE (4 KiB) or PMD_SIZE
>    (2 MiB) -- not an arbitrary page multiple. The alloc-unit module param to
>    advertise supported granularities is deferred.
> 
>  .../userspace-api/ioctl/ioctl-number.rst      |   1 +
>  fs/famfs/famfs_file.c                         | 328 +++++++++++++++++-
>  fs/famfs/famfs_inode.c                        |   1 +
>  fs/famfs/famfs_internal.h                     |  46 +++
>  include/uapi/linux/famfs_ioctl.h              |  91 +++++
>  5 files changed, 464 insertions(+), 3 deletions(-)
>  create mode 100644 include/uapi/linux/famfs_ioctl.h
> 
> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> index 3f0ef1e27eb0..5e244dec1b98 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -299,6 +299,7 @@ Code  Seq#    Include File                                             Comments
>  'u'   00-2F  linux/ublk_cmd.h                                          conflict!
>  'u'   20-3F  linux/uvcvideo.h                                          USB video class host driver
>  'u'   40-4f  linux/udmabuf.h                                           userspace dma-buf misc device
> +'u'   50-5F  linux/famfs_ioctl.h                                       famfs shared memory file system
>  'v'   00-1F  linux/ext2_fs.h                                           conflict!
>  'v'   00-1F  linux/fs.h                                                conflict!
>  'v'   00-0F  linux/sonypi.h                                            conflict!
> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> index 9c1cd2f67489..ba19b17e80b1 100644
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c
> @@ -13,9 +13,315 @@
>  #include <linux/mm.h>
>  #include <linux/dax.h>
>  #include <linux/iomap.h>
> +#include <linux/capability.h>
>  
> +#include <linux/famfs_ioctl.h>
>  #include "famfs_internal.h"
>  
> +/* Expose famfs kernel abi version as a read-only module parameter */
> +static int kabi_version = FAMFS_KABI_VERSION;
> +module_param(kabi_version, int, 0444);
> +MODULE_PARM_DESC(kabi_version, "famfs kernel abi version");
> +
> +void
> +famfs_meta_free(struct famfs_file_meta *map)
> +{
> +	if (map) {
> +		switch (map->fm_extent_type) {
> +		case FAMFS_IOC_EXT_SIMPLE:
> +			kfree(map->se);
> +			break;
> +		case FAMFS_IOC_EXT_INTERLEAVE:
> +			if (map->ie) {
> +				u32 i;
> +
> +				for (i = 0; i < map->fm_niext; i++)
> +					kfree(map->ie[i].ie_strips);
> +			}
> +			kfree(map->ie);
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +	kfree(map);
> +}
> +
> +static int
> +famfs_check_ext_alignment(struct famfs_meta_simple_ext *se)
> +{
> +	int errs = 0;
> +
> +	if (!IS_ALIGNED(se->ext_offset, PAGE_SIZE))
> +		errs++;
> +	if (!IS_ALIGNED(se->ext_len, PAGE_SIZE))
> +		errs++;
> +
> +	return errs;
> +}
> +
> +/**
> + * famfs_file_init_dax() - FAMFSIOC_MAP_CREATE ioctl handler
> + * @file: the un-initialized file
> + * @arg:  user pointer to a self-describing fmap message
> + *
> + * The map-create ioctl carries the fmap as a self-describing message: a
> + * struct famfs_ioc_fmap_header followed by an extent list. The message is
> + * copied in, parsed into a famfs_file_meta, and published on inode->i_private.
> + * Both the simple-extent and the interleaved (striped) wire forms are handled.
> + * The wire layout byte-matches the fmap carried in a fuse famfs GET_FMAP reply.
> + */
> +static int
> +famfs_file_init_dax(struct file *file, void __user *arg)
> +{
> +	struct famfs_ioc_fmap_header fmh;
> +	struct famfs_file_meta *meta = NULL;
> +	struct famfs_fs_info *fsi;
> +	struct super_block *sb;
> +	struct inode *inode;
> +	void *fmap_buf = NULL;
> +	size_t extent_total = 0;
> +	size_t next_offset;
> +	int errs = 0;
> +	int rc;
> +	u32 i, j;
> +
> +	inode = file_inode(file);
> +	if (!inode)
> +		return -EBADF;
> +	if (inode->i_private)
> +		return -EEXIST;
> +
> +	sb  = inode->i_sb;
> +	fsi = sb->s_fs_info;
> +	if (fsi->deverror)
> +		return -ENODEV;
> +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_MAP_CREATE))
> +		return -EPERM;
> +

I think this only check whether MAP_CREATE is enabled for the mount ?

Does it check whether the caller is trusted or not ? I think no ?

Maybe we require more privilege such as CAP_SYS_RAWIO, FMODE_WRITE?


> +	if (copy_from_user(&fmh, arg, sizeof(fmh)))
> +		return -EFAULT;
> +
> +	if (fmh.fmap_version != FAMFS_FMAP_VERSION)
> +		return -EINVAL;
> +	if (fmh.fmap_size < sizeof(fmh))
> +		return -EINVAL;
> +	if (fmh.fmap_size > FAMFS_FMAP_MSG_MAX)
> +		return -EFBIG;
> +	if (fmh.nextents < 1)
> +		return -EINVAL;
> +
> +	fmap_buf = kvmalloc(fmh.fmap_size, GFP_KERNEL);
> +	if (!fmap_buf)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(fmap_buf, arg, fmh.fmap_size)) {
> +		rc = -EFAULT;
> +		goto out;
> +	}
> +	next_offset = sizeof(fmh);	/* start of the extent list */
> +
> +	meta = kzalloc_obj(*meta, GFP_KERNEL);
> +	if (!meta) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	meta->error = false;
> +	meta->file_type = fmh.file_type;
> +	meta->file_size = fmh.file_size;
> +	meta->fm_extent_type = fmh.ext_type;
> +
> +	switch (fmh.ext_type) {
> +	case FAMFS_IOC_EXT_SIMPLE: {
> +		struct famfs_ioc_simple_ext *se_in = fmap_buf + next_offset;
> +
> +		next_offset += (size_t)fmh.nextents * sizeof(*se_in);
> +		if (next_offset > fmh.fmap_size) {
> +			rc = -EINVAL;
> +			goto out;
> +		}
> +
> +		meta->fm_nextents = fmh.nextents;
> +		meta->se = kcalloc(meta->fm_nextents, sizeof(*meta->se),
> +				   GFP_KERNEL);
> +		if (!meta->se) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +
> +		for (i = 0; i < fmh.nextents; i++) {
> +			meta->se[i].dev_index  = se_in[i].se_devindex;
> +			meta->se[i].ext_offset = se_in[i].se_offset;
> +			meta->se[i].ext_len    = se_in[i].se_len;
> +
> +			if (meta->se[i].dev_index >= FAMFS_MAX_DAXDEVS) {
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +			meta->dev_bitmap |= BIT_ULL(meta->se[i].dev_index);
> +			errs += famfs_check_ext_alignment(&meta->se[i]);
> +			extent_total += meta->se[i].ext_len;

offset + length + entent_total can overflow, and file_size can be larger
than MAX_LFS_FILESIZE. And overflow can wrap the DAX address back to 0
and map the wrong memory.

Maybe check_add_overflow() can be utilized ?


> +		}
> +		break;
> +	}
> +
> +	case FAMFS_IOC_EXT_INTERLEAVE: {
> +		s64 size_remainder = meta->file_size;
> +		u32 niext = fmh.nextents;
> +
> +		meta->fm_niext = niext;
> +		meta->ie = kcalloc(niext, sizeof(*meta->ie), GFP_KERNEL);
> +		if (!meta->ie) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +
> +		/* Outer loop is over the separate interleaved extents */
> +		for (i = 0; i < niext; i++) {
> +			struct famfs_ioc_iext *ie_in = fmap_buf + next_offset;
> +			struct famfs_ioc_simple_ext *sie_in;
> +			u64 nstrips;
> +
> +			next_offset += sizeof(*ie_in);
> +			if (next_offset > fmh.fmap_size) {
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +
> +			/* chunk_size must be exactly one supported alloc unit */
> +			if (ie_in->ie_chunk_size != PAGE_SIZE &&
> +			    ie_in->ie_chunk_size != PMD_SIZE) {
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +			if (ie_in->ie_nbytes == 0) {
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +
> +			nstrips = ie_in->ie_nstrips;
> +			if (nstrips < 1) {
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +
> +			meta->ie[i].fie_chunk_size = ie_in->ie_chunk_size;
> +			meta->ie[i].fie_nstrips    = ie_in->ie_nstrips;
> +			meta->ie[i].fie_nbytes     = ie_in->ie_nbytes;
> +
> +			/* The strip extents follow the interleaved-ext header */
> +			sie_in = fmap_buf + next_offset;
> +			next_offset += nstrips * sizeof(*sie_in);
> +			if (next_offset > fmh.fmap_size) {
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +
> +			meta->ie[i].ie_strips =
> +				kcalloc(nstrips,
> +					sizeof(meta->ie[i].ie_strips[0]),
> +					GFP_KERNEL);
> +			if (!meta->ie[i].ie_strips) {
> +				rc = -ENOMEM;
> +				goto out;
> +			}
> +
> +			/* Inner loop is over the strips */
> +			for (j = 0; j < nstrips; j++) {
> +				struct famfs_meta_simple_ext *so =
> +					&meta->ie[i].ie_strips[j];
> +
> +				so->dev_index  = sie_in[j].se_devindex;
> +				so->ext_offset = sie_in[j].se_offset;
> +				so->ext_len    = sie_in[j].se_len;
> +
> +				if (so->dev_index >= FAMFS_MAX_DAXDEVS) {
> +					rc = -EINVAL;
> +					goto out;
> +				}
> +				meta->dev_bitmap |= BIT_ULL(so->dev_index);
> +				errs += famfs_check_ext_alignment(so);
> +				extent_total += so->ext_len;
> +				size_remainder -= so->ext_len;

We use physical allocation size here to check logical file coverage,
it doesn't make sense to me.
For example, file_size can be 1MB and ie_nbytes only 4KB, but a 1MB ext_len makes this check pass, and you access the area after the first 4 KB will fail,
because it has no logical mapping.

Maybe we should make sure the sum of ie_nbytes covers file_size, and
separately check that each strip's ext_len is large enough for its assigned
chunks ?


> +			}
> +		}
> +
> +		if (size_remainder > 0) {
> +			/* Strips do not cover the whole file */
> +			rc = -EINVAL;
> +			goto out;
> +		}
> +		break;
> +	}
> +
> +	default:
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (errs > 0) {
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +	if (extent_total < meta->file_size) {
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* Publish the famfs metadata on inode->i_private */
> +	inode_lock(inode);
> +	if (inode->i_private) {
> +		rc = -EEXIST; /* file already has famfs metadata */
> +	} else {
> +		inode->i_private = meta;
> +		i_size_write(inode, meta->file_size);
> +		inode->i_flags |= S_DAX;
> +		meta = NULL; /* owned by the inode now */
> +		rc = 0;
> +	}
> +	inode_unlock(inode);
> +
> +out:
> +	kvfree(fmap_buf);
> +	if (meta)
> +		famfs_meta_free(meta);
> +	return rc;
> +}
> +
> +/**
> + * famfs_file_ioctl() - Top-level famfs file ioctl handler
> + * @file: the file
> + * @cmd:  ioctl opcode
> + * @arg:  ioctl opcode argument (if any)
> + */
> +static long
> +famfs_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct famfs_fs_info *fsi = inode->i_sb->s_fs_info;
> +	long rc;
> +
> +	if (fsi->deverror && (cmd != FAMFSIOC_NOP))
> +		return -ENODEV;
> +
> +	switch (cmd) {
> +	case FAMFSIOC_NOP:
> +		rc = 0;
> +		break;
> +
> +	case FAMFSIOC_MAP_CREATE:
> +		rc = famfs_file_init_dax(file, (void __user *)arg);
> +		break;
> +
> +	default:
> +		rc = -ENOTTY;
> +		break;
> +	}
> +
> +	return rc;
> +}
> +
>  /*********************************************************************
>   * vm_operations
>   */
> @@ -94,9 +400,25 @@ const struct vm_operations_struct famfs_file_vm_ops = {
>  static ssize_t
>  famfs_file_invalid(struct inode *inode)
>  {
> +	struct famfs_file_meta *meta = inode->i_private;
> +	size_t i_size = i_size_read(inode);
> +
> +	if (!meta) {
> +		pr_debug("%s: un-initialized famfs file\n", __func__);
> +		return -EIO;
> +	}
> +	if (meta->error) {
> +		pr_debug("%s: previously detected metadata errors\n", __func__);
> +		return -EIO;
> +	}
> +	if (i_size != meta->file_size) {
> +		pr_warn("%s: i_size overwritten from %ld to %ld\n",
> +		       __func__, meta->file_size, i_size);
> +		meta->error = true;
> +		return -ENXIO;
> +	}
>  	if (!IS_DAX(inode)) {
> -		pr_debug("%s: inode %llx IS_DAX is false\n",
> -			 __func__, (u64)inode);
> +		pr_debug("%s: inode %llx IS_DAX is false\n", __func__, (u64)inode);
>  		return -ENXIO;
>  	}
>  	return 0;
> @@ -233,7 +555,7 @@ const struct file_operations famfs_file_operations = {
>  	/* Custom famfs operations */
>  	.write_iter	   = famfs_dax_write_iter,
>  	.read_iter	   = famfs_dax_read_iter,
> -	.unlocked_ioctl    = NULL /*famfs_file_ioctl*/,
> +	.unlocked_ioctl    = famfs_file_ioctl,
>  	.mmap		   = famfs_file_mmap,
> 

We don't have compat_ioctl handler, a 32-bit application on a 64-bit
kernel will get ENOTTY, if we will have that scenario I think the handler
should be added.

Best regards,
Richard Cheng.
 
>  	/* Force PMD alignment for mmap */
> diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> index 9e8662c4ac98..98c877a6009e 100644
> --- a/fs/famfs/famfs_inode.c
> +++ b/fs/famfs/famfs_inode.c
> @@ -341,6 +341,7 @@ famfs_show_options(struct seq_file *m, struct dentry *root)
>  static void
>  famfs_evict_inode(struct inode *inode)
>  {
> +	famfs_meta_free((struct famfs_file_meta *)inode->i_private);
>  	inode->i_private = NULL;
>  	dax_break_layout_final(inode);
>  	truncate_inode_pages_final(&inode->i_data);
> diff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h
> index ff9f1d3f686e..f17380d24f6d 100644
> --- a/fs/famfs/famfs_internal.h
> +++ b/fs/famfs/famfs_internal.h
> @@ -15,8 +15,52 @@
>  #include <linux/bits.h>
>  #include <linux/build_bug.h>
>  
> +#include <linux/famfs_ioctl.h>
> +
>  extern const struct file_operations famfs_file_operations;
>  
> +/*
> + * Internal sanity bound on a FAMFSIOC_MAP_CREATE fmap message. The ABI does
> + * not advertise a maximum (the message is self-describing); this only guards
> + * the copy-in against an unreasonable allocation. Oversize is rejected with
> + * -EFBIG.
> + */
> +#define FAMFS_FMAP_MSG_MAX (4 * 1024 * 1024)
> +
> +struct famfs_meta_simple_ext {
> +	u64 dev_index;
> +	u64 ext_offset;
> +	u64 ext_len;
> +};
> +
> +struct famfs_meta_interleaved_ext {
> +	u64 fie_nstrips;
> +	u64 fie_chunk_size;
> +	u64 fie_nbytes;
> +	struct famfs_meta_simple_ext *ie_strips;
> +};
> +
> +/*
> + * Each famfs dax file has this hanging from its inode->i_private.
> + */
> +struct famfs_file_meta {
> +	bool                   error;
> +	enum famfs_file_type   file_type;
> +	size_t                 file_size;
> +	enum famfs_ioc_ext_type fm_extent_type;
> +	u64                    dev_bitmap; /* referenced daxdev indices */
> +	union { /* This will make code a bit more readable */
> +		struct {
> +			size_t         fm_nextents;
> +			struct famfs_meta_simple_ext  *se;
> +		};
> +		struct {
> +			size_t         fm_niext;
> +			struct famfs_meta_interleaved_ext *ie;
> +		};
> +	};
> +};
> +
>  struct famfs_mount_opts {
>  	umode_t mode;
>  };
> @@ -83,4 +127,6 @@ int famfs_devlist_alloc(struct famfs_fs_info *fsi);
>  int famfs_install_daxdev(struct famfs_fs_info *fsi, struct super_block *sb,
>  			 u64 index, dev_t devno, const char *name);
>  
> +void famfs_meta_free(struct famfs_file_meta *map);
> +
>  #endif /* FAMFS_INTERNAL_H */
> diff --git a/include/uapi/linux/famfs_ioctl.h b/include/uapi/linux/famfs_ioctl.h
> new file mode 100644
> index 000000000000..b4eb373c1ade
> --- /dev/null
> +++ b/include/uapi/linux/famfs_ioctl.h
> @@ -0,0 +1,91 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * famfs - dax file system for shared fabric-attached memory
> + *
> + * Copyright 2023-2024 Micron Technology, Inc.
> + *
> + * This file system, originally based on ramfs the dax support from xfs,
> + * is intended to allow multiple host systems to mount a common file system
> + * view of dax files that map to shared memory.
> + */
> +#ifndef FAMFS_IOCTL_H
> +#define FAMFS_IOCTL_H
> +
> +#include <linux/ioctl.h>
> +#include <linux/uuid.h>
> +
> +#define FAMFS_KABI_VERSION 44
> +
> +enum famfs_file_type {
> +	FAMFS_REG,
> +	FAMFS_SUPERBLOCK,
> +	FAMFS_LOG,
> +};
> +
> +/*
> + * Extent type in a famfs fmap message, and of the in-core map
> + * (famfs_file_meta.fm_extent_type).
> + */
> +enum famfs_ioc_ext_type {
> +	FAMFS_IOC_EXT_SIMPLE,
> +	FAMFS_IOC_EXT_INTERLEAVE,
> +};
> +
> +/*
> + * The FAMFSIOC_MAP_CREATE payload is a self-describing fmap message: a
> + * struct famfs_ioc_fmap_header immediately followed by @nextents extent
> + * records. @fmap_size gives the total message length, so a reader is
> + * self-delimiting.
> + *
> + * For ext_type == FAMFS_IOC_EXT_SIMPLE the records are an array of
> + * @nextents famfs_ioc_simple_ext. For ext_type == FAMFS_IOC_EXT_INTERLEAVE
> + * each of the @nextents records is a famfs_ioc_iext header immediately
> + * followed by ie_nstrips famfs_ioc_simple_ext strip extents.
> + *
> + * This wire layout is byte-identical to the fmap carried in a fuse famfs
> + * GET_FMAP reply, so the same userspace serializer emits both.
> + *
> + * The message is self-describing (@fmap_size bounds it), so neither the extent
> + * and strip counts nor the total size are capped by this ABI. The kernel
> + * applies an internal sanity limit to the copy-in and returns -EFBIG for a
> + * message larger than it will accept.
> + */
> +#define FAMFS_FMAP_VERSION 1
> +
> +struct famfs_ioc_simple_ext {
> +	__u32 se_devindex;
> +	__u32 reserved;
> +	__u64 se_offset;
> +	__u64 se_len;
> +};
> +
> +struct famfs_ioc_iext {		/* interleaved (striped) extent */
> +	__u32 ie_nstrips;
> +	__u32 ie_chunk_size;
> +	__u64 ie_nbytes;	/* total bytes mapped by this interleaved extent */
> +	__u64 reserved;
> +};
> +
> +struct famfs_ioc_fmap_header {
> +	__u8  file_type;	/* enum famfs_file_type */
> +	__u8  reserved;
> +	__u16 fmap_version;	/* FAMFS_FMAP_VERSION */
> +	__u32 ext_type;		/* enum famfs_ioc_ext_type */
> +	__u32 nextents;
> +	__u32 fmap_size;	/* total message bytes, including this header */
> +	__u64 file_size;
> +	__u64 reserved1;
> +};
> +
> +#define FAMFSIOC_MAGIC 'u'
> +
> +/* famfs file ioctl opcodes */
> +#define FAMFSIOC_NOP           _IO(FAMFSIOC_MAGIC,   0x50)
> +
> +/*
> + * MAP_CREATE carries the self-describing fmap message - struct
> + * famfs_ioc_fmap_header followed by the extent list (see above).
> + */
> +#define FAMFSIOC_MAP_CREATE    _IOW(FAMFSIOC_MAGIC,  0x51, struct famfs_ioc_fmap_header)
> +
> +#endif /* FAMFS_IOCTL_H */
> -- 
> 2.53.0
> 
> 
> 
