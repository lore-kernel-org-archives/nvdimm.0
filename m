Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C075717FAA1
	for <nvdimm@lists.linux.dev>; Wed, 12 Jun 2024 15:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718206155; cv=fail; b=C51ALZP9FWJiARYgh9vXx8MbHmwr68b01aplOzsaH4chrI9iAaSonlRwY9eDt5bp7qJoAHSdHM7HHB+oZQXjE/a6a3BTIgMGYk5kJ5Fd9Y4dgOBjQGM3L3WB5yWwZe4MH/lf5ZTHxMOOpep5yRMTqu1wOjAn6NevfFcMUn4Cz54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718206155; c=relaxed/simple;
	bh=XI68pqmvuqRk5PI4hLvDY9kOxnH1Cek+0PoJIgKJkGg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SbdegwXNbEoRoHBhZoEGWgPznkLg2+yVQ7OsqA8CMBX+h7unFvkSCLkjU2CLNYYPyz1Zn3j6HIr9K+UyTEmr8FpL1/UMbR3P3fLmpCd24sz1btCjIQBOKfy7l127k33Vb8EUmaM8blBvwJz5E13hCOPgqO5fS1PeqJMjPg+qScU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dm4nt3pk; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dm4nt3pk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718206153; x=1749742153;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XI68pqmvuqRk5PI4hLvDY9kOxnH1Cek+0PoJIgKJkGg=;
  b=Dm4nt3pks9cEQ4sjnYgs0wTCbvKHRsD0bKwg74vTqMnSTNn3auBiO8B5
   axur1sg16rQicthoCOU/4ep7jmI651rJPgcwiM+sOoPtiIFCM8ra0nxIe
   fHZxOCzrRyMsoMmxYZzvsoQJ9E9HL/d7ibKJgB4QUp5kAkLyqW1miDulF
   aPmhWI+tyojqN5k53A8xOBUaRWU98iAcVZWjZ+xnHKXQkV0r8TuufNImC
   ScrlgEIij2vbfp8m3jVNsVXqW1erlmOHXm4W/Xl30fnK1fpFbjSPKuAxW
   x8k2wiEk5H3yGFeG0Xlg3oGTtXOyjbFjNMUcL38nc+R0KHCUqIq9pPCUY
   A==;
X-CSE-ConnectionGUID: 5S04vZqJRgWrXN21olpE8Q==
X-CSE-MsgGUID: rzHrsACeSuyPOCL8/WIS6w==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="32463197"
X-IronPort-AV: E=Sophos;i="6.08,233,1712646000"; 
   d="scan'208";a="32463197"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 08:29:13 -0700
