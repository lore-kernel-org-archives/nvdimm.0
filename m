Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE922E737F
	for <nvdimm@lists.linux.dev>; Tue, 15 Sep 2026 00:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789433728; cv=fail; b=kSMrumeiZY1ncG8qN7IAqvVJ0FjloreI7PQW1AOph9Vr4X/L+VQTltNoJL823qhUEM0gZy6Z+0ftzgyGR30Hw7ApiM2LBaPrrnVsqEytYyd5LSdCiFD+WaD0eo/7frUawJpdfsuVmj9ZVYWlljzTeZZygRYueiJlNVEAepiM9Oc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789433728; c=relaxed/simple;
	bh=DOnixE5gdmIZWQubnpedOHKw0od2jMbzq9d/xr4NrUc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ck0okX5C+KD6LIY4Rt+VFhrcWx1Fa1AfMhUvSx9MI9MYCfxCW2kKFxSkl3JsWNnpOBCe0YrFqnoMRB4ln6va0mubSO54/+2ImDT7o8wBCQTSiJGpP2svTLoh37vT/LExJbZW/h47sVs+arbXCYne6pb0w9tV+kT6+8FjX3r86I8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VdQxPrga; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VdQxPrga"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789433726; x=1820969726;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DOnixE5gdmIZWQubnpedOHKw0od2jMbzq9d/xr4NrUc=;
  b=VdQxPrgahAQJI//6L8Ak4vKSXtUEeYpbe2/I2qBqjqGp89svldsL1ptr
   w8bJutE7g18VDxZXUDiyArTFHfz1RiL3voK5Xd+TbNBK1r9z+Xf6MEDT6
   U90PTM85egMRpU2OKyPz1GGjnDdxbJQ0ZM0xbQxlOHdzhwI3Jc5nUCubp
   j1LreSx1HrWKC2TBuCww4MG75mX3kC7ktGSKgjPbRc2y9RmJcqLzwvVKy
   /nepaSvwNZEjAr26C/VMrSCVReauQ+2d/aCcqzvpBk0Okt9Q9Kya9c/ux
   H+kulgU5e7CUlZAUiKpYqrL3gHIBaYuBZ3uEMq+AAN+tn1+LrKWJgfQXQ
   A==;
