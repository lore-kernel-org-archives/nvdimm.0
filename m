Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB21C248881
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 00:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785803695; cv=fail; b=BK2b1aZ+xaBNqJ0FCCjxNZObWTuOLUk2s0GPhg0TRhtlFnlXI7LFOi9+2q8YFer1ravSPbT2mOO1fICRZ2r9i4A7l3jP0glX/hvk6g+QLQ/1cVGLTm9vkuOhsEc9e7MVCbPRx7dEmYZqS0L8Di1TVR89d4qJTCn0AqzoeqSxJcg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785803695; c=relaxed/simple;
	bh=4H2Mwh9lENDVLdPc8F+VQ+I5U8L4kT8PtJXpkqTmOqk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KqNRtIoKaTq4fSK7N3I7vi+3u+t39BTCWwMl5LerKwaTYAjJVwn1jrzfgGjRsZPGPOj4m7gnLdHz6hrtMcTeKFNiyTjDttaqoDYC0kdifWsxQ9ECeE6UyJRzMi5ue4YAZAsZ56JzP/OXjBxxb3zj74lWxIQarWuX5FR/tc7FnVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wi+mYzd9; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wi+mYzd9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785803694; x=1817339694;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4H2Mwh9lENDVLdPc8F+VQ+I5U8L4kT8PtJXpkqTmOqk=;
  b=Wi+mYzd9z0QDlNP6tLQAL/m2SnECggGx/9g7QPkWd2vX4amGP/kgee8M
   Iq4Cxx5zcn/vsxyZFXlhcs8OQH5ziATKhwFd9SiUvra3prqTkFm4EOxTE
   C1wedGxhEC3MTgGbl+tLC2UF4m81k82lpkpSh5yfGXQo+eHmPnROxvX9t
   3lpidD5d0QK/5hK30MksbdxjcFTebvy3VApGHsrGDmXEUy9LPrioh5uPJ
   dwnhx9tAce/RiK9peKr83rxlT1W2H5fJt1Oe+OYRrx5vXHyZZCQuhf3sv
   mWGb7aid4mwpIzasvZ1CvlqXoltGnyp+c3pV4i9zX9evGOkjE4L6b/HsH
   g==;
