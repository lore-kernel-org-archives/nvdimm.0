Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C983812C2
	for <nvdimm@lists.linux.dev>; Thu, 16 Jul 2026 04:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784174915; cv=fail; b=rfs/6qZYQn7g9wlgX56QnJBx7SvwZelyphsDZjFvpncrq4BNefsdnro7/TT0VBqIBENULrqG+WlGpK5D8Uhp+WIEMUGFy4Gx6uSDWWZqs/tS/yRAlypUdTdkyZdomhMUFbx33mxL8JXFbawbpFP5v2Wg1Rb5Z1RPRjG7r4XSNZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784174915; c=relaxed/simple;
	bh=7gbGecGcXEFPK5LBdht8nMM1uXBlNK9VGVxujUh8mYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QsIuCFSuEHYZf36AkNbp9V7rIBr+s7EXW2B4JYN9KR4TacR7a+bC4AOwTtbcfPT7ht/fwthrn/cgI7TOLTO1NMWO2DuA9bIdPs8Z/WpUCpCCK9F/skyjzPZqTy4V+8nif4VMYx6b2IVjb4oQgbuA8LWoAKmfpo9nWKbk+6IEils=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jE6jqMg5; arc=fail smtp.client-ip=52.101.46.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jE6jqMg5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uLzf9x38Ru6UH4L1iYYj7L4cujjSeFeeQWMIhvRoOI9iEenxdeFwS4X3vWWjq9t9+jLpoGtKh2MVfOaEQweX0eRePMzc46jG4A007Pd2HHglOsHQdD6kkewVWngXly6hSwhHbfRfV5JuJXv7bWNcVtpYU1MPTZ1YfjH4kL0WLgDNYyPDCfNBryVGNspJdphwR2ndbhxk51rhYiwasWkkPY91I3Vc828xIzQRLdAHVFK79Go5lbNijaO6sCd2iGmW4WHXRwD6kBhu+T3qVwjOR4Qp50aTUMW5jat5jJRL16QN0RShlyJy9n1A1cm0JyNz4I8VKyb2wKjscbzijJqlOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JHNDmpQSbUFVwn2u+OGewJ/pkSHtsKGkU0dZed9lLZM=;
 b=uP0IDvNNYuUZo4dao/SX6wTY442eDoEI9BMw2G/UUpopZCAPL4ixAmoKMvlsiMDjYmrfAx8mdUr8dMDZeOsxoQrWZiPGevzdXpHaejk0eF5rRnpNKSb9FJHfUBcf2feCnf1rrh9hB46E2KgdZfcxGAlzB2W81XE1A1eAAt7A/YeF1VBshfQKBncyMbVsIY4+hGXlRM7HQrRSP0lff0iJ2/KSJs5iu8I9sPlfyKpDqBgIC4RcWzxV5jd27GapXK2TYDCuW7EjDCK6XAXzxGvVzcRbd2/lnAgv7EyZnCEdApvGmvi9MduNQEnM3p5z30dXGkWe0Y0K3ArILwd8WhyOjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHNDmpQSbUFVwn2u+OGewJ/pkSHtsKGkU0dZed9lLZM=;
 b=jE6jqMg53vdUO2C3j1lzb1MxSP1v8GmXFJQlqfSiHBheFcs6kjJFMVB+n8i/MpRo0Vgr3gEu5tdKkVQYqTQ1oUaHoUivBsv1UNpvdBfzvphmPQNh+dBrJUl53JVrBthSuO6jeXt3Tpq+yRVW3Xtk4EUkIUrhuOcsa/1YnxyCB74Hd0JU7gCItX7OUp63iKXwHApxTXi2C4CU+wHw8rMMde7c9b9LJm3ed3rtq8uGwVrjqtl6+83IHsn+aXiahKLTDkaKwXm2wCe4CnoAmiOMegDb/1xS8TXUh4R6aIewgYlt3OqCmuDXXfmG/yW/7Lf8sZjlJyigvKi+5dpwx1LLow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by LVXPR12MB999197.namprd12.prod.outlook.com (2603:10b6:408:3dc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.13; Thu, 16 Jul
 2026 04:08:30 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0223.008; Thu, 16 Jul 2026
 04:08:29 +0000
Date: Thu, 16 Jul 2026 12:08:24 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: dave@stgolabs.net, jic23@kernel.org, dave.jiang@intel.com, 
	vishal.l.verma@intel.com, djbw@kernel.org, danwilliams@nvidia.com, nvdimm@lists.linux.dev, 
	iweiny@kernel.org, ming.li@zohomail.com, kobak@nvidia.com, kaihengf@nvidia.com, 
	kees@kernel.org, newtonl@nvidia.com, kristinc@nvidia.com, mochs@nvidia.com, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ndctl PATCH] test/fwctl: Add Get Feature OOB rejection
 regression test
