Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 21 Jun 2019 07:58:06 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm/sparsemem: Cleanup 'section number' data types
Message-ID: <20190621145805.GN32656@bombadil.infradead.org>
References: <156107543656.1329419.11505835211949439815.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156107543656.1329419.11505835211949439815.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, Michal Hocko <mhocko@suse.com>, Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 20, 2019 at 05:06:46PM -0700, Dan Williams wrote:
> David points out that there is a mixture of 'int' and 'unsigned long'
> usage for section number data types. Update the memory hotplug path to
> use 'unsigned long' consistently for section numbers.

... because we're seriously considering the possibility that we'll need
more than 4 billion sections?