X-CSE-ConnectionGUID: 98Zr6u6rTbexhzGXhuOlTQ==
X-CSE-MsgGUID: 2M4KA859RUmqzv+3WfLl5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="90027737"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="90027737"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 17:34:53 -0700
X-CSE-ConnectionGUID: lEmEwwEkSbaLCYv3XlIREQ==
X-CSE-MsgGUID: vQd4LgwYR6ySfNy7ePXJoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="257470623"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 17:34:53 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 17:34:52 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 3 Aug 2026 17:34:52 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.22) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 17:34:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M/4n8ri0UTzz7up5wodom3JaxsiXDoRvH7IXgDQmOpF8yHHb/3KQMxniYyXZO/aMwkmll8AB/w/EU9kbGz3f3FjzhM2wVWCGvJxvkGTXNJoF5hPip5XgIQjhsECFWsKLAyI2mSdzR+MHTbo+KA2ICCZiUUjOFI1orxRsJ0cfrVvmrkkU/MH7pp84STcKb2XOpCeYXvRmivmOVUPaaDhwsymiF68Seg9F+ucJG1t3PqyDnUswReNUGbr6TSs6I1bkOUN4MRLF5bbe0XIFiwq9Kp0HdpYuEid/Hy6JKragX2f02qNZeew/OVnl6s5hFDeanj4jkOC+VGfJL096kxAAUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5/sJHueuE1EzesjrY1kvC84GUIK3imk0p2NAhIa9Lc=;
 b=w3rFDC4vwaTw/f6JFBN43KiF51hNGuqjW09eGz7UBVzwM7DPST+C5/BMt+PtIAa57UfsysFoFu19iUEFF5KY0vzswGLKYNkvoumfT5bEu6zoTePdzhCdUM2tLIv0HuT88riN6cJ2fomQNeuYXuZtVmmtgT+qg+fm3o/ni8Tl9x5P3mJwPf7vtAT+J0n26MkrxOaNyeeZbZt3JSwTJet6Qaw0IEQvgyH1ZXM6EMQKEF4y1KKt4UtoS5YJ1YPZyPIjqb306SGUy/y9V0PxbanN2CB9vRcGif8QgLt9PX3+dCFB6/leDMAYCiDaONxx6d8jWISmkxPGZKR03zpr4xBjJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS4PPF399DBF572.namprd11.prod.outlook.com (2603:10b6:f:fc02::1e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Tue, 4 Aug
 2026 00:34:49 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0270.017; Tue, 4 Aug 2026
 00:34:49 +0000
Date: Mon, 3 Aug 2026 17:34:45 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, "Jonathan
 Cameron" <jic23@kernel.org>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
	<ming.li@zohomail.com>, Vishal Verma <vishal.l.verma@intel.com>, "Davidlohr
 Bueso" <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Wonjae Lee <wj28.lee@samsung.com>, Junhee Park
	<jh9934.park@samsung.com>, Heesoo Kim <habil.kim@samsung.com>, Anisa Su
	<anisa.su@samsung.com>
Subject: Re: [PATCH v12 6/8] cxl/mem: Configure dynamic capacity interrupts
Message-ID: <anEzpWk5jRdwMwvt@aschofie-mobl2.lan>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-7-anisa.su@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260731084901.1512819-7-anisa.su@samsung.com>
X-ClientProxiedBy: SJ0PR03CA0271.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::6) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS4PPF399DBF572:EE_
X-MS-Office365-Filtering-Correlation-Id: dae525f1-8cee-40e9-3e94-08def1c0311f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info: pw2ckmqa7L2FnOtZylDC8kjpAOB7msiWUSQD7p+DlyX8m8KHl81/NJJY1avB83vt6rNlAuZhcb8zVmBzpR69fdIOzEzDuigFswbMJRXC5GD8c58s5H6Vg7w4kSUqKTxjgoRAhS6RBSsGLefUO6eH8apgjLNDm2dgLqxJXtfDAbkGjqlf8N/9nINDpSuigeftKXIAyW/odVpkrcZXQc8yjTGyPjTkjgL1nEpi8isutKrHbAbvALDIJo5XNh9w/fuGzfL+ZQHG5zBf43+rspCLKoz+x1v/MfJiPDS3DsJKUzA5Rofzan258FkHamhOVC1SvSLoaQpImfm64ilcTHxwk78CmYpnn6ZM9IQqfn1dF7rYfDO9ozfDhn9C9HekMrBG06VHx0Wy1iA0If2ZmavjeP7KIv7DGDb6woD3Tfl+BKk5YyGkyVUMkBfITXXTLQORjedv6O7mh6hyFFktfWOZ/2pIawQovOlmDHc9HZqaCxYV6zfSVMIohCuFh7xptNM5gtdwGqXj5ZsIrkCmdqtASqOJ5nE7/GrXj4GJm7bAqQaBePR4/4tJLasxE73995Ts45k6Vl97jh1vZ0S3naML09FdVrQCBFGy0lO1Ez/FwM54A4BwcOxfPXAj87GuDr1bC8t0+ZMoNGeqJDE7tRvIdkv8kP5Nt8pat1XFXKooRno=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P/sVH3oXLzus7NBEtlB7IWYxFY575FWNW33kxuJaUOJggAFCiuqLuC/p5HmT?=
 =?us-ascii?Q?0FxyxBUXtptx9wXxbp/hGh8dQpNoj5Z4AVEVfjvlnuME/u5Q2v3fqeSlM+Tj?=
 =?us-ascii?Q?AJYxs4MQqkQWCiP6a6ZNb8dtEXo//mm8BfyW1dR2k9dHCo0u9/kVbVGy7ap+?=
 =?us-ascii?Q?WtfiP/GDKrASfxcx1dBo5kIrT6OZRz/N+dXQr2oGIrU8q/i3Yw5adtE7L/iq?=
 =?us-ascii?Q?ooVuiAXMlisDolk18a9smVGfDkl0VAymo7ZPWV3WYxC1h4CCNbzD/J9VeJUx?=
 =?us-ascii?Q?j9/CajNoAIlC5eNfQdT5Zmj0NisQc/AC4cn1k6r2dWoAtmx0Nmb3q8vzf+3u?=
 =?us-ascii?Q?b9KT2qXjVJR/H8qo0laCZDplSovmwnxhrZlvkGqZDvut9SBxPgCqoYvlXmzV?=
 =?us-ascii?Q?EObRexrnrZlddov2yI3hMD+pZkShPsOuiCwNNo6NRbNwRj7dRcfUjSsyRpNp?=
 =?us-ascii?Q?aRACm3LVUjIiFa0PbZXMzyOMHpcbH2cz0hx58dD4wZQ2s+0TBFTd8OhdgAEc?=
 =?us-ascii?Q?hNYojrfsTvi+ftNw5He1DHMu1kGK0D9DZJ6aDx3j4mmLFIuKZVhv3dHXQBGM?=
 =?us-ascii?Q?lsXh/n98olj9SEArNOOPaivjQhgPuK7GWyFS/LwOhLi81p5zF1I6k7sncKsX?=
 =?us-ascii?Q?vUb/Uwcpg1Vx4cq+4yu+ZWV6FEBVLroCKpVF7xRTMDl9psacjnInC60YSW+c?=
 =?us-ascii?Q?Wnc5Xy5Es0MD/R9hPxOLSq4TICpI8+4qRq62b9gGh/Nl31sSuW8FScgHqlBh?=
 =?us-ascii?Q?94hfw6hBjkYuZ7PZhFs1wf3Q0i57vm1Wic15UqqWUJvgt4MwoJBJb0M4zseu?=
 =?us-ascii?Q?+wS9AzdcMGldohdYKEARQ6eA5Vl5AXoi7SvToo6MjEO4m/nwnnercPIyVDc7?=
 =?us-ascii?Q?O+cRnQR5pIVFiSga1OiJ3CmaBlf48Q3P8xJiyiZrd3kZMJqx3Wy+ugGoz5Mn?=
 =?us-ascii?Q?kGakXxXDj6ldmINsb4RrE/q3jNO6cyLHDthjrMiVJpAlzn3qQf6+zSCjPzVZ?=
 =?us-ascii?Q?TV/uibkYB3/rzgn+t6tbwgjc/E8xLL7aK9RNdeiF9uqHilb8ro3Mxy+d8Lr8?=
 =?us-ascii?Q?cTZJCNcZmKE1MYGGGyi7Di6kyoUZGU7mMi3wnpcbnkQuPFrpBjDjSIbukg6m?=
 =?us-ascii?Q?kvqcm1PMmwM8XL3ZdzOtpU+Q+3o1uL7FN3vj52QpB/O/lAW/xgchSjg+6Z7y?=
 =?us-ascii?Q?REnJsu+lKgJYodJbofxmLUxqvd7s3RI+xKZp1LOk6VY5eFzhYRcLAQYPkidL?=
 =?us-ascii?Q?E/9FhNEnpZt658klJc+T/MOiOuUcH0Pq46Xcy1cHkZNsnOtr8deKoO7ZX/QJ?=
 =?us-ascii?Q?mHgMZc00wX/SJh6OVfl3ycGwvYf3nODxV7WgScw75fbXQpgezDs2D+3xyGN7?=
 =?us-ascii?Q?Fl6Z4gkLE3BtUuL61qpzDX4TR/auvxAeiU1aK+WZ7bg0JEVUpqRKocq3q26j?=
 =?us-ascii?Q?NigrKiYLisDBJfcJK1ITCA5zw9lT+j8EBROfrXywjctUBjx6eRem+pGTmHj5?=
 =?us-ascii?Q?q+FMkzPWlDQSk1zE+0nn2+OSDzOvaVMA1wa96rA2sjbDzt3EbWf07M81qvSi?=
 =?us-ascii?Q?nZZAyR7dAk944dB/fgl7xBdkR9snMLlhiSyhupukY1rORnbBYV8TOHBB/jNo?=
 =?us-ascii?Q?T7lro5fOXAR3BEhHWLA59ciRNlN3lqTecmaaXKicR31jzfRrHAcrI37cocqk?=
 =?us-ascii?Q?RtlRgW6SzF4GG1S32uVnk+aYHg1tB1zRBnV7a7tf2EM3GPX0yfK06RuKIkUq?=
 =?us-ascii?Q?BoC4idOMMDk/4ekFHaRZ+baVTfJROLw=3D?=
