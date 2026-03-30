Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1933A1E67
	for <nvdimm@lists.linux.dev>; Mon, 30 Mar 2026 21:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774905731; cv=fail; b=jk5bf+wTvjuqmDuafNyI3KHvxS2ialbbs8qzMSFbjOFOLd8dSNkyDjwzTmXXpb38OiOsFhxbGG2JdpAO7ntnQBKu92KErDl96qTsqg7/F1i56pssNnNvdqfKO5EC5VHIBr2xRM+Fhyx3kBMhFIM7TIfvvbLTf8SRGF3y4RN7i2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774905731; c=relaxed/simple;
	bh=QUXShZGTbUrR+xgC9kbpcRF+gPi1Me7b2MuCQQJ8ymU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RW1A7uwxuZoPxoTEdgCoTT7rl0vlj5JjuqvNi/myIH+XeWiNhxlJBat3d+ISuatVjvGdGIzLit07va9oplfktlLVZ8xoYwEM7HVYD7iSBy7tbtINF0ZSSxf/kA60tSEi1dc14AaMr+6dgVwK5z1v2yuKdSzIfO/KgedS/XW8gLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gXnQVpnD; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gXnQVpnD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774905729; x=1806441729;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QUXShZGTbUrR+xgC9kbpcRF+gPi1Me7b2MuCQQJ8ymU=;
  b=gXnQVpnD4+Gm+kaaJxiEcGnwXh3/nmvrUtvvpSeMVz+TcIk6m7AeAbTg
   UORnZqfWGxzxFsmc0hC9UWTYstE+wgWTRAkZNKoHSSm3AvaeuzNfJgwJk
   3pqtQbgkC118MtDIJ8CHv9BOh7DO3+0654e8V9NbhCdWbTqcVA3dij2fx
   J+8P+Urt1AEu49ys8uXoJtsCPgOtgmSGf7tQMp68VM2vM4X/j09cYwBwA
   Nw2GeRGOROtJqL641pk+9nIU5f9zwQFgwwrEAz5RhcsdyapOsyDSqYZHv
   /41lGPzZ50+VZqxa1/Lt7F7h+/xAcqZx3/VVsPUi3vFaAvbVgkf1eTb2i
   g==;
X-CSE-ConnectionGUID: 8qNR0tu5Qaev+EJd8iW4tw==
X-CSE-MsgGUID: k9fa/o+rTImX87Ud+xHnGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="75083435"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="75083435"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:22:08 -0700
X-CSE-ConnectionGUID: LJ1nzKqpRV++yvD4mI+JDQ==
X-CSE-MsgGUID: jcoEDaYqQnKohEr44bjL0A==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:22:08 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 30 Mar 2026 14:22:08 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 30 Mar 2026 14:22:07 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.56) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 30 Mar 2026 14:22:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dnLbhmPuAro8EyNIWfe2obSK1BD+7So3Ga4GcrQbNYy3+ldRqLsDv8t3YF8LK0oUacecMyU6cWM7GwkvjpCDO8P0wN4MjQ9RUJ2WsZE8ZCiPq6Eo4E8R5Nvn0b/uKMZjUdUaPkiHTltRHFvZlw1kqhEwOeydPtpHnZXHiIdk6y2XrwA+jmDjYs3WXuZn263FZ+A+cQxwblZW/Ue6K22Qg1ICMgH/A535a/kNKDuH8NptDAXWyMp1t1bIMPEFVYnkS+Vb/Q4sdbjcIxl5wZ5L86bZzlCuyXVC1Jqt2ERV9+PEFAQbjehQOz2pbTImDowAXmOAHNSuNzPKUUx1+NdVvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zcQUYO9sqXCKwPHm+LuUEVGzyZe17WifgI31Ybz1Ul8=;
 b=jSHjoZ03o/VUIUjQdFfAF9u5LWrWLVKhniMRORS7zTNBYxRcOENDrNZPI68Yd3UkMkJTUetvIqROmaLzbo+O9t6P3GOKFLPl4OwRBoaeDh8IXiHXrsuyDVdmfhC/K7v4DqAQuuvcfbu3OSLePC4YF1weQqpwUCmPPuyeVzn+j0jAw9mONOPPtjFRlev/XMXGiU2fSFdgYTMF0RNutnM18dDu5SrzTw1gcp8kMaaTioxGlX7gG0qpSZKKZd8pxczRXzLBQEgRohrTSukdr6R7nEXhayluxqr27I0URKeg1yMSOHerwk7yEokJisVdhFZrbsoQdesnsq0Fjfmeekt0LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by BL1PR11MB6049.namprd11.prod.outlook.com (2603:10b6:208:391::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Mon, 30 Mar
 2026 21:21:59 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%6]) with mapi id 15.20.9769.014; Mon, 30 Mar 2026
 21:21:59 +0000
