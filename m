Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792986167;
	b=vdEvaJLOP6jbNCCudeywL5rWhBQ9n2rNDIPjKik47rdEfYgbFCSBooFI6FtKNkKnuwL3
	 Q75uHN8nKFkDUeR2yH20nt4GyD+FQDs6vTzeuYEiO/0Zo+TzzSION2BwrBHc8scXIAwyG
	 ltxCjI6kAKOa5Tup8abvWoRPYWxhr9gbRFLb1+i528vS+L+iSxCfscJmL6ZrZq7KHVoRS
	 PIDFlM1KGl6zDSJVRdwuIGEWPgE/L5FklqUN/yyadTECHWQhyCw3zFdJ0jolrYIhKYMKD
	 YvZqZGq0QJpamCEgCEW2ZLMcjBpHGrAi8L8SnP2vvV8ep1GUyk1Ag8f/OLLKy6apREg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792986167;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 Content-Type:Content-Disposition:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=0DSc06Tvrs1REh/+hfnS2Kl87LtwK1fGP6QP9k8T3dk=;
	b=e85IyIDH7A4QApDhK4rydXCDxE7WFaifv6zwwO/qUrwFWB4Xj3ZY6YdZpjLyXoPbm+XJ
	 AiLXvAc/mov1514QQNFJ+qVbNvQ5iMrQ7KyHHGIxjzOfwVrA4qsR+MCfYspnSfULAqfTR
	 wLbFLgVwWZvHFVhMMeab2R9jfwabcwmErc/REN41yjhMvt/ECzoRvUoS92vtyyfKYcNuh
	 2bTg5vb3SkqzWJztp95LSU3Qsujo85N6+vNecbtV23YU0uvSm1pucBHi08eTsher5zZff
	 csSvH8MvJ/Peu9tyOzlw4yHY8AycEGzyB7AMW1fwKjWCRkSOQynBQBJVse9frHJSqYw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=AzGIjYXh;
	arc=fail smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA29606A31B
	for <nvdimm@lists.linux.dev>; Mon, 26 Oct 2026 03:42:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CA29606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=AzGIjYXh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792986165; x=1824522165;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=XmbFLNvNu6w2K0TrV3YpsXKWQY1eD+bXtFJ6vGK79rM=;
  b=AzGIjYXhaZMPXMaSA+1LL3pcL3s9ArQj0OFabdzMud6Y5cqh+EEVwIle
   C9aDDkUkLhUX/nYOkl7oHhkDhhkhoik/Kd8q5J7cSSda11s7dpauqSotA
   EzkaPAc3JEYZCvdMFvlKHKs/xSpx5N+toS1nsCbWM6D2/a/z5LVmMQCzH
   tHWsaEdVvLzl5Lx2QLT+IMgG3g7qAR8E7+IvIVp22ncDyyvnTUGXAG5Pz
   ylNi1LuO3y71dysjjcvtPNJbAzSqzsOR3ppJVlbecIk/FnsD2/RU5dAga
   VNjeYCqviFTafP9C0mv2ec/34VqPJ8Da1cvxZAF4JFZarqO8PvA4DA0lg
   g==;
X-CSE-ConnectionGUID: Czv/CnniRMqIvY5QEUo9Xg==
X-CSE-MsgGUID: gu1YvxNXQ0eQuBekm3mLmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11946"; a="1656958"
X-IronPort-AV: E=Sophos;i="6.27,178,1787036400"; 
   d="scan'208";a="1656958"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2026 20:42:44 -0700
