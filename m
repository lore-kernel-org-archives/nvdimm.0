Return-Path: <SRS0=+foX=FN=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD5BC4361B
	for <linux-nvdimm@archiver.kernel.org>; Wed,  9 Dec 2020 11:06:02 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CD83E2336F
	for <linux-nvdimm@archiver.kernel.org>; Wed,  9 Dec 2020 11:06:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD83E2336F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 9DAEE100EBBB7;
	Wed,  9 Dec 2020 03:06:01 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=156.151.31.86; helo=userp2130.oracle.com; envelope-from=joao.m.martins@oracle.com; receiver=<UNKNOWN> 
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C5883100EBBB4
	for <linux-nvdimm@lists.01.org>; Wed,  9 Dec 2020 03:05:56 -0800 (PST)
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9B54fr011182;
	Wed, 9 Dec 2020 11:05:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4Rx8Zow8VgTjl2LNtMGT6k1EpzTumqcLQhFi0+zC5xQ=;
 b=n421yIl7E7B9trY2ZFfm35iwnEBqfMiw03ZPLBBpnNbTuC3ZRXtrje+J94fibf4vdpt6
 EvwzfhHvQ+ltN0AKoVDRVq2A53OKuda/TflS0AXP/qLh0Cl+fdwFr1Pf0GOe6VGmif1D
 Kd4v4esj8WpGH+6Wg74qmV2ag55DFHiwJEts3hkfXd2P9zgNG7GSo9Yr4U1CWZz/G58C
 oK7MZRmraH+YYQKdz4KoDgngj8knStngK7ZBH8JCtvd1GJKV41eBb/ZTqZ5NgLseB2gJ
 0nFOhoPcKonS3U55Das6wWGnzCd0a68cymSSZ1zCZSw5KmnIIdzExpXxxBLJDVlVhXS+ lA==
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 3581mqyg7b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 09 Dec 2020 11:05:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9B5l45128013;
	Wed, 9 Dec 2020 11:05:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by userp3030.oracle.com with ESMTP id 358m50cnev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Dec 2020 11:05:48 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
	by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B9B5hvr003656;
	Wed, 9 Dec 2020 11:05:43 GMT
Received: from [10.175.160.66] (/10.175.160.66)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Wed, 09 Dec 2020 03:05:43 -0800
Subject: Re: [PATCH RFC 6/9] mm/gup: Grab head page refcount once for group of
 subpages
To: Jason Gunthorpe <jgg@ziepe.ca>
References: <20201208172901.17384-1-joao.m.martins@oracle.com>
 <20201208172901.17384-8-joao.m.martins@oracle.com>
 <20201208194905.GQ5487@ziepe.ca>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <b7f5fe44-f2f5-aea6-57b3-7e14a9ef624d@oracle.com>
Date: Wed, 9 Dec 2020 11:05:39 +0000
MIME-Version: 1.0
In-Reply-To: <20201208194905.GQ5487@ziepe.ca>
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090077
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090077
Message-ID-Hash: ZDLCA7TW6BKVQXDRZ74JXAFBSYGPW7Q7
X-Message-ID-Hash: ZDLCA7TW6BKVQXDRZ74JXAFBSYGPW7Q7
X-MailFrom: joao.m.martins@oracle.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-mm@kvack.org, linux-nvdimm@lists.01.org, Matthew Wilcox <willy@infradead.org>, Muchun Song <songmuchun@bytedance.com>, Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ZDLCA7TW6BKVQXDRZ74JXAFBSYGPW7Q7/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 12/8/20 7:49 PM, Jason Gunthorpe wrote:
> On Tue, Dec 08, 2020 at 05:28:58PM +0000, Joao Martins wrote:
>> Much like hugetlbfs or THPs, we treat device pagemaps with
>> compound pages like the rest of GUP handling of compound pages.
>>
>> Rather than incrementing the refcount every 4K, we record
>> all sub pages and increment by @refs amount *once*.
>>
>> Performance measured by gup_benchmark improves considerably
>> get_user_pages_fast() and pin_user_pages_fast():
>>
>>  $ gup_benchmark -f /dev/dax0.2 -m 16384 -r 10 -S [-u,-a] -n 512 -w
>>
>> (get_user_pages_fast 2M pages) ~75k us -> ~3.6k us
>> (pin_user_pages_fast 2M pages) ~125k us -> ~3.8k us
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>  mm/gup.c | 67 ++++++++++++++++++++++++++++++++++++++++++--------------
>>  1 file changed, 51 insertions(+), 16 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 98eb8e6d2609..194e6981eb03 100644
>> +++ b/mm/gup.c
>> @@ -2250,22 +2250,68 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
>>  }
>>  #endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
>>  
>> +
>> +static int record_subpages(struct page *page, unsigned long addr,
>> +			   unsigned long end, struct page **pages)
>> +{
>> +	int nr;
>> +
>> +	for (nr = 0; addr != end; addr += PAGE_SIZE)
>> +		pages[nr++] = page++;
>> +
>> +	return nr;
>> +}
>> +
>>  #if defined(CONFIG_ARCH_HAS_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
>> -static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>> -			     unsigned long end, unsigned int flags,
>> -			     struct page **pages, int *nr)
>> +static int __gup_device_compound_huge(struct dev_pagemap *pgmap,
>> +				      struct page *head, unsigned long sz,
>> +				      unsigned long addr, unsigned long end,
>> +				      unsigned int flags, struct page **pages)
>> +{
>> +	struct page *page;
>> +	int refs;
>> +
>> +	if (!(pgmap->flags & PGMAP_COMPOUND))
>> +		return -1;
>> +
>> +	page = head + ((addr & (sz-1)) >> PAGE_SHIFT);
> 
> All the places that call record_subpages do some kind of maths like
> this, it should be placed inside record_subpages and not opencoded
> everywhere.
> 
Makes sense.

>> +	refs = record_subpages(page, addr, end, pages);
>> +
>> +	SetPageReferenced(page);
>> +	head = try_grab_compound_head(head, refs, flags);
>> +	if (!head) {
>> +		ClearPageReferenced(page);
>> +		return 0;
>> +	}
>> +
>> +	return refs;
>> +}
> 
> Why is all of this special? Any time we see a PMD/PGD/etc pointing to
> PFN we can apply this optimization. How come device has its own
> special path to do this?? 
> 
I think the reason is that zone_device struct pages have no relationship to one other. So
you anyways need to change individual pages, as opposed to just the head page.

I made it special to avoid breaking other ZONE_DEVICE users (and gating that with
PGMAP_COMPOUND). But if there's no concerns with that, I can unilaterally enable it.

> Why do we need to check PGMAP_COMPOUND? Why do we need to get pgmap?
> (We already removed that from the hmm version of this, was that wrong?
> Is this different?) Dan?
> 
> Also undo_dev_pagemap() is now out of date, we have unpin_user_pages()
> for that and no other error unwind touches ClearPageReferenced..
> 
/me nods Yeap I saw that too.

> Basic idea is good though!
> 
Cool, thanks!

	Joao
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