Date: Mon, 30 Mar 2026 14:21:48 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>, "Dan
 Williams" <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>,
	"John Groves" <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>,
	"Dave Jiang" <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, David
 Hildenbrand <david@kernel.org>, Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi
	<shajnocz@redhat.com>, "Joanne Koong" <joannelkoong@gmail.com>, Josef Bacik
	<josef@toxicpanda.com>, "Bagas Sanjaya" <bagasdotme@gmail.com>, Chen Linxuan
	<chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba
	<tabba@google.com>, "Sean Christopherson" <seanjc@google.com>, Shivank Garg
	<shivankg@amd.com>, "Ackerley Tng" <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, "Aravind Ramesh" <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V10 0/8] dax: prepare for famfs
Message-ID: <acrpbBt5UsWEiEbm@aschofie-mobl2.lan>
References: <20260327210311.79099-1-john@jagalactic.com>
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com>
X-ClientProxiedBy: BYAPR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:40::32) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|BL1PR11MB6049:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fba39eb-e3ef-4265-25bb-08de8ea260cc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: gm6PKNJ4uvYEhKGpZ0s/pXDHfBDNiE3XE38+eYO4skurFTkQQlzbZMO4KhXHOyj1PPIsWZ3Us6+KnBEztN8VrXRXFZqeAZAsxyIcJ+xjsypDX7R5ZLgh0TnC+5hFN2Rr7CxLrB7kP7y02sqwYtiIs+jEarjYxTR1ftq1HJV3b+QBRbh8H3otjj21Iw4K32biaPK2nmj3rLTzKm89HhN38MarDv+2rNpMrYhKQ1q15QlmXkk+eHVarH5PxE+/ngzNTyMxERdkemI308F+OWfkH01IWeR6i9t7ItRaF8G4An1tIlzYQQcZWYGGWmxGBrywL1CzwFzTTMjRt9v7hAzIckKMebv1sA5m03pRKi5FtnVXv9a5/svhqWIXIsv4YlDQokrOpqJThhkQuN2h16XttNDu2zLX3MNjdjLXPxjaz0s2FWs87W2XDXDgSnbUhcNjB6WKONplY56svSk+twgBmKehYkFfeIzp7J82PKNcjJpmm+lenViuvofE7KFGErzpH9uMUJ5pySeASujEnnvFxCWjRmWtq+0Kl1WJONPyW4PhbFZ2wsYGil5YSVTiHqZM8qCiD4PZWWHF/t5gCfGTQNyxUVBI380Etd5KP4JkyaF35UFbvmFxwOjOxiywyKMg9Q/qMa+EEjh9tVc1uQsLTZsHIp2AzNg8pz8Uoc5DHye3N+b06WeBuOanfMcgxSpOXmu2VOWHYqD++gV1alSDA5tj6Bi9iOGgnXum9x9yYzY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?epjoN8BSv5I2fFJhVRi2pyaQ23sLSDv5wOTUkRB9S9Ec4S+pk0mOkeWvEVoj?=
 =?us-ascii?Q?5BO5ygE/601k62qkjAUuqmUV647v2OWla8b5CS/CHCt9yUdjzsi99GjeUN06?=
 =?us-ascii?Q?bgQRnYHK3jZkBUcXObIVobo7HrSa4nXITsXsA2R1YWdp525xdG8dTeAsbjXs?=
 =?us-ascii?Q?50j41Rb9Q2Z/2SjgoJ7PmkeU6g1tkB8pCdpkDtb/Mqg8jXm1StiGBe5AsLET?=
 =?us-ascii?Q?kcmPZn1UmJoo5jXV9SaIdFbC3h9BGUMttYPUO03JKu0C3WT+tOMJ46sswJVH?=
 =?us-ascii?Q?dmSxFPiv+6exBQmAkBxaYO2PWON8UBNliYbjpW6K5WOXjrnfW1w0o1EOQWwA?=
 =?us-ascii?Q?dKQVRE2o9aK+xtImlr9kd+CaO/tNwo5b9Ybaobmb5e9cqqbuIgeC8UqV2jmg?=
 =?us-ascii?Q?Ifp1X2X7HEfLzGui/dF4NQPNOfdMECN124tQOmefZriub4a6qr9gYMQzj9gM?=
 =?us-ascii?Q?x6ITBxr5f8USfeRSGp536cRST7eAqVW6hEkfAhXaQ3KXb4h76Dk/rHQYfqwG?=
 =?us-ascii?Q?xocbeARpUaRElQ1ucM64EyRPXtaK9pWxfFTXWwzljpbWF/cyt8nUOH6p0UQ0?=
 =?us-ascii?Q?rBArWeGgZEGKx8cxXePYYKTX+JNdGIm5mBqPKyrq7TWCV57Bo5aCC7j3iWbn?=
 =?us-ascii?Q?uMtTR8F1t/0ZeNNZGNWYIUUhumJVZwgg6xzVQeJOpzLrP/KHzxKGIkMxyKUT?=
 =?us-ascii?Q?LEgwm+S2hwy28w96CaqZlsn6GpyygcWSR75oHoYHb8RAkiRjLeGZpn20m2GL?=
 =?us-ascii?Q?Dh84WpV7PRLeia2eB3zRfcp6PaOdSq9ltWz5Z6ydemAAun+X4/PHyKXzQoMX?=
 =?us-ascii?Q?Cqtwoa8rOM4/H76sENgOgoMDVdM7EBXHROoqv6coDewPZz5s8RTJobRDpkcn?=
 =?us-ascii?Q?4tn1BP5SNPfNWivme7k6EJ4IagHwHVZ5t89vtPMWaSxWGv7CjLZJYVdJns5X?=
 =?us-ascii?Q?eQeKiIGLEQloR4LaLLXz21ODUR/Fcv0xVbcFdyOZ7oJFo2HuVx5kJ7BKUEhl?=
 =?us-ascii?Q?7XAtdls7ltKf285N6ld5mUPFRAbAJJX3T4CSEv+FfmnU5PAkLcKgrKPozcpA?=
 =?us-ascii?Q?KEiRusurVLQgQjjjBWxNhQFriPlYPnau6EC6uiDyXXoQsuhurluxYC8qnre0?=
 =?us-ascii?Q?rqlE8h+4LehrpblM9VMi/GgCdWja2b5GkT5fLgT2/UvYqemMSNg1NKJ1l0TR?=
 =?us-ascii?Q?/9O9qxDq0K2MpGimanfAx+rKQ2JsLrd6v+pP1DchW1fmbqUcAmIyY3UDdAfo?=
 =?us-ascii?Q?1PXcJssOtuvD6G/DffVcfdIEovocOY3RZaQnD6fUkOq5akSjSb/IY1ghTA+c?=
 =?us-ascii?Q?7uI3ZRXrFdN0VJ84uI7nkRifMXdCN8szMkzkcN6oOK35ewjJuB+WBVy7zdk2?=
 =?us-ascii?Q?szn6ukfEnwZP1EmiT4wlaJUoraOYa4+cGnbukDQs7Ze3uggaMywQn153MH4B?=
 =?us-ascii?Q?kNPKzGm+DlBtmRB/pHMeXkYzrGICM+MES+vrb3doQNo8eraUvDy0phOyLg7j?=
 =?us-ascii?Q?WamIvqpwdDPNcUaVrKxnX494Kn8+Xzs2x+WYZbygi0G/8fifwJnz11ZhAPWM?=
 =?us-ascii?Q?wvjfj2WdaJpUgz/8TyOUMj9rJuKrmjtZvQw0Ru4/DdGa48OsVRnUhADtbdEU?=
 =?us-ascii?Q?THPY6c8d1QTE/OUri3SQiIEDppz97TPugQ91WSC3JwoJsgFEWEZakRkILoMn?=
 =?us-ascii?Q?ck2P9h6yG2YAjsart91UTHb5IU0LxnxVFwRIT0+8zwI1T8+zaKJHdn31nuKT?=
 =?us-ascii?Q?wADN2V2RLLUZNeRxihJt9mytxDXg6ro=3D?=
