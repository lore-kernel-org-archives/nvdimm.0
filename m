Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312051C8605
	for <nvdimm@lists.linux.dev>; Fri, 29 Aug 2025 00:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756428484; cv=fail; b=SiM93UZ7Yi6UQBfZ2W4NG0VY4syndA4fLe2HrjVDe3j8/a+ISzxRzGFtn76P81FOIHkK5Nc/pZ8AfF+d/zqh/xK5FJl4mdTyBFla3leB4a5ZeI9IVvUekqjdxr3kmfQ4wD1bUKleL7QtF6irZ1skUULwTFefPaC/MJRdeA67EKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756428484; c=relaxed/simple;
	bh=bkx2jY+VjcxHZU6eTYU6EH+bQWj3r54/vlsBO0c5b/0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=p+q4H6f/tqW6vMryF+WPoFJECnr6jHLQ6tkKKotfTKPG/Q0ZWi7SaEpi3xsBh0OsbF1/YYxaDikTjfok5/M9aiO79YyEVw9eZMYecy0egh+uvuuKPE2/KrOis9ydq9qBC5e2uEmEkVOB/bBo33dFh0G1aYQDEOj4mOwiV8k0nYs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JOuYPP7X; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JOuYPP7X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756428483; x=1787964483;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=bkx2jY+VjcxHZU6eTYU6EH+bQWj3r54/vlsBO0c5b/0=;
  b=JOuYPP7Xe+3xdKxi/twnmIN8BVg6kvMJWV8Z2hWZexRGI0KI2HofIDNb
   j5AdQYb3uVUQl2K8M7IFVcOCcY/7H7CM9SYocGO3XpsqpdeUBrjibEIdd
   j97aGDvjhp1nHnk+CB8AIW1bQmHsxB6BN+JbLDz3k9Yqlivl9M+lQ4a73
   T1XD+LtjKrrwt2l6ee8lEUsnMQ5t4s+Xh3XYlOuQWvrMqymasem1odX2j
   3EqIFq5dzIHELBpfQcdqQHS7aLA/qTTiVFq41yEggYWSKZa2Wea4Z7LN3
   5c/ES5++gJiwFmPzq+irotIkp8e466gTWjiBertNi2PvZW4r3xeOK8RtL
   A==;
