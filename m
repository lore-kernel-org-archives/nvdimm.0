Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92278147C74
	for <nvdimm@lists.linux.dev>; Mon, 10 Jun 2024 17:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718041497; cv=fail; b=nxkZrx7n+XC2Rm7/nKxx57XGiUVIlSsNeDMgyFKmwMJOFLz3TMbyLhakEi8EgS7LCab3Z09VqgqTx1rdHBZI8639+c4QNBcOECWVFBA1c00OljJ9tHoLMGuwT8Pm6Nz3pDS5UDwaOTvcTadGSlcmRcLBjqQdhuOmHAFnk97HS+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718041497; c=relaxed/simple;
	bh=ookLVnbVJTyrZZn3wDTA+AkWQCU87z+AULrE1ti3k3o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H4VhmRZuwfU625/B6eMgl3DBZ9qC/7oaMLhtCoNUi0QnbEDH+ont09EUuCi1whXBJ10DgHFu88J7inTFUJXi5RZLiDr75HD39abKxNDkBiu0ES1zV2hQzsuHkXMNhEIC8v2w1u1f58r30EPT3fP2h4NJ6wht8Zcx+F27WwaLj7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WuOHRzRB; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WuOHRzRB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718041496; x=1749577496;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ookLVnbVJTyrZZn3wDTA+AkWQCU87z+AULrE1ti3k3o=;
  b=WuOHRzRB9LN3cWspOAyl/X5FjqkYoDyJ2vBFW9paKFJ3ZYcoz8+oDKNZ
   HwYGif4dYW6J6I+rrsvI9lnLIhiGSaClQnBH1ndJp/H/y7K1OrLJNi2Sa
   SoeIm1oKMNhjCgA82Fc0H7sz6hg8lFWiEJ/PoYvIuDnJwEgxkRE3mZsNs
   v7zdrZy9AbfcaFglO2+oXYwufip9LRyyZX0A+Zt+3i+Cykr4XUFxMcrVZ
   Jfxlynb9hRctEGal/QnVLm41WaNZeHUW27/0WsnXFoHsaM9CkEXRjd6Wv
   SyI//v4W1Gi6088vtSKjM5HjDGkQ6pNUcdrsHsIXAnKY+XSzCAGI/aBnh
   Q==;
