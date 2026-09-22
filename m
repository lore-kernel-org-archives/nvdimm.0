Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013060.outbound.protection.outlook.com [40.107.201.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BD943F4AF
	for <nvdimm@lists.linux.dev>; Tue, 22 Sep 2026 09:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790067735; cv=fail; b=Ff2iyvtVRtSUvWApnjbo3hn5KlvpMIMRzu+nOSVB8jJk+zZvtZhjtbcuX/E5Xlq/OJljwbQCC32aGCAudhuTgU6tGYnPODgSLB5I0ODFD8IQ27qzig0EnpWVwWvdO4MN+OcITCNGZ97PT35vWEiH19sYhiH9qAeF0oIjNRB3b08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790067735; c=relaxed/simple;
	bh=DP6ytjUTt87gy/IZaTGhuQg16nsz0e4B1z0CoZA8vFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NY4jmJkXlu0LtD8XzieUD2ZpJ5gRK6IobjkWfG6a4Fn7WAi219mUoqNGqBasOf58aQwLjTF0nkBrBHM+phxG9goOqNoBgi7XVBjQOy9M4VRRHNFA41eZ4FhcIVR1PTuRDbtfwBp5fXAuzqoM/QTjMFI+NOdC0LuTKJa55sPj01o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=guHUWM8F; arc=fail smtp.client-ip=40.107.201.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="guHUWM8F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LQi92a93p2lLvWmtQ0p9gSJSqXZ7DFON69j8x0LYwOqwClYCBMxc5OBc0yPM2PP261kEXXn7Pa4PBSCNgzpxW7wvRJfYpSJSAmibymVhv2W82+gOuYMkCcm7v1Boz1rmg1rEqTwvaKv97pqdCsxEXGWm4CQ0KTIOQ4Z8nCq+3/EespSFXiZmw5oDTANakuyofzh9PeOIoXi78e5KofuonN+PgFuksux+PwU7g9hgSnkmy+t5kGb/IW6s/vRGZ45/eIVCRa+J4lml/seJu8eTyuFOTcdEKgOqOreOW/kj4LZU+LtqJmLxX/HIomfiDGXyBhKomWAqfyagniRfprXQAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GM1vSTvAk1SnLu/aIcNZ0Px556JR82N2zHVRLdGlCnE=;
 b=j7TeYTKZee4WkwzgBLF09EEFna1qAdSrSYDUSDafA2/+7lNUffR8vx6Uw5DCI6GJYBfzUC0YGrkNHPS+0aRENyl/m+7RKQc0hY+RoQ2YzBOuYliNi+2YuFhy5q4XsYv2g6GWPa8ooGcvYIMYoFEBj9b4XK3VuVfOlsecp72DemPayRqdF9F/c3jjNghYnS9q85x0S5+0JsV4huUlDTIEt3QnbGl1l145tOkBIgempn7QBUhLytLjdUszXdb3WMYKDNJ6GSzOSq0XgT4UuagKoVx/j7LnMdO4jTmbgn/II7Z6FxqtWafd5ZXt/WGU79d+Lg0B/yNUhlGgY+pRftsoxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GM1vSTvAk1SnLu/aIcNZ0Px556JR82N2zHVRLdGlCnE=;
 b=guHUWM8Fx94ugysYM9EaUHVxfmZL7XxMMPo813sGt43qtARERe9pcKodu531BQRcySl1CDzN0MG+0dZaMVPdjj5CaEBqK4WpF0EL6QOJkr1HB2k8NOab9XmQWXACrb8B69o1WOscorgMQxXYBoz+Tg2Clw6UaoLb3c7lXgF6EYuqvpgurypRj+q/C5uCyhRNBb9Qfq38fd/FQuAxXVbyoO5SkcJDhcZArowbYYTeKY+TEAOxOQGtCx2lVKMUBhQEXj+NU/i2Et0mFqDRdJYa9bH7QZpj+lMsoDQeNwg/PJvptrMR3PY8gCOxy/skdur0+GMlwcutQ+Rby7rxFBve4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by MW6PR12MB8759.namprd12.prod.outlook.com (2603:10b6:303:243::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 09:02:07 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%7]) with mapi id 15.21.0428.014; Tue, 22 Sep 2026
 09:02:05 +0000
