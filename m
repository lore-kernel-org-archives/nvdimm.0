Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DBF4C6F
	for <nvdimm@lists.linux.dev>; Thu,  7 Mar 2024 01:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709773762; cv=fail; b=e2o6IyGFvBiIMqmq4X7YQCzLu1mr9/7yAg0avQswwCb0etNX10UfHzPJ+ukhY4ZJuR9Tgfc+pF/Zi3cInAvXULulc8W2kF+/JJS/MgK2NIW7Wq5COSPx4mWdq+UlaxFSLTAwkPh8F3Ge8upgLRs/XPr/ZqU8rE2MsDgaMoSUEgE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709773762; c=relaxed/simple;
	bh=bckjRL4WBBQImhOhsJy1cnoZ9f7/+mqGZBq13Xij4cQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ROOPsdV3AufoXvCTiUE5j0HNdmwj0a4Ea0hUZ6ft5JYo30q6Al8nwgTtSNqjx+47pj3y9PvGQr7cu7G4Lma1w3gaV0vOv7qBUzYScsTgn1SYVDULf5rZAASA5Zssy2qduKQCgbhkpajldTBjZc+Xk4Jub6QIVqv6CDnFbE3jS/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H0jVc7Vk; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H0jVc7Vk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709773760; x=1741309760;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bckjRL4WBBQImhOhsJy1cnoZ9f7/+mqGZBq13Xij4cQ=;
  b=H0jVc7Vk+6BVfAksEYUvvmFPpM+FWiywG4w5EbN/bi7X4RgYCCtSGTxW
   zuGnRZSfYSS6NpeXD+pfyX7Jaa9Cv6s5rMx1SifhfbE1Q1R3nDygqlHnd
   ld2eGFDD2UAfdQmgkBroPQsHKhZv3F2EaYMMkEQBx9Tiq2Tu6JPWTxaZN
   7A5NK3gW1MM9oZQs70wL6iIOMlc7g3ia3MOOK1smv6TFdRxM8sJbISPv/
   j3qs0YnlG4F1BYrOzCO7PL39Xp5eHRvj+HRQ4wdTFDodMjFu35fCaGv3W
   e+g9E0Y3eKlnAZN+qRgAslSNHCKZd2BdIW6fjPftmJVWzGqSVpTdKj4Kf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="29867504"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="29867504"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 17:09:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="40919173"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 17:09:19 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 17:09:18 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 17:09:18 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 17:09:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bR18xk288bqMvqmArgSoi0jIO1KlX3BsGKLInB39OSoGl5ydX1DDWQGZrdRo8bmi2NXqi5d1jH8CRn0pV9G3pV3uxcrtOMwh/61U/uBLK4TzSvlQpaqEn5otxZVAaZZW7zD2kLdeUlKDK/hwmXrR7w4WH2RxmEU7pMksunUiCsyYANGuNUGaVb2tkZK1dlqk4M4XwFCObNbu+CB5DuF+6qVvCIwHis3+StMqIjeetrCa86IsimaQngGo8B9xD46cOhYU4BwFrVAHOJpsJ4X/FcOOMmp4qfVRRRKloRJ3eybkRpm/gyj/waiq5RjyrCrVjoubluEqfdqMlnlaVBA4/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/TDpKbfCgym4qdpUT0N75v4b8RaV+E+fx6knUm+JAM=;
 b=EZ+ylyeXgapPgw5+KNpnE0ct8Rt+PVjRwJIJeRbOQK7TP4ol8ryUxETwsNPDYksWKfI5I05cwm2EwSw2+VXu1k0HvE9No/mwLH8UMLD+lhB0gwyizJ18ak+rATPkPK2FxUs5+/SfsL3LJ+6tHo2wyidJLDRz7YRrBjKt5Q6L0dMZGAoiT/uqAwUGXhN2ldIo+2dFdK8G0rpbVLuW4wpmVeEIbpGxaeEArFTAnCA3Bahygh8nV+Rv4r+SSjvsQ9GDQhdcN1DASjLxAsso+38MU9YmxLISp1Df+zT+oUrPZJ8FNTaifb0wbEeUh4Uvnq1biZa6ByVEnz2NfvFMxajPQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB6042.namprd11.prod.outlook.com (2603:10b6:8:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Thu, 7 Mar
 2024 01:09:16 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7362.019; Thu, 7 Mar 2024
 01:09:16 +0000
Date: Wed, 6 Mar 2024 17:09:14 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v10 6/7] cxl/list: add --media-errors option to cxl
 list
