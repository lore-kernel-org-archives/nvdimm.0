Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5014C7D
	for <nvdimm@lists.linux.dev>; Sat, 17 May 2025 01:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747445434; cv=fail; b=T28ILAtgZsfVU4DJfZMRRKfNM8DiQ9IH2S8E+bJEG9e0eHZH8VZ0DMHgHT85AsT2FecaLfdn4wyxTuNXeCZ+xaMEWqQ4QKY/SdCfL6OG6ZJgRFluLcd+RmO0GjSIYU8d75C4e8ZZez2+67ONwgs+dnxEimHtCfmgJLQ9ITyC+2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747445434; c=relaxed/simple;
	bh=y4uhTDUoEUkKdwqhZbr+w65I0Ro3TUspct2q8wm2BFA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kUc903nMCMzirNMQVYMmDRNUZ3Cx9VDq3vFW20ydzbyD4Lg3yFunS9uU12gtZubjY8qoKHrsItgGxxOEQ7yfYOKXnGJDmAHFDuPWNRShoNKJMaXlEqdUzDJKbGp0Z+mGZAR3U8TyzZK5nHY0EcbsPBuzJHCEFJbE2HaKcB1gsLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V+vxBeX9; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V+vxBeX9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747445432; x=1778981432;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=y4uhTDUoEUkKdwqhZbr+w65I0Ro3TUspct2q8wm2BFA=;
  b=V+vxBeX9yzUdN1qjkpaakLTstEeMMbNwhGbIBGPMc6iDojYOT14LPTJR
   6HhlqRtsFYT5Rwb7SPh72jsdep1UthQL7m81FZh+kGs1QXs88Bci1J5LI
   DlKF3B3OXy+pnlGijz/kDGi6p2ZAbHk2jA2XGxWWkDC+sTHNOGvvw9z6k
   YJ9f3nlMSLG6zsXTdJrQj64PbZA5/2T9KyG6A/xner4o2wtowmfGrrA6d
   u+XyDG1dQlBMC3wWPdWw+gdZ9bMmD8AcM/+0necdm8HiOndw4opzCt3tO
   R1QuxO38HmdiIMMsFSDHdQU7z7R+2D5OAlNZVtVpdfw9DWRSOxsFUYYF3
   g==;