Message-ID: <alhYLE0LxiO32H98@MWDK4CY14F>
References: <20260624140006.50773-1-icheng@nvidia.com>
 <alaN3HGUZ9Fl8vcD@aschofie-mobl2.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alaN3HGUZ9Fl8vcD@aschofie-mobl2.lan>
X-ClientProxiedBy: TP0P295CA0059.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::12) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|LVXPR12MB999197:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d0ec074-e9c3-4432-a129-08dee2efe484
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|18002099003|22082099003|11063799006|4143699003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	CEDnOnL6CINcqw9Zozi+9YaxATkipfFhkFoLt8n4/USea40vNJXkKu8P34cDucYGyBXL9InNcnTd4meekLfarL7c8+5LAyn09mOd0NxuhRBZ6TPUB2k7bc+u4sMuKwxlrE63Ws2iJ5Mg74ftfJ8TjW/fAX5FcmK5Hfs2W/KMBuo1gleDy9APwZQmG2uBhYPbX0LwKzjuvaOqvsekC02DILjuSmgsjze1ksn+mzCj+jF0YXvV0i1ME4MIDBjQlOzdC1xFnLNvZhVZmQ6xdg8Ot12kN3hZC8cZh1EeBeP8tLhXosNiERq5N/DG0uYbB3Wpft9xLTFRHzeg8m1fRqTA+c/OEc+bB+dXUHTCn2CVzsUdJtje0qShVW/dfpxEJiqMJohuIxwwR560wXW8Zd/+VhzFYHKUcVeR82fhfBfkVdbRknj6upv05KVppsJ7aawr+B/+HMUZdtL2BEJ7Pgp1Vl05/o5jGOdYDnaKve1iuSTJQ6Bls3zDdhQ7zV3Djg6irJDs2u4b2FkP9eJOn0osZmpRGXpcSfHHvWKjnALdB/7dMYUJGFAV/Kt0PYg4mhsWneNOBdjJHjW364IpSw6hVf5hq+ofGTLH7k1ZAXNghBMg7iuHER/NI0mJ7b//SIxDT9op3EXeEbha+pcprMYfzOuV0CIlHCNYHxvI73/duAY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(18002099003)(22082099003)(11063799006)(4143699003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2UNskKB0j+lFyRdd0KCIlL71PVP/p10VLhWiePLXmOMNb3r+Vq2esGG61R3A?=
 =?us-ascii?Q?sPQyCFjUhAVJ7sHDH+BZzqXbRi+L9H8CVQnM6+t93xfBU/g8rIezcZHqnzRG?=
 =?us-ascii?Q?9A/9uCNXdeYhwL7p9U3MKshWR3NhN/7KyboVN/JG23iUqUgzL915VTrX2eQA?=
 =?us-ascii?Q?w1/HucU2NiUciFuetDWw/cIRurmmhROa1FXKWIYjLZ87pv7MYbM3foEsl9Nd?=
 =?us-ascii?Q?A6rqi+smFw2/g1Tcl6UMlQoJdIwSWIvHNieQ34t+4yGAx5OE/BlH9bjQUAqy?=
 =?us-ascii?Q?Kn9XckL2eNcTAWXd6v9S8EomUOVNczH1I9eOOP8K7yYYbRwD5o8MZTMv18vV?=
 =?us-ascii?Q?/JFGHU8du2JtnGzsAEoblYk6Rx1fmq4defbk6lvkT5Fm6Jatp1moYFDagA52?=
 =?us-ascii?Q?WOiBhQyFXWkw1U8U8YIttZrA7cTeoiV39QgimIi4BbUkiJI9kvBuJuRgUIqD?=
 =?us-ascii?Q?tQ18835T+endeNYKP6Dyqn7LjmS29xxOn/BylULADf5jQNgB5sSDC3HQFZMT?=
 =?us-ascii?Q?LgSg98j4tc1Jl5DZsQZUmUqDNocEYiXLnw5yHHqLajKBEkfZYFsmL5LkC24I?=
 =?us-ascii?Q?zdZhTrGChBvF9TEfaXiQsYUD/irKkJjy6bdYeiCSSWfWxuwMzU8P7sxYa2f9?=
 =?us-ascii?Q?VanRU8obx4ujg15c2txXWDn/5X4G4qnTfEnjzT27jxWYY0KqW7uAajbBp4Jg?=
 =?us-ascii?Q?pLcHGczkZZ3n5aO+vJlfFFhhEB0MZ+OXNji7f6CEnn5DIcfpTIb9QUtgyzSm?=
 =?us-ascii?Q?SV2UF8ADoeUTwv5ccUeApBjyd2Y/Uuv2aDVxtxUOgiVW2BSZKMcZFsCxKO89?=
 =?us-ascii?Q?ms8biEpHM7VAtkcokL6kxarEYjt+IauOCOTS8M8sHcQQPEThYeoUIXulgHhC?=
 =?us-ascii?Q?LVeHZAIkZjUzcqrX+GSEP1IFWuyQ6dcUjHM41MME1Cqje/FCtQEl9Xtz7IpS?=
 =?us-ascii?Q?p5Wfbu247MZVccwN/SlP1yMx0aywlPiduPY0wcaTG/pXYbhRhvI3KawsTjS9?=
 =?us-ascii?Q?JYnH6TUe6Szdl1JH3LukyR/A9YmtK3v26VMIgV25X02V0VoZZ7fctXd615Je?=
 =?us-ascii?Q?jp+ilWTJcrwk8EmQdFT6Vcz9j3nlyDpw2xw+SuY9eiEj+F/UJOxl4mNi5iIR?=
 =?us-ascii?Q?XGf/DOQZXyp6zQqRBRcx48hRXvtTsdZeodBiflvVHJIJnBBL7X9hMUQs2CgU?=
 =?us-ascii?Q?NaUULMgX2wELhOVOZeaY4PdVN8OP4iCec9KhBtd4W9ddxZuh/8cwgSDgoFIN?=
 =?us-ascii?Q?dw9Htd2SIQrEatt4xnxZ1S4KTdH9OWjMpY28HqSHhD9f2thxOsawoOmZTC6A?=
 =?us-ascii?Q?HdFDCb6x/L+wmCEZ+RnP4AwNc1JnD1JE6VkGDpy69iB+vVc6kro3ZZ/rmnFo?=
 =?us-ascii?Q?qgV6aaES7Z2MToPQoiK+cgLMzt/L8QJsm1hdLtinqkTBaxwinHr3hem2rznT?=
 =?us-ascii?Q?XZsff91TDxD07fz8aukK6thYEoOJSl6g1mHoC3cTIQ71AOhHEcQEf7nbin+S?=
 =?us-ascii?Q?mV87r7uzs2x//L7Rn4rb/rgIL2coo7fB2ySNh7dWfmI0JkIfnUa1mO/kEzGa?=
 =?us-ascii?Q?t/8a94NRN9XB/xn50NV+m4XZHk06chPlfZ6YBmQFUQ0ZpUl+qa/nazTn79OY?=
 =?us-ascii?Q?1jIPlTxUc4xPqz6RB/vD/d7XKhNet+EU9bTSnM/ihIyqrUKxhC5Q49hPjHbZ?=
 =?us-ascii?Q?ojYuqIklvyK1w4C+ypo0vRki6U0IYhf/q6ZUYGvtB5QT5Djc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d0ec074-e9c3-4432-a129-08dee2efe484
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 04:08:29.8902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kg134uo4xI8dTWPVThBpGgec3uMN3yYeYkUpXHoOP7taxBb/6M7ybfEcvmtTQsORk9Xouae5aPXeiRkEXdzegw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVXPR12MB999197