X-CSE-ConnectionGUID: ZVbBNeTsSXSgwQvV/A6WaQ==
X-CSE-MsgGUID: GR+JO/TkRSSa95MRbX6NVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="89817321"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="89817321"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 17:55:26 -0700
X-CSE-ConnectionGUID: jc/YIYmOQpa7RUBGzHKlAA==
X-CSE-MsgGUID: In+f0esbTM2KpGdePBwy0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="276318427"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 17:55:25 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 17:55:24 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 14 Sep 2026 17:55:24 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.26) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 17:55:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=THIDp7c2J/Wki1Sz7JF98JzDtSo/U2gVpryM3FschvWYFksbWKpIs3rle9Yn3RKyEUGfvwz60FIw+ibbWwA9ftkroZ77l0vwKoSZPDIPt4dOtxXz/7k+NXWXgJZFVf41PTm6VfgFNOcLygNY/axv6PtycDBWU03MV+DeAz78eRQhttJyi1ZCMRH6a5kqwwPOilyUcj28jBozxpSUqE/N2zlj3c2/u17VxMlhHfKzwj6O8vHYoDtVf3lBZU6hvIy5BL7VSVZEIhzaSPnVCO/bVuvKzdsyyBmL6BSg2JRMdkf8TS/FDDrWWJL4PHff0kI4v3mD3Tc4Mt3gGfLWekAx1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SfaOKeGx+sjPfM++CFO9vJkTF9FJ6wkuX3ghVrXfiZw=;
 b=cmFey0uficDVxsZZTrHSbGgqWpG5eM4c8lNyFCqzILKcqvsyl6yH0viVIoy6RIVhdBlT2cJX6Hro9na5iRa3Tgr5tnr0qoknQdzSUKS+dFix0o1lp58WIMH64ps8Bb7Z7CcKW69XUO+aIYckykZaS0swWVFcgAu/nI58egQT7i6IkGbgG8xIEozwRXRkcH9/P9f8qQZ5LopuDj6QWbQ/DmSHKfAsK7GA0O3J6QE9xyCErpdxF+YwkDyksVEFHSDf8Xp9YpOTWvfTJuKkbhkDLnR/3iN7+ElUjwm/WWRR4pPyfQdhLRNQ7aKKQ2PXtr2M06Nm6tdbOc8kAtjYytecYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA3PR11MB7555.namprd11.prod.outlook.com (2603:10b6:806:311::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 00:55:21 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 00:55:21 +0000
Date: Mon, 14 Sep 2026 17:55:16 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Richard Cheng <icheng@nvidia.com>
CC: <dave@stgolabs.net>, <jic23@kernel.org>, <dave.jiang@intel.com>,
	<vishal.l.verma@intel.com>, <djbw@kernel.org>, <danwilliams@nvidia.com>,
	<nvdimm@lists.linux.dev>, <iweiny@kernel.org>, <ming.li@zohomail.com>,
	<kobak@nvidia.com>, <kaihengf@nvidia.com>, <kees@kernel.org>,
	<newtonl@nvidia.com>, <kristinc@nvidia.com>, <mochs@nvidia.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [ndctl PATCH RESEND] test/cxl-mbox: Regression test for huge
 CXL_MEM_SEND_COMMAND out.size
Message-ID: <aqiXdEIiMb3I9w-3@aschofie-mobl2.lan>
References: <20260624150158.55264-1-icheng@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260624150158.55264-1-icheng@nvidia.com>
X-ClientProxiedBy: BY1P220CA0050.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59e::12) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA3PR11MB7555:EE_
X-MS-Office365-Filtering-Correlation-Id: d1e30fbf-19e9-4e48-1765-08df12c40463
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|7416014|56012099006|11063799006|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info: lvOBgwIIrZQyJjduxLMEqRCjlesGxl2S9gQxJoh66Yum0yxJvzCYoc7WWEAl6fXEdOiC0RdvKR50xD5ntQmF7AJaIW1Kj/YK1icPLFc2qkeBcxtkzSehA4H0k4+WJp6CsVpXqvMayM4ZPq3K/qWcVH/hvY7ghZlpioEOA8zJQFdplOliBQARlN7rA0XOmY4zmF7TZ0V8uloyTcEGjn+RSvLe4kSZZdpzRE9Vx1ugLtw43fZHT6fVt9oO7vy2a/YzAKXOe5azJyO4DLddwVPBMbI5XCIm4mjO0RsnBf2OAByW2/+qpvFi8ciQ0zV82t1Kjz6/Pdqiqw5kEXPamNAVks+2qFeoqOgwJlkb3GxlxcLgeH3PFa4XNZMnZRrJ8XluoJwXuPjryqMH+M42vskCT5JfdDAa8N+g4wUFVvfrbavBcoOf9uQvFuuagYsrLgq2Nai1LPIQ9H3p4ka6gFWjtsYkE2WUpigIKR+d0MsE1sAl7HKki97vG/aGDOLFyvPmlbAo5VT/oZsh2e6lpNXMwd2QP8jdOzaPjORcnrcgsiHnDtv0RI0N61W5O52ZET4dsFQWZN6Arw0lkl0sf0sMUj2Q5IXQmmmYRIQD5IhpEHm0lIct1D+1WMuXwEhH9NmqxAl5yzo/ZKJwpIN1AE8KuIwLS/F66zF7lxJS28Uo/7o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(7416014)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jRdyQcZrPcQOo0xATRToJVNYqUcFORCg9/y2a7EpzioGuvATCBydeorEzc0U?=
 =?us-ascii?Q?2XlFa2Upi/wjNqNQ9WYXDY94LGL9uClCxALmzFqS/dPWsuiaEgMQw+IRq3Fn?=
 =?us-ascii?Q?H9LlKQxDoZyWvnGD652ucQz40zJ0+YofrXD5a+lHCK+WqneA+Kzrps0GHIMB?=
 =?us-ascii?Q?8DDXj8lXXmP5soRPw0sjqdrjRLlyw0f2wX4wdXqUeTmNsdSJhSLPwBinkzJe?=
 =?us-ascii?Q?/fu2eYaMzGwJJ7qBKHDyoK0iZp46DpImTCYkDHPuaG4lZHdVsrYtNtE8lFnu?=
 =?us-ascii?Q?OLdiurCU0TWduLgAk7anQucEugHYtEW62PIRR2MJEV70mVbMVTMQrfkACrO7?=
 =?us-ascii?Q?yA7bHshCOQ6uHgWNw/sixjFit8xeyYNOGiEgwYvjMl3q8ouRlVNhhckyrOg7?=
 =?us-ascii?Q?6L7n2rSxdjq+bQNxWLDNqAB+h9zFtgLNfxY+sQJvSpogqq6ZLerb5OACVcwq?=
 =?us-ascii?Q?I8m9VjZy3GUINbDxue3ZaFBCsVWHCsrTCEmF2Io1LORQGLzAlVKhpaMtG6OF?=
 =?us-ascii?Q?4GUCwoNXZBjf/pWwOFx04VYRQJU8aiUSZCnkCC4Q08VptsKIuQgqgUdruYMg?=
 =?us-ascii?Q?+3Y/kgz4gJpV/gQhvwgwTxUzG5zwUyizaritYd4PKp0lPg4WDTuKYQrqudrG?=
 =?us-ascii?Q?lgihgJ2jWaslIrt7UgHmlngsdwyBCVd7yokhLyFbuo3rCo9tUgTmdTf2KmA0?=
 =?us-ascii?Q?s2dVgZheWLQYXc05YK8pZ1XEglD2VGiIJfe0hV5deUQxQkG+T9TG9Rw4P8wK?=
 =?us-ascii?Q?qmvMrjMhL7B83Gz/Vt5hJEefyJn3DYsIe7ID17g/1HpDtDZcDpbTr4q4LHJ5?=
 =?us-ascii?Q?CwPWmcelJ26+ohJpzAXxfIzx8K8lA8NaaobLwCukzE5ABK1s9Jgyx1fsgX7t?=
 =?us-ascii?Q?KqSRZbAlBSHH0P+u/jp+xLEzRbE3GPSqB5os073I4kby9AqpbndBTKuEQPDo?=
 =?us-ascii?Q?hHpIvQZuqKxHaU+k+zc/RqIDwQ7eQQL/Rpc8ycHXvKx5NaHVL/evBJb0478o?=
 =?us-ascii?Q?gCcIiXj89skwzDHxOe+CKnszAnfXVcS1ghM7MbaEVE9TNb3fwKhhqP9Tvzrr?=
 =?us-ascii?Q?tC9NWHHccSFMoPs4xXnUVr+nqyKi6+QL4CXtEm4Ghh5W31493D9SrtuvYIvc?=
 =?us-ascii?Q?PF+nePAlXqur/iS1+tfBz2e4lZsb4BPxmdoO+sh7zAEBoPHB4Vxt9jhMKfmk?=
 =?us-ascii?Q?JBFOPMNlGg4InDEuENqstwnoezZbJEspHMoxs2DAJxzR7qDjNJFqEW8Bxxfp?=
 =?us-ascii?Q?WZ+B2HA4MQTAackM8dkRzlQFHYdNinXzn4yksLAnmNOhq43QfNpVWsrII37f?=
 =?us-ascii?Q?mHdiP/jVz93hYMj/n86y1g3gaMcuOYqVsd1Qx13G1vpxqsTGXdQi2N5BbPN2?=
 =?us-ascii?Q?08e3gkThhpRuubO10IvW0D17C09gpwcs49hvFgMyMPOGwco/yXSpUTYaGVeW?=
 =?us-ascii?Q?dYO+u/a6NPJ3k8a59DMmxheeTDGofcWl+CX+d6pwSGjBzyN+QrEJEInpzAfj?=
 =?us-ascii?Q?Flyu6hS94flDOoJWpTNeAQq+yx5Jzfq3mVIO2NZc7IgTkL2NKDPhlzl24RpZ?=
 =?us-ascii?Q?q3JetaNHdY8zaoIkCwjvodQFDn341kRBLEqBITd2sTjDaiyAaZlUXOd0TYlB?=
 =?us-ascii?Q?c0ukra/cnVtngbT7u9MwxMR/shS3fqsH1/bsfmKQFpulgcgIUwVOdW2aFCrs?=
 =?us-ascii?Q?4ggr6UH1YZfXP6fZ2a3IpHBJwaA5/eMbG8wLWzBJ5LKBEYLWcZlZfZiZnWLG?=
 =?us-ascii?Q?d8Bd7je/+goF7h8KAgVBXYspxGszH00=3D?=