X-Exchange-RoutingPolicyChecked: p57brlEFGs0T9PRkh7TSfNBmkJwpV8isCVZ/K1Y2czZc0ktkyAI0wbiesUXdhCE/Cpf2UhYrinbpGgn2fgCbRf1/dfsfd29QeODEAINjdrW25Jd+e2AfUj73HnAPiEz5Aqeae5z6TTzz2sjMcIzxwja7jJLgiu4GXvS5o23X59iUTqzft7HNLip6UXRub3435ee9oIKs+IXI6b4B1UZslaIsFyA9gsU3xudq0LOSwNEmzJiSWY6C9kXGgIiDFtTX5pk7q5xM8T+mWQXFtjhuclNzDzh9Sxsbe5/be2509Fo3/H72pJRplfMDA4hzJZanLIoHK4XNWnR2EmBrqyIB7Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fba39eb-e3ef-4265-25bb-08de8ea260cc
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 21:21:59.5528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: draT0VLasMcpwur/+svzHzbQhLR9pHzwgQA+KKF51BFSHfwfDGPYOWbFxQ+JaFOmBGMlyw/7+4VoTMNwDCBVrCnqq9InFE5bu2ahbvX9Xsk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6049
X-OriginatorOrg: intel.com

On Fri, Mar 27, 2026 at 09:03:26PM +0000, John Groves wrote:
> From: John Groves <john@groves.net>
> 
> This patch series along with the bundled patches to fuse are available
> as a git tag at [0].
> 
> Dropped the "bundle" thread. If this submission goes smoothly, I'll update
> the fuse patches to v10 (very little change there as yet).
> 
> Changes v9 -> v10
> - Minor modernizations per comments from (mostly) Jonathan
> - Minor Kconfig simplification
> - bus.c:dax_match_type(): don't make fsdev_dax eligible for automatic binding
>   where devdax would otherwise bind
> - dax-private.h: add missing kerneldoc comment for field cached_size in
>   struct dev_dax_range (thanks Dave)
> - fsdev_write_dax(): s/pmem_addr/addr/ (thanks Dave)
> - include/linux/dax.h: remove a spuriously-added declaration of inode_dax()
>   (thanks Jonathan)
> 
> Description:
> 
> This patch series introduces the required dax support for famfs.
> Previous versions of the famfs series included both dax and fuse patches.
> This series separates them into separate patch series' (and the fuse
> series dependends on this dax series).
> 
> The famfs user space code can be found at [1]
> 
> Dax Overview:
> 
> This series introduces a new "famfs mode" of devdax, whose driver is
> drivers/dax/fsdev.c. This driver supports dax_iomap_rw() and
> dax_iomap_fault() calls against a character dax instance. A dax device
> now can be converted among three modes: 'system-ram', 'devdax' and
> 'famfs' via daxctl or sysfs (e.g. unbind devdax and bind famfs instead).
> 
> In famfs mode, a dax device initializes its pages consistent with the
> fsdaxmode of pmem. Raw read/write/mmap are not supported in this mode,
> but famfs is happy in this mode - using dax_iomap_rw() for read/write and
> dax_iomap_fault() for mmap faults.
> 

Here's what I found:

famfs-v10 on 7.0-rc5 + ndctl v84:
	dax suite all pass 13/13, so no regression appears

famfs-v10 on 7.0-rc5 +
(ndctl v84 w https://github.com/jagalactic/ndctl/tree/famfs
top 3 patches + edit daxctl-famfs.sh to use cxl-test:

	existing dax suite keeps passing
	daxctl-famfs.sh oops w the new test at # Restore original mode"
	seems easy to repoduce, maybe cannot go back to system-ram???

Let me know if you need more info.

-- Alison