On Tue, Jul 14, 2026 at 12:28:28PM +0800, Alison Schofield wrote:
> On Wed, Jun 24, 2026 at 10:00:06PM +0800, Richard Cheng wrote:
> > Add a negative case to the CXL fwctl test that issues a Get Feature
> > FWCTL_RPC with out_len == offset(struct fwctl_rpc_cxl_out, payload) and
> > a non-zero count. The kernel must reject this with -EINVAL instead of
> > writing the feature payload past the rpc_out buffer.
> > 
> > This is the userspace regression test for corresponding kernel fix [1].
> 
> Hi Richard,
> 
> I just finished reviewing the now 3 piece series[2], that [1] is now
> a piece of.
> 
> One suggestion on top of the kver gating suggested in prior response
> is to add a companion negative case for the Set Feature bounds fix
> in the same series. Same shape as this one, ie build a normal Set
> Feature RPC, set out_len to 0, expect -EINVAL. It's a stronger backstop
> than the Get case, too because before the fix an out_len of 0 makes
> kvzalloc() return ZERO_SIZE_PTR, which passes the !rpc_out check, and
> the header write then oopses rather than just returning a wrong status.
> Gate it on the same kver helper.
> 
> I'm stopping short of suggesting a test for the third patch (the Get
> Feature per-iteration clamp). That one looks like it needs a
> multi-transfer feature and a device that over returns on the last chunk,
> neither possible without a cxl_test mock change.
> 
> -- Alison
> 
> > [1]: https://lore.kernel.org/all/20260624134737.49166-1-icheng@nvidia.com/
> [2]: https://lore.kernel.org/linux-cxl/20260626104102.53892-1-icheng@nvidia.com/#r
> 
>

