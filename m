Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010028.outbound.protection.outlook.com [52.101.56.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449143F5BE3
	for <nvdimm@lists.linux.dev>; Fri, 18 Sep 2026 09:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789724400; cv=fail; b=hFNQBLOP1+8ebGydnM7Mi7BNId4pUJzmGksvr6wCFtebftNDwIkUIGADWuPEBPw4ZJ5kivFNVsgr6SG4xiqfe0CT3JIrFKVUHJ6APJI98WTRqRXDlFOyYcQdWzEwIL2P4grzIGW7STkOGT6/SICJhdrkZXlhTWYxxtrXbEd0uoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789724400; c=relaxed/simple;
	bh=95S+P36065Wwu6OuUU7c2Y7m891dQIaRcGPikNDsqn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pRJRVgBbuq4SNp48Xvi6PEj6aDLFzaXMB6g6ZzkxYj7e2X4syO0h0Lax8Qa8Pu6qrbmW7M27wKlTmKgoTRdVbfwRecBjyQOhCNC1zHz4I4bn6ZN3lmntL7IZSMjWY/kFL1YPf64/5cqyoJZEGkCyCjFbKafxsUUc4F+JACzMHtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WG0VS5fj; arc=fail smtp.client-ip=52.101.56.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WG0VS5fj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yTRwummmCyTcaoQvD5HYCa4i/d+bVZZe6jGhydz5IIXbVkvhzUfFBijHzykV5LNyW8a38UNnB5j266fiwWtGbTXtauwwZjNQHZEuLcTWYxQ8EkU3r7wCjsKlr2C/EZV+Q4Kv5RylohhRcfuzui6rn0hiojJOVTuMryi3QWVMLZjlz6nmhwxv8LOB8csFOB+JUTXTckoCCtEhjgirEyH0xFsEsNQisKMHONAHDzBFxUrY+Z9OGdZEJZ5ULwnfQbeYu1v15lmQmCU5qOo18JAFh27JQfKQZBI+zR1BzvqZanh0xenAsiCpAAJxA2xPPGZT4x/g6x91GWF+ezfn4P0sng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+bTu+vfmm/3SwrmZChS/fzS6ZxW0b9AhmGeAFp4JaKk=;
 b=wwoc5AykBTN007Sylacw9/wOJUD/d3Bg6s9zBFvhnvfwP6GWVRtUtWe9ahwTSRbsf1w5pmTb8PjF2hvmaK6UKOTfM9Z4jd9nRnOC91xUAMjw5LoHCVn1Dy3LfRz/NGMBgUyWvGVKP4+pHE7jkA5ULMaCTBk9lKNk+RQJTZn1TvLkqa8TdP25kn46Qjps2hQ2o6YWTuz+c473HE+f5nFvS28YWtJDNM6yApVSZno6tmNX8bfytl8vq2qLPuf1SvsyQpvZUairxbq81HCdJRKa+4HK51JZ1MXFB7vzCiBlvxx4AhYD5uonNXpTQ8aC+Fv+aBsH+3vFn2M6Jr3XTmLUJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bTu+vfmm/3SwrmZChS/fzS6ZxW0b9AhmGeAFp4JaKk=;
 b=WG0VS5fjhUm4rSqxeHo5zD88St6/Fq3EoDtkBpbLBpTlg2Xec8VTBKVhbkBkscMwRSIcLtNZc2b8eMGXQ4Rb7RlalvwDxNOSHSO6CEeqsPBvLspPpW7gvTtD8kCP3twHtn9RyoZxSGaNEGPFvdILc8N5x+MiX74eK84ZN3G/aStqRSoJEViMzBLFrAbrC3ensFd7Slvc6ZBX8tm7AnghQ+1A/YHiekDZX2qZaYR6GuWWtfPMs3xKLPrs7bMKVXRo4hKJfZ1nXOG2l3GLhwz9oJgGVQ48dgDIrhI5rg1/17Th3u+U088whZQ1qaWqA5RMldnD2Ai0HOGAp0GZGaYhsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by SN7PR12MB6742.namprd12.prod.outlook.com (2603:10b6:806:26e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Fri, 18 Sep
 2026 09:39:46 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%7]) with mapi id 15.21.0406.014; Fri, 18 Sep 2026
 09:39:46 +0000
