Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CD5173
	for <nvdimm@lists.linux.dev>; Thu,  9 Dec 2021 07:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
	t=1639034942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SW8x2hIqJwzFqqcHI5Btw9I6OJvTdL4IaW95tZ0NbFI=;
	b=ajofrQS9fHHXANyzCXav+SbtJnhc998c5Lj4e7LliHzhwgAMNL6OHOg0yyytu6UujrDE/2
	OG+t5uYELL8TjnRqW5xIw3Ly012WQQUfG75UDPOLyOo2hFThJyeci69RWsPpDG7O9/GZGI
	kXmFVaIFWA0Z3UTf7p/excW21PaIroY=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2105.outbound.protection.outlook.com [104.47.17.105]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-39-KYqZ5Q1rNwqpmGuOQPxwjw-1; Thu, 09 Dec 2021 08:29:01 +0100
X-MC-Unique: KYqZ5Q1rNwqpmGuOQPxwjw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMgacBRPLj44eDb5yCCJmuBzwx88vY0WpeWOvCXjUXBXk13rngsdSEk4ztJN8OmBMbzKqOasfLEziF+ayVVUoBVsIeXj2CrkhitWu1gR2xg5MSSzlDOAmgf+8kqikSmbdLbUR9sfh6kd+wpVM9oyngI9u7hodFd5Fzr+HsMWRbJ5WHActOwRCOcdTHjtcpfzvWAy9jPlqSIpPTeEVaWxInsP1yP8Rz8H8n+NGUWjWBLweNNMoTZGD2RhKscN+3sqhLsUEMerIsFj0xCQhYYHc0XvcltOiTjGzdeyTdTgC3XB1hXdsQQ8EOYnYpKxKE6QgDbamgZHDKgazpr0YbREnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SW8x2hIqJwzFqqcHI5Btw9I6OJvTdL4IaW95tZ0NbFI=;
 b=boMg6bYsb/hdKYAxxdYDidybUrYtsb/q2hrwVvxAos7U6GMkiqRiobFyJP+lpk9ku+kf7X7ClkZqoEmWPznR2DuftwLP2KXEVZAI6YhBnDc3BmJ9dgOk3OpjPtHtT+RqMwV88u+jLlw8hKqF5Td7V6yu8h9fW+74hZ8Vq+2TfMpR3C60fSoHR/wOCwFS5FGucwToCkb9gNI8xnJb3kBId1ExRu2E2L3GGqdU7ipFlZo5bhMN1dlx8p0RkbrtgFziiKja9rNoWHO3YD9V487Jp3y4DHFvmx9R2+vnsSXJ0S+SCWsPIvPiZzkcQqZNsj5cj2ZsCDxHy8tvQT5+GCbjgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by HE1PR04MB2955.eurprd04.prod.outlook.com (2603:10a6:7:20::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Thu, 9 Dec
 2021 07:28:59 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::59a0:4185:3e03:7366]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::59a0:4185:3e03:7366%7]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 07:28:59 +0000
Date: Thu, 9 Dec 2021 15:28:59 +0800
From: Geliang Tang <geliang.tang@suse.com>
To: Coly Li <colyli@suse.de>
Cc: nvdimm@lists.linux.dev, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
	Vishal L Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH v3 3/6] badblocks: improvement badblocks_set() for
 multiple ranges handling