X-Exchange-RoutingPolicyChecked: 4BtPZV5X8Gcmhhmoxy915netucvaB9Ry46QVXwYY7ic+7ILyQqTuhaCbNZUF5ccxlo0EvbOYM3HouiRUYobgK3cQDJMW+5ProxFAtoAor9/pZaI2qHEDc2Ca3xVnTHMLrNDWVYsbaIK7JcQ3wL66thAHfQ7mXpFlaty47RCVk0BUEg/xkw0jZw3XZ9BH/MLugMFqByYGQgXAOezMYcrW1myDKely28A2JuBWJYefWEkLZjIwdPuvbyUyADErpQ4fZX6XR0tJEddiGy1uzGwo7ahGmSNusox1y3aNi7Itu1SBw9YwOx9Dw41DPUdMJKQbd9c/Q1/oQq9zToEfxmH3/A==
X-MS-Exchange-CrossTenant-Network-Message-Id: d1e30fbf-19e9-4e48-1765-08df12c40463
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 00:55:21.0334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dG2RW1FWVJdKXAe2npD7vyMkNYzh0Q3wvYNZQKKgZEzK0ScKZEftXLyKHntX/+SX0AfOlfM0Asua73ru7frNLPP1LJOJNiIYTJjosKagLLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7555
X-OriginatorOrg: intel.com