X-CSE-ConnectionGUID: DxA5EruVR7SzTn4hGPrZBQ==
X-CSE-MsgGUID: Ua5usMe6QFKeQFnNN2cvUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,178,1787036400"; 
   d="scan'208";a="4211570"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2026 20:42:44 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 25 Oct 2026 20:42:43 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Sun, 25 Oct 2026 20:42:43 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.47) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 25 Oct 2026 20:42:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kj0SzohT1hdvvvbNW/8dckwcxdNBi+efY4mUP7+BCqZ8thJJvHGubplX4akTCB6Xk+oKZyS4dbb9uYKiwzaG36HAa3WOm1rEFuHzcBt42rnSPjzorKMUabT4PKNGKluiOmh65cQekf61I/9hcZ4zkM8lkiTcecqZnpZmgrENI+m7PKFtkLYdVhO1GpW4lwWFu2KufvO8oeu634q652Zo9INV1bkyR3iNm6nhu6eDxWzwaelP/I5NHRIA6yvPkVKdtjHnsvAGtdKKpTbJSj+oBUTgMSknPiWyRd70le8v4UzLMM/4rlJq8A+HERpLjXmJkmm9YjCnC1LEOvn1hMYbSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0DSc06Tvrs1REh/+hfnS2Kl87LtwK1fGP6QP9k8T3dk=;
 b=w6yoXlwnyhRlU4Rh1f7I+d+CmYmMpRB1h93/eRbYmcBawZp065l5WHYIXiyVl9s2qnRZ6a5GwTlEM3H/usOCDSRVhPwyjKtFaj9uTLn/+0I7cDzb0tARMEBY9WoYbO+zWRG6VYd8EAuGRbrdYMqbqAC/yLU2U/O27tolitiTsyVw6t36LrKZO5lg+5gVwYjzTYXMbtJKmOx8SfGU7P2ntLaazjnVyBYCucs3KJJXrnCQG7vpdsv2/Xs2MjraKeqvywa54LeGFl3mkRTXDH5lOhWYNseUNjjx+Ly508t+7Gb7BHIKH42ay+hkzexmNzOxaaT3V2cHM9SkSFfA4pdtSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CO1PR11MB5011.namprd11.prod.outlook.com (2603:10b6:303:6d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 03:42:11 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 03:42:11 +0000
Date: Sun, 25 Oct 2026 20:42:01 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <dave.jiang@intel.com>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <vishal.l.verma@intel.com>
Subject: [GIT PULL] NVDIMM and DAX for 7.4
Message-ID: <at7MCT6uhsn0B4ER@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: MW4PR04CA0261.namprd04.prod.outlook.com
 (2603:10b6:303:88::26) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CO1PR11MB5011:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fb40ba8-1cf8-4aec-8a07-08df33131e37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|261021123027099003|11063799006|56012099006|261009223027099003|261022075727099003|261022105027099003|261021121427099003|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: Q08hfdI6YW7AJjcaiYdbhAHKSB+m3oLnfPm1AGEDMpPkIwZUp9I8kvzmcF7WjxP2TSCUdZ7NPMcNJfoc5XM4IisHzez7A4hsQyxwF66cLdYzZ6YAIQPGyz+nuCOdmK+0YNfyUx1XDskJXZelmBwQKsivtP/uXtenNGLGPEFZ9GqyZtJjNjB4UPjjwRcoly8Cntrz9yH5CYaFWp1/E1zy7UB84p7FIIgfWrec+va6g9e618VNm+W7G+cCVP8YrdJyA1x9M5wdjKSrecizHIxyYDsVt7gNjo+EAYlNVnFQJEOVYKMT1JCO1ouK6Gg86IYWGIrVUeE0+jFSRkBp1K7Aw0PHlpoLQYurBlzW2qP3du52trqifZoPaR1dHz7GWz6Tn2Vfh8W4o4vWvaTmv9WjTfHe/aBR8l/BzZq6IXfa1oQfqMP2h5t/xCfzrdXtnsJE7iL4FKMtGO4PQtfwsvuhcsRXh02HnpssbnAK18Fc+XFkirbY6WJkKJBNMLill7L9WMcz8tjLeehHu1onxZ9LXBctSyKmjj76njhQaYtOoOQer5qXDpn7cCTsgYt+OhsVcLlFVx/o7v1G+KCn+0SOOsV1xof6dbLuHK6fMcTC5lrSLB0fbNCIU50YnSgxJsWhQ/wpE7YrW5NqwHRGfoWuJZygdKcL2I5rGkdWITvdt0E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(261021123027099003)(11063799006)(56012099006)(261009223027099003)(261022075727099003)(261022105027099003)(261021121427099003)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eLjdIGYf0Nnv8Snp53BaBAR+YG+NHtepqjawWIzcpWEyi9KEVz6I0zucjN7p?=
 =?us-ascii?Q?z7iCiyf9npl7EPPMmytzGwpUrYIYFsAdCxcaQxG1mXzkIFQstcgE11NVOSRM?=
 =?us-ascii?Q?ksLB8m5Da+k36Nq/Q90fZIZXT9+V1seNX76Rxp76mx03h8BTkmIUzJveMTw1?=
 =?us-ascii?Q?LAOfMeDFE+wELwcxAOFqLmjzQ6IhyVG8JM32/niVBC9uC+lcfOvY0XmhfVOt?=
 =?us-ascii?Q?NJK0GsjWOedx4RaH2Y32Fs9Lu1wYOlC07C8QZqKJihR4ulb2Deuqy2JoHoVz?=
 =?us-ascii?Q?WnmD4QsRFXNCgWGIgSWRQbXz2pJCUmwWpZ1E1okwlpjZhDr9R/95lNJYpVCy?=
 =?us-ascii?Q?epaJzKgYJf8OeJwzgd3hDUVzCyG4FqVhILGm3KwOPSm7LohbnmaqcWQ7nefu?=
 =?us-ascii?Q?WANDDfQspY1o1qCruXvXEd7hh6a2ax3SQ0Aca7nmBDeGC+EAIuPFnEhwwTIo?=
 =?us-ascii?Q?3OTOEYqnMs8gRAhMtRC1ZTY258ObnONZQhrfNCmgIh9W2I5aDXrVckedCXAb?=
 =?us-ascii?Q?+9YB1o72RRR3XVu6jI6q/tjhIhNgbzqggY+LzZ6WZgslDSDjXneawgH77U15?=
 =?us-ascii?Q?e6OOMPb/mEw4TNexa7RSOLSNLmPlWL8gLVe6526yFa4CfR88tQVMP4RR2ndO?=
 =?us-ascii?Q?GwYIJIADbB/C/EkVtVNkpjY+BJ4LtcaPu3SJbql/66q+DKBh3sVwvgi2DQbk?=
 =?us-ascii?Q?F/zGGIjVPXvu5BKDEvmPm6mVGZenUzBSUfpqzh9918LiNzplGQsWHlznTKtw?=
 =?us-ascii?Q?oWDq5qzfK3/XxZ6FtZLlOBj5FD8DkfJIFfzhykvItEfxhk47kxddKql5EZhk?=
 =?us-ascii?Q?PPDilobXdU3Q5JExegudG6wDL7l9YtIHPVSXEqtqNwATIwEI8XDJT0tOl3iU?=
 =?us-ascii?Q?85HjZn32vDzZGUHlodGVGeh9xbPiKDRbzhGTgJS/R2qbNDMLoUIKcXSJcrH2?=
 =?us-ascii?Q?pKwjpUol0uLSKRyTiURit4yRV++q+m87ZpyRKEW0zYdBriBaWat2nOpB2Ube?=
 =?us-ascii?Q?/E8ALu1HqJCo0sds5tfU4bRKLwWggDv5BpHuYJ+w6pmDM0p6MGTXM3NZsQrX?=
 =?us-ascii?Q?+ATRC5xd7M4bij+oAytHeMsaMR4w93asL/IxSFRrZWg0v5Jib8x/WQsCNHg4?=
 =?us-ascii?Q?qezIicyZ3VtiRvjHGixNf3S/Rkn0NogMLBGnzbpHLT1tt8EaTFBmXvCa09Ui?=
 =?us-ascii?Q?rZE0AmHJWo2UpS/4Iy7UDDatokYs76sRb66I+jrF5CqlM4z27KGjJZzSbVPL?=
 =?us-ascii?Q?O3V0tKZ/sFPMHM2s0vPterGRnDJurIzyTVqy40qRdkmV12RMWavSJHkXlRfY?=
 =?us-ascii?Q?V6Rq4PfnGz2nmdSKDS9e1ky8p9AI4BosQYydUz9hGk84686D6AeWJQrPFfHE?=
 =?us-ascii?Q?04OhtbqyIXHnTDH61V19CmmmvvihzQZvfSAS02Y7w7uW5qNyltXSJUUJJ5pg?=
 =?us-ascii?Q?wttvXnzhdWx23+WrJynC+Is8kEMaQ/HSrHZdbWJPi50Rhsw0zMdglAB1DTSK?=
 =?us-ascii?Q?ANA2ZXCSwvsW7flpUvaO9k9wmOHTtrx1VsTXbz2vES+qw6N62Zq/EsTNbPSC?=
 =?us-ascii?Q?mdit22X1L8zjzCcGjoGoY7umzPnROV/QnUYM4wHI/AbwvzpawQrFtwkvZrBA?=
 =?us-ascii?Q?y3wo+o4/iZgchF78weF+fiEv/D2QX4QA9dcdAztkY2qeAzQXmFQlKjFqc6gk?=
 =?us-ascii?Q?IyF+7AK0+TgiDWgHz0pjJDziDgZ75fsj3z8yll6f4MEjIt0Os8XXmWbRF8An?=
 =?us-ascii?Q?7Fxc+KboF6pE6J/Fw3NpMJHWzJVKYQs=3D?=
X-Exchange-RoutingPolicyChecked: CP77TVVjiJTWodiiVt5mAnqPgc5qSt7oHkczNffeMt8W1bizrajceeIYJ1KVVtGCP2gRehw00+008z7hJheE/QOVLL/A1JeuJJOiQi4XzBpV8fqfCak3vpoCq9vwm+qao8aoZr7tmqv2xLq4SzAYpdo4KknXOG1DwnXZVPO3KVcXiYomt1HONKobpj2+uboAFqdG69vfViDV+4zuO093ou6NBXatgvRbiXxkpETwhLjwyD7iLw5C+AblMkFeql0LmkmWU4Hnfk88pCyc1D3NcFoyPQrJY4c5HbHq3ruQS4FKyRKmqIh113kyXVIThANvrzV0MIoVN6QpGvDGC2GqGA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fb40ba8-1cf8-4aec-8a07-08df33131e37
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 03:42:11.6202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: owK3eH7Cnq0rSX2wb87tQOsfYnRtC/hDcz5FKhyB5EIg8WGWncaiuRR6rVr0Azo3pcEHnfLqzn++026hy9+yWqqt+HGnm5JvPT0Yakw30v4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5011
X-OriginatorOrg: intel.com

Hi Linus,

Please pull to receive NVDIMM and DAX changes for 7.4:

    git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.4

This is a small set of fixes: error handling corrections in the DAX
core and bus code, a fix to the DAX file range comparison helpers, and
two libnvdimm/pmem fixes for error and probe failure paths.

These have all appeared in -next for at least 6 days.

Thank-you,
Alison

---

The following changes since commit 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e:

  Linux 7.3-rc5 (2026-09-27 13:55:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.4

for you to fetch changes up to 9b036546a02c6c9a5133f9c1e93503896595c6ba:

  dax: fix wrong error code returned from dax_dedupe_file_range_compare() (2026-10-19 09:43:01 -0700)

----------------------------------------------------------------
NVDIMM and DAX for v7.4

DAX fixes:
dax: fix wrong error code returned from dax_dedupe_file_range_compare()
dax: fix dax_range_compare_iter() to use correct size and address offset
dax: Return errors from dax_core_init()
dax/bus: Return errors for invalid mapping targets

NVDIMM fixes:
libnvdimm: Handle negative return from nvdimm_clear_poison() in nsio_rw_bytes()
nvdimm/pmem: Release gendisk on probe failure

----------------------------------------------------------------
Hemanth Selam (1):
      nvdimm/pmem: Release gendisk on probe failure

Jianyun Gao (3):
      dax: Return errors from dax_core_init()
      dax: fix dax_range_compare_iter() to use correct size and address offset
      dax: fix wrong error code returned from dax_dedupe_file_range_compare()

Muchun Song (1):
      dax/bus: Return errors for invalid mapping targets

Serhat Kumral (1):
      libnvdimm: Handle negative return from nvdimm_clear_poison() in nsio_rw_bytes()

 drivers/dax/bus.c      |  8 ++++++--
 drivers/dax/super.c    |  2 +-
 drivers/nvdimm/claim.c |  2 +-
 drivers/nvdimm/pmem.c  |  6 ++++--
 fs/dax.c               | 14 ++++++++------
 5 files changed, 20 insertions(+), 12 deletions(-)
