Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A3C24B21
	for <nvdimm@lists.linux.dev>; Wed, 17 Jan 2024 20:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705522179; cv=fail; b=useTTfs/xQ0irmDFwWdcLZSeIZOB8KdctWNv8qgNpKVUWM3ELuqWi44ZuGSf215u4RdZo88BIF7Pydpg6eh26jg3dqsAf7xHjwLnajszImzvFj6umOUGTlxircHbaPF2ASQnc4dyMmUmA7IJJ+z8OXVfgqO1gRi7nI6vhX/pTw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705522179; c=relaxed/simple;
	bh=lmF3MPJ4gAvnJZIhORncxGQl1yJrjqFzqvw/NjO4cNM=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:
	 Received:ARC-Message-Signature:ARC-Authentication-Results:Received:
	 Received:Date:From:To:CC:Subject:Message-ID:References:
	 Content-Type:Content-Disposition:In-Reply-To:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	b=mTMQ4dcKR70DmfFtZZi7XFufO0oHWzScCgnsiONThaNoFZdb05hD4F2ojx7D/mXFOnk4WA1z5inQpm3aOwb3YfYvTLW5SMUIG9PO8eIvkBwAgPvsp/4WJxwObIe184M2aHp1KY+Lsyrz+y2WCD0cmrKzlqaiBz80fdd/nxw8xBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CPyvBPz/; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CPyvBPz/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705522178; x=1737058178;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lmF3MPJ4gAvnJZIhORncxGQl1yJrjqFzqvw/NjO4cNM=;
  b=CPyvBPz/WRpt6vpTYXiwyAnNx2yMTZZ24Mm4SMY4u6REYshqaZLiwvgW
   SZbqy66ZxqItKXckq1RiMerqWDiWh3iE/ApJP3sPpt82q4/4jgpYCe5Ro
   EmcyAbxfZ17sQUDRX/EprHWervky7LJcmmfhQgPes2TqOxtN9ZFe39n2F
   a/2K7CWM0jFYioHi8vIk0BpOSgpBVzY0tes3X3LuC4/CqWKQulRDGLYKV
   mmqhCHh4zgaSy49VmVpMPZtE+vWnV62rkQIcR8BJVYuE6RwzhtTleor8z
   t7DDwbmOJpsBN1RmvbkBlH+N16qaQ25C5+ur5Sz9Xg35GCOQocEClbreK
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="167044"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="167044"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 12:09:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="927918616"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="927918616"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jan 2024 12:09:36 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Jan 2024 12:09:36 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Jan 2024 12:09:35 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Jan 2024 12:09:35 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Jan 2024 12:09:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQHCOXT2Dd6XMFWGiK2jhcYEBcTGhL6llIDdkz2i/w8jK4JcvsZ2htujO/DL1Vc4cPDzq8gzlTfOEKSz7YzPia2JPDZCmahiShbQxQgrALqL9mZCv0b652TTwZ0o7RAbzZVt8kMoYoYCe2K2UI8+Gsl3S28MiyINEgnEJRykIG3r8d1d6YuRZ2COfL5FaCiotC1cgtXdjAXnARrjOc4HoLUXcYj0WBGUfP6tGrZH3YDIiKj1GZUW60CKX/1rf6DoW32MZ5TaBjP7+JUsABCyF9j6OQLzjoBQAdWlwqCTepenHKEHwXl7TlTghtMAruS9j8RevmKBPuqR7O1WwRq0/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y9OjnRYD8NBUF95e/DrT8V2eMOn2dw5Oo8KBBpTqm2E=;
 b=Y1DaRZu0To/krd8B+6IfR9Lb5iNsSn0miZg7au1jxY7BkmGNwMcGtbp5Wy8SXdWLq/KsPxaZnOinI7lPn9b02DCjySSj+DRTn5a6naTX05w6xrqtdBoJKhc0607pEgmoVy26QN28w4tSy8XU1yKLoIqSgFaVVGEDIBFgolMk/4DGu82rh68Ls5lmFpiefJ4paN4kfPtyVdSIEvO8eC6wvXBp2ZQry1CkWLxWnMs+U/RKnMUi/r3vmzuFAeytcUBwb8sED7ezyfmIc42Ok5443WriHRwutoVcqVWJ+5/6yXQ06t7Z83SEC/bbXyEL6SHf1f9l3itUT4b3smEZaWcgBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY8PR11MB7338.namprd11.prod.outlook.com (2603:10b6:930:9e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.23; Wed, 17 Jan
 2024 20:09:33 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6257:f90:c7dd:f0b2%4]) with mapi id 15.20.7181.015; Wed, 17 Jan 2024
 20:09:33 +0000