On Wed, Jun 24, 2026 at 11:01:58PM +0800, Richard Cheng wrote:
> Implement a regression test for unbounded kvzalloc() in the kernel's
> cxl_mbox_cmd_ctor(), which a CXL_MEM_SEND_COMMAND with an out.size
> greater than INT_MAX could drive into a size > INT_MAX kvmalloc() WARN.
> 
> libcxl's cxl_cmd_set_output_payload() rejects an out.size larger than
> the mailbox payload_max, so the test crafts a raw struct
> cxl_send_command and issues the CXL_MEM_SEND_COMMAND ioctl directly
> against the cxl_test mock memdev.
> 
> The test is for a kernel bug fix [1].

Hi Richard,

I appreciate the new test and sorry it got buried in the backlog. I'm
appending a diff that I have tested with in my pending branch. If you
ACK this diff, then I'll just apply with that. If you want to change
anything else, then send a v2.

My changes are:
- wire the test into the meson environment
- update the shell script to be like others, including using check_dmesg
  intead of reading tainted.
- NO changes to your cxl-mbox.c


-- Alison


diff --git a/test/cxl-mbox.sh b/test/cxl-mbox.sh
index 67fecf5a3f46..1b9f95fc7836 100755
--- a/test/cxl-mbox.sh
+++ b/test/cxl-mbox.sh
@@ -2,33 +2,25 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (C) 2026 Nvidia Corporation. All rights reserved.

-. $(dirname "$0")/common
+. "$(dirname "$0")"/common

 BIN="$TEST_PATH"/cxl-mbox
 rc=77
 # 237 is -ENODEV
 ERR_NODEV=237
-# TAINT_WARN is bit 9
-TAINT_WARN=512

 trap 'err $LINENO' ERR

-modprobe -r cxl_test 2>/dev/null
+modprobe -r cxl_test
 modprobe cxl_test
-# cxl_test alone does not autoload the mock memdev module on this box
-modprobe cxl_mock_mem

 main()
 {
        test -x "$BIN" || do_skip "no CXL mailbox test"

-       t0=$(cat /proc/sys/kernel/tainted)
-
        rc=0
        "$BIN" || rc=$?

-       t1=$(cat /proc/sys/kernel/tainted)
-
        echo "status: $rc"
        if [ "$rc" -eq "$ERR_NODEV" ]; then
                do_skip "no cxl_test memdev"
@@ -36,9 +28,8 @@ main()
                echo "fail: $LINENO" && exit 1
        fi

-       if (( (t1 & TAINT_WARN) && !(t0 & TAINT_WARN) )); then
-               echo "fail: $LINENO kernel WARN taint (bit 9) set" && exit 1
-       fi
+       rc=1
+       check_dmesg "$LINENO"

        _cxl_cleanup
 }