X-CSE-ConnectionGUID: vH7kn4rbTYebSYV+fMVmWw==
X-CSE-MsgGUID: hLh+RftASM+r56JkIVEbDw==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="49584685"
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="49584685"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 18:30:31 -0700
X-CSE-ConnectionGUID: 6+zfLcaBQLuRAzeMNhIUHw==
X-CSE-MsgGUID: sgWcDX/jSxmE8LS/Lr2FJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="169778192"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 18:30:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 18:30:31 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 18:30:31 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 18:30:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OYEaVIPrzrenpzjHfxJFsSo9GHpDIgdwo+0Jf1P+NtKp1hjASfp+Trai+WaER+KEPYTTaW7OmF1p3+17VINcVE/afM4yBEBUlOVlNNxU2gcJ7Zsflte0tJ9ZTI7b4OVgaNFFW6s/hzF0HhWqLgSrFTfoVas+ARXgBfqrTmR0OnTz5Kvq6Js/5lWB7zXKRtboF+1ZaTGxdGShCAIaYbVqu0KQKflCK6MXl+h4cLEWZyAfUlMu19885fgw8f4Hax5HbnF3Hx1ckeBnM8nwt3k/3Qo6acd8QRnWbJAi3h+rEGjUnJguRvlMBzIV5HJR3juhX02xjSq8wps1nGxBJV4QXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F8McaDKdCq/cDSNNg87J++qHICPRO/6ossDMh+0XC1s=;
 b=w8yYanM5cwJudtE9IY9MDXKJMVI2lafu+SthzoppbjG9j/AMpJJNFsOZdum172IWRY9x6OE315BNBwXX7N5dNWtaAxFy37HVbIFGwM7EftbMGrEmUTGsvTityzBEcw1pDttCJhpueFxSO103lBuYNi+iDGr3PVUUBzZOXceq866HyQdf6kU0573chvn2nF6ZybnNxrpaWqmcRNO3jaOQ2CRhpvGrZTIBnbTwN1ubY7nJtvTwFXz97qOHYzVl+dWwpAbRuVIGPJ0CAbeLDrkkOUEGFtHEZkL2a5mfwbZJBJR1Kv06RPsPtkWGEPykbMn1dfpyqqnhwSbLrxINE3de7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by MW3PR11MB4667.namprd11.prod.outlook.com (2603:10b6:303:53::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Sat, 17 May
 2025 01:29:47 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8722.027; Sat, 17 May 2025
 01:29:47 +0000
Date: Fri, 16 May 2025 18:29:35 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Marc Herbert <marc.herbert@linux.intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, <nvdimm@lists.linux.dev>, "Li
 Zhijian" <lizhijian@fujitsu.com>
Subject: Re: [ndctl PATCH v2] test/monitor.sh: replace sleep with polling
 after sync
Message-ID: <aCfmf_cYQp-KqJWy@aschofie-mobl2.lan>
References: <20250516044628.1532939-1-alison.schofield@intel.com>
 <6826d67768427_290329430@dwillia2-xfh.jf.intel.com.notmuch>
 <15a03474-57f8-43ad-97be-ee986e796df0@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <15a03474-57f8-43ad-97be-ee986e796df0@linux.intel.com>
X-ClientProxiedBy: SJ0PR13CA0221.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::16) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|MW3PR11MB4667:EE_
X-MS-Office365-Filtering-Correlation-Id: f27ddb57-86fb-42f1-c54f-08dd94e24f7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YA/emRTSyli7JCAN1tien0O5EDo6ma7WjHnYv4djeZFP9nkhryyXafAxxleL?=
 =?us-ascii?Q?vEQnhS2kmjYV7ft3UjxjjXiZE6d3kVpbUdEdSO0F3RMZEkD+Opd1ksOPWQKy?=
 =?us-ascii?Q?LFZhO/7O9dlUqfWB4fm5FoX7spGc7ZCoMVpsU/lM2glydipNnZfnQhVR/46D?=
 =?us-ascii?Q?l7b/A3co0MjZMzHG7jWFJ/iDLWWT/y7SUi4ZoKy26AsJo4eLzCyAGgykCO7H?=
 =?us-ascii?Q?EYNEUoHK+3Qc5Qj3pluZOuoqxRveQBtABjntk6JMNHBS6BwIR5DtH1rDxhh4?=
 =?us-ascii?Q?A3Tu0FbqPGsOQXdpCl9Ym0GdwMCS+aW0qBOpyBFEekJk+m1LKWrGSVv9OpEB?=
 =?us-ascii?Q?wKWeihzjKOaPsSNIAwxXGFlTAuACoTAYXTbyLASVmkiRzcDVZqgBot045INF?=
 =?us-ascii?Q?Hiuy/YbMCNctoqv1SkPXcZ0QUAxvTEon6+Ywo2SCgc2wTxruST1RaN9IFKOj?=
 =?us-ascii?Q?K+/3kW0IQ/EnS9g5T1n79Xu6xguSSf51X3PxaSTjTVrICcazLmJQk5WZbd6v?=
 =?us-ascii?Q?S3xRD6te7Mh/Y/U8isvNTEMHAz9/LMgAwznhw+LCIfEweGbVNU2CrElOwUY/?=
 =?us-ascii?Q?XgpgI8NLcktCc0VbGQKHBNxmhCdCw9v0MYUzCI1V42WxuyDIjN5NmpEmHZsH?=
 =?us-ascii?Q?IWIS1KQ5wvJvMdLgS1SVTbOvoQyGnvN8WZv7vPuiOiADQJiJyJ2sHkJoH3zj?=
 =?us-ascii?Q?tVCpQr7Z8joy2mmQFVXZXYjeM+H9/KGTiPrdRtx0MUfQdkSp9BM3nN7hNjrO?=
 =?us-ascii?Q?uUNW4SpVQ4zeoQuqrO4Nj1xu817Mb1jd8wBQTje8RV+/6K8M7AbV/QAH/tC5?=
 =?us-ascii?Q?QPj9NI1Rraoe3TthnshFVQlS7nTH1A+4VgrGN7XWZDZJa9x7fFIOF7qiNRO8?=
 =?us-ascii?Q?H7q7lYqOLawt46vPi669YIyel4ImPdfeuxPzAFzoE0VS7ZsXaYGqSaRfzgLN?=
 =?us-ascii?Q?DNTUEdNmj7UWOVm4TNAkV4QB45UMm0jpCTewe9rkWMfaV3OI87YA2SlFfO9p?=
 =?us-ascii?Q?4jYg7bc8FUl7cKcIzTzVc3Zk3v716/sq83w1n1OaFcgONnDgnnHY/nImQZ0Y?=
 =?us-ascii?Q?JPVi1K0/GyEyVLeVvGi2kpnnGZeIS4i3JTNki0nKIy/XUvIx6zubw4C/0+BV?=
 =?us-ascii?Q?ObMwc1X1t9zWRDOh2Lb8+8SLWr/BYefQEOHAsSJVd8RjE7KiBu5ztpSjE55g?=
 =?us-ascii?Q?wUW7BHIFSqbZPmC9DbIOMmWYHRx13q/1GKT3HaaBLIif9gaY5yM6XDKRQG99?=
 =?us-ascii?Q?QRxGR5fzcJI15IavpSzhEb8fxr6N95fPtZo+NUVyMF0gSPjo5ll3gYNGo6Zx?=
 =?us-ascii?Q?D+4dZsMS2X4g8SpzjytRx//OWApFT27bFddO3jHSNmModyqhuetNV1hsk7MC?=
 =?us-ascii?Q?eQdl4qc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rYpexUqPoIGvkSfF7uyQGTc5U8tvRo2QM1QsE0Tim/+wWPcW3GLwHwDicnji?=
 =?us-ascii?Q?yzTBxvJOVhixVrL/iHHZc3tJ/JAt4MAnFtu7LSUxxCuSS/j6RabR7sQ1TWRV?=
 =?us-ascii?Q?zaQnGCv7S8dXdbcPY5WDf7VRVUK/Uv/A6TE/roBSQioLM4l7pK0QNCMVufvr?=
 =?us-ascii?Q?I8Ov4yUDglxIEBDyJXxX8SFQAfPZDblxiGkNALBca+Lfgyzr1b3RzltVbbjS?=
 =?us-ascii?Q?8nsDAjhG8Qc3w9anx7Iwmx9uP9s0cRIKXUm0fbGmTckxw+Wdz9iiLjYnW2ty?=
 =?us-ascii?Q?ODiD8g9OKFl1gsxYTDUdl1cAfKk4PngCWNcTjQ7b5XXYK3FadiMq2nmSyBSs?=
 =?us-ascii?Q?eQ1S1gu9hAjrGbaRDWjM7b8fzZ2SfqlSeJ1n0ME/jrdX737tPp1GZhsbOB+V?=
 =?us-ascii?Q?XXZpA6GOO8UaS0mO8IN/lMf2LMhDcuUCzaWlvku0Klhv7Qy5bcAFBBDYt/3t?=
 =?us-ascii?Q?e+DKu6CZzO7MJ3kxIBuuUpqiEEeEpTnNpQltiyuogvTqoqW42+Gvr4+i1EKc?=
 =?us-ascii?Q?VyDuqZf2VE/q7JO2DqkE8W5b5jTKCC2YfiG14WdkyK1Js5O7fEdHHziOSXJ0?=
 =?us-ascii?Q?K/Yyk0pFYHpouk++akaKABhkXfaCZFA503yo4MrGoiHVUqXQrPG+Q830wZCk?=
 =?us-ascii?Q?u6dlgXmIjjjf2RnXOoLM1UcQTBGt/W3EGNp08jlfgAUrlXHFkjnm9BzgGEaZ?=
 =?us-ascii?Q?0CyRBvqPqKxqPiUwL+pli3WFONgpHe77VWuwog33mpbk0cf80ts/FQIa83k7?=
 =?us-ascii?Q?jskeLmyILPTPAeT6ThK1kN5AgOpQNa8O/9cl9jcv4TE/d4uIPv62k2O5WfdS?=
 =?us-ascii?Q?W10sQn4PzXdAtER5YSEYXmlw73ltyJ8Khzw/DmqSlx0BmbadsNUKjkwbl6Xp?=
 =?us-ascii?Q?GShN4HBwreRQSFBVR1dM1mE9/jypamcCBhbTcJe+Uk2boT8Wsdz5GyzEG7r6?=
 =?us-ascii?Q?xVWhB6pzbiaUNS5tMIWiyd+49LIVZGdlkoHTXr/+1dilmlCwScBpy5/bwBTo?=
 =?us-ascii?Q?rz2pggKukVcErAidZ3N612iwLHyl2qdMYWu6zNeDAvP4X9/ER1tB9DRAwlat?=
 =?us-ascii?Q?MpCPSbaC8j0t3WS+R6fptTRm15KJw3FeDxLM/QWmzfXqgMm1QZw6UbXMP5N9?=
 =?us-ascii?Q?VIlaKTcUB+Glg8Nq+4CYOatCkNz/ddpl4PdgAZIRBIzDtjP71uTM2q083puS?=
 =?us-ascii?Q?FuWsMY8/e4+hhVne+PckKrjyA5lT7Tglope8Ir14TcywSBE+fQN3gPF0FbO8?=
 =?us-ascii?Q?CBVUvZ9QKdVkAsztkK+z1Mip+dRReRnNbx53S0nogwGg1+zeXNz1lYSq8bpk?=
 =?us-ascii?Q?ZgRsYtvNxKW23OuTrpFZOR4/OKmRzXYBON6hmNFCkmNFww53haZ2B9hAlnui?=
 =?us-ascii?Q?WXsIs8iH+EXHp9AnUGb1dUNel4WB0cKgLHUrgdwehf0T5zzvdTW2TXxxNNBs?=
 =?us-ascii?Q?VNmEvLPdVO2MYOFS6YQw/VFxYUHwsGkgqg9qyGiBsNGgHgHmECfoU3j5jR8J?=
 =?us-ascii?Q?HFBOlpUHjQxnzBK4CUItsuVQjyqeaH1U7QGflP+dDY7RBuWPlxz8EWt/BBNj?=
 =?us-ascii?Q?ic0zdaEX3PB0gpc/XngO2gMdFEMrBmhD2cfojQ9RHVrxGNErkU0kRmiuS714?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f27ddb57-86fb-42f1-c54f-08dd94e24f7d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2025 01:29:47.7926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y3cuc4UJ89q/1o/jLtUqHDykE9hUh5gr3iqBePx/hkkjey4wLzLvyavTJSnC1ObFzW0L+SF73u0xUHLVyFyOfnXajq3bg/Zctp3NmB8HH4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4667