Message-ID: <20211209072859.GB26976@dhcp-10-157-36-190>
References: <20211202125245.76699-1-colyli@suse.de>
 <20211202125245.76699-4-colyli@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202125245.76699-4-colyli@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: HK0PR01CA0068.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::32) To HE1PR0402MB3497.eurprd04.prod.outlook.com
 (2603:10a6:7:83::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from localhost (60.251.47.115) by HK0PR01CA0068.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Thu, 9 Dec 2021 07:28:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd4d48f1-9beb-41b7-cf10-08d9bae590f8
X-MS-TrafficTypeDiagnostic: HE1PR04MB2955:EE_
X-Microsoft-Antispam-PRVS:
	<HE1PR04MB2955FD8E0D822A7091872ADAF8709@HE1PR04MB2955.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HzBYm5RG1vqxYXxNOxPk0xGTCi1NZt4E+YKunp3RWI+bcfwtf5unoFO/tmF3DviuNqK4zct9Px+JqY71NdDJec830k7aPxMAxeVKSRwCy9iohFbgYQb7bnRJbWq8ejf7eEMNiKHSm2RnyJPkDcL20Ewgc1s9CIW9c+1cd7GiQSAqttt+ftnA1ADM8wmPrky2xbvuzVklRc+BUfeF8WmQUORKqH2nBrVbjKAdngDhFcrUNnzNrzO7PzllC9tCD1/IB89tK1R8V21LNSuNv4M2cKeuQjg3SY8UnpBIIG+s7hxdv6Ta54RuPGNBCLwSueBntvB6S39s1RFOx/nPdIZ67DfZeannhQp6hSNu/zg/FpLtMjoSJ4v83TAd+LtBHUG5MbgOKyVj3Ev3IPzWNCtAAn8ufnvFzvVto+bhzQRT9VXyfxeIDDfPtf5tfFEmSAFQvWvfGq3dIh8ACACAz92e3Qhfeq7XeF1+oksiiCcuBXGqhPaTkQFKtnRYs21veJb42NiWDMUmuW8TKHNJ60W5hqQAPDHp/8uU/qHJ6iAZf6uwftmuZFwr/l1MuMJwjCvRhgRNDE0A9A8BFfBmCyQCxRj8Ux6o3HoXU2pmuOuZ0W3Z9SPy7Y4xlcDWENrzMXym0yEAmXV+yQ2YjA4MMgBJHg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(4326008)(2906002)(55236004)(33656002)(9686003)(8676002)(83380400001)(66946007)(956004)(66556008)(8936002)(6496006)(508600001)(316002)(54906003)(86362001)(6916009)(44832011)(66476007)(1076003)(6486002)(186003)(5660300002)(33716001)(26005)(38100700002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qL4UHUXqw0VghMhSoncoijWYZvQ3Rve8Y8aQutaROAGpOAVcomL6zyO8zRL4?=
 =?us-ascii?Q?9XgUetHwPr1W+c7TfHGx6UORTk+hzqathUuLiH+8tkZ6eALUETkLExCtxFEZ?=
 =?us-ascii?Q?XhNSGj1IVo32cbJdYq5hxYjt1MbjVRRccfWnfW6YmEly5FzG5izQVs2dmnis?=
 =?us-ascii?Q?X/DpvASC5Pz456oFRzYVCuKtUPNdTMPKyTuy42qv+b4FDf7rRi49NUvce5sd?=
 =?us-ascii?Q?U7ZYu2yMy45DgIoeyzus6eVikubrMO0I74G4m7pScmhLYzNxeviw0nFEBbhg?=
 =?us-ascii?Q?TJIP9NAZcN5cqZaML8F1K71YDu+12TvtrkLgYarQIgq+5wY3jWJO4h/nzl0V?=
 =?us-ascii?Q?Ex7DO+kHWp2VJICWm6o0BrL5vcS10t/uRiUZaJX7DskYwMxqB4YQIxl6wx7o?=
 =?us-ascii?Q?coOOkJmKgzwnrkqCnsQVbvLW9DW4biNxOHGwzHqzmBv4BOHeCeXm4wT2J9PN?=
 =?us-ascii?Q?vC3/cN3AafpAQ/usan2GkZhb4L2A6q2AluQU3A6vBqaVCX5Hco274WV1/9y9?=
 =?us-ascii?Q?F2Evyjs1dmnQevqhM5jjqb7Qp1J2j+OVYhXhlky/UfAC4Nl/d6pnFiUIfcna?=
 =?us-ascii?Q?+woo07G02PZnACKPTeEUaCRRdQ8rIFaeOD2T+MuNHernFAAtpYT3Ask/JhQs?=
 =?us-ascii?Q?E4J5J2v0PIbkSpKWv3yKXwZscOIJ0YgeplnCfPnHXlQDQjxa8QIseKQZmL35?=
 =?us-ascii?Q?1z1q/K9vM+wNVFtYL348sQjeKeeWNJ+W/3HMCQyWTh57fhd/KiupdlzrDgDL?=
 =?us-ascii?Q?ILRQBvF8ugGvFulQQr+1HdTiYo9MtRt6WQooRFxQrsX2S6aHkRVQMm6Zk2ac?=
 =?us-ascii?Q?m3osctBSYvWwHsfAuRvwyX2/KB4HksOF1Tqjz2okFPWjrEGOMUdC8rUCYfL2?=
 =?us-ascii?Q?6/GF982/Ppop+IVg55YLyGwBNYjTDfksuHUsBhL2Cou8qN53speGlTFrX5HG?=
 =?us-ascii?Q?VU8/HUIxx9/aJx4ohtshGSRIzbk6VmGJVSJJYYa9p9yaA986/ysWjo9ThjEu?=
 =?us-ascii?Q?t549OvHEr3s+ryWBweDi0KnUJkXeUPKlZ40r9d1Q7KFR8EM9XqNnHoD45HEk?=
 =?us-ascii?Q?1LvS1hWyflsUMGOlqTHeafnBhfH/TZPCy0qphyUrsJekgG/oq1pVv3ChjAbV?=
 =?us-ascii?Q?1plWvSEj7bVgZO2jauZ3rfA633Ue+pcK0gX9PaeKqafl+e/hJAB4SMQXmA2Z?=
 =?us-ascii?Q?Xlab8XSlZ5E2WJ2qTEPDHxnWFlXGfQIzptl1AkgEhOc3m7UJyHsw3r8NHNac?=
 =?us-ascii?Q?NdymeKcqJdqaqjpO7VWpLdJEMac4r89kKMNFxTsexNAk01DhHjslQO3/gjuT?=
 =?us-ascii?Q?1GdibE0+iX/09RMWUSwDa+QgCwLvFg3zuStbC4GCTaTsJLBcHep/Lf1CwWii?=
 =?us-ascii?Q?IF9yqPiCDz7EmqTgj4FzV7KqHZNamoti1T2bt1E8Q3BFlh2C9aUUKK6lTfe+?=
 =?us-ascii?Q?GRZS9bfWRx2YtuL6NTdHDeY07irTIQVa3PeDOYCqaF5GyTlc+SDHSSU6U/Nk?=
 =?us-ascii?Q?+nrMnL9pzmulfjLz7TGs0l99QW6GQ6GbBnaHtH+ryUIj6QPHKHI+w29SG/bK?=
 =?us-ascii?Q?C5cZ/BxjEeSkVZvsBKixZaO0yH06kdU4JHNqDkofSqWJGzLdomXCFDIobpSe?=
 =?us-ascii?Q?u5hWcFa39Gl3x2T+oS9yRs0=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd4d48f1-9beb-41b7-cf10-08d9bae590f8
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 07:28:59.5695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Nz2vi9ZAWKT9DXnT6IoCceaMNpeftGLYZBp9/4bdHfd1cRxEEbVpLs9KKs5EofHwIV+sbr47+39U0a6rTjxTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR04MB2955

On Thu, Dec 02, 2021 at 08:52:41PM +0800, Coly Li wrote:
> Recently I received a bug report that current badblocks code does not
> properly handle multiple ranges. For example,
>         badblocks_set(bb, 32, 1, true);
>         badblocks_set(bb, 34, 1, true);
>         badblocks_set(bb, 36, 1, true);
>         badblocks_set(bb, 32, 12, true);
> Then indeed badblocks_show() reports,
>         32 3
>         36 1
> But the expected bad blocks table should be,
>         32 12
> Obviously only the first 2 ranges are merged and badblocks_set() returns
> and ignores the rest setting range.
> 
> This behavior is improper, if the caller of badblocks_set() wants to set
> a range of blocks into bad blocks table, all of the blocks in the range
> should be handled even the previous part encountering failure.
> 
> The desired way to set bad blocks range by badblocks_set() is,
> - Set as many as blocks in the setting range into bad blocks table.
> - Merge the bad blocks ranges and occupy as less as slots in the bad
>   blocks table.
> - Fast.
> 
> Indeed the above proposal is complicated, especially with the following
> restrictions,
> - The setting bad blocks range can be ackknowledged or not acknowledged.

ackknowledged -> acknowledged

> - The bad blocks table size is limited.
> - Memory allocation should be avoided.
> 
> The basic idea of the patch is to categorize all possible bad blocks
> range setting combinationsinto to much less simplified and more less
> special conditions. Inside badblocks_set() there is an implicit loop
> composed by jumping between labels 're_insert' and 'update_sectors'. No
> matter how large the setting bad blocks range is, in every loop just a
> minimized range from the head is handled by a pre-defined behavior from
> one of the categorized conditions. The logic is simple and code flow is
> manageable.
> 
> The different relative layout between the setting range and existing bad
> block range are checked and handled (merge, combine, overwrite, insert)
> by the helpers in previous patch. This patch is to make all the helpers
> work together with the above idea.
> 
> This patch only has the algorithm improvement for badblocks_set(). There
> are following patches contain improvement for badblocks_clear() and
> badblocks_check(). But the algorithm in badblocks_set() is fundamental
> and typical, other improvement in clear and check routines are based on
> all the helpers and ideas in this patch.
> 
> In order to make the change to be more clear for code review, this patch
> does not directly modify existing badblocks_set(), and just add a new
> one named _badblocks_set(). Later patch will remove current existing
> badblocks_set() code and make it as a wrapper of _badblocks_set(). So
> the new added change won't be mixed with deleted code, the code review
> can be easier.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Geliang Tang <geliang.tang@suse.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Vishal L Verma <vishal.l.verma@intel.com>
> ---
>  block/badblocks.c | 560 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 540 insertions(+), 20 deletions(-)
> 
> diff --git a/block/badblocks.c b/block/badblocks.c
> index e216c6791b4b..13eaad18be15 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -16,6 +16,322 @@
>  #include <linux/types.h>
>  #include <linux/slab.h>
>  
> +/*
> + * The purpose of badblocks set/clear is to manage bad blocks ranges which are
> + * identified by LBA addresses.
> + *
> + * When the caller of badblocks_set() wants to set a range of bad blocks, the
> + * setting range can be acked or unacked. And the setting range may merge,
> + * overwrite, skip the overlaypped already set range, depends on who they are
> + * overlapped or adjacent, and the acknowledgment type of the ranges. It can be
> + * more complicated when the setting range covers multiple already set bad block
> + * ranges, with restritctions of maximum length of each bad range and the bad
> + * table space limitation.
> + *
> + * It is difficut and unnecessary to take care of all the possible situations,
> + * for setting a large range of bad blocks, we can handle it by dividing the
> + * large range into smaller ones when encounter overlap, max range length or
> + * bad table full conditions. Every time only a smaller piece of the bad range
> + * is handled with a limited number of conditions how it is interacted with
> + * possible overlapped or adjacent already set bad block ranges. Then the hard
> + * complicated problem can be much simpler to habndle in proper way.

habndle -> handle

> + *
> + * When setting a range of bad blocks to the bad table, the simplified situations
> + * to be considered are, (The already set bad blocks ranges are naming with
> + *  prefix E, and the setting bad blocks range is naming with prefix S)
> + *
> + * 1) A setting range is not overlapped or adjacent to any other already set bad
> + *    block range.
> + *                         +--------+
> + *                         |    S   |
> + *                         +--------+
> + *        +-------------+               +-------------+
> + *        |      E1     |               |      E2     |
> + *        +-------------+               +-------------+
> + *    For this situation if the bad blocks table is not full, just allocate a
> + *    free slot from the bad blocks table to mark the setting range S. The
> + *    result is,
> + *        +-------------+  +--------+   +-------------+
> + *        |      E1     |  |    S   |   |      E2     |
> + *        +-------------+  +--------+   +-------------+
> + * 2) A setting range starts exactly at a start LBA of an already set bad blocks
> + *    range.
> + * 2.1) The setting range size < already set range size
> + *        +--------+
> + *        |    S   |
> + *        +--------+
> + *        +-------------+
> + *        |      E      |
> + *        +-------------+
> + * 2.1.1) If S and E are both acked or unacked range, the setting range S can
> + *    be merged into existing bad range E. The result is,
> + *        +-------------+
> + *        |      S      |
> + *        +-------------+
> + * 2.1.2) If S is uncked setting and E is acked, the setting will be denied, and

uncked -> unacked

> + *    the result is,
> + *        +-------------+
> + *        |      E      |
> + *        +-------------+
> + * 2.1.3) If S is acked setting and E is unacked, range S can overwirte on E.
> + *    An extra slot from the bad blocks table will be allocated for S, and head
> + *    of E will move to end of the inserted range E. The result is,

move to end of the inserted range 'S', not 'E'.

> + *        +--------+----+
> + *        |    S   | E  |
> + *        +--------+----+
> + * 2.2) The setting range size == already set range size
> + * 2.2.1) If S and E are both acked or unacked range, the setting range S can
> + *    be merged into existing bad range E. The result is,
> + *        +-------------+
> + *        |      S      |
> + *        +-------------+
> + * 2.2.2) If S is uncked setting and E is acked, the setting will be denied, and

uncked -> unacked

> + *    the result is,
> + *        +-------------+
> + *        |      E      |
> + *        +-------------+
> + * 2.2.3) If S is acked setting and E is unacked, range S can overwirte all of
> +      bad blocks range E. The result is,
> + *        +-------------+
> + *        |      S      |
> + *        +-------------+
> + * 2.3) The setting range size > already set range size
> + *        +-------------------+
> + *        |          S        |
> + *        +-------------------+
> + *        +-------------+
> + *        |      E      |
> + *        +-------------+
> + *    For such situation, the setting range S can be treated as two parts, the
> + *    first part (S1) is as same size as the already set range E, the second
> + *    part (S2) is the rest of setting range.
> + *        +-------------+-----+        +-------------+       +-----+
> + *        |    S1       | S2  |        |     S1      |       | S2  |
> + *        +-------------+-----+  ===>  +-------------+       +-----+
> + *        +-------------+              +-------------+
> + *        |      E      |              |      E      |
> + *        +-------------+              +-------------+
> + *    Now we only focus on how to handle the setting range S1 and already set
> + *    range E, which are already explained in 1.2), for the rest S2 it will be

1.2) -> 2.2)

> + *    handled later in next loop.
> + * 3) A setting range starts before the start LBA of an already set bad blocks
> + *    range.
> + *        +-------------+
> + *        |      S      |
> + *        +-------------+
> + *             +-------------+
> + *             |      E      |
> + *             +-------------+
> + *    For this situation, the setting range S can be divided into two parts, the
> + *    first (S1) ends at the start LBA of already set range E, the second part
> + *    (S2) starts exactly at a start LBA of the already set range E.
> + *        +----+---------+             +----+      +---------+
> + *        | S1 |    S2   |             | S1 |      |    S2   |
> + *        +----+---------+      ===>   +----+      +---------+
> + *             +-------------+                     +-------------+
> + *             |      E      |                     |      E      |
> + *             +-------------+                     +-------------+
> + *    Now only the first part S1 should be handled in this loop, which is in
> + *    similar condition as 1). The rest part S2 has exact same start LBA address
> + *    of the already set range E, they will be handled in next loop in one of
> + *    situations in 2).
> + * 4) A setting range starts after the start LBA of an already set bad blocks
> + *    range.
> + * 4.1) If the setting range S exactly matches the tail part of already set bad
> + *    blocks range E, like the following chart shows,
> + *            +---------+
> + *            |   S     |
> + *            +---------+
> + *        +-------------+
> + *        |      E      |
> + *        +-------------+
> + * 4.1.1) If range S and E have same ackknowledg value (both acked or unacked),

ackknowledg -> acknowledge

> + *    they will be merged into one, the result is,
> + *        +-------------+
> + *        |      S      |
> + *        +-------------+
> + * 4.1.2) If range E is acked and the setting range S is unacked, the setting
> + *    request of S will be rejected, the result is,
> + *        +-------------+
> + *        |      E      |
> + *        +-------------+
> + * 4.1.3) If range E is unacked, and the setting range S is acked, then S may
> + *    overwrite the overlapped range of E, the result is,
> + *        +---+---------+
> + *        | E |    S    |
> + *        +---+---------+
> + * 4.2) If the setting range S stays in middle of an already set range E, like
> + *    the following chart shows,
> + *             +----+
> + *             | S  |
> + *             +----+
> + *        +--------------+
> + *        |       E      |
> + *        +--------------+
> + * 4.2.1) If range S and E have same ackknowledg value (both acked or unacked),

ackknowledg -> acknowledge

> + *    they will be merged into one, the result is,
> + *        +--------------+
> + *        |       S      |
> + *        +--------------+
> + * 4.2.2) If range E is acked and the setting range S is unacked, the setting
> + *    request of S will be rejected, the result is also,
> + *        +--------------+
> + *        |       E      |
> + *        +--------------+
> + * 4.2.3) If range E is unacked, and the setting range S is acked, then S will
> + *    inserted into middle of E and split previous range E into twp parts (E1
> + *    and E2), the result is,
> + *        +----+----+----+
> + *        | E1 |  S | E2 |
> + *        +----+----+----+
> + * 4.3) If the setting bad blocks range S is overlapped with an already set bad
> + *    blocks range E. The range S starts after the start LBA of range E, and
> + *    ends after the end LBA of range E, as the following chart shows,
> + *            +-------------------+
> + *            |          S        |
> + *            +-------------------+
> + *        +-------------+
> + *        |      E      |
> + *        +-------------+
> + *    For this situation the range S can be divided into two parts, the first
> + *    part (S1) ends at end range E, and the second part (S2) has rest range of
> + *    origin S.
> + *            +---------+---------+            +---------+      +---------+
> + *            |    S1   |    S2   |            |    S1   |      |    S2   |
> + *            +---------+---------+  ===>      +---------+      +---------+
> + *        +-------------+                  +-------------+
> + *        |      E      |                  |      E      |
> + *        +-------------+                  +-------------+
> + *     Now in this loop the setting range S1 and already set range E can be
> + *     handled as the situations 4), the rest range S2 will be handled in next
> + *     loop and ignored in this loop.
> + * 5) A setting bad blocks range S is adjacent to one or more already set bad
> + *    blocks range(s), and they are all acked or unacked range.
> + * 5.1) Front merge: If the already set bad blocks range E is before setting
> + *    range S and they are adjacent,
> + *                +------+
> + *                |  S   |
> + *                +------+
> + *        +-------+
> + *        |   E   |
> + *        +-------+
> + * 5.1.1) When total size of range S and E <= BB_MAX_LEN, and their acknowledge
> + *    values are same, the setting range S can front merges into range E. The
> + *    result is,
> + *        +--------------+
> + *        |       S      |
> + *        +--------------+
> + * 5.1.2) Otherwise these two ranges cannot merge, just insert the setting
> + *    range S right after already set range E into the bad blocks table. The
> + *    result is,
> + *        +--------+------+
> + *        |   E    |   S  |
> + *        +--------+------+
> + * 6) Special cases which above conditions cannot handle
> + * 6.1) Multiple already set ranges may merge into less ones in a full bad table
> + *        +-------------------------------------------------------+
> + *        |                           S                           |
> + *        +-------------------------------------------------------+
> + *        |<----- BB_MAX_LEN ----->|
> + *                                 +-----+     +-----+   +-----+
> + *                                 | E1  |     | E2  |   | E3  |
> + *                                 +-----+     +-----+   +-----+
> + *     In the above example, when the bad blocks table is full, inserting the
> + *     first part of setting range S will fail because no more available slot
> + *     can be allocated from bad blocks table. In this situation a proper
> + *     setting method should be go though all the setting bad blocks range and
> + *     look for chance to merge already set ranges into less ones. When there
> + *     is available slot from bad blocks table, re-try again to handle more
> + *     setting bad blocks ranges as many as possible.
> + *        +------------------------+
> + *        |          S3            |
> + *        +------------------------+
> + *        |<----- BB_MAX_LEN ----->|
> + *                                 +-----+-----+-----+---+-----+--+
> + *                                 |       S1        |     S2     |
> + *                                 +-----+-----+-----+---+-----+--+
> + *     The above chart shows although the first part (S3) cannot be inserted due
> + *     to no-space in bad blocks table, but the following E1, E2 and E3 ranges
> + *     can be merged with rest part of S into less range S1 and S2. Now there is
> + *     1 free slot in bad blocks table.
> + *        +------------------------+-----+-----+-----+---+-----+--+
> + *        |           S3           |       S1        |     S2     |
> + *        +------------------------+-----+-----+-----+---+-----+--+
> + *     Since the bad blocks table is not full anymore, re-try again for the
> + *     origin setting range S. Now the setting range S3 can be inserted into the
> + *     bad blocks table with previous freed slot from multiple ranges merge.
> + * 6.2) Front merge after overwrite
> + *    In the following example, in bad blocks table, E1 is an acked bad blocks
> + *    range and E2 is an unacked bad blocks range, therefore they are not able
> + *    to merge into a larger range. The setting bad blocks range S is acked,
> + *    therefore part of E2 can be overwritten by S.
> + *                      +--------+
> + *                      |    S   |                             acknowledged
> + *                      +--------+                         S:       1
> + *              +-------+-------------+                   E1:       1
> + *              |   E1  |    E2       |                   E2:       0
> + *              +-------+-------------+
> + *     With previosu simplified routines, after overwiting part of E2 with S,
> + *     the bad blocks table should be (E3 is remaining part of E2 which is not
> + *     overwritten by S),
> + *                                                             acknowledged
> + *              +-------+--------+----+                    S:       1
> + *              |   E1  |    S   | E3 |                   E1:       1
> + *              +-------+--------+----+                   E3:       0
> + *     The above result is correct but not perfect. Range E1 and S in the bad
> + *     blocks table are all acked, merging them into a larger one range may
> + *     occupy less bad blocks table space and make badblocks_check() faster.
> + *     Therefore in such situation, after overwiting range S, the previous range
> + *     E1 should be checked for possible front combination. Then the ideal
> + *     result can be,
> + *              +----------------+----+                        acknowledged
> + *              |       E1       | E3 |                   E1:       1
> + *              +----------------+----+                   E3:       0
> + * 6.3) Behind merge: If the already set bad blocks range E is behind the setting
> + *    range S and they are adjacent. Normally we don't need to care about this
> + *    because front merge handles this while going though range S from head to
> + *    tail, except for the tail part of range S. When the setting range S are
> + *    fully handled, all the above simplified routine doesn't check whether the
> + *    tail LBA of range S is adjacent to the next already set range and not able
> + *    to them if they are mergeable.
> + *        +------+
> + *        |  S   |
> + *        +------+
> + *               +-------+
> + *               |   E   |
> + *               +-------+
> + *    For the above special stiuation, when the setting range S are all handled
> + *    and the loop ends, an extra check is necessary for whether next already
> + *    set range E is right after S and mergeable.
> + * 6.2.1) When total size of range E and S <= BB_MAX_LEN, and their acknowledge
> + *    values are same, the setting range S can behind merges into range E. The
> + *    result is,
> + *        +--------------+
> + *        |       S      |
> + *        +--------------+
> + * 6.2.2) Otherwise these two ranges cannot merge, just insert the setting range
> + *     S infront of the already set range E in the bad blocks table. The result

infront -> in front

> + *     is,
> + *        +------+-------+
> + *        |  S   |   E   |
> + *        +------+-------+
> + *
> + * All the above 5 simplified situations and 3 special cases may cover 99%+ of
> + * the bad block range setting conditions. Maybe there is some rare corner case
> + * is not considered and optimized, it won't hurt if badblocks_set() fails due
> + * to no space, or some ranges are not merged to save bad blocks table space.
> + *
> + * Inside badblocks_set() each loop starts by jumping to re_insert label, every
> + * time for the new loop prev_badblocks() is called to find an already set range
> + * which starts before or at current setting range. Since the setting bad blocks
> + * range is handled from head to tail, most of the cases it is unnecessary to do
> + * the binary search inside prev_badblocks(), it is possible to provide a hint
> + * to prev_badblocks() for a fast path, then the expensive binary search can be
> + * avoided. In my test with the hint to prev_badblocks(), except for the first
> + * loop, all rested calls to prev_badblocks() can go into the fast path and
> + * return correct bad blocks table index immediately.
> + */
> +
>  /*
>   * Find the range starts at-or-before 's' from bad table. The search
>   * starts from index 'hint' and stops at index 'hint_end' from the bad
> @@ -390,6 +706,230 @@ static int insert_at(struct badblocks *bb, int at, struct badblocks_context *bad
>  	return len;
>  }
>  
> +static void badblocks_update_acked(struct badblocks *bb)
> +{
> +	bool unacked = false;
> +	u64 *p = bb->page;
> +	int i;
> +
> +	if (!bb->unacked_exist)
> +		return;
> +
> +	for (i = 0; i < bb->count ; i++) {
> +		if (!BB_ACK(p[i])) {
> +			unacked = true;
> +			break;
> +		}
> +	}
> +
> +	if (!unacked)
> +		bb->unacked_exist = 0;
> +}
> +
> +/* Do exact work to set bad block range into the bad block table */
> +static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> +			  int acknowledged)
> +{
> +	int retried = 0, space_desired = 0;
> +	int orig_len, len = 0, added = 0;
> +	struct badblocks_context bad;
> +	int prev = -1, hint = -1;
> +	sector_t orig_start;
> +	unsigned long flags;
> +	int rv = 0;
> +	u64 *p;
> +
> +	if (bb->shift < 0)
> +		/* badblocks are disabled */
> +		return 1;
> +
> +	if (sectors == 0)
> +		/* Invalid sectors number */
> +		return 1;
> +
> +	if (bb->shift) {
> +		/* round the start down, and the end up */
> +		sector_t next = s + sectors;
> +
> +		rounddown(s, bb->shift);
> +		roundup(next, bb->shift);
> +		sectors = next - s;
> +	}
> +
> +	write_seqlock_irqsave(&bb->lock, flags);
> +
> +	orig_start = s;
> +	orig_len = sectors;
> +	bad.ack = acknowledged;
> +	p = bb->page;
> +
> +re_insert:
> +	bad.start = s;
> +	bad.len = sectors;
> +	len = 0;
> +
> +	if (badblocks_empty(bb)) {
> +		len = insert_at(bb, 0, &bad);
> +		bb->count++;
> +		added++;
> +		goto update_sectors;
> +	}
> +
> +	prev = prev_badblocks(bb, &bad, hint);
> +
> +	/* start before all badblocks */
> +	if (prev < 0) {
> +		if (!badblocks_full(bb)) {
> +			/* insert on the first */
> +			if (bad.len > (BB_OFFSET(p[0]) - bad.start))
> +				bad.len = BB_OFFSET(p[0]) - bad.start;
> +			len = insert_at(bb, 0, &bad);
> +			bb->count++;
> +			added++;
> +			hint = 0;
> +			goto update_sectors;
> +		}
> +
> +		/* No sapce, try to merge */
> +		if (overlap_behind(bb, &bad, 0)) {
> +			if (can_merge_behind(bb, &bad, 0)) {
> +				len = behind_merge(bb, &bad, 0);
> +				added++;
> +			} else {
> +				len = min_t(sector_t,
> +					    BB_OFFSET(p[0]) - s, sectors);
> +				space_desired = 1;
> +			}
> +			hint = 0;
> +			goto update_sectors;
> +		}
> +
> +		/* no table space and give up */
> +		goto out;
> +	}
> +
> +	/* in case p[prev-1] can be merged with p[prev] */
> +	if (can_combine_front(bb, prev, &bad)) {
> +		front_combine(bb, prev);
> +		bb->count--;
> +		added++;
> +		hint = prev;
> +		goto update_sectors;
> +	}
> +
> +	if (overlap_front(bb, prev, &bad)) {
> +		if (can_merge_front(bb, prev, &bad)) {
> +			len = front_merge(bb, prev, &bad);
> +			added++;
> +		} else {
> +			int extra = 0;
> +
> +			if (!can_front_overwrite(bb, prev, &bad, &extra)) {
> +				len = min_t(sector_t,
> +					    BB_END(p[prev]) - s, sectors);
> +				hint = prev;
> +				goto update_sectors;
> +			}
> +
> +			len = front_overwrite(bb, prev, &bad, extra);
> +			added++;
> +			bb->count += extra;
> +
> +			if (can_combine_front(bb, prev, &bad)) {
> +				front_combine(bb, prev);
> +				bb->count--;
> +			}
> +		}
> +		hint = prev;
> +		goto update_sectors;
> +	}
> +
> +	if (can_merge_front(bb, prev, &bad)) {
> +		len = front_merge(bb, prev, &bad);
> +		added++;
> +		hint = prev;
> +		goto update_sectors;
> +	}
> +
> +	/* if no space in table, still try to merge in the covered range */
> +	if (badblocks_full(bb)) {
> +		/* skip the cannot-merge range */
> +		if (((prev + 1) < bb->count) &&
> +		    overlap_behind(bb, &bad, prev + 1) &&
> +		    ((s + sectors) >= BB_END(p[prev + 1]))) {
> +			len = BB_END(p[prev + 1]) - s;
> +			hint = prev + 1;
> +			goto update_sectors;
> +		}
> +
> +		/* no retry any more */
> +		len = sectors;
> +		space_desired = 1;
> +		hint = -1;
> +		goto update_sectors;
> +	}
> +
> +	/* cannot merge and there is space in bad table */
> +	if ((prev + 1) < bb->count &&
> +	    overlap_behind(bb, &bad, prev + 1))
> +		bad.len = min_t(sector_t,
> +				bad.len, BB_OFFSET(p[prev + 1]) - bad.start);
> +
> +	len = insert_at(bb, prev + 1, &bad);
> +	bb->count++;
> +	added++;
> +	hint = prev + 1;
> +
> +update_sectors:
> +	s += len;
> +	sectors -= len;
> +
> +	if (sectors > 0)
> +		goto re_insert;
> +
> +	WARN_ON(sectors < 0);
> +
> +	/* Check whether the following already set range can be merged */
> +	if ((prev + 1) < bb->count &&
> +	    BB_END(p[prev]) == BB_OFFSET(p[prev + 1]) &&
> +	    (BB_LEN(p[prev]) + BB_LEN(p[prev + 1])) <= BB_MAX_LEN &&
> +	    BB_ACK(p[prev]) == BB_ACK(p[prev + 1])) {
> +		p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +				  BB_LEN(p[prev]) + BB_LEN(p[prev + 1]),
> +				  BB_ACK(p[prev]));
> +
> +		if ((prev + 2) < bb->count)
> +			memmove(p + prev + 1, p + prev + 2,
> +				(bb->count -  (prev + 2)) * 8);
> +		bb->count--;
> +	}
> +
> +	if (space_desired && !badblocks_full(bb)) {
> +		s = orig_start;
> +		sectors = orig_len;
> +		space_desired = 0;
> +		if (retried++ < 3)
> +			goto re_insert;
> +	}
> +
> +out:
> +	if (added) {
> +		set_changed(bb);
> +
> +		if (!acknowledged)
> +			bb->unacked_exist = 1;
> +		else
> +			badblocks_update_acked(bb);
> +	}
> +
> +	write_sequnlock_irqrestore(&bb->lock, flags);
> +
> +	if (!added)
> +		rv = 1;
> +
> +	return rv;
> +}
> +
>  /**
>   * badblocks_check() - check a given range for bad sectors
>   * @bb:		the badblocks structure that holds all badblock information
> @@ -499,26 +1039,6 @@ int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>  }
>  EXPORT_SYMBOL_GPL(badblocks_check);
>  
> -static void badblocks_update_acked(struct badblocks *bb)
> -{
> -	u64 *p = bb->page;
> -	int i;
> -	bool unacked = false;
> -
> -	if (!bb->unacked_exist)
> -		return;
> -
> -	for (i = 0; i < bb->count ; i++) {
> -		if (!BB_ACK(p[i])) {
> -			unacked = true;
> -			break;
> -		}
> -	}
> -
> -	if (!unacked)
> -		bb->unacked_exist = 0;
> -}
> -
>  /**
>   * badblocks_set() - Add a range of bad blocks to the table.
>   * @bb:		the badblocks structure that holds all badblock information
> -- 
> 2.31.1
> 

