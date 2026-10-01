Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE21836E466
	for <nvdimm@lists.linux.dev>; Thu,  1 Oct 2026 05:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790833266; cv=fail; b=JeaLPSrV9ODEtFcfiytxu6nCQH+rU3BZ2XkWF9RleaDc8wVTg1q1mbh2Bxa0oyOLJVhTcENaywvGjF7yB0PfJsu80RbT/ci5/o4VvoigG0nHVZ3ptVyE3t5xdZCxVlJzMqRKiM5kAtJNOtZtzD1G4Vhw5ClRenEvhroILPzHpmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790833266; c=relaxed/simple;
	bh=3m2GpNQ7lPUXAWewtvhWLjmjaT08c1k8QugMOXezBbc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uVmB5kpm5jEOh63NeXtBQTJD1KcNwo/mj1DfpfE5m2EWtn/OYaE9Jdf+ZS3g3aByFXextsW3OVIsLgbLI4NRpPIv32B+kibeiN4waDMjppPl+sqNXIdxzlryoM4+T6x1g/xlNFwmvXDKODQ1s+4m2znqZBTXRxeUM5DcwpvD2iU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m/JOpQKI; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m/JOpQKI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790833263; x=1822369263;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3m2GpNQ7lPUXAWewtvhWLjmjaT08c1k8QugMOXezBbc=;
  b=m/JOpQKIwVTalVVYvMKNRzpogGAJOk/dL3qvk9JmVhD4AQ3Up83c9F4S
   qVqdXnoNhJ4Y0ZqIhquxV16R5knx6RaCGTtmP+s75qrBqC17CD7kwseEs
   nJzh59qdMA6r4n3Z4BjeBDOb+uct2mptJHE7Y4uv7b+TmRNRE+91SH9PJ
   rQap/Sfg+dSPxKNMsifHZGucJicLwYQoqheGTzaXkynme6MnNdREn+1Yv
   lERnbPqips3nljbtSpL/9w+2oQJr0iS7JU2KB7Xj/fSqJfACt8KNps2ws
   V9dtas7HrNYa2+psUH2Ee9s9o4dLBcRf+CZKlP6fDXVltYP6Z73xs7Igo
   g==;