Date: Wed, 17 Jan 2024 12:09:30 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Xiao Yang <yangx.jy@fujitsu.com>, <vishal.l.verma@intel.com>,
	<fan.ni@gmx.us>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, Xiao Yang <yangx.jy@fujitsu.com>
Subject: RE: [PATCH v2] daxctl: Remove unused memory_zone and mem_zone
Message-ID: <65a833fa98da0_3b8e294f7@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230811011618.17290-1-yangx.jy@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230811011618.17290-1-yangx.jy@fujitsu.com>
X-ClientProxiedBy: MW4PR03CA0343.namprd03.prod.outlook.com
 (2603:10b6:303:dc::18) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY8PR11MB7338:EE_
X-MS-Office365-Filtering-Correlation-Id: 173d74c2-ee70-4678-2c11-08dc179838b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v+9aKE5OOCAJVKGw0A61OxsNteANaXWWNh81QDeAGzPIdl9qpDuyj/YHQqMIuF63ttsTyZbaLUftEYCn5uXGj1M4I1Fr18QmX6Pg3bpFvjl0A3yRXQ8+0aY0AfIjRDH2cUoVSLZ+tNC5Zu1VvYqXqFRTUF0LcKhblySeAnl0XqNJ6b1VX1L4juEf8BrkKxQzk7nBXTW+u3YYO677DCJStAGv2Z6M6+soUBi4IX7w1zwVV7T2lChkvuf7tXMWwPFYGSfeg7pmScLrcdK4bgjmEJa33ZpcIcoB6kzGlDyRE/6tljA3H6yaJXrdryEW5q60p+eLiACYI1dZwsA1X/UZa5+HmmxxI6WmwFzTljfvSpHG/H4Dz1QQJ6ubGblCvMMpKTfXenvzoqH31QQJNb1w28IZpd6fYbjM88L94wIA1e0gTnr5BtKJg0isd1+pMill69CXP8Bhz9FE7VYcKm6nDnCYhGb9Qwrlyc3l2Vzy0QSpy9vcJQzPg4JxkJgICZS3Z15bRmaJxUUn6vobbr6nzO8pVN87UVCscvw2G7wBRZjiCPGt8RB5YSe5lCm/jAHt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(39860400002)(366004)(346002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(558084003)(86362001)(82960400001)(8676002)(8936002)(4326008)(38100700002)(26005)(9686003)(6506007)(6486002)(6512007)(66946007)(66556008)(66476007)(316002)(5660300002)(478600001)(2906002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ox1i40rLVoCP9ix3fxl+X0WCtz1/stBm7t4CWuQBrwHOAB8HUQxffdyR7yQJ?=
 =?us-ascii?Q?xAMLrQ+KP4O8OGdYTtgKbWdNw/0mmpsuoWw55yWwVWGjuWwflMa6LjAfpAW0?=
 =?us-ascii?Q?CPMvL362qoA9iHci6/wo5CwDW92AUTKRG4Eo2ezpsI47YnoOhT+vvtJ67Owc?=
 =?us-ascii?Q?ZuUITchENGVZ4scs16z6hi1Oy+Du/CX/d9yqKFOo9yEr81soXDjjeeOaZC/K?=
 =?us-ascii?Q?XnQrZHhtMywMsU1QBbhRWe+VDasoISU//wNBoc9OFccGkSk9dNFB1Rhiyetq?=
 =?us-ascii?Q?7AEz8440n7IR+ko+b/HTA1GetspW7W4PeRqRMRcR9w4/+yAXz7iTsVi8mX5W?=
 =?us-ascii?Q?jZFNK1N1BcJLLyIbumWOVF5DRCxWMzr5hzf8nMKYGd0WfQs/P0DfNStXibeL?=
 =?us-ascii?Q?GsYFnCKljYdxhQ4FgpKK3cY84UQgDQJWfiVqVX75sEisQHq7al8a1Cxk0/he?=
 =?us-ascii?Q?OySO4q2shilX39cUPLvCmpulWmPnM3VMyUt+O3EvTXqXZ1DmKwP5yXK5Jb6A?=
 =?us-ascii?Q?j0euVRxBH5pL8W4zcUzjdPWp3w7v8xgHzb2iXi0Fmvu1gzodDnGDxZD0YZTJ?=
 =?us-ascii?Q?PI8v4eFP7CSaX3Io3MuB9KshOqVMXH6vkbVjNqfrFmxJJ12G2GS9rKMss5Zi?=
 =?us-ascii?Q?3kYzM5kC+nBQf0UKZAWA/Ru9HZ2PI0Oqb/AF3b9B0yXLVwWZ0xeBFDvZuSIB?=
 =?us-ascii?Q?fA/kqguI3R9Q+6HSIytwqQxTIgGBRSZSW7WxQ7HNGJnoQdwDpQQSSqB9Cic4?=
 =?us-ascii?Q?vJpeHT/MXNt7d6iitzwR5XlJYtjS+o/eZb2QZ4iv6IbAqGIOG2hQ5WPofUK2?=
 =?us-ascii?Q?e3GnOC6yu/l8YgJ1NgyPzqzgLNL4A5I9jyxrkH15HgaZVDAp8C0YhDR/hxZw?=
 =?us-ascii?Q?SuO/2swY2qRG7PaOdH5EPkdpjyXpSNbwnr8zyCFz2fsO/3UWlzhogNuae/cV?=
 =?us-ascii?Q?+VbS6Ng224maBAxnzPC71/6f1fGOJD/sndw8ZCIwmhScGWZ71uTmYV7FvRdt?=
 =?us-ascii?Q?HnA35xeKjkQLn+BQUH1S4UWgUROGANXvw4WeW7pjQcTPt7fDsL4YqPL8I+iC?=
 =?us-ascii?Q?HqxZoR7iXrnrMKmftoOx9tNoyO1AmaFx+2HgsVGpYNb4q/EwdxY5dgBYxru5?=
 =?us-ascii?Q?ORF54ExEu0+rI5vhi5jx2aPqtG4RN4tEZXwiRv8hwQAyE4pk2JWYAcrZcLUX?=
 =?us-ascii?Q?jv+K/TI+yF1S3CL+kxciKPTau+vCaCzTdI+hhJH8ToNwrygCvYIm+Ok8JdQH?=
 =?us-ascii?Q?QB/6k4CjX+XhHuacx3ErYJGxr7PcEjrIFXDhB6PWS80Alih2Znky9GXCmtss?=
 =?us-ascii?Q?ODMX6XD6QjbWzePYVIBi6VbI7lCloSsAeu97WGRKHHm0HcoYqvr03iCKYxp1?=
 =?us-ascii?Q?opk1qKjl29nOzzT/V+J/HIq9tg9VP+Ctx4paNAf90rSqdO6qsN56eSscRMGo?=
 =?us-ascii?Q?5K6JmIBbLZyg895M4PL8TJ7O8Z1S5iPFT9GUVb8JqjSrysDKi8KvfPjy+gPt?=
 =?us-ascii?Q?sIr3kFPZIt86sfQmV7xcI0RAHhUfKb8+xMJz+0rKdw4G+b3HBvIEZzXdqLHv?=
 =?us-ascii?Q?/0DQKEIIU+m+wscmTHW5LB+xB3yuICZoE0Xyt3jTyvF7R/LS7lIlq+eLB3WT?=
 =?us-ascii?Q?cA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 173d74c2-ee70-4678-2c11-08dc179838b0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2024 20:09:33.4665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +A5i/i+aDcur1vg0YrLBErxCYCJn7MQxgk8ofN0ZVJT/iotm8R7a6lhjokLPVkYVKCVTz1LzqgU86QQvAGQI+QiFg7PbKz72t2vhyHqL6bw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7338
X-OriginatorOrg: intel.com

Xiao Yang wrote:
> The enum memory_zone definition and mem_zone variable
> have never been used so remove them.
> 
> Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
