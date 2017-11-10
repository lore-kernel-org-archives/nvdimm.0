Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 10 Nov 2017 10:06:58 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/15] mm, devmap: introduce CONFIG_DEVMAP_MANAGED_PAGES
Message-ID: <20171110090658.GD4895@lst.de>
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com> <150949216597.24061.3943310722702629588.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150949216597.24061.3943310722702629588.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 31, 2017 at 04:22:46PM -0700, Dan Williams wrote:
> Combine the now three use cases of page-idle callbacks for ZONE_DEVICE
> memory into a common selectable symbol.

Very sparse changelog.  I understand the Kconfig bit, but it also seems to
introduce new static key functionality that isn't explained at all.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