X-CSE-ConnectionGUID: x3YM0qIaQTOB67eJR4DqFQ==
X-CSE-MsgGUID: yvEzx9H3QUOWphpxZDci4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="90349436"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="90349436"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 22:41:02 -0700
X-CSE-ConnectionGUID: uU/O1kG0SQuV83wX5KZqwg==
X-CSE-MsgGUID: edS0aAuNStm08iwb4zodLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="279686074"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 22:41:02 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 22:41:01 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 30 Sep 2026 22:41:01 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.44) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 22:40:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s3ncUIEy+Bsg8liFF/T6CKL1B/9hhXqZQqlLFhhk2W9LfBHOnCumbyex2qdMFry43mn0O5q2wYLMiDh/LZqGV43kLAwwwGQ+tTVej1R0bmt28P71lOrXlmI5LOPS1MvlBCUzBMeacCcgm880dvriNrEtE/orb+X0diAXTSFcxdYhko+EXTVH47RthxerKbaEC/mvuGG+Ja/QsRJJL85/mT7sm79l42S5NR2A1Vx1dMA6soac8NwwQVEBgYUkbFOiKpGiu6HeXuvFvQYduqDB3/esscy1c6zgtqZCW8X0K/t2EY0ZmGhB1iTvV/k5KN5rst2j/HefArcFuqYZa5lTtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Qvy1A2vzRfRduNjjivSAsrfzKc+XiNE9UR0+NaLGnQ=;
 b=seFwR6aY+Liixq8H7rOHVvBFL1dZ6GFbsWgPQr0RW9k/2WHe2KBRiBLcls+ZcSe8jUYcCiHpE4n9jR/8OJQdAUenVmxte0k5zkI3gYeU1Tq0Kx1JlSoANHbOMG9A/eUMRwOder3bZ7aISYVYLhHeormdWSv0jIZ/i0O9sshkTblUELZy/IrEs9or75XmAhwH0uy8MgNdDbz2/9Xl1xQw5do7ecWDA34JGAUxENGE35RuFimmiSchQhYUhwtgrrrMz/al8JwFo+pCHWSg5eYy5ZjEGfIDqGYAn3FY9do91w1/uyu9P5O4ex/nRmWaOya0MwFJBLNKn+Za+LhiKeuYCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS0PR11MB8207.namprd11.prod.outlook.com (2603:10b6:8:164::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Thu, 1 Oct
 2026 05:40:52 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0472.015; Thu, 1 Oct 2026
 05:40:52 +0000
Date: Wed, 30 Sep 2026 22:40:47 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Kees Cook <kees@kernel.org>
CC: Bill Wendling <morbo@google.com>, <nvdimm@lists.linux.dev>, Dave Jiang
	<dave.jiang@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Guangshuo Li <lgs201920130244@gmail.com>, Ira Weiny <iweiny@kernel.org>, Uwe
 =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Steven Rostedt <rostedt@goodmis.org>,
	<nikitash.mariiaw@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>
Subject: Re: [PATCH v3 10/11] nvdimm: ndtest: Return the string length from
 flags_show()
Message-ID: <ar3yXzo-0k0_BuCD@aschofie-mobl2.lan>
References: <20260930235231.out.387-kees@kernel.org>
 <20260930235247.157921-10-kees@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260930235247.157921-10-kees@kernel.org>
X-ClientProxiedBy: BY3PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:254::14) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS0PR11MB8207:EE_
X-MS-Office365-Filtering-Correlation-Id: aefc1754-869c-42a5-e894-08df1f7e8e30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|11063799006|4143699003|10067099003|3023799007|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: b5Clpkqn3fXalUtLoHpUyD4jEjBpPL2mISwmd6oilLQaA4w7i3jV+EjZDxi5xu6ZKtwnxWKrB9NjnK+RZn0orUZzR4kdeVux7XaqVgWFTqp5l7rEbh1akd1LwGDfm7Cp57Lx0hboeQkhMxEMwkNBuyyf1dnHuUMLQy8MsBX34BB8mdabgL91Q6n/Cgq26zqgdaWmqZFsyWl9stKOTuhdpsJoUyHrR29bfH6p1U6+Vg5DdzyKxbDbLLZptBkfJTC8Ln7OaYC/p0fJ+7SP8w+3Wnk8GO/M97oMojclkKluJ4qkpKyRgy2r8/NJ3Vn4QHGvzKqYPyvOdefLsS/+q7hSYocnvxZfdm4XaKbBsMsl2T5SvhX59G7A2iyoMCigj0P/X9TR9fIA3NzKc/CGNPp7M7kHcv/+NL1pXUAMgd8N0Y/W0egDynVYhMRHubOd/mGE8kOqtJzbHaYigJxZNAARt5tg0G48vqdw3Gx3MF1fGn3EsSq9RwyWg02xvuFZe2vCPSzFiqM7l/Zla6sIlDV0rj0wwic7//gS3NKdKQZ6iiUt8preBKBfiMJXTD6MQpYNiSIOrspmSjAkt1WyZnICufXL3S0FCWoNInYbN06/O2h0iyB/iFfaVN9UdcSt+Af9WVZtKdkZzLGkv+l0fs80ionPXURl9DzD/2E+N4kiTA0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(11063799006)(4143699003)(10067099003)(3023799007)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sIPyjB7weKR4nfFrJCLKSzxj3tvAB2dDbb9O4s/v4cWIibKlIfH5WMuxYBpC?=
 =?us-ascii?Q?AkYDnRlGZheyQ6VosOlIEIJ36gUDHwoSlv+GyyEqMRiChbfh8u4gPlud9lxm?=
 =?us-ascii?Q?hnPff8lt0eKQt3QFdjSz3JUxtGaA+tDHnzwbYAEqtVjqkDMTKzhDD2/4LDN1?=
 =?us-ascii?Q?B7k3WFxleAqtMcgEOXyjKZUuqPbaYnzlJCWPfe0qennW3BZVoVXHZ00yvEgg?=
 =?us-ascii?Q?RFBZgX7AyZl7ahlCnAACmideG8BXhfewamZP9b2+2N1mcC5JQwEq5BB9I4m7?=
 =?us-ascii?Q?dtIPRheAh011xbKa7O5pEkOa3cNYB3B86dHQrmDSCc5AyukJATUTfLwLRMxV?=
 =?us-ascii?Q?uCEk0SPZGA4sxnyoxaCDmMLlBgMh1rXpJS2RGtoJRL6nQ/IFYBauUHoM68WJ?=
 =?us-ascii?Q?VvdWw4QoULEqKeNXCebAQOuDb99qRXFoyTeLx3skGsrh0dpN1c0j7nkY9XjB?=
 =?us-ascii?Q?Sp++NqBpMlRBtPNqRkUpd9cdxplgVWJuXnWEiPnmRbnsmQBWPl+1xNrmT9uv?=
 =?us-ascii?Q?8/2z/799EtvOSSmVaBZUsw05SNB1B0yv+TCNcTg8N8WbcIiJHusvLEtaUiNP?=
 =?us-ascii?Q?qMPlTRJcxcPHqzPKKK9aUZPNqx6JbRRsjQwlNRnuDu6DizgrntMmhC7+7/P6?=
 =?us-ascii?Q?DLLroghhX6IrLifIzR6KephCMBjM1WpBMOJ359D/L/lxJpojj2WSyVWHsiaC?=
 =?us-ascii?Q?Zm5X9mkvcqI54RkHFLxg/cUrf1b0R+FEkdRxAv/3klTzWRI7ZKlnucgh2x4a?=
 =?us-ascii?Q?TWZP1UQAgrQVlJLj+wxol1IPs/ayBcQbg10PhKA8Wo6S4ufEbZzG2TpgEtZY?=
 =?us-ascii?Q?dT/vcT8Ylmra2VN48Q/2XF4EmOqS5z3yqZHenS3AxmRNPVJSw/3CP79xwh98?=
 =?us-ascii?Q?bEB6UBYaQS7Dgc9OtkzmpwsqGRa/o6yDnsP93FHoosVrbxSzAQaCzuaNkhZQ?=
 =?us-ascii?Q?b15++/k93tZKPNh27NAq5cTPBRcHQxJ/W9ff9h8DIA5ZgOASQn6CmVPIcEA0?=
 =?us-ascii?Q?wIEuG2TpuCSvZcgdgxRL6ZmA/pVw5ZQDEt9pogsRaB7xUxKEIzwbSeFxKFxn?=
 =?us-ascii?Q?lT7Lea3JERh/lzDAYJhNS3/hLTmOvco4wCpf3WH4/wdYV8h2t84/WAllWAEZ?=
 =?us-ascii?Q?bKqtp7Xd+4V+uWb/0wT36ZJp1nbynI4RhLGHSo5qRvksVK4N2so5RWuKbwa/?=
 =?us-ascii?Q?Pk4Kny3zaJZ9LkF6VY2VzgZUz0UY6r7+EVQQaU+qnAj3McP3ujK+CERBku2g?=
 =?us-ascii?Q?VjrMY08j94LWqtw+8OV7Z5n6IgLF4Z38X/OuClSjHlxJEIqkP1L/zUT8DFGB?=
 =?us-ascii?Q?JEH1Q5WHGWcK2PQoe638mOOXvTet/OZ1Ntwezg3e4OKkKxXMN7aKCjOTidGA?=
 =?us-ascii?Q?7MlzPu2CepejMv+6F9Y2oLwSxXjTQTlTSOCpeote8vCx14+eRD2u74FlS4mu?=
 =?us-ascii?Q?wTgXrUx3Ek3zR1Ildbe+dCrpSLR7zal7FILZlEsWCCHRKEyTyAwpLvXc16n9?=
 =?us-ascii?Q?6+LXx3oQK5mU6KbcE7iMS+SCCh7vcPPBDZbW1RxiDyCGStWaFgL6f/3DA3vt?=
 =?us-ascii?Q?lRxbnbWhA7en6fGvu5p0ClWWnvwS9gkAnolQnz5SxTW9iF2lUqPKuLusgveb?=
 =?us-ascii?Q?f5ExJK0BYVTVReVs6b1cYLeiXV3PPv9jLsM69A1zQWw/2pHmbqSEkg2Gwovz?=
 =?us-ascii?Q?PjhR67qZb79SqgKjcPIl93qN8ayDOjEHhYVzPJireVQQNitVCsw7sBBrh/VA?=
 =?us-ascii?Q?HyvFufSkXjYz5+p+xz9Ti64LMbqXxnI=3D?=
