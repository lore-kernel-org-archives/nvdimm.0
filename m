Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D89D173
	for <nvdimm@lists.linux.dev>; Thu,  9 Dec 2021 07:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
	t=1639035356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+JWukVL2z1sWGZlkxKi5C9oZWtcnXW6nnT19hv5ZfaQ=;
	b=TA6jo/asICnNBzBhyIxbUmfHqrIpaYbhqwMS6Q4SSoePxnco1eyA+vy5fxF3LmXk46f2SB
	1XQY9H0dTzhWZ9B7i5uwwOU4iaitlHJ7McgoR3uMQW7G3nKyQ7TB869POJd83WKJc0BoFm
	PrJGXIhZaRT32axhxkxQMKgJAm0rYKk=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2050.outbound.protection.outlook.com [104.47.6.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-24-tGGafLcxOeWPTzB5fg_IjQ-1; Thu, 09 Dec 2021 08:35:55 +0100
X-MC-Unique: tGGafLcxOeWPTzB5fg_IjQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTf4tsOfUgNJmWZgzAvtDtGf9IegQdekmtsyBeSpRViGYTDvA08JV5k8xXqg9lJEZCRTWbvl3ZGqFMvs3Qm5wsZKSJftg20g2Kt7QoExdvBMH1OfFKZ+l0pMJ6pcMmCFJ4s0fXZe+KFJxKFUoS7fen6t35jPu55qhnTWNKtSL68gGWcEmVwG+Xl34JGEGPmpryqTQf3s+pez3aBu4zNhnuX5xWnt5NOd22ERt1MXXtCmA93gVjgf0ISWssqHs2/8cmq1d9LW+OWNbIkjFl64oHKrR7mvlBtVyzl97q0Wzc0ztCnaLVa0FLFW8Gr/dqIJ/QPGTb57AssOibKHyhmsnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+JWukVL2z1sWGZlkxKi5C9oZWtcnXW6nnT19hv5ZfaQ=;
 b=DqFLLbTv3R6TLkODu7WTHN1ld++2wJE1RezDQLN5FkilPTK5cqIndv2vtqJJJRygYT2GvHv7yjmNIwxxI9vWwGIj/80Hv4EBh8qi2kKW72zAY76t59ULG6+FkhiGmcx/goXw+5L/qEpiPAQgdzmc/Ea5Gas2IvGPdgzvgWDr/qp0VJlMFdcSl6vLt52OkSO/IaXU/H4jMDMVvF7uf61VhaFi0RsGg07lYbTPsTcyegN+2pzt/g3FIIrJnLBaEkThI/CX3uV2kgxVGmuZahlQ9xSUHMziTeW4ds24cg5Zu+TSIiyvEd8+Vu25uKAkPu9ciYRv3EPxwHv5HW7K2giltw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by HE1PR0402MB3515.eurprd04.prod.outlook.com (2603:10a6:7:8e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Thu, 9 Dec
 2021 07:35:51 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::59a0:4185:3e03:7366]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::59a0:4185:3e03:7366%7]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 07:35:51 +0000
Date: Thu, 9 Dec 2021 15:35:51 +0800
From: Geliang Tang <geliang.tang@suse.com>
To: Coly Li <colyli@suse.de>
Cc: nvdimm@lists.linux.dev, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
	Vishal L Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH v3 4/6] badblocks: improve badblocks_clear() for multiple
 ranges handling