Date: Fri, 18 Sep 2026 17:39:40 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: dave@stgolabs.net, jic23@kernel.org, dave.jiang@intel.com, 
	vishal.l.verma@intel.com, djbw@kernel.org, danwilliams@nvidia.com, nvdimm@lists.linux.dev, 
	iweiny@kernel.org, ming.li@zohomail.com, kobak@nvidia.com, kaihengf@nvidia.com, 
	kees@kernel.org, newtonl@nvidia.com, kristinc@nvidia.com, mochs@nvidia.com, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ndctl PATCH RESEND] test/cxl-mbox: Regression test for huge
 CXL_MEM_SEND_COMMAND out.size
Message-ID: <aq0GdumB0WfxNm30@MWDK4CY14F>
References: <20260624150158.55264-1-icheng@nvidia.com>
 <aqiXdEIiMb3I9w-3@aschofie-mobl2.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqiXdEIiMb3I9w-3@aschofie-mobl2.lan>
X-ClientProxiedBy: TPYP295CA0045.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:7::6)
 To BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|SN7PR12MB6742:EE_
X-MS-Office365-Filtering-Correlation-Id: 10d54212-226e-46ef-8930-08df1568c639
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|10067099003|4143699003|3023799007|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	XIkmGej0kc+F6feULZ5HstLd6y2cUulaq82fmTlzDnTvVzv7QvOxyrC23cn/HRBQNosu420lpjjqMNSjQXGsPtJv+h4h1SHXtpjvDnllRBJ6T0foR7QfnyQEsaU2qRvkfeohJ2m0oGNW2FCGTfdAyxyf3QPK6+zlLK/LM4isdEWYqAD+FrwtyQe5YAiLoAy/RoCsvLs/TiARJquWi8OeGRaNcVZhrpCo4dszWo0sPNePmbLY+duNIovTx/G2VM1lwboL1GuSGm+r7Q6q5OvEX6Y4Qk22Cn6ryIhKzWCxPYASaoXcg/+EfvQgh3tgrcBz1dYBsOAV1zf6BU70TlRrHsoI6EqNmJe+PpaoQpXB9kVJ58mCutJ2QAKowwBXf4jtr6wY27FwgC9gKrwxtHRagz7gQ6Y2gbogphQVY/ptW639NAsPKakmF/dCoaiaeneo32IgYwooNh/igN/TdOseYHmK1ktYBzW1W+puZvR8aDMMqIf+cJvq3Oz6ylLjWjc6BW0KDT0UqevadXZEvNxXdEhloZwIcrbT9D/+eMWsDQ/9fNfSkccT7bbVguflvbDB0OeMc1FNF4PQoL2tY6yHtMRiWaTaLkqj4dn9igFHzbjbNaZLMsc3j/fjNs0iLXth75KDkcZ+yv/d1rbEJxf4F30SkXeSQhtyI1tJC6azJXY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(10067099003)(4143699003)(3023799007)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ozwba1erv8mD1nxAMvVjvQePAXp0kT717pAusmy4jK1PoogQzGgnhWsS/D7F?=
 =?us-ascii?Q?JdkUwK5HgAMndG9C0f1wiuQ9ybDyrLhtxyJiMmYqvN4YUxbXoJCLJB4Nz8dL?=
 =?us-ascii?Q?USj6VBeAbc7csZ8Bx7IkxlbbMwosDcQdvpdqXjTiQPZFA0dsc2y/VwJW1KQu?=
 =?us-ascii?Q?upgIVQ3Hx87nBbmgsa2vpQY6PXZl5V4FRulBpHpYykfu8sjSu3qMGl2zOZyF?=
 =?us-ascii?Q?5NwPaHBZmwvQ6HNoCRkht2JPz9OtDwdeQrIHIMAyn7yCfV+HPMRCLITJU01Y?=
 =?us-ascii?Q?XfQUf5sNi4uSHDHhZay4h/67ILOgFvCaCykVjFBSn4hfaVYCvgi/E/so3HSZ?=
 =?us-ascii?Q?qZ/UMSwnpbIE0bRmFXiOPEedW9AJZHqcoQBfDeZplKBnhoN9iatLrm+CgVXa?=
 =?us-ascii?Q?zrBd6SdSwBNEdsXa7Qk9jbXYQ64Smcp5XATeYVYvQZfD2B3SSWD2Om2JzydT?=
 =?us-ascii?Q?wvwmD8HoZ0bUqYk03gvuaJiblxeqV2bbWqpE9QOQ0urTkLH09KDG93MTLVHd?=
 =?us-ascii?Q?pUpjCWGjFksn+/JiG29D8vV2Dty2g6jIniKto6Vrha9tL/vWrEt6mu0B7Noo?=
 =?us-ascii?Q?YqkoCyZEiJCT88NENwbD5/exClaQ9bLuyf+mFcIot2HxYsCcvlASR0BT0QdS?=
 =?us-ascii?Q?X9p8zFc1bV6ho3+q40zjZ/y0HVFszZmTkkR6mQHZs+gF3+Pe3YQFWDGH1jCK?=
 =?us-ascii?Q?sqta2p8DmiZUs97rz76H3wnZtO8WXjdLdDWNXwqQZ+r21mjYmiarrSjdae3+?=
 =?us-ascii?Q?LvUeRp1LMIRWf1qZtxW43XknNem7uBR0STXEi6Eyqc8oJ171ijefymCh2K0G?=
 =?us-ascii?Q?N4tzmxIMjm3A465z6HR7VGz/4g+TYF70LB1lRjfzzAMhdmyZ6zdcwejCeIEj?=
 =?us-ascii?Q?v5YHjqlz9CDRdxReGJvSS/1xTZ9FRuxShPZ8mRswjknzIaOpYTOYhyu0DJqX?=
 =?us-ascii?Q?u2pnabjfFPnIlHeVo2nQLbKNe0++7iLxAAk7lwzqoMXY9f3lU+PIJmVIP1kk?=
 =?us-ascii?Q?1MOmH+XCjLGLjiLQN60KfopSEyLCXI7p5ACXeNBGueSBvuAoXtKS2wwy0g67?=
 =?us-ascii?Q?mUzv2YGQEJAZ0jLVZPMxTUFpCNR445P0TD1h0EXDACTbRk5RIcS+w2Iz9g3+?=
 =?us-ascii?Q?xeJ7pGvW6wYrA1K0AS4mVaBIK9yDav+fG0sDcsknMMWfdkXpm80+O6vazKIZ?=
 =?us-ascii?Q?1aIwEpz1ZctvI0NbRs/tManj+ab+RUN7GKSbPJ44/sEDGqzJoonHNwSNX7rX?=
 =?us-ascii?Q?heK93VsGXOYvgl2YuDwAnl/ArMbZB1axKrP+nZ3YSLgYXOH/bXccSRbsEiTo?=
 =?us-ascii?Q?rtGHlDnotvosqRBTBEUZhLDo9it31Gk3gKM0Ov9d6cw3OrNJBx9Lvhd9xKKi?=
 =?us-ascii?Q?lxlhBIAH0LhUgMq6uPk+FfMRT4z5PL8MANUTlq0Ih6P4zTUA0c66GICRbqcT?=
 =?us-ascii?Q?Ocio7OgPXnFSR6rXp0+ChNHHrlUSoRf0WUy/dLmAKUvbvPxKTcdXlRXvH9HG?=
 =?us-ascii?Q?hVg3rVqo4wT+mlUpf9zoPfmmJrwG1l3ieMzBmIhyosas2uCX7yrgMry4lv+a?=
 =?us-ascii?Q?AauyXfiWROFnXGqTNpa118vCNE9g50shx5JqEPZxVHAY5vuYK2zaxe++Ge1k?=
 =?us-ascii?Q?K47rWizo8lD5gMTnee3zJOgFRi2WTMD57WvoqA7vuJpz+gvrM8rWUR/iBVxi?=
 =?us-ascii?Q?QwJYcB8eZQrSPW29xRgQe5TPeSIpPOlyf8E/+HcgOd4SAzED/2RbUJVBWSFv?=
 =?us-ascii?Q?yCHgbMYDlg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d54212-226e-46ef-8930-08df1568c639
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 09:39:46.2263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWDvYvZe7cpozilv1OzsNxMLtrbBxgHM7PNJJc0RWntF3s+TmG37b7ZCXQ/qpnLYeJPtCtMTcXL9qq9yy9WOUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6742