X-CSE-ConnectionGUID: cPIWtLWJQpqygdwJGwKjWw==
X-CSE-MsgGUID: MRDiZ/8ARgGMrxt9jDQi6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="58814757"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="58814757"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 17:48:02 -0700
X-CSE-ConnectionGUID: aaBRRL1RTDi/W8ODZtB9mw==
X-CSE-MsgGUID: y8XKMQUQR6W5jINKEXX22g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="175542516"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 17:48:02 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 17:48:01 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 17:48:01 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.70) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 17:48:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uhk4i/BRw8lpJogdL1gsKdCbKl2S3W71DmA8WIlC4DEVKqtUb2fJk90M2yA5BL/dQAMABxmPLb/cA6tt4Mlmqf0f6qzMUXoCFf22ntf39eM3bKeAyKEixlx4fPZxLd5VWdNkxjdxkOp1XGzi7JKkMO5MltMbdoLMCPrDEh3Dl2qckGcrjPbRE64ULs8izn4PQqvUOq7vCv8n9PywBehBspOJ/u5i37p4Ykg44eTFTMLwYm1eP2xs7zYFdJtC1Ni4SVFpowKoFd9qpJutqB5IuO/FxyagK0SifAm49cnDmTHa0LjW+eMTnWQ4CGLNoYBTLYQBAKBxI2FPo9Uopkqijg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZZsBgWIYKLEMjYarkoYQaHOQ3T2JhGEK0E/HwB/evFg=;
 b=jN4SrjONMF3G7uL0SF+rM3FFxZf95H3vWZ4ybmXWlWyCYDjf9swW6a5BbNGlaydt0jetLl+aT4QJvk5v9AhSKkG8Gb1FW4tjlvR2Z4xhYXkXLHivZcbaFcuUSWgjhpaB/8sFA8vT3dMmQP19kUZqKWK9fw5RsN3G1STi226GFCd1oSV6lUXrPNk10gTXdSp+xhPIS3R6+Q9kIi7powpoflWK7eYmjrAb+Cgcr8mBpKH68qQY49tUKeC+sTEbPHeeameH0rzVe6FmpKo9bXDKPI1I2nfKR5jCSc8CsFgFsxexSzJKfQH5g9Y9h3ANYdj86DsbAbD1ytiMugRzg9iN+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by PH0PR11MB5175.namprd11.prod.outlook.com
 (2603:10b6:510:3d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.17; Fri, 29 Aug
 2025 00:47:56 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 00:47:56 +0000
Date: Thu, 28 Aug 2025 19:49:43 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, "Ira
 Weiny" <ira.weiny@intel.com>
CC: Jonathan Corbet <corbet@lwn.net>, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>, "Paul E. McKenney" <paulmck@kernel.org>, "Thomas
 Huth" <thuth@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Borislav Petkov (AMD)" <bp@alien8.de>, "Ard
 Biesheuvel" <ardb@kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] libnvdimm/e820: Add a new parameter to configure
 many regions per e820 entry
Message-ID: <68b0f92761d25_293b329449@iweiny-mobl.notmuch>
References: <20250612114210.2786075-1-mclapinski@google.com>
 <685c67525ba79_2c35442945@iweiny-mobl.notmuch>
 <CAAi7L5cq9OqRGdyZ07rHhsA8GRh2xVXYGh7n20UoTCRfQK03WA@mail.gmail.com>
 <CAAi7L5djEJCVzWWjDMO7WKbXgx6Geba6bku=Gjj2DnBtysQC4A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAi7L5djEJCVzWWjDMO7WKbXgx6Geba6bku=Gjj2DnBtysQC4A@mail.gmail.com>
X-ClientProxiedBy: MW4PR03CA0203.namprd03.prod.outlook.com
 (2603:10b6:303:b8::28) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|PH0PR11MB5175:EE_
X-MS-Office365-Filtering-Correlation-Id: 75a10a77-04db-48f4-8be2-08dde695b1dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YUZSVk5TNVZNK3VRU3JUNkFkZGl6OTV5RzBxRjZJS0FHMER4K01BTFFIWG1v?=
 =?utf-8?B?K1VqRHQrelp5YnFHbGVtRTFaTWoyTzBmQUo0LzdBT3llK0ZqbGE0eGJ5WC9U?=
 =?utf-8?B?aUk5Q1VDZGFMa1NrR253Sy9vTzc4WHlnWG5DcmF3eUlaRzlpcm1oM0xEZFBz?=
 =?utf-8?B?TFRUeHFTOEtkNlFnRll1T1dOenRHcGhCK0VOc1ExZGcxaUhkVElad2ZGLzU0?=
 =?utf-8?B?ZlJuUEhQalFJV1dBZ1NEWEZUcGN5OWRoVS94OHN0NGI1ckdPV3FjeFJoRkl2?=
 =?utf-8?B?Q253U2xqaVRMZGV5R0tYbXRHSXJ5Y2V4MEsyY0JvbEtSZUJwK2drd2lLNU1Y?=
 =?utf-8?B?VlorazIwMXE2QTVFc01OUGJPNDV4MFdlQ0pFNDJEcWtUcDd3dW5LYVhJa1c2?=
 =?utf-8?B?U3BuQjRyc3Q4c2UzeG5hMXQ5MGlTZ1R3aDlkb0FKTEYralNJQzdlOU1KOWVJ?=
 =?utf-8?B?T1UraFd2R3pLYkJmUlUyQlpNMFJXTC9CaGpoMXhFWWJPWmlTdFhSRXdld0Nj?=
 =?utf-8?B?NUtGY1FpNnNJUUxLMDRzY1IvUDlQWm80c0tFcnlFUkd5a2xzcXJGVnB1Qzlv?=
 =?utf-8?B?dGd0bDRVQWpiNStLQVJMSmhaYXZhbi9QcWVmTXp6dFNnU0JQUjFlM2VzdllE?=
 =?utf-8?B?MWRnK2M3bzlIQzdXQzRiUzNCb0JLbGFQUFhGdjh4YXBIODhMZFpjK1FuWkd6?=
 =?utf-8?B?NFh1YzhwYlJLZXVTZ1QwRVVpL0NuaThOUzZick90cWxXN0R0Z3hLYlY3KzRk?=
 =?utf-8?B?UFRLMGdDVjA4em1KeGNFKzR2ZzlLYXREV3VnclpMNEdETHpucVpVTGN6eU9M?=
 =?utf-8?B?Z1hGUXZNRG9JTEhWOHdRcXgvcmpjRllBdTdha0VrYkQ5S0tVdHk5Q0VFc0dD?=
 =?utf-8?B?SnpBYlkvWTc1KzJJN2pwQWUveC8vUWxCM2VmRDA3NjI3OVJYOS95SDYySmJK?=
 =?utf-8?B?WkRrNEtja05GWDVRYTFiMzhyZ3pUSlZlRWRwaEFEYUJGNjBqU1NYVzFNYXc1?=
 =?utf-8?B?N1F3c002bDFubTUwRHR0dnRnekRJdjNZdkxUQXVKUU1RTnB2SUhvSzVGVzA2?=
 =?utf-8?B?QnVhM0RjUHpiYWNrTVl5SUNCM3FaM0p5TEprbWxsMmFPdHYwM3FtOGFvSjhT?=
 =?utf-8?B?Ky9neHo1T3hTeUhKZVNDaCs4TVR4OXI3eG9OQTI1Znc1RE5sYmpOeTRabmxw?=
 =?utf-8?B?WjhDUzdhQ1dDWCs1YnMrSktHVFZRelNnWmlPNFA2UFV1dUQ2VWFtYm4zNmU3?=
 =?utf-8?B?dWtIRStyeENHTS8zS0FuQmRXWTlNNCtYcFJDcVVSbVFvK3RmVE5YMWdIQzA0?=
 =?utf-8?B?RGtSSkgrNDFrZjgzYWhNVFZGYUM2dVpteHh5cVU3UkVWYU5wZFZuUkRSNUgx?=
 =?utf-8?B?ZUxPV1RpbUhWK0V2a1lGUzFDbXQ3T29NK0xET1BIRFVRODBpa3dwMkpTdkRo?=
 =?utf-8?B?Qk9yOU0wYVUzUGk1MGNZU0JKcm5ZaGl2VExPcWp4QnRDcGtxYzJTTGI0S1pK?=
 =?utf-8?B?K0ZUZndSdlRKcU13TU0yYXJGM3VrK0JLWWtsVFd1Qm0xdStKTm92MGc2bGFH?=
 =?utf-8?B?ZFZqclJYWGJOcmxKUWozNEhzQ05DNHZGUUF5U2R6Uk5pRjFoZGg4UHRtdVBG?=
 =?utf-8?B?VzNnTmFXMUt0WVcrSCs3RnhUMzIyMkJzMC9qYXkvaGpURUl2bFZvOHBQMGph?=
 =?utf-8?B?enk4YnlNYUdrNGh1bUhwNVozQjQvTUw2TmIyd09iOC9ZR3ZTdE9ncGtSMjc0?=
 =?utf-8?B?R0pyc2NmT0dPSWlPZFluQmkzYThheGt5Y0xSNTRSWWloeGlNcFZNSXU0cGdp?=
 =?utf-8?B?dVZ1Q2gxeG5xV1gwbVNGSms4TlhJeGltUTM2bEx2K0ZKTEtUUXQwMjVPQUF1?=
 =?utf-8?B?STZVVmJ6UDJYSHNsL0NXS0htbHQ4Yml1QjFKOVBWOEhCR0IzSVkzeDNqYVB0?=
 =?utf-8?Q?bvaAY1hJ+9k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eU9ycGh3R21CdWZzTTB5bGcyNzJENXBGVkRpYkFJVXI2enFaZDFTY2cySTNW?=
 =?utf-8?B?VGw5K1J2cWVSOVNicEJRc3BTQjFQVFJKeEVncmt0VzExOTdQVGcyOExPczRR?=
 =?utf-8?B?TjNnekFBcmNTcDhseis3Q2hqMk9vbGZMVXlUUm15SHBFYlNPbDNJSlgvTEpw?=
 =?utf-8?B?dTVoSnRlZTF3dWNNb0xxWGxjdjNKc0poWW9hNytjOVp0VU9rZUdVUlRiT1BE?=
 =?utf-8?B?RnlsbGhTTHF6WDNsZTZRdndoZ3pqcDJyVlc0TkN0SjQwK20wQ3NUQUtpaWpY?=
 =?utf-8?B?WnpVbnlyT1hPMXE4VDhxUDd6REdoS0dqV2RGckNvQWtWNGs1ZWc2Wk5rbzE4?=
 =?utf-8?B?bHc4V3R2K2pGTVpIUlFoVERxZENNaE0vYzFCdW5wWmdGdnFyUTRxc1p5anUz?=
 =?utf-8?B?QVRaNjFYcTFiMlJva3owVVF0Ti92VkJmRjYrUlpYUlZ0QU9qYUxQYzVadUFI?=
 =?utf-8?B?UkpEZ2hyam9ES05XQ2lJRkRTY3hUTXIwTkxQSFRkYjFUKzZHQ1BlT2t4NWJz?=
 =?utf-8?B?T3BIUG96Y3VZT0pCcnVjKzlnc2Q1ejcrZ3pSRlczY21tbVZ0eGkrdy9DbjJu?=
 =?utf-8?B?ZkxMbU45RC9VNGk3V0hYcjRYZ1RMNnRyc3RYV3QyZUZkVnhaMDZFSC80V1BK?=
 =?utf-8?B?ZE1LNTJlVFZ4VEhLaVE2VkpUQVJMUGZGS1hJOVo2YXJxM0VoNmx5azdlK05v?=
 =?utf-8?B?c2EzMUxBVVJwSHZLbTgyMWtoU2J1TldtQi9zQWdzeEdObHVZL3p1TFVBTG1S?=
 =?utf-8?B?N3RSRjJJbHA2Rk54NE5IWndDeDU2SFM5S0F2SXgycGlzVENWUkhja1VROUhM?=
 =?utf-8?B?UjFpSzgxUFRNMzl1ZklhRlBFY01LdGhzemtRR2w3ZW0vUWNSampOcXpGQ1Iw?=
 =?utf-8?B?L0VkQjNJNGR0WDJYM0ZaUDRSZEVSNCtWYUdMaVJMYlZtS2VXUjJJUnlrYmJx?=
 =?utf-8?B?bkY3NEtLcjBLYmxLV0RnUWpGQjczR2kzQ3lsOUUxenZ2a1g2RkQ3c0Y5eWhv?=
 =?utf-8?B?c3M3NmdISTNnWEZUTU15K3RzL01WUFMxb1lVdWRiUDZjVk41MDhFUld2c3BL?=
 =?utf-8?B?bUs5T2NjYVdNbG9zL3phd3FsLzNPbTJKSmNqRUhaTUNva29acnBKZDlTZ0Rr?=
 =?utf-8?B?czFmSzZlTUtnVTdMSW9sWS85eWIyOU5iYkd5eFVhOFErWFFjdTNPa0JEZGNC?=
 =?utf-8?B?eFBlaU1rRXptWFREdlY3VEpuWXphMWhqOGpsYWgzZUdKK2dNTTJvQ0VxbnJn?=
 =?utf-8?B?V2Z5TjZyTWk4RGVkeTM2TWowNUJXMGt1R284Z05sNm9jcWRjSUg2ai9sNVc0?=
 =?utf-8?B?d0VxbmN4NWNTQmxsRy92cld0NEwya2NOTWVmbDl6ZUhiT0RHbkhXSUJHVzNG?=
 =?utf-8?B?bmZiV291M0F4cGV5QUxaeitCTFJuaU85NFNER3R0QzZnUmVLRmJkTXR1Mklu?=
 =?utf-8?B?T3E5THY3UmpaWExlYVBaTjNlc2xFcm9yVGt4SzFYRzlOeGRFOVFzMm1UVUpK?=
 =?utf-8?B?MS83R0JBQTFlTmZJNzFTdDlUK3lKbkVEY3E4eHIzdHEwNXhyMW5LVWtLNjVS?=
 =?utf-8?B?Z1luUmpsRDc5UmZGZlJNL3RDRlVRNUc4UkVCRFpZU2hRSUNDZ1BRWko1TzNW?=
 =?utf-8?B?WTA0d3BCaG16Ulc2RTJVR1RhYlNYeWJ4Q0RtLzN3ZDM5WUhWYW5WSFpubyt2?=
 =?utf-8?B?YkVNWGoybnNlSU5Rc296OFhSVlArNHlDSVh2bWQ4OWNqUlM4dnMvQTdyN3ZW?=
 =?utf-8?B?NXBXU2N0R0JTNktMSjFWRVZoZk8xbDRFMGxhR3BtL3Arb0Rha0tsREdMS0xJ?=
 =?utf-8?B?VS9saGtiVHRpMUVqUjVTOHMyZ25uUVpualZYKzIvM29KdnBCdm43R2haZ2Yv?=
 =?utf-8?B?Y1hTZUJvcXNlVU1XYXZuZWhBVlkyYkNCUnlVd09zY1djWE14RDdVS0xOemJ5?=
 =?utf-8?B?eHJVbmg3cDd4QnpWOFEzQlZkaFJERVVSOWsxczIzNEl0MFY4RkNydURDTUl5?=
 =?utf-8?B?NDFXd1oyZlE4cDZ2TkVWeVBESWMvWUsyajg0RCtXdTlkQmk3MURsNTlwdEQr?=
 =?utf-8?B?clhucldGUEVUUnZNTXVGU2Y5WjVyZ1F6VW51dHZSdzY2S2ZZRExxcElnRWs1?=
 =?utf-8?B?b1RwOUdTdnpFTUVuSFJpZXB3ZlJEQmptZk9jbHZKbWpxaFlYUkRDdmFTWUJT?=
 =?utf-8?B?WHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a10a77-04db-48f4-8be2-08dde695b1dd
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 00:47:56.7546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ShS0IITNlygB/r5EMqUfZJz1oI0NhTKyesmCGYd+oZc8oNpfmol5kMc9ZKdPighwhUorBh0e6jkbwUtqv+P2Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5175
X-OriginatorOrg: intel.com

Michał Cłapiński wrote:
> On Tue, Jul 1, 2025 at 2:05 PM Michał Cłapiński <mclapinski@google.com> wrote:
> >
> > On Wed, Jun 25, 2025 at 11:16 PM Ira Weiny <ira.weiny@intel.com> wrote:
> > >
> > > Michal Clapinski wrote:
> > > > This includes:
> > > > 1. Splitting one e820 entry into many regions.
> > > > 2. Conversion to devdax during boot.
> > > >
> > > > This change is needed for the hypervisor live update. VMs' memory will
> > > > be backed by those emulated pmem devices. To support various VM shapes
> > > > I want to create devdax devices at 1GB granularity similar to hugetlb.
> > > > Also detecting those devices as devdax during boot speeds up the whole
> > > > process. Conversion in userspace would be much slower which is
> > > > unacceptable while trying to minimize
> > >
> > > Did you explore the NFIT injection strategy which Dan suggested?[1]
> > >
> > > [1] https://lore.kernel.org/all/6807f0bfbe589_71fe2944d@dwillia2-xfh.jf.intel.com.notmuch/
> > >
> > > If so why did it not work?
> >
> > I'm new to all this so I might be off on some/all of the things.
> >
> > My issues with NFIT:
> > 1. I can either go with custom bios or acpi nfit injection. Custom
> > bios sounds rather aggressive to me and I'd prefer to avoid this. The
> > NFIT injection is done via initramfs, right? If a system doesn't use
> > initramfs at the moment, that would introduce another step in the boot
> > process. One of the requirements of the hypervisor live update project
> > is that the boot process has to be blazing fast and I'm worried
> > introducing initramfs would go against this requirement.
> > 2. If I were to create an NFIT, it would have to contain thousands of
> > entries. That would have to be parsed on every boot. Again, I'm
> > worried about the performance.
> >
> > Do you think an NFIT solution could be as fast as the simple command
> > line solution?
> 
> Hello,
> just a follow up email. I'd like to receive some feedback on this.

Apologies.  I'm not keen on adding kernel parameters so I'm curious what
you think about Mike's new driver?[1]

[1] https://lore.kernel.org/all/68b0f8a31a2b8_293b3294ae@iweiny-mobl.notmuch/

Ira