Date: Tue, 22 Sep 2026 17:01:58 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: dave@stgolabs.net, jic23@kernel.org, dave.jiang@intel.com, 
	vishal.l.verma@intel.com, djbw@kernel.org, danwilliams@nvidia.com, nvdimm@lists.linux.dev, 
	iweiny@kernel.org, ming.li@zohomail.com, kobak@nvidia.com, kaihengf@nvidia.com, 
	kees@kernel.org, newtonl@nvidia.com, kristinc@nvidia.com, mochs@nvidia.com, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ndctl PATCH RESEND] test/cxl-mbox: Regression test for huge
 CXL_MEM_SEND_COMMAND out.size
Message-ID: <arJDl7DmQJzQQu9-@MWDK4CY14F>
References: <20260624150158.55264-1-icheng@nvidia.com>
 <aqiXdEIiMb3I9w-3@aschofie-mobl2.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqiXdEIiMb3I9w-3@aschofie-mobl2.lan>
X-ClientProxiedBy: SI2P153CA0005.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::11) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|MW6PR12MB8759:EE_
X-MS-Office365-Filtering-Correlation-Id: 75ffa5e8-1bbc-4cfc-4a78-08df18882c48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|10067099003|4143699003|56012099006|3023799007|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	fZxYOsm1RUQR2F+nIgj4ZxKVzOgSZ44dYiVziie61Ed6BhfTpzn1Mkp9/zIfoCF+eits4bpiIcSCYq0FaBH61fs9XfajOMEqOxMASk6nhC4y+AlrNpfw2bEiKi4OWHAhMTm4k48iEoYJKR54wbJPXa5d3yLAzSLlkKdMNQdGHoR7nkdaXrNz7GgdW9bTU/buvnXcNmQ7nOMrOnZ1vnhjbo5a9Em8voPYIO2Zos8+aBnl4QstDiU80fyGVEBlQU5drDSHPz8MjPSzTy+3a/m+aGoTCg5//+ULV73ztrYVIMFxRLYTuT/VRZeShh0ZRX1falpVCf76tqDv8TyDK2PYupMXEaYvdL/Y6qDr2wJSCfEVtPm4+sO/nNjKYX0bF5Zaic1JvZUippmPmSUBD6ff3GeI++6dN//TJmsZQoEoJCAOCfTn7KGgTw02Us5mTNpGHWF5UxLNibm1+gNUUrieIg9O5IdTLT1FIFN++lMeO6b9Odrxa7dtqsnACWyGZGi1h9SPwg5nANMo+KyhFB6ZuRGtGwoc+bZMTRE8G+lGW6UYnTKRfNyNEBgyMfa5USE9Ev/PcK87+dekdV3WezLG+Ad+iqyhHuYM78/y8k5OAk1udx936vq9Q/2Exr+TqwJWpxwZYFasQAvpjx8u/18f6wrhm2a94Hs6edcPnlbVldA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(10067099003)(4143699003)(56012099006)(3023799007)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qqHu/i0SahtdfejNff6LzJ9nC495mZIIwaVAdHX9jfmhu6CrztFugRMlkIpm?=
 =?us-ascii?Q?CNvod5z4Eol9QAkc+uIyC0eHzMyNYvqZC2O0rpo9p4ar38Xs8ifT0kbdabh0?=
 =?us-ascii?Q?MJiL801xVer+6r3vMIx5iCqayJMk1+U1mAoR276gtRRcrnB1FDpxIns+mXyb?=
 =?us-ascii?Q?H4aU0PBWxE3jiF39kUfmNH/aYjDIXAB2ruRS+bpXz3D4gwH0YVwcTePAQ5oT?=
 =?us-ascii?Q?qKOTD8fj26TPOPySrc1AcsRBz8OhuPImY6wNdk8XdUEUU6PyyUgg0YIISIjR?=
 =?us-ascii?Q?kpmdUvLcbvDEKJSBfy2W0Z3SsiPFCob6oaruWgO8iokDDY5ajf+Y351tIP/R?=
 =?us-ascii?Q?0SvuAKtrRTHjRs/prH67z+iXA2rIDDbmTQkOtRuwW4LjYF/79sqDezyh+a2F?=
 =?us-ascii?Q?c8mgqfVFOESVR6Xl8Tk4Hg6B57TfWjTGXY24Fw3ALOfWid+xcyqWevcbm74S?=
 =?us-ascii?Q?ZhoPENLphjVb9COsnAd56dRzMa2t5WKPHq+5+yBcNSePsqo/2eUQ2AZZAVA9?=
 =?us-ascii?Q?tc9TQNJNZBTbqwS+3COsmlOyK9f2lC7p9KecQ/iMOQKjRmZM49eXxFYAHpYP?=
 =?us-ascii?Q?O4eVGVbIdApHqBTCpfNi+bAWKgDR7bUrKAVbNo2exR9HBlTk3aelCR60ZckA?=
 =?us-ascii?Q?hSAYb9OCF6tE/sCweuv7N4l11rUdUL4Hlvb9hz9n2etkdMXEsSnYYon8TDUh?=
 =?us-ascii?Q?yW6WogtVtx7d2UQTLE+UPZONTnNqfBayBPmvMxZWMS1h5Jibp9U9TtZVIMSa?=
 =?us-ascii?Q?YMN6HHfw6nj0AO/cuAUgyAnK6hg3Xbwb999kv0I8vtHGOPV6wZH+8VXS+Lbc?=
 =?us-ascii?Q?wYwX7FkFr0agPrgcJ/47tde1tQ+MWD7QZLayM+IWYs0+KVBXH7xhyJxL4xpa?=
 =?us-ascii?Q?u3dwrdIzFPazEIwyN/CYpJ5PlM8EVbkkjDjCMuEfj2yh3VGOOaKb66pGoGLp?=
 =?us-ascii?Q?CqBC6lCQsuxnXfVmZxDOgZKMWJqS/7UGYdu/HXnqMMATxsUoXVaCkIVOwVwZ?=
 =?us-ascii?Q?PyOeN9HvKclTMIpbfhWVUZtKOwH9zK2i+vXcYIj+PVAemmq7RL3Oj3sL1Xef?=
 =?us-ascii?Q?MaT5x6DOQ+WphGbQCNXKU2VDvyrfbvPX0gBUndMtLgRhgexLo1DVHBnDctkS?=
 =?us-ascii?Q?iHkBE0PgIoG2ppiXsBhr/92OqFNVrZEO2YsENnJwz/A9camPRqaOavtWhcYI?=
 =?us-ascii?Q?reJmx393Nqmy0h+D0tDdNDjgA9tKFHgu6X8o05xg4kQXtgITondA4CxUUdPw?=
 =?us-ascii?Q?e4ddIVO5KomuKGHV2V8s9RsdqNGh8xVTmGcFvKn3JbvOuf4sB+c94CLHJmgP?=
 =?us-ascii?Q?3P2l4I45KzMVo9SCcFl3ZkVTFE+dmVLDPM79fa90ss6CmChhqPftV1n14t/l?=
 =?us-ascii?Q?W1ykkKGjfuAIUEjiAGfnwO3tUsci2nPI0WbsOVR9RWyh9pOnkp1uXrTLuYM4?=
 =?us-ascii?Q?k+UzovhUx4xTpoErJNdj452jV2PsRNZaG2AbBg5UGO+oa0OYKWHLPrn5IMjr?=
 =?us-ascii?Q?mBS033DM4hdwapFTeQSpl35w3Cm+zFzLBdyOUHNpFmjYxNGKRrszc0g/Nk8d?=
 =?us-ascii?Q?37imlRQLmJzz04tYeme+VmyPZVneBYmdY/dYnfPBMXGcJac5L5fc0GqjFHnX?=
 =?us-ascii?Q?8FgyJ8tO3PxnehnK/EOTApfx8wGG5IIvXyCZ7TbDz0ySGTLNgKS9UNr0p2/9?=
 =?us-ascii?Q?MBOxObxU89DlqTg+3M620tkzF/RAJmcL5SXb/zxlchFY5/Ba3mitmUkZr6LW?=
 =?us-ascii?Q?s0qMUvQ6gQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ffa5e8-1bbc-4cfc-4a78-08df18882c48
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 09:02:05.2131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S23tLanD6xARy7GPJCP6ya9Dt6c8+NlnjoR0djNwTXY+QjuGe6IMZTIsiiv4qJDetZVqd0eYOgxBCgeuTJ3bVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8759

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

Hi Alison,

Thanks for your kindly review and the modification.

Acked-by: Richard Cheng <icheng@nvidia.com>

Best regards,
Richard Cheng.

 
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
