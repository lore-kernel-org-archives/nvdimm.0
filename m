Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD03121CFF7
	for <nvdimm@lists.linux.dev>; Wed, 18 Jun 2025 22:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750285324; cv=fail; b=HDgItrT4taouPKjwL64Ke1DUEwkXDZ2ADp4b3qLNrLfcyQSg6IlYEAAsYnM5Ad//pzf3o/wOMfFpN75p+AHwIP+AK72R5bHGmukpV88r2DSFYavOtACsMnd7w5svMeqBr6DEHcU1Z+0nn2hhfN0IW2LonG5sUgjjKbW9+KD6XFA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750285324; c=relaxed/simple;
	bh=CGfvPKXU5zPhQNTfGI5Omd7fMfolC/QoaJoPJeN0OD0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HdPOuraT6oLjqdhl6YtQSI3voPEr8jyM/gaOv1LzRqjTQxCLRIwtTQqlSrkaKUIuQOnRoeicZN30S44felQiILN2HQuZTJBAr1d+syNMLnb+JSZDEn1RkZEx4LS78/7F8+ioEcd/qHomLYnCz5bey6I+qYpuzXlBCZsMTXYPeN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eIl6ZiXz; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eIl6ZiXz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750285323; x=1781821323;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=CGfvPKXU5zPhQNTfGI5Omd7fMfolC/QoaJoPJeN0OD0=;
  b=eIl6ZiXzhfzlKPsDTg3+X8ccqrWtg9MOgbZCjCMl3Nlc/JX+4efYcrvn
   4Ea1yMKVSrTADTmdn2SXCMS5cGrtPDwQMAzPhaNmcPXtNqFtrOqk9ACWq
   TIShrNKYK43DfMBqddpwU4rcj8EDNWyfeJndSBxLJSbG+LFNIwAyhx/fN
   h+84AzmeihN7I2VwtU88ora8SfqeIDMZLsaaVrvxqM6nMXWWOZZQQRz/v
   5DrMQherr+dmaUv9o7CUBCLsvZw6gKjXUTVgl0YQhzs9T5s/SWMQG5lfE
   aMfXzX116zbu4v1RHKFq5foGjG3x4mi3KAAX+ME36qdbVAyLG2oWfGJOv
   A==;
