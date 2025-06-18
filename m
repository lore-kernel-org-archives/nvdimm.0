Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A876627E05C
	for <nvdimm@lists.linux.dev>; Wed, 18 Jun 2025 22:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750285302; cv=fail; b=DSqxtliwS+xM9uco2SsZQ/rstMw5WTzlLytuB1fcwunhWZD3HPFf6y27TENu/L3QYuKnhIcNUPqrdWatwFDsPwZ+14j/e7wnipKFgbhagGKs1U/Kn0hGgdNH/M9Dl3/RB4xfR+w8zM5i7Q8D0+l6ZOZA9oSdyU0fYKSrBNclsGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750285302; c=relaxed/simple;
	bh=RJcuTnD4Fk8SGGYLqxtCiCJA2Q2CvoCTJAnAMJZM/yU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Kg3CU+5n6CVkYiaFTkKd7d5ImaT6+XljwA+MLKgFOaWTUSTdvimwRdcZw5s395kFLT9aJKYW4Vvigq7fOCZ3kJxrRfbqbbQhTEV9DcqTknD+DLfV7TTy3WouHMdGsY6iX8Z2ho/1mGK0Sj2TUp9r4P9p53Adf1rWmIJ8xZx/48o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MP+0aV5f; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MP+0aV5f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750285301; x=1781821301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=RJcuTnD4Fk8SGGYLqxtCiCJA2Q2CvoCTJAnAMJZM/yU=;
  b=MP+0aV5fUYFieIMQ4+FdUBdHUNsr9vcdsmT6WvP+6BKXjbC/i8mG9OHz
   cXh9OxSyuUJU/N8AvfMj3z/cyHlUYjixMpPz1whwZEM9F2Bl3aBbsCdRj
   oHor1XXEMZdJ8jRSXwJzzJaSIDZlaPA4aJUSh6ENPdeRRIsKmwpAv4q+Z
   fK5Y4othZa+6ulT53WhAOA7YUBVnLwDRjkIslPI0eXLqJC0eZe+2DTGFf
   G+hUpLmLziBTtFrnZfLV3Nte8Ombu1yQ6Lk21oFwsH4jOPhkvqQz0JaQG
   hVhUicl5feUxtMPXeJN/QbQAlhXlF4ENtyoXzZ0i6Ugf6JoAvoUNKJiei
   Q==;