X-Exchange-RoutingPolicyChecked: c5TBaMvDFaQeIO6fb05CdaK9NV5EpgxJ7U49HoO+ET+JBAkgPkWiaG45jy1svys3gNKO24l/GGiHdakRbjfMmH9/ujCD1DdoEVAkt7iBtjmphENJ0zTsXIW87h8KKPvugigz+wqGHuSu1QXgvl2dxbtzIpPzPJL038oNJ0yS2mDTwbSjYPlzSI1REcf+dA6m9SjR/i9z5WCNyWjNuAhrM38xqOmeR/hYcUrF8T1kPTFhKYxF8AHyT9KfWmXe4IAgsFYF/O0TLFEhZsHcXFQrJn089bL3Yj+Blcm5re+BR0qn7GYL1QagSOG3Nex3a0Lu9rSrStYO5Nqg707yjEPpNA==
X-MS-Exchange-CrossTenant-Network-Message-Id: dae525f1-8cee-40e9-3e94-08def1c0311f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 00:34:49.5640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cm3iBQaiXTt376gBZe0pRfS6BFDMZJ08bjjvATu0bKy+3dHHPsoViMf2XiD74tHJTe+HL8z4TgVFDlNA/1yujoYgQNaA1lH7sKyLaPPhzmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF399DBF572
X-OriginatorOrg: intel.com

