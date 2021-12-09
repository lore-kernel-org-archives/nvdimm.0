Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EEA2C9E
	for <nvdimm@lists.linux.dev>; Thu,  9 Dec 2021 07:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
	t=1639034577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WBvLniboMeIuEHrsc8VhLDaazeRis0mBmx+1KIklXRc=;
	b=SgQpdWzyQ3whh/dbxXF5ojQZ+A8s4AIhv/QpbxEXmajbk4EOz5pkKRGYXwUG3zI2En3P3p
	xIXlDyqVt/z+cLtAkeCugKVK1ogPotazZpoI+Clmw1lZVKBoE8z7GNMuyPvjP6LlAoa6lF
	HpqUWIjMSdEqNi7t6L0g4ORODs3p8Rk=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2053.outbound.protection.outlook.com [104.47.10.53]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-12-jECW15yfO7eMv4SimLED3g-1; Thu, 09 Dec 2021 08:22:56 +0100
X-MC-Unique: jECW15yfO7eMv4SimLED3g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GzGWEZDt5tp5l7/QaUk5N6gsJQLL5As//xtiERA20jp1rGgAxv7YscTbmU6Sf/TeWErMI8ULOr3mDTwdJK7IKCFH7tX3KP9AEVBZlOvd1E91NPB2eOMBiHm3QwC429UIwfbWNGulBio84hKBFa3dlrkUFO+/86fKgx39YI9mWMfvaCK6ZWSsUK2Q/giY8lqTGfeaoDHCrafergORwo9b5n+ION7NR900MkRmINeM3XIL5S7u359BLj/zSzjPATLuXGCkRJHdSQaoWmIYyv18I4+4fr9V+fbx64G9BNnF9Yjn4Vdyir5LxzVC0M3zHwOOBY9fGxf+tWqUhh1UkOWIFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WBvLniboMeIuEHrsc8VhLDaazeRis0mBmx+1KIklXRc=;
 b=A96NAEYo5yuqNMpmfSgLuosyucazVe11UkLY3zJWLzoBP0HGwCkDp2EmHHqGfiNf5jebHHQh/Vpj7zNcxTgKUiFoveOlPIbaPFob4qkXOLn2e2Wyv/BYZfzzyM5AM27Ov6KfzUcY6rPNd75r4IvQlM4zzw9KL6qUu9ZobGdEbvd8Wv4zpJRMR8heWmuOIV37h7uWd2u+KfhQy92FtHVTxOhI1hNfPzKIoyjKjL+pA36tDHj0UkNXTcBqwJx73lFu08W2+phRioioIvULfSNtj3a14YgJcLVSP0R6vRtSd8eC+LfmcXSM91kvrtyxSNxqhfgh9jlT1zRSmLp/0x4TmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by HE1PR0401MB2332.eurprd04.prod.outlook.com (2603:10a6:3:25::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 07:22:55 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::59a0:4185:3e03:7366]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::59a0:4185:3e03:7366%7]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 07:22:55 +0000
Date: Thu, 9 Dec 2021 15:22:51 +0800
From: Geliang Tang <geliang.tang@suse.com>
To: Coly Li <colyli@suse.de>
Cc: nvdimm@lists.linux.dev, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
	Vishal L Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH v3 2/6] badblocks: add helper routines for badblock
 ranges handling