On Mon, Sep 14, 2026 at 05:55:16PM +0800, Alison Schofield wrote:
> On Wed, Jun 24, 2026 at 11:01:58PM +0800, Richard Cheng wrote:
> > Implement a regression test for unbounded kvzalloc() in the kernel's
> > cxl_mbox_cmd_ctor(), which a CXL_MEM_SEND_COMMAND with an out.size
> > greater than INT_MAX could drive into a size > INT_MAX kvmalloc() WARN.
> > 
> > libcxl's cxl_cmd_set_output_payload() rejects an out.size larger than
> > the mailbox payload_max, so the test crafts a raw struct
> > cxl_send_command and issues the CXL_MEM_SEND_COMMAND ioctl directly
> > against the cxl_test mock memdev.
> > 
> > The test is for a kernel bug fix [1].
> 
> Hi Richard,
> 
> I appreciate the new test and sorry it got buried in the backlog. I'm
> appending a diff that I have tested with in my pending branch. If you
> ACK this diff, then I'll just apply with that. If you want to change
> anything else, then send a v2.
>

Hi Alison,

Thanks for taking look at this, from the first glance it looks good
to me, but I'll spend some time to review it next week.

Best regards,
Richard Cheng.
 
> My changes are:
> - wire the test into the meson environment
> - update the shell script to be like others, including using check_dmesg
>   intead of reading tainted.
> - NO changes to your cxl-mbox.c
> 
> 
> -- Alison
> 
> 
> diff --git a/test/cxl-mbox.sh b/test/cxl-mbox.sh
> index 67fecf5a3f46..1b9f95fc7836 100755
> --- a/test/cxl-mbox.sh
> +++ b/test/cxl-mbox.sh
> @@ -2,33 +2,25 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Copyright (C) 2026 Nvidia Corporation. All rights reserved.
> 
> -. $(dirname "$0")/common
> +. "$(dirname "$0")"/common
> 
>  BIN="$TEST_PATH"/cxl-mbox
>  rc=77
>  # 237 is -ENODEV
>  ERR_NODEV=237
> -# TAINT_WARN is bit 9
> -TAINT_WARN=512
> 
>  trap 'err $LINENO' ERR
> 
> -modprobe -r cxl_test 2>/dev/null
> +modprobe -r cxl_test
>  modprobe cxl_test
> -# cxl_test alone does not autoload the mock memdev module on this box
> -modprobe cxl_mock_mem
> 
>  main()
>  {
>         test -x "$BIN" || do_skip "no CXL mailbox test"
> 
> -       t0=$(cat /proc/sys/kernel/tainted)
> -
>         rc=0
>         "$BIN" || rc=$?
> 
> -       t1=$(cat /proc/sys/kernel/tainted)
> -
>         echo "status: $rc"
>         if [ "$rc" -eq "$ERR_NODEV" ]; then
>                 do_skip "no cxl_test memdev"
> @@ -36,9 +28,8 @@ main()
>                 echo "fail: $LINENO" && exit 1
>         fi
> 
> -       if (( (t1 & TAINT_WARN) && !(t0 & TAINT_WARN) )); then
> -               echo "fail: $LINENO kernel WARN taint (bit 9) set" && exit 1
> -       fi
> +       rc=1
> +       check_dmesg "$LINENO"
> 
>         _cxl_cleanup
>  }
> diff --git a/test/meson.build b/test/meson.build
> index 07c8618cbc6e..69c22c579b02 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -139,6 +139,11 @@ revoke_devmem = executable('revoke_devmem', testcore + [
> 
>  mmap = executable('mmap', 'mmap.c',)
> 
> +cxl_mbox = executable('cxl-mbox', 'cxl-mbox.c',
> +  dependencies : libcxl_deps,
> +  include_directories : root_inc,
> +)
> +
>  create = find_program('create.sh')
>  clear = find_program('clear.sh')
>  pmem_errors = find_program('pmem-errors.sh')
> @@ -173,6 +178,7 @@ cxl_elc = find_program('cxl-elc.sh')
>  cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
>  cxl_region_replay = find_program('cxl-region-replay.sh')
>  cxl_type2 = find_program('cxl-type2.sh')
> +cxl_mbox_sh = find_program('cxl-mbox.sh')
> 
>  tests = [
>    [ 'libndctl',               libndctl,                  'ndctl' ],
> @@ -211,6 +217,7 @@ tests = [
>    [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
>    [ 'cxl-region-replay.sh',   cxl_region_replay,  'cxl'   ],
>    [ 'cxl-type2.sh',           cxl_type2,          'cxl'   ],
> +  [ 'cxl-mbox.sh',            cxl_mbox_sh,        'cxl'   ],
>  ]
> 
>  if get_option('destructive').enabled()
> @@ -292,6 +299,7 @@ tests_deps = [
>    daxdev_errors,
>    dax_dev,
>    mmap,
> +  cxl_mbox,
>  ]
> 
>  if get_option('fwctl').enabled()
> 
> 
> > 
> > [1]: https://lore.kernel.org/all/20260624144147.53997-1-icheng@nvidia.com/
> > Signed-off-by: Richard Cheng <icheng@nvidia.com>
> > ---
> >  test/cxl-mbox.c  | 129 +++++++++++++++++++++++++++++++++++++++++++++++
> >  test/cxl-mbox.sh |  48 ++++++++++++++++++
> >  2 files changed, 177 insertions(+)
> >  create mode 100644 test/cxl-mbox.c
> >  create mode 100755 test/cxl-mbox.sh
> > 
> > diff --git a/test/cxl-mbox.c b/test/cxl-mbox.c
> > new file mode 100644
> > index 0000000..d81327b
> > --- /dev/null
> > +++ b/test/cxl-mbox.c
> > @@ -0,0 +1,129 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// Copyright (C) 2026 Nvidia Corporation. All rights reserved.
> > +#include <errno.h>
> > +#include <fcntl.h>
> > +#include <stdio.h>
> > +#include <stdint.h>
> > +#include <stddef.h>
> > +#include <stdlib.h>
> > +#include <syslog.h>
> > +#include <string.h>
> > +#include <unistd.h>
> > +#include <sys/ioctl.h>
> > +#include <cxl/libcxl.h>
> > +#include <cxl/cxl_mem.h>
> > +
> > +static const char provider[] = "cxl_test";
> > +
> > +/*
> > + * The cxl_test mock advertises a 4 KiB (SZ_4K) mailbox payload_size and
> > + * IDENTIFY returns a full struct cxl_mbox_identify. Post-fix the kernel
> > + * clamps the output allocation to payload_size and copies that many bytes
> > + * back into out.payload, so the buffer must be >= payload_size. 64 KiB is
> > + * comfortably above the mock's 4 KiB payload.
> > + */
> > +#define OUT_BUF_SIZE	(64 * 1024)
> > +
> > +/*
> > + * Regression for the unbounded kvzalloc() in cxl_mbox_cmd_ctor() driven by a
> > + * huge CXL_MEM_SEND_COMMAND out.size. The kernel fix CLAMPS the output
> > + * allocation to the mailbox payload_size; it does not reject the request.
> > + * Assert the ioctl SUCCEEDS (no -ENOMEM) -- do NOT assert -EINVAL.
> > + */
> > +static int test_cxl_mbox_huge_out_size(struct cxl_memdev *memdev)
> > +{
> > +	struct cxl_send_command c = { 0 };
> > +	const char *devname;
> > +	char path[256];
> > +	void *buf;
> > +	int fd, rc;
> > +
> > +	devname = cxl_memdev_get_devname(memdev);
> > +	if (!devname)
> > +		return -ENODEV;
> > +
> > +	snprintf(path, sizeof(path), "/dev/cxl/%s", devname);
> > +
> > +	fd = open(path, O_RDWR);
> > +	if (fd < 0) {
> > +		if (errno == ENOENT || errno == ENODEV)
> > +			return -ENODEV;
> > +		fprintf(stderr, "failed to open %s: %s\n", path,
> > +			strerror(errno));
> > +		return -errno;
> > +	}
> > +
> > +	buf = calloc(1, OUT_BUF_SIZE);
> > +	if (!buf) {
> > +		rc = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> > +	c.id = CXL_MEM_COMMAND_ID_IDENTIFY;
> > +	/*
> > +	 * 0x80000000 (2^31, > INT_MAX) is the proven reproducer that trips the
> > +	 * size > INT_MAX kvmalloc() WARN. out.size is __s32 in this vendored
> > +	 * UAPI; cast to avoid -Woverflow, the kernel reads the same 4 bytes
> > +	 * (kernel UAPI declares it __u32).
> > +	 */
> > +	c.out.size = (typeof(c.out.size))0x80000000U;
> > +	c.out.payload = (__u64)(uintptr_t)buf;
> > +
> > +	rc = ioctl(fd, CXL_MEM_SEND_COMMAND, &c);
> > +
> > +	/* Pass iff the kernel clamped (success), not rejected. */
> > +	if (rc == 0 && c.retval == 0) {
> > +		rc = 0;
> > +		goto out;
> > +	}
> > +
> > +	fprintf(stderr,
> > +		"CXL_MEM_SEND_COMMAND huge out.size mishandled: rc=%d errno=%d retval=%u\n",
> > +		rc, errno, c.retval);
> > +	rc = -ENXIO;
> > +
> > +out:
> > +	free(buf);
> > +	close(fd);
> > +	return rc;
> > +}
> > +
> > +static int test_cxl_mbox(struct cxl_ctx *ctx, struct cxl_bus *bus)
> > +{
> > +	struct cxl_memdev *memdev;
> > +
> > +	cxl_memdev_foreach(ctx, memdev) {
> > +		if (cxl_memdev_get_bus(memdev) != bus)
> > +			continue;
> > +		return test_cxl_mbox_huge_out_size(memdev);
> > +	}
> > +
> > +	return -ENODEV;
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +	struct cxl_ctx *ctx;
> > +	struct cxl_bus *bus;
> > +	int rc;
> > +
> > +	rc = cxl_new(&ctx);
> > +	if (rc < 0)
> > +		return rc;
> > +
> > +	cxl_set_log_priority(ctx, LOG_DEBUG);
> > +
> > +	bus = cxl_bus_get_by_provider(ctx, provider);
> > +	if (!bus) {
> > +		fprintf(stderr, "%s: unable to find bus (%s)\n",
> > +			argv[0], provider);
> > +		rc = -ENODEV;
> > +		goto out;
> > +	}
> > +
> > +	rc = test_cxl_mbox(ctx, bus);
> > +
> > +out:
> > +	cxl_unref(ctx);
> > +	return rc;
> > +}
> > diff --git a/test/cxl-mbox.sh b/test/cxl-mbox.sh
> > new file mode 100755
> > index 0000000..67fecf5
> > --- /dev/null
> > +++ b/test/cxl-mbox.sh
> > @@ -0,0 +1,48 @@
> > +#!/bin/bash -Ex
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (C) 2026 Nvidia Corporation. All rights reserved.
> > +
> > +. $(dirname "$0")/common
> > +
> > +BIN="$TEST_PATH"/cxl-mbox
> > +rc=77
> > +# 237 is -ENODEV
> > +ERR_NODEV=237
> > +# TAINT_WARN is bit 9
> > +TAINT_WARN=512
> > +
> > +trap 'err $LINENO' ERR
> > +
> > +modprobe -r cxl_test 2>/dev/null
> > +modprobe cxl_test
> > +# cxl_test alone does not autoload the mock memdev module on this box
> > +modprobe cxl_mock_mem
> > +
> > +main()
> > +{
> > +	test -x "$BIN" || do_skip "no CXL mailbox test"
> > +
> > +	t0=$(cat /proc/sys/kernel/tainted)
> > +
> > +	rc=0
> > +	"$BIN" || rc=$?
> > +
> > +	t1=$(cat /proc/sys/kernel/tainted)
> > +
> > +	echo "status: $rc"
> > +	if [ "$rc" -eq "$ERR_NODEV" ]; then
> > +		do_skip "no cxl_test memdev"
> > +	elif [ "$rc" -ne 0 ]; then
> > +		echo "fail: $LINENO" && exit 1
> > +	fi
> > +
> > +	if (( (t1 & TAINT_WARN) && !(t0 & TAINT_WARN) )); then
> > +		echo "fail: $LINENO kernel WARN taint (bit 9) set" && exit 1
> > +	fi
> > +
> > +	_cxl_cleanup
> > +}
> > +
> > +{
> > +	main "$@"; exit "$?"
> > +}
> > 
> > base-commit: 8ad90e54f0ff4f7291e7f21d44d769d10f24e2b6
> > -- 
> > 2.43.0
> > 