X-CSE-ConnectionGUID: u0dz7LL4Swaek6X0B7SHbQ==
X-CSE-MsgGUID: 7ufwMMcRS02DlpWrJA/Heg==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="52671191"
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="52671191"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:22:00 -0700
X-CSE-ConnectionGUID: sqLzg0TLTo+oqHTsNyFuhw==
X-CSE-MsgGUID: 9hY/KDLWRPqOWkNmomUSmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="156023665"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:22:00 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 15:21:59 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 15:21:59 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.51)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 15:21:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DDw7FQKITUqmLEgs2sqEVks3DRTt93+FMc6lpEsck0uMl2XLiooMM5IvvygF9GxS0oX+4hUCtDd8fhN2nbVraQc2WOHF59HTbZGT0x4GccwmI1Wme7viaSH7X5eTc2i/oXvy/Vtkbg762m4T3GsSosZ2ujZFfcYEnxiy9kATKYa8s/yNwv2gpUvi8NmXW1HSYIvwX1y/4kOyg+Vz4AUnch3N2jI4UzrdSGARBEnu/vKFgYB4TiV8zuQ+qv+m3ridyjQpsQzBYw0tl7vI9swf0CNDIqPzNe0khwev5UTwQrUYhU3x73stG5S1+BnunQt+tkMWs0SYl4MoL1PpCFBuiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AY2acHOqY1w0UxQvlh/trkOK+LYUFpsX1sxFfuv/KZ4=;
 b=PcMLQC0kJSrraO02JQFdqnNPSoSNhf40U2i6Kdiy9RvuNLvRn+z9lEL1GUJ9qRu7Sjt1G19y21g8gQJc4IAHLEOsqu/BA8iSQE/DMEe5G/tzQAR93bVr4WlwjoyRVt/wl4LjWWIQ/CPEnHFkYgrQVB4Gs3ka0mpJAAgn7PdxFArVdsBYxHG+hcnuUrlz+AxuxwHGSjbTSvVB5JjB9sksVYU8fZs9rX9NRTmbge/KXHGUyAY4r+42U61dhxlHf7kMtkb1Xol5WgUTKNb6tFmfoGakgLLKRKVOfeZRIljHH8E1ygywKsuqqCcSGzAoa0V4i2l5d4Mgub5OLNg6hjmPMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA1PR11MB7728.namprd11.prod.outlook.com (2603:10b6:208:3f0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Wed, 18 Jun
 2025 22:21:38 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 22:21:37 +0000
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: [ndctl PATCH 5/5] test: Fixup fwctl dependency
Date: Wed, 18 Jun 2025 15:21:30 -0700
Message-ID: <20250618222130.672621-6-dan.j.williams@intel.com>
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
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA1PR11MB7728:EE_
X-MS-Office365-Filtering-Correlation-Id: 79d7cb64-c7e6-4308-c9f3-08ddaeb67d91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?gdNDB+OGr/MFjxPytzVRUr0iHKjlAMvV7O9YbSVwOZGHW/4vBbLC1jj359lY?=
 =?us-ascii?Q?pb5gZ15R1Jc+aCvQu0SDn8+Xzs93+WWYvuLvpKPMXxXGiVwYNT9vsgJlZXVo?=
 =?us-ascii?Q?gEfLDTGMrFYYZEIAABf8EAeTnMDNzidlcBh7UAssgyFqXKxGTVnQzelR77l2?=
 =?us-ascii?Q?djzba9YEUHyqj+udXysxZ2a77l7wVWdj/dTiIxF8ihgxHux8NOTJFzbuWecj?=
 =?us-ascii?Q?iUKbP+xq0Y8WWYFpwFC5IhZ+nQPwFQlFLRaGyxZsEbzFygFwfRmFV8xm1Adr?=
 =?us-ascii?Q?VQY4TCr3lpXfhn+xtTNyoLUUqKn8uqNAnk4TXQJMy/y9bv0BoOqZn6b0UJje?=
 =?us-ascii?Q?XNPKyTFFrgehaj3AjcnJ6n61vSPghPYYD8JB4Gtn7fTu3g+dJwdJNcNzTzwz?=
 =?us-ascii?Q?osDeZK1MOCeXxTLUYgKjBy2L3NBULbj4Fb0Ax2lT7PdMteNeVCiDzcG/U2j8?=
 =?us-ascii?Q?NAbmFiGbpCTwM/yhWxwkqrJE1eqnYn85vnJQqiNz9Mx8+TvBvBhjKCnBbRJm?=
 =?us-ascii?Q?GH4xr1ue1aqJ/hqbPuLkpxLpv4cGdsLZUzUeoxSF/8tr086EX0B4yKBxKZ6D?=
 =?us-ascii?Q?z1h1PgAB9oHgKmqAJxTaEKnR32Lx+uVlBlBvi11DarPjTUNf2xMVHfaH/Xyu?=
 =?us-ascii?Q?q/rVcw0Yy3clabqu9efybv2fxRGm7wMNqvxnFku/uh7JXGTLK2hPExg3vTSF?=
 =?us-ascii?Q?Kv8aMUPI8u4cCgIkq+eYp5q/QSxNdvhL9D2GPp6ljjbXt1eUCl6Iu5JNufOi?=
 =?us-ascii?Q?ACnPV0disqMEfIP7t23d/zH0SOSMAyJDmUKyXZfHDSdL/z85oS6tR+2fIxQB?=
 =?us-ascii?Q?r7Smo7pVThYivdHGfO4MJmG9DXAjNPgPelJFrXMoYewNulwhLJP6fUGmixWC?=
 =?us-ascii?Q?/GLDY2nTP6DjV2yEdjrnSWJNQ4yWafZUIVio8nq5rny4YiUJTL+/0annlyVA?=
 =?us-ascii?Q?fL3wlIzj+VLp8nKd7LyTTDjKV4lCQvaNarnXneJGuswPY94LQNmrRktnku/F?=
 =?us-ascii?Q?UQgCYIAeaeBGxRQ5zr4QZlw1F+zYROM6jSvx01Pa17KABSqQ4+ULUIuC2E2D?=
 =?us-ascii?Q?GqIszUwwuwSW6mEo71CNt15mL2yIn2XR2jIk9UijjHojZLJbJY2dQVgin3+k?=
 =?us-ascii?Q?t5YgKtk3kd6JPQKVWqae7mHkW0PcwZtciIdF7nqyF7Iey6/bJcgNRUxYF41T?=
 =?us-ascii?Q?qfCvdrA3COSGq9/GCy+IbesZ7PQPxZZmAbIBaCD4KDLr7OXhONv/UC6YjGUu?=
 =?us-ascii?Q?04nGeDWAycDkUr0xB4RD/mjsUUuuO+6fNVeyiB0BJQrqrkQ6uyFl4Cr82C2F?=
 =?us-ascii?Q?amLXHIgdyt2+CXgI17tHCFuHjG6XAfMVABwGXS/Erl34gBm0DPykj0G5BINY?=
 =?us-ascii?Q?hjXMcno7ZqhAYj6y0vwUNF4Jyw+FEBG7I7rTcWGVvypXdzgyAcRTxprDbg9v?=
 =?us-ascii?Q?VTcgqi/Khi4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QS2/3ROj4MrDcrGMsctJQRPtV2Gd03OtI6ZCobXLxQqRtDNWKlGa0WyorizR?=
 =?us-ascii?Q?YdsRaPRbyOatr1/yu+e9JeL5oaX4PARYPp9GAAgU8P62AN5yP5on06HXpRNY?=
 =?us-ascii?Q?NQjblhgvqVUNys2PhlTy1WcRE00/RENVq1FUmS5yzxU7XNv/LfIWC8W2qMsp?=
 =?us-ascii?Q?iGPqgwdVuCvQq4sDhbEsQTnpswRfguW94EQXW5+h1oQz0qybAAC+bNxRolrQ?=
 =?us-ascii?Q?gavjz95NfsGMTOSKc0HnxyYz9uea1h8LcOtPo5Ueo6/qpqJ6VW9cz+wziMen?=
 =?us-ascii?Q?Y8FPGileM8MQw91Htq/p6kFynSNTGEogFnBDz9Vy91g+mtnnVZPk+eYL00KE?=
 =?us-ascii?Q?uD70VUdI5bnzyEJPzyddVyAiFsB7zopnKkREurKM2WFoMemwVzLZ9pWmWpph?=
 =?us-ascii?Q?xiD7WXiMrrEw8Qf9gvMtj4FnV3pgIdibBSYyAHRyizbN5L3ogPyIgZW9yoTI?=
 =?us-ascii?Q?5A1ORtumCC/02IsAvobwEeYTeLz4kmayeGq15AG/3ClBpt2tzRM7dzA+MPXL?=
 =?us-ascii?Q?qPgpGHrVnR6eISS2FhFslL+ztR6yiA2IBRoFqvRfPOFnZln18Wch1aUof9N2?=
 =?us-ascii?Q?lu9OQm+Bt+D5s6b+tIza4pLR+hHuJPRpiU8WENRQV8CM2tp7Q5AXgp4PV2cc?=
 =?us-ascii?Q?XCLbqABPPx0vfoKolTTvaTAr67ZIEr5Egzi1DCBmXgHOMEZZ/UxT7ZyoRXyR?=
 =?us-ascii?Q?zNEdCp1gQOSNeWLlYAJDkCuGTX4L4OnOjJAkeDqrJSTgDA5jj+nJG0Lx5X9e?=
 =?us-ascii?Q?LU+WxRgBG42f3sGYlA+Q6lpVv/mDYXHRVsoNBuZJNNTr5n9iHEuN+lRppCCs?=
 =?us-ascii?Q?LyFAd9gHZU4JalSg2dZJqV7auKC9+gcmSpR60GnmeRgaRW3f8Nlqozh8JTs+?=
 =?us-ascii?Q?hnFupCXk+qVK+PQyIMuUQiEePZxl0LfZYitHXsfNIumSqskFAtWPL9BgxAM/?=
 =?us-ascii?Q?2tVHu784anGMoFQVfbwJjoksTmMR7CtnVX1/v5fprdWU6LX9JbMqUHaFaaUH?=
 =?us-ascii?Q?uJBUT3uFH8EeP3x0iY/LpB0zejwy9AqnIIRG6IVgo7voIuFIiDULYmRjPp+k?=
 =?us-ascii?Q?4P1Keulx4U4pMKuAF43U9GmlnmqHVXBHubSVVhMiK0gx9gob7a2ZoQjxYzLq?=
 =?us-ascii?Q?OfOA9Nh+Q/uGGBwewVDvPKPBZMQG90eEey5iVxgnExpbz5rNpDYYJtE9Tp9u?=
 =?us-ascii?Q?IyCjD08y4ZYc5WL7TMtfwlLKlKpCHdpxLb8gOcoW5InYIzMaRcCaEsAqHnk6?=
 =?us-ascii?Q?T7SJ+c9VxovceTsTvfYmw4dUzQOxSSw1VuIukcJMpZCqUZiqOhwf1kJbqvi5?=
 =?us-ascii?Q?aYOL9304FxK0watvLWvwHqOVNisWrTOrsk1spJBnWGVOm1G7Q+nhSoh1mkek?=
 =?us-ascii?Q?vtesYy6+zG1NfIc7BO1oKLlYohDDxHfizx3BqzpR8gao/0c3c3YvTQ2pO1k9?=
 =?us-ascii?Q?Vrz5tH45pGgZvJBGePc5ZmCI+keXJMNuqSPdOpa21mYQn1cVUt63eJFAukx1?=
 =?us-ascii?Q?/L9N65+K3C1DHHxVF7ikB6DvKddJYRaW4M2XEwKPK39/MGZr59p+R1BYjLlQ?=
 =?us-ascii?Q?bEirWDj3daaxkv8bSu2n/x1lw7pZckXyzLyOQ7cZ/POlkbnEO9upmNDT2Q4W?=
 =?us-ascii?Q?DQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 79d7cb64-c7e6-4308-c9f3-08ddaeb67d91
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 22:21:37.3309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dnv8ZhT5+ANWYAls7tspUoi/x9elWwEo2B9bXoDi1b8LvQPqDEuJqqRoEzLyflApvSDjJi2Ov3meFArbUvoRraHdyEWtqO+Mc2hCxFyhPsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7728
X-OriginatorOrg: intel.com

Ensure the 'fwctl' test binary is always built for test runs.

Fixes: e461c7e2da63 ("test/cxl-features.sh: add test for CXL features device")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test/meson.build b/test/meson.build
index 91eb6c2b1363..775542c1b787 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -275,6 +275,7 @@ foreach t : tests
       dax_errors,
       daxdev_errors,
       dax_dev,
+      fwctl,
       mmap,
     ],
     suite: t[2],
-- 
2.49.0