diff --git a/test/meson.build b/test/meson.build
index 07c8618cbc6e..69c22c579b02 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -139,6 +139,11 @@ revoke_devmem = executable('revoke_devmem', testcore + [

 mmap = executable('mmap', 'mmap.c',)

+cxl_mbox = executable('cxl-mbox', 'cxl-mbox.c',
+  dependencies : libcxl_deps,
+  include_directories : root_inc,
+)
+
 create = find_program('create.sh')
 clear = find_program('clear.sh')
 pmem_errors = find_program('pmem-errors.sh')
@@ -173,6 +178,7 @@ cxl_elc = find_program('cxl-elc.sh')
 cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
 cxl_region_replay = find_program('cxl-region-replay.sh')
 cxl_type2 = find_program('cxl-type2.sh')
+cxl_mbox_sh = find_program('cxl-mbox.sh')

 tests = [
   [ 'libndctl',               libndctl,                  'ndctl' ],
@@ -211,6 +217,7 @@ tests = [
   [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
   [ 'cxl-region-replay.sh',   cxl_region_replay,  'cxl'   ],
   [ 'cxl-type2.sh',           cxl_type2,          'cxl'   ],
+  [ 'cxl-mbox.sh',            cxl_mbox_sh,        'cxl'   ],
 ]

 if get_option('destructive').enabled()
@@ -292,6 +299,7 @@ tests_deps = [
   daxdev_errors,
   dax_dev,
   mmap,
+  cxl_mbox,
 ]

 if get_option('fwctl').enabled()


> 
> [1]: https://lore.kernel.org/all/20260624144147.53997-1-icheng@nvidia.com/
> Signed-off-by: Richard Cheng <icheng@nvidia.com>
> ---
>  test/cxl-mbox.c  | 129 +++++++++++++++++++++++++++++++++++++++++++++++
>  test/cxl-mbox.sh |  48 ++++++++++++++++++
>  2 files changed, 177 insertions(+)
>  create mode 100644 test/cxl-mbox.c
>  create mode 100755 test/cxl-mbox.sh
> 
> diff --git a/test/cxl-mbox.c b/test/cxl-mbox.c
> new file mode 100644
> index 0000000..d81327b
> --- /dev/null
> +++ b/test/cxl-mbox.c
> @@ -0,0 +1,129 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2026 Nvidia Corporation. All rights reserved.
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdint.h>
> +#include <stddef.h>
> +#include <stdlib.h>
> +#include <syslog.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/ioctl.h>
> +#include <cxl/libcxl.h>
> +#include <cxl/cxl_mem.h>
> +
> +static const char provider[] = "cxl_test";
> +
> +/*
> + * The cxl_test mock advertises a 4 KiB (SZ_4K) mailbox payload_size and
> + * IDENTIFY returns a full struct cxl_mbox_identify. Post-fix the kernel
> + * clamps the output allocation to payload_size and copies that many bytes
> + * back into out.payload, so the buffer must be >= payload_size. 64 KiB is
> + * comfortably above the mock's 4 KiB payload.
> + */
> +#define OUT_BUF_SIZE	(64 * 1024)
> +
> +/*
> + * Regression for the unbounded kvzalloc() in cxl_mbox_cmd_ctor() driven by a
> + * huge CXL_MEM_SEND_COMMAND out.size. The kernel fix CLAMPS the output
> + * allocation to the mailbox payload_size; it does not reject the request.
> + * Assert the ioctl SUCCEEDS (no -ENOMEM) -- do NOT assert -EINVAL.
> + */
> +static int test_cxl_mbox_huge_out_size(struct cxl_memdev *memdev)
> +{
> +	struct cxl_send_command c = { 0 };
> +	const char *devname;
> +	char path[256];
> +	void *buf;
> +	int fd, rc;
> +
> +	devname = cxl_memdev_get_devname(memdev);
> +	if (!devname)
> +		return -ENODEV;
> +
> +	snprintf(path, sizeof(path), "/dev/cxl/%s", devname);
> +
> +	fd = open(path, O_RDWR);
> +	if (fd < 0) {
> +		if (errno == ENOENT || errno == ENODEV)
> +			return -ENODEV;
> +		fprintf(stderr, "failed to open %s: %s\n", path,
> +			strerror(errno));
> +		return -errno;
> +	}
> +
> +	buf = calloc(1, OUT_BUF_SIZE);
> +	if (!buf) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	c.id = CXL_MEM_COMMAND_ID_IDENTIFY;
> +	/*
> +	 * 0x80000000 (2^31, > INT_MAX) is the proven reproducer that trips the
> +	 * size > INT_MAX kvmalloc() WARN. out.size is __s32 in this vendored
> +	 * UAPI; cast to avoid -Woverflow, the kernel reads the same 4 bytes
> +	 * (kernel UAPI declares it __u32).
> +	 */
> +	c.out.size = (typeof(c.out.size))0x80000000U;
> +	c.out.payload = (__u64)(uintptr_t)buf;
> +
> +	rc = ioctl(fd, CXL_MEM_SEND_COMMAND, &c);
> +
> +	/* Pass iff the kernel clamped (success), not rejected. */
> +	if (rc == 0 && c.retval == 0) {
> +		rc = 0;
> +		goto out;
> +	}
> +
> +	fprintf(stderr,
> +		"CXL_MEM_SEND_COMMAND huge out.size mishandled: rc=%d errno=%d retval=%u\n",
> +		rc, errno, c.retval);
> +	rc = -ENXIO;
> +
> +out:
> +	free(buf);
> +	close(fd);
> +	return rc;
> +}
> +
> +static int test_cxl_mbox(struct cxl_ctx *ctx, struct cxl_bus *bus)
> +{
> +	struct cxl_memdev *memdev;
> +
> +	cxl_memdev_foreach(ctx, memdev) {
> +		if (cxl_memdev_get_bus(memdev) != bus)
> +			continue;
> +		return test_cxl_mbox_huge_out_size(memdev);
> +	}
> +
> +	return -ENODEV;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct cxl_ctx *ctx;
> +	struct cxl_bus *bus;
> +	int rc;
> +
> +	rc = cxl_new(&ctx);
> +	if (rc < 0)
> +		return rc;
> +
> +	cxl_set_log_priority(ctx, LOG_DEBUG);
> +
> +	bus = cxl_bus_get_by_provider(ctx, provider);
> +	if (!bus) {
> +		fprintf(stderr, "%s: unable to find bus (%s)\n",
> +			argv[0], provider);
> +		rc = -ENODEV;
> +		goto out;
> +	}
> +
> +	rc = test_cxl_mbox(ctx, bus);
> +
> +out:
> +	cxl_unref(ctx);
> +	return rc;
> +}
> diff --git a/test/cxl-mbox.sh b/test/cxl-mbox.sh
> new file mode 100755
> index 0000000..67fecf5
> --- /dev/null
> +++ b/test/cxl-mbox.sh
> @@ -0,0 +1,48 @@
> +#!/bin/bash -Ex
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2026 Nvidia Corporation. All rights reserved.
> +
> +. $(dirname "$0")/common
> +
> +BIN="$TEST_PATH"/cxl-mbox
> +rc=77
> +# 237 is -ENODEV
> +ERR_NODEV=237
> +# TAINT_WARN is bit 9
> +TAINT_WARN=512
> +
> +trap 'err $LINENO' ERR
> +
> +modprobe -r cxl_test 2>/dev/null
> +modprobe cxl_test
> +# cxl_test alone does not autoload the mock memdev module on this box
> +modprobe cxl_mock_mem
> +
> +main()
> +{
> +	test -x "$BIN" || do_skip "no CXL mailbox test"
> +
> +	t0=$(cat /proc/sys/kernel/tainted)
> +
> +	rc=0
> +	"$BIN" || rc=$?
> +
> +	t1=$(cat /proc/sys/kernel/tainted)
> +
> +	echo "status: $rc"
> +	if [ "$rc" -eq "$ERR_NODEV" ]; then
> +		do_skip "no cxl_test memdev"
> +	elif [ "$rc" -ne 0 ]; then
> +		echo "fail: $LINENO" && exit 1
> +	fi
> +
> +	if (( (t1 & TAINT_WARN) && !(t0 & TAINT_WARN) )); then
> +		echo "fail: $LINENO kernel WARN taint (bit 9) set" && exit 1
> +	fi
> +
> +	_cxl_cleanup
> +}
> +
> +{
> +	main "$@"; exit "$?"
> +}
> 
> base-commit: 8ad90e54f0ff4f7291e7f21d44d769d10f24e2b6
> -- 
> 2.43.0
> 