Message-ID: <65e913ba824c0_1271329410@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1709748564.git.alison.schofield@intel.com>
 <2047e536ed7a1d1a46c048053dfe22fc798ca35e.1709748564.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2047e536ed7a1d1a46c048053dfe22fc798ca35e.1709748564.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR04CA0196.namprd04.prod.outlook.com
 (2603:10b6:303:86::21) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB6042:EE_
X-MS-Office365-Filtering-Correlation-Id: cb73f497-8662-4838-99cb-08dc3e4335b7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: veGMP6WqrUWwOxnK++3u+0dIaGEfunQS329887HhfBSertvuXGYkINfcgLFxbGXO3Ub/KzVijqlyYfQMwiNYgxVHASnfipmAsZuKgx5RBho51aZIJaVbw2pTAb/RGrsyUCJNETE9/JWMjsi++md/W5oPfszn0FyHvvbRnR8zbp9vlc8MJT4T+eL+owNTFAaBgVG42M8T1rPYLZPdhTJwz+SH3ue/SczetrBV002Hfby0M0qPwKMLDlzlgYEOChbgapZMKWbWvDoBf31L9U+XuqE1gYkEg36YmKC4ZYOSNgtnU/0B99J4mB/FU01gqQNToTc3ocw3BBPcAe2qE5VkfjSZSuvdFkDzF2iZwpw8TAvWdgiyzG7a13VjeJ6rOp0fbI2MVNnFeg3AFmMFmFB7tDUFjVWHqW7IijC8nUjEGXwDQFM9qDpRG22L6dGDO5LOtS/fUOzUk61aEhGQRS2uzX5+bNthU/1cMcYX999w1kTIWPI3sPQSfTi017mynG1VEVMSL692GIW5dQa5eNveTuKO2s6po9czRnMjZE1RlG7aaWey1kdiflnOJiE82+pbSbNMf9dluptBukb6UM13AePv6I+cHhyu1Q5VHiLSkm0a6rrZQLACPHf3hMIcVGYOFuyC/325WG82WlsXqJ1nePZP2ftEgMhOOfkAyU0uqxQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BxeFLPGn5s552h/jMSKjJw9Ilz6c98zkwsra3NlKBRWKlQvaqUDmiZqzGjUg?=
 =?us-ascii?Q?nD5LgEg/3lkDxzXcKNeMh0+4G8fudHOkXqaxuZ/fRVXiFpxKjI/P56MqkkWZ?=
 =?us-ascii?Q?zhL8I0eCLaGqZGHQNg1/KSJRR0EjSiY3Iz7WMMKghYflP4YoY8jYN13hNqgj?=
 =?us-ascii?Q?ltDMRhTfdN6XH2vyZJFjOVxdP1rJ02RQJvNjtDDyxWJYxkcpCNaFb13RfvJd?=
 =?us-ascii?Q?K5uPYqWtufke2+ns/GDXM20Gn7Ao4Wc4CSBl5H4SGW25AmNgE/vpMuuRjjvk?=
 =?us-ascii?Q?YzCyq1ke7Tco/1nq4OrwTtZMGe6IjrS7le26Zq1L9PuSgLnyjSyIhQB2FWoW?=
 =?us-ascii?Q?yvu81XxTeEVwV4xHbUjQXbeB47r5jJEdVAb5pIixrVK90rcnyMRnCiQP1sy2?=
 =?us-ascii?Q?O1fMxC3q4jLHGKsGxW8LEe5ZPvE6eyYGM+GCR6Mzprx3Oqy1bQMzcZmtC991?=
 =?us-ascii?Q?zuOyXKnDs6HF+ECGZVPZ5GmvVRrqYqXHCOdshy5Sts2JpFTh028kLoQ+ZDCt?=
 =?us-ascii?Q?0uNAn8v0VEG04NtMdb2j+WUfVwPG2F+NJw9Q82Y5PaCduqMdjUlesU03+Kcu?=
 =?us-ascii?Q?D/eOcD+fxzEabl9fvFyx4gZkfWns0jIZLei5v+iu7j4V4oUBQ/MNN08+d7nQ?=
 =?us-ascii?Q?t2hfW8pY0ofqc189zMW6h0QT8i41sIYPim2Wb4fmvE9kPRHj8ChTew5ubFhg?=
 =?us-ascii?Q?wI6beaTwOe5/WxSkQl4FX4N82Y7HZQ5DDLFopghLReeS16yrnvgTY1blO8+K?=
 =?us-ascii?Q?YrsDNUbJvJpA4Vk8Mjd/H0CPFQHB8RVuXOyN4GUdlGnJc8QHWdDfO1RTaqwa?=
 =?us-ascii?Q?uCtk2qfQhNe9hSFLAVGhSGNjrOBXi8bzM+j4BzzUL9VVurNlwouIRXKeelAr?=
 =?us-ascii?Q?1EgvImG6FDLWqSym9pPFpXxmkY1/4Kd8FeH7+k32+uVivnaFA7l87uUss4BT?=
 =?us-ascii?Q?W/o0rI7gX11eZD5HmBL6+RJ8XwtYEaIqRFccpugmIzcJgzSzHWFc4Ov3maBP?=
 =?us-ascii?Q?AmMFo4jYMVqqEv4/rqzZhPcuLZ74RjEulZkgRJutLPRMHtJftmza3fQS+aK6?=
 =?us-ascii?Q?5IngAR+Hf8r35nNkaKeZH4MbH93pP6mizJZOnUNrsMs9jzRwfo+28Cfcwoo6?=
 =?us-ascii?Q?Pfe3P7ug+Ghm9LP0XN/cgUaQlREWZu4sNxw72gXz/rT1+40ttB8AXJquU9LN?=
 =?us-ascii?Q?81psePqRW00q43UHLzLi8fux0HhrqAMR6jSxdjnimXi5XTlMwE8leVoFqmpt?=
 =?us-ascii?Q?gJ2JiTuYQ3MXC+aZuIvs+iZpRK7ovtFooJRxzreeNThqmltZzAWpsPX3/nwC?=
 =?us-ascii?Q?oKhrb1BjOdAiF2maHv4u69EiZdKY2shI4Jm+d4rbOtBPnKFhp94pZ/BUfZmX?=
 =?us-ascii?Q?j0N6Lp4cEeQlnU3K1HoB3/2AuGMuEuQ0YHTTXgVmpwiBXLfUkjBeV4WT/xxZ?=
 =?us-ascii?Q?byXT3bvmz01LVijoWMrQGiyXaAA53h5wpAn6BpNv5spfoOw6v9f0FUcBPVnF?=
 =?us-ascii?Q?LEaqSG6aQu/eBoNchaF+12tHxU8KCKHgZTw/vx84s+D+BbvdK+UOoaXxd39X?=
 =?us-ascii?Q?PT3aWi6AAj4raSDab4t3gZXeu4FKcXF1z+liykeqjiOgZ62c8xdDCnwOozWC?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cb73f497-8662-4838-99cb-08dc3e4335b7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 01:09:16.6505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v5wCsLc0+3fRlsiTkrpd4AX8mN0oFWdGxpexy9z5AGXcWWcao78esiiahf/+IUi8ZGAnRoND//UxhgG06p4IHxb/Vyq70/TdWofrWYebA0E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6042
X-OriginatorOrg: intel.com

alison.schofield@ wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> The --media-errors option to 'cxl list' retrieves poison lists from
> memory devices supporting the capability and displays the returned
> media_error records in the cxl list json. This option can apply to
> memdevs or regions.
> 
> Include media-errors in the -vvv verbose option.
> 
> Example usage in the Documentation/cxl/cxl-list.txt update.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Looks good, just the comment on switching from "dpa" + "hpa" to an {
offset, length } tuple.

Other than that, for this one and patch 7/7:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