X-CSE-ConnectionGUID: sb+TNJm4Rmi/62qpaJaFYw==
X-CSE-MsgGUID: tZsrxFa8QTSxVIUrfZXW6w==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="40115545"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="40115545"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 10:44:52 -0700
X-CSE-ConnectionGUID: lbeOvrEHQFqy34Hmc08cFA==
X-CSE-MsgGUID: IJFYtUj6TdyqaUtVSrgGuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="39233279"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jun 2024 10:44:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 10 Jun 2024 10:44:51 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 10 Jun 2024 10:44:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 10 Jun 2024 10:44:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcN35aH2mMZ7T+441A8yXW27+cZBcN4llqtektwlxotHXhsMJwhhZ04eyx9Y09vXOnjMXrUfJwItIBSD7pIIN6Y+UCCMyP1FVu6R39njKffhVPMLrn+JnO0lMTr3fhdaQhIscL/OBOeBGj0AWkc266JATXDuevtMqjRulDKEhKj6sX3hL/EaJZ90zrsN+/+A+i+6yerokNBLiG5j4OD+AD5ZoohUMWjWkgX92ZWbsMQo4bifG8aHKhmLgbviWipdQNnczUhIevgOikWRmuGErzOcScsB57wnTrAsxYxHkYVHMRr80FwxqoZ8fcZ8tzUmVssdtCH68mvKMUfzCQ6kTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ookLVnbVJTyrZZn3wDTA+AkWQCU87z+AULrE1ti3k3o=;
 b=Jah0aPMUFL2GZRB+6dJUebHxgL1UI4O1my7Jh82gvaRoMVuMQrGjiVCk6jt3cZcu80hh8yirRmQm+yD1NLw4ti3YVX4ihhjJAlUmaD/dvmWJMG2o1TqTy1krjMydqzVzn5I7xBaMjwuPvNnw+KsA9LNrnU+wuJZCwrtW7X2Nl+IPEoi0m+kt4Ti9jHRIR1dwIz7V3FYA4e8n+zF0oILuYljiSEgL/cyiIde8j+yHBx4Wr6Vv3ahmo6IRRBAhlVvtOjIDr7NcDghbBB1+ZbK6zGfvME/3h6eaUXUUmwWjSLK+fkSM3GhYgYax/Jh3xMilo/BS36/1OZtFi3vq9Y0Nyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS7PR11MB6296.namprd11.prod.outlook.com (2603:10b6:8:94::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 17:44:44 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7633.021; Mon, 10 Jun 2024
 17:44:44 +0000
Date: Mon, 10 Jun 2024 10:44:42 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <nvdimm@lists.linux.dev>
CC: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	"Ira Weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH] nvdimm: make nd_class constant
Message-ID: <66673b8a1ec86_12552029457@dwillia2-xfh.jf.intel.com.notmuch>
References: <2024061041-grandkid-coherence-19b0@gregkh>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2024061041-grandkid-coherence-19b0@gregkh>
X-ClientProxiedBy: MW4PR04CA0272.namprd04.prod.outlook.com
 (2603:10b6:303:89::7) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS7PR11MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: 40d99d1a-0b8b-4f35-12eb-08dc8975038f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mE0MWPAVRHowBIqaDWxqGFBnoXRVggch/wuuDhYDFr3vL+26lmhWB28yu/u3?=
 =?us-ascii?Q?J8I98pjZxExPb0q6aeJ8h6JtzSIUo/7oNJElokvTTh23/LMdGj2H2AWuhcE7?=
 =?us-ascii?Q?fmIZKUIgMgU3rSdFRyU1aDO4JgSo3q2IVYh9Cr5T+QvyLmEMu9hU3P7OUIx8?=
 =?us-ascii?Q?ZWF3PzEJPdSsWXYa1FHogPH7rm4xD7fC3MqG1BfIKKejbysCaWx6gGigWhMf?=
 =?us-ascii?Q?U3Yw5itLwKuRUhmmi5g6EZkz7EdFTwGc/pcbKpXOdFxMb3aWykr7MWgsBcsc?=
 =?us-ascii?Q?26DwNgG/eWiHUKFvGf0EqbwOp0vagwQLlRAJqyY8jv+A/G3lAgkCvneE2EPj?=
 =?us-ascii?Q?C5EVc+uNCm12qr5TLlP/WD2zVXRy2GOu0jIT+NTjMHiq7YOANAERMbEKHO5h?=
 =?us-ascii?Q?Dy9JGQMFcbSIcGrMIDmL/1HUtJpsGx2SnweJVa5x28LHqM4Ksd2+Suwg58Ig?=
 =?us-ascii?Q?K1XcTXKINVEtPyXdG0vZNoZzuPM0H1OD8i3TgVKRbcbsE/9ev/kv+88hHTlh?=
 =?us-ascii?Q?41cIgnjWrFeZcVOWXLsUXKTSmKlNllrIkcvRz8UOcYXEowh2rBXOWjgPE5uW?=
 =?us-ascii?Q?wibgWNx4lAvCy97jtFtUrNuY2zLRJuEfPlDj3i6rypHK5exGIy7rixMQocYV?=
 =?us-ascii?Q?1VEhbec/eftFGqHVpWlWPIKog0LWK3XvxG+ciUEMGbhyNO8+YcaGfq1cUqBw?=
 =?us-ascii?Q?XdOroQqcY1o9jc+GNvPWbjZR1T0AtpkJAN4upkaBfZfQlmUO8BqOjiZHMP0c?=
 =?us-ascii?Q?mnBAXU42hnIVmm+DO6tBvWefXAhJSvtAV87sMpGHcgcgJ3e8V0Hz30zIxPFp?=
 =?us-ascii?Q?wG6EA3WSa195e5feJmGp9vhYMVojNHP5VXw/Rf6R2n2bCLqPD53GIYxrkyQT?=
 =?us-ascii?Q?GRirkeXM4dPVhF1L9f/otGVw98PvizcsfTST3MTvpHIs8sm+51WjGeJYyQl5?=
 =?us-ascii?Q?DK6PBHLKo1x1xjbwvb4JOcc1OCmQHkWiNw53hVzvXR6YnFfa1kxBYYd6Dlzo?=
 =?us-ascii?Q?ihT3okjbRKF5wNUqiYLxJIUf4NHtft5RYn/+if0XkQx8vi/Ih3NIqV67mw2x?=
 =?us-ascii?Q?hAUd62l2lgePatfNyR1bYE32Dn+l4fKAAoQ+HYOfa1aRRIJycoiQ4ZdZj58H?=
 =?us-ascii?Q?oTjtw+Q4P1FlwviXUGJWiIimhPqcekJThs5/igevqKs0W2dVthk8a4aUP0G5?=
 =?us-ascii?Q?1E0on6owgUsMXdJ0Rxxa92yMWaYGthAlB/RZ4F7LalJYBknRR4gDrVhi2jW1?=
 =?us-ascii?Q?EvZGeghDnjOFKMPgwWJDv6ETnYggOEvDn/KYXihe0R1DlZ38jayo6ptxmRMH?=
 =?us-ascii?Q?W3HxUysM37xZ3oRaZ9gaY9o8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7ZxeuX1pxM7mKD0PnUGhlA4srxY78mfmy/WjV8Deb3qbPjMu+lVNciqiApLX?=
 =?us-ascii?Q?qkfcG57c//6n6DkApn0VHDlM6D2MM//yJ55R63p8EsND6ihv2ZVlIex7q7oG?=
 =?us-ascii?Q?D+MWiFzIbKcEFbZ/8rgEywDzqs/6o7DUjDSo+z3uLBsFafeaWk5J+NseiuZM?=
 =?us-ascii?Q?BmWiQ3eMQia4Nm86e/dbDuKvu35KypJzcV1XQ3a7lgW4405Bz61KlLtIbG/o?=
 =?us-ascii?Q?nRYNDVLqvWFeP4i8lU+JSqI9DY4uVc9HvG/Cc98VVQRVC6s3fR0Pnm/XMrwd?=
 =?us-ascii?Q?/C2yBKlZvVaf8fH9E5fkF9FUObdOUL/EFxpcPIW7oZZSM+IkSyCG3o0/h+nO?=
 =?us-ascii?Q?QlmfWrNt9Fu/p+d2gpJmX9hhPlprM/hIbkayBDplXZm2vl6DqiYMEUietZt3?=
 =?us-ascii?Q?S9TQL4oS+Mt/3lUwVlMeQue/ERkvXLasDjJYLkGkA9xLvmxemxsyH9DdNdZb?=
 =?us-ascii?Q?yxIeK9ZO1JTwRhXI5AntpnIocemyn66SAhbHC4b3km9+MtthnQQ9tlGezJ2W?=
 =?us-ascii?Q?frPaOFAF3bA9Dxc/M8jaW6SaRoM4OhtOQj1LV/yFjoWmxqWyMMhE5ebE7Dx/?=
 =?us-ascii?Q?PbYRLUyXG3qbLnajJmMUxNvjncgUB7JV0G4bZ5t8N6+58q0lui1Iw00kSIHG?=
 =?us-ascii?Q?sURdaalGh0yxAIDa/zVeEk4VwMyU1YQq+e2FLXDtF/fNb20Lrrss4bxrqMjf?=
 =?us-ascii?Q?DlEBRVt/FypXswgQ54DFgndil8qZtjz43eoVzMg2QUCOR6ZUYrsZuBB/i80e?=
 =?us-ascii?Q?ZAMtqFPRC+VyeJpqAM48lQ+OmuwtF3DXQUGwBnnOoORj2YYBKBU34bfXqrdb?=
 =?us-ascii?Q?EMix6UMbOhBarQ7fq/SXJof08uvBPF2W+pWUNlblPVVThwBhq0b3CC0IQFX5?=
 =?us-ascii?Q?xF8HjfjaBdTBgurRVHFofLplB62a99vvw0vD4WcU3sCid2doIQMATz5zSFqY?=
 =?us-ascii?Q?m3zJYSI+WKNj+/kUwOCSIEHHP9hX8iD1YWoB2FnYX5WJf404XQ+K+Ua9zgs5?=
 =?us-ascii?Q?W79vwFKPFXBZDm5p4RGPeGTlp2IaD7kVBYVDQUFLW4PrF1bYtC/DKfvU2aNZ?=
 =?us-ascii?Q?yYfiDozqdBELg7o34241nPoFTEBeIxLx+4LZN+YNKr/0clvsygtgyloTNGJD?=
 =?us-ascii?Q?8b88Bu76kzTLKsNKER2lrr4XZ+zw/hECx6G6nkymNwZztpf8RSfiul8LH06L?=
 =?us-ascii?Q?pM19lzoqgteQVm5TTdCATR61Q1tiH534HND4maRd3kpw2V98pvGFUnplM4nX?=
 =?us-ascii?Q?PQIGHwpl9uXjTt36BwBzibaZh30TAg56hE4uaFstuNkgjBVyHN6zhTc8ovVH?=
 =?us-ascii?Q?Bz9okOJwYm1Ryj5vUh7qjqAeaN5BDlrT+M7s/X99otAD+yJV9oFrzG6VcYAC?=
 =?us-ascii?Q?9bqOSH2lajlaGOeqNUXZPRKw2+oABtebJ8Mx5JAsifgAgrUL6RQNCyXdcqtr?=
 =?us-ascii?Q?flhb2/ngFA1xFBI5A0cQJSeGoLUDW6idGPTw6MMC+XQ3UnTkZ0twYUAw92hV?=
 =?us-ascii?Q?jG0Hr2JcRw+7N7UVfmZs2Z6yotQtoynT39uzWb9FWmBe1fBT9ZpMGQHVMqQx?=
 =?us-ascii?Q?Nl2FwMXk400nlOrgWDouLDRjjUzt9e9oIrOBN+uq6x1bnp+DiVLrusxZ86Lh?=
 =?us-ascii?Q?TQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d99d1a-0b8b-4f35-12eb-08dc8975038f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 17:44:44.5042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x2vxUPZrOLYi/6TqKmiFLUg5q3sZNj3Mk960susWbbNphTWdsTUbhCXrw////k/rdw2NqPwmAU+CZdHe8LbOJtL8MVAOGQOG1k+cKesO4Tk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6296
X-OriginatorOrg: intel.com

Greg Kroah-Hartman wrote:
> Now that the driver core allows for struct class to be in read-only
> memory, we should make all 'class' structures declared at build time
> placing them into read-only memory, instead of having to be dynamically
> allocated at runtime.

Change looks good to me,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

...changelog grammar tripped me up though, how about:

"Now that the driver core allows for struct class to be in read-only
memory, it is possible to make all 'class' structures be declared at
build time. Move the class to a 'static const' declaration and register
it rather than dynamically create it."