X-Exchange-RoutingPolicyChecked: Bs4CYYfdS9XRHfWVaSMtBBW6j5Z4WIXubC1GabnEeV8dqRZ1ha/iBscKjgrnY3nyioiPd4uoi97ORH8fSlGdvr0JzgdVS2uuUsVghFql6oxsg1qqqI2cfcBZKDcNEJAOI+UiMc/rEQmgc6ZJaExn/UMsYPlFXx5C2Tq8kbqAWncm9zC/ISPwEYx0k4cST44bcz7DzrjR2LrhnyDfDC+/5FcRGp1zW9JtEdu2tiOEzRFXMFoDMJZU1VTkmy0SNJKtqnCSIM3aP5FlfZPPJ4MWU/3j3c7pMWxjc79e+jIb71hYc1KjJQmMDoCAEEevGIGU+/AzEc9U04o0jBjyXht3UA==
X-MS-Exchange-CrossTenant-Network-Message-Id: aefc1754-869c-42a5-e894-08df1f7e8e30
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 05:40:52.4108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bxozCcJOA+1bnV62pMq9J+wuTxaz6ESptmfqrbndW1tA9I6kLdX3RCA7vo1Yfnf/FXlB9xrAM/W5Tb+JPRXPft9ssqDQnX7HJ/JZGkS/0eE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8207
X-OriginatorOrg: intel.com

On Wed, Sep 30, 2026 at 04:52:38PM -0700, Kees Cook wrote:
> flags_show() build their output with a seq_buf and return seq_buf_used(),
> which may include the trailing NUL byte when the seq_buf has
> overflowed. Use seq_buf_strlen() instead.
> 
> The flag names are far shorter than the PAGE_SIZE buffer sysfs
> provides, so this cannot overflow today.
> 
> Build tested ARCH=x86_64 with GCC 16.2.0, built out of tree with
> make M=tools/testing/nvdimm:
> tools/testing/nvdimm/test/ndtest.o
> 
> Assisted-by: LLM
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Kees Cook <kees@kernel.org>


Hi Kees,

Should I include this one in a 7.4 PR for nvdimm or is someone else
merging the entire series?

-- Alison



> ---
>  tools/testing/nvdimm/test/ndtest.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> index 2051ad5d4882..f097f2992966 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -693,7 +693,7 @@ static ssize_t flags_show(struct device *dev,
>  	if (seq_buf_used(&s))
>  		seq_buf_printf(&s, "\n");
>  
> -	return seq_buf_used(&s);
> +	return seq_buf_strlen(&s);
>  }
>  static DEVICE_ATTR_RO(flags);
>  
> -- 
> 2.34.1
> 