On Fri, Jul 31, 2026 at 01:48:11AM -0700, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Dynamic Capacity Devices (DCD) support extent change notifications
> through the event log mechanism.  The interrupt mailbox commands were
> extended in CXL 3.1 to support these notifications.  Firmware can't
> configure DCD events to be FW controlled but can retain control of
> memory events.
> 
> Configure DCD event log interrupts on devices supporting dynamic
> capacity.  Disable DCD if interrupts are not supported.
> 
> Care is taken to preserve the interrupt policy set by the FW if FW first
> has been selected by the BIOS.

Hi Anisa,

I gave one comment in response to a Sashiko comment, wrt 'drain'.
Another below-


> +
> +	/*
> +	 * A CXL 3.0+ device can carry dcd_settings field without DCD command
> +	 * support, so size the request by the device's policy_size and only
> +	 * enable the DCD interrupt when DCD commands are supported.
> +	 */
> +	if (cxl_dcd_supported(mds))
> +		policy->dcd_settings = CXL_INT_MSI_MSIX;
>  
>  	mbox_cmd = (struct cxl_mbox_cmd) {
>  		.opcode = CXL_MBOX_OP_SET_EVT_INT_POLICY,
>  		.payload_in = policy,
> -		.size_in = sizeof(*policy),
> +		.size_in = policy_size,
>  	};

Can you help me understand what happens if policy_size is only 4 bytes.
dcd_settings is never sent in the Set command. How do we know cxl_irqsetup()
isn't using a value the device never accepted?


>  	rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
> @@ -596,7 +635,7 @@ static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
>  	}
>  
>  	/* Retrieve final interrupt settings */
> -	return cxl_event_get_int_policy(mds, policy);
> +	return cxl_event_get_int_policy(mds, policy, NULL);
>  }

snip