Message-ID: <20211209072251.GA26976@dhcp-10-157-36-190>
References: <20211202125245.76699-1-colyli@suse.de>
 <20211202125245.76699-3-colyli@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202125245.76699-3-colyli@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: HK2PR0401CA0022.apcprd04.prod.outlook.com
 (2603:1096:202:2::32) To HE1PR0402MB3497.eurprd04.prod.outlook.com
 (2603:10a6:7:83::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from localhost (60.251.47.115) by HK2PR0401CA0022.apcprd04.prod.outlook.com (2603:1096:202:2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Thu, 9 Dec 2021 07:22:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbf22d61-2e38-4568-e868-08d9bae4b79f
X-MS-TrafficTypeDiagnostic: HE1PR0401MB2332:EE_
X-Microsoft-Antispam-PRVS:
	<HE1PR0401MB2332F411DBD58C2D7C49AF78F8709@HE1PR0401MB2332.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8CuNinQ1oxy8H+YX+VMm0grZy1/XoeWHkOk7ZHpGWw5hCD6Fnh6whbpu0a/BCn7jdRnZm7SDRL+ROau1LFMNttotDXlxM9bIe6nTm8Bo8YimfBVlp3ZWK+5V6RI9aHXwSsV2jD8mJSZYT2VxxIPfOh/ZYYF5VrmgX8GXKXBYGNYHe/TLXJyuXZfApaG3qmapyGkd4YnBXdRYr7mqDySeqL7TpnB0UTssRjpvGm9ZnPWNPSQ6M8zEO0nBv2JGVYF5yHts6JUNTOnPOi2bvYy19Ka/+X7UvI/VEyo9DiDqtthyV3hEyzk3/YN8J4541ibtVsN6t/tj4+yHyhX1C4A2A3N9ykIeLAD10R8ELs9i1nZZSXUqNoXflJKEgK02gmQddemBT2XMpnN+p0dtrPZbfzmsQVj2kBbv4P/okq92M6n7p0CUZNE5aFlv9l/Kn8WAExL4zpERJalR82Jit2lOTFtT/tbzRdhU/oViOLVgsQ1GjVsI5vsdMhuqG7GuJUj1MSr8XLFwlMm9EtLy4kChJHC4PBi334LcQMFkP3KHZ17Bvt6eojB5fZM0XTET2KwyLMkaVmQOVej9czJOWqYgkNCm7PIc6dSflrUwHwgtDlzHiiiHQOwBVHepOaYWX8ItqA2LD5vQmIUQpkgQTmxZjg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(316002)(2906002)(66946007)(508600001)(1076003)(66556008)(5660300002)(6486002)(8676002)(186003)(66476007)(8936002)(6496006)(4326008)(956004)(38100700002)(30864003)(9686003)(55236004)(86362001)(83380400001)(6666004)(33656002)(44832011)(6916009)(54906003)(33716001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K4gO3oTuEKOb0Dkl+i2O1Kx0mdyweZdVQzskElVW9j6kb8sC28f+qaUpRCRG?=
 =?us-ascii?Q?mmEWnv2UkeA96C43CfhhscHKtSfDACjmIJ9O9M4ofwSzygWot+XRCSNKaTtp?=
 =?us-ascii?Q?3p1YL/nUR+3CXLyGtKkYmAjHi2UrxGi8hByZBGqeeGtZw9JDj+0vVIgoQpsh?=
 =?us-ascii?Q?THqUW57QYiKVH/WrOei4QGPv58RXBztpbWZatJBWW/QN1q9kTS1Vl4cM+VBL?=
 =?us-ascii?Q?3NpfpmqVb4Qx7Yxqjl5labhEDyNnIQVZnbhE2SWBW5DMwqCVvqe1gl9wmCU2?=
 =?us-ascii?Q?Nd/rBMHRxmGrNuLVEaTTrEud718yRI7HFuW9bH/diLxyTyUXpvRiQRxtAfUb?=
 =?us-ascii?Q?9n6/C/mEfdGhn6Ul5Fw2YrnP/kpJnBrq9cuq4OaqO3RzGkTVPJSUylgqNKY8?=
 =?us-ascii?Q?RQFWZDnad5GvXv2olUpx/m4i3QD5bBvwnhAF54LfjL1w2Jd4PYhpZRrap80Z?=
 =?us-ascii?Q?5bFkdMA6wvUp+NQ1H/gvj7rNBAQBxBNog1YurwrTxwORfxEZJmNWEj+ElKuX?=
 =?us-ascii?Q?6zjCDBTvmcaLq36ssazcb5Is4w1SCqj/NVQU/gEfSLV5i9Cg/tcl6d9LUN/c?=
 =?us-ascii?Q?9biGReLYWhwiPLikowACJh0uLbeFgjPqiwfV+JnIV5eoofQcpyNvqTz/12u/?=
 =?us-ascii?Q?EtDcraXX+ojxv/81J8otriviba2r5crBpOCBPQfMLw5uahM0vaXO/0J2MxHC?=
 =?us-ascii?Q?iqkT+UeWnsX9h4z/0DgryqQHfeLAvxuWQWDRLfucNjLwBYXBSxwdLsYFTnTA?=
 =?us-ascii?Q?MbyqBuG6A0YZCjVmt/rK2ZS7+cIIMIezFmZRllP5N+kCridrnfm/09rcKnzi?=
 =?us-ascii?Q?Ycx+7DsrlKsrKlUMYu5lWmi7avXg6L75Tpa8xhIkQmrGGVTj/rX1HDARlSlF?=
 =?us-ascii?Q?QbO6inOhpO7cWl9rQT84QQWVsjDmOKbDUU857hWoKjWjzPJLwDMpjOUK3d2c?=
 =?us-ascii?Q?XE2gzGf8zpLf+8WyO6gxBzh7ZCQa5h+bi4/VM7G+YYEMZ/TUY/6XuG8tb/mO?=
 =?us-ascii?Q?G/zP6aZxlPkktm5l4uWzfBmLWLJwr6KNqgV2gYtSb+NQ9PvQNYf/50fCfewg?=
 =?us-ascii?Q?v+aXxXB8NGPszBRTCMBXgQKiUmYgzTQRCxHyMaibIt6WHokXKeY6O1qX7lCM?=
 =?us-ascii?Q?DK1MKODEIQxUAl4aEfuvV65ZsJxHXF77ptHrUKSg7liQ4UaLXNKJfh4RM+GM?=
 =?us-ascii?Q?Vx44BYHxQ8GsyDkEN56ZqZhE00ZeeSus6/fgCZdNzW6nHwURy2O/fBYQGtor?=
 =?us-ascii?Q?mcsCpMZARArnB5eEFozVeqnyo9rOR/kyTTvNUM8q3QkLsCWNZN8aJbxZWtM5?=
 =?us-ascii?Q?PX8hi2xY0TrIWTXCg4W6nfVV3P6swcIaTPl03ZDdJUfbLlgvHvhcYdHTLEhN?=
 =?us-ascii?Q?S+3aJTD92llm0P5+7SDWBs426OYgeFo0U5zNpDwJCWS2TErYIUz5vOdu1D4L?=
 =?us-ascii?Q?HRKETTcc9n/sQFhjdp7sY6ifMukSo4GKRkbuA4CXOmFEQRYU0bo5Q9dILhG+?=
 =?us-ascii?Q?m4eK80avk93ceBJ8Z/XicXWcA41aDYG3/UYuxhlaDrsdbBGIa1WMxriFtQ3G?=
 =?us-ascii?Q?2Qb+xneZYSZ376TMRxIgqG4x7PltoYTUweGQAEOyinBGhAprRzEGObKfz2Fr?=
 =?us-ascii?Q?iii+ItkxYk/F2Kp8Bg/pBgA=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf22d61-2e38-4568-e868-08d9bae4b79f
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 07:22:54.9913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0aefE/alVHWrXt+oHqYgBQoMBY0ooc5a3j4o95qTOpJKYQw5CYBe3RrV0Z+ifPwQCCHPrPkAr9gtcEpvAKACLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0401MB2332

Hi Coly,

Thanks for this new version!

On Thu, Dec 02, 2021 at 08:52:40PM +0800, Coly Li wrote:
> This patch adds several helper routines to improve badblock ranges
> handling. These helper routines will be used later in the improved
> version of badblocks_set()/badblocks_clear()/badblocks_check().
> 
> - Helpers prev_by_hint() and prev_badblocks() are used to find the bad
>   range from bad table which the searching range starts at or after.
> 
> - The following helpers are to decide the relative layout between the
>   manipulating range and existing bad block range from bad table.
>   - can_merge_behind()
>     Return 'true' if the manipulating range can backward merge with the
>     bad block range.
>   - can_merge_front()
>     Return 'true' if the manipulating range can forward merge with the
>     bad block range.
>   - can_combine_front()
>     Return 'true' if two adjacent bad block ranges before the
>     manipulating range can be merged.
>   - overlap_front()
>     Return 'true' if the manipulating range exactly overlaps with the
>     bad block range in front of its range.
>   - overlap_behind()
>     Return 'true' if the manipulating range exactly overlaps with the
>     bad block range behind its range.
>   - can_front_overwrite()
>     Return 'true' if the manipulating range can forward overwrite the
>     bad block range in front of its range.
> 
> - The following helpers are to add the manipulating range into the bad
>   block table. Different routine is called with the specific relative
>   layout between the maniplating range and other bad block range in the
>   bad block table.
>   - behind_merge()
>     Merge the maniplating range with the bad block range behind its
>     range, and return the number of merged length in unit of sector.
>   - front_merge()
>     Merge the maniplating range with the bad block range in front of
>     its range, and return the number of merged length in unit of sector.
>   - front_combine()
>     Combine the two adjacent bad block ranges before the manipulating
>     range into a larger one.
>   - front_overwrite()
>     Overwrite partial of whole bad block range which is in front of the
>     manipulating range. The overwrite may split existing bad block range
>     and generate more bad block ranges into the bad block table.
>   - insert_at()
>     Insert the manipulating range at a specific location in the bad
>     block table.
> 
> All the above helpers are used in later patches to improve the bad block
> ranges handling for badblocks_set()/badblocks_clear()/badblocks_check().
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Geliang Tang <geliang.tang@suse.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Vishal L Verma <vishal.l.verma@intel.com>
> ---
>  block/badblocks.c | 374 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 374 insertions(+)
> 
> diff --git a/block/badblocks.c b/block/badblocks.c
> index d39056630d9c..e216c6791b4b 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -16,6 +16,380 @@
>  #include <linux/types.h>
>  #include <linux/slab.h>
>  
> +/*
> + * Find the range starts at-or-before 's' from bad table. The search
> + * starts from index 'hint' and stops at index 'hint_end' from the bad
> + * table.
> + */
> +static int prev_by_hint(struct badblocks *bb, sector_t s, int hint)
> +{
> +	int hint_end = hint + 2;
> +	u64 *p = bb->page;
> +	int ret = -1;
> +
> +	while ((hint < hint_end) && ((hint + 1) <= bb->count) &&
> +	       (BB_OFFSET(p[hint]) <= s)) {
> +		if ((hint + 1) == bb->count || BB_OFFSET(p[hint + 1]) > s) {
> +			ret = hint;
> +			break;
> +		}
> +		hint++;
> +	}
> +
> +	return ret;
> +}
> +
> +/*
> + * Find the range starts at-or-before bad->start. If 'hint' is provided
> + * (hint >= 0) then search in the bad table from hint firstly. It is
> + * very probably the wanted bad range can be found from the hint index,
> + * then the unnecessary while-loop iteration can be avoided.
> + */
> +static int prev_badblocks(struct badblocks *bb, struct badblocks_context *bad,
> +			  int hint)
> +{
> +	sector_t s = bad->start;
> +	int ret = -1;
> +	int lo, hi;
> +	u64 *p;
> +
> +	if (!bb->count)
> +		goto out;
> +
> +	if (hint >= 0) {
> +		ret = prev_by_hint(bb, s, hint);
> +		if (ret >= 0)
> +			goto out;
> +	}
> +
> +	lo = 0;
> +	hi = bb->count;
> +	p = bb->page;
> +
> +	while (hi - lo > 1) {
> +		int mid = (lo + hi)/2;
> +		sector_t a = BB_OFFSET(p[mid]);
> +
> +		if (a <= s)
> +			lo = mid;
> +		else
> +			hi = mid;
> +	}
> +
> +	if (BB_OFFSET(p[lo]) <= s)
> +		ret = lo;
> +out:
> +	return ret;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' can be backward merged
> + * with the bad range (from the bad table) index by 'behind'.
> + */
> +static bool can_merge_behind(struct badblocks *bb, struct badblocks_context *bad,
> +			     int behind)
> +{
> +	sector_t sectors = bad->len;
> +	sector_t s = bad->start;
> +	int ack = bad->ack;

The local variables 'sectors' and 'ack' only be used once in this
fuction, how about using 'bad->len' and 'bad->ack' directly.

> +	u64 *p = bb->page;
> +
> +	if ((s <= BB_OFFSET(p[behind])) &&
> +	    ((s + sectors) >= BB_OFFSET(p[behind])) &&
> +	    ((BB_END(p[behind]) - s) <= BB_MAX_LEN) &&
> +	    BB_ACK(p[behind]) == ack)
> +		return true;
> +	return false;
> +}
> +
> +/*
> + * Do backward merge for range indicated by 'bad' and the bad range
> + * (from the bad table) indexed by 'behind'. The return value is merged
> + * sectors from bad->len.
> + */
> +static int behind_merge(struct badblocks *bb, struct badblocks_context *bad,
> +			int behind)
> +{
> +	sector_t sectors = bad->len;
> +	sector_t s = bad->start;
> +	int ack = bad->ack;

The local variable 'ack' can be dropped too.

> +	u64 *p = bb->page;
> +	int merged = 0;
> +
> +	WARN_ON(s > BB_OFFSET(p[behind]));
> +	WARN_ON((s + sectors) < BB_OFFSET(p[behind]));
> +
> +	if (s < BB_OFFSET(p[behind])) {
> +		WARN_ON((BB_LEN(p[behind]) + merged) >= BB_MAX_LEN);
> +
> +		merged = min_t(sector_t, sectors, BB_OFFSET(p[behind]) - s);
> +		p[behind] =  BB_MAKE(s, BB_LEN(p[behind]) + merged, ack);
> +	} else {
> +		merged = min_t(sector_t, sectors, BB_LEN(p[behind]));
> +	}
> +
> +	WARN_ON(merged == 0);
> +
> +	return merged;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' can be forward
> + * merged with the bad range (from the bad table) indexed by 'prev'.
> + */
> +static bool can_merge_front(struct badblocks *bb, int prev,
> +			    struct badblocks_context *bad)
> +{
> +	sector_t s = bad->start;
> +	int ack = bad->ack;

The local variable 'ack' here can be dropped too.

> +	u64 *p = bb->page;
> +
> +	if (BB_ACK(p[prev]) == ack &&
> +	    (s < BB_END(p[prev]) ||
> +	     (s == BB_END(p[prev]) && (BB_LEN(p[prev]) < BB_MAX_LEN))))
> +		return true;
> +	return false;
> +}
> +
> +/*
> + * Do forward merge for range indicated by 'bad' and the bad range
> + * (from bad table) indexed by 'prev'. The return value is sectors
> + * merged from bad->len.
> + */
> +static int front_merge(struct badblocks *bb, int prev, struct badblocks_context *bad)
> +{
> +	sector_t sectors = bad->len;
> +	sector_t s = bad->start;
> +	int ack = bad->ack;

The local variable 'ack' here can be dropped too.

> +	u64 *p = bb->page;
> +	int merged = 0;
> +
> +	WARN_ON(s > BB_END(p[prev]));
> +
> +	if (s < BB_END(p[prev])) {
> +		merged = min_t(sector_t, sectors, BB_END(p[prev]) - s);
> +	} else {
> +		merged = min_t(sector_t, sectors, BB_MAX_LEN - BB_LEN(p[prev]));
> +		if ((prev + 1) < bb->count &&
> +		    merged > (BB_OFFSET(p[prev + 1]) - BB_END(p[prev]))) {
> +			merged = BB_OFFSET(p[prev + 1]) - BB_END(p[prev]);
> +		}
> +
> +		p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +				  BB_LEN(p[prev]) + merged, ack);
> +	}
> +
> +	return merged;
> +}
> +
> +/*
> + * 'Combine' is a special case which can_merge_front() is not able to
> + * handle: If a bad range (indexed by 'prev' from bad table) exactly
> + * starts as bad->start, and the bad range ahead of 'prev' (indexed by
> + * 'prev - 1' from bad table) exactly ends at where 'prev' starts, and
> + * the sum of their lengths does not exceed BB_MAX_LEN limitation, then
> + * these two bad range (from bad table) can be combined.
> + *
> + * Return 'true' if bad ranges indexed by 'prev' and 'prev - 1' from bad
> + * table can be combined.
> + */
> +static bool can_combine_front(struct badblocks *bb, int prev,
> +			      struct badblocks_context *bad)
> +{
> +	u64 *p = bb->page;
> +
> +	if ((prev > 0) &&
> +	    (BB_OFFSET(p[prev]) == bad->start) &&
> +	    (BB_END(p[prev - 1]) == BB_OFFSET(p[prev])) &&
> +	    (BB_LEN(p[prev - 1]) + BB_LEN(p[prev]) <= BB_MAX_LEN) &&
> +	    (BB_ACK(p[prev - 1]) == BB_ACK(p[prev])))
> +		return true;
> +	return false;
> +}
> +
> +/*
> + * Combine the bad ranges indexed by 'prev' and 'prev - 1' (from bad
> + * table) into one larger bad range, and the new range is indexed by
> + * 'prev - 1'.
> + */
> +static void front_combine(struct badblocks *bb, int prev)
> +{
> +	u64 *p = bb->page;
> +
> +	p[prev - 1] = BB_MAKE(BB_OFFSET(p[prev - 1]),
> +			      BB_LEN(p[prev - 1]) + BB_LEN(p[prev]),
> +			      BB_ACK(p[prev]));
> +	if ((prev + 1) < bb->count)
> +		memmove(p + prev, p + prev + 1, (bb->count - prev - 1) * 8);
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' is exactly forward
> + * overlapped with the bad range (from bad table) indexed by 'front'.
> + * Exactly forward overlap means the bad range (from bad table) indexed
> + * by 'prev' does not cover the whole range indicated by 'bad'.
> + */
> +static bool overlap_front(struct badblocks *bb, int front,
> +			  struct badblocks_context *bad)
> +{
> +	u64 *p = bb->page;
> +
> +	if (bad->start >= BB_OFFSET(p[front]) &&
> +	    bad->start < BB_END(p[front]))
> +		return true;
> +	return false;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' is exactly backward
> + * overlapped with the bad range (from bad table) indexed by 'behind'.
> + */
> +static bool overlap_behind(struct badblocks *bb, struct badblocks_context *bad,
> +			   int behind)
> +{
> +	u64 *p = bb->page;
> +
> +	if (bad->start < BB_OFFSET(p[behind]) &&
> +	    (bad->start + bad->len) > BB_OFFSET(p[behind]))
> +		return true;
> +	return false;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' can overwrite the bad
> + * range (from bad table) indexed by 'prev'.
> + *
> + * The range indicated by 'bad' can overwrite the bad range indexed by
> + * 'prev' when,
> + * 1) The whole range indicated by 'bad' can cover partial or whole bad
> + *    range (from bad table) indexed by 'prev'.
> + * 2) The ack value of 'bad' is larger or equal to the ack value of bad
> + *    range 'prev'.
> + *
> + * If the overwriting doesn't cover the whole bad range (from bad table)
> + * indexed by 'prev', new range might be split from existing bad range,
> + * 1) The overwrite covers head or tail part of existing bad range, 1
> + *    extra bad range will be split and added into the bad table.
> + * 2) The overwrite covers middle of existing bad range, 2 extra bad
> + *    ranges will be split (ahead and after the overwritten range) and
> + *    added into the bad table.
> + * The number of extra split ranges of the overwriting is stored in
> + * 'extra' and returned for the caller.
> + */
> +static bool can_front_overwrite(struct badblocks *bb, int prev,
> +				struct badblocks_context *bad, int *extra)
> +{
> +	u64 *p = bb->page;
> +	int len;
> +
> +	WARN_ON(!overlap_front(bb, prev, bad));
> +
> +	if (BB_ACK(p[prev]) >= bad->ack)
> +		return false;
> +
> +	if (BB_END(p[prev]) <= (bad->start + bad->len)) {
> +		len = BB_END(p[prev]) - bad->start;
> +		if (BB_OFFSET(p[prev]) == bad->start)
> +			*extra = 0;
> +		else
> +			*extra = 1;
> +
> +		bad->len = len;
> +	} else {
> +		if (BB_OFFSET(p[prev]) == bad->start)
> +			*extra = 1;
> +		else
> +		/*
> +		 * prev range will be split into two, beside the overwritten
> +		 * one, an extra slot needed from bad table.
> +		 */
> +			*extra = 2;
> +	}
> +
> +	if ((bb->count + (*extra)) >= MAX_BADBLOCKS)
> +		return false;
> +
> +	return true;
> +}
> +
> +/*
> + * Do the overwrite from the range indicated by 'bad' to the bad range
> + * (from bad table) indexed by 'prev'.
> + * The previously called can_front_overwrite() will provide how many
> + * extra bad range(s) might be split and added into the bad table. All
> + * the splitting cases in the bad table will be handled here.
> + */
> +static int front_overwrite(struct badblocks *bb, int prev,
> +			   struct badblocks_context *bad, int extra)
> +{
> +	u64 *p = bb->page;
> +	sector_t orig_end = BB_END(p[prev]);
> +	int orig_ack = BB_ACK(p[prev]);

How about renaming 'orig_end' to 'end', renaming 'orig_ack' to 'ack'?

> +	int n = extra;

I think no need to add this local variable 'n' here, use 1 or 2
instead.

> +
> +	switch (extra) {
> +	case 0:
> +		p[prev] = BB_MAKE(BB_OFFSET(p[prev]), BB_LEN(p[prev]),
> +				  bad->ack);
> +		break;
> +	case 1:
> +		if (BB_OFFSET(p[prev]) == bad->start) {
> +			p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +					  bad->len, bad->ack);
> +			memmove(p + prev + 2, p + prev + 1,
> +				(bb->count - prev - 1) * 8);
> +			p[prev + 1] = BB_MAKE(bad->start + bad->len,
> +					      orig_end - BB_END(p[prev]),
> +					      orig_ack);
> +		} else {
> +			p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +					  bad->start - BB_OFFSET(p[prev]),
> +					  BB_ACK(p[prev]));
> +			memmove(p + prev + 1 + n, p + prev + 1,

Here use 'p + prev + 2' instead of 'p + prev + 1 + n',

> +				(bb->count - prev - 1) * 8);
> +			p[prev + 1] = BB_MAKE(bad->start, bad->len, bad->ack);
> +		}
> +		break;
> +	case 2:
> +		p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +				  bad->start - BB_OFFSET(p[prev]),
> +				  BB_ACK(p[prev]));
> +		memmove(p + prev + 1 + n, p + prev + 1,

And here use 'p + prev + 3' instead of 'p + prev + 1 + n'.

> +			(bb->count - prev - 1) * 8);
> +		p[prev + 1] = BB_MAKE(bad->start, bad->len, bad->ack);
> +		p[prev + 2] = BB_MAKE(BB_END(p[prev + 1]),
> +				      orig_end - BB_END(p[prev + 1]),
> +				      BB_ACK(p[prev]));
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return bad->len;
> +}
> +
> +/*
> + * Explicitly insert a range indicated by 'bad' to the bad table, where
> + * the location is indexed by 'at'.
> + */
> +static int insert_at(struct badblocks *bb, int at, struct badblocks_context *bad)
> +{
> +	sector_t sectors = bad->len;
> +	sector_t s = bad->start;
> +	int ack = bad->ack;

The local variables 'sectors', 's' and 'ack' can be dropped here.

> +	u64 *p = bb->page;
> +	int len;
> +
> +	WARN_ON(badblocks_full(bb));
> +
> +	len = min_t(sector_t, sectors, BB_MAX_LEN);
> +	if (at < bb->count)
> +		memmove(p + at + 1, p + at, (bb->count - at) * 8);
> +	p[at] = BB_MAKE(s, len, ack);
> +
> +	return len;
> +}
> +
>  /**
>   * badblocks_check() - check a given range for bad sectors
>   * @bb:		the badblocks structure that holds all badblock information
> -- 
> 2.31.1
> 