X-OriginatorOrg: intel.com

On Fri, May 16, 2025 at 03:34:55PM -0700, Marc Herbert wrote:
> On 2025-05-15 23:08, Dan Williams wrote:
> > alison.schofield@ wrote:
> 
> >>  
> >> +wait_for_logfile_update()
> >> +{
> >> +	local file="$1"
> >> +	local prev_size="$2"
> >> +	local timeout=30
> >> +	local i=0
> >> +
> >> +	# prev_size is always zero because start_monitor truncates it.
> >> +	# Set and check against it anyway to future proof.
> >> +	while [ $i -lt $timeout ]; do
> >> +		local new_size=$(stat -c%s "$file" 2>/dev/null || echo 0)
> >> +		if [ "$new_size" -gt "$prev_size" ]; then
> >> +			return 0
> >> +		fi
> >> +		sleep 0.1
> >> +		i=$((i+1))
> >> +	done
> >> +
> >> +	echo "logfile not updated within 3 seconds"
> >> +	err "$LINENO"
> > 
> > Hmm... not a fan of this open coded "wait for file to change" bash
> > function. This feels like something that a tool can do... (searches)
> > 
> > Does inotifywait fit the bill here?
> > 
> > https://linux.die.net/man/1/inotifywait
> 
> If inotify works, go for it. Blocking is always better than polling.  It
> might be tricky because the file does not exist yet. Create an empty
> file yourself first, would that work? Probably not if ndctl monitor
> creates a brand new file.
> 
> If inotify does not work, consider adding to test/common this generic
> polling function that lets you poll in bash literally anything:
> 
> https://github.com/pmem/run_qemu/pull/177/files
> 
> It would require making `prev_size` global which does not look like an
> issue to me.
> 
> Before adding it run_qemu, that polling function has been used for years
> and thousands of runs in
> https://github.com/thesofproject/sof-test/blob/main/case-lib/lib.sh
> I mean it's been extremely well tested.
> 
> Even if you don't need polling here, it's unfortunately fairly common to
> have to poll from shell scripts. Why I'm suggesting a test/common
> location.

Thanks. I'm not sure what other polling type work is going on in
the tests, but I'm sure if any, it'll come out of the woodwork
now that we're mentioning it.

I did drop the polling. Not that I thought polling was so horrid,
but mostly because I found something better to 'look' for, so using
'tail -F' to watch the logfile made more sense.



> 
> >> +}
> >> +
> >>  start_monitor()
> >>  {
> >>  	logfile=$(mktemp)
> >>  	$NDCTL monitor -c "$monitor_conf" -l "$logfile" $1 &
> >>  	monitor_pid=$!
> >> -	sync; sleep 3
> >> +	sync
> >> +	for i in {1..30}; do
> >> +		if ps -p "$monitor_pid" > /dev/null; then
> >> +			sleep 0.1
> >> +			break
> >> +		fi
> >> +		sleep 0.1
> >> +	done
> >> +	if ! ps -p "$monitor_pid" > /dev/null; then
> >> +		echo "monitor not ready within 3 seconds"
> >> +		err "$LINENO"
> >> +	fi
> > 
> > This does not make sense to. The shell got the pid from the launching
> > the executable. This is effectively testing that bash command execution
> > works. About the only use I can imagine for this is checking that the
> > monitor did not die early, but that should be determined by other parts
> > of the test.
> 
> Agreed: I'm afraid the only thing this code does is sleeping 0.1s only
> once instead of 3s. Because not sleeping at all worked for you, no
> surprise a single sleep 0.1 works too.
> 
> I suspect the only case where the "for" loop actually iterates is when the
> "monitor" process crashes extremely fast, faster than the
> "sync". Basically racing with its parent to crash before the latter
> notices. That race does not look like a "feature" to me.
> 
> I agree this should be replaced by observing side-effects from the
> monitor. Dunno what. grep something in the ndctl monitor -v output?
> 
> 
> By the way, UNTESTED:
> 

Is this because in your testing the monitor was left dangling and
the test hanging? I suspect the that the cleanup on err was missing,
and I added it my v3 patch.



> --- a/test/monitor.sh
> +++ b/test/monitor.sh
> @@ -67,7 +67,19 @@ check_result()
>  
>  stop_monitor()
>  {
> -	kill $monitor_pid
> +	kill $monitor_pid || die "monitor $monitor_pid was already dead"
> +
> +	local ret=0
> +	timeout 3 wait $monitor_pid || ret=$?
> +	case "$ret") in
> +	124) # timeout
> +		die "monitor $monitor_pid ignored SIGTERM" ;;
> +	0|127) # either success or killed fast
> +		: ;;
> +	*)
> +		die "unexpected monitor exit status:$ret" ;;
> +	esac
> +
>  	rm "$logfile"
>  }
> 
> 
> Something like that...
> 
> This is all assuming the monitor does not have any kind of "remote
> control"; that would be much better.
> 
> I don't know the "monitor", but if it has neither obvious
> side-effects nor any kind of "remote control", then it does a "great"
> job... getting in the way of tests! :-( Maybe the monitor is what should
> be fixed rather than adding shell script "creativity"?