Hi Alison,

Thanks for the review. I'll update the ndctl patch to add kernel-version check
and a Set Feature negative test with "out_len=0"

I'll use the same version check for both tsets and send a new version for it.

As for the Get Feature per-iteration clamp, I'll also work on extending cxl_test
with the required mock behavior. I'll send the cxl_test change and its regression
test as follow-up patches.

--Richard
 
> > Signed-off-by: Richard Cheng <icheng@nvidia.com>
> > ---
> >  test/fwctl.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 46 insertions(+)
> > 
> > diff --git a/test/fwctl.c b/test/fwctl.c
> > index 979c1a6..69d0048 100644
> > --- a/test/fwctl.c
> > +++ b/test/fwctl.c
> > @@ -5,6 +5,7 @@
> >  #include <stdio.h>
> >  #include <endian.h>
> >  #include <stdint.h>
> > +#include <stddef.h>
> >  #include <stdlib.h>
> >  #include <syslog.h>
> >  #include <string.h>
> > @@ -207,6 +208,45 @@ out:
> >  	return rc;
> >  }
> >  
> > +static int cxl_fwctl_rpc_get_feature_oob(int fd, struct test_feature *feat_ctx)
> > +{
> > +	struct cxl_mbox_get_feat_in *feat_in;
> > +	struct fwctl_rpc_cxl_out *out;
> > +	size_t out_size, in_size;
> > +	struct fwctl_rpc_cxl *in;
> > +	struct fwctl_rpc *rpc;
> > +	int rc;
> > +
> > +	in_size = sizeof(*in) + sizeof(*feat_in);
> > +	/* header only => zero payload room */
> > +	out_size = offsetof(struct fwctl_rpc_cxl_out, payload);
> > +
> > +	rpc = get_prepped_command(in_size, out_size,
> > +				  CXL_MBOX_OPCODE_GET_FEATURE);
> > +	if (!rpc)
> > +		return -ENXIO;
> > +
> > +	in = (struct fwctl_rpc_cxl *)rpc->in;
> > +	out = (struct fwctl_rpc_cxl_out *)rpc->out;
> > +
> > +	feat_in = &in->get_feat_in;
> > +	uuid_copy(feat_in->uuid, feat_ctx->uuid);
> > +	/* non-zero count that exceeds the zero payload room */
> > +	feat_in->count = feat_ctx->get_size;
> > +
> > +	rc = send_command(fd, rpc, out);
> > +	free_rpc(rpc);
> > +
> > +	if (rc == -EINVAL)
> > +		return 0;
> > +	if (rc == 0) {
> > +		fprintf(stderr, "Get Feature with undersized out_len was not rejected\n");
> > +		return -ENXIO;
> > +	}
> > +	fprintf(stderr, "Get Feature OOB rejection test: unexpected rc %d\n", rc);
> > +	return rc;
> > +}
> > +
> >  static int cxl_fwctl_rpc_set_test_feature(int fd, struct test_feature *feat_ctx)
> >  {
> >  	struct cxl_mbox_set_feat_in *feat_in;
> > @@ -393,6 +433,12 @@ static int test_fwctl_features(struct cxl_memdev *memdev)
> >  		goto out;
> >  	}
> >  
> > +	rc = cxl_fwctl_rpc_get_feature_oob(fd, &feat_ctx);
> > +	if (rc) {
> > +		fprintf(stderr, "Failed Get Feature OOB rejection test: %d\n", rc);
> > +		goto out;
> > +	}
> > +
> >  out:
> >  	close(fd);
> >  	return rc;
> > 
> > base-commit: 8ad90e54f0ff4f7291e7f21d44d769d10f24e2b6
> > -- 
> > 2.43.0
> > 
