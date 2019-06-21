Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH] mm/sparsemem: Cleanup 'section number' data types
References: <156107543656.1329419.11505835211949439815.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190621145805.GN32656@bombadil.infradead.org>
From: David Hildenbrand <david@redhat.com>
Message-ID: <ed4ccc6e-082b-df7a-6633-0b5f95e7bf2d@redhat.com>
Date: Fri, 21 Jun 2019 17:04:45 +0200
MIME-Version: 1.0
In-Reply-To: <20190621145805.GN32656@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Matthew Wilcox <willy@infradead.org>, Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, Michal Hocko <mhocko@suse.com>, Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 21.06.19 16:58, Matthew Wilcox wrote:
> On Thu, Jun 20, 2019 at 05:06:46PM -0700, Dan Williams wrote:
>> David points out that there is a mixture of 'int' and 'unsigned long'
>> usage for section number data types. Update the memory hotplug path to
>> use 'unsigned long' consistently for section numbers.
> 
> ... because we're seriously considering the possibility that we'll need
> more than 4 billion sections?
> 

To make it consistent ;)

-- 

Thanks,

David / dhildenb