Message-ID: <20211209073551.GC26976@dhcp-10-157-36-190>
References: <20211202125245.76699-1-colyli@suse.de>
 <20211202125245.76699-5-colyli@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202125245.76699-5-colyli@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: HK0PR03CA0119.apcprd03.prod.outlook.com
 (2603:1096:203:b0::35) To HE1PR0402MB3497.eurprd04.prod.outlook.com
 (2603:10a6:7:83::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from localhost (60.251.47.115) by HK0PR03CA0119.apcprd03.prod.outlook.com (2603:1096:203:b0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 07:35:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66de4676-cf43-4a2b-c8c6-08d9bae68693
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3515:EE_
X-Microsoft-Antispam-PRVS:
	<HE1PR0402MB351565403B7172AED36594ECF8709@HE1PR0402MB3515.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7Cjn7qEENjO4gZmyo82hXizlFULMxM0GqrxUCEZvcpYw3CeQnQUgE9c1Dqs9GlJZTceAhHmcTAY7MQmp8tCnNwBkR3Jdyh8UDbBl9DINWYcrcdqENq9jTfcl4yKHif055hPTgaBscwXqHYoC0652rdZtC2olwIYJ2XrbJ09i28A0DzXFDvDzLOksDIVGFi28XUZFLonNLq1s/7jwSpAAyH/BQQGa/ysGZ/vHoT0e7IK8OsCMQFvjXIgNz/ggqvAACBhw8fEpqdSsiWLZfoSO2eiy07lcVph9UUWD4Xw4QjPqwlM5W98DzGKUBWwlHsJ6A+k6jaYfXna43j5VlbSKxovZ0M9krfkhBGRjZrKCYrWjef1vxGLDLXFr6xFO8l6zHp8jMlU6SllFI+MYNWR1MDXhp+tQZfSOAPu+GtUdzrxLPOIW3zvQ6pcGbnN+3CoGGwnX1VqQFObzVQu8qY1DKQ7shEYg0xu3l2tea3ybEazSsj/RYlNaruOGYnmcIXVegKs2KgPbQQCab17Fk3/WSss0kLyOnOCRJNC98vw6kGqG61b95Vdtw1IIUJmE0Xu8tc5FwGoMi39/sV/py2QluytinptlrvlX1jk541LCjB4kQJ9HcifR37AjM9p1ru9PKFYcDMMbTgnD0DXvjwJEHg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(1076003)(9686003)(8936002)(33716001)(8676002)(316002)(6486002)(54906003)(66476007)(26005)(38100700002)(66946007)(33656002)(6916009)(30864003)(2906002)(86362001)(66556008)(83380400001)(186003)(956004)(4326008)(508600001)(5660300002)(55236004)(6496006)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kVIX6cAcktKc7pgT5alPYFuR2sk1CnKIjHrX6WEBL0uz6zEZHYQf+MUyjYpG?=
 =?us-ascii?Q?CoJa2Y9scHvRcnQiGFRM/Jfo7w+S/7ynO/SghZb7/lr5B7rFC5loiBNN86EN?=
 =?us-ascii?Q?4jgmd024d/8fSnxwC6/L3VwrUuUNHRKFeL81jwGK/bY7EBYcrp2qxTOMuQ1Q?=
 =?us-ascii?Q?YU5tUAhKOCMoRb9TtvVtQ3MGf/ShjVg0fDq4XoUHDxv6NGdOGePGxoWiMix0?=
 =?us-ascii?Q?Tm+Z4UAgP5sMIfuc/6kU/JkK5YpnCWKak/cTICLHtTz1YFpUIEQ9DxXH3QZP?=
 =?us-ascii?Q?hnL5sWTQmdGJZObUNVTuiqM2FtjbUNr+haN6SoFgo3cm0jjhtL/eSUPoWK14?=
 =?us-ascii?Q?nFoB7Dh9TeH9gfSxnJYylPDSzxmMNqX14Tn8Grxd/4NmPdt3kUltvIysPeWQ?=
 =?us-ascii?Q?h31mYVN1atEdh+k+VI/BQlPn2kXhR6+nz2eHE/AymOfJ0zXEjy/Tcnbflwpv?=
 =?us-ascii?Q?zKZb6ztUmLq+1Vu2fsPadDtg3SmtVJ3U1Fz1VDAtVclxLhC3TgJs60UxBJ83?=
 =?us-ascii?Q?I8m0B04ZOHpEwR/sfZisx1DVat63fabNGc1pZ/Ujxqj/SMPKRml2RcfM61qB?=
 =?us-ascii?Q?bJtN7MuKlsARNFbsx6jz0y61B+OxNaLaIUsIFrT5q4HG0GkCXvL+lSF74GuG?=
 =?us-ascii?Q?yCRiRg4tnzK18JF5AX1ITJQ8DjiB5a1xnbFENgg2JIST+eP1ZZ1+6D3WOmyP?=
 =?us-ascii?Q?yH6xfiICHdXqZk/EnaWLcxnmn3jiv0q4kPKkqe/4wOs9Wz8+DPC9kgK3pZM6?=
 =?us-ascii?Q?t1L/KYUKP5Mc7DzJxGy9710ptD31O6xVAeYV9psjv3G8Kh/k+fTceqgJA7e5?=
 =?us-ascii?Q?oPCTt3NhsvNTMx/LQD4nlUR4+/neWCHzjmxI7Uh85vSXurJS7VU5q0Hg2CJ3?=
 =?us-ascii?Q?thKwbu8c7b0tDp+FnB+BE8mFaNnKB/MaHXGs4q46Hde0Pl345EuxqV6vaadz?=
 =?us-ascii?Q?aSbC+4moock5t2/dxEYPpD5lCKB9wifjNX7dScplwA5Zq2bRkaTlzY8H7KVK?=
 =?us-ascii?Q?Biv6a+QO8X4i3tOyMGS+8iDrCzEWOHz1OpsgmPJDoYNl1+jhUgax0Y1Vif0W?=
 =?us-ascii?Q?3Gi8cPm82LKfQoKvWJqr1WGvBpp534ccmV3rQv/UlLm9X9PAcrLAlPzFc6ar?=
 =?us-ascii?Q?692INwekzrnzjQ7SEnYc12hlTPAVE4aXHu5YtlBOZ5qaZrtOU6+09AWf/QeA?=
 =?us-ascii?Q?CwPNZBabBcGK3mtcknYt1eqNFjNkLV3D2g8gXISoqFAyx9KEsBqBMQo0CUhX?=
 =?us-ascii?Q?2YgGezzQ+HNDXYW491Mo2qCx6+v7AJbIoWw+HwP0aG+0uPKm3+tqVWKNGYEy?=
 =?us-ascii?Q?GRmJwJM0Ylz2zFN+UwZBbbT+y7j4F83X+D/I/19nqD0r9CEaNr8B4BhGcM+M?=
 =?us-ascii?Q?Uje0NzxcW4WdUOuwTysI21kHLz2p6Jk0S8l+iFB2Oax+6Boi1EEGTghupvQg?=
 =?us-ascii?Q?fLXLkzHNqarBuhB2CpevxDe4cLPhy93iHSZS1+T4m2T1wp73TgTff53Lkpew?=
 =?us-ascii?Q?jobV+2vAx1RsvlNlZOiPFtXc4uvtTrv3D84XhZDMcezFXJ5tnl1DD1wwzUkX?=
 =?us-ascii?Q?JkvkOYQ/OoY8Wdob+Pr7PkVClzI2rRPRxnnBZG/GICtl+6CMP+KwvVPbTYfS?=
 =?us-ascii?Q?AJ6T7oCde3S5nZoyRSh6ReE=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66de4676-cf43-4a2b-c8c6-08d9bae68693
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 07:35:51.6450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hYPfHHdyQrzsuUlZBm8mBdhlNrI1Wz1YTrPhBSpRHQzgRipnGu2uU2rIYsxuJ5UH18gqt571ooVBYI8aYgVuUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3515

On Thu, Dec 02, 2021 at 08:52:42PM +0800, Coly Li wrote:
> With the foundamental ideas and helper routines from badblocks_set()
> improvement, clearing bad block for multiple ranges is much simpler.
> 
> With a similar idea from badblocks_set() improvement, this patch
> simplifies bad block range clearing into 5 situations. No matter how
> complicated the clearing condition is, we just look at the head part
> of clearing range with relative already set bad block range from the
> bad block table. The rested part will be handled in next run of the
> while-loop.
> 
> Based on existing helpers added from badblocks_set(), this patch adds
> two more helpers,
> - front_clear()
>   Clear the bad block range from bad block table which is front
>   overlapped with the clearing range.
> - front_splitting_clear()
>   Handle the condition that the clearing range hits middle of an
>   already set bad block range from bad block table.
> 
> Similar as badblocks_set(), the first part of clearing range is handled
> with relative bad block range which is find by prev_badblocks(). In most
> cases a valid hint is provided to prev_badblocks() to avoid unnecessary
> bad block table iteration.
> 
> This patch also explains the detail algorithm code comments at beginning
> of badblocks.c, including which five simplified situations are categried
> and how all the bad block range clearing conditions are handled by these
> five situations.
> 
> Again, in order to make the code review easier and avoid the code
> changes mixed together, this patch does not modify badblock_clear() and
> implement another routine called _badblock_clear() for the improvement.
> Later patch will delete current code of badblock_clear() and make it as
> a wrapper to _badblock_clear(), so the code change can be much clear for
> review.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Geliang Tang <geliang.tang@suse.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Vishal L Verma <vishal.l.verma@intel.com>
> ---
>  block/badblocks.c | 325 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 325 insertions(+)
> 
> diff --git a/block/badblocks.c b/block/badblocks.c
> index 13eaad18be15..c188b2e98140 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -330,6 +330,123 @@
>   * avoided. In my test with the hint to prev_badblocks(), except for the first
>   * loop, all rested calls to prev_badblocks() can go into the fast path and
>   * return correct bad blocks table index immediately.
> + *
> + *
> + * Clearing a bad blocks range from the bad block table has similar idea as
> + * setting does, but much more simpler. The only thing needs to be noticed is
> + * when the clearning range hits middle of a bad block range, the existing bad

clearning -> clearing

> + * block range will split into two, and one more item should be added into the
> + * bad block table. The simplified situations to beconsidered are, (The already

beconsidered -> be considered

> + * set bad blocks ranges in bad block table are naming with prefix E, and the
> + * clearing bad blocks range is naming with prefix C)
> + *
> + * 1) A clearing range is not overlapped to any already set ranges in bad block
> + *    table.
> + *    +-----+         |          +-----+         |          +-----+
> + *    |  C  |         |          |  C  |         |          |  C  |
> + *    +-----+         or         +-----+         or         +-----+
> + *            +---+   |   +----+         +----+  |  +---+
> + *            | E |   |   | E1 |         | E2 |  |  | E |
> + *            +---+   |   +----+         +----+  |  +---+
> + *    For the above situations, no bad block to be cleared and no failure
> + *    happens, simply returns 0.
> + * 2) The clearing range hits middle of an already setting bad blocks range in
> + *    the bad block table.
> + *            +---+
> + *            | C |
> + *            +---+
> + *     +-----------------+
> + *     |         E       |
> + *     +-----------------+
> + *    In this situation if the bad block table is not full, the range E will be
> + *    split into two ranges E1 and E2. The result is,
> + *     +------+   +------+
> + *     |  E1  |   |  E2  |
> + *     +------+   +------+
> + * 3) The clearing range starts exactly at same LBA as an already set bad block range
> + *    from the bad block table.
> + * 3.1) Partially covered at head part
> + *         +------------+
> + *         |     C      |
> + *         +------------+
> + *         +-----------------+
> + *         |         E       |
> + *         +-----------------+
> + *    For this situation, the overlapped already set range will update the
> + *    start LBA to end of C and shrink the range to BB_LEN(E) - BB_LEN(C). No
> + *    item deleted from bad block table. The result is,
> + *                      +----+
> + *                      | E1 |
> + *                      +----+
> + * 3.2) Exact fully covered
> + *         +-----------------+
> + *         |         C       |
> + *         +-----------------+
> + *         +-----------------+
> + *         |         E       |
> + *         +-----------------+
> + *    For this situation the whole bad blocks range E will be cleared and its
> + *    corresponded item is deleted from the bad block table.
> + * 4) The clearing range exactly ends at same LBA as an already set bad block
> + *    range.
> + *                   +-------+
> + *                   |   C   |
> + *                   +-------+
> + *         +-----------------+
> + *         |         E       |
> + *         +-----------------+
> + *    For the above situation, the already set range E is updated to shrink its
> + *    end to the start of C, and reduce its length to BB_LEN(E) - BB_LEN(C).
> + *    The result is,
> + *         +---------+
> + *         |    E    |
> + *         +---------+
> + * 5) The clearing range is partially overlapped with an already set bad block
> + *    range from the bad block table.
> + * 5.1) The already set bad block range is front overlapped with the clearing
> + *    range.
> + *         +----------+
> + *         |     C    |
> + *         +----------+
> + *              +------------+
> + *              |      E     |
> + *              +------------+
> + *   For such situation, the clearing range C can be treated as two parts. The
> + *   first part ends at the start LBA of range E, and the second part starts at
> + *   same LBA of range E.
> + *         +----+-----+               +----+   +-----+
> + *         | C1 | C2  |               | C1 |   | C2  |
> + *         +----+-----+         ===>  +----+   +-----+
> + *              +------------+                 +------------+
> + *              |      E     |                 |      E     |
> + *              +------------+                 +------------+
> + *   Now the first part C1 can be handled as condition 1), and the second part C2 can be
> + *   handled as condition 3.1) in next loop.
> + * 5.2) The already set bad block range is behind overlaopped with the clearing
> + *   range.
> + *                 +----------+
> + *                 |     C    |
> + *                 +----------+
> + *         +------------+
> + *         |      E     |
> + *         +------------+
> + *   For such situation, the clearing range C can be treated as two parts. The
> + *   first part C1 ends at same end LBA of range E, and the second part starts
> + *   at end LBA of range E.
> + *                 +----+-----+                 +----+    +-----+
> + *                 | C1 | C2  |                 | C1 |    | C2  |
> + *                 +----+-----+  ===>           +----+    +-----+
> + *         +------------+               +------------+
> + *         |      E     |               |      E     |
> + *         +------------+               +------------+
> + *   Now the first part clearing range C1 can be handled as condition 4), and
> + *   the second part clearing range C2 can be handled as condition 1) in next
> + *   loop.
> + *
> + *   All bad blocks range clearing can be simplified into the above 5 situations
> + *   by only handling the head part of the clearing range in each run of the
> + *   while-loop. The idea is similar to bad blocks range setting but much
> + *   simpler.
>   */
>  
>  /*
> @@ -930,6 +1047,214 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>  	return rv;
>  }
>  
> +/*
> + * Clear the bad block range from bad block table which is front overlapped
> + * with the clearing range. The return value is how many sectors from an
> + * already set bad block range are cleared. If the whole bad block range is
> + * covered by the clearing range and fully cleared, 'delete' is set as 1 for
> + * the caller to reduce bb->count.
> + */
> +static int front_clear(struct badblocks *bb, int prev,
> +		       struct badblocks_context *bad, int *deleted)
> +{
> +	sector_t sectors = bad->len;
> +	sector_t s = bad->start;
> +	u64 *p = bb->page;
> +	int cleared = 0;
> +
> +	*deleted = 0;
> +	if (s == BB_OFFSET(p[prev])) {
> +		if (BB_LEN(p[prev]) > sectors) {
> +			p[prev] = BB_MAKE(BB_OFFSET(p[prev]) + sectors,
> +					  BB_LEN(p[prev]) - sectors,
> +					  BB_ACK(p[prev]));
> +			cleared = sectors;
> +		} else {
> +			/* BB_LEN(p[prev]) <= sectors */
> +			cleared = BB_LEN(p[prev]);
> +			if ((prev + 1) < bb->count)
> +				memmove(p + prev, p + prev + 1,
> +				       (bb->count - prev - 1) * 8);
> +			*deleted = 1;
> +		}
> +	} else if (s > BB_OFFSET(p[prev])) {
> +		if (BB_END(p[prev]) <= (s + sectors)) {
> +			cleared = BB_END(p[prev]) - s;
> +			p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +					  s - BB_OFFSET(p[prev]),
> +					  BB_ACK(p[prev]));
> +		} else {
> +			/* Splitting is handled in front_splitting_clear() */
> +			BUG();
> +		}
> +	}
> +
> +	return cleared;
> +}
> +
> +/*
> + * Handle the condition that the clearing range hits middle of an already set
> + * bad block range from bad block table. In this condition the existing bad
> + * block range is split into two after the middle part is cleared.
> + */
> +static int front_splitting_clear(struct badblocks *bb, int prev,
> +				  struct badblocks_context *bad)
> +{
> +	u64 *p = bb->page;
> +	u64 end = BB_END(p[prev]);
> +	int ack = BB_ACK(p[prev]);
> +	sector_t sectors = bad->len;
> +	sector_t s = bad->start;
> +
> +	p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +			  s - BB_OFFSET(p[prev]),
> +			  ack);
> +	memmove(p + prev + 2, p + prev + 1, (bb->count - prev - 1) * 8);
> +	p[prev + 1] = BB_MAKE(s + sectors, end - s - sectors, ack);
> +	return sectors;
> +}
> +
> +/* Do the exact work to clear bad block range from the bad block table */
> +static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
> +{
> +	struct badblocks_context bad;
> +	int prev = -1, hint = -1;
> +	int len = 0, cleared = 0;
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
> +		sector_t target;
> +
> +		/* When clearing we round the start up and the end down.
> +		 * This should not matter as the shift should align with
> +		 * the block size and no rounding should ever be needed.
> +		 * However it is better the think a block is bad when it
> +		 * isn't than to think a block is not bad when it is.
> +		 */
> +		target = s + sectors;
> +		roundup(s, bb->shift);
> +		rounddown(target, bb->shift);
> +		sectors = target - s;
> +	}
> +
> +	write_seqlock_irq(&bb->lock);
> +
> +	bad.ack = true;
> +	p = bb->page;
> +
> +re_clear:
> +	bad.start = s;
> +	bad.len = sectors;
> +
> +	if (badblocks_empty(bb)) {
> +		len = sectors;
> +		cleared++;
> +		goto update_sectors;
> +	}
> +
> +