X-CSE-ConnectionGUID: B190RGi5Rr+VCMUMMfnItA==
X-CSE-MsgGUID: NcBV0B+XTmmXYFHhZD14Ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="52671143"
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="52671143"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:21:39 -0700
X-CSE-ConnectionGUID: WcnGoP0zRQuXoTirZxSd2Q==
X-CSE-MsgGUID: yJG9Hz2EQamyQbI45yYuew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="156023343"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:21:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 15:21:38 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 15:21:38 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.40)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 15:21:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mkiR3RaOYxLM/A1YfK8MX5Izru0LgG7rub9H8I4cLB3yTpAW2zhR/2xqfThYQiUb2QX8KYuJLee/lcaVTQXJF69o+KR0VPQlHdMDPPMD2hUTT1537WJtgCLJtK2MFPt9tGNG2B42kautZvFOqa6/OsWEJbqGw5BRjlMqzgR10wWBW8y7xDIibfUWxVBeZx5eP09WoiP5brOijRVgFQjPRzo/sG4Fjn6HRFw0d71Ayn00ttphBNWUXGPv65vHrysF9vSwqWD6Wri9mXNV4BOt6A+lfElRt22lcc0CZQqNvoceIIw38fpnoCC0U2ZhSOrqEU/ZmCpfS+ZhXdCz9z6p5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MgL9gHJinvZr8UMhef5CQNado/z52AVsxinTroi850g=;
 b=Vvq9MnAfqjLhj9LI4bd9v+sGdzLl6fJvU+bBheQRTD3OLdik0mIKaOomq6aWmUcn02M69kLzuo2douWxAWGwoenmI+EytBqBjDPHxPOCmNE2QiT+5o3ykv1ggwLt0l5AR+Pl5jWSHQSz1Ubf5LsVNLLuCNYEe6hdOB6du3pPRlxgTqIovwacs0aXUc/qtRLwpmR6MXxBPNfB172bRI5bpktWOnPttFn+uB/6/3r8htr+HR+iRRjsjSNAyQaeiKru7YaAScauwolsFrmSvEG3polyOGrk06rovo7QlOyXJENvWGW0tt6LhFo5zGWUSUhQRKxc/+aS2grRBOj8cI/oDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB7668.namprd11.prod.outlook.com (2603:10b6:806:341::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Wed, 18 Jun
 2025 22:21:35 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 22:21:35 +0000
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: [ndctl PATCH 3/5] test: Fix dax.sh expectations
Date: Wed, 18 Jun 2025 15:21:28 -0700
Message-ID: <20250618222130.672621-4-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250618222130.672621-1-dan.j.williams@intel.com>
References: <20250618222130.672621-1-dan.j.williams@intel.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB7668:EE_
X-MS-Office365-Filtering-Correlation-Id: 935ece39-008f-406a-1d6e-08ddaeb67ca2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?tOwYDhSIyBpi4injKA96LazWR+6Nx/eJh/oFBqeVG7QutbiH2sX1NE8cb5GC?=
 =?us-ascii?Q?qgss/0MFJcX9Y4w0dRfpp+7A+Kdr+NpppURm3TS0b/lT36lgJ/Vc/dC5zER9?=
 =?us-ascii?Q?sol5ooL4wTseIMjXRsRiEqJivGlKgWZDPRbszgfmy16I0mlzGSWKYOOUzNr5?=
 =?us-ascii?Q?/HyA84CXN29k1/54gOn6/AIP+RVdHLule0++p1u06TfBoEZV84iq2z1z2zAL?=
 =?us-ascii?Q?caCagsXHogCzmVg8g7lT8nXFlAYpYPSkCQYJFCWgrIm+xRiGWZztPhKeRzx4?=
 =?us-ascii?Q?xeJxSU9I5uc1gaV6oqSuyHl9b0aNT2/ImSkmcTvytlefGQro2i2WCF6Gwls7?=
 =?us-ascii?Q?FwtLfLxyNRD/eA6oef29N1Egd7npUpVUpVlnD8BTMnKrnolaIaDOs+3FRLld?=
 =?us-ascii?Q?IRy+D92+fRpjMGQibpdajAYCYT++8DyleVwf7KgTPpDQ9GRjgh/UjlrBWlna?=
 =?us-ascii?Q?KkC/bIfBLzkEApLPwK7kfxEEK7yahJG9fB541q+C+MqPrkvnaL+RANnfWgLq?=
 =?us-ascii?Q?Fdaz5R3CQ3HbngdaU98fCcf2OBoivJZ1oF3gSucBt+RpAsZt/WUFXn5r4GbR?=
 =?us-ascii?Q?B+VdTW8bwJ+TbnkAXcRy3+27O6U5lEkrr/mXGUVGryjxhj+u61xvHC2C5K/9?=
 =?us-ascii?Q?klQXF+oaMgBThZdo7y309cKySixvNUMiBsIlsLb9qOVfMk+cREZAlsElQC70?=
 =?us-ascii?Q?BMtdld+hLRfVgz9Vxl8hXtPYKdooRSZqkTcstKQmu0/uZCQbChEPetyV0Wrc?=
 =?us-ascii?Q?XiEfQ+GKDuPoJP3U5WgT0cmGjbURs0+rI/Kr8MkOmFmw3R7aeZT4G6CAXHrH?=
 =?us-ascii?Q?NvrzDx2al9wfps6OQhOxnKNYh//8TnolG6NyydoMpm91ySU9gZepzt3TfnlX?=
 =?us-ascii?Q?DoY9scw+XqcI/wfQmbmv4EmtYwYqLoQBaH23iZuvGBrxJGk3R57CIdDYSRIm?=
 =?us-ascii?Q?z7J/sCsF93xTo57sJAMM4gCWJLbE1HpuwZRs3u49a1q9Imyy5qfahuFgh6cV?=
 =?us-ascii?Q?zIHaj2iTvS+fxLkxNWf5bzg0YA0ncQcdrbBoUCktFB0LlYYDTJ1/aZS0kIFh?=
 =?us-ascii?Q?dj3MtaCi/0/yRy7AgFwFg6inKWDhRIUbyPQN8hAwXsAABBDV/TpyggGFnk27?=
 =?us-ascii?Q?Mrc6mJ80hptRa3UejqJQyOg+SHjKBYUOXJnzEiSuW7ErsVhe985ddWAscPj1?=
 =?us-ascii?Q?8DdIfLlJmsxwYmaM58E5A7n9KE0SnsKc+sHHp0JLr0PrYhR2pM36fRVntJai?=
 =?us-ascii?Q?BWG4rGTBqfJb/W7gvIybAeTLsDeaQJS/oA0O+uhOPc6WUp8qeeaYXGSscjzE?=
 =?us-ascii?Q?tAGEpTzo4FrgJ43xclehTzbm4S6c05fof5k2w1k7E8Icy8l7d8Zoulr5a7BZ?=
 =?us-ascii?Q?7qWHxIEAsn9krimGlwZ+lRAY5Km8iB890nbBqN2abgbXYYBgHvDG9Tshn1ec?=
 =?us-ascii?Q?w8IYc1kbibc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wey69KgBx3PWFgkALbY7ivW8fJA92B+I52DiGG9ACo0s/SC7VFp/637Rv4nG?=
 =?us-ascii?Q?TcoGISMpbDOb1GZ5veQDb9QP95DyjAdzy3FioErbcioqzXZGsiUCQkHGgrRb?=
 =?us-ascii?Q?HLsG7aJtNrpmBxMTJJuS+ILksmrxWQDkh5OsgRMDF4bue2i2rYEdf0OR1Flz?=
 =?us-ascii?Q?Ttjnq1KGU9V5ySqd42RLy4znNTmD87J4DCMgxSyHwHdsP3vA2x+c3Gyq3DKc?=
 =?us-ascii?Q?LZIChOM9bqikpOQxtDIVxhT5cLf/mCAWE7ZGsZrM2Z4mGexsjSzL26CVOKTR?=
 =?us-ascii?Q?WmABgobDk1J1CgnIl1AmZycEHZqaCNttW3b6TZxliExDfk+NBleUAr86DgSM?=
 =?us-ascii?Q?BtYi2rxhNSle5033If+paspJTCft782pSmoLdN5MABymNJY21I6YqVjm5b/y?=
 =?us-ascii?Q?xiQQD7z3FmxL4n8tJxnDjdDMS/gsIrgGwS71yedw3WPBV3qJeUTWwIqEXo2x?=
 =?us-ascii?Q?G+Mo1SUVbeVd/7+BnC0edvxgxIqn1YCEjtNLyZfkDMQaBfAFqEwJ972spLb0?=
 =?us-ascii?Q?sV6CzR1XP2I9VxiKS5iAszEqQLsDkXFjBTmFCknKxp6N3xqwbP2fKkmwAjs+?=
 =?us-ascii?Q?mv4vnSr7tzPAlyosmJS1g8oWpuG/2vqU6lYsEp1DDDD6Okia/qPf8XAA0ku7?=
 =?us-ascii?Q?KGhkV5F+1qlrmYMAojUBVG6ZTFuvKdA5XP8DIcKfroa5xydr1+h4QRBndjhG?=
 =?us-ascii?Q?oqujErqHbsXGyaITsCcLg2S6pzjW28it3Cf9i3mH1Ad0rv8qMflt0WiMKAoM?=
 =?us-ascii?Q?VYP0aisnp8BpQdq45YnXVbnpH9BoOzxMIm4e2noyGl562GtIRAmT8viZvHAa?=
 =?us-ascii?Q?pVX15x+iwwejU5aCs/zJI/Lmam6MEbHsdUSVvJqH9ktjY9ntXj8jts+2fyGp?=
 =?us-ascii?Q?V+hzU1DCKvj0EBcQjWOiXZLn+oNEu2bzRMzuZgCr9ajiEqPAXFtZ1x4/A1UX?=
 =?us-ascii?Q?14++huQ6wH7J/RRdQlfIN30BF4TnUB8UtDNa1DJ3QaX2hRvWGp/GEnC8h6tm?=
 =?us-ascii?Q?VM/7176EYj+dinflSwQoeTPigaD1r1mC1VAkGkRyXHXG65LVdHgCGjl1TxL5?=
 =?us-ascii?Q?3eR7Z62G8cvG/sv7ey3Vztl/J2WKdcBfb21+H28Zb/GNoFBqdykVO0A6VsUj?=
 =?us-ascii?Q?KICQsrDvip/rSjiSUgMCtuhIUtjQPWGonxOLHreytyApfcO8mswSPx5Ns9z4?=
 =?us-ascii?Q?88NUH+EggWDYpT+Y5qMYZAUCVqa120I8j74zwON/QL9jBiEnoUX6BmzPRS93?=
 =?us-ascii?Q?pBJLURvKtDfgJKBT9AyZCsApI3yqlrXwSb0iPYSdjYvW/I29QPhVBwyKTF4Y?=
 =?us-ascii?Q?O+NGN3E48r1MM7hLFso1ZOTMVFyQ0siGDbHmF6kN+SZaCeSm1f1qE7Og4+0B?=
 =?us-ascii?Q?d1pApG1FvctbFNQRw78gE4OfBqTd1pJMc4IxWtiRaYMpvfCjJAoeeoNIqOZ+?=
 =?us-ascii?Q?QrLNDZlUTSQMe5n/Rd5vyyfjg9v06JfXcS4BQrbu5vgHnSqqHZTb53ENTqqG?=
 =?us-ascii?Q?4Cb0TOsMx1tUdRoyq1rzLOMlSNe/sR4+etwyiw1ZMc5QPqallB2AuSYM1R3i?=
 =?us-ascii?Q?QwhQh9tOcNUQiDDdBqmMI+Ju3SGRVaMhcUfVKx7GLCcXA3AQj67VsV8VvPdJ?=
 =?us-ascii?Q?WA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 935ece39-008f-406a-1d6e-08ddaeb67ca2
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 22:21:35.7216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mj85sdn3cfS95DXvfV3F4McDeqPj8oQa+69jx2nR8JtZdfVnyBear5G/MMTNVOGF8cyW7uRmlGNP0AWunOY4wiruIKhYQY4bMo/2BxHI1f0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7668
X-OriginatorOrg: intel.com

With current kernel+tracecmd combinations stdout is no longer purely trace
records and column "21" is no longer the vmfault_t result.

Drop, if present, the diagnostic print of how many CPUs are in the trace
and use the more universally compatible assumption that the fault result is
the last column rather than a specific column.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/dax.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/test/dax.sh b/test/dax.sh
index 3ffbc8079eba..98faaf0eb9b2 100755
--- a/test/dax.sh
+++ b/test/dax.sh
@@ -37,13 +37,14 @@ run_test() {
 	rc=1
 	while read -r p; do
 		[[ $p ]] || continue
+		[[ $p == cpus=* ]] && continue
 		if [ "$count" -lt 10 ]; then
 			if [ "$p" != "0x100" ] && [ "$p" != "NOPAGE" ]; then
 				cleanup "$1"
 			fi
 		fi
 		count=$((count + 1))
-	done < <(trace-cmd report | awk '{ print $21 }')
+	done < <(trace-cmd report | awk '{ print $NF }')
 
 	if [ $count -lt 10 ]; then
 		cleanup "$1"
-- 
2.49.0

