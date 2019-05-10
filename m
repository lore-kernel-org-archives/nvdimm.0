Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH, RFC 2/2] Implement sharing/unsharing of PMDs for FS/DAX
References: <1557417933-15701-1-git-send-email-larry.bassel@oracle.com>
 <1557417933-15701-3-git-send-email-larry.bassel@oracle.com>
 <20190509164914.GA3862@bombadil.infradead.org>
 <20190510161607.GB27674@ubuette>
From: Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <af218b46-ece3-1189-e43c-209ec5cf1022@oracle.com>
Date: Fri, 10 May 2019 15:45:04 -0700
MIME-Version: 1.0
In-Reply-To: <20190510161607.GB27674@ubuette>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Larry Bassel <larry.bassel@oracle.com>, Matthew Wilcox <willy@infradead.org>
Cc: dan.j.williams@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 5/10/19 9:16 AM, Larry Bassel wrote:
> On 09 May 19 09:49, Matthew Wilcox wrote:
>> On Thu, May 09, 2019 at 09:05:33AM -0700, Larry Bassel wrote:
>>> This is based on (but somewhat different from) what hugetlbfs
>>> does to share/unshare page tables.
>>
>> Wow, that worked out far more cleanly than I was expecting to see.
> 
> Yes, I was pleasantly surprised. As I've mentioned already, I 
> think this is at least partially due to the nature of DAX.

I have not looked in detail to make sure this is indeed all the places you
need to hook and special case for sharing/unsharing.  Since this scheme is
somewhat like that used for hugetlb, I just wanted to point out some nasty
bugs related to hugetlb PMD sharing that were fixed last year.

5e41540c8a0f hugetlbfs: fix kernel BUG at fs/hugetlbfs/inode.c:444!
dff11abe280b hugetlb: take PMD sharing into account when flushing tlb/caches
017b1660df89 mm: migration: fix migration of huge PMD shared pages

The common issue in these is that when unmapping a page with a shared PMD
mapping you need to flush the entire shared range and not just the unmapped
page.  The above changes were hugetlb specific.  I do not know if any of
this applies in the case of DAX.
-- 
Mike Kravetz