X-CSE-ConnectionGUID: RUI4tXPCQ2eEolUZ6oRMPA==
X-CSE-MsgGUID: qTWfL63OQZyNPpy2uucyXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,233,1712646000"; 
   d="scan'208";a="77277757"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Jun 2024 08:29:12 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 12 Jun 2024 08:29:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 12 Jun 2024 08:29:11 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 12 Jun 2024 08:29:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLKuISydoeN1kgOdnfmPP6bfjtm+MSSN9AF0V2ArwLDOZsBjegEMLkkS84cx/kaFW1PCIW5r+uC2iGY9bFURU/1dgs9sqjZ+w6VBDYzZ8HXhCho/gncX7xLOls2GDEk2UjuV7dL0fEboc66C0oB2xrIy8dU+5ynj4y0mE/e8xBeIqEy7wS/OZKgCKm6jaBC8cmwoCR4/0BS6WLJT0HZPSXKy5SCEba62pOxfcQCvAm0cQgoSLPLb1M7PaX3TGsOwfhXNVOAoit8KsD1XInlsAhZmN9/KchTxdvIfN8FnbCIHPboHn9G0tP2h65wD2VNGLjTeTzV9F73bzleIpAGphw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bI2yeDdzG85mpcGPWaOURJeTcb3nUiFJfm8/asMrwQM=;
 b=iBz96bkaKSdm6oB/7DQHuyGlsAv170clGMGIHNhY48kD+U8c7TDxrXu2yayjMXttjdY1EmD29jF/NIUbZn+Tcad2Z79ozJqfaGZFbVRz1F7zY353A/6FZQ9tlBnik65mMDSyw3KkH6PxsFaAqz8yhiI78SuwhwN9DITx5fQYtQGbIRuxj1nAO/Yp6fldC33tx++aCHs7dVASvINlR6vKS1S30zADnUAj+JDW5u+2YtTsUxFJZ4NurySqwOvY5NKpcW57H11ASpxovCAEPYKUzXxuNlSSst+TOIl63YpwuaLHb32EHqfGSj6yszw+fQROchobJIcGM8stpoRjUrw44g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by LV3PR11MB8531.namprd11.prod.outlook.com (2603:10b6:408:1b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Wed, 12 Jun
 2024 15:29:09 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7633.021; Wed, 12 Jun 2024
 15:29:09 +0000
Date: Wed, 12 Jun 2024 08:29:07 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams
	<dan.j.williams@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>
Subject: Re: [PATCH] nvdimm: make nd_class constant
Message-ID: <6669bec3102cb_310129441@dwillia2-xfh.jf.intel.com.notmuch>
References: <2024061041-grandkid-coherence-19b0@gregkh>
 <66673b8a1ec86_12552029457@dwillia2-xfh.jf.intel.com.notmuch>
 <2024061206-unleveled-seduce-9861@gregkh>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2024061206-unleveled-seduce-9861@gregkh>
X-ClientProxiedBy: MW2PR2101CA0005.namprd21.prod.outlook.com
 (2603:10b6:302:1::18) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|LV3PR11MB8531:EE_
X-MS-Office365-Filtering-Correlation-Id: bf6cdb1d-a455-457f-d517-08dc8af46798
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230033|1800799018|376007|366009;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ii9FyCEp2PsdP5kgRhF7v0/dBgXzZAMKM/suFyDXQecQp3mDwe9b62THIN1r?=
 =?us-ascii?Q?g8BLLBpdhF/SyKumqkqK1SAz+L8hWUo8B2RLrFXN91o8/H+fBLjfNaDLuIqc?=
 =?us-ascii?Q?lO1fVdCqAQMAX+XT1n+djpAU9kuZZ5Z26FwMozwVloVLTCGOr4CSmnXa73iH?=
 =?us-ascii?Q?d+EeLJg28CwsCIenE9lHX+SslqMX9xtowqKULVrEDrdKBLSulHF6J4Voq3s/?=
 =?us-ascii?Q?yXARwM/5wWVufSfTCrgdGjSwf3khGrP3NfO/ehExXrQd5taWZQukUxXJctDr?=
 =?us-ascii?Q?sCR/rhodPWHCunbJ76SGKGCEB0bg6OBamhdxZM0HKgTBJ0tAr10XUUJcwbaV?=
 =?us-ascii?Q?VLVdEhBDlvBdZE1+rvDS4eysLhsADJ268ozZ20AIoPancRfxjqgGzOH6Eh/q?=
 =?us-ascii?Q?YDEiC5dAFeLRbZoIpzID154jMNPOWF0HwD04pisxi2qe6nZeiadwGOaJ1Dav?=
 =?us-ascii?Q?xqBWnqo0SlzqSSpr2qUgCF5kWBmmDmNC6Ci7hySF61DEWiWkl6pMeM7aww/A?=
 =?us-ascii?Q?9hL4C/h4YUkcIgTupsXtWyG6lhqhdJoWeQhBXQXDrUfAew1giAvoqHbpMt++?=
 =?us-ascii?Q?Ndm7PoVTHmDM0hIfFok4x8uCK/NX6+iFBxvlBdmN44Ho6hiEk3+HWB/gYEEv?=
 =?us-ascii?Q?W8wvfyEC0Ha40RbIiujrB6xaN+ifb0xedSyjmrW7GrOBbmnuM4vG8HAXn+Ol?=
 =?us-ascii?Q?CDleNfEuu2GbQaSrPUFKyWlMMjj9lyg0j/2yc99DpFDEv03f4pWbT1Yk9cFr?=
 =?us-ascii?Q?RzY6H/xDyVF8pHZeMIi5aZ1Op5JtLkcoOS+uVYvdF+lDemeGQH+LUWvbYAYk?=
 =?us-ascii?Q?wDRIDhRV+20Z1GSRWI+rSi+kgydmDCQ9/0rwtg6OXpTKptlTY8cmeFMTrnRQ?=
 =?us-ascii?Q?4DPQhTkZZ/IQ6znbC8tgjr70jIkrKilp2tF4kS50i5O4bjYS0tksAmqlM7W7?=
 =?us-ascii?Q?1wpBm+HcXQbrjnBwnRbDgnphue+x6s9FW4E0Qw44aoM/DOSpd+RrYyTfW/c5?=
 =?us-ascii?Q?fJh3+qW1nao9Lxvgc9YmKg3cYMp6UW9bDgltWte9ycd7si/Ge/US0pYRb2cm?=
 =?us-ascii?Q?okhhrnQgSTwtcQd5ba2EnQNFTXIeVRpabagNblcPZBhgYvX+TZ6hUZR2ZVZJ?=
 =?us-ascii?Q?jJ5RUP+6F/dZe3Mznze5Hhgu52SURTi5xMyRSx1grGg3F2FUfu9iBqMO0rBa?=
 =?us-ascii?Q?fIuFbOGzANyNwleNl/RzZswUKXCBlVlAPFfzP4j/zqN46r6YOVJoh9K5wx7D?=
 =?us-ascii?Q?74aPwyP1ug1LjlXSV8kPo6RnbV4rlOUA6Al400ShMRhgkYujAciIxmALGu6p?=
 =?us-ascii?Q?hA8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230033)(1800799018)(376007)(366009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XFZGj1tfrdk55Ejj61PnFli0rdg02E+LJ33O/ktO3GfU31EeEK/P1z/rM/in?=
 =?us-ascii?Q?s9fqk4pniPKZIgd2zXtMyAkcR7BcoVm2nJ+xBJA5DMv9Xt9aHdqVfh/o8/SH?=
 =?us-ascii?Q?FE2162PjjMg0hdoaiCc3n/+F2RRaa+/3RDS3RXGFoO+eeaa/2UL6HhVoCFv/?=
 =?us-ascii?Q?Cx3lCH/nxGdZS37MDhEVZVGVAtO9e3N/wGoxskQ8BDTlpTAKF7dSOX62LxL4?=
 =?us-ascii?Q?F9LU+AsiBWT2ZJNbZrd2pNfxHlNEWSuhmNaPYsHaOWf/ye003z14HkS1VCdE?=
 =?us-ascii?Q?W83J4z0WLKnD4LZ3P740MskgUVgO90CHRmifCaPfWmkL20/sM3ELWNm0356d?=
 =?us-ascii?Q?CaLdUVGYkBnnvA5EixjjT/CBg3Kx4QwPX7ppOxXNzn8yAET9ypmPJkgOZyUg?=
 =?us-ascii?Q?bt2QixE2jLkvA32plRTyp0v8xv1r7iiSD4PA1oYPJFhFmLUhEmLrCzcXPcMx?=
 =?us-ascii?Q?zkDrq4ul6E93g3LBCiB3jFcknK7qzQVJEhn1otrmTQ0aNJRhUOKBRSBtZk1B?=
 =?us-ascii?Q?s/qAfyU+DEbjswaqNUBG6XiSewA3TjlJ4NGbp62m7du/M8Qb/y92TR9PU+fN?=
 =?us-ascii?Q?BThiKFgml9pvzBnZhEbqwbdqw4OK2zpscMvn63KCor9a18llNrPds29Kb3rF?=
 =?us-ascii?Q?amnoQn1O8TN+yBGcwcuWcFIRgJYloD011IQc92c7Hv+KBGzQ5ulB89nTfOpT?=
 =?us-ascii?Q?JYMabNZiT5IP7pe0pHBCUwq8ke1lka02xFMsWw6/EFmmaiEH+/uruseiUn5k?=
 =?us-ascii?Q?4xTwnYi+SlBqO186TrKmZKYWxCh414XNihwkeb4wBFQjniQMCaLsDwYhcj7X?=
 =?us-ascii?Q?dcAoPqoU3MN0I/grb0JVdOI9jT/1vrdFsBDEgzUtwvVMmB4vDvLljizdRSb6?=
 =?us-ascii?Q?JtllUJXpnfa3iIb3EwCLu2NNaOKWIePPHCer1sujbJCmhxTemc646oTpoegw?=
 =?us-ascii?Q?nTnfQQATwBg3duGnli+R/7ym3ctbiGTYHdmDNBxDL4mAOmqxToWt7ki/ZlGQ?=
 =?us-ascii?Q?cAdFo2krfM7lmLIZeH6oKTJeVDAhOZ7TcQA83JXPljrXqe6kPIqLxiXcvNCe?=
 =?us-ascii?Q?6P74zI8ls2HQDsYxbLUPdF545M/flnEHN88Jkpo+GkeYyE6Ju7GED/n5ulzd?=
 =?us-ascii?Q?6295wY7MtZqLItVS3/TzUCS1byCgrCp/+fdGTlSRie2FZcY1pSpvkCMoLlFx?=
 =?us-ascii?Q?agW0diR7QhYQtJGXEmPK//XZKQTbOR6s/BP/grwB4xHLMJXfOjbve85Ut+J/?=
 =?us-ascii?Q?4HQ45dG8bCjdudAvoL9HDDJak//yDjdPzP9mYLqFlDPkhzSYF/TqiM3hHUp4?=
 =?us-ascii?Q?Ke4RZ7om67U96UXKIsTg0F+yzOKUw+Mn7m12lV9M8G4nWtmAZ/4tDiZ+qK/a?=
 =?us-ascii?Q?EXZcKI20qOCoy3YkJnANR13iM4TwbkecV/6CCvJGKVdMvjS0zM4NMz6th4Eq?=
 =?us-ascii?Q?Id4CYP6mQ6bgM4Et+PQSmuQp28uqZdtUPl7QEJiAzxdcTtM2ynpjys9tzH7n?=
 =?us-ascii?Q?LW65RA4VrI0AdZ9+KlrVoOwHKLIpaJlDmhy9WN0a6R8Ap/of8EjuyU57e8qE?=
 =?us-ascii?Q?0W34D7/TEaxLFll6NUwWkzinGQInkWBynSiEGEnccll+/1ty5Et7P11NaIeX?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf6cdb1d-a455-457f-d517-08dc8af46798
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2024 15:29:09.5868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SuhRCS9uyAzvfDrego9TnSSmHTI90VFEgqpV1Ifk34Ajhf4mPKDaetfctUpVMYyfkpvj+1tm+8YkE6uRbujYLBTGrBmCUyASlR0MHyzITCU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8531
X-OriginatorOrg: intel.com

Greg Kroah-Hartman wrote:
> On Mon, Jun 10, 2024 at 10:44:42AM -0700, Dan Williams wrote:
> > Greg Kroah-Hartman wrote:
> > > Now that the driver core allows for struct class to be in read-only
> > > memory, we should make all 'class' structures declared at build time
> > > placing them into read-only memory, instead of having to be dynamically
> > > allocated at runtime.
> > 
> > Change looks good to me,
> > 
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > 
> > ...changelog grammar tripped me up though, how about:
> > 
> > "Now that the driver core allows for struct class to be in read-only
> > memory, it is possible to make all 'class' structures be declared at
> > build time. Move the class to a 'static const' declaration and register
> > it rather than dynamically create it."
> 
> That works too, want me to resubmit with this, or can I update it when I
> commit it to my tree?

Take it through your tree sounds good to me.

> thanks,
> 
> greg "the changelog is the hardest part" k-h

lol!

dan "can't code, but can proofread" williams