This duplicate empty line can be dropped.

Thanks,
-Geliang

> +	prev = prev_badblocks(bb, &bad, hint);
> +
> +	/* Start before all badblocks */
> +	if (prev < 0) {
> +		if (overlap_behind(bb, &bad, 0)) {
> +			len = BB_OFFSET(p[0]) - s;
> +			hint = prev;
> +		} else {
> +			len = sectors;
> +		}
> +		/*
> +		 * Both situations are to clear non-bad range,
> +		 * should be treated as successful
> +		 */
> +		cleared++;
> +		goto update_sectors;
> +	}
> +
> +	/* Start after all badblocks */
> +	if ((prev + 1) >= bb->count && !overlap_front(bb, prev, &bad)) {
> +		len = sectors;
> +		cleared++;
> +		goto update_sectors;
> +	}
> +
> +	/* Clear will split a bad record but the table is full */
> +	if (badblocks_full(bb) && (BB_OFFSET(p[prev]) < bad.start) &&
> +	    (BB_END(p[prev]) > (bad.start + sectors))) {
> +		len = sectors;
> +		goto update_sectors;
> +	}
> +
> +	if (overlap_front(bb, prev, &bad)) {
> +		if ((BB_OFFSET(p[prev]) < bad.start) &&
> +		    (BB_END(p[prev]) > (bad.start + bad.len))) {
> +			/* Splitting */
> +			if ((bb->count + 1) < MAX_BADBLOCKS) {
> +				len = front_splitting_clear(bb, prev, &bad);
> +				bb->count += 1;
> +				cleared++;
> +			} else {
> +				/* No space to split, give up */
> +				len = sectors;
> +			}
> +		} else {
> +			int deleted = 0;
> +
> +			len = front_clear(bb, prev, &bad, &deleted);
> +			bb->count -= deleted;
> +			cleared++;
> +			hint = prev;
> +		}
> +
> +		goto update_sectors;
> +	}
> +
> +	/* Not front overlap, but behind overlap */
> +	if ((prev + 1) < bb->count && overlap_behind(bb, &bad, prev + 1)) {
> +		len = BB_OFFSET(p[prev + 1]) - bad.start;
> +		hint = prev + 1;
> +		/* Clear non-bad range should be treated as successful */
> +		cleared++;
> +		goto update_sectors;
> +	}
> +
> +	/* Not cover any badblocks range in the table */
> +	len = sectors;
> +	/* Clear non-bad range should be treated as successful */
> +	cleared++;
> +
> +update_sectors:
> +	s += len;
> +	sectors -= len;
> +
> +	if (sectors > 0)
> +		goto re_clear;
> +
> +	WARN_ON(sectors < 0);
> +
> +	if (cleared) {
> +		badblocks_update_acked(bb);
> +		set_changed(bb);
> +	}
> +
> +	write_sequnlock_irq(&bb->lock);
> +
> +	if (!cleared)
> +		rv = 1;
> +
> +	return rv;
> +}
> +
> +
>  /**
>   * badblocks_check() - check a given range for bad sectors
>   * @bb:		the badblocks structure that holds all badblock information
> -- 
> 2.31.1
> 

